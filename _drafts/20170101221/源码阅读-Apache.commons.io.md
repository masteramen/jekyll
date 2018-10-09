---
layout: post
title:  "源码阅读-Apache.commons.io"
title2:  "源码阅读-Apache.commons.io"
date:   2017-01-01 23:55:21  +0800
source:  "https://www.jfox.info/%e6%ba%90%e7%a0%81%e9%98%85%e8%af%bbapachecommonsio.html"
fileName:  "20170101221"
lang:  "zh_CN"
published: true
permalink: "2017/%e6%ba%90%e7%a0%81%e9%98%85%e8%af%bbapachecommonsio.html"
---
{% raw %}
本人现尝试去阅读一些源码，准备从Apache.commons入手。IO包花了一天的时间阅读。都是些工具类。但还是有些感悟，关于类的组织结构以及一些java语法的应用。内容较杂，用于本人自己记录和查阅。

1. 
 函数的参数、类的域大多都用 **final** 进行修饰。这意味着无法在方法中更改参数引用所指向的对象。这是一种保护变量的手段。 

2. 
 对于一些工具类，由于不需要任何配置，可直接调用，通过 **单例模式** 提供。若存在多种可能配置，则一个类里可提供多个单例模式，为每一种可能配置生成一个单例。 

3. 
 一些方法的开头进行了参数的合法性检查，有些方法又没有。 **疑问：什么时候需要对参数进行合法性检查**

4. 
 对 **comparator包** 的组织结构很感兴趣。AbstractFileComparator为抽象类，实现了Comparator接口，且sort方法使用this参数。AbstractFileComparator的子类，生成面向Comparator接口的单例模式。示例： 

    ((AbstractFileComparator) DefaultFileComparator.DEFAULT_REVERSE).sort(array);
    

该包的目的是为了构造各种比较器

分析比较器的相同点、不同点：

- 相同点：sort()方法；面向接口Compartor
- 不同点：compare()方法的实现

将相同部分提炼到一个类中，由于不完整，所以不用父类，而是抽象类，并设置包访问级别。

各比较器中实现面向Compartor的单例，通过sort()方法调用相应的单例。

5. 
 在 **filefilter包** 中接口IOFileFilter把接口FileFilter、FilenameFilter结合 

该包下的类面向接口IOFileFilter

抽象类AbstractFileFilter，为所有FileFilter的父类

FileFilterUtils集成了所有的FileFilter，可以只用一个该类的实例，完成许多文件筛选工作。
{% endraw %}
