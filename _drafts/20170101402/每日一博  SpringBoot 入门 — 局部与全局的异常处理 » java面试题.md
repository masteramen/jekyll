---
layout: post
title:  "每日一博 | SpringBoot 入门 — 局部与全局的异常处理 » java面试题"
title2:  "每日一博  SpringBoot 入门 — 局部与全局的异常处理 » java面试题"
date:   2017-01-01 23:58:22  +0800
source:  "https://www.jfox.info/%e6%af%8f%e6%97%a5%e4%b8%80%e5%8d%9aspringboot%e5%85%a5%e9%97%a8%e5%b1%80%e9%83%a8%e4%b8%8e%e5%85%a8%e5%b1%80%e7%9a%84%e5%bc%82%e5%b8%b8%e5%a4%84%e7%90%86.html"
fileName:  "20170101402"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%af%8f%e6%97%a5%e4%b8%80%e5%8d%9aspringboot%e5%85%a5%e9%97%a8%e5%b1%80%e9%83%a8%e4%b8%8e%e5%85%a8%e5%b1%80%e7%9a%84%e5%bc%82%e5%b8%b8%e5%a4%84%e7%90%86.html"
---
{% raw %}
## SpringBoot入门——局部与全局的异常处理

## 1、构建测试代码

### (1)、新建MAVEN项目

打开IDE—新建Maven项目—构建一个简单Maven项目

![](/wp-content/uploads/2017/07/1501308785.png)

![](/wp-content/uploads/2017/07/1501308787.png)

![](/wp-content/uploads/2017/07/1501308788.png)

### (2)、编写pom.xls引入包

编写pom配置引入jar包

注：引入完毕后可能项目会报红叉，更新maven即可

    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
      <modelVersion>4.0.0</modelVersion>
      <groupId>com.springboot</groupId>
      <artifactId>springboot</artifactId>
      <version>0.0.1-SNAPSHOT</version>
      <parent>
    		<groupId>org.springframework.boot</groupId>
    		<artifactId>spring-boot-starter-parent</artifactId>
    		<version>1.4.1.RELEASE</version>
    	</parent>
    
    	<properties>
    		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    		<java.version>1.8</java.version>
    	</properties>
    
    	<dependencies>
    		<!-- 引入web相关包 -->
    		<dependency>
    			<groupId>org.springframework.boot</groupId>
    			<artifactId>spring-boot-starter-web</artifactId>
    		</dependency>
    		<!-- Springboot devtools热部署 依赖包 -->
    		<dependency>
    			<groupId>org.springframework.boot</groupId>
    			<artifactId>spring-boot-devtools</artifactId>
    			<optional>true</optional>
    			<scope>true</scope>
    		</dependency>
    
    	</dependencies>
    	<build>
    		<plugins>
    			<plugin>
    				<groupId>org.springframework.boot</groupId>
    				<artifactId>spring-boot-maven-plugin </artifactId>
    				<configuration>
    				<!-- 如果没有该项配置，devtools不会起作用，即应用不会restart -->
    					<fork>true</fork>
    				</configuration>
    			</plugin>
    		</plugins>
    	</build>
    </project>

### (3)、新建一个controller类

包名 ： com.springboot.controller

类名 ： TestController

    package com.springboot.controller;
    
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;
    
    //@RestController=@Controller+@ResponseBody
    @RestController
    @RequestMapping("/test")
    public class TestController {
    	
    	@RequestMapping("/hello1")
    	public String hello(){
    		return "hello1";
    	}
    	
    }

### (4)、新建一个Application类

包名 ： com.springboot

类名 ： TestController

    package com.springboot;
    
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    
    @SpringBootApplication
    public class Application {
    	
    	public static void main(String[] args) {
    		SpringApplication.run(Application.class, args);
    		System.out.println("_____OK______");
    	}
    	
    }

然后运行程序

### (5)、测试

输入地址 ： http://localhost:8080/test/hello1

如果显示：hello1 ，则测试成功 

测试代码编写完成

#### ———————————————————————————————————————

