---
layout: post
title:  "Java Selenium (四) 使用浏览器调试工具"
title2:  "Java Selenium (四) 使用浏览器调试工具"
date:   2017-01-01 23:52:58  +0800
source:  "https://www.jfox.info/javaselenium%e5%9b%9b%e4%bd%bf%e7%94%a8%e6%b5%8f%e8%a7%88%e5%99%a8%e8%b0%83%e8%af%95%e5%b7%a5%e5%85%b7.html"
fileName:  "20170101078"
lang:  "zh_CN"
published: true
permalink: "2017/javaselenium%e5%9b%9b%e4%bd%bf%e7%94%a8%e6%b5%8f%e8%a7%88%e5%99%a8%e8%b0%83%e8%af%95%e5%b7%a5%e5%85%b7.html"
---
{% raw %}
在基于UI元素的自动化测试中, 无论是桌面的UI自动化测试,还是Web的UI自动化测试. 首先我们需要查找和识别UI元素.

在基于Web UI 自动化测试中, 测试人员需要了解HTML, CSS和Javascript的一些知识, 还需要学会使用各种浏览器的调试功能

查找Web UI 页面上的元素, 必须先了解页面的DOM结构, 元素的属性, 甚至一些JavaScript的调用信息. 现在主流的浏览器都自带了很多强有力的工具

## Google Chrome

Google Chrome 自带Web开发调试工具, 可以通过3种方法启动此工具

**方法一**:　　按F12快捷键

**方法二**:　　点击右上角的图标->More tools->Developer Tools 菜单命令, 打开Developer Tools , 然后点击”箭头”图标, 然后选择你要查找的元素. 请看下面动画演示

![](/wp-content/uploads/2017/07/1499268858.gif)

**方法三**:　　鼠标放在你想要的UI元素上，单击鼠标右键，　选择Inspect Element菜单命令

![](/wp-content/uploads/2017/07/1499268861.gif)

我们还可以使用Chrome 来直接获取元素的XPath.

![](/wp-content/uploads/2017/07/1499268862.png)

## Internet Explorer 或者Edge

微软自己出品的浏览器同样带有”开发人员工具”, 通过工具菜单,或者F12来 启动

![](/wp-content/uploads/2017/07/1499268863.png)

## Firefox 的firebug插件

Firefox 是selenium 支持的最好的浏览器, 推荐在Firefox 中安装Firebug 插件. 使用firebug 也很方便的查找页面元素

firebug的调用方法, 跟上面Chrome 的调试工具 使用方法一模一样. 这里就不详细解释了

![](/wp-content/uploads/2017/07/1499268866.gif)

## 利用FireFinder 插件， 来测试XPath 语句

在自动化测试中，我们经常要写XPath, 我们可以通过FireFinder 插件来验证我们写的xpath语句是否正确

![](/wp-content/uploads/2017/07/1499268867.gif)

## 附： selenium java教程 (连载中, 敬请期待）
{% endraw %}
