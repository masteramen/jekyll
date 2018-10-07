---
layout: post
title:  "springJDBC01 利用springJDBC操作数据库"
title2:  "springJDBC01 利用springJDBC操作数据库"
date:   2017-01-01 23:56:10  +0800
source:  "http://www.jfox.info/springjdbc01%e5%88%a9%e7%94%a8springjdbc%e6%93%8d%e4%bd%9c%e6%95%b0%e6%8d%ae%e5%ba%93.html"
fileName:  "20170101270"
lang:  "zh_CN"
published: true
permalink: "springjdbc01%e5%88%a9%e7%94%a8springjdbc%e6%93%8d%e4%bd%9c%e6%95%b0%e6%8d%ae%e5%ba%93.html"
---
{% raw %}
## 1 什么是springJDBC

　　spring通过抽象JDBC访问并一致的API来简化JDBC编程的工作量。我们只需要声明SQL、调用合适的SpringJDBC框架API、处理结果集即可。事务由Spring管理，并将JDBC受查异常转换为Spring一致的非受查异常，从而简化开发。

　　利用传统的jdbc操作数据库的步骤：获取连接→创建Statement→执行数据操作→获取结果→关闭Statement→关闭结果集→关闭连接；而Spring JDBC通过一个模板类org.springframework. jdbc.core.JdbcTemplate封装了样板式的代码，用户通过模板类就可以轻松地完成大部分数据访问的操作。

## 2 前期准备

### 　　2.1 jar包

　　　　spring-jdbc : springjdbc的包
mysql ： MySQL的驱动包
dbcp ：数据库连接池
spring-webmvc : springmvc框架包
annotation ：@resource需要用到的包，该包在Tomcat中有，如果是web项目而且运行环境是Tomcat的话就不需要导入这个包了
junit ： 单元测试包

### 　　2.2 数据库（使用mysql数据库5.4）
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1# 创建用户表
     2CREATE TABLE t_user (
     3    user_id INT AUTO_INCREMENT PRIMARY KEY,
     4    user_name VARCHAR (30),
     5    credits INT,
     6    password VARCHAR (32),
     7    last_visit DATETIME,
     8    last_ip VARCHAR(23)
     9) ENGINE = InnoDB;
    1011# 查询t_user表的结构
    12DESC t_user;
    1314# 创建用户登录日志表
    15CREATE TABLE t_login_log (
    16    login_log_id INT AUTO_INCREMENT PRIMARY KEY,
    17    user_id INT,
    18    ip VARCHAR (23),
    19    login_datetime DATETIME
    20) ENGINE = InnoDB;
    2122#查询 t_login_log 表的结构
    23DESC t_login_log;
    2425INSERT INTO t_user
    26(user_name, password) 
    27VALUES
    28("wys", "182838" ); 
    2930 SELECT * FROM t_user;

相关表
## 3 环境搭建（使用的是eclipse）

### 　　3.1 利用maven导入相关jar包
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> 2<modelVersion>4.0.0</modelVersion> 3<groupId>cn.xiangxu</groupId> 4<artifactId>baobaotao</artifactId> 5<version>0.0.1-SNAPSHOT</version> 6<packaging>war</packaging> 7<dependencies> 8<dependency> 9<groupId>org.springframework</groupId>10<artifactId>spring-webmvc</artifactId>11<version>3.2.8.RELEASE</version>12</dependency>13<dependency>14<groupId>mysql</groupId>15<artifactId>mysql-connector-java</artifactId>16<version>5.1.37</version>17</dependency>18<dependency>19<groupId>org.springframework</groupId>20<artifactId>spring-jdbc</artifactId>21<version>3.2.8.RELEASE</version>22</dependency>23<dependency>24<groupId>commons-dbcp</groupId>25<artifactId>commons-dbcp</artifactId>26<version>1.4</version>27</dependency>28<dependency>29<groupId>javax.annotation</groupId>30<artifactId>javax.annotation-api</artifactId>31<version>1.2</version>32</dependency>33<dependency>34<groupId>junit</groupId>35<artifactId>junit</artifactId>36<version>4.12</version>37</dependency>38</dependencies>39</project>

pom.xml
### 　　3.2 创建properties文件，用于存放数据库相关信息
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
    1driverClassName=com.mysql.jdbc.Driver
    2url=jdbc:mysql://127.0.0.1:3306/sampledb
    3username=root
    4password=182838
    5maxActive=10
    6 maxWait=3000

mysql.properties
### 　　3.3 创建spring配置文件

#### 　　　　3.3.1 配置properties文件的bean

#### 　　　　3.3.2 配置数据库连接池

#### 　　　　3.3.3 配置jdbcTemplate

