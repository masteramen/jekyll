---
layout: post
title:  "Java基础——String类（二）"
title2:  "Java基础——String类（二）"
date:   2017-01-01 23:49:55  +0800
source:  "http://www.jfox.info/java%e5%9f%ba%e7%a1%80-string%e7%b1%bb-%e4%ba%8c.html"
fileName:  "20170100895"
lang:  "zh_CN"
published: true
permalink: "java%e5%9f%ba%e7%a1%80-string%e7%b1%bb-%e4%ba%8c.html"
---
{% raw %}
今天做了几道String常见操作。先来几个代码实例：

例一：此方法，仅把字符串前后出现的空格去掉了，中间部分不会。

     1class TestTrim {
     2publicstaticvoid main(String[] args) {
     3         String str = "         这是一   个要            去                 两端    空格    的字符串         ";
     4 5         str = trim(str);
     6         System.out.println("去完空格以后:" + str);
     7    }
     8 9static String trim(String str) {
    1011int beginIndex = 0;
    12int endIndex = str.length() - 1;
    1314while (beginIndex <= endIndex) {
    15// 从前往后算空格16if (str.charAt(beginIndex) == ' ') {
    17                 beginIndex++;
    18             } else {
    19break;
    20            }
    21        }
    2223while (beginIndex <= endIndex) {
    24// 从后往前算空格25if (str.charAt(endIndex) == ' ') {
    26                 endIndex--;
    27             } else {
    28break;
    29            }
    30        }
    3132         str = str.substring(beginIndex, endIndex + 1);
    33return str;
    34    }
    35 }

例二：

     1//字符串翻转 2publicclass TestTrim2 {
     3publicstaticvoid main(String[] args) {
     4         String str = "请        把我   翻转   过来                        ";
     5 6char[] list = str.toCharArray();
     7 8for (int i = 0; i < list.length / 2; i++) {
     9char temp = ' ';
    1011             temp = list[i];
    12             list[i] = list[list.length - 1 - i];
    13             list[list.length - 1 - i] = temp;
    14        }
    15         str = new String(list);
    16        System.out.println(str);
    17    }
    18 }

例三：

     1//String 常见操作——获取 2publicclass TestTrim3 {
     3publicstaticvoid main(String[] args) {
     4         String[] fileList = { "我是中国人", "我热爱我的祖国", "我在自学编程", "我将文件存为.java的形式了",
     5                 "我喜欢.java", "java读起来就很好听", "你喜欢java吗？", "和我一起学习.java",
     6                 "我通常将文件保存在E盘", "文件的名称为XXXX.java", "字节码文件为XXX.class" };
     7 8for (int i = 0; i < fileList.length; i++) {
     9if (fileList[i].startsWith("我") && fileList[i].endsWith(".java")
    10                     && fileList[i].contains("中国"))
    11                ;
    12             System.out.println("发现：" + fileList[i]);
    13        }
    14    }
    1516 }

例四：

     1publicclass TestTrim4 {
     2publicstaticvoid main(String[] args) {
     3         StringBuffer buff = new StringBuffer();
     4         buff.append("第一句话");
     5 6         StringBuffer buff2 = buff;
     7         buff2.append("这是第二句话");
     8 9        System.out.println(buff);
    10        System.out.println(buff2);
    11    }
    12 }

例五&例六：

     1//探讨StringBuffer的效率问题 2publicclass TestTrim5 {
     3publicstaticvoid main(String[] args) {
     4// 设置一个得到当前时间，来进行效率测试，以毫秒为单位。 5long begin = System.currentTimeMillis();
     6 7         String str = "";//下面沒有打印，有個小小的報錯，但不影響的 8for (int i = 0; i < 50000; i++) {
     9             str += i;
    10        }
    11long end = System.currentTimeMillis();
    1213         System.out.println("程序运行了" + (end - begin) + "毫秒");
    14//System.out.println(str);為了測試，這個地方就不打印了，等全部打印出來就太慢了15    }
    16 }

     1//用StringBuffer测试效率 2publicclass TestTrim6 {
     3publicstaticvoid main(String[] args) {
     4 5long begin = System.currentTimeMillis();
     6 7         StringBuffer buff = new StringBuffer();
     8for (int i = 0; i < 50000; i++) {
     9            buff.append(i);
    10        }
    1112long end = System.currentTimeMillis();
    1314         System.out.println("程序一共执行了" + (end - begin) + "毫秒");
    15    }
    16 }

在例五和例六中，可以从打印方式去思考，为什么例六要不例五速度快那么多。

例五的执行方式就好比：

    1
    12
    123
    1234
    12345
    123456
    1234567
    12345678
    .........
    ..........
    ...........

 例六的执行方式就不一样了：

它是执行一次之后，下一次会再上一次保留的状态下继续往上堆。

1,2,3,4,5,6,7,8,9……..（中间没有逗号哈，就是不停的往上加，直到循环结束。）

**String转换类操作**

==字符数组转成字符串

–String(char[]) 构造函数

–String(char[] value, int offset, int count)

char [] data={‘a’,’b’,’c’};

String str=new String (data);

== String类的静态方法

–static String copyValueOf(char[] data)

–static String copyValueOf(char[] data, int offset, int count)

char[] cArray=new char[]{‘广’,’阔’,’天’,’地’}; 

String str=String.copyValueOf(cArray,2,2); //从第过引为2的开始,拷贝2个

–static String valueOf(char[]); // 返回 char 数组参数的字符串表示形式。

char[] c=new char[]{‘a’,’b’,’c’,’d’};

String str=String.valueOf(c); // abcd

== 将字符串,转换成数组(字符数组,字节数组)

char [] array=str.toCharArray(); 

byte[] b=str.getBytes()//注意,这个有点不太一样,照API讲

