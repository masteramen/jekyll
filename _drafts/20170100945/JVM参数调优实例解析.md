---
layout: post
title:  "JVM参数调优实例解析"
title2:  "JVM参数调优实例解析"
date:   2017-01-01 23:50:45  +0800
source:  "https://www.jfox.info/jvm%e5%8f%82%e6%95%b0%e8%b0%83%e4%bc%98%e5%ae%9e%e4%be%8b%e8%a7%a3%e6%9e%90.html"
fileName:  "20170100945"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/jvm%e5%8f%82%e6%95%b0%e8%b0%83%e4%bc%98%e5%ae%9e%e4%be%8b%e8%a7%a3%e6%9e%90.html"
---
{% raw %}
H2M_LI_HEADER $JAVA_ARGS .= ” -Dresin.home=$SERVER_ROOT -server -Xms6000M -Xmx6000M -Xmn500M -XX:PermSize=500M 
H2M_LI_HEADER -XX:MaxPermSize=500M -XX:SurvivorRatio=65536 -XX:MaxTenuringThreshold=0 -Xnoclassgc -XX:+DisableExplicitGC 
H2M_LI_HEADER -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection 
H2M_LI_HEADER -XX:CMSFullGCsBeforeCompaction=0 -XX:+CMSClassUnloadingEnabled -XX:-CMSParallelRemarkEnabled 
H2M_LI_HEADER -XX:CMSInitiatingOccupancyFraction=90 -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+PrintClassHistogram 
H2M_LI_HEADER -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintHeapAtGC -Xloggc:log/gc.log “; 

说明一下，-XX:SurvivorRatio=65536 -XX:MaxTenuringThreshold=0就是去掉了救助空间：
◆-Xnoclassgc禁用类垃圾回收，性能会高一点； 
◆-XX:+DisableExplicitGC禁止System.gc()，免得程序员误调用gc方法影响性能； 
◆-XX:+UseParNewGC，对年轻代采用多线程并行回收，这样收得快；带CMS参数的都是和并发回收相关的。

**CMSInitiatingOccupancyFraction**

这个参数设置有很大技巧，基本上满足*(Xmx-Xmn)*(100-CMSInitiatingOccupancyFraction)/100>=Xmn*就不会出现promotion failed。在我的应用中Xmx是6000，Xmn是500，那么Xmx-Xmn是5500兆，也就是年老代有5500兆，CMSInitiatingOccupancyFraction=90说明年老代到90%满的时候开始执行对年老代的并发垃圾回收（CMS），这时还剩10%的空间是5500*10%=550兆，所以即使Xmn（也就是年轻代共500兆）里所有对象都搬到年老代里，550兆的空间也足够了，所以只要满足上面的公式，就不会出现垃圾回收时的Promotion Failed；

**SoftRefLRUPolicyMSPerMB**

这个参数我认为可能有点用，官方解释是softly reachable objects will remain alive for some amount of time after the last time they were referenced. The default value is one second of lifetime per free megabyte in the heap，我觉得没必要等1秒；

网上其他介绍JVM参数的也比较多，估计其中大部分是没有遇到Promotion Failed，或者访问量太小没有机会遇到，(Xmx-Xmn)*(100-CMSInitiatingOccupancyFraction)/100>=Xmn这个公式绝对是原创，真遇到Promotion Failed了，还得这么处理。
{% endraw %}
