---
layout: post
title:  "Maven转化为Dynamic Web Module"
title2:  "Maven转化为Dynamic Web Module"
date:   2017-01-01 23:51:23  +0800
source:  "https://www.jfox.info/maven%e8%bd%ac%e5%8c%96%e4%b8%badynamic-web-module.html"
fileName:  "20170100983"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/maven%e8%bd%ac%e5%8c%96%e4%b8%badynamic-web-module.html"
---
{% raw %}
如今Maven仍然是最常用的项目管理工具，若要将Java Web项目使用Maven进行管理，则首先需要新建Maven项目，然后将其转化为web项目。

在项目右键选择properties，然后点击左侧Project Facets，勾选Dynamic Web Module，点击Apply–>OK即可。理想情况应该可以在项目下出现WebContent目录。如果没有的话，首先回到Project Facets界面，将Dynamic Web Module取消勾选，点击Apply。然后重新勾选，下方会出现“further configuration available”的链接，点击进入，勾选生成web.xml文件即可。

WebContent生成之后将其下两个文件夹剪切到src/main/webapp下，将WebContent删除。

右击项目，选择 `properties`，选择`Deployment Assembly。选择`WebContent`，并将它`remove`掉。接着重新指定一个web路径，点击`Add`，选择`Folder`，点击Next。在`src/main`下找到`webapp`目录，点击Finish。继续点击`Add`，选择`Java Build Path Entries`。将当前`build path`指向`Maven Dependency`。点击Apply和OK。`
{% endraw %}
