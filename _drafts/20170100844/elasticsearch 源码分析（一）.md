---
layout: post
title:  "elasticsearch 源码分析（一）"
title2:  "elasticsearch 源码分析（一）"
date:   2017-01-01 23:49:04  +0800
source:  "http://www.jfox.info/elasticsearch-yuan-ma-fen-xi-yi.html"
fileName:  "20170100844"
lang:  "zh_CN"
published: true
permalink: "elasticsearch-yuan-ma-fen-xi-yi.html"
---
{% raw %}
工作中经常使用es，所以想研究一下es的源码，常用的es版本为2.1.0，所以此系列以2.1.0为准

1、下载源码

 如果有报错，可以用根据报错下载相应的jar到本地的maven库里即可。

 等出现build success信息的时候代表成功了。
可以到core/target目录下看到elasticsearch-2.1.0-SNAPSHOT.jar。

 编译完成后转换成eclipse工程：

 进入本地elasticsearch-2.1.0/core目录下，执行mvn eclipse:eclipse

 同样会有很多报错，我遇到最多是找不到jar的解决方法是在/elasticserach-2.1.0下面对应的目录target里面去找。找到后拷贝到本地的maven repo对应的目录里面。

 编译成功会看到.classpath 和.project文件。

 把core 当做普通java 工程import就可以了

3、运行elasticsearch

 打开刚刚导入成功的工程：

 Run As—-Run Configution—Args
设置ProgramArgument 为 start
设置VMArgument为 -Des.path.home=..elasticsearch-2.1.0core #对应的目录，如果不可以，用绝对路径

 然后就可以运行。

 可能会有[WARN ][bootstrap ] unable to install syscall filter: syscall filtering not supported for OS的警告，不过可以忽略。

 最后在本地的localhost:9200可以看到运行成功
{% endraw %}
