---
layout: post
title:  "一步步带你构建Spring Boot + Docker的单体应用"
title2:  "一步步带你构建Spring Boot + Docker的单体应用"
date:   2017-01-01 23:58:03  +0800
source:  "https://www.jfox.info/%e4%b8%80%e6%ad%a5%e6%ad%a5%e5%b8%a6%e4%bd%a0%e6%9e%84%e5%bb%baspringbootdocker%e7%9a%84%e5%8d%95%e4%bd%93%e5%ba%94%e7%94%a8.html"
fileName:  "20170101383"
lang:  "zh_CN"
published: true
permalink: "2017/%e4%b8%80%e6%ad%a5%e6%ad%a5%e5%b8%a6%e4%bd%a0%e6%9e%84%e5%bb%baspringbootdocker%e7%9a%84%e5%8d%95%e4%bd%93%e5%ba%94%e7%94%a8.html"
---
{% raw %}
今天10:04

![](/wp-content/uploads/2017/07/1500908009.png)

## 前置知识

 Spring Boot 

Spring Boot 是 Spring 社区发布的一个开源项目，旨在帮助开发者快速简单地构建可独立运行的项目。Spring Boot 会选择最适合的 Spring 子项目和第三方开源库进行整合。大部分 Spring Boot 应用只需要非常少的配置就可以快速运行起来。

 Docker 

Docker 是一套以容器技术为核心的，用于应用的构建、分发和执行的体系和生态。

 单体应用 

单体应用（monolith application）就是将应用程序的所有功能都打包成一个独立的单元，可以是JAR、WAR、EAR或其它归档格式。

 网易云基础服务 

由网易公司推出的专业的容器云平台，深度整合了 IaaS、PaaS 及容器技术，提供弹性计算、DevOps 工具链及微服务基础设施等服务，帮助企业解决 IT、架构及运维等问题，使企业更聚焦于业务，是新一代的云计算平台。官网地址：https://c.163yun.com

## 前置条件

○ 操作系统：64位，系统不限（需支持Docker），Windows 上建议安装 Git 客户端，方便支持 Linux 命令行操作

○ JDK 1.8 + ：推荐一款 Java 环境管理工具 jenv

○ Maven 3.0 +

○ Docker: Linux安装教程参考：https://docs.docker.com/engine/installation/linux/,如果你使用的是Mac或Windows，官方已有原生应用支持，下载地址：https://docs.docker.com/

○ Git及Github：文中源码通过 Git 做版本管理，并托管在 Github：https://github.com/163yun/spring-boot-docker-cloudcomb

○ 15分钟空挡时间（在以上环境准备好的情况下）

完成上述知识和环境的准备工作之后，我们就可以开始了。

## 第一步：新建工程目录

新建一个文件夹，名字就以你的项目名命名，这里以 spring-boot-docker-cloudcomb 为例。

    mkdir spring-boot-docker-cloudcomb

在根目录下创建pom.xml文件

    touch pom.xml

在当前目录下新建子目录

    mkdir -p src/main/java/com/bingohuang/hello

一个典型的Maven项目结构如下：

    spring-boot-docker-cloudcomb
     ├── pom.xml
     └── src
        └── main
            └── java
                └── com
                    └── bingohuang
                        └── hello

## 第二步：配置pom文件

在 pom.xml 中添加内容如下： 

    <?xml version="1.0" encoding="UTF-8"?>
    <**project** xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"         
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <**modelVersion**>4.0.0<**/modelVersion**>
    
    <**groupId**>bingohuang.com<**/groupId**>
    <**artifactId**>spring-boot-docker-cloudcomb<**/artifactId**>
    <**version**>0.1.0<**/version**>
    <**packaging**>jar<**/packaging**>
    <**name**>Spring Boot + Docker + Cloudcomb<**/name**>
    <**description**>一步步带你构建 Spring Boot + Docker 应用及网易云基础服务务</description>
    
    <**parent**>
        <**groupId**>org.springframework.boot<**/groupId**>
        <**artifactId**>spring-boot-starter-parent<**/artifactId**>
        <**version**>1.3.3.RELEASE<**/version**>
        <**relativePath/**>
    <**/parent**>
    
    <**properties**>
        <**java.version**>1.8<**/java.version**>
    <**/properties**>
    
    <**dependencies**>
      <**dependency**>
       <**groupId**>org.springframework.boot<**/groupId**>
       <**artifactId**>spring-boot-starter-web<**/artifactId**>
      <**/dependency**>
      <**dependency**>
       <**groupId**>org.springframework.boot<**/groupId**>
       <**artifactId**>spring-boot-starter-test<**/artifactId**>
       <**scope**>test<**/scope**>
      <**/dependency**>
    <**/dependencies**>
    
    <**build**>
         <**plugins**>
           <**plugin**>
            <**groupId**>org.springframework.boot<**/groupId**>
            <**artifactId**>spring-boot-maven-plugin<**/artifactId**>
          <**/plugin**>
         <**/plugins**>
    <**/build**>
    
    <**/project**>

