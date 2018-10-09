---
layout: post
title:  "同一个tomcat多个项目共享session，一个tomcat两个项目共享sessionId"
title2:  "同一个tomcat多个项目共享session，一个tomcat两个项目共享sessionId"
date:   2017-01-01 23:56:05  +0800
source:  "https://www.jfox.info/%e5%90%8c%e4%b8%80%e4%b8%aatomcat%e5%a4%9a%e4%b8%aa%e9%a1%b9%e7%9b%ae%e5%85%b1%e4%ba%absession%e4%b8%80%e4%b8%aatomcat%e4%b8%a4%e4%b8%aa%e9%a1%b9%e7%9b%ae%e5%85%b1%e4%ba%absessionid.html"
fileName:  "20170101265"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%90%8c%e4%b8%80%e4%b8%aatomcat%e5%a4%9a%e4%b8%aa%e9%a1%b9%e7%9b%ae%e5%85%b1%e4%ba%absession%e4%b8%80%e4%b8%aatomcat%e4%b8%a4%e4%b8%aa%e9%a1%b9%e7%9b%ae%e5%85%b1%e4%ba%absessionid.html"
---
{% raw %}
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

©Copyright 蕃薯耀 2017年7月12日

http://fanshuyao.iteye.com/

一个是2个项目，一个是web-session，一个是web。

为了让两个项目共享session（sessionId一样），需要修改tomcat/conf/server.xml。在两个项目的Context节点后分别加上

    sessionCookiePath="/"

，具体如下所示：

    <Context docBase="web-session" path="/web-session" reloadable="true" source="org.eclipse.jst.jee.server:web-session" sessionCookiePath="/"/>
    
    <Context docBase="web" path="/web" reloadable="true" source="org.eclipse.jst.jee.server:web" sessionCookiePath="/"/>

然后分别查看两个项目的2个不同的jsp显示sessionId，代码如下：

    <body>
    	<p>session.id如下：</p>
    	<p>${pageContext.session.id}</p>
    </body>

结果显示两个sessionId是一样的。

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

©Copyright 蕃薯耀 2017年7月12日

http://fanshuyao.iteye.com/
{% endraw %}
