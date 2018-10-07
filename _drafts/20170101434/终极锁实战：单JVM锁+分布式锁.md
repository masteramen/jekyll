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
    40            }
    4142while (true) {
    43long currentTime = System.currentTimeMillis();
    44                 ttl = tryAcquire(leaseTime, unit, threadId);
    45// lock acquired46if (ttl == null) {
    47returntrue;
    48                }
    4950                 time -= (System.currentTimeMillis() - currentTime);
    51if (time <= 0) {
    52                    acquireFailed(threadId);
    53returnfalse;
    54                }
    5556// waiting for message57                 currentTime = System.currentTimeMillis();
    58if (ttl >= 0 && ttl < time) {
    59                    getEntry(threadId).getLatch().tryAcquire(ttl, TimeUnit.MILLISECONDS);
    60                 } else {
    61                    getEntry(threadId).getLatch().tryAcquire(time, TimeUnit.MILLISECONDS);
    62                }
    6364                 time -= (System.currentTimeMillis() - currentTime);
    65if (time <= 0) {
    66                    acquireFailed(threadId);
    67returnfalse;
    68                }
    69            }
    70         } finally {
    71            unsubscribe(subscribeFuture, threadId);
    72        }
    73//        return get(tryLockAsync(waitTime, leaseTime, unit));74     }

上述方法，调用加锁的逻辑就是在tryAcquire(leaseTime, unit, threadId)中，如下图：

    1private Long tryAcquire(long leaseTime, TimeUnit unit, long threadId) {
    2return get(tryAcquireAsync(leaseTime, unit, threadId));//tryAcquireAsync返回RFutrue
    3 }

    tryAcquireAsync中commandExecutor.evalWriteAsync就是咱们加锁核心方法了

     1 <T> RFuture<T> tryLockInnerAsync(long leaseTime, TimeUnit unit, long threadId, RedisStrictCommand<T> command) {
     2         internalLockLeaseTime = unit.toMillis(leaseTime);
     3 4return commandExecutor.evalWriteAsync(getName(), LongCodec.INSTANCE, command,
     5                   "if (redis.call('exists', KEYS[1]) == 0) then " +
     6                       "redis.call('hset', KEYS[1], ARGV[2], 1); " +
     7                       "redis.call('pexpire', KEYS[1], ARGV[1]); " +
     8                       "return nil; " +
     9                   "end; " +
    10                   "if (redis.call('hexists', KEYS[1], ARGV[2]) == 1) then " +
    11                       "redis.call('hincrby', KEYS[1], ARGV[2], 1); " +
    12                       "redis.call('pexpire', KEYS[1], ARGV[1]); " +
    13                       "return nil; " +
    14                   "end; " +
    15                   "return redis.call('pttl', KEYS[1]);",
    16                     Collections.<Object>singletonList(getName()), internalLockLeaseTime, getLockName(threadId));
    17     }

如上图，已经到了redis命令了

**加锁：**

- KEYS[1] ：需要加锁的key，这里需要是字符串类型。
- ARGV[1] ：锁的超时时间，防止死锁
- ARGV[2] ：锁的唯一标识，*（UUID.randomUUID()） + “:” + threadId*

     1// 检查是否key已经被占用，如果没有则设置超时时间和唯一标识，初始化value=1 2if (redis.call('exists', KEYS[1]) == 0) 
     3then  
     4 redis.call('hset', KEYS[1], ARGV[2], 1); 
     5 redis.call('pexpire', KEYS[1], ARGV[1]);  
     6return nil; 
     7end; 
     8// 如果锁重入,需要判断锁的key field 都一直情况下 value 加一 9if (redis.call('hexists', KEYS[1], ARGV[2]) == 1) 
    10then 
    11 redis.call('hincrby', KEYS[1], ARGV[2], 1);
    12 redis.call('pexpire', KEYS[1], ARGV[1]);//锁重入重新设置超时时间13return nil; 
    14end; 
    15// 返回剩余的过期时间16return redis.call('pttl', KEYS[1]);

以上的方法，当返回空是，说明获取到锁，如果返回一个long数值（pttl 命令的返回值），说明锁已被占用，通过返回剩余时间，外部可以做一些等待时间的判断和调整。

不再分析解锁步骤，直接贴上解锁的redis 命令

**解锁：**

– KEYS[1] ：需要加锁的key，这里需要是字符串类型。

– KEYS[2] ：redis消息的ChannelName,一个分布式锁对应唯一的一个channelName:*“redisson_lock__channel__{” + getName() + “}”*

– ARGV[1] ：reids消息体，这里只需要一个字节的标记就可以，主要标记redis的key已经解锁，再结合redis的Subscribe，能唤醒其他订阅解锁消息的客户端线程申请锁。

– ARGV[2] ：锁的超时时间，防止死锁

