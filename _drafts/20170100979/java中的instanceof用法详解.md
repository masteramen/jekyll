---
layout: post
title:  "java中的instanceof用法详解"
title2:  "java中的instanceof用法详解"
date:   2017-01-01 23:51:19  +0800
source:  "https://www.jfox.info/java%e4%b8%ad%e7%9a%84instanceof%e7%94%a8%e6%b3%95%e8%af%a6%e8%a7%a3.html"
fileName:  "20170100979"
lang:  "zh_CN"
published: true
permalink: "2017/java%e4%b8%ad%e7%9a%84instanceof%e7%94%a8%e6%b3%95%e8%af%a6%e8%a7%a3.html"
---
{% raw %}
instanceof是Java的一个二元操作符（运算符）,也是Java的保留关键字。它的作用是判断其左边对象是否为其右边类的实例，返回的是boolean类型的数据。用它来判断某个对象是否是某个Class类的实例。

用法：

　　boolean result = object instanceof class

参数：

　　result ：boolean类型。

　　object ：必选项。任意对象表达式。

　　class：必选项。任意已定义的对象类。

说明：

　　如果该object 是该class的一个实例，那么返回true。如果该object 不是该class的一个实例，或者object是null，则返回false。

例子：

 

  　　package com.instanceoftest; 
 

  　　interface A { } 
 

  　　class B implements A { } //B是A的实现 
 

  　　class C extends B { } //C继承B 
 

  　　class D { } 
 

  　　class instanceoftest { 
 

  　　　　public static void main(String[] args) { 
 

  　　　　　　A a = null; 
 

  　　　　　　B b = null; 
 

  　　　　　　boolean res; 
 

  　　　　　　System.out.println(“instanceoftest test case 1: ——————“); 
 

  　　　　　　res = a instanceof A; 
 

  　　　　　　System.out.println(“a instanceof A: ” + res); // a instanceof A:false 
 

　　　　　　res = b instanceof B; 
 

　　　　　　System.out.println(“b instanceof B: ” + res); // b instanceof B: false 
 

  　　　　　　System.out.println(“ninstanceoftest test case 2: ——————“); 
 

  　　　　　　a = new B(); 
 

  　　　　　　b = new B(); 
 

  　　　　　　res = a instanceof A; 
 

  　　　　　　System.out.println(“a instanceof A: ” + res); // a instanceof A:true 
 

  　　　　　　res = a instanceof B; 
 

  　　　　　　System.out.println(“a instanceof B: ” + res); // a instanceof B:true 
 

  　　　　　　res = b instanceof A; 
 

  　　　　　　System.out.println(“b instanceof A: ” + res); // b instanceof A:true 
 

  　　　　　　res = b instanceof B; 
 

  　　　　　　System.out.println(“b instanceof B: ” + res); // b instanceof B:true 
 

  　　　　　　System.out.println(“ninstanceoftest test case 3: ——————“); 
 

  　　　　　　B b2 = new C(); 
 

  　　　　　　res = b2 instanceof A; 
 

  　　　　　　System.out.println(“b2 instanceof A: ” + res); // b2 instanceof A:true 
 

  　　　　　　res = b2 instanceof B; 
 

  　　　　　　System.out.println(“b2 instanceof B: ” + res); // b2 instanceof A:true 
 

  　　　　　　res = b2 instanceof C; 
 

  　　　　　　System.out.println(“b2 instanceof C: ” + res); // b2 instanceof A:true 
 

  　　　　　　 
 
   　　　　　　System.out.println(“ninstanceoftest test case 4: ——————“); 
  
 
   　　　　　　D d = new D(); 
  
 
   　　　　　　res = d instanceof A; 
  
 
   　　　　　　System.out.println(“d instanceof A: ” + res); // d instanceof A:false 
  
 
   　　　　　　res = d instanceof B; 
  
 
   　　　　　　System.out.println(“d instanceof B: ” + res); // d instanceof B:false 
  

 
  
    　　　　　　res = d instanceof C; 
   
  
    　　　　　　System.out.println(“d instanceof C: ” + res); // d instanceof C:false 
   
 
   
     　　　　　　res = d instanceof D; 
    
   
     　　　　　　System.out.println(“d instanceof D: ” + res); // d instanceof D:true
{% endraw %}
