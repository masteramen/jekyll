---
layout: post
title:  "慕课网_《Hibernate缓存策略》学习总结"
title2:  "慕课网_《Hibernate缓存策略》学习总结"
date:   2017-01-01 23:56:08  +0800
source:  "http://www.jfox.info/%e6%85%95%e8%af%be%e7%bd%91hibernate%e7%bc%93%e5%ad%98%e7%ad%96%e7%95%a5%e5%ad%a6%e4%b9%a0%e6%80%bb%e7%bb%93.html"
fileName:  "20170101268"
lang:  "zh_CN"
published: true
permalink: "%e6%85%95%e8%af%be%e7%bd%91hibernate%e7%bc%93%e5%ad%98%e7%ad%96%e7%95%a5%e5%ad%a6%e4%b9%a0%e6%80%bb%e7%bb%93.html"
---
{% raw %}
# 慕课网_《Hibernate缓存策略》学习总结 


    了解缓存
    掌握Hibernate一级缓存的使用
    掌握Hibernate二级缓存的使用
    Hibernate一二级缓存的对比和总结

什么是缓存？

    并不是指计算机的内存或者CPU的一二级缓存
    缓存是为了降低应用程序对物理数据源访问的频次，从而提高应用程序的运行性能的一种策略

为什么使用缓存？

    ORM框架访问数据库的效率直接影响应用程序的运行速度，
        提升和优化ORM框架的执行效率至关重要
    Hibernate的缓存是提升和优化Hibernate执行效率的重要手段，
        所以学会Hibernate缓存的使用和配置是优化的关键

缓存的一般工作原理

![](/wp-content/uploads/2017/07/1500042405.png)

![](/wp-content/uploads/2017/07/1500042406.png)

# 第二章：不使用缓存的问题

## 2-1 不使用缓存的问题

使用Hibernate查询数据时

    第二次查询同一个对象时，并没有再次执行数据库查询
    在不同的session中多次查询同一个对象时，会执行多次数据库查询
    一级缓存中，持久化类的每个实例都具有唯一的OID
    

# 第三章：一级缓存介绍

## 3-1 一级缓存介绍

介绍Hibernate一级缓存

    Hibernate一级缓存又称为“session缓存”、“会话级缓存”
    通过Session从数据库查询实体时会把实体在内存中存储起来，
        下一次查询同一个实体时不再从数据库获取，而从内存中获取，这就是缓存
    一级缓存的生命周期和Session相同；Session销毁，它也销毁
    一级缓存中的数据可适用范围在当前会话之内

Hibernate一级缓存的API

    一级缓存无法取消，用两个方法管理
    evict()：用于将某个对象从Session的一级缓存中清除
    clear()：用于将一级缓存中的所有对象全部清除
    一级缓存也有些时候会对程序的性能产生影响

query.list()和query.iterate()区别

    1.返回的类型不同：
    list()返回List；iterate()返回Iterate。
    2.查询策略不同：
    list()直接发送sql语句，查询数据库；
    iterate()发送sql语句，从数据库取出id，然后先从缓存中根据id查找对应信息，
    有就返回结果，没有就根据id发送sql语句，查询数据库。
    3.返回对象不同：
    list()返回持久化实体类对象；
    iterate()返回代理对象。
    4.与缓存的关系不同：
    list()只缓存，但不使用缓存（查询缓存除外）；
    iterate()会使用缓存。
    

# 第四章：二级缓存应用

## 4-1 二级缓存应用

提出问题，如何解决？

    有些常用的数据，在一个session中缓存以后，我们希望在其它session中能够直接使用，而不用再次缓存怎么办？

使用更高级别的二级缓存，每个session共享的缓存

二级缓存的配置步骤

    添加二级缓存对应的jar包
    在hibernate的配置文件中添加Provider类的描述
    添加二级缓存的属性配置文件
    在需要被缓存的表所对应的映射文件中添加<cache/>标签

<cache/>标签的详细介绍

    usage：指定缓存策略，可选的策略包括：transactional，read-write，nonstrict-read-write或read-only
    include：指定是否缓存延迟加载的对象
    region：指定二级缓存区域名，可以进行个性化定制缓存策略
    

# 第五章：对比及总结

## 5-1 一二级缓存对比及总结

二级缓存的介绍

    二级缓存又称为“全局缓存”、“应用级缓存”
    二级缓存中的数据可适用范围是当前应用的所有会话
    二级缓存是可插拔式缓存，默认是EHCahe，
    还支持其它二级缓存组件如：Hashtable、OSCache、SwarmCache、JBoss TreeCache等

在通常情况下会将具有以下特征的数据放入到二级缓存中

    很少被修改的数据
    不是很重要的数据，允许出现偶尔并发的数据
    不会被并发访问的数据
    参数数据

一二级缓存的对比

![](/wp-content/uploads/2017/07/1500042407.png)

总结

    Hibernate的缓存能提高检索效率
    Hibernate的缓存分为一级缓存和二级缓存
    一级缓存是会话级缓存，二级缓存是应用级缓存
    Hibernate的缓存在提高检索的同时，也会增加服务器的消耗
    所以要注意缓存的使用策略
{% endraw %}
