---
layout: post
title:  "ThreadLocal 导致Full GC 分析"
title2:  "ThreadLocal 导致Full GC 分析"
date:   2017-01-01 23:59:20  +0800
source:  "https://www.jfox.info/threadlocal%e5%af%bc%e8%87%b4fullgc%e5%88%86%e6%9e%90.html"
fileName:  "20170101460"
lang:  "zh_CN"
published: true
permalink: "2017/threadlocal%e5%af%bc%e8%87%b4fullgc%e5%88%86%e6%9e%90.html"
---
{% raw %}
难得出现了一次Full GC，抓住机会分析了一次。

### 事件回顾

之前服务线上总共有6台机器，其中2台机器为4核CPU+4G内存，另外4台机器为4核CPU+8G内存。

- 2017-08-01 早上11:00 开始FullGC报警，同时有两台，均为4G内存机器，其他8G内存机器未发现报警。监控无业务报警及Exception。
- 接到报警之后，马上摘除了一台机器留作jvm分析，另外一台重启。
- dump 机器的堆栈信息
- 观察重启之后的机器情况，以及其他机器的运行情况，均未发现异常迹象。

事件背景

- 这个服务已经有超过一周的时间未发布也未重启过，之前一直没有出现过问题。
- 当时周二，在一周时间内是流量较低的时候；发生在早上，也是一天内流量较小的时候。

周维度qps情况
![](/wp-content/uploads/2017/08/1501770753.png)
天维度qps情况
![](/wp-content/uploads/2017/08/1501770754.png)
### 事件分析

 在dump文件下来之后，使用 [MAT](https://www.jfox.info/go.php?url=http://www.eclipse.org/mat/) 打开dump文件。 

- 
内存泄漏分析结果：

333 instances of “java.lang.Thread”, loaded by “<system class loader>” occupy 575,044,016 (89.85%) bytes.

Keywords

java.lang.Thread

![](/wp-content/uploads/2017/08/1501770755.png)
根据分析，应该是有大量的线程未被会收掉，且配置监控系统的监控见过可以发现：
![](/wp-content/uploads/2017/08/1501770756.png)
- 从运行图中可以发现在每次FullGC之后，oldgen里面的内存并没有释放，也就是说FullGC也没有起到回收内存的作用。由此可见，占用oldgen的对象仍然被持有。
- 
jvm稳定的有5个左右的线程处于blocked状态。

![](/wp-content/uploads/2017/08/1501770757.png)再来看看mat中对问题线程的分析，发现有大量相同大小的线程，根据线程命名可以发现是中间件组提供的RPC线程。因为线程中由嵌套了大量线程，因此初步怀疑有两个可能：

1. 代码里面出现了死循环，再极端情况下导致出现case
2. RPC框架出现问题

首先针对第一个可能，因为近一周都没有上线和重启，且经历过qps较高和客服case较高的时候，且检查代码之后也未曾发现循环调用，因此这种可能性很小。

现在通过内存泄漏分析已经知道，thread持有了大量占用内存的引用，但是到底持有了什么类型的对象呢，继续使用mat来分析占用内存最大的类型。
![](/wp-content/uploads/2017/08/1501770767.png)
发现占用内存最大的是mtrace.KVAnnotation和LinkedList$Node，其中mtrace是中间件提供一个打点组件，一般情况下也只会在RPC组件里使用，业务代码里是不会涉及到的。
 知道了占用内存最大的类，却不清楚调用链是什么样子的，而且mtrace.KVAnnotation和LinkedList$Node是否有关系也不清楚。使用mat一直没有找到相关的分析功能，因此换成 [VisualVM](https://www.jfox.info/go.php?url=https://visualvm.github.io/) 继续分析。 
![](/wp-content/uploads/2017/08/15017707671.png)从VisualVM的分析结果来看，mtrace.KVAnnotation引用了LinkedList$Node，而且从调用信息来看，mtrace.KVAnnotation保存了一定的业务信息。

至此，基本确定了是mtrace导致了问题。
因此联系了中间件的相关同事，来定位问题。联想到前一天（07-31）RPC框架组曾打开mtrace开关，当时造成了事故。这个服务当时有exception报警，但并未影响业务。
#### 确认问题

考虑到RPC框架在短暂打开mtrace之后立即关闭了，如果出问题只可能是其中使用了ThreadLocal变量，且未清理。如果推论成立，那其他的机器这种内存占用会一直上升，中间不重启，其他机器会再次出现FullGC。按照内存容量估算，应该在第二天的相同时间点就会出现。

事件后的第二天（08-03）早上09:00左右，其他8G机器也相继出现FullGC报警，dump下来之后，发现问题相同。重启之后均未在出现。

### RootCause

    public void complete(){
        super.complete();
        InvocationResponse response = InvocationContext.getResponse();
        if(response!=null){
            tracer.setSize(response.getSize());
        }
        Tracer.serverSend();
    }

 在这段代码中的 `Tracer.serverSend()` 会进行ThreadLocal变量的清楚，但 `tracer.setSize(response.getSize())` 抛异常，未能执行 `Tracer.serverSend()` ，从而导致未能清除ThreadLocal变量。 
 关于ThreadLocal导致内存泄漏更多可以参考： [ThreadLocal原理和内存泄露分析](https://www.jfox.info/go.php?url=http://j360.me/2017/04/13/ThreadLocal-gc/) 和 [深入ThreadLocal之三（ThreadLocal可能引起的内存泄露）](https://www.jfox.info/go.php?url=http://www.cnblogs.com/duanxz/p/5445152.html)
{% endraw %}
