---
layout: post
title:  "深入理解Thread类"
title2:  "深入理解Thread类"
date:   2017-01-01 23:53:47  +0800
source:  "https://www.jfox.info/%e6%b7%b1%e5%85%a5%e7%90%86%e8%a7%a3thread%e7%b1%bb.html"
fileName:  "20170101127"
lang:  "zh_CN"
published: true
permalink: "2017/%e6%b7%b1%e5%85%a5%e7%90%86%e8%a7%a3thread%e7%b1%bb.html"
---
{% raw %}
云计算与大数据时代，分布式、高并发是Java程序员面临的难题，其中Thread类的复杂性，往往让人摸不着头脑，学习《Java多线程编程核心技术》，对于初学者确实是一本入门宝典。

#### 一、interrupt、interrupted和isInterrupted方法的差异

- interrupt仅是为线程打了一个停止标记，并不影响其正常运行；
- interrupted判断当前线程是否为中断状态，有则清除停止标记；
- isInterrupted判断调用线程是否为中断状态，不清楚停止标记；

    public class MyThread extends Thread {
        @Override
        public void run() {
            super.run();
            for(int i=0;i < 10000;i++){
                System.out.println("i : "+(i+1));
            }
        }
    }
    
    public class Run {
        public static void main(String[] args) {
            try {
                MyThread t = new MyThread();
                t.start();
                t.interrupt();
                // interruted方法为判断当前线程是否中断，此为main线程
                System.out.println("是否停止： "+t.interrupted()); 
                // isInterrupted方法为判断调用线程是否中断，此为t 
                System.out.println("是否停止: "+t.isInterrupted());
            } catch (Exception e) {
                e.getStackTrace();
            }
        }
    }

    i : 1
    是否停止： false
    i : 2
    是否停止: true
    i : 3

#### 二、sleep与interrupt方法的先后顺序

- 无论是先sleep后interrupt，或是顺序切换，中断状态均会被清除；

    public class MyThread extends Thread {
        @Override
        public void run() {
            super.run();
            try {
                for(int i=0;i < 200000;i++){
                    System.out.println("i : "+(i+1));
                }
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                System.out.println("睡眠中中断状态是否清除： "+this.isInterrupted());
                e.printStackTrace();
            }
        }
    }
    
    public class Run {
        public static void main(String[] args) {
            try {
                MyThread t = new MyThread();
                t.start();
                t.interrupt(); // 先中断后睡眠
            } catch (Exception e) {
                e.getStackTrace();
            }
        }
    }

    i : 199999
    i : 200000
    睡眠中中断状态是否清除： false
    java.lang.InterruptedException: sleep interrupted
        at java.lang.Thread.sleep(Native Method)
        at javaBasic.MyThread.run(MyThread.java:11)

#### 三、加锁后被暂停，程序卡顿

