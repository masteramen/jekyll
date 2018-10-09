---
layout: post
title:  "在java中，将String类型字符串s赋值为null后，将字符串与其他字符串拼接后得到结果出现了null字符串与其他字符连接的样式"
title2:  "在java中，将String类型字符串s赋值为null后，将字符串与其他字符串拼接后得到结果出现了null字符串与其他字符连接的样式"
date:   2017-01-01 23:49:52  +0800
source:  "https://www.jfox.info/%e5%9c%a8java%e4%b8%ad-%e5%b0%86string%e7%b1%bb%e5%9e%8b%e5%ad%97%e7%ac%a6%e4%b8%b2s%e8%b5%8b%e5%80%bc%e4%b8%banull%e5%90%8e-%e5%b0%86%e5%ad%97%e7%ac%a6%e4%b8%b2%e4%b8%8e%e5%85%b6%e4%bb%96%e5%ad%97.html"
fileName:  "20170100892"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%9c%a8java%e4%b8%ad-%e5%b0%86string%e7%b1%bb%e5%9e%8b%e5%ad%97%e7%ac%a6%e4%b8%b2s%e8%b5%8b%e5%80%bc%e4%b8%banull%e5%90%8e-%e5%b0%86%e5%ad%97%e7%ac%a6%e4%b8%b2%e4%b8%8e%e5%85%b6%e4%bb%96%e5%ad%97.html"
---
{% raw %}
String s = null;

s += “hello”;

System.out.println(s);

结果为：nullhello

原因：

先应用String.valueOf 得出s的value值，再通过StringBuilder拼接hello，因此将value与hello进行了拼接；

String s = null;
s = (new StringBuilder(String.valueOf(s))).append(“hello”).toString();
System.out.println(s);
{% endraw %}
