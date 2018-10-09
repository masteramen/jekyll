---
layout: post
title:  "Java基础——线程 » java面试题"
title2:  "Java基础——线程 » java面试题"
date:   2017-01-01 23:53:01  +0800
source:  "https://www.jfox.info/java%e5%9f%ba%e7%a1%80%e7%ba%bf%e7%a8%8b.html"
fileName:  "20170101081"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e5%9f%ba%e7%a1%80%e7%ba%bf%e7%a8%8b.html"
---
{% raw %}
是指一个内存中运行的应用程序，每个进程都有自己独立的一块内存空间，一个进程中可以启动多个线程。

比如在Windows系统中，一个运行的exe就是一个进程。

**二、线程**

是指进程中的一个执行流程，一个进程中可以运行多个线程。比如java.exe进程中可以运行很多线程。

线程总是属于某个进程，进程中的多个线程共享进程的内存。“同时”执行是人的感觉，在线程之间实际上轮换执行。

现在的操作系统是多任务操作系统。多线程是实现多任务的一种方式。

**创建多线程程序的方法及步骤： **

**方法一：**用 Thread 类创建线程

1) 一写个类,继承自 Thread 类

2) 重写run方法 //这个方法里放的变是要执行的内容

3) new 这个自定义的Thread 类

4) 调用start方法,启动这个线程 (start 方法有两个作用 ,一个是开启线程,一个是调用run方法)

    publicclass Test12 {
        publicstaticvoid main(String[] args) {
            ThreadDemo t = new ThreadDemo();
            t.start();// 启动
            ThreadDemo t2 = new ThreadDemo();
            t2.start();
    
            ThreadDemo t3 = new ThreadDemo();
            t3.start();
    
            for (int i = 0; i < 20; i++) {
                System.out.println("线程" + Thread.currentThread().getName() + "正在运行");
            }
        }
    }
    
    class ThreadDemo extends Thread {
        @Override
        publicvoid run() {
            for (int i = 0; i < 200; i++) {
                System.out.println("线程" + Thread.currentThread().getName() + "正在运行");
            }
        }
    
    }

打印结果：

    线程Thread-0正在运行
    线程Thread-0正在运行
    线程Thread-0正在运行
    线程Thread-2正在运行
    线程main正在运行
    线程Thread-1正在运行
    线程Thread-1正在运行
    线程Thread-1正在运行
    线程main正在运行
    线程Thread-2正在运行
    线程Thread-0正在运行
    线程Thread-2正在运行
    
    。。。。。。。。。。。
    下面还有输出省略了

**要点总结：**

要将一段代码放在一个新的线程上运行,这段代码应该放在一个类的 run 函数中, 并且,ran函数所在的类是Thread类的子类

倒过来说,我们要实现多线程,必须编写一个继承了Threa类的的子类,并重写其run方法

启动一个线程,我们不是调用Thread子类对象的run方法,而是调用Thread子类对象的start 方法( 从Thread类继承到的),该方法将

产生一个新的线程 并在该线程上运行子类对象中的run方法

由于线程的代码段放在run 方法中,那么该方法执行完后,线程就结束了

    publicclass Test {
                    publicstaticvoid main(String[] args) throws InterruptedException {
                        ThreadDemo t=new ThreadDemo();
                        t.start();
                        
                        while(true){
                            System.out.println("这是线程一输出的内容");
                            Thread.sleep(10);
                        }
                    }
                }
                
                
                class ThreadDemo extends Thread{
                    publicvoid run() {
                        for (int i = 0; i < 50; i++) {
                            System.out.println("这是线程二输出的内容");
                        }
                    }
                }

    //例子,创建三个线程,和主线程同时运行publicclass Test2 {
                publicstaticvoid main(String[] args) {
                    MyThread t1=new MyThread();
                    t1.start();
                    
                    MyThread t2=new MyThread();
                    t2.start();
                    
                    MyThread t3=new MyThread();
                    t3.start();
                        
                    for (int i = 0; i < 200; i++) {
                        System.out.println("主线程"+Thread.currentThread().getName()+"正在运行");
                    }    
                }    
            }

**方法二：**使用Runnable接口实现多线程

1)自定义一个类，implements Runnable接口

2）重写run方法

3）new出来这个自定的类//该类对象会作为Thread类构造函数的参数       

4)new出Thread类

5）调用start方法

