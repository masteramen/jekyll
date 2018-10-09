---
layout: post
title:  "【Motan源码学习】2-与Spring集成"
title2:  "【Motan源码学习】2-与Spring集成"
date:   2017-01-01 23:57:48  +0800
source:  "https://www.jfox.info/motan%e6%ba%90%e7%a0%81%e5%ad%a6%e4%b9%a02%e4%b8%8espring%e9%9b%86%e6%88%90.html"
fileName:  "20170101368"
lang:  "zh_CN"
published: true
permalink: "2017/motan%e6%ba%90%e7%a0%81%e5%ad%a6%e4%b9%a02%e4%b8%8espring%e9%9b%86%e6%88%90.html"
---
{% raw %}
ServiceConfig<MotanDemoService> motanDemoService = new ServiceConfig<MotanDemoService>();
    // 设置接口及实现类
    motanDemoService.setInterface(MotanDemoService.class);
    motanDemoService.setRef(new MotanDemoServiceImpl());
    // 配置服务的group以及版本号
    motanDemoService.setGroup("motan-demo-rpc");
    motanDemoService.setVersion("1.0");
    // 配置ZooKeeper注册中心
    RegistryConfig zookeeperRegistry = new RegistryConfig();
    zookeeperRegistry.setRegProtocol("zookeeper");
    zookeeperRegistry.setAddress("127.0.0.1:2181");
    motanDemoService.setRegistry(zookeeperRegistry);
    // 配置RPC协议
    ProtocolConfig protocol = new ProtocolConfig();
    protocol.setId("motan");
    protocol.setName("motan");
    motanDemoService.setProtocol(protocol);
    motanDemoService.setExport("motan:8002");
    // 服务发布
    motanDemoService.export();
    

####  2. 服务引用 

    RefererConfig<MotanDemoService> motanDemoServiceReferer = new RefererConfig<MotanDemoService>();
    // 设置接口及实现类
    motanDemoServiceReferer.setInterface(MotanDemoService.class);
    // 配置服务的group以及版本号
    motanDemoServiceReferer.setGroup("motan-demo-rpc");
    motanDemoServiceReferer.setVersion("1.0");
    motanDemoServiceReferer.setRequestTimeout(2000);
    // 配置ZooKeeper注册中心
    RegistryConfig zookeeperRegistry = new RegistryConfig();
    zookeeperRegistry.setRegProtocol("zookeeper");
    zookeeperRegistry.setAddress("127.0.0.1:2181");
    motanDemoServiceReferer.setRegistry(zookeeperRegistry);
    // 配置RPC协议
    ProtocolConfig protocol = new ProtocolConfig();
    protocol.setId("motan");
    protocol.setName("motan");
    motanDemoServiceReferer.setProtocol(protocol);
    // 使用服务
    MotanDemoService service = motanDemoServiceReferer.getRef();
    service.hello("motan");
    

###  与 Spring 集成的 XML 配置 

 接下来看下上面这两段 [ 代码 ](https://www.jfox.info/go.php?url=http://www.liuhaihua.cn/archives/tag/%e4%bb%a3%e7%a0%81) 是如何通过XML来玩的. 

 1. 服务发布 

    <beansxmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:motan="http://api.weibo.com/schema/motan"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
           http://api.weibo.com/schema/motan http://api.weibo.com/schema/motan.xsd">
    
        <!-- 业务具体实现类 -->
        <beanid="motanDemoServiceImpl"class="com.weibo.motan.demo.server.MotanDemoServiceImpl"/>
        <!-- 注册中心配置 使用不同注册中心需要依赖对应的jar包。如果不使用注册中心，可以把check属性改为false，忽略注册失败。-->
        <motan:registryregProtocol="zookeeper"name="registry"address="127.0.0.1:2181"/> 
        <!-- 协议配置。为防止多个业务配置冲突，推荐使用id表示具体协议。-->
        <motan:protocolid="demoMotan"default="true"name="motan"
                        maxServerConnection="80000" maxContentLength="1048576"
                        maxWorkerThread="800" minWorkerThread="20"/>
        <!-- 通用配置，多个rpc服务使用相同的基础配置. group和module定义具体的服务池。export格式为“protocol id:提供服务的端口”-->
        <motan:basicServiceexport="demoMotan:8002"
                            group="motan-demo-rpc" accessLog="false" shareChannel="true" module="motan-demo-rpc"
                            application="myMotanDemo" registry="registry" id="serviceBasicConfig"/>
        <!-- 具体rpc服务配置，声明实现的接口类。-->
        <motan:serviceinterface="com.weibo.motan.demo.service.MotanDemoService"
                       ref="motanDemoServiceImpl" export="demoMotan:8002" basicService="serviceBasicConfig">
        </motan:service>
    </beans>
    
    在基于Spring的项目中，引用这个配置文件即可完成服务的发布。那么 Motan 是怎么与Spring集成的呢？
    Motan 自定义了一个 shcema motan.xsd，然后在 motan-core # META-INF/spring.handlers 中定义了 这个 schema 的 handler.
    ```sh
    http/://api.weibo.com/schema/motan=com.weibo.api.motan.config.springsupport.MotanNamespaceHandler
    

 

  MotanNamespaceHandler 中定义了 
  
  
[点赞](void(0))[ACE](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/ACE/)[Spring](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/Spring/)[App](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/App/)[cat](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/cat/)[bean](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/bean/)[API](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/API/)
{% endraw %}
