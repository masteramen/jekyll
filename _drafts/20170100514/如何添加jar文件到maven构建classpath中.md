---
layout: post
title:  "如何添加jar文件到maven构建classpath中"
title2:  "如何添加jar文件到maven构建classpath中"
date:   2017-01-01 23:43:34  +0800
source:  "http://www.jfox.info/ru-he-tian-jia-jar-wen-jian-dao-maven-gou-jian-classpath-zhong.html"
fileName:  "20170100514"
lang:  "zh_CN"
published: true
permalink: "ru-he-tian-jia-jar-wen-jian-dao-maven-gou-jian-classpath-zhong.html"
---
{% raw %}
By Lee - Last updated: 星期六, 二月 1, 2014

添加JAR文件到构建类路径，但不安装到本地或远程存储库

<dependency>

<groupId>doesntMatter</groupId>
<artifactId>doesntMatter</artifactId>
<version>doesntMatter</version>
<scope>system</scope>
<systemPath>${basedir}/lib/test-1.0-SNAPSHOT.jar</systemPath>
</dependency>
{% endraw %}