#### 　　　　3.3.4 配置组件扫描
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1<?xml version="1.0" encoding="UTF-8"?> 2<beans xmlns="http://www.springframework.org/schema/beans" 3    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context" 4    xmlns:jdbc="http://www.springframework.org/schema/jdbc" xmlns:jee="http://www.springframework.org/schema/jee" 5    xmlns:tx="http://www.springframework.org/schema/tx" xmlns:aop="http://www.springframework.org/schema/aop" 6    xmlns:mvc="http://www.springframework.org/schema/mvc" xmlns:util="http://www.springframework.org/schema/util" 7    xmlns:jpa="http://www.springframework.org/schema/data/jpa" 8    xsi:schemaLocation="
     9        http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
    10        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.2.xsd
    11        http://www.springframework.org/schema/jdbc http://www.springframework.org/schema/jdbc/spring-jdbc-3.2.xsd
    12        http://www.springframework.org/schema/jee http://www.springframework.org/schema/jee/spring-jee-3.2.xsd
    13        http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-3.2.xsd
    14        http://www.springframework.org/schema/data/jpa http://www.springframework.org/schema/data/jpa/spring-jpa-1.3.xsd
    15        http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-3.2.xsd
    16        http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd
    17        http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util-3.2.xsd">1819<!-- 读取mysql.properties文件 -->20<util:properties id="mysql" location="classpath:config/mysql.properties"/>2122<!-- 配置连接池 -->23<bean id="ds" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">24<property name="driverClassName" value="#{mysql.driverClassName}"/>25<property name="url" value="#{mysql.url}"/>26<property name="username" value="#{mysql.username}"/>27<property name="password" value="#{mysql.password}"/>28</bean>2930<!-- 配置jdbcTemplate -->31<bean id="jt" class="org.springframework.jdbc.core.JdbcTemplate">32<property name="dataSource" ref="ds"></property>33</bean>3435<!-- 组件扫描 -->36<context:component-scan base-package="com.baobaotao"></context:component-scan>3738</beans>

spring_mysql.xml
　　注意：我们不用配置spirng的主控制器，因为我们只是操作持久层；虽然我们用到了spring容器，但是我们可以通过编写代码来启动容器

### 　　3.4 项目结构图

![](/wp-content/uploads/2017/07/1500041949.png)

## 4 代码实现数据库操作

