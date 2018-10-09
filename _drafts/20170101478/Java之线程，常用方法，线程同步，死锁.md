---
layout: post
title:  "Java之线程，常用方法，线程同步，死锁"
title2:  "Java之线程，常用方法，线程同步，死锁"
date:   2017-01-01 23:59:38  +0800
source:  "https://www.jfox.info/java%e4%b9%8b%e7%ba%bf%e7%a8%8b%e5%b8%b8%e7%94%a8%e6%96%b9%e6%b3%95%e7%ba%bf%e7%a8%8b%e5%90%8c%e6%ad%a5%e6%ad%bb%e9%94%81.html"
fileName:  "20170101478"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e4%b9%8b%e7%ba%bf%e7%a8%8b%e5%b8%b8%e7%94%a8%e6%96%b9%e6%b3%95%e7%ba%bf%e7%a8%8b%e5%90%8c%e6%ad%a5%e6%ad%bb%e9%94%81.html"
---
{% raw %}
1, 线程的概念

进程与线程

进程：每个进程都有独立的代码和数据空间（进程上下文），进程间的切换会有较大的开销，一个进程包含1–n个线程。（进程是资源分配的最小单位）

线程：同一类线程共享代码和数据空间，每个线程有独立的运行栈和程序计数器(PC)，线程切换开销小。（线程是cpu调度的最小单位）

切换而不是同步
 一个程序中的方法有几条执行路径, 就有几个线程

Java中线程的生命周期

![](/wp-content/uploads/2017/08/1501895777.png)

**Java线程具有五中基本状态**

**新建状态（New）：**当线程对象对创建后，即进入了新建状态，如：Thread t = new MyThread();

**就绪状态（Runnable）：**当调用线程对象的start()方法（t.start();），线程即进入就绪状态。处于就绪状态的线程，只是说明此线程已经做好了准备，随时等待CPU调度执行，并不是说执行了t.start()此线程立即就会执行；

**运行状态（Running）：**当CPU开始调度处于就绪状态的线程时，此时线程才得以真正执行，即进入到运行状态。注：就     绪状态是进入到运行状态的唯一入口，也就是说，线程要想进入运行状态执行，首先必须处于就绪状态中；

**阻塞状态（Blocked）：**处于运行状态中的线程由于某种原因，暂时放弃对CPU的使用权，停止执行，此时进入阻塞状态，直到其进入到就绪状态，才 有机会再次被CPU调用以进入到运行状态。根据阻塞产生的原因不同，阻塞状态又可以分为三种：

1.等待阻塞：运行状态中的线程执行wait()方法，使本线程进入到等待阻塞状态；

2.同步阻塞 — 线程在获取synchronized同步锁失败(因为锁被其它线程所占用)，它会进入同步阻塞状态；

3.其他阻塞 — 通过调用线程的sleep()或join()或发出了I/O请求时，线程会进入到阻塞状态。当sleep()状态超时、join()等待线程终止或者超时、或者I/O处理完毕时，线程重新转入就绪状态。

**死亡状态（Dead）：**线程执行完了或者因异常退出了run()方法，该线程结束生命周期。

2, 线程的创建:

Thread类：
java.lang
- All Implemented Interfaces:[Runnable](Runnable)已知直接子类：[ForkJoinWorkerThread](ForkJoinWorkerThread)*线程*是程序中执行的线程。 Java虚拟机允许应用程序同时执行多个执行线程。
每个线程都有优先权。 具有较高优先级的线程优先于优先级较低的线程执行。 每个线程可能也可能不会被标记为守护程序。 当在某个线程中运行的代码创建一个新的`Thread`对象时，新线程的优先级最初设置为等于创建线程的优先级，并且当且仅当创建线程是守护进程时才是守护线程。

创建一个新的执行线程有两种方法。 一个是将一个类声明为`Thread`的子类。 这个子类应该重写`run`类的方法`Thread` 。

