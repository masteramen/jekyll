---
layout: post
title:  "Java selenium (二) 环境搭建方法"
title2:  "Java selenium (二) 环境搭建方法"
date:   2017-01-01 23:52:17  +0800
source:  "https://www.jfox.info/java-selenium-%e4%ba%8c-%e7%8e%af%e5%a2%83%e6%90%ad%e5%bb%ba%e6%96%b9%e6%b3%95.html"
fileName:  "20170101037"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java-selenium-%e4%ba%8c-%e7%8e%af%e5%a2%83%e6%90%ad%e5%bb%ba%e6%96%b9%e6%b3%95.html"
---
{% raw %}
webdriver 就是selenium 2。 webdriver 是一款优秀的，开源的，自动化测试框架。 支持很多语言。 本文描述的是用java Eclipse 如何搭建环境。 

##  首先下载好Eclipse 和配置好Java 环境变量 

 步骤省略， 请百度。 

##  方法一 添加jar包 

 官方下载地址： http://www.seleniumhq.org/download/ 

 官方地址经常被墙, 也可以到我百度网盘中下载:　http://pan.baidu.com/s/1c1tD6Kw 

![](/wp-content/uploads/2017/07/1499007681.html_.png)

 解压后有四个文件： 

![](/wp-content/uploads/2017/07/1499007683.html_.png)

 1. 新建一 个Java Project 

 把上面解压出来的文件， 都复制到新建的Project 目录下， 目录结构如下 

![](/wp-content/uploads/2017/07/1499007686.html_.png)

 2. 添加build path, 项目目录右键　Build Path -> Config build path -> java build Path ->　Libraries -> Add JARs 

 3. 把libs 文件夹下的jar包，全部添加上，再添加 selenium-java-2.44.0-src.jar和selenium-java-2.44.0.jar 

![](/wp-content/uploads/2017/07/1499007687.html_.png)

 添加成功后，目录结构如下。 

##  方法二 直接引用selenium-server-standalone.jar 

 selenium-server-standalone.jar 下载地址也在： http://pan.baidu.com/s/1c1tD6Kw 

 将selenium-server-standalone.jar 直接添加到java项目中就可以了 

![](/wp-content/uploads/2017/07/1499007689.html_.png)

##  附： selenium java教程 (连载中, 敬请期待）
{% endraw %}
