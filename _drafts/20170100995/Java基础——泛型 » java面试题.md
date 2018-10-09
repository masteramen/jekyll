---
layout: post
title:  "Java基础——泛型 » java面试题"
title2:  "Java基础——泛型 » java面试题"
date:   2017-01-01 23:51:35  +0800
source:  "https://www.jfox.info/java%e5%9f%ba%e7%a1%80-%e6%b3%9b%e5%9e%8b.html"
fileName:  "20170100995"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e5%9f%ba%e7%a1%80-%e6%b3%9b%e5%9e%8b.html"
---
{% raw %}
**一、定义**

泛型（generic）是指参数化类型的能力。可以定义带泛型类型的类或方法，随后编译器会用具体的类型来替换它（泛型实例化）。使用泛型的主要优点是能够在编译时，而不是在运行时检测出错误。它是jdk1.5之后出现的特性，为了增强安全性。我的理解是，它更像一种特殊规范，比如程序员在调用的时候，或者客户端在引入的时候，总不能鱼龙混杂，想怎样就怎样啊？！前面定义说输入一个String型的，这边再不听话，没必要让你执行下去了，就直接让你挂掉。

**二、未定泛型的坏处**

1.报警告, 没有进泛型参数化

2.不定义泛型,集合里可以装入任何类型的对象,这是不安全的

3.取集合中的数据的时候,要进行强转

    import java.util.Iterator;
    import java.util.Set;
    import java.util.TreeSet;
    publicclass Test {
        publicstaticvoid main(String[] args) {
            Set treeSet = new TreeSet();//没有使用泛型，应该这样：Set<Student> treeSet = new TreeSet<Student>();
            treeSet.add(new Student(11, 80, "李平"));
            treeSet.add(new Student(23, 40, "王芳"));
            treeSet.add(new Student(10, 60, "赵磊"));
            treeSet.add(new Student(12, 40, "王小二"));
            treeSet.add(new Student(10, 60, "马苗"));
            treeSet.add(new Student(18, 60, "马苗"));
            treeSet.add(new Student(25, 70, "姜浩"));
            Iterator it = treeSet.iterator();
            while (it.hasNext()) {
                Student stu = (Student) it.next();//没有使用泛型：需要强转            System.out.println(stu);
            }
        }
    }

编译时开始报错（黄色）：

**修改之后：**

**注意：泛型类型必须是引用类型！！！**

**注意：泛型类型必须是引用类型！！！**

**注意：泛型类型必须是引用类型！！！**

** 三、泛型的制定**

在JDK中我们经常看见如下的三种情况：

1.TreeSet(Collection<? extends E> c)

2.TreeSet(Comparator<? super E> comparator)

3.TreeSet(SortedSet<E> s)

其中，

**? 通配符,指的是任意数据类型**

**< > 指的是泛型。**（可以看出，3 就是正常定义泛型）

下面的注意：

泛型的限定上限：<? extends E > // 表示接收E这个类型,或E的子类型
泛型的限定下限 ：<? super E > // 表示接收E这个类型,或E的父类型

代码实例：

    //这时这个函数只能接收 Number及其子类staticvoid show(Point<? extends Number> p){ 
            System.out.println(p.getX());
            System.out.println(p.getY());
        }
        publicstaticvoid main(String[] args) {
            /* 对于上面的声明,下面的操作是可以的
            Point<Integer> p1=new Point<Integer>();
            p1.setX(new Integer(90));
            p1.setY(new Integer(50));
            show(p1);      *///下面的操作将出错
            Point<String> p1=new Point<String>();
            p1.setX("90ok");
            p1.setY("50ok");
            show(p1); //出错

    class Test7{
        //这时这个函数只能接收 Number及其子类staticvoid show(Point<? super String> p){ 
            System.out.println(p.getX());
            System.out.println(p.getY());
        }
        publicstaticvoid main(String[] args) {
        /*
          这里将出错
            Point<Integer> p1=new Point<Integer>();
            p1.setX(new Integer(90));
            p1.setY(new Integer(50));
            show(p1);      */  
            Point<String> p1=new Point<String>();
            p1.setX("90ok");
            p1.setY("50ok");
            show(p1);  //可以    }
    }
    

 （图片来自网络）

**四、理解泛型的应用**

我们可以自定义泛型类，泛型方法和泛型接口。学习的时候需要知道它的原理，以后就可以愉快的调用JDK里面的啦~~

**1.自定义泛型类**

    class ObjectFactory<T> { // 声明泛型為<T>private T obj;
        public T getObj() {
            returnthis.obj;
        }
        publicvoid setObj(T obj) {
            this.obj = obj;
        }
        /*
         * 下面的写法不成立 public T getNewObj(){ T t=new T(); //在编译期,无法确定泛型的参数化的类型 return
         * t; }
         */
    }
    class Test4 {
        publicstaticvoid main(String[] args) {
            // List list=new ArrayList();/*
             * ObjectFactory f=new ObjectFactory(); f.SetObj("ss");
             */
            ObjectFactory<String> f = new ObjectFactory<String>();
            f.setObj("这里必须是String");
            // f.SetObj(89); 不可以
            String obj = f.getObj();
            System.out.println(obj);
            ObjectFactory<Student> stuList = new ObjectFactory<Student>();
            stuList.setObj(new Student(67, 90, "张三"));
            stuList.getObj().speak();
        }
    }

**2.泛型方法**

    publicclass TestFan {
        // 泛型方法,这里不做限制，传什么都可以public <T> void show(T t) {
            System.out.println("这是泛型方法中的" + t);
        }
    }
    class Test5 {
        publicstaticvoid main(String[] args) {
            TestFan tfan = new TestFan();
            tfan.show("777");
            tfan.show(898);
            tfan.show(new Student(30, 20, "猫"));
        }
    }

**3.泛型接口**

**五、泛型限制**

1.不能使用泛型参数创建实例，即不能使用new E()

2.异常类不能是泛型的

3.在静态环境下不允许类的参数是泛型类型（注意）

由于泛型类的所有实例都有相同的运行时类，所以泛型类的静态变量和方法是被它的所有实例所共享的。既然是共享的你就没有必要再重新定义一样的泛型类型，那如果你不定义一样的泛型类型，又达不到共享（或者说是一致性），更没有必要让这种情况通过。所以，在静态环境了类的参数被设置成泛型是非法的。

    publicclass Ee<E> {
        publicstatic E Example1;  // Illegalpublicstaticvoid Example2(E o1) { 
            // Illegal    }
        static {
            E Example3; // Illegal    }
    }
{% endraw %}