代码演示：

    //使用Runnable实现多线程
    //注意：在调用的时候与Thread的不同。。。publicclass Test13 {
        publicstaticvoid main(String[] arg) {
    
            /*
             * 注意：
    *1.下面用到的是Runnable接口
    *2.并没有继承Thread，就不能直接用.start()方法
             * 
             * 解决办法：
    *1.MyThread对象依然要被创建；
    *2.创建Thread对象；
    *3.将MyThread创建的对象作为Thread构造函数的参数，传入
             * 4.即可调用.start();方法了
             */
            MyThread m = new MyThread();// 此时，m好像没参与，把它传入下一行Thread（）；中
            Thread t = new Thread(m);
            t.start();
    
            for (int i = 0; i < 10; i++) {
                System.out.println("--------》");
            }
        }
    }
    
    // 实现Runnable接口class MyThread implements Runnable {
    
        @Override
        publicvoid run() {
            for (int i = 0; i < 14; i++) {
                System.out.println("(--------");
            }
    
        }
    
    }

**继承Thread类创建线程和实现Runnable接口创建线程的区别**

使用 Runnable 接口创建多线程

1.适合多个相同的程序代码去处理同一资源的情况 把虚拟CPU (线程)同程序的代码 数据有效分离,较好的体现了面象对象

2.可以避免java单继承带来的局限

例如:当我们将已经继承了某类的一个类的子类放入多线程中,由于不能同时继承两个类,所以这什么情况下，不能采用继承Thread的方式,只好通过实现Ruanable。.当线程被构造时,需要的代码和数据通过一个对象作为构造函数实参传递进去,这个对象就是一个实现了Runnable接口类的实例.事实上,几乎所有的多线程都可以用Runnable接口方式

**代码演示：(这个代码有有误，在出票处有重复票）**

    //用Runnable的好处,模拟买票系统publicclass Test14 {
        publicstaticvoid main(String[] args) {
            // 好处在这里，可以资源t共享
            // 模拟四个买票窗口
            SaleThread t = new SaleThread();
            new Thread(t).start();// 窗口1new Thread(t).start();// 窗口2new Thread(t).start();// 窗口3new Thread(t).start();// 窗口4
        }
    }
    
    class SaleThread implements Runnable {
        // 卖20张票staticint ticket = 20;
    
        @Override
        publicvoid run() {
            // TODO Auto-generated method stubwhile(true){
                try {
                    // 貌似我电脑的虚拟机有问题，它总跑同一个Thread，所以我设置一下，让它交替运行
                    Thread.sleep(10);
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block                e.printStackTrace();
                }
                if (ticket > 0) {
                    System.out.println("线程" + Thread.currentThread().getName()+ "正在卖第" + ticket + "张票");
                } else {
                    break;
                }    
                ticket--;
            }
            
        }
    
    }

![](/wp-content/uploads/2017/07/1499262867.png)

 上面的二代在出票处有重复，我的ticket递减理解错位置了。我理解是，没有写在if里面会导致，if多次执行，再执行递减。他俩有不相交的地方。下面该了这个bug。

    if (ticket>0) {
                    System.out.println("线程" + Thread.currentThread().getName()+ "正在卖第" + ticket--+ "张票");
                } else {
                    break;
                }    
                //ticket--;不是写在这里的，会有重复票（自己写的时候，写在这里了。）ticket--在上面if中。

更改之后，正常了：

![](/wp-content/uploads/2017/07/1499262868.png)

**还没结束！！！**

**还没结束！！！**

**还没结束！！！**

**上面的代码似乎是设置好了，可是在我多次点击运行之后，依然出现了少量的重票。**

**![](/wp-content/uploads/2017/07/1499262870.png)**

这就引出了线程同步问题。

**三、线程同步 synchronized**

原理讲解：任何对象都有一个标志位.是0或1 程序执行到这里.会检查这个对象的标志位,如果是1,那么向下执行,同时将标志位为0

如果标志位为0,则线程发生阻塞.一直等到标志位为1 标志位又叫锁旗标

synchronized 又叫锁定了监视器 一个线程可以再进入线程锁定临视器.就象蓝球运动员再拿到球一样。

    class SaleThread2  implements Runnable{
                //static int ticket=1000;privateint ticket;
                public SaleThread2(int ticket){
                    this.ticket=ticket;
                }
                
                String lockStr="";
                //Object obj=new Object();publicvoid run() {
                    while(true){
                        synchronized (lockStr) {  //锁 ,锁旗标if(ticket>0){
                                try{
                                        Thread.sleep(10);    
                                }
                                catch(Exception ex){
                                    ex.printStackTrace();
                                }
                                
                                System.out.println("线程"+Thread.currentThread().getName() +"正在卖第"+ticket--+"张票");
                            }
                            else{
                                break;
                            }
                        }
                    }    
                }
            }

