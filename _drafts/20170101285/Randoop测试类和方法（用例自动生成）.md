---
layout: post
title:  "Randoop测试类和方法（用例自动生成）"
title2:  "Randoop测试类和方法（用例自动生成）"
date:   2017-01-01 23:56:25  +0800
source:  "https://www.jfox.info/randoop%e6%b5%8b%e8%af%95%e7%b1%bb%e5%92%8c%e6%96%b9%e6%b3%95%e7%94%a8%e4%be%8b%e8%87%aa%e5%8a%a8%e7%94%9f%e6%88%90.html"
fileName:  "20170101285"
lang:  "zh_CN"
published: true
permalink: "2017/randoop%e6%b5%8b%e8%af%95%e7%b1%bb%e5%92%8c%e6%96%b9%e6%b3%95%e7%94%a8%e4%be%8b%e8%87%aa%e5%8a%a8%e7%94%9f%e6%88%90.html"
---
{% raw %}
详细使用方法见randoop官网：　　https://randoop.github.io/randoop/manual/index.html　　

测试程序之前，先检测下你的Randoop是否配置好：

打开cmd，输入命令　　java -ea -classpath %RANDOOP_JAR% randoop.main.Main help　　

**用randoop测试java类：**

**比如**测试一个Triangle.java程序（代码见本人软件测试assertEquals的博客），首先提取出Triangle.class，然后创建一个txt文件命名为myclasses.txt，文件内容为测试的类名（仅是类名，无后缀），都放在同一个目录下，比如放在E:test文件夹内。

测试开始：在cmd输入命令　　java -classpath .;%RANDOOP_JAR%  randoop.main.Main  gentests  –classlist=myclasses.txt  –timelimit=6

　　　　▲1‘　　输入命令的路径为防止class和txt文件的路径

　　　　　2’　　classpath是一个横杠，后面classlist和timelimit是两个横杠

　　　　　3‘　　classlist后面是包含要测试类名的txt文件名，timelimit是测试运行时间限制

　　　　　4’　　cmd切换目录的方法：磁盘的切换直接输入 E：即可，若要进入某个文件夹，逐次输入  cd   foldername

若是运行成功，会在当前目录下出现两个测试结果的java文件。

▲有时候运行该命令到会出现如下错误：

问题出在jdk的问题，解决方法：

　　cmd输入　　java  -version　　　查看jdk版本；然后在环境变量设置里查看JAVA_HOME和Path里面的jdk版本，不一样的话，就是jdk冲突问题，在path和classpath里面讲java的路径提到最前面，将JAVA_HOME的路径加上英文双引号；然后确定后重启运行上述命令。若是还是未解决，则在c盘windows该目录下C:WindowsSystem32  搜索java，删掉java的相关文件即可。

用Randoop测试类的方法：

　　同上述同一个目录下，先删去生成的两个测试类的java文件，新建mymethod.txt文件放置类名和方法名（如图以Triangle为例），格式如下：

cons:类名.<init>(类型1，类型2…..)

method：类名.方法名（类型1，类型2…..）

method：类名.方法名（类型1，类型2…..）

method：类名.方法名（类型1，类型2…..）

运用classlist和methodlist命令测试。

 创建好后，在cmd输入命令　　java -classpath .;%RANDOOP_JAR%  randoop.main.Main  gentests  –classlist=myclasses.txt  –methodlist=mymethods.txt –timelimit=6

运行成功后在当前目录下会生成两个名字同第一个测试相同的java文件，不过内容不一样。
{% endraw %}
