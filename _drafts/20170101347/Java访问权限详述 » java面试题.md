---
layout: post
title:  "Java访问权限详述 » java面试题"
title2:  "Java访问权限详述 » java面试题"
date:   2017-01-01 23:57:27  +0800
source:  "https://www.jfox.info/java%e8%ae%bf%e9%97%ae%e6%9d%83%e9%99%90%e8%af%a6%e8%bf%b0.html"
fileName:  "20170101347"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e8%ae%bf%e9%97%ae%e6%9d%83%e9%99%90%e8%af%a6%e8%bf%b0.html"
---
{% raw %}
1.什么是访问权限？

类中全局变量与方法的可见范围，即可以通过对象引用的方式出现的范围。

### 2.权限修饰符的可见范围
public protectedprivate包范围√√×其他包√××能否被继承√√×
### 3.对可见的理解

一个变量或者方法对另一个类B可见，意味着该变量或者方法可以直接通过对象引用的方式暴露在B中，反之，不可见意味着在B类中不可以直接通过对象引用的方式访问该变量或者方法。

一个变量或者方法对一个类不可见并不意味着该变量或者方法不能出现在B类中，而是不能直接暴露在B类中，可以间接暴露，通过公开或者protected类型的方法引用的方式间接出现。

    package com.javase.temp;
    
    import org.junit.Test;
    
    public class TempTest {
    
        private String str = new String("abc");
    
        @Test
        public void printStr() {
            System.out.println(this.str);
        }
    }

很明显在TempTest类中有一个成员变量str，private类型，对其他类不可见，意味着该变量不可以通过对象引用的形式出现在其他类中，可以通过调用printStr方法的方式间接出现在其他类中。

    package com.javase.temp;
    
    import org.junit.Test;
    
    public class TempTest01 {
    
        @Test
        public void test01() {
            TempTest obj = new TempTest();
            obj.printStr();//通过TempTest类型的public类型的方法间接访问了private类型的变量，在访问时不知道private类型变量的情况
        }
    }

输出：

![](/wp-content/uploads/2017/07/1500115717.png)

在TempTest01类中调用TempTest对象obj中的方法printStr，输出了私有变量str的值。str没有直接暴露中TempTest01中，而是直接暴露在TempTest的方法printStr中，而方法printStr直接暴露在TempTest中，从而使str间接暴露在TempTest中。

虽然在TempTest01中输出了TempTest中private类型变量的值，这种输出是随机的，无意识的，TempTest01无法知道输出的结果来自变量str，输出毫无意义。

一个被设计成不可以被外界直接访问的变量通常用作本类运算的中间过程，辅助其他可见的变量与方法。

**本文永久更新链接地址** ： [http://www.linuxidc.com/Linux/2017-07/145707.htm](https://www.jfox.info/go.php?url=http://www.linuxidc.com/Linux/2017-07/../../Linux/2017-07/145707.htm)
{% endraw %}
