---
layout: post
title:  "JAVAWEB开发之mybatis详解(一)——mybatis的入门(实现增删改查操作)、自定义别名、抽取代码块以及动态SQL的使用"
title2:  "JAVAWEB开发之mybatis详解(一)——mybatis的入门(实现增删改查操作)、自定义别名、抽取代码块以及动态SQL的使用"
date:   2017-01-01 23:48:50  +0800
source:  "https://www.jfox.info/javaweb-kai-fa-zhi-mybatis-xiang-jie-yi-mybatis-de-ru-men-shi-xian-zeng-shan-gai-cha-cao-zuo-zi-ding.html"
fileName:  "20170100830"
lang:  "zh_CN"
published: true
permalink: "2017/javaweb-kai-fa-zhi-mybatis-xiang-jie-yi-mybatis-de-ru-men-shi-xian-zeng-shan-gai-cha-cao-zuo-zi-ding.html"
---
{% raw %}
# JAVAWEB开发之mybatis详解(一)——mybatis的入门(实现增删改查操作)、自定义别名、抽取代码块以及动态SQL的使用 

By Lee - Last updated: 星期二, 六月 6, 2017

## mybatis简介

 mybatis是一个Java持久层框架，Java中操作关系型数据库使用的是jdbc，mybatis是对jdbc的封装。

mybatis的入门需要掌握以下几点：

1、使用jdbc程序使用原生态的jdbc进行开发存在很多弊端，优点是执行效率高，mybatis弥补了jdbc的缺陷。

2、mybatis的架构(重点)。

3、mybatis的入门程序(重点)。

 实现数据的查询、添加、修改、删除

4、mybatis开发DAO的两种方法(重点)

 原始的DAO开发方式(DAO接口和DAO实现都需要编写)

 mapper代理方式(只需要编写DAO接口)

5、输入映射类型和输出映射类型

6、动态SQL

mybatis的高级知识主要包括以下几点：

高级映射查询(一对一、一对多、多对多)(重点)

查询缓存

延迟加载

mybatis和Spring整合(重点)

mybatis逆向工程

## 开发环境(eclipse、MySQL)

创建数据库

创建数据库mybatis

新建表结构：

