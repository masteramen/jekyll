---
layout: post
title:  "JMS 之 Active MQ 的spring整合"
title2:  "JMS 之 Active MQ 的spring整合"
date:   2017-01-01 23:50:02  +0800
source:  "https://www.jfox.info/jms-%e4%b9%8b-active-mq-%e7%9a%84spring%e6%95%b4%e5%90%88.html"
fileName:  "20170100902"
lang:  "zh_CN"
published: true
permalink: "2017/jms-%e4%b9%8b-active-mq-%e7%9a%84spring%e6%95%b4%e5%90%88.html"
---
{% raw %}
### 一、与spring整合实现ptp的同步接收消息

pom.xml:

    <!-- https://mvnrepository.com/artifact/org.springframework/spring-jms --><dependency><groupId>org.springframework</groupId><artifactId>spring-jms</artifactId><version>4.3.7.RELEASE</version></dependency><!-- https://mvnrepository.com/artifact/org.apache.activemq/activemq-pool --><dependency><groupId>org.apache.activemq</groupId><artifactId>activemq-pool</artifactId><version>5.9.0</version></dependency>

spring-jms.xml:

    <?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:jms="http://www.springframework.org/schema/jms"
    xmlns:amq="http://activemq.apache.org/schema/core"
    xsi:schemaLocation="http://activemq.apache.org/schema/core
    http://activemq.apache.org/schema/core/activemq-core.xsd
    http://www.springframework.org/schema/jms
    http://www.springframework.org/schema/jms/spring-jms.xsd
    http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd"><!-- ActiveMQConnectionFactory就是JMS中负责创建到ActiveMQ连接的工厂类 --><bean id="connectionFactory" class="org.apache.activemq.spring.ActiveMQConnectionFactory"><property name="brokerURL" value="tcp://192.168.0.224:61616"/></bean><!-- 创建连接池 --><bean id="pooledConnectionFactory" class="org.apache.activemq.pool.PooledConnectionFactory" destroy-method="stop"><property name="connectionFactory" ref="connectionFactory"/><property name="maxConnections" value="10"/></bean><!-- Spring为我们提供了多个ConnectionFactory，有SingleConnectionFactory和CachingConnectionFactory --><bean id="cachingConnectionFactory" class="org.springframework.jms.connection.CachingConnectionFactory"><property name="targetConnectionFactory" ref="pooledConnectionFactory"/></bean><!-- Spring提供的JMS工具类，它可以进行消息发送、接收等 --><bean id="jmsTemplate" class="org.springframework.jms.core.JmsTemplate"><!-- 这个connectionFactory对应的是我们定义的Spring提供的那个ConnectionFactory对象 --><property name="connectionFactory" ref="cachingConnectionFactory"/></bean><!--这个是队列目的地，点对点的--><bean id="queueDestination" class="org.apache.activemq.command.ActiveMQQueue"><constructor-arg index="0" value="spring-queue"/></bean></beans>

 ConnectionFactory是用于产生到JMS服务器的链接的，Spring为我们提供了多个ConnectionFactory，有SingleConnectionFactory和CachingConnectionFactory。SingleConnectionFactory对于建立JMS服务器链接的请求会一直返回同一个链接，并且会忽略Connection的close方法调用。CachingConnectionFactory继承了SingleConnectionFactory，所以它拥有SingleConnectionFactory的所有功能，同时它还新增了缓存功能，它可以缓存Session、MessageProducer和MessageConsumer。这里我们使用CachingConnectionFactory来作为示例。

消息生产者：

    package com.jalja.org.jms.spring;
    import javax.jms.Destination;
    import javax.jms.JMSException;
    import javax.jms.Message;
    import javax.jms.Session;
    import org.springframework.context.ApplicationContext;
    import org.springframework.context.support.ClassPathXmlApplicationContext;
    import org.springframework.jms.core.JmsTemplate;
    import org.springframework.jms.core.MessageCreator;
    publicclass SpringJmsSend {
        publicstaticvoid main(String[] args) {
            ApplicationContext context=new ClassPathXmlApplicationContext("spring-jms.xml");
            JmsTemplate jmsTemplate=(JmsTemplate) context.getBean("jmsTemplate");
            Destination queueDestination=(Destination) context.getBean("queueDestination");
            jmsTemplate.send(queueDestination, new MessageCreator(){
                @Override
                public Message createMessage(Session session) throws JMSException {
                    return session.createTextMessage("Hello spring JMS");
                }
            });
        }
    }
    

