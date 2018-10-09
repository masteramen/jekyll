---
layout: post
title:  "少打一局王者荣耀就能上手Spring Cloud？！"
title2:  "少打一局王者荣耀就能上手Spring Cloud？！"
date:   2017-01-01 23:57:15  +0800
source:  "https://www.jfox.info/%e5%b0%91%e6%89%93%e4%b8%80%e5%b1%80%e7%8e%8b%e8%80%85%e8%8d%a3%e8%80%80%e5%b0%b1%e8%83%bd%e4%b8%8a%e6%89%8bspringcloud.html"
fileName:  "20170101335"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%b0%91%e6%89%93%e4%b8%80%e5%b1%80%e7%8e%8b%e8%80%85%e8%8d%a3%e8%80%80%e5%b0%b1%e8%83%bd%e4%b8%8a%e6%89%8bspringcloud.html"
---
{% raw %}
大神的操作当然离不开合适的装备。（框架说明-组件架构） 

  Piggymetrics基础服务设施中用到了 
 Spring Cloud Config、Netflix Eureka、Netflix Hystrix、Netflix Zuul、Netflix Ribbon、Netflix Feign等组件，而这也正是Spring Cloud分布式开发中最核心的组件。 
 

  组件架构如下图所示： 
 
 
 ![](/wp-content/uploads/2017/07/1500040122.jpeg)
 
 

  • 账户服务通过远程客户端（Feign）调用统计服务及通知服务，通过Ribbon实现负载均衡，并在调用过程中增加了断路器（Hystrix）的功能； 
 

  • 由于服务发现后才能调用，因此账户服务、统计服务、通知服务通过注册中心（Eureka）实现互相发现； 
 

  • API Gateway（Zuul）提供对外统一的服务网关，首先从注册中心（Eureka）处获取相应服务，再根据服务调用各个服务的真实业务逻辑； 
 

  • 服务调用过程通过聚合器（Turbine）统一所有断路信息； 
 

  • 整个业务过程中所有服务的配置文件通过Spring Cloud Config来管理，即起什么端口、配置什么参数等； 
 

  • 认证机制通过Auth service实现，提供基本认证服务； 
 

  • Spring Cloud Config、Eureka、Ribbon、Hystrix、Feign以及Turbine均为标准组件，与业务之间没有强关系，不涉及到业务代码，仅需简单配置即可工作。 
 
 
 
那么如何变成自己的项目呢？ 
 

  总共有5步。 
 

  1. git clone项目到本地，并基于该项目创建自己的mvn项目 
 

  2. 将auth-service、account-service、notification-service、statistics-service替换成自己的服务，构造成docker镜像并上传至官方镜像库 
 

      PS: config、registry、gateway、monitoring代码无需修改 
 

  3. 在config中修改统一的配置文件，比如新增服务的服务名、端口等，构造成docker镜像并上传至官方镜像库 
 

  4. 将前文提到的docker-compose（贴个url）例子中对应service的“image”改为修改后上传的官方镜像库地址
{% endraw %}