## 2、局部异常处理

#### 对TestController类进行操作

### (1)、创造异常点

如果设置一个变量=整数/0，则会发生ArithmeticException异常

在TestController中加入除0异常点

    @RequestMapping("/hello1")
    	public String hello(){
    		// 自己编写的除0异常
    		int a=1/0;
    
    		return "hello1";
    	}

### (2)、编写异常处理方法

在TestController中加入异常处理方法

    //局部异常处理
    	@ExceptionHandler(Exception.class)
    	public String exHandler(Exception e){
    		// 判断发生异常的类型是除0异常则做出响应
    		if(e instanceof ArithmeticException){
    			return "发生了除0异常";
    		}
    		// 未知的异常做出响应
    		return "发生了未知异常";
    	}

### (3)、测试

输入地址 ： http://localhost:8080/test/hello1

如果显示：发生了除0异常，则测试成功

#### ———————————————————————————————————————

## 3、全局异常处理

### (1)、创建一个新的Cpntroller类

包名 ： package com.springboot.controller;

类名 ： TestGlobalController

    package com.springboot.controller;
    
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;
    
    @RestController
    @RequestMapping("/test")
    public class TestGlobalController {
    	
    	@RequestMapping("/hello2")
    	public String hello2(){
    		// 自己编写的异常发生点
    		int a=1/0;
    		
    		return "hello2";
    	}
    	
    }

#### ————————————————————————————–

### (2)、编写全局异常类

包名 ： com.springboot.controller.exception

类名 ： GlobalDefaultExceptionHandler

#### ⒈全局异常处理返回字符串

    package com.springboot.controller.exception;
    
    import org.springframework.web.bind.annotation.ControllerAdvice;
    import org.springframework.web.bind.annotation.ExceptionHandler;
    import org.springframework.web.bind.annotation.ResponseBody;
    
    @ControllerAdvice
    public class GlobalDefaultExceptionHandler {
    	
    	// 全局异常处理返回字符串
    	@ExceptionHandler(Exception.class)
    	@ResponseBody
    	public String exception(Exception e){
    		// 判断发生异常的类型是除0异常则做出响应
    		if(e instanceof ArithmeticException){
    			return "全局：发生了除0异常";
    		}
    		// 未知的异常做出响应
    		return "全局：发生了未知异常";
    	}
    }

#### ⒉全局异常处理返回JSON

    // 全局异常处理返回JSON
    	@ExceptionHandler(Exception.class)
    	@ResponseBody
    	public Map<String,Object> exception(Exception e){
    		Map<String,Object> map=new HashMap<String,Object>();
    
    		// 判断发生异常的类型是除0异常则做出响应
    		if(e instanceof ArithmeticException){
    			map.put("codeNumber", "1");
    			map.put("message", e.getMessage());
    			return map;
    		}
    		// 未知的异常做出响应
    		map.put("codeNumber", "0");
    		map.put("message", e.getMessage());
    		return map;
    	}

#### ⒊全局异常处理返回JSP

    @ExceptionHandler(Exception.class)
    	public String exception(Exception e){
    
    		// 判断发生异常的类型是除0异常则做出响应
    		if(e instanceof ArithmeticException){
    			// 跳转到test.jsp页面
    			return "test";
    		}
    		// 未知的异常做出响应
    		// 跳转到test.jsp页面
    		return "test";
    	}

 注：需要配置一下才能支持jsp 

①需要在pom添加JSP的支持

    <!-- 对JSP的解析支持 -->
    		<dependency>
    			<groupId>org.apache.tomcat.embed</groupId>
    			<artifactId>tomcat-embed-jasper</artifactId>
    			<scope>provided</scope>
    		</dependency>
    		<!-- 对JSTL的支持 -->
    		<dependency>
    			<groupId>javax.servlet</groupId>
    			<artifactId>jstl</artifactId>
    		</dependency>

②需要配置application.properties

添加application.properties文件，然后往其中写入

    # 页面默认前缀目录
    spring.mvc.view.prefix=/WEB-INF/
    # 响应页面默认后缀
    spring.mvc.view.suffix=.jsp

