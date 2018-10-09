---
layout: post
title:  "EJB系列 – EJB高级概念"
title2:  "EJB系列 – EJB高级概念"
date:   2017-01-01 23:52:49  +0800
source:  "https://www.jfox.info/ejb%e7%b3%bb%e5%88%97ejb%e9%ab%98%e7%ba%a7%e6%a6%82%e5%bf%b5.html"
fileName:  "20170101069"
lang:  "zh_CN"
published: true
permalink: "2017/ejb%e7%b3%bb%e5%88%97ejb%e9%ab%98%e7%ba%a7%e6%a6%82%e5%bf%b5.html"
---
{% raw %}
幕后的EJB:容器会为每一个bean实例自动生成称为EJB对象的代理, 由容器实现, 对使用者开发者透明

EJB上下文: 在理想情况下, 不应该编程中使用EJB上下文对象; 但现实中, 难免有要求, 所以便有EJBContext的存在; 对应会话bean的专有子类SessionContext, 对应MDB的专有子类MessageDrivenContext; 可通过@Resource注入, 注入时, 容器会根据当前bean的类型自动注入专有子类

##  

## 依赖注入和JNDI访问资源

@Resource:EJB3中依赖注入最全面的注解; 参数: name: 其值会在容器进一步解析, 其形式为 java:conp/env/{name}的全限定JNDI名;

在幕后容器在部署过程中会把EJB组件, 服务解析为资源, 并把资源绑定到ENC(环境命名上下文); 使用设置器(setter)注入, 方便单元测试, 便于初始化

 @Resource实际应用:
a. 注入JMS资源
b. 注入EJBContext
c. 访问部署描述文件中的环境条目
d. 注入JavaMail
e. 注入计时器服务 

 @Resouce继承: 如果超类使用@Resouce注解定义了任何资源, 它们可以被子类继承 

 查找资源与EJB: 使用查找(即使用API)而非依赖注入允许在运行时动态地确定要使用哪些资源 

##  EJB中的AOP 拦截器 

 AOP概述:面向切面 

 什么是拦截器: 拦截器是EJB版的AOP, 没有真正AOP强大, 但使用简单; 拦截器只有一种形式”环绕调用通知”. 在方法的开头和方法的返回时被触发, 可用于业务方法和生命周期回调方法,可用于会话bean和消息驱动bean 

 指定拦截器:
a. @Interceptions注解允许方法或类调用一个或者多个拦截器类; 当在类级别注解使用拦截器时, 其生命周期会触发拦截器中的生命周期回调拦截器方法, 调用业务方法时怎会触发业务方法拦截器; 除了方法和类级别的拦截器之外, 还有默认拦截器, 只能在部署描述文件中进行设置
b. 拦截器的调用顺序: 从大作用域到小作用域进行的, 首先是默认拦截器到类拦截器到方法拦截器
c. 在同级的多个拦截器调用顺序: 按照注解中的的顺序执行
d. 可使用@ExcludeDefaultInerceptors禁止默认级别拦截器; 可使用@ExcludeClassInerceptors禁止类级别拦截器 

 拦截器的实现: 
@AroundInvoke注解被触发的环绕调用方法, 一个拦截器类中只能有一个被该注解注解的方法
环绕调用方法的方法签名必须遵守Object <method name> (InvocationContext invocationContext) throws Exception
InvocationContext接口: 可以动态检查被拦截的bean的状态和对其动态修改参数等操作
{% endraw %}
