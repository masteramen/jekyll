---
layout: post
title:  "Java for Web学习笔记（七一）：Service和Repository（6）在Spring框架中使用Listener"
title2:  "Java for Web学习笔记（七一）：Service和Repository（6）在Spring框架中使用Listener"
date:   2017-01-01 23:55:15  +0800
source:  "https://www.jfox.info/javaforweb%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0%e4%b8%83%e4%b8%80service%e5%92%8crepository6%e5%9c%a8spring%e6%a1%86%e6%9e%b6%e4%b8%ad%e4%bd%bf%e7%94%a8listener.html"
fileName:  "20170101215"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/javaforweb%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0%e4%b8%83%e4%b8%80service%e5%92%8crepository6%e5%9c%a8spring%e6%a1%86%e6%9e%b6%e4%b8%ad%e4%bd%bf%e7%94%a8listener.html"
---
{% raw %}
Listener是Servlet的，不属于Spring framework，也就是说我们无法在Listener中主动注入Spring bean。本学习将解决这个问题。

## 进一步了解Spring的bean注入

 在解决之前，我们先进一步了解Spring的注入机制。在Spring中，我们可以使用@Inject，@Anwired，@Resource等方式实现对自动扫描和自动注入。 同一上下文环境中，bean只实例化一次，在不同类中注入的，都是同一个bean（同一对象） 。我们通常在根上下文中进行扫描，即使我们在不同的类中都进行注入，实际是注入的是同一个对象的。 

我们将通过小测试来验证这点。

### 小测试：设置Service

设置一个简单的Service，打印对象地址，同时在构造函数中给出log，看看在哪个阶段进行实例化。

    public interface MyTestService {
        public void whoAmI(String className);
    }

    @Service
    public class MyTestServiceImpl implements MyTestService{
        private static final Logger log = LogManager.getLogger();
    
        public MyTestServiceImpl(){
            log.info("MyTestServiceImpl instance is created, address is " + this);
        }
    
        @Override
        public void whoAmI(String className) {
            log.info("{} : {}" , className,this);        
        }
    }

### 小测试：注入该Service

在AuthenticationController中

    @Controller
    public class AuthenticationController {
        @Inject private AuthenticationService authenticationService;
    
        @RequestMapping(value="login",method=RequestMethod.GET)
        public ModelAndView login(Map<String,Object> model,HttpSession session){
            myTestService.whoAmI(this.getClass().getName());
            ... ... 
        }
        ... ... 
    }

在TicketController中

    @Controller
    @RequestMapping("ticket")
    public class TicketController {
        @Inject private MyTestService myTestService;
    
        @RequestMapping(value = {"", "list"}, method = RequestMethod.GET)
        public String list(Map<String,Object> model){
            this.myTestService.whoAmI(this.getClass().getName());
            ... ... 
        }
    }

输出结果：

    14:19:19.985 [localhost-startStop-1] [INFO ] (Spring) ContextLoader - Root WebApplicationContext: initialization started
    ... ...
    14:19:20.633 [localhost-startStop-1] [INFO ] (Spring) AutowiredAnnotationBeanPostProcessor - JSR-330 'javax.inject.Inject' annotation found and supported for autowiring
    14:19:20.934 [localhost-startStop-1]  [INFO ] MyTestServiceImpl:12 <init>() - MyTestServiceImpl instance is created, address is cn.wei.flowingflying.customer_support.site.test.MyTestServiceImpl@407cec
    ... ...
    六月 23, 2017 2:19:21 下午 org.apache.catalina.core.ApplicationContext log
    信息: Initializing Spring FrameworkServlet 'springDispatcher'
    ... ...
    14:19:23.217 [http-nio-8080-exec-5]  [INFO ] MyTestServiceImpl:16 whoAmI() - cn.wei.flowingflying.customer_support.site.AuthenticationController : cn.wei.flowingflying.customer_support.site.test.MyTestServiceImpl@407cec
    ... ...
    14:19:36.195 [http-nio-8080-exec-8] wei [INFO ] MyTestServiceImpl:16 whoAmI() - cn.wei.flowingflying.customer_support.site.TicketController : cn.wei.flowingflying.customer_support.site.test.MyTestServiceImpl@407cec

我们看到在AuthenticationController和TicketController中注入的对象实际地址一样，都是407cec，即为同一对象,是在Root Context中被实例化，且只实例化一次。了解这点非常重要，不同Controller对某个注入的Service进行操作，是可能相互影响的。

## 在Listener 中实现注入实例

### 无法直接在Listener中自动注入

Listener是Serlvet container的，不是Spring framework的，不是任何的Spring Component，不在自动扫描的范围内，我们在里面标记的任何@Inject不会被注入。

