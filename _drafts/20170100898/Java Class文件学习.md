---
layout: post
title:  "Java Class文件学习"
title2:  "Java Class文件学习"
date:   2017-01-01 23:49:58  +0800
source:  "https://www.jfox.info/java-class%e6%96%87%e4%bb%b6%e5%ad%a6%e4%b9%a0.html"
fileName:  "20170100898"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java-class%e6%96%87%e4%bb%b6%e5%ad%a6%e4%b9%a0.html"
---
{% raw %}
数据类型：

class 文件结构

 minor version:副版本

 major version:主版本号

文件的版本号 major_version.minor_version

flags:访问标志

1. ACC_PUBLICH 声明为publich
2. ACC_FINAL 声明为final
3. ACC_SUPER 当用到invokespecial指令时，需要对父类方法做特殊处理
4. ACC_INTERFACE 该class文件定义的是接口而不是类
5. ACC_ABSTRACT 声明为abstract
6. ACC_SYNTHETIC 声明为synthetic
7. ACC_ANNOTATION 标识注解类型
8. ACC_ENUM 标识枚举类型

constant pool 常量池

方法调用和返回指令

1.  invokevirtual 指令用于调用对象的实例方法，根据对象的实际类型进行分派
2. invokeinterface 指令用于调用接口方法，它会在运行时搜索由特定对象实现的这个接口方法，并找出适合的方法进行调用
3. invokespecial 指令用于调用一些需要特殊的实例方法，包括实例的初始化，私有方法和父类方法
4. invokestatic 指令用于调用命名类中的静态方法
5. invokedynamic 指令用于调用可以绑定invokedynamic指令的调用点对象作为目标方法。

aaload_<n>:从局部变量表中加载索引值为n的引用

aconst_null:将一个null值压入到操作数栈顶

putfield:为制定类的字段赋值

通过执行javac xxx.java javap -verbose xxx.class 查看class文件

    public class AconstNullDemo {
        Integer i=null;
        void test(){
            i=1;
            if(i.equals(Integer.valueOf(1))){
                System.out.println("eq");
            }
        }
    }
    public class common.jvm.AconstNullDemo
      minor version: 0
      major version: 52
      flags: ACC_PUBLIC, ACC_SUPER
    Constant pool:
       #1 = Methodref          #9.#20         // java/lang/Object."<init>":()V
       #2 = Fieldref           #8.#21         // common/jvm/AconstNullDemo.i:Ljava/lang/Integer;
       #3 = Methodref          #22.#23        // java/lang/Integer.valueOf:(I)Ljava/lang/Integer;
       #4 = Methodref          #22.#24        // java/lang/Integer.equals:(Ljava/lang/Object;)Z
       #5 = Fieldref           #25.#26        // java/lang/System.out:Ljava/io/PrintStream;
       #6 = String             #27            // eq
       #7 = Methodref          #28.#29        // java/io/PrintStream.println:(Ljava/lang/String;)V
       #8 = Class              #30            // common/jvm/AconstNullDemo
       #9 = Class              #31            // java/lang/Object
      #10 = Utf8               i
      #11 = Utf8               Ljava/lang/Integer;
      #12 = Utf8               <init>
      #13 = Utf8               ()V
      #14 = Utf8               Code
      #15 = Utf8               LineNumberTable
      #16 = Utf8               test
      #17 = Utf8               StackMapTable
      #18 = Utf8               SourceFile
      #19 = Utf8               AconstNullDemo.java
      #20 = NameAndType        #12:#13        // "<init>":()V
      #21 = NameAndType        #10:#11        // i:Ljava/lang/Integer;
      #22 = Class              #32            // java/lang/Integer
      #23 = NameAndType        #33:#34        // valueOf:(I)Ljava/lang/Integer;
      #24 = NameAndType        #35:#36        // equals:(Ljava/lang/Object;)Z
      #25 = Class              #37            // java/lang/System
      #26 = NameAndType        #38:#39        // out:Ljava/io/PrintStream;
      #27 = Utf8               eq
      #28 = Class              #40            // java/io/PrintStream
      #29 = NameAndType        #41:#42        // println:(Ljava/lang/String;)V
      #30 = Utf8               common/jvm/AconstNullDemo
      #31 = Utf8               java/lang/Object
      #32 = Utf8               java/lang/Integer
      #33 = Utf8               valueOf
      #34 = Utf8               (I)Ljava/lang/Integer;
      #35 = Utf8               equals
      #36 = Utf8               (Ljava/lang/Object;)Z
      #37 = Utf8               java/lang/System
      #38 = Utf8               out
      #39 = Utf8               Ljava/io/PrintStream;
      #40 = Utf8               java/io/PrintStream
      #41 = Utf8               println
      #42 = Utf8               (Ljava/lang/String;)V
    {
      java.lang.Integer i;
        descriptor: Ljava/lang/Integer;
        flags:
      public common.jvm.AconstNullDemo();
        descriptor: ()V
        flags: ACC_PUBLIC
        Code:
          stack=2, locals=1, args_size=1
             0: aload_0
             1: invokespecial #1                  // Method java/lang/Object."<init>":()V
             4: aload_0
             //将null压入栈顶
             5: aconst_null
             //将null赋值给属性i
             6: putfield      #2                  // Field i:Ljava/lang/Integer;
             9: return
          LineNumberTable:
            line 6: 0
            line 7: 4
      void test();
        descriptor: ()V
        flags:
        Code:
          stack=2, locals=1, args_size=1
            //加载this到操作栈
             0: aload_0  
             //加载常量1到操作栈
             1: iconst_1
             //调用静态方法
             2: invokestatic  #3                  // Method java/lang/Integer.valueOf:(I)Ljava/lang/Integer;
             //将计算结果赋值给属性，为什么putfield的索引不是连续的？这是因为invokestatic操作和操作数长度为3个slot
             5: putfield      #2                  // Field i:Ljava/lang/Integer;
             //加载this到操作栈
             8: aload_0
             //将属性压入栈顶
             9: getfield      #2                  // Field i:Ljava/lang/Integer;
            //加载常量1到操作栈顶
            12: iconst_1
            //调用静态方法Integer.valueOf()
            13: invokestatic  #3                  // Method java/lang/Integer.valueOf:(I)Ljava/lang/Integer;
            //调用虚方法equals
            16: invokevirtual #4                  // Method java/lang/Integer.equals:(Ljava/lang/Object;)Z
            //如果ifeq的结果为0则挑战到30行
            19: ifeq          30
            22: getstatic     #5                  // Field java/lang/System.out:Ljava/io/PrintStream;
            25: ldc           #6                  // String eq
            27: invokevirtual #7                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
            30: return
          LineNumberTable:
            line 10: 0
            line 11: 8
            line 12: 22
            line 14: 30
          StackMapTable: number_of_entries = 1
            frame_type = 30 /* same */
    }
{% endraw %}