消费者：

    package com.jalja.org.jms.spring;
    import javax.jms.Destination;
    import org.springframework.context.ApplicationContext;
    import org.springframework.context.support.ClassPathXmlApplicationContext;
    import org.springframework.jms.core.JmsTemplate;
    publicclass SpringJmsReceive {
    publicstaticvoid main(String[] args) {
        ApplicationContext context=new ClassPathXmlApplicationContext("spring-jms.xml");
        JmsTemplate jmsTemplate=(JmsTemplate) context.getBean("jmsTemplate");
        Destination queueDestination=(Destination) context.getBean("queueDestination");
        String msg=(String) jmsTemplate.receiveAndConvert(queueDestination);
        System.out.println(msg);
    　　}
    }

### 二、PTP的异步调用

 我们在spring中直接配置异步接收消息的监听器，这样就相当于在spring中配置了消费者，在接受消息的时候就不必要启动消费者了。

spring-jms.xml:

    <?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:jms="http://www.springframework.org/schema/jms"
    xmlns:amq="http://activemq.apache.org/schema/core"
    xsi:schemaLocation="http://activemq.apache.org/schema/core
    http://activemq.apache.org/schema/core/activemq-core.xsd
    http://www.springframework.org/schema/jms
    http://www.springframework.org/schema/jms/spring-jms.xsd
    http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd"><!-- ActiveMQConnectionFactory就是JMS中负责创建到ActiveMQ连接的工厂类 --><bean id="connectionFactory" class="org.apache.activemq.spring.ActiveMQConnectionFactory"><property name="brokerURL" value="tcp://192.168.0.224:61616"/></bean><!-- 创建连接池 --><bean id="pooledConnectionFactory" class="org.apache.activemq.pool.PooledConnectionFactory" destroy-method="stop"><property name="connectionFactory" ref="connectionFactory"/><property name="maxConnections" value="10"/></bean><!-- Spring为我们提供了多个ConnectionFactory，有SingleConnectionFactory和CachingConnectionFactory --><bean id="cachingConnectionFactory" class="org.springframework.jms.connection.CachingConnectionFactory"><property name="targetConnectionFactory" ref="pooledConnectionFactory"/></bean><!-- Spring提供的JMS工具类，它可以进行消息发送、接收等 --><bean id="jmsTemplate" class="org.springframework.jms.core.JmsTemplate"><!-- 这个connectionFactory对应的是我们定义的Spring提供的那个ConnectionFactory对象 --><property name="connectionFactory" ref="cachingConnectionFactory"/></bean><!--这个是队列目的地，点对点的--><bean id="queueDestination" class="org.apache.activemq.command.ActiveMQQueue"><constructor-arg index="0" value="spring-queue"/></bean><!-- 消息监听器 --><bean id="myMessageListener" class="com.jalja.org.jms.spring.yb.MyMessageListener"/><!-- 消息监听容器 --><bean id="jmsContainer"  class="org.springframework.jms.listener.DefaultMessageListenerContainer"><property name="connectionFactory" ref="cachingConnectionFactory"/><property name="destination" ref="queueDestination"/><property name="messageListener" ref="myMessageListener"/></bean></beans>

　　生产者往指定目的地Destination发送消息后，接下来就是消费者对指定目的地的消息进行消费了。那么消费者是如何知道有生产者发送消息到指定目的地Destination了呢？这是通过Spring为我们封装的消息监听容器MessageListenerContainer实现的，它负责接收信息，并把接收到的信息分发给真正的MessageListener进行处理。每个消费者对应每个目的地都需要有对应的MessageListenerContainer。对于消息监听容器而言，除了要知道监听哪个目的地之外，还需要知道到哪里去监听，也就是说它还需要知道去监听哪个JMS服务器，这是通过在配置MessageConnectionFactory的时候往里面注入一个ConnectionFactory来实现的。所以我们在配置一个MessageListenerContainer的时候有三个属性必须指定，一个是表示从哪里监听的ConnectionFactory；一个是表示监听什么的Destination；一个是接收到消息以后进行消息处理的MessageListener。Spring一共为我们提供了两种类型的MessageListenerContainer，SimpleMessageListenerContainer和DefaultMessageListenerContainer。
SimpleMessageListenerContainer：SimpleMessageListenerContainer会在一开始的时候就创建一个会话session和消费者Consumer，并且会使用标准的JMS MessageConsumer.setMessageListener()方法注册监听器让JMS提供者调用监听器的回调函数。它不会动态的适应运行时需要和参与外部的事务管理。兼容性方面，它非常接近于独立的JMS规范，但一般不兼容Java EE的JMS限制。

