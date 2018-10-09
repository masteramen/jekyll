---
layout: post
title:  "程序员与技术债 » java面试题"
title2:  "程序员与技术债 » java面试题"
date:   2017-01-01 23:51:49  +0800
source:  "https://www.jfox.info/%e7%a8%8b%e5%ba%8f%e5%91%98%e4%b8%8e%e6%8a%80%e6%9c%af%e5%80%ba.html"
fileName:  "20170101009"
lang:  "zh_CN"
published: true
permalink: "2017/%e7%a8%8b%e5%ba%8f%e5%91%98%e4%b8%8e%e6%8a%80%e6%9c%af%e5%80%ba.html"
---
{% raw %}
最近半年一直在弄一个项目，原来做项目都是基于HTML5+Spring MVC+Mybatis开发的，HTML5也是采用了BootStrap和JQuery，中间还浅尝辄止的用过Angular，不过没感觉到Angular的强大，现在再做新项目的时候，就全部转到Spring Boot了。

Spring Boot说实话，入门非常简单，随便找一篇文档就可以入门了，不过我还是推荐Spring boot的官方文档 http://docs.spring.io/spring-boot/docs/current/reference/html/ ，刚开始阅读的时候有些枯燥，遇到问题，边做边看这个文档，有醍醐灌顶之感，所有与Spring boot有关的中文文档，也基本都是从这个官方文档翻译过来的。

不过，Spring Boot使用的时候，坑还是挺多的，例如，图片文件的上传和图片文件路径的选择，如果Spring boot放在Tomcat里做标准war文件运行，这是没有问题的，与标准J2EE程序文件上传并无任何区别。不过，既然选择了Spring boot，那么单个jar/war文件，嵌入tomcat运行就是首选了。单个war文件嵌入tomcat自运行，就没有上传文件图片路径了，图片是不可能上传到压缩文件里面去的。这个问题想了很久也没好的解决办法，就弄了一个二级域名，单独存放图片文件的路径。

在开发过程当中，原来都是使用SVN做版本控制的，现在也选择了git做版本控制，XX年龄的老男人了，还是要学很多新东西的，我老婆换工作到了一个新的媒体公司，新的媒体公司公司写作风格与我老婆原来写作风格差异甚大，1个月了，一篇合格稿子也没写出来，我老婆对此很焦虑。就像我弄了Spring Boot后，下面肯定就是Spring Cloud了。看了其他大牛的分析，一般不推荐Spring的eureka，而推荐Consul，Consul我断断续续搞了三周，终于把与Spring Boot整合demo调通了，却依然没弄明白怎么把Spring boot做好的服务跟Consul结合起来，供客户端调用。

产品做了一个新版本后，又想着升级改版，把原来的单纯使用JQuery升级到vue框架上，虽然vue对标的是Angular与React。之所以打算选择 vue，是看了vue的demo，觉得学习曲线很低，以前也用过Angular，Angular并没有给自己留下深刻印象。

总之，最近半年，学习了微信服务号的开发，Spring boot、Spring cloud、Consul、Git、vue以及阿里云消息服务。阿里云消息服务也有一个不小的坑，期间还发工单问阿里云技术支持，也没找到答案。期间还接触了Docker、Java8新的表达式，以及看了微服务很多文档，收获满满，也感觉到需要学习的东西太多了，原来一个项目自己就可以搞定，现在需要4-5个人才可以搞定。

有对微信服务号开发的可以加我微信 eesssss 共同探讨微服务新架构下与企业软件的集成以及与微信服务号的集成。
{% endraw %}
