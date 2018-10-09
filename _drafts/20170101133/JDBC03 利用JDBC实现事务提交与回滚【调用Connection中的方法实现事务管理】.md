---
layout: post
title:  "JDBC03 利用JDBC实现事务提交与回滚【调用Connection中的方法实现事务管理】"
title2:  "JDBC03 利用JDBC实现事务提交与回滚【调用Connection中的方法实现事务管理】"
date:   2017-01-01 23:53:53  +0800
source:  "https://www.jfox.info/jdbc03%e5%88%a9%e7%94%a8jdbc%e5%ae%9e%e7%8e%b0%e4%ba%8b%e5%8a%a1%e6%8f%90%e4%ba%a4%e4%b8%8e%e5%9b%9e%e6%bb%9a%e8%b0%83%e7%94%a8connection%e4%b8%ad%e7%9a%84%e6%96%b9%e6%b3%95%e5%ae%9e%e7%8e%b0%e4%ba%8b.html"
fileName:  "20170101133"
lang:  "zh_CN"
published: true
permalink: "2017/jdbc03%e5%88%a9%e7%94%a8jdbc%e5%ae%9e%e7%8e%b0%e4%ba%8b%e5%8a%a1%e6%8f%90%e4%ba%a4%e4%b8%8e%e5%9b%9e%e6%bb%9a%e8%b0%83%e7%94%a8connection%e4%b8%ad%e7%9a%84%e6%96%b9%e6%b3%95%e5%ae%9e%e7%8e%b0%e4%ba%8b.html"
---
{% raw %}
1 Connection中的重用方法

　　2 JDBC事务管理经典案例

## 1 Connection类中常用的方法回顾

### 　　1.1 Statement createStatement() throws SQLException;

　　　　创建一个Statement实例（即：创建一个SQL执行对象）

### 　　1.2 PreparedStatement prepareStatement(String sql) throws SQLException;

　　　　创建一个PreparedStatement对象（即：创建一个预编译SQL执行对象）

### 　　1.3 void setAutoCommit(boolean autoCommit) throws SQLException;

　　　　设置事务的自动提交（false为关闭自动提交，true为启动自动提交）

### 　　1.4 void commit() throws SQLException;

　　　　手动提交事务

### 　　1.5 void rollback() throws SQLException;

　　　　手动回滚事务

## 2 需要用到事务回滚的经典案例：银行转账案例

　　转出和转入是一个事务，如果转出成功但是转入失败的会就需要进行事务回滚，否则就出出现转出者余额减少但是转入者余额没有增加

　　注意：事务的提交与回滚是通过Connection提供的方法来调用的;本质上事务还是依赖数据库的实现；Connection的方法实质上也是调用了数据库事务机制.

　　2.1 不使用事务控制的转账业务

　　　　缺点：如果转入成功，但是转入失败的话，会造成转出者余额减少，但是转入者余额不变

　　　　项目结构图

