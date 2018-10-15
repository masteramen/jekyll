---
layout: post
title:  "Jenkins+Gitlab+Maven+Tomcat实现自动集成、打包、部署"
title2:  "Jenkins+Gitlab+Maven+Tomcat实现自动集成、打包、部署"
date:   2018-10-15 09:52:39  +0800
source:  "https://liubin.fun/2018/%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90%E5%B7%A5%E5%85%B7Jenkins%E7%9A%84%E4%BD%BF%E7%94%A8/"
fileName:  "67741e0"
lang:  "zh_CN"
published: false

---
{% raw %}
[![](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018918173750.jpg)](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018918173750.jpg)

## 从装修厨房看项目开发效率优化

### 持续部署(Continuous Deployment)

**装修厨房**
全部装好之后发现灯不亮，电路有问题；冷热水装反了，管路有问题。这些问题要解决就必须把地砖、墙砖拆掉——一个环节有问题，其他环节跟着返工。
那怎么做会好些呢？
任何安装完成即时测试，确保其可以正常工作。

**项目开发**
开发过程中进行单元测试能够通过，但是部署到服务器上运行出现问题。
那怎么做会好一些呢？
仅仅单元测试还不够，各个模块都必须能够在服务器上运行。

**关注点**
持续部署的关注点在于项目功能部署至服务器后可以运行，为下一步测试环节
或最终用户正式使用做好准备。

### 持续集成(Continuous Integration)

**装修厨房**
装修厨房时我们需要铺地砖，如果把所有地砖都切好再拿去铺就会发现：每一块地砖单独看都是好的，但是实际铺的时候，把所有地砖整合起来，发现和厨房
地面总体尺寸不匹配，边边角角的地砖需要重新切，时间和物料成本陡然升高。
那怎么做会好一些呢？
切一块铺一块，根据需要的尺寸来切，尽早发现尺寸变化，避免返工。

**项目开发**
各个小组分别负责各个具体模块开发，本模块独立测试虽然能够通过，但是上线前夕将所有模块整合到一起集成测试却发现很多问题，想要解决就需要把很多代
码返工重写而且仍然有可能有问题，但现在时间很可能不够了。
那怎么做会好一些呢？
经常性、频繁的把所有模块集成在一起进行测试，有问题尽早发现，这就是持续集成。

**关注点**
持续集成的关注点在于尽早发现项目整体运行问题，尽早解决。

### 持续交付(Continuous Delivery)

**装修厨房**
全部装修好之后房屋主人来验收，各项功能都正常，但是水龙头的样式主人不喜欢，灶台的位置主人不满意，要求返工。
那怎么做会好一些呢？
房屋主人随时查看装修进度，施工团队及时调整。

**项目开发**
项目的各个升级版本之间间隔时间太长，对用户反馈感知迟钝，无法精确改善用户体验，用户流失严重。
那怎么做会好一些呢？
用小版本不断进行快速迭代，不断收集用户反馈信息，用最快的速度改进优化。

**关注点**
持续交付的关注点在于研发团队的最新代码能够尽快让最终用户体验到。

### 总体目标

1.降低风险
一天中进行多次的集成，并做了相应的测试，这样有利于检查缺陷，了解软件的健康状况，减少假定。

2.减少重复过程
产生重复过程有两个方面的原因，一个是编译、测试、打包、部署等等固定操作都必须要做，无法省略任何一个环节；另一个是一个缺陷如果没有及时发现，有可能导致后续代码的开发方向是错误的，要修复问题需要重新编写受影响的所有代码。而使用Jenkins 等持续集成工具既可以把构建环节从手动完成转换为自动化完成，又可以通过增加集成频次尽早发现缺陷避免方向性错误。

