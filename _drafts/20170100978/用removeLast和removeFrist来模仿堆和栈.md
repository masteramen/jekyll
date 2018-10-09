---
layout: post
title:  "用removeLast和removeFrist来模仿堆和栈"
title2:  "用removeLast和removeFrist来模仿堆和栈"
date:   2017-01-01 23:51:18  +0800
source:  "https://www.jfox.info/%e7%94%a8removelast%e5%92%8cremovefrist%e6%9d%a5%e6%a8%a1%e4%bb%bf%e5%a0%86%e5%92%8c%e6%a0%88.html"
fileName:  "20170100978"
lang:  "zh_CN"
published: true
permalink: "2017/%e7%94%a8removelast%e5%92%8cremovefrist%e6%9d%a5%e6%a8%a1%e4%bb%bf%e5%a0%86%e5%92%8c%e6%a0%88.html"
---
{% raw %}
/*

*在大不久前，我决定自学Java，关注了很多的公众号、微博等。没几天我看到一个笑话：

*晚上孩子哭了，老婆让我去看看。

*我说：“不行，咱们的床是队列，你先上的床就得你先下床。。。

*老婆说：NO NO No，是栈。 

* 紧接着一脚踹到我的屁股上。

* 当时，看了评论，都是在说程序员夫妻欢乐多之类的话，也上网查了堆栈的知识，

* 不是计算机专业的，看得也是云里雾里的。今天是二轮复习基础知识，

* 关于LinkedList有可以模拟堆栈的方法，就上手操作了一下，才理解了这个笑话的真谛，

* 越来越感觉，编程语言的魅力了，开心。

*/

     1import java.util.LinkedList;
     2 3publicclass NoNo {
     4publicstaticvoid main(String[] args) {
     5         MyQueue q = new MyQueue();
     6         q.add("老婆先上床");
     7         q.add("我在老婆之后上床");
     8 9while (q.isEmpty() == false) {
    1011             System.out.println(q.get2() + "却要下床哄熊孩子");
    1213        }
    1415    }
    16}
    1718class MyQueue {
    19private LinkedList List;// 底层2021    MyQueue() {
    22         List = new LinkedList();
    23    }
    2425publicvoid add(Object obj) {
    26        List.addFirst(obj);
    27    }
    28public Object get2() {
    29// 模仿栈30return List.removeFirst();
    31    }
    3233publicboolean isEmpty() {
    34return List.isEmpty();
    35    }
    36 }

    PutOut：
    我在老婆之后上床却要下床哄熊孩子
    老婆先上床却要下床哄熊孩子

     1import java.util.LinkedList;
     2 3publicclass NoNo {
     4publicstaticvoid main(String[] args) {
     5         MyQueue q = new MyQueue();
     6         q.add("老婆先上床");
     7         q.add("我在老婆之后上床");
     8 9while (q.isEmpty() == false) {
    1011                 System.out.println(q.get()+"却要下床哄熊孩子");
    12        }
    1314    }
    15}
    1617class MyQueue {
    18private LinkedList List;// 底层1920    MyQueue() {
    21         List = new LinkedList();
    22    }
    2324publicvoid add(Object obj) {
    25        List.addFirst(obj);
    26    }
    2728public Object get(){
    29//模仿队列30return List.removeLast();
    31        }
    3233publicboolean isEmpty() {
    34return List.isEmpty();
    35    }
    36 }

    OutPut：
    老婆先上床却要下床哄熊孩子
    我在老婆之后上床却要下床哄熊孩子
{% endraw %}