![](/wp-content/uploads/2017/07/1499444128.png)
![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
     1package cn.xiangxu.entity;
     2 3import java.sql.Connection;
     4import java.sql.PreparedStatement;
     5import java.util.Scanner;
     6 7import cn.xiangxu.tools.DBUtil;
     8 9publicclass Test {
    10publicstaticvoid main(String[] args) {
    11         Scanner scanner = new Scanner(System.in);
    12         System.out.println("请输入转出用户名：");
    13         String outName = scanner.nextLine();
    14         System.out.println("请输入需要转出的资金额度：");
    15         Double money = Double.parseDouble(scanner.nextLine());
    16         System.out.println("请输入转入用户名：");
    17         String inName = scanner.nextLine();
    18         System.out.println("转出账户为：" + outName + "转出金额为：" + money + "转入账户为：" + inName);
    192021         Connection conn = null;
    22try {
    23             conn = DBUtil.getConnection(); // 实例化连接对象
    2425//            conn.setAutoCommit(false); // 关闭自动提交事务功能2627             String sql = "UPDATE client "
    28                     + "SET account = account - ? " 
    29                     + "WHERE name = ? ";
    30             PreparedStatement ps = conn.prepareStatement(sql);
    31             ps.setDouble(1, money);
    32             ps.setString(2, outName);
    33             Integer rs = ps.executeUpdate();
    34if(rs > 0) {
    35                 System.out.println("转出成功");
    36             } else {
    37                 System.out.println("转出失败");
    38return; // 转出失败跳出函数，不再执行下面的语句；但是finally中的语句还是会执行的，因为就算天塌下来finally中的语句都会执行39            }
    4041             System.out.println("======分割线=======");
    4243             String sql_in = "UPDATE client "
    44                     + "SET account = account + ? " 
    45                     + "WHERE name = ? ";
    46             PreparedStatement ps_in = conn.prepareStatement(sql_in);
    47             ps_in.setDouble(1, money);
    48             ps_in.setString(2, inName);
    49             Integer judge_in = ps_in.executeUpdate();
    50if(judge_in > 0) {
    51                 System.out.println("转入成功");
    52//                conn.commit(); // 转出、转入都成功就提交事务53             } else {
    54                 System.out.println("转入失败");
    55//                conn.rollback(); // 转出成功、转入失败就回滚事务56            }
    5758//            conn.setAutoCommit(true); // 打开自动提交事务5960         } catch (Exception e) {
    61// TODO Auto-generated catch block62            e.printStackTrace();
    63         } finally {
    64             System.out.println("我是finally中的语句哟");
    65try {
    66                DBUtil.closeConnection();
    67             } catch (Exception e) {
    68// TODO Auto-generated catch block69                e.printStackTrace();
    70            }
    71        }
    72    }
    73 }

转账业务java源代码![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
    1CREATE TABLE client  (
    2    id INT (10)  PRIMARY KEY,
    3    name VARCHAR (10),
    4    pwd VARCHAR (10),
    5    account INT (20)
    6 );

SQL语句![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
     1package cn.xiangxu.tools;
     2 3import java.io.IOException;
     4import java.io.InputStream;
     5import java.sql.Connection;
     6import java.sql.SQLException;
     7import java.util.Properties;
     8 9import org.apache.commons.dbcp.BasicDataSource;
    1011publicclass DBUtil {
    12/*13     * ThreadLocal用于线程跨方法共享数据使用
    14     * ThreadLocal内部有一个Map,  key为需要共享数据的线程本身,value就是其需要共享的数据
    15*/16privatestatic ThreadLocal<Connection> tl; // 声明一个类似于仓库的东西17privatestatic BasicDataSource dataSource; // 声明一个数据库连接池对象
    1819// 静态代码块，在类加载的时候执行，而且只执行一次20static {
    21         tl = new ThreadLocal<Connection>(); // 实例化仓库对象22         dataSource = new BasicDataSource(); // 实例数据库连接池对象2324         Properties prop = new Properties(); // 创建一个Properties对象用（该对象可以用来加载配置文件中的属性列表）25         InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("config/mysql.properties"); // 读取配置文件信息26try {
    27             prop.load(is); // 加载配置文件中的属性列表2829             String driverClassName = prop.getProperty("driverClassName"); // 获取属性信息30             String url = prop.getProperty("url");
    31             String username = prop.getProperty("username");
    32             String password = prop.getProperty("password");
    33             Integer maxActive = Integer.parseInt(prop.getProperty("maxActive"));
    34             Integer maxWait = Integer.parseInt(prop.getProperty("maxWait"));
    3536             dataSource.setDriverClassName(driverClassName); // 初始化数据库连接池（即：配置数据库连接池的先关参数）37            dataSource.setUrl(url);
    38            dataSource.setUsername(username);
    39            dataSource.setPassword(password);
    40            dataSource.setMaxActive(maxActive);
    41            dataSource.setMaxWait(maxWait);
    4243             is.close(); // 关闭输入流，释放资源44         } catch (IOException e) {
    45// TODO Auto-generated catch block46            e.printStackTrace();
    47        } 
    4849    }
    5051/**52     * 创建连接对象（注意：静态方法可以直接通过类名来调用）
    53     * @return 连接对象
    54     * @throws Exception
    55*/56publicstatic Connection getConnection() throws Exception { 
    57try {
    58             Connection conn = dataSource.getConnection(); // 创建连接对象（利用数据库连接池进行创建）59             tl.set(conn); // 将连接对象放到仓库中60return conn; 
    61         } catch (Exception e) {
    62// TODO Auto-generated catch block63            e.printStackTrace();
    64throw e;
    65        }
    66    }
    6768/**69     * 关闭连接对象（注意：静态方法可以通过类名直接调用）
    70     * @throws Exception
    71*/72publicstaticvoid closeConnection() throws Exception {
    73         Connection conn = tl.get(); // 从仓库中取出连接对象74         tl.remove(); // 清空仓库75if(conn != null) { // 判断连接对象是否释放资源76try {
    77                conn.close();
    78             } catch (Exception e) {
    79// TODO Auto-generated catch block80                e.printStackTrace();
    81throw e;
    82            }
    83        }
    84    }
    8586 }

数据库连接池的java源代码![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
    1# zhe shi zhu shi , yi ban bu yong zhong wen 
    2# deng hao liang bian mei you kong ge, mo wei mei you fen hao
    3# hou mian bu neng you kong ge
    4driverClassName=com.mysql.jdbc.Driver
    5url=jdbc:mysql://localhost:3306/test
    6username=root
    7password=182838
    8maxActive=100
    9 maxWait=3000

数据库信息文件![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
     1<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> 2<modelVersion>4.0.0</modelVersion> 3<groupId>cn.xiangxu</groupId> 4<artifactId>testJDBC</artifactId> 5<version>0.0.1-SNAPSHOT</version> 6<dependencies> 7<dependency> 8<groupId>mysql</groupId> 9<artifactId>mysql-connector-java</artifactId>10<version>5.1.37</version>11</dependency>12<dependency>13<groupId>junit</groupId>14<artifactId>junit</artifactId>15<version>4.12</version>16</dependency>17<dependency>18<groupId>commons-dbcp</groupId>19<artifactId>commons-dbcp</artifactId>20<version>1.4</version>21</dependency>22</dependencies>23</project>

maven依赖文件
### 　　2.2 利用事务控制的转账业务
![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
     1package cn.xiangxu.entity;
     2 3import java.sql.Connection;
     4import java.sql.PreparedStatement;
     5import java.sql.SQLException;
     6import java.util.Scanner;
     7 8import cn.xiangxu.tools.DBUtil;
     910publicclass Test {
    11publicstaticvoid main(String[] args) {
    12         Scanner scanner = new Scanner(System.in);
    13         System.out.println("请输入转出用户名：");
    14         String outName = scanner.nextLine();
    15         System.out.println("请输入需要转出的资金额度：");
    16         Double money = Double.parseDouble(scanner.nextLine());
    17         System.out.println("请输入转入用户名：");
    18         String inName = scanner.nextLine();
    19         System.out.println("转出账户为：" + outName + "转出金额为：" + money + "转入账户为：" + inName);
    202122         Connection conn = null;
    23try {
    24             conn = DBUtil.getConnection(); // 实例化连接对象2526             conn.setAutoCommit(false); // 关闭自动提交事务功能2728             String sql = "UPDATE client "
    29                     + "SET account = account - ? " 
    30                     + "WHERE name = ? ";
    31             PreparedStatement ps = conn.prepareStatement(sql);
    32             ps.setDouble(1, money);
    33             ps.setString(2, outName);
    34             Integer rs = ps.executeUpdate();
    35if(rs > 0) {
    36                 System.out.println("转出成功");
    37             } else {
    38                 System.out.println("转出失败");
    39return; // 转出失败跳出函数，不再执行下面的语句；但是finally中的语句还是会执行的，因为就算天塌下来finally中的语句都会执行40            }
    4142             System.out.println("======分割线=======");
    4344             String sql_in = "UPDATE client "
    45                     + "SET account = account + ? " 
    46                     + "WHERE name = ? ";
    47             PreparedStatement ps_in = conn.prepareStatement(sql_in);
    48             ps_in.setDouble(1, money);
    49             ps_in.setString(2, inName);
    50             Integer judge_in = ps_in.executeUpdate();
    51if(judge_in > 0) {
    52                 System.out.println("转入成功");
    53                 conn.commit(); // 转出、转入都成功就提交事务54             } else {
    55                 System.out.println("转入失败");
    56                 conn.rollback(); // 转出成功、转入失败就回滚事务57            }
    5859             conn.setAutoCommit(true); // 打开自动提交事务6061         } catch (Exception e) {
    62// TODO Auto-generated catch block63try {
    64                 conn.rollback(); // 捕获到异常后也需要进行事务回滚65             } catch (SQLException e1) {
    66// TODO Auto-generated catch block67                e1.printStackTrace();
    68            } 
    69            e.printStackTrace();
    70         } finally {
    71             System.out.println("我是finally中的语句哟");
    72try {
    73                DBUtil.closeConnection();
    74             } catch (Exception e) {
    75// TODO Auto-generated catch block76                e.printStackTrace();
    77            }
    78        }
    79    }
    80 }

转账业务的java源代码
### 　　2.3 将关闭自动提交功能、手动提交功能、手动回滚功能封装到一个类中
![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
      1package cn.xiangxu.tools;
      2  3import java.io.IOException;
      4import java.io.InputStream;
      5import java.sql.Connection;
      6import java.sql.SQLException;
      7import java.util.Properties;
      8  9import org.apache.commons.dbcp.BasicDataSource;
     10 11publicclass DBUtil {
     12/* 13     * ThreadLocal用于线程跨方法共享数据使用
     14     * ThreadLocal内部有一个Map,  key为需要共享数据的线程本身,value就是其需要共享的数据
     15*/ 16privatestatic ThreadLocal<Connection> tl; // 声明一个类似于仓库的东西 17privatestatic BasicDataSource dataSource; // 声明一个数据库连接池对象
     18 19// 静态代码块，在类加载的时候执行，而且只执行一次 20static {
     21         tl = new ThreadLocal<Connection>(); // 实例化仓库对象 22         dataSource = new BasicDataSource(); // 实例数据库连接池对象 23 24         Properties prop = new Properties(); // 创建一个Properties对象用（该对象可以用来加载配置文件中的属性列表） 25         InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("config/mysql.properties"); // 读取配置文件信息 26try {
     27             prop.load(is); // 加载配置文件中的属性列表 28 29             String driverClassName = prop.getProperty("driverClassName"); // 获取属性信息 30             String url = prop.getProperty("url");
     31             String username = prop.getProperty("username");
     32             String password = prop.getProperty("password");
     33             Integer maxActive = Integer.parseInt(prop.getProperty("maxActive"));
     34             Integer maxWait = Integer.parseInt(prop.getProperty("maxWait"));
     35 36             dataSource.setDriverClassName(driverClassName); // 初始化数据库连接池（即：配置数据库连接池的先关参数） 37            dataSource.setUrl(url);
     38            dataSource.setUsername(username);
     39            dataSource.setPassword(password);
     40            dataSource.setMaxActive(maxActive);
     41            dataSource.setMaxWait(maxWait);
     42 43             is.close(); // 关闭输入流，释放资源 44         } catch (IOException e) {
     45// TODO Auto-generated catch block 46            e.printStackTrace();
     47        } 
     48 49    }
     50 51/** 52     * 创建连接对象（注意：静态方法可以直接通过类名来调用）
     53     * @return 连接对象
     54     * @throws Exception
     55*/ 56publicstatic Connection getConnection() throws Exception { 
     57try {
     58             Connection conn = dataSource.getConnection(); // 创建连接对象（利用数据库连接池进行创建） 59             tl.set(conn); // 将连接对象放到仓库中 60return conn; 
     61         } catch (Exception e) {
     62// TODO Auto-generated catch block 63            e.printStackTrace();
     64throw e;
     65        }
     66    }
     67 68/** 69     * 关闭连接对象（注意：静态方法可以通过类名直接调用）
     70     * @throws Exception
     71*/ 72publicstaticvoid closeConnection() throws Exception {
     73         Connection conn = tl.get(); // 从仓库中取出连接对象 74         tl.remove(); // 清空仓库 75if(conn != null) { // 判断连接对象是否释放资源 76try {
     77                conn.close();
     78             } catch (Exception e) {
     79// TODO Auto-generated catch block 80                e.printStackTrace();
     81throw e;
     82            }
     83        }
     84    }
     85 86/** 87     * 在执行SQL语句前关闭JDBC的自动提交事务功能
     88     * @throws SQLException
     89*/ 90publicstaticvoid tansBegin() throws SQLException {
     91try {
     92             tl.get().setAutoCommit(false); // 从仓库中获取连接对象并调用setAutoCommit来关闭自动提交事务功能 93         } catch(SQLException e) {
     94            e.printStackTrace();
     95throw e;
     96        }
     97    }
     98 99/**100     * 手动回滚功能
    101     * @throws SQLException
    102*/103publicstaticvoid transBack() throws SQLException {
    104         tl.get().rollback(); // 从仓库中获取连接对象并调用rollback来实现事务回滚操作105         tl.get().setAutoCommit(true); // 回滚启动事务自动提交功能106    }
    107108/**109     * 手动提交功能
    110     * @throws SQLException
    111*/112publicstaticvoid transCommit() throws SQLException {
    113         tl.get().commit(); // 从仓库中获取连接对象并调用commit来实现事务提交操作114         tl.get().setAutoCommit(true); // 提交后启动事务自动提交功能115    }
    116117 }

DBUtil![](/wp-content/uploads/2017/07/1499444662.gif)![](/wp-content/uploads/2017/07/1499444663.gif)
     1package cn.xiangxu.entity;
     2 3import java.sql.Connection;
     4import java.sql.PreparedStatement;
     5import java.sql.SQLException;
     6import java.util.Scanner;
     7 8import cn.xiangxu.tools.DBUtil;
     910publicclass Test {
    11publicstaticvoid main(String[] args) {
    12         Scanner scanner = new Scanner(System.in);
    13         System.out.println("请输入转出用户名：");
    14         String outName = scanner.nextLine();
    15         System.out.println("请输入需要转出的资金额度：");
    16         Double money = Double.parseDouble(scanner.nextLine());
    17         System.out.println("请输入转入用户名：");
    18         String inName = scanner.nextLine();
    19         System.out.println("转出账户为：" + outName + "转出金额为：" + money + "转入账户为：" + inName);
    202122         Connection conn = null;
    23try {
    24             conn = DBUtil.getConnection(); // 实例化连接对象2526             DBUtil.tansBegin(); // 关闭自动提交事务功能2728             String sql = "UPDATE client "
    29                     + "SET account = account - ? " 
    30                     + "WHERE name = ? ";
    31             PreparedStatement ps = conn.prepareStatement(sql);
    32             ps.setDouble(1, money);
    33             ps.setString(2, outName);
    34             Integer rs = ps.executeUpdate();
    35if(rs > 0) {
    36                 System.out.println("转出成功");
    37             } else {
    38                 System.out.println("转出失败");
    39return; // 转出失败跳出函数，不再执行下面的语句；但是finally中的语句还是会执行的，因为就算天塌下来finally中的语句都会执行40            }
    4142             System.out.println("======分割线=======");
    4344             String sql_in = "UPDATE client "
    45                     + "SET account = account + ? " 
    46                     + "WHERE name = ? ";
    47             PreparedStatement ps_in = conn.prepareStatement(sql_in);
    48             ps_in.setDouble(1, money);
    49             ps_in.setString(2, inName);
    50             Integer judge_in = ps_in.executeUpdate();
    51if(judge_in > 0) {
    52                 System.out.println("转入成功");
    53                 DBUtil.transCommit(); // 转出、转入都成功就提交事务54             } else {
    55                 System.out.println("转入失败");
    56                 DBUtil.transBack(); // 转出成功、转入失败就回滚事务57            }
    5859         } catch (Exception e) {
    60// TODO Auto-generated catch block61try {
    62                 DBUtil.transBack();// 捕获到异常后也需要进行事务回滚63             } catch (SQLException e1) {
    64// TODO Auto-generated catch block65                e1.printStackTrace();
    66            } 
    67            e.printStackTrace();
    68         } finally {
    69             System.out.println("我是finally中的语句哟");
    70try {
    71                DBUtil.closeConnection();
    72             } catch (Exception e) {
    73// TODO Auto-generated catch block74                e.printStackTrace();
    75            }
    76        }
    77    }
    78 }
{% endraw %}
