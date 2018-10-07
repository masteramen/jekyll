---
layout: post
title:  "华为软件开发云对比Jenkins-JavaWeb项目持续部署方式"
title2:  "华为软件开发云对比Jenkins-JavaWeb项目持续部署方式"
date:   2017-01-01 23:59:16  +0800
source:  "http://www.jfox.info/%e5%8d%8e%e4%b8%ba%e8%bd%af%e4%bb%b6%e5%bc%80%e5%8f%91%e4%ba%91%e5%af%b9%e6%af%94jenkinsjavaweb%e9%a1%b9%e7%9b%ae%e6%8c%81%e7%bb%ad%e9%83%a8%e7%bd%b2%e6%96%b9%e5%bc%8f.html"
fileName:  "20170101456"
lang:  "zh_CN"
published: true
permalink: "%e5%8d%8e%e4%b8%ba%e8%bd%af%e4%bb%b6%e5%bc%80%e5%8f%91%e4%ba%91%e5%af%b9%e6%af%94jenkinsjavaweb%e9%a1%b9%e7%9b%ae%e6%8c%81%e7%bb%ad%e9%83%a8%e7%bd%b2%e6%96%b9%e5%bc%8f.html"
---
{% raw %}
作者[程序员的那点事](/u/e03fc43b507b)2017.08.02 14:58字数 2531
### 一、前言：Jenkins介绍

Jenkins是一个开源软件项目，是基于Java开发的一种持续集成工具，用于监控持续重复的工作，旨在提供一个开放易用的软件平台，使软件的持续集成和持续部署变成可能。

本文演示样例是一个JavaWeb项目，环境如下：

服务器：CentOS 7.3.1611主机一台

代码管理：git

编译打包：maven

发布部署：tomcat7

本试验以下下载、解压、执行等操作均在主机/home/centos目录下进行

传统工作模式需要通过手动操作大概完成如下几个步骤：

1、拉取代码

2、编译打包

3、停止tomcat服务

4、将程序包上传至tomcat容器内

5、启动tomcat服务

使用Jenkins可以将上述步骤一键完成，再配合相应的触发器机制（扫描代码变动或强制定时任务），可以实现完全的无人干预、自动完成。它的内部工作步骤如下：

1、Jenkins的触发器扫描到代码仓库发生变化或者到了设定好的任务开始时间

2、Jenkins使用git到代码仓库拉取代码

3、Jenkins使用maven对拉取的代码进行编译、打包

4、Jenkins把打包好的war工程传输到指定tomcat的webapps目录下

5、Jenkins重启tomcat服务

### 二、准备工作

Git版本控制服务器：

本实验中所用的Git代码服务器已提前备好，直接使用

CentOS主机上安装（已存在可忽略）：

1、JDK安装

本试验中Tomcat和Jenkins都需要依赖JDK，其中最新版的Jenkins需要JDK1.8版本，采用yum安装

yum install java-1.8.0-openjdk –y

安装完毕后执行java

-version确认一下，看到版本号表示成功

2、Tomcat安装

本试验中Tomcat用来部署JavaWeb项目，Jenkins插件目前只支持到Tomcat7版本

下载安装包：

wget http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-7/v7.0.79/bin/apache-tomcat-7.0.79.tar.gz

地址如果失效，可去官网http://tomcat.apache.org/重新找一个链接地址

修改端口：

Tomcat默认端口是8080，本试验中主机该端口已被占用，修改为8082

解压安装包后到Tomcat目录里面conf目录下编辑server.xml文件，将下图位置的8080修改为新的端口号：
![](/wp-content/uploads/2017/08/1501683372.png)
启停服务：

到tomcat目录里面bin目录下，执行./startup启动，访问一下，地址：

http://主机IP:8082。不能访问基本都是防火墙问题，能出现小猫界面就表示服务启动成功，要想停止服务可以执行./shutdown.sh ,也可以找到进程pid，执行kill -9 pid号。

解决Tomcat启动慢：

如果发现Tomcat启动特别慢，可以打开jdk安装路径下/jre/lib/security/java.security这个文件找到securerandom.source参数修改为

securerandom.source=file:/dev/./urandom

本试验中该文件路径为/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/jre/lib/security/java.security

3、Git安装

yum

-y installgit

安装完后执行git –version确认，看到版本号表示成功

4、Maven安装

yum-y install maven

安装完后执行mvn -v确认，看到版本号表示成功

### 三、安装Jenkins

下载程序包：

wget http://mirrors.jenkins.io/war/latest/jenkins.war

启动程序包：

下载的Jenkins程序war包可以用Tomcat发布，也可以直接执行启动，本试验中Tomcat服务用于发布JavaWeb项目，为避免混淆，采用直接执行启动。

启动命令

java -jarjenkins.war –httpPort=8081

如果不写端口号参数，默认启动端口是8080

初次启动控制台里会生成一个密码，对其进行复制

打开访问地址：http://主机IP:8081，出现如下页面
![](/wp-content/uploads/2017/08/15016833721.png)
将刚才的密码进行粘贴，也可根据提示到主机上

cat /root/.jenkins/secrets/initialAdminPassword找到密码进行复制粘贴。来到如下页面
![](/wp-content/uploads/2017/08/15016833722.png)
这步是让选择推荐安装还是自定义安装，之后可以随时更改，点第一个，知道用什么插件点第二个也可以这样装的包少一点。安装的插件都在/root/.jenkins/plugins/下面
![](/wp-content/uploads/2017/08/15016833723.png)![](/wp-content/uploads/2017/08/15016833724.png)
直接选择continue as admin
![](/wp-content/uploads/2017/08/15016833725.png)
开始使用，点击就会进来
![](/wp-content/uploads/2017/08/1501683373.png)
重置admin密码：

