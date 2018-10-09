---
layout: post
title:  "【comparator, comparable】小总结"
title2:  "【comparator, comparable】小总结"
date:   2017-01-01 23:53:52  +0800
source:  "https://www.jfox.info/comparatorcomparable%e5%b0%8f%e6%80%bb%e7%bb%93.html"
fileName:  "20170101132"
lang:  "zh_CN"
published: true
permalink: "2017/comparatorcomparable%e5%b0%8f%e6%80%bb%e7%bb%93.html"
---
{% raw %}
H2M_LI_HEADER 
有些类是直接实现了Comparable接口的，这个时候如果要改写排序条件，就直接改写Comparable接口的CompareTo方法

H2M_LI_HEADER 
有些类不是用Comparable接口，而是用了个Comparator类，这时候改写Compare方法

**Comparable接口：**
只有一个方法compareTo(T o). 具体实践中一般写作o与某个的比较，比如o.age – this.age.
**Comparator类：**
1） int compare(T o1, T o2) o1,o2比较（>, < , =）
2) boolean equals(Object obj)
**排序时重写comparator*：
有些类在构造时可以加Comparator参数，比如PriorityQueue，默认是从小到大排序，如果要改写可以加入一个重写了compare方法的comparator
Comparator<Integer> revCmp = new Comparator<Integer>() {

            @Override
            public int compare(Integer left, Integer right) {
                return right.compareTo(left);//原本应该是left.compareTo(right)
            }
        };
        Queue<Integer> Maxqueue= new PriorityQueue<Integer>(k, revCmp);

注意这里compareto方法也是Integer类自带的
{% endraw %}
