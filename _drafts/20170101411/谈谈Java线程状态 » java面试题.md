---
layout: post
title:  "谈谈Java线程状态 » java面试题"
title2:  "谈谈Java线程状态 » java面试题"
date:   2017-01-01 23:58:31  +0800
source:  "https://www.jfox.info/%e8%b0%88%e8%b0%88java%e7%ba%bf%e7%a8%8b%e7%8a%b6%e6%80%81.html"
fileName:  "20170101411"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e8%b0%88%e8%b0%88java%e7%ba%bf%e7%a8%8b%e7%8a%b6%e6%80%81.html"
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
**NEW状态：**
英文翻译过来是线程还是没有开始执行。
首先，既然已经有状态了，那肯定是已经创建好线程对象了（如果对象都没有，何来状态这一说？），这样一来问题的焦点就在于还没有开始执行，我们都知道当调用线程的start()方法时，线程不一定会马上执行，因为Java线程是映射到操作系统的线程进行执行，此时可能还需要等操作系统调度，但此时该线程的状态已经为RUNNABLE了。

**RUNNABLE状态：**
英文翻译过来是该状态指运行中的线程，一个线程处于RUNNABLE状态的意思是在JVM层面它是在执行的，但是该线程可能是在等待操作系统的资源，比如说CPU。这个状态是最有争议的，注释中说了，它表示线程在JVM层面是执行的，但在操作系统层面不一定，它举例是CPU，毫无疑问CPU是一个操作系统资源，但这也就意味着在等操作系统其他资源的时候，线程也会是这个状态，这里就有一个关键点**IO阻塞**算是等操作系统的资源么？
我自己写代码测试了一下：

    public class BIOServer {
        public static void main(String[] args) throws Exception {
            ServerSocket serverSocket = new ServerSocket(8888);
            Socket accept = serverSocket.accept();
            System.out.println("连接");
            accept.getInputStream().read();
            System.out.println("读取");
        }
    }
    

代码很简单，开始的accept()会阻塞直到有连接进来，然后输入流的read()方法又会阻塞等数据进来，这个时候线程的状态应该是BLOKED？RUNNABLE？
我用jstack导出线程查了一下：

    "Monitor Ctrl-Break" #10 daemon prio=5 os_prio=31 tid=0x00007fc5ac029000 nid=0x5503 runnable [0x0000000124689000]
       java.lang.Thread.State: RUNNABLE
            at java.net.PlainSocketImpl.socketAccept(Native Method)
            at java.net.AbstractPlainSocketImpl.accept(AbstractPlainSocketImpl.java)
            at java.net.ServerSocket.implAccept(ServerSocket.java:545)
            at java.net.ServerSocket.accept(ServerSocket.java:513)
            at com.intellij.rt.execution.application.AppMain$1.run(AppMain.java:90)
            at java.lang.Thread.run(Redefined)
    

**java.lang.Thread.State: RUNNABLE！！！**
从调用栈来看它确实是阻塞在accept()方法上，但是线程状态是RUNNABLE，是不是很意外？同理，read()方法也阻塞了，也处于RUNNABLE状态。
在回过头去理解JDK的英文注释，**在等操作系统资源，比如说CPU**，我们都知道Java的线程是映射到操作系统的线程上去执行的，也就是说操作系统的线程到底有没有在执行JVM是不知道的，JVM判断线程是否执行的逻辑就是自己的线程是否已经映射到了一个操作系统的线程，而不关系操作系统层面上该映射到的线程到底有没有再执行。
同理，NIO中调用select()方法时，线程状态也是RUNNABLE，这里就不贴代码了。

**BLOCKED状态：**
英文翻译过来是该状态表示线程在阻塞等待monitor lock(监视器锁)。一个线程在进入synchronized修饰的临界区的时候,或者在synchronized临界区中调用Object.wait然后被唤醒重新进入synchronized临界区都对应该状态。结合上面RUNNABLE的分析,也就是IO阻塞不会进入BLOCKED状态,只有synchronized会导致线程进入该状态。
关于BLOCKED状态，注释里只提到一种情况就是进入synchronized声明的临界区时会导致，这个也很好理解，synchronized是JVM自己控制的，所以这个阻塞事件它自己能够知道（对比理解上面的操作系统层面）。

**WAITING状态：**
代表线程进入等待状态。 当一个线程调用如下方法时会进入该状态:
1.Object.wait;
2.Thread.join;
3.LockSupport.park
处在这个状态的线程是在等另一个线程做一些特殊的操作。比如Object.wait()方法在等另一个线程调用Object.notify()或者Object.notifyAll()，Thread.join()方法在等一个指定线程完成,即变为TERMINATED状态，当然，LockSupport.park则是在等另一个线程调用LockSupport.unpark方法。

**TIMED_WAITING状态：**
代表一个线程在等一个指定时间,然后自动醒来。
调用以下方法时,线程会进入该状态:
1.Thread.sleep
2.Object.wait(long)
3.Thread.join(long)
4.LockSupport.parkNanos
5.LockSupport.parkUntil

**TERMINATED状态：**
当线程执行完成时会进入该状态。

通过上面的分析，我画了一个Java线程状态转换图：
![](/wp-content/uploads/2017/07/1501314166.png) 
  
    Java线程状态转换图 
   
  
 
写在最后：
Java线程状态应该算是一个有争议的问题，因为它涉及到操作系统本身。上面的内容只是我自己的理解跟做实验的结论，如果大家有不一样的看法或者其他实验证明我上面的观点有问题，欢迎给我评论或者私信，期待跟大家交流。
{% endraw %}
