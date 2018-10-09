---
layout: post
title:  "Java基础——String类（一）"
title2:  "Java基础——String类（一）"
date:   2017-01-01 23:50:06  +0800
source:  "https://www.jfox.info/java%e5%9f%ba%e7%a1%80-string%e7%b1%bb-%e4%b8%80.html"
fileName:  "20170100906"
lang:  "zh_CN"
published: true
permalink: "2017/java%e5%9f%ba%e7%a1%80-string%e7%b1%bb-%e4%b8%80.html"
---
{% raw %}
**`一、String` 类代表字符串**

Java 程序中的所有字符串字面值（如 `"abc"` ）都作为此类的实例实现。

字符串是常量；它们的值在创建之后不能更改。字符串缓冲区支持可变的字符串。因为 String 对象是不可变的，所以可以共享。例如：

1 String str = “abc”;

等效于：

1char data[] = {‘a’, ‘b’, ‘c’}; 2 String str = new String(data);

下面给出了一些如何使用字符串的更多示例：

    1 System.out.println("abc");
    2      String cde = "cde";
    3      System.out.println("abc" + cde);
    4      String c = "abc".substring(2,3);
    5      String d = cde.substring(1, 2);

`String` 类包括的方法可用于检查序列的单个字符、比较字符串、搜索字符串、提取子字符串、创建字符串副本并将所有字符全部转换为大写或小写。大小写映射基于Character类指定的 Unicode 标准版。

Java 语言提供对字符串串联符号（”+”）以及将其他对象转换为字符串的特殊支持。字符串串联是通过 `StringBuilder`（或 `StringBuffer`）类及其 `append` 方法实现的。字符串转换是通过 `toString` 方法实现的，该方法由 `Object` 类定义，并可被 Java 中的所有类继承。有关字符串串联和转换的更多信息，请参阅 Gosling、Joy 和 Steele 合著的 The Java Language Specification。

除非另行说明，否则将 null 参数传递给此类中的构造方法或方法将抛出空指针异常。

`String` 表示一个 UTF-16 格式的字符串，其中的增补字符由代理项对表示。索引值是指 `char` 代码单元，因此增补字符在 `String` 中占用两个位置。

`String` 类提供处理 Unicode 代码点（即字符）和 Unicode 代码单元（即 `char` 值）的方法。

**二、字符串的创建方式**

1 String s=”abc”; 

表示，先在栈上创建一个引用s ,它会先去常量池中看有没有 “abc” 这个常量,如果有,则把s指向常量池中的 “abc”。

如果没有,则在常量池中创建 abc,

1 String s=new String(“abc”);

相当于 String obj=”abc”; String s=new String(obj) ; 经过这个操作以后,内存中有两份数据: 常量池中一份,堆上一份。由于有了 new 这个操作,不管常量池中原来有没有 “abc” ,它都会在堆上创建一份

**三、字符串的比较**

例1：字符串常量池的使用

    1 String s0 = "abc"; 
    2 String s1 = "abc"; 
    3 System.out.println(s0==s1); //true 
    4//s0  和  s1 都指向了常量池中的同一个 "abc"

例2：String中 == 与equals的区别

    1 String s0 =new String ("abc");   //new 这个操作,将在堆上产生对象,s0指向了堆2 String s1 =new String ("abc"); 
    3 System.out.println(s0==s1); //false  s0 和 s1 指向的是堆上不同de的对象System.out.println(s0.equals(s1)); //true 因为String类重写了equals方法,比的是实体的内容 

例3：编译期确定

    1 String s0="helloworld";
    2 String s1="helloworld";
    3 String s2="hello" + "world";   //编译的时候,直接就编译成了 helloworld4 System.out.println( s0==s1 );   //true5 System.out.println( s0==s2 );   //true

例4：编译期无法确定

    1 String s0="helloworld";
    2 String s1=new String("helloworld");
    3 String s2="hello" + new String("world");
    4 System.out.println( s0==s1 ); //false  一个指向常量池,一个指向堆System.out.println( s0==s2 ); //false5 System.out.println( s1==s2 ); //false

例5：编译期优化

     1 String s0 = "a1";
     2 String s1 = "a" + 1;
     3 System.out.println((s0 == s1)); //true 4 5 String s2 = "atrue";
     6 String s3= "a" + "true";
     7 System.out.println((s2 == s3))  //true 8 9 String s4 = "a3.4";
    10 String s5 = "a" + 3.4;
    11 System.out.println((s4 == s5));  //true

例6 编译期无法确定

    1 String s0 = "ab";
    2 String s1 = "b";
    3 String s2 = "a" + s1;   //s1不是常量,编译期无法确定4 System.out.println((s0 == s2)); //false

