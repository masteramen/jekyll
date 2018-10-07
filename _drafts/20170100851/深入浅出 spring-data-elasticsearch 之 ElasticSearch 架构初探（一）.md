---
layout: post
title:  "深入浅出 spring-data-elasticsearch 之 ElasticSearch 架构初探（一）"
title2:  "深入浅出 spring-data-elasticsearch 之 ElasticSearch 架构初探（一）"
date:   2017-01-01 23:49:11  +0800
source:  "http://www.jfox.info/shen-ru-qian-chu-spring-data-elasticsearch-zhi-elasticsearch-jia-gou-chu-tan-yi.html"
fileName:  "20170100851"
lang:  "zh_CN"
published: true
permalink: "shen-ru-qian-chu-spring-data-elasticsearch-zhi-elasticsearch-jia-gou-chu-tan-yi.html"
---
{% raw %}
**本文目录**
一、Elasticsearch 基本术语
1.1 文档（Document）、索引（Index）、类型（Type）文档三要素
1.2 集群（Cluster）、节点（Node）、分片（Shard）分布式三要素
二、Elasticsearch 工作原理
2.1 文档存储的路由
2.2 如何健康检查 2.3 如何水平扩容 三、小结

    GET [http://127.0.0.1:9200/_cluster/stats](http://www.jfox.info/go.php?url=http://127.0.0.1:9200/_cluster/stats) 
    {
       "cluster_name":          "elasticsearch",
       "status":                "green", 
       "timed_out":             false,
       "number_of_nodes":       1,
       "number_of_data_nodes":  1,
       "active_primary_shards": 0,
       "active_shards":         0,
       "relocating_shards":     0,
       "initializing_shards":   0,
       "unassigned_shards":     0
    }

status 字段是需要我们关心的。状态可能是下列三个值之一：

    green
    所有的主分片和副本分片都已分配。你的集群是 100% 可用的。
    yellow
    所有的主分片已经分片了，但至少还有一个副本是缺失的。不会有数据丢失，所以搜索结果依然是完整的。高可用会弱化把 yellow 想象成一个需要及时调查的警告。
    red
    至少一个主分片（以及它的全部副本）都在缺失中。这意味着你在缺少数据：搜索只能返回部分数据，而分配到这个分片上的写入请求会返回一个异常。
    

active_primary_shards 集群中的主分片数量
active_shards 所有分片的汇总值
relocating_shards 显示当前正在从一个节点迁往其他节点的分片的数量。通常来说应该是 0，不过在 Elasticsearch 发现集群不太均衡时，该值会上涨。比如说：添加了一个新节点，或者下线了一个节点。
initializing_shards 刚刚创建的分片的个数。
unassigned_shards 已经在集群状态中存在的分片。
**2.3 如何水平扩容**
主分片在索引创建已经确定。读操作可以同时被主分片和副分片处理。因此，更多的分片，会拥有更高的吞吐量。自然，需要增加更多的硬件资源支持吞吐量。
说明，这里无法提高性能，因为每个分片获得的资源会变少。
动态调整副本分片数，按需伸缩集群，比如把副本数默认值为 1 增加到 2：

    PUT /blogs/_settings
    {
       "number_of_replicas" : 2
    }

三、小结
简单初探了下 ElasticSearch 的相关内容。后面会主要落地到实战，关于 spring-data-elasticsearch 这块的实战。
最后，《 深入浅出 spring-data-elasticsearch 》小连载目录如下：
深入浅出 spring-data-elasticsearch – ElasticSearch 架构初探（一）
深入浅出 spring-data-elasticsearch – 概述（二）
深入浅出 spring-data-elasticsearch – 基本案例详解（三）
深入浅出 spring-data-elasticsearch – 复杂案例详解（四）
深入浅出 spring-data-elasticsearch – 架构原理以及源码浅析（五）
资料：
官方《Elasticsearch: 权威指南》
[https://www.elastic.co/guide/c … .html](http://www.jfox.info/go.php?url=https://www.elastic.co/guide/cn/elasticsearch/guide/current/index.html)
{% endraw %}
