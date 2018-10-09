---
layout: post
title:  "使用Java JConsole监控Tomcat"
title2:  "使用Java JConsole监控Tomcat"
date:   2017-01-01 23:56:44  +0800
source:  "https://www.jfox.info/%e4%bd%bf%e7%94%a8javajconsole%e7%9b%91%e6%8e%a7tomcat.html"
fileName:  "20170101304"
lang:  "zh_CN"
published: true
permalink: "2017/%e4%bd%bf%e7%94%a8javajconsole%e7%9b%91%e6%8e%a7tomcat.html"
---
{% raw %}
作者[人生_0809](/u/9da7a52eeea3)2017.07.13 17:46字数 494
在做性能测试的时候，我们常常需要对Tomcat进行监控，一般tomcat使用的配置就是默认配置。这里我们说下Tomcat的默认配置情况

在tomcat配置文件server.xml中的配置中，和连接数相关的参数有：

minProcessors：最小空闲连接线程数，用于提高系统处理性能，默认值为10

maxProcessors：最大连接线程数，即：并发处理的最大请求数，默认值为75

acceptCount：允许的最大连接数，即等待队列，指定当所有可以使用的处理请求的线程数都被使用时，可以放到处理队列中的请求数，超过这个数的请求将不予处理。应大于等于maxProcessors，默认值为100

在大并发的情况下超过等待队列默认值，Nginx就会报错，因此为了更好的使用tomcat故对tomcat进行监控

首先打开被监控的对象Tomcat配置面板

找到Java选项卡；

在Java Options框的最下方增加以下内容:

-Djava.rmi.server.hostname=IP地址

-Dcom.sun.management.jmxremote

-Dcom.sun.management.jmxremote.port=”端口号”

-Dcom.sun.management.jmxremote.authenticate=”false”

-Dcom.sun.management.jmxremote.ssl=”false”
![](/wp-content/uploads/2017/07/1499955499.png)
重启Tomcat 服务

JConsole是一个可执行文件，在java根目录下bin文件；单击bin文件下JConsole.exe运行程序，可以通过JDK的bin来搜索JConsole
![](/wp-content/uploads/2017/07/14999554991.png)
执行JConsole程序，会弹出JConsole：新建连接对话框：

有两种监控方法：本地进程监控和远程监控。

选择“本地进程”在下拉列表框中会列出JConsole程序相同用户的进程，我们这里选择远程进程，单击“链接”按钮，即可进入监控的主界面。
{% endraw %}
