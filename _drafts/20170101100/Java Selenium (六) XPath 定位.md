---
layout: post
title:  "Java Selenium (六) XPath 定位"
title2:  "Java Selenium (六) XPath 定位"
date:   2017-01-01 23:53:20  +0800
source:  "https://www.jfox.info/javaselenium%e5%85%adxpath%e5%ae%9a%e4%bd%8d.html"
fileName:  "20170101100"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/javaselenium%e5%85%adxpath%e5%ae%9a%e4%bd%8d.html"
---
{% raw %}
xpath 的定位方法， 非常强大。 使用这种方法几乎可以定位到页面上的任意元素。 

## 什么是xpath

xpath 是XML Path的简称， 由于HTML文档本身就是一个标准的XML页面，所以我们可以使用Xpath 的用法来定位页面元素。

## xpath定位的缺点

xpath 这种定位方式， webdriver会将整个页面的所有元素进行扫描以定位我们所需要的元素， 这是个非常费时的操作， 如果脚本中大量使用xpath做元素定位的话， 脚本的执行速度可能会稍慢

## testXpath.html 代码如下

    <html>
    <head><title>Test Xpath</title></head>
    <body>
        <div id="div1">
            <input name="div1input"></input>
            <a href="http://www.sogou.com">搜狗搜索</a>
            <img alt="div1-img1" src="http://www.sogou.com/images/logo/new/sogou.png" href="http://www.sogou.com">搜狗图片</img>
            <input type="button" value="查询"></input>
        </div>
        <br />
        <div name="div2">
            <input name="div2iniput" /></input>
            <a href="http://www.baidu.com">百度搜索</a>
            <img alt="div2-img2" src="http://www.baidu.comn/img/bdlogo.png" href="http:/www.baidu.com">百度图片</img>
        </div>
    </body>
    </html>

## 绝对路径定位方式

在被测试网页中， 查找第一个div标签中的按钮

XPath的表达式

    /html/body/div/input[@value="查询"]
    
    WebElement button = driver.findElement(By.xpath("/html/body/div/input[@value='查询']"));

## 使用浏览器调试工具，可以直接获取xpath语句

![](/wp-content/uploads/2017/07/1499268862.png)

## 绝对路径的缺点

1. 一旦页面结构发生改变，改路径也随之失效，必须重新。 所以不推荐使用绝对路径的写法

## 绝对路径和相对路径的区别

绝对路径 以 “/” 开头， 让xpath 从文档的根节点开始解析

相对路径 以”//” 开头， 让xpath 从文档的任何元素节点开始解析

## 相对路径定位方式

在被测试网页中，查找第一个div标签中的按钮

XPath的表达式

    //input[@value="查询"]
    
    WebElement button = driver.findElement(By.xpath("//input[@value='查询']"));

## 使用索引号定位

在被测试网页中， 查找第二个div标签中的”查询”按钮

    //input[2] 
    
    WebElement button = driver.findElement(By.xpath("//input[2]"));

## 使用页面属性定位

定位被测试页面中的第一个图片元素

    //img[@alt='div1-img1']
    
    WebElement button = driver.findElement(By.xpath("//img[@alt='div1-img1']"));

## 模煳定位starts-with关键字

查找图片alt属性开始位置包含’div1′关键字的元素

    //img[starts-with(@alt,'div')]

## 模煳定位contains关键字

查找图片alt属性包含’g1′关键字的元素

    //img[contains(@alt,'g1')]

## text() 函数 文本定位

查找所有文本为”百度搜索” 的元素

    driver.findElement(By.xpath("//*[text()='百度搜索']"));

查找所有文本为“搜索” 的超链接

    driver.findElement(By.xpath("//a[contains(text(),'搜索')]"));

## 附： selenium java教程 (连载中, 敬请期待）
{% endraw %}
