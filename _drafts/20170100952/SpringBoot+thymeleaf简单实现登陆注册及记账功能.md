---
layout: post
title:  "SpringBoot+thymeleaf简单实现登陆注册及记账功能"
title2:  "SpringBoot+thymeleaf简单实现登陆注册及记账功能"
date:   2017-01-01 23:50:52  +0800
source:  "https://www.jfox.info/springboot-thymeleaf%e7%ae%80%e5%8d%95%e5%ae%9e%e7%8e%b0%e7%99%bb%e9%99%86%e6%b3%a8%e5%86%8c%e5%8f%8a%e8%ae%b0%e8%b4%a6%e5%8a%9f%e8%83%bd.html"
fileName:  "20170100952"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springboot-thymeleaf%e7%ae%80%e5%8d%95%e5%ae%9e%e7%8e%b0%e7%99%bb%e9%99%86%e6%b3%a8%e5%86%8c%e5%8f%8a%e8%ae%b0%e8%b4%a6%e5%8a%9f%e8%83%bd.html"
---
{% raw %}
本项目主要是使用了SpringBoot及其集成的thymeleaf、分页查询框架、mybatis框架、redis(提供了该功能，但是没有完全实现该验证)，同时使用了的是mysql数据库，项目主要实现的功能如下:

 1.简单的登陆、注册以及密码修改功能；

 2.新增收入、支出功能；

 3.分别按照年月日来查询收入、支出的单独情况；

 4.分别按照年月日来查询收入支出的总体情况；

 5.定时任务来按照年月日运行相关的收入支出情况；

 6.分别按照年月日来手动运行 收入支出情况。

 相关的数据库设计、SQL表结构及自动生成表对应的java类的bat文件都在项目中，具体的实现细节请参考上传的文件。
{% endraw %}
