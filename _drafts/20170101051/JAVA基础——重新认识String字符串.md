---
layout: post
title:  "JAVA基础——重新认识String字符串"
title2:  "JAVA基础——重新认识String字符串"
date:   2017-01-01 23:52:31  +0800
source:  "http://www.jfox.info/java%e5%9f%ba%e7%a1%80%e9%87%8d%e6%96%b0%e8%ae%a4%e8%af%86string%e5%ad%97%e7%ac%a6%e4%b8%b2.html"
fileName:  "20170101051"
lang:  "zh_CN"
published: true
permalink: "java%e5%9f%ba%e7%a1%80%e9%87%8d%e6%96%b0%e8%ae%a4%e8%af%86string%e5%ad%97%e7%ac%a6%e4%b8%b2.html"
---
{% raw %}
在程序开发中字符串无处不在，如用户登陆时输入的用户名、密码等使用的就是字符串。

在 Java 中，字符串被作为 String 类型的对象处理。 String 类位于 java.lang 包中。**默认情况下，该包被自动导入所有的程序。**

### 创建 String 对象有三种方法

    String s1="我是字符串1";
    String s2=new String();//创建一个空的字符串对象
    String s3=new String("我是字符串2");//创建一个空的字符串对象

创建String对象要**注意**下面这个问题：

    1//申明一个string类型的s1，即没有在申请内存地址，更没有在内存任何指向引用地址；2String s1;
    3//申明一个string类型的s2，同时在内存里申请了一个地址，但是该地址不指向任何引用地址；4 String s2=null;
    5//申明一个string类型的s3，既在内存里申请了地址，该地址又指向一个引用该字符串的引用地址；6 String s3="";
    7//同理s3;8 String s4=new String();

虽然new String()与””值一样，但是**内存地址不一样**。

*一般来说 字符串的使用 最好用String str = “”;语句，可以防止后面的程序因引用地址混乱而找不到的异常！String s = null;String s;劲量少用！能不用就不要使用！*

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

### String 字符串的不变性

String 对象创建后则不能被修改，是**不可变**的，所谓的修改其实是创建了新的对象，所指向的**内存空间不同**。如下所示：

     1publicstaticvoid main(String[] args) {
     2// TODO Auto-generated method stub
     3//分别给四个字符串变量赋值，相同的内容 4         String s1="云开的立夏";
     5         String s2="云开的立夏";
     6         String s3=new String("云开的立夏");
     7         String s4=new String("云开的立夏");
     8 9//多次出现的字符串，java编译程序只创建一个内存空间，所以返回true10         System.out.println(s1==s2);
    11//s1和s3是不同的对象，所以返回false12         System.out.println(s1==s3);
    13//s3和s4是不同的对象，所以返回false14         System.out.println(s3==s4);
    151617         s1="欢迎来到"+s1+"的博客园";
    18//字符串s1被修改，指向新的内存空间,返回false19        System.out.println(s1);
    2021         System.out.println(s1==s2);
    2223     }

运行结果：

![](/wp-content/uploads/2017/07/1499096309.png)

**结果分析：**

结合上面的代码，和运行结果我们来逐一分析，为什么会出现这样的结果？String字符串的不变性又是如何体现的呢？

1、 通过 String s1=”云开的立夏”; 声明了一个字符串对象， s1 存放了到字符串对象的引用，在内存中的存放引用关系如下图所示：

![](/wp-content/uploads/2017/07/1499177888.png)

然后通过 s1=”欢迎来到”+s1+”的博客园”; 改变了字符串 s1 ，其实本质是**创建了新的字符串对象**，变量 s1 指向了新创建的字符串对象，如下图所示：

![](/wp-content/uploads/2017/07/14991778881.png)

2、 一旦一个字符串在内存中创建，则这个字符串将不可改变。如果需要一个可以改变的字符串，我们可以使用StringBuffer或者StringBuilder（我明天将会写一篇博文来讲解它们的使用，请关注哦~）。

3、** 每次 new 一个字符串就是产生一个新的对象**，即便两个字符串的内容相同，使用 ”==” 比较时也为 ”false” ,如果只需比较内容是否相同，应使用 ”equals()” 方法（前面条件运算符章节讲过哦~~）。

## Java 中的 String 类常用方法 Ⅰ

String 类提供了许多用来处理字符串的方法，例如，获取字符串长度、对字符串进行截取、将字符串转换为大写或小写、字符串分割等，下面我们就来领略它的强大之处吧。

String 类的常用方法：

![](/wp-content/uploads/2017/07/1499177890.jpg)

