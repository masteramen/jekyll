---
layout: post
title:  "instanceof 面试"
title2:  "instanceof 面试"
date:   2017-01-01 23:42:02  +0800
source:  "http://www.jfox.info/instanceof-mian-shi.html"
fileName:  "20170100422"
lang:  "zh_CN"
published: true
permalink: "instanceof-mian-shi.html"
---
{% raw %}
By Lee - Last updated: 星期四, 六月 6, 2013

### instanceof是判断一个对象的引用(reference) 是否某一类型的面试题目。

Integer i = new Integer(0);
System.out.println( i instanceof Integer);
返回为true，因为i是一个Integer的对象的引用。
Integer i = new Integer(0);
System.out.println( i instanceof Long);
则返回为false, 因为i不是一个Long的对象的引用。
但是，
Integer i = null;
System.out.println( i instanceof Integer);
返回值为false. 这是因为i的值为null, null不是任何对象的引用。
{% endraw %}
