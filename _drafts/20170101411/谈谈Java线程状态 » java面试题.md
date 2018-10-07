---
layout: post
title:  "谈谈Java线程状态 » java面试题"
title2:  "谈谈Java线程状态 » java面试题"
date:   2017-01-01 23:58:31  +0800
source:  "http://www.jfox.info/%e8%b0%88%e8%b0%88java%e7%ba%bf%e7%a8%8b%e7%8a%b6%e6%80%81.html"
fileName:  "20170101411"
lang:  "zh_CN"
published: true
permalink: "%e8%b0%88%e8%b0%88java%e7%ba%bf%e7%a8%8b%e7%8a%b6%e6%80%81.html"
---
{% raw %}
作者[凌风郎少](/u/1d96ba4c1912)2017.07.29 09:07*字数 1329
本来以为这个知识点自己已经很了解了，但最近跟同事讨论Java线程对应的状态以及转换过程的时候，发现还是有一些没理清楚的地方，或者说争议点，趁机梳理了一下这块的知识，自己也动手做了实验，写篇文章总结一下。

先看一下Thread类中关于状态的源码：

    public enum State {
            /**
             * Thread state for a thread which has not yet started.
             */
            NEW,
    
            /**
             * Thread state for a runnable thread.  A thread in the runnable
             * state is executing in the Java virtual machine but it may
             * be waiting for other resources from the operating system
             * such as processor.
             */
            RUNNABLE,
    
            /**
             * Thread state for a thread blocked waiting for a monitor lock.
             * A thread in the blocked state is waiting for a monitor lock
             * to enter a synchronized block/method or
             * reenter a synchronized block/method after calling
             * {@link Object#wait() Object.wait}.
             */
            BLOCKED,
    
            /**
             * Thread state for a waiting thread.
             * A thread is in the waiting state due to calling one of the
             * following methods:
             * <ul>
             *   <li>{@link Object#wait() Object.wait} with no timeout</li>
             *   <li>{@link #join() Thread.join} with no timeout</li>
             *   <li>{@link LockSupport#park() LockSupport.park}</li>
             * </ul>
             *
             * <p>A thread in the waiting state is waiting for another thread to
             * perform a particular action.
             *
             * For example, a thread that has called <tt>Object.wait()</tt>
             * on an object is waiting for another thread to call
             * <tt>Object.notify()</tt> or <tt>Object.notifyAll()</tt> on
             * that object. A thread that has called <tt>Thread.join()</tt>
             * is waiting for a specified thread to terminate.
             */
            WAITING,
    
            /**
             * Thread state for a waiting thread with a specified waiting time.
             * A thread is in the timed waiting state due to calling one of
             * the following methods with a specified positive waiting time:
             * <ul>
             *   <li>{@link #sleep Thread.sleep}</li>
             *   <li>{@link Object#wait(long) Object.wait} with timeout</li>
             *   <li>{@link #join(long) Thread.join} with timeout</li>
             *   <li>{@link LockSupport#parkNanos LockSupport.parkNanos}</li>
             *   <li>{@link LockSupport#parkUntil LockSupport.parkUntil}</li>
             * </ul>
             */
            TIMED_WAITING,
    
            /**
             * Thread state for a terminated thread.
             * The thread has completed execution.
             */
            TERMINATED;
        }
    

这里特意贴了下英文注释，下面我挨个来解释一下：
{% endraw %}