哇，String类的常用方法确实有多哦！死记硬背可是不行的，我们来结合代码来熟悉一下方法的使用：

     1publicstaticvoid main(String[] args) {
     2// TODO Auto-generated method stub 3         String str="学习 java 编程";
     4 5//打印字符串长度 6         System.out.println("字符串长度："+str.length());
     7 8//查找字符‘编’的位置，如果找不到返回-1 9char c='编';
    10         System.out.println("字符‘编’的位置："+str.indexOf(c));
    11         System.out.println("字符‘b’的位置："+str.indexOf('b'));
    12//查找字符串“java”的位置，如果找不到返回-113         System.out.println("字符串“java”的位置"+str.indexOf("java"));
    14         System.out.println("字符串“云开的立夏”的位置"+str.indexOf("云开的立夏"));
    1516//按空格把字符串拆分成一个数组，并输出数组元素17         String[] arr=str.split(" ");
    18         System.out.print("按空格把字符串拆分成一个数组"+Arrays.toString(arr));
    19        System.out.println();
    20//按,(字符串中不存在的)把字符串拆分成一个数组，并输出数组元素21         String[] arr2=str.split(",");
    22         System.out.print("按按,(字符串中不存在的)把字符串拆分成一个数组"+Arrays.toString(arr2));
    23        System.out.println();
    24//按空格把字符串拆分成一个数组，并规定数组最大长度为2，并输出数组元素25         String[] arr3=str.split(" ",2);
    26         System.out.print("按空格把字符串拆分成一个数组，并规定数组最大长度为2："+Arrays.toString(arr3));
    27        System.out.println();
    2829//获取索引位置[3,7)之间的子串30         System.out.println("获取索引位置[3,7)之间的子串："+str.substring(3, 7));
    31//获取索引位置3开始的子串32         System.out.println("获取索引位置[3,7)之间的子串："+str.substring(3));
    333435     }

运行结果：

![](/wp-content/uploads/2017/07/1499177890.png)

**结果分析：**

1. 字符串 str 中字符的索引从0开始，范围为 0 到 str.length()-1

2. 使用 indexOf 进行字符或字符串查找时，如果匹配返回位置索引；如果没有匹配结果，返回 -1

3. 使用 substring(beginIndex , endIndex) 进行字符串截取时，包括 beginIndex 位置的字符，不包括 endIndex 位置的字符

4、使用String[] split(String regex, int limit)进行字符串拆分时，如果按字符串没有的字符分隔则不进行分隔，即返回长度为1的数组内容就是原来的字符串。

## Java 中的 String 类常用方法 Ⅱ

我们继续来看 String 类常用的方法，如下代码所示：

     1publicstaticvoid main(String[] args) {
     2// TODO Auto-generated method stub 3         String str="学习 java 编程";
     4 5//将字符转换为大写 6         System.out.println("将字符转换为大写:"+str.toUpperCase());
     7//再讲字符串转换为小写 8         System.out.println("再讲字符串转换为小写:"+str.toLowerCase());
     910//获取位置为1的字符11         System.out.println("获取位置为1的字符:"+str.charAt(1));
    1213//将字符串转为byte[]数组，并打印输出14byte[] b=str.getBytes();
    15         System.out.print("将字符串转为byte[]数组:"+Arrays.toString(b));
    16        System.out.println();
    1718//定义一个新的字符串，前后加上空格19         String str2=" 学习 java 编程 ";
    20//返回除去前后空格的字符串21         String str3=str2.trim();
    22         System.out.println("返回除去前后空格的字符串:"+str3);
    2324//将str和str3字符串进行比较25         System.out.println("str和str3的内存地址相同吗？:"+(str==str3));
    26         System.out.println("str和str3的内容相同吗？:"+str.equals(str3));
    2728    }
    2930 }

运行结果：

![](/wp-content/uploads/2017/07/1499177891.png)

**结果分析：**

1.  ==: 判断两个字符串在内存中首地址是否相同，即判断是否是同一个字符串对象。

2.  equals(): 比较存储在两个字符串对象中的内容是否一致。

3. 汉字对应的字节值为负数，原因在于每个字节是 8 位，最大值不能超过 127，而**汉字转换为字节后超过 127，如果超过就会溢出，以负数的形式显示。**（关于编码，我会在后续的博文中讲解，小小期待哦~~）

注意：Object类中equal()方法比较的是对象的引用是否指向同一块内存地址，而String类中equals(): 比较存储在两个字符串对象中的内容是否一致。**Object类中是equal()方法；String类中是equals()，差了一个s。**

针对如此繁杂的方法，推荐大家一个学习技巧：**好记性不如烂笔头**！多看的同时一定要多敲哦~~
{% endraw %}
