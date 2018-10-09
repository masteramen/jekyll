---
layout: post
title:  "Java xml 操作(Dom4J修改xml   + xPath技术  + SAX解析 + XML约束)"
title2:  "Java xml 操作(Dom4J修改xml   + xPath技术  + SAX解析 + XML约束)"
date:   2017-01-01 23:50:15  +0800
source:  "https://www.jfox.info/java-xml-%e6%93%8d%e4%bd%9c-dom4j%e4%bf%ae%e6%94%b9xml-xpath%e6%8a%80%e6%9c%af-sax%e8%a7%a3%e6%9e%90-xml%e7%ba%a6%e6%9d%9f.html"
fileName:  "20170100915"
lang:  "zh_CN"
published: true
permalink: "2017/java-xml-%e6%93%8d%e4%bd%9c-dom4j%e4%bf%ae%e6%94%b9xml-xpath%e6%8a%80%e6%9c%af-sax%e8%a7%a3%e6%9e%90-xml%e7%ba%a6%e6%9d%9f.html"
---
{% raw %}
# Java xml 操作(Dom4J修改xml   + xPath技术  + SAX解析 + XML约束) 


1 XML基础

1）XML的作用

1.1 作为软件配置文件

1.2 作为小型的“数据库”

2）XML语法（由w3c组织规定的）

标签：

标签名不能以数字开头，中间不能有空格，区分大小写。有且仅有一个根标签。

属性：

可有多个属性，但属性值必须用引号（单引号或双引号）包含，但不能省略，也不能单双混用。

文档声明：

<?xml version=”1.0″ encoding=”utf-8″?>

encoding=”utf-8″：　打开或解析xml文档时的编码

注意：

保存xml文档时的编码 和 解析xml文档时的编码要保持一致，才能避免中文乱码问题！

3）XML解析

程序读取或操作xml文档

两种解析方式： DOM解析 vs SAX解析

DOM解析原理：一次性把xml文档加载成Document树，通过Document对象得到节点对象，通过节点对象访问xml文档内容（标签，属性，文本，注释）。

Dom4j工具（基于DOM解析原理）：

读取xml文档：

 Document doc = new SAXReader().read(“xml文件“); 

节点：

nodeIterator(); 所有节点

标签：

element(“名称“) 指定名称的第一个子标签对象

elementIterator(“名称“); 指定名称的所有子标签对象

elements(); 所有子标签对象

属性：

attributeValue（“名称”） 指定名称的属性值

attribute(“名称“) 指定名称的属性对象

getName() 属性名称

getValue（） 属性值

atributeIterator() 所有属性对象（Iterator）

attributes() 所有属性对象（List）

文本：

getText（） 得到当前标签的文本

elementText(“子标签名称“) 得到子标签的文本

# **2 Dom4j修改xml文档**

## **2.1 写出内容到xml文档**

XMLWriter writer = new XMLWriter(OutputStream, OutputForamt)

wirter.write(Document);

## **2.2 修改xml文档的API**

增加：

DocumentHelper.createDocument() 增加文档

addElement(“名称“) 增加标签

addAttribute(“名称“，“值”) 增加属性

修改：

Attribute.setValue(“值“) 修改属性值

Element.addAtribute(“同名的属性名“,”值“) 修改同名的属性值

Element.setText(“内容“) 修改文本内容

删除

Element.detach(); 删除标签

Attribute.detach(); 删除属性

# **3 xPath技术 **

## **3.1 引入**

问题：当使用dom4j查询比较深的层次结构的节点（标签，属性，文本），比较麻烦！！！

## **3.2 xPath作用**

主要是用于快速获取所需的节点对象。

## **3.3 在dom4j中如何使用xPath技术**

1）导入xPath支持jar包 。 jaxen-1.1-beta-6.jar

2）使用xpath方法

List<Node> selectNodes(“xpath表达式“); 查询多个节点对象

Node selectSingleNode(“xpath表达式“); 查询一个节点对象

## **3.4 xPath语法**

/ 绝对路径 表示从xml的根位置开始或子元素（一个层次结构）

// 相对路径 表示不分任何层次结构的选择元素。

* 通配符 表示匹配所有元素

[] 条件 表示选择什么条件下的元素

@ 属性 表示选择属性节点

and 关系表示条件的与关系（等价于&&）

text() 文本 表示选择文本内容

# **4 SAX解析**

## **4.1回顾DOM解析**

DOM解析原理：一次性把xml文档加载进内存，然后在内存中构建Document树。

对内存要求比较要。

缺点：不适合读取大容量的xml文件，容易导致内存溢出。

SAX解析原理： 加载一点，读取一点，处理一点。对内存要求比较低。

## **4.2 SAX解析工具**

SAX解析工具– Sun公司提供的。内置在jdk中。org.xml.sax.*

核心的API：

 SAXParser类： 用于读取和解析xml文件对象

parse（[File](File) f, [DefaultHandler](DefaultHandler) dh）方法：解析xml文件

参数一： File：表示 读取的xml文件。

参数二： DefaultHandler： SAX事件处理程序。使用DefaultHandler的子类

例如：｛

 1.创建SAXParser对象 

 SAXParser parser=SAXParserFactory.*newInstance*().newSAXParser();

 2.调用parse方法

parser.parse(**new** File(“./src/contact.xml”), **new** MyDefaultHandler());

｝ [一个类继承class 类名（**extends** DefaultHandler）在调用是创建传进去

DefaultHandler类的API:

void startDocument() : 在读到文档开始时调用

void endDocument() ：在读到文档结束时调用

void startElement(String uri, String localName, String qName, Attributes attributes) ：读到开始标签时调用

void endElement(String uri, String localName, String qName) ：读到结束标签时调用

void characters(char[] ch, int start, int length) ：读到文本内容时调用

**============DOM解析 vs SAX解析****========**

**DOM解析**

**SAX解析**

原理： 一次性加载xml文档，不适合大容量的文件读取

原理： 加载一点，读取一点，处理一点。适合大容量文件的读取

DOM解析可以任意进行增删改成

SAX解析只能读取

DOM解析任意读取任何位置的数据，甚至往回读

SAX解析只能从上往下，按顺序读取，不能往回读

DOM解析面向对象的编程方法（Node，Element，Attribute）,Java开发者编码比较简单。

SAX解析基于事件的编程方法。java开发编码相对复杂。

总结：

1）Dom4j修改xml文档

 new XMLWrier();

……

2）xPath技术： 快速查询xml节点

selectNodes()

selectSinglNode();

xpath表达式语言

3) SAX解析

SAXParser parse

parser（）

DefaultHandler类：

startElement();

characters();

endElement();
{% endraw %}
