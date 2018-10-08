---
layout: post
title:  "轻量级高性能ORM框架：Dapper高级玩法"
title2:  "轻量级高性能ORM框架：Dapper高级玩法"
date:   2017-01-01 23:52:15  +0800
source:  "http://www.jfox.info/%e8%bd%bb%e9%87%8f%e7%ba%a7%e9%ab%98%e6%80%a7%e8%83%bdorm%e6%a1%86%e6%9e%b6-dapper%e9%ab%98%e7%ba%a7%e7%8e%a9%e6%b3%95.html"
fileName:  "20170101035"
lang:  "zh_CN"
published: true
permalink: "%e8%bd%bb%e9%87%8f%e7%ba%a7%e9%ab%98%e6%80%a7%e8%83%bdorm%e6%a1%86%e6%9e%b6-dapper%e9%ab%98%e7%ba%a7%e7%8e%a9%e6%b3%95.html"
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

[![image](/wp-content/uploads/2017/07/319628-20170701195139352-1286446753.png)](http://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195138774-1551303313.png)

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

[![image](/wp-content/uploads/2017/07/319628-20170701195140477-1714671408.png)](http://www.jfox.info/go.php?url=http://images2015.cnblogs.com/blog/319628/201707/319628-20170701195139836-684806990.png)

数据绑定成功。

就一句Dapper.DefaultTypeMap.MatchNamesWithUnderscores = true，让我们少写了不少AS语句。

**Dapper高级玩法2：**

法力无边的
{% endraw %}
