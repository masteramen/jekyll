---
layout: post
title:  "SpringBoot系列一（入门，ORM，Transaction,log4j2等）"
title2:  "SpringBoot系列一（入门，ORM，Transaction,log4j2等）"
date:   2017-01-01 23:58:19  +0800
source:  "https://www.jfox.info/springboot%e7%b3%bb%e5%88%97%e4%b8%80%e5%85%a5%e9%97%a8ormtransactionlog4j2%e7%ad%89.html"
fileName:  "20170101399"
lang:  "zh_CN"
published: true
permalink: "2017/springboot%e7%b3%bb%e5%88%97%e4%b8%80%e5%85%a5%e9%97%a8ormtransactionlog4j2%e7%ad%89.html"
---
{% raw %}
今天写篇springboot的博客，主要介绍一下springboot搭建以及一些整合。

首先介绍springboot搭建，我今天选择Maven，想用Gradle搭建的就自己百度一下吧，访问“http://start.spring.io/”官网。

![](/wp-content/uploads/2017/07/1501258292.png)

填写好Maven的GroupId以及ArtifactId然后Generate Project。

我这次使用的是IntellIj IDEA,导入generate出来的project，选择maven导入，一直选next就行了（记得选一下jdk版本，我用的是1.8），eclipse的话直接import project就行了。

初始的项目结构应该就是一个普通的maven项目，只有一个配置文件就是application.properties，也是springboot整合所有东西的配置文件。

maven pom文件的依赖只需要以下：
<dependency><groupId>org.springframework.boot</groupId><artifactId>spring-boot-starter</artifactId></dependency> 
 

    
 
 
 <dependency><groupId>org.springframework.boot</groupId><artifactId>spring-boot-starter-test</artifactId><scope>test</scope></dependency>
如果加入web模块：
<dependency><groupId>org.springframework.boot</groupId><artifactId>spring-boot-starter-web</artifactId></dependency>
我用的版本是1.5.4

![](/wp-content/uploads/2017/07/15012582921.png)

可以按照我上面的项目结构去建立resource文件夹以及package包，注意一点，test和main的根包名需要一致，否则会报错（具体报错可以自己试试）。

首先来试试最基础的helloworld。

![](/wp-content/uploads/2017/07/1501258293.png)
![](/wp-content/uploads/2017/07/15012582931.png)
 写一个跟SpringMVC类似的controller就可以试试helloworld了，在包的根路径建立一个Application类作为程序入口(springboot的规矩)，也可以直接运行main方法启动springboot，相当于内嵌了tomcat。

运行起来之后就可以在localhost:8080/hello看到映射结果了。

如果使用Test访问：

![](/wp-content/uploads/2017/07/1501258294.png)

Mock一下，然后引入

    import static org.hamcrest.Matchers.equalTo;
    import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
    import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
    具体代码不解释了，看一看能猜出来。
    然后来看一下普通restful风格的controller咋写,通俗点说就是我咋用springboot实现springmvc一样的东东

    package com.zhengyu.web;
    
    import com.zhengyu.model.User;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;
    import org.springframework.web.bind.annotation.RestController;
    import java.util.ArrayList;
    import java.util.Collections;
    import java.util.HashMap;
    import java.util.List;
    import java.util.Map;
    
    /**
     * Created by niezy on 2017/7/26.
     */
    @RestController
    @RequestMapping(value = "/users") // 通过这里配置使下面的映射都在/users下publicclass UserController {
    
      // 创建线程安全的Mapstatic Map<Long, User> users = Collections.synchronizedMap(new HashMap<Long, User>());
    
      @RequestMapping(value = "/", method = RequestMethod.GET)
      public List<User> getUserList() {
        // 处理"/users/"的GET请求，用来获取用户列表
        // 还可以通过@RequestParam从页面中传递参数来进行查询条件或者翻页信息的传递
        List<User> r = new ArrayList<User>(users.values());
        return r;
      }
    
      @RequestMapping(value = "/", method = RequestMethod.POST)
      public String postUser(@ModelAttribute User user) {
        // 处理"/users/"的POST请求，用来创建User
        // 除了@ModelAttribute绑定参数之外，还可以通过@RequestParam从页面中传递参数    users.put(user.getId(), user);
        return "success";
      }
    
      @RequestMapping(value = "/{id}", method = RequestMethod.GET)
      public User getUser(@PathVariable Long id) {
        // 处理"/users/{id}"的GET请求，用来获取url中id值的User信息
        // url中的id可通过@PathVariable绑定到函数的参数中return users.get(id);
      }
    
      @RequestMapping(value = "/{id}", method = RequestMethod.PUT)
      public String putUser(@PathVariable Long id, @ModelAttribute User user) {
        // 处理"/users/{id}"的PUT请求，用来更新User信息
        User u = users.get(id);
        u.setName(user.getName());
        u.setAge(user.getAge());
        users.put(id, u);
        return "success";
      }
    
      @RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
      public String deleteUser(@PathVariable Long id) {
        // 处理"/users/{id}"的DELETE请求，用来删除User    users.remove(id);
        return "success";
      }
    
    }