**DefaultMessageListenerContainer：**在大多数情况下我们还是使用的DefaultMessageListenerContainer，跟SimpleMessageListenerContainer相比，DefaultMessageListenerContainer会动态的适应运行时需要，并且能够参与外部的事务管理。它很好的平衡了对JMS提供者要求低、先进功能如事务参与和兼容Java EE环境。

消息生产者：

    publicstaticvoid main(String[] args) {
            ApplicationContext context=new ClassPathXmlApplicationContext("spring-jms.xml");
            JmsTemplate jmsTemplate=(JmsTemplate) context.getBean("jmsTemplate");
            Destination queueDestination=(Destination) context.getBean("queueDestination");
            System.out.println("异步调用执行开始");
            jmsTemplate.send(queueDestination, new MessageCreator(){
                @Override
                public Message createMessage(Session session) throws JMSException {
                    return session.createTextMessage("Hello spring JMS");
                }
            });
            System.out.println("异步调用执行结束");
        }

消息监听器：MyMessageListener

    publicclass MyMessageListener implements MessageListener{
        @Override
        publicvoid onMessage(Message message) {
            TextMessage msg= (TextMessage) message;
            try {
                System.out.println("你好："+msg.getText());
            } catch (JMSException e) {
                e.printStackTrace();
            }
        }
    }

启动消息生产者 监听器的执行结果是：

    异步调用执行开始
    异步调用执行结束
    你好：Hello spring JMS

### 三、发布订阅 同步接收

spring-jms.xml:

    <?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:jms="http://www.springframework.org/schema/jms"
    xmlns:amq="http://activemq.apache.org/schema/core"
    xsi:schemaLocation="http://activemq.apache.org/schema/core
    http://activemq.apache.org/schema/core/activemq-core.xsd
    http://www.springframework.org/schema/jms
    http://www.springframework.org/schema/jms/spring-jms.xsd
    http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd"><!-- ActiveMQConnectionFactory就是JMS中负责创建到ActiveMQ连接的工厂类 --><bean id="connectionFactory" class="org.apache.activemq.spring.ActiveMQConnectionFactory"><property name="brokerURL" value="tcp://192.168.0.224:61616"/></bean><!-- 创建连接池 --><bean id="pooledConnectionFactory" class="org.apache.activemq.pool.PooledConnectionFactory" destroy-method="stop"><property name="connectionFactory" ref="connectionFactory"/><property name="maxConnections" value="10"/></bean><!-- Spring为我们提供了多个ConnectionFactory，有SingleConnectionFactory和CachingConnectionFactory --><bean id="cachingConnectionFactory" class="org.springframework.jms.connection.CachingConnectionFactory"><property name="targetConnectionFactory" ref="pooledConnectionFactory"/></bean><!-- Spring提供的JMS工具类，它可以进行消息发送、接收等 --><bean id="jmsTemplate" class="org.springframework.jms.core.JmsTemplate"><!-- 这个connectionFactory对应的是我们定义的Spring提供的那个ConnectionFactory对象 --><property name="connectionFactory" ref="cachingConnectionFactory"/></bean><!--这个是队列目的地，发布订阅--><bean id="topicDestination" class="org.apache.activemq.command.ActiveMQTopic"><constructor-arg index="0" value="spring-Topic"/></bean></beans>

生产者：

    publicstaticvoid main(String[] args) {
            ApplicationContext context=new ClassPathXmlApplicationContext("spring-jms.xml");
            JmsTemplate jmsTemplate=(JmsTemplate) context.getBean("jmsTemplate");
            Destination topicDestination=(Destination) context.getBean("topicDestination");
            jmsTemplate.send(topicDestination, new MessageCreator(){
                @Override
                public Message createMessage(Session session) throws JMSException {
                    return session.createTextMessage("Hello spring JMS topicDestination");
                }
            });
        }

消费者：

    publicclass SpringJmsSubscriber {
        publicstaticvoid main(String[] args) {
            ApplicationContext context=new ClassPathXmlApplicationContext("spring-jms.xml");
            JmsTemplate jmsTemplate=(JmsTemplate) context.getBean("jmsTemplate");
            Destination topicDestination=(Destination) context.getBean("topicDestination");
            String msg=(String) jmsTemplate.receiveAndConvert(topicDestination);
            System.out.println(msg);
        }
    }
{% endraw %}
