---
layout: post
title: "什么是RESTful API？"
title2: "What is RESTful API?"
date: 2018-10-08 07:34:12  +0800
source: "https://searchmicroservices.techtarget.com/definition/RESTful-API"
fileName: "df4aa17"
lang: "en"
published: true
---

{% raw %}
A RESTful API is an application program interface ([API](https://searchmicroservices.techtarget.com/definition/application-program-interface-API)) thatthat uses [HTTP](https://searchwindevelopment.techtarget.com/definition/HTTP) requests to GET, PUT, POST and DELETE data.
RESTful API 是一个使用[HTTP]的应用程序接口（[API]（https://searchmicroservices.techtarget.com/definition/application-program-interface-API））（https://searchwindevelopment.techtarget.com/定义/ HTTP）请求 GET，PUT，POST 和 DELETE 数据。(zh_CN)

A RESTful API -- also referred to as a RESTful web service -- is based on representational state transfer ([REST](https://searchmicroservices.techtarget.com/definition/REST-representational-state-transfer)) technology, an architectural style and approach to communications often used in [web services](https://searchmicroservices.techtarget.com/definition/Web-services-application-services) development.
RESTful API（也称为 RESTful Web 服务）基于代表性状态转移（[REST]（https://searchmicroservices.techtarget.com/definition/REST-representational-state-transfer））技术，通常用于[web services]（https://searchmicroservices.techtarget.com/definition/Web-services-application-services）开发的架构风格和通信方法。(zh_CN)

REST technology is generally preferred to the more robust Simple Object Access Protocol ([SOAP](https://searchmicroservices.techtarget.com/definition/SOAP-Simple-Object-Access-Protocol)) technology because REST leverages less [bandwidth](https://searchnetworking.techtarget.com/definition/bandwidth), making it more suitable for internet usage. An API for a website is [code](https://whatis.techtarget.com/definition/code) that allows two software programs to communicate with each another. The API spells out the proper way for a developer to write a program requesting services from an [operating system](https://whatis.techtarget.com/definition/operating-system-OS) or other [application](https://searchsoftwarequality.techtarget.com/definition/application).
REST 技术通常比更健壮的简单对象访问协议（[SOAP]（https://searchmicroservices.techtarget.com/definition/SOAP-Simple-Object-Access-Protocol））技术更受欢迎，因为REST利用的带宽更少[带宽]（ https://searchnetworking.techtarget.com/definition/bandwidth），使其更适合互联网使用。网站的API是[code]（https://whatis.techtarget.com/definition/code），它允许两个软件程序相互通信。 API 为开发人员编写一个从[操作系统]（https://whatis.techtarget.com/definition/operating-system-OS）或其他[应用程序]（https：/）请求服务的程序说明了正确的方法。 /searchsoftwarequality.techtarget.com/definition/application）。(zh_CN)

This video by Kevin Babcock
这段视频由 Kevin Babcock 撰写(zh_CN)
details RESTful API design and
详细介绍 RESTful API 设计和(zh_CN)
related HTTP concepts.
相关的 HTTP 概念。(zh_CN)

The REST used by [browsers](https://searchwindevelopment.techtarget.com/definition/browser) can be thought of as the language of the [internet](https://searchwindevelopment.techtarget.com/definition/Internet). With cloud use on the rise, APIs are emerging to expose web services. REST is a logical choice for building APIs that allow users to connect and interact with [cloud services](https://searchcloudprovider.techtarget.com/definition/cloud-services). RESTful APIs are used by such sites as [Amazon](https://whatis.techtarget.com/definition/Amazon), [Google](https://searchcio.techtarget.com/definition/Google-The-Company), [LinkedIn](https://whatis.techtarget.com/definition/LinkedIn) and [Twitter](https://whatis.techtarget.com/definition/Twitter).
[browsers]（https://searchwindevelopment.techtarget.com/definition/browser）使用的REST可以被认为是[internet]的语言（https://searchwindevelopment.techtarget.com/definition/Internet）。随着云的使用不断增加，API正在出现以暴露Web服务。 REST 是构建 API 的合理选择，允许用户连接[云服务]并与之交互（https://searchcloudprovider.techtarget.com/definition/cloud-services）。 RESTful API 被[亚马逊]（https://whatis.techtarget.com/definition/Amazon），[Google]（https://searchcio.techtarget.com/definition/Google-The-Company）等网站使用， [LinkedIn]（https://whatis.techtarget.com/definition/LinkedIn）和[Twitter]（https://whatis.techtarget.com/definition/Twitter）。(zh_CN)

### How RESTful APIs work

### RESTful API 的工作原理(zh_CN)

A RESTful API breaks down a [transaction](https://searchcio.techtarget.com/definition/transaction) to create a series of small modules. Each [module](https://whatis.techtarget.com/definition/module) addresses a particular underlying part of the transaction. This modularity provides developers with a lot of flexibility, but it can be challenging for developers to design from scratch. Currently, the models provided by [Amazon Simple Storage Service](https://searchaws.techtarget.com/definition/Amazon-Simple-Storage-Service-Amazon-S3), [Cloud Data Management Interface](https://searchstorage.techtarget.com/definition/Cloud-Data-Management-Interface) and [OpenStack Swift](https://searchstorage.techtarget.com/definition/OpenStack-Swift) are the most popular.
RESTful API 分解[事务]（https://searchcio.techtarget.com/definition/transaction）以创建一系列小模块。每个[module]（https://whatis.techtarget.com/definition/module）都解决了事务的特定底层部分。这种模块化为开发人员提供了很大的灵活性，但开发人员从头开始设计可能具有挑战性。目前，[亚马逊简单存储服务]（https://searchaws.techtarget.com/definition/Amazon-Simple-Storage-Service-Amazon-S3），[云数据管理接口]（https：// searchstorage）提供的模型.techtarget.com / definition / Cloud-Data-Management-Interface）和[OpenStack Swift]（https://searchstorage.techtarget.com/definition/OpenStack-Swift）是最受欢迎的。(zh_CN)

A RESTful API explicitly takes advantage of HTTP methodologies defined by the RFC 2616 protocol. They use GET to retrieve a resource; PUT to change the state of or update a resource, which can be an [object](https://searchmicroservices.techtarget.com/definition/object), [file](https://searchexchange.techtarget.com/definition/file) or [block](https://searchsqlserver.techtarget.com/definition/block); POST to create that resource; and DELETE to remove it.
RESTful API 显式利用 RFC 2616 协议定义的 HTTP 方法。他们使用 GET 来检索资源; PUT 改变资源的状态或更新资源，可以是[对象]（https://searchmicroservices.techtarget.com/definition/object），[文件]（https://searchexchange.techtarget.com/definition/文件）或[块]（https://searchsqlserver.techtarget.com/definition/block）; POST 来创建该资源;和 DELETE 删除它。(zh_CN)

With REST, networked components are a resource you request access to -- a [black box](https://searchsoftwarequality.techtarget.com/definition/black-box) whose implementation details are unclear. The presumption is that all calls are stateless; nothing can be retained by the RESTful service between executions.
使用 REST，网络组件是您请求访问的资源 - [黑盒子]（https://searchsoftwarequality.techtarget.com/definition/black-box），其实现细节不清楚。假设所有呼叫都是无国籍的;执行之间RESTful服务无法保留任何内容。(zh_CN)

Because the calls are [stateless](https://whatis.techtarget.com/definition/stateless), REST is useful in cloud applications. Stateless components can be freely redeployed if something fails, and they can [scale](https://searchdatacenter.techtarget.com/definition/scalability) to accommodate [load](https://searchdatacenter.techtarget.com/definition/workload) changes. This is because any request can be directed to any instance of a component; there can be nothing saved that has to be remembered by the next transaction. That makes REST preferred for web use, but the RESTful model is also helpful in cloud services because binding to a service through an API is a matter of controlling how the URL is decoded. [Cloud computing](https://searchcloudcomputing.techtarget.com/definition/cloud-computing) and [microservices](https://searchmicroservices.techtarget.com/definition/microservices) are almost certain to make RESTful API design the rule in the future.
由于调用是[无状态]（https：//whatis.techtarget.com/definition/stateless），因此 REST 在云应用程序中非常有用。如果出现问题，可以自由重新部署无状态组件，并且可以[扩展]（https://searchdatacenter.techtarget.com/definition/scalability）以适应[load]（https://searchdatacenter.techtarget.com/definition/workload ） 变化。这是因为任何请求都可以定向到组件的任何实例;下一次交易可能没有任何东西可以记住。这使 REST 成为 Web 使用的首选，但 RESTful 模型在云服务中也很有用，因为通过 API 绑定到服务是控制 URL 解码的方式。 [云计算]（https://searchcloudcomputing.techtarget.com/definition/cloud-computing）和[微服务]（https://searchmicroservices.techtarget.com/definition/microservices）几乎肯定会使RESTful API 设计成为规则在将来。(zh_CN)
{% endraw %}
