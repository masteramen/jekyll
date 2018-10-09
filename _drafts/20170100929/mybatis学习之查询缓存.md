---
layout: post
title:  "mybatis学习之查询缓存"
title2:  "mybatis学习之查询缓存"
date:   2017-01-01 23:50:29  +0800
source:  "https://www.jfox.info/mybatis%e5%ad%a6%e4%b9%a0%e4%b9%8b%e6%9f%a5%e8%af%a2%e7%bc%93%e5%ad%98.html"
fileName:  "20170100929"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/mybatis%e5%ad%a6%e4%b9%a0%e4%b9%8b%e6%9f%a5%e8%af%a2%e7%bc%93%e5%ad%98.html"
---
{% raw %}
### 什么是查询缓存？

mybatis提供查询缓存，用于减轻数据压力，提高数据库性能

mybatis提供一级缓存和二级缓存

**一级缓存是SQLSession的缓存**

在操作数据库时需要构造SQLSession对象，在对象中有一个数据结构（HashMap）用于存储缓存数据

不同的SQLSession之间的缓存数据区域（HashMap）是互相不影响的

**二级缓存是mapper级别的缓存**

多个SqlSession，操作同一个mapper的SQL语句，多个SqlSession可以共用二级缓存，二级缓存是跨SQLSession的

### 为什么要用缓存?
 
 
   如果缓存中有数据就不用从数据库中获取，大大提高系统的性能。 
   
 
### 一级缓存

#### 1、工作原理
  
 
   第一次发起查询用户Id为1的用户信息，先去找缓存中是否有id为1的用户信息，如果没有就从数据库查询用户信息 得到用户的信息后，将用户信息存到一级缓存中去 
   
 
   如果SQLSession去执行commit操作（执行插入，更新，删除）,清空SQLSession中的一级缓存，这样做的目的为了让缓存中存储的是最新的信息，避免脏读 
   
 
   第二次发起查询用户id为1的用户信息，先去找缓存中是否有id为1的用户信息，缓存中有，直接从缓存中获取用户信息 
   
 
#### 2、一级缓存测试
 
 
   mybatis默认是支持一级缓存的，不需要从配置文件中开启缓存开关。 
   
 
   按照上面的一级缓存的原理步骤去测试。 
  
  
  
        //一级缓存测试
        @Test
        public void testCache1() throws Exception{
            //创建SqlSession
            SqlSession sqlSession = sqlSessionFactory.openSession();
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            //第一次发起请求，查询ID为29的用户
            User user1 = userMapper.findUserById(29);
            System.out.println(user1);
            //如果sqlSession执行commit操作，是否会清空一级缓存
            //更新user1的信息,清空缓存
            user1.setUsername("一级缓存已更新");
            userMapper.updateUser(user1);
            //执行commit才会清空缓存
            sqlSession.commit();
            //第二次发起请求，查询ID为29的用户
            User user2 = userMapper.findUserById(29);
            System.out.println(user2);
            sqlSession.close();
        }

