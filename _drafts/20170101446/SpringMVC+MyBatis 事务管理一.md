---
layout: post
title:  "SpringMVC+MyBatis 事务管理一"
title2:  "SpringMVC+MyBatis 事务管理一"
date:   2017-01-01 23:59:06  +0800
source:  "https://www.jfox.info/springmvcmybatis%e4%ba%8b%e5%8a%a1%e7%ae%a1%e7%90%86%e4%b8%80.html"
fileName:  "20170101446"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springmvcmybatis%e4%ba%8b%e5%8a%a1%e7%ae%a1%e7%90%86%e4%b8%80.html"
---
{% raw %}
spring事务管理包含两种情况，编程式事务、声明式事务。而声明式事务又包括基于注解@Transactional和tx+aop的方式。那么本文先分析编程式注解事务和基于注解的声明式事务。 编程式事务管理使用TransactionTemplate或者PlatformTransactionManager。对于编程式事务spring推荐使用TransactionTemplate。

### 一、编程式事务

     spring事务特性

     spring中所有的事务策略类都继承自org.springframework.transaction.PlatformTransactionManager接口

    publicinterface PlatformTransactionManager {
    
        TransactionStatus getTransaction(TransactionDefinition definition) throws TransactionException;
    
        void commit(TransactionStatus status) throws TransactionException;
    
        
        void rollback(TransactionStatus status) throws TransactionException;
    
    }

      编程式事务TransactionTemplate需要手动在代码中处理事务，一般不推荐使用，也不符合spring的思想，因为它直接耦合代码，但各有利弊。先看下TransactionTemplate的源码。

    public class TransactionTemplate extends DefaultTransactionDefinition
    		implements TransactionOperations, InitializingBean {
    
    	
    	protected final Log logger = LogFactory.getLog(getClass());
    
    	private PlatformTransactionManager transactionManager;
    
    	public TransactionTemplate() {
    	}
    
    	public TransactionTemplate(PlatformTransactionManager transactionManager) {
    		this.transactionManager = transactionManager;
    	}
    
    	
    	public TransactionTemplate(PlatformTransactionManager transactionManager, TransactionDefinition transactionDefinition) {
    		super(transactionDefinition);
    		this.transactionManager = transactionManager;
    	}
    
    	public void setTransactionManager(PlatformTransactionManager transactionManager) {
    		this.transactionManager = transactionManager;
    	}
    
    	public PlatformTransactionManager getTransactionManager() {
    		return this.transactionManager;
    	}
    
    	@Override
    	public void afterPropertiesSet() {
    		if (this.transactionManager == null) {
    			throw new IllegalArgumentException("Property 'transactionManager' is required");
    		}
    	}
    
    
    	@Override
    	public <T> T execute(TransactionCallback<T> action) throws TransactionException {
    		if (this.transactionManager instanceof CallbackPreferringPlatformTransactionManager) {
    			return ((CallbackPreferringPlatformTransactionManager) this.transactionManager).execute(this, action);
    		}
    		else {
    			TransactionStatus status = this.transactionManager.getTransaction(this);
    			T result;
    			try {
    				result = action.doInTransaction(status);
    			}
    			catch (RuntimeException ex) {
    				// Transactional code threw application exception -> rollback
    				rollbackOnException(status, ex);
    				throw ex;
    			}
    			catch (Error err) {
    				// Transactional code threw error -> rollback
    				rollbackOnException(status, err);
    				throw err;
    			}
    			catch (Throwable ex) {
    				// Transactional code threw unexpected exception -> rollback
    				rollbackOnException(status, ex);
    				throw new UndeclaredThrowableException(ex, "TransactionCallback threw undeclared checked exception");
    			}
    			this.transactionManager.commit(status);
    			return result;
    		}
    	}
    
    	
    	private void rollbackOnException(TransactionStatus status, Throwable ex) throws TransactionException {
    		logger.debug("Initiating transaction rollback on application exception", ex);
    		try {
    			this.transactionManager.rollback(status);
    		}
    		catch (TransactionSystemException ex2) {
    			logger.error("Application exception overridden by rollback exception", ex);
    			ex2.initApplicationException(ex);
    			throw ex2;
    		}
    		catch (RuntimeException ex2) {
    			logger.error("Application exception overridden by rollback exception", ex);
    			throw ex2;
    		}
    		catch (Error err) {
    			logger.error("Application exception overridden by rollback error", ex);
    			throw err;
    		}
    	}
    
    }
    

　　从上面的代码可以看到核心方法是execute，该方法入参TransactionCallback<T>。查看TransactionCallback源码：

    public interface TransactionCallback<T> { 
        T doInTransaction(TransactionStatus status); 
    }
    

　那么以上两个源码可以确定我们使用编程式事务管理的方式也就是自己需要重写doInTransaction()。OK，那么我们手动使用TransactionTemplate处理下。

1、先配置transactionmanager

    <!--事务管理器 --><bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager"><property name="dataSource" ref="dataSource"/></bean>

2、配置transactionTemplate

    <!--编程式事务，推荐使用TransactionTemplate--><bean id="transactionTemplate"
              class="org.springframework.transaction.support.TransactionTemplate"><property name="transactionManager" ref="transactionManager"/></bean>

3、业务代码处理

     @Autowired
        private TransactionTemplate transactionTemplate;
    
        publicint insertUser2(final User user) {
            Integer i= (Integer) this.transactionTemplate.execute(new TransactionCallback() {
                public Object doInTransaction(TransactionStatus transactionStatus) {
    
                    int i = userMapper.insertUser(user);
                    if (i > 0) {
                        System.out.println("success");
                    }
                    int j = 10 / 0;
    
                    return i;
    
                }
            });
    
            return i;
        }

  业务代码中我们使用by zero的异常故意抛出，你会发现能继续打印success，当你断点debug时，你会发现数据库一直是锁定状态，直到你程序执行完。如下图：

![](/wp-content/uploads/2017/08/1501683692.png)

二、基于Transactional注解的事务管理

    当前应该是使用最清爽的事务管理方式了，也符合spring的理念，非入侵代码的方式。

1、配置

    <!--事务管理器 --><bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager"><property name="dataSource" ref="dataSource"/></bean><!-- 使用注解事务，需要添加Transactional注解属性 --><tx:annotation-driven transaction-manager="transactionManager"/><!--启用最新的注解器、映射器--><mvc:annotation-driven/>

2、配置后只需要在要处理的地方加上Transactional注解，而且Transactional注解的方式可以应用在类上，也可以应用在方法上，当然只针对public方法。

3、业务代码处理

      @Transactional
        publicint insertUser(User user) {
            int i = userMapper.insertUser(user);
            if (i > 0) {
                System.out.println("success");
            }
            int j = 10 / 0;
    
            return i;
        }
{% endraw %}
