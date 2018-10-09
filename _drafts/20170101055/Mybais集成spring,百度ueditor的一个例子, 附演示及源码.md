---
layout: post
title:  "Mybais集成spring,百度ueditor的一个例子, 附演示及源码"
title2:  "Mybais集成spring,百度ueditor的一个例子, 附演示及源码"
date:   2017-01-01 23:52:35  +0800
source:  "https://www.jfox.info/mybais%e9%9b%86%e6%88%90spring%e7%99%be%e5%ba%a6ueditor%e7%9a%84%e4%b8%80%e4%b8%aa%e4%be%8b%e5%ad%90%e9%99%84%e6%bc%94%e7%a4%ba%e5%8f%8a%e6%ba%90%e7%a0%81.html"
fileName:  "20170101055"
lang:  "zh_CN"
published: true
permalink: "2017/mybais%e9%9b%86%e6%88%90spring%e7%99%be%e5%ba%a6ueditor%e7%9a%84%e4%b8%80%e4%b8%aa%e4%be%8b%e5%ad%90%e9%99%84%e6%bc%94%e7%a4%ba%e5%8f%8a%e6%ba%90%e7%a0%81.html"
---
{% raw %}
关于mybatis的例子已经是好几年前写的了，依然有不少朋友在用，同时这些例子只是记录我当初测试的情况，所以在很多朋友的机器上未必能跑起来，当然也有细心的朋友，纠正错误，跑起来了的。以前写的例子，都是单独的知识点。今天我打算放一个算一个mybatis 综合应用的小例子。整个工程采用 maven 构建。若是没兴趣看以前写的那些博客的朋友，可以直接看这个例子就行了，虽然也比较老，也是几年前弄得了，参考价值也还是有的。演示地址： 
[ http://www.yihaomen.com:8080/mybatis/login ](https://www.jfox.info/go.php?url=http://www.yihaomen.com:8080/mybatis/login)
 ,先放几张图: 

 登录的图。 

![](/wp-content/uploads/2017/07/1499179309.png)
 列表界面： 

![](/wp-content/uploads/2017/07/1499179313.png)
 与百度ueditor集成，富文本编辑器，上传等处理. 

![](/wp-content/uploads/2017/07/1499179316.png)
 这是一个比较完整的mybatis 例子了，可以借鉴参考。 

 注意事项： 

 1. 仅供学习使用了。 

 2. 文件上传并显示的时候，我配置了一个静态资源URL，其实也就是当前网站上传目录了，毕竟是测试用的。 

 3. 百度 ueditor可能有点老，毕竟是几年前的，我是下载的源码，自己修改了下。
{% endraw %}
