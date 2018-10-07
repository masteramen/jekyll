---
layout: post
title:  "Java入门——（5）Java API"
title2:  "Java入门——（5）Java API"
date:   2017-01-01 23:52:19  +0800
source:  "http://www.jfox.info/java%e5%85%a5%e9%97%a85javaapi.html"
fileName:  "20170101039"
lang:  "zh_CN"
published: true
permalink: "java%e5%85%a5%e9%97%a85javaapi.html"
---
{% raw %}
int indexOf(int ch) int lastIndexOf(int ch) char charAt(int index) boolean endsWith(String suffix) int length() boolean equals(Object anObject) boolean isEmpty() boolean startsWith(String prefix) boolean contains(CharSequence cs) String toUpperCase() String toLowerCase() String valueOf(int i) char[] toCharArray() String replace(CharSequence oldstr,CharSequence newstr) String[] split(String regex) String substring(int beginIndex) String substring(int beginIndex,int endIndex) String trim() 

示例：

     1 public class Example02 {
     2     public static void main(String[] args) { 3 new Thread(new One()).start(); 4 new Thread(new Two()).start(); 5 new Thread(new Three()).start(); 6 new Thread(new Four()).start(); 7 new Thread(new Five()).start(); 8  } 9 } 10 //字符串的基本操作 11 class One implements Runnable{ 12 public void run() { 13 String s = "abcdedcba"; 14 System.out.println("字符串的长度为："+s.length()); 15 System.out.println("字符串中第一个字符："+s.charAt(0)); 16 System.out.println("字符c中第一个出现的位置："+s.indexOf('c')); 17 System.out.println("字符c中最后出现的位置："+s.lastIndexOf('c')); 18 System.out.println("_____________"); 19  } 20 } 21 //字符串的判断操作 22 class Two implements Runnable { 23 public void run() { 24 String s1 = "abcdedcba"; 25 String s2 = "ABCDEDCBA"; 26 System.out.println("字符串结尾是否是A：" + s1.endsWith("A")); 27 System.out.println("字符串s1与s2是否相同：" + s1.equals("ABCDEDCBA")); 28 System.out.println("字符串s1是否为空：" + s1.isEmpty()); 29 System.out.println("字符串s1是否以abc开头：" + s1.startsWith("abc")); 30 System.out.println("字符串s1是否包含abc：" + s1.contains("abc")); 31 System.out.println("将字符串s1转为大写：" + s1.toUpperCase()); 32 System.out.println("将字符串s2转为小写：" + s1.toLowerCase()); 33 System.out.println("_____________"); 34  } 35 } 36 //字符串的转换操作 37 class Three implements Runnable{ 38 public void run() { 39 String s3 = "abcd"; 40 System.out.print("将字符串转为字符数组后的结果"); 41 char[] charArray=s3.toCharArray(); 42 for (int i = 0;i<charArray.length;i++){ 43 if(i!=charArray.length-1){ 44 System.out.print(charArray[i]+","); 45 }else 46  System.out.println(charArray[i]); 47  } 48 System.out.println("将int值转换为String类型之后的结果："+String.valueOf(123)); 49 System.out.println("_____________"); 50  } 51 } 52 //字符串的替换和去除空格操作 53 class Four implements Runnable{ 54 public void run() { 55 String s = "itcase"; 56 System.out.print("将it替换为cn.it的结果："+s.replace("it","cn.it")); 57 String s4 = " i t c a s e "; 58 System.out.println("去除字符串两端空格后的结果："+s4.trim()); 59 System.out.println("去除字符串所有空格后的结果："+s4.replace(" ","")); 60 System.out.println("_____________"); 61 62  } 63 } 64 //字符串的截取和分割 65 class Five implements Runnable{ 66 public void run() { 67 String str = "羽毛球-篮球-乒乓球"; 68 System.out.println("从第五个字符截取到末尾的结果："+str.substring(4)); 69 System.out.println("从第五个字符截取到第六个字符的结果："+str.substring(4,6)); 70 System.out.print("分割后的字符串数组中的元素依次为："); 71 String[] strArray = str.split("-"); 72 for (int i = 0;i<strArray.length;i++){ 73 if(i!=strArray.length-1){ 74 System.out.print(strArray[i]+","); 75 }else { 76  System.out.println(strArray[i]); 77  } 78  } 79 System.out.println("_____________"); 80  } 81 }

