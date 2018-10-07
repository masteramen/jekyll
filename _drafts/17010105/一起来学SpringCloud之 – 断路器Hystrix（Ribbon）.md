---
layout: post
title:  "一起来学SpringCloud之 – 断路器Hystrix（Ribbon）"
title2:  "一起来学SpringCloud之 – 断路器Hystrix（Ribbon）"
date:   2017-01-01 00:00:00  +0800
source:  "http://www.jfox.info/%e4%b8%80%e8%b5%b7%e6%9d%a5%e5%ad%a6springcloud%e4%b9%8b%e6%96%ad%e8%b7%af%e5%99%a8hystrixribbon.html"
fileName:  "17010105"
lang:  "zh_CN"
published: true
permalink: "%e4%b8%80%e8%b5%b7%e6%9d%a5%e5%ad%a6springcloud%e4%b9%8b%e6%96%ad%e8%b7%af%e5%99%a8hystrixribbon.html"
---
{% raw %}
微服务架构中，根据业务划分成若干个服务，各单元应用间通过服务注册与订阅的方式互相依赖，依赖通过远程调用的方式执行，该方式难以避免因网络或自身原因而出现故障或者延迟，从而并不能保证服务的100%可用，此时若有大量的网络涌入，会形成任务累计，导致服务瘫痪，甚至导致服务“雪崩”。

## – Hystrix 

1.Netflix 已经为我们创建了 Hystrix 库来实现服务降级、服务熔断、线程隔离、请求缓存、请求合并以及服务监控（Hystrix Dashboard）等强大功能，在微服务架构中，多层服务调用是非常常见的。

