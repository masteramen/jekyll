---
layout: post
title:  "Java进阶自测：面向对象基础知识掌握了吗？（附答案及个人解析）"
title2:  "Java进阶自测：面向对象基础知识掌握了吗？（附答案及个人解析）"
date:   2017-01-01 23:49:54  +0800
source:  "https://www.jfox.info/java%e8%bf%9b%e9%98%b6%e8%87%aa%e6%b5%8b-%e9%9d%a2%e5%90%91%e5%af%b9%e8%b1%a1%e5%9f%ba%e7%a1%80%e7%9f%a5%e8%af%86%e6%8e%8c%e6%8f%a1%e4%ba%86%e5%90%97-%e9%99%84%e7%ad%94%e6%a1%88%e5%8f%8a%e4%b8%aa.html"
fileName:  "20170100894"
lang:  "zh_CN"
published: true
permalink: "2017/java%e8%bf%9b%e9%98%b6%e8%87%aa%e6%b5%8b-%e9%9d%a2%e5%90%91%e5%af%b9%e8%b1%a1%e5%9f%ba%e7%a1%80%e7%9f%a5%e8%af%86%e6%8e%8c%e6%8f%a1%e4%ba%86%e5%90%97-%e9%99%84%e7%ad%94%e6%a1%88%e5%8f%8a%e4%b8%aa.html"
---
{% raw %}
publicclass Test { 
           publicintaMethod() {
                  staticint i=0;
                  i++;
                  return i;
           }
           publicstaticvoidmain(String args[]) {
                  Test test = newTest();
                  test.aMethod();
                  int j = test.aMethod();
                  System.out.println(j);
           }
    }

将产生哪种结果：

A. Compilation will fail

B. Compilation will succeed and the program will print“0”

C. Compilation will succeed and the program will print“1”

D. Compilation will succeed and the program will print“2”
H2M_LI_HEADER 
如要在字符串s（内容为“welcome to mldn !! ”），中，发现字符’t’的位置，应该使用下面哪种方法？

A.`mid(2,s);`

B. `charAt(2);`

C. `s.indexOf('t');`

D. `indexOf(s,'v');`

H2M_LI_HEADER 
编译和运行下面代码可能会发生什么？

    class Base {
        privatevoidamethod(int iBase) {
            System.out.println("Base.amethod");
        }
    }    
    class Over extends Base {
        publicstaticvoidmain(String args[]) {
            Over o = newOver();
            int iBase = 0 ;
             o.amethod(iBase) ;
        }
        publicvoidamethod(int iOver) {
            System.out.println("Over.amethod");
        }
    }

A. Compile time error complaining that Base.amethod is private

B. Runntime error complaining that Base.amethod is private

C. Output of Base amethod

D. Output of Over.amethod

H2M_LI_HEADER 
现在有如下一段程序

    classsuper {
        String name ;
        publicsuper(String name) {    
            this.name = name ;
        }
        publicvoidfun1()     {
            System.out.println("this is class super !"+name);
        }
    }
    class sub extendssuper {
        publicvoidfun1()     {
            System.out.println("this is class sub !"+name);
        }
    }
    class Test {
        publicstaticvoidmain(String args[]) {
            super s = newsub();
        }
    }

运行上面的程序可能会出现的结果？

A. this is class super !

B. this is class sub !

C. 编译时出错

D. 运行时出错

H2M_LI_HEADER 
现在有如下一段程序

    class Happy {
        publicstaticvoidmain(String args[]) {
            float [][] f1 = {{1.2f,2.3f},{4.5f,5.6f}} ;
            Object oo = f1 ;
            f1[1] = oo ;
            System.out.println("Best Wishes "+f1[1]);
        }
    }

该程序会出现何种效果？

A. {4.5,5.6}

B. 4.5

C. compilation error in line NO.5

D. exception

H2M_LI_HEADER 
在一个类文件中，导入包、类和打包是怎样的排列顺序？

A. package、import、class；

B. class、import、package

C. import、package、class

D. package、class、import

H2M_LI_HEADER 
如果你试图编译并运行下列代码时可能会打印输出什么？

    int i = 9 ;
    switch(i) {
        default:
            System.out.println("default");
        case0 :
            System.out.println("zero");
            break ;
        case1 : System.out.println("one");
        case2 : System.out.println("two");
    }

A. default

B. default , zero

C. error default clause not defined

D. no output displayed

H2M_LI_HEADER 
当你编译下列代码可能会输出什么？

    class Test {
        staticint i ;
        publicstaticvoidmain(String args[]) {
            System.out.println(i);
        }
    }

A. Error Variable i may not have been initialized

B. null

C. 1

D. 0

H2M_LI_HEADER 
下面代码会存在什么问题？

    publicclass MyClass {
        publicstaticvoidmain(String arguments[])     {
            amethod(arguments);
        }
        publicvoidamethod(String[] arguments){
            System.out.println(arguments);
            System.out.println(arguments[1]);
        }
    }

A. 错误，void amethod()不是static类型

B. 错误，main()方法不正确

C. 错误，数组必须导入参数

D. 方法amethod()必须用String类型描述

H2M_LI_HEADER 
为Demo类的一个无形式参数无返回值的方法method书写方法头，使得使用类名Demo作为前缀就可以调用它，该方法头的形式为？

A. `static void method( )`

B. `public void method( )`

C. `final void method( )`

D. `abstract void method( )`

### 答案

ACDCC ABDAA

### 个人解析

1. 
在方法体内声明的变量是“局部变量”，而局部变量是不能用static修饰的，private、protected、public也是不能用的。

2. 
indexOf是String类的一个方法，作用是查找第一次出现参数的位置，没有则返回-1。

3. 
无论amethod方法是不是private，结果都是执行子类的amethod方法。区别是，如果不是private，子类的amethod方法是重写了父类的方法；如果是private，子类的amethod方法并没有重写父类的方法。

4. 
Java中，如果类里没有写构造方法，那么会默认有一个无参的构造方法。但是一旦手动写了构造方法，那么默认的无参构造方法就没有了。这道题是因为父类只有一个有参的构造方法，但是子类却没有，所以编译出错。

5. 
Java中的数组是对象，所以第四行没有问题。而f1[1]需要的是一个数组并且是一维数组，所以第五行编译出错。

6. 
无

7. 
在default中进入，在case 0中因为break跳出。

8. 
基本数据类型都有相应的默认值，其中int是0，char为‘u0000’，boolean为false。

9. 
静态方法无法调用非静态方法。

10. 
静态方法可以用类名.方法名直接调用。
{% endraw %}
