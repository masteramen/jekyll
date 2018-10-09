---
layout: post
title:  "Tomcat源码分析-catalina.home和catalina.base"
title2:  "Tomcat源码分析-catalina.home和catalina.base"
date:   2017-01-01 23:49:46  +0800
source:  "https://www.jfox.info/tomcat%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90-catalina-home%e5%92%8ccatalina-base.html"
fileName:  "20170100886"
lang:  "zh_CN"
published: true
permalink: "2017/tomcat%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90-catalina-home%e5%92%8ccatalina-base.html"
---
{% raw %}
Bootstrap启动的时候使用了两个系统变量catalina.home和catalina.base，从官网和源码中的注释可以知道这两者的区别主要是：catalina.home是Tomcat产品的安装目录，而catalina.base是tomcat启动过程中需要读取的各种配置及日志的根目录。

默认情况下catalina.base是和catalina.home是相同的，本章就为了解决本人看到这两个东西时本能的反应“它们有什么区别，该怎么用”的疑问。

### **应用**

实际上是可以利用这两个系统变量，实现在一台机器上运行多个tomcat实例的目的。主要就是利用catalina.base，因为它是Tomcat启动过程中读取各自配置的根目录，本文将实现一个简单的catalina.base和catalina.home不同的例子。

### **实现流程**

第一步，开启本地虚拟机，上传tomcat解压版的文件到目标虚拟机。 
第二步，在/home/wood/目录下创建一个mytomcat的文件夹。 
第三步，将tomcat安装文件夹下的logs,conf,lib,webapps，这几个目录，上传到mytomcat目录下。（它们是启动tomcat实例相关的文件夹） 
第四步，修改conf目录下的server.xml，修改三个端口，参考如下：

Server port=”8015” shutdown=”SHUTDOWN” 
Connector port=”8080” protocol=”HTTP/1.1” 
Connector port=”8019” protocol=”AJP/1.3” redirectPort=”8443” 

第五步，为当前mytomcat应用的启用，创建一个启动脚本startmytomcat.sh。

    #!/bin/bash 
    JAVA_HOME=/usr/java/jdk1.8.0_60
    CATALINA_HOME=/sensor/web/tomcat
    #导出环境变量，指向自定义的tomcat实例的配置根目录
    CATALINA_BASE=/home/wood/mytomcat
    export JAVA_HOME
    export CATALINA_HOME
    export CATALINA_BASE
    start_tomcat=$CATALINA_HOME/bin/startup.sh
    ${start_tomcat}

而tomcat的启动脚本catalina.sh中会设置catalina.base和catalian.home这两个环境变量的。

      -Dcatalina.base="$CATALINA_BASE"  -Dcatalina.home="$CATALINA_HOME"

该脚本的重点在于设置CATALINA_BASE这个系统环境变量，然后调用catalina.home产品安装目录下的启动脚本。那么该tomcat实例启动是就以mytomcat下的配置为主了。

最后一步，调用startmytomat.sh脚本，可以看到新配置的tomcat实例成功启动。 
![](/wp-content/uploads/2017/06/SouthEast.png)

目标机器启动了两个tomcat，监听端口分别是80和8080，通过浏览器访问两个主页显示正常。

### **延伸思考**

首先，这让我突然联想到Eclipse的tomcat插件，它的原理是不是就是利用这个环境变量的呢？可以这么解释，我可以开多个Eclipse工作空间，同时创建多个server，设置不同的配置，但是我的Eclipse的tomcat的产品安装目录指向的是同一个。我就可以同时将这几个Eclipse中的server都启动起来，端口不同，各不冲突。

其次，这给我们部署多个项目提供了一种新思路通过多个web项目公用一个tomcat产品安装目录，但是配置根目录不同，以达到一台机器部署多个web项目的目的。

而我以前的做法都是上传多个tomcat安装产品，每个Java web应用部署到一个tomcat中，那样显然工作量比前者多，而且存在tomcat版本不统一的问题。
{% endraw %}