以后访问时会需要账号密码，在“系统管理”-“管理用户”中对admin账户进行密码重置修改。

至此完成Jenkins安装以及初次登录。

此时Jenkins运行在CentOS当前页面进程里，如果关掉当前会话会导致Jenkins服务停止，可先将服务停掉，运行如下命令进行后台启动：

nohup java -jarjenkins.war –httpPort=8081 &

如要停止服务，可找到进程pid号，执行kill-9pid号

### 四、配置Jenkins

1、插件安装：

（1）发布容器插件
![](/wp-content/uploads/2017/08/15016833731.png)![](/wp-content/uploads/2017/08/15016833732.png)
选择可选插件，过滤搜索Deploy to[Container](http://www.jfox.info/go.php?url=http://lib.csdn.net/base/docker)Plugin插件（这个是支持将代码部署到tomcat容器的）

勾选，点击下边的按钮：直接安装，这个可能时间较久，等待即可。
![](/wp-content/uploads/2017/08/15016833733.png)
（2）Maven工程插件

步骤同上，插件名为MavenIntegration plugin

2、系统配置
![](/wp-content/uploads/2017/08/15016833734.png)
（1）JDK，别名是任意的,路径填写刚才yum安装的jdk位置

/usr/lib/jvm/java-1.8.0-openjdk
![](/wp-content/uploads/2017/08/15016833735.png)
（2）Git，注意这里的git位置，是可执行文件的地址（类似于Java中bin下的java可执行文件位置），可通过git –exec-path命令查看路径，本试验yum安装的git可执行文件位置为/usr/libexec/git-core/git
![](/wp-content/uploads/2017/08/15016833736.png)
（3）Maven，选择刚才yum安装的maven存放位置

/usr/share/maven
![](/wp-content/uploads/2017/08/15016833737.png)
至此Jenkins的基本配置完成。

### 五、创建任务

1、新建任务
![](/wp-content/uploads/2017/08/15016833738.png)
2、配置任务

（1）源码管理

源码管理选择Git，这个时候添加url之后，下边会报错，显示让去认证，认证即可（其他的安装中又遇到这个问题），如果认证失败，请下载认证Github Authentication plugin插件，这个在插件管理的可选插件中搜索安装
![](/wp-content/uploads/2017/08/15016833739.png)
（2）构建触发器
![](/wp-content/uploads/2017/08/150168337310.png)
此处默认为第一个选项，可以根据实际业务选择其他选项，

例如：

Build periodically：周期性触发执行

Poll SCM：周期性扫描代码仓库，源代码发生变化触发执行

配置内容可以点选后面的问号圆圈查看填写规则说明

此试验配置为：每五分钟执行一次，H/5 * * * *

（3）构建后操作
![](/wp-content/uploads/2017/08/150168337311.png)![](/wp-content/uploads/2017/08/150168337312.png)
此配置是将编译后的文件**/target/intro.war（就是本试验的JavaWeb项目编译构建后生成的war包）部署到下边的远程Tomcat容器中；这里Containers的用户名和密码是Tomcat管理员的账户密码，Tomcat URL就是你需要进行部署的远程Tomcat服务器的ip和端口。

这里需要进行设置的是Tomcat的管理员信息，修改Tomcat容器下的conf文件夹下的tomcat-users.xml文件，在内添加下边的内容后重启Tomcat：

至此任务创建配置完成

### 六、查看任务

此时可以点击“立即构建”，也可以等待定时任务自动触发。
![](/wp-content/uploads/2017/08/1501683374.png)![](/wp-content/uploads/2017/08/15016833741.png)![](/wp-content/uploads/2017/08/15016833742.png)![](/wp-content/uploads/2017/08/15016833743.png)
打开JavaWeb项目验证地址

http://主机ip：8082/intro
![](/wp-content/uploads/2017/08/1501683375.png)
至此，使用Jenkins搭建的持续集成部署环境全部完成，项目人员现在只需要专注于程序开发，将完成编写和测试的代码提交至代码仓库，后续的编译、打包、上传、部署等工作全部由Jenkins根据事先的配置自动完成。

1、软件易安装

Jenkins★★★☆

程序包下载后通过命令安装或者通过web容器发布，依赖于JDK，需要主机

华为软件开发云★★★★

云上服务，无需任何安装和依赖，即开即用，需要网络

2、工具集成度

Jenkins★★☆☆

依靠插件调用Git、Maven、Ant等工具，所用到的工具都需要本地安装

[华为软件开发云](http://www.jfox.info/go.php?url=https://www.hwclouds.com/devcloud/)★★★★

工具全部内置到了云端服务上，无需安装，直接使用

3、工具扩展

Jenkins★★★★

插件丰富，自由选择使用，对不同的软件环境均可很好的支持

华为软件开发云★★☆☆

所集成的工具种类和版本较为固定，不可自由选择

4、软件易使用

Jenkins★★★☆

操作界面友好，各个配置项均有图标进行说明和配置样例。

华为软件开发云★★★☆

产品上有大量的帮助文档、操作视频，配合在线客服，从不同角度提供技术支持

5、自动化任务功能

Jenkins★★★★

功能强大，支持月周天时分各个级别的自由配置

华为软件开发云★★☆☆

目前流水线功能支持每天固定一个时间或每周某些天的固定时间，无法进行更自由的配置

6、消息通知机制

Jenkins★★★☆

发送邮件进行通知，邮件内容可配置

[华为软件开发云](http://www.jfox.info/go.php?url=https://www.hwclouds.com/devcloud/)★★★☆

通过邮件和站内消息两种方式进行通知
{% endraw %}