一样的controller如上图，然后开始测试呗

    package com.zhengyu;
    
    import com.zhengyu.web.UserController;
    import org.junit.Before;
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
    import org.springframework.test.context.web.WebAppConfiguration;
    import org.springframework.test.web.servlet.MockMvc;
    import org.springframework.test.web.servlet.RequestBuilder;
    import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
    import org.springframework.test.web.servlet.setup.MockMvcBuilders;
    importstatic org.hamcrest.Matchers.equalTo;
    importstatic org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
    importstatic org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
    importstatic org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
    importstatic org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
    importstatic org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
    
    @RunWith(SpringJUnit4ClassRunner.class)
    @WebAppConfiguration
    publicclass ApplicationTests {
    
      private MockMvc mvc;
    
      @Before
      publicvoid setUp() throws Exception {
        mvc = MockMvcBuilders.standaloneSetup(new UserController()).build();
      }
    
      @Test
      publicvoid testUserController() throws Exception {
        // 测试UserController
        RequestBuilder request = null;
    
        // 1、get查一下user列表，应该为空
        request = MockMvcRequestBuilders.get("/users/");
        mvc.perform(request).andExpect(status().isOk()).andExpect(content().string(equalTo("[]")));
    
        // 2、post提交一个user
        request = post("/users/").param("id", "1").param("name", "测试大师").param("age", "20");
        mvc.perform(request).andExpect(content().string(equalTo("success")));
    
        // 3、get获取user列表，应该有刚才插入的数据
        request = MockMvcRequestBuilders.get("/users/");
        mvc.perform(request).andExpect(status().isOk())
            .andExpect(content().string(equalTo("[{\"id\":1,\"name\":\"测试大师\",\"age\":20}]")));
    
        // 4、put修改id为1的user
        request = put("/users/1").param("name", "测试终极大师").param("age", "30");
        mvc.perform(request).andExpect(content().string(equalTo("success")));
    
        // 5、get一个id为1的user
        request = MockMvcRequestBuilders.get("/users/1");
        mvc.perform(request).andExpect(content().string(equalTo("{\"id\":1,\"name\":\"测试终极大师\",\"age\":30}")));
    
        // 6、del删除id为1的user
        request = delete("/users/1");
        mvc.perform(request).andExpect(content().string(equalTo("success")));
    
        // 7、get查一下user列表，应该为空
        request = MockMvcRequestBuilders.get("/users/");
        mvc.perform(request).andExpect(status().isOk()).andExpect(content().string(equalTo("[]")));
    
      }
    
    
    
    }

