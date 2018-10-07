---
layout: post
title:  "深入剖析ThreadPool的运行原理"
title2:  "深入剖析ThreadPool的运行原理"
date:   2017-01-01 23:55:27  +0800
source:  "http://www.jfox.info/%e6%b7%b1%e5%85%a5%e5%89%96%e6%9e%90threadpool%e7%9a%84%e8%bf%90%e8%a1%8c%e5%8e%9f%e7%90%86.html"
fileName:  "20170101227"
lang:  "zh_CN"
published: true
permalink: "%e6%b7%b1%e5%85%a5%e5%89%96%e6%9e%90threadpool%e7%9a%84%e8%bf%90%e8%a1%8c%e5%8e%9f%e7%90%86.html"
---
{% raw %}
# 深入剖析ThreadPool的运行原理 


线程在执行任务时，正常的情况是这样的：

    Thread  t=new Thread(new  Runnable() {            
                @Override
                public void run() {
                    // TODO Auto-generated method stub    
                }
            });
            
            t.start();
            

  Thread 在初始化的时候传入一个Runnable,以后就没有机会再传入一个Runable了。那么，woker作为一个已经启动的线程。是如何不断获取Runnable的呢？这个时候可以使用一个包装器，将线程包装起来，在Run方法内部获取任务。

    public final class Worker implements Runnable {
        Thread thread = null;
        Runnable task;
        private BlockingQueue<Runnable> queues;
        public Worker(Runnable task, BlockingQueue<Runnable> queues) {
            this.thread = new Thread(this);
            this.task = task;
            this.queues = queues;
        }
        public void run() {
            if (task != null) {
                task.run();
            } 
                try {
                    while (true) {
                        task = queues.take();
                        if (task != null) {
                            task.run();
                        }
                    }
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        public void start() {
            this.thread.start();
        }
    }
    
    public class Main {
        public static void main(String[] args) {
            BlockingQueue<Runnable> queues=new ArrayBlockingQueue<Runnable>(100);
            Worker  worker=new Worker(new Runnable() {
                public void run() {
                    System.out.println("hello!!! ");
                    try {
                        Thread.currentThread().sleep(3000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }            
                }
            }, queues);
            worker.start();
            for(int i=0;i<100;i++){
                queues.offer(new Runnable() {
                    public void run() {
                        System.out.println("hello!!! ");
                        try {
                            Thread.currentThread().sleep(3000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                });
            }
        }
    
    }

  这样我们就简单地实现了一个“线程池”（可以将这个“线程池”改造成官方的模式，不过可以自己尝试一下）。ThreadPool的这种实现模式是并发编程中经典的Cyclic Work Distribution模式。  那么，这种实现的线程池性能如何呢？  由于其任务队列使用的是阻塞队列，在队列内部是自旋的。Reeteenlok是改进的CLH队列。自旋锁会耗费一定CPU的资源，在拥有大量任务执行下的情况下比较有效。而且，线程池中的线程并没有睡眠，而是进入了自旋状态。

  如果是不支持超线程的CPU，在同一时刻的确只能处理2个线程，但是并不意味着双核的CPU只能处理两个线程，它可以通过切换上下文来执行多个线程。比如我只有一个大脑，但是我要处理5个人提交的任务，我可以处理完A的事情后，把事情的中间结果保存下，然后再处理B的，然后再读取A的中间结果，处理A的事情。

# JDK中的线程池实现分析

  Woker自身继承了Runnable,并对Thread做了一个包装。Woker代码如下所示：

    private final class Worker
            extends AbstractQueuedSynchronizer
            implements Runnable
        {
    
            private static final long serialVersionUID = 6138294804551838833L;
    
        
            Runnable firstTask;
       
            volatile long completedTasks;
    
     
            Worker(Runnable firstTask) {
                setState(-1); // inhibit interrupts until runWorker
                this.firstTask = firstTask;
                this.thread = getThreadFactory().newThread(this);
            }
            public void run() {
                runWorker(this);
            }
            protected boolean isHeldExclusively() {
                return getState() != 0;
            }
    
            protected boolean tryAcquire(int unused) {
                if (compareAndSetState(0, 1)) {
                    setExclusiveOwnerThread(Thread.currentThread());
                    return true;
                }
                return false;
            }
    
            protected boolean tryRelease(int unused) {
                setExclusiveOwnerThread(null);
                setState(0);
                return true;
            }
    
            public void lock()        { acquire(1); }
            public boolean tryLock()  { return tryAcquire(1); }
            public void unlock()      { release(1); }
            public boolean isLocked() { return isHeldExclusively(); }
    
            void interruptIfStarted() {
                Thread t;
                if (getState() >= 0 && (t = thread) != null && !t.isInterrupted()) {
                    try {
                        t.interrupt();
                    } catch (SecurityException ignore) {
                    }
                }
            }
        }
    

  execute(Runnable command)方法内部是这样的：

    public void execute(Runnable command) {
           if (command == null)
               throw new NullPointerException();
         
           int c = ctl.get();
           if (workerCountOf(c) < corePoolSize) {
               if (addWorker(command, true))
                   return;
               c = ctl.get();
           }
           if (isRunning(c) && workQueue.offer(command)) {
               int recheck = ctl.get();
               if (! isRunning(recheck) && remove(command))
                   reject(command);
               else if (workerCountOf(recheck) == 0)
                   addWorker(null, false);
           }
           else if (!addWorker(command, false))
               reject(command);
       }
    

  ctl一个合并类型的值。将当前线程数和线程池状态通过数学运算合并到了一个值。具体是如何合并的可以参看一下源码，这里就不叙述了。继续向下走：

    if (workerCountOf(c) < corePoolSize) {
                if (addWorker(command, true))
                    return;
                c = ctl.get();
            }

  可以看到，如果当前线程数量小于了核心线程数量corePoolSize，就直接增加线程处理任务。与队列没有
{% endraw %}
