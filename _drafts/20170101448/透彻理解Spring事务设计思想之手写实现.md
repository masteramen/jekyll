---
layout: post
title:  "透彻理解Spring事务设计思想之手写实现"
title2:  "透彻理解Spring事务设计思想之手写实现"
date:   2017-01-01 23:59:08  +0800
source:  "https://www.jfox.info/%e9%80%8f%e5%bd%bb%e7%90%86%e8%a7%a3spring%e4%ba%8b%e5%8a%a1%e8%ae%be%e8%ae%a1%e6%80%9d%e6%83%b3%e4%b9%8b%e6%89%8b%e5%86%99%e5%ae%9e%e7%8e%b0.html"
fileName:  "20170101448"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e9%80%8f%e5%bd%bb%e7%90%86%e8%a7%a3spring%e4%ba%8b%e5%8a%a1%e8%ae%be%e8%ae%a1%e6%80%9d%e6%83%b3%e4%b9%8b%e6%89%8b%e5%86%99%e5%ae%9e%e7%8e%b0.html"
---
{% raw %}
# 透彻理解Spring事务设计思想之手写实现 


作者[张丰哲](/u/cb569cce501b)2017.08.01 22:15字数 765
# 前言

事务，是描述一组操作的抽象，比如对数据库的一组操作，要么全部成功，要么全部失败。事务具有4个特性：Atomicity（原子性），Consistency（一致性），Isolation（隔离性），Durability（持久性）。在实际开发中，我们对事务应用最多就是在数据库操作这一环，特别是Spring对数据库事务进行了封装管理。Spring对事务的支持，确实很强大，但是从本质上来讲：事务是否生效取决数据库底层是否支持（比如MySQL的MyISAM引擎就不支持事务，Spring能奈何！），同时一个事务的多个操作需要在同一个Connection上。事务也往往是在业务逻辑层来控制。本篇博客将通过手写一个Demo来分析Spring事务底层到底是如何帮助我们轻松完成事务管理的！

# 透彻理解Spring事务设计思想之手写实现

先来看一眼工程结构：
![](/wp-content/uploads/2017/08/1501682446.png) 
  
    工程结构 
   
  
 
ConnectionHolder

![](/wp-content/uploads/2017/08/15016824461.png)ConnectionHolder
在Spring中，有时候我们是不是要配置多个数据源DataSource？很显然，Spring需要通过DataSource来得到操作数据库的管道Connection，这有点类似于JNDI查找。

这里通过ConnectionHolder类来完成这个过程，需要思考的是在多线程下，这显然是存在问题的。为避免多线程问题，难道我们采用线程安全的Map，比如ConcurrentHashMap，其实我们真正的目的是什么？是保证一个线程下，一个事务的多个操作拿到的是一个Connection，显然使用ConcurrentHashMap根本无法保证！

Spring很聪明，她提供了一种思路，来解决，看下面的代码！

SingleThreadConnectionHolder

![](/wp-content/uploads/2017/08/15016824462.png)SingleThreadConnectionHolder
本来线程不安全的，通过ThreadLocal这么封装一下，立刻就变成了线程的局部变量，不仅仅安全了，还保证了一个线程下面的操作拿到的Connection是同一个对象！这种思想，确实非常巧妙，这也是无锁编程思想的一种方式！

TransactionManager

![](/wp-content/uploads/2017/08/15016824463.png)TransactionManager
TransactionManager，这个我们经常在Spring里面进行配置吧，事务大管家！

UserAccountDao、UserOrderDao
{% endraw %}