我们创建一个Session Listener作测试

    @WebListener
    public class WeiTempListener implements HttpSessionListener {
        private static final Logger log = LogManager.getLogger();
        @Inject private MyTestService myTestService;
    
        public WeiTempListener() { }
    
        public void sessionCreated(HttpSessionEvent se)  { 
            log.info("------------------------------------");
            this.myTestService.whoAmI(this.getClass().getName());
        }
    
        public void sessionDestroyed(HttpSessionEvent se)  { }
    }

    14:50:31.164 [http-nio-8080-exec-4]  [INFO ] WeiTempListener:32 sessionCreated() - ------------------------------------
    六月 23, 2017 2:50:31 下午 org.apache.catalina.session.StandardSession tellNew 
    严重: Session event listener threw exception
    java.lang.NullPointerException
          at cn.wei.flowingflying.customer_support.site.WeiTempListener.sessionCreated(WeiTempListener.java:33)

### 实现方式

前面已经看到注入的实例化是在Root Context中进行。我们需要在Listener的初始化过程中，想办法从Root Context中获得实例。我们需要：

1.  跟踪发现，Listener的初始化是RootContext的初始化之前，这时是无法获取bean的。因此 
  
- 删除 @WebListener的标记，否则无法确保初始化的顺序
- 在BootStrap中，在Root Context的初始化后加载Listener，确保能够获取在Root Context中实例化的bean

2. HttpSessionListener封装很好，不开放初始化接口，因此需要增加继承ServletContextListener，以便暴露初始化的方法，在初始化中作为bean。
3. 使用org.springframework.beans.factory.annotation.Configurable标注对于非Spring管理的bean。

    public class BootStrap implements WebApplicationInitializer{
        @Override
        public void onStartup(ServletContext container) throws ServletException {
            container.getServletRegistration("default").addMapping("/resource/*");
    
            AnnotationConfigWebApplicationContext rootContext =  new AnnotationConfigWebApplicationContext();
            rootContext.register(RootContextConfiguration.class);
            container.addListener(new ContextLoaderListener(rootContext));
            //【1】设置Listener的加载位置，在完成Root Context之后
            container.addListener(WeiTempListener.class);
            ... ...
        }
    }

我们再看看WeiTempListener

    //【1】删除@WebListener标记，采用手动在BootStrap中加入
    //【2】增加ServletContextListener接口，以获得初始化入口
    public class WeiTempListener implements HttpSessionListener,ServletContextListener {
        private static final Logger log = LogManager.getLogger();
        @Inject private MyTestService myTestService;
     
        public WeiTempListener() {
            // 这在Root Context初始化之前执行，因此我们不能在构造函数中进行设置
            log.info("-----------------WeiTempListener-------------------");
        }
    
        public void sessionCreated(HttpSessionEvent se)  {         
            this.myTestService.whoAmI(this.getClass().getName());  // 测试
        }
    
        public void sessionDestroyed(HttpSessionEvent se)  {    }
    
        //【3】在contextInitialized()中获得Spring的rootContext实例
        @Override
        public void contextInitialized(ServletContextEvent event) {
            // 根据BoorStrap的执行顺序，这时RootContext的初始化已经完成，包括Service的实例化，可以注入。
            // 无法自动注入是因为Listerner并不是Spring的bean（如不是@Controller），我们要想办法手动让Listerner成为bean。
            // （1）获取Spring的root WebApplicationContext
            WebApplicationContext rootContext = 
                        WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());
            // （2）获取根上下文扫描和注入bean的factory
            AutowireCapableBeanFactory factory = rootContext.getAutowireCapableBeanFactory();
            // （3）无法扫描是因为Listener不是Spring的bean，类上没有加spring的annotation，我们需要手动设置这个对象（this）作为Factory中的一个bean，这样才能对里面的属性进行注入
            factory.autowireBeanProperties(this, AutowireCapableBeanFactory.AUTOWIRE_BY_TYPE,true);
            // （4）在factory中对这个新的bean进行初始化。
            factory.initializeBean(this,"WeiTempListener");
            log.info(this.myTestService); //测试一下注入情况 
        }
    
        public void contextDestroyed(ServletContextEvent sce) { }
    }

### 限制说明

虽然我们将Listener手动设置为fatory可以认识的bean，但仍不是spring下一个真正意义的bean。其他的bean中不能将其注入，部分地我们可以通过factory的registerSingleton()，将其设置为singleton bean来解决（即确保注入的都是同一的bean），但依然收到限制，有些内容仍无法正常执行，如计划执行，构造后和注销前的回调函数。

## SessionListener的具体应用例子

