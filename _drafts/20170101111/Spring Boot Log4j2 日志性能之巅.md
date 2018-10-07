---
layout: post
title:  "Spring Boot Log4j2 日志性能之巅"
title2:  "Spring Boot Log4j2 日志性能之巅"
date:   2017-01-01 23:53:31  +0800
source:  "http://www.jfox.info/springbootlog4j2%e6%97%a5%e5%bf%97%e6%80%a7%e8%83%bd%e4%b9%8b%e5%b7%85.html"
fileName:  "20170101111"
lang:  "zh_CN"
published: true
permalink: "springbootlog4j2%e6%97%a5%e5%bf%97%e6%80%a7%e8%83%bd%e4%b9%8b%e5%b7%85.html"
---
{% raw %}
0x01 Maven 依赖 pom.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
    
        <groupId>org.spring</groupId>
        <artifactId>springboot</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <packaging>jar</packaging>
    
        <name>springboot</name>
        <description>Demo Log4j2 for Spring Boot</description>
    
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>1.5.4.RELEASE</version>
        </parent>
    
        <properties>
            <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
            <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
            <java.version>1.8</java.version>
        </properties>
    
        <dependencies>
    
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
                <exclusions>
                    <exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-logging</artifactId>
                    </exclusion>
                </exclusions>
            </dependency>
    
            <!-- 代码简化 -->
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>1.16.16</version>
            </dependency>
    
            <!-- 日志 Log4j2 -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-log4j2</artifactId>
            </dependency>
    
            <!-- Log4j2 异步支持 -->
            <dependency>
                <groupId>com.lmax</groupId>
                <artifactId>disruptor</artifactId>
                <version>3.3.6</version>
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
    
    </project>

0x02 配置 Log4j2，在 resources 文件目录下添加文件 log4j2.xml，会被自动配置

    <?xml version="1.0" encoding="UTF-8"?>
    <!-- Configuration后面的status，这个用于设置log4j2自身内部的信息输出，可以不设置，当设置成trace时，
         你会看到log4j2内部各种详细输出。可以设置成OFF(关闭) 或 Error(只输出错误信息)。
         30s 刷新此配置
    -->
    <configuration status="WARN" monitorInterval="30">
    
        <!-- 日志文件目录、压缩文件目录、日志格式配置 -->
        <properties>
            <Property name="fileName">/Users/admin/Code/log</Property>
            <Property name="fileGz">/Users/admin/Code/log/7z</Property>
            <Property name="PID">????</Property>
            <Property name="LOG_PATTERN">%clr{%d{yyyy-MM-dd HH:mm:ss.SSS}}{faint} %clr{%5p} %clr{${sys:PID}}{magenta} %clr{---}{faint} %clr{[%15.15t]}{faint} %clr{%-40.40c{1.}}{cyan} %clr{:}{faint} %m%n%xwEx</Property>
        </properties>
    
        <Appenders>
            <!-- 输出控制台日志的配置 -->
            <Console name="console" target="SYSTEM_OUT">
                <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
                <ThresholdFilter level="debug" onMatch="ACCEPT" onMismatch="DENY"/>
                <!-- 输出日志的格式 -->
                <PatternLayout pattern="${LOG_PATTERN}"/>
            </Console>
    
            <!-- 打印出所有的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份创建的文件夹下面并进行压缩，作为存档 -->
            <RollingRandomAccessFile name="infoFile" fileName="${fileName}/web-info.log" immediateFlush="false"
                                        filePattern="${fileGz}/$${date:yyyy-MM}/%d{yyyy-MM-dd}-%i.web-info.gz">
                <PatternLayout pattern="${LOG_PATTERN}"/>
    
                <Policies>
                    <SizeBasedTriggeringPolicy size="20 MB"/>
                </Policies>
    
                <Filters>
                    <!-- 只记录info和warn级别信息 -->
                    <ThresholdFilter level="error" onMatch="DENY" onMismatch="NEUTRAL"/>
                    <ThresholdFilter level="info" onMatch="ACCEPT" onMismatch="DENY"/>
                </Filters>
    
                <!-- 指定每天的最大压缩包个数，默认7个，超过了会覆盖之前的 -->
                <DefaultRolloverStrategy max="50"/>
            </RollingRandomAccessFile>
    
            <!-- 存储所有error信息 -->
            <RollingRandomAccessFile name="errorFile" fileName="${fileName}/web-error.log" immediateFlush="false"
                                        filePattern="${fileGz}/$${date:yyyy-MM}/%d{yyyy-MM-dd}-%i.web-error.gz">
                <PatternLayout pattern="${LOG_PATTERN}"/>
    
                <Policies>
                    <SizeBasedTriggeringPolicy size="50 MB"/>
                </Policies>
    
                <Filters>
                    <!-- 只记录error级别信息 -->
                    <ThresholdFilter level="error" onMatch="ACCEPT" onMismatch="DENY"/>
                </Filters>
    
                <!-- 指定每天的最大压缩包个数，默认7个，超过了会覆盖之前的 -->
                <DefaultRolloverStrategy max="50"/>
            </RollingRandomAccessFile>
        </Appenders>
    
        <!-- Mixed sync/async -->
        <Loggers>
            <Root level="debug" includeLocation="true">
                <AppenderRef ref="console"/>
                <AppenderRef ref="infoFile"/>
                <AppenderRef ref="errorFile"/>
            </Root>
    
            <AsyncRoot level="debug" includeLocation="true">
                <AppenderRef ref="console"/>
                <AppenderRef ref="infoFile"/>
                <AppenderRef ref="errorFile"/>
            </AsyncRoot>
        </Loggers>
    
    </configuration>

0x03 添加 Application 启动类

    @SpringBootApplication
    @EnableScheduling
    public class Application {
    
        public static void main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
    
    }

0x04 添加测试的 Job 类

    @Component
    @Log4j2
    public class LogJob {
    
        /**
         * 2秒钟执行1次
         */
        @Scheduled(fixedRate = 2 * 1000)
        public void logging(){
            Date now = new Date();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            log.info(simpleDateFormat.format(now));
            log.debug("-------DEBUG---------");
            log.error(now.getTime());
        }
    
    }

0x05 大致文件目录结构
{% endraw %}