### 　　4.1 编写实体类
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1package com.baobaotao.entity;
     2 3import java.io.Serializable;
     4import java.util.Date;
     5 6publicclass User implements Serializable {
     7 8privatestaticfinallong serialVersionUID = -3573627859368072117L;
     910private Integer userId;
    11private String userName;
    12private Integer credits;
    13private String password;
    14private Date lastVisit;
    15private String lastIp;
    1617public User() {
    18super();
    19// TODO Auto-generated constructor stub20    }
    2122public User(Integer userId, String userName, Integer credits, String password, Date lastVisit, String lastIp) {
    23super();
    24this.userId = userId;
    25this.userName = userName;
    26this.credits = credits;
    27this.password = password;
    28this.lastVisit = lastVisit;
    29this.lastIp = lastIp;
    30    }
    3132    @Override
    33publicint hashCode() {
    34finalint prime = 31;
    35int result = 1;
    36         result = prime * result + ((lastIp == null) ? 0 : lastIp.hashCode());
    37return result;
    38    }
    39    @Override
    40publicboolean equals(Object obj) {
    41if (this == obj)
    42returntrue;
    43if (obj == null)
    44returnfalse;
    45if (getClass() != obj.getClass())
    46returnfalse;
    47         User other = (User) obj;
    48if (lastIp == null) {
    49if (other.lastIp != null)
    50returnfalse;
    51         } elseif (!lastIp.equals(other.lastIp))
    52returnfalse;
    53returntrue;
    54    }
    55public Integer getUserId() {
    56return userId;
    57    }
    58publicvoid setUserId(Integer userId) {
    59this.userId = userId;
    60    }
    61public String getUserName() {
    62return userName;
    63    }
    64publicvoid setUserName(String userName) {
    65this.userName = userName;
    66    }
    67public Integer getCredits() {
    68return credits;
    69    }
    70publicvoid setCredits(Integer credits) {
    71this.credits = credits;
    72    }
    73public String getPassword() {
    74return password;
    75    }
    76publicvoid setPassword(String password) {
    77this.password = password;
    78    }
    79public Date getLastVisit() {
    80return lastVisit;
    81    }
    82publicvoid setLastVisit(Date lastVisit) {
    83this.lastVisit = lastVisit;
    84    }
    85public String getLastIp() {
    86return lastIp;
    87    }
    88publicvoid setLastIp(String lastIp) {
    89this.lastIp = lastIp;
    90    }
    9192    @Override
    93public String toString() {
    94return "User [userId=" + userId + ", userName=" + userName + ", credits=" + credits + ", password=" + password
    95                 + ", lastVisit=" + lastVisit + ", lastIp=" + lastIp + "]";
    96    }
    9798 }

User.java![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1package com.baobaotao.entity;
     2 3import java.io.Serializable;
     4import java.util.Date;
     5 6publicclass LoginLog implements Serializable {
     7 8privatestaticfinallong serialVersionUID = 5176708814959439551L;
     910private Integer loginLogId;
    11private String userId;
    12private String ip;
    13private Date loginDatetime;
    14    @Override
    15publicint hashCode() {
    16finalint prime = 31;
    17int result = 1;
    18         result = prime * result + ((ip == null) ? 0 : ip.hashCode());
    19         result = prime * result + ((loginDatetime == null) ? 0 : loginDatetime.hashCode());
    20         result = prime * result + ((loginLogId == null) ? 0 : loginLogId.hashCode());
    21         result = prime * result + ((userId == null) ? 0 : userId.hashCode());
    22return result;
    23    }
    24    @Override
    25publicboolean equals(Object obj) {
    26if (this == obj)
    27returntrue;
    28if (obj == null)
    29returnfalse;
    30if (getClass() != obj.getClass())
    31returnfalse;
    32         LoginLog other = (LoginLog) obj;
    33if (ip == null) {
    34if (other.ip != null)
    35returnfalse;
    36         } elseif (!ip.equals(other.ip))
    37returnfalse;
    38if (loginDatetime == null) {
    39if (other.loginDatetime != null)
    40returnfalse;
    41         } elseif (!loginDatetime.equals(other.loginDatetime))
    42returnfalse;
    43if (loginLogId == null) {
    44if (other.loginLogId != null)
    45returnfalse;
    46         } elseif (!loginLogId.equals(other.loginLogId))
    47returnfalse;
    48if (userId == null) {
    49if (other.userId != null)
    50returnfalse;
    51         } elseif (!userId.equals(other.userId))
    52returnfalse;
    53returntrue;
    54    }
    55public Integer getLoginLogId() {
    56return loginLogId;
    57    }
    58publicvoid setLoginLogId(Integer loginLogId) {
    59this.loginLogId = loginLogId;
    60    }
    61public String getUserId() {
    62return userId;
    63    }
    64publicvoid setUserId(String userId) {
    65this.userId = userId;
    66    }
    67public String getIp() {
    68return ip;
    69    }
    70publicvoid setIp(String ip) {
    71this.ip = ip;
    72    }
    73public Date getLoginDatetime() {
    74return loginDatetime;
    75    }
    76publicvoid setLoginDatetime(Date loginDatetime) {
    77this.loginDatetime = loginDatetime;
    78    }
    79public LoginLog() {
    80super();
    81// TODO Auto-generated constructor stub82    }
    83public LoginLog(Integer loginLogId, String userId, String ip, Date loginDatetime) {
    84super();
    85this.loginLogId = loginLogId;
    86this.userId = userId;
    87this.ip = ip;
    88this.loginDatetime = loginDatetime;
    89    }
    90    @Override
    91public String toString() {
    92return "LoginLog [loginLogId=" + loginLogId + ", userId=" + userId + ", ip=" + ip + ", loginDatetime="
    93                 + loginDatetime + "]";
    94    }    
    9596 }

LoginLog.java
### 　　4.2 编写UserDao接口
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1package com.baobaotao.dao;
     2 3import java.util.List;
     4 5import com.baobaotao.entity.User;
     6 7publicinterface UserDao {
     8/** 9     * 向用户表中添加记录
    10     * @param user 用户表实体对象
    11*/12publicvoid insert(User user);
    1314/**15     * 查询所有用户数据
    16     * @return 由查询到记录组成的集合
    17*/18public List<User> findAll();
    1920 }

UserDao.java
### 　　4.3 编写UserDao接口的实现类UserDaoImpl　　
![](/wp-content/uploads/2017/07/1500041948.gif)![](/wp-content/uploads/2017/07/15000419481.gif)
     1package com.baobaotao.dao;
     2 3import java.sql.ResultSet;
     4import java.sql.SQLException;
     5import java.util.List;
     6 7import javax.annotation.Resource;
     8 9import org.springframework.jdbc.core.JdbcTemplate;
    10import org.springframework.jdbc.core.RowMapper;
    11import org.springframework.stereotype.Repository;
    1213import com.baobaotao.entity.User;
    1415 @Repository("userDao")
    16publicclass UserDaoImpl implements UserDao {
    1718     @Resource(name="jt")
    19private JdbcTemplate jt;
    2021publicvoid insert(User user) {
    2223         String sql = "INSERT INTO t_user " + 
    24                 "(user_name, password) " + 
    25                 "VALUES " + 
    26                 "(?, ?) ";
    27         Object [] args = {user.getUserName(), user.getPassword()};
    28         Integer num = jt.update(sql, args);
    29if(num > 0) {
    30             System.out.println("插入数据成功");
    31         } else {
    32             System.out.println("插入数据失败");
    33        }
    3435    }
    3637public List<User> findAll() {
    38         String sql = "SELECT * FROM t_user ";
{% endraw %}
