---
layout: post
title:  "Spring学习之声明式事务管理"
title2:  "Spring学习之声明式事务管理"
date:   2017-01-01 23:57:29  +0800
source:  "http://www.jfox.info/spring%e5%ad%a6%e4%b9%a0%e4%b9%8b%e5%a3%b0%e6%98%8e%e5%bc%8f%e4%ba%8b%e5%8a%a1%e7%ae%a1%e7%90%86.html"
fileName:  "20170101349"
lang:  "zh_CN"
published: true
permalink: "spring%e5%ad%a6%e4%b9%a0%e4%b9%8b%e5%a3%b0%e6%98%8e%e5%bc%8f%e4%ba%8b%e5%8a%a1%e7%ae%a1%e7%90%86.html"
---
{% raw %}
# Spring学习之声明式事务管理 


作者[颜洛滨](/u/b1a604b2eaed)2017.07.15 18:26字数 816
# Spring学习之声明式事务管理

## 前言

在前面的小节中，我们学习了关于事务的概念以及事务管理的重要性，并且通过编程使用Spring的编程序事务管理进行操作，加深对事务管理的重要性的学习，不过，由于编程序的事务管理使用起来不是很方便，所以在日常的开发中基本不怎么使用，接下来的内容我们将学习使用Spring的声明式事务管理，这里有一个地方需要明白的是，Spring的声明式事务管理的实现方式其实是通过AOP的方式来实现的，也就是为原始的事务管理对象创建代理对象，从而实现事务管理增强的

## 基于TransactionProxyFactoryBean的事务管理配置

经过前面的学习，可以知道，Spring中配置AOP有三种方式，分别是通过ProxyFactoryBean创建代理，通过XML的方式以及通过注解的方式，既然Spring事务管理是通过AOP来实现的，那么对应的就有三种不同的方式，首先来看下基于TransactionProxyFactoryBean的管理方式

首先是Spring的配置文件

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:context="http://www.springframework.org/schema/context"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd 
           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    
        <!--开启自动扫描-->
        <context:component-scan base-package="cn.xuhuanfeng.transaction"/>
    
        <!--配置数据源，这里采用dbcp-->
        <bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource">
            <property name="url" value="jdbc:mysql://localhost:3306/spring"/>
            <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
            <property name="username" value="root"/>
            <property name="password" value="huanfeng"/>
        </bean>
    
        <!--配置JdbcTemplate-->
        <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
            <!--注入数据源-->
            <property name="dataSource" ref="dataSource"/>
        </bean>
    
        <!--配置事务管理-->
        <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
            <!--注入数据源-->
            <property name="dataSource" ref="dataSource"/>
        </bean>
        <!--为AccountService创建代理类-->
        <bean id="accountServiceProxy" class="org.springframework.transaction.interceptor.TransactionProxyFactoryBean">
            <!--注入事务管理-->
            <property name="transactionManager" ref="transactionManager"/>
            <!--注入目标类，也就是所要增强的类-->
            <property name="target" ref="accountService"/>
            <!--配置相应的事务属性-->
            <property name="transactionAttributes">
                <props>
                    <!--指定不同的事务的处理方式
                        配置格式：事务传播方式，隔离级别，readOnly，-Exception，+Exception
                        传播行为是唯一必须配置的，其他的如果不配置则使用默认
                        -Exception表示如果发生对应的异常，则回滚事务
                        +Exception表示即使发生对应的异常，也依旧提交事务
                    -->
                    <prop key="transfer">PROPAGATION_REQUIRED,ISOLATION_DEFAULT</prop>
                </props>
            </property>
        </bean>
    </beans>

对应的持久层代码

    @Repository
    public class AccountDao {
    
        @Autowired
        private JdbcTemplate jdbcTemplate;
    
        public void transferIn(String name, double money){
            String sql = "update account set money = money + ? where name = ?";
    
            jdbcTemplate.update(sql, money, name);
        }
    
        public void transferOut(String name, double money){
            String sql = "update account set money = money - ? where name = ?";
    
            jdbcTemplate.update(sql, money, name);
        }
    }

业务层代码

@Service
public class AccountService {

    @Autowired
    private AccountDao accountDao;
    
    public void transfer(final String fromName,final String toName,final double money){
    
        accountDao.transferOut(fromName, money);
        int d = 1/0; // 除0异常
        accountDao.transferIn(toName, money);
    }

}

通过上面的配置之后，当我们在使用AccountService的时候，由于获取的对象的代理后的对象，所以Spring会自动进行事务的监管，而我们需要做的就是配置对应的事务传播类型以及事务管理级别等的信息，这种方式明显对代码以及没有什么侵入了，但是使用这种方式意味着没有都需要为不同的服务对象创建对应的代理对象，这其实是不太方便的，接下来我们来看下使用aop/tx命名空间来进行配置的方式。

## 基于aop/tx命名空间的事务管理配置

由于是对上面的业务操作进行事务管理，而且经过上一小节的学习，我们也基本熟悉了该业务，所以这里直接演示配置的代码

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:context="http://www.springframework.org/schema/context"
           xmlns:tx="http://www.springframework.org/schema/tx" xmlns:aop="http://www.springframework.org/schema/aop"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd
           http://www.springframework.org/schema/tx
           http://www.springframework.org/schema/tx/spring-tx.xsd 
           http://www.springframework.org/schema/aop 
           http://www.springframework.org/schema/aop/spring-aop.xsd">
    
        <!--
            这里配置同前，故省略
        -->
    
        <!--aop配置-->
        <aop:config>
            <!--配置切点-->
            <aop:pointcut id="serviceMethod" expression="execution(* cn.xuhuanfeng.transaction.AccountService.*(..))"/>
            <!--对应的切面-->
            <aop:advisor advice-ref="txAdvice" pointcut-ref="serviceMethod"/>
        </aop:config>
    
        <!--配置事务增强-->
        <tx:advice id="txAdvice" transaction-manager="transactionManager">
            <tx:attributes>
                <!--配置对应的事务管理，其中name为与事务相关的方法名，可以使用通配符-->
                <tx:method name="transfer*" isolation="DEFAULT" propagation="REQUIRED"/>
            </tx:attributes>
        </tx:advice>
    
    </beans>

可以看到，通过XML配置的方式，可以更加灵活地进行事务管理

## 基于注解的事务管理配置

基于注解的配置方式提供了更加简单的配置方式，只需要使用@Transactional注解进行标注，并且开启对应的扫描即可。

    // 配置相应的隔离级别、事务传播等
    @Transactional(isolation = Isolation.DEFAULT, propagation = Propagation.REQUIRED)
    @Service
    public class AccountService {
        // 省略其他内容
    }

Spring配置文件也相对比较简单了

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:context="http://www.springframework.org/schema/context"
           xmlns:tx="http://www.springframework.org/schema/tx"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/context
           http://www.springframework.org/schema/context/spring-context.xsd
           http://www.springframework.org/schema/tx
           http://www.springframework.org/schema/tx/spring-tx.xsd">
    
        <!--数据源配置等同上-->
        <!--通过tx命名空间，开启主机自动扫描，并且注入事务管理器-->
        <tx:annotation-driven transaction-manager="transactionManager"/>
    </beans>

可以看到，通过注解配置的方式是最简单的配置方式，在日常的开发中，这种方式的使用的频率也比较高

## 总结

本小节主要学习了Spring声明式事务管理的配置，包括了使用TransactionProxyFactoryBean、通过aop/tx命名空间的XML配置以及基于注解的配置方式，其中，基于注解的配置方式是比较简单的，也是使用频率比较高的一种
{% endraw %}