另一种方法来创建一个线程是声明实现类`Runnable`接口。 那个类然后实现了`run`方法。 然后可以分配类的实例，在创建`Thread`时作为参数传递，并启动。

 两种方式:
 1, 继承Thread类
 class TestThread extends Thread {……}

     1 package com.hanqi.maya.test;
     2 
     3 import javax.swing.plaf.FontUIResource;
     4 import javax.swing.text.StyledEditorKit.ForegroundAction;
     5 
     6 public class Threadtest {
     7     public static void main(String[] args) {
     8         MyThread mt=new MyThread();
     9         mt.start();//开启线程 
    10         for(int i=0;i<50;i++){
    11             System.out.println("main"+i);
    12         }
    13     }
    14 }
    15 class MyThread extends Thread{ //通过继承Thread类的方法来创建多线程
    16     
    17     public void run(){
    18         for(int i=0;i<50;i++){
    19             System.out.println("MyThead"+i);
    20         }
    21     }
    22     
    23 }

 2, 实现Runnable接口, 然后作为参数传入到Thread类的构造方法中
 class TestThread implements Runnable {……}

     1 package com.hanqi.maya.test;
     2 
     3 import javax.swing.plaf.FontUIResource;
     4 import javax.swing.text.StyledEditorKit.ForegroundAction;
     5 
     6 public class Threadtest {
     7     public static void main(String[] args) {
     8         MyThread mt=new MyThread();
     9         
    10         Thread t=new Thread(mt);
    11         t.start();//自动去找t中实现的Runnable方法
    12         for(int i=0;i<50;i++){
    13             System.out.println("main"+i);
    14         }
    15 /*        
    16         mt.start();//开启线程 
    17         for(int i=0;i<50;i++){
    18             System.out.println("main"+i);
    19         }*/
    20     }
    21 }
    22 
    23 class MyThread implements Runnable{ //通过继承Thread类的方法来创建多线程
    24     
    25     public void run(){
    26         for(int i=0;i<50;i++){
    27             System.out.println("MyThead"+i);
    28         }
    29     }
    30     
    31 }
    32 /*class MyThread extends Thread{ //通过继承Thread类的方法来创建多线程
    33     
    34     public void run(){
    35         for(int i=0;i<50;i++){
    36             System.out.println("MyThead"+i);
    37         }
    38     }
    39     
    40 }*/

线程的启动:

调用线程类中的start()方法, 不能直接调用run()方法, 直接调用run()方法是方法调用, 不是启动线程

3, 线程常用方法

![](/wp-content/uploads/2017/08/1501895778.png)

isAlive()
判断线程是否还活着, 调用start()之前和终止之后都是死的, 其他的都是活的

判断线程是否还在

     1 package com.hanqi.maya.test;
     2 
     3 public class TestThread1 {
     4     public static void main(String[] args) {
     5         MyThread1 mt=new MyThread1();
     6         
     7         Thread t=new Thread(mt);
     8         
     9         System.out.println(t.isAlive());//判断线程是否还在，此处线程未开启
    10         t.start();
    11         System.out.println(t.isAlive());//判断线程是否还在，此处线程已经开启
    12     }
    13 }
    14 
    15 class MyThread1 implements Runnable{ //通过继承Thread类的方法来创建多线程
    16     
    17     public void run(){
    18         for(int i=0;i<50;i++){
    19             System.out.println("MyThead"+i);
    20         }
    21     }
    22 }

优先级

getPriority()
setPriority()
设置优先级, 优先级的概念: 谁的优先级高, 谁执行的时间就多
Thread里面的默认优先级:
Thread.MIN_PRIORITY = 1
Thread.MAX_PRIORITY = 10
Thread.NORM_PRIORITY = 5

     1 package com.hanqi.maya.test;
     2 
     3 public class TestPriority {
     4     public static void main(String[] args) {
     5         MyThread11 mt1 = new MyThread11("超人");
     6         MyThread2 mt2 = new MyThread2("蝙蝠侠");
     7         mt1.setPriority(Thread.NORM_PRIORITY + 5);//设置优先级
     8         mt1.start();
     9         mt2.start();
    10         System.out.println("123");
    11         try {
    12             Thread.sleep(2000);
    13         } catch (InterruptedException e) {
    14             // TODO Auto-generated catch block
    15             e.printStackTrace();
    16         }
    17         System.out.println(456);
    18     }
    19 }
    20 
    21 
    22 class MyThread11 extends Thread {
    23     
    24     public MyThread11(String name) {
    25         super(name);//调用父类构造方法将name穿减去
    26     }
    27 
    28     public void run() {
    29         for (int i = 0; i < 50; i++) {
    30             System.out.println(this.getName() + ": " + i);
    31         }
    32     }
    33 }
    34 
    35 class MyThread2 extends Thread {
    36     
    37     public MyThread2(String name) {
    38         super(name);
    39     }
    40     
    41     public void run() {
    42         for (int i = 0; i < 50; i++) {
    43             System.out.println(this.getName() + ": " + i);
    44         }
    45     }
    46 }

沉睡和终止

interrupt()
停止线程

这个方法要配合延迟使用，不要直接启动线程然后直接使用此方法

     1 package interupt;
     2 
     3 import java.util.Date;
     4 
     5 public class TestInterupt {
     6     public static void main(String[] args) {
     7         MyNewThread mnt = new MyNewThread();
     8         Thread t = new Thread(mnt);
     9         t.start();
    10         try {
    11             Thread.sleep(5000);
    12         } catch (InterruptedException e) {
    13             e.printStackTrace();
    14         }
    15         t.interrupt();
    16         t.stop();
    17 //         终止线程, 将run方法结束, 线程就结束了
    18         MyNewThread.flag = false;
    19     }
    20 }
    21 
    22 class MyNewThread implements Runnable {
    23 
    24     static boolean flag = true;
    25     @Override
    26     public void run() {
    27         while(flag) {
    28             System.out.println(new Date());
    29             try {
    30                 Thread.sleep(1000);
    31             } catch (Exception e) {
    32                 System.out.println("线程终止 !");
    33                 System.out.println(e.getMessage());
    34                 return;
    35             }
    36         }
    37     }
    38     
    39 }

