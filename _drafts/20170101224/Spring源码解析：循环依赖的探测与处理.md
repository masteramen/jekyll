---
layout: post
title:  "Spring源码解析：循环依赖的探测与处理"
title2:  "Spring源码解析：循环依赖的探测与处理"
date:   2017-01-01 23:55:24  +0800
source:  "https://www.jfox.info/spring%e6%ba%90%e7%a0%81%e8%a7%a3%e6%9e%90%e5%be%aa%e7%8e%af%e4%be%9d%e8%b5%96%e7%9a%84%e6%8e%a2%e6%b5%8b%e4%b8%8e%e5%a4%84%e7%90%86.html"
fileName:  "20170101224"
lang:  "zh_CN"
published: true
permalink: "2017/spring%e6%ba%90%e7%a0%81%e8%a7%a3%e6%9e%90%e5%be%aa%e7%8e%af%e4%be%9d%e8%b5%96%e7%9a%84%e6%8e%a2%e6%b5%8b%e4%b8%8e%e5%a4%84%e7%90%86.html"
---
{% raw %}
Spring 为开发人员提供了极其灵活和强大的配置方式，在方便使用的同时也为容器的初始化过程带来了不确定性，本篇所要介绍的循环依赖就是其中之一，尤其在一些大型项目中，循环依赖的配置往往是我们不经意而为之的，幸好 Spring 能够在初始化的过程中探测到对象之间的循环依赖，并能够在一定程度上对其进行处理。 

### 一. 什么是循环依赖 

以最简单的循环依赖举例，假设我们定义了两个类 A 和 B，如下：

    public class A{
    
        private String name;
    
        private B b;
    
        public A(){
        }
    
        public A(B b){
            this.b = b;
        }
    
        // 省略 getter 和 setter
    }
    

    public class B{
    
        private String name;
    
        private A a;
    
        public B(){
        }
    
        public B(A a){
            this.a = a;
        }
    
        // 省略 getter 和 setter
    }
    

我们看到 A 中定义有 B 类型的属性，而 B 中定义有 A 类型的属性，这个时候如果我们基于 Spring 容器来管理对象 A 和 B 之间的依赖关系，就会存在循环依赖的问题。

### 二. Spring 如何发现和处理循环依赖 

那么 Spring 如何探测和处理循环依赖呢？我们先给出结论：

Spring 仅能够处理单例对象之间基于 setter 注入方式造成的循环依赖，除此之外全部抛出 BeanCurrentlyInCreationException 异常。

也就是说如果按照如下配置，则容器能够正常的完成初始化：

    <!--单例：setter注入-->
    <beanid="a"class="org.zhenchao.cyclic.A">
        <propertyname="name"value="bean a"/>
        <propertyname="b"ref="b"/>
    </bean>
    <beanid="b"class="org.zhenchao.cyclic.B">
        <propertyname="name"value="bean b"/>
        <propertyname="a"ref="a"/>
    </bean>
    

而余下两种配置方式均会触发容器初始化出错：

    <!--单例：构造方法注入-->
    <beanid="a"class="org.zhenchao.cyclic.A">
        <constructor-argname="b"ref="b"/>
        <propertyname="name"value="bean a"/>
    </bean>
    <beanid="b"class="org.zhenchao.cyclic.B">
        <constructor-argname="a"ref="a"/>
        <propertyname="name"value="bean b"/>
    </bean>
    

    <!--原型：setter注入-->
    <beanid="a"class="org.zhenchao.cyclic.A"scope="prototype">
        <propertyname="name"value="bean a"/>
        <propertyname="b"ref="b"/>
    </bean>
    <beanid="b"class="org.zhenchao.cyclic.B"scope="prototype">
        <propertyname="name"value="bean b"/>
        <propertyname="a"ref="a"/>
    </bean>
    

那么 Spring 又是怎么发现我们的配置存在循环依赖的呢？首先我们先列出整个过程中需要用到的几个用于记录状态的集合属性：

-  singletonFactories：Map 
  
    > 类型，用于记录beanName和创建bean的工厂之间的关系 
   
-  singletonObjects: Map 
  
    类型，用于记录beanName和bean实例之间的关系 
   
-  earlySingletonObjects：Map 
  
    类型，用于记录beanName和原始bean实例之间的关系 
   

其中 singletonObjects 和 earlySingletonObjects 虽然都是记录 beanName 与 bean 实例之间的关系，但是区别在于当一个 bean 的实例记录在 earlySingletonObjects 中后，即使 bean 还在创建过程中，也可以通过 getBean 方法获取到，所以说二者存放的内容是互斥的。