– ARGV[3] ：锁的唯一标识，*（UUID.randomUUID()） + “:” + threadId*

     1// 如果key已经不存在，说明已经被解锁，直接发布（publihs）redis消息 2if (redis.call('exists', KEYS[1]) == 0) 
     3then
     4     redis.call('publish', KEYS[2], ARGV[1]);
     5return 1;
     6end;
     7// key和field不匹配，说明当前客户端线程没有持有锁，不能主动解锁。 8if (redis.call('hexists', KEYS[1], ARGV[3]) == 0)
     9then 
    10return nil;
    11end; 
    12// 将value减113 local counter = redis.call('hincrby', KEYS[1], ARGV[3], -1); 
    14// 如果counter>0说明锁在重入，不能删除key15if (counter > 0)  
    16then
    17     redis.call('pexpire', KEYS[1], ARGV[2]);                             
    18return 0; 
    19else20// 删除key并且publish 解锁消息21     redis.call('del', KEYS[1]);                            
    22     redis.call('publish', KEYS[2], ARGV[1]); 
    23return 1; 
    24end; 
    25return nil;

#### 实战：

1.创建RedissonClient

    1 Config config = new Config();
    2 config.useSingleServer().setAddress(redisHost + ":" + redisPort)
    3.setPassword(redisPassword)
    4 .setDatabase(redisDatabase);//可以不设置，看业务是否需要隔离 0-15共16个数据库5 RedissonClient redisson = Redisson.create(config);

2.加锁解锁

     1 1.加锁
     2try {
     3//根据key获取锁实例，非公平锁 4     RLock lock = redissonClient.getLock(key);
     5//在leaseTime时间内阻塞获取锁，获取锁后持有锁直到leaseTime租期结束（除非手动unLock释放锁）。 6return lock.tryLock(waitTime, leaseTime, timeUnit);
     7 } catch (Exception e) {
     8     logger.error("redis获取分布式锁异常;key=" + key + ",waitTime=" + waitTime + ",leaseTime=" + leaseTime +
     9             ",timeUnit=" + timeUnit, e);
    10returnfalse;
    11}
    12 2.解锁
    13 RLock lock = redissonClient.getLock(key);
    14 lock.unlock();

####  特点：

逻辑并不复杂, 但是通过记录客户端ID和线程ID来唯一标识线程, 实现重入功能, 通过pub sub功能来减少空转.

实现了Lock的大部分功能, 提供了特殊情况方法(如:强制解锁, 判断当前线程是否已经获取锁, 超时强制解锁等功能), 可重入, 减少重试.

使用依赖Redisson, 而Redisson依赖netty, 如果简单使用, 引入了较多的依赖, pub sub的实时性需要测试, 没有监控等功能, 查问题麻烦, 统计功能也没有

### 2）基于zookeeper实现

#### 原理：

每个客户端（每个JVM中共用一个客户端实例，单例模式）对某个方法加锁时，在zookeeper上的与该方法对应的指定节点的目录下，生成一个唯一的瞬时有序节点。判断是否获取锁的方式很简单，只需要判断有序节点中序号最小的一个。当释放锁的时候，只需将这个瞬时节点删除即可。同时，可以避免服务宕机导致的锁无法释放，而产生的死锁问题（临时节点服务宕机节点就没了）。

#### 特点：

单个JVM可实现按照请求顺序获取锁，分布式下无法保证全部顺序：顺序创建节点-》获取锁时获取第一个节点（节点名有序）。一般实现分布式锁肯定会是有多个JVM即多个客户端那么无法保证按照请求时间顺序获取锁，因为每个JVM中服务请求时间不一定一致。（节点名和请求时间有关）

#### 实战：

**Curator组件概览：**

- Recipes：通用ZooKeeper技巧(“recipes”)的实现. 建立在Curator Framework之上
- Framework：简化zookeeper使用的高级. 增加了很多建立在zooper之上的特性. 管理复杂连接处理和重试操作
- Utilities：各种工具类
- Client：ZooKeeper本身提供的类的替代者。负责底层的开销以及一些工具
- Errors：Curator怎样来处理错误和异常
- Extensions：curator-recipes包实现了通用的技巧，这些技巧在ZooKeeper文档中有介绍。为了避免是这个包(package)变得巨大，recipes/applications将会放入一个独立的extension包下。并使用命名规则curator-x-name