Thread.sleep(long millions)将程序暂停一会，暂停当前线程，如果没有线程也可以给普通程序暂停，需要抛出一个异常即可

     1 package com.hanqi.maya.test;
     2 
     3 import java.util.Date;
     4 
     5 public class TestInterupt {
     6     public static void main(String[] args) {
     7         MyNewThread mnt = new MyNewThread();
     8         Thread t = new Thread(mnt);
     9         t.start();
    10         try {
    11             Thread.sleep(5000);//先沉睡5s
    12         } catch (InterruptedException e) {
    13             e.printStackTrace();
    14         }
    15         /*t.interrupt();//调用会抛出异常
    16         t.stop();//不建议使用，已经过时
    17 *///         终止线程, 将run方法结束, 线程就结束了
    18         MyNewThread.flag = false;//更改属性终止线程
    19     }
    20 }
    21 
    22 class MyNewThread implements Runnable {
    23 
    24     static boolean flag = true;
    25     @Override
    26     public void run() {
    27         while(flag) {
    28             System.out.println(new Date());
    29             try {
    30                 Thread.sleep(1000);//延迟一秒
    31             } catch (Exception e) {
    32                 System.out.println("线程终止 !");
    33                 System.out.println(e.getMessage());
    34                 return;
    35             }
    36         }
    37     }
    38     
    39 }

 join()
合并线程

     1 package join;
     2 
     3 public class TestJoin {
     4     public static void main(String[] args) {
     5         NewThread nt = new NewThread();
     6         nt.start();
     7         try {
     8             nt.join();//合并线程，继承自Thread，将这个线程加到当前线程，先执行这个线程
     9         } catch (InterruptedException e) {
    10             e.printStackTrace();
    11         }
    12         
    13         for (int i = 0; i < 10; i++) {
    14             System.out.println("我是main线程-----" + i);
    15         }
    16     }
    17 }
    18 
    19 class NewThread extends Thread {
    20     public void run() {
    21         for (int i = 0; i < 10; i++) {
    22             System.out.println("我是NewThread线程=====" + i);
    23         }
    24     }
    25 }

yield()—礼让
让出CPU执行其他线程

     1 package com.hanqi.maya.test;
     2 
     3 public class TestPriority {
     4     public static void main(String[] args) {
     5         MyThread11 mt1 = new MyThread11("超人");
     6         MyThread2 mt2 = new MyThread2("蝙蝠侠");
     7         mt1.setPriority(Thread.NORM_PRIORITY + 5);//设置优先级
     8         mt1.start();
     9         mt2.start();
    10         System.out.println("123");
    11         try {
    12             Thread.sleep(2000);
    13         } catch (InterruptedException e) {
    14             // TODO Auto-generated catch block
    15             e.printStackTrace();
    16         }
    17         System.out.println(456);
    18     }
    19 }
    20 
    21 
    22 class MyThread11 extends Thread {
    23     
    24     public MyThread11(String name) {
    25         super(name);//调用父类构造方法将name穿减去
    26     }
    27 
    28     public void run() {
    29         for (int i = 0; i < 50; i++) {
    30             System.out.println(this.getName() + ": " + i);
    31         }
    32     }
    33 }
    34 
    35 class MyThread2 extends Thread {
    36     
    37     public MyThread2(String name) {
    38         super(name);
    39     }
    40     
    41     public void run() {
    42         for (int i = 0; i < 50; i++) {
    43             System.out.println(this.getName() + ": " + i);
    44         }
    45     }
    46 }

wait()

-  
  
    导致当前线程等待，直到另一个线程调用此对象的 
   [`notify()`](`notify()`)方法或 
   [`notifyAll()`](`notifyAll()`)方法，或指定的时间已过。 
   

notify()

- 
    public final void notify()

 
  
    唤醒正在等待对象监视器的单个线程。 如果任何线程正在等待这个对象，其中一个被选择被唤醒。 选择是任意的，并且由实施的判断发生。 线程通过调用 
   `wait`方法之一等待对象的监视器。 
   
唤醒的线程将无法继续，直到当前线程放弃此对象上的锁定为止。 唤醒的线程将以通常的方式与任何其他线程竞争，这些线程可能正在积极地竞争在该对象上进行同步; 例如，唤醒的线程在下一个锁定该对象的线程中没有可靠的权限或缺点。

notifyAll()—

