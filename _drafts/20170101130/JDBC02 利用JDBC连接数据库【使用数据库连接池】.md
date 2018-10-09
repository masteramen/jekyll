---
layout: post
title:  "JDBC02 利用JDBC连接数据库【使用数据库连接池】"
title2:  "JDBC02 利用JDBC连接数据库【使用数据库连接池】"
date:   2017-01-01 23:53:50  +0800
source:  "https://www.jfox.info/jdbc02%e5%88%a9%e7%94%a8jdbc%e8%bf%9e%e6%8e%a5%e6%95%b0%e6%8d%ae%e5%ba%93%e4%bd%bf%e7%94%a8%e6%95%b0%e6%8d%ae%e5%ba%93%e8%bf%9e%e6%8e%a5%e6%b1%a0-2.html"
fileName:  "20170101130"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/jdbc02%e5%88%a9%e7%94%a8jdbc%e8%bf%9e%e6%8e%a5%e6%95%b0%e6%8d%ae%e5%ba%93%e4%bd%bf%e7%94%a8%e6%95%b0%e6%8d%ae%e5%ba%93%e8%bf%9e%e6%8e%a5%e6%b1%a0-2.html"
---
{% raw %}
1/2/3  Statement 和 Preparedstatement 的区别

　　4 读取properties配置文件

　　5 数据库连接池

　　6 利用数据库连接池连接数据库

## 1 使用Statement执行含有动态信息的SQL语句时有几个不足:

### 　　1.1 由于需要将动态数据拼接到SQL语句中,这导致程序复杂度高,容易出错
1.2 拼接的数据若含有SQL语法内容就会导致拼接后的SQL语法含义改变而出现SQL注入攻击
1.3 当大批量执行语义相同,但是含有动态数据的SQL时效率很差

## 2 使用Statement执行SQL语句不好的原因

### 　　2.1 当执行一条SQL语句发送到数据库时,数据库先将该SQL解析并生成一个执行计划(这个过程会消耗资源和性能)，如果多次执行一样的SQL语句,数据库会重用执行计划,但是若多次执行语义相同但是含有动态数据的SQL时,数据库会生成不同的执行计划,严重影响数据库的开销
2.2 例如

　　　　执行 SELECT * FROM userifo_fury 生成一个执行计划再次执行SELECT * FROM userifo_fury 就会重用上面的执行计划(因为这是静态的SQL语句 

　　　　但是，执行INSERT INTO userifo VALUES(1, ‘JACK’,’122314′,’141234@QQ.COM’,’FURY’,15600) ) 生成一个执行计划，再执行执行INSERT INTO userifo VALUES(2, ‘rose’,’122314′,’141234@QQ.COM’,’FURY’,15600)由于内容不同,会再次生成另外一个执行计划，若执行1000次上述情况的INSERT,数据库会产生1000个执行计划，这样就严重影响了数据库的效率
因此，Statement只适合执行静态的SQL语句，不适合执行动态的SQL语句

## 3 利用PreparedStatement代替Statement

### 编写简单

### 没有SQL注入问题