好咯~

    
    下面说一下log,spring1.5.4版本是不支持log4j老用法了，我查了一下然后选择的是log4j2xml的方式，pom如下：

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
    首先springboot自带的是logback,我们首先更改之前的pom，加上
    

     <exclusions>
    <exclusion>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
    </exclusion>
    </exclusions>

    除去logback，然后引入log4j2.
    然后在resource文件夹底下新建一个log4j2.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
    <!--Configuration后面的status，这个用于设置log4j2自身内部的信息输出，可以不设置，当设置成trace时，你会看到log4j2内部各种详细输出-->
    <!--monitorInterval：Log4j能够自动检测修改配置 文件和重新配置本身，设置间隔秒数-->
    <configuration status="WARN" monitorInterval="30">
        <!--先定义所有的appender-->
        <appenders>
            <!--这个输出控制台的配置-->
            <console name="Console" target="SYSTEM_OUT">
                <!--输出日志的格式-->
                <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
            </console>
            <!--文件会打印出所有信息，这个log每次运行程序会自动清空，由append属性决定，这个也挺有用的，适合临时测试用-->
            <File name="log" fileName="log/test.log" append="false">
                <PatternLayout pattern="%d{HH:mm:ss.SSS} %-5level %class{36} %L %M - %msg%xEx%n"/>
            </File>
            <!-- 这个会打印出所有的info及以下级别的信息，每次大小超过size，则这size大小的日志会自动存入按年份-月份建立的文件夹下面并进行压缩，作为存档-->
            <RollingFile name="RollingFileInfo" fileName="${sys:user.home}/logs/info.log"
                         filePattern="${sys:user.home}/logs/$${date:yyyy-MM}/info-%d{yyyy-MM-dd}-%i.log">
                <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
                <ThresholdFilter level="info" onMatch="ACCEPT" onMismatch="DENY"/>
                <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
            <RollingFile name="RollingFileWarn" fileName="${sys:user.home}/logs/warn.log"
                         filePattern="${sys:user.home}/logs/$${date:yyyy-MM}/warn-%d{yyyy-MM-dd}-%i.log">
                <ThresholdFilter level="warn" onMatch="ACCEPT" onMismatch="DENY"/>
                <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
                <!-- DefaultRolloverStrategy属性如不设置，则默认为最多同一文件夹下7个文件，这里设置了20 -->
                <DefaultRolloverStrategy max="20"/>
            </RollingFile>
            <RollingFile name="RollingFileError" fileName="${sys:user.home}/logs/error.log"
                         filePattern="${sys:user.home}/logs/$${date:yyyy-MM}/error-%d{yyyy-MM-dd}-%i.log">
                <ThresholdFilter level="error" onMatch="ACCEPT" onMismatch="DENY"/>
                <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
                <Policies>
                    <TimeBasedTriggeringPolicy/>
                    <SizeBasedTriggeringPolicy size="100 MB"/>
                </Policies>
            </RollingFile>
        </appenders>
        <!--然后定义logger，只有定义了logger并引入的appender，appender才会生效-->
        <loggers>
            <!--过滤掉spring和mybatis的一些无用的DEBUG信息-->
            <logger name="org.springframework" level="INFO"></logger>
            <logger name="org.mybatis" level="INFO"></logger>
            <root level="all">
                <appender-ref ref="Console"/>
                <appender-ref ref="RollingFileInfo"/>
                <appender-ref ref="RollingFileWarn"/>
                <appender-ref ref="RollingFileError"/>
            </root>
        </loggers>
    </configuration>
    

　　然后在application.properties配置文件里加上

    logging.config=classpath:log4j2.xml 
    其实不加也行，起码我测试这个版本没问题，随便你啦，强迫症的加上吧。
    下面说说spring jdbcTemplate
    

    <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
    <version>1.5.2.RELEASE</version>
    </dependency>
    <dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.21</version>
    </dependency>
    加上这个依赖，然后我们开始codeing

![](/wp-content/uploads/2017/07/15012582941.png)

建个user类

