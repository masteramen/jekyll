---
layout: post
title:  "Java的数据类型和参数传递"
title2:  "Java的数据类型和参数传递"
date:   2017-01-01 23:54:30  +0800
source:  "https://www.jfox.info/java%e7%9a%84%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b%e5%92%8c%e5%8f%82%e6%95%b0%e4%bc%a0%e9%80%92.html"
fileName:  "20170101170"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e7%9a%84%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b%e5%92%8c%e5%8f%82%e6%95%b0%e4%bc%a0%e9%80%92.html"
---
{% raw %}
Java提供的数据类型主要分为两大类：基本数据类型和引用数据类型。
Java中的基本数据类型名称大小　取值范围byte型 （字节）8bit-128-127  (-2^7到2^7-1)
short型 （短整型）
16bit-2^15到2^15-1int型 （整形）32bit-2^31到2^31-1long型 （长整型）64bit-2^63到2^63-1float型 （单精度浮点型）32bit double型 （双精度浮点型）64bit char型 （字符型）16bit boolean型 （布尔型）true和false只有两种结果，要么为“真”要么为“假”
Java中的引用数据类型：

Java作为面向对象的语言，Java中所有用class，interface，abstract class定义的都属于Java的引用数据类型。

如何理解Java中的基本数据类型和引用数据类型：

　　1.Java的基本数据类型是由Java语言本身提供的数据类型，不需要用户自己定义；

　　2.Java中的引用数据类型则是由用户自己定义的，而引用数据类型的定义需要用到基本数据类型；

　　3.从内存关系上来说：

 　　Java的的内存分为两大块：栈内存和堆内存

**　栈内存负责存储方法中的基本数据类型变量和对象的引用变量**

**　　堆内存负责存储通过new关键字产生的数据，也就是new关键字后面的类中的属性和方法。**

Java中基本数据类型存储在栈内存中，而引用数据类型的类型名存储在栈内存中，但是引用数据类型的内容则存储在堆内存中。两者之间通过地址来连接，实现互相的访问。

4.数据由小范围往大范围转换时，JVM会自动帮我们实现类型的转换。比如：**int i=10;long l=i;**类似于这样的数据转换，Java的虚拟机可以自动帮我们来完成这个工作。但是当数据由大范围往小范围转换时就需要手动的加上强制类型转换。如果在转过程中出现数据的溢出则根据小范围的数据类型的值域进行变动。比如说把整形的**-129**赋值给**byte**这时候输出byte的值就是**127**；如果把整形的**128**赋值给**byte**类型，那么输出的就应该是-128。

Java中的参数传递：

基本数据类型：

    public void test1(){
            int i=10;
            long l;
            l=i;
            System.out.println(i);//输出值10
            System.out.println(l);//输出值10
            l=i+1;
            System.out.println(i);//输出值10
            System.out.println(l);//输出值11
        } 

由于基本数据类型是变量名与变量值一同存储在栈内存中，**i** 和** l** 这两个变量是互相独立的，对** l **的赋值操作并不会影响** i** 值。

引用数据类型：

    public class Book {
        private String name;
    
        public String getName() {
            return name;
        }
    
        public void setName(String name) {
            this.name = name;
        }
    }
    public class Test {
        public static void main(String[] args) {
            Book book1=new Book();
            book1.setName("《百年孤独》");
            Book book2=new Book();
            book2.setName("《围城》");
            System.out.println("book1:"+book1.getName());//输出：book1:《百年孤独》
            System.out.println("book2:"+book2.getName());//输出：book2:《围城》
            book1=book2;
            book1.setName("《活着》");
            System.out.println("book1:"+book1.getName());//输出：book1:《活着》
            System.out.println("book2:"+book2.getName());//book2:《活着》
    
        }
    }

第一次new了两个对象分别是book1,book2他们的书名分别是“百年孤独”和“围城”。然后通过赋值，book1也指向了与book2一样的内存区域，这时无论是对book1 还是book2 进行操作影响的都是同一块内存区域了。这也就是为什么后面的输出都是一样的原因了。另外book1原先开辟的内存空间由于没有使用，JVM的垃圾回收机制会对其进行处理，将这些不用的内存空间进行释放。
 

  posted @ 
 2017-07-09 08:10[迷失的小菜包](https://www.jfox.info/go.php?url=http://www.cnblogs.com/cbs-writing/) 阅读( 
 …) 评论( 
 …)
{% endraw %}
