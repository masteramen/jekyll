---
layout: post
title:  "浅谈Servlet和Filter的区别以及两者在Struts2和Springmvc中的应用"
title2:  "浅谈Servlet和Filter的区别以及两者在Struts2和Springmvc中的应用"
date:   2017-01-01 23:59:23  +0800
source:  "https://www.jfox.info/%e6%b5%85%e8%b0%88servlet%e5%92%8cfilter%e7%9a%84%e5%8c%ba%e5%88%ab%e4%bb%a5%e5%8f%8a%e4%b8%a4%e8%80%85%e5%9c%a8struts2%e5%92%8cspringmvc%e4%b8%ad%e7%9a%84%e5%ba%94%e7%94%a8.html"
fileName:  "20170101463"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%b5%85%e8%b0%88servlet%e5%92%8cfilter%e7%9a%84%e5%8c%ba%e5%88%ab%e4%bb%a5%e5%8f%8a%e4%b8%a4%e8%80%85%e5%9c%a8struts2%e5%92%8cspringmvc%e4%b8%ad%e7%9a%84%e5%ba%94%e7%94%a8.html"
---
{% raw %}
在javaweb开发中，Servlet和Filter是很重要的两个概念，我们平时进行javaweb开发的时候，会经常和Servlet和Filter打交道，但我们真的了解Servlet和Filter吗？

一、基本概念

Servlet:

       Servlet 是在WEB服务器上运行的程序。这个词是在 Java applet的环境中创造的，Java applet 是一种当作单独文件跟网页一起发送的小程序，它通常用于在客户端运行，结果得到为用户进行运算或者根据用户互作用定位图形等服务。

       服务器上需要一些程序，常常是根据用户输入访问数据库的程序。这些通常是使用公共网关接口（Common Gateway Interface，CGI）应用程序完成的。然而，在服务器上运行 Java，这种程序可使用 Java 编程语言实现。在通信量大的服务器上，JavaServlet 的优点在于它们的执行速度更快于 CGI 程序。各个用户请求被激活成单个程序中的一个线程，而无需创建单独的进程，这意味着服务器端处理请求的系统开销将明显降低。

        Servlet创建并返回一个包含基于客户请求性质的动态内容的完整的html页面；
创建可嵌入到现有的html页面中的一部分html页面（html片段）；
读取客户端发来的隐藏数据；
读取客户端发来的显示数据；
与其他服务器资源（包括数据库和java的应用程序）进行通信；
通过状态代码和响应头向客户端发送隐藏数据。

Filter:

        filter是一个可以复用的代码片段，可以用来转换HTTP请求、响应和头信息。Filter不像Servlet，它不能产生一个请求或者响应，它只是修改对某一资源的请求，或者修改从某一的响应。

 二、生命周期：
1、servlet：servlet的生命周期始于它被装入web服务器的内存时，并在web服务器终止或重新装入servlet时结束。servlet一旦被装入web服务器，一般不会从web服务器内存中删除，直至web服务器关闭或重新结束。
(1)、装入：启动服务器时加载Servlet的实例；
(2)、初始化：web服务器启动时或web服务器接收到请求时，或者两者之间的某个时刻启动。初始化工作有init（）方法负责执行完成；
(3)、调用：从第一次到以后的多次访问，都是只调用doGet()或doPost()方法；
(4)、销毁：停止服务器时调用destroy()方法，销毁实例。 
2、filter：（一定要实现javax.servlet包的Filter接口的三个方法init()、doFilter()、destroy()，空实现也行）
(1)、启动服务器时加载过滤器的实例，并调用init()方法来初始化实例；
(2)、每一次请求时都只调用方法doFilter()进行处理；

        (3)、停止服务器时调用destroy()方法，销毁实例。

三、职责
1、servlet：
创建并返回一个包含基于客户请求性质的动态内容的完整的html页面；
创建可嵌入到现有的html页面中的一部分html页面（html片段）；
读取客户端发来的隐藏数据；
读取客户端发来的显示数据；
与其他服务器资源（包括数据库和java的应用程序）进行通信；
通过状态代码和响应头向客户端发送隐藏数据。
2、filter：
filter能够在一个请求到达servlet之前预处理用户请求，也可以在离开servlet时处理http响应：
在执行servlet之前，首先执行filter程序，并为之做一些预处理工作；
根据程序需要修改请求和响应；
在servlet被调用之后截获servlet的执行

四、区别：

        1,servlet 流程是短的，url传来之后，就对其进行处理，之后返回或转向到某一自己指定的页面。它主要用来在 业务处理之前进行控制.
2,filter 流程是线性的， url传来之后，检查之后，可保持原来的流程继续向下执行，被下一个filter, servlet接收等，而servlet 处理之后，不会继续向下传递。filter功能可用来保持流程继续按照原来的方式进行下去，或者主导流程，而servlet的功能主要用来主导流程。
filter可用来进行字符编码的过滤，检测用户是否登陆的过滤，禁止页面缓存等

五、执行流程图：

         1、servlet：

               ![](/wp-content/uploads/2017/08/1501893869.png)

          2、filter：

           ![](/wp-content/uploads/2017/08/1501893870.png)

javaweb开发我们常用到的后台框架有Struts2和Springmvc。其中Struts2的入口filter，而Springmvc的入口是servlet;

我们在使用Struts2进行开发时，web.xml中的核心控制器是这样配置的

<filter>
<filter-name>struts2</filter-name>
<filter-class>org.apache.struts2.dispatcher.ng.filter.StrutsPrepareAndExecuteFilter</filter-class>
</filter>

而使用Springmvc进行开发时，其web.xml是这样配置的

<servlet>
<servlet-name>springmvc</servlet-name>
<servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
</servlet>
{% endraw %}
