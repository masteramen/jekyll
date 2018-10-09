---
layout: post
title:  "JMS 之 Active MQ 消息存储"
title2:  "JMS 之 Active MQ 消息存储"
date:   2017-01-01 23:49:20  +0800
source:  "https://www.jfox.info/jms_zhi_active_mq_xiao_xi_cun_chu.html"
fileName:  "20170100860"
lang:  "zh_CN"
published: true
permalink: "2017/jms_zhi_active_mq_xiao_xi_cun_chu.html"
---
{% raw %}
ActiveMQ支持JMS规范中的持久化消息与非持久化消息

- 持久化消息通常用于不管是否消费者在线，它们都会保证消息会被消费者消费。当消息被确认消费后，会从存储中删除
- 非持久化消息通常用于发送通知以及实时数据，通常要求性能优先，消息可靠性并不是必须的情况
- MQ支持可插拔式的消息存储，如：内存、文件和关系数据库等方式

Queue消息模型在ActiveMQ的存储

　　采用存储采用先进先出（FIFO），一个消息只能被一个消费者消费，当消息被确认消费之后才会被删除。

　　KahaDB是从ActiveMQ 5.4开始默认的持久化插件。KahaDb恢复时间远远小于其前身AMQ并且使用更少的数据文件，所以可以完全代替AMQ，kahaDB的持久化机制同样是基于日志文件，索引和缓存。

**（一）、KahaDB主要特性：**

1. 日志形式存储消息；
2. 消息索引以B-Tree结构存储，可以快速更新；
3. 完全支持JMS事务；
4. 支持多种恢复机制；

**（二）、适用场景：**

1. 高吞吐量的应用程序
2. 存储大数据量的消息

**（三）、配置方式 conf/activemq.xml：**

    <persistenceAdapter><kahaDB directory="${activemq.data}/kahadb"/></persistenceAdapter>

**（四）、KahaDB存储原理：**

 当有活动消费者时，用于临时存储，消息会被发送给消费着，同时被安排将被存储，如果消息及时被确认，就不需要写入到磁盘。写入到磁盘中的数据消息，在后续的消息活动中，如果消息发送成功，变标记为可删除的。系统会周期性的清除或者归档日志文件。

　1、KahaDB内部结构

Data logs：消息日志包含了消息日志和一些命令Cache：当有活动消费者时，用于临时存储，消息会被发送给消费着，同时被安排将被存储，如果消息及时被确认，这不需要写入到磁盘Btree indexes（消息索引）：用于引用消息日志（message id），它存储在内存中，这样能快速定位到。MQ会定期将内存中的消息索引保存到metadata store中，避免大量消息未发送时，消息索引占用过多内存空间。Redo log用于在非正常关机情况下维护索引完整性。

2、目录结构：

Db log files：用于存储消息（默认大小32M），当log日志满了，会创建一个新的，当log日志中的消息都被删除，该日志文件会被删除或者归档。Archive directory：当datalog不在被kahadb需要会被归档（通过archiveDataLogs属性控制）。Db.data：存放Btree indexs。Db.redo：存放redo file，用于恢复Btree indexs。

## 三、AMQ消息存储

　　写入消息时，会将消息写入日志文件，由于是顺序追加写，性能很高。为了提升性能，创建消息主键索引，并且提供缓存机制，进一步提升性能。每个日志文件的大小都是有限制的（默认32m，可自行配置）。当超过这个大小，系统会重新建立一个文件。当所有的消息都消费完成，系统会删除这个文件或者归档（取决于配置）。主要的缺点是AMQ Message会为每一个Destination创建一个索引，如果使用了大量的Queue，索引文件的大小会占用很多磁盘空间。而且由于索引巨大，一旦Broker崩溃，重建索引的速度会非常慢。