application.properties加上：

    spring.datasource.url=jdbc:mysql://localhost:3306/boot
    spring.datasource.username=root
    spring.datasource.password=root
    spring.datasource.driver-class-name=com.mysql.jdbc.Driver
    spring.jpa.properties.hibernate.hbm2ddl.auto=create-drop
    log4j.logger.org.springframework.jdbc.core=DEBUG, file
    log4j.logger.org.springframework.jdbc.core.StatementCreatorUtils=TRACE, file
    然后建一个UserService，跟springmvc没什么两样

    /**
     * Created by niezy on 2017/7/26.
     */publicinterface UserService {
      /**
       * 新增一个用户
       * 
       * @param name
       * @param age
       */void create(String name, Integer age);
    
      /**
       * 根据name删除一个用户高
       * 
       * @param name
       */void deleteByName(String name);
    
      /**
       * 获取用户总量
       */
      Integer getAllUsers();
    
      /**
       * 删除所有用户
       */void deleteAllUsers();
    
      /**
       * 根据姓名更新年龄
       * @param name
       * @param age
       */void update(String name,int age);
    
    
      /**
       * 根据姓名查对象
       * @param name
       * @return*/
      User querySingleUser(String name);
    
    
    
    }

    /**
     * Created by niezy on 2017/7/26.
     */
    @Service
    publicclass UserServiceImpl implements UserService {
      @Autowired
      private JdbcTemplate jdbcTemplate;
    
      @Override
      publicvoid create(String name, Integer age) {
        jdbcTemplate.update("insert into USER(NAME, AGE) values(?, ?)", name, age);
      }
    
      @Override
      publicvoid deleteByName(String name) {
        jdbcTemplate.update("delete from USER where NAME = ?", name);
      }
    
      @Override
      public Integer getAllUsers() {
        return jdbcTemplate.queryForObject("select count(1) from USER", Integer.class);
      }
    
      @Override
      publicvoid deleteAllUsers() {
        jdbcTemplate.update("delete from USER");
      }
    
      @Override
      publicvoid update(String name, int age) {
        jdbcTemplate.update("update user set age = ? where name=? ", age, name);
      }
    
      @Override
      public User querySingleUser(String name) {
        User user = new User();
        user.setName(name);
        // 返回对象需要beanPropertyRowMapper映射，查询条件放到Object数组return jdbcTemplate.queryForObject("select * from user where name=? ", new Object[] {name},
            new BeanPropertyRowMapper<User>(User.class));
      }
    }

然后测试

    package com.zhengyu;
    
    import org.junit.Assert;
    import org.junit.Before;
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.test.context.junit4.SpringRunner;
    
    import com.zhengyu.jdbcservice.UserService;
    
    /**
     * Created by niezy on 2017/7/26.
     */
    
    
    @RunWith(SpringRunner.class)
    @SpringBootTest
    publicclass JdbcApplicationTests {
      @Autowired
      private UserService userSerivce;
    
      @Before
      publicvoid setUp() {
        // 准备，清空user表    userSerivce.deleteAllUsers();
      }
    
      @Test
      publicvoid test() throws Exception {
        // 插入5个用户
        userSerivce.create("zhangsan", 18);
        userSerivce.create("lisi", 19);
        userSerivce.create("wangwu", 20);
        userSerivce.create("haozi", 25);
        userSerivce.create("zhengyu", 23);
        // 查数据库，应该有5个用户
        Assert.assertEquals(5, userSerivce.getAllUsers().intValue());
        // 删除两个用户
        userSerivce.deleteByName("zhangsan");
        userSerivce.deleteByName("haozi");
        userSerivce.update("wangwu", 28);
        System.out.println(userSerivce.querySingleUser("zhengyu").toString());
        // 查数据库，应该有3个用户
        Assert.assertEquals(3, userSerivce.getAllUsers().intValue());
      }
    }

自己跑一下试试  ~

jdbcTemplate只有一点注意的，返回对象稍微麻烦点，需要按他的BeanPropertyRowMapper规矩来，其实还有很多种玩法，ORM框架都有很多玩法，包括我进携程以后用的携程的dal框架，返回Object数组啦，集合啦，List<Map>等等，说到底都是封装的jdbc，然后有的框架是全mapping，有的是半mapping，包括Hibernate实现的JPA标准，也可以nativeSql支持数组[]选字段返回，也可以直接mapping整个类，甚至级联操作，下次专门写个博客好好说说ORM

插一点事务的东东，springboot整合jpa jdbctempalte等ORM的depency已经自带Transaction注解了，也是默认的

你可以在@Test处加上

    @Transactional(propagation = Propagation.REQUIRED)
    

