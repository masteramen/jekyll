---
layout: post
title:  "SpringMVC：SpringMVC启动初始化过程"
title2:  "SpringMVC：SpringMVC启动初始化过程"
date:   2017-01-01 23:57:37  +0800
source:  "http://www.jfox.info/springmvcspringmvc%e5%90%af%e5%8a%a8%e5%88%9d%e5%a7%8b%e5%8c%96%e8%bf%87%e7%a8%8b.html"
fileName:  "20170101357"
lang:  "zh_CN"
published: true
permalink: "springmvcspringmvc%e5%90%af%e5%8a%a8%e5%88%9d%e5%a7%8b%e5%8c%96%e8%bf%87%e7%a8%8b.html"
---
{% raw %}
公司项目使用 struts2 作为控制层框架，为了实现前后端分离，计划将 struts2 切换为 SpringMVC ，因此，这段时间都在学习新的框架，《Spring实战》是一本好书，里面对 Spring 的原理实现以及应用都说得很透彻，强烈推荐，但是如果想深挖 Spring 的实现，还是要从他的源码入手，这次，就先从 SpringMVC 初始化开始。

- 
Web 容器初始化过程

- 
SpringMVC的Web.xml配置

- 
DispatchServlet初始化

### Web容器初始化过程

web容器初始化的过程，其官方文档给出了这样的描述：

1. 
 Instantiate an instance of each event listener identified by a **<listener>** element in the deployment descriptor. 

For instantiated listener instances that implement ServletContextListener, call the contextInitialized() method.

2. 
 Instantiate an instance of each filter identified by a **<filter>** element in the deployment descriptor and call each filter instance’s init() method. 

3. 
 Instantiate an instance of each servlet identified by a **<servlet>** element that includes a <load-on-startup> element in the order defined by the load-on-startup element values, and call each servlet instance’s init() method. 

其初始化的过程实际如下：

![](/wp-content/uploads/2017/07/1500289230.png)

### SpringMVC 的 web.xml配置

web.xml 配置代码：

    <?xml version="1.0" encoding="UTF-8"?>  
    <web-app version="2.5" xmlns="http://java.sun.com/xml/ns/javaee"  
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
             xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd">  
       
        <context-param>  
            <param-name>contextConfigLocation</param-name>  
            <param-value>classpath:applicationContext.xml</param-value>  
        </context-param>  
      
        <listener>  
            <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>  
        </listener>  
      
      
        <servlet>  
            <servlet-name>mvc-dispatcher</servlet-name>  
            <servlet-class>  
                org.springframework.web.servlet.DispatcherServlet  
            </servlet-class>  
            <load-on-startup>1</load-on-startup>  
        </servlet>  
                                                                                                                                               
        <servlet-mapping>  
            <servlet-name>mvc-dispatcher</servlet-name>  
            <url-pattern>/</url-pattern>  
        </servlet-mapping>  
      
    </web-app>

- 
#### <listener>标签中定义了spring容器加载器

- 
#### <servlet>标签中定义了spring前端控制器

在 Servlet API中有一个ServletContextListener接口，它能够监听ServletContext对象的生命周期，实际上就是监听Web应用的生命周期。当Servlet容器启动或终止Web应用时，会触发ServletContextEvent事件，该事件由ServletContextListener来处理。在ServletContextListener接口中定义了处理ServletContextEvent 事件的两个方法contextInitialized()和contextDestroyed()。

ContextLoaderListener监听器的作用就是启动Web容器时，自动装配ApplicationContext的配置信息。因为它实现了ServletContextListener这个接口，在web.xml配置了这个监听器，启动容器时，就会默认执行它实现的方法。由于在ContextLoaderListener中关联了ContextLoader这个类，所以整个加载配置过程由ContextLoader来完成。

### DispatchServlet初始化

在SpringMVC架构中，DispatchServlet负责请求分发，起到控制器的作用。下面详细来解释说明：

![](/wp-content/uploads/2017/07/1500289232.png)

- 
DispatchServlet名如其义，它的本质上是一个Servlet，子类不断的对HttpServlet父类进行方法扩展

- 
HttpServlet有两大核心方法：init()和service()方法。HttpServletBean重写了init()方法，在这部分，我们可以看到其实现思路：公共的部分统一来实现，变化的部分统一来抽象，交给其子类来实现，故用了abstract class来修饰类名。此外，HttpServletBean提供了一个HttpServlet的抽象实现，使的Servlet不再关心init-param部分的赋值，让servlet更关注于自身Bean初始化的实现

- 
FrameworkServlet提供了集成web javabean和spring application context的集成方案。在源码中可以看到通过执行initWebApplicationContext()方法和initFrameworkServlet()方法实现

- 
 DispatchServlet是HTTP请求的中央调度处理器，它将web请求转发给controller层处理，它提供了敏捷的映射和异常处理机制， DispatchServlet转发请求的核心代码在doService()方法中实现

DispatchServlet类和ContextLoaderListener类的关系图：

![](/wp-content/uploads/2017/07/15002892321.png)

#### 用ContextLoaderListener初始化上下文，接着使用DispatchServlet来初始化WebMVC的上下文
{% endraw %}
