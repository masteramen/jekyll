---
layout: post
title: "如何分析SQL Server执行计划？"
title2: "How Do I Analyze a SQL Server Execution Plan?"
date: 2018-09-05 08:14:01  +0800
source: "https://littlekendra.com/2017/09/22/how-do-i-analyze-a-sql-server-execution-plan/"
fileName: "863c3bd"
lang: "en"
published: true
---

{% raw %}
A query is slow, and you figure out how to collect the query execution plan. Now what? In this video, I talk “big picture” about what execution plans are, what “cost” is, why to collect “compiled for” values, and the steps I take to analyze execution plans while performance tuning queries.
查询很慢，您可以了解如何收集查询执行计划。怎么办？在这个视频中，我谈到了关于执行计划是什么，“成本”是什么，为什么要收集“编译为”值的“大局”，以及我在分析性能调优查询时分析执行计划的步骤。(zh_CN)

_No time to watch right now or read the transcript below? Listen in podcast format [on iTunes](https://itunes.apple.com/us/podcast/dear-sql-dba/id1117507864) , [on Google Play,](https://goo.gl/app/playmusic?ibi=com.google.PlayMusic&isi=691797987&ius=googleplaymusic&link=https://play.google.com/music/m/Ivy7ctr66hgx4jfwi7tsasixheu?t%3DDear_SQL_DBA) or plug this RSS feed into your favorite podcast app: [http://dearsqldba.libsyn.com/rss](http://dearsqldba.libsyn.com/rss)_
_没时间观看或阅读下面的成绩单？收听播客格式[在 iTunes 上]（https://itunes.apple.com/us/podcast/dear-sql-dba/id1117507864），[在Google Play 上]，（https://goo.gl/app/playmusic ？ibi = com.google.PlayMusic＆amp; isi = 691797987＆amp; ius = googleplaymusic＆amp; link = https://play.google.com/music/m/Ivy7ctr66hgx4jfwi7tsasixheu？t％3DDear_SQL_DBA）或将此RSS Feed 插入您最喜爱的播客应用中： [http://dearsqldba.libsyn.com/rss](http://dearsqldba.libsyn.com/rss)_(zh_CN)

## Transcript of this episode

## 本集的成绩单(zh_CN)

_Please forgive errors in grammar and punctuation: robots helped create this transcript. And I’m grammatically challenged._
_请原谅语法和标点符号中的错误：机器人帮助创建了此成绩单。我在语法上受到挑战。_(zh_CN)

Welcome to Dear SQL DBA, a podcast for SQL Server developers and database administrators. I’m Kendra Little from [SQLWorkbooks.com](https://sqlworkbooks.com/).
欢迎使用亲爱的 SQL DBA，这是一个面向 SQL Server 开发人员和数据库管理员的播客。我是来自[SQLWorkbooks.com]（https://sqlworkbooks.com/）的Kendra Little。(zh_CN)

This week I’m talking about a question that I recently got from a student– but I’ve gotten it from different people by email over the years, too. We’re talking about how to analyze a SQL Server execution plan.
这个星期我正在谈论我最近从学生那里得到的一个问题 - 但我也是通过电子邮件多年来从不同的人那里得到的。我们正在讨论如何分析 SQL Server 执行计划。(zh_CN)

Here’s how the question came in this time: a student asked, “I’ve got a terribly performing query, and I’ve collected a complex execution plan for it. But I’m not sure how to interpret valuable information from the plan. Big picture: What do i do? How do I attack this thing?”
以下是这个时间问题的出现：一位学生问：“我的查询表现非常糟糕，而且我已经收集了一份复杂的执行计划。但我不确定如何从计划中解读有价值的信息。大图：我该怎么办？我怎么攻击这个东西？“(zh_CN)

We’re gonna talk about this and break it down.
我们要谈论这个并将其分解。(zh_CN)

## First up: what is an execution plan?

## 首先：什么是执行计划？(zh_CN)

When you submit a query to SQL Server, it needs to figure out: how am I gonna run this thing? What indexes do I want to use? Can I do seeks on them do I need to scan them? What kind of joins? If you’re joining different tables together, what kind of operations do I want to use to join these things together? Do I need to build temporary objects? Do I want to do lookup operations? Should I use multiple cores to do this or should I do it single threaded?
当您向 SQL Server 提交查询时，它需要弄清楚：我将如何运行这个东西？我想使用哪些索引？我是否可以对它们进行搜索？我需要扫描它们吗？什么样的加入？如果您要将不同的表连接在一起，我希望使用哪种操作将这些内容组合在一起？我需要构建临时对象吗？我想做查找操作吗？我应该使用多个内核来执行此操作还是应该使用单线程？(zh_CN)

There’s a lot of different things for it to consider and the execution plan is compiled by the SQL Server query optimizer before it ever gets started running the query. SQL Server has to use things like statistics– these little samples of data that help it guess, “hey how much data will I be dealing with from this particular table?” It also has to look at things in the query: if you have parameterized values it’ll try to sniff out, “hey if i have to compile a plan for this, what are the the values you’re using for the parameters for this stored procedure?”
它需要考虑很多不同的事情，执行计划是在 SQL Server 查询优化器开始运行查询之前编译的。 SQL Server 必须使用像统计这样的小数据样本来帮助它猜测，“嘿，我将从这个特定的表中处理多少数据？”它还必须查看查询中的内容：如果你已经参数化了值得它试图嗅出来，“嘿，如果我必须为此编译一个计划，你对这个存储过程的参数使用的值是什么？”(zh_CN)

Or perhaps it’s a parameterized query. Because if you’re if you’ve got those values in a predicate and you’re limiting the rows by certain filters with those values, that influences heavily how much data is coming out of different tables involved in the query.
或者它可能是一个参数化查询。因为如果您在谓词中获得了这些值并且您使用这些值限制了某些过滤器的行，则会严重影响查询中涉及的不同表中的数据量。(zh_CN)

It has to make a lot of guesses before the query ever starts executing, and SQL Server doesn’t reconsider the execution plan while the query is in mid-flight.
它必须在查询开始执行之前进行大量猜测，并且 SQL Server 在查询处于中途时不会重新考虑执行计划。(zh_CN)

There is a feature that’s coming to us in SQL Server 2017 where certain query plans under certain conditions will have parts of them that are quote “adaptable”. Where on later runs of the query, SQL Server might be like, “that didn’t work out so well, so I’m gonna try a different tactic just for this part of the plan,” but that’s only in certain cases and we don’t even have SQL Server 2017 yet. So as of right now with SQL Server 2016 and prior, optimization only happens before the query starts running, and it’s all based on these estimates. SQL Server doesn’t stop and think, “did the query turn out like I estimated?”
我们在 SQL Server 2017 中有一个功能，其中某些条件下的某些查询计划将具有引用“自适应”的部分查询计划。在稍后运行的查询中，SQL Server 可能会像“那样做得不好，所以我会为这部分计划尝试不同的策略”，但这只是在某些情况下我们甚至还没有 SQL Server 2017。因此，对于 SQL Server 2016 和之前的版本，优化仅在查询开始运行之前发生，并且全部基于这些估计。 SQL Server 没有停下来思考，“查询结果是否像我估计的那样？”(zh_CN)

## We also have execution plans that can be reused

## 我们还有可以重复使用的执行计划(zh_CN)

SQL Server doesn’t want to compile an execution plan every time that you run a query if it doesn’t have to, so it’ll look at it and say, “hey do I have a compiled plan in cache for this query, and maybe are we running it the same stored procedure or this same parameterized query — are we running it with different values for the parameter?” In a lot of cases, it’ll say, “good thing I already compiled the plan for that, I’ve got it in memory. I can just reuse that execution plan.” So an execution plan is a way that SQL server guesses: given all my options, I think this is the best way to execute this query. It makes that guess before it ever starts running the query. Sometimes it’s using a guess that it compiled earlier, possibly for different parameter values.
SQL Server 不希望每次运行查询时都编译执行计划（如果不需要），所以它会查看并说“我在缓存中为此查询编译计划，也许我们正在运行相同的存储过程或相同的参数化查询 - 我们是否使用不同的参数值运行它？“在很多情况下，它会说，”好的事情我已经为此编制了计划，我已经记忆中了。我可以重用那个执行计划。“因此执行计划是 SQL 服务器猜测的一种方式：给定我所有选项，我认为这是执行此查询的最佳方式。它在开始运行查询之前就做出了猜测。有时它会使用之前编译的猜测，可能是针对不同的参数值。(zh_CN)

## When you get to asking the question, “why was the query slow?” the answer to why it was slow is NOT always in the execution plan

## 当你问这个问题时，“为什么查询速度慢？”为什么它变慢的答案并不总是在执行计划中(zh_CN)

We have this additional factor in addition to everything I’ve started talking about: sometimes it query is slow for reasons that have nothing to do with the execution plan itself! Or at least that aren’t the fault of the execution plan.
除了我开始讨论的所有内容之外，我们还有这个额外的因素：有时它的查询速度很慢，原因与执行计划本身无关！或者至少那不是执行计划的错。(zh_CN)

Maybe my query needed a lock on a resource and something else was holding that lock, and it just had to sit and wait for the lock for a really long time. Yeah, okay, the execution plan was accessing a structure that was locked, it is _kinda_ related to the plan, but the cause of this is more like: “Well why was something holding that lock for a really long time?” or “What isolation levels are we using?”
也许我的查询需要锁定资源而其他东西正在持有该锁，而且它只需要等待锁定很长时间。是的，好吧，执行计划是访问一个被锁定的结构，它有点\*与计划相关，但其原因更像是：“那么为什么持有这个锁很长一段时间呢？”或者“我们使用什么隔离级别？”(zh_CN)

Those aren’t a problem with the plan. Is the issue that storage was really slow? Sometimes the query is slow for reasons entirely different from the plan, and you wouldn’t know that just from looking at the plan.
这些不是计划的问题。存储真的很慢的问题是什么？有时候查询的速度很慢，原因与计划完全不同，而且您不会仅仅通过查看计划就知道这一点。(zh_CN)

Things are changing fast though: as of SQL Server 2016 Service Pack 1, certain kinds of plans called actual execution plans do you have some information about wait statistics in them. It’s only that type of plan– the actual type of plan in SQL Server 2016 Service Pack 1 and later.
事情正在快速变化：从 SQL Server 2016 Service Pack 1 开始，某些称为实际执行计划的计划中有一些关于等待统计信息的信息。它只是那种类型的计划 - SQL Server 2016 Service Pack 1 及更高版本中的实际计划类型。(zh_CN)

Most of the time when we’re looking at an execution plan we don’t have that information of did the query have to wait, and if so what was it waiting on.
大多数时候，当我们查看执行计划时，我们没有查询必须等待的信息，如果是，那么等待什么。(zh_CN)

## We also usually don’t even have information in the plan about how long did the query take

## 我们通常在计划中甚至没有关于查询需要多长时间的信息(zh_CN)

Even looking at the actual execution plan, only if the SQL Server Engine — not where you have management studio is, but the instance you were running the query against– only in SQL Server 2014 Service Pack 2 and higher will you have information about how much CPU was used, how what was the duration, and how many reads did something’s do. Even then it’s still only those actual plans: only one type of execution plan.
即使查看实际的执行计划，只有 SQL Server 引擎 - 而不是管理工作室的位置，但是您运行查询的实例 - 仅在 SQL Server 2014 Service Pack 2 及更高版本中才能获得有关多少的信息使用了 CPU，持续时间是多少，以及做了多少次读取。即便如此，它仍然只是那些实际的计划：只有一种执行计划。(zh_CN)

So how long was the query even slow?
那么查询还有多长时间？(zh_CN)

So many execution plans– when you look at those most execution plans you can’t even tell how long did the whole query take, much less how long did a specific part of the query take. What all this means is that execution plans are absolutely valuable — I love working with them– and they make tuning queries much easier to me, but you do have to do other legwork to figure out things like were there waits in wait statistics? In other words, were there resources that the query didn’t have to execute, that impacted it, that we’re outside of the plan’s control.
如此多的执行计划 - 当您查看那些大多数执行计划时，您甚至无法判断整个查询需要多长时间，更不用说查询的特定部分需要多长时间。所有这一切意味着执行计划绝对有价值 - 我喜欢和他们一起工作 - 他们让调优查询对我来说更容易，但你必须做其他的工作来弄清楚等待统计中等待的东西吗？换句话说，如果资源不是必须执行查询，那么影响它，我们就不在计划的控制之内。(zh_CN)

How long did the query take in parts and in whole? Having that extra information and figuring it out is a valuable part of interpreting the plan.
查询在部分和整体中需要多长时间？获得额外信息并将其弄清楚是解释计划的重要部分。(zh_CN)

I love plans I’m not putting them down, you can get tons of valuable info from them just be prepared to dig for supplementary information to help you interpret the plan, or to know if the problem can be answered in part by the plan.
我喜欢我没有放下它们的计划，你可以从中获取大量有价值的信息，只是准备挖掘补充信息以帮助你解释计划，或者知道问题是否可以部分地由计划来解决。(zh_CN)

When I’m interpreting plans, I think about a lot of different things and I’m going to step through today just what are the types of execution plans, what is “cost” in an execution plan and how I think of it, what “compiled for” values are and why you should collect them, and then steps to interpret the plan.
当我在解释计划时，我会考虑很多不同的事情，今天我将逐步介绍执行计划的类型，执行计划中的“成本”以及我如何看待它，什么“编译为”值是为什么你应该收集它们，然后采取步骤来解释计划。(zh_CN)

## Types of execution plans

## 执行计划的类型(zh_CN)

### 1. Estimated execution plans

### 1. 估计执行计划(zh_CN)

If you’re going to run a query against SQL Server in Management Studio, you can say, give me an estimated plan for this. SQL Server will compile, “here’s what I think I would do,” without executing the query. These can be really useful because maybe your query takes 15 minutes to run you just want to get an idea of how much work do you think this is gonna be, without waiting the whole 10 minutes or using those resources.
如果您打算在 Management Studio 中对 SQL Server 运行查询，可以说，给我一个估计的计划。 SQL Server 将编译，“这是我认为我会做的”，而不执行查询。这些可能非常有用，因为您的查询可能需要 15 分钟才能运行您只想了解您认为这将会有多少工作，而无需等待整整 10 分钟或使用这些资源。(zh_CN)

You can also see certain things in estimated plans that show up in a different way than they do in other plans: things like functions. If you look at an estimated plan, they will actually show up in a more obvious way — they’ll be broken out in more detail than they are when you’re looking at what’s called an actual execution plan.
您还可以看到估算计划中的某些内容以与其他计划中不同的方式显示：功能之类的内容。如果你看一个估计的计划，它们实际上会以一种更明显的方式出现 - 它们会比你在查看所谓的实际执行计划时更详细。(zh_CN)

Sometimes you can get a really clear insight of, “oh look at all this work involved in this function” broken out in a different way in an estimated plan when you look at that in Management Studio. But an estimated plan, is just that, “Here’s what I think I would do. Here’s how many rows I think would come back from this, here’s what index I think I would use.” We don’t know how many rows are actually gonna come back from that, so we just have information about “here’s here’s the direction I think I’d head in.”
有时候，当你在 Management Studio 中查看时，你可以得到一个非常清晰的洞察力，“哦，看看这个功能所涉及的所有这些工作”，在估计的计划中以不同的方式分解。但是一个估计的计划就是这样，“这就是我认为我会做的。这是我认为会从这里回来的行数，这是我认为我会使用的索引。“我们不知道有多少行实际上会从那里回来，所以我们只是有关于”这里是我的方向的信息我想我会进去的。“(zh_CN)

### 2. Cached execution plans

### 2. 缓存执行计划(zh_CN)

A lot of times when we’re troubleshooting a slow query we are working with an execution plan that we have pulled from the memory of the SQL Server because we’re looking for our top queries and we’re saying, “hey based on the information you have in memory, SQL Server,” maybe I’ve got a query where I’ve said I want to see the execution plans for the queries that have the longest duration. I pulled these plans out of cache.
很多时候，当我们对慢速查询进行故障排除时，我们正在处理我们从 SQL Server 内存中提取的执行计划，因为我们正在寻找我们的顶级查询，我们说，“嘿，基于你在内存中的信息，SQL Server，“也许我有一个查询，我说我希望看到持续时间最长的查询的执行计划。我把这些计划从缓存中拉出来了。(zh_CN)

These cached plans can be reused, and I may have overall information on, “since this plan was put in cache, how much CPU does it take on average? What duration does it take on average?” And also things like what’s the max duration it’s taken, what’s the max CPU it’s used. I have aggregate information like that, but with this cached plan I don’t know things like — okay you estimated 10 rows would come from that index, was it actually 10 or was it 10 million? The cached plan just has things like those estimated rows. It doesn’t have details on actually how many rows flowed through different parts of the plan. It doesn’t have duration information for how long different parts of the plan took.
这些缓存的计划可以重复使用，我可能会有一个全面的信息，“因为这个计划被放入缓存中，平均需要多少 CPU？它的平均持续时间是多长？“还有最长持续时间是什么，它使用的最大 CPU 是多少。我有这样的汇总信息，但有了这个缓存的计划，我不知道这样的事情 - 好吧你估计 10 行会来自那个索引，它实际上是 10 还是 1000 万？缓存的计划只有那些估计的行。它没有详细说明有多少行流过计划的不同部分。它没有持续时间信息，说明计划的不同部分需要多长时间。(zh_CN)

I can kind of make some guesses based on those aggregate statistics, what I know about the tables, and some testing, but again I have to do some legwork to figure out, “hey is all of this estimated stuff in the plan, does it it does have anything to do with what actually happened when the query ran?”
我可以根据这些汇总统计数据，我对表格的了解以及一些测试进行一些猜测，但我还要做一些工作来弄清楚，“嘿，这是计划中所有估计的东西，是吗？它与查询运行时实际发生的事情有什么关系？“(zh_CN)

_(Note: I think it was Brent Ozar who I first saw categorize cached plans as a different type than estimated plans. It may make sense to break out Query Store plans as their own type as well, as there are going to be certain nuances where they’re difference from the plan in memory, especially when adaptive query plans come into play.)_
_(注意：我认为是 Brent Ozar 我第一次看到将缓存计划分类为与估计计划不同的类型。将 Query Store 计划分解为自己的类型也是有意义的，因为它们会与内存中的计划有所不同，特别是当自适应查询计划发挥作用时。）_(zh_CN)

### 3. Actual execution plans

### 3. 实际执行计划(zh_CN)

These are really, really valuable, but we have to be careful generating them. One of the deals with actual execution plans is that tracing plans (any type, not just actual plans) may slow down your SQL Server a lot. Collecting them by trace is really expensive and can hurt performance.
这些确实非常有价值，但我们必须小心生成它们。实际执行计划的一个处理是跟踪计划（任何类型，而不仅仅是实际计划）可能会大大减慢您的 SQL Server 速度。通过跟踪收集它们非常昂贵并且可能会损害性能。(zh_CN)

You can get them by running a query yourself, but you have to run the query yourself and sometimes that’s not ok. Sometimes we have to restore the database someplace else to be able to rerun the query, and that can take a lot of time. Sometimes if the query is modifying a bunch of data that process of running it someplace where it’s safe to run, and then resetting the environment again can be somewhat cumbersome.
您可以通过自己运行查询来获取它们，但是您必须自己运行查询，有时这不是正常的。有时我们必须在其他地方恢复数据库以便能够重新运行查询，这可能需要很长时间。有时，如果查询正在修改一堆数据，那么在运行它的地方运行它的过程，然后再次重置环境可能有点麻烦。(zh_CN)

But actual execution plans can have a wealth of information, especially on SQL Server 2014 service pack 2 and higher where we can get things like not only how many rows flowed through different parts of the plan, but also information on how much CPU were we using at this point in the plan. It takes a little while to get used to interpreting this, because in certain operators that information is cumulative with its child operators, and in certain operators it’s not, but it’s a wealth of information for us. We also get those wait statistics in SQL Server 2016 and higher.
但是实际的执行计划可以拥有丰富的信息，特别是在 SQL Server 2014 Service Pack 2 和更高版本上，我们可以获得不仅有多少行流经计划的不同部分，而且还有关于我们使用了多少 CPU 的信息在计划的这一点上。习惯于解释这一点需要一点时间，因为在某些运营商中，信息与其子运营商是累积的，而在某些运营商中则不是，但它对我们来说是丰富的信息。我们还在 SQL Server 2016 及更高版本中获得了这些等待统计信息。(zh_CN)

## Cost is an estimate – even in “actual” plans

## 成本是估计 - 即使在“实际”计划中也是如此(zh_CN)

Depending on knowing what type of plan we’re looking at, when interpreting a plan it’s really useful — even in an actual plan — one important thing to know is that when you’re looking at cost numbers they are always an estimate.
根据我们正在查看的计划类型，在解释计划时，它确实非常有用 - 即使在实际计划中 - 要知道的一件重要事情是，当您查看成本数字时，它们总是一个估计值。(zh_CN)

Even though we call it an actual plan, an actual plan is an estimated plan that’s had some additional information added to it about things like, “okay what were our actual rows and what were certain actuals” But SQL Server doesn’t go back and readjust the cost. It wouldn’t make sense to in a lot of ways, as the cost information in the plan has to do with the reasoning behind why it chose these operators. If the cost was just sort of completely adjusted all the time, sometimes looking at a plan it would make no sense why it had done that.
即使我们称之为实际计划，实际计划也是一个估计计划，其中添加了一些额外信息，例如“好吧我们的实际行是什么以及什么是确定的实际值”但 SQL Server 不会返回重新调整成本。在很多方面都没有意义，因为计划中的成本信息与选择这些运营商的原因有关。如果成本只是一直在完全调整，有时候看一个计划就没有意义，为什么它已经做到了。(zh_CN)

So I actually like that cost is always an estimate, the important thing is just to remember that and don’t fall into the trap of always just looking at the “high cost operators.” I do think it’s valuable to look for the operators that have the highest cost– I will look at those in the plan. I’m gonna be like, “okay this is what SQL Server thought would be the most work.” It’s very valuable information you know about how it optimized the query, just know that it has to do just with those estimates and what it thought would be the most work and what actually took the longest in the query may or may not be those highest cost operators.
所以我真的希望成本总是一个估计值，重要的是要记住这一点并且不要陷入总是只看“高成本运营商”的陷阱。我认为寻找那些经营者是有价值的。成本最高 - 我会看一下计划中的那些。我会说，“好吧这就是 SQL Server 认为最有效的方法。”这是非常有价值的信息，你知道它如何优化查询，只知道它只需要做那些估计和它的想法将是最多的工作，在查询中实际花费时间最长的可能是也可能不是那些成本最高的运营商。(zh_CN)

_(Note: Kimberly Tripp is great at driving this point home about cost being an estimate. I always think of her when this comes up.)_
_(注意：金佰利·特里普（Kimberly Tripp）非常擅长将这一点作为估算成本。当它出现时我总是想起她。）_(zh_CN)

## There is no magic shortcut

## 没有神奇的捷径(zh_CN)

This all means there is no single shortcut when you’re looking at a complex plan, there’s no single shortcut that just lets you know exactly where to look all the time to find the secret info.
这一切都意味着当您查看复杂的计划时没有单一的快捷方式，没有单一的快捷方式可以让您确切地知道在哪里查找秘密信息。(zh_CN)

It’s just not that easy and looking at big complex plans can absolutely be time-consuming. It’s not that you’re dumb it’s that it’s hard, and there is a lot to look at.
这并不容易，看大型复杂计划绝对是非常耗时的。并不是说你很愚蠢，这很难，而且还有很多值得关注的地方。(zh_CN)

## Collect “compiled for” values

## 收集“编译为”值(zh_CN)

One of the things that doesn’t always show up right in front of you in the plan that I always want to collect though is to check the properties of the plan and see what was this plan compiled for in terms of parameter values. Not all queries are parameterized, so figuring out, “okay, look at the query does it have parameters?” is part of that. If it was a parameterized query, what were the compiled for values in a cached plan.
在我总是想要收集的计划中，并不总是出现在你面前的事情之一是检查计划的属性，并查看该计划在参数值方面编译的内容。并非所有查询都是参数化的，所以搞清楚，“好吧，查看查询是否有参数？”是其中的一部分。如果它是参数化查询，那么在缓存计划中为值编译的是什么。(zh_CN)

If you’re pulling plans out of the cache, make sure that you know what those are, and you make notes– okay I’m looking at a plan that was compiled for these parameter values. One of the things that’s tricky about analyzing execution plans is: when if you rerun the query for those “compiled for” values it may be really fast. So okay, well when the query was run when it was slow, was it being executed for different parameter values?
如果你将计划从缓存中拉出来，请确保你知道它们是什么，然后你做笔记 - 好吧我正在查看为这些参数值编译的计划。分析执行计划的一个棘手问题是：如果重新运行那些“编译为”值的查询，那么它可能非常快。好吧，当查询运行缓慢时，是否正在为不同的参数值执行？(zh_CN)

Here’s the bad news: those aren’t in the cached plan.
这是坏消息：那些不在缓存计划中。(zh_CN)

It may be that the query slow because if a parameter sniffing issue, where it’s compiled with certain values and then it’s slow when it runs with different values. The execution plan will give you the compiled for values, but you have to do a legwork to figure out what other values is this often executed with, and why may it have been slow. Maybe that requires doing tracing, maybe it requires looking in your application logs. There’s lots of different ways you can research this but that’s part of the piece where like all the information we need isn’t always in the plan.
可能是查询速度慢，因为如果参数嗅探问题，它使用某些值进行编译，然后在使用不同值运行时速度很慢。执行计划将为您提供已编译的值，但您必须做一些工作来确定通常执行的其他值，以及为什么它可能很慢。也许这需要进行跟踪，也许它需要查看您的应用程序日志。有很多不同的方法可以研究这个，但这是我们需要的所有信息并不总是在计划中的一部分。(zh_CN)

## Big picture: Interpreting a plan

## 大图：解读计划(zh_CN)

When I’m interpreting a plan big picture, here’s what I do. I analyze. I step back — sometimes literally zooming out to and look at the plan and try to figure out, how is the data flowing through this plan?
当我在解释计划大图时，这就是我的工作。我分析一下。我退后一步 - 有时会逐渐缩小并查看计划并试图弄清楚，数据是如何流经这个计划的？(zh_CN)

I’m thinking about where I may be able to start, looking at the whole shape of the plan. Then say okay I’m gonna zoom in now on certain areas that are high cost. This is where SQL Server thought it would be the most work.
我正在考虑我可以从哪里开始，看看整个计划的形状。然后说好的我现在要放大某些高成本的区域。这是 SQL Server 认为最有效的地方。(zh_CN)

Then I’m gonna step back and start asking questions about was that really the most work. I’m not gonna assume that those were the highest amount of work, I’m gonna look at those values it was compiled for and note, okay this is was optimized for these values, so if I’m executing this for different parameter values do I get different plans, and how do they compare? Maybe something I want to look at if I suspect that plan reuse is an issue.
然后我会退后一步，开始询问有关真正最重要的问题。我不会认为这些是最高的工作量，我会查看它编译的那些值并注意，好吧这是针对这些值进行优化的，所以如果我为不同的参数值执行此操作我有不同的计划，他们如何比较？如果我怀疑计划重用是一个问题，也许我想看看。(zh_CN)

I’m gonna start noting likely suspects for why I think different parts of the plan might be causing the query to be slow. Suspects include large row counts. Maybe these are large row counts from a high estimate if it’s just a cached plan. Maybe it’s just a high estimated row count, I don’t know for sure, was it right? Even if it is a lot of rows I don’t even know for sure if that was slow. It’s a possible suspect.
我将开始注意可能的嫌疑人为什么我认为计划的不同部分可能导致查询缓慢。嫌犯包括大排数。如果它只是一个缓存计划，也许这些是高估计的大排数。也许它只是一个很高的估计行数，我不确定，是不是？即使它是很多行，我也不确定这是否很慢。这可能是个嫌疑人。(zh_CN)

Do I see evidence of there being spills, or do I see estimates that I think might be way off, I see anti-patterns in the query plan, where I’m like, “we’ve got a lot of functions being used here,” or “we’ve got implicit conversions that may be causing a scan,” We’ll put these in as suspects.
我是否看到有溢出的证据，或者我看到我认为可能有所偏差的估计，我在查询计划中看到反模式，我喜欢，“我们在这里使用了很多函数，“或”我们有隐含的转换，可能会导致扫描，“我们将这些作为嫌疑人。(zh_CN)

## Then I set up a repro case and start testing things

## 然后我设置了一个 repro 案例并开始测试(zh_CN)

I have to check out all of these suspects, and I have to check them out even if they’re anti patterns.
我必须检查所有这些嫌疑人，即使他们是反模式我也必须检查它们。(zh_CN)

I have learned one lesson the hard way: when looking at execution plans to try to pinpoint what makes a query slow, this has happened to me so many times where, there’s something in the plan that’s just the glaring anti pattern. It’s a well-known thing you shouldn’t do. And you start testing things out, and that is NOT at all why the query is slow.
我已经从困难的方式中吸取了一个教训：在查看执行计划以试图找出导致查询缓慢的原因时，这种情况发生在我身上很多次，计划中的某些东西只是明显的反模式。这是你不应该做的众所周知的事情。而且你开始测试的东西，这根本不是查询缓慢的原因。(zh_CN)

But if you if you start harping on it too much, too early, then you really have egg on your face when you test out fixing that anti pattern and it’s still slow. Or maybe removing that anti pattern makes it even slower.
但是，如果你过早地开始咀嚼太多，那么当你测试修复反模式并且它仍然很慢时，你的脸上确实有蛋。或者可能删除反模式使其更慢。(zh_CN)

Just because something is an anti pattern don’t assume that is what’s making it slow, you’ve got to test it out and check it!
只是因为某种东西是一种反模式，并不认为这是使它变慢的原因，你必须测试它并检查它！(zh_CN)

## Most of your ‘likely suspects’ are going to be innocent

## 你的大多数“可能的嫌疑人”将是无辜的(zh_CN)

Execution plans and code are complicated, and you’re gonna come up with a lot of candidates that might be making the query slow, and they just don’t pan out. You’ve got to just keep hunting and figuring out, hey what is the thing that’s making this slow? If it’s part of the plan itself.
执行计划和代码很复杂，你会想出很多候选人可能会使查询变慢，他们只是没有成功。你必须继续狩猎和搞清楚，嘿这是什么让这个慢？如果它是计划本身的一部分。(zh_CN)

Setting up that repro case and testing it is really where you start interacting with the query plan. You start testing out your hypothesis. I made this change now what happens? Does it get faster? Does it get slower?
设置该 repro 案例并对其进行测试确实是您开始与查询计划进行交互的地方。你开始测试你的假设。我现在做了什么改变会发生什么？它变快了吗？变慢了吗？(zh_CN)

That’s really where you start the query tuning process. You set up hypotheses using the plan and related info. The actual tuning process is when you dig in setting up a repro.
这就是你开始查询调优过程的地方。您可以使用计划和相关信息设置假设。实际的调整过程就是你在设置一个 repro 时。(zh_CN)

It takes takes work, sometimes you can’t just run the query against production and sometimes you aren’t lucky enough to have a realistic development or staging database to work with. Sometimes you’ve got to set up staging data yourself outside of production so that you can test one part of a process. What if my query is slow in the middle of a nightly batch process and I’ve got to get it to the point where the data is right before that process begins in order to test the slow query? It’s absolutely worth it to do it, but yeah you have to do a little bit of work if you really want to test your hypothesis sometimes.
这需要花费时间，有时您不能仅仅针对生产运行查询，有时您没有足够的幸运能够使用真实的开发或临时数据库。有时您必须在生产之外自己设置分段数据，以便可以测试流程的一部分。如果我的查询在夜间批处理过程中很慢并且我必须在该过程开始之前将数据调到正确以便测试慢查询，该怎么办？这样做是绝对值得的，但是如果你真的想有时候测试你的假设，那么你必须做一些工作。(zh_CN)

Also, if I have a really complex query and I really want to work on part of it, I can try to break out that part of the query. Sometimes when I vastly simplify a query everything changes.
此外，如果我有一个非常复杂的查询，我真的想要处理它的一部分，我可以尝试打破查询的那一部分。有时当我大大简化查询时，一切都会发生变化。(zh_CN)

I may have to do a lot of work to reproduce the behavior that I’m seeing in the problematic execution plan to be able to test it in a smaller format.
我可能需要做很多工作才能重现我在有问题的执行计划中看到的行为，以便能够以更小的格式测试它。(zh_CN)

Sometimes I also have to execute a query multiple times to get one execution plan in cache, and then reuse it with different parameter values.
有时我还必须多次执行查询才能在缓存中获得一个执行计划，然后使用不同的参数值重复使用它。(zh_CN)

But all of these steps in setting up a repro and testing it are steps where I learn more about the nature of the execution plan how the data is really flowing through there, and why things are slow. So in this process of building the repro, I’m still working on the tuning process, I’m not wasting time.
但是，设置 repro 并对其进行测试的所有这些步骤都是我了解更多关于执行计划性质的步骤，以及数据在那里流动的原因，以及为什么事情变慢。因此，在构建 repro 的这个过程中，我仍在努力调整过程，我不是在浪费时间。(zh_CN)

## There are ways to save time

## 有办法节省时间(zh_CN)

If you have a monitoring tool that looks at your SQL Server and collects information like how much CPU and how many logical and physical reads do queries use, how long do they take, and what are their cached execution plans — that can be helpful because when you’re looking at a plan and you want that information of “okay, this time what parameter values was it executed with?” “How slow was it?” You have a place where you can go get those. You don’t have to setup a new trace or run a bunch of queries to figure it out.
如果你有一个监视工具，它可以查看你的 SQL Server 并收集信息，比如查询使用了多少 CPU 和多少逻辑和物理读取，它们需要多长时间，以及它们的缓存执行计划是什么 - 这可能会有所帮助，因为当你正在看一个计划，你想要的信息“好吧，这次执行的参数值是多少？”“它有多慢？”你有一个地方可以去那些。您不必设置新跟踪或运行一堆查询来解决问题。(zh_CN)

If you have SQL Server 2016 and higher the built in Query Store feature that you can enable per database collects much of this information. A lot of it is in aggregate form. It’s not as detailed, it is not a monitoring tool, but it has aggregate information that can help you figure out hey has this query had different execution plans over time? For different intervals, what were the execution statistics for that query plan in that interval? They are an aggregate, but they persist over restarts. They’re a lot more stable than just hoping the information you want is in memory, and that can be really helpful. It’s built right into the SQL Server.
如果您具有 SQL Server 2016 及更高版本，则可以为每个数据库启用的内置查询存储功能收集大部分此类信息。其中很多是汇总形式。它不是那么详细，它不是一个监控工具，但它有一些汇总信息可以帮助你弄清楚这个查询有不同的执行计划随着时间的推移？对于不同的时间间隔，该时间间隔内该查询计划的执行统计信息是什么？它们是聚合的，但它们会在重新启动时持续存在。它们比仅仅希望你想要的信息在内存中更稳定，这可能非常有用。它内置于 SQL Server 中。(zh_CN)

## There is an art to pulling this all together

## 将这一切拉到一起是一种艺术(zh_CN)

Which parts of the plan are taking the longest, what should you do to change the behavior? Right? Because even in an execution plan, even when I’ve analyzed, here here’s the part of it that’s slow, I then have to start making additional guesses about, okay well here’s the part that’s slow what do I do to make it faster?
计划的哪些部分花费的时间最长，您应该怎样做才能改变行为？对？因为即使在执行计划中，即使我已经分析过，这里的部分内容很慢，然后我必须开始进行额外的猜测，好吧，这里的部分很慢，我该怎样做才能让它变得更快？(zh_CN)

I’ve absolutely found it to be the case where I do a lot of work I figure out exactly which part of the complex plan is slow and then I stop and I’m like uh-oh, geez, how do I fix it???
我绝对发现这是我做大量工作的情况我确切地知道复杂计划的哪一部分很慢然后我停下来我就像呃 - 哦，天哪，我该如何解决？ ??(zh_CN)

There’s no obvious option, and I’ve got to be a little creative with saying, “okay, do I need to rewrite the query? Do I need to create an index? Do I need to change an index? Do I need to use a hint?” What are the things I can do to influence SQL Server’s behavior? Then test them.
没有明显的选择，我必须有点创意，说：“好吧，我需要重写查询吗？我需要创建索引吗？我需要更改索引吗？我是否需要使用提示？“我可以做些什么来影响 SQL Server 的行为？然后测试它们。(zh_CN)

Very often the thing I want to do to change the behavior may make the query slower, so I have to make sure that my change will reliably make the query faster, even when it’s optimized for different parameter values. Narrowing as you go through this process– narrowing down which parts of this query are making it slower– you’ll learn more about the query and you’re really not wasting time.
通常我想要改变行为的方法可能会使查询变慢，所以我必须确保我的更改能够可靠地使查询更快，即使它针对不同的参数值进行了优化。在您完成此过程时缩小范围 - 缩小此查询的哪些部分会使其变慢 - 您将了解有关查询的更多信息，而您实际上并不是在浪费时间。(zh_CN)

The more you learn about the query, you’re gonna use that information when you have to start guessing about how to make it faster as well, and trying to make it faster reliably.
您对查询了解的越多，当您必须开始猜测如何使其更快，并尝试使其更快可靠时，您将使用该信息。(zh_CN)

The more that you break down execution plans and dive in — it can be frustrating and you’re not gonna have a success every time, trust me I have not had success every time. I’ve looked at an execution plan, I need to figure out more information, I need to set up a repro, I need to get an actual plan, it will take work to do that.
你打破执行计划和潜入的越多 - 它可能令人沮丧，你每次都不会取得成功，相信我，我每次都没有成功。我看了一个执行计划，我需要找出更多的信息，我需要设置一个 repro，我需要得到一个实际的计划，它需要工作才能做到这一点。(zh_CN)

## The more you do this, you will become faster at it

## 你做得越多，你就会变得更快(zh_CN)

You’ll develop those suspects more quickly and you’ll come up with different tests you can do to see if you can make it faster more quickly as well. I think it really becomes more fun the more you do it, too.
您将更快地开发这些嫌疑人，并且您将提出不同的测试，以确定您是否可以更快地加快速度。我认为你做的越多越有趣。(zh_CN)

Thanks for joining me for Dear SQL DBA. I’m Kendra Little from [SQLWorkbooks.com](https://sqlworkbooks.com/)
感谢您加入我的亲爱的 SQL DBA。我是来自[SQLWorkbooks.com]的 Kendra Little（https://sqlworkbooks.com/）(zh_CN)

### _Related_

### _有关_(zh_CN)

{% endraw %}
