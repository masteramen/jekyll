---
layout: post
title: "where子句的顺序在SQL中是否重要？"
title2: "Does order of where clauses matter in SQL?"
date: 2018-09-05 08:53:57  +0800
source: "https://stackoverflow.com/questions/11436469/does-order-of-where-clauses-matter-in-sql"
fileName: "4ef2675"
lang: "en"
published: true
---

{% raw %}
No, that order doesn't matter (or at least: shouldn't matter).
不，这个顺序无关紧要（或至少：无所谓）。(zh_CN)

Any decent query optimizer will look at **all** the parts of the `WHERE` clause and figure out the most efficient way to satisfy that query.
任何体面的查询优化器都会查看**所有**部分`WHERE` 子句并找出满足该查询的最有效方法。(zh_CN)

I know the SQL Server query optimizer will pick a suitable index - no matter which order you have your two conditions in. I assume other RDBMS will have similar strategies.
我知道 SQL Server 查询优化器会选择一个合适的索引 - 无论你有两个条件的顺序。我假设其他 RDBMS 将有类似的策略。(zh_CN)

What does matter is whether or not you have a suitable index for this!
重要的是你是否有适合的指数！(zh_CN)

In the case of SQL Server, it will likely use an index if you have:
对于 SQL Server，如果您有以下情况，它可能会使用索引：(zh_CN)

- an index on `(LastName, FirstName)`
- 一个索引`(LastName, FirstName)`(zh_CN)
- an index on `(FirstName, LastName)`
- 一个索引`(FirstName, LastName)`(zh_CN)
- an index on just `(LastName)`, or just `(FirstName)` (or both)
- 关于公正的指数`(LastName)`, 要不就`(FirstName)` (或两者）(zh_CN)

On the other hand - again for SQL Server - if you use `SELECT *` to grab **all** columns from a table, and the table is rather small, then there's a good chance the query optimizer will just do a table (or clustered index) scan instead of using an index (because the lookup into the full data page to get **all** other columns just gets too expensive very quickly).
另一方面 - 再次为 SQL Server - 如果您使用`SELECT *` 从表中获取**所有**列，并且表格相当小，然后查询优化器很可能只执行表（或聚簇索引）扫描而不是使用索引（因为查找到完整数据页面得到**所有**其他列只是很快就太贵了）。(zh_CN)
{% endraw %}