这些集合属性涉及到的操作方法如下：

    // org.springframework.beans.factory.support.DefaultSingletonBeanRegistry#addSingletonFactory
    protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory){
        Assert.notNull(singletonFactory, "Singleton factory must not be null");
        synchronized (this.singletonObjects) {
            if (!this.singletonObjects.containsKey(beanName)) {
                this.singletonFactories.put(beanName, singletonFactory);
                this.earlySingletonObjects.remove(beanName);
                this.registeredSingletons.add(beanName);
            }
        }
    }
    

    // org.springframework.beans.factory.support.DefaultSingletonBeanRegistry#addSingleton
    protected void addSingleton(String beanName, Object singletonObject){
        synchronized (this.singletonObjects) {
            this.singletonObjects.put(beanName, (singletonObject != null ? singletonObject : NULL_OBJECT));
            this.singletonFactories.remove(beanName);
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }
    

    // org.springframework.beans.factory.support.DefaultSingletonBeanRegistry#getSingleton(java.lang.String, boolean)
    protectedObjectgetSingleton(String beanName,booleanallowEarlyReference){
        Object singletonObject = this.singletonObjects.get(beanName);
        if (singletonObject == null && this.isSingletonCurrentlyInCreation(beanName)) {
            synchronized (this.singletonObjects) {
                singletonObject = this.earlySingletonObjects.get(beanName);
                if (singletonObject == null && allowEarlyReference) {
                    ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                    if (singletonFactory != null) {
                        singletonObject = singletonFactory.getObject();
                        this.earlySingletonObjects.put(beanName, singletonObject);
                        this.singletonFactories.remove(beanName);
                    }
                }
            }
        }
        return (singletonObject != NULL_OBJECT ? singletonObject : null);
    }
    

记得我们之间在探究 bean 实例的创建和初始化过程时曾提到过在一个 bean 的实例创建出来之后，且在注入属性值之前，会执行如下这样一段代码：

    boolean earlySingletonExposure = (
        mbd.isSingleton() // 单例
                && this.allowCircularReferences // 允许循环依赖，需要通过程序设置
                && this.isSingletonCurrentlyInCreation(beanName)); // 当前 bean 正在创建中
    if (earlySingletonExposure) {
        if (logger.isDebugEnabled()) {
            logger.debug("Eagerly caching bean '" + beanName + "' to allow for resolving potential circular references");
        }
        // 为避免循环依赖，在完成bean实例化之前，将对应的ObjectFactory加入创建bean的工厂集合中
        this.addSingletonFactory(beanName, new ObjectFactory<Object>() {
            @Override
            publicObjectgetObject()throwsBeansException{
                // 对bean再一次依赖引用，应用SmartInstantiationAwareBeanPostProcessor
                return getEarlyBeanReference(beanName, mbd, bean);
            }
        });
    }
    

这段代码的核心就是调用了上面的列出的 addSingletonFactory 方法，将创建 bean 的 ObjectFactory 对象记录到 singletonFactories 属性中。

如果此时正好有另外一个操作试图获取正在创建中的单例 bean，则会进入上面列出的 getSingleton 方法，该方法将获取我们之前缓存的 ObjectFactory 对象，并调用对象的 getObject() 方法获取到我们之前创建的目标 bean 实例，并记录到 earlySingletonObjects 中，同时移除 singletonFactories 中的 ObjectFactory 对象。

而实例化过程也会很快调用上面列出的 addSingleton 方法，将完整的 bean 实例记录到 singletonObjects 属性中，并移除所有的临时记录。

再回到我们前面的例子，为什么用构造方法注入就会抛异常，而 setter 则不会呢，这是因为对于构造方法注入而言，在创建单例对象之前，Spring 会调用如下方法检查指定 bean 是否处于正在创建中，且不在免检的白名单里面：

    protected void beforeSingletonCreation(String beanName){
        if (!this.inCreationCheckExclusions.contains(beanName) && !this.singletonsCurrentlyInCreation.add(beanName)) {
            throw new BeanCurrentlyInCreationException(beanName);
        }
    }
    

这里先解释一下这两个属性：

-  singletonsCurrentlyInCreation：Set 
  
    类型，记录正在创建的 beanName 
   
-  inCreationCheckExclusions：Set 
  
    类型，beanName 集合，可以将其视为白名单 
   

beforeSingletonCreation 方法在每次创建对象之前都会被调用，对于创建同一个 bean 的第二次之后的调用就会触发该方法抛出异常，而我们在前面的例子中通过构造方法注入时，因为创建目标对象需要调用包含依赖对象类型参数的构造方法，而循环依赖势必导致该构造方法的循环调用，从而触发该方法抛出异常。但是对于 setter 注入来说就不存在这样的问题，因为 Spring 对于 bean 实例的构造是分两步走的，第一步完成对象的创建，第二步再执行对象的初始化操作，将相应的属性值注入到该对象中。这个情况下即使有循环依赖也不会阻碍对象的创建，因为这个时候调用的是无参数的构造方法（即使有参数，参数中也不包含循环依赖的对象），所以基于 setter 方法的单例对象循环依赖，容器的初始化机制能够很好的处理。

那么非单例的怎么就不行了呢？我们先来看一下源码的实现，容器会用一个 prototypesCurrentlyInCreation 集合变量来记录当前线程内正在创建的 beanName，并且在创建一个非单例 bean 之前，容器会调用如下方法进行校验：

    // org.springframework.beans.factory.support.AbstractBeanFactory#doGetBean
    if (this.isPrototypeCurrentlyInCreation(beanName)) {
        throw new BeanCurrentlyInCreationException(beanName);
    }
    

    protected boolean isPrototypeCurrentlyInCreation(String beanName){
        Object curVal = this.prototypesCurrentlyInCreation.get();
        return (curVal != null &&
                (curVal.equals(beanName) || (curVal instanceof Set && ((Set<?>) curVal).contains(beanName))));
    }
    

如果存在循环依赖则抛出 BeanCurrentlyInCreationException 异常。

Spring 为什么需要这样设计呢？网上有很多文章说是因为容器无法暴露一个正处于创建中的 bean，我个人觉得这不太科学。对于非单例来说，完全可以复用单例那一套来实现，只不过这些中间变量都是属于线程私有的，个人觉得 Spring 之所以没有这样设计是出于性能考虑，非单例对象的特性就是每次 getBean 都会返回一个新的对象，并且这个过程可能是频繁调用的，这样就会降低框架的性能，同时增加内存占用，而更多时候循环依赖是因为开发者的错误配置导致的，这个时候还不如直接抛出异常，快速失败为好。
{% endraw %}
