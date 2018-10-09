---
layout: post
title:  "Eclipse中运行Tomcat遇到的内存溢出错误"
title2:  "Eclipse中运行Tomcat遇到的内存溢出错误"
date:   2017-01-01 23:56:16  +0800
source:  "https://www.jfox.info/eclipse%e4%b8%ad%e8%bf%90%e8%a1%8ctomcat%e9%81%87%e5%88%b0%e7%9a%84%e5%86%85%e5%ad%98%e6%ba%a2%e5%87%ba%e9%94%99%e8%af%af.html"
fileName:  "20170101276"
lang:  "zh_CN"
published: true
permalink: "2017/eclipse%e4%b8%ad%e8%bf%90%e8%a1%8ctomcat%e9%81%87%e5%88%b0%e7%9a%84%e5%86%85%e5%ad%98%e6%ba%a2%e5%87%ba%e9%94%99%e8%af%af.html"
---
{% raw %}
使用Eclipse(版本Indigo 3.7)调试Java项目的时候，遇到了下面的错误：

    Exception in thread “main” Java.lang.OutOfMemoryError: PermGen space
    at java.lang.ClassLoader.defineClass1(Native Method)
    at java.lang.ClassLoader.defineClassCond(Unknown Source)

很明显是内存溢出的错误，在Eclipse集成的Tomcat环境下，频繁进行热发布的时候会出现这个情况。了解到该原因是因为默认分配给JVM的内存为4M，而Eclipse中有BUG导致eclipse.ini中的参数无法传递给Tomcat，这样在项目加载内容较多时，很容易造成内存溢出。解决方案为增加JVM的内存空间。

有一点需要注意，因为使用的是Eclipse中集成的Tomcat，因此要在下面的界面中设置。

### 附主要的Eclipse版本代号及版本
{% endraw %}
