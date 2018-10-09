---
layout: post
title:  "dos命令-环境变量-数据类型-命名规范"
title2:  "dos命令-环境变量-数据类型-命名规范"
date:   2017-01-01 23:53:03  +0800
source:  "https://www.jfox.info/dos%e5%91%bd%e4%bb%a4%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b%e5%91%bd%e5%90%8d%e8%a7%84%e8%8c%83.html"
fileName:  "20170101083"
lang:  "zh_CN"
published: true
permalink: "2017/dos%e5%91%bd%e4%bb%a4%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b%e5%91%bd%e5%90%8d%e8%a7%84%e8%8c%83.html"
---
{% raw %}
2、能够使用常见的DOS命令
d: — 回到d盘根目录；
cd.. — 返回上级目录（以C盘为例）；
cd “文件名” — 打开文件夹；
dir — 查看当前文件夹；
cls — 清屏；
exit — 退出；

3、能够编写HelloWorld源文件
public class HelloWorld{
public static void main(String[] args){
System.out.println(“HelloWorld!”);
}
}

4、能够编译HelloWorld.java
dos进入需编译的源文件（.java）文件夹–dos窗口输入javac.exe路径  .java文件–enter–生成.class文件
5、能够运行HelloWorld.class文件
dos进入需运行的.class文件所在文件夹–dos窗口输入java.exe路径  .class文件–enter–窗口输出

6、能够独立配置path环境变量
环境变量配置需修改两个地方：
a.系统–高级系统设置–环境变量–系统变量–新建–名称（JAVA_HOME）,变量值(D:JAVA);
b.系统–高级系统设置–环境变量–系统变量–找到“PATH”–在最前加上”%JAVA_HOME%bin;……”

7、能够在源代码中使用注释
java中注释分为三类：
a.单行注释  //
b.多行注释  /*  */
c.文档注释  /**  */

8、能够解释关键字的概念
关键字是JAVA赋予特殊含义的单词，其特征为全为小写，且在特定软件中会以颜色标示。

9、能够理解常量的概念和分类
常量分为6类：
a.整数
b.小数
c.字符
d.字符串
e.布尔型
f.空值

10.能够复述变量的概念
变量分为两类：基础变量，引用变量
引用变量如数组、接口等
基础变量分为4类8小种
a.整型
1)byte 1字节
2)short 2字节
3)int(默认) 4字节
4)long 8字节
b.浮点型
1)float 4字节
2)double(默认) 8字节
c.布尔型：boolean–true/false 1字节,默认值为false.
d.字符型:char 2字节

![](/wp-content/uploads/2017/07/1499266501.png)

11、能够记住变量的定义格式
两种定义方式：
a. int b;
b = 130;
b. int b = 130;
注意：各变量类型的数据范围；变量必须初始化才能使用；

12.能够使用标识符定义变量和类名   
标识符是指命名规范，有如下几点：
a.命名可使用字母/数字/$/_;
b.数字和_不可开头；
c.包的命名，各单词首字母均为小写；
d.类的命名，各单词首字母均为大写(大驼峰命名法)；
e.变量命名，第一个单词首字母小写，其后各单词首字母大写（小驼峰命名法）；
f.方法命名，第一个单词首字母小写，其后各单词首字母大写（小驼峰命名法）；

13.反编译
javap <option> 编译后的class文件(文件名加不加.class都可)
-c:分解方法代码,显示每个方法的具体字节码
-l:指定显示行号和局部变量列表
-verbose:显示详细信息
-public|protected|default|private:显示该级别的类成员
{% endraw %}
