---
layout: post
title:  "JSP基本语法总结【2】九大内置对象"
title2:  "JSP基本语法总结【2】九大内置对象"
date:   2017-01-01 23:55:36  +0800
source:  "https://www.jfox.info/jsp%e5%9f%ba%e6%9c%ac%e8%af%ad%e6%b3%95%e6%80%bb%e7%bb%932%e4%b9%9d%e5%a4%a7%e5%86%85%e7%bd%ae%e5%af%b9%e8%b1%a1.html"
fileName:  "20170101236"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/jsp%e5%9f%ba%e6%9c%ac%e8%af%ad%e6%b3%95%e6%80%bb%e7%bb%932%e4%b9%9d%e5%a4%a7%e5%86%85%e7%bd%ae%e5%af%b9%e8%b1%a1.html"
---
{% raw %}
内置对象也称为内建对象，隐含对象，即无需声明，直接可以在JSP中使用的java对象。JSP的内置对象就是把最常用、重要的几个对象直接创建了。

JSP有9大内置对象：Request，Response,  Page,  Application  ,   PageContext,   Out,  Session , Config,  Exception

1’　　使用Request对象获取请求

　　　　表示javax.servlet.http.HttpServletRequset对象。包含所以请求的信息，如请求来源，表头，cookies，相关的参数值等。

　　　　常用方法：

　　　　　　　　（1）Object   getAttribute(String  name)　　返回name指定的属性值，该属性返回不存在时返回null

　　　　　　　　（2）void  setAttribute(String  name,Object)　　在属性列表中add/delete指定的属性

　　　　　　　　   (3)  String  getParameter(String name)  获取客户端发送给服务器端的参数值

　　　　　　　　（4）String[]   getParameters(String name)　获取请求中指定参数的所有值

　　　　　　　　（5）String  getProtocol()　　返回请求使用的协议，如HTTP1.1

　　　　　　　　（6）String  RequestURI()　　返回发送请求的客户端地址，但不包括请求的参数字符串

　　　　　　　　（7）String getRemoteAddr() 　　 获取发出请求的客户端IP地址

　　　　　　　　（8）HttpSession   getSession() 　　获取session

2’　　使用Response对象做应答

　　　　表示HttpServletResponse对象，并提供了几个用于设置送回浏览器的响应的方法。

　　　　　　　　（1）sendRedirect(URL) 　　可以将用户重定向到一个不同的页面URL

　　　　　　　　（2）setContentType(String  type)　　响应设置内容类型头

　　　　　　　　（3）addHeader(String name,String  value)　　添加String类型的值到HTTP文件头

▲sendRedirect与forword重定向的区别：后者实在容器内部实现的同一个web app的重定向，只能重定向到同一个web app的一个资源，URL不变；而前者可以重定向任意URL，因为senRedirect是修改HTTP头实现的，URL没什么限制，重定向后浏览器的地址栏URL改变。还有一个，forword重定向将原始的HTTP请求对象Request从一个Servlet实例传递到另一个实例，而senRedirect方式的两者不是同一个Request，简而言之，就是forword可以在转移时带上请求参数，而sendRedirect则不可。

3‘　　Session对象中保存用户会话

　　　　表示一个请求的javax.servlet.http.HttpSession对象。session可以存储用户的状态信息。在第一个JSP页面被装载时自动创建，完成会话期管理。从一个客户打开浏览器并连接到服务器到客户关闭浏览器离开服务器时结束，被称为一个会话。

　　　　当一个客户访问一个服务器时，可能会在这个服务器的几个页面之间反复连接，反复刷新一个页面，服务器应当通过某种办法（如cookie）知道这是同一个客户，此时就需要session了。

　　　　常用方法：

　　　　　　（1）public String  getId()　　获取session对象编号。

　　　　　　（2）public  void setAttribute(String key,Object  obj)　　 将obj对象添加到session对象中，并指定一个索引关键字。

　　　　　　（3）public  Object  getAttribute(String  key)　　　　获取session中含有关键字的对象

　　　　　　（4）public Boolean  isNew()　　　　判断是否为一个新客户

4’　　Appliction对象，pageContext对象和JSP的Scope

　　　　服务器启动后就产生了Application对象；pageContext与Application类似，有setAttribute（）和getAttribute（）方法来保存对象，只是他只限于本页面内。

▲JSP的范围（Scope），分为四个：Page，Request，Session，Application。分别由pageContext，Request，Session，Application4个内置对象对应来保存对象，方法名都为上述两个方法setAttribute（）和getAttribute（）。

　　　　　　Ⅰ　　Page Scope 　　一个jsp页面中

　　　　　　Ⅱ　　Request Scope　　一个jsp网页发出请求到另一个jsp网页之间，随后这个属性失效。即一个Client发出的一个请求

　　　　　　Ⅲ　　Session　Scope　　　一个Client的所有请求共享

　　　　　　Ⅳ　　Application Scope　　全局唯一，共享一个（慎用）　　服务器开始执行服务到服务器关闭为止

5‘　　使用Out对象输出

　　　　为javax.jsp.JspWriter的一个实例，是一个输出流，用来向客户端输出数据。

　　　　　　常用方法：

　　　　　　　　（1）out.print()　　输出各种类型数据

　　　　　　　　（2）out.newLine()　　输出一个换行符

　　　　　　　　（3）out.close()　　关闭流

6’　　Exception处理异常

　　　　用于处理JSP文件执行发生的错误和异常，只有在错误页面才可以使用，前提在page指令中加入”　　isErrorPage=True　　”

　　　　常用方法：

　　　　　　（1）String  getMessage()　　取得错误提示信息

　　　　　　（2）void  printStackTrace()　　一场的堆栈信息

7‘　　Page对象和Config对象

　　　　Page对象表示从该页面产生的一个Servlet实例，详单与这个JSP产生Servlet类的this，可以通过Page对象访问实例的属性和函数。

　　　　Config表示一个javax.servlet.ServletConfig对象。用于存取Servlet实例的初始化参数。

　　　　　　常用方法：

　　　　　　　　（1）String  getInitParameter(String  name)　　返回名称为那么的初始化参数值

　　　　　　　　（2）Enumeration  getInitParameter()　　　　返回这个JSP所有的初始参数的名称集合

　　　　　　　　（3）ServletContext  getContext()　　　　返回执行者的Servlet的上下文

　　　　　　　　（4）String   getServletName()　　返回Servlet的名称
 

  posted @ 
 2017-07-09 00:03[sunwengang](https://www.jfox.info/go.php?url=http://www.cnblogs.com/1996swg/) 阅读( 
 …) 评论( 
 …)
{% endraw %}
