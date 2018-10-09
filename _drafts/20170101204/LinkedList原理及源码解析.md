---
layout: post
title:  "LinkedList原理及源码解析"
title2:  "LinkedList原理及源码解析"
date:   2017-01-01 23:55:04  +0800
source:  "https://www.jfox.info/linkedlist%e5%8e%9f%e7%90%86%e5%8f%8a%e6%ba%90%e7%a0%81%e8%a7%a3%e6%9e%90.html"
fileName:  "20170101204"
lang:  "zh_CN"
published: true
permalink: "2017/linkedlist%e5%8e%9f%e7%90%86%e5%8f%8a%e6%ba%90%e7%a0%81%e8%a7%a3%e6%9e%90.html"
---
{% raw %}
# LinkedList原理及源码解析 


LinkedList是一个双向线性链表，但是并不会按线性的顺序存储数据，而是在每一个节点里存到下一个节点的指针(Pointer)。由于不必须按顺序存储，链表在插入的时候可以达到O(1)的复杂度，比另一种线性表顺序表快得多，但是查找一个节点或者访问特定编号的节点则需要O(n)的时间，而顺序表相应的时间复杂度分别是O(logn)和O(1)。

# UML关系图

# 使用示例

    LinkedList list = new LinkedList<>();
    //新增
    list.add("a");
    list.add("a");
    list.add("b");
    System.out.println(list);
    
    //删除
    list.remove("a");//删除第一个对应对象
    list.remove(0);//删除下标为0的元素
    list.removeFirst();//删除第一个元素
    list.removeLast();//删除最后一个元素
    System.out.println(list);
    
    //修改
    list.set(0,"c");//修改下标为0的元素
    System.out.println(list);
    
    //插入 
    list.add(1,"a");//只能在已有元素的前后或中间位置插入
    System.out.println(list);
    
    //获取
    list.get(0);//根据下标获取元素
    list.getFirst();//获取第一个元素
    list.getLast();//获取最后一个元素
    
    //循环
    //普通循环
    for(int i=0;i<list.size();i++){
        System.out.println(list.get(i));
    }
    //foreach循环
    for(Object o:list){
        System.out.println(o);
    }
    //迭代循环
    Iterator iterator = list.iterator();
    while (iterator.hasNext()){
        System.out.println(iterator.next());
    }

# 源码解析

## 初始化

### 节点

    //链表的核心类-节点
    private static class Node<E> {
        //节点元素
        E item;
        //下一个节点引用
        Node<E> next;
        //上一个节点引用
        Node<E> prev;
    
        Node(Node<E> prev, E element, Node<E> next) {
            this.item = element;
            this.next = next;
            this.prev = prev;
        }
    }

### 构造方法

    //默认大小
    transient int size = 0;
    //第一个节点
    transient Node<E> first;
    //最后一个节点
    transient Node<E> last;
    //无参构造
    public LinkedList() {
    }
    //带有初始化集合构造
    public LinkedList(Collection<? extends E> c) {
        this();
        addAll(c);
    }

### addAll的分析

## 常用函数分析

### 增加

    //增加元素，默认向链表的结尾增加节点
    public boolean add(E e) {
            linkLast(e);
            return true;
        }
    void linkLast(E e) {
        //获取链表尾部节点
        final Node<E> l = last;
        //创建新的节点，将最后的节点做为新节点的上一个节点引用，元素为传入元素
        final Node<E> newNode = new Node<>(l, e, null);
        //链表尾部指向最新节点
        last = newNode;
        //如果原来尾部节点为空，说明为空链表需要设置链表头部节点
        //否则将原来链表尾部节点的next指向新的节点
        if (l == null)
            first = newNode;
        else
            l.next = newNode;
        //增加大小
        size++;
        //记录修改次数，主要用于集合迭代，保证迭代数据的准确性
        //在迭代时候如果集合发生变化则会抛出异常
        //throw new ConcurrentModificationException();
        modCount++;
    }

### 删除
{% endraw %}