3.任何时间、任何地点生成可部署的软件
持续集成可以让您在任何时间发布可以部署的软件。从外界来看，这是持续集成最明显的好处，我们可以对改进软件品质和减少风险说起来滔滔不绝，但对于客户来说，可以部署的软件产品是最实际的资产。利用持续集成，您可以经常对源代码进行一些小改动，并将这些改动和其他的代码进行集成。如果出现问题，项目成员马上就会被通知到，问题会第一时间被修复。不采用持续集成的情况下，这些问题有可能到交付前的集成测试的时候才发现，有可能会导致延迟发布产品，而在急于修复这些缺陷的时候又有可能引入新的缺陷，最终可能导致项目失败。

4.增强项目的可见性
持续集成让我们能够注意到趋势并进行有效的决策。如果没有真实或最新的数据提供支持，项目就会遇到麻烦，每个人都会提出他最好的猜测。通常，项目成员通过手工收集这些信息，增加了负担，也很耗时。持续集成可以带来两点积极效果：

- 有效决策：持续集成系统为项目构建状态和品质指标提供了及时的信息，有些持续集成系统可以报告功能完成度和缺陷率。
- 注意到趋势：由于经常集成，我们可以看到一些趋势，如构建成功或失败、总体品质以及其它的项目信息。

5.建立团队对开发产品的信心
持续集成可以建立开发团队对开发产品的信心，因为他们清楚的知道每一次构建的结果，他们知道他们对软件的改动造成了哪些影响，结果怎么样。

## 持续集成工具Jenkins

> Jenkins是一个独立的开源软件项目，是基于Java开发的一种持续集成工具，用于监控持续重复的工作，旨在提供一个开放易用的软件平台，使软件的持续集成变成可能。前身是Hudson是一个可扩展的持续集成引擎。可用于自动化各种任务，如构建，测试和部署软件。Jenkins可以通过本机系统包Docker安装，甚至可以通过安装Java Runtime Environment的任何机器独立运行。

## JavaEE项目部署方式对比

1.手动部署
![持续集成工具Jenkins的使用-2018918181039](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018918181039.jpg)

2.自动化部署
“自动化”的具体体现：向版本库提交新的代码后，应用服务器上自动部署，用户或测试人员使用的马上就是最新的应用程序。
![持续集成工具Jenkins的使用-2018918181125](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018918181125.jpg)
搭建上述持续集成环境可以把整个构建、部署过程自动化，很大程度上减轻工作量。对于程序员的日常开发来说不会造成任何额外负担——自己把代码提交上去之后，服务器上运行的马上就是最新版本——一切都发生在无形中。

## 实战

下面我们就通过Jenkins+GitLab+Maven+Tomcat实现自动集成、打包、部署。
![持续集成工具Jenkins的使用-201892017056](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892017056.png)

### GitLab环境搭建

