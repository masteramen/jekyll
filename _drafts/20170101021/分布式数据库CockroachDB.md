---
layout: post
title:  "分布式数据库CockroachDB"
title2:  "分布式数据库CockroachDB"
date:   2017-01-01 23:52:01  +0800
source:  "https://www.jfox.info/%e5%88%86%e5%b8%83%e5%bc%8f%e6%95%b0%e6%8d%ae%e5%ba%93cockroachdb.html"
fileName:  "20170101021"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%88%86%e5%b8%83%e5%bc%8f%e6%95%b0%e6%8d%ae%e5%ba%93cockroachdb.html"
---
{% raw %}
CockroachDB（中文名蟑螂DB，所以又可以称为小强DB），是构建于事务处理及强一致性KV存储上的分布式SQL数据库，支持水平扩展、自动容错处理、强一致性事务，并且提供SQL接口用于数据处理，是Google Spanner/F1的开源实现。
CockroachDB适用于应用对数据要求精确、可靠、完全正确的场景，支持自动复制、均匀分布、基于极小配置的数据恢复，可用于分布式的、可复制的联机事务处理（OLTP），多数据中心的部署，私有云的基础构建，它不适用于读少写多的场景，可以用内存数据库来代替，也不适用于复杂的join查询，重量级的数据分析及联机分析处理（OLAP）。

**扩展性**
可运行于本地机器、单服务、开发集群中，在运行的集群中扩容只需指定一个新的节点即可。在KV层，CockroachDB开始是单一的空区域，单一达到阈值（64M）时数据被分裂为两个区域，每块覆盖整个键值空间的一个连续段，当新的数据进入时继续分裂，目的是保持相对小及一致的区域大小。集群跨越多个节点时，新分裂的区域自动平衡到有更多容量的节点中，CockroachDB使用对等的gossip协议使得节点间可以交换网络地址、存储容量等信息。
{% endraw %}