### webSocket chat例子

这个小例子场景，我们在下一学习中继续使用，再此作个说明，用户请求帮助（通过websocket发其chat），客服（另一用户）选择需要帮助的用户（加入chat），双方之间进行通话：

- 用户和web app之间创建web socket连接A，客服（另一用户）和web app之间创建web socket连接B，web app关联这两段连接之间的消息收发。
- web app在web socket中定时向浏览器发送ping消息，并监听响应的pong消息。
-  用户的名字将根据登录信息自动获取，用户退出，chat也将关闭 
  
- 通过SessionRegisterService来维护所有的在线http session
- 将存放在session中的username方在请求的principal中，方便获取

在webSocket chat中我们通过SessionRegisterService打算维护在线的session。对用户退出登录（主动退出，session超时而被删除）时，如果该用户在chat中，需要行chat close动作，可以利用Consumer进行触发。

### SessionRegisterService

    public interface SessionRegistryService {
        public void addSession(HttpSession session);
        public void updateSessionId(HttpSession session, String oldSessionId);
        public void removeSession(HttpSession session);
        /** 注册回调函数 用户开启chat进行回掉函数或者触发函数的注册 */ 
        public void registerOnRemoveCallback(Consumer<HttpSession> callback);
        /** 注销回掉函数 用户关闭chat进行注销 */
        public void deregisterOnRemoveCallback(Consumer<HttpSession> callback);
    }

### SessionListener

SessionListener没有什么特别：

1. 允许SessionRegisterService的注入，前面刚刚学习
2. 对create/change Id/remove session是调用service的add/update和remove接口

    public class SessionListener implements HttpSessionListener, ServletContextListener {
        @Inject private SessionRegistryService sessionRegistryService;
    
        public void sessionCreated(HttpSessionEvent event)  { 
            this.sessionRegistryService.addSession(event.getSession());
        }
    
        public void sessionIdChanged(HttpSessionEvent event, String oldSessionId)  { 
            this.sessionRegistryService.updateSessionId(event.getSession(), oldSessionId);
        }
    
        public void sessionDestroyed(HttpSessionEvent event)  { 
             this.sessionRegistryService.removeSession(event.getSession());
        }
    
        @Override
        public void contextInitialized(ServletContextEvent event) {
            .... 见前面 ....
        }
        ... ...
    }

### SessionRegistryService的实现

    @Service
    public class DefaultSessionRegistryService implements SessionRegistryService{
        private final Map<String, HttpSession> sessions = new Hashtable<>();
        /** Consumer的具体操作是：如果httpSession相同，则删除，里面已经进行了判断，所以就不需要Predicate */
        private final Set<Consumer<HttpSession>> callbacks = new HashSet<>();
        /** callbacksAddesWhileLocked是个比较有意思的处理，需要学习：
         *  我们几乎同时收到了同一个用户（同一个httpSession）要求退出登录 和 chat申请的两个操作，一般来讲虽然不会如此，多页面的请求有可能会造成几乎同时到达，由或者session到期的瞬间。callbacksAddedWhileLocked用于对这个时间差的session进行处理，即请求加入，然后马上推出登录，即removeSession()和registerOnRemoveCallback()几乎同时操作。理想顺序是有先后，而不是同时进行，但实际多线程运行的顺序无法保证。callbacksAddedWhileLocked来避免同时运行的问题。 */
        private final Set<Consumer<HttpSession>> callbacksAddedWhileLocked = new HashSet<>();
    
        @Override
        public void addSession(HttpSession session) {
            this.sessions.put(session.getId(), session);        
        }
    
        @Override
        public void updateSessionId(HttpSession session, String oldSessionId) {
            synchronized(this.sessions) {
                this.sessions.remove(oldSessionId);
                addSession(session);
            }
        }
    
        @Override
        public void removeSession(HttpSession session) {
            this.sessions.remove(session.getId());
            synchronized(this.callbacks){
                this.callbacksAddedWhileLocked.clear();
                this.callbacks.forEach(c -> c.accept(session));
                try {
                    this.callbacksAddedWhileLocked.forEach(c -> c.accept(session));
                } catch(ConcurrentModificationException ignore) { }
            }        
        }
    
        @Override
        public void registerOnRemoveCallback(Consumer<HttpSession> callback) {
            this.callbacksAddedWhileLocked.add(callback);
    
            synchronized(this.callbacks){
                this.callbacks.add(callback);
            }        
        }
    
        @Override
        public void deregisterOnRemoveCallback(Consumer<HttpSession> callback) {
            synchronized(this.callbacks){
                this.callbacks.remove(callback);
            }        
        }
    }
{% endraw %}