特点：类似KahaDB，也包含了事务日志，每个destination都包含一个index文件，AMQ适用于高吞吐量的应用场景，但是不适合多个队列的场景。

 配置方式conf/activemq.xml：

    <!--AMQ    directory:数据存储路径 syncOnWrite：是否同步写入  maxFileLength：日志文件大小 --><persistenceAdapter><amqPersistenceAdapter
                    directory="${activemq.data}/AMQdb"
                    syncOnWrite="true"
                    maxFileLength="10mb"/></persistenceAdapter>

1、AMQ内部结构：

Data logs：消息日志包含了消息日志Cache：用于消息的快速检索Reference store indexes：用于引用datalogs中的消息，通过message ID 关联

2、目录结构：

Lock：保证同一时间只有一个borker访问文件目录temp-storag：用于存储非持久化消息（当不在被存储在内存中），如等待慢消费者处理消息Kr-store：用于存储引用消息日志数据journal directory：包含了消息文件、消息日志和消息控制信息Archive：归档的数据日志

## 四、JDBC存储

支持通过JDBC将消息存储到关系数据库，性能上不如文件存储，能通过关系型数据库查询到消息的信息。

MQ支持的数据库：Apache Derby、MYsql、PostgreSQL、Oracle、SQLServer、Sybase、Informix、MaxDB。

**存储表结构：**

A、ACTIVEMQ_MSGS：用于存储消息，Queue和Topic都存储在这个表中：

- ID：自增的数据库主键
- CONTAINER：消息的Destination
- MSGID_PROD：消息发送者客户端的主键
- MSG_SEQ：是发送消息的顺序，MSGID_PROD+MSG_SEQ可以组成JMS的MessageID
- EXPIRATION：消息的过期时间，存储的是从1970-01-01到现在的毫秒数
- MSG：消息本体的Java序列化对象的二进制数据
- PRIORITY：优先级，从0-9，数值越大优先级越高

B、ACTIVEMQ_ACKS：用于存储订阅关系。如果是持久化Topic，订阅者和服务器的订阅关系在这个表保存：

- 主要的数据库字段如下：
- CONTAINER：消息的Destination
- SUB_DEST：如果是使用Static集群，这个字段会有集群其他系统的信息
- CLIENT_ID：每个订阅者都必须有一个唯一的客户端ID用以区分
- SUB_NAME：订阅者名称
- SELECTOR：选择器，可以选择只消费满足条件的消息。条件可以用自定义属性实现，可支持多属性AND和OR操作
- LAST_ACKED_ID：记录消费过的消息的ID。

C、ACTIVEMQ_LOCK（消息锁，保证同一时间只能有一个broker访问这些表结构）： 表activemq_lock在集群环境中才有用，只有一个Broker可以获得消息，称为Master Broker，其他的只能作为备份等待Master Broker不可用，才可能成为下一个Master Broker。这个表用于记录哪个Broker是当前的Master Broker。

配置方式：

1、配置数据源 conf/acticvemq.xml文件：

    <!-- 配置数据源--><bean id="mysql-ds" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close"><property name="driverClassName" value="com.mysql.jdbc.Driver"/><property name="url" value="jdbc:mysql://localhost:3306/activemq?relaxAutoCommit=true"/><property name="username" value="root"/><property name="password" value="111111"/><property name="maxActive" value="200"/><property name="poolPreparedStatements" value="true"/></bean>

2、配置broke中的persistenceAdapter ：

dataSource指定持久化数据库的bean，createTablesOnStartup是否在启动的时候创建数据表，默认值是true，这样每次启动都会去创建数据表了，一般是第一次启动的时候设置为true，之后改成false。

    <!-- JDBC配置 --><persistenceAdapter><jdbcPersistenceAdapter dataSource="#mysql-ds"  createTablesOnStartup="false"/></persistenceAdapter>

ps：数据库activemq 需要手动创建。

## 五、内存消息存储

内存消息存储，会将所有的持久化消息存储在内存中，必须注意JVM使用情况以及内存限制，适用于一些能快速消费的数据量不大的小消息，当MQ关闭或者宕机，未被消费的内存消息会被清空。

配置方式 设置 broker属性值 persistent=”false”：

    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}" persistent="false">
{% endraw %}
