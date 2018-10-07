---
layout: post
title:  "我的网站之struts2笔记2"
title2:  "我的网站之struts2笔记2"
date:   2017-01-01 23:59:57  +0800
source:  "http://www.jfox.info/%e6%88%91%e7%9a%84%e7%bd%91%e7%ab%99%e4%b9%8bstruts2%e7%ac%94%e8%ae%b02.html"
fileName:  "20170101497"
lang:  "zh_CN"
published: true
permalink: "%e6%88%91%e7%9a%84%e7%bd%91%e7%ab%99%e4%b9%8bstruts2%e7%ac%94%e8%ae%b02.html"
---
{% raw %}
作者[金字塔的蜗牛](/u/a8ae22295f18)2017.08.07 10:24*字数 842
越学习，越发现自己的无知。
（法国）笛卡尔

上一篇笔记总结了struts的版本、入门案例和相关的配置说明，链接：[我的网站之struts2笔记1](http://www.jfox.info/go.php?url=http://www.jianshu.com/p/a40a60ed4681)，这篇总结一下struts2中action配置的三种方式以及三种可用的类方法配置。

**1、struts2中action配置的三种方式**
 
    方式一： 创建普通类，不继承任何类，不实现任何接口，默认执行execute方法。如下图所示，action就是一个普通的类。如果想让类能够访问到，记得在struts.xml文件进行类的配置。 
   
   ![](/wp-content/uploads/2017/08/1502353878.png)  
   
  
    方式二：创建类，实现Action接口，大家知道实现一个接口，必须实现该接口中的方法，所以实现Action接口的类中需要实现execute()方法。 
   
   ![](/wp-content/uploads/2017/08/15023538781.png)  
   
  
    方式三：创建类，继承ActionSupport，之所以继承ActionSupport类成为一个action，是因为ActionSupport类也实现了方式二中的Action接口。 
   
   ![](/wp-content/uploads/2017/08/1502353879.png)
以上三种方式均可以创建一个action，一般建议使用第三种方式。

**2、struts2的action方法访问的三种方式**

方式一：使用action标签的method属性，在这个属性里配置执行action的方法，过程步骤如下。
`1：先创建一个action，然后在该action中创建多个方法。`
![](/wp-content/uploads/2017/08/15023538791.png)`2：进行struts.xml的配置，我们使用method方式进行配置，但是由于每个方法都需要配置，所以action方法很多的话，需要很多配置，这一点是个缺陷，我们可以在方式二中进行改进。`![](/wp-content/uploads/2017/08/1502353880.png)
方式二：使用通配符方式实现（**重点**）
我们可以在action中的name属性值里写 * 号代表任何配置，例如实现一本书的增删改查，我们可以用book_*代替：book_insert，book_update，book_delete。
其中{1}代表第一个星号内容，book_*中只有一个*号，所以*值就是方法名，如book_update就是访问update方法。
**当有多个星号，如我的代码库网站采用*_*的配置用来处理所有jsp页面的跳转，不执行任何业务逻辑，比如想访问resource文件夹下的index.jsp时，只需要浏览器访问resource_index即可进行跳转，如果想访问根目录的index.jsp文件，只需要输入（_index）即可，约定大于配置，使用起来很方便。**
![](/wp-content/uploads/2017/08/15023538801.png)  
   
  
    方式三：动态访问方式实现，这个使用不是很常见，帖一下我学习视频时截的图。通过在页面上按照一定的规则进行路径的配置，通过struts.xml的跳转，进入到指定的action中执行对应的方法。 
   
   ![](/wp-content/uploads/2017/08/1502353881.png)
这篇笔记总结了struts2中action书写的三种方式以及类方法配置的三种方式，一般建议通过继承ActionSupport来创建action，约定大于配置，推荐使用通配符方式实现方法的访问。下篇笔记将总结struts2中action获取页面表单提交的数据以及数据的处理封装。
{% endraw %}
