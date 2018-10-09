---
layout: post
title:  "Sharding-JDBC 1.5.0 正式发布：全新 SQL 解析发动机"
title2:  "Sharding-JDBC 1.5.0 正式发布：全新 SQL 解析发动机"
date:   2017-01-01 23:58:53  +0800
source:  "https://www.jfox.info/shardingjdbc150%e6%ad%a3%e5%bc%8f%e5%8f%91%e5%b8%83%e5%85%a8%e6%96%b0sql%e8%a7%a3%e6%9e%90%e5%8f%91%e5%8a%a8%e6%9c%ba.html"
fileName:  "20170101433"
lang:  "zh_CN"
published: true
permalink: "2017/shardingjdbc150%e6%ad%a3%e5%bc%8f%e5%8f%91%e5%b8%83%e5%85%a8%e6%96%b0sql%e8%a7%a3%e6%9e%90%e5%8f%91%e5%8a%a8%e6%9c%ba.html"
---
{% raw %}
经过了 1.5.0.M1-1.5.0.M3 这 3 次里程碑版本的发布，Sharding-JDBC 1.5.0 稳定版终于正式发布。 

Sharding-JDBC 1.5.0 版本是一次里程碑式升级，工作量巨大，Sharding-JDBC 截止到 1.4.2 之前所有的提交次数为 385 次，而 1.5.0 版本的总共提交次数为 804 次。

Sharding-JDBC 定位为水平扩展数据库中间件以及云原生基础开发套件，将全力专注于 OLTP 和本地内联事务处理以及数据库访问层治理。

#### 本次里程碑版本的重要更新是：

1. 
数据库全支持，包括 MySQL、Oracle、SQLServer 和 PostgreSQL 

2. 
全新的 SQL 解析模块，去掉对 Druid 的依赖。仅解析分片上下文，对于 SQL 采用”半理解”理念，进一步提升性能和兼容性，并降低代码复杂度 

3. 
全新的 SQL 改写模块，增加优化性改写模块 

4. 
全新的 SQL 归并模块，重构为流式、内存以及装饰者 3 种归并引擎 

Sharding-JDBC 从 2016 年开源至今，已发布了 16 个版本，其中包含 5 个里程碑版本升级。在经历了整体架构的数次精炼以及稳定性打磨后，如今它已积累了足够的底蕴，相信可以成为开发者选择技术组件时的一个参考。真诚邀请感兴趣的人关注和参与。
{% endraw %}
