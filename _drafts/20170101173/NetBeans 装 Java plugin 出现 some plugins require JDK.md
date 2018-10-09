---
layout: post
title:  "NetBeans 装 Java plugin 出现 some plugins require JDK"
title2:  "NetBeans 装 Java plugin 出现 some plugins require JDK"
date:   2017-01-01 23:54:33  +0800
source:  "https://www.jfox.info/netbeans%e8%a3%85javaplugin%e5%87%ba%e7%8e%b0somepluginsrequirejdk.html"
fileName:  "20170101173"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/netbeans%e8%a3%85javaplugin%e5%87%ba%e7%8e%b0somepluginsrequirejdk.html"
---
{% raw %}
安装 NetBeans 时系统没 JDK、或 JDK版本太旧，

则安装 NetBeans 后，会使用 Java JRE 启动，而不是 JDK，

之后，若要再加安装 Java plugin 时，会出现“some plugins require JDK”信息。
![](/wp-content/uploads/2017/07/1499445161.png)
解决方是，先下载 Java SE JDK 安装：

[http://www.oracle.com/technetwork/java/javase/downloads/index.html](https://www.jfox.info/go.php?url=http://www.oracle.com/technetwork/java/javase/downloads/index.html)

安装完后，修改 NetBeans 设定档“netbeans.conf”，

设定档路径位置如：

    C:Program FilesNetBeans 8.2etcnetbeans.conf

找到 netbeans_jdkhome 设定的那一行，将路径改为已安装的 Java JDK 路径

    #netbeans_jdkhome="C:Program FilesNetBeans 8.2binjre"
    netbeans_jdkhome="C:Program FilesJavajdk1.8.0_131"

注：修改后若无法储存，文字编辑器可能须用系统管理员身分权限打开
{% endraw %}
