---
layout: post
title:  "DataUtils对Connection的获取、释放和关闭的操作学习"
title2:  "DataUtils对Connection的获取、释放和关闭的操作学习"
date:   2017-01-01 23:56:13  +0800
source:  "http://www.jfox.info/datautils%e5%af%b9connection%e7%9a%84%e8%8e%b7%e5%8f%96%e9%87%8a%e6%94%be%e5%92%8c%e5%85%b3%e9%97%ad%e7%9a%84%e6%93%8d%e4%bd%9c%e5%ad%a6%e4%b9%a0.html"
fileName:  "20170101273"
lang:  "zh_CN"
published: true
permalink: "datautils%e5%af%b9connection%e7%9a%84%e8%8e%b7%e5%8f%96%e9%87%8a%e6%94%be%e5%92%8c%e5%85%b3%e9%97%ad%e7%9a%84%e6%93%8d%e4%bd%9c%e5%ad%a6%e4%b9%a0.html"
---
{% raw %}
# DataUtils对Connection的获取、释放和关闭的操作学习 


# DataSourceUitls介绍

DataSourceUitls类位于org.springframework.jdbc.datasource包下，提供了很多的静态方法去从一个javax.sql.DataSource下获取JDBC Connection,并且提供了对Spring 事务管理的支持。

在JdbcTemplate类的内部，DataSourceUtils被多次使用。其实，我们还可以在代码中直接使用DataSourceUitls来操作Jdbc。

# DataSourceUitls获取Connection

## getConnection方法

### 内部实现

        public static Connection getConnection(DataSource dataSource) throws CannotGetJdbcConnectionException {
            try {
                return doGetConnection(dataSource);
            }
            catch (SQLException ex) {
                throw new CannotGetJdbcConnectionException("Failed to obtain JDBC Connection", ex);
            }
            catch (IllegalStateException ex) {
                throw new CannotGetJdbcConnectionException("Failed to obtain JDBC Connection: " + ex.getMessage());
            }
        }

可以看出，通过传入一个指定的DataSource，可以获取一个Connection，获取过程由doGetConnection方法实现。如果抛出SQLException和IllegalStateException,则将其包装成CannotGetJdbcConnectionException，事实上也只能抛出SQLException和IllegalStateException这两种异常。通过查看CannotGetJdbcConnectionException的源代码，我们可以发现CannotGetJdbcConnectionException实际上是DataAccessException的子类，因此可以说，getConnection会将抛出的异常统一封装成Spring的DataAccessException。

## doGetConnection方法

### 内部实现

        public static Connection doGetConnection(DataSource dataSource) throws SQLException {
            Assert.notNull(dataSource, "No DataSource specified");
    
            ConnectionHolder conHolder = (ConnectionHolder) TransactionSynchronizationManager.getResource(dataSource);
            if (conHolder != null && (conHolder.hasConnection() || conHolder.isSynchronizedWithTransaction())) {
                conHolder.requested();
                if (!conHolder.hasConnection()) {
                    logger.debug("Fetching resumed JDBC Connection from DataSource");
                    conHolder.setConnection(fetchConnection(dataSource));
                }
                return conHolder.getConnection();
            }
            // Else we either got no holder or an empty thread-bound holder here.
    
            logger.debug("Fetching JDBC Connection from DataSource");
            Connection con = fetchConnection(dataSource);
    
            if (TransactionSynchronizationManager.isSynchronizationActive()) {
                logger.debug("Registering transaction synchronization for JDBC Connection");
                // Use same Connection for further JDBC actions within the transaction.
                // Thread-bound object will get removed by synchronization at transaction completion.
                ConnectionHolder holderToUse = conHolder;
                if (holderToUse == null) {
                    holderToUse = new ConnectionHolder(con);
                }
                else {
                    holderToUse.setConnection(con);
                }
                holderToUse.requested();
                TransactionSynchronizationManager.registerSynchronization(
                        new ConnectionSynchronization(holderToUse, dataSource));
                holderToUse.setSynchronizedWithTransaction(true);
                if (holderToUse != conHolder) {
                    TransactionSynchronizationManager.bindResource(dataSource, holderToUse);
                }
            }
    
            return con;
        }

