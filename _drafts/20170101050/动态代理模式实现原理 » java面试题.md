---
layout: post
title:  "动态代理模式实现原理 » java面试题"
title2:  "动态代理模式实现原理 » java面试题"
date:   2017-01-01 23:52:30  +0800
source:  "https://www.jfox.info/%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e6%a8%a1%e5%bc%8f%e5%ae%9e%e7%8e%b0%e5%8e%9f%e7%90%86.html"
fileName:  "20170101050"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e6%a8%a1%e5%bc%8f%e5%ae%9e%e7%8e%b0%e5%8e%9f%e7%90%86.html"
---
{% raw %}
# 动态代理模式实现原理 


    代理模式分为两种，一种是静态代理模式，一种是动态代理模式。
    静态代理模式：在程序运行之前需要写好代理类
    动态代理模式：在程序运行期间动态生成代理类
    

# 2.动态代理的实现

    动态代理实现的步骤：
    (1)写一个代理类SubjectHandler实现InvocationHandler接口,重写invoke方法,
       通过构造函数把代理的对象realSubject传入到此处理类中，
       在invoke方法中增加method.invoke(realSubject, args);
    

    public interface Subject
    {
        public void rent();
    }

    public class RealSubject implements Subject
    {
        @Override
        public void rent()
        {
            System.out.println("I want to rent my house");
        }
    }

    public class SubjectHandler implements InvocationHandler
    {
        private Subject subject;
        public SubjectHandler(Subject subject)
        {
            this.subject = subject;
        }
        
        @Override
        public Object invoke(Object object, Method method, Object[] args) throws Throwable
        {
            System.out.println("before rent house");
            method.invoke(subject, args);
            System.out.println("after rent house");
            return null;
        }
    }

       
    (2)在调用方法中增加代码即可完成调用

    public class Client
    {
        public static void main(String[] args)
        {
            RealSubject realSubject = new RealSubject();
            //生成代理类的对象
            Subject subject = (Subject)Proxy.newProxyInstance(realSubject.getClass().getClassLoader(), realSubject.getClass().getInterfaces(), new SubjectHandler(realSubject));
            subject.rent(); //调用代理类的方法
        }
    }
    //第一个参数为realSubject的classloader
    //第二个参数为realSubject的所有接口
    //第三个参数为处理类

上面的内容是几年前在网上看到的，具体出自那篇文章忘记了，动态代理的处理过程大体如上。

# 3.动态代理的实现过程

通过看马士兵的设计模式中的代理模式教程，对代理模式的内部实现原理有了更清楚的认识，下面的图片是自己总结的代理类的产生过程：
![](/wp-content/uploads/2017/07/1499175584.png)

下面的代码来自马士兵关于动态代理讲解的源码

            //模拟代理类的实现代码
            //把出来的内容写入文件中
            String fileName = 
                "d:/src/com/proxy/$Proxy1.java";
            File f = new File(fileName);
            FileWriter fw = new FileWriter(f);
            fw.write(src);
            fw.flush();
            fw.close();
            
            //编译文件，
            JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
            StandardJavaFileManager fileMgr = compiler.getStandardFileManager(null, null, null);
            Iterable units = fileMgr.getJavaFileObjects(fileName);
            CompilationTask t = compiler.getTask(null, fileMgr, null, null, null, units);
            t.call();
            fileMgr.close();
            
            //把class文件加载到内存中，通过构造方法生成代理的对象
            URL[] urls = new URL[] {new URL("file:/" + "d:/src/")};
            URLClassLoader ul = new URLClassLoader(urls);
            Class c = ul.loadClass("com.proxy.$Proxy1");
            System.out.println(c);
            
            Constructor ctr = c.getConstructor(InvocationHandler.class);
            Object m = ctr.newInstance(h);
            return m;

在生成的代理类中对应的方法如下

    private static Method m0;
    public final void rent() {
            try {
                super.h.invoke(this, m0, null);
                return;
            } catch (Error e) {
            } catch (Throwable throwable) {
                throw new UndeclaredThrowableException(throwable);
            }
    }
           

从上面我们可以看出，生成的代理对象subject 调用rent方法，其实是调用的上面代理类中生成的rent方法，在rent方法中调用了SubjectHandler 的invoke方法，通过上面的流程梳理，对于代理模式理解就更容易一些。

spring aop面向切面的编程也是使用动态代理模式来实现的。
{% endraw %}
