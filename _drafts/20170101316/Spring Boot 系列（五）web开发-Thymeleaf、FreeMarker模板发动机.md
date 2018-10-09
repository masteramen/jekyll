---
layout: post
title:  "Spring Boot 系列（五）web开发-Thymeleaf、FreeMarker模板发动机"
title2:  "Spring Boot 系列（五）web开发-Thymeleaf、FreeMarker模板发动机"
date:   2017-01-01 23:56:56  +0800
source:  "https://www.jfox.info/springboot%e7%b3%bb%e5%88%97%e4%ba%94web%e5%bc%80%e5%8f%91thymeleaffreemarker%e6%a8%a1%e6%9d%bf%e5%8f%91%e5%8a%a8%e6%9c%ba-2.html"
fileName:  "20170101316"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springboot%e7%b3%bb%e5%88%97%e4%ba%94web%e5%bc%80%e5%8f%91thymeleaffreemarker%e6%a8%a1%e6%9d%bf%e5%8f%91%e5%8a%a8%e6%9c%ba-2.html"
---
{% raw %}
# Spring Boot 系列（五）web开发-Thymeleaf、FreeMarker模板发动机 


#### 前面几篇介绍了返回json数据提供良好的RESTful api，下面我们介绍如何把处理完的数据渲染到页面上。

# Spring Boot 使用模板发动机

Spring Boot 推荐使用Thymeleaf、FreeMarker、Velocity、Groovy、Mustache等模板发动机。不建议使用JSP。

#### Spring Boot 对以上几种发动机提供了良好的默认配置，默认 src/main/resources/templates 目录为以上模板发动机的配置路径。

### 一、Spring Boot 中使用Thymeleaf模板发动机

简介：Thymeleaf 是类似于Velocity、FreeMarker 的模板发动机，可用于Web与非Web环境中的应用开发，并且可以完全替代JSP 。

#### 1、pom.xml 添加依赖

    <!-- thymeleaf 模板发动机-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>

#### 2、编写controller

    /**
     * @author sam
     * @since 2017/7/16
     */
    @Controller
    public class HomeController {
    
        @RequestMapping("/home")
        public String home(ModelMap modelMap) {
    
            modelMap.put("name", "Magical Sam");
    
            List<String> list = new ArrayList<>();
            list.add("sam a");
            list.add("sam b");
            list.add("sam c");
            list.add("sam d");
            modelMap.put("list", list);
    
            return "home";
        }
    
    }
    

#### 3、编写html代码，其中th:text=”${name}” 为thymeleaf的语法，具体可参考：[Thymeleaf 官方文档](https://www.jfox.info/go.php?url=http://www.thymeleaf.org/doc/articles/standarddialect5minutes.html)

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org">
    <head>
        <meta charset="UTF-8"/>
        <title>Home</title>
    </head>
    <body>
        <span th:text="${name}"></span>
        <ul>
            <li th:each="item : ${list}" th:text="${item}"></li>
        </ul>
    </body>
    </html>

#### 如需修改 thymeleaf 的默认配置，可以在application.properties中添加：

    # ================================================
    #                   Thymeleaf配置
    # ================================================
    # 是否启用thymeleaf模板解析
    spring.thymeleaf.enabled=true
    # 是否开启模板缓存（建议：开发环境下设置为false，生产环境设置为true）
    spring.thymeleaf.cache=false 
    # Check that the templates location exists.
    spring.thymeleaf.check-template-location=true 
    # 模板的媒体类型设置，默认为text/html
    spring.thymeleaf.content-type=text/html
    # 模板的编码设置，默认UTF-8
    spring.thymeleaf.encoding=UTF-8
    # 设置可以被解析的视图，以逗号,分隔
    #spring.thymeleaf.view-names=
    # 排除不需要被解析视图，以逗号,分隔
    #spring.thymeleaf.excluded-view-names=
    # 模板模式设置，默认为HTML5
    #spring.thymeleaf.mode=HTML5 
    # 前缀设置，SpringBoot默认模板放置在classpath:/template/目录下
    spring.thymeleaf.prefix=classpath:/templates/ 
    # 后缀设置，默认为.html
    spring.thymeleaf.suffix=.html
    # 模板在模板链中被解析的顺序
    #spring.thymeleaf.template-resolver-order=

### 二、Spring Boot 中使用FreeMarker模板发动机

#### 1、pom.xml 添加依赖

    <!-- freemarker 模板发动机 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-freemarker</artifactId>
    </dependency>

#### 2、编写controller

    同上。

#### 3、templates 下新建 home.ftl文件编写html代码，freemarker语法 可参考：[FreeMarker 官方文档](https://www.jfox.info/go.php?url=http://freemarker.org/docs/dgui_quickstart.html)
 
home.ftl 

    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
        <span>${name}</span>
        <ul>
        <#list list as item >
            <li>${item}</li>
        </#list>
        </ul>
    </body>
    </html>

#### 如需修改 freemarker 的默认配置，可以在application.properties中添加：

    # ================================================
    #                   FreeMarker配置
    # ================================================
    # 是否开启模板缓存
    spring.freemarker.cache=true
    # 编码格式
    spring.freemarker.charset=UTF-8
    # 模板的媒体类型设置
    spring.freemarker.content-type=text/html
    # 前缀设置 默认为 ""
    spring.freemarker.prefix=
    # 后缀设置 默认为 .ftl
    spring.freemarker.suffix=.ftl
    #spring.freemarker.allow-request-override=false
    #spring.freemarker.check-template-location=true
    #spring.freemarker.expose-request-attributes=false
    #spring.freemarker.expose-session-attributes=false
    #spring.freemarker.expose-spring-macro-helpers=false
    #spring.freemarker.request-context-attribute=
    #spring.freemarker.template-loader-path=classpath:/templates/
    #spring.freemarker.view-names=
{% endraw %}