以上 pom 文件并不复杂，是一个 Spring Boot 的标准配置，Spring Boot 的 Maven 插件会提供以下功能：

○ 收集类路径上所有 jar 文件，并构建成一个单一的、可运行的 jar 文件，这使得它更方便地执行和传输服务。

○ 搜索 public static void main() 方法来标记为可运行的类。

○ 提供了一个内置的依赖解析器，用于设置版本号以匹配 Spring Boot 的依赖。你可以覆盖任何你想要的版本，但它会默认使用Spring Boot 所设置的版本集。

## 第三步：编写Spring Boot应用

创建一个简单的Java应用程序 

    touch src/main/java/com/bingohuang/hello/Application.java
    **package** com.bingohuang.hello;
    **import **org.springframework.boot.SpringApplication;
    **import** org.springframework.boot.autoconfigure.SpringBootApplication;
    **import** org.springframework.web.bind.annotation.RequestMapping;
    **import **org.springframework.web.bind.annotation.RestController;
    /**
    * Sprint Boot 主应用入口
    * @author <a href="http://bingohuang.com">bingohuang.com</a>
    * @date 2016.11.15
    */
    @SpringBootApplication
    @RestController
    **public class** Application {
    @RequestMapping("/")
    **public** String home() {
    **return** "Hello Spring Boot, Docker and CloudComb!";
       }
    **public static void** main(String[] args) {
    SpringApplication.run(Application.class, args);
       }
    }

代码核心就是处理了根路径（/）的 web 请求，并包含可执行的 main 方法，比较好理解，解释一下其中几个关键点：

○ 用 @SpringBootApplication 和 @RestController 注解类, 表示可用 Spring MVC 来处理 Web 请求

○ @RequestMapping 将 / 映射到 home() 方法，并返回相应文本

○ main() 方法使用 Spring Boot 的 SpringApplication.run() 方法来启动应用

## 第四步：本地运行程序

### Maven构建

该应用的核心代码就已完成，也就两个文件，可见Spring Boot非常简单，目录结构如下： 

    spring-boot-docker-cloudcomb
     ├── pom.xml
     └── src
        └── main
            └── java
                └── com
                    └── binghuang
                        └── hello
                            └── Application.java

在根目录执行：

    mvn package

之后会在根目录下生成一个targrt目录，并在target目录下包含一个可执行的jar包。 

### 运行jar包

Spring Boot的强大之处是将应用打包成一个可独立运行的jar文件： 

    java -jar target/spring-boot-docker-cloudcomb-0.1.0.jar

不出意外，输出日志，应用启动，默认会监听8080端口。

    .   ____          _            __ _ _ 
     /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
     ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \ 
     \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
      '  |____| .__|_| |_|_| |_\__, | / / / / =========|_|==============|___/=/_/_/_/
     :: Spring Boot ::        (v1.3.3.RELEASE) 
    
    2016-11-15 22:21:26.789  INFO 91932 --- [           main] hello.Application                        : Starting Application 
    v0.1.0 on BingoHuang.local with PID 91932 (/Users/bingo/Git/springboot/spring-boot-docker-
    cloudcomb/target/spring-boot-docker-cloudcomb-0.1.0.jar started by bingo in /Users/bingo/Git/springboot/spring-
    boot-docker-cloudcomb)

### 访问应用

应用正常启动后，浏览器访问http://127.0.0.1:8080/，即可看到页面输出字样 

    Hello Spring Boot, Docker and CloudComb!

## 第五步：容器化构建及运行

### 书写Dockerfile

