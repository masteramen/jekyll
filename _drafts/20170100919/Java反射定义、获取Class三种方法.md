---
layout: post
title:  "Java反射定义、获取Class三种方法"
title2:  "Java反射定义、获取Class三种方法"
date:   2017-01-01 23:50:19  +0800
source:  "https://www.jfox.info/java%e5%8f%8d%e5%b0%84%e5%ae%9a%e4%b9%89-%e8%8e%b7%e5%8f%96class%e4%b8%89%e7%a7%8d%e6%96%b9%e6%b3%95.html"
fileName:  "20170100919"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e5%8f%8d%e5%b0%84%e5%ae%9a%e4%b9%89-%e8%8e%b7%e5%8f%96class%e4%b8%89%e7%a7%8d%e6%96%b9%e6%b3%95.html"
---
{% raw %}
反射机制的定义：

　　在运行状态时(动态的)，对于任意一个类，都能够得到这个类的所有属性和方法。

　　　　　　　　　　　　 对于任意一个对象，都能够调用它的任意属性和方法。

　　Class类是反射机制的起源，我们得到Class类对象有3种方法：

　　第一种：通过类名获得

　　Class<?> class = ClassName.class;

　　第二种：通过类名全路径获得：

　　Class<?> class = Class.forName(“类名全路径”);

　　第三种：通过实例对象获得：

　　Class<?> class = object.getClass();

　　通过代码总结三种方法的区别：

     1/** 2 * Created by hunt on 2017/6/23.
     3*/ 4 5/** 6 * 测试类
     7*/ 8publicclass ClassTest {
     9static{
    10         System.out.println("静态代码块儿...");
    11    }
    12    {
    13         System.out.println("动态构造块儿...");
    14    }
    15public ClassTest(){
    16         System.out.println("构造方法...");
    17    }
    18 }

     1/** 2 * Created by hunt on 2017/6/23.
     3*/ 4 5/** 6 * 第一种方法获得Class对象
     7*/ 8publicclass MainTest {
     9publicstaticvoid main(String[] args) {
    10         Class<?> calss = ClassTest.class;
    11    }
    12}
    1314/**15 * 打印结果是：
    16 * 什么都没打印
    17 * 说明ClassName.class不执行静态块和不执行动态块儿
    18*/

     1/** 2 * Created by hunt on 2017/6/23.
     3*/ 4 5/** 6 * 第二种方法获得Class对象
     7*/ 8publicclass MainTest {
     9publicstaticvoid main(String[] args) {
    10try {
    11             Class<?> calss = Class.forName("com.souche.lease.admin.mytest.reflect.ClassTest");
    12         } catch (ClassNotFoundException e) {
    13            e.printStackTrace();
    14        }
    15    }
    16}
    1718/**19 * 打印结果是：
    20 * 静态代码块儿...
    21 * 说明Class.forName("类名全路径")执行静态块但是不执行动态块儿（需要异常处理）
    22*/

     1/** 2 * Created by hunt on 2017/6/23.
     3*/ 4 5/** 6 * 第三种方法获得Class对象
     7*/ 8publicclass MainTest {
     9publicstaticvoid main(String[] args) {
    10         Class<?> calss = new ClassTest().getClass();
    11    }
    12}
    1314/**15 * 打印结果是：
    16 * 静态代码块儿...
    17   动态构造块儿...
    18   构造方法...
    19 * 说明对象.getClass()执行静态块也执行动态块儿
    20*/

总结：第一种方法：类字面常量使得创建Class对象的引用时不会自动地初始化该对象，而是按照之前提到的加载，链接，初始化三个步骤，这三个步骤是个懒加载的过程，不使用的时候就不加载。

　　　第二种方法：Class类自带的方法。

　　　第三种方法：是所有的对象都能够使用的方法，因为getClass()方法是Object类的方法，所有的类都继承了Object，因此所有类的对象也都具有getClass()方法。

建议：使用类名.class，这样做即简单又安全，因为在编译时就会受到检查，因此不需要置于try语句块中，并且它根除了对forName()方法的调用，所以也更高效。

注意：静态块仅在类加载时执行一次，若类已加载便不再重复执行；而动态构造块在每次new对象时均会执行。
{% endraw %}
