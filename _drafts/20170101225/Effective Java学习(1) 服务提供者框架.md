---
layout: post
title:  "Effective Java学习(1) 服务提供者框架"
title2:  "Effective Java学习(1) 服务提供者框架"
date:   2017-01-01 23:55:25  +0800
source:  "http://www.jfox.info/effectivejava%e5%ad%a6%e4%b9%a01%e6%9c%8d%e5%8a%a1%e6%8f%90%e4%be%9b%e8%80%85%e6%a1%86%e6%9e%b6.html"
fileName:  "20170101225"
lang:  "zh_CN"
published: true
permalink: "effectivejava%e5%ad%a6%e4%b9%a01%e6%9c%8d%e5%8a%a1%e6%8f%90%e4%be%9b%e8%80%85%e6%a1%86%e6%9e%b6.html"
---
{% raw %}
什么是服务提供者框架？服务提供者框架是指这一个系统:多个服务提供者来实现一个服务，系统为客户端的服务提供者提供多个实现，并且
把他们从多个实现中解耦出来。咋一看这个定义，一脸懵逼。那么我们就来看一下他们之间的关系图吧。

#### 关系图
![](/wp-content/uploads/2017/07/1499518243.png) 
 
   这里写图片描述 
  
  

#### 讲解

服务提供框架有4个组件，依次是服务接口，服务器提供者接口，提供者注册API，服务访问API。

- 
服务接口
在服务接口中定义一些提供具体服务的方法，假设我们要提供一个注册登录的服务UserService。那么这个服务接口中肯定有login(),register()方法。我们再去创建这个服务接口的具体实现类去实现login(),register()方法。

- 
服务提供者接口
在服务提供者接口里，就是去定义提供什么样子的服务的方法。我们上面创建了一个提供“注册登录”的服务。那么这里我们肯定要去定义一个能获取“注册登录”的服务的方法，假设是getUserService(),返回类型是UserService。然后在去创建服务提供者接口的具体实现类去这个getUserService()，那么我们怎么去实现呢？我们只需要返回一个UserService的具体实现类即可。

- 
提供者注册API
其实是服务提供者接口的具体实现类里面去注册这个API，在类中的静态初始化块中去注册API，因为你只有注册了API，才能享有享受服务的权利。这些注册过的服务集中交给ServiceManager管理。

- 
服务访问API
既然已经注册了API，那么我们可以向ServiceManager申请具体的服务，可以获得具体服务的实例，就可以调用服务里面的方法。服务访问API是“灵活的静态工厂”，它构成了服务提供者框架的基础。

#### JDBC

为什么要讲到JDBC?其实我们可以仔细回想一下JDBC的基本步骤，是不是和我们上面的步骤类似。没错，JDBC也是用到了服务提供者框架。

    Class.forName("com.mysql.jdbc.Driver");   
    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/test","root","cmazxiaoma");

- Class.forName()这个方法其实是利用反射的方法获得服务提供者接口的具体实现类。Connection就是服务接口，DriverManager就是我们上面提供的服务管理类，getConnection()就是从服务管理类里面获取指定名字的且已经注册过的服务。

- 
DriverManager.getConnection(“jdbc:mysql://localhost:3306/test”,”root”,”cmazxiaoma”);这个方法返回的是一个服务接口的具体实现类的实例，把这个实现类的实例赋值给Connection的服务接口，就可以调用具体服务的里面的一些方法，接口回调嘛。

- 
观看JDBC源码，JDBC中的服务接口具体实现类中其实调用了DriverManager.registerDriver（）静态工厂方法去注册服务的api。java.sql.Driver就是服务提供者接口，com.mysql.jdbc.Driver是服务提供者具体的实现类。

#### JAVA代码

    /**
     * 服务接口
     * @author Administrator
     *
     */
    
    public interface UserService {
    
        public void login();
    
        public void register();
    
    }

    package 服务提供者框架;
    
    /**
     * 服务具体实现类
     * @author Administrator
     *
     */
    public class UserServiceImpl implements UserService{
    
        @Override
        public void login() {
            // TODO Auto-generated method stub
            System.out.println("cmazxiaoma登录成功");
    
        }
    
        @Override
        public void register() {
            // TODO Auto-generated method stub
            System.out.println("cmazxiaoma注册成功");
        }
    
    
    }

      package 服务提供者框架;
    
    /**
     * 服务提供者接口
     * @author Administrator
     *
     */
    public interface UserProvider {
    
        public UserService getUserService();
    
    }

     package 服务提供者框架;
    
    /**
     * 服务提供者具体实现类
     * @author Administrator
     *
     */
    public class UserProviderImpl implements UserProvider{
    
        @Override
        public UserService getUserService() {
            // TODO Auto-generated method stub
            return new UserServiceImpl();
        }
    
    
        static{
            ServiceManager.registerProvider("登录注册",new UserProviderImpl());
        }
    
    }

      package 服务提供者框架;
    
    import java.util.Map;
    import java.util.concurrent.ConcurrentHashMap;
    
    /**
     * 服务提供者注册类
     * @author Administrator
     *
     */
    public class ServiceManager {
    
        private ServiceManager(){
    
        }
    
        private static final  Map<String,UserProvider> providers=new ConcurrentHashMap<String,UserProvider>();
    
        public static void  registerProvider(String name,UserProvider provider){
    
            providers.put(name, provider);
    
        }
    
        public static UserService getService(String name){
            UserProvider provider=providers.get(name);
            if(provider==null){
                throw new IllegalArgumentException("No provider registered with name="+name);
    
            }
            return provider.getUserService();
        }
    
    
    
    
    }

       package 服务提供者框架;
    
    
    /**
     * 测试类
     * @author Administrator
     *
     */
    public class test {
    
        public static void main(String[] args){
    
            try {
                Class.forName("服务提供者框架.UserProviderImpl");
                UserService userService=ServiceManager.getService("登录注册");
                userService.register();
                userService.login();
    
            } catch (ClassNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
    
        }
    }
{% endraw %}
