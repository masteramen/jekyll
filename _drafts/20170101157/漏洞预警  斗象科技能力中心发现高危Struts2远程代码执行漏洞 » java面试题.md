---
layout: post
title:  "漏洞预警 | 斗象科技能力中心发现高危Struts2远程代码执行漏洞 » java面试题"
title2:  "漏洞预警  斗象科技能力中心发现高危Struts2远程代码执行漏洞 » java面试题"
date:   2017-01-01 23:54:17  +0800
source:  "http://www.jfox.info/%e6%bc%8f%e6%b4%9e%e9%a2%84%e8%ad%a6%e6%96%97%e8%b1%a1%e7%a7%91%e6%8a%80%e8%83%bd%e5%8a%9b%e4%b8%ad%e5%bf%83%e5%8f%91%e7%8e%b0%e9%ab%98%e5%8d%b1struts2%e8%bf%9c%e7%a8%8b%e4%bb%a3%e7%a0%81%e6%89%a7.html"
fileName:  "20170101157"
lang:  "zh_CN"
published: true
permalink: "%e6%bc%8f%e6%b4%9e%e9%a2%84%e8%ad%a6%e6%96%97%e8%b1%a1%e7%a7%91%e6%8a%80%e8%83%bd%e5%8a%9b%e4%b8%ad%e5%bf%83%e5%8f%91%e7%8e%b0%e9%ab%98%e5%8d%b1struts2%e8%bf%9c%e7%a8%8b%e4%bb%a3%e7%a0%81%e6%89%a7.html"
---
{% raw %}
近期，来自斗象科技（Tophant）的安全研究员 icez（星光） 发现著名J2EE框架——Struts2存在远程代码执行的严重漏洞。Struts2官方已经确认该漏洞（漏洞编号S2-048，CVE编号：CVE-2017-9791），漏洞危害程度为高危(High)。

## 在线检测

 斗象科技旗下产品网藤风险感知（ [www.riskivy.com](http://www.jfox.info/go.php?url=http://www.riskivy.com) ）已率先支持该漏洞检测，您可以立即 [点击](http://www.jfox.info/go.php?url=http://www.riskivy.com) 试用 

## 漏洞编号

CVE-2017-9791

S2-048

## ![](/wp-content/uploads/2017/07/1499444816.png)

## 漏洞概述

Apache Struts是美国阿帕奇（Apache）软件基金会负责维护的一个开源项目，是一套用于创建企业级Java Web应用的开源MVC框架。在Struts 2.3.x 系列的Showcase 应用中演示Struts2集成Struts 1 的插件中存在一处任意代码执行漏洞。当你的应用使用了Struts2 Struts1的插件时，可能导致不受信任的输入传入到ActionMessage类中导致命令执行。

## 解决方案

向ActionMessage传递原始消息时使用类似下面的资源键值，不要直接传递原始数值

    messages.add("msg", new ActionMessage("struts1.gangsterAdded", gform.getName()));

值不应如此：

    messages.add("msg", new ActionMessage("Gangster " + gform.getName() + " was added"));
{% endraw %}
