---
layout: post
title:  "【一条通用sql因为sq"
title2:  "【一条通用sql因为sq"
date:   2017-01-01 23:50:21  +0800
source:  "http://www.jfox.info/%e4%b8%80%e6%9d%a1%e9%80%9a%e7%94%a8sql%e5%9b%a0%e4%b8%basq.html"
fileName:  "20170100921"
lang:  "zh_CN"
published: true
permalink: "%e4%b8%80%e6%9d%a1%e9%80%9a%e7%94%a8sql%e5%9b%a0%e4%b8%basq.html"
---
{% raw %}
问题背景：用到GROUP BY 语句查询5.7版本时com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column ‘col_user_6.a.START_TIME’ which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by错误

**一、查看与设置**

查看当前连接会话的sql模式：

mysql> select @@session.sql_mode;

或者从环境变量里取

mysql> show variables like “sql_mode”;

查看全局sql_mode设置：

mysql> select @@global.sql_mode; 

只设置global，需要重新连接进来才会生效

设置

mysql> set sql_mode=”;

mysql> set global sql_mode=’NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES’;

mysql5.0以上版本支持三种sql_mode模式：ANSI、TRADITIONAL和STRICT_TRANS_TABLES。 

ANSI模式：宽松模式，对插入数据进行校验，如果不符合定义类型或长度，对数据类型调整或截断保存，报warning警告。 

TRADITIONAL模式：严格模式，当向mysql数据库插入数据时，进行数据的严格校验，保证错误数据不能插入，报error错误。用于事物时，会进行事物的回滚。 

STRICT_TRANS_TABLES模式：严格模式，进行数据的严格校验，错误数据不能插入，报error错误。 

**sql_mode常用值如下： **

**ONLY_FULL_GROUP_BY**：

对于GROUP BY聚合操作，如果在SELECT中的列，没有在GROUP BY中出现，那么这个SQL是不合法的，因为列不在GROUP BY从句中

**NO_AUTO_VALUE_ON_ZERO**：

该值影响自增长列的插入。默认设置下，插入0或NULL代表生成下一个自增长值。如果用户 希望插入的值为0，而该列又是自增长的，那么这个选项就有用了。

**STRICT_TRANS_TABLES**：

在该模式下，如果一个值不能插入到一个事务表中，则中断当前的操作，对非事务表不做限制

**NO_ZERO_IN_DATE**：

在严格模式下，不允许日期和月份为零

**NO_ZERO_DATE**：

设置该值，mysql数据库不允许插入零日期，插入零日期会抛出错误而不是警告。

**ERROR_FOR_DIVISION_BY_ZERO**：

在INSERT或UPDATE过程中，如果数据被零除，则产生错误而非警告。如 果未给出该模式，那么数据被零除时MySQL返回NULL

**NO_AUTO_CREATE_USER**：

禁止GRANT创建密码为空的用户

**NO_ENGINE_SUBSTITUTION**：

如果需要的存储引擎被禁用或未编译，那么抛出错误。不设置此值时，用默认的存储引擎替代，并抛出一个异常

**PIPES_AS_CONCAT**：

将”||”视为字符串的连接操作符而非或运算符，这和Oracle数据库是一样的，也和字符串的拼接函数Concat相类似

**ANSI_QUOTES**：

启用ANSI_QUOTES后，不能用双引号来引用字符串，因为它被解释为识别符
{% endraw %}
