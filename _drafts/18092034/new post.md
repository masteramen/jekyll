---
layout: post
title: "Java Spring框架面试总结"
title2: "Java Spring框架面试总结"
date: 2018-10-20 10:21:20  +0800
source: ""
fileName: "18092034"
lang: "zh_CN"
published: false
---

{% raw %}

# Spring IoC 和 DI 的理解

1. Ioc(Inverse of Control)反转控制的概念，就是将原本在程序中手动创建对象的控制权，交由 Spring 框架来管理，简单点说，就是创建对象的控制权被反转到 Spring 框架了。
2. DI（Dependency Injection,依赖注入),在 Spring 框架负责创建 Bean 对象时，动态的将其依赖对象注入到该 Bean 对象组件中。
3. 两者的区别：Ioc 控制反转，指将对象的创建权反转到 Spring 容器；DI 依赖注入，指 Spring 创建对象时，将对象的依赖属性通过配置进行注入。

# Spring Bean 的作用域(Scope)

1. singleton （默认的作用域）, 当一个 Bean 的作用域为 singleton,那么 Spring Ioc 容器只会存在一个共享的 bean 实例
2. prototype, 每次获取该 bean 时，都会创建一个新的 bean 实例。

3. request, 在一次 HTTP 请求中，只会创建一个 Bean 实例。
4. session, 在一个 HTTP Session 中， 只会创建一个 bean 实例。
5. global session

# Spring Bean 属性注入方式

1. 构造方法注入
2. set 方法注入
3. 基于注解注入

# BeanFactory 接口与 ApplicationContext 接口的区别

1. ApplicationContext 接口 继承 BeanFactory 接口，Spring 的核心工厂是 BeanFactory，BeanFactory 采取延迟加载，第一次 getBean 时才会初始化 Bean，ApplicationContext 是在加载配置文件时初始化 Bean.
2. ApplicationContext 是对 BeanFactory 扩展，添加了国际化处理，事件传递和 bean 自动装配以及各种不同应用层的 Context 实现，现实开发中基本使用的都是 ApplicationContext,web 项目使用 WebApplicationContext,很少使用 BeanFactory.

# Spring 实例化 bean 的方法

1. 使用类构造器（默认是无参数）
2. 使用静态工厂方法（简单工厂模式）
3. 使用实例工厂方法（工厂方法模式）

# Spring MVC 流程原理

1. Springmvc 将所有的请求都交给 DispatcherServlet（前端控制器,他会委托应用系统的其他模块负责对请求进行真正的处理工作）。

2. DispatcherServlet 根据请求的 URL 格式， 查询一个或多个 HandlerMapping（处理器映射器）,找到处理请求的 Controller.
3. DispatcherServlet 将请求转交给目标 Controller.
4. Controller 进行业务逻辑处理后，返回一个 ModelAndView（模型和视图） 对象。
5. DispatcherServlet 查询一个或多个 ViewResolver(视图解析器)，找到 ModelAndView 对象指定的视图对象
6. 视图对象负责将渲染结果显示返回给客户端。
   {% endraw %}