sql_table.sql

    *
    SQLyog v10.2 
    MySQL - 5.1.72-community : Database - mybatis
    *********************************************************************
    */
    /*!40101 SET NAMES utf8 */;
    /*!40101 SET SQL_MODE=''*/;
    /*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
    /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
    /*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
    /*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
    /*Table structure for table `items` */
    CREATE TABLE `items` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `name` varchar(32) NOT NULL COMMENT '商品名称',
      `price` float(10,1) NOT NULL COMMENT '商品定价',
      `detail` text COMMENT '商品描述',
      `pic` varchar(64) DEFAULT NULL COMMENT '商品图片',
      `createtime` datetime NOT NULL COMMENT '生产日期',
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
    /*Table structure for table `orderdetail` */
    CREATE TABLE `orderdetail` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `orders_id` int(11) NOT NULL COMMENT '订单id',
      `items_id` int(11) NOT NULL COMMENT '商品id',
      `items_num` int(11) DEFAULT NULL COMMENT '商品购买数量',
      PRIMARY KEY (`id`),
      KEY `FK_orderdetail_1` (`orders_id`),
      KEY `FK_orderdetail_2` (`items_id`),
      CONSTRAINT `FK_orderdetail_1` FOREIGN KEY (`orders_id`) REFERENCES `orders` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
      CONSTRAINT `FK_orderdetail_2` FOREIGN KEY (`items_id`) REFERENCES `items` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
    /*Table structure for table `orders` */
    CREATE TABLE `orders` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `user_id` int(11) NOT NULL COMMENT '下单用户id',
      `number` varchar(32) NOT NULL COMMENT '订单号',
      `createtime` datetime NOT NULL COMMENT '创建订单时间',
      `note` varchar(100) DEFAULT NULL COMMENT '备注',
      PRIMARY KEY (`id`),
      KEY `FK_orders_1` (`user_id`),
      CONSTRAINT `FK_orders_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
    ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
    /*Table structure for table `user` */
    CREATE TABLE `user` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `username` varchar(32) NOT NULL COMMENT '用户名称',
      `birthday` date DEFAULT NULL COMMENT '生日',
      `sex` char(1) DEFAULT NULL COMMENT '性别',
      `address` varchar(256) DEFAULT NULL COMMENT '地址',
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
    /*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
    /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
    /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
    /*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
    

创建数据
sql_data.sql

    /*
    SQLyog v10.2 
    MySQL - 5.1.72-community : Database - mybatis
    *********************************************************************
    */
    /*!40101 SET NAMES utf8 */;
    /*!40101 SET SQL_MODE=''*/;
    /*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
    /*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
    /*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
    /*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
    /*Data for the table `items` */
    insert  into `items`(`id`,`name`,`price`,`detail`,`pic`,`createtime`) values (1,'台式机',3000.0,'该电脑质量非常好！！！！',NULL,'2015-02-03 13:22:53'),(2,'笔记本',6000.0,'笔记本性能好，质量好！！！！！',NULL,'2015-02-09 13:22:57'),(3,'背包',200.0,'名牌背包，容量大质量好！！！！',NULL,'2015-02-06 13:23:02');
    /*Data for the table `orderdetail` */
    insert  into `orderdetail`(`id`,`orders_id`,`items_id`,`items_num`) values (1,3,1,1),(2,3,2,3),(3,4,3,4),(4,4,2,3);
    /*Data for the table `orders` */
    insert  into `orders`(`id`,`user_id`,`number`,`createtime`,`note`) values (3,1,'1000010','2015-02-04 13:22:35',NULL),(4,1,'1000011','2015-02-03 13:22:41',NULL),(5,10,'1000012','2015-02-12 16:13:23',NULL);
    /*Data for the table `user` */
    insert  into `user`(`id`,`username`,`birthday`,`sex`,`address`) values (1,'王五',NULL,'2',NULL),(10,'张三','2014-07-10','1','北京市'),(16,'张小明',NULL,'1','河南郑州'),(22,'陈小明',NULL,'1','河南郑州'),(24,'张三丰',NULL,'1','河南郑州'),(25,'陈小明',NULL,'1','河南郑州'),(26,'王五',NULL,NULL,NULL);
    /*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
    /*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
    /*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
    /*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
    

![](/wp-content/uploads/2017/06/Center.png)
## jdbc编程中的问题

 企业开发中，根据项目大小、特点进行技术选型，jdbc操作数据库时效率时很高的，jdbc也是结束选型的参考

### jdbc程序 

 需要数据库驱动包

![](/wp-content/uploads/2017/06/Center1.png)

上边是MySQL的驱动，下边是oracle的驱动

参考下边一段程序

    package test.lx.mybatis.jdbc;
    import java.sql.Connection;
    import java.sql.DriverManager;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.sql.SQLException;
    /**
     * jdbc的测试程序
     * 
     * @author lx
     * 
     */
    public class JdbcTest {
    	public static void main(String[] args) {
    		Connection connection = null;
    		//PreparedStatement是预编译的Statement，通过Statement发起数据库的操作
    		//PreparedStatement防止sql注入，执行数据库效率高
    		PreparedStatement preparedStatement = null;
    		ResultSet resultSet = null;
    		try {
    			//加载数据库驱动
    			Class.forName("com.mysql.jdbc.Driver");
    			//通过驱动管理类获取数据库链接
    			connection =  DriverManager.getConnection("jdbc:mysql://localhost:3306/mybatis?characterEncoding=utf-8", "root", "root");
    			//定义sql语句 ?表示占位符
    		String sql = "select * from user where username = ?" ;
    			//获取预处理statement
    			preparedStatement = connection.prepareStatement(sql);
    			//设置参数，第一个参数为sql语句中参数的序号（从1开始），第二个参数为设置的参数值
    			preparedStatement.setString(1, "王五");
    			//向数据库发出sql执行查询，查询出结果集
    			resultSet =  preparedStatement.executeQuery();
    			//遍历查询结果集
    			while(resultSet.next()){
    				System.out.println(resultSet.getString("id")+"  "+resultSet.getString("username"));
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}finally{
    			//释放资源
    			if(resultSet!=null){
    				try {
    					resultSet.close();
    				} catch (SQLException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    				}
    			}
    			if(preparedStatement!=null){
    				try {
    					preparedStatement.close();
    				} catch (SQLException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    				}
    			}
    			if(connection!=null){
    				try {
    					connection.close();
    				} catch (SQLException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    				}
    			}
    		}
    	}
    }

### jdbc问题总结
1、数据库连接频繁的创建和关闭，缺点浪费数据库的资源，影响操作效率 设想：使用数据库连接池2、SQL语句是硬编码，如果需求变更需要修改SQL，就需要修改Java代码，需要重新编译，系统不易维护。 设想：将SQL语句统一配置在文件中，修改SQL不需要修改Java代码3、通过PreparedStatement向占位符设置参数，存在硬编码(参数位置，参数)问题。系统不易维护。 设想：将SQL中的占位符以及对应的参数类型配置在配置文件中，能够自动输入映射4、遍历查询结果集中存在硬编码(列名) 设想：自动进行SQL查询结果向Java对象的映射(输出映射)
## mybatis架构(重点)
mybatis介绍：
- mybatis本是Apache的一个开源项目ibatis，2010年这个项目由Apache software foundation迁移到了Google code，并且改名为mybatis，实质上mybatis对ibatis进行了一些改进。目前mybatis在GitHub上托管。git(分布式版本控制，当前比较流行)
- mybatis是一个优秀的持久层框架，它对jdbc的操作数据库的过程进行封装，使开发者只需要关注SQL本身，而不需要花费精力去处理例如注册驱动、创建connection、创建statement、手动设置参数、结果集检索等jdbc繁杂的过程代码。
- mybatis通过xml或注解的方式将要执行的各种statement( statement、PreparedStatement、CallableStatement)配置起来，并通过Java对象和Statement中的SQL进行映射生成最终执行的SQL语句，最后由mybatis框架执行SQL并将结果映射成Java对象并返回。

mybatis架构![](/wp-content/uploads/2017/06/Center2.png)

## mybatis入门程序

### 需求

实现用户查询：

根据用户的id查询用户的信息(单条记录)

根据用户名模糊查询用户信息(多条记录)

用户添加、用户修改、用删除

### 导入jar包

从mybatis官网下载地址是: [https://github.com/mybatis/mybatis-3/releases](https://www.jfox.info/go.php?url=https://github.com/mybatis/mybatis-3/releases)

![](/wp-content/uploads/2017/06/Center3.png)

mybatis-3.2.7.pdf —操作手册

mybatis-3.2.7.jar— 核心jar

lib—依赖jar包

![](/wp-content/uploads/2017/06/Center4.png)

### 工程结构

![](/wp-content/uploads/2017/06/Center5.png)

### log4j.properties(公用文件)

建议开发环境中要使用debug

    # Global logging configurationuff0cu5efau8baeu5f00u53d1u73afu5883u4e2du8981u7528debug
    log4j.rootLogger=DEBUG, stdout
    # Console output...
    log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
    

### SqlMapConfig.xml(公用文件)
通过SqlMapConfig.xml加载mybatis运行环境
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE configuration
    PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
    	<!-- 和Spring整合后environments配置将废除 -->
    	<environments default="development">
    		<environment id="development">
    			<!-- 使用jdbc事务管理 -->
    			<transactionManager type="JDBC" />
    			<dataSource type="POOLED">
    				<property name="driver" value="com.mysql.jdbc.Driver" />
    				<property name="url" value="jdbc:mysql://localhost:3306/mybatis" />
    				<property name="username" value="root" />
    				<property name="password" value="root" />
    			</dataSource>
    		</environment>
    	</environments>
    	<!-- 加載mapper文件 -->
    	<mappers>
    		<mapper resource="sqlmap/User.xml" />
    	</mappers>
    </configuration>
    

### 根据id查询用户

#### pojo (User.java)

    public class User {
    	private int id;
    	private String username; // 用户姓名
    	private String sex; // 性别
    	private Date birthday; // 生日
    	private String address; // 地址
            // 添加对应的setter和getter方法
            ......
    }

#### User.xml (重点)
建议命名规则：表名+mapper.xml早期ibatis命名规则：表名.xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <!-- namespace命名空间，为了对SQL语句进行隔离，方便管理，mapper可开发dao方式，使用namespace有特殊作用 
    mapper代理开发时将namespace指定为mapper接口的全限定名 -->
    <mapper namespace="test">
    <!-- 在mapper.xml文件中配置很多的SQL语句，执行每个SQL语句时，封装为MappedStatement对象
    mapper.xml以statement为单位管理SQL语句
     -->
     <!-- 根据id查询用户信息 -->
     <!-- 
        id: 唯一标识一个statement
        #{}：表示一个占位符，如果#{} 中传入简单类型的参数，#{}中的名称随意
        parameterType: 输入参数的类型，通过#{}接收parameterType输入的参数
        resultType：输出结果类型，指定单条记录映射的pojo类型
      -->
      <select id="findUserById" parameterType="int" resultType="test.lx.mybatis.po.User">
         SELECT * FROM USER WHERE id=#{id};
      </select>
    </mapper>

#### 编码
创建SqlSessionFactory
                    // 会话工厂
    		private SqlSessionFactory sqlSessionFactory;
    		// 创建工厂
    		@Before
    		public void init() throws IOException {
    			// 配置文件（SqlMapConfig.xml）
    			String resource = "SqlMapConfig.xml";
    			// 加载配置文件到输入 流
    			InputStream inputStream = Resources.getResourceAsStream(resource);
    			// 创建会话工厂
    			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    		}
    		// 测试根据id查询用户(得到单条记录)
    		@Test
    		public void testFindUserById() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			// 通过sqlSession操作数据库
    			// 第一个参数：statement的位置，等于namespace+statement的id
    			// 第二个参数：传入的参数
    			User user = null;
    			try {
    				user = sqlSession.selectOne("test.findUserById", 1);
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    			System.out.println(user);
    		}

### 根据用户名称模糊查询用户信息
根据用户名称模糊查询用户信息可能返回多条记录。
#### User.xml

     <!-- 根据用户名称查询用户信息，可能返回多条 
      ${}:表示SQL的拼接，通过${}接收参数，将参数的内容不加任何修饰的拼接在SQL中
      -->
      <select id="findUserByName" parameterType="java.lang.String" resultType="test.lx.mybatis.po.User">
           select * from user where username like '%${value}%' 
      </select>
      <select id="findUserByName2" parameterType="java.lang.String" resultType="test.lx.mybatis.po.User">
           select * from user where username like #{username} 
      </select>

#### 编码

    // 测试根据名称模糊查询用户(可能得到多条记录)
    		@Test
    		public void testFindUserByName() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			// 通过sqlSession操作数据库
    			// 第一个参数：statement的位置，等于namespace+statement的id
    			// 第二个参数：传入的参数
    			List<User> list = null;
    			try {
    				//list = sqlSession.selectList("test.findUserByName", "小明");
    				list = sqlSession.selectList("test.findUserByName2", "%小明%");
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    			System.out.println(list.size());
    		}

### mybatis开发过程小结
1.编写SqlMapConfig.xml2.编写mapper.xml（定义了statement）3.编程通过配置文件创建SqlSessionFactory4.通过SqlSessionFactory获取SqlSession5.通过SqlSession操作数据库（如果执行修改、添加、删除需要调用SqlSession.commit()）6.SqlSession使用完后后要关闭
### 用户添加
向用户表中添加一条数据记录
#### User.xml

     <!-- 添加用户 
       parameterType:输入参数的类型，User对象包括username,birthday,sex,address
       #{}接收pojo数据,可以使用OGNL解析出pojo的属性值
       #{username}表示从parameterType中获取pojo的属性值
      -->
      <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert>

#### 编码

    		@Test
    		public void testInsertUser() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			//通过sqlSession操作数据库
    			//创建插入数据对象
    			User user = new User();
    			user.setUsername("一蓑烟雨");
    			user.setAddress("河南周口");
    			user.setBirthday(new Date());
    			user.setSex("1");
    			try {
    				sqlSession.insert("test.insertUser", user);
    				//需要提交事务
    				sqlSession.commit();
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    		}

测试结果如下![](/wp-content/uploads/2017/06/Center6.png)

#### 主键返回
需求：user对象插入到数据库后，新纪录的主键要通过user对象返回，通过user获取主键值。解决思路：通过LAST_INSERT_ID()获取刚插入记录的自增主键值，在insert语句执行后，执行select LAST_INSERT_ID()就可以获取自增主键。注意：此语句必须和INSERT语句一块使用并且要在插入后执行。修改User.xml
    <!-- 添加用户 
       parameterType:输入参数的类型，User对象包括username,birthday,sex,address
       #{}接收pojo数据,可以使用OGNL解析出pojo的属性值
       #{username}表示从parameterType中获取pojo的属性值
       <selectKey>:用于进行主键返回，定义了主键值的SQL
       order：设置selectKey标签中SQL的执行顺序，相对于insert语句而言
       keyProperty： 将主键设置到哪个属性上
       resultType：select LAST_INSERT_ID()的结果类型
      -->
      <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
         <selectKey keyProperty="id" order="AFTER" resultType="int">
            select LAST_INSERT_ID()
         </selectKey>
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert>

使用MySQL的uuid机制生成主键：使用uuid生成主键的好处是不考虑数据库移植后的主键冲突问题实现思路：先查询uuid得到主键，将主键设置到user对象中，将user插入到数据库中
     <!-- mysql的uuid()函数生成主键 -->
      <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
         <selectKey keyProperty="id" order="BEFORE" resultType="string">
            select uuid()
         </selectKey>
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert>

如何实现oracle数据库的主键返回？ 

 oracle没有自增主键机制，使用序列完成主键生成 

实现思路：先查询序列得到主键，将主键设置到user对象中，将user对象插入数据库

    <!-- oracle
             在执行insert之前执行select 序列.nextval() from dual取出序列最大值，将值设置到user对象的id属性中
       -->
      <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
         <selectKey keyProperty="id" order="BEFORE" resultType="int">
            select 序列.nextval() from dual
         </selectKey>
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert>

### 用户删除和更新

#### User.xml

     <!-- 用户删除 -->
      <delete id="deleteUser" parameterType="int">
       delete from user where id=#{id}
      </delete>
      <!-- 用户更新
      	要求：传入的user对象包括id属性值
       -->
       <update id="updateUser" parameterType="test.lx.mybatis.po.User">
       update user set username = #{username},birthday=#{birthday},sex=#{sex},address=#{address} where id=#{id}
       </update>

#### 编码

    // 测试删除用户
    		@Test
    		public void testDeleteUser() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			//通过sqlSession操作数据库
    			try {
    				sqlSession.delete("test.deleteUser", 28);
    				//需要提交事务
    				sqlSession.commit();
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    		}
    		// 测试根据id更新用户(得到单条记录)
    		@Test
    		public void testUpdateUser() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			//通过sqlSession操作数据库
    			//创建更新数据库对象，要求必须包括id
    			User user= new User();
    			user.setId(28);
    			user.setUsername("任平生");
    			//凡是没有设置的属性都被当成了NULL进行赋值
    			//user.setBirthday(new Date());
    			user.setSex("1");
    			try {
    				sqlSession.delete("test.updateUser", user);
    				//需要提交事务
    				sqlSession.commit();
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    		}

### Mybatis解决jdbc编程中的问题
1.数据库链接创建、释放频繁造成系统资源浪费从而影响性能，如果使用数据库连接池可以解决此问题。 解决：在SqlMapConfig.xml中配置数据连接池，使用连接池管理数据库连接。2.SQL语句写在代码中造成代码不易维护，实际应用SQL变化可能较大，SQL变动需要改变Java代码。 解决：将SQL语句配置在XXXXMapper.xml文件中与Java代码分离。3.向SQL语句中传参数麻烦，因为SQL语句的where条件不一定，可能多也可能少，占位符和参数要一一对应。 解决：Mybatis自动将Java对象映射至SQL语句，通过statement中的parameterType定义输入参数的类型。4.对结果集解析麻烦，SQL变化导致解析代码变化，且解析前需要遍历，如果能将数据库记录封装成pojo对象解析比较方便。 解决：Mybatis自动将SQL执行结果映射至Java对象，通过statement中的resultType定义输出结果的类型
### Mybatis与Hibernate的重要区别

企业开发进行选型，考虑mybatis和Hibernate适用场景。

Mybatis：入门简单，程序容易上手开发，节省开发成本。Mybatis需要程序员自己编写SQL语句，是一个不完全的ORM框架，对SQL修改和优化非常容易实现。Mybatis适合开发需求变更频繁的系统，比如：互联网项目。

Hibernate：入门门槛高，如果使用Hibernate写出高性能的程序不容易实现。Hibernate不用写SQL语句，是一个完全的ORM框架。Hibernate适合需求固定，对象数据模型稳定，中小型项目，比如：企业OA系统。

总之，企业在技术选型时根据项目实际情况，以降低成本和提高系统可维护性为出发点进行技术选型。

### 总结

#### SqlMapConfig.xml

是mybatis全局配置文件，只有一个，名称不固定，主要mapper.xml,mapper.xml中配置SQL语句。

#### mapper.xml

mapper.xml是以statement为单位进行配置。（把一个SQL称为一个statement），statement中配置SQL语句、parameterType输入参数类型(完成输入映射)、resultType输出结果类型(完成输出映射)。

还提供了parameterMap配置输入参数类型(已过期，不推荐使用)

还提供了resultMap配置输出结果类型(完成输出映射)。

#### 占位符#{}

#{}表示一个占位符吗，向占位符输入参数，mybatis自动进行Java类型和jdbc类型的转换。程序员不需要考虑参数的类型，比如传入字符串，mybatis最终拼接好的SQL就是参数两边加上单引号。#{} 接收pojo数据，可以使用OGNL解析出pojo的属性值。

#### 拼接符${}

表示SQL的拼接，通过${}接收参数，将参数的内容不加任何修饰拼接在SQL中。${}也可以接收pojo的数据，可以使用OGNL解析出pojo的属性值。

缺点：不能防止SQL注入。

#### selectOne和selectList

selectOne用于查询单条记录，不能用于查询多条记录，否则会抛出异常。而selectList用户查询多条记录，也可用于查询单条记录。

# mybatis开发DAO的方法

## SqlSession的作用范围
SqlSessionFactoryBuilder: 是以工具类的方式来使用，需要创建SqlSessionFactory时就new一个SqlSessionFactoryBuilder。SqlSessionFactory：正常开发时，以单例方式管理SqlSessionFactory，整个系统运行过程中SqlSessionFactory只有一个实例，将来和Spring整合后由Spring以单例模式管理SqlSessionFactory。SqlSession: SqlSession是一个面向用户(程序员)的接口，程序员调用SqlSession的 接口方法进行操作数据库问题：SqlSession是否能以单例方式使用？由于SqlSession是线程不安全的，所以SqlSession最佳应用范围是在方法体内，在方法体内定义局部变量使用SqlSession。
## 原始DAO的开发方式

程序员需要编写DAO接口和DAO的实现类

### DAO接口

    public interface UserDao {
    	// 根据id查询用户信息
    	public User findUserById(int id) throws Exception;
    }

### DAO接口的实现

    public class UserDaoImpl implements UserDao {
       private SqlSessionFactory sqlSessionFactory;
       //将SqlSessionFactory注入
       public UserDaoImpl(SqlSessionFactory sqlSessionFactory){
    	   this.sqlSessionFactory = sqlSessionFactory;
       }
    	public User findUserById(int id) throws Exception {
    		//创建SqlSession
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		//根据id查询用户信息
    		User user = sqlSession.selectOne("test.findUserById", id);
    		sqlSession.close();
    		return user;
    	}
    }

### 测试代码

    public class UserDaoImplTest {
    	// 会话工厂
    	private SqlSessionFactory sqlSessionFactory;
    	//创建工厂
    	@Before
    	public void init() throws IOException{
    		//配置文件(SqlMapConfig.xml)
    		String resource = "SqlMapConfig.xml";
    		//加载配置文件到输入流
    		InputStream inputStream = Resources.getResourceAsStream(resource);
    		//创建会话工厂
    		sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);		
    	}
    	@Test
    	public void testFindUserById() throws Exception{
    		UserDao userDao = new UserDaoImpl(sqlSessionFactory);
    		User user = userDao.findUserById(1);
    		System.out.println(user);
    	}
    }

## mapper代理方式
对于mapper代理的方式，程序员只需要写DAO接口，DAO接口实现对象由mybatis自动生成代理对象。本身DAO在三层架构中就是一个通用的接口。
### 原始DAO开发方式的问题

- DAO的实现类中存在重复代码，整个mybatis操作的过程代码模板重复(先创建SqlSession、调用SqlSession的方法、关闭SqlSession)
- DAO的实现类中存在硬编码，调用SqlSession方法时将statement的id硬编码。

### mapper开发规范

要想让mybatis自动创建DAO接口实现类的代理对象，必须遵循一些规则：

1.mapper.xml中namespace指定为mapper接口的全限定名。

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <!-- namespace命名空间，为了对SQL语句进行隔离，方便管理，mapper可开发dao方式，使用namespace有特殊作用 
    mapper代理开发时将namespace指定为mapper接口的全限定名 -->
    <mapper namespace="test.lx.mybatis.mapper.UserMapper">
    ......

此步骤目的：通过mapper.xml和mapper.java进行关联 

2.mapper.xml中statement的id就是mapper.java中的方法名。

3.mapper.xml中statement的parameterType和mapper.java中方法输入参数类型一致。

4.mapper.xml中statement的resultType和mapper.java中方法返回值一致。

### mapper.xml(映射文件)

mapper映射文件的命名方式建议: 表名Mapper.xml

namespace指定为mapper接口的全限定名

     <!-- 根据id查询用户信息 -->
     <!-- 
        id: 唯一标识一个statement
        #{}：表示一个占位符，如果#{} 中传入简单类型的参数，#{}中的名称随意
        parameterType: 输入参数的类型，通过#{}接收parameterType输入的参数
        resultType：输出结果类型，不管返回是多条还是单条，指定单条记录映射的pojo类型
      -->
      <select id="findUserById" parameterType="int" resultType="test.lx.mybatis.po.User">
         SELECT * FROM USER WHERE id=#{id};
      </select>

### mapper接口
mybatis提出了mapper接口，相当于DAO接口mapper接口的命名方式建议: 表名Mapper
    public interface UserMapper {
    	//根据用户id查询用户信息
    	public User findUserById(int id) throws Exception;
    }

### 将mapper.xml在SqlMapConfig.xml中加载

    <!-- 加載mapper文件 -->
    	<mappers>
    		<mapper resource="sqlmap/User.xml" />
    		<mapper resource="test/lx/mybatis/mapper/UserMapper.xml"/>
    	</mappers>

### mapper接口返回单个对象和集合对象
不管查询记录是单条还是多条，在statement中resultType定义一致，都是单条记录映射的pojo类型。mapper接口方法返回值，如果是返回的单个对象，返回值类型是pojo类型，生成的代理对象内部通过selectOne获取记录，如果返回值类型是集合对象，生成的代理对象内部通过selectList获取记录。
    //根据用户id查询用户信息
    	public User findUserById(int id) throws Exception;
    	//根据用户姓名查询用户信息
    	public List<User> findUserByName(String username) throws Exception;

### 问题

#### 返回值问题
如果方法调用的statement，返回的是多条记录，而mapper.java方法的返回值为pojo，此时代理对象通过selectOne调用，由于返回多条记录，所以报错：org.apache.ibatis.exceptions.TooManyResultsException: Expected one result (or null) to be returned by selectOne(), but found: 4

#### 输入参数的问题

使用mapper代理的方式开发，mapper接口方法输入参数只有一个，可扩展性是否很差？

扩展性没有任何问题，因为DAO层就是通用的，可以通过扩展pojo(定义pojo包装类型)将不同的参数(可以是pojo也可以是简单类型)传入进去。

# SqlMapConfig.xml
SqlMapConfig.xml中配置的内容和顺序如下：properties（属性）settings（全局配置参数）typeAliases（类型别名）typeHandlers（类型处理器）objectFactory（对象工厂）plugins（插件）environments（环境集合属性对象） environment（环境子属性对象） transactionManager（事务管理器） dataSource（数据源）mappers（映射器）![](/wp-content/uploads/2017/06/Center7.png)

## properties属性定义

可以把一些通用的属性值配置在属性文件中，加载到mybatis运行环境内，比如：创建db.properties配置数据库连接参数。

     <!-- 属性定义
                 加载一个properties文件
                 在properties标签中配置属性值
         -->
         <properties resource="db.properties">
             <!-- <property name="" value=""/> -->
         </properties>
    	<!-- 和Spring整合后environments配置将废除 -->
    	<environments default="development">
    		<environment id="development">
    			<!-- 使用jdbc事务管理 -->
    			<transactionManager type="JDBC" />
    			<dataSource type="POOLED">
    				<property name="driver" value="${jdbc.driver}" />
    				<property name="url" value="${jdbc.url}" />
    				<property name="username" value="${jdbc.username}" />
    				<property name="password" value="${jdbc.password}" />
    			</dataSource>
    		</environment>
    	</environments>

注意：Mybatis将按照下面的顺序加载属性：

- 在properties元素体内定义的属性首先被读取。
- 然后会读取properties元素中resource或url加载的属性，它会覆盖已经读取的同名属性。
- 最后读取parameterType传递的属性，它会覆盖已经读取的同名属性。

建议使用properties，不要在properties中定义属性，只引用定义的properties文件中的属性，并且properties中定义的key要有一些特殊的规则。

settings全局参数配置

mybatis运行时可以调整一些全局参数，根据使用需求进行参数配置。注意：需要小心配置，配置的参数会影响mybatis的执行。

ibatis的全局配置参数中包括很多的性能参数(最大线程数，最大等待时间…)，通过调整这些参数使ibatis达到高性能的运行，mybatis没有这些性能参数，由mybatis自行调节。

mybatis中全局参数配置示例如下：

     <settings>
            <setting name="cacheEnabled" value="true"/>
         </settings>

还有许多全局参数，根据需求进行配置，如下表所示： 

Setting(设置) Description（描述）Valid Values(验证值组)Default(默认值)

- cacheEnabled在全局范围内启用或禁用缓存配置任何映射器在此配置下。取值范围(true | false),默认值为TRUE
- lazyLoadingEnabled在全局范围内启用或禁用延迟加载。禁用时，所有协会将热加载。取值范围(true | false),默认值为TRUE
- aggressiveLazyLoading启用时，有延迟加载属性的对象将被完全加载后调用懒惰的任何属性。否则，每一个属性是按需加载。取值范围(true | false),默认值为TRUE
- multipleResultSetsEnabled 允许或不允许从一个单独的语句（需要兼容的驱动程序）要返回多个结果集。取值范围(true | false)默认值为TRUE。
- useColumnLabel使用列标签，而不是列名。在这方面，不同的驱动有不同的行为。参考驱动文档或测试两种方法来决定你的驱动程序的行为如何。取值范围(true | false)，默认值为TRUE。
- useGeneratedKeys允许JDBC支持生成的密钥。兼容的驱动程序是必需的。此设置强制生成的键被使用，如果设置为true，一些驱动会不兼容性，但仍然可以工作。取值范围(true | false)，默认值为FALSE。
- autoMappingBehavior指定MyBatis的应如何自动映射列到字段/属性。NONE自动映射。 PARTIAL只会自动映射结果没有嵌套结果映射定义里面。 FULL会自动映射的结果映射任何复杂的（包含嵌套或其他）。取值范围(NONE, PARTIAL, FULL),默认值为PARTIAL。
- defaultExecutorType配置默认执行器。SIMPLE执行器确实没有什么特别的。 REUSE执行器重用准备好的语句。 BATCH执行器重用语句和批处理更新。取值范围(SIMPLE REUSE BATCH),默认值为SIMPLE。
- defaultStatementTimeout设置驱动程序等待一个数据库响应的秒数。任意整型不允许为空(Any positive integer Not Set (null))。
- safeRowBoundsEnabled允许使用嵌套的语句RowBounds。取值范围(true | false)，默认值为FALSE。
- mapUnderscoreToCamelCase从经典的数据库列名A_COLUMN启用自动映射到骆驼标识的经典的Java属性名aColumn。取值范围(true | false)，默认值为FALSE。
- localCacheScopeMyBatis的使用本地缓存，以防止循环引用，并加快反复嵌套查询。默认情况下（SESSION）会话期间执行的所有查询缓存。如果localCacheScope=STATMENT本地会话将被用于语句的执行，只是没有将数据共享之间的两个不同的调用相同的SqlSession。取值范围(SESSION | STATEMENT),默认值为SESSION。
- dbcTypeForNull 指定为空值时，没有特定的JDBC类型的参数的JDBC类型。有些驱动需要指定列的JDBC类型，但其他像NULL，VARCHAR或OTHER的工作与通用值。JdbcType enumeration. Most common are: NULL, VARCHAR and OTHEROTHER
- lazyLoadTriggerMethods指定触发延迟加载的对象的方法。A method name list separated by commas equals,clone,hashCode,toString
- defaultScriptingLanguage指定所使用的语言默认为动态SQL生成。A type alias or fully qualified class name.org.apache.ibatis.scripting.xmltags.XMLDynamicLanguageDriver
- callSettersOnNulls指定如果setter方法​​或地图的put方法时，将调用检索到的值是null。它是有用的，当你依靠Map.keySet（）或null初始化。注意原语（如整型，布尔等）不会被设置为null。取值范围(true | false)FALSE
- logPrefix指定的前缀字串，MyBatis将会增加记录器的名称。Any StringNot set
- logImpl指定MyBatis的日志实现使用。如果此设置是不存在的记录的实施将自动查找。SLF4J | LOG4J | LOG4J2 | JDK_LOGGING | COMMONS_LOGGING | STDOUT_LOGGING | NO_LOGGINGNot set
- proxyFactory指定代理工具，MyBatis将会使用创建懒加载能力的对象。CGLIB | JAVASSIST

## typeAliases别名(常用)

### mybatis提供的别名

别名

映射的类型

_byte 

byte 

_long 

long 

_short 

short 

_int 

int 

_integer 

int 

_double 

double 

_float 

float 

_boolean 

boolean 

string 

String 

byte 

Byte 

long 

Long 

short 

Short 

int 

Integer 

integer 

Integer 

double 

Double 

float 

Float 

boolean 

Boolean 

date 

Date 

decimal 

BigDecimal 

bigdecimal 

BigDecimal 

### 自定义别名

    <!-- 定义别名 -->
         <typeAliases>
         <!-- 
    	     单个别名定义
    	     alias:别名, type:别名映射类型
    	     <typeAlias type="test.lx.mybatis.po.User" alias="user"/>
          -->
          <!-- 批量别名定义
    		 指定包路径，自动扫描包内的pojo,定义别名，别名默认为类名(首字母小写或大写)      		
           -->
           <package name="test.lx.mybatis.po"/>
         </typeAliases>

### 使用别名
在parameterType、resultType中使用别名：
    <!-- 根据id查询用户信息 -->
     <!-- 
        id: 唯一标识一个statement
        #{}：表示一个占位符，如果#{} 中传入简单类型的参数，#{}中的名称随意
        parameterType: 输入参数的类型，通过#{}接收parameterType输入的参数
        resultType：输出结果类型，不管返回是多条还是单条，指定单条记录映射的pojo类型
      -->
      <select id="findUserById" parameterType="int" resultType="user">
         SELECT * FROM USER WHERE id=#{id};
      </select>

### typeHandlers
类型处理器将Java类型和jdbc类型进行映射。mybatis默认提供很多类型处理器，一般情况下足够使用。
### mappers

    <!-- 加載mapper映射
    	如果和Spring整合后，可以使用整合包中的mapper扫描器，到那时此处的mapper就不用配置了
    	-->
    	<mappers>
    	     <!-- 通过resource映入mapper的映射文件 -->
    		<mapper resource="sqlmap/User.xml" />
    		<!-- <mapper resource="test/lx/mybatis/mapper/UserMapper.xml"/> -->
    		<!-- 通过class引用mapper接口
    			 class：配置mapper接口的全限定名
    			 要求：需要mapper.xml和mapper.java同名并且在同一目录中
    		 -->
    		<!-- <mapper class="test.lx.mybatis.mapper.UserMapper"/> -->
    		<!-- 批量mapper配置
    			 通过package进行自动扫描包下边的mapper接口
    			 要求：需要mapper.xml和mapper.java同名并在同一目录中
    		 -->
    		<package name="test.lx.mybatis.mapper"/>
    	</mappers>

# 输入和输出映射
通过parameterType完成输入映射，通过resultType和resultMap完成输出映射。
## parameterType传递pojo包装对象
可以自定义pojo包装类型扩展mapper接口输入参数的内容。需求：自定义查询条件查询用户信息，需要向statement输入查询条件，查询条件可以有user信息，商品信息……
### 定义包装类型

    public class UserQueryVo {
    	//用户信息
    	private User user;
    	//自定义User的扩展对象
    	private UserCustom userCustom;
    	//提供对应的getter和setter方法
            ......
    }

### mapper.xml

    <!-- 自定义查询条件查询用户信息 
      parameterType: 指定包装类型
      %${userCustom.username}%: userCustom是userQueryVo中的属性，通过OGNL获取属性的值
      -->
      <select id="findUserList" parameterType="userQueryVo" resultType="user">
         select * from user where username like '%${userCustom.username}%'
      </select>

### mapper.java

    //自定义查询条件查询用户信息
    	public List<User> findUserList(UserQueryVo userQueryVo) throws Exception;

### 测试

    //通过包装类型查询用户信息
    	@Test
    	public void testFindUserList() throws Exception {
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		// 创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		// 构造查询条件
    		UserQueryVo userQueryVo = new UserQueryVo();
    		UserCustom userCustom = new UserCustom();
    		userCustom.setUsername("小明");
    		userQueryVo.setUserCustom(userCustom);
    		List<User> list = userMapper.findUserList(userQueryVo);
    		System.out.println(list);
    	}

### 异常
如果parameterType中指定属性错误，会抛出异常，找不到getter方法：org.apache.ibatis.exceptions.PersistenceException: 
### Error querying database. Cause: org.apache.ibatis.reflection.ReflectionException: There is no getter for property named ‘userCusto’ in class …注意：如果将来和Spring整合后，不是通过getter方法来获取获取属性值，而是通过反射强读pojo的属性值。
## resultType
指定输出结果的类型(pojo、简单类型、hashmap…),将SQL查询结果映射为Java对象。
### 返回简单类型
mapper.xml
    <!-- 输出简单类型
      功能：自定义查询条件，返回查询记录个数，通常用于实现查询分页
       -->
       <select id="findUserCount" parameterType="userQueryVo" resultType="int">
       	select count(*) from user where username like '%${userCustom.username}%'
       </select>

mapper.java 
  
  
  
    //查询用户返回记录个数
    	public int findUserCount(UserQueryVo userQueryVo) throws Exception;

测试代码 
  
  
  
    //返回查询记录总数
    	@Test
    	public void testFindUserCount() throws Exception{
    		SqlSession sqlSession  =sqlSessionFactory.openSession();
    		//创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		//构建查询条件
    		UserQueryVo userQueryVo = new UserQueryVo();
    		UserCustom userCustom = new UserCustom();
    		userCustom.setUsername("小明");
    		userQueryVo.setUserCustom(userCustom);
    		int count = userMapper.findUserCount(userQueryVo);
    		System.out.println(count);
    	}

注意：如果查询记录结果集为一条记录且一列 才适合返回简单类型。 
  
  
  
## resultMap(入门)
resultType：指定输出结果的类型(pojo、简单类型、hashmap),将SQL查询结果映射为Java对象。使用resultType注意：sql查询的列名要和resultType指定pojo的属性相同，指定相同，属性方可映射成功。如果sql查询的列名要和resultType指定pojo的属性全部不相同，list中是无法创建pojo对象的。有几个属性对应相同，则能给对应相同的属性赋值。
resultMap：将SQL查询结果映射为Java对象。如果SQL查询列名和最终要映射的pojo的属性名不一致，使用resultMap将列名和pojo的属性名做一个映射关系(列名和属性名映射配置)。
### resultMap配置

    <!-- 定义resultMap，列名和属性名映射配置
     id: mapper.xml中唯一标识
     type: 最终要映射的pojo类型
      -->
      <resultMap id="userListResultMap" type="user" >
    	  <!-- 列名
    	  id,username_,birthday_
    	  id:要映射结果集的唯一标识，称为主键
    	  column: 结果集的列名
    	  property:type指定pojo中的某个属性
    	  -->
    	  <id column="id_" property="id" />
          <!-- result就是普通列的映射配置 -->
          <result column="username_" property="username"/>
          <result column="birthday_" property="birthday"/>
      </resultMap>

### 使用resultMap

     <!-- 使用resultMap作为结果映射
      resultMap: 如果引用resultMap的位置和resultMap的定义在同一个mapper.xml中，
      直接使用resultMap的id,如果不在同一个mapper.xml中，要在引用resultMap的id前边加namespace
       -->
      <select id="findUserListResultMap" parameterType="userQueryVo" resultMap="userListResultMap">
      	select id id_,username username_,birthday birthday_ from user where username like '%${userCustom.username}%'
      </select>

### mapper.java

    //查询用户，使用resultMap进行映射
    	public List<User> findUserListResultMap(UserQueryVo userQueryVo) throws Exception;

# 动态SQL(重点)

## 需求
将自定义查询条件查询用户列表和查询用户列表总记录数改为动态SQL。
## if和where

     <!-- where标签相当于where关键字，可以自动除去第一个and -->
         <where>
            <!-- 如果userQueryVo中传入查询条件，在进行SQL拼接 -->
            <!-- test中userCustom.username表示从userQueryVo中读取属性值 -->
            <if test="userCustom!=null">
            	<if test="userCustom.username!=null and userCustom.username.trim().length() > 0">
            		and username like '%${userCustom.username.trim()}%'
            	</if>
            	<if test="userCustom.sex!=null and userCustom.sex!=''">
            		and sex = #{userCustom.sex}
            	</if>
            	<!-- 还可以添加更多的查询条件 -->
            </if>
         </where>

## sql片段
通过sql片段可以将通用的SQL语句抽取出来，单独定义，在其它的statement中可以引用SQL片段。即通用的SQL语句，常用的：where条件、查询列
### sql片段的定义

    <!-- 将用户查询条件定义为SQL片段
    	 建议对单表的查询条件单独抽取成SQL片段，提高公用性
    	 注意：不要讲where标签放在SQL片段,因为where条件中可能有多个SQL片段进行结合
    	  -->
    	  <sql id="query_user_where">
    	   		<!-- 如果userQueryVo中传入查询条件，在进行SQL拼接 -->
    	        <!-- test中userCustom.username表示从userQueryVo中读取属性值 -->
    	        <if test="userCustom!=null">
    	        	<if test="userCustom.username!=null and userCustom.username.trim().length() > 0">
    	        		and username like '%${userCustom.username.trim()}%'
    	        	</if>
    	        	<if test="userCustom.sex!=null and userCustom.sex!=''">
    	        		and sex = #{userCustom.sex}
    	        	</if>
    	        	<!-- 还可以添加更多的查询条件 -->
    	        </if>
    	  </sql>

### 引用sql片段
在查询用户数据中引用
    <select id="findUserList" parameterType="userQueryVo" resultType="user">
    	     select * from user 
    	     <!-- where标签相当于where关键字，可以自动除去第一个and -->
    	     <where>
    	       <!-- 引用sql片段，如果sql片段和引用处不在同一个mapper 必须在前边加namespace. -->
    	       <include refid="query_user_where"></include>
    	       <!-- 下边还有很多其它的条件 -->
    	       <!-- <include refid="其它的sql片段"></include> -->
    	     </where>
    	  </select>

在查询用户数据总数量中引用 
  
  
  
     <!-- 输出简单类型
    	  功能：自定义查询条件，返回查询记录个数，通常用于实现查询分页
    	   -->
    	   <select id="findUserCount" parameterType="userQueryVo" resultType="int">
    	   	select count(*) from user 
    	   	<!-- where标签相当于where关键字，可以自动除去第一个and -->
    	     <where>
    	       <!-- 引用sql片段，如果sql片段和引用处不在同一个mapper 必须在前边加namespace. -->
    	       <include refid="query_user_where"></include>
    	       <!-- 下边还有很多其它的条件 -->
    	       <!-- <include refid="其它的sql片段"></include> -->
    	     </where>
    	   </select>

## foreach
在statement中通过foreach遍历parameterType中的集合类型需求：假设根据多个用户id查询用户信息
### 在userQueryVo中定义list<Integer> ids;
在UserQueryVo中定义List<Integer> ids存储多个id
    public class UserQueryVo {
    	//用户信息
    	private User user;
    	//自定义User的扩展对象
    	private UserCustom userCustom;
    	//用户id集合
    	private List<Integer> ids;
           //添加对应的setter和getter方法
           ......
    }

### 修改where语句
使用foreach遍历list
    <!-- 根据id集合查询用户信息 -->
    	        	<!-- 最终拼接的效果：
    	        	SELECT id,username,birthday FROM USER WHERE username LIKE '%小明%' AND id IN (16,22,25)
    	        	collection: pojo中的表示集合的属性
    	        	open: 开始循环拼接的串
    	        	close: 结束循环拼接的串
    	        	item: 每次循环从集合中取到的对象
    	        	separator: 没两次循环中间拼接的串
    	        	 -->
    	        	<foreach collection="ids" open=" AND id IN (" close=")" item="id" separator=",">
    	        		#{id}
    	        	</foreach>
    	        	<!-- 
       	        	 SELECT id ,username ,birthday  FROM USER WHERE username LIKE '%小明%' AND (id = 16 OR id = 22 OR id = 25) 
    	        	 <foreach collection="ids" open=" AND id IN (" close=")" item="id" separator=" OR ">
    	        	 	id=#{id}
    	        	 </foreach>
    	        	 -->

### 测试代码

    //id集合
    		List<Integer> ids = new ArrayList<Integer>();
    		ids.add(16);
    		ids.add(22);
    		userQueryVo.setIds(ids);
    		List<User> list = userMapper.findUserList(userQueryVo);

最终Demo代码如下：(GitHub地址：[https://github.com/LX1993728/mybatisDemo_1](https://www.jfox.info/go.php?url=https://github.com/LX1993728/mybatisDemo_1))![](/wp-content/uploads/2017/06/Center8.png)
UserDao
    package test.lx.mybatis.dao;
    import java.util.List;
    import test.lx.mybatis.po.User;
    /**
     * 用户DAO
     * 
     * @author lx
     * 
     */
    public interface UserDao {
    	// 根据id查询用户信息
    	public User findUserById(int id) throws Exception;
    	// 根据用户名称模糊查询用户列表
    	public List<User> findUserByUsername(String username) throws Exception;
    	// 插入用户
    	public void insertUser(User user) throws Exception;
    }

UserDaoImpl 
  
  
  
    package test.lx.mybatis.dao;
    import java.util.List;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import test.lx.mybatis.po.User;
    public class UserDaoImpl implements UserDao {
       private SqlSessionFactory sqlSessionFactory;
       //将SqlSessionFactory注入
       public UserDaoImpl(SqlSessionFactory sqlSessionFactory){
    	   this.sqlSessionFactory = sqlSessionFactory;
       }
    	public User findUserById(int id) throws Exception {
    		//创建SqlSession
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		//根据id查询用户信息
    		User user = sqlSession.selectOne("test.findUserById", id);
    		sqlSession.close();
    		return user;
    	}
    	public List<User> findUserByUsername(String username) throws Exception {
    		//创建SqlSession
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		List<User> list = sqlSession.selectList("test.findUserByName", username);
    		sqlSession.close();
    		return list;
    	}
    	public void insertUser(User user) throws Exception {
    		//创建SqlSession
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		sqlSession.insert("test.insertUser", user);
    		sqlSession.commit();
    		sqlSession.close();
    	}
    }
    

MyBatisFirst 
  
  
  
    package test.lx.mybatis.first;
    import java.io.IOException;
    import java.io.InputStream;
    import java.util.Date;
    import java.util.List;
    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;
    import org.junit.Before;
    import org.junit.Test;
    import test.lx.mybatis.po.User;
    /**
     * mybatis入门程序
     * 
     * @author lx
     * 
     */
    public class MybatisFirst {
    	    // 会话工厂
    		private SqlSessionFactory sqlSessionFactory;
    		// 创建工厂
    		@Before
    		public void init() throws IOException {
    			// 配置文件（SqlMapConfig.xml）
    			String resource = "SqlMapConfig.xml";
    			// 加载配置文件到输入 流
    			InputStream inputStream = Resources.getResourceAsStream(resource);
    			// 创建会话工厂
    			sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    		}
    		// 测试根据id查询用户(得到单条记录)
    		@Test
    		public void testFindUserById() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			// 通过sqlSession操作数据库
    			// 第一个参数：statement的位置，等于namespace+statement的id
    			// 第二个参数：传入的参数
    			User user = null;
    			try {
    				user = sqlSession.selectOne("test.findUserById", 1);
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    			System.out.println(user);
    		}
    		// 测试根据名称模糊查询用户(可能得到多条记录)
    		@Test
    		public void testFindUserByName() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			// 通过sqlSession操作数据库
    			// 第一个参数：statement的位置，等于namespace+statement的id
    			// 第二个参数：传入的参数
    			List<User> list = null;
    			try {
    				//list = sqlSession.selectList("test.findUserByName", "小明");
    				list = sqlSession.selectList("test.findUserByName2", "%小明%");
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    			System.out.println(list.size());
    		}
    		// 测试插入用户
    		@Test
    		public void testInsertUser() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			//通过sqlSession操作数据库
    			//创建插入数据对象
    			User user = new User();
    			user.setUsername("一蓑烟雨");
    			user.setAddress("河南周口");
    			user.setBirthday(new Date());
    			user.setSex("1");
    			try {
    				sqlSession.insert("test.insertUser", user);
    				//需要提交事务
    				sqlSession.commit();
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    			System.out.println(user.getId());
    		}
    		// 测试删除用户
    		@Test
    		public void testDeleteUser() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			//通过sqlSession操作数据库
    			try {
    				sqlSession.delete("test.deleteUser", 28);
    				//需要提交事务
    				sqlSession.commit();
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    		}
    		// 测试根据id更新用户(得到单条记录)
    		@Test
    		public void testUpdateUser() {
    			// 通过sqlSessionFactory创建sqlSession
    			SqlSession sqlSession = sqlSessionFactory.openSession();
    			//通过sqlSession操作数据库
    			//创建更新数据库对象，要求必须包括id
    			User user= new User();
    			user.setId(28);
    			user.setUsername("任平生");
    			//凡是没有设置的属性都被当成了NULL进行赋值
    			//user.setBirthday(new Date());
    			user.setSex("1");
    			try {
    				sqlSession.delete("test.updateUser", user);
    				//需要提交事务
    				sqlSession.commit();
    			} catch (Exception e) {
    				e.printStackTrace();
    			} finally {
    				// 关闭sqlSession
    				sqlSession.close();
    			}
    		}
    }
    

JdbcTest 
  
  
  
    package test.lx.mybatis.jdbc;
    import java.sql.Connection;
    import java.sql.DriverManager;
    import java.sql.PreparedStatement;
    import java.sql.ResultSet;
    import java.sql.SQLException;
    /**
     * jdbc的测试程序
     * 
     * @author lx
     * 
     */
    public class JdbcTest {
    	public static void main(String[] args) {
    		Connection connection = null;
    		//PreparedStatement是预编译的Statement，通过Statement发起数据库的操作
    		//PreparedStatement防止sql注入，执行数据库效率高
    		PreparedStatement preparedStatement = null;
    		ResultSet resultSet = null;
    		try {
    			//加载数据库驱动
    			Class.forName("com.mysql.jdbc.Driver");
    			//通过驱动管理类获取数据库链接
    			connection =  DriverManager.getConnection("jdbc:mysql://localhost:3306/mybatis?characterEncoding=utf-8", "root", "root");
    			//定义sql语句 ?表示占位符
    		String sql = "select * from user where username = ?" ;
    			//获取预处理statement
    			preparedStatement = connection.prepareStatement(sql);
    			//设置参数，第一个参数为sql语句中参数的序号（从1开始），第二个参数为设置的参数值
    			preparedStatement.setString(1, "王五");
    			//向数据库发出sql执行查询，查询出结果集
    			resultSet =  preparedStatement.executeQuery();
    			//遍历查询结果集
    			while(resultSet.next()){
    				System.out.println(resultSet.getString("id")+"  "+resultSet.getString("username"));
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}finally{
    			//释放资源
    			if(resultSet!=null){
    				try {
    					resultSet.close();
    				} catch (SQLException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    				}
    			}
    			if(preparedStatement!=null){
    				try {
    					preparedStatement.close();
    				} catch (SQLException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    				}
    			}
    			if(connection!=null){
    				try {
    					connection.close();
    				} catch (SQLException e) {
    					// TODO Auto-generated catch block
    					e.printStackTrace();
    				}
    			}
    		}
    	}
    }
    

UserMapper.java 
  
  
  
    package test.lx.mybatis.mapper;
    import java.util.List;
    import test.lx.mybatis.po.User;
    import test.lx.mybatis.po.UserQueryVo;
    /**
     * 用户mapper
     * 
     * @author lx
     *
     */
    public interface UserMapper {
    	// 根据用户id查询用户信息
    	public User findUserById(int id) throws Exception;
    	// 根据用户姓名查询用户信息
    	public List<User> findUserByName(String username) throws Exception;
    	// 自定义查询条件查询用户信息
    	public List<User> findUserList(UserQueryVo userQueryVo) throws Exception;
    	// 查询用户，使用resultMap进行映射
    	public List<User> findUserListResultMap(UserQueryVo userQueryVo) throws Exception;
    	// 查询用户返回记录个数
    	public int findUserCount(UserQueryVo userQueryVo) throws Exception;
    	// 插入用户
    	public void insertUser(User user) throws Exception;
    	// 删除用户
    	public void deleteUser(int id) throws Exception;
    	// 修改用户
    	public void updateUser(User user) throws Exception;
    }
    

UserMapper.xml 
  
  
  
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <!-- namespace命名空间，为了对SQL语句进行隔离，方便管理，mapper可开发dao方式，使用namespace有特殊作用 
    mapper代理开发时将namespace指定为mapper接口的全限定名 -->
    <mapper namespace="test.lx.mybatis.mapper.UserMapper">
    <!-- 在mapper.xml文件中配置很多的SQL语句，执行每个SQL语句时，封装为MappedStatement对象
    mapper.xml以statement为单位管理SQL语句
     -->
    	 <!-- 将用户查询条件定义为SQL片段
    	 建议对单表的查询条件单独抽取成SQL片段，提高公用性
    	 注意：不要讲where标签放在SQL片段,因为where条件中可能有多个SQL片段进行结合
    	  -->
    	  <sql id="query_user_where">
    	   		<!-- 如果userQueryVo中传入查询条件，在进行SQL拼接 -->
    	        <!-- test中userCustom.username表示从userQueryVo中读取属性值 -->
    	        <if test="userCustom!=null">
    	        	<if test="userCustom.username!=null and userCustom.username.trim().length() > 0">
    	        		and username like '%${userCustom.username.trim()}%'
    	        	</if>
    	        	<if test="userCustom.sex!=null and userCustom.sex!=''">
    	        		and sex = #{userCustom.sex}
    	        	</if>
    	        	<!-- 根据id集合查询用户信息 -->
    	        	<!-- 最终拼接的效果：
    	        	SELECT id,username,birthday FROM USER WHERE username LIKE '%小明%' AND id IN (16,22,25)
    	        	collection: pojo中的表示集合的属性
    	        	open: 开始循环拼接的串
    	        	close: 结束循环拼接的串
    	        	item: 每次循环从集合中取到的对象
    	        	separator: 没两次循环中间拼接的串
    	        	 -->
    	        	 <if test="ids != null and ids.size()>0">
    		        	<foreach collection="ids" open=" AND id IN (" close=")" item="id" separator=",">
    		        		#{id}
    		        	</foreach>
    	        	 </if>
    	        	<!-- 
       	        	 SELECT id ,username ,birthday  FROM USER WHERE username LIKE '%小明%' AND (id = 16 OR id = 22 OR id = 25) 
    	        	 <foreach collection="ids" open=" AND id IN (" close=")" item="id" separator=" OR ">
    	        	 	id=#{id}
    	        	 </foreach>
    	        	 -->
    	        	<!-- 还可以添加更多的查询条件 -->
    	        </if>
    	  </sql>
    	 <!-- 定义resultMap，列名和属性名映射配置
    	 id: mapper.xml中唯一标识
    	 type: 最终要映射的pojo类型
    	  -->
    	  <resultMap id="userListResultMap" type="user" >
    		  <!-- 列名
    		  id,username_,birthday_
    		  id:要映射结果集的唯一标识，称为主键
    		  column: 结果集的列名
    		  property:type指定pojo中的某个属性
    		  -->
    		  <id column="id_" property="id" />
    	      <!-- result就是普通列的映射配置 -->
    	      <result column="username_" property="username"/>
    	      <result column="birthday_" property="birthday"/>
    	  </resultMap>
    	 <!-- 根据id查询用户信息 -->
    	 <!-- 
    	    id: 唯一标识一个statement
    	    #{}：表示一个占位符，如果#{} 中传入简单类型的参数，#{}中的名称随意
    	    parameterType: 输入参数的类型，通过#{}接收parameterType输入的参数
    	    resultType：输出结果类型，不管返回是多条还是单条，指定单条记录映射的pojo类型
    	  -->
    	  <select id="findUserById" parameterType="int" resultType="user">
    	     SELECT * FROM USER WHERE id=#{id};
    	  </select>
    	  <!-- 根据用户名称查询用户信息，可能返回多条 
    	  ${}:表示SQL的拼接，通过${}接收参数，将参数的内容不加任何修饰的拼接在SQL中
    	  -->
    	  <select id="findUserByName" parameterType="java.lang.String" resultType="test.lx.mybatis.po.User">
    	       select * from user where username like '%${value}%' 
    	  </select>
    	  <!-- <select id="findUserByName" parameterType="java.lang.String" resultType="test.lx.mybatis.po.User">
    	       select * from user where username like #{username} 
    	  </select> -->
    	  <!-- 自定义查询条件查询用户信息 
    	  parameterType: 指定包装类型
    	  %${userCustom.username}%: userCustom是userQueryVo中的属性，通过OGNL获取属性的值
    	  -->
    	  <select id="findUserList" parameterType="userQueryVo" resultType="user">
    	     select * from user 
    	     <!-- where标签相当于where关键字，可以自动除去第一个and -->
    	     <where>
    	       <!-- 引用sql片段，如果sql片段和引用处不在同一个mapper 必须在前边加namespace. -->
    	       <include refid="query_user_where"></include>
    	       <!-- 下边还有很多其它的条件 -->
    	       <!-- <include refid="其它的sql片段"></include> -->
    	     </where>
    	  </select>
    	  <!-- 使用resultMap作为结果映射
    	  resultMap: 如果引用resultMap的位置和resultMap的定义在同一个mapper.xml中，
    	  直接使用resultMap的id,如果不在同一个mapper.xml中，要在引用resultMap的id前边加namespace
    	   -->
    	  <select id="findUserListResultMap" parameterType="userQueryVo" resultMap="userListResultMap">
    	  	select id id_,username username_,birthday birthday_ from user where username like '%${userCustom.username}%'
    	  </select>
    	  <!-- 输出简单类型
    	  功能：自定义查询条件，返回查询记录个数，通常用于实现查询分页
    	   -->
    	   <select id="findUserCount" parameterType="userQueryVo" resultType="int">
    	   	select count(*) from user 
    	   	<!-- where标签相当于where关键字，可以自动除去第一个and -->
    	     <where>
    	       <!-- 引用sql片段，如果sql片段和引用处不在同一个mapper 必须在前边加namespace. -->
    	       <include refid="query_user_where"></include>
    	       <!-- 下边还有很多其它的条件 -->
    	       <!-- <include refid="其它的sql片段"></include> -->
    	     </where>
    	   </select>
    	  <!-- 添加用户 
    	   parameterType:输入参数的类型，User对象包括username,birthday,sex,address
    	   #{}接收pojo数据,可以使用OGNL解析出pojo的属性值
    	   #{username}表示从parameterType中获取pojo的属性值
    	   <selectKey>:用于进行主键返回，定义了主键值的SQL
    	   order：设置selectKey标签中SQL的执行顺序，相对于insert语句而言
    	   keyProperty： 将主键设置到哪个属性上
    	   resultType：select LAST_INSERT_ID()的结果类型
    	  -->
    	  <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
    	     <selectKey keyProperty="id" order="AFTER" resultType="int">
    	        select LAST_INSERT_ID()
    	     </selectKey>
    	 	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
    	  </insert>
    	  <!-- mysql的uuid()函数生成主键 -->
    	 <!--  <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
    	     <selectKey keyProperty="id" order="BEFORE" resultType="string">
    	        select uuid()
    	     </selectKey>
    	 	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
    	  </insert> -->
    	  <!-- oracle
    	         在执行insert之前执行select 序列.nextval() from dual取出序列最大值，将值设置到user对象的id属性中
    	   -->
    	 <!--  <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
    	     <selectKey keyProperty="id" order="BEFORE" resultType="int">
    	        select 序列.nextval() from dual
    	     </selectKey>
    	 	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
    	  </insert> -->
    	  <!-- 用户删除 -->
    	  <delete id="deleteUser" parameterType="int">
    	   delete from user where id=#{id}
    	  </delete>
    	  <!-- 用户更新
    	  	要求：传入的user对象包括id属性值
    	   -->
    	   <update id="updateUser" parameterType="test.lx.mybatis.po.User">
    	   update user set username = #{username},birthday=#{birthday},sex=#{sex},address=#{address} where id=#{id}
    	   </update>
    </mapper>

User.java 
  
  
  
    package test.lx.mybatis.po;
    import java.util.Date;
    /**
     * 用户PO类
     * 
     * @author lx
     * 
     */
    public class User {
    	private int id;
    	private String username; // 用户姓名
    	private String sex; // 性别
    	private Date birthday; // 生日
    	private String address; // 地址
    	public int getId() {
    		return id;
    	}
    	public void setId(int id) {
    		this.id = id;
    	}
    	public String getUsername() {
    		return username;
    	}
    	public void setUsername(String username) {
    		this.username = username;
    	}
    	public String getSex() {
    		return sex;
    	}
    	public void setSex(String sex) {
    		this.sex = sex;
    	}
    	public Date getBirthday() {
    		return birthday;
    	}
    	public void setBirthday(Date birthday) {
    		this.birthday = birthday;
    	}
    	public String getAddress() {
    		return address;
    	}
    	public void setAddress(String address) {
    		this.address = address;
    	}
    	@Override
    	public String toString() {
    		return "User [id=" + id + ", username=" + username + ", sex=" + sex
    				+ ", birthday=" + birthday + ", address=" + address + "]";
    	}
    }
    

UserCustom 
  
  
  
    package test.lx.mybatis.po;
    /**
     * User的扩展类型
     * @author liuxun
     *
     */
    public class UserCustom extends User {
        //添加一些扩展类型
    }
    

UserQueryVo 
  
  
  
    package test.lx.mybatis.po;
    import java.util.List;
    /**
     * 包装类型，将来在使用时从页面传递到controller、service、mapper
     * @author liuxun
     *
     */
    public class UserQueryVo {
    	//用户信息
    	private User user;
    	//自定义User的扩展对象
    	private UserCustom userCustom;
    	//用户id集合
    	private List<Integer> ids;
    	public User getUser() {
    		return user;
    	}
    	public void setUser(User user) {
    		this.user = user;
    	}
    	public UserCustom getUserCustom() {
    		return userCustom;
    	}
    	public void setUserCustom(UserCustom userCustom) {
    		this.userCustom = userCustom;
    	}
    	public List<Integer> getIds() {
    		return ids;
    	}
    	public void setIds(List<Integer> ids) {
    		this.ids = ids;
    	}
    }
    

User.xml 
  
  
  
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE mapper
    PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <!-- namespace命名空间，为了对SQL语句进行隔离，方便管理，mapper可开发dao方式，使用namespace有特殊作用 
    mapper代理开发时将namespace指定为mapper接口的全限定名 -->
    <mapper namespace="test">
    <!-- 在mapper.xml文件中配置很多的SQL语句，执行每个SQL语句时，封装为MappedStatement对象
    mapper.xml以statement为单位管理SQL语句
     -->
     <!-- 根据id查询用户信息 -->
     <!-- 
        id: 唯一标识一个statement
        #{}：表示一个占位符，如果#{} 中传入简单类型的参数，#{}中的名称随意
        parameterType: 输入参数的类型，通过#{}接收parameterType输入的参数
        resultType：输出结果类型，指定单条记录映射的pojo类型
      -->
      <select id="findUserById" parameterType="int" resultType="test.lx.mybatis.po.User">
         SELECT * FROM USER WHERE id=#{id};
      </select>
      <!-- 根据用户名称查询用户信息，可能返回多条 
      ${}:表示SQL的拼接，通过${}接收参数，将参数的内容不加任何修饰的拼接在SQL中
      -->
      <select id="findUserByName" parameterType="java.lang.String" resultType="test.lx.mybatis.po.User">
           select * from user where username like '%${value}%' 
      </select>
      <select id="findUserByName2" parameterType="java.lang.String" resultType="test.lx.mybatis.po.User">
           select * from user where username like #{username} 
      </select>
      <!-- 添加用户 
       parameterType:输入参数的类型，User对象包括username,birthday,sex,address
       #{}接收pojo数据,可以使用OGNL解析出pojo的属性值
       #{username}表示从parameterType中获取pojo的属性值
       <selectKey>:用于进行主键返回，定义了主键值的SQL
       order：设置selectKey标签中SQL的执行顺序，相对于insert语句而言
       keyProperty： 将主键设置到哪个属性上
       resultType：select LAST_INSERT_ID()的结果类型
      -->
      <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
         <selectKey keyProperty="id" order="AFTER" resultType="int">
            select LAST_INSERT_ID()
         </selectKey>
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert>
      <!-- mysql的uuid()函数生成主键 -->
     <!--  <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
         <selectKey keyProperty="id" order="BEFORE" resultType="string">
            select uuid()
         </selectKey>
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert> -->
      <!-- oracle
             在执行insert之前执行select 序列.nextval() from dual取出序列最大值，将值设置到user对象的id属性中
       -->
     <!--  <insert id="insertUser" parameterType="test.lx.mybatis.po.User">
         <selectKey keyProperty="id" order="BEFORE" resultType="int">
            select 序列.nextval() from dual
         </selectKey>
     	 INSERT INTO USER(username,birthday,sex,address) VALUES(#{username},#{birthday},#{sex},#{address})
      </insert> -->
      <!-- 用户删除 -->
      <delete id="deleteUser" parameterType="int">
       delete from user where id=#{id}
      </delete>
      <!-- 用户更新
      	要求：传入的user对象包括id属性值
       -->
       <update id="updateUser" parameterType="test.lx.mybatis.po.User">
       update user set username = #{username},birthday=#{birthday},sex=#{sex},address=#{address} where id=#{id}
       </update>
    </mapper>

db.properties 
  
  
  
    jdbc.driver=com.mysql.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/mybatis
    jdbc.username=root
    jdbc.password=root
    

log4j.properties 
  
  
  
    # Global logging configurationuff0cu5efau8baeu5f00u53d1u73afu5883u4e2du8981u7528debug
    log4j.rootLogger=DEBUG, stdout
    # Console output...
    log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
    

SqlMapConfig.xml 
  
  
  
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE configuration
    PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
        <!-- 属性定义
                 加载一个properties文件
                 在properties标签中配置属性值
         -->
         <properties resource="db.properties">
             <!-- <property name="" value=""/> -->
         </properties>
         <settings>
            <setting name="cacheEnabled" value="true"/>
         </settings>
         <!-- 定义别名 -->
         <typeAliases>
         <!-- 
    	     单个别名定义
    	     alias:别名, type:别名映射类型
    	     <typeAlias type="test.lx.mybatis.po.User" alias="user"/>
          -->
          <!-- 批量别名定义
    		 指定包路径，自动扫描包内的pojo,定义别名，别名默认为类名(首字母小写或大写)      		
           -->
           <package name="test.lx.mybatis.po"/>
         </typeAliases>
    	<!-- 和Spring整合后environments配置将废除 -->
    	<environments default="development">
    		<environment id="development">
    			<!-- 使用jdbc事务管理 -->
    			<transactionManager type="JDBC" />
    			<dataSource type="POOLED">
    				<property name="driver" value="${jdbc.driver}" />
    				<property name="url" value="${jdbc.url}" />
    				<property name="username" value="${jdbc.username}" />
    				<property name="password" value="${jdbc.password}" />
    			</dataSource>
    		</environment>
    	</environments>
    	<!-- 加載mapper映射
    	如果和Spring整合后，可以使用整合包中的mapper扫描器，到那时此处的mapper就不用配置了
    	-->
    	<mappers>
    	     <!-- 通过resource映入mapper的映射文件 -->
    		<mapper resource="sqlmap/User.xml" />
    		<!-- <mapper resource="test/lx/mybatis/mapper/UserMapper.xml"/> -->
    		<!-- 通过class引用mapper接口
    			 class：配置mapper接口的全限定名
    			 要求：需要mapper.xml和mapper.java同名并且在同一目录中
    		 -->
    		<!-- <mapper class="test.lx.mybatis.mapper.UserMapper"/> -->
    		<!-- 批量mapper配置
    			 通过package进行自动扫描包下边的mapper接口
    			 要求：需要mapper.xml和mapper.java同名并在同一目录中
    		 -->
    		<package name="test.lx.mybatis.mapper"/>
    	</mappers>
    </configuration>
    

UserDaoImplTest 
  
  
  
    package test.lx.mybatis.dao;
    import java.io.IOException;
    import java.io.InputStream;
    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;
    import org.junit.Before;
    import org.junit.Test;
    import test.lx.mybatis.po.User;
    public class UserDaoImplTest {
    	// 会话工厂
    	private SqlSessionFactory sqlSessionFactory;
    	//创建工厂
    	@Before
    	public void init() throws IOException{
    		//配置文件(SqlMapConfig.xml)
    		String resource = "SqlMapConfig.xml";
    		//加载配置文件到输入流
    		InputStream inputStream = Resources.getResourceAsStream(resource);
    		//创建会话工厂
    		sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);		
    	}
    	@Test
    	public void testFindUserById() throws Exception{
    		UserDao userDao = new UserDaoImpl(sqlSessionFactory);
    		User user = userDao.findUserById(1);
    		System.out.println(user);
    	}
    }
    

UserMapperTest.java 
  
  
  
    package test.lx.mybatis.mapper;
    import java.io.IOException;
    import java.io.InputStream;
    import java.util.ArrayList;
    import java.util.List;
    import org.apache.ibatis.io.Resources;
    import org.apache.ibatis.session.SqlSession;
    import org.apache.ibatis.session.SqlSessionFactory;
    import org.apache.ibatis.session.SqlSessionFactoryBuilder;
    import org.junit.Before;
    import org.junit.Test;
    import test.lx.mybatis.po.User;
    import test.lx.mybatis.po.UserCustom;
    import test.lx.mybatis.po.UserQueryVo;
    public class UserMapperTest {
    	// 会话工厂
    	private SqlSessionFactory sqlSessionFactory;
    	// 创建工厂
    	@Before
    	public void init() throws IOException {
    		// 配置文件（SqlMapConfig.xml）
    		String resource = "SqlMapConfig.xml";
    		// 加载配置文件到输入流
    		InputStream inputStream = Resources.getResourceAsStream(resource);
    		// 创建会话工厂
    		sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
    	}
    	@Test
    	public void testFindUserById() throws Exception {
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		// 创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		User user = userMapper.findUserById(1);
    		System.out.println(user);
    		sqlSession.close();
    	}
    	@Test
    	public void testFindUserByUsername() throws Exception {
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		// 创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		List<User> list = userMapper.findUserByName("小明");
    		sqlSession.close();
    		System.out.println(list);
    	}
    	@Test
    	public void testInsertUser() throws Exception{
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		// 创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		//插入对象
    		User user = new User();
    		user.setUsername("一蓑烟雨任平生");
    		userMapper.insertUser(user);
    		sqlSession.commit();
    		sqlSession.close();
    		System.out.println(user);
    	}
    	//通过包装类型查询用户信息
    	@Test
    	public void testFindUserList() throws Exception {
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		// 创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		// 构造查询条件
    		UserQueryVo userQueryVo = new UserQueryVo();
    		UserCustom userCustom = new UserCustom();
    		userCustom.setUsername("   小明");
    		userCustom.setSex("1");
    		userQueryVo.setUserCustom(userCustom);
    		//id集合
    		List<Integer> ids = new ArrayList<Integer>();
    		ids.add(16);
    		ids.add(22);
    		userQueryVo.setIds(ids);
    		List<User> list = userMapper.findUserList(userQueryVo);
    		sqlSession.close();
    		System.out.println(list);
    	}
    	//使用resultMap进行结果映射
    	@Test
    	public void testFindUserListResultMap() throws Exception {
    		SqlSession sqlSession = sqlSessionFactory.openSession();
    		// 创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		// 构造查询条件
    		UserQueryVo userQueryVo = new UserQueryVo();
    		UserCustom userCustom = new UserCustom();
    		userCustom.setUsername("小明");
    		userQueryVo.setUserCustom(userCustom);
    		List<User> list = userMapper.findUserListResultMap(userQueryVo);
    		sqlSession.close();
    		System.out.println(list);
    	}
    	//返回查询记录总数
    	@Test
    	public void testFindUserCount() throws Exception{
    		SqlSession sqlSession  =sqlSessionFactory.openSession();
    		//创建代理对象
    		UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
    		//构建查询条件
    		UserQueryVo userQueryVo = new UserQueryVo();
    		UserCustom userCustom = new UserCustom();
    		userCustom.setUsername("小明");
    		userQueryVo.setUserCustom(userCustom);
    		int count = userMapper.findUserCount(userQueryVo);
    		sqlSession.close();
    		System.out.println(count);
    	}
    }
{% endraw %}