==将基本数据类型转换成字符串

String.valueOf(89); = 89+”” //Api中,共重载了9种 

**切割替换类操作**

— String replace(CharSequence target, CharSequence replacement) //

String str=”中国人民,人民,人民”;

str=str.replace(“人民”, “百姓”);

如何把字符串中的所有的空格去掉 str=str.replace(” “,””);

— String[] split

String str=”中国,美国,法国,小日本”;

String [] list= str.split(“,”);

String str=”中国|美国|法国|小日本”;

String [] list=str.split(“|”); //注意,要对|进行转义 (.也要转义)

— String substring(int beginIndex) 

String str=”abcdefg”;

str= str.substring(2); //从索引为2的位置(含) 开始截取

System.out.println(str); //cdefg

— String substring(int beginIndex, int endIndex) beginIndex – 起始索引（包括） endIndex – 结束索引（不包括）。 顾头不顾尾

— String toUpperCase(); //转换大小写

— String toLowerCase();

— String trim(); //去空格(去两端空格)

**StringBuffer 的其他操作**

删除

StringBuffer delete(int start, int end) //清空缓冲区 buff.delete(0,buff.length())

StringBuffer deleteCharAt(int index)

获取

char charAt(int index)

int indexOf(String str)

int lastIndexOf(String str)

String subString(int index,int end)

从哪索引开始 到哪个索引 从数组的哪开始存

void getChars(int srcBegin, int srcEnd, char[] dst, int dstBegin); 将缓冲区的数据存到指定的字符数组里 //buff.getChars(2, 3, c, 3); 

修改

StringBuffer replace(start,end,String)

void setCharAt(int index,char ch);

StringBuffer reverse();

//例子:

StringBuffer buff=new StringBuffer(str);

buff.reverse();

==== StringBuilder jdk1.5 以后出现的,它的功能和 StringBuffer相同

StringBuffer 是线程安全的,没有StringBuilder速度快

StringBuilder 是线程不安全的,速度快

**包装类**

基本数据类型的包装类

8种基本数据类型 (原生类)

byte Byte

short Short

int Integer

long Long

char Character

boolean Boolean

float Float

double Double

主要用于基本数据类型和字符串之间进行转换等操作

//求int型的最大数**

System.out.println(Integer.MAX_VALUE);

//把一个字符转大写

char x=’a’;

System.out.println(Character.toUpperCase(x)); //A

//例子,将 数字转成字符串

90 +”” ;

Integer.toString(90);

//例子,将字符串转成基本数据类型

计算 “44” + “55” =99

int result= Integer.parseInt(“44”)+Integer.parseInt(“55”); //parseInt是静态方法

int a =new Integer(“22”).intValue(); //也可以

附:如果要转的字符串不符数字规则,则抛出 NumberFormatException

// 进制转换

System.out.println(Integer.toBinaryString(x)); //0b1011010

System.out.println(Integer.toHexString(x)); //0x5a

System.out.println(Integer.toOctalString(x)); //0123

**关于拆箱和装箱**

装箱:把基本数据类型,转成对象类型

拆箱:把对象类型,转成基本数类型

Integer x=new Integer(“100”); //可以

Integer y=new Integer(100); //可以

System.out.println(x==y); //false

System.out.println(x.equals(y)); //true

从 jdk1.5 以后 

Integer x=5; //可以,自动装箱 (基本数据类型,转成对象类型,叫装箱)

x=x+2; //可以,自动拆箱,做完加法以后,又自动 装箱

Integer x=null; //可以

Integer a=100;

Integer b=100;

System.out.println(a==b); true 但当 值大于128时,它为false

**BigDecimal类的应用**

BigDecimal a=new BigDecimal(“89149801457809234985932404572309”);

BigDecimal b=new BigDecimal(“89140345823459735”);

System.out.println( a.multiply(b));

它是java.math包下的

Bigdecimal 的构造函数

BigDecimal(int) 创建一个具有参数所指定整数值的对象。

BigDecimal(double) 创建一个具有参数所指定双精度值的对象。

BigDecimal(long) 创建一个具有参数所指定长整数值的对象。

BigDecimal(String) 创建一个具有参数所指定以字符串表示的数值的对象。

常用方法

add(BigDecimal) BigDecimal对象中的值相加，然后返回这个对象。

subtract(BigDecimal) BigDecimal对象中的值相减，然后返回这个对象。

multiply(BigDecimal) BigDecimal对象中的值相乘，然后返回这个对象。

divide(BigDecimal) BigDecimal对象中的值相除，然后返回这个对象。

toString() 将BigDecimal对象的数值转换成字符串。

doubleValue() 将BigDecimal对象中的值以双精度数返回。

floatValue() 将BigDecimal对象中的值以单精度数返回。

longValue() 将BigDecimal对象中的值以长整数返回。

intValue() 将BigDecimal对象中的值以整数返回。 咒

格式化及例子

由于NumberFormat类的format()方法可以使用BigDecimal对象作为其参数，

可以利用BigDecimal对超出16位有效数字的货币值，百分值，以及一般数值进行格式化控制。

以利用BigDecimal对货币和百分比格式化为例。

— 首先，创建BigDecimal对象，进行BigDecimal的算术运算后，分别建立对货币和百分比格式化的引用，

— 最后利用BigDecimal对象作为format()方法的参数，输出其格式化的货币值和百分比

**符串工具类**

import java.io.UnsupportedEncodingException;

import java.lang.reflect.Field;

import java.lang.reflect.Method;

import java.math.BigDecimal;

import java.text.ParseException;

import java.text.SimpleDateFormat;

import java.util.*;

import java.util.regex.Matcher;

import java.util.regex.Pattern;
{% endraw %}
