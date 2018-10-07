---
layout: post
title:  "lombok的简单介绍和使用方法"
title2:  "lombok的简单介绍和使用方法"
date:   2017-01-01 23:57:53  +0800
source:  "http://www.jfox.info/lombok%e7%9a%84%e7%ae%80%e5%8d%95%e4%bb%8b%e7%bb%8d%e5%92%8c%e4%bd%bf%e7%94%a8%e6%96%b9%e6%b3%95-2.html"
fileName:  "20170101373"
lang:  "zh_CN"
published: true
permalink: "lombok%e7%9a%84%e7%ae%80%e5%8d%95%e4%bb%8b%e7%bb%8d%e5%92%8c%e4%bd%bf%e7%94%a8%e6%96%b9%e6%b3%95-2.html"
---
{% raw %}
这是上周在群里发现有人推荐lombok，他说是神器，当时就引起了我的好奇，然后下班回来我就看了看官网介绍（菜鸟英语水平），这就是难点了，然后就是大概了解了一下，就在网上查了查相关资料，周末的时候自己试了试，现在来做个总结：

　　官网：[http://projectlombok.org/](http://www.jfox.info/go.php?url=http://projectlombok.org/)  ；进去就有一个几分钟的视频介绍，不过是英语；还有相关的文档等。

　　lombok简介：就是通过@Data注解的方式省去了我们平时开发定义JavaBean之后，生成其属性的构造器、getter、setter、equals、hashcode、toString方法；但是，在编译时会自动生成这些方法，在.class文件中。（我就不多介绍了。。。）

　　要使用lombok，我们需要安装配置lombok，首先下载lombok.jar包：[https://projectlombok.org/download.html](http://www.jfox.info/go.php?url=https://projectlombok.org/download.html)

**安装：**

　在eclipse中安装使用：（其他开发工具我没弄）

　　　　打开eclipse.ini文件，在最后添加如下两行：

　　　　　　-javaagent:[lombok.jar所在路径] 
-Xbootclasspath/a:[lombok.jar所在路径]

　　　　然后重启eclipse。　

**lombok 注解：**
lombok 提供的注解不多，可以参考官方视频的讲解和官方文档。
文档地址：[http://projectlombok.org/features/index.](http://www.jfox.info/go.php?url=http://projectlombok.org/features/index.html)

 　　下面介绍几个常用的 lombok 注解：
@Data ：注解在类上；提供类所有属性的 getting 和 setting 方法，此外还提供了equals、canEqual、hashCode、toString 方法
@Setter：注解在属性上；为属性提供 setting 方法
@Getter：注解在属性上；为属性提供 getting 方法
@Log4j ：注解在类上；为类提供一个 属性名为log 的 log4j 日志对象
@NoArgsConstructor：注解在类上；为类提供一个无参的构造方法
@AllArgsConstructor：注解在类上；为类提供一个全参的构造方法

　在使用之前，我们需要导入相应的包：

![](/wp-content/uploads/2017/07/1500648276.png)

　下面来瞅瞅代码：

　　1、当我没有使用lombok时：

     1import java.io.Serializable;
     2 3 4import org.junit.Test;
     5import org.slf4j.Logger;
     6import org.slf4j.LoggerFactory;
     7 8 910import lombok.Data;
    11121314publicclass TestLombok implements Serializable{
    1516privatestaticfinallong serialVersionUID = 5071239632319759222L;
    17privatestaticfinal Logger logger = LoggerFactory.getLogger(TestLombok.class);
    1819private String name;
    20private String  gender;
    21privateint age;
    }

下面我们来看看其结构图：

![](/wp-content/uploads/2017/07/15006482761.png)

从图上可以发现，没有相应的getter，setter等方法。

2、下面我们再来看看加了@Data 注解之后

     1import org.junit.Test;
     2import org.slf4j.Logger;
     3import org.slf4j.LoggerFactory;
     4 5 6 7import lombok.Data;
     8 910@Data
    11publicclass TestLombok implements Serializable{
    1213privatestaticfinallong serialVersionUID = 5071239632319759222L;
    14privatestaticfinal Logger logger = LoggerFactory.getLogger(TestLombok.class);
    1516private String name;
    17private String  gender;
    18privateint age;
    }

看看结构图会是什么样子？

![](/wp-content/uploads/2017/07/1500648277.png)

从上图可以很明显的发现，加了@Data 注解之后，多了对应的getter，setter等方法。（是不是很简单，笑~~）那么我们再来简单的测试下看看能不能用吧？

    1@Test
    2publicvoid lombok(){
    3         TestLombok lombok = new TestLombok();
    4         lombok.setName("lombok");
    5         lombok.setGender("noGender");
    6         lombok.setAge(99);
    7        System.out.println(lombok.getName());
    89     }

运行结果：

![](/wp-content/uploads/2017/07/1500648278.png)

事实证明，这个是有作用的，那么对lombok，我就介绍到这儿了。下面说说我觉得的优缺点吧。

　　优点：

　　　　　1、首先，大家都看到了，这是一个很方便的工具，省去了我们不少的操作，特别是在类的属性很多的时候，代码看上去也很简洁。

　　　　　2、其次，也避免了我们在修改属性时，忘记修改字段的错误。

　　缺点：

　　　　1、虽然代码看上去很简洁，但是降低了源代码文件的可读性和完整性（你没发现看上去怪怪的吗，O(∩_∩)O哈哈哈~）

　　　　2、不支持多种参数构造器的重载。

　　其他方面的影响本人暂时还不知道，坐等其他大佬来指教，谢谢！
{% endraw %}
