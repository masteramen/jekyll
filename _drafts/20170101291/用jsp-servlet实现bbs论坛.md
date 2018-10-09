---
layout: post
title:  "用jsp-servlet实现bbs论坛"
title2:  "用jsp-servlet实现bbs论坛"
date:   2017-01-01 23:56:31  +0800
source:  "https://www.jfox.info/%e7%94%a8jspservlet%e5%ae%9e%e7%8e%b0bbs%e8%ae%ba%e5%9d%9b.html"
fileName:  "20170101291"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e7%94%a8jspservlet%e5%ae%9e%e7%8e%b0bbs%e8%ae%ba%e5%9d%9b.html"
---
{% raw %}
H2M_LI_HEADER 
对servlet&jsp的技术更为熟悉了些，总体来说servlet&jsp就是一种在服务器上动态生成HTML页面的一种技术

H2M_LI_HEADER 
一开始在jsp中有使用java代码来获得文章列表。我在jsp中使用java代码的主要目的就是为了获取数据。但这种方式却十分混乱。例如在循环输出列表的过程中，会出现如下的代码：

    <% { %/>
    	...
    <% } %/>
    

这种在大括号出现在jsp中，将十分混乱，因为你无法知道大括号是与哪个大括号对应。

所以后来，我把jsp中的java代码全都去掉了，不是由一个jsp跳另一个jsp，而在中间加了一个servlet类，该servlet能处理数据，然后发送给jsp，而jsp中显示数据则用到了EL表达式和JSTL。

 关于如何把java脚本从jsp中剥离，可参考 [这里](https://www.jfox.info/go.php?url=https://github.com/giantray/stackoverflow-java-top-qa/blob/master/contents/how-to-avoid-java-code-in-jsp-files.md)

接下来，我将尝试使用框架对该BBS的代码进行修改。

该BBS系统，只使用了三张表如下：
{% endraw %}