在项目根目录下创建一个Dockerfile文件，内容如下： 

    touch Dockerfile
    FROM hub.c.163.com/bingohuang/jdk8:latest 
    MAINTAINER Bingo Huang <me@bingohuang.com> 
    COPY target/spring-boot-docker-cloudcomb-0.1.0.jar app.jar 
    ENTRYPOINT ["java","-jar","/app.jar"]

此 Dockerfile 并不复杂，核心功能就是将可执行文件拷贝到镜像中，并在容器启动时默认执行启动命令 java -jar /app.jar

此时项目所有源文件编写完成，共三个文件，目录结构如下：

    spring-boot-docker-cloudcomb
     ├── Dockerfile
     ├── pom.xml
     └── src
        └── main
            └── java
                └── com
                    └── bingohuang
                        └── hello
                            └── Application.java

### Docker构建

在项目根目录下执行docker构建镜像命令： 

    docker build -t spring-boot-docker-cloudcomb:0.1.0 .

详情请查看docker build命令详解。

### Docker运行

运行docker容器

    docker run -p 8080:8080 -t spring-boot-docker-cloudcomb:0.1.0

详情请查看docker run命令详解 

### 访问项目

同样，会输出日志（略有不同），监听8080端口，浏览器访问http://127.0.0.1:8080/，输出文本。 

    .   ____          _            __ _ _
     /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
     ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
     \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
      '  |____| .__|_| |_|_| |_\__, | / / / / =========|_|==============|___/=/_/_/_/
     :: Spring Boot ::        (v1.3.3.RELEASE)
    
     2016-11-15 14:18:54.889  INFO 1 --- [           main] hello.Application                        : Starting Application 
    v0.1.0 on 509da1aefb69 with PID 1 (/app.jar started by root in /)
    Hello Spring Boot, Docker and CloudComb!

## 第六步：推送镜像到网易云基础服务

首先，需要有一个网易云基础服务的账号，可在网易云基础服务首页注册。

接下里，在命令行中登录网易云基础服务镜像仓库：]

    docker login hub.c.163.com
    Username (me@bingohuang.com): me@bingohuang.com
    Password:
    Login Succeeded

接着，统一标记本地镜像：

    docker tag spring-boot-docker-cloudcomb:0.1.0  hub.c.163.com/bingohuang/spring-boot-docker-cloudcomb:0.1.0

最后，推送镜像到网易云基础服务镜像仓库：

    docker push hub.c.163.com/bingohuang/spring-boot-docker-cloudcomb:0.1.0

## 第七步：在网易云基础服务上创建服务

打开网易云基础服务控制台（http://c.163yun.com/dashboard），点击左侧菜单栏服务管理，可以使用默认空间，点击创建服务：
![](/wp-content/uploads/2017/07/1500908011.png)
创建服务总共分三步，可进可退。

第一步：设置服务名，服务状态，公网 IP 及计费模式设置，再点击下一步：
![](/wp-content/uploads/2017/07/15009080111.png)
第二步：选择镜像，设置容器名称即可，SSH秘钥用于远程登录，对于一个服务来说，可以不选，点击下一步：
![](/wp-content/uploads/2017/07/1500908012.png)
第三步：选择规格，默认SSD云硬盘，配置容器到服务的端口映射（对有状态的服务，对外暴露的端口默认还是容器端口），副本数限制为1，不到 5 分钱一个小时，非常实惠，立即创建：
![](/wp-content/uploads/2017/07/1500908013.png)
不到一分钟，服务创建成功：
![](/wp-content/uploads/2017/07/1500908014.png)
再点击详细信息，查看基本信息中的公网IP，此服务是：59.111.114.43
![](/wp-content/uploads/2017/07/1500908015.png)
打开浏览器，访问服务：http://59.111.114.43:8080/，发现同样输出了：
![](/wp-content/uploads/2017/07/15009080151.png)
注：此镜像我已经在网易云基础服务上公开，地址是：https://c.163.com/hub#/m/repository/?repoId=41359 （你也可以直接在网易云基础服务镜像中心搜索：spring-boot-docker-cloudcomb），打开收藏，即可直接基于该镜像创建 Spring Boot + Docker 的应用服务。

至此，一个基于 Spring Boot 和 Docker 的应用就构建完成，并演示了如何在网易云基础服务上快速创建该应用的在线服务，希望对你有所帮助。
{% endraw %}