doGetConnection方法是用于实际操作获取Connection的核心方法。从源代码中可以得出，如果不存在与当前线程绑定的Connection，则新建一个全新的Connection，如果当前线程的事务同步处于活动状态，那么为刚刚创建的Connection添加Spring事务管理的支持；如果当前线程存在一个相应的Connection，那么则有当前的事务管理分配。

## fetchConnection方法

fetchConnection是一个private方法，不对外公开，实际上是做了一个简单的功能：从当前的DastaSource新建一个Connection，如果新建失败，那么抛出IllegalStateException，提示不能获取一个新的Connection。

# DataSourceUitls释放Connection

## releaseConnection方法

### 内部实现

        public static void releaseConnection(@Nullable Connection con, @Nullable DataSource dataSource) {
            try {
                doReleaseConnection(con, dataSource);
            }
            catch (SQLException ex) {
                logger.debug("Could not close JDBC Connection", ex);
            }
            catch (Throwable ex) {
                logger.debug("Unexpected exception on closing JDBC Connection", ex);
            }
        }

releaseConnection方法的具体实现由doReleaseConnection处理。如果抛出异常，仅仅是在日志中做debug处理，不会对外抛出。该方法的两个参数均存在NULL的情况，
如果con为NULL，则忽略本次调用；而另一个参数则被允许为NULL。

## doReleaseConnection方法

### 内部实现

        public static void doReleaseConnection(@Nullable Connection con, @Nullable DataSource dataSource) throws SQLException {
            if (con == null) {
                return;
            }
            if (dataSource != null) {
                ConnectionHolder conHolder = (ConnectionHolder) TransactionSynchronizationManager.getResource(dataSource);
                if (conHolder != null && connectionEquals(conHolder, con)) {
                    // It's the transactional Connection: Don't close it.
                    conHolder.released();
                    return;
                }
            }
            logger.debug("Returning JDBC Connection to DataSource");
            doCloseConnection(con, dataSource);
        }

doReleaseConnection方法是真正释放了Connection的方法，与releaseConnection方法相比，则完成了对传入的两个参数的校验和抛出更底层的异常。在dataSource不为NULL的情况下，释放此ConnectionHolder保留的当前连接，使得该当前的Connection可以得到复用，对提供Jdbc操作的性能很有帮助。如果dataSource为null的情况下则选择直接关闭连接。

# DataSourceUitls关闭Connection

## doCloseConnection方法

### 内部实现

        public static void doCloseConnection(Connection con, @Nullable DataSource dataSource) throws SQLException {
            if (!(dataSource instanceof SmartDataSource) || ((SmartDataSource) dataSource).shouldClose(con)) {
                con.close();
            }
        }

在doReleaseConnection方法中，我们已经得知当datasource为NULL的时候会执行doCloseConnection方法。事实上，只有dataSource没有实现org.springframework.jdbc.datasource.SmartDataSource接口的时候或者dataSource实现了org.springframework.jdbc.datasource.SmartDataSource接口且允许关闭的时候，在真正关闭了Connection。

org.springframework.jdbc.datasource.SmartDataSource接口是 javax.sql.DataSource接口的一个扩展，用一种未包装的形式返回Jdbc的连接。实现该接口的类可以查询Connection在完成操作之后是否应该关闭。在Srping和DataSourceUitls和JdbcTemplate中会自动执行这样的检查。

# 总结

DataSourceUitls是一个强大的工具辅助类，不仅仅是提供了Connection的获取、释放和关闭，其实还提供了为Connection提供Spring事务的支持。a
{% endraw %}