然后我们开始spring-data-jpa黑魔法，号称业务操作几乎不需要写任何sql的ORM框架，也是spring进军ORM的产品

pom：

    <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
    <version>1.5.3.RELEASE</version>
    </dependency>
    <dependency>
    <groupId>javax.persistence</groupId>
    <artifactId>persistence-api</artifactId>
    <version>1.0.2</version>
    </dependency>
    IDEA 1.5.4版本要选择一下jpa的版本，否则会有引不到JPA注解的bug，我当时就被坑了十几分钟，换了很多persistence的depency
    老规矩，model开始

    package com.zhengyu.model;
    
    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.Id;
    import javax.persistence.Table;
    import java.math.BigDecimal;
    
    /**
     * Created by niezy on 2017/7/26.
     */
    @Entity
    @Table(name = "student")
    publicclass Student {
      @Id
      @GeneratedValue
      private Long id;
      @Column(nullable = false,length = 5)
      private String name;
      @Column(nullable = false)
      private Integer age;
    
      @Column(nullable = false)
      private BigDecimal salary;
    
      @Column(nullable = false)
      private String address;
    
      public Student() {}
    
      public Student(String name, Integer age) {
        this.name = name;
        this.age = age;
      }
    
      public Student(Long id, String name, Integer age) {
        this.id = id;
        this.name = name;
        this.age = age;
      }
    
      public Student(String name, Integer age, BigDecimal salary, String address) {
        this.name = name;
        this.age = age;
        this.salary = salary;
        this.address = address;
      }
    
      public BigDecimal getSalary() {
        return salary;
      }
    
      publicvoid setSalary(BigDecimal salary) {
        this.salary = salary;
      }
    
      public String getAddress() {
        return address;
      }
    
      publicvoid setAddress(String address) {
        this.address = address;
      }
    
      public Long getId() {
        return id;
      }
    
      publicvoid setId(Long id) {
        this.id = id;
      }
    
      public String getName() {
        return name;
      }
    
      publicvoid setName(String name) {
        this.name = name;
      }
    
      public Integer getAge() {
        return age;
      }
    
      publicvoid setAge(Integer age) {
        this.age = age;
      }
    
      @Override
      public String toString() {
        return "Student{" + "id=" + id + ", name='" + name + '\'' + ", age=" + age + ", salary=" + salary + ", address='"
            + address + '\'' + '}';
      }
    }

