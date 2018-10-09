---
layout: post
title:  "构建自己的Tomcat镜像"
title2:  "构建自己的Tomcat镜像"
date:   2017-01-01 23:56:11  +0800
source:  "https://www.jfox.info/%e6%9e%84%e5%bb%ba%e8%87%aa%e5%b7%b1%e7%9a%84tomcat%e9%95%9c%e5%83%8f.html"
fileName:  "20170101271"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%9e%84%e5%bb%ba%e8%87%aa%e5%b7%b1%e7%9a%84tomcat%e9%95%9c%e5%83%8f.html"
---
{% raw %}
H2M_LI_HEADER 在官方提供的Tomcat镜像的基础上进行构建（以官方Tomcat镜像为父镜像）。官方的Tomcat镜像已经为我们做了很多工作，我们只需要修改部分内容即可。
H2M_LI_HEADER 根据openjdk镜像，参考官方Tomcat镜像的Dockerfile文件进行构建。我们可以完全按照自己的需求安装和配置Tomcat。当然，通过第一种方式也能达到这个目的，这不是本文的重点。

为了更好地演示Tomcat镜像的构建步骤，本文将按照第二种方式构建我们自己的Tomcat。我们构建的依据当然是官方Tomcat镜像的Dockerfile文件，有想了解该文件的内容朋友，可以移步至我的另一篇博客：[官方Tomcat镜像Dockerfile分析及镜像使用](https://www.jfox.info/go.php?url=http://www.cnblogs.com/dfengwei/p/7144937.html?_blank)。

我们会对官方的Dockerfile进行一定的精简，去掉可有可无的指令，并添加我们自定义的指令。当然这个可有可无只是我个人认为，仅供参考。

## 改造后的Dockerfile文件

    FROM openjdk:8-jre
    
    MAINTAINER dfengwei@163.com
    
    ENV JAVA_HOME /docker-java-home
    ENV CATALINA_HOME /usr/local/tomcat
    ENV PATH $CATALINA_HOME/bin:$PATH
    ENV TIME_ZONE Asia/Shanghai
    RUN mkdir -p "$CATALINA_HOME"
    WORKDIR $CATALINA_HOME
    
    RUN set -x 
        
        # 下载Tomcat压缩文件
        && wget -O tomcat.tar.gz 'https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz' 
        # 解压
        && tar -xvf tomcat.tar.gz --strip-components=1 
        # 删除供Windows系统使用的.bat文件
        && rm bin/*.bat 
        # 删除Tomcat压缩文件
        && rm tomcat.tar.gz* 
        
        # 更改时区
        && echo "${TIME_ZONE}" > /etc/timezone 
        && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime 
        
        # 处理Tomcat启动慢问题（随机数产生器初始化过慢）
        && sed -i "s#securerandom.source=file:/dev/random#securerandom.source=file:/dev/./urandom#g" $JAVA_HOME/jre/lib/security/java.security
    
    EXPOSE 8080
    CMD ["catalina.sh", "run"]

这个Dockerfile够精简了吧，里面的指令我加了注释，大家应该都能看懂。和官方的Dockerfile相比，虽然看上去是去掉了很多指令，但实际上也是完全够用了的。这里再大致列一下和官方Dockerfile的区别：

1. 去掉了Tomcat Native相关组件。此组件用于支持Tomcat的APR模式，个人认为一般应用并不需要。
2. 去掉了对下载的Tomcat做签名验证的相关内容。我们的Tomcat下载地址已经是官方地址。
3. 增加了对时区的配置。
4. 处理了Tomcat因随机数产生器初始化过慢而导致启动过慢问题。该问题可能在某些硬件条件下会出现，比如阿里云的ECS。

**注意**：在增加指令进行定制化改造的同时，也要适当考虑镜像的通用性。

## 构建镜像

进入Dockerfile所在路径，执行以下命令构造镜像（注意末尾的点不能遗漏）：

    $ docker build -t dfengwei/tomcat:8.5.15-jre8 .

Docker的build命令这里就不多做解释了，请自行百度或参考官方文档。构建后的镜像存于本机，只能本机使用。

命令中的`-t`参数用于指定该镜像的标签。标签格式一般是是：`用户名/镜像名称:镜像版本号`。

如果该镜像只是你本地使用，那么标签你可以随意取；但是如果你要使用DockerHub等托管服务托管该镜像，则必须使用托管服务商给你用户名作为标签的`用户名`，并且`镜像名称`和`镜像版本号`遵循一定的规则。官方的托管服务是[DockerHub](https://www.jfox.info/go.php?url=https://hub.docker.com/)，非官方的有很多，比如阿里云的[开发者平台](https://www.jfox.info/go.php?url=https://dev.aliyun.com)。我将在之后的文章中介绍如何操作。

## 运行容器

    $ docker run -d --name tomcat-test -p 8888:8080 dfengwei/tomcat:8.5.15-jre8

本容器的使用方式其实和官方的Tomcat是一样的，只是不支持Tomcat的APR模式。大家可以参考我之前的一篇博客：[官方Tomcat镜像Dockerfile分析及镜像使用](https://www.jfox.info/go.php?url=http://www.cnblogs.com/dfengwei/p/7144937.html?_blank)
{% endraw %}
