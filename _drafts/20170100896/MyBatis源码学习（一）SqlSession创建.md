---
layout: post
title:  "MyBatis源码学习（一）SqlSession创建"
title2:  "MyBatis源码学习（一）SqlSession创建"
date:   2017-01-01 23:49:56  +0800
source:  "http://www.jfox.info/mybatis%e6%ba%90%e7%a0%81%e5%ad%a6%e4%b9%a0-%e4%b8%80-sqlsession%e5%88%9b%e5%bb%ba.html"
fileName:  "20170100896"
lang:  "zh_CN"
published: true
permalink: "mybatis%e6%ba%90%e7%a0%81%e5%ad%a6%e4%b9%a0-%e4%b8%80-sqlsession%e5%88%9b%e5%bb%ba.html"
---
{% raw %}
MyBatis封装了JDBC操作数据库的代码，通过SqlSession来执行sql语句,那么首先来看看MyBatis是怎么创建SqlSession。 
MyBatis没有托管给spring的时候，数据库的配置信息是在Configuration.xml文件里边配置的 ，测试代码如下

    1Reader reader =  Resources.getResourceAsReader("Configuration.xml");

Mybatis通过SqlSessionFactoryBuilder.build(Reader reader)方法创建一个SqlSessionFactory对象 build方法的参数就是刚才的reader对象，里边包含了配置文件的所有信息，build方法有很多重载方法

     1public SqlSessionFactory build(Reader reader, String environment, Properties properties) {
     2try {
     3//委托XMLConfigBuilder来解析xml文件，并构建 4       XMLConfigBuilder parser = new XMLConfigBuilder(reader, environment, properties);
     5return build(parser.parse());
     6     } catch (Exception e) {
     7throw ExceptionFactory.wrapException("Error building SqlSession.", e);
     8     } finally {
     9      ErrorContext.instance().reset();
    10try {
    11        reader.close();
    12       } catch (IOException e) {
    13  }
    14public SqlSessionFactory build(Configuration config) {
    15returnnew DefaultSqlSessionFactory(config);
    16   }

最后返回一个DefaultSqlSessionFactory对象，通过DefaultSqlSessionFactory的openSession()返回一个SqlSession对象

    public SqlSession openSession() {
        return openSessionFromDataSource(configuration.getDefaultExecutorType(), null, false);
      }
    private SqlSession openSessionFromDataSource(ExecutorType execType, TransactionIsolationLevel level, boolean autoCommit) {
        Transaction tx = null;
        try {
          final Environment environment = configuration.getEnvironment();
          final TransactionFactory transactionFactory = getTransactionFactoryFromEnvironment(environment);
          //通过事务工厂来产生一个事务
          tx = transactionFactory.newTransaction(environment.getDataSource(), level, autoCommit);
          //生成一个执行器(事务包含在执行器里)final Executor executor = configuration.newExecutor(tx, execType);
          //然后产生一个DefaultSqlSessionreturnnew DefaultSqlSession(configuration, executor, autoCommit);
        } catch (Exception e) {
          //如果打开事务出错，则关闭它
          closeTransaction(tx); // may have fetched a connection so lets call close()throw ExceptionFactory.wrapException("Error opening session.  Cause: " + e, e);
        } finally {
          //最后清空错误上下文      ErrorContext.instance().reset();
        }
      }

可以看到最后返回一个DefaultSqlSession即SqlSession对象，DefaultSqlSession中的selectOne(…) selectList(…) 
selectMap(…) update(…)等方法就是真正执行要执行sql的方法 
具体的执行由executor对象来执行

    publicvoid select(String statement, Object parameter, RowBounds rowBounds, ResultHandler handler) {
        try {
          MappedStatement ms = configuration.getMappedStatement(statement);
          executor.query(ms, wrapCollection(parameter), rowBounds, handler);
        } catch (Exception e) {
          throw ExceptionFactory.wrapException("Error querying database.  Cause: " + e, e);
        } finally {
          ErrorContext.instance().reset();
        }
      }
{% endraw %}
