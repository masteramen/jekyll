---
layout: post
title:  "EJB系列 – 消息与MDB"
title2:  "EJB系列 – 消息与MDB"
date:   2017-01-01 23:51:04  +0800
source:  "http://www.jfox.info/ejb%e7%b3%bb%e5%88%97-%e6%b6%88%e6%81%af%e4%b8%8emdb.html"
fileName:  "20170100964"
lang:  "zh_CN"
published: true
permalink: "ejb%e7%b3%bb%e5%88%97-%e6%b6%88%e6%81%af%e4%b8%8emdb.html"
---
{% raw %}
松散耦合的异步通信过程

1. 面向消息的中间件(MOM): 消息发送者称为生产者; 存储消息的位置称为目的地; 接受消息的组件称为消费者

 2. 消息模型: 
a. 点对点:目的地成为队列,消息只能被消费一次
b. 发布-订阅:目的地成为主体,消费者称为订阅者,消息能被任意数量消费 

##  Java消息服务 

 1. JMS API:提供使用Java访问MOM(消息中间件)的统一标准方式 

 2. 开发消息生产者流程:
a. 使用依赖注入,获得连接工厂ConnectionFactory和目的地Destination对象
b. 使用连接工厂的createConnection打开连接Connection
c. 使用连接Connection的createSession创建会话Session并指定事务参数
d. 使用会话Session的createProducer创建货运队列Producer
e. 使用会话Session的createMessage创建消息Message并设置
f. 使用货运队列Producer的send发送消息
g. 释放资源
注意: 以上流程是基于JavaEE 6 的情况下, JavaEE 7 提供了更加简易的A开发流程 

 3. Message接口: 消息头, 消息属性, 消息体; 实现类: ObjectMessage传递对象, ByteMessage传递字节, MapMessage传递Map, StreamMessage传递流数据, TextMessage传递文字 

##  消息驱动bean(MDB) 

 1. 优点:多线程,简化的消息代码 

 2. 设计原则: 
a. MDB类必须直接或间接实现消息监听器接口
b. 必须是具体的公开的,不能是final和抽象类
c. 必须是POJO,不能是另一个MDB的子类
d. 必须有无参的构造器
e. 不能有final方法
f. 不能抛出任何运行时异常,因为当抛出是MDB实例将被终止 

 3. 使用MDB开发消费者流程
a. 使用注解@MessageDriven把类标记为MDB并且指定MDB配置
b. 实现MessageListener接口, 并实现onMessage方法
c. 在onMessage中实现逻辑 

 4. @MessageDriven: 注解被注解的类为MDB, 该注解有3个参数, name指定MDB的名称, messageListenerInterface指定MDB实现的消息接口(可以直接在类上implements接口), activationConfig用于指定专有的配置属性 

 5. MessageLisener: 把MDB注册为消息消费者, 可根据不同场景实现不同监听器接口 

 6. ActivationConfigProperty: 配置消息系统的配置信息
a. destinationType: 通知容器该MDB监听的是队列还是主题
b. connectionFactoryJndiName: 指定用于创建MDB的JMS连接的连接工厂JDNI
c. destianName: 指定正在监听的目的地
d. acknowledgeMode: 指定JMS会话确认模式
e. subscriptionDurability: 用于设置为持久订阅者
f. messageSelector: 过滤消息 

 7. MDB生命周期:
a. 创建MDB实例并设置它们
b. 注入资源
c. 存放到受管理的池中
d. 当检测到消息到达时监听的目的地时,从池中取出空闲bean
e. 执行消息监听器方法,即onMessage方法
f. 当onMessage方法执行完毕,把空闲bean存回池中
g. 根据需求从池中撤销/销毁bean 

 8. 从MDB发送消息: 从JNDI注入队列, 连接工厂对象, 然后和Java消息一样的操作 

 9. 管理事务: 正常情况下, 在onMessage方法前开启事务, 方法结束时提交事务. 可以通过消息上下文对象rollback事务 

##  MDB最佳实践 

 1. 根据使用情况选择是否使用MDB 

 2. 选择消息模型: 应在程序设计时决定是PTP还是发布-订阅, 但幸运的是, 两者间切换仅仅需要修改配置即可 

 3. 保持模块化: MDB的onMessage方法不应该处理业务逻辑, 业务逻辑应该放在对应的会话bean, 并注入MDB, MDB负责调用对应的会话bean 

 4. 根据场景充分使用过滤器或划分目的地 

 5. 选择消息类型: 根据使用场景选择传输时使用的消息类型 

 6. 警惕有毒消息: 无法消费但又回滚了的消息会陷入无限循环的接收/回滚中, 虽然个别厂商有自己的处理死消息的实现, 但是在编程的时候要注意 

 7. 配置MDB池额大小: 根据场景和需求配置
{% endraw %}
