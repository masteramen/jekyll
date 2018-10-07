---
layout: post
title:  "终极锁实战：单JVM锁+分布式锁"
title2:  "终极锁实战：单JVM锁+分布式锁"
date:   2017-01-01 23:58:54  +0800
source:  "http://www.jfox.info/%e7%bb%88%e6%9e%81%e9%94%81%e5%ae%9e%e6%88%98%e5%8d%95jvm%e9%94%81%e5%88%86%e5%b8%83%e5%bc%8f%e9%94%81.html"
fileName:  "20170101434"
lang:  "zh_CN"
published: true
permalink: "%e7%bb%88%e6%9e%81%e9%94%81%e5%ae%9e%e6%88%98%e5%8d%95jvm%e9%94%81%e5%88%86%e5%b8%83%e5%bc%8f%e9%94%81.html"
---
{% raw %}
[只会一点java](http://www.jfox.info/go.php?url=http://www.cnblogs.com/dennyzhangdd/) 阅读( 
…) 评论( 
…) 
[编辑](http://www.jfox.info/go.php?url=https://i.cnblogs.com/EditPosts.aspx?postid=7133653)[收藏](#)
目录

1.前言

2.单JVM锁

3.分布式锁

4.总结

=========正文分割线=================

## 1.前言

锁就像一把钥匙，需要加锁的代码就像一个房间。出现互斥操作的场景：多人同时想进同一个房间争抢这个房间的钥匙（只有一把），一人抢到钥匙，其他人都等待这个人出来归还钥匙，此时大家再次争抢钥匙循环下去。

本篇用java语言分析锁的原理（简单描述）和应用（详细代码），根据锁的作用范围分为：JVM锁和分布式锁。如理解有误之处，还请指出。

## 2.单JVM锁（进程级别）

程序部署在一台服务器上，当容器启动时（例如tomcat），一台JVM就运行起来了。第一部门分析的锁均只能在单JVM下生效。因为最终锁定的是某个对象，这个对象生存在JVM中，自然锁只能锁单JVM。这一点很重要。如果你的服务只部署一个实例，那么恭喜你，用以下几种锁就可以了。

1.synchronized同步锁

2.ReentrantLock重入锁

3.ReadWriteLock读写锁

4.StampedLock戳锁

由于之前已经详细分析过原理+使用，各位直接坐飞机吧：[同步中的四种锁synchronized、ReentrantLock、ReadWriteLock、StampedLock](http://www.jfox.info/go.php?url=http://www.cnblogs.com/dennyzhangdd/p/6925473.html)

## 3.分布式锁（多服务节点，多进程）

### 3.1基于数据库锁实现

场景举例：

卖商品，先查询库存>0,更新库存-1。

 1.悲观锁：**select for update**

    确保以下2步骤在一个事务中：
    

    SELECT * FROM tb_product_stock WHERE product_id=1 FOR UPDATE--->product_id有索引，锁行.加锁（注:条件字段必须有索引才能锁行，否则锁表，且最好用explain查看一下是否使用了索引，因为有一些会被优化掉最终没有使用索引）
    

    UPDATE tb_product_stock SET number=number-1 WHERE product_id=1--->更新库存-1.解锁
    

 2.乐观锁：**版本控制**，选一个`字段作为版本控制字段，更新前查询一次，更新时该字段作为更新条件`。不同业务场景，版本控制字段，可以0 1控制，也可以+1控制，也可以-1控制，这个随意。

    确保以下2步骤在一个事务中：
    SELECT number FROM tb_product_stock WHERE product_id=1--》查询库存总数，不加锁
    

    UPDATE tb_product_stock SET number=number-1 WHERE product_id=1 AND number=第一步查询到的库存数--》number字段作为版本控制字段
    

### 3.2基于缓存实现（redis，memcached）

#### 原理：

redisson开源jar包,提供了很多功能，其中就包含分布式锁。

核心org.redisson.api.RLock接口封装了分布式锁的获取和释放。源码如下：

     1@Override
     2publicboolean tryLock(long waitTime, long leaseTime, TimeUnit unit) throws InterruptedException {
     3long time = unit.toMillis(waitTime);
     4long current = System.currentTimeMillis();
     5finallong threadId = Thread.currentThread().getId();
     6Long ttl = tryAcquire(leaseTime, unit, threadId);//申请锁，返回还剩余的锁过期时间 7// lock acquired 8if (ttl == null) {
     9returntrue;
    10        }
    1112         time -= (System.currentTimeMillis() - current);
    13if (time <= 0) {
    14            acquireFailed(threadId);
    15returnfalse;
    16        }
    1718         current = System.currentTimeMillis();
    19final RFuture<RedissonLockEntry> subscribeFuture = subscribe(threadId);
    20if (!await(subscribeFuture, time, TimeUnit.MILLISECONDS)) {
    21if (!subscribeFuture.cancel(false)) {
    22                 subscribeFuture.addListener(new FutureListener<RedissonLockEntry>() {
    23                    @Override
    24publicvoid operationComplete(Future<RedissonLockEntry> future) throws Exception {
    25if (subscribeFuture.isSuccess()) {
    26                            unsubscribe(subscribeFuture, threadId);
    27                        }
    28                    }
    29                });
    30            }
    31            acquireFailed(threadId);
    32returnfalse;
    33        }
    3435try {
    36             time -= (System.currentTimeMillis() - current);
    37if (time <= 0) {
    38                acquireFailed(threadId);
    39returnfalse;
{% endraw %}
