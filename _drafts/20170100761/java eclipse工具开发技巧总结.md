---
layout: post
title:  "java eclipse工具开发技巧总结"
title2:  "java eclipse工具开发技巧总结"
date:   2017-01-01 23:47:41  +0800
source:  "http://www.jfox.info/java-eclipse-gong-ju-kai-fa-ji-qiao-zong-jie.html"
fileName:  "20170100761"
lang:  "zh_CN"
published: true
permalink: "java-eclipse-gong-ju-kai-fa-ji-qiao-zong-jie.html"
---
{% raw %}
习惯了eclipse开发java程序，公司最近的项目都是idea开发的，同时android studio也是idea原型开发的，在学android开发，所以脱离eclipse转向idea看来是一个趋势了。

开发工具的使用就是一个习惯的问题， 习惯了开发效率就高，不习惯工具使用问题，还得去百度。培养新习惯最终的目的就是忘掉旧习惯，当然，凡事都不绝对，只是有可能在长时间不使用eclipse后，会忘掉其中的使用技巧，快捷键等。所以，为了防止旧习惯完全被忘掉，这里总结一份我在开发过程中常用的eclipse或myeclipse的使用技巧。

## 一、快捷键

1、提示：Alt+/

2、格式化：ctrl+shift+f

3、输入一对的符号，如””，()，会自动补全，输入后跳出:tab

4、查找某个方法被谁调用：选中方法名，ctrl+shift+g

5、查看某个类的继承关系：选中该类，ctrl+t

6、通过文件名称查找类或文件：ctrl+shift+r

7、alt+上/下，移动当前行到上或下

8、ctrl+alt+上/下，复制当前行到上或下

9、注释：ctrl+/行注释、shift+ctrl+/块注释

10、方法或者类名上部输入：/**然后回车，会自动生成文档注释

11、ctrl+d删除当前行

12、选中方法名，点击F2，提示方法信息

13、提示错误等

## 二、设置

1、快捷键添加set、get方法，重写或实现接口的某个方法：shift+alt+s

![](/wp-content/uploads/2015/05/c097423c12f34cb054704397544f9517.png.png)

2、版本控制：项目名或文件名，右键

![](/wp-content/uploads/2015/05/c7b3546fc13a67ef8bb29ec27cf3784f.png.png)

点击文件名，右键->team->show history：

![](/wp-content/uploads/2015/05/eff584f9dc917304662fa7e3ea6dc070.png.png)

版本控制update出现错误时，可以通过compare with，对左侧的当前本地版本文件进行修改，修改后保证自己的代码存在，且其他代码和服务器上的相同即可。对于完全需要被覆盖的，使用get contents即可。

3、maven

maven设置![](/wp-content/uploads/2015/05/55288742d3fa3ab4b749cf8d24678ac3.png.png)

maven使用：

![](/wp-content/uploads/2015/05/1e3e3a7bbb274d77f5f8e6ae01d8a032.png.png)

update dependencise可以更新jar包依赖

maven添加依赖：

![](/wp-content/uploads/2015/05/87e06c1d9acf58ef183a7b47d67d038d.png.png)

输入jar包的名称，会自动给你检索

reindexmaven库中的jar包

![](/wp-content/uploads/2015/05/a72bfc77922ab127f1251296a8c83df5.png.png)

4、设置字体

![](/wp-content/uploads/2015/05/fc097f3ea9e03549dc1ac0a5e659a948.png.png)

5、设置整个工具的编码

![](/wp-content/uploads/2015/05/181ea30fbf4bd33061834c4d77f0a8b0.png.png)

6、配置项目输出文件地址、添加本地jar包等

![](/wp-content/uploads/2015/05/2094eb11dcd477191726cd08532a7868.png.png)

configure build path

![](/wp-content/uploads/2015/05/8cded66664d53232a0157383278926ce.png.png)

7、自动编译

![](/wp-content/uploads/2015/05/515e0a47718a6e95693a9b36f42f9cfb.png.png)

8、junit-test

我觉得这点比idea好用，可以直接选中要测试的方法名，右击run as即可

![](/wp-content/uploads/2015/05/06288d4f718dcc082e3f820b8f64b2be.png.png)
{% endraw %}
