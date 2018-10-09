---
layout: post
title:  "JDBC01 利用JDBC连接数据库【不使用数据库连接池】"
title2:  "JDBC01 利用JDBC连接数据库【不使用数据库连接池】"
date:   2017-01-01 23:53:59  +0800
source:  "https://www.jfox.info/jdbc01%e5%88%a9%e7%94%a8jdbc%e8%bf%9e%e6%8e%a5%e6%95%b0%e6%8d%ae%e5%ba%93%e4%b8%8d%e4%bd%bf%e7%94%a8%e6%95%b0%e6%8d%ae%e5%ba%93%e8%bf%9e%e6%8e%a5%e6%b1%a0.html"
fileName:  "20170101139"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/jdbc01%e5%88%a9%e7%94%a8jdbc%e8%bf%9e%e6%8e%a5%e6%95%b0%e6%8d%ae%e5%ba%93%e4%b8%8d%e4%bd%bf%e7%94%a8%e6%95%b0%e6%8d%ae%e5%ba%93%e8%bf%9e%e6%8e%a5%e6%b1%a0.html"
---
{% raw %}
目录：

　　1 什么是JDBC

　　2 JDBC主要接口

　　3 JDBC编程步骤【学渣版本】

　　5 JDBC编程步骤【学神版本】

　　6 JDBC编程步骤【学霸版本】

## 1 什么是JDBC

　　JDBC是JAVA提供的一套标准连接数据库的接口，规定了连接数据库的步骤和功能；不同的数据库提供商提供了一套JDBC实现类，他们称为数据库驱动。

## 2 JDBC的主要接口

　　　Connection　　与数据库连接有关

　　　DriverManager   与创建数据库连接对象有关

　　　Statement  与执行SQL语句有关

　　　ResultSet  与返回的结果及有关

　　　注意：通过JDBC操作数据库是自动提交的，当然也可是设置成手动提交

## 3 利用JDBC操作数据库的步骤【学渣版本】

### 　　3.1 导入数据库驱动

　Class.forName(“数据库驱动包”);

　　　　注意：Class.forName的底层实际上是利用的java反射机制

    　　　　例如：Class.forName("com.mysql.jdbc.Driver"); //mysql驱动包的固定写法

### 　　3.2 创建连接

