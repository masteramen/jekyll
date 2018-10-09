---
layout: post
title:  "有关LinkedList常用方法的源码解析"
title2:  "有关LinkedList常用方法的源码解析"
date:   2017-01-01 23:51:03  +0800
source:  "https://www.jfox.info/%e6%9c%89%e5%85%b3linkedlist%e5%b8%b8%e7%94%a8%e6%96%b9%e6%b3%95%e7%9a%84%e6%ba%90%e7%a0%81%e8%a7%a3%e6%9e%90.html"
fileName:  "20170100963"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%9c%89%e5%85%b3linkedlist%e5%b8%b8%e7%94%a8%e6%96%b9%e6%b3%95%e7%9a%84%e6%ba%90%e7%a0%81%e8%a7%a3%e6%9e%90.html"
---
{% raw %}
第一个默认不带参数的构造方法，构造一个空链表。

    //1.LinkedList，默认构造方法public LinkedList() {
    }

　　第二个构造方法能把一个集合作为一个参数传递，同时集合中的元素需要是LinkedList的子类。

    //2.LinkedList，能将一个集合作为参数的构造方法public LinkedList(Collection<? extends E> c) {
        this();
        addAll(c);
    }

　　两个构造方法都比较简单，接下来看元素的插入及删除等方法。

    publicboolean add(E e) {
        linkLast(e);    //将元素添加到链表尾部returntrue;
    }

    //LinkedList#linkLastvoid linkLast(E e) {
        final Node<E> l = last;    //链表尾指针引用暂存final Node<E> newNode = new Node<>(l, e, null);    //构造新节点
        last = newNode;    //将链表的尾指针指向新节点if (l == null)    //此时为第一次插入元素
            first = newNode;
        else
            l.next = newNode;    
        size++;    //链表数据总数+1
        modCount++;    //modCount变量在[《有关ArrayList常用方法的源码解析》](https://www.jfox.info/go.php?url=http://www.cnblogs.com/yulinfeng/p/7082700.html)提到过，增删都会+1，防止一个线程在用迭代器遍历的时候，另一个线程在对其进行修改。
    }

　　学过《数据结构》的同学相信看到链表的操作不会感到陌生，接着来看看删除指定位置的元素remove(int)方法。

    //LinkedList#removepublic E remove(int index) {
        checkElementIndex(index);    //检查是否越界 index >= 0 && index <= sizereturn unlink(node(index));    //调用node方法查找并返回指定索引位置的Node节点
    }
{% endraw %}
