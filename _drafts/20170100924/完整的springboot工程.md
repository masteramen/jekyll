---
layout: post
title:  "完整的springboot工程"
title2:  "完整的springboot工程"
date:   2017-01-01 23:50:24  +0800
source:  "http://www.jfox.info/%e5%ae%8c%e6%95%b4%e7%9a%84springboot%e5%b7%a5%e7%a8%8b.html"
fileName:  "20170100924"
lang:  "zh_CN"
published: true
permalink: "%e5%ae%8c%e6%95%b4%e7%9a%84springboot%e5%b7%a5%e7%a8%8b.html"
---
{% raw %}
spring-boot出乎意料的好用，本文给大家展示生产实践中怎么用spring-boot。

    whatsmars-spring-boot
      |-src
        |-java
          |-com.itlong.whatsmars.spring.boot
             Application.java
             BeanConfig.java
             UserConfig.java
             UserController.java
             UserService.java
        |-resources
          |-mapper
             User-mapper.xml
          |-static
             red.jpg
          |-templates
             index.html
           application.properties
           application-bean.xml
           application-dev.properties
           application-prod.properties
           application-test.properties
           log4j2.xml
           mybatis-config.xml
      pom.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <artifactId>whatsmars-spring-boot</artifactId>
        <packaging>jar</packaging>
        <name>${project.artifactId}</name>
        <url>http://maven.apache.org</url>
        <properties>
            <!-- The main class to start by executing java -jar -->
            <start-class>com.itlong.whatsmars.spring.boot.Application</start-class>
        </properties>
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>1.5.2.RELEASE</version>
        </parent>
        <dependencies>
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>1.1.1</version>
                <exclusions>
                    <exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-logging</artifactId>
                    </exclusion>
                    <exclusion>
                        <groupId>ch.qos.logback</groupId>
                        <artifactId>logback-classic</artifactId>
                    </exclusion>
                </exclusions>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
                <exclusions>
                    <exclusion>
                        <groupId>ch.qos.logback</groupId>
                        <artifactId>logback-classic</artifactId>
                    </exclusion>
                    <!--<exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-tomcat</artifactId>
                    </exclusion>-->
                </exclusions>
            </dependency>
            <!-- <dependency>
                 <groupId>org.springframework.boot</groupId>
                 <artifactId>spring-boot-starter-jetty</artifactId>
             </dependency>-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-actuator</artifactId>
                <exclusions>
                    <exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-logging</artifactId>
                    </exclusion>
                </exclusions>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-aop</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
            </dependency>
            <!-- 开启如下依赖后，应用会自动检测相关配置 -->
            <!--<dependency>
                <groupId>org.springframework.session</groupId>
                <artifactId>spring-session</artifactId>
            </dependency>-->
            <!--<dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-data-redis</artifactId>
            </dependency>-->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-log4j2</artifactId>
            </dependency>
            <dependency>
                <groupId>commons-dbcp</groupId>
                <artifactId>commons-dbcp</artifactId>
                <version>1.4</version>
            </dependency>
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
            </dependency>
            <dependency>
                <groupId>org.mybatis.spring.boot</groupId>
                <artifactId>mybatis-spring-boot-starter</artifactId>
                <version>1.1.1</version>
                <exclusions>
                    <exclusion>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-starter-logging</artifactId>
                    </exclusion>
                    <exclusion>
                        <groupId>ch.qos.logback</groupId>
                        <artifactId>logback-classic</artifactId>
                    </exclusion>
                </exclusions>
            </dependency>
            <dependency>
                <groupId>com.github.pagehelper</groupId>
                <artifactId>pagehelper</artifactId>
                <version>4.1.6</version>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-thymeleaf</artifactId>
            </dependency>
        </dependencies>
        <build>
            <finalName>${project.artifactId}</finalName>
            <resources>
                <resource>
                    <directory>src/main/resources</directory>
                    <!--<includes>
                        <include>**/*.properties</include>
                        <include>**/*.xml</include>
                        <include>**/*.html</include>
                    </includes>-->
                    <filtering>true</filtering>
                </resource>
            </resources>
            <plugins>
                <!-- 该插件会使package打出一个可直接运行的jar包，即该jar包包含了依赖的所有jar包 -->
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                    <dependencies>
                        <!-- 使用SpringLoaded热部署 -->
                        <dependency>
                            <groupId>org.springframework</groupId>
                            <artifactId>springloaded</artifactId>
                            <version>1.2.6.RELEASE</version>
                        </dependency>
                    </dependencies>
                    <!-- POM不是继承spring-boot-starter-parent的话，需要下面的指定 -->
                    <!--<configuration>
                        <mainClass>${start-class}</mainClass>
                        <layout>ZIP</layout>
                    </configuration>
                    <executions>
                        <execution>
                            <goals>
                                <goal>repackage</goal>
                            </goals>
                        </execution>
                    </executions>-->
                </plugin>
            </plugins>
        </build>
    </project>

application.properties

    #spring.profiles.active=prod
    #spring.profiles.active=dev
    spring.profiles.active=test

application-test.properties

    server.port: 80
    spring.session.store-type=redis
    server.session.timeout=14400
    #server.session.cookie.domain=${toutiao.domain}
    #server.session.cookie.http-only=true
    #server.session.cookie.path=/
    #监控
    #management.port: 9900
    #management.address: 127.0.0.1
    #server.contextPath=/user
    server.tomcat.uri-encoding=UTF-8
    server.tomcat.basedir=/data/wely/logs
    server.tomcat.accesslog.directory=logs
    server.tomcat.accesslog.enabled=true
    server.tomcat.accesslog.pattern=common
    server.tomcat.accesslog.prefix=access_log
    server.tomcat.accesslog.suffix=.log
    spring.datasource.url=jdbc:mysql://127.0.0.1:3306/wely?useUnicode=true&characterEncoding=UTF-8&allowMultiQueries=true
    spring.datasource.username=root
    spring.datasource.password=123456
    spring.datasource.driver-class-name=com.mysql.jdbc.Driver
    spring.datasource.tomcat.min-idle=10
    spring.datasource.tomcat.max-idle=50
    spring.datasource.tomcat.max-active=100
    spring.datasource.tomcat.max-wait=10000
    spring.datasource.tomcat.max-age=10000
    spring.datasource.tomcat.test-on-borrow=true
    spring.datasource.tomcat.test-on-return=false
    spring.datasource.tomcat.test-while-idle=true
    spring.datasource.tomcat.time-between-eviction-runs-millis=5000
    spring.datasource.tomcat.validation-query=SELECT 1
    mybatis.config-location=classpath:mybatis-config.xml
    # REDIS (RedisProperties)
    spring.redis.host=127.0.0.1
    spring.redis.password=123456
    spring.redis.pool.max-active=8
    spring.redis.pool.max-idle=8
    spring.redis.pool.max-wait=-1
    spring.redis.pool.min-idle=1
    spring.redis.port=6379
    spring.redis.timeout=0
    spring.jackson.date-format=yyyy-MM-dd HH:mm:ss
    toutiao.domain=www.toutiao.im
    toutiao.loginCallback=http://${toutiao.domain}/user/login
    toutiao.logoutCallback=http://${toutiao.domain}/
    toutiao.loginSuccessIndex=http://${toutiao.domain}/index.html
    user.welcome=Hello, World!
    user.noFilterUrl=/,/login
    spring.thymeleaf.cache=false
    

application-bean.xml spring-boot追求无xml配置，但仍可以加载xml配置

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
                               http://www.springframework.org/schema/beans/spring-beans-3.2.xsd"
           default-autowire="byName">
        <bean id="userService" class="com.itlong.whatsmars.spring.boot.UserService"></bean>
    </beans>

index.html

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org"
          xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity3">
    <head>
        <title>thymeleaf</title>
    </head>
    <body>
    <h1 th:inline="text">thymeleaf</h1>
    <p th:text="${hello}"></p>
    </body>
    </html>

    @SpringBootApplication
    @EnableAutoConfiguration(exclude={DataSourceAutoConfiguration.class})
    @EnableConfigurationProperties({UserConfig.class})
    public class Application {
        public static void main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
    }

注意，**Application类所在包及子包下的所有类默认均在ComponentScan非为内**。

    @Controller
    public class UserController {
        @Autowired
        private UserConfig userConfig;
        @RequestMapping("/")
        public String home(Map<String,Object> map) {
            map.put("hello", "Hi, boy!");
            return "index";
        }
        @RequestMapping("/do")
        @ResponseBody
        public String doSth() {
            return userConfig.getWelcome();
        }
    }

    @ConfigurationProperties(prefix="user")
    public class UserConfig {
        private String welcome;
        private List<String> noFilterUrl;
        public String getWelcome() {
            return welcome;
        }
        public void setWelcome(String welcome) {
            this.welcome = welcome;
        }
        public List<String> getNoFilterUrl() {
            return noFilterUrl;
        }
        public void setNoFilterUrl(List<String> noFilterUrl) {
            this.noFilterUrl = noFilterUrl;
        }
    }

    @Configuration
    @ImportResource(locations={"classpath:application-bean.xml"})
    public class BeanConfig {
    }

    public class UserService {
        final Logger logger = LogManager.getLogger(getClass());
        public UserService() {
            logger.info("UserService init...");
            System.out.println("UserService init...");
        }
    }

    <?xml version="1.0" encoding="UTF-8"?>
    <configuration status="debug">
        <properties>
            <property name="logPath">/data/wely/logs</property>
        </properties>
        <appenders>
            <console name="Console" target="SYSTEM_OUT">
                <Filters>
                    <ThresholdFilter level="DEBUG" onMatch="ACCEPT"
                                     onMismatch="DENY"/>
                </Filters>
                <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss:SSS}] [%p] [%t] - [%X{sid}] %c{1.} - %m%n"/>
            </console>
            <RollingFile name="RollingFileDebug" fileName="${logPath}/debug.log"
                         filePattern="${logPath}/$${date:yyyy-MM-dd}/debug-%d{yyyy-MM-dd}-%i.log">
                <Filters>
                    <ThresholdFilter level="INFO" onMatch="DENY"
                                     onMismatch="ACCEPT"/>
                    <ThresholdFilter level="DEBUG" onMatch="ACCEPT"
                                     onMismatch="DENY"/>
                </Filters>
                <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss:SSS}] [%p] [%t] - [%X{sid}] %c{1.} - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
            <RollingFile name="RollingFileInfo" fileName="${logPath}/info.log"
                         filePattern="${logPath}/$${date:yyyy-MM-dd}/info-%d{yyyy-MM-dd}-%i.log">
                <Filters>
                    <ThresholdFilter level="INFO"/>
                    <ThresholdFilter level="WARN" onMatch="DENY"
                                     onMismatch="NEUTRAL"/>
                </Filters>
                <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss:SSS}] [%p] [%t] - [%X{sid}] %c{1.} - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
            <RollingFile name="RollingFileWarn" fileName="${logPath}/warn.log"
                         filePattern="${logPath}/$${date:yyyy-MM-dd}/warn-%d{yyyy-MM-dd}-%i.log">
                <Filters>
                    <ThresholdFilter level="WARN"/>
                    <ThresholdFilter level="ERROR" onMatch="DENY"
                                     onMismatch="NEUTRAL"/>
                </Filters>
                <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss:SSS}] [%p] [%t] - [%X{sid}] %c{1.} - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
            <RollingFile name="RollingFileError" fileName="${logPath}/error.log"
                         filePattern="${logPath}/$${date:yyyy-MM-dd}/error-%d{yyyy-MM-dd}-%i.log">
                <ThresholdFilter level="ERROR"/>
                <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss:SSS}] [%p] [%t] - [%X{sid}] %c{1.} - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
            <RollingFile name="RollingFileTrace" fileName="${logPath}/trace.log"
                         filePattern="${logPath}/$${date:yyyy-MM-dd}/trace-%d{yyyy-MM-dd}-%i.log">
                <ThresholdFilter level="TRACE" onMatch="ACCEPT" onMismatch="DENY"/>
                <PatternLayout pattern="[%d{yyyy-MM-dd HH:mm:ss:SSS}] [%p] [%t] - [%X{sid}] %c{1.} - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
            <File name="UserService" fileName="${logPath}/user-service.log">
                <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n" />  
            </File>
        </appenders>
        <loggers>
            <root level="INFO">
                <appender-ref ref="Console"/>
                <appender-ref ref="RollingFileInfo"/>
                <appender-ref ref="RollingFileWarn"/>
                <appender-ref ref="RollingFileError"/>
                <appender-ref ref="RollingFileDebug"/>
                <appender-ref ref="RollingFileTrace"/>
            </root>
            <logger name="com.itlong.whatsmars.spring.boot.UserService" level="info" additivity="false">
                <appender-ref ref="UserService"/>
            </logger>
            <!-- mybatis loggers -->
            <logger name="com.ibatis" level="INFO"/>
            <logger name="org.apache.ibatis" level="INFO"/>
            <logger name="org.mybatis.spring" level="INFO"/>
            <logger name="com.ibatis.common.jdbc.SimpleDataSource" level="INFO"/>
            <logger name="com.ibatis.common.jdbc.ScriptRunner" level="DEBUG"/>
            <logger name="com.ibatis.sqlmap.engine.impl.SqlMapClientDelegate" level="DEBUG"/>
            <!-- sql loggers -->
            <logger name="java.sql.Connection" level="DEBUG" additivity="true"/>
            <logger name="java.sql.Statement" level="DEBUG" additivity="true"/>
            <logger name="java.sql.PreparedStatement" level="DEBUG" additivity="true"/>
            <logger name="java.sql.ResultSet" level="DEBUG" additivity="true"/>
            <!-- spring loggers -->
            <logger name="org.springframework" level="WARN"/>
            <logger name="org.springframework.web" level="WARN"/>
            <logger name="springfox.documentation" level="WARN"/>
            <logger name="org.hibernate" level="ERROR"/>
            <logger name="springfox.documentation" level="ERROR"/>
        </loggers>
    </configuration>

三种启动方式：

1. Application.main()

2. mvn spring-boot:run

3. java -jar whatsmars-spring-boot.jar
{% endraw %}
