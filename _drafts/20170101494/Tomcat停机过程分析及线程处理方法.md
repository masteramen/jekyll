---
layout: post
title:  "Tomcat停机过程分析及线程处理方法"
title2:  "Tomcat停机过程分析及线程处理方法"
date:   2017-01-01 23:59:54  +0800
source:  "http://www.jfox.info/tomcat%e5%81%9c%e6%9c%ba%e8%bf%87%e7%a8%8b%e5%88%86%e6%9e%90%e5%8f%8a%e7%ba%bf%e7%a8%8b%e5%a4%84%e7%90%86%e6%96%b9%e6%b3%95.html"
fileName:  "20170101494"
lang:  "zh_CN"
published: true
permalink: "tomcat%e5%81%9c%e6%9c%ba%e8%bf%87%e7%a8%8b%e5%88%86%e6%9e%90%e5%8f%8a%e7%ba%bf%e7%a8%8b%e5%a4%84%e7%90%86%e6%96%b9%e6%b3%95.html"
---
{% raw %}
工作中经常遇到因为Tomcat shutdown时自己创建的线程因没有及时停止而引起的各种莫名其妙的报错，这篇文章将通过对Tomcat停机过程的梳理讨论产生这些错误的原因,同时提出了两个可行的解决办法。

## Tomcat停机过程分析 

一个Tomcat进程本质上是一个JVM进程，其内部结构如下图所示：（图片来自网络）
![](/wp-content/uploads/2017/08/1502147887.png)
从上至下分别为Server、service、connnector | Engine、host、context。

在实现中Engine和host只是一种抽象，更核心的功能在context中实现。顶层的Server只能有一个，一个Server可以包含多个Service，一个Service可以包含多个Connector和一个Continer。Continer是对Engine、Host或者Context的抽象。不严格的说，一个Context对应一个Webapp。

当Tomcat启动时，主线程的主要工作概括如下：

    public void start() {
    
        load();//config server and init it
        
        getServer().start();//start server and all continers belong to it
        
        Runtime.getRuntime().addShutdownHook(shutdownHook);// register the shutdown hook
        
        await();//wait here util the end of Tomcat Proccess
        
        stop();
    }
    

1. 
通过扫描配置文件（默认为server.xml）来构建从顶层Server开始到Service、Connector等容器（其中还包含了对Context的构建）。

2. 
调用Catalina的start方法，进而调用Server的start方法。start方法将导致整个容器的启动。

Server、Service、Connector、Context等容器都实现了Lifecycle接口，同时这些组件保持了严格的、从上至下的树状结构。Tomcat只通过对根节点（Server）的生命周期管理就可以实现对所有树状结构中其他所有容器的管理。

1. 
将自己阻塞于await()方法，await()方法会等待一个网络连接请求，当有用户连接到对应端口并发送指定字符串（通常是’SHUTDOWN’）时，await()返回，主线程继续执行。

2. 
主线程执行stop()方法。stop()方法将会从Server开始调用所有其下容器的stop方法。stop()方法执行完后，主线程退出，如果没有问题，Tomcat容器此时运行终止。

值得注意的是stop()方法自Service下面一层开始是异步执行的。代码如下：

    protected synchronized void stopInternal(){
    
        /*other code*/
        
        Container children[] = findChildren();
        List<Future<Void>> results = new ArrayList<Future<Void>>();
        for (int i = 0; i < children.length; i++) {
            results.add(startStopExecutor.submit(new StopChild(children[i])));
        }
        boolean fail = false;
        for (Future<Void> result : results) {
            try {
                result.get();
            } catch (Exception e) {
                log.error(sm.getString("containerBase.threadedStopFailed"), e);
                fail = true;
            }
        }
        if (fail) {
            throw new LifecycleException(
                    sm.getString("containerBase.threadedStopFailed"));
        }
        
        /*other code*/
    }
    

在这些被关闭的children中，按照标准应该是Engine-Host-Context这样的层状结构，也就是说最后会调用Context的stop()方法。在Context的stopInternal方法中会调用：

    filterStop();
    
    listenerStop();
    
    ((Lifecycle) loader).stop();
    

这三个方法。（这只是其中的一部分，因为与我们分析的过程有关所以列出来了，其他与过程无关的方法未予列出）

其中filterStop会清理我们在web.xml中注册的filter，listenerStop会进一步调用web.xml中注册的Listener的onDestory方法（如果有多个Listener注册，调用顺序与注册顺序相反）。而loader在这儿是WebappClassLoader，其中重要的操作（尝试停止线程、清理引用资源和卸载Class）都是在stop函数中做的。