- suspend方法，虽然已经被deprecated，学习其工作原理；
- suspend与resume联合使用，容易造成数据不一致的情况；

    public class MyThread extends Thread {
        @Override
        public void run() {
            super.run();
            try {
                for(int i=0;i < 200000;i++){
                    System.out.println("i : "+(i+1));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    public class Run {
        public static void main(String[] args) {
            try {
                MyThread t = new MyThread();
                t.start();
                Thread.sleep(1000);
                t.suspend();
                System.out.println("共享对象加锁被停止后，被独占");
            } catch (Exception e) {
                e.getStackTrace();
            }
        }
    }

    // 程序停顿在此，无法继续执行
    i : 109178
    i : 109179
    i : 109180
    i : 109181
    i : 109182

        // 加锁后被暂停，println方法不能被使用，知道resume恢复后继续执行
        public void println(String x) {
            synchronized (this) {
                print(x);
                newLine();
            }
        }

#### 四、常用概念小结

- 守护线程
Dameon的作用是为其他线程提供便利，一旦没有其他线程工作，则伴随JVM一起停止，常见的是JVM垃圾回收线程；
- 优先级
线程的优先级具有继承性、规则性和随机性，意味着CPU会提供更多的时间为其服务；高优先级的任务会大部分先执行完，不代表会全部先执行完；
- 常用的方法
yield()：放弃CPU资源，让给其他任务，放弃时间未知；
isAlive()：判断当前线程是否是存活状态；
concurrentThread()：判断当前线程；
- 线程状态(常用五种、细分七种)

![](/wp-content/uploads/2017/07/1499350981.png) 
 
   线程状态切换.png 
  
 

#### 五、等待通知机制

- wait和notify方法使用前，均需要获得对象锁，即二者须使用在同步语句中；
- wait方法执行后，释放对象锁，进入阻塞状态；此时调用该进程的interrupt方法，抛出java.lang.InterruptedException异常；
- notify方法执行后，从该同步对象的阻塞队列中唤醒一个线程（每个对象具有一个就绪队列和一个阻塞队列）；notify执行完所在的同步语句后，线程才被真正唤醒；（notifyAll唤醒多个线程）

    public class Add {
        private String lock;
        private ArrayList<String> list;
    
        public Add(String lock,ArrayList<String> list){
            this.lock = lock;
            this.list = list;
        }
    
        public void add() {
            synchronized(lock){
                list.add("Hello World");
                lock.notifyAll();;
            }
        }
    }
    
    public class Substract {
        private String lock;
        private ArrayList<String> list;
    
        public Substract(String lock,ArrayList<String> list){
            this.lock = lock;
            this.list = list;
        }
    
        public void substract(){
            try {
                synchronized(lock){
                    while(list.size() == 0){
                        System.out.println("begin : "+System.currentTimeMillis());
                        lock.wait();
                        System.out.println("end :　"+System.currentTimeMillis());
                    }
                    list.remove(0);
                    System.out.println("The operation is done now");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public class ThreadAdd extends Thread{
        private Add p;
    
        public ThreadAdd(Add p){
            super();
            this.p = p;
        }
    
        @Override
        public void run() {
            p.add();
        }
    }
    public class ThreadSubstract extends Thread{
        private Substract s;
    
        public ThreadSubstract(Substract s){
            super();
            this.s = s;
        }
    
        @Override
        public void run() {
            s.substract();
        }
    }

    public class Test {
        public static void main(String[] args) throws Exception {
            String lock = new String("");
            ArrayList<String> list = new ArrayList<String>();
    
            Add p = new Add(lock,list);
            Substract s = new Substract(lock,list);
    
            ThreadSubstract ts1 = new ThreadSubstract(s);
            ts1.start();
    
            ThreadSubstract ts2 = new ThreadSubstract(s);
            ts2.start();
    
    //        ts1.interrupt();
    
            Thread.sleep(1000);
    
            ThreadAdd ta = new ThreadAdd(p);
            ta.start();
    
        }
    }

    // 执行结果
    begin : 1499092455187  // ts1执行wait方法阻塞
    begin : 1499092455187  // ts2执行wait方法阻塞
    end :　1499092456188  // list添加后执行notifyAll，ts1或者ts2抢先执行后删除list中元素
    The operation is done now
    end :　1499092456188 // 未结束的线程一直在循环执行
    begin : 1499092456188

- 因为synchronized同步语句执行退出后，会将最新值从主内存刷新到线程的工作内存中，同理，在开始执行synchronized语句获得对象锁前，将主内存中的最新值刷新到工作内存中，所以list的大小实现同步；

#### 六、join方法

- 作用
将指定线程添加到当前线程；
调用iterrupt方法，直接抛出中断异常（直接原因与wait方法相同）；

    a.join(); // b线程调用a的join方法，等待直到a运行结束
    a.join(1000); //b线程调用a的join方法，等待1s

        public final synchronized void join(long millis)
        throws InterruptedException {
            long base = System.currentTimeMillis();
            long now = 0;
    
            if (millis < 0) {
                throw new IllegalArgumentException("timeout value is negative");
            }
    
            if (millis == 0) {
                while (isAlive()) {
                    wait(0);
                }
            } else {
                while (isAlive()) {
                    long delay = millis - now;
                    if (delay <= 0) {
                        break;
                    }
                    wait(delay);
                    now = System.currentTimeMillis() - base;
                }
            }
        }

    public class ThreadA extends Thread{
    
        @Override
        synchronized public void run() {
            try {
                System.out.println("begin A : ThreadName--"+
                        Thread.currentThread().getName()+System.currentTimeMillis());
                Thread.sleep(5000);
                System.out.println("end A : ThreadName--"+
                        Thread.currentThread().getName()+System.currentTimeMillis());                
            } catch (InterruptedException e) {
                e.printStackTrace();
            }    
        }
    }
    
    public class TestJoin {
    
        public static void main(String[] args) throws InterruptedException {
            ThreadA ta = new ThreadA();
            ta.start();
            ta.join(1000);        
            System.out.println("main end -- " + System.currentTimeMillis());
        }
    }

    // 测试结果，main线程无法获取锁对象只能等待，且执行时间为5秒而不是6秒
    begin A : ThreadName--Thread-01499224208429
    end A : ThreadName--Thread-01499224213429
    main end -- 1499224213429

    public class ThreadA extends Thread{
        private ThreadB tb;
    
        public ThreadA(ThreadB tb){
            super();
            this.tb = tb;
        }
    
        @Override
        public void run() {
            synchronized(tb){
                try {
                    System.out.println("begin A : ThreadName--"+
                            Thread.currentThread().getName()+System.currentTimeMillis());
                    Thread.sleep(5000);
                    System.out.println("end A : ThreadName--"+
                            Thread.currentThread().getName()+System.currentTimeMillis());                
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
    }
    
    public class ThreadB extends Thread{
    
        @Override
        synchronized public void run() {
            super.run();
            try {
                System.out.println("begin B : ThreadName--"+
                        Thread.currentThread().getName()+System.currentTimeMillis());
                Thread.sleep(1000);
                System.out.println("end B : ThreadName--"+
                        Thread.currentThread().getName()+System.currentTimeMillis());                
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }    
    }

    public class TestJoin {
    
        public static void main(String[] args) throws InterruptedException {
            ThreadB tb = new ThreadB();
            ThreadA ta = new ThreadA(tb);
    
            ta.start();
            tb.start();
            //参见源码，快速释放锁，出现ta、tb和tb.join抢占锁，出现多种情况
            tb.join(2000);
    
            System.out.println("main end -- " + System.currentTimeMillis());
        }
    }
{% endraw %}