**四、自定义线程**

1) 线程的名字，一个运行中的线程总是有名字的，名字有两个来源，一个是虚拟机自己给的名字，

一个是你自己的定的名字。在没有指定线程名字的情况下，虚拟机总会为线程指定名字，并且主线程的名字总是mian，非主线程的名字不确定。

//Thread(String name)   可以在构造线程的时候,直接传入名字

//getName () 可以得到线程的名字

2) 获取当前线程的对象的方法是：Thread.currentThread();

3) 在上面的代码中，只能保证：每个线程都将启动，每个线程都将运行直到完成。一系列线程以某种顺序启动并不意味着将按该顺序执行。

对于任何一组启动的线程来说，调度程序不能保证其执行次序，持续时间也无法保证。

4) 当线程目标run()方法结束时该线程完成

5) 一旦线程启动，它就永远不能再重新启动。只有一个新的线程可以被启动，并且只能一次。一个可运行的线程或死线程可以被重新启动。

//t1.start(); 即这个操作只能一次,如果多次,将引发 java.lang.IllegalThreadStateException

    class MyThread extends Thread{
                publicvoid run() {
                    for (int i = 0; i < 20000; i++) {
                        System.out.println("线程"+Thread.currentThread().getName()+"正在运行");
                    }
                }
    }

**五、线程的状态    ** 

新建 (Born) :  新建的线程处于新建状态

就绪 (Ready) : 在创建线程后，start() 方法被调用它将处于就绪状态

运行 (Running) : 线程在开始执行时(run)进入运行状态

睡眠 (Sleeping) : 线程的执行可通过使用 sleep() 方法来暂时中止。在睡眠结束后，线程将进入就绪状态

等待 (Waiting) : 如果调用了 wait() 方法，线程将处于等待状态。用于在两个或多个线程并发运行时。

挂起 (Suspended) : 在临时停止或中断线程的执行时，线程就处于挂起状态。 //suspend()  已过时,有固定的死锁倾向

恢复 (Resume) : 在挂起的线程被恢复执行时，可以说它已被恢复。

阻塞 (Blocked) – 在线程等待一个事件时（例如输入/输出操作），就称其处于阻塞状态。

死亡 (Dead) – 在 run() 方法已完成执行或其 stop() 方法被调用之后，线程就处于死亡状态。 //stop 方法有两个重载,均已过时,有固定的不安全性

![](/wp-content/uploads/2017/07/1499262871.png)

****

Java 中的线程优先级是在 Thread 类中定义的常量

NORM_PRIORITY : 值为 5

MAX_PRIORITY : 值为 10

MIN_PRIORITY : 值为 1

缺省优先级为 NORM_PRIORITY

****

有关优先级的方法有两个：

final void setPriority(int newp) : 修改线程的当前优先级

final int getPriority() : 返回线程的优先级

**补充面试题：**

**sleep 和 yield 的区别**

1) sleep是Thread类的一个静态方法，该方法会让当前正在 执行的线程暂停执行，从而将执行机会让给其他线程执行。

sleep(long mills)参数指定当前线程暂停执行的时间，经过这段阻塞时间后，该线程会进入就绪状态，等候线程调度器的调度

sleep方法声明抛出了InterruptedException异常，所以调用sleep方法时要么在方法开始处抛出异常要么使用try{}..catch{}块进行捕获。 

2) yield 方法只会给优先级相同或更高优先级的线程执行机会。yield不会将线程转入阻塞状态，只是强制当前线程进入就绪状态。

因此完全有可能某个线程调用yield方法暂停后，立即又获得处理器资源被执行。yield方法没有声明抛出任何异常。

//  通俗地说 yield()方法只是把线程的状态 由执行状态打回准备就绪状态

    publicvoid run() {
        for (int i = 0; i < 50; i++) {
            System.out.println(getName() + "--->" + i);
            if (i == 20) {
                Thread.yield();
                }
                }
                }
                publicstaticvoid main(String[] args) {
                    YieldThread t1 = new YieldThread("高级");
                    t1.start();
                    // 若当前线程优先级最高，那么即使调用了yield()方法，线程调度器又会将这个线程调度出来重新执行
                    // t1.setPriority(Thread.MAX_PRIPORITY);
                    YieldThread t2 = new YieldThread("低级");
                    t2.start();
                    t2.setPriority(Thread.MIN_PRIORITY);
                    }
{% endraw %}
