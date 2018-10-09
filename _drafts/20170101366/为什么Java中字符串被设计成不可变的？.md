---
layout: post
title:  "为什么Java中字符串被设计成不可变的？"
title2:  "为什么Java中字符串被设计成不可变的？"
date:   2017-01-01 23:57:46  +0800
source:  "https://www.jfox.info/%e4%b8%ba%e4%bb%80%e4%b9%88java%e4%b8%ad%e5%ad%97%e7%ac%a6%e4%b8%b2%e8%a2%ab%e8%ae%be%e8%ae%a1%e6%88%90%e4%b8%8d%e5%8f%af%e5%8f%98%e7%9a%84.html"
fileName:  "20170101366"
lang:  "zh_CN"
published: true
permalink: "2017/%e4%b8%ba%e4%bb%80%e4%b9%88java%e4%b8%ad%e5%ad%97%e7%ac%a6%e4%b8%b2%e8%a2%ab%e8%ae%be%e8%ae%a1%e6%88%90%e4%b8%8d%e5%8f%af%e5%8f%98%e7%9a%84.html"
---
{% raw %}
String是Java中一个不可变的类，所以他一旦被实例化就无法被修改。不可变类的实例一旦创建，其成员变量的值就不能被修改。不可变类有很多优势。本文总结了为什么字符串被设计成不可变的。

    public final class String implements java.io.Serializable, Comparable<String>, CharSequence{....}

String 类被final关键字修饰

一，字符串池

字符串池是方法区中的一部分特殊存储。当一个字符串被被创建的时候，首先会去这个字符串池中查找，如果找到，直接返回对该字符串的引用。

下面的代码只会在堆中创建一个字符串

    String str1=new String("aa");
    String str2=new String("aa");

![](/wp-content/uploads/2017/07/1500290109.png)

#### 如果字符串可变的话，当两个引用指向指向同一个字符串时，对其中一个做修改就会影响另外一个。

二，缓存Hashcode

Java中经常会用到字符串的哈希码（hashcode）。例如，在HashMap中，字符串的不可变能保证其hashcode永远保持一致，这样就可以避免一些不必要的麻烦。这也就意味着每次在使用一个字符串的hashcode的时候不用重新计算一次，这样更加高效。

在String类中，有以下代码：

    /** Cache the hash code for the string */
        private int hash; // Default to 0

以上代码中hash变量中就保存了一个String对象的hashcode，因为String类不可变，所以一旦对象被创建，该hash值也无法改变。所以，每次想要使用该对象的hashcode的时候，直接返回即可。

三，使其他类的使用更加便利

    public static void main(String[] args) {
            HashSet<String> set = new HashSet<String>();
            set.add(new String("a"));
            set.add(new String("b"));
            set.add(new String("c"));
            for(String a: set){
            a.value = "a";}//The field String.value is not visible
        }

程序报错：The field String.value is not visible

 在上面的例子中，如果字符串可以被改变，那么以上用法将有可能违反Set的设计原则，因为Set要求其中的元素不可以重复。上面的代码只是为了简单说明该问题，其实String类中并没有value这个字段值。 

四，安全性

 String被广泛的使用在其他Java类中充当参数。比如网络连接、打开文件等操作。如果字符串可变，那么类似操作可能导致安全问题。因为某个方法在调用连接操作的时候，他认为会连接到某台机器，但是实际上并没有（其他引用同一String对象的值修改会导致该连接中的字符串内容被修改）。可变的字符串也可能导致反射的安全问题，因为他的参数也是字符串。 

五，不可变对象天生就是线程安全的

 因为不可变对象不能被改变，所以他们可以自由地在多个线程之间共享。不需要任何同步处理。 

总之，String被设计成不可变的主要目的是为了安全和高效。所以，使String是一个不可变类是一个很好的设计。
{% endraw %}
