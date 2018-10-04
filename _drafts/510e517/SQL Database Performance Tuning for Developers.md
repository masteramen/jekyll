---
layout: post
title: "面向开发人员的SQL数据库性能调优"
title2: "SQL Database Performance Tuning for Developers"
date: 2018-09-04 07:19:10  +0800
source: "https://www.toptal.com/sql-server/sql-database-tuning-for-developers"
fileName: "510e517"
lang: "en"
published: true
---

{% raw %}
SQL performance tuning can be an incredibly difficult task, particularly when working with large-scale data where even the most minor change can have a dramatic (positive or negative) impact on performance.
SQL 性能调优可能是一项非常困难的任务，尤其是在处理大规模数据时，即使是最微小的变化也会对性能产生巨大的（正面或负面）影响。(zh_CN)

In mid-sized and large companies, most SQL performance tuning will be handled by a Database Administrator (DBA). But believe me, there are [plenty of developers](https://www.toptal.com/sql) out there who have to perform DBA-like tasks. Further, in many of the companies I’ve seen that _do_ have DBAs, they often struggle to work well with developers—the positions simply require different modes of problem solving, which can lead to disagreement among coworkers.
在中型和大型公司中，大多数 SQL 性能调优将由数据库管理员（DBA）处理。但请相信我，有很多开发人员（https://www.toptal.com/sql），他们必须执行类似DBA的任务。此外，在许多公司中，我见过*做*有DBA，他们往往很难与开发人员合作 - 这些职位只需要不同的问题解决方式，这可能会导致同事之间的分歧。(zh_CN)

When working with large-scale data, even the most minor change can have a dramatic impact on performance.
在处理大规模数据时，即使是最微小的变化也会对性能产生巨大影响。(zh_CN)

On top of that, corporate structure can also play a role. Say the DBA team is placed on the 10th floor with all of their databases, while the devs are on the 15th floor, or even in a different building under a completely separate reporting structure—it’s certainly hard to work together smoothly under these conditions.
最重要的是，企业结构也可以发挥作用。假设 DBA 团队位于 10 楼，所有数据库都在，而开发人员在 15 楼，甚至在完全独立的报告结构下的不同建筑物中 - 在这些条件下很难顺利合作。(zh_CN)
￼
In this article, I’d like to accomplish two things:
在本文中，我想完成两件事：(zh_CN)

1. Provide developers with some developer-side SQL performance tuning techniques.
1. 为开发人员提供一些开发人员端的 SQL 性能调优技术。(zh_CN)
1. Explain how developers and DBAs can work together effectively.
1. 解释开发人员和 DBA 如何有效地协同工作。(zh_CN)

## SQL Performance Tuning (in the Codebase): Indexes

## SQL 性能调优（在代码库中）：索引(zh_CN)

If you’re a complete newcomer to databases and even asking yourself “What is SQL [performance tuning](https://www.toptal.com/sql-server/how-to-tune-microsoft-sql-server-for-performance)?”, you should know that indexing is an effective way to tune your SQL database that is often neglected during development. In basic terms, an [index](https://en.wikipedia.org/wiki/Database_index) is a data structure that improves the speed of data retrieval operations on a database table by providing rapid random lookups and efficient access of ordered records. This means that once you’ve created an index, you can select or sort your rows faster than before.
如果你是数据库的全新成员，甚至会问自己“什么是 SQL [性能调优]（https://www.toptal.com/sql-server/how-to-tune-microsoft-sql-server-for-性能）？“，您应该知道索引是调整SQL数据库的有效方法，在开发过程中经常被忽略。在基本术语中，[index]（https://en.wikipedia.org/wiki/Database_index）是一种数据结构，它通过提供快速随机查找和有序访问有序记录来提高数据库表上数据检索操作的速度。这意味着，一旦创建了索引，就可以比以前更快地选择或排序行。(zh_CN)

Indexes are also used to define a primary-key or unique index which will guarantee that no other columns have the same values. Of course, database indexing is a vast an interesting topic to which I can’t do justice with this brief description (but [here’s a more detailed write-up](http://stackoverflow.com/questions/1108/how-does-database-indexing-work/1130#1130)).
索引还用于定义主键或唯一索引，以确保没有其他列具有相同的值。当然，数据库索引是一个非常有趣的话题，我无法用这个简短的描述来做到这一点（但是[这里有更详细的报道]（http://stackoverflow.com/questions/1108/how-does -database 索引工作/ 1130＃1130））。(zh_CN)

If you’re new to indexes, I recommend using this diagram when structuring your queries:
如果您不熟悉索引，我建议您在构建查询时使用此图表：(zh_CN)
￼
![This diagram illustrates a few SQL performance tuning tips every developer should know.](https://uploads.toptal.io/blog/image/149/toptal-blog-1_C.png)

Basically, the goal is to index the major searching and ordering columns.
基本上，目标是索引主要的搜索和排序列。(zh_CN)

Note that if your tables are constantly hammered by `INSERT`, `UPDATE`, and `DELETE`, you should be careful when indexing—you could end up [decreasing performance](http://stackoverflow.com/questions/141232/how-many-database-indexes-is-too-many/141243#141243) as all indexes need to be modified after these operations.
请注意，如果您的表经常被敲打`INSERT`, `UPDATE`, 和`DELETE`, 索引时应该小心 - 因为所有索引需要，你最终会降低[性能下降]（http://stackoverflow.com/questions/141232/how-many-database-indexes-is-too-many/141243#141243）在这些操作之后进行修改。(zh_CN)

Further, DBAs often drop their SQL indexes before performing batch inserts of million-plus rows to [speed up the insertion process](http://stackoverflow.com/questions/13700575/is-a-good-practice-to-disable-indexes-before-insertion-of-many-records-on-sql-se). After the batch is inserted, they then recreate the indexes. Remember, however, that dropping indexes will affect every query running in that table; so this approach is only recommended when working with a single, large insertion.
此外，DBA 经常删除其 SQL 索引，然后执行百万行以上的批量插入[加快插入过程]（http://stackoverflow.com/questions/13700575/is-a-good-practice-to-disable-指数先于插入的一对多-记录上-SQL-SE）。插入批处理后，它们会重新创建索引。但请记住，删除索引会影响该表中运行的每个查询;因此，只有在使用单个大插入时才建议使用此方法。(zh_CN)

### SQL Tuning: Execution Plans in SQL Server

### SQL 调优：SQL Server 中的执行计划(zh_CN)

By the way: the Execution Plan tool in SQL Server can be useful for creating indexes.
顺便说一句：SQL Server 中的执行计划工具可用于创建索引。(zh_CN)

Its main function is to graphically display the data retrieval methods chosen by the SQL Server query optimizer. If you’ve never seen them before, there’s [a detailed walkthrough](https://youtu.be/lH2_SI04PWQ).
它的主要功能是以图形方式显示 SQL Server 查询优化器选择的数据检索方法。如果你以前从未见过它们，那就是[详细的演练]（https://youtu.be/lH2_SI04PWQ）。(zh_CN)

To retrieve the execution plan (in SQL Server Management Studio), just click “Include Actual Execution Plan” (CTRL + M) before running your query.
要检索执行计划（在 SQL Server Management Studio 中），只需在运行查询之前单击“包含实际执行计划”（CTRL + M）。(zh_CN)

Afterwards, a third tab named “Execution Plan” will appear. You might see a detected missing index. To create it, just right click in the execution plan and choose the “Missing Index Details…”. It’s as simple as that!
之后，将出现名为“执行计划”的第三个选项卡。您可能会看到检测到的缺失索引。要创建它，只需右键单击执行计划并选择“缺少索引详细信息...”。就这么简单！(zh_CN)

![This screenshot demonstrates one of the performance tuning techniques for your SQL database.](https://uploads.toptal.io/blog/image/146/toptal-blog-image2.png)

(_Click to zoom_)
(_点击放大_）(zh_CN)

### SQL Tuning: Avoid Coding Loops

### SQL 调优：避免编码循环(zh_CN)

Imagine a scenario in which 1000 queries hammer your database in sequence. Something like:
想象一下，1000 个查询按顺序锤击您的数据库的场景。就像是：(zh_CN)

    for (int i = 0; i < 1000; i++)
    {
        SqlCommand cmd = new SqlCommand("INSERT INTO TBL (A,B,C) VALUES...");
        cmd.ExecuteNonQuery();
    }

You should [avoid such loops](http://codeutopia.net/blog/2010/10/07/optimizing-sql-removing-queries-inside-loops/) in your code. For example, we could transform the above snippet by using a unique `INSERT` or `UPDATE` statement with multiple rows and values:
您应该[在代码中避免此类循环]（http://codeutopia.net/blog/2010/10/07/optimizing-sql-removing-queries-inside-loops/）。例如，我们可以使用唯一的转换上面的代码段`INSERT` 要么`UPDATE` 具有多个行和值的语句：(zh_CN)

    INSERT INTO TableName (A,B,C) VALUES (1,2,3),(4,5,6),(7,8,9) -- SQL SERVER 2008

    INSERT INTO TableName (A,B,C) SELECT 1,2,3 UNION ALL SELECT 4,5,6 -- SQL SERVER 2005

    UPDATE TableName SET A = CASE B
            WHEN 1 THEN 'NEW VALUE'
            WHEN 2 THEN 'NEW VALUE 2'
            WHEN 3 THEN 'NEW VALUE 3'
        END
    WHERE B in (1,2,3)

Make sure that your `WHERE` clause avoids updating the stored value if it matches the existing value. Such a trivial optimization can dramatically increase SQL query performance by updating only hundreds of rows instead thousands. For example:
确保你的`WHERE` 子句避免在存储值与现有值匹配时更新存储值。这种简单的优化可以通过仅更新数百行而不是数千行来显着提高 SQL 查询性能。例如：(zh_CN)

    UPDATE TableName
    SET A = @VALUE
    WHERE
          B = 'YOUR CONDITION'
                AND A <> @VALUE -- VALIDATION

A [correlated subquery](https://en.wikipedia.org/wiki/Correlated_subquery) is one which uses values from the parent query. This kind of SQL query tends to run [row-by-row](<http://technet.microsoft.com/en-us/library/ms187638(v=sql.105).aspx>), once for each row returned by the outer query, and thus decreases SQL query performance. New SQL developers are often caught structuring their queries in this way—because it’s usually the easy route.
[相关子查询]（https://en.wikipedia.org/wiki/Correlated_subquery）是使用父查询中的值的子查询。这种SQL查询倾向于[逐行]运行（http://technet.microsoft.com/en-us/library/ms187638（v = sql.105）.aspx），对于每行返回一次外部查询，从而降低 SQL 查询性能。新的 SQL 开发人员经常被抓住以这种方式构建他们的查询 - 因为它通常是简单的路径。(zh_CN)

Here’s an example of a correlated subquery:
以下是相关子查询的示例：(zh_CN)

    SELECT c.Name,
           c.City,
           (SELECT CompanyName FROM Company WHERE ID = c.CompanyID) AS CompanyName
    FROM Customer c

In particular, the problem is that the inner query (`SELECT CompanyName…`) is run for _each_ row returned by the outer query (`SELECT c.Name…`). But why go over the `Company` again and again for every row processed by the outer query?
特别是，问题是内部查询（`SELECT CompanyName…`) 为外部查询返回的* each *行运行（`SELECT c.Name…`). 但为什么要过去`Company` 对于外部查询处理的每一行，一次又一次？(zh_CN)

A more efficient SQL performance tuning technique would be to refactor the correlated subquery as a join:
更高效的 SQL 性能调优技术是将相关子查询重构为连接：(zh_CN)

    SELECT c.Name,
           c.City,
           co.CompanyName
    FROM Customer c
    	LEFT JOIN Company co
    		ON c.CompanyID = co.CompanyID

In this case, we go over the `Company` table just once, at the start, and JOIN it with the `Customer` table. From then on, we can select the values we need (`co.CompanyName`) more efficiently.
在这种情况下，我们过去了`Company` 表只是一次，在开始时，和它一起加入`Customer` 表。从那时起，我们可以选择我们需要的值（`co.CompanyName`) 更有效率。(zh_CN)

### SQL Tuning: Select Sparingly

### SQL 调优：选择 Sparingly(zh_CN)

One of my favorite SQL optimization tips is to avoid `SELECT *`! Instead, you should individually include the specific columns that you need. Again, this sounds simple, but I see this error all over the place. Consider a table with hundreds of columns and millions of rows—if your application only really needs a few columns, there’s no sense in querying for _all_ the data. It’s a massive waste of resources. (_For more issues, see [here](http://stackoverflow.com/questions/3639861/why-is-select-considered-harmful#answer-3639964)._)
我最喜欢的 SQL 优化技巧之一是避免`SELECT *`! 相反，您应该单独包含所需的特定列。再次，这听起来很简单，但我看到这个错误到处都是。考虑一个包含数百列和数百万行的表 - 如果您的应用程序只需要几列，那么查询* all *数据就没有意义。这是对资源的巨大浪费。 （_有关更多问题，请参阅[此处]（http://stackoverflow.com/questions/3639861/why-is-select-considered-harmful#answer-3639964）。_）(zh_CN)

For example:
例如：(zh_CN)

    SELECT * FROM Employees

vs.

    SELECT FirstName, City, Country FROM Employees

If you really need every column, explicitly list every column. This isn’t so much a rule, but rather, a means of preventing future system errors and additional SQL performance tuning. For example, if you’re using an `INSERT... SELECT...` and the source table has changed via the addition of a new column, you might run into issues, even if that column isn’t needed by the destination table, e.g.:
如果您确实需要每一列，请明确列出每一列。这不是一个规则，而是一种防止未来系统错误和额外 SQL 性能调整的方法。例如，如果您正在使用`INSERT... SELECT...` 并且通过添加新列来更改源表，即使目标表不需要该列，也可能遇到问题，例如：(zh_CN)

    ￼￼￼￼￼￼￼INSERT INTO Employees SELECT * FROM OldEmployees

    Msg 213, Level 16, State 1, Line 1
    Insert Error: Column name or number of supplied values does not match table definition.

To avoid this kind of error from SQL Server, you should declare each column individually:
要避免 SQL Server 出现此类错误，您应该单独声明每个列：(zh_CN)

    INSERT INTO Employees (FirstName, City, Country)
    SELECT Name, CityName, CountryName
    FROM OldEmployees

Note, however, that there are some situations where the use of `SELECT *` could be appropriate. For example, with temp tables—which leads us to our next topic.
但请注意，有些情况下使用`SELECT *` 可能是合适的。例如，使用临时表 - 这将引导我们进入下一个主题。(zh_CN)

### SQL Tuning: The Wise Use of Temporary Tables (#Temp)

### SQL 调优：临时表的明智使用（#Temp）(zh_CN)

[Temporary tables](http://www.tutorialspoint.com/sql/sql-temporary-tables.htm) usually increase a query’s complexity. If your code can be written in a simple, straightforward manner, I’d suggest avoiding temp tables.
[临时表]（http://www.tutorialspoint.com/sql/sql-temporary-tables.htm）通常会增加查询的复杂性。如果您的代码可以用简单，直接的方式编写，我建议避免使用临时表。(zh_CN)

But if you have a stored procedure with some data manipulation that _cannot_ be handled with a single query, you can use temp tables as intermediaries to help you to generate a final result.
但是如果你有一个带有一些数据操作的存储过程\*不能用单个查询来处理，你可以使用临时表作为中介来帮助你生成最终结果。(zh_CN)

When you have to join a large table and there are conditions on said table, you can increase database performance by transferring your data in a temp table, and then making a join on _that_. Your temp table will have fewer rows than the original (large) table, so the join will finish faster!
当您必须加入一个大表并且所述表上有条件时，您可以通过在临时表中传输数据，然后在* that *上进行连接来提高数据库性能。您的临时表将比原始（大）表具有更少的行，因此连接将更快完成！(zh_CN)

The decision isn’t always straightforward, but this example will give you a sense for situations in which you might want to use temp tables:
这个决定并不总是直截了当，但是这个例子将让您了解可能需要使用临时表的情况：(zh_CN)

Imagine a customer table with millions of records. You have to make a join on a specific region. You can achieve this by using a `SELECT INTO` statement and then joining with the temp table:
想象一下拥有数百万条记录的客户表。您必须在特定区域进行联接。你可以通过使用 a 来实现这一点`SELECT INTO` 语句然后加入临时表：(zh_CN)

    SELECT * INTO #Temp FROM Customer WHERE RegionID = 5
    SELECT r.RegionName, t.Name FROM Region r JOIN #Temp t ON t.RegionID = r.RegionID

(_Note: some SQL developers also avoid using `SELECT INTO` to create temp tables, saying that this command locks the tempdb database, disallowing other users from creating temp tables. Fortunately, this is [fixed in 7.0 and later](http://stackoverflow.com/questions/1302670/sql-server-select-into-and-blocking-with-temp-tables#answer-1302787)_.)
(_注意：一些 SQL 开发人员也避免使用`SELECT INTO` 创建临时表，说该命令锁定 tempdb 数据库，禁止其他用户创建临时表。幸运的是，这是[在 7.0 及更高版本中修复]（http://stackoverflow.com/questions/1302670/sql-server-select-into-and-blocking-with-temp-tables#answer-1302787）_。）(zh_CN)

As an alternative to temp tables, you might consider using a subquery as a table:
作为临时表的替代方法，您可以考虑将子查询用作表：(zh_CN)

    SELECT r.RegionName, t.Name FROM Region r
    JOIN (SELECT * FROM Customer WHERE RegionID = 5) AS t
    ON t.RegionID = r.RegionID

But wait! There’s a problem with this second query. As described above, we should only be including the columns we need in our subquery (i.e., not using `SELECT *`). Taking that into account:
可是等等！第二个查询存在问题。如上所述，我们应该只在子查询中包含我们需要的列（即，不使用`SELECT *`). 考虑到这一点：(zh_CN)

    SELECT r.RegionName, t.Name FROM Region r
    JOIN (SELECT Name, RegionID FROM Customer WHERE RegionID = 5) AS t
    ON t.RegionID = r.RegionID

All of these SQL snippets will return the same data. But with temp tables, we could, for example, create an index in the temp table to improve performance. There’s some good discussion [here](http://stackoverflow.com/questions/11169550/is-there-a-speed-difference-between-cte-subquery-and-temp-tables/11169910#11169910) on the differences between temporary tables and subqueries.
所有这些 SQL 片段都将返回相同的数据。但是使用临时表，我们可以在临时表中创建一个索引来提高性能。有一些很好的讨论[这里]（http://stackoverflow.com/questions/11169550/is-there-a-speed-difference-between-cte-subquery-and-temp-tables/11169910#11169910）之间的差异临时表和子查询。(zh_CN)

Finally, when you’re done with your temp table, delete it to clear tempdb resources, rather than just wait for it to be automatically deleted (as it will be when your connection to the database is terminated):
最后，当你完成临时表时，删除它以清除 tempdb 资源，而不是等待它被自动删除（就像你终止与数据库的连接时一样）：(zh_CN)

    DROP TABLE #temp

### SQL Tuning: “Does My Record Exist?”

### SQL 调优：“我的记录存在吗？”(zh_CN)

This SQL optimization technique concerns the use of `EXISTS()`. If you want to check if a record exists, use `EXISTS()` instead of `COUNT()`. While `COUNT()` scans the entire table, counting up all entries matching your condition, `EXISTS()` will exit as soon as it sees the result it needs. This will give you [better performance and clearer code](http://sqlblog.com/blogs/andrew_kelly/archive/2007/12/15/exists-vs-count-the-battle-never-ends.aspx).
这种 SQL 优化技术涉及到的使用`EXISTS()`. 如果要检查记录是否存在，请使用`EXISTS()` 代替`COUNT()`. 而`COUNT()` 扫描整个表格，计算符合条件的所有条目，`EXISTS()` 一看到它需要的结果就会退出。这将为您提供[更好的性能和更清晰的代码]（http://sqlblog.com/blogs/andrew_kelly/archive/2007/12/15/exists-vs-count-the-battle-never-ends.aspx）。(zh_CN)

    IF (SELECT COUNT(1) FROM EMPLOYEES WHERE FIRSTNAME LIKE '%JOHN%') > 0
        PRINT 'YES'

vs.

    IF EXISTS(SELECT FIRSTNAME FROM EMPLOYEES WHERE FIRSTNAME LIKE '%JOHN%')
        PRINT 'YES'

## SQL Performance Tuning With SQL Server 2016

## SQL Server 2016 的 SQL 性能调优(zh_CN)

As DBAs working with SQL Server 2016 are likely aware, the version marked an important shift in [defaults and compatibility management](https://www.sqlshack.com/query-optimizer-changes-in-sql-server-2016-explained/). As a major version, it of course comes with new query optimizations, but control over whether they’re used is now streamlined via `sys.databases.compatibility_level`.
由于使用 SQL Server 2016 的 DBA 可能知道，该版本标志着[默认和兼容性管理]的重要转变（https://www.sqlshack.com/query-optimizer-changes-in-sql-server-2016-explained /）。作为一个主要版本，它当然会带来新的查询优化，但现在可以通过简化控制它们是否被使用`sys.databases.compatibility_level`.(zh_CN)

## SQL Performance Tuning (in the Office)

## SQL 性能调优（在 Office 中）(zh_CN)

SQL database administrators (DBAs) and developers often clash over data- and non-data-related issues. Drawn from my experience, here are some tips (for both parties) on how to get along and work together effectively.
SQL 数据库管理员（DBA）和开发人员经常会遇到与数据和非数据相关的问题。根据我的经验，这里有一些关于如何相处和有效合作的提示（双方）。(zh_CN)

![SQL performance tuning goes beyond the codebase when DBAs and developers have to work together effectively.](https://uploads.toptal.io/blog/image/143/toptal-blog-1_A.png)

### Database Optimization for Developers:

### 开发人员的数据库优化：(zh_CN)

1.

If your application stops working suddenly, it may not be a database issue. For example, maybe you have a network problem. Investigate a bit before you accuse a DBA!
如果您的应用程序突然停止工作，则可能不是数据库问题。例如，您可能遇到网络问题。在指责 DBA 之前调查一下！(zh_CN)

2.

Even if you’re a ninja SQL data modeler, ask a DBA to help you with your relational diagram. They have a lot to share and offer.
即使您是忍者 SQL 数据建模者，也请 DBA 帮助您处理关系图。他们有很多东西要分享和提供。(zh_CN)

3.

DBAs don’t like rapid changes. This is natural: they need to analyze the database as a whole and examine the impact of any changes from all angles. A simple change in a column can take a week to be implemented—but that’s because an error could materialize as huge losses for the company. Be patient!
DBA 不喜欢快速变化。这很自然：他们需要整体分析数据库，并从各个角度检查任何变化的影响。列中的简单更改可能需要一周才能实现 - 但这是因为错误可能会成为公司的巨大损失。耐心一点！(zh_CN)

4.

Do not ask SQL DBAs to make data changes in a production environment. If you want access to the production database, you have to be responsible for all your own changes.
不要让 SQL DBA 在生产环境中进行数据更改。如果要访问生产数据库，则必须对所有自己的更改负责。(zh_CN)

### Database Optimization for SQL Server DBAs:

### SQL Server DBA 的数据库优化：(zh_CN)

1.

If you don’t like people asking you about the database, give them a real-time status panel. [Developers](https://www.toptal.com/sql-server) are always suspicious of a database’s status, and such a panel could save everyone time and energy.
如果您不喜欢人们向您询问数据库，请为他们提供实时状态面板。 [开发人员]（https://www.toptal.com/sql-server）总是怀疑数据库的状态，这样的面板可以节省每个人的时间和精力。(zh_CN)

2.

Help developers in a test/quality assurance environment. Make it easy to simulate a production server with simple tests on real-world data. This will be a significant time-saver for others as well as yourself.
在测试/质量保证环境中帮助开发人员。通过对真实数据的简单测试，可以轻松地模拟生产服务器。对于其他人和您自己来说，这将节省大量时间。(zh_CN)

3.

Developers spend all day on systems with frequently-changed business logic. Try to understand this world being more flexible, and be able to break some rules in a critical moment.
开发人员整天都在经常更改业务逻辑的系统上花费一整天。尝试理解这个世界更灵活，并能够在关键时刻打破一些规则。(zh_CN)

4.

SQL databases evolve. The day will come when you have to migrate your data to a new version. Developers count on significant new functionality with each new version. Instead of refusing to accept their changes, plan ahead and be ready for the migration.
SQL 数据库不断发展。必须将数据迁移到新版本的那一天。开发人员依靠每个新版本的重要新功能。不要拒绝接受他们的更改，而是提前计划并为迁移做好准备。(zh_CN)

## Understanding the Basics

## 了解基础知识(zh_CN)

### What is query processing in a DBMS?

### 什么是 DBMS 中的查询处理？(zh_CN)

Database management systems like SQL Server have to translate the SQL queries you give them into the actual instructions they have to perform to read or change the data in the database. After processing, the database engine then also attempts to automatically optimize the query where possible.
像 SQL Server 这样的数据库管理系统必须将您提供的 SQL 查询转换为他们必须执行的实际指令，以读取或更改数据库中的数据。在处理之后，数据库引擎然后还尝试在可能的情况下自动优化查询。(zh_CN)

### What is query optimization in SQL Server?

### 什么是 SQL Server 中的查询优化？(zh_CN)

Query optimization is when a developer, or the database engine, changes a query in such a way that SQL Server is able to return the same results more efficiently. Sometimes it's a simple as using EXISTS() instead of COUNT(), but other times the query needs to be rewritten with a different approach.
查询优化是指开发人员或数据库引擎以这样的方式更改查询，即 SQL Server 能够更有效地返回相同的结果。有时候使用 EXISTS（）而不是 COUNT（）很简单，但有时候需要用不同的方法重写查询。(zh_CN)

### What is performance tuning in SQL Server?

### 什么是 SQL Server 中的性能调优？(zh_CN)

Performance tuning includes query optimization, SQL client code optimization, database index management, and in another sense, better coordination between developers and DBAs.
性能调优包括查询优化，SQL 客户端代码优化，数据库索引管理，以及在另一种意义上，开发人员和 DBA 之间更好的协调。(zh_CN)

### What is the use of an index in SQL?

### SQL 中的索引有什么用？(zh_CN)

An index tracks a targeted subset of a table's data so that selecting and ordering can be done much faster, without the server having to look through every last bit of data for that table.
索引跟踪表数据的目标子集，以便可以更快地完成选择和排序，而服务器不必查看该表的每个最后一位数据。(zh_CN)

### Why is EXISTS() faster than COUNT()?

### 为什么 EXISTS（）比 COUNT（）更快？(zh_CN)

EXISTS() stops processing as soon as it finds a matching row, whereas COUNT() has to count every row, regardless of whether you actually need that detail in the end.
EXISTS（）一找到匹配的行就会停止处理，而 COUNT（）必须计算每一行，无论你最后是否真的需要这个细节。(zh_CN)

## About the author

## 关于作者(zh_CN)

[Rodrigo Koch, Brazil](https://www.toptal.com/resume/rodrigo-koch)
[Rodrigo Koch，巴西]（https://www.toptal.com/resume/rodrigo-koch）(zh_CN)

member since June 24, 2012
会员自 2012 年 6 月 24 日起(zh_CN)

Rodrigo is a Microsoft Certified Professional in .NET Web Applications with C#. His dual nationality makes him a valuable resource as developer in both Germany and Brazil. He has strong development and troubleshooting skills with a portfolio to match; his extensive list of well-known clients includes Nestlé, Chartis Insurance, and Casio Brazil. Today, he works at Samsung Latin America. [[click to continue...]](https://www.toptal.com/resume/rodrigo-koch)
Rodrigo 是使用 C＃的.NET Web 应用程序的 Microsoft 认证专家。他的双重国籍使他成为德国和巴西开发商的宝贵资源。他具有强大的开发和故障排除技能，并且具有匹配的组合;他广泛的知名客户包括雀巢，Chartis 保险和卡西欧巴西。如今，他在三星拉丁美洲工作。 [[点击继续...]]（https://www.toptal.com/resume/rodrigo-koch）(zh_CN)
{% endraw %}
