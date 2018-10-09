---
layout: post
title:  "MyBatis环境的简单搭建"
title2:  "MyBatis环境的简单搭建"
date:   2017-01-01 23:56:49  +0800
source:  "https://www.jfox.info/mybatis%e7%8e%af%e5%a2%83%e7%9a%84%e7%ae%80%e5%8d%95%e6%90%ad%e5%bb%ba.html"
fileName:  "20170101309"
lang:  "zh_CN"
published: true
permalink: "2017/mybatis%e7%8e%af%e5%a2%83%e7%9a%84%e7%ae%80%e5%8d%95%e6%90%ad%e5%bb%ba.html"
---
{% raw %}
MyBatis是支持普通SQL查询，存储过程和高级映射的持久层框架。封装了几乎所有的JDBC代码和参数的手工设置以及结果集的检索。MyBatis使用简单的XML或注解做配置和定义映射关系，将接口中POJO(实体类)映射成数据库的记录。

### 2.体系架构：

加载配置 — SQL解析 — SQL执行 — 结果映射

### 3.常用对象：

SqlSessionFactoryBuilder：该对象负责根据MyBatis配置文件mybatis-config.xml(配置文件名命名可能会有所不同)构建SqlSessionFactory实例；

SqlSessionFactory：每一个MyBatis的应用程序都以SqlSessionFactory对象为核心创建SqlSession实例；

SqlSession：该对象包含了所有执行sql的操作的方法，用于执行已经映射的sql语句

### 4.说明：

这里实现的是环境的简单搭建，并测试搭建成功后执行数据库插入操作是否能够实现；

此处使用开发工具MyEclipse，数据库使用的是MySql；

 MyBatis相关jar包可去官网自行下载最新版本(不同数据库的驱动jar包也不同)，本例中使用jar包的 [下载链接](https://www.jfox.info/go.php?url=http://pan.baidu.com/s/1qYv20dI)

### 1.首先创建一个数据表，用来测试交互。

命名为Student，字段包括id,name,age,score；表结构如下

![](/wp-content/uploads/2017/07/1499955980.png)

### 2.运行MyEclipse平台，新建Java Project

项目名为MyBatisProject(以下相关文件命名自定义)

![](/wp-content/uploads/2017/07/1499955983.png)

一个新建的空工程结构如下图所示

![](/wp-content/uploads/2017/07/1499955984.png)

### 3.我们导入基本所需的jar包并Add to Build Path 添加到工程中

在根路径src下创建实体类包，接口包，测试类包；此时工程结构图如下所示

![](/wp-content/uploads/2017/07/14999559841.png)

### 4.创建相关文件及配置

新建实体类Student.java，接口StudentMapper.java及对应的配置文件mapper.xml(此处命名为StudentMapper.xml)；MyBatis配置文件mybatis.xml；

工程结构图如下

![](/wp-content/uploads/2017/07/1499955985.png)

#### 4.1文件Student.Java

    package pers.rfeng.entities;
    
    public class Student {
    
    	private Integer id;
    	private String name;
    	private int age;
    	private double score;
    	
    	public Student() {
    		super();
    	}
    
    	public Student(String name, int age, double score) {
    		super();
    		this.name = name;
    		this.age = age;
    		this.score = score;
    	}
    
    	@Override
    	public String toString() {
    		return "Student [id=" + id + ", name=" + name + ", age=" + age
    				+ ", score=" + score + "]";
    	}
    
    	public Integer getId() {
    		return id;
    	}
    
    	public void setId(Integer id) {
    		this.id = id;
    	}
    
    	public String getName() {
    		return name;
    	}
    
    	public void setName(String name) {
    		this.name = name;
    	}
    
    	public int getAge() {
    		return age;
    	}
    
    	public void setAge(int age) {
    		this.age = age;
    	}
    
    	public double getScore() {
    		return score;
    	}
    
    	public void setScore(double score) {
    		this.score = score;
    	}
    	
    }

#### 4.2文件StudentMapper.java

    package pers.rfeng.mappers;
    
    import pers.rfeng.entities.Student;
    
    public interface StudentMapper {
    
    	public void insert(Student student);
    }

#### 4.3文件StudentMapper.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE mapper
     PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
     "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="mybatis">
    	<insert id="insert" parameterType="pers.rfeng.entities.Student">
    		insert into student(name,age,score) values(#{name}, #{age}, #{score})
    	</insert>
    </mapper>

#### 4.4文件mybatis.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE configuration
     PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
     "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
    	<environments default="development">
    		<environment id="development">
    			<transactionManager type="JDBC" />
    			<dataSource type="POOLED">
    				<property name="driver" value="com.mysql.jdbc.Driver" />
    				<property name="url" value="jdbc:mysql://localhost:3306/mybatis" />
    				<property name="username" value="root" />
    				<property name="password" value="739150" />
    			</dataSource>
    		</environment>
    	</environments>
    	
    	<mappers>
    		<mapper resource="pers/rfeng/mappers/StudentMapper.xml" />
    	</mappers>
    </configuration>

#### 4.5文件log4j.xml

    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE log4j:configuration SYSTEM "log4j.dtd">
     
    <log4j:configuration xmlns:log4j="http://jakarta.apache.org/log4j/">
     <appender name="STDOUT" class="org.apache.log4j.ConsoleAppender">
       <param name="Encoding" value="UTF-8" />
       <layout class="org.apache.log4j.PatternLayout">
        <param name="ConversionPattern" value="%-5p %d{MM-dd HH:mm:ss,SSS} %m  (%F:%L) n" />
       </layout>
     </appender>
     <logger name="java.sql">
       <level value="debug" />
     </logger>
     <logger name="org.apache.ibatis">
       <level value="info" />
     </logger>
     <root>
       <level value="debug" />
       <appender-ref ref="STDOUT" />
     </root>
    </log4j:configuration>

### 5.测试MyBatis环境搭建及SqlSessionFactoryBuilder，SqlSessionFactory，SqlSession对象的使用

在测试包下创建测试类MyTest

#### 5.1文件MyTest.java

    package pers.rfeng.test;
    
    import java.io.IOException;
    import java.io.InputStream;
    
    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;
    import org.junit.Test;
    
    import pers.rfeng.entities.Student;
    
    public class MyTest {
    
    	@Test
    	public void testInsert() throws IOException{
    		InputStream inputStream = Resources.getResourceAsStream("mybatis.xml");
    		SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(inputStream);
    		SqlSession session = factory.openSession();
    		
    		Student student = new Student("jerry", 5, 88);
    		session.insert("insert",student);
    		
    		session.commit();
    	}
    }

### 6.测试testInsert方法

测试结果输出控制台如下所示，SQL语句正常执行，数据正确处理，操作正确响应。

![](/wp-content/uploads/2017/07/14999559851.png)

### 7.查询数据库，新对象确实被插入数据表中。mybatis环境基本搭建完成。
{% endraw %}
