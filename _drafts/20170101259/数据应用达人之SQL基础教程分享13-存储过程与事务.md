---
layout: post
title:  "数据应用达人之SQL基础教程分享13-存储过程与事务"
title2:  "数据应用达人之SQL基础教程分享13-存储过程与事务"
date:   2017-01-01 23:55:59  +0800
source:  "https://www.jfox.info/%e6%95%b0%e6%8d%ae%e5%ba%94%e7%94%a8%e8%be%be%e4%ba%ba%e4%b9%8bsql%e5%9f%ba%e7%a1%80%e6%95%99%e7%a8%8b%e5%88%86%e4%ba%ab13%e5%ad%98%e5%82%a8%e8%bf%87%e7%a8%8b%e4%b8%8e%e4%ba%8b%e5%8a%a1.html"
fileName:  "20170101259"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%95%b0%e6%8d%ae%e5%ba%94%e7%94%a8%e8%be%be%e4%ba%ba%e4%b9%8bsql%e5%9f%ba%e7%a1%80%e6%95%99%e7%a8%8b%e5%88%86%e4%ba%ab13%e5%ad%98%e5%82%a8%e8%bf%87%e7%a8%8b%e4%b8%8e%e4%ba%8b%e5%8a%a1.html"
---
{% raw %}
简单的解释，存储过程就是将一条或多条SQL语句保存起来，以方便以后反复使用。
而且存储过程都有一个特性，特别是在有多条SQL语句的情况下，如果有一条语句执行失败，则全部不执行，只有在全部语句都执行成功的情况下，才会通过。
（Access和SQLite不支持存储过程）

### 2、执行存储

### 【知识点介绍】

执行存储远比编写要复杂的多，虽然语句很简单，SQL中使用EXECUTE关键字来执行存储过程。
EXECUTE接收存储过程名和需要传递给它的参数。

    EXECUTE 存储过程名
    (参数1,参数2,......)

### 3.创建存储过程

### 【知识点介绍】

创建存储过程不是一个简单的事情，如果你想要了解详细的内容，我们建议你可以从具体的数据库软件入手学习。
在这里，我们只是举一个例子，让大家对创建存储过程有一个感性的认识。
我们为学生表创建一个myprocess的存储过程,用来给学生添加新的学生，传递的参数是ID和SName：

    CREATE PROCEDURE myprocess(
    ID INT IN,
    SName VARCHAR IN)
    IS
    N_ID INT,
    N_Name VARCHAR;
    BEGIN
        INSERT INTO student
        VALUES (N_ID,N_Name);
    END; 

创建好了存储过程，我们就可以使用EXECUTE来执行插入学生数据的这个存储过程了：

    EXECUTE myprocess(20161555,'Bill');

当然你可以在创建存储过程的时候，要求添加更多的参数。
***事务管家***

### 1、什么是事务管理

### 【知识点介绍】

事务实际上是指一个或多个SQL语句，事务管理则是对事务进行管理，以维护数据库的完整性。简单说，SQL语句要么完全执行，要么完全不执行，这就是SQL里的事务管理（Transaction Processing）。
事务管理有以下几个关键词：
TRANSACTION，事务，指一条或一组SQL语句；
ROLLBACK，回退，指撤销指定的SQL语句的过程，即撤销；
COMMIT，提交，指将未执行的SQL语句的结果写入数据库，即保持更改；
SAVEPOINT，保留点，指事务处理中设置的占位符_，可 以对它发布回退（与回退整个事务处理不同）。
不同的数据库软件控制事务管理的方法也都各不相同，比如：

    -- MySQL
    START TRANSACTION
    ......
    
    -- Oracle
    SET TRANSACTION
    ......

### 2、ROLLBACK

### 【知识点介绍】

ROLLBACK命令可以用来回退、撤销SQL语句，但不是所有SQL语句都是可以被撤销的。
INSERT、UPDATE、DELETE语句我们是可以撤销的，但对SELECT语句（因为SELECT没有必要撤销）、CREATE、DROP操作是无效的。
假如我们用DELETE删除了学生表中的某一行值，通过ROLLBACK是可以撤销的：

    DELETE FROM student
    WHERE ID = 20160014;
    ROLLBACK; 

### 3、COMMIT与保留点

### 【知识点介绍】

由于不同数据库的使用都有所不同，所以我们只对COMMIT和保留点做一个简单的介绍。
COMMIT是为了保证数据完整执行的一个关键字，假如我们现在有这样一段代码

    START TRANSACTION
    DELETE FROM 表;
    DELETE FROM 表2;
    COMMIT;

COMMIT的作用在于，如果我们的第一句DELETE语句是正确的，但第二句DELETE是错误的，则这段TRANSACTION就不会被执行，说明了COMMIT仅在所有语句都不出错时才会真正执行，从而保护了数据。
保留点，在MySQL中的用法是：

    SAVEPOINT delete1;

保留点多用于更为复杂的事务管理，即在事务处理的过程中添加占位符（即保留点），如果需要回退，则可以退到我们指定的保留点。从维护数据的层面上来说，处理事务的时候，原则上保留点设置越多越好。
如果你想要了解更多关于SQL事务管理的内容，我们依旧建议大家从具体的数据库软件语言入手。

下文待续。。。。。。

欢迎大家前往访问我们的官网：

http://www.datanew.com/datanew/homepage

http://www.lechuangzhe.com/homepage
{% endraw %}
