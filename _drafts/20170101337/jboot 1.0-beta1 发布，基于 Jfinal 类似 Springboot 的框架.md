---
layout: post
title:  "jboot 1.0-beta1 发布，基于 Jfinal 类似 Springboot 的框架"
title2:  "jboot 1.0-beta1 发布，基于 Jfinal 类似 Springboot 的框架"
date:   2017-01-01 23:57:17  +0800
source:  "https://www.jfox.info/jboot10beta1%e5%8f%91%e5%b8%83%e5%9f%ba%e4%ba%8ejfinal%e7%b1%bb%e4%bc%bcspringboot%e7%9a%84%e6%a1%86%e6%9e%b6.html"
fileName:  "20170101337"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/jboot10beta1%e5%8f%91%e5%b8%83%e5%9f%ba%e4%ba%8ejfinal%e7%b1%bb%e4%bc%bcspringboot%e7%9a%84%e6%a1%86%e6%9e%b6.html"
---
{% raw %}
jboot 1.0-beta1 changes更新如下： 

    1、重构shiro模块，使其支持shiro.ini配置，方便其他项目迁移。
    2、新增JbootRedisLock基于redis的分布式锁。
    3、重构jboot.java 不再支持静态调用，而是通过Jboot.me().xxx这样去调用，方便后续的热加载功能。
    4、新增JbootServer的restart方法，方便后续的热加载。
    5、修复redis密码配置，在没有超时时间配置的时候无效的问题。
    6、修复：redis不能使用blpop命令和brpop命令的bug。
    7、修复：@JbootrpcService注解无法指定远程rpc分组和版本的问题。
    8、完善 jboot 的错误输出，在500错误的时候能够在页面清晰看到错误信息，方便开发排查。
    9、升级 fastjson 到最新版本 1.2.3
    10、完善jboot开发模式设置，新增jboot默认设置为dev，方便日志输出。
    11、修复：motan rpc模块在spi加载的错误问题。
    12、修复：jboot微信模块的access token cache的可能导致的缓存冲突的问题。
    13、更正readme文档，修复其他若干bug，增强稳定性。

Jboot是一个基于jfinal、undertow开发的一个类似springboot的开源框架， 我们已经在正式的商业上线项目中使用。她集成了权限控制（shiro）、微服务，MQ(redismq,rabbitmq,activemq)，RPC（motan/grpc/thrift），监控(使用了Hystrix和 Metrics)、访问隔离、容错隔离、延迟隔离、 熔断、代码生成等功能，开发者使用及其简单，同时保证分布系统的高效和稳定。

欢迎各位小伙伴使用Jboot和SpringBoot做各种PK。

关于错误信息的输出，截个图吧.

![](/wp-content/uploads/2017/07/1500040241.png)

#### Jboot下一步的主要任务：

1、完善错误信息输出。

2、完善程序的自动热加载。

3、完善微服务监控。 

#### Jboot的主要目标：

1、完善的错误信息输出，包括给出日常错误解决方案。

2、完善的自动热加载，极爽的开发体验。

3、完善的监控功能，对微服务模块了如指掌。

4、基于Google的guice框架AOP支持，极度轻量级。

5、极地的学习成本，基于jfinal开发，只需基础servlet知识，无需其他多余概念。
{% endraw %}
