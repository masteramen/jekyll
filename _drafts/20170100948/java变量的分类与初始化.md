---
layout: post
title:  "java变量的分类与初始化"
title2:  "java变量的分类与初始化"
date:   2017-01-01 23:50:48  +0800
source:  "http://www.jfox.info/java%e5%8f%98%e9%87%8f%e7%9a%84%e5%88%86%e7%b1%bb%e4%b8%8e%e5%88%9d%e5%a7%8b%e5%8c%96.html"
fileName:  "20170100948"
lang:  "zh_CN"
published: true
permalink: "java%e5%8f%98%e9%87%8f%e7%9a%84%e5%88%86%e7%b1%bb%e4%b8%8e%e5%88%9d%e5%a7%8b%e5%8c%96.html"
---
{% raw %}
2017/6/25

首先学习java最权威的就是官方的文档了，今天从头读了文档，把一些小细节理清楚。

## 变量

Java语言里的变量分以下4类：

1. Instance Variables: (Non-Static Fields) 就是类里非静态的field

2. Class Variables: (Static Fields) 类里静态的field

3. Local Variables: 局部变量

4. Parameters: 参数

两个术语要注意，分别是field和variable。field是指上面的1和2，是class拥有的。而不是field的变量就叫variable，对应上面的3和4，或者说局部的都是variable。

## 命名

Java的文档中明确写了推荐的命名方式，这就是为什么java的代码里命名基本都差不多。格式就是用连续的有意义的单词，从第二个单词开始，首字母大写。比如： speed, currentGear

## 基本数据类型 Primitive Data Type

Java有8个基本数据类型

整数型 4个： byte, short, int, long

浮点 2个： float, double

字符 1个： char

布尔 1个： boolean

他们的默认初始值如下：
{% endraw %}
