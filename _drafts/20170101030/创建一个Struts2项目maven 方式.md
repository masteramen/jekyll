---
layout: post
title:  "创建一个Struts2项目maven 方式"
title2:  "创建一个Struts2项目maven 方式"
date:   2017-01-01 23:52:10  +0800
source:  "https://www.jfox.info/%e5%88%9b%e5%bb%ba%e4%b8%80%e4%b8%aastruts2%e9%a1%b9%e7%9b%aemaven-%e6%96%b9%e5%bc%8f.html"
fileName:  "20170101030"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%88%9b%e5%bb%ba%e4%b8%80%e4%b8%aastruts2%e9%a1%b9%e7%9b%aemaven-%e6%96%b9%e5%bc%8f.html"
---
{% raw %}
选择Artifact Id ：maven-archetype-webapp 那一项

GroupID是项目组织唯一的标识符，实际对应JAVA的包的结构，是main目录里java的目录结构。

ArtifactID就是项目的唯一的标识符，实际对应项目的名称，就是项目根目录的名称。 一般GroupID就是填com.leafive.test这样子。

1. 
在pom中加入sturts2依赖

添加struts2依赖到的pom.xml 此处使用的是 版本是3.8.1，保存文件后 maven 会自动下载依赖的相关包

pom.xml内容：

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>com.str2</groupId>
        <artifactId>struts</artifactId>
        <packaging>war</packaging>
        <version>0.0.1-SNAPSHOT</version>
        <name>struts Maven Webapp</name>
        <url>http://maven.apache.org</url>
        <dependencies>
            <dependency>
                <groupId>junit</groupId>
                <artifactId>junit</artifactId>
                <version>3.8.1</version>
                <scope>test</scope>
            </dependency>
            <dependency>
                <groupId>org.apache.struts</groupId>
                <artifactId>struts2-core</artifactId>
                <version>2.3.8</version>
            </dependency>
    
            <dependency>
                <groupId>javassist</groupId>
                <artifactId>javassist</artifactId>
                <version>3.12.1.GA</version>
            </dependency>
        </dependencies>
        <build>
            <finalName>struts</finalName>
        </build>
    </project>
    

3.在src/main下创建 文件结构：java/action/user.java

userAction.java 内容

    package com.struts.action;
    
    public class UserAction   {
        private String name;
        private String password;
        
        
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        
        public String getPassword() {
            return password;
        }
        public void setPassword(String password) {
            this.password = password;
        }
        public String execute() {
            return "success";
        }
        public String user_login_go() {
            return "success";
        }
        public String login_go() {
            return "success";
        }
        public String user_login() {
            return "success";
        }
        public String login() {
            return "success";
        }
    }
    

1. 
在resource包下 创建struts2文件

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE struts PUBLIC  
        "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"  
        "http://struts.apache.org/dtds/struts-2.0.dtd">  
    <struts>
        <package name="user" namespace="/"  extends="struts-default">
            <action name="user_login_go" class="com.struts.action.UserAction" method="user_login">
                <result name="success">/login.jsp</result>
            </action>
            <action name="login_go" class="com.struts.action.UserAction" method="login">
                <result name="success">/welcome.jsp</result>
            </action>
        </package>
    </struts>

1. 
配置 src/main/webapp/WEB-INF/web.xml

web.xml 内容

    <!DOCTYPE web-app PUBLIC
     "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
     "http://java.sun.com/dtd/web-app_2_3.dtd" >
    
    <web-app>
      <display-name>Archetype Created Web Application</display-name>
      <filter>
      <filter-name>struts2</filter-name>
          <filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
          
      </filter>
      <filter-mapping>
          <filter-name>struts2</filter-name>
          <url-pattern>/*</url-pattern>
      </filter-mapping>
    </web-app>
    

1. 
在 src/main/webapp/WEB-INF/ 下创建一个空的文件夹 classes

2. 
在 src/main/webapp/ 创建文件inde.jsp

index.jsp

    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <body>
        <h2>Struts2-Demo</h2>
        <a href="user_login_go">去登录界面</a>
    </body>
    </html>

1. 
在 src/main/webapp/创建文件 login.jsp

login.jsp

    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>struts2-Demo-登录界面</title>
    </head>
    <body>
        <p>struts2-Demo-登录界面</p>
        <form action="login_go" method="post">
            name:<input type="text" name="name" />
            password<input type="password" name="password" />
            <input type="submit" value="登录" />
        </form>
    </body>
    </html>

1. 
在 src/main/webapp/ 创建文件 welcome.jsp

welcome.jsp

    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib prefix="s" uri="/struts-tags" %>
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Struts2-Demo-欢迎页面</title>
    </head>
    <body>
        Welcome:
        <br>
        <h1>name=<s:property value="name" /></h1>
        <h1>password=<s:property value="password" /></h1>    
        <h1>重新登录</h1>
        <s:form action="login_go" namespace="/" method="post">
            <s:textfield name="name" label="name"></s:textfield>  
            <s:password name="password" label="password"></s:password>  
                  
            <s:submit value="Login"></s:submit>
        </s:form>
    </body>
    </html>

1. 
在项目上右键 Build path> configure Build path 配置项目相关 变量

source 选择编译的目录 我们选择 java 和resources 这两个目录

Libraries 添加

jre7：Add Librars> Jre System library

Tomcat7 ：Add Librars> Server Runtime> Apache Tomcat V7.0 前提你的eclipse已经配置了Tomcat

1. 
在项目上右键 run as> run on serve 选择Tomcat7 启动Tomcat 在浏览器访问：localhost:8080/struts2/

1. 
出现错误的原因：

1. 
tomcat 是否配置成功

2. 
创建 java目录 和classes 目录的路径是否正确

3. 
tomcat 访问路径是否正确

4. 
pom.xml 配置后是否自动下载了struts2的包
{% endraw %}
