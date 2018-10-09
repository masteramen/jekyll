---
layout: post
title:  "Spring学习之动态代理"
title2:  "Spring学习之动态代理"
date:   2017-01-01 23:56:42  +0800
source:  "https://www.jfox.info/spring%e5%ad%a6%e4%b9%a0%e4%b9%8b%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86.html"
fileName:  "20170101302"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/spring%e5%ad%a6%e4%b9%a0%e4%b9%8b%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86.html"
---
{% raw %}
# Spring学习之动态代理 


作者[颜洛滨](/u/b1a604b2eaed)2017.07.13 20:29字数 1122
# Spring学习之动态代理

## 前言

动态代理，是一种通过运行时操作字节码，以达到增强类的功能的技术，也是Spring AOP操作的基础，关于AOP的内容，将在后面的笔记中详细讲解，本小节主要是理清楚动态代理，毕竟，Spring的AOP是基于动态代理技术，对动态代理技术有所了解，对于学习Spring AOP也会有帮助

## 动态代理技术详解

动态代理，现在主要是用于增强类的功能，同时由于是具有动态性，所以避免了需要频繁创建类的操作，同时，也使得原有的代码在不需要改变的情况下，对类的功能进行增强，主要的动态代理技术有：通过实现目标接口，重写其方法，以增强其能力，典型的以JDK动态代理为代表；或者，通过继承类，重写其方法以增强其能力，典型的以CGLib为代表，这两种技术分别从不同的方向来对类的能力进行扩充，接下来来具体看下这两种技术的特点以及差异。

### 基于JDK动态代理

基于JDK的动态代理技术，其主要特点就是目标类，也就是需要被代理的类，必须有接口，并且代理类必须实现跟它一样的接口，从而来起到代理其事务的功能，具体使用如下代码所示，假设有一个UserService类，主要用于负责用户的登录和退出，同时，有个日志类，负责记录用户的操作信息，直接将信息日志写在对应的UserService实现类中，可以达到目的，但显然这种方式不是很合理，特别是在UserService有很多个方法需要做日志记录的时候，就会使得日志记录代码遍布整个UserService，不仅使得代码的冗余很大，而且当需要进行修改的时候，也需要逐个修改，非常麻烦，这个时候，采用动态代理技术就是一种非常好的方法了。

    /**
     * UserService接口
     */
    interface UserService{
    
        void login();
        void logout();
    }
    
    /**
     * UseService实现类
     */
    class UserServiceImpl implements UserService{
    
        @Override
        public void login() {
            System.out.println("someone login....");
        }
    
        @Override
        public void logout() {
            System.out.println("someone logout....");
        }
    }
    
    
    /**
     * 实现InvocationHandle接口，用于织入所要增强的代码
     */
    class UserServiceHandle implements InvocationHandler{
    
        private UserService userService;
    
        public UserServiceHandle(UserService userService) {
            this.userService = userService;
        }
    
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    
            LogService.info();
            Object object = method.invoke(userService, args);
            LogService.info();
            return object;
        }
    }
    
    /**
     * 代理类工厂，用于产生UseService类的代理类
     */
    class ProxyFactory{
    
        public static UserService getProxyObject(UserService userService){
    
            // 使用JDK动态代理技术来创建对应的代理类
            return (UserService) Proxy.newProxyInstance(
                    userService.getClass().getClassLoader(),
                    userService.getClass().getInterfaces(),
                    new UserServiceHandle(userService)
            );
        }
    }

这样，当我们需要使用UseService类的时候，只需要从ProxyFactory中获取即可，而且获取的对象是UserService对象的代理类，也就是说，获得的对象是UserService对象的增强版

### 基于CGLib的动态代理技术

从上面的ProxyFactory工厂中可以看到，在使用JDK进行创建动态代理对象的时候，需要为其提供接口，或者说，如果所要增强的目标类没有实现任何接口，则JDK动态代理技术是无法为其创建对应的代理对象的，这是JDK动态代理技术的一种缺点，而CGLib动态代理技术则恰好弥补了这个缺点，CGLib动态代理技术使用的是继承该类的方式，从而避免了需要接口的缺陷，具体使用如下所示，注意，需要导入对应的依赖文件

    /**
     * 基于CGLib的动态代理技术
     * 注意这里需要实现MethodInterceptor接口
     */
    class ProxyFactory implements MethodInterceptor{
    
        // 提供对应的增强操作类
        private  Enhancer enhancer = new Enhancer();
    
        public UserService getProxyObject(Class clazz){
            // 设置所要增强的类的父类
            enhancer.setSuperclass(clazz);
            // 设置回调对象
            enhancer.setCallback(this);
            // 创建对应的对象
            return (UserService) enhancer.create();
        }
    
        // 实现拦截方法，用于拦截对应的方法，并且对对应的方法进行增强
        // 参数含义：传入的对象， Method对象，方法的参数，进行代理后的Method对象
        @Override
        public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
    
            LogService.info();
            // 这里需要注意，由于methodProxy对象是增强后的Method对象，所以这里需要调用的
            // 是methodProxy父类的方法，也就是所以增强的类的方法，以实现原来的功能
            Object object = methodProxy.invokeSuper(o, objects);
            LogService.info();
            return object;
        }
    }

可以看到，使用CGLib动态代理技术可以在不需要实现接口的情况下东塔为对象创建代理对象，在很大程度上弥补了JDK动态代理技术的缺点，不过由于CGLib动态代理技术是采用继承目标类的方式，所以也存在一些问题，比如说，对于final以及private修饰的方法是无法为其增强的，这里还需要注意一下。

## 总结

动态代理技术是实现AOP技术的基础，也是一种很方便地实现方式，常用的动态代理技术有基于JDK动态代理技术以及基于CGLib的动态代理技术，两种技术各有千秋，也都各有缺点基于JDK的动态代理技术需要为其提供接口，基于CGLib的动态代理技术不能为final以及private修饰的方法进行增强，在使用的时候需要根据具体进行进行合理选择。
{% endraw %}
