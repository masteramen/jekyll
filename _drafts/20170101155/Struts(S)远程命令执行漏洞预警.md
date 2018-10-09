---
layout: post
title:  "Struts(S)远程命令执行漏洞预警"
title2:  "Struts(S)远程命令执行漏洞预警"
date:   2017-01-01 23:54:15  +0800
source:  "https://www.jfox.info/strutss%e8%bf%9c%e7%a8%8b%e5%91%bd%e4%bb%a4%e6%89%a7%e8%a1%8c%e6%bc%8f%e6%b4%9e%e9%a2%84%e8%ad%a6.html"
fileName:  "20170101155"
lang:  "zh_CN"
published: true
permalink: "2017/strutss%e8%bf%9c%e7%a8%8b%e5%91%bd%e4%bb%a4%e6%89%a7%e8%a1%8c%e6%bc%8f%e6%b4%9e%e9%a2%84%e8%ad%a6.html"
---
{% raw %}
天融信 .阿尔法实验室

##  一、 CVE-2017-9791概要

##  1.1 漏洞背景

 Apache 的Struts2是一个优雅的,可扩展的开源 MVC框架 ,主要用于创建企业级 的Java Web 应用程序。在 Struts 2.3.X 系列的Showcase 插件中演示 Struts2 集成Struts 1的插件中存在一处任意代码执行漏洞。当你的 Web 应用使用了 Struts 2 Struts 1插件 , 则可能导致Struts2执行由外部输入的恶意攻击代码。 

##  1.2 漏洞影响

Apache Struts 2.3.x系列中启用了struts2-struts1-plugin插件的版本

##  二、 修复建议

## 2 .1 影响版本

 Apache Struts 2.3.x 系列中的Showcase应用

##  2.2 漏洞检测 （检测是否存在漏洞的方法）

 检查 Struts 2框架的版本号 

##  2.3 补丁地址

 暂无补丁，请升级到最新版 Struts2

##  2.4 临时解决方案

2.4.1不启用struts2-struts1-plugin插件

2.4.2建议升级到最新版本2.5.10.1

 2.4.3开发者通过使用 resource keys替代将原始消息直接传递给ActionMessage的方式。 如下所示

messages.add(“msg”, new ActionMessage(“struts1.gangsterAdded”, gform.getName()));

一定不要使用如下的方式

messages.add(“msg”, new ActionMessage(“Gangster ” + gform.getName() + ” was added”));
{% endraw %}
