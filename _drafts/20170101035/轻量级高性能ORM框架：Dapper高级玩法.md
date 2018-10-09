---
layout: post
title:  "轻量级高性能ORM框架：Dapper高级玩法"
title2:  "轻量级高性能ORM框架：Dapper高级玩法"
date:   2017-01-01 23:52:15  +0800
source:  "https://www.jfox.info/%e8%bd%bb%e9%87%8f%e7%ba%a7%e9%ab%98%e6%80%a7%e8%83%bdorm%e6%a1%86%e6%9e%b6-dapper%e9%ab%98%e7%ba%a7%e7%8e%a9%e6%b3%95.html"
fileName:  "20170101035"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e8%bd%bb%e9%87%8f%e7%ba%a7%e9%ab%98%e6%80%a7%e8%83%bdorm%e6%a1%86%e6%9e%b6-dapper%e9%ab%98%e7%ba%a7%e7%8e%a9%e6%b3%95.html"
---
{% raw %}
public class User
        {
            public int UserID { get; set; }
    
            public string UserName { get; set; }
    
            public int RoleID { get; set; }
        }

**3，扩写抽取数据逻辑代码.**

select * from [user]

    static Program()
            {
                var config = new ConfigurationBuilder()
                    .SetBasePath(Directory.GetCurrentDirectory())
                    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
    
                var data = config.Build();
                DapperExtension.DBConnectionString = data.GetConnectionString("DefaultConnection");
            }
    
            static void Main(string[] args)
            {
                IDbConnection dbconnection = null;
    
                using (dbconnection = dbconnection.OpenConnection())
                {
                    var users = dbconnection.List("select * from [user]", null);
                    foreach (var user in users)
                    {
                        Console.WriteLine($"{user.UserID}-{user.UserName}-{user.RoleID}");
                    }
                }
    
                Console.ReadKey();
            }

**4，无MatchNamesWithUnderscores设置时的数据抽取**

[![image](/wp-content/uploads/2017/07/319628-20170701195139352-1286446753.png)](https://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195138774-1551303313.png)

没有绑定成功？？

这是因为用了Select * from的缘故，取出来的字段是带下划线的与Model的字段不匹配。

**5，设置MatchNamesWithUnderscores再次数据抽取**

    static void Main(string[] args)
            {
                Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
                IDbConnection dbconnection = null;
                using (dbconnection = dbconnection.OpenConnection())
                {
                    var users = dbconnection.List("select * from [user]", null);
                    foreach (var user in users)
                    {
                        Console.WriteLine($"{user.UserID}-{user.UserName}-{user.RoleID}");
                    }
                }
    
                Console.ReadKey();
            }

[![image](/wp-content/uploads/2017/07/319628-20170701195140477-1714671408.png)](https://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195139836-684806990.png)

数据绑定成功。

就一句Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true，让我们少写了不少AS语句。

**Dapper高级玩法2：**

法力无边的Query,由于带有Function功能，可以自由设置模型绑定逻辑。

**1，创建两张有关联的表，并填入数据。**

[![image](/wp-content/uploads/2017/07/319628-20170701195141618-1863557863.png)](https://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195141164-35503913.png)

[![image](/wp-content/uploads/2017/07/319628-20170701195142618-1279980874.png)](https://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195142211-1880206721.png)

**2，抽取user和它关联的role数据。**

select 1 as table1,T1.*,1 as table2,T2.* from [user] T1 inner join [role] T2 on T1.role_id = T2.role_id

扩展方法：

    public static IEnumerable QueryT(this IDbConnection dbconnection, string sql, Func map, object param = null, IDbTransaction transaction = null, string splitOn = "Id")
            {
                return dbconnection.Query(sql, map, param, transaction, splitOn: splitOn);
            }

使用：

    static void QueryTest()
            {
                Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
                IDbConnection dbconnection = null;
                using (dbconnection = dbconnection.OpenConnection())
                {
                    var result = dbconnection.QueryT(
                        @"select 1 as table1,T1.*,1 as table2,T2.* from [user] T1 inner join [role] T2 on T1.role_id = T2.role_id",
                        (user, role) =>
                        {
                            user.Role = role;
                            return user;
                        },
                        null,
                        splitOn: "table1,table2");
    
                    foreach (var user in result)
                    {
                        Console.WriteLine($"{user.UserID}-{user.UserName}-{user.Role.RoleID}-{user.Role.RoleName}");
                    }
                }
                Console.ReadKey();
            }

[![image](/wp-content/uploads/2017/07/319628-20170701195143868-1216835364.png)](https://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195143446-1180054740.png)

成功取到数据。

**splitOn解释**：模型绑定时的字段分割标志。table1到table2之间的表字段绑定到User，table2之后的表字段绑定到Role。

**3，特殊Function逻辑。比如抽取role_id对应的user一览。**

select 1 as table1,T1.*,1 as table2,T2.* from [role] T1 left join [user] T2 on T1.role_id = T2.role_id

外部定义了一个字典类型，Query内部模型绑定的时候每次调用Function函数，Function函数中将数据添加到外部字典中，这在复杂数据处理时很有用。

    static void QueryTest2()
            {
                Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true;
                IDbConnection dbconnection = null;
                using (dbconnection = dbconnection.OpenConnection())
                {
                    Dictionary> dic = new Dictionary>();
    
                    dbconnection.QueryT(
                       @"select 1 as table1,T1.*,1 as table2,T2.* from [role] T1 left join [user] T2 on T1.role_id = T2.role_id",
                       (role, user) =>
                       {
                           if (dic.ContainsKey(role.RoleID))
                           {
                               dic[role.RoleID].Add(user);
                           }
                           else
                           {
                               dic.Add(role.RoleID, new List { user });
                           }
    
                           return true;
                       },
                       null,
                       splitOn: "table1,table2");
    
                    foreach (var data in dic)
                    {
                        Console.WriteLine($"role:{data.Key}");
                        foreach (var user in data.Value)
                        {
                            Console.WriteLine($"user:{user.UserID}-{user.UserName}");
                        }
                    }
                }
                Console.ReadKey();
            }
{% endraw %}
