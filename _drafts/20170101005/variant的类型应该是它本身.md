---
layout: post
title:  "variant的类型应该是它本身"
title2:  "variant的类型应该是它本身"
date:   2017-01-01 23:51:45  +0800
source:  "https://www.jfox.info/variant%e7%9a%84%e7%b1%bb%e5%9e%8b%e5%ba%94%e8%af%a5%e6%98%af%e5%ae%83%e6%9c%ac%e8%ba%ab.html"
fileName:  "20170101005"
lang:  "zh_CN"
published: true
permalink: "2017/variant%e7%9a%84%e7%b1%bb%e5%9e%8b%e5%ba%94%e8%af%a5%e6%98%af%e5%ae%83%e6%9c%ac%e8%ba%ab.html"
---
{% raw %}
(type list (a) (Var (:cons a (list a)) (:nil)))
    (type fruit (Var (:apple string) (:orange)))
    (type r1 (Rec (:name string) (:value int)))
    (type r2 (Rec (:name string) (:value float)))
    

 Rec表示是一个record，Var表示是一个variant。也就是在原来基础HM类型上面添加了Rec和Var两种类型。其实写法是几乎一样的，只不过用的是lisp，换成其它语言： 

      datatype 'a list
      | Cons of 'a
      | Nil
      type record = {name: string; value: int}
    

 上面定义了r1和r2，这俩不是一个东西。函数r1.name用于取出r1里面name字段，函数叫r2.name用于取出r2里面name字段，它们的类型分别是： 

    r1.name : r1 -> string
    r2.name : r2 -> string
    

 假如我又想定义一个函数，它可以从任何的record里面，取出name字段，如何描述这个函数的类型？ 

    get-name-field : (Rec (:name string)) -> string
    

 子类型是一个比较复杂的问题，觉得往那个方向走下去就走偏了。为了不走偏，我们不能把这个类型具体化的定义出来。 

 再看看fruit的定义 ` (type fruit (Var (:apple string) (:orange))) ` ，这里的 ` :apple ` 就是ML里面的Constructor。它的类型是啥？是一个 ` string -> ? ` ，而 ` ? ` 又是啥？是一个apple，apple是fruit这个variant其中的一种。怎么描述，都没有它本身在所处的上下文准确。因为如果还有其它的variant里面也定义了 ` :apple ` ，就歧义了。 

 看看case语句 

    (case x
      (:apple s) -> e1
      (:orange) -> e2)
    

 s的类型是什么？整个case表达式的类型又如何描述？当我们实现类型推导的时候，要把类型给写出来，但是这个类型确实不太好做形式化描述。 

 然而它的类型是什么其实可以不用关心。不需要类型，只需要约束。用约束描述比类型更准确。我们可以生成这样的约束: 

    (== (typeof e1) (typeof e1))
    (== (typeof s) T1)
    (== (Var (:apple string)) T1)
    (<= (Var (:apple string)) fruit)
{% endraw %}
