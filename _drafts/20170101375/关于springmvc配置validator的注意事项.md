---
layout: post
title:  "关于springmvc配置validator的注意事项"
title2:  "关于springmvc配置validator的注意事项"
date:   2017-01-01 23:57:55  +0800
source:  "https://www.jfox.info/%e5%85%b3%e4%ba%8espringmvc%e9%85%8d%e7%bd%aevalidator%e7%9a%84%e6%b3%a8%e6%84%8f%e4%ba%8b%e9%a1%b9.html"
fileName:  "20170101375"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%85%b3%e4%ba%8espringmvc%e9%85%8d%e7%bd%aevalidator%e7%9a%84%e6%b3%a8%e6%84%8f%e4%ba%8b%e9%a1%b9.html"
---
{% raw %}
1<mvc:annotation-driven validator="validator"/>

　　在使用springmvc整合hibernate-validator做表单数据验证的时候(页面标签使用spring的form相关标签)，不知道是由于版本原因还是其他原因，需要把上面的配置放置在***最前面***，数据验证注释（例如：@size、@email等）才会生效，错误绑定类才能接收到错误信息。

　　另外，说一下springmvc中spring-servlet.xml、applicationContext.xml的区别：

　　1：spring-servlet.xml是在dispatcherServlet启动的时候读取并加载其中的配置，applicationContext.xml是由contextLoaderListener监听到服务器启动的时候加载的；

　　2：在不使用springmvc的dispatcherServlet做控制层的时候（比如用struts2），applicationContext.xml可以单独使用配置所有spring相关的东西；一起使用的时候有一些规范，spring-servlet.xml最好加载包含Web组件的bean，如控制器、视图解析器以及处理器映射，而contextLoaderListener要加载应用中的其他bean，这些bean通常是驱动应用后端的中间层和数据层组件。
{% endraw %}
