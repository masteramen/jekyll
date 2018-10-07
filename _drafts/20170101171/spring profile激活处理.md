---
layout: post
title:  "spring profile激活处理"
title2:  "spring profile激活处理"
date:   2017-01-01 23:54:31  +0800
source:  "http://www.jfox.info/springprofile%e6%bf%80%e6%b4%bb%e5%a4%84%e7%90%86.html"
fileName:  "20170101171"
lang:  "zh_CN"
published: true
permalink: "springprofile%e6%bf%80%e6%b4%bb%e5%a4%84%e7%90%86.html"
---
{% raw %}
项目开发一共有三个环境：测试环境，灰度环境和生产环境，比如我们想在测试环境下，不加载某些配置信息，可以通过profile来实现

## 2.激活profile实现方式

1. 
JVM增加参数spring.profiles.active设置

2. 
在ServletContextListener 中初始化属性spring.profiles.active

## 3. JVM增加参数spring.profiles.active设置

在JVM中增加参数spring.profiles.active设置，如果我们想设置spring.profiles.active为dev，使用Dspring.profiles.active=”dev” 。

此种方式需要修改tomcat的JVM配置，通用性不高。

## 4. 在ServletContextListener 中初始化spring.profiles.active

写一个类InitConfigListener实现接口ServletContextListener，重写容器初始化方法contextInitialized(),设置属性为spring.profiles.active为指定值environment。environment可以定义在一个属性文件中，在使用maven构建时使用测试，灰度或者生产环境的属性文件。在contextInitialized方法中读取指定属性文件，获取environment 值，通过setProperty即可实现。

    @WebListener
    public class InitConfigListener implements ServletContextListener {
        @Override
        public void contextInitialized(ServletContextEvent sce) {
            String environment = "";
            //加载Properties属性文件获取environment值 
            //侦测jvm环境，并缓存到全局变量中
            String env = System.setProperty("spring.profiles.active",environment);
        }
        @Override
        public void contextDestroyed(ServletContextEvent sce) {
        }
    }
    

spring.xml配置只在dev模式下加载配置文件spring-mybatis.xml

    <beans profile="dev">
        <import resource="spring-mybatis.xml" /> 
    </beans>

springboot使用注解@Profile和@Configuration来配置，@ActiveProfiles()在测试时切换环境

大家可以关注我的公众号：不知风在何处，相互沟通，共同进步。
{% endraw %}
