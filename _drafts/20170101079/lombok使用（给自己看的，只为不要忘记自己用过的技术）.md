---
layout: post
title:  "lombok使用（给自己看的，只为不要忘记自己用过的技术）"
title2:  "lombok使用（给自己看的，只为不要忘记自己用过的技术）"
date:   2017-01-01 23:52:59  +0800
source:  "https://www.jfox.info/lombok%e4%bd%bf%e7%94%a8%e7%bb%99%e8%87%aa%e5%b7%b1%e7%9c%8b%e7%9a%84%e5%8f%aa%e4%b8%ba%e4%b8%8d%e8%a6%81%e5%bf%98%e8%ae%b0%e8%87%aa%e5%b7%b1%e7%94%a8%e8%bf%87%e7%9a%84%e6%8a%80%e6%9c%af.html"
fileName:  "20170101079"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/lombok%e4%bd%bf%e7%94%a8%e7%bb%99%e8%87%aa%e5%b7%b1%e7%9c%8b%e7%9a%84%e5%8f%aa%e4%b8%ba%e4%b8%8d%e8%a6%81%e5%bf%98%e8%ae%b0%e8%87%aa%e5%b7%b1%e7%94%a8%e8%bf%87%e7%9a%84%e6%8a%80%e6%9c%af.html"
---
{% raw %}
一、1）eclipse使用方法

1. 从项目首页下载lombok.jar

2. 双击lombok.jar, 将其安装到eclipse中(该项目需要jdk1.6+的环境)

  2）idea使用方法

 1.打开IDEA的Settings面板，并选择Plugins选项，然后点击 “Browse repositories..” 

2.输入lombok；安装lombok plugin插件

二、添加maven依赖

`<dependency>`

    <groupId>org.projectlombok</groupId><artifactId>lombok</artifactId><version>1.16.6</version><scope>provided</scope></dependency>
    

  下面只是介绍了几个常用的注解，更多的请参见[https://projectlombok.org/features/index.html](https://www.jfox.info/go.php?url=https://projectlombok.org/features/index.html)。

### @Getter / @Setter

  可以作用在类上和属性上，放在类上，会对所有的非静态(non-static)属性生成Getter/Setter方法，放在属性上，会对该属性生成Getter/Setter方法。并可以指定Getter/Setter方法的访问级别。

### @EqualsAndHashCode

  默认情况下，会使用所有非瞬态(non-transient)和非静态(non-static)字段来生成equals和hascode方法，也可以指定具体使用哪些属性。

### @ToString

  生成toString方法，默认情况下，会输出类名、所有属性，属性会按照顺序输出，以逗号分割。

### @NoArgsConstructor, @RequiredArgsConstructor and @AllArgsConstructor

  无参构造器、部分参数构造器、全参构造器，当我们需要重载多个构造器的时候，Lombok就无能为力了。

### @Data

  @ToString, @EqualsAndHashCode, 所有属性的@Getter, 所有non-final属性的@Setter和@RequiredArgsConstructor的组合，通常情况下，我们使用这个注解就足够了。

     

    @Data
    @Log4j
    @NoArgsConstructor
    @AllArgsConstructor
    publicclass Person {
    
        private String id;
        private String name;
        private String identity;
        
    }

1. 从项目首页下载lombok.jar

2. 双击lombok.jar, 将其安装到eclipse中(该项目需要jdk1.6+的环境)
{% endraw %}
