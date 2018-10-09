---
layout: post
title:  "springboot结合服务化框架motan"
title2:  "springboot结合服务化框架motan"
date:   2017-01-01 23:52:00  +0800
source:  "https://www.jfox.info/springboot%e7%bb%93%e5%90%88%e6%9c%8d%e5%8a%a1%e5%8c%96%e6%a1%86%e6%9e%b6motan.html"
fileName:  "20170101020"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springboot%e7%bb%93%e5%90%88%e6%9c%8d%e5%8a%a1%e5%8c%96%e6%a1%86%e6%9e%b6motan.html"
---
{% raw %}
springboot极大地提升了java应用的开发体验，感觉特别酸爽。服务化框架可谓是大型系统必用，比较古典的是阿里开源的dubbo，可惜很早就不更新了，研究其代码来看，感觉不够轻量，幸运的是去年微博开源了自己的轻量级服务化框架motan。本文阐述下如何在springboot下用motan。

服务方：

    whatsmars-motan
      |-src
        |-main
          |-java
            |-com.weibo.motan.demo.service
    	  |-impl
    	    MotanDemoServiceImpl.java
    	  APP.java
    	  MotanDemoService.java
          |-resource
            |-spring
    	  motan_demo_server.xml
    	log4j.properties
      pom.xml

依赖：

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
        <modelVersion>4.0.0</modelVersion>
    
        <artifactId>whatsmars-motan</artifactId>
    
        <properties>
            <!-- The main class to start by executing java -jar -->
            <start-class>com.weibo.motan.demo.service.App</start-class>
            <motan.version>0.1.1</motan.version>
        </properties>
    
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>1.5.2.RELEASE</version>
        </parent>
    
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter</artifactId>
            </dependency>
            <!--weibo motan-->
            <dependency>
                <groupId>com.weibo</groupId>
                <artifactId>motan-core</artifactId>
                <version>${motan.version}</version>
            </dependency>
            <dependency>
                <groupId>com.weibo</groupId>
                <artifactId>motan-transport-netty</artifactId>
                <version>${motan.version}</version>
            </dependency>
            <dependency>
                <groupId>com.weibo</groupId>
                <artifactId>motan-registry-consul</artifactId>
                <version>${motan.version}</version>
            </dependency>
            <dependency>
                <groupId>com.weibo</groupId>
                <artifactId>motan-registry-zookeeper</artifactId>
                <version>${motan.version}</version>
            </dependency>
    
            <!-- dependencies blow were only needed for spring-based features -->
            <dependency>
                <groupId>com.weibo</groupId>
                <artifactId>motan-springsupport</artifactId>
                <version>${motan.version}</version>
            </dependency>
        </dependencies>
    
        <build>
            <finalName>${project.artifactId}</finalName>
            <resources>
                <resource>
                    <directory>src/main/resources</directory>
                    <filtering>true</filtering>
                </resource>
            </resources>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                    <dependencies>
                        <dependency>
                            <groupId>org.springframework</groupId>
                            <artifactId>springloaded</artifactId>
                            <version>1.2.6.RELEASE</version>
                        </dependency>
                    </dependencies>
                </plugin>
            </plugins>
        </build>
    </project>

 demo_motan_server.xml

    <?xml version="1.0" encoding="UTF-8"?>
    
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:motan="http://api.weibo.com/schema/motan"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.5.xsd
           http://api.weibo.com/schema/motan http://api.weibo.com/schema/motan.xsd">
    
        <!-- 业务具体实现类 -->
        <!-- <bean id="motanDemoServiceImpl" class="com.weibo.motan.demo.service.impl.MotanDemoServiceImpl"/> -->
    
        <!-- 注册中心配置 使用不同注册中心需要依赖对应的jar包。如果不使用注册中心，可以把check属性改为false，忽略注册失败。-->
        <!--<motan:registry regProtocol="local" name="registry" />-->
        <!--<motan:registry regProtocol="consul" name="registry" address="127.0.0.1:8500"/>-->
        <motan:registry regProtocol="zookeeper" name="registry" address="127.0.0.1:2181"/>
    
        <!-- 协议配置。为防止多个业务配置冲突，推荐使用id表示具体协议。-->
        <motan:protocol id="demoMotan" default="true" name="motan"
                        maxServerConnection="80000" maxContentLength="1048576"
                        maxWorkerThread="800" minWorkerThread="20"/>
    
        <!-- 通用配置，多个rpc服务使用相同的基础配置. group和module定义具体的服务池。export格式为“protocol id:提供服务的端口”-->
        <motan:basicService export="demoMotan:8002"
                            group="motan-demo-rpc" accessLog="false" shareChannel="true" module="motan-demo-rpc"
                            application="myMotanDemo" registry="registry" id="serviceBasicConfig"/>
    
        <!-- 具体rpc服务配置，声明实现的接口类。-->
        <motan:service interface="com.weibo.motan.demo.service.MotanDemoService"
                       ref="motanDemoService" export="demoMotan:8001" basicService="serviceBasicConfig">
        </motan:service>
        <motan:service interface="com.weibo.motan.demo.service.MotanDemoService"
                       ref="motanDemoService" export="demoMotan:8002" basicService="serviceBasicConfig">
        </motan:service>
    
    </beans>

 启动类：

    @SpringBootApplication
    @EnableAutoConfiguration
    @ImportResource(locations={"classpath*:spring/*server.xml"})
    public class App {
    
        public static void main(String[] args) {
            SpringApplication.run(App.class, args);
        }
    
    }

下面这个很重要：

    @Component
    @Order(value = 1)
    public class MotanSwitcherRunner implements CommandLineRunner {
        @Override
        public void run(String... args) throws Exception {
            // 在使用注册中心时要主动调用下面代码
            MotanSwitcherUtil.setSwitcherValue(MotanConstants.REGISTRY_HEARTBEAT_SWITCHER, true);
            System.out.println("server start...");
        }
    }

服务接口：

    public interface MotanDemoService {
    
        String hello(String name);
    }

 服务实现：

    @Service("motanDemoService")
    public class MotanDemoServiceImpl implements MotanDemoService {
    
        public String hello(String name) {
            System.out.println(name);
            return "Hello " + name + "!";
        }
    
    }

就这么简单，先启动zookeeper，再启动App就可发布motan服务，当应用中既要发布服务，又要引用服务时，可以将注册中心配置单独放在一个配置文件里。另外，不管是dubbo，还是motan，对注解的支持都不是特别好用，所以还是建议采用xml配置。关于消费方怎么用，详细代码见https://github.com/javahongxi/whatsmars的whatsmars-motan-demo模块。
{% endraw %}
