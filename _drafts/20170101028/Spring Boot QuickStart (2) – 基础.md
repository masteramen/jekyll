---
layout: post
title:  "Spring Boot QuickStart (2) – 基础"
title2:  "Spring Boot QuickStart (2) – 基础"
date:   2017-01-01 23:52:08  +0800
source:  "https://www.jfox.info/spring-boot-quickstart-2-%e5%9f%ba%e7%a1%80.html"
fileName:  "20170101028"
lang:  "zh_CN"
published: true
permalink: "2017/spring-boot-quickstart-2-%e5%9f%ba%e7%a1%80.html"
---
{% raw %}
环境：Spring Boot 1.5.4

基于 Spring Boot 创建一个命令行应用，先来个最基本的体验，体验一下：

- 
配置管理（配置文件加载，多环境配置文件）

- 
日志

- 
单元测试

## 创建项目

比较好的两种方法：

1. 
通过 [https://start.spring.io/](https://www.jfox.info/go.php?url=https://start.spring.io/) 网站，生成项目框架，导入到 IDE

2. 
IDEA 有Spring Boot的插件，直接按照提示创建

3. 
其他

创建个最基本的应用，包含了devtools，logging，test，以及maven插件：

    ...
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.3.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    ...
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
        
        ...

## 配置管理

### 修改 banner

Spring Boot 的默认 banner：

      .   ____          _            __ _ _
     / / ___'_ __ _ _(_)_ __  __ _    
    ( ( )___ | '_ | '_| | '_ / _` |    
     /  ___)| |_)| | | | | || (_| |  ) ) ) )
      '  |____| .__|_| |_|_| |___, | / / / /
     =========|_|==============|___/=/_/_/_/
     :: Spring Boot ::        (v1.5.3.RELEASE)

resources 目录下创建一个 banner.txt 文件可以修改，并且还提供了一些参数，可以配色。

当然也可以在配置文件或入口处关闭：

    spring.main.banner-mode=off

或

    public static void main(String[] args) {
       SpringApplication application = new SpringApplication(HelloApplication.class);
       application.setBannerMode(Banner.Mode.OFF);
       application.run(args);
    }

关闭 banner 竟然还弄这么多方式，我也是醉了，其实只是展示一下在入口处还可以进行很多应用的配置罢了。

### 自定义属性

如果不是特殊的应用场景，就只需要在 application.properties 中完成一些属性配置就能开启各模块的应用。

application.properties：

    mysql.host=default
    mysql.user=default_user
    mysql.mix=${mysql.host}/${mysql.user}

如上所示：参数之间也可以使用变量直接引用来使用

定义 MysqlProperties Class：

    @Component
    public class MysqlProperties {
        @Value("${mysql.host:localhost}")
        private String host;
    
        @Value("${admin.user:root}")
        private String user;
        
        // 省略getter、setter、toString
    }    

@Value 注解未免有点蛋疼

可以使用 @ConfigurationProperties 注解直接配置个属性前缀，同时还可以加载一个额外的 .properties 文件

app.properties：

    app.name=hello
    app.version=1.0

定义 AppProperties Class：

    @Component
    @PropertySource("classpath:app.properties")
    @ConfigurationProperties(prefix = "app")
    public class AppProperties {
        private String name;
        private String version;
        
        // 省略getter、setter、toString
    }    

## 命令行运行

Spring Boot 默认 Application 定义了 main 方法入口，所以要实现一个命令行运行的应用，需要实现 CommandLineRunner 接口，覆写 run 方法，这样命令行参数就通过变长参数 strings 接受到。

    @SpringBootApplication
    public class HelloApplication implements CommandLineRunner {
    
        @Override
        public void run(String... strings) throws Exception {
        }
    }

## 多环境配置

Spring Boot中多环境配置文件名需要满足application-{profile}.properties的格式，其中{profile}对应你的环境标识，如：

    application-dev.properties：开发环境
    application-test.properties：测试环境

同时，需要在application.properties文件中通过spring.profiles.active属性来设置，其值对应{profile}值，并且可以设置多个。

其次，通过命令行参数 `--spring.profiles.active=test` 可以切换多环境。比如：

    java -jar xxx.jar --spring.profiles.active=test

## 日志

Spring Boot 默认使用 Logback 作为第一选择，默认集成了 slf4j，并且支持配置使用 Log4j：

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
        <exclusions>
            <exclusion>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-logging</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-log4j2</artifactId>
    </dependency>

log4j2 貌似和 log4j 有点变化，暂时不折腾了
{% endraw %}
