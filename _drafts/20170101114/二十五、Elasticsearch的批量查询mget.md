---
layout: post
title:  "二十五、Elasticsearch的批量查询mget"
title2:  "二十五、Elasticsearch的批量查询mget"
date:   2017-01-01 23:53:34  +0800
source:  "https://www.jfox.info/%e4%ba%8c%e5%8d%81%e4%ba%94elasticsearch%e7%9a%84%e6%89%b9%e9%87%8f%e6%9f%a5%e8%af%a2mget.html"
fileName:  "20170101114"
lang:  "zh_CN"
published: true
permalink: "2017/%e4%ba%8c%e5%8d%81%e4%ba%94elasticsearch%e7%9a%84%e6%89%b9%e9%87%8f%e6%9f%a5%e8%af%a2mget.html"
---
{% raw %}
**1、什么是批量查询**
就是一次性查出来N条所需数据，而不是多次网络请求的去查询。就是java中的接口返回list

**2、批量查询有什么好处？**
比如说要查询100条数据，那么就要发送100次网络请求，这个开销还是很大的，如果进行批量查询的话，查询100条数据，就只要发送1次网络请求，网络请求的性能开销缩减100倍。

**3、mget语法**

需求：要查询出test_index/test_type下面id为1和2的数据

（1）一条一条的查询
`GET /test_index/test_type/1`
`GET /test_index/test_type/2`
发了两次网络请求。

（2）mget批量查询

    GET /_mget
    {
      "docs" : [
        {
          "_index" : "test_index",
          "_type" : "test_type",
          "_id" : 11
        },
        {
          "_index" : "test_index",
          "_type" : "test_type",
          "_id" : 10
        }
      ]
    }

返回结果（是个list）：

    {
      "docs": [
        {
          "_index": "test_index",
          "_type": "test_type",
          "_id": "11",
          "_version": 1,
          "found": true,
          "_source": {
            "num": 0,
            "tags": []
          }
        },
        {
          "_index": "test_index",
          "_type": "test_type",
          "_id": "10",
          "_version": 4,
          "found": true,
          "_source": {
            "test_field1": "test1",
            "test_field2": "updated test2"
          }
        }
      ]
    }

（3）如果查询的document是一个index下，但是不同的type的话

    GET /test_index/_mget
    {
      "docs" : [
        {
          "_type" : "test_type",
          "_id" : 10
        },
        {
          "_type" : "test_type",
          "_id" : 11
        }  
      ]
    }

返回结果一样的

（4）如果查询的数据都在同一个index下且同一个type下，那么直接如下

    GET /test_index/test_type/_mget
    {
      "ids" : [11,10]
    }

返回结果一样的

**再次强调mget的重要性：一般来说，在进行查询的时候，如果一次性要查询多条数据的话，那么一定要用batch批量操作的api，尽可能减少网络开销次数，可能可以将性能提升数倍，甚至数十倍，非常重要！！！**

若有兴趣，欢迎来加入群，【Java初学者学习交流群】：458430385，此群有Java开发人员、UI设计人员和前端工程师。有问必答，共同探讨学习，一起进步！
{% endraw %}