Connection conn = DriverManager.getConnection(“jdbc:mysql:// + IP + : + 端口 +  / + 数据库名称”，“数据库用户名”，“密码”);

　　　　注意：DriverManager是一个驱动管理类，通过调用该类的静态方法DriverManager来创建连接对象

    　　　　例如：　　Connection conn = DriverManager.getConnection(
     　　　　　　　　　　"jdbc:mysql://localhost:3306/test", // jdbc:mysql:// + IP + : + 端口 + / + 数据库名称  
               　　　　"root", // 用户名
    　　　　　　 　　　　"182838"); // 用户密码

### 　　3.3 创建语句对象

Statement state = conn.createStatement();

　　　　注意：利用连接对象来创建语句对象

### 　　3.4 执行SQL语句

ResultSet executeQuery(String sql)

　　　　　　用来执行查询语句(DQL)的方法,返回的是一个查询结果集

Integer executUpdate(String sql)

　　　　　　用来执行DML语句的方法,返回值为执行了该DML后影响了数据库中多少条数据

boolean execute(String sql)  　　

　　　　　　　　可以执行所有类型的SQL语句,但是DQL,DML都有专门的方法,所以该方法通常
用来执行DDL语句.当返回值为true时表示该SQL语句执行后有结果集,没有结果集
的都是返回的false.(并不是根据语句的对错来返回true或者false)

　　　　注意：利用语句对象来执行SQL语句，DQL指查询，DML指修改、删除、插入，DDL指新建

 　　　   注意：如果是查询语句会得到一个结果集，结果集类型是ResultSet，可对结果集进行遍历

![](/wp-content/uploads/2017/07/1499355884.png)

### 　　3.5 遍历结果集

![](/wp-content/uploads/2017/07/1499355887.png)

### 　　3.6 关闭语句对象、关闭连接对象

执行对象.close();

　　　　连接对象.close();
![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
     1<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd"> 2<modelVersion>4.0.0</modelVersion> 3<groupId>cn.xiangxu</groupId> 4<artifactId>testJDBC</artifactId> 5<version>0.0.1-SNAPSHOT</version> 6<dependencies> 7<dependency> 8<groupId>mysql</groupId> 9<artifactId>mysql-connector-java</artifactId>10<version>5.1.37</version>11</dependency>12<dependency>13<groupId>junit</groupId>14<artifactId>junit</artifactId>15<version>4.12</version>16</dependency>17</dependencies>18</project>

maven依赖包![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
     1CREATE TABLE user (
     2    id INT (10)  PRIMARY KEY,
     3    name VARCHAR (10),
     4    pwd VARCHAR (10)
     5);
     6 7DESC USER;
     8 9DROP TABLE user;
    1011 SELECT * FROM user;

SQL语句![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
     1package testJDBC;
     2 3import java.sql.Connection;
     4import java.sql.DriverManager;
     5import java.sql.ResultSet;
     6import java.sql.SQLException;
     7import java.sql.Statement;
     8 9import org.junit.Test;
    1011publicclass TestCase {
    12    @Test
    13publicvoid test01() {
    14         Connection conn = null;
    15try {
    16// 01 导入驱动模块17             Class.forName("com.mysql.jdbc.Driver");
    1819// 02 初始化连接对象（以为在之前就创建了，进行初始化就行啦）20             conn = DriverManager.getConnection(
    21                     "jdbc:mysql://localhost:3306/test", "root", "182838");
    2223// 03 创建执行对象24             Statement state = conn.createStatement();
    2526             String sql = "SELECT * FROM user ";
    2728// 04 执行SQL语句29             ResultSet rs = state.executeQuery(sql);  // 查询结果的类型为ResultSet
    3031// 05 遍历查询结果32while(rs.next()) {  // 遍历结果集33                 System.out.println(rs.getString("name"));  
    34            }
    3536// 06 关闭执行对象、连接对象37            state.close();
    38            conn.close();
    3940         } catch (ClassNotFoundException e) {
    41// TODO Auto-generated catch block42            e.printStackTrace();
    43         } catch (SQLException e) {
    44// TODO Auto-generated catch block45            e.printStackTrace();
    46         } finally {
    47if(null != conn) { // 判断连接是否关闭48try {
    49                    conn.close();
    50                 } catch (SQLException e) {
    51// TODO Auto-generated catch block52                    e.printStackTrace();
    53                }
    54            }
    55        }
    5657    }
    58 }

java代码
##  4 存在的问题

## 　　4.1 重复编译问题

　　　　利用 Statement对象执行SQL语句时每执行一条SQL语句在数据库端就会进行一次变异，如果是类似的SQL语句也是这样；严重加大了数据库的负担

　　　　改进：利用预编译的Statement

　　　　　　　　注意：预编译statement向数据库中发送一个sql语句，数据库编译sql语句，并把编译的结果保存在数据库砖的缓存中。下次再发sql时，如果sql相同，则不会再编译，直接使用缓存中的。

### 　　4.2 释放资源问题　　

　　　　程序执行后应该对 结果集、执行对象、连接对象进行释放，而且在finally那里还需要判断是否成功释放（注意：try里面定义的变量在finally是获取不到的）

　　　　改进：在程序的最前面定义 连接对象、执行对象、结果集对象；在程序结束后调用各自的close方法来释放资源，在finally中判断这三个对象是否成功关闭

## 5 jdbc编程步骤【学神版本】

加载数据库驱动

　　创建并获取数据库链接

　　创建jdbc statement对象

　　设置sql语句

　　设置sql语句中的参数(使用preparedStatement)

　　通过statement执行sql并获取结果

　　对sql执行结果进行解析处理

　　释放资源(resultSet、preparedstatement、connection)
![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
     1package testJDBC;
     2 3import java.sql.Connection;
     4import java.sql.DriverManager;
     5import java.sql.PreparedStatement;
     6import java.sql.ResultSet;
     7import java.sql.SQLException;
     8 9import org.junit.Test;
    1011publicclass TestCase {
    12    @Test
    13publicvoid test01() {
    14         Connection conn = null;
    15         PreparedStatement ps = null;
    16         ResultSet rs = null;
    17try {
    18             Class.forName("com.mysql.jdbc.Driver"); // 加载数据库驱动1920             conn = DriverManager.getConnection( // 初始化连接对象21                     "jdbc:mysql://localhost:3306/test", "root", "182838");
    222324             String sql = "SELECT * FROM user WHERE pwd = ? "; // 拼接SQL语句，位置参数用？代替2526             ps = conn.prepareStatement(sql); // 初始化预编译执行对象2728             ps.setString(1, "182838"); // 设置SQL语句中的位置位置参数（注意：是从1开始数不是从0开始数）2930             rs = ps.executeQuery(); // 执行SQL语句3132while(rs.next()) { // 遍历结果集33                 System.out.println("====================");
    34                 System.out.println(rs.getInt("id"));
    35                 System.out.println(rs.getString("name"));
    36                 System.out.println(rs.getString("pwd"));
    37            }
    3839// 释放资源40            rs.close();
    41            ps.close(); 
    42            conn.close();
    4344         } catch (Exception e) {
    45// TODO Auto-generated catch block46            e.printStackTrace();
    47         } finally {
    48if(rs != null) {
    49try {
    50                    rs.close();
    51                 } catch (SQLException e) {
    52// TODO Auto-generated catch block53                    e.printStackTrace();
    54                }
    55            }
    56if(ps != null) {
    57try {
    58                    ps.close();
    59                 } catch (SQLException e) {
    60// TODO Auto-generated catch block61                    e.printStackTrace();
    62                }
    63            }
    64if(conn != null) {
    65try {
    66                    conn.close();
    67                 } catch (SQLException e) {
    68// TODO Auto-generated catch block69                    e.printStackTrace();
    70                }
    71            }
    72        }
    7374    }
    75 }

优化后的java代码
## 6 可优化的地方【学霸版本】

　　没有将查询到的结果封装换成一个对象
![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
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

user表对应的实体类![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
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
    90 }

对查询结果进行封装了的java代码
## 7 小案例

　　用户登录、转账系统
![](/wp-content/uploads/2017/07/1499355887.gif)![](/wp-content/uploads/2017/07/1499355888.gif)
      1package day01;
      2  3import java.sql.Connection;
      4import java.sql.DriverManager;
      5import java.sql.ResultSet;
      6import java.sql.SQLException;
      7import java.sql.Statement;
      8import java.util.ArrayList;
      9import java.util.List;
     10import java.util.Scanner;
     11 12/** 13 * 用户登录系统
     14 * Description: 
     15*/ 16publicclass Service {
     17privatestaticfinalint USER_REG = 1;
     18privatestaticfinalint USER_LOGIN = USER_REG + 1;
     19privatestaticfinalint USER_UPDATE = USER_LOGIN + 1;
     20privatestaticfinalint USER_DELETE = USER_UPDATE + 1;
     21privatestaticfinalint USER_INFO = USER_DELETE + 1;
     22privatestaticfinalint USER_TRANSFER = USER_INFO + 1;
     23privatestaticfinalint USER_QUIT = USER_TRANSFER + 1;
     24privatestaticfinalint EXIT = USER_QUIT + 1;
     25 26     UserInfo user = null;
     27 28publicstaticvoid main(String[] args) {
     29         Service serv = new Service();
     30        serv.start();
     31    }
     32 33privatevoid start() {
     34        welcome();
     35int code = getCode();
     36        execute(code);
     37    }
     38 39/** 40     * 执行选择
     41     * Description: 
     42*/ 43privatevoid execute(int code) {
     44switch (code) {
     45case USER_REG:
     46            user_reg();
     47break;
     48case USER_LOGIN:
     49            user_login();
     50break;
     51case USER_UPDATE:
     52            user_update();
     53break;
     54case USER_DELETE:
     55            user_delete();
     56break;
     57case USER_INFO:
     58            user_info();
     59break;
     60case USER_TRANSFER:
     61            user_transfer();
     62break;
     63case USER_QUIT:
     64            user_quit();
     65break;
     66case EXIT:
     67            exit();
     68break;
     69default:
     70             System.out.println("输入错误，请重新输入");
     71            start();
     72break;
     73        }
     74    }
     75 76/** 77     * Description: 
     78*/ 79privatevoid exit() {
     80// TODO Auto-generated method stub 81if(null != this.user) {
     82             System.out.println("当前用户还没有退出，所以执行自动退出当前用户");
     83            user_quit();
     84         }else {
     85             System.out.println("你选择了退出系统");
     86             System.out.println("系统退出成功");
     87        }
     88 89    }
     90 91/** 92     * 退出当前用户
     93     * Description: 
     94*/ 95privatevoid user_quit() {
     96// TODO Auto-generated method stub 97if(null != this.user) {
     98             System.out.println("你选择了退出当前用户功能");
     99this.user = null;
    100if(null == this.user) {
    101                 System.out.println("成功退出当前用户");
    102             }else {
    103                 System.out.println("退出当前用户失败");
    104            }
    105         }else {
    106             System.out.println("你还没有登录成功，还不能使用该功能");
    107             System.out.println("请登录！");
    108            user_login();
    109        }
    110        start();
    111    }
    112113/**114     * 转账功能
    115     * Description: 
    116*/117privatevoid user_transfer() {
    118// TODO Auto-generated method stub119if(null != this.user) {
    120             System.out.println("你选择了转账功能！");
    121             Scanner scanner = new Scanner(System.in);
    122             System.out.println("请输入转入账户的用户名：");
    123             String name = scanner.nextLine();
    124             System.out.println("请输入转账金额：");
    125int money = Integer.parseInt(scanner.nextLine());
    126127             Connection conn = null;
    128try {
    129                 Class.forName("com.mysql.jdbc.Driver");
    130                 conn = DriverManager.getConnection(
    131                         "jdbc:mysql://localhost:3306/test",
    132                         "root",
    133                         "182838");
    134                 Statement state = conn.createStatement();
    135136//转出137                 String out_sql = "UPDATE userinfo_fury "
    138                         + "SET account = account - '"+money+"' "
    139                         + "WHERE username = '"+this.user.getUsername()+"' ";
    140int judge01 = state.executeUpdate(out_sql);
    141if(judge01 > 0) {
    142                     System.out.println("转出成功");
    143                 }else {
    144                     System.out.println("转出失败");
    145                }
    146147//转入148                 String in_sql = "UPDATE userinfo_fury "
    149                         + "SET account = account + '"+money+"' "
    150                         + "WHERE username = '"+name+"' ";
    151int judge02 = state.executeUpdate(in_sql);
    152if(judge02 > 0) {
    153                     System.out.println("转入成功");
    154                 }else {
    155                     System.out.println("转入失败");
    156                }
    157             }catch(Exception e) {
    158                e.printStackTrace();
    159             }finally {
    160if(null != conn) {
    161try {
    162                        conn.close();
    163                     }catch(SQLException e1) {
    164                        e1.printStackTrace();
    165                    }
    166                }
    167            }
    168         }else {
    169             System.out.println("请先登录！");
    170            user_login();
    171        }
    172        start();
    173    }
    174175/**176     * 查询表中的所有数据
    177     * Description: 
    178*/179privatevoid user_info() {
    180// TODO Auto-generated method stub181if(null != this.user) {
    182             System.out.println("你选择了查询所有用户功能！");
    183             Connection conn = null;
    184try {
    185                 Class.forName("com.mysql.jdbc.Driver");
    186                 conn = DriverManager.getConnection(
    187                         "jdbc:mysql://localhost:3306/test",
    188                         "root",
    189                         "182838");
    190                 Statement state = conn.createStatement();
    191                 String sql = "SELECT id,username,password,email,nickname,account "
    192                         + "FROM userinfo_fury ";
    193                 ResultSet rs = state.executeQuery(sql);
    194                 List<UserInfo> list = new ArrayList<UserInfo>();
    195196while(rs.next()) {
    197int id = rs.getInt("id");
    198                     String username = rs.getString("username");
    199                     String password = rs.getString("password");
    200                     String email = rs.getString("email");
    201                     String nickname = rs.getString("nickname");
    202double account = rs.getDouble("account");
    203                     UserInfo userinfo = new UserInfo(id, username, password, email, nickname, account);
    204                    list.add(userinfo);
    205                }
    206for(UserInfo lis : list) {
    207                    System.out.println(lis);
    208                }
    209             }catch(Exception e) {
    210                e.printStackTrace();
    211             }finally {
    212if(null != conn) {
    213try {
    214                        conn.close();
    215                     }catch(SQLException e1) {
    216                        e1.printStackTrace();
    217                    }
    218                }
    219            }
    220         }else {
    221             System.out.println("请先登录");
    222            user_login();
    223        }
    224        start();
    225    }
    226227/**228     * 删除用户
    229     * Description: 
    230*/231privatevoid user_delete() {
    232// TODO Auto-generated method stub233if(null != this.user) {
    234             System.out.println("你选择了删除用户功能");
    235             System.out.println("你不是超级用户，你无法使用删除用户功能");
    236         }else {
    237             System.out.println("请先登录！");
    238            user_login();
    239        }
    240        start();
    241    }
    242243/**244     * 修改用户信息
    245     * Description: 
    246*/247privatevoid user_update() {
    248// TODO Auto-generated method stub249if(null != this.user) {
    250             System.out.println("你选择了修改当前用户功能!");
    251//可改进 -->> 可由用户选择需要修改的字段252             System.out.println("你当前的昵称为：" + this.user.getNickname());
    253             Scanner scanner = new Scanner(System.in);
    254             System.out.println("你想将你的昵称修改为：");
    255             String nickname = scanner.nextLine();
    256257             Connection conn = null;
    258try {
    259                 Class.forName("com.mysql.jdbc.Driver");
    260                 conn = DriverManager.getConnection(
    261                         "jdbc:mysql://localhost:3306/test",
    262                         "root",
    263                         "182838");
    264                 Statement state = conn.createStatement();
    265266                 String sql = "UPDATE userinfo_fury "
    267                         + "SET nickname = '"+nickname+"' "
    268                         + "WHERE username = '"+this.user.getUsername()+"' ";
    269int judge = state.executeUpdate(sql);
    270if(judge > 0) {
    271this.user.setNickname(nickname);
    272                     System.out.println("修改昵称成功,当前昵称为：" + this.user.getNickname());
    273                 }else {
    274                     System.out.println("修改昵称失败");
    275                }
    276             }catch(Exception e) {
    277                e.printStackTrace();
    278             }finally {
    279if(null != conn) {
    280try {
    281                        conn.close();
    282                     }catch(SQLException e1) {
    283                        e1.printStackTrace();
    284                    }
    285                }
    286            }
    287         }else {
    288             System.out.println("请登录成功后在进行此操作！");
    289            user_login();
    290        }
    291        start();
    292    }
    293294/**295     * 用户登录
    296     * Description: 
    297*/298privatevoid user_login() {
    299// TODO Auto-generated method stub300         System.out.println("你选择了用户登录功能！");
    301         Scanner scanner = new Scanner(System.in);
    302         System.out.println("请输入用户名:");
    303         String username = scanner.nextLine();
    304         System.out.println("请输入密码：");
    305         String password = scanner.nextLine();
    306307         Connection conn = null;
    308try {
    309             Class.forName("com.mysql.jdbc.Driver");
    310             conn = DriverManager.getConnection(
    311                     "jdbc:mysql://localhost:3306/test",
    312                     "root",
    313                     "182838");
    314             Statement state = conn.createStatement();
    315316             String sql = "SELECT id, username, password,email, nickname,account "
    317                     + "FROM userinfo_fury "
    318                     + "WHERE username = '"+username+"' "
    319                     + "AND password = '"+password+"' ";
    320            System.out.println(sql);
    321             ResultSet rs = state.executeQuery(sql);
    322if(rs.next()) {
    323int id = rs.getInt("id");
    324                 String name = rs.getString("username");
    325                 String word = rs.getString("password");
    326                 String email = rs.getString("email");
    327                 String nickname = rs.getString("nickname");
    328double account = rs.getDouble("account");
    329                 UserInfo userinfo = new UserInfo(id, name, word, email, nickname, account);
    330this.user = userinfo;
    331                 System.out.println("登录成功,你的昵称为：" + this.user.getNickname());
    332             }else {
    333                 System.out.println("登录失败:" + this.user);
    334            }
    335/*336             * 注意：
    337             *         当用户输入的密码个的格式是：    任意字符' or '数值开头      时无论用户名和密码正确与否，都会登录成功
    338             *         因为  如果这样输入就改变了 SQL 语句的原意（在SQL语句中AND的优先级要高于OR）
    339             *         实例 ： asdfaer1234' or '1
    340*/341         }catch(Exception e) {
    342            e.printStackTrace();
    343         }finally {
    344if(null != conn) {
    345try {
    346                    conn.close();
    347                 }catch(SQLException e1) {
    348                    e1.printStackTrace();
    349                }
    350            }
    351        }
    352        start();
    353    }
    354355/**356     * 用户注册
    357     * Description: 
    358*/359privatevoid user_reg() {
    360         System.out.println("你选择了用户注册功能！");
    361         Scanner scanner = new Scanner(System.in);
    362         System.out.println("请输入用户名：");
    363         String username = scanner.nextLine();
    364         System.out.println("请输入密码：");
    365         String password = scanner.nextLine();
    366         System.out.println("请输入邮箱：");
    367         String email = scanner.nextLine();
    368         System.out.println("请输入昵称：");
    369         String nickname = scanner.nextLine();
    370         Connection conn = null;
    371try {
    372             Class.forName("com.mysql.jdbc.Driver");
    373             conn = DriverManager.getConnection(
    374                     "jdbc:mysql://localhost:3306/test",
    375                     "root",
    376                     "182838");
    377             Statement state = conn.createStatement();
    378             String sql = "INSERT INTO userinfo_fury "
    379                     + "(username,password,email,nickname) "
    380                     + "VALUES "
    381                     + "('"+username+"','"+password+"','"+email+"','"+nickname+"')";
    382int judge = state.executeUpdate(sql);
    383if(judge > 0) {
    384                 System.out.println("注册成功");
    385             }else {
    386                 System.out.println("注册失败");
    387            }
    388         }catch(Exception e) {
    389            e.printStackTrace();
    390         }finally {
    391if(null != conn) {
    392try {
    393                    conn.close();
    394                 }catch(SQLException e1) {
    395                    e1.printStackTrace();
    396                }
    397            }
    398        }
    399        start();
    400    }
    401402/**403     * 功能选择
    404     * Description: 
    405*/406privateint  getCode() {
    407         System.out.println("请选择功能：");
    408         Scanner scanner = new Scanner(System.in);
    409int code = Integer.parseInt(scanner.nextLine());
    410return code;
    411    }
    412413/**414     * 界面信息
    415     * Description: 
    416*/417privatevoid welcome() {
    418         System.out.println("欢迎使用用户登录系统！");
    419         System.out.println("请输入需要操作的功能序号");
    420         System.out.println("======================");
    421         System.out.println("================");
    422         System.out.println("1 : 用户注册");
    423         System.out.println("2 : 用户登录");
    424         System.out.println("3 : 修改用户信息");
    425         System.out.println("4 : 删除用户");
    426         System.out.println("5 : 查看所有用户信息");
    427         System.out.println("6 : 转账业务");
    428         System.out.println("7 : 用户退出");
    429         System.out.println("8 : 退出系统");
    430         System.out.println("================");
    431         System.out.println("======================");
    432    }
    433 }
{% endraw %}