然后service：

    package com.zhengyu.datajpaservice;
    
    import com.zhengyu.model.Student;
    import org.springframework.data.jpa.repository.JpaRepository;
    import org.springframework.data.jpa.repository.Query;
    import org.springframework.data.repository.query.Param;
    
    import java.math.BigDecimal;
    import java.util.List;
    
    /**
     * Created by niezy on 2017/7/26.
     */publicinterface StudentRepository extends JpaRepository<Student, Long> {
    
      Student findByName(String name);
    
      List<Student> findListByName(String name);
    
      Student findByNameAndAge(String name, Integer age);
    
      @Query("from Student  where name=:name")
      Student findStudent(@Param("name") String name);
    
      List<Student> findByNameOrderBySalaryDesc(String name);
    
      List<Student> findBySalary(BigDecimal salary);
    
    }

    测试：

    package com.zhengyu;
    
    
    import com.zhengyu.datajpaservice.StudentRepository;
    import com.zhengyu.model.Student;
    import org.junit.Assert;
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.test.context.junit4.SpringRunner;
    import org.springframework.transaction.annotation.Propagation;
    import org.springframework.transaction.annotation.Transactional;
    
    import java.math.BigDecimal;
    import java.util.List;
    
    /**
     * Created by niezy on 2017/7/26.
     */
    @RunWith(SpringRunner.class)
    @SpringBootTest
    publicclass SpringdatajpaTest {
      @Autowired
      private StudentRepository studentRepository;
    
      // @Before
      // public void setUp() {
      //// 准备工作
      // studentRepository.deleteAll();
      //// }
      @Test
      @Transactional(propagation = Propagation.REQUIRED)
      publicvoid test() throws Exception {
    
        // 创建10条记录
        studentRepository.save(new Student("AAA", 10, new BigDecimal(20000), "shanghai"));
        studentRepository.save(new Student("BBB", 20, new BigDecimal(50000), "beijing"));
        studentRepository.save(new Student("CCC", 30, new BigDecimal(20000), "shanghai"));
        studentRepository.save(new Student("DDD", 40, new BigDecimal(50000), "beijing"));
        studentRepository.save(new Student("EEE", 50, new BigDecimal(20000), "shanghai"));
        studentRepository.save(new Student("EEE", 60, new BigDecimal(50000), "beijing"));
        studentRepository.save(new Student("EEE", 70, new BigDecimal(20000), "shanghai"));
        studentRepository.save(new Student("FFF", 60, new BigDecimal(50000), "beijing"));
        studentRepository.save(new Student("III", 90, new BigDecimal(20000), "shanghai"));
        studentRepository.save(new Student("JJJ", 100, new BigDecimal(50000), "beijing"));
    
        // 测试findAll, 查询所有记录
        Assert.assertEquals(10, studentRepository.findAll().size());
        // 测试findByName, 查询姓名为FFF的User
        Assert.assertEquals(60, studentRepository.findByName("FFF").getAge().longValue());
        // 测试findUser, 查询姓名为FFF的User
        Assert.assertEquals(60, studentRepository.findStudent("FFF").getAge().longValue());
        // 测试findByNameAndAge, 查询姓名为FFF并且年龄为60的User
        Assert.assertEquals("FFF", studentRepository.findByNameAndAge("FFF", 60).getName());
        // 测试删除姓名为AAA的User
        studentRepository.delete(studentRepository.findByName("AAA"));
        // 测试findAll, 查询所有记录, 验证上面的删除是否成功
        Assert.assertEquals(9, studentRepository.findAll().size());
    
        // List<Student> stuList = studentRepository.findByNameOrderBySalaryDesc("EEE");
        List<Student> stuList = studentRepository.findBySalary(new BigDecimal(20000));
        for (Student stu : stuList) {
          System.out.println(stu.toString());
        }
    
        List<Student> stuList2 = studentRepository.findListByName("EEE");
        for (Student stu : stuList2) {
          System.out.println(stu.toString());
        }
    
    
      }
    }

application.properties加上：

    spring.jpa.properties.hibernate.hbm2ddl.auto=create-drop
    关于hbm2ddl:

![](/wp-content/uploads/2017/07/1501258295.png)

这个属于hibernate知识点了，我这里选择create-drop。

关于spring-data-jpa,确实很轻量很给力

在实际开发过程中，对数据库的操作无非就“增删改查”。就最为普遍的单表操作而言，除了表和字段不同外，语句都是类似的，开发人员需要写大量类似而枯燥的语句来完成业务逻辑。

为了解决这些大量枯燥的数据操作语句，我们第一个想到的是使用ORM框架，比如：Hibernate。通过整合Hibernate之后，我们以操作Java实体的方式最终将数据改变映射到数据库表中。

为了解决抽象各个Java实体基本的“增删改查”操作，我们通常会以泛型的方式封装一个模板Dao来进行抽象简化，但是这样依然不是很方便，我们需要针对每个实体编写一个继承自泛型模板Dao的接口，再编写该接口的实现。虽然一些基础的数据访问已经可以得到很好的复用，但是在代码结构上针对每个实体都会有一堆Dao的接口和实现。

由于模板Dao的实现，使得这些具体实体的Dao层已经变的非常“薄”，有一些具体实体的Dao实现可能完全就是对模板Dao的简单代理，并且往往这样的实现类可能会出现在很多实体上。Spring-data-jpa的出现正可以让这样一个已经很“薄”的数据访问层变成只是一层接口的编写方式。

**Spring-data-jpa的能力远不止本文提到的这些，由于本文主要以整合介绍为主，对于Spring-data-jpa的使用只是介绍了常见的使用方式。诸如@Modifying操作、分页排序、原生SQL支持以及与Spring MVC的结合使用等等内容就不在本文中详细展开**

    
    

    
    

@Transactional(isolation = Isolation.DEFAULT)
{% endraw %}
