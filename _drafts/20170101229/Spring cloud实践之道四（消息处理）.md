---
layout: post
title:  "Spring cloud实践之道四（消息处理）"
title2:  "Spring cloud实践之道四（消息处理）"
date:   2017-01-01 23:55:29  +0800
source:  "https://www.jfox.info/springcloud%e5%ae%9e%e8%b7%b5%e4%b9%8b%e9%81%93%e5%9b%9b%e6%b6%88%e6%81%af%e5%a4%84%e7%90%86.html"
fileName:  "20170101229"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springcloud%e5%ae%9e%e8%b7%b5%e4%b9%8b%e9%81%93%e5%9b%9b%e6%b6%88%e6%81%af%e5%a4%84%e7%90%86.html"
---
{% raw %}
作者[hutou](/u/67378d2013bb)2017.07.09 11:28字数 735
## 说明

之前我们知道了如何使用spring cloud config 进行统一配置，但是，当配置发生了变化的时候，需要服务自行去刷新才能更新。在实际的使用场景中这是一个可怕的工作量，并且容易出错误。这里有一个通用的解决方案，使用spring cloud bus结合消息中间件，通过消息通知的方式进行配置的刷新。
 
  
  
    整体架构图 
   
  
 
当有配置信息发生变化的时候，会有如下的方式完成配置的刷新和通知

1. 向配置中心发送刷新请求 POST /bus/refresh
2. 配置中心向消息总线发送消息
3. 所有的服务接收消息总线的消息
4. 服务向配置中心获取最新的配置信息从而完成配置的刷新工作

## 使用和验证步骤

1. 使用eureka注册服务
2. 修改配置中心应用，提供spring cloud bus的支持：[演示项目源码](https://www.jfox.info/go.php?url=https://github.com/hutou-workhouse/miscroServiceHello/tree/master/springCloudConfigBusServer)
3. 修改各个服务，提供spring cloud bus的支持：[演示项目源码](https://www.jfox.info/go.php?url=https://github.com/hutou-workhouse/miscroServiceHello/tree/master/springCloudConfigBusClient)
4. 修改配置文件，并提交到git服务器
5. 向配置中心提交 POST /bus/refresh
6. 查看各个服务的配置信息，正常情况下应该配置生效

## 配置中心改造

1. 修改pom.xml增加依赖，这里使用RabbitMq作为消息中间件，遵循amqp标准
         <dependency>
             <groupId>org.springframework.cloud</groupId>
             <artifactId>spring-cloud-starter-bus-amqp</artifactId>
         </dependency>    
         <dependency>
             <groupId>org.springframework.boot</groupId>
             <artifactId>spring-boot-starter-actuator</artifactId>
         </dependency>

2. 配置文件中增加RabbitMq的配置
    spring.rabbitmq.host=localhost
    spring.rabbitmq.port=5672
    #spring.rabbitmq.username=linxm
    #spring.rabbitmq.password=111111
    # 打开安全控制，通过/refresh刷新数据
    management.security.enabled=false
    endpoints.enabled=false
    endpoints.refresh.enabled=true

3. 正确启动之后，可以发送 POST /bus/refresh 进行验证

## 服务的改造

与配置中心的改造方法完全一样！然后就可以启动服务进行验证了！

**注意：**我们可以指定刷新范围：通过使用**destination**参数

1. 刷新具体服务
    /bus/refresh?destination=mybusservice1:1811

2. 刷新某种服务
    /bus/refresh?destination=mybusservice1:**

## 使用kafka做消息中间件

逻辑上与RabbitMq的方法没有区别

1. 增加pom.xml依赖
    <dependency>
     <groupId>org.springframework.cloud</groupId>
     <artifactId>spring-cloud-starter-bus-kafka</artifactId>
    </dependency>

2. 修改配置文件
    # Kafka的服务端列表，默认值localhost
    spring.cloud.stream.kafka.binder.brokers=master,backup
    # Kafka服务端的默认端口，当brokers属性中没有配置端口信息时，就会使用这个默认端口        
    spring.cloud.stream.kafka.binder.defaultBrokerPort=9092
    # Kafka服务端连接的ZooKeeper节点列表
    spring.cloud.stream.kafka.binder.zkNodes=localhost
    # ZooKeeper节点的默认端口，当zkNodes属性中没有配置端口信息时，就会使用这个默认端口    
    spring.cloud.stream.kafka.binder.defaultZkPort=2181
{% endraw %}
