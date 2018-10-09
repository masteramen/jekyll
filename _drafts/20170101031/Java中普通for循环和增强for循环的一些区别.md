---
layout: post
title:  "Java中普通for循环和增强for循环的一些区别"
title2:  "Java中普通for循环和增强for循环的一些区别"
date:   2017-01-01 23:52:11  +0800
source:  "https://www.jfox.info/java%e4%b8%ad%e6%99%ae%e9%80%9afor%e5%be%aa%e7%8e%af%e5%92%8c%e5%a2%9e%e5%bc%bafor%e5%be%aa%e7%8e%af%e7%9a%84%e4%b8%80%e4%ba%9b%e5%8c%ba%e5%88%ab.html"
fileName:  "20170101031"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e4%b8%ad%e6%99%ae%e9%80%9afor%e5%be%aa%e7%8e%af%e5%92%8c%e5%a2%9e%e5%bc%bafor%e5%be%aa%e7%8e%af%e7%9a%84%e4%b8%80%e4%ba%9b%e5%8c%ba%e5%88%ab.html"
---
{% raw %}
## Java中for的几种常见形式

1.For loop using index.

    for (int i = 0; i < arr.length; i++) { 
        type var = arr[i];
        body-of-loop
    }

2.Loop using explicit iterator.

    for (Iterator<type> iter = coll.iterator(); iter.hasNext(); ) {
        type var = iter.next();
        body-of-loop
    }

3.Foreach loop over all elements in arr.

    for (type var : coll) {
        body-of-loop
    }

## For循环用来处理哪些数据结构

1.数组

    int[] a = {1,2,3,4,5,6};
    int[] b = new int[]{1,2,3,4,5,6};
    int[] c = new int[6];
    
    for (int i = 0; i < a.length; i++) {
        System.out.println(i);
    }
    for (int i : a) {
        System.out.println(i);
    }

2.实现了java.util.Iterator的类

    import java.util.Iterator;
    
    public class IterableTest<E> implements Iterable<E> {
    
        public static void main(String[] args) {
            IterableTest<Integer> integers = new IterableTest<Integer>();
            for (Integer integer : integers) {
                System.out.println(integer);
            }
        }
    
        @Override
        public Iterator<E> iterator() {
            return new Iterator() {
    
                @Override
                public boolean hasNext() {
                    //...
                    return false;
                }
    
                @Override
                public Object next() {
                    //...
                    return null;
                }
    
                @Override
                public void remove() {
                    //...
                }
            };
        }
    }

## 普通for遍历和增强for的一些区别

增强的for循环的底层使用迭代器来实现，所以它就与普通for循环有一些差异

1. 
增强for使用增强for循环的时候不能使用集合删除集合中的元素；

2. 
增强for循环不能使用迭代器中的方法，例如remove()方法删除元素；

3. 
与普通for循环的区别：增强For循环有遍历对象，普通for循环没有遍历对象;

对于实现了RandomAccess接口的集合类，推荐使用普通for，这种方式faster than Iterator.next

The RandomAccess interface identifies that a particular java.util.List implementation has fast random access. (A more accurate name for the interface would have been “FastRandomAccess.”) This interface tries to define an imprecise concept: what exactly is fast? The documentation provides a simple guide: if repeated access using the List.get( ) method is faster than repeated access using the Iterator.next( ) method, then the List has fast random access. The two types of access are shown in the following code examples.
{% endraw %}