搭建设备：GitLab
GitLab的搭建，这里就不在敖述，步骤可见博客[Gitlab快速搭建和使用](https://liubin.fun/2018/Gitlab%E5%BF%AB%E9%80%9F%E6%90%AD%E5%BB%BA/)。

1.初始化项目
![持续集成工具Jenkins的使用-201892017943](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892017943.png)

这里提供一个可以用maven构建的Java项目：[点击下载](http://p8d1sg7ey.bkt.clouddn.com/hello.zip)

2.添加本地client端的ssh keys
![持续集成工具Jenkins的使用-2018920171623](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920171623.png)

3.在项目目录下初始化git仓库并上传到gitlab

    1
    2
    3
    4
    5
    6
    

    cd hello
    git init
    git remote add origin git@gitlab.example.com:root/hello.git
    git add .
    git commit -m "Initial commit"
    git push -u origin master
    

![持续集成工具Jenkins的使用-2018920171928](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920171928.png)

### Maven安装

安装设备:Jenkins
1.安装JDK

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    

    tar xf jdk-8u121-linux-x64.tar.gz -C  /usr/local/
    vim /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/local/jdk1.8.0_121
    export PATH=$JAVA_HOME/bin:$PATH
    
    source /etc/prfile.d/jdk.sh
    
    # 查看版本
    [root@jenkins local]# java -version
    java version "1.8.0_121"
    Java(TM) SE Runtime Environment (build 1.8.0_121-b13)
    Java HotSpot(TM) 64-Bit Server VM (build 25.121-b13, mixed mode)
    

2.安装maven

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    

    wget http://mirrors.shu.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
    tar xf apache-maven-3.5.4-bin.tar.gz -C /usr/local/
    cd /usr/local
    ln -s apache-maven-3.5.4  maven
    
    vim /etc/profile.d/maven.sh
    export MAVEN_HOME=/usr/local/maven
    export PATH=$MAVEN_HOME/bin:$PATH
    
    source /etc/profile.d/maven.sh
    
    # 查看版本
    [root@jenkins local]# mvn -version
    Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-18T02:33:14+08:00)
    Maven home: /usr/local/maven
    Java version: 1.8.0_121, vendor: Oracle Corporation, runtime: /usr/local/jdk1.8.0_121/jre
    Default locale: en_US, platform encoding: UTF-8
    OS name: "linux", version: "3.10.0-862.el7.x86_64", arch: "amd64", family: "unix"
    

### 部署Jenkins

部署设备:Jenkins
这里使用Jenkins的var包来实现
1.安装tomcat

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    

    yum install tomcat
    
    # 修改JAVA_HOME
    vim /etc/tomcat/tomcat.conf
    JAVA_HOME="/usr/local/jdk1.8.0_121/jre"
    
    # 修改URI编码
    vim /etc/tomcat/server.xml
    <Connector port="8080" protocol="HTTP/1.1"
                connectionTimeout="20000"
                redirectPort="8443" URIEncoding="UTF-8"/>
    

2.将jenkins.war放在webapps下面

    1
    2
    3
    4
    

    [root@jenkins webapps]# pwd
    /usr/share/tomcat/webapps
    [root@jenkins webapps]# ls
    examples  host-manager  jenkins.war  manager  ROOT  sample
    

3.启动tomcat

4.解锁jenkins
![持续集成工具Jenkins的使用-201892019051](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892019051.png)

5.安装插件
![持续集成工具Jenkins的使用-201892019220](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892019220.png)
![持续集成工具Jenkins的使用-201892019315](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892019315.png)

![持续集成工具Jenkins的使用-2018920191946](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920191946.png)

然后继续就行了。

主页面：
![持续集成工具Jenkins的使用-2018920192155](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920192155.png)

### web服务器部署tomcat

部署tomcat，提供http服务。
1.安装JDK

    1
    2
    3
    4
    5
    6
    

    tar xf jdk-8u121-linux-x64.tar.gz -C  /usr/local/
    vim /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/local/jdk1.8.0_121
    export PATH=$JAVA_HOME/bin:$PATH
    
    source /etc/prfile.d/jdk.sh
    

2.安装tomcat

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    

    yum install tomcat-admin-webapps -y
    
    # 修改JAVA_HOME
    vim /etc/tomcat/tomcat.conf
    JAVA_HOME="/usr/local/jdk1.8.0_121/jre"
    
    # 添加账号
    vim /etc/tomcat/tomcat-users.xml
    <role rolename="manager-gui"/> 
    <role rolename="manager-script"/> 
    <role rolename="manager-jmx"/>
    <role rolename="manager-status"/>
    <user name="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status" />
    

3.启动服务

### 安装插件

![持续集成工具Jenkins的使用-2018920192919](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920192919.png)

1.安装Deploy to containe
![持续集成工具Jenkins的使用-2018920193044](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920193044.png)

### Jenkins配置

#### Configure Global Security

![持续集成工具Jenkins的使用-2018920193559](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920193559.png)

#### Global Tool Configuration

1.配置Maven的Configuration
![持续集成工具Jenkins的使用-2018920193816](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920193816.png)

2.配置JDK
![持续集成工具Jenkins的使用-201892019401](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892019401.png)

3.配置git
如果没有git，可以使用yum安装
![持续集成工具Jenkins的使用-201892019411](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892019411.png)

4.配置Maven
![持续集成工具Jenkins的使用-201892019430](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892019430.png)

### 新建jobs

1.新建
![持续集成工具Jenkins的使用-2018920194349](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920194349.png)
![持续集成工具Jenkins的使用-2018920194427](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920194427.png)

### 配置jobs

1.配置描述信息
![持续集成工具Jenkins的使用-2018920194521](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920194521.png)

这里需要将在Jenkins主机上生成公私钥，将公钥添加到gitlab的ssh keys
2.生成公私钥

    1
    2
    3
    4
    5
    

    [root@jenkins ~]# ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (/root/.ssh/id_rsa): 
    /root/.ssh/id_rsa already exists.
    Overwrite (y/n)?
    

3.将公钥写入gitlab的SSK keys
![持续集成工具Jenkins的使用-2018920195039](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920195039.png)

4.源码管理
![持续集成工具Jenkins的使用-2018920195551](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920195551.png)
![持续集成工具Jenkins的使用-2018920195556](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920195556.png)

5.触发构建
![持续集成工具Jenkins的使用-2018920195743](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920195743.png)

记下URL为`http://192.168.31.57:8080/jenkins/job/hello/build?token=123456`

6.构建
![持续集成工具Jenkins的使用-2018920195932](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920195932.png)
![持续集成工具Jenkins的使用-201892020056](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892020056.png)

7.构建之后的动作
构建完成之后，需要将var包直接上传到webserver上。
![持续集成工具Jenkins的使用-201892020246](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892020246.png)
![持续集成工具Jenkins的使用-201892020752](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892020752.png)
![持续集成工具Jenkins的使用-20189202071](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-20189202071.png)

8.手动构建
![持续集成工具Jenkins的使用-2018920202349](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920202349.png)

然后就可以在webserver的webapps看到刚刚构建完成的应用

    1
    2
    3
    

    [root@webserver ~]# cd /usr/share/tomcat/webapps/
    [root@webserver webapps]# ls
    hello  hello.war  host-manager  manager
    

可以通过浏览器访问:
![持续集成工具Jenkins的使用-201892020263](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-201892020263.png)

### 配置Webhooks

配置Webhooks，可以实现，当开发人员push代码到仓库的时候，可以实现自动打包部署。
在gitlab上配置：
![持续集成工具Jenkins的使用-2018920202920](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920202920.png)

如果报以下错误：
![持续集成工具Jenkins的使用-2018920203044](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920203044.png)

可以设置：
![持续集成工具Jenkins的使用-2018920203132](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920203132.png)

再次设置Webhooks即可。

### 测试

修改项目代码并push到仓库。

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    

    liubi@DESKTOP-N9CPG7D ~/Desktop/hello$ vim  src/main/java/controller/helloController.java
          write.write("hello world!");
    
    liubi@DESKTOP-N9CPG7D ~/Desktop/hello$ git add .
    
    liubi@DESKTOP-N9CPG7D ~/Desktop/hello$ git commit -m "2th commit"
    [master 84c1666] 2th commit
     1 file changed, 1 insertion(+), 1 deletion(-)
    
    liubi@DESKTOP-N9CPG7D ~/Desktop/hello$ git push origin master
    Counting objects: 7, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (7/7), 516 bytes | 516.00 KiB/s, done.
    Total 7 (delta 1), reused 0 (delta 0)
    To gitlab.example.com:root/hello.git
       55912ee..84c1666  master -> master
    

可以看到触发了自动打包部署：
![持续集成工具Jenkins的使用-2018920203648](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920203648.png)

在浏览器查看是否部署成功：
![持续集成工具Jenkins的使用-2018920203719](http://p8d1sg7ey.bkt.clouddn.com/持续集成工具Jenkins的使用-2018920203719.png)

以上。
{% endraw %}
