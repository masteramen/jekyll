---
layout: post
title:  "spring mvc 配置bootstrap"
title2:  "spring mvc 配置bootstrap"
date:   2017-01-01 23:53:02  +0800
source:  "http://www.jfox.info/springmvc%e9%85%8d%e7%bd%aebootstrap.html"
fileName:  "20170101082"
lang:  "zh_CN"
published: true
permalink: "springmvc%e9%85%8d%e7%bd%aebootstrap.html"
---
{% raw %}
1.下载bootstrap

到下面的链接下载最新的 http://getbootstrap.com/，我下载的版本是bootstrap-3.3.7-dist

2.解压bootstrap-3.3.7-dist.zip,把整个文件夹copy到项目的中。我创建的是maven项目，我的bootstrap资源文件放在webappres文件夹下。

bootstrap-3.3.7-dist本身没有包含jquery.js脚本文件，需要单独下载，下载地址http://jquery.com/download/。

具体文件目录结构请看下图：

![](/wp-content/uploads/2017/07/1499262778.png)

3.修改web.xml,对客户端请求的静态资源，如js,css等，交由默认的servlet处理；*.tff,*.woff,*.woff2是bootstrap的font目录下的文件后缀。
![](/wp-content/uploads/2017/07/1499262901.gif)![](/wp-content/uploads/2017/07/1499262902.gif)
    <servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.jpg</url-pattern></servlet-mapping><servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.js</url-pattern></servlet-mapping><servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.css</url-pattern></servlet-mapping><servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.html</url-pattern></servlet-mapping><servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.ttf</url-pattern></servlet-mapping><servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.woff</url-pattern></servlet-mapping><servlet-mapping><servlet-name>default</servlet-name><url-pattern>*.woff2</url-pattern></servlet-mapping><servlet-mapping><servlet-name>springDispatcherServlet</servlet-name><!-- 可以应答所有请求，也就是将所有的请求都交给Spring的DispatcherServlet来处理 --><url-pattern>/</url-pattern></servlet-mapping>

View Code
如果不添加，会报404错误，下面的报错的url和截图

http://localhost:8080/maven05/res/bootstrap-3.3.7-dist/fonts/glyphicons-halflings-regular.woff2

![](/wp-content/uploads/2017/07/1499262780.png)

 点击进去看详情

 ![](/wp-content/uploads/2017/07/1499262903.png)

4.在web页面中引用bootstrap

这里没有使用cdn，直接引用本地文件
![](/wp-content/uploads/2017/07/1499262901.gif)![](/wp-content/uploads/2017/07/1499262902.gif)
    <%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><title>Insert title here</title><meta name="viewport" content="width=device-width, initial-scale=1.0"><!-- 引用本地资源 --><link rel="stylesheet"
        href="res/bootstrap-3.3.7-dist/css/bootstrap.min.css"><script
        src="res/bootstrap-3.3.7-dist/js/jquery.min.js"></script><script
        src="res/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script><!-- 引用cdn资源 --><!-- <link rel="stylesheet"
        href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css">
    <script
        src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script>
    <script
        src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script> --></head><body><p><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-attributes"></span></button><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-attributes-alt"></span></button><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-order"></span></button><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-order-alt"></span></button></p><button type="button" class="btn btn-default btn-lg"><span class="glyphicon glyphicon-user"></span> User
        </button><button type="button" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-user"></span> User
        </button><button type="button" class="btn btn-default btn-xs"><span class="glyphicon glyphicon-user"></span> User
        </button></body></html>

View Code
　　运行效果

![](/wp-content/uploads/2017/07/1499262904.png)

5.如果使用cdn，很简单，直接在web页面引用即可，不需要配置web.xml
![](/wp-content/uploads/2017/07/1499262901.gif)![](/wp-content/uploads/2017/07/1499262902.gif)
    <%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><title>Insert title here</title><meta name="viewport" content="width=device-width, initial-scale=1.0"><!-- 引用本地资源 --><!-- <link rel="stylesheet"
        href="res/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <script
        src="res/bootstrap-3.3.7-dist/js/jquery.min.js"></script>
    <script
        src="res/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script> --><!-- 引用cdn资源 --><link rel="stylesheet"
        href="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css"><script
        src="http://cdn.static.runoob.com/libs/jquery/2.1.1/jquery.min.js"></script><script
        src="http://cdn.static.runoob.com/libs/bootstrap/3.3.7/js/bootstrap.min.js"></script></head><body><p><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-attributes"></span></button><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-attributes-alt"></span></button><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-order"></span></button><button type="button" class="btn btn-default"><span class="glyphicon glyphicon-sort-by-order-alt"></span></button></p><button type="button" class="btn btn-default btn-lg"><span class="glyphicon glyphicon-user"></span> User
        </button><button type="button" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-user"></span> User
        </button><button type="button" class="btn btn-default btn-xs"><span class="glyphicon glyphicon-user"></span> User
        </button></body></html>
{% endraw %}