运行结果：

    字符串的长度为：9
    字符串中第一个字符：a
    字符c中第一个出现的位置：2 字符c中最后出现的位置：6 _____________ 字符串结尾是否是A：false 字符串s1与s2是否相同：false 字符串s1是否为空：false 字符串s1是否以abc开头：true 字符串s1是否包含abc：true 将字符串s1转为大写：ABCDEDCBA 将字符串s2转为小写：abcdedcba _____________ 将字符串转为字符数组后的结果a,b,c,d 将int值转换为String类型之后的结果：123 _____________ 从第五个字符截取到末尾的结果：篮球-乒乓球 从第五个字符截取到第六个字符的结果：篮球 分割后的字符串数组中的元素依次为：将it替换为cn.it的结果：cn.itcase去除字符串两端空格后的结果：i t c a s e 去除字符串所有空格后的结果：itcase _____________ 羽毛球,篮球,乒乓球 _____________

4、StringBuffer：字符串缓冲区，类似是一个字符容器，将任何数据转变字符串进行添加。
 

  5、StringBuffer类常用方法： 
 
 
 StringBuffer append(char c)StringBuffer insert(int offset ,String str)StringBuffer deleteCharAt(int index)StringBuffer delete(int start, int end)StringBuffer replace(int start ,int end, String str)void setCharAt(int index,char ch)String toString()StringBuffer reverse() 示例： 
  
  
     1 public class Example08 {
     2     public static void main(String[] args) { 3  add(); 4 new Thread(new remove()).start(); 5 System.exit(0); 6 new Thread(new alter()).start(); 7  } 8 public static void add() { 9 System.out.println("1、添加——————————————————"); 10 StringBuffer sb = new StringBuffer(); //定义一个字符串缓冲区 11 sb.append("abcdefg");//在末尾添加字符串 12 System.out.println("append添加结果：" + sb); 13 sb.insert(2, "123"); 14 System.out.println("insert添加结果：" + sb); 15  } 16 } 17 class remove implements Runnable{ 18  @Override 19 public void run() { 20 System.out.println("2、删除——————————————————"); 21 StringBuffer sb = new StringBuffer("abcdefg"); 22 sb.delete(1,5);//指定范围删除 23 System.out.println("删除指定范围结果："+sb); 24 sb.deleteCharAt(2);//指定位置删除 25 System.out.println("删除指定位置结果："+sb); 26 sb.delete(0,sb.length());//清除缓存区 27 System.out.println("清空缓冲区结果："+sb); 28  } 29 } 30 class alter implements Runnable{ 31  @Override 32 public void run() { 33 System.out.println("3、修改——————————————————"); 34 StringBuffer sb = new StringBuffer("abcdefg"); 35 sb.setCharAt(1,'p');//修改指定位置字符 36 System.out.println("修改指定位置字符结果："+sb); 37 sb.replace(1,3,"qq");//替换指定位置字符串或字符 38 System.out.println("替换指定位置字符串或字符结果："+sb); 39 System.out.println("字符串翻转结果："+sb.reverse()); 40  } 41 }

运行结果：

    1、添加——————————————————
    append添加结果：abcdefg
    insert添加结果：ab123cdefg
    2、删除—————————————————— 删除指定范围结果：afg 删除指定位置结果：af 清空缓冲区结果：

6、StringBuffer与String的区别

①String类表示的字符串是常量，一旦创建后，内容和长度都是无法改变的，而StringBuffer表示字符容器，其内容和长度都可以随时改变。

②String类覆盖了Object类的equals()方法，而StringBuffer类没有覆盖。

③String类对象可以用操作符+进行连接，而StringBuffer类对象之间不能。
 
  

  二、System类常用方法 
 
 
 static void exit(int status)static long gc()**static long currentTimeMills()****static void arraycopy(Object src ,int srcPos,Object dest,int destPos,int length)**static Properties getProperties()static String getProperty(String key) 
 

  Runtime类用于表示虚拟机运行时的状态，它用于封装JVM虚拟机进程。实例方法：Runtime run = Runtime.getRuntime(); 
  

  三、Math类与Random类 
 

  1、Math类是数学操作类，静态方法。如 
 
 
  
  
     1 public class Testt01 {
     2     public static void main(String[] args) { 3 System.out.println("取绝对值："+Math.abs(-2)); 4 System.out.println("向上取整："+Math.ceil(2.1)); 5 System.out.println("四舍五入："+Math.round(2.1)); 6 System.out.println("向下取整："+Math.floor(2.1)); 7 System.out.println("取最大值："+Math.max(3.2,2.1)); 8 System.out.println("取最小值："+Math.min(3.21,2.1)); 9 System.out.println("反余弦："+Math.acos(Math.PI/90)); 10 System.out.println("反正弦："+Math.asin(Math.PI/45)); 11 System.out.println("反正切："+Math.atan(12)); 12 System.out.println(Math.atan2(12,12)); 13 System.out.println("余弦："+Math.cos(Math.PI/3)); 14 System.out.println("正弦："+Math.sin(30*Math.PI/180));//单位为弧度，30度用弧度表示（30*Math.PI/180）； 15 System.out.println("自然对数的底数e："+Math.E); 16 System.out.println("自然对数的底数e的n次方："+Math.exp(12)); 17 System.out.println("圆周率："+Math.PI); 18 System.out.println("平方根："+Math.sqrt(5)); 19 System.out.println("生成一个大于等于0.0小于1.0的随机值："+Math.random()); 
    20 System.out.println("2的3次方："+Math.pow( 2,3 )); 
    21 System.out.println( System.currentTimeMillis() );//获得当前系统时间，运行程序最省内存 
    22 System.out.println( new Date().getTime() );
    23 System.out.println( Calendar.getInstance().getTime() );
    24 
    25 } 
    26 }

运行结果：

     1 取绝对值：2
     2 向上取整：3.0
     3 四舍五入：2
     4 向下取整：2.0
     5 取最大值：3.2
     6 取最小值：2.1
     7 反余弦：1.5358826490960904
     8 反正弦：0.06987000497506388
     9 反正切：1.4876550949064553
    10 0.7853981633974483
    11 余弦：0.5000000000000001
    12 正弦：0.49999999999999994
    13 自然对数的底数e：2.718281828459045
    14 自然对数的底数e的n次方：162754.79141900392
    15 圆周率：3.141592653589793
    16 平方根：2.23606797749979
    17 生成一个大于等于0.0小于1.0的随机值：0.3660454717733955
    18 2的3次方：8.0
    19 1498976435080
    20 1498976435085
    21 Sun Jul 02 14:20:35 CST 2017

 
  
  

  2、Rondom类，非静态方法 
 

  Rondom类构造方法：Rondom()；Rondom（ long seed）; 
 

  Rondom类常用方法 
 
 
 boolean nextBoolean()double nextDouble()float nextFloat()int nextInt()int nextInt(int n)long nextLong()
示例：

     1 public class Example16 {
     2     public static void main(String[] args) { 3 new Thread(new One()).start(); 4 new Thread(new Two()).start(); 5 new Thread(new Three()).start(); 6  } 7 } 8 class One implements Runnable{ 9 public void run() { 10 Random r = new Random();//不传入种子 11 // 随机产生10个[0,100)之间的整数 12 for (int x=0;x<10;x++){ 13 System.out.println(r.nextInt(100)); 14  } 15 System.out.println("_____________"); 16  } 17 } 18 class Two implements Runnable{ 19 public void run() { 20 Random r = new Random(13);//不传入种子 21 // 随机产生10个[0,100)之间的整数 22 for (int x=0;x<10;x++){ 23 System.out.println(r.nextInt(100)); 24  } 25 System.out.println("_____________"); 26  } 27 } 28 class Three implements Runnable{ 29 public void run() { 30 Random r = new Random(); 31 System.out.println("产生float类型随机数"+r.nextFloat()); 32 System.out.println("产生0~100之间int类型随机数"+r.nextInt(100)); 33 System.out.println("产生double类型随机数"+r.nextDouble()); 34 System.out.println("_____________"); 35  } 36 }

运行结果：

     1 90
     2 98
     3 23
     4 17
     5 97
     6 66
     7 10
     8 42
     9 10
    10 67
    11 _____________
    12 92
    13 0
    14 75
    15 98
    16 63
    17 10
    18 93
    19 13
    20 56
    21 14
    22 _____________ 23 产生float类型随机数0.9580269 24 产生0~100之间int类型随机数44 25 产生double类型随机数0.13987266903473206 26 _____________

 
  
 

  四、针对日期类型的操作类有三个，分别是java.util.Date，java.util.Calendar和 java.text.DateFormat 。 
 

  1、Date类用于表示日期和时间：其中构造方法： 
 

  ①Date()用于创建当前日期时间的Date对象， 
 

  ②Date(long date)用于创建指定时间的Date对象。创建如： 
 

  Date date1 = new Date（）； 
 

  Date date2 = new Date（9666546565L ）； 
  

  2、Calendar类用于完成日期和时间字段的操作，为抽象类，不能被实例化，在程序中需要调用其静态方法getInstance()来得到一个Calendar对象，然后调用其相应的方法： 
 

  Calendar calendar = Calendar.getInstance（）； 
 

  Calendar常用方法： 
 
 
 int get(int field)返回指定日历字段的值，如 ：calendar.(Calendar.YERR);void add（int field，int amount）void set(int field,int value)void set(int year,int month,int date)void set(int year,int month,int date,int hourOfDay,int minute,int second) 
 

  注意：Calendar.MONTH字段月份的起始值是从0开始而不是1 。 
  

  示例： 
  
  
     1 public class Example {
     2     public static void main(String[] args) { 3 new Thread(new One()).start(); 4 new Thread(new Two()).start(); 5  } 6 } 7 class One implements Runnable { 8 public void run() { 9 Date date = new Date(); 10 Date date2 = new Date(966666666666L); 11  System.out.println(date); 12  System.out.println(date2); 13 System.out.println("--------------"); 14  } 15 } 16 class Two implements Runnable { 17 public void run() { 18 Calendar calendar = Calendar.getInstance();//获取表示当前时间的Calendar 19 int year = calendar.get(Calendar.YEAR); 20 int month = calendar.get(Calendar.MONTH)+1; 21 int date = calendar.get(Calendar.DATE); 22 int hour = calendar.get(Calendar.HOUR); 23 int minute = calendar.get(Calendar.MINUTE); 24 int second = calendar.get(Calendar.SECOND); 25 System.out.println("当前时间为："+year+"年"+month+"月"+date+"日"+hour+"时"+minute+"分"+second+"秒"); 26 System.out.println("--------------"); 27  } 28 }

运行结果：

    Sun Jul 02 14:29:41 CST 2017
    Sat Aug 19 14:31:06 CST 2000
    ------------- 当前时间为：2017年7月2日2时29分41秒 --------------

 
   
  

  3、DateFormat类，专门用于将日期格式化为字符串或者用特定格式显示的日期字符串转换成一个Date对象，抽象类不可实例化，但提供静态方法。 
 

  SimpleDateFormat ，DateFormat类子类，可通过new创建实例对象， 是一个以语言环境敏感的方式来格式化和分析日期的类。SimpleDateFormat 允许你选择任何用户 自定义日期时间格式来运行。如： 
 

  SimpleDateFormat ft = new SimpleDateFormat (“E yyyy.MM.dd ‘at’ hh:mm:ss a zzz”); 
 

  这一行代码确立了转换的格式，其中 yyyy 是完整的公元年，MM 是月份，dd 是日期，HH:mm:ss 是时、分、秒。 
 

  注意:有的格式大写，有的格式小写，例如 MM 是月份，mm 是分；HH 是 24 小时制，而 hh 是 12 小时制。 
 

  以上实例编译运行结果如下: 
 

  Current Date: Sun 2014.07.18 at 14:14:09 PM PDT 
 

  其中parse(String source)方法，它试图按照给定的SimpleDateFormat 对象的格式化存储来解析字符串。 
 

  示例： 
 
 
  
  
     1 public class Example {
     2     public static void main(String[] args) throws Exception{ 3 // 创建一个SimpleDateFormat 对象 4 SimpleDateFormat df1 = new SimpleDateFormat( 5 "Gyyyy年MM月dd日：今天是yyyy年的第D天，E"); 6 // SimpleDateFormat 对象的日期模板格式化Date对象 7 System.out.println(df1.format(new Date())); 8 9 SimpleDateFormat df2 = new SimpleDateFormat("yyyy年MM月dd日"); 10 String dt = "2012年8月3日"; 11 // 将字符串解析成Date对象 12  System.out.println(df2.parse(dt)); 13  } 14 }

运行结果：

    AD2017年07月02日：今天是2017年的第183天，Sun
    Fri Aug 03 00:00:00 CST 2012
{% endraw %}
