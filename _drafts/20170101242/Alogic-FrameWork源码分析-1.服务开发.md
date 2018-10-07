---
layout: post
title:  "Alogic-FrameWork源码分析-1.服务开发"
title2:  "Alogic-FrameWork源码分析-1.服务开发"
date:   2017-01-01 23:55:42  +0800
source:  "http://www.jfox.info/alogicframework%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%901%e6%9c%8d%e5%8a%a1%e5%bc%80%e5%8f%91.html"
fileName:  "20170101242"
lang:  "zh_CN"
published: true
permalink: "alogicframework%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%901%e6%9c%8d%e5%8a%a1%e5%bc%80%e5%8f%91.html"
---
{% raw %}
## 1.0 Alogic-FrameWork介绍

Alogic-FrameWork是一个轻量级的Java服务框架，源代码位于[Alogic-Github](http://www.jfox.info/go.php?url=https://github.com/anylogic/alogic.git)。具有快速开发服务的特点，在alogic-framework下，一个成熟的Java开发者可以快速的开发出实现自己业务逻辑的Restful服务。在这里我们不谈具体的开发逻辑，而是专注于分析该框架的源码。
Alogic-FrameWork的一个HelloWorld级别代码如下：[Alogic的HelloWorld-Github](http://www.jfox.info/go.php?url=https://github.com/anylogic/alogic/blob/master/alogic-doc/alogic-framework/001.md)
其中主要包括以下几个部分：

1. 
HelloWorld.java 服务调用的具体内容

2. 
web.xml web项目构建的配置文件

3. 
settings.xml Alogic服务目录配置文件

4. 
servant.xml 服务描述配置文件

## 1.1 服务初始化入口

服务由servlet进行拦截，servlet-class对请求进行处理，并返回响应。

在一个HelloWorld级别的应用中，一个典型的web.xml配置如下：

    <servlet>
        <display-name>MessageRouter</display-name>
        <servlet-name>MessageRouter</servlet-name>
        <servlet-class>com.anysoft.webloader.ServletAgent</servlet-class>
        <init-param>
            <param-name>handler</param-name>
            <param-value>com.logicbus.backend.server.http.MessageRouterServletHandler</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>MessageRouter</servlet-name>
        <url-pattern>/services/*</url-pattern>
    </servlet-mapping>

服务通过注册ServletAgent类拦截/services/*的全部路由，其中初始化参数handler为MessageRouterServletHandler类。我们来看一下如何进行这个过程：

## 1.2 服务上下文的处理

ServletAgent是一个代理类，继承自HttpServlet，主要代理了Servlet的初始化、执行和销毁，其中重写了init(ServletConfig servletConfig)，它通过ClassLoader类加载器加载实际处理的ServletHandler，并由ServletHandler去执行它的初始化方法。

    public void init(ServletConfig servletConfig) throws ServletException {
        // 获取handler参数
        String handlerClass = servletConfig.getInitParameter("handler");
        // 获取当前Servlet的上下文
        ServletContext sc = servletConfig.getServletContext();
        // 获取当前web项目类加载器
        ClassLoader classLoader = (ClassLoader) sc.getAttribute("classLoader");
        if (classLoader != null) {
            try {
                //创建Handler实例
                handler = (ServletHandler) classLoader.loadClass(handlerClass)
                        .newInstance();
                //执行Handler的初始化方法
                handler.init(servletConfig);
            } catch (Exception e) {
                logger.error("Error occurs when creating handler:"
                        + handlerClass, e);
            }
        } else {
            logger.error("Can not find classLoader");
        }
    }

ServletHandler是一个接口，重新封装了关于Servlet的init、service、destory方法；在web.xml中需要配置它的实现方法，MessageRouterServletHandler是它的具体实现类，在init实现方法中，设置了一些关键属性，如Http的编码、跨域、缓存等属性，以及获取服务id、目录、访问控制等。

在doService实现方法中，将上述初始化的一些列属性设置，达到重新封装Http请求的目的；service方法初始化Context，并将参数作为输入传入到action方法中。如下：

        // 初始化HttpContext,HttpContext是Context类的一个实现，它是一个封装后的Http请求的上下文。
        HttpContext ctx = new HttpContext(request,response,encoding,interceptMode);
        // 获取当前服务路径的id
        Path id = normalizer.normalize(ctx, request);
        MessageRouter.action(id,ctx,ac);

![](/wp-content/uploads/2017/07/1499957103.png)

## 1.3 服务请求过程

上文提到过，MessageRouterServletHandler实现了ServletHandler接口，将Http上下文封装起来，同时将doService方法中获取得到的服务id，访问控制给MessageRouter的action方法。MessageRouter是Alogic的消息路由器，是具体负责每一个请求的路由过程。在action方法中，包括以下逻辑：

1. 
处理路由追踪

2. 
获取服务实例池

3. 
通过访问控制器分配访问优先级

4. 
从服务实例池获取实例

5. 
日志记录

首先，MessageRouter根据获取得到的服务id来获取一个服务实例池，通过资源池模式来保证服务实例的不断重复利用。资源池获取代码如下：

            // 获取服务实例池
            ServantFactory factory = servantFactory;
            // 根据服务id获取服务工厂
            pool = factory.getPool(id);        
            if (!pool.isRunning()){
                throw new ServantException("core.service_paused",
                    "The Service is paused:service id:" + id);
            }

而接着，对于已经获得的资源池中根据优先级获得服务实例。在非线程模式下调用execute()方法，在多线程模式下创建服务工作线程。当执行结束后，向服务池归还资源。

            //从服务实例池中拿服务实例，并执行
            servant = pool.borrowObject(priority);
            // 判断是否获取到了服务并输出错误日志
            if (servant == null){
                logger.warn("Can not get a servant from pool in the limited time,check servant.queueTimeout variable.");
                ctx.setReturn("core.time_out", "Can not get a servant from pool in the limited time,check servant.queueTimeout variable.");
            }else{
                   if (!threadMode){
                    //在非线程模式下,不支持服务超时
                    execute(servant,ctx);
                }else{
                    // 构建CountDownLatch，用于等待服务工作线程创建。
                    CountDownLatch latch = new CountDownLatch(1);
                    //创建服务工作线程
                    ServantWorkerThread thread = new ServantWorkerThread(servant,ctx,latch,tc != null ? tc.newChild() : null);
                    thread.start();
                    // 判断服务工作线程是否在指定的时间内创建完成。如果超时则取消主线程阻塞状态，并
                    if (!latch.await(servant.getTimeOutValue(), TimeUnit.MILLISECONDS)){
                        ctx.setReturn("core.time_out","Time out or interrupted.");
                    }
                    thread = null;
                }
            }
        }catch (ServantException ex){
            ctx.setReturn(ex.getCode(), ex.getMessage());
            logger.error(ex.getCode() + ":" + ex.getMessage());
        }catch (Exception ex){
            ctx.setReturn("core.fatalerror",ex.getMessage());
            logger.error("core.fatalerror:" + ex.getMessage(),ex);
        }catch (Throwable t){
            ctx.setReturn("core.fatalerror",t.getMessage());
            logger.error("core.fatalerror:" + t.getMessage(),t);            
        }
        finally {
                ctx.setEndTime(System.currentTimeMillis());
                if (ctx != null){
                    // 完成Context
                    ctx.finish();
                }
                if (pool != null){
                    if (servant != null){
                        // 向服务池归还资源
                        pool.returnObject(servant);        
                    }
                    // 服务池访问一次                
                    pool.visited(ctx.getDuration(),ctx.getReturnCode());
                    if (ac != null){
                        ac.accessEnd(sessionId,id, pool.getDescription(), ctx);
                    }                
                }                        
                if (bizLogger != null){                
                    //需要记录日志
                    log(id,sessionId,pool == null ? null : pool.getDescription(),ctx);
                }
                if (tracerEnable){
                    boolean ok = ctx.getReturnCode().equals("core.ok");
                    Tool.end(tc, "ALOGIC", id.getPath(), ok ?"OK":"FAILED", ok ? ctx.getQueryString() : ctx.getReason(), ctx.getContentLength());
                }
            }

在非线程模式下的execute方法执行了服务调用的前置方法、执行方法和后置方法。

        protected static int execute(Servant servant,Context ctx) throws Exception {
            servant.actionBefore(ctx);
            servant.actionProcess(ctx);
            servant.actionAfter(ctx);
            return 0;
        }

在多线程模式下，同样也是在服务线程中执行Servant接口的三种方法。

        public void run(){
            TraceContext tc = null;
            if (traceCtx != null){
                tc = Tool.start(traceCtx.sn(), traceCtx.order());
            }
            boolean error = false;
            try
            {
                m_servant.actionBefore(m_ctx);
                m_servant.actionProcess(m_ctx);
                m_servant.actionAfter(m_ctx);
            }
        }

## 1.4 服务响应

在MessageRouter的acion方法中，服务调用的最后会调用ctx.finish()，在这个方法中调用了msg的finish方法。

        try {
                if (!isIgnore()){
                    if (msg == null){
                        if (getReturnCode().equals("core.ok")){
                            response.sendError(404, "No message is found,check servant implemention.");
                        }else{
                            response.sendError(404, getReturnCode() + ":" + getReason());
                        }
                    }else{
                        response.setCharacterEncoding(encoding);
                        msg.finish(this,!cometMode());
                    }
                }
            }

Message是一个接口，主要代表服务输出的消息实例。在Alogic中，Message可以有XML、JSON等协议的消息实例，如输出为RawMessage时，finish方法如下：

        public void finish(Context ctx,boolean closeStream) {
            // 设置输出流
            OutputStream out = null;
            try {
                // 设置返回内容格式
                ctx.setResponseContentType(contentType);
                out = ctx.getOutputStream();
                byte [] bytes = buf.toString().getBytes(ctx.getEncoding());
                contentLength += bytes.length;
                // 将字符串写到输出流中
                Context.writeToOutpuStream(out, bytes);
                // 输出打印
                out.flush();
            }catch (Exception ex){
                logger.error("Error when writing data to outputstream",ex);
            }finally{
                if (closeStream)
                IOTools.close(out);
            }
        }

到此，一个服务的执行逻辑如下：
![](/wp-content/uploads/2017/07/1499957104.png)
{% endraw %}