![](http://www.jfox.info/wp-content/uploads/2017/08/1502353738.png)

2.较底层的服务中的服务故障可能导致级联故障，当对特定的服务的调用达到一个阀值（Hystric 是5秒20次） 断路器将会被打开，故障百分比大于circuitBreaker.errorThresholdPercentage（默认值：> 50％）时metrics.rollingStats.timeInMilliseconds（默认10秒），断路打开后，开发人员可以回退机制。

![](http://www.jfox.info/wp-content/uploads/2017/08/1502353740.png)

 官方文档： [http://cloud.spring.io/spring-cloud-static/Dalston.SR2/#_circuit_breaker_hystrix_clients](http://www.jfox.info/go.php?url=http://cloud.spring.io/spring-cloud-static/Dalston.SR2/#_circuit_breaker_hystrix_clients)

## – 准备工作 

1.启动Consul

 2.创建 `battcn-provider` 和 `battcn-consumer`

## – battcn-provider 

### – pom.xml 

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
    
        <groupId>com.battcn</groupId>
        <artifactId>battcn-provider</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>jar</packaging>
        <name>battcn-provider</name>
        <description>Ribbon与Hystrix</description>
    
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>1.5.4.RELEASE</version>
            <relativePath/> <!-- lookup parent from repository -->
        </parent>
    
        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
            <java.version>1.8</java.version>
            <spring-cloud.version>Dalston.SR2</spring-cloud.version>
        </properties>
    
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-consul-discovery</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
            </dependency>
        </dependencies>
    
        <dependencyManagement>
            <dependencies>
                <dependency>
                    <groupId>org.springframework.cloud</groupId>
                    <artifactId>spring-cloud-dependencies</artifactId>
                    <version>${spring-cloud.version}</version>
                    <type>pom</type>
                    <scope>import</scope>
                </dependency>
            </dependencies>
        </dependencyManagement>
    
        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </build>
    
    
    </project>

### – ProviderApplication.java 

    package com.battcn;
    
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;
    
    @SpringBootApplication
    @EnableDiscoveryClient
    @RestController
    public class ProviderApplication {
    
        @Value("${spring.application.name}")
        String applicationName;
    
    
        public static void main(String[] args) {
            SpringApplication.run(ProviderApplication.class, args);
        }
    
        @GetMapping("/hello")
        public String hello() {
            return "My Name's :" + applicationName + " Email:1837307557@qq.com";
        }
    }

### – bootstrap.yml 

    server:
      port: 8765
    
    spring:
      application:
        name: battcn-provider
      cloud:
        consul:
          host: localhost
          port: 8500
          enabled: true
          discovery:
            enabled: true
            prefer-ip-address: true

## – battcn-consumer 

### – pom.xml 

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
    
        <groupId>com.battcn</groupId>
        <artifactId>battcn-consumer</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <packaging>jar</packaging>
        <name>battcn-consumer</name>
        <description>Ribbon与Hystrix</description>
    
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>1.5.4.RELEASE</version>
            <relativePath/> <!-- lookup parent from repository -->
        </parent>
    
        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
            <java.version>1.8</java.version>
            <spring-cloud.version>Dalston.SR2</spring-cloud.version>
        </properties>
    
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-hystrix</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-starter-consul-discovery</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
            </dependency>
        </dependencies>
    
        <dependencyManagement>
            <dependencies>
                <dependency>
                    <groupId>org.springframework.cloud</groupId>
                    <artifactId>spring-cloud-dependencies</artifactId>
                    <version>${spring-cloud.version}</version>
                    <type>pom</type>
                    <scope>import</scope>
                </dependency>
            </dependencies>
        </dependencyManagement>
    
        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </build>
    
    
    </project>

### – ConsumerApplication 

    package com.battcn;
    
    import org.springframework.boot.SpringApplication;
    import org.springframework.cloud.client.SpringCloudApplication;
    import org.springframework.cloud.client.loadbalancer.LoadBalanced;
    import org.springframework.context.annotation.Bean;
    import org.springframework.web.client.RestTemplate;
    
    //@EnableDiscoveryClient
    //@SpringBootApplication
    //@EnableCircuitBreaker
    
    /**
     * SpringCloudApplication 一个注解顶上面三个,有兴趣的可以点进去看源码
     */
    @SpringCloudApplication
    public class ConsumerApplication {
    
        @Bean
        @LoadBalanced
        public RestTemplate restTemplate() {
            return new RestTemplate();
        }
    
        public static void main(String[] args) {
            SpringApplication.run(ConsumerApplication.class, args);
        }
    
    }

### – HiController 

    package com.battcn.controller;
    
    import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;
    import org.springframework.web.client.RestTemplate;
    
    /**
     * 为了偷懒，就写一个文件了
     */
    @RestController
    public class HiController {
    
        static Logger LOGGER = LoggerFactory.getLogger(HiController.class);
        @Autowired
        HiService hiService;
    
        @GetMapping("/hi")
        public String hi() {
            return hiService.hello();
        }
    
        @Service
        class HiService {
            @Autowired
            RestTemplate restTemplate;
    
            @HystrixCommand(fallbackMethod = "ribbonFallback")
            public String hello() {
                return restTemplate.getForObject("http://battcn-provider/hello", String.class);
            }
    
            public String ribbonFallback() {
                return "My Name's :ribbonFallback Email:1837307557@qq.com";
            }
        }
    
    }

### – bootstrap.yml 

    server:
      port: 8766
    
    spring:
      application:
        name: battcn-consumer
      cloud:
        consul:
          host: localhost
          port: 8500
          enabled: true
          discovery:
            enabled: true
            prefer-ip-address: true

## – 测试 

启动：battcn-provider

启动：battcn-consumer

 访问： [http://localhost:8500/](http://www.jfox.info/go.php?url=http://localhost:8500/) 显示如下代表服务注册成功 

![](http://www.jfox.info/wp-content/uploads/2017/08/1502353741.png)

 访问： [http://localhost:8766/hi](http://www.jfox.info/go.php?url=http://localhost:8766/hi)

    My Name's :battcn-provider Email:1837307557@qq.com    #正确情况
    
    My Name's :ribbonFallback Email:1837307557@qq.com    #关闭battcn-provider后结果

### – 源码 

 1.当我们开启 `Hystrix` 的时候 Hystrix 会为我们注入 `HystrixCommandAspect` 切面，操作所有带 `HystrixCommand` 注解，随后就是通过反射与Cglib创建代理然后发送请求，不管服务是否健壮都会先进入AOP切面然后才会执行后续操作（打脸轻点…） 

![](http://www.jfox.info/wp-content/uploads/2017/08/15023537411.png)

### – 监控 

 1.在 `ConsumerApplication` 中添加 `@EnableHystrixDashboard` 的注解 

    @SpringCloudApplication
    @EnableHystrixDashboard    //多了个开启监控注解
    public class ConsumerApplication {
    
        @Bean
        @LoadBalanced
        public RestTemplate restTemplate() {
            return new RestTemplate();
        }
    
        public static void main(String[] args) {
            SpringApplication.run(ConsumerApplication.class, args);
        }
    
    }

 2.在 `pom.xml` 中添加如下配置 

    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-hystrix-dashboard</artifactId>
    </dependency>

 3.访问： [http://localhost:8766/hystrix](http://www.jfox.info/go.php?url=http://localhost:8766/hystrix)

![](http://www.jfox.info/wp-content/uploads/2017/08/1502353742.png)

 4.访问N次： [http://localhost:8766/hi](http://www.jfox.info/go.php?url=http://localhost:8766/hi)

![](http://www.jfox.info/wp-content/uploads/2017/08/1502353743.png)

我们可以看到请求成功，失败，等信息

## – 说点什么 

 本章代码（battcn-provider/consumer）： [https://git.oschina.net/battcn/battcn-cloud/tree/master/battcn-cloud-hystrix-ribbon](http://www.jfox.info/go.php?url=https://git.oschina.net/battcn/battcn-cloud/tree/master/battcn-cloud-hystrix-ribbon)

如有问题请及时与我联系

1. 个人QQ：1837307557
2. Spring Cloud中国社区①：415028731
3. Spring For All 社区⑤：157525002
4. 好消息 Dubbo 进入维护阶段，欢迎一起讨论与交流 （猜测为了迎合阿里商用软件）

转载标明出处，thanks
赏
  谢谢你请我吃糖果  

![](http://www.jfox.info/wp-content/uploads/2017/08/15023537431.png)支付宝

![](http://www.jfox.info/wp-content/uploads/2017/08/1502353745.png)微信
{% endraw %}
