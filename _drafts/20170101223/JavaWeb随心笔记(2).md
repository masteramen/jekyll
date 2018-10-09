---
layout: post
title:  "JavaWeb随心笔记(2)"
title2:  "JavaWeb随心笔记(2)"
date:   2017-01-01 23:55:23  +0800
source:  "https://www.jfox.info/javaweb%e9%9a%8f%e5%bf%83%e7%ac%94%e8%ae%b02.html"
fileName:  "20170101223"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/javaweb%e9%9a%8f%e5%bf%83%e7%ac%94%e8%ae%b02.html"
---
{% raw %}
JSP 是在 HTML 页面中嵌入 Java 代码。HTML 负责页面的静态部分， Java 代码负责动态部分，java 代码获取服务端的数据，并利用数据在游览器上。JSP 的实质是 Servlet，具体通过 jsp 的生命周期理解。

## JSP 指令 

 格式:<%@ page 属性名=”Value” 属性名=”Value” > 

language=”java”

Content-Type=”text/html;charset=utf-8”

import=””

## JSP 注释 

    <!-- --> HTML 注释，可以再游览器中查看
    <%-- --%> 注释不能再游览器中查看
    <% java 代码 %>  jsp 脚本  
    <!% java 代码 %> jsp 的声明，定义变量和方法
    <%= %> jsp 的表达式 可以调用 jsp 中声明的 java 代码
    

## JSP 的生命周期 

 详情页面: [菜鸟教程](https://www.jfox.info/go.php?url=http://www.runoob.com/jsp/jsp-life-cycle.html)

## JSP 的内置对象 

1. request
2. response
3. out (向游览器输出内容)
4. page (表示当前页面)
5. pageContent (当前页面的上下文环境，可以获取上下文的数据)
6. session (一次会话)
7. application (开始于服务器的启动,结束与服务器的结束)
8. exception (异常)
9. config (在 Servlet 初始化的时候来获取相关参数和传递信息)

### 利用 application 实现网站计数器 

    <%
    //获取应用中的Counter 值
        if(application.getAttribute("counter")==null){
            application.setAttribute("counter",new Integer(1));
        }
        //如果存在就 +1
        int value=(Integer)application.getAttribute("counter");
        application.setAttribute("counter",new Integer(value+1));
    %>
    欢迎第<%application.getAttribute("conter") %>名顾客访问！
    

## javaBean 的简介 

1. 该类是一个公共类
2. 必须有一个无参的构造方法
3. 必须有所有的属性私有
4. 通过 getter 和 setter 进行私有属性的存取

### 在 JSP 中使用 JavaBean 

#### 普通方式 

1. 导包(<%@page import=”bean.User”>)
2. 使用(<% User user=new User()%>)

#### 使用 JSP 标签 

    <jsp:useBean id="myUser" class="bean.User" scope="page"/>
    用户名称<%myUser.getName()%>
    

#### SetProperty 标签 

配合 useBean 标签使用，给你usebean 赋值 

    //匹配信息到User 中的名字
    <jsp:setProperty property="username" name="myUser" />
    //将密码匹配到User
    <jsp:setProperty property="password" name="myUser" value="123456"/>
    

## JavaBean 中作用域 

1. page 当前页面有效
2. request 一次请求有效
3. session 一次会话有效
4. application 从服务器开启到服务器关闭有效
{% endraw %}