我们主要使用的Client、Framework、Recipes三个组件。

     1package distributed.lock.zk;
     2 3import java.text.SimpleDateFormat;
     4import java.util.Date;
     5import java.util.concurrent.TimeUnit;
     6 7import org.apache.curator.framework.CuratorFramework;
     8import org.apache.curator.framework.CuratorFrameworkFactory;
     9import org.apache.curator.framework.recipes.locks.InterProcessMutex;
    10import org.apache.curator.retry.RetryNTimes;
    1112/**13 * 
    14 * @ClassName:CuratorDistrLockTest
    15 * @Description:Curator包实现zk分布式锁
    16 * @author diandian.zhang
    17 * @date 2017年7月11日下午12:43:44
    18*/1920publicclass CuratorDistrLock {
    2122privatestaticfinal String ZK_ADDRESS = "192.168.50.253:2181";//地址23privatestaticfinal String ZK_LOCK_PATH = "/zktest";//path24static SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    2526publicstaticvoid main(String[] args)  {
    27try {
    28//创建zk客户端29             CuratorFramework client = CuratorFrameworkFactory.newClient(
    30                    ZK_ADDRESS,
    31new RetryNTimes(10, 5000)
    32            );
    33//开启34            client.start();
    35             System.out.println("zk client start successfully!");
    36//依赖ZK生成的互斥锁，公平锁（按照请求顺序获取锁）37             InterProcessMutex lock = new InterProcessMutex(client, ZK_LOCK_PATH);
    38             Thread t1 = new Thread(() -> {
    39                 doWithLock(client,lock);//函数式编程40             }, "t1");
    41             Thread t2 = new Thread(() -> {
    42                doWithLock(client,lock);
    43             }, "t2");
    44             Thread t3 = new Thread(() -> {
    45                doWithLock(client,lock);
    46             }, "t3");
    47//启动线程48            t1.start();
    49            t2.start();
    50            t3.start();
    51         } catch (Exception e) {
    52            e.printStackTrace();
    53        }
    54    }
    5556/**57     * 
    58     * @Description 线程执行函数体
    59     * @param client
    60     * @param lock
    61     * @author diandian.zhang
    62     * @date 2017年7月12日下午6:00:53
    63     * @since JDK1.8
    64*/65privatestaticvoid doWithLock(CuratorFramework client,InterProcessMutex lock) {
    66         Boolean b = false;//是否持有锁67try {
    68             System.out.println("进入线程="+Thread.currentThread().getName()+":"+time.format(new Date()));
    69//花1秒时间尝试获取锁，成功70if (lock.acquire(1, TimeUnit.SECONDS)) {
    71                 b = true;
    72                 System.out.println(Thread.currentThread().getName() + " 获取锁成功！，执行需要加锁的任务"+time.format(new Date()));
    73                 Thread.sleep(2000L);//休息2秒模拟执行需要加锁的任务
    74//获取锁超时75             }else{
    76                 System.out.println(Thread.currentThread().getName() + " 获取锁超时！"+time.format(new Date()));
    77            }
    78         } catch (Exception e) {
    79            e.printStackTrace();
    80         } finally {
    81try {
    82                 System.out.println(Thread.currentThread().getName() + " 释放锁"+time.format(new Date()));
    83//当前线程获取到锁，那么最后需要释放锁84if(b){
    85                    lock.release();
    86                }
    87             } catch (Exception e) {
    88                e.printStackTrace();
    89            }
    90        }
    91    }
    9293 }

执行结果：

    zk client start successfully!
    进入线程=t2:2017-07-1311:13:13
    进入线程=t1:2017-07-1311:13:13
    进入线程=t3:2017-07-1311:13:13
    t2 获取锁成功！，执行需要加锁的任务2017-07-1311:13:23
    t2 释放锁2017-07-1311:13:25
    t3 获取锁成功！，执行需要加锁的任务2017-07-1311:13:25
    t3 释放锁2017-07-1311:13:27
    t1 获取锁成功！，执行需要加锁的任务2017-07-1311:13:27
    t1 释放锁2017-07-1311:13:29

## 4.总结比较

### 一级锁分类

### 二级锁分类

### 锁名称

### 特性

### 是否推荐

### 单JVM锁
基于JVM源生synchronized关键字实现
synchronized同步锁
 适用于低并发的情况，性能稳定。新手推荐基于JDK实现，需显示获取锁，释放锁
ReentrantLock可重入锁
 适用于低、高并发的情况，性能较高 建议需要手动操作线程时使用。
ReentrantReadWriteLock

可重入读写锁
 适用于读多写少的情况。性能高。 老司机推荐
StampedLock戳锁
 JDK8才有，适用于高并发且读远大于写时，支持乐观读，票据校验失败后可升级悲观读锁，性能极高！ 老司机推荐
### 分布式锁

基于数据库锁实现

**悲观锁：select for update**
 sql直接使用，但可能出现死锁 不推荐
**乐观锁：版本控制**
 自己实现字段版本控制 新手推荐
基于缓存实现

org.redisson
 支持除了分布式锁外还实现了分布式对象、分布式集合等极端强大的功能 老司机推荐
基于zookeeper实现

org.apache.curator zookeeper
 除支持分布式锁外，还实现了master选举、节点监听（）、分布式队列、Barrier、AtomicLong等计数器 老司机推荐
{% endraw %}
