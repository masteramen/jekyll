---
layout: post
title:  "【Spring】1、Spring 中的监听器 Listener"
title2:  "【Spring】1、Spring 中的监听器 Listener"
date:   2017-01-01 23:58:50  +0800
source:  "https://www.jfox.info/spring1spring%e4%b8%ad%e7%9a%84%e7%9b%91%e5%90%ac%e5%99%a8listener.html"
fileName:  "20170101430"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/spring1spring%e4%b8%ad%e7%9a%84%e7%9b%91%e5%90%ac%e5%99%a8listener.html"
---
{% raw %}
1、EventListener

2、HttpSessionAttributeListener   继承EventListener接口

     HttpSessionAttributeListener是“属性改变监听器”，当在会话对象中加入属性、移除属性或替换属性时，相对应的attributeAdded()、attributeRemoved()与

     attributeReplaced()方法就会被调用，并分别传入HttpSessionBindingEvent。

package javax.servlet.http;

import java.util.EventListener;

public interface HttpSessionAttributeListener extends EventListener {
public void attributeAdded ( HttpSessionBindingEvent se );
public void attributeRemoved ( HttpSessionBindingEvent se );
public void attributeReplaced ( HttpSessionBindingEvent se );

}

如果希望容器在部署应用程序时，实例化实现HttpSessionAttributeListener的类并注册给应用程序，则同样也是在实现类上标注@WebListener：
…
@WebListener()
public class HttpSessionAttrListener
implements HttpSessionAttributeListener {
…
}

另一个方式是在web.xml下进行设置：
…
<listener>
<listener-class>cc.openhome.HttpSessionAttrListener</listener-class>
</listener>

3、HttpSessionListener    继承EventListener接口

    publicinterface HttpSessionListener extends EventListener {
        publicvoid sessionCreated(HttpSessionEvent se);
        publicvoid sessionDestroyed(HttpSessionEvent se);
    }

   在HttpSession对象初始化或结束前，会分别调用sessionCreated()与session- Destroyed()方法，可以通过传入的HttpSessionEvent，使用getSession()取得HttpSession，    以针对会话对象作出相对应的创建或结束处理操作。

4、HttpSessionBindingListener

HttpSessionBindingListener是“对象绑定监听器”，如果有个即将加入HttpSession的属性对象，希望在设置给HttpSession成为属性或从HttpSession中移除时，可以收到HttpSession的通知，则可以让该对象实现HttpSessionBindingListener接口。

    package javax.servlet.http;
    import java.util.EventListener;
    publicinterface HttpSessionBindingListener extends EventListener {
        publicvoid valueBound(HttpSessionBindingEvent event);
        publicvoid valueUnbound(HttpSessionBindingEvent event);
    }

当用户输入正确的名称与密码时，首先会以用户名来创建User实例，而后加入HttpSession中作为属性。希望User实例被加入成为HttpSession属性时，可以自动从数据库中加载用户的其他数据，如地址、照片等，或是在日志中记录用户登录的信息，可以让User类实现HttpSessionBindingListener接口。

5. HttpSessionActivationListener

HttpSessionActivationListener是“对象迁移监听器”，其定义了两个方法sessionWillPassivate()与sessionDidActivate()。很多情况下，几乎不会使用到HttpSessionActivationListener。在使用到分布式环境时，应用程序的对象可能分散在多个JVM中。当HttpSession要从一个JVM迁移至另一个JVM时，必须先在原本的JVM上序列化(Serialize)所有的属性对象，在这之前若属性对象有实现HttpSessionActivationListener，就会调用sessionWillPassivate()方法，而 HttpSession迁移至另一个JVM后，就会对所有属性对象作反序列化，此时会调用sessionDidActivate()方法。

要可以序列化的对象必须实现Serializable接口。如果HttpSession属性对象中有些类成员无法作序列化，则可以在sessionWillPassivate()方法中做些替代处理来保存该成员状态，而在sessionDidActivate()方法中做些恢复该成员状态的动作。

概述：

Servlet监听器用于监听一些重要事件的发生，监听器对象可以在事情发生前、发生后可以做一些必要的处理。

接口：

目前Servlet2.4和JSP2.0总共有8个监听器接口和6个Event类，其中HttpSessionAttributeListener与

HttpSessionBindingListener 皆使用HttpSessionBindingEvent;HttpSessionListener和 HttpSessionActivationListener则都使用HttpSessionEvent;其余Listener对应的Event如下所示：

Listener接口

Event类

ServletContextListener

ServletContextEvent

ServletContextAttributeListener

ServletContextAttributeEvent

HttpSessionListener

HttpSessionEvent

HttpSessionActivationListener

HttpSessionAttributeListener

