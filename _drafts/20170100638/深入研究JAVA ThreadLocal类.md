---
layout: post
title:  "深入研究JAVA ThreadLocal类"
title2:  "深入研究JAVA ThreadLocal类"
date:   2017-01-01 23:45:38  +0800
source:  "http://www.jfox.info/in-depth-study-java-threadlocal-class.html"
fileName:  "20170100638"
lang:  "zh_CN"
published: true
permalink: "in-depth-study-java-threadlocal-class.html"
---
{% raw %}
深入研究java.lang.ThreadLocal类

一、概述

ThreadLocal是什么呢？其实ThreadLocal并非是一个线程的本地实现版本，它并不是一个Thread，而是threadlocalvariable(线程局部变量)。也许把它命名为ThreadLocalVar更加合适。线程局部变量(ThreadLocal)其实的功用非常简单，就是为每一个使用该变量的线程都提供一个变量值的副本，是Java中一种较为特殊的线程绑定机制，是每一个线程都可以独立地改变自己的副本，而不会和其它线程的副本冲突。

从线程的角度看，每个线程都保持一个对其线程局部变量副本的隐式引用，只要线程是活动的并且 ThreadLocal 实例是可访问的；在线程消失之后，其线程局部实例的所有副本都会被垃圾回收（除非存在对这些副本的其他引用）。

通过ThreadLocal存取的数据，总是与当前线程相关，也就是说，JVM 为每个运行的线程，绑定了私有的本地实例存取空间，从而为多线程环境常出现的并发访问问题提供了一种隔离机制。

ThreadLocal是如何做到为每一个线程维护变量的副本的呢？其实实现的思路很简单，在ThreadLocal类中有一个Map，用于存储每一个线程的变量的副本。

概括起来说，对于多线程资源共享的问题，同步机制采用了“以时间换空间”的方式，而ThreadLocal采用了“以空间换时间”的方式。前者仅提供一份变量，让不同的线程排队访问，而后者为每一个线程都提供了一份变量，因此可以同时访问而互不影响。

二、API说明

ThreadLocal()

          创建一个线程本地变量。

T get()

          返回此线程局部变量的当前线程副本中的值，如果这是线程第一次调用该方法，则创建并初始化此副本。

protected  T initialValue()

          返回此线程局部变量的当前线程的初始值。最多在每次访问线程来获得每个线程局部变量时调用此方法一次，即线程第一次使用 get() 方法访问变量的时候。如果线程先于 get 方法调用 set(T) 方法，则不会在线程中再调用 initialValue 方法。

   若该实现只返回 null；如果程序员希望将线程局部变量初始化为 null 以外的某个值，则必须为 ThreadLocal 创建子类，并重写此方法。通常，将使用匿名内部类。initialValue 的典型实现将调用一个适当的构造方法，并返回新构造的对象。

void remove()

          移除此线程局部变量的值。这可能有助于减少线程局部变量的存储需求。如果再次访问此线程局部变量，那么在默认情况下它将拥有其 initialValue。

void set(T value)

          将此线程局部变量的当前线程副本中的值设置为指定值。许多应用程序不需要这项功能，它们只依赖于 initialValue() 方法来设置线程局部变量的值。

在程序中一般都重写initialValue方法，以给定一个特定的初始值。

三、典型实例

1、Hiberante的Session 工具类HibernateUtil

这个类是Hibernate官方文档中HibernateUtil类，用于session管理。

public class HibernateUtil {

    private static Log log = LogFactory.getLog(HibernateUtil.class);

    private static final SessionFactory sessionFactory;     //定义SessionFactory

    static {

        try {

            // 通过默认配置文件hibernate.cfg.xml创建SessionFactory

            sessionFactory = new Configuration().configure().buildSessionFactory();

        } catch (Throwable ex) {

            log.error(“初始化SessionFactory失败！”, ex);

            throw new ExceptionInInitializerError(ex);

        }

    }

    //创建线程局部变量session，用来保存Hibernate的Session

    public static final ThreadLocal session = new ThreadLocal();

    /**

     * 获取当前线程中的Session

     * @return Session

     * @throws HibernateException

     */

    public static Session currentSession() throws HibernateException {

        Session s = (Session) session.get();

        // 如果Session还没有打开，则新开一个Session

        if (s == null) {

            s = sessionFactory.openSession();

            session.set(s);         //将新开的Session保存到线程局部变量中

        }

        return s;

    }

    public static void closeSession() throws HibernateException {

        //获取线程局部变量，并强制转换为Session类型

        Session s = (Session) session.get();

        session.set(null);

        if (s != null)

            s.close();

    }

}

在这个类中，由于没有重写ThreadLocal的initialValue()方法，则首次创建线程局部变量session其初始值为null，第一次调用currentSession()的时候，线程局部变量的get()方法也为null。因此，对session做了判断，如果为null，则新开一个Session，并保存到线程局部变量session中，这一步非常的关键，这也是“public static final ThreadLocal session = new ThreadLocal()”所创建对象session能强制转换为Hibernate Session对象的原因。

2、另外一个实例

创建一个Bean，通过不同的线程对象设置Bean属性，保证各个线程Bean对象的独立性。

/**

 * Created by IntelliJ IDEA.

 * User: leizhimin

 * Date: 2007-11-23

 * Time: 10:45:02

 * 学生

 */

public class Student {

    private int age = 0;   //年龄

    public int getAge() {

        return this.age;

    }

    public void setAge(int age) {

        this.age = age;

    }

}

/**

 * Created by IntelliJ IDEA.

 * User: leizhimin

 * Date: 2007-11-23

 * Time: 10:53:33

 * 多线程下测试程序

 */

public class ThreadLocalDemo implements Runnable {

    //创建线程局部变量studentLocal，在后面你会发现用来保存Student对象

    private final static ThreadLocal studentLocal = new ThreadLocal();

    public static void main(String[] agrs) {

        ThreadLocalDemo td = new ThreadLocalDemo();

        Thread t1 = new Thread(td, “a”);

        Thread t2 = new Thread(td, “b”);

        t1.star
{% endraw %}
