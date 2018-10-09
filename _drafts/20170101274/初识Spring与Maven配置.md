---
layout: post
title:  "初识Spring与Maven配置"
title2:  "初识Spring与Maven配置"
date:   2017-01-01 23:56:14  +0800
source:  "https://www.jfox.info/%e5%88%9d%e8%af%86spring%e4%b8%8emaven%e9%85%8d%e7%bd%ae.html"
fileName:  "20170101274"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%88%9d%e8%af%86spring%e4%b8%8emaven%e9%85%8d%e7%bd%ae.html"
---
{% raw %}
# 初识Spring与Maven配置 


作者[icecrea](/u/3019468982a9)2017.07.01 15:33*字数 471
# 配置maven

下载settings.xml

    <?xml version="1.0" encoding="UTF-8"?>
    
    <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    
        <localRepository>E:/maven</localRepository>
        <pluginGroups>
        </pluginGroups>
    
        <proxies>
        </proxies>
    
        <servers>
        </servers>
    
        <mirrors>
            <mirror>
                <id>nexus</id>
                <name>Tedu Maven</name>
                <mirrorOf>*</mirrorOf>
                <url>http://maven.aliyun.com/nexus/content/groups/public</url>
                <!-- <url>http://maven.aliyun.com/content/groups/public</url> -->
            </mirror>
        </mirrors>
        <profiles>
    
        </profiles>
        <activeProfiles>
        </activeProfiles>
    
    
    
    </settings>

 注意镜像地址`http://maven.aliyun.com/nexus/content/groups/public`配置eclipseeclipse-window-preference-maven-usersettingsGlobal Settings设置setting.xml文件路径

在阿里云查找需要的包 我们此处用到commons-code

新建Maven项目 复制上图右侧xml文档 添加到pom.xml里 放到<dependencies>标签里 

自动安装需要的jar包成功

maven可能下载失败 关闭eclipse删除包 右击项目maven updateProject 勾选force update 强制更新变可成功

#### 摘要：用于检验完整性的技术

#### 数据一样摘要一定一样，摘要一样数据一定一样

测试：通过刚才导入的commons-code包里的DigestUtils方法 查看其摘要 可以进行判断是否下载成功 是否完整等

迅雷就是通过摘要自动比较，如果摘要（md5）不同 自动提示下载失败 重新下载

#### 配置Spring

搜索spring-webmvc 找到3.2.8版本 复制xml文档添加到pom.xml文档里

spring-service.xml文件如下 配置到src/main/resources文件夹下

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:context="http://www.springframework.org/schema/context" 
        xmlns:jdbc="http://www.springframework.org/schema/jdbc"  
        xmlns:jee="http://www.springframework.org/schema/jee" 
        xmlns:tx="http://www.springframework.org/schema/tx"
        xmlns:aop="http://www.springframework.org/schema/aop" 
        xmlns:mvc="http://www.springframework.org/schema/mvc"
        xmlns:util="http://www.springframework.org/schema/util"
        xmlns:jpa="http://www.springframework.org/schema/data/jpa"
        xsi:schemaLocation="
            http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
            http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.2.xsd
            http://www.springframework.org/schema/jdbc http://www.springframework.org/schema/jdbc/spring-jdbc-3.2.xsd
            http://www.springframework.org/schema/jee http://www.springframework.org/schema/jee/spring-jee-3.2.xsd
            http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-3.2.xsd
            http://www.springframework.org/schema/data/jpa http://www.springframework.org/schema/data/jpa/spring-jpa-1.3.xsd
            http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-3.2.xsd
            http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd
            http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util-3.2.xsd">
    
    
    
    </beans>

在spring-service.xml里添加组件 可以通过spring容器直接获取

<bean id=”date” class=”java.util.Date”></bean> 

考虑到数量的问题 可以通过组件扫描方法更方便 不用一个个添加在spring-service.xml文档里添加`<context:component-scan base-package="com.example"></context:component-scan>`自动扫描有@Component注释的包 自动创建bean组件

如果有@Autowired注释 会将该对象直接注入到变量中

新建servlet 选择已存在的servlet

url mappings设置为*.do

更改web.xml信息 设置servlet的init-param

    <servlet>
        <description></description>
        <display-name>DispatcherServlet</display-name>
        <servlet-name>DispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
          <init-param>
              <param-name>contextConfigLocation</param-name>
              <param-value>classpath:spring-service.xml</param-value>
          </init-param>
          <load-on-startup>1</load-on-startup>
      </servlet>
      <servlet-mapping>
        <servlet-name>DispatcherServlet</servlet-name>
        <url-pattern>*.do</url-pattern>
      </servlet-mapping>

重启 查看后台信息 显示初始化完成

在spring-service.xml里添加如下

        <!-- 启动注解版本的Spring MVC -->
        <mvc:annotation-driven></mvc:annotation-driven>
        <context:component-scan base-package="com.sdu.wh"></context:component-scan>

新建DemoController类此时用到注解@RequestMapping(“/xxx”)映射类路径 方法路径 简单的注解就可以实现功能

    package com.sdu.wh;
    
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.ResponseBody;
    
    @Controller //自动的在Spring容器中创建Bean对象，Bean ID demoController 与Component完全一样 
    //语义上Controller更符合
    @RequestMapping("/test")//映射URL路径 /demo
    public class DemoController {
    
        @RequestMapping("/hello")//映射URL路径 /hello 映射的完整路径：http://localhost:8080/Spring1/test/hello.do
        @ResponseBody //自动处理返回值，将字符串送到浏览器 
        public String hello(){
            return "HelloWorld";
        }
    }
{% endraw %}