③需要添加jsp文件

添加JSP，放置在src/main/webapp/WEB-INF目录下

### ![](/wp-content/uploads/2017/07/15013087881.png)

#### ————————————————————————————–

### (3)、全局异常类应用范围设置

#### *⒈@ControllerAdvice简介*

在spring 3.2中,新增了@ControllerAdvice 注解可以用于定义@ExceptionHandler、@InitBinder、@ModelAttribute,并应用到所有@RequestMapping中。

这里我们全局异常只应用到@ExceptionHandler

#### ***⒉设置@ControllerAdvice应用范围***

设置了@ControllerAdvice应用范围，即就设置了异常类的应用范围

@ControllerAdvice的范围有：

①basePackages：应用在xx包

②basePackageClasses：应用在xx类

③assignableTypes：应用在加了@Controller的类

④annotations：应用在带有xx注解的类或者方法

#### ————————————————————

#### ≥简单用法例子：

#### ————————————————————

@ControllerAdvice(basePackages={“com.springboot.controller”})

只捕捉com.springboot.controller包中的异常

@ControllerAdvice(basePackageClasses={TestController.class})

只捕捉TestController.class中的异常

@ControllerAdvice(assignableTypes={TestController.class})

只捕捉TestController.class中的异常

@ControllerAdvice(annotations=TestException.class)

只捕捉带有@TestException注解的类

上面四个注解一个应用包，然后的两个用在类，而最后一个只应用于带有XX注解的类

#### ————————————————————————————–

#### *3、讲讲应用在注解怎么写*

#### 1、创建一个注解类

    package com.springboot.annotation;
    
    import static java.lang.annotation.ElementType.TYPE;
    import static java.lang.annotation.RetentionPolicy.RUNTIME;
    
    import java.lang.annotation.Documented;
    import java.lang.annotation.Retention;
    import java.lang.annotation.Target;
    
    // 这种类型的Annotations将被JVM保留,所以他们能在运行时被JVM或其他使用反射
    @Retention(RUNTIME)
    // 目标类型可以应用在方法
    @Target(ElementType.TYPE)
    // 对doc文档支持
    @Documented
    public @interface TestException {
    	
    }

———————————————————————————

注：关于注解类的简说请看：

[https://my.oschina.net/u/3523885/blog/1489959](https://www.jfox.info/go.php?url=https://my.oschina.net/u/3523885/blog/1489959)

#### ———————————————————————————

#### 2、将注解加到TestController类

加入@TestException注解

    // 加入TestException注解
    @TestException
    @RestController
    @RequestMapping("/test")
    public class TestController {
    	
    	@RequestMapping("/hello1")
    	public String hello(){
    		// 自己编写的除0异常
    		int a=1/0;
    		
    		return "hello1";
    	}
    
    }

#### 3、TestController类不加注解

    @RestController
    @RequestMapping("/test")
    public class TestGlobalController {
    	
    	@RequestMapping("/hello2")
    	public String hello(){
    		// 自己编写的除0异常
    		int a=1/0;
    		
    		return "hello2";
    	}
    	
    }

#### 4、设置异常类只捕捉带有@TestException注解的类的异常

    // 设置范围应用于带有@TestException的注解的类上
    @ControllerAdvice(annotations={TestException.class})
    public class GlobalDefaultExceptionHandler {
    
    	@ExceptionHandler(Exception.class)
    	@ResponseBody
    	public String exceptionReturnString(Exception e){
    		// 判断发生异常的类型是除0异常则做出响应
    		if(e instanceof ArithmeticException){
    			return "全局：发生了除0异常";
    		}
    		// 未知的异常做出响应
    		return "全局：发生了未知异常";
    	}
    }

#### 5、测试

 输入地址 **：**http://localhost:8080/test/hello1

![](/wp-content/uploads/2017/07/15013087882.png)

输入地址：http://localhost:8080/test/hello2

![](/wp-content/uploads/2017/07/1501308789.png)
{% endraw %}