- 
    public final void notifyAll()

 
  
    唤醒正在等待对象监视器的所有线程。 线程通过调用 
   `wait`方法之一等待对象的监视器。 
   
唤醒的线程将无法继续，直到当前线程释放该对象上的锁。 唤醒的线程将以通常的方式与任何其他线程竞争，这些线程可能正在积极地竞争在该对象上进行同步; 例如，唤醒的线程在下一个锁定该对象的线程中不会有可靠的特权或缺点。

4, 线程同步
 synchronized

线程的同步是保证多线程安全访问竞争资源的一种手段。

当多个线程同时读写同一份共享资源的时候，可能会引起冲突。这时候，我们需要引入线程“同步”机制，即各位线程之间要有个先来后到的执行。 

线程同步的真实意思和字面意思恰好相反。线程同步的真实意思，其实是“排队”：几个线程之间要排队，一个一个对共享资源进行操作，而不是同时进行操作。

比如银行取钱：

银行卡余额3000，A从取款机取2000，B也想从支付宝这张卡转出2000，这时就要用到线程同步

线程同步，可以在方法声明中用 synchronized 关键字

也可以用 synchronized 关键字将代码块包起来实现

     1 package com.hanqi.util;
     2 
     3 public class Bank {
     4     public int money=3000;
     5     
     6     public /*synchronized*/ void getMoney(String name,int mon){
     7         synchronized(this){
     8             if(money>mon&&money>0){
     9                 try {
    10                     Thread.sleep(1);
    11                 } catch (InterruptedException e) {
    12                     e.printStackTrace();
    13                 }
    14                 
    15                 money-=mon;
    16                 System.out.println("hi,"+name);
    17                 System.out.println("取款"+mon);
    18                 System.out.println("余额："+money);
    19                 
    20             }else{
    21                 System.out.println("hi,"+name);
    22                 System.out.println("取款失败");
    23                 System.out.println("余额："+money);
    24             }
    25         }
    26     }
    27 }

     1 package com.hanqi.util;
     2 
     3 public class Threadt1 {
     4 
     5     public static void main(String[] args) {
     6         MyThread mt=new MyThread();
     7         
     8         Thread t1=new Thread(mt);
     9         Thread t2=new Thread(mt);
    10         
    11         t1.setName("Tom");
    12         t2.setName("BomSa");
    13         
    14         t1.start();
    15         t2.start();
    16     }
    17 }
    18 class MyThread implements Runnable{
    19     public Bank bank=new Bank();
    20     @Override
    21     public void run() {
    22         bank.getMoney(Thread.currentThread().getName(), 2000);
    23     }
    24 }

五、死锁概念

所谓死锁，是两个甚至多个线程被永久阻塞时的一种运行局面，这种局面的生成伴随着至少两个线程和两个或者多个资源。两个或两个以上的进程在执行过程中，因争夺资源而造成的一种互相等待的现象，若无外力作用，它们都将无法推进下去。此时称系统处于死锁状态或系统产生了死锁，这些永远在互相等待的进程称为死锁进程。由于资源占用是互斥的，当某个进程提出申请资源后，使得有关进程在无外力协助下，永远分配不到必需的资源而无法继续运行，这就产生了一种特殊现象死锁。

     1 package com.hanqi.util;
     2 
     3 public class Deadlock implements Runnable {
     4 
     5     
     6     public static void main(String[] args) {
     7         
     8         Deadlock d1 = new Deadlock();
     9         Deadlock d2 = new Deadlock();
    10         
    11         d1.flag = 1;
    12         d2.flag = 2;
    13         
    14         Thread t1 = new Thread(d1);
    15         Thread t2 = new Thread(d2);
    16         
    17         t1.start();
    18         t2.start();
    19         
    20     }
    21     
    22     public static Object obj1 = new Object();
    23     public static Object obj2 = new Object();
    24 
    25     public int flag;
    26 
    27     @Override
    28     public void run() {
    29         if (flag == 1) {
    30             System.out.println("这是第" + flag + "个线程");
    31             synchronized (obj1) {
    32                 try {
    33                     Thread.sleep(500);
    34                 } catch (InterruptedException e) {
    35                     e.printStackTrace();
    36                 }
    37                 synchronized (obj2) {
    38                     System.out.println("第" + flag + "个线程结束");
    39                 }
    40             }
    41         }
    42         
    43         if (flag == 2) {
    44             System.out.println("这是第" + flag + "个线程");
    45             synchronized (obj2) {
    46                 try {
    47                     Thread.sleep(500);
    48                 } catch (InterruptedException e) {
    49                     e.printStackTrace();
    50                 }
    51                 synchronized (obj1) {
    52                     System.out.println("第" + flag + "个线程结束");
    53                 }
    54             }
    55         }
    56 
    57     }
    58 
    59 }
{% endraw %}