输出结果为： 
  
    DEBUG [main] - Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
    DEBUG [main] - Class not found: org.jboss.vfs.VFS
    DEBUG [main] - JBoss 6 VFS API is not available in this environment.
    DEBUG [main] - Class not found: org.jboss.vfs.VirtualFile
    DEBUG [main] - VFS implementation org.apache.ibatis.io.JBoss6VFS is not valid in this environment.
    DEBUG [main] - Using VFS adapter org.apache.ibatis.io.DefaultVFS
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Reader entry: Items.class
    DEBUG [main] - Reader entry: Order.class
    DEBUG [main] - Reader entry: OrderCustom.class
    DEBUG [main] - Reader entry: OrderDetail.class
    DEBUG [main] - Reader entry: User.class
    DEBUG [main] - Reader entry: UserCustom.class
    DEBUG [main] - Reader entry: UserQueryVo.class
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Reader entry: ����   4 W
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Reader entry: ����   4 f
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Reader entry: ����   4 "
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Reader entry: ����   4 J
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Reader entry: ����   4 [
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Reader entry: ����   4 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Reader entry: ����   4 %
    DEBUG [main] - Checking to see if class pojo.Items matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.Order matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderDetail matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.User matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserQueryVo matches criteria [is assignable to Object]
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Reader entry: OrderMapperCustom.class
    DEBUG [main] - Reader entry: OrderMapperCustom.xml
    DEBUG [main] - Reader entry: UserMapper.class
    DEBUG [main] - Reader entry: UserMapper.xml
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Reader entry: ����   4    
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Reader entry: ����   4    findUserByIdResultMap (I)Lpojo/User; 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Checking to see if class mapper.OrderMapperCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class mapper.UserMapper matches criteria [is assignable to Object]
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Created connection 439904756.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='测试测试1', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - ==>  Preparing: UPDATE user SET username = ? , birthday = ? , sex = ? , address = ? where id = ? 
    DEBUG [main] - ==> Parameters: 一级缓存已更新(String), 2017-06-19 00:00:00.0(Timestamp), 1(String), 湖南益阳(String), 29(Integer)
    DEBUG [main] - <==    Updates: 1
    DEBUG [main] - Committing JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='一级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - Returned connection 439904756 to pool.
    Process finished with exit code 0

 对比 
  
  
  
        //一级缓存测试
        @Test
        public void testCache1() throws Exception{
            //创建SqlSession
            SqlSession sqlSession = sqlSessionFactory.openSession();
            UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
            //第一次发起请求，查询ID为29的用户
            User user1 = userMapper.findUserById(29);
            System.out.println(user1);
            //第二次发起请求，查询ID为29的用户
            User user2 = userMapper.findUserById(29);
            System.out.println(user2);
            sqlSession.close();
        }

 输出结果为： 
  
  
  
    DEBUG [main] - Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
    DEBUG [main] - Class not found: org.jboss.vfs.VFS
    DEBUG [main] - JBoss 6 VFS API is not available in this environment.
    DEBUG [main] - Class not found: org.jboss.vfs.VirtualFile
    DEBUG [main] - VFS implementation org.apache.ibatis.io.JBoss6VFS is not valid in this environment.
    DEBUG [main] - Using VFS adapter org.apache.ibatis.io.DefaultVFS
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Reader entry: Items.class
    DEBUG [main] - Reader entry: Order.class
    DEBUG [main] - Reader entry: OrderCustom.class
    DEBUG [main] - Reader entry: OrderDetail.class
    DEBUG [main] - Reader entry: User.class
    DEBUG [main] - Reader entry: UserCustom.class
    DEBUG [main] - Reader entry: UserQueryVo.class
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Reader entry: ����   4 W
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Reader entry: ����   4 f
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Reader entry: ����   4 "
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Reader entry: ����   4 J
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Reader entry: ����   4 [
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Reader entry: ����   4 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Reader entry: ����   4 %
    DEBUG [main] - Checking to see if class pojo.Items matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.Order matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderDetail matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.User matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserQueryVo matches criteria [is assignable to Object]
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Reader entry: OrderMapperCustom.class
    DEBUG [main] - Reader entry: OrderMapperCustom.xml
    DEBUG [main] - Reader entry: UserMapper.class
    DEBUG [main] - Reader entry: UserMapper.xml
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Reader entry: ����   4    
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Reader entry: ����   4    findUserByIdResultMap (I)Lpojo/User; 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Checking to see if class mapper.OrderMapperCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class mapper.UserMapper matches criteria [is assignable to Object]
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Created connection 439904756.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='一级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    User{id=29, username='一级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@1a3869f4]
    DEBUG [main] - Returned connection 439904756 to pool.
    Process finished with exit code 0

 
  
 
   可见后一种方法，第二次查询并没有执行sql语句，而第一种方法在执行了commit操作后，清空了一级缓存，所以就再次查询了一遍 
   
 
#### 3、一级缓存的应用
 
 
   正式开发，是将mybatis和spring进行整合开发，事物控制在service中，一个services方法中包括很多mapper方法的调用 
   
 
   service{ 
  
 
   //在开始执行时，开启事物，创建sqlsession对象 
  
 
   //第一次调用mapper的方法findUserById（1） 
   
 
   //第二次调用mapper的方法findUserById（1）,从一级缓存中获取数据 
  
 
   //方法结束，sqlsession关闭 
  
 
   } 
  
  
  **如果是执行两次service的调用，查询相同的用户信息，不走一级缓存，因为service方法结束，spring AOP控制sqlsession关闭，一级缓存就清空了**
### 二级缓存

#### 1、原理
  
 
   首先需要开启mybatis的二级缓存 
   
 
   SQLSession1去查询用户ID为1的用户信息，查询到用户信息会将查询数据存储到二级缓存区域中 
   
 
   如果sqlsession3去执行相同mapper下的sql，执行commt提交 ，会清空该mapper下的二级缓存区域的数据 
   
 
   SQLSession2去查询用户ID为1的用户信息，去缓存中找是否存在数据，如果存在就直接从缓存中取出数据 
   
 
   二级缓存与一级缓存的区别在于，二级缓存的范围更大，多个SqlSession可以共享一个UserMapper的二级缓存区域 
   
 
UserMapper有一个二级缓存区域（按照namespace分），其他的Mapper也有自己的二级缓存区域（按照namespace分）。

每一个namespace的mapper，都有一个二级缓存区域。两个mapper的namespace如果相同，那么这两个mapper执行sql查询到的数据会存储在相同的二级缓存区域中。

#### 2、开启二级缓存
 
 
   mybatis的二级缓存是mapper范围级别，除了在SqlMapConfig.xml中设置二级缓存的总开关，还要在具体的mapper.xml中开启二级缓存。 
   
 
在核心配置文件SqlMapConfig.xml中加入

<settingname=“cacheEnabled”value=“true“/>

描述

允许值

默认值

cacheEnabled

对在此配置文件下的所有cache 进行全局性开/关设置。

true false

true
   
 
   在UserMapper.xml中开启二级缓存,这个mapper下的sql执行完成后会存储到它的缓存区域（hashmap） 
  
  
  
    <!--开启本mapper的namespace下的二级缓存 -->
    <cache />

#### 3、调用pojo类实现序列化接口

    public class User implements Serializable{
        //属性名和数据库表的字段一一对应
        private Integer id;
        private String username;// 用户姓名
        private String sex;// 性别
        private Date birthday;// 生日
        private String address;// 地址

 为了将缓存数据取出，执行反序列化操作，因为二级缓存数据存储介质多种多样，不一定在内存中。 
   
  
  
#### 4、测试方法
 未执行提交操作，不同SQLSession查询同一个mapper的sql，二级缓存测试： 
  
  
  
        //二级缓存测试
        @Test
        public void testCache2() throws Exception{
            //创建SqlSession1与SqlSession2
            SqlSession sqlSession1 = sqlSessionFactory.openSession();
            SqlSession sqlSession2 = sqlSessionFactory.openSession();
            SqlSession sqlSession3 = sqlSessionFactory.openSession();
            UserMapper userMapper1 = sqlSession1.getMapper(UserMapper.class);
            UserMapper userMapper2 = sqlSession2.getMapper(UserMapper.class);
            UserMapper userMapper3 = sqlSession3.getMapper(UserMapper.class);
            //第一次发起请求，查询ID为29的用户
            User user1 = userMapper1.findUserById(29);
            System.out.println(user1);
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession1.close();
            //第二次发起请求，查询ID为29的用户
            User user2 = userMapper2.findUserById(29);
            System.out.println(user2);
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession2.close();
            //第三次发起请求，执行commit操作
    //        User user3 = userMapper3.findUserById(29);
    //        System.out.println(user3);
    //        //执行关闭操作，将sqlSession的数据写到二级缓存区域
    //        sqlSession3.close();
        }

 
  
 
   测试结果： 
  
  
  
    DEBUG [main] - Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
    DEBUG [main] - Class not found: org.jboss.vfs.VFS
    DEBUG [main] - JBoss 6 VFS API is not available in this environment.
    DEBUG [main] - Class not found: org.jboss.vfs.VirtualFile
    DEBUG [main] - VFS implementation org.apache.ibatis.io.JBoss6VFS is not valid in this environment.
    DEBUG [main] - Using VFS adapter org.apache.ibatis.io.DefaultVFS
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Reader entry: Items.class
    DEBUG [main] - Reader entry: Order.class
    DEBUG [main] - Reader entry: OrderCustom.class
    DEBUG [main] - Reader entry: OrderDetail.class
    DEBUG [main] - Reader entry: User.class
    DEBUG [main] - Reader entry: UserCustom.class
    DEBUG [main] - Reader entry: UserQueryVo.class
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Reader entry: ����   4 W
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Reader entry: ����   4 f
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Reader entry: ����   4 "
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Reader entry: ����   4 J
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Reader entry: ����   4 ]
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Reader entry: ����   4 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Reader entry: ����   4 %
    DEBUG [main] - Checking to see if class pojo.Items matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.Order matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderDetail matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.User matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserQueryVo matches criteria [is assignable to Object]
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Reader entry: OrderMapperCustom.class
    DEBUG [main] - Reader entry: OrderMapperCustom.xml
    DEBUG [main] - Reader entry: UserMapper.class
    DEBUG [main] - Reader entry: UserMapper.xml
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Reader entry: ����   4    
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Reader entry: ����   4    findUserByIdResultMap (I)Lpojo/User; 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Checking to see if class mapper.OrderMapperCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class mapper.UserMapper matches criteria [is assignable to Object]
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.0
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Created connection 1780132728.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='一级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Returned connection 1780132728 to pool.
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.5
    User{id=29, username='一级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    Process finished with exit code 0

 可以看到这里第一次执行查询了数据库，第二次执行时，没有查询，Cache Hit Ratio 命中率由0 变为了0.5，含义为，查询了两次，命中一次，为百分之50 
   
 
   执行提交操作： 
  
  
  
        //二级缓存测试
        @Test
        public void testCache2() throws Exception{
            //创建SqlSession1与SqlSession2
            SqlSession sqlSession1 = sqlSessionFactory.openSession();
            SqlSession sqlSession2 = sqlSessionFactory.openSession();
            SqlSession sqlSession3 = sqlSessionFactory.openSession();
            UserMapper userMapper1 = sqlSession1.getMapper(UserMapper.class);
            UserMapper userMapper2 = sqlSession2.getMapper(UserMapper.class);
            UserMapper userMapper3 = sqlSession3.getMapper(UserMapper.class);
            //第一次发起请求，查询ID为29的用户
            User user1 = userMapper1.findUserById(29);
            System.out.println(user1);
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession1.close();
            //第三次发起请求，执行commit操作
            User user3 = userMapper3.findUserById(29);
            user3.setUsername("二级缓存已更新");
            userMapper3.updateUser(user3);
            //执行提交操作，清空UserMapper下的二级缓存
            sqlSession3.commit();
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession3.close();
            //第二次发起请求，查询ID为29的用户
            User user2 = userMapper2.findUserById(29);
            System.out.println(user2);
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession2.close();
        }

 结果： 
  
  
  
    DEBUG [main] - Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
    DEBUG [main] - Class not found: org.jboss.vfs.VFS
    DEBUG [main] - JBoss 6 VFS API is not available in this environment.
    DEBUG [main] - Class not found: org.jboss.vfs.VirtualFile
    DEBUG [main] - VFS implementation org.apache.ibatis.io.JBoss6VFS is not valid in this environment.
    DEBUG [main] - Using VFS adapter org.apache.ibatis.io.DefaultVFS
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Reader entry: Items.class
    DEBUG [main] - Reader entry: Order.class
    DEBUG [main] - Reader entry: OrderCustom.class
    DEBUG [main] - Reader entry: OrderDetail.class
    DEBUG [main] - Reader entry: User.class
    DEBUG [main] - Reader entry: UserCustom.class
    DEBUG [main] - Reader entry: UserQueryVo.class
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Reader entry: ����   4 W
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Reader entry: ����   4 f
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Reader entry: ����   4 "
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Reader entry: ����   4 J
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Reader entry: ����   4 ]
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Reader entry: ����   4 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Reader entry: ����   4 %
    DEBUG [main] - Checking to see if class pojo.Items matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.Order matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderDetail matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.User matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserQueryVo matches criteria [is assignable to Object]
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Reader entry: OrderMapperCustom.class
    DEBUG [main] - Reader entry: OrderMapperCustom.xml
    DEBUG [main] - Reader entry: UserMapper.class
    DEBUG [main] - Reader entry: UserMapper.xml
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Reader entry: ����   4    
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Reader entry: ����   4    findUserByIdResultMap (I)Lpojo/User; 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Checking to see if class mapper.OrderMapperCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class mapper.UserMapper matches criteria [is assignable to Object]
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.0
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Created connection 1780132728.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='一级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Returned connection 1780132728 to pool.
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.5
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Checked out connection 1780132728 from pool.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - ==>  Preparing: UPDATE user SET username = ? , birthday = ? , sex = ? , address = ? where id = ? 
    DEBUG [main] - ==> Parameters: 二级缓存已更新(String), 2017-06-19 00:00:00.0(Timestamp), 1(String), 湖南益阳(String), 29(Integer)
    DEBUG [main] - <==    Updates: 1
    DEBUG [main] - Committing JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Returned connection 1780132728 to pool.
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.3333333333333333
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Checked out connection 1780132728 from pool.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='二级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@6a1aab78]
    DEBUG [main] - Returned connection 1780132728 to pool.
    Process finished with exit code 0

 可以看到此处，在我们执行了SQLSession3的commit操作后，该mapper的二级缓存就被清空了，当SQLSession2再次执行查询操作时，请求了数据库。 
  

#### 5、userCache配置

在statement中设置useCache=false可以禁用当前select语句的二级缓存，即每次查询都会发出sql去查询，**默认情况是true，即该sql使用二级缓存。**

    <select id="findOrderListResultMap" resultMap="ordersUserMap" useCache="false"> 

总结：针对每次查询都需要最新的数据sql，要设置成useCache=false，禁用二级缓存。

#### 6、刷新缓存（就是清空缓存）

在mapper的同一个namespace中，如果有其它insert、update、delete操作数据后需要刷新缓存，如果不执行刷新缓存会出现脏读。

 设置statement配置中的flushCache=”true” 属性，**默认情况下为true即刷新缓存**，如果改成false则不会刷新。使用缓存时如果手动修改数据库表中的查询数据会出现脏读。

如下：

    <insert id="insertUser" parameterType="cn.itcast.mybatis.po.User" flushCache="true">

总结：一般下执行完commit操作都需要刷新缓存，flushCache=true表示刷新缓存，这样可以避免数据库脏读。不需要更改该设置

### mybatis整合ehcache
  
   
     EhCache是一个纯Java的进程内缓存框架， 是一种广泛使用的开源Java分布式缓存，具有快速、精干等特点，是Hibernate中默认的CacheProvider 
    
   
     EhCache是一个分布式的缓存框架。 
    
   
#### 1、分布式缓存
 
   
  
 
   我们的系统为了提高系统并发、性能们一般对系统进行分布式部署（集群部署方式） 
     
 
   不使用分布式缓存，缓存的数据在各个服务器中单独存储。不方便系统开发。所以要使用分布式缓存对缓存数据进行集中管理。 
   
 
   mybatis无法实现分布式缓存，需要和其他分布式缓存框架进行整合。 
    
 
#### 2、整合方法（掌握）
 
 
   mybaits提供了一个cache接口，如果要实现自己的缓存逻辑，实现cache接口开发即可。 
   
 
   mybatis要个echcache整合时，mybatis和ehcache整合包中提供了一个cache接口的实现类。 
   
 
   mybatis默认实现的cache类： 
   
 
#### 3、加入ehcache包

#### 4、整合ehcache（掌握）
 
  
  
    编写mapper.xml，配置tyoe为ehcache对cache接口的实现类型 
   
   
   
        <!--
        开启本mapper的namespace下的二级缓存
        type:指定cache接口的实现类的类型，默认使用PerpetualCache，要和EhCache整合，需要配置type为ehcache实现cache接口的类型
         -->
        <cache type="org.mybatis.caches.ehcache.EhcacheCache" />

#### 5、加入EhCache配置文件

classpath下添加：ehcache.xml

内容如下：

    <ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    	xsi:noNamespaceSchemaLocation="../config/ehcache.xsd">
    	<diskStore path="F:developehcache" />
    	<defaultCache 
    		maxElementsInMemory="1000" 
    		maxElementsOnDisk="10000000"
    		eternal="false" 
    		overflowToDisk="false" 
    		timeToIdleSeconds="120"
    		timeToLiveSeconds="120" 
    		diskExpiryThreadIntervalSeconds="120"
    		memoryStoreEvictionPolicy="LRU">
    	</defaultCache>
    </ehcache>

#### 6、测试代码
 
   
     以上面的二级缓存测试代码为例： 
     
   
       //二级缓存测试
        @Test
        public void testCache2() throws Exception{
            //创建SqlSession1与SqlSession2
            SqlSession sqlSession1 = sqlSessionFactory.openSession();
            SqlSession sqlSession2 = sqlSessionFactory.openSession();
            SqlSession sqlSession3 = sqlSessionFactory.openSession();
            UserMapper userMapper1 = sqlSession1.getMapper(UserMapper.class);
            UserMapper userMapper2 = sqlSession2.getMapper(UserMapper.class);
            UserMapper userMapper3 = sqlSession3.getMapper(UserMapper.class);
            //第一次发起请求，查询ID为29的用户
            User user1 = userMapper1.findUserById(29);
            System.out.println(user1);
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession1.close();
            //第三次发起请求，执行commit操作
            User user3 = userMapper3.findUserById(29);
            user3.setUsername("二级缓存已更新");
            userMapper3.updateUser(user3);
            //执行提交操作，清空UserMapper下的二级缓存
            sqlSession3.commit();
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession3.close();
            //第二次发起请求，查询ID为29的用户
            User user2 = userMapper2.findUserById(29);
            System.out.println(user2);
            //执行关闭操作，将sqlSession的数据写到二级缓存区域
            sqlSession2.close();
        }

#### 7、运行结果

    DEBUG [main] - Logging initialized using 'class org.apache.ibatis.logging.slf4j.Slf4jImpl' adapter.
    DEBUG [main] - Class not found: org.jboss.vfs.VFS
    DEBUG [main] - JBoss 6 VFS API is not available in this environment.
    DEBUG [main] - Class not found: org.jboss.vfs.VirtualFile
    DEBUG [main] - VFS implementation org.apache.ibatis.io.JBoss6VFS is not valid in this environment.
    DEBUG [main] - Using VFS adapter org.apache.ibatis.io.DefaultVFS
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Reader entry: Items.class
    DEBUG [main] - Reader entry: Order.class
    DEBUG [main] - Reader entry: OrderCustom.class
    DEBUG [main] - Reader entry: OrderDetail.class
    DEBUG [main] - Reader entry: User.class
    DEBUG [main] - Reader entry: UserCustom.class
    DEBUG [main] - Reader entry: UserQueryVo.class
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Items.class
    DEBUG [main] - Reader entry: ����   4 W
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/Order.class
    DEBUG [main] - Reader entry: ����   4 f
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderCustom.class
    DEBUG [main] - Reader entry: ����   4 "
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/OrderDetail.class
    DEBUG [main] - Reader entry: ����   4 J
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/User.class
    DEBUG [main] - Reader entry: ����   4 ]
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserCustom.class
    DEBUG [main] - Reader entry: ����   4 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/pojo/UserQueryVo.class
    DEBUG [main] - Reader entry: ����   4 %
    DEBUG [main] - Checking to see if class pojo.Items matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.Order matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.OrderDetail matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.User matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class pojo.UserQueryVo matches criteria [is assignable to Object]
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - PooledDataSource forcefully closed/removed all connections.
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Reader entry: OrderMapperCustom.class
    DEBUG [main] - Reader entry: OrderMapperCustom.xml
    DEBUG [main] - Reader entry: UserMapper.class
    DEBUG [main] - Reader entry: UserMapper.xml
    DEBUG [main] - Listing file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.class
    DEBUG [main] - Reader entry: ����   4    
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/OrderMapperCustom.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.class
    DEBUG [main] - Reader entry: ����   4    findUserByIdResultMap (I)Lpojo/User; 
    DEBUG [main] - Find JAR URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Not a JAR: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/mapper/UserMapper.xml
    DEBUG [main] - Reader entry: <?xml version="1.0" encoding="UTF-8" ?>
    DEBUG [main] - Checking to see if class mapper.OrderMapperCustom matches criteria [is assignable to Object]
    DEBUG [main] - Checking to see if class mapper.UserMapper matches criteria [is assignable to Object]
    DEBUG [main] - Configuring ehcache from ehcache.xml found in the classpath: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/ehcache.xml
    DEBUG [main] - Configuring ehcache from URL: file:/E:/%e5%a4%a7%e5%ad%a6%e9%a1%b9%e7%9b%ae/IDEA%20Project/mybatis/out/production/mybatis/ehcache.xml
    DEBUG [main] - Configuring ehcache from InputStream
    DEBUG [main] - Ignoring ehcache attribute xmlns:xsi
    DEBUG [main] - Ignoring ehcache attribute xsi:noNamespaceSchemaLocation
    DEBUG [main] - Disk Store Path: F:developehcache
    DEBUG [main] - Creating new CacheManager with default config
    DEBUG [main] - propertiesString is null.
    DEBUG [main] - No CacheManagerEventListenerFactory class specified. Skipping...
    DEBUG [main] - No BootstrapCacheLoaderFactory class specified. Skipping...
    DEBUG [main] - CacheWriter factory not configured. Skipping...
    DEBUG [main] - No CacheExceptionHandlerFactory class specified. Skipping...
    DEBUG [main] - Initialized net.sf.ehcache.store.NotifyingMemoryStore for mapper.UserMapper
    DEBUG [main] - Initialised cache: mapper.UserMapper
    DEBUG [main] - CacheDecoratorFactory not configured for defaultCache. Skipping for 'mapper.UserMapper'.
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.0
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Created connection 631659383.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='二级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Returned connection 631659383 to pool.
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.5
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Checked out connection 631659383 from pool.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - ==>  Preparing: UPDATE user SET username = ? , birthday = ? , sex = ? , address = ? where id = ? 
    DEBUG [main] - ==> Parameters: 二级缓存已更新(String), 2017-06-19 00:00:00.0(Timestamp), 1(String), 湖南益阳(String), 29(Integer)
    DEBUG [main] - <==    Updates: 1
    DEBUG [main] - Committing JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Returned connection 631659383 to pool.
    DEBUG [main] - Cache Hit Ratio [mapper.UserMapper]: 0.3333333333333333
    DEBUG [main] - Opening JDBC Connection
    DEBUG [main] - Checked out connection 631659383 from pool.
    DEBUG [main] - Setting autocommit to false on JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - ==>  Preparing: SELECT * FROM USER WHERE id = ? 
    DEBUG [main] - ==> Parameters: 29(Integer)
    DEBUG [main] - <==      Total: 1
    User{id=29, username='二级缓存已更新', sex='1', birthday=Mon Jun 19 00:00:00 CST 2017, address='湖南益阳', orderList=null}
    DEBUG [main] - Resetting autocommit to true on JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Closing JDBC Connection [com.mysql.jdbc.JDBC4Connection@25a65b77]
    DEBUG [main] - Returned connection 631659383 to pool.
    Process finished with exit code 0

### 二级缓存的应用场景

对于访问多的查询请求且用户对查询结果实时性要求不高，此时可采用mybatis二级缓存技术降低数据库访问量，提高访问速度，业务场景比如：耗时较高的统计分析sql、电话账单查询sql等。

实现方法如下：通过设置刷新间隔时间，由mybatis每隔一段时间自动清空缓存，根据数据变化频率设置缓存刷新间隔flushInterval，比如设置为30分钟、60分钟、24小时等，根据需求而定。

### 二级缓存的局限性
 
  
    缓存命中率低，对于细粒度（改哪个只改哪个）级别的缓存实现不好。 
   
   
   
mybatis二级缓存对细粒度的数据级别的缓存实现不好，比如如下需求：对商品信息进行缓存，由于商品信息查询访问量大，但是要求用户每次都能查询最新的商品信息，此

时如果使用mybatis的二级缓存就无法实现当一个商品变化时只刷新该商品的缓存信息而不刷新其它商品的信息，因为mybaits的二级缓存区域以mapper为单位划分，当一个商品信

息变化会将所有商品信息的缓存数据全部清空。解决此类问题需要在业务层根据需求对数据有针对性缓存。
{% endraw %}