例7：编译期确定

    1 String s0 = "ab";
    2final String s1 = "b";     //加上final 就变成了常量3 String s2 = "a" + s1;  //对于两个常量相加,编译器能确定它的值4 System.out.println((s0 == s2));     //true

**四、String对象内存分析**

//例一

String a = “abc”; ①　　

String b = “abc”; ②　

分析：

①代码执行后在常量池(constant pool)中创建了一个值为abc的String对象，

②执行时，因为常量池中存在 “abc” 所以就不再创建新的String对象了。

//例二

String c = new String(“xyz”);①　　

String d = new String(“xyz”);②　　

分析：

①Class被加载时，”xyz”被作为常量读入，在常量池(constant pool)里创建了一个共享的值为”xyz”的String对象；

然后当调用到new String(“xyz”)的时候，会在堆(heap)里创建这个new String(“xyz”)对象;

②由于常量池(constant pool)中存在”xyz”所以不再创建”xyz”，然后创建新的new String(“xyz”)。

//例三

String s1 = new String(“xyz”); //创建二个对象(常量池和堆中)，一个引用 　　

String s2 = new String(“xyz”); //创建一个对象(堆中)，并且以后每执行一次创建一个对象，一个引用 　　

String s3 = “abc”; //创建一个对象(常量池中)，一个引用 　　

String s4 = “abc”; //不创建对象(共享上次常量池中的数据)，只是创建一个新的引用s4)

//例四

     1publicstaticvoid main(String[] args) {    
     2//以下两条语句创建了1个对象。"凤山"存储在字符串常量池中     3 String str1 = "凤山";    
     4 String str2 = "凤山";     
     5 System.out.println(str1==str2);//true     
     6//以下两条语句创建了3个对象。"天峨"，存储在字符串常量池中，两个new String()对象存储在堆内存中      7 String str3 = new String("天峨");     
     8 String str4 = new String("天峨");     
     9 System.out.println(str3==str4);//false      
    10//以下两条语句创建了1个对象。9是存储在栈内存中   //这里所说的一个对象,是指的9 , i 和 j 则是对9的引用  11int i = 9;     
    12int j = 9;     
    13 System.out.println(i==j);//true      
    14//由于没有了装箱，以下两条语句创建了2个对象。两个1对象存储在堆内存中    15 Integer l1 = new Integer(1);    注意这里是没有装箱操作的
    16 Integer k1 = new Integer(1);    
    17 System.out.println(l1==k1);//false 　
    18//以下两条语句创建了1个对象。1对象存储在栈内存中。自动装箱时对于值从127之间的值，使用一个实例。    19 Integer l = 20;//装箱     20 Integer k = 20;//装箱     21 System.out.println(l==k);//true    22 Integer i1 = 256;     //以下两条语句创建了2个对象。i1,i2变量存储在栈内存中，两个256对象存储在堆内存中   23 Integer i2 = 256;     
    24 System.out.println(i1==i2);//false  25 }

**五、String 类常见操作**

字符串的常见操作，大致有以下几类 获取,判断,转换,替换和切割

1) 获取类操作 

String str=”春花秋月何时了,往事知多少?小楼昨夜又东风,故国不堪回首月明中”;

1 这个字符串到底有多长

2 第4个字是什么 即根据索引获取字符 

3 第一个逗号是第几个字符 即根据字符取索引（ 取字符(或字符串)的位置）

4 最后一个“月”字的索引

5 是否含有“月明” 这个字符序列

6 是不是以”春花”开头，是否以“月明中”结尾

7 这个串是否为空

8 是否和另一个串相等

String str=”春花秋月何时了,往事知多少?小楼昨夜又东风,故国不堪回首月明中”;

System.out.println(“长度:” + str.length()); //31

System.out.println(“第四个字是”+str.charAt(3)); //月

System.out.println(“第一个逗号的位置是”+str.indexOf(‘,’)); //7

System.out.println(“第一个逗号的位置是”+str.indexOf(“,”)); //7

System.out.println(“第一个往事的位置是”+str.indexOf(“往事”)); //8

System.out.println(“最后一个月字的索引”+str.lastIndexOf(“月”)); //28

System.out.println(“是否含有月明”+str.contains(“月明”)); //true

System.out.println(“是否以春花开头”+str.startsWith(“春花”)); //true

System.out.println(“是否以月明中结尾”+str.endsWith(“月明中”)); //true

System.out.println(“是否为空”+str.isEmpty()); //false

System.out.println(str.equals(“另一个字符串”)); //false

String s1=”abc”;

String s2=”aBC”;

System.out.println(s1.equalsIgnoreCase(s2)); //true equalsIgnoreCase 比较的时候忽略大小写。
{% endraw %}
