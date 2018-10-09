---
layout: post
title:  "浅入深出之Java集合框架（中）"
title2:  "浅入深出之Java集合框架（中）"
date:   2017-01-01 23:54:41  +0800
source:  "https://www.jfox.info/%e6%b5%85%e5%85%a5%e6%b7%b1%e5%87%ba%e4%b9%8bjava%e9%9b%86%e5%90%88%e6%a1%86%e6%9e%b6%e4%b8%ad.html"
fileName:  "20170101181"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%b5%85%e5%85%a5%e6%b7%b1%e5%87%ba%e4%b9%8bjava%e9%9b%86%e5%90%88%e6%a1%86%e6%9e%b6%e4%b8%ad.html"
---
{% raw %}
# 浅入深出之Java集合框架（中） 


# Java中的集合框架（中）

由于Java中的集合框架的内容比较多，在这里分为三个部分介绍Java的集合框架，内容是从浅到深，如果已经有java基础的小伙伴可以直接跳到<浅入深出之Java集合框架（下）>。

### 目 录

*[浅入深出之Java集合框架（上）](https://www.jfox.info/go.php?url=http://www.cnblogs.com/hysum/p/7136480.html)*

*浅入深出之Java集合框架（下）　*努力赶制中。。*关注后更新会提醒哦！***

### **前 言**

在<*[浅入深出之Java集合框架（上）](https://www.jfox.info/go.php?url=http://www.cnblogs.com/hysum/p/7136480.html)*>中介绍了List接口和Set接口的基本操作，在这篇文章中，我将介绍关于Map接口的基本操作。使用的示例是在<*[浅入深出之Java集合框架（上）](https://www.jfox.info/go.php?url=http://www.cnblogs.com/hysum/p/7136480.html)*>中的模拟学生选课的小程序，不清楚的朋友可以先去阅读<*[浅入深出之Java集合框架（上）](https://www.jfox.info/go.php?url=http://www.cnblogs.com/hysum/p/7136480.html)*>。

##  一、Map&HashMap简介

#### 1）Map接口

1. Map接口提供了一中映射关系，其中的元素是键值对（key-value）的形式存储的，能够实现根据Key快速查找value。Key-value可以是任何对象，是以Entry类型的对象实例存在的。

2.Key是不可以重复的，Value是可以重复的。Key-value都可以为null，不过只能有一个key是null。

3.Map支持泛型，Map<K,V>

4.每个键最多只能映射到一个值

5.Map接口提供了分别返回key值集合、value值集合以及Entry（键值对）集合的方法

6.通过put<K key,V value>,remove<Object key>操作数

#### 2）HashMap实现类

1.  HashMap中的Entry对象是无序排列的，HashMap是Map的一个重要实现类，也是最常用的，基于哈希表是实现

2.  Key值和value值都可以为null，但是一个HashMap只能有一个key值为null的映射（key不可重复）

##  二、学生选课——使用Map添加学生

#### 案例功能说明

1.通过Map<String,Student>进行学生信息管理，其中key为学生ID，value为学生对象。

2.通过键盘输入学生信息

3.对集合中的学生信息进行增删该查操作

首先创建一个StuMap类来测试Map的使用方法。如下：

     1/** 2 * 学生类的Map集合类
     3 * 
     4 * @author acer
     5 *
     6*/ 7publicclass StuMap {
     8// 用来承装学生类型对象 9private Map<String, Student> students;
    10privatestatic Scanner in;
    11    {
    12         in = new Scanner(System.in);
    13    }
    1415public StuMap() {
    16         students = new HashMap<String, Student>();
    1718    }
    19//省略方法，下面的方法会逐个列出20 }

**>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>**

和List接口不同，向Map添加对象使用的是put(key,value)方法。以下是使用示例：

     1/* 2     * 添加学生类 输入学生id，
     3     * 判断是否被占用 若未被占用，则输入姓名，创建新的学生对象，并且把该对象添加到Map中
     4     * 否则，则提示已有该id
     5*/ 6publicvoid AddStu() {
     7         System.out.println("请输入要添加的学生id：");
     8         String Id = in.next();// 接受输入的id 9         Student st=students.get(Id);
    10if(st==null){
    1112             System.out.println("请输入要添加的学生姓名：");
    13             String name = in.next();// 接受输入的name14this.students.put(Id, new Student(Id, name));
    15         }else{
    16             System.out.println("此Id已被占用！");
    17        }
    1819     }

再写一个打印输出的测试函数，如：

     1/* 2     * 打印学生类
     3     * 
     4*/ 5publicvoid PrintStu() {
     6         System.out.println("总共有"+this.students.size()+"名学生：");
     7//遍历keySet 8for (String s : this.students.keySet()) {
     9             Student st=students.get(s);
    10if(st!=null){
    11             System.out.println("学生：" + students.get(s).getId() + "," + students.get(s).getName());
    12            }
    13        }
    14     }

上面的例子是使用Map的keySet()返回Map中的key的Set集合再用if进行判断输出，在Map还可以用entrySet()的方法返回Map中的键值对Entry，如：

     1/* 2     * 通过entrySet方法遍历Map
     3*/ 4publicvoid EntrySet(){
     5         Set<Entry<String, Student>> entrySet =students.entrySet();
     6for(Entry<String, Student> entry:entrySet){
     7             System.out.println("取得建："+entry.getKey());
     8             System.out.println("对应的值："+entry.getValue().getName());
     910        }
    11     }

最后我们用主函数调用一下这些函数来看看效果如何

    1publicstaticvoid main(String[] args) {
    2         StuMap stu = new StuMap();
    3for (int i = 0; i < 3; i++) {
    4            stu.AddStu();
    5        }
    6        stu.PrintStu();
    7        stu.EntrySet();
    8     }

代码分析：

1.student.get(ID)是采用Map的get（）方法，检测是否存在值为ID的学生，如果没有，则返回null。这里的案例是把Map中的key值设为学生的ID值，所以可以用这样的方式来检测，如果key值是学生其他属则性另当别论！！

2.keySet()方法，返回所有键的Set集合。

3.keyset()返回Map中所有的key以集合的形式可用Set集合接收，HashMap当中的映射是无序的。

3.Map还可以用entrySet()的方法返回Map中的键值对Entry，Entry也是Set集合，它可以调用getKey()和getValue()方法来分别得到键值对的**“键”和“值”**。

运行结果：

##  三、学生选课——删除Map中的学生

删除Map中的键值对是调用remove(object key)方法，下面是它的使用示例：

     1/* 2     * 删除map中映射
     3*/ 4publicvoid RemoveStu(){
     5do{
     6         System.out.println("请输入要删除的学生id：");
     7         String Id = in.next();// 接受输入的id 8         Student st=students.get(Id);
     9if(st==null){
    10             System.out.println("此id不存在！");
    1112         }else{
    13this.students.remove(Id);
    14             System.out.println("成功删除"+st.getId()+","+st.getName()+"同学");
    15break;
    16        }
    17         }while(true);
    18     }

运行结果：

##  四、学生选课——修改Map中的学生

修改Map中的键值对有两种方法，第一种就是用**put方法**。其实就是添加方法中的put，使用方法跟添加无异，这里的本质就是利用put把原来的数据给覆盖掉，即修改。

     1/* 2     * 利用put方法修改Map中的value值
     3*/ 4publicvoid ModifyStu(){
     5do{
     6             System.out.println("请输入要修改的学生id：");
     7             String Id = in.next();// 接受输入的id 8             Student st=students.get(Id);
     9if(st==null){
    10                 System.out.println("此id不存在！");
    1112             }else{
    13                 System.out.println("学生原来的姓名："+st.getName()+"，请输入修改后的姓名：");
    14                 String name = in.next();// 接受输入的name15                 st=new Student(Id,name);
    16this.students.put(Id,st);
    17                 System.out.println("成功修改！修改后的学生为："+st.getId()+","+st.getName()+"同学");
    18break;
    19            }
    20             }while(true);
    2122     }

除了用put方法外，Map中提供一个叫做replace的方法，知名知其意，就是“替换”的意思。replace的方法使用和put方法一样，这是因为它的内部源码如下：

    1if (map.containsKey(key)) {
    2return map.put(key, value);
    3  } else4returnnull;
    5

可以看出replace方法就是调用put方法来完成修改操作的，但是我们为了和添加put进行区分，最好在使用修改的时候用replace方法进行修改。这样的代码可读性和维护性就增强了。

那么使用replace修改Map中的value值如下：**（推荐使用replace方法）**

     1/* 2     * 利用replace方法修改Map中的value值
     3*/ 4publicvoid Modify(){
     5do{
     6             System.out.println("请输入要修改的学生id：");
     7             String Id = in.next();// 接受输入的id 8             Student st=students.get(Id);
     9if(st==null){
    10                 System.out.println("此id不存在！");
    1112             }else{
    13                 System.out.println("学生原来的姓名："+st.getName()+"，请输入修改后的姓名：");
    14                 String name = in.next();// 接受输入的name15                 st=new Student(Id,name);
    16this.students.replace(Id, st);
    17                 System.out.println("成功修改！修改后的学生为："+st.getId()+","+st.getName()+"同学");
    18break;
    19            }
    20             }while(true);
    21     }

运行结果：

##  五、总结

Map** –特点**：元素成对出现，key-value，是映射关系，key不能重复，但value可以重复，也就是说，可以多key对一个value。支持泛型如Map<yy1, yy2>。

–**实现类**：HashMap是最常用的，HashMap中是无序排列，其元素中key或value可为null(但只能有一个为null)。

–**声明(泛型)举例**： 在类中声明 public Map<类型1, 类型2> xxx; 然后再构造方法中this.xxx = new HashMap<类型1, 类型2();

–**获取**：yy temp = xxx.get(key)

–**添加**：xxx.put( key(xx型), zz(yy型) );

–**返回map中所有key（返回是set型集合形式）** set xxxxx = xxx.keyset(); 用于遍历。

–**返回map中所有entry对（key-value对）**（返回是set型集合形式） set<Entry<xx, yy>> xxxxx = xxx.entrySet(); 同样用于遍历。 遍历时：for(Entry<xx,yy> 元素: xxxxx)

–**删除**：xxx.remove(key);

 –**修改：**可以用put，当put方法传入的key存在就相当于是修改（覆盖）；但是推荐使用replace方法！

本章主要介绍了Map接口的基本操作，发出下一篇预告：集合的基本操作不够用怎么办？如何判断集合中的某个元素对象是否存在？如何对List集合进行排序呢？这些问题是否困扰着你呢，在下一篇中博主将会针对这些问题来给大家介绍java集合框架的其他成员，后续如何请**关注**~~
{% endraw %}