HttpSessionBindingEvent

HttpSessionBindingListener

ServletRequestListener

ServletRequestEvent

ServletRequestAttributeListener

ServletRequestAttributeEvent

分别介绍：

一 ServletContext相关监听接口

补充知识：

通过ServletContext 的实例可以存取应用程序的全局对象以及初始化阶段的变量。

在JSP文件中，application 是 ServletContext 的实例，由JSP容器默认创建。Servlet 中调用 getServletContext()方法得到 ServletContext 的实例。

注意：

全局对象即Application范围对象，初始化阶段的变量指在web.xml中，经由<context-param>元素所设定的变量，它的范围也是Application范围，例如：

<context-param>

<param-name>Name</param-name>

<param-value>browser</param-value>

</context-param>

当容器启动时，会建立一个Application范围的对象，若要在JSP网页中取得此变量时：

String name = (String)application.getInitParameter(“Name”);

或者使用EL时：

${initPara.name}

若是在Servlet中，取得Name的值方法：

String name = (String)ServletContext.getInitParameter(“Name”);

1.ServletContextListener：

用于监听WEB 应用启动和销毁的事件，监听器类需要实现javax.servlet.ServletContextListener 接口。

ServletContextListener 是 ServletContext 的监听者，如果 ServletContext 发生变化，如服务器启动时 ServletContext 被创建，服务器关闭时 ServletContext 将要被销毁。

ServletContextListener接口的方法：

void contextInitialized(ServletContextEvent sce)

通知正在接受的对象，应用程序已经被加载及初始化。

void contextDestroyed(ServletContextEvent sce)

通知正在接受的对象，应用程序已经被载出。

ServletContextEvent中的方法：

ServletContext getServletContext()

取得ServletContext对象

2.ServletContextAttributeListener：用于监听WEB应用属性改变的事件，包括：增加属性、删除属性、修改属性，监听器类需要实现javax.servlet.ServletContextAttributeListener接口。

ServletContextAttributeListener接口方法：

void attributeAdded(ServletContextAttributeEvent scab)

若有对象加入Application的范围，通知正在收听的对象

void attributeRemoved(ServletContextAttributeEvent scab)

若有对象从Application的范围移除，通知正在收听的对象

void attributeReplaced(ServletContextAttributeEvent scab)

若在Application的范围中，有对象取代另一个对象时，通知正在收听的对象

ServletContextAttributeEvent中的方法：

java.lang.String getName()

回传属性的名称

java.lang.Object getValue()

回传属性的值

二、HttpSession相关监听接口

1.HttpSessionBindingListener接口

注意：HttpSessionBindingListener接口是唯一不需要再web.xml中设定的Listener

当我们的类实现了HttpSessionBindingListener接口后，只要对象加入 Session范围（即调用HttpSession对象的setAttribute方法的时候）或从Session范围中移出（即调用HttpSession对象的 removeAttribute方法的时候或Session Time out的时候）时，容器分别会自动调用下列两个方法：

void valueBound(HttpSessionBindingEvent event)

void valueUnbound(HttpSessionBindingEvent event)

思考：如何实现记录网站的客户登录日志， 统计在线人数？

2.HttpSessionAttributeListener接口

HttpSessionAttributeListener监听HttpSession中的属性的操作。

当在Session增加一个属性时，激发attributeAdded(HttpSessionBindingEvent se) 方法；当在Session删除一个属性时，激发attributeRemoved(HttpSessionBindingEvent se)方法；当在Session属性被重新设置时，激发attributeReplaced(HttpSessionBindingEvent se) 方法。这和ServletContextAttributeListener比较类似。

3.HttpSessionListener接口

HttpSessionListener监听 HttpSession的操作。当创建一个Session时，激发session Created(HttpSessionEvent se)方法；当销毁一个Session时，激发sessionDestroyed (HttpSessionEvent se)方法。

4.HttpSessionActivationListener接口

主要用于同一个Session转移至不同的JVM的情形。

四、ServletRequest监听接口

1.ServletRequestListener接口

和ServletContextListener接口类似的，这里由ServletContext改为ServletRequest

2.ServletRequestAttributeListener接口

和ServletContextListener接口类似的，这里由ServletContext改为ServletRequest

有的listener可用于统计网站在线人数及访问量。 如下：

服务器启动时（实现ServletContextListener监听器contextInitialized方法），读取[数据库](https://www.jfox.info/go.php?url=http://lib.csdn.net/base/mysql)，并将其用一个计数变量保存在application范围内

session创建时（实现HttpSessionListener监听器sessionCreated方法），读取计数变量加1并重新保存

服务器关闭时（实现ServletContextListener监听器contextDestroyed方法），更新数据库
{% endraw %}