如果我们使用的SpringWeb，一般web.xml中注册的Listener将会是：

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
    

看ContextLoaderListener的代码不难发现，Spring框架通过Listener的contextInitialized方法初始化Bean，通过contextDestroyed方法清理Bean。

    public class ContextLoaderListener extends ContextLoader implements ServletContextListener {
        public ContextLoaderListener() {
        }
    
        public ContextLoaderListener(WebApplicationContext context) {
            super(context);
        }
    
        public void contextInitialized(ServletContextEvent event) {
            this.initWebApplicationContext(event.getServletContext());
        }
    
        public void contextDestroyed(ServletContextEvent event) {
            this.closeWebApplicationContext(event.getServletContext());
            ContextCleanupListener.cleanupAttributes(event.getServletContext());
        }
    }
    

在这儿有一个重要的事：我们的线程是在loader中被尝试停止的，而loader的stop方法在listenerStop方法之后，也就是说即使loader成功终止了用户自己启动的线程，依然有可能在线程终止之前使用Sping框架，而此时Spring框架已经在Listener中关闭了！况且在loader的清理线程过程中只有配置了clearReferencesStopThreads参数，用户自己启动的线程才会被强制终止（使用Thread.stop()），而在大多数情况下为了保证数据的完整性，这个参数不会被配置。也就是说在WebApp中，用户自己启动的线程（包括Executors），都不会因为容器的退出而终止。我们知道，JVM自行退出的原因主要有两个：

- 
调用了System.exit()方法

- 
所有非守护线程都退出

而Tomcat中没有在stop执行结束时主动调用System.exit()方法，所以如果有用户启动的非守护线程，并且用户没有与容器同步关闭线程的话，Tomcat不会主动结束！这个问题暂且搁置，下面说说停机时遇到的各种问题。

## Tomcat停机过程中的异常分析 

### IllegalStateException 

在使用Spring框架的Webapp中，Tomcat退出时Spring框架的关闭与用户线程结束之间是有严重的同步问题的。在这段时间里（Spring框架关闭，用户线程结束前）会发生很多不可预料的问题。这些问题中最常见的就是IllegalStateException了。发生这样的异常的标准代码如下：

    public void run(){
        while(!isInterrupted()) {
            try {
                Thread.sleep(1000);
                GQBean bean = SpringContextHolder.getBean(GQBean.class);
                /*do something with bean...*/
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    

这种错误很容易复现，也很常见，不用多说。

### ClassNotFound/NullPointerException 

这种错误不常见，分析起来也比较麻烦。

在前面的分析中我们确定了两件事：

1. 用户创建的线程不会随着容器的销毁而停止。
2. ClassLoader在容器的停止过程中卸载了加载过的Class

很容易确定这又是线程没有结束引起的。

- 当ClassLoader卸载完毕，用户线程尝试去load一个Class时，报ClassNotFoundException或者NoClassDefFoundError。
- 在ClassLoader卸载过程中，因为Tomcat没有对停止容器进行严格的同步，此时如果尝试load一个Class可能会导致NullPointerException，原因如下：

    //part of load class code, may be executed in user thread
    protected ResourceEntry findResourceInternal(...){
        if (!started) return null;
        
        synchronized (jarFiles) {
            if (openJARs()) {
                for (int i = 0; i < jarFiles.length; i++) {
                    jarEntry = jarFiles[i].getJarEntry(path);
                        if (jarEntry != null) {
                        try {
                            entry.manifest = jarFiles[i].getManifest();
                        } catch (IOException ioe) {
                            // Ignore
                        }
                        break;
                    }
                }
            }
        }
        /*Other statement*/
    }
    

从代码中可以看到，对jarEntry的访问进行了非常谨慎的同步操作。在其他对jarEntry的使用处都有非常谨慎的同步，除了在stop中没有：

    // loader.stop() must be executed in stop thread
    public void stop() throws LifecycleException {
        /*other statement*/
        
        length = jarFiles.length;
        for (int i = 0; i < length; i++) {
            try {
                if (jarFiles[i] != null) {
                    jarFiles[i].close();
                }
            } catch (IOException e) {
                // Ignore
            }
            jarFiles[i] = null;
        }
        
        /*other statement*/
    }
    

可以看到，上面两段代码中，如果用户线程进入同步代码块后（此时会导致线程缓存区的刷新），started变为false跳过了更新jarFiles或者此时jarFiles[0]还未被置空，等到从openJARs返回后，stop正好执行过jarFiles[0]
{% endraw %}