### 　　批量执行语义相同的SQL语句会重用执行计划
![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
     1package cn.xiangxu.entity;
     2 3import java.io.Serializable;
     4 5publicclass User implements Serializable {
     6 7privatestaticfinallong serialVersionUID = -5109978284633713580L;
     8 9private Integer id;
    10private String name;
    11private String pwd;
    12public User() {
    13super();
    14// TODO Auto-generated constructor stub15    }
    16public User(Integer id, String name, String pwd) {
    17super();
    18this.id = id;
    19this.name = name;
    20this.pwd = pwd;
    21    }
    22    @Override
    23publicint hashCode() {
    24finalint prime = 31;
    25int result = 1;
    26         result = prime * result + ((id == null) ? 0 : id.hashCode());
    27return result;
    28    }
    29    @Override
    30publicboolean equals(Object obj) {
    31if (this == obj)
    32returntrue;
    33if (obj == null)
    34returnfalse;
    35if (getClass() != obj.getClass())
    36returnfalse;
    37         User other = (User) obj;
    38if (id == null) {
    39if (other.id != null)
    40returnfalse;
    41         } elseif (!id.equals(other.id))
    42returnfalse;
    43returntrue;
    44    }
    45public Integer getId() {
    46return id;
    47    }
    48publicvoid setId(Integer id) {
    49this.id = id;
    50    }
    51public String getName() {
    52return name;
    53    }
    54publicvoid setName(String name) {
    55this.name = name;
    56    }
    57public String getPwd() {
    58return pwd;
    59    }
    60publicvoid setPwd(String pwd) {
    61this.pwd = pwd;
    62    }
    63    @Override
    64public String toString() {
    65return "User [id=" + id + ", name=" + name + ", pwd=" + pwd + "]";
    66    }
    67686970 }

user表对应的实体类![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
     1package testJDBC;
     2 3import java.sql.Connection;
     4import java.sql.DriverManager;
     5import java.sql.PreparedStatement;
     6import java.sql.ResultSet;
     7import java.sql.SQLException;
     8import java.util.ArrayList;
     9import java.util.List;
    1011import org.junit.Test;
    1213import cn.xiangxu.entity.User;
    1415publicclass TestCase {
    16    @Test
    17publicvoid test01() {
    18         Connection conn = null;
    19         PreparedStatement ps = null;
    20         ResultSet rs = null;
    21try {
    22             Class.forName("com.mysql.jdbc.Driver"); // 加载数据库驱动2324             conn = DriverManager.getConnection( // 初始化连接对象25                     "jdbc:mysql://localhost:3306/test", "root", "182838");
    262728             String sql = "SELECT * FROM user WHERE pwd = ? "; // 拼接SQL语句，位置参数用？代替2930             ps = conn.prepareStatement(sql); // 初始化预编译执行对象3132             ps.setString(1, "182838"); // 设置SQL语句中的位置位置参数（注意：是从1开始数不是从0开始数）3334             rs = ps.executeQuery(); // 执行SQL语句3536             List<User> users = new ArrayList<User>(); // 创建一个集合来存放记录对象37while(rs.next()) { // 遍历结果集
    38//                System.out.println("====================");
    39//                System.out.println(rs.getInt("id"));
    40//                System.out.println(rs.getString("name"));
    41//                System.out.println(rs.getString("pwd"));42                 User user = new User();
    43                 user.setId(rs.getInt("id"));
    44                 user.setName(rs.getString("name"));
    45                 user.setPwd(rs.getString("pwd"));
    46                 users.add(user); // 向集合中添加元素47            }
    4849             System.out.println(users); // 打印输出集合50for(User user : users) {
    51                System.out.println(user);
    52            }
    5354// 释放资源55            rs.close();
    56            ps.close(); 
    57            conn.close();
    5859         } catch (Exception e) {
    60// TODO Auto-generated catch block61            e.printStackTrace();
    62         } finally {
    63if(rs != null) {
    64try {
    65                    rs.close();
    66                 } catch (SQLException e) {
    67// TODO Auto-generated catch block68                    e.printStackTrace();
    69                }
    70            }
    71if(ps != null) {
    72try {
    73                    ps.close();
    74                 } catch (SQLException e) {
    75// TODO Auto-generated catch block76                    e.printStackTrace();
    77                }
    78            }
    79if(conn != null) {
    80try {
    81                    conn.close();
    82                 } catch (SQLException e) {
    83// TODO Auto-generated catch block84                    e.printStackTrace();
    85                }
    86            }
    87        }
    8889    }
    9091 }

使用预编译Statement的实例
## 4 利用Properties对象读取properties配置文件中的信息

### 　　4.1 Properties继承了Hashtable类，Properties对象也是使用键值对的方式来保存数据，但是Properties对象的键和值都是字符串类型

class Properties extends Hashtable<Object,Object>

### 　　4.2 Properties 类中的主要方法

#### 　　　　4.2.1 public synchronized void load(InputStream inStream) throws IOException

　　　　　　将properties属性文件的文件输入流加载到Properties对象

**![](/wp-content/uploads/2017/07/1499444208.png)**

#### 　　　　4.2.2 public void store(OutputStream out, String comments) *throws IOException*

 　　　　　　将Properties对象中的属性列表保存到输出流文件中

![](/wp-content/uploads/2017/07/1499444209.png)

　　　　　　注意：第二个参数表示注释信息（注意：properties文件中不能用中文），在注释信息后面会自动添加一个时间信息

　　　　　　注意：新创建的文件在项目的根目录下面（问题：为什么在eclipse中没有，但是到文件夹中却能找到？？？）

#### 　　　　4.2.3 public String getProperty(String key)

　　　　　　获取属性值，参数是属性的键

####  　　　　4.2.4 public synchronized Object setProperty(String key, String value)

　　　　　　修改属性值，参数1是属性的键，参数2是属性的新值

### 　　4.3 案例

　　　　要求：读取properties配置文件总的属性值，将读取到的属性值进行修改后保存到另外一个properties配置文件中
![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
     1package cn.xiangxu.entity;
     2 3import java.io.FileInputStream;
     4import java.io.FileOutputStream;
     5import java.io.InputStream;
     6import java.util.Iterator;
     7import java.util.Properties;
     8 9publicclass Test {
    10publicstaticvoid main(String[] args) {
    11try {
    12             Properties prop = new Properties(); // 创建Properties对象
    1314//            prop.load(new FileInputStream("config.properties")); // 使用这种方式时，配置文件必须放在项目的根目录下15             InputStream  is = Test.class.getClassLoader().getResourceAsStream("config/config.properties"); // 读取属性文件1617             prop.load(is); // 加载属性列表1819             Iterator<String> it=prop.stringPropertyNames().iterator(); // 将配置文件中的所有key放到一个可迭代对象中20while(it.hasNext()){ // 利用迭代器模式进行迭代21                 String key=it.next(); // 读取下一个迭代对象的下一个元素22                 System.out.println(key+":"+prop.getProperty(key)); // 根据key值获取value值（获取属性信息）23            }
    2425             is.close(); // 关闭输入流，释放资源2627             FileOutputStream oFile = new FileOutputStream("b.properties", true);//创建一个输出流文件，true表示追加打开28             prop.setProperty("maxactive", "33"); // 修改属性信息29             prop.store(oFile, "zhe shi yi ge xin de shu xing pei zhi wen jian."); // 将Properties对象中的内容放到刚刚创建的文件中去30             oFile.close(); // 关闭输出流，释放资源3132         } catch (Exception e) {
    33// TODO Auto-generated catch block34            e.printStackTrace();
    35        } 
    36    }
    37 }

读取属性配置文件信息
　　　　等待读取的properties配置文件的位置如下图所示

![](/wp-content/uploads/2017/07/1499444210.png)

## 5 数据库连接池

### 　　5.1 什么是数据库连接池

　　　　程序启动时就创建足够多的数据库连接，并将这些连接组成一个连接池，由程序自动地对池中的连接进行申请、使用、释放

### 　　5.2 数据库连接池的运行机制

》程序初始化时创建连接池

　　　　》需要操作数据库时向数据库连接池申请一个可用的数据库连接

　　　　》使用完毕后就将数据库连接还给数据库连接池（注意：不是关闭连接，而是交给连接池）

　　　　》整个程序退出时，断开所有连接，释放资源（即：管理数据库连接池的那个线程被杀死后才关闭所有的连接）

 　　　　![](/wp-content/uploads/2017/07/1499444211.png)

### 　　5.3 数据库连接池的编程步骤

#### 　　　　5.3.1 导包

![](/wp-content/uploads/2017/07/14994442111.png)

#### 　　　　5.3.2 声明ThreadLocal、BasicDataSource成员变量（注意：这两个成员变量是静态的）

![](/wp-content/uploads/2017/07/1499444212.png)

#### 　　　　5.3.3 在静态代码块中实例化那两个成员变量，并通过Properties对象读取配置文件信息，利用这些配置文件信息给BasicDataSource对象进行初始化处理

![](/wp-content/uploads/2017/07/1499444213.png)

#### 　　　　5.3.4 编写创建连接静态方法

　　　　　　利用BasicDataSource对象实例化一个连接对象

　　　　　　将这个连接对象放到ThreadLocal对象中

![](/wp-content/uploads/2017/07/14994442131.png)

#### 　　　　5.3.5 编写释放连接静态方法

　　　　　　从ThreadLocal对象中获取连接对象

　　　　　　清空ThreadLocal对象

　　　　　　判断连接对象是否释放

![](/wp-content/uploads/2017/07/1499444214.png)

## 6 利用数据库连接池操作数据库

　　项目结构图

![](/wp-content/uploads/2017/07/14994442141.png)
![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
    1# zhe shi zhu shi , yi ban bu yong zhong wen 
    2# deng hao liang bian mei you kong ge, mo wei mei you fen hao
    3# hou mian bu neng you kong ge
    4driverClassName=com.mysql.jdbc.Driver
    5url=jdbc:mysql://localhost:3306/test
    6username=root
    7password=182838
    8maxActive=100
    9 maxWait=3000

properties配置文件![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
     1<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> 2<modelVersion>4.0.0</modelVersion> 3<groupId>cn.xiangxu</groupId> 4<artifactId>testJDBC</artifactId> 5<version>0.0.1-SNAPSHOT</version> 6<dependencies> 7<dependency> 8<groupId>mysql</groupId> 9<artifactId>mysql-connector-java</artifactId>10<version>5.1.37</version>11</dependency>12<dependency>13<groupId>junit</groupId>14<artifactId>junit</artifactId>15<version>4.12</version>16</dependency>17<dependency>18<groupId>commons-dbcp</groupId>19<artifactId>commons-dbcp</artifactId>20<version>1.4</version>21</dependency>22</dependencies>23</project>

maven依赖文件![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
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

数据库连接池类![](/wp-content/uploads/2017/07/1499444502.gif)![](/wp-content/uploads/2017/07/14994445021.gif)
     1package testJDBC;
     2 3import java.sql.Connection;
     4import java.sql.PreparedStatement;
     5import java.sql.ResultSet;
     6 7import org.junit.Test;
     8 9import cn.xiangxu.tools.DBUtil;
    1011publicclass TestDBUtil {
    12    @Test
    13publicvoid test01() {
    14try {
    15             Connection conn = DBUtil.getConnection(); // 创建连接对象16             String sql = "SELECT * FROM user "; // 拼接SQL语句17             PreparedStatement ps = conn.prepareStatement(sql); // 创建执行对象18             ResultSet rs = ps.executeQuery(sql); // 执行SQL语句19while(rs.next()) { // 遍历结果集20                 System.out.println(rs.getString("name"));
    21            }
    22         } catch (Exception e) {
    23            e.printStackTrace();
    24         } finally {  // 关闭连接，释放资源25try {
    26                DBUtil.closeConnection();
    27             } catch (Exception e) {
    28                e.printStackTrace();
    29            }
    30        }
    31    }
    32 }
{% endraw %}
