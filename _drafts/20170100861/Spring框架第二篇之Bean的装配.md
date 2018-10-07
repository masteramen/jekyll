---
layout: post
title:  "Spring框架第二篇之Bean的装配"
title2:  "Spring框架第二篇之Bean的装配"
date:   2017-01-01 23:49:21  +0800
source:  "http://www.jfox.info/spring_kuang_jia_di_er_pian_zhi_bean_de_zhuang_pei.html"
fileName:  "20170100861"
lang:  "zh_CN"
published: true
permalink: "spring_kuang_jia_di_er_pian_zhi_bean_de_zhuang_pei.html"
---
{% raw %}
代码通过getBean();方式从容器中获取指定的Bean实例，容器首先会调用Bean类的无参构造器，创建空值的实例对象。

举例：

首先我在applicationContext.xml配置文件中配置了一个bean：

    <?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="
            http://www.springframework.org/schema/beans 
            http://www.springframework.org/schema/beans/spring-beans.xsd"><!-- 注册Service 这里相当于容器做了SomeServiceImpl myService = new SomeServiceImpl(); --><bean id="myService" class="com.ietree.spring.basic.ioc.SomeServiceImpl"/></beans>

此时程序会报以下的错误：

    org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'myService' defined in class path resource [applicationContext.xml]: Instantiation of bean failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate [com.ietree.spring.basic.ioc.SomeServiceImpl]: No default constructor found; nested exception is java.lang.NoSuchMethodException: com.ietree.spring.basic.ioc.SomeServiceImpl.<init>()
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.instantiateBean(AbstractAutowireCapableBeanFactory.java:1155)
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBeanInstance(AbstractAutowireCapableBeanFactory.java:1099)
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:513)
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:483)
        at org.springframework.beans.factory.support.AbstractBeanFactory$1.getObject(AbstractBeanFactory.java:306)
        at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:230)
        at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:302)
        at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:197)
        at org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:761)
        at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:867)
        at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:543)
        at org.springframework.context.support.ClassPathXmlApplicationContext.<init>(ClassPathXmlApplicationContext.java:139)
        at org.springframework.context.support.ClassPathXmlApplicationContext.<init>(ClassPathXmlApplicationContext.java:83)
        at com.ietree.spring.basic.test.MyTest.testConstrutor(MyTest.java:67)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
        at java.lang.reflect.Method.invoke(Unknown Source)
        at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:50)
        at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12)
        at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47)
        at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17)
        at org.junit.runners.ParentRunner.runLeaf(ParentRunner.java:325)
        at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:78)
        at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:57)
        at org.junit.runners.ParentRunner$3.run(ParentRunner.java:290)
        at org.junit.runners.ParentRunner$1.schedule(ParentRunner.java:71)
        at org.junit.runners.ParentRunner.runChildren(ParentRunner.java:288)
        at org.junit.runners.ParentRunner.access$000(ParentRunner.java:58)
        at org.junit.runners.ParentRunner$2.evaluate(ParentRunner.java:268)
        at org.junit.runners.ParentRunner.run(ParentRunner.java:363)
        at org.eclipse.jdt.internal.junit4.runner.JUnit4TestReference.run(JUnit4TestReference.java:86)
        at org.eclipse.jdt.internal.junit.runner.TestExecution.run(TestExecution.java:38)
        at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:459)
        at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.runTests(RemoteTestRunner.java:678)
        at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.run(RemoteTestRunner.java:382)
        at org.eclipse.jdt.internal.junit.runner.RemoteTestRunner.main(RemoteTestRunner.java:192)
    Caused by: org.springframework.beans.BeanInstantiationException: Failed to instantiate [com.ietree.spring.basic.ioc.SomeServiceImpl]: No default constructor found; nested exception is java.lang.NoSuchMethodException: com.ietree.spring.basic.ioc.SomeServiceImpl.<init>()
        at org.springframework.beans.factory.support.SimpleInstantiationStrategy.instantiate(SimpleInstantiationStrategy.java:85)
        at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.instantiateBean(AbstractAutowireCapableBeanFactory.java:1147)
        ... 36 more
    Caused by: java.lang.NoSuchMethodException: com.ietree.spring.basic.ioc.SomeServiceImpl.<init>()
        at java.lang.Class.getConstructor0(Unknown Source)
        at java.lang.Class.getDeclaredConstructor(Unknown Source)
        at org.springframework.beans.factory.support.SimpleInstantiationStrategy.instantiate(SimpleInstantiationStrategy.java:80)
        ... 37 more

解析：这里的错误报的很明显，没有发现默认的构造器。

修改：为该类加上无参构造器：

    package com.ietree.spring.basic.ioc;
    /**
     * 实现类
     * 
     * @author Root
     */publicclass SomeServiceImpl implements ISomeService {
        privateint a;
        public SomeServiceImpl() {
            System.out.println("执行无参构造器，创建SomeServiceImpl对象");
        }
        public SomeServiceImpl(int a) {
            this.a = a;
        }
        @Override
        publicvoid doSomeThing() {
            System.out.println("执行doSomeThing()方法...");
        }
    }

此时，再次运行测试用例，会发现运行成功。

结论：Spring容器实际上是使用了类的反射机制，会首先调用Bean类的无参构造器创建实例对象。

## 二、动态工厂Bean

 创建SomeServiceImpl类：

    package com.ietree.spring.basic.ioc;
    /**
     * 实现类
     * 
     * @author Root
     */publicclass SomeServiceImpl implements ISomeService {
        public SomeServiceImpl() {
            System.out.println("执行无参构造器，创建SomeServiceImpl对象");
        }
        @Override
        publicvoid doSomeThing() {
            System.out.println("执行doSomeThing()方法...");
        }
    }

创建工厂类ServiceFactory：

    package com.ietree.spring.basic.ioc;
    /**
     * 工厂类
     * 
     * @author Root
     */publicclass ServiceFactory {
        public ISomeService getSomeService() {
            returnnew SomeServiceImpl();
        }
    }

使用动态工厂方式获取Bean对象，配置如下：

    <?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="
            http://www.springframework.org/schema/beans 
            http://www.springframework.org/schema/beans/spring-beans.xsd"><!-- 注册动态工厂 --><bean id="factory" class="com.ietree.spring.basic.ioc.ServiceFactory"/><!-- 注册Service：动态工厂Bean --><bean id="myService" factory-bean="factory" factory-method="getSomeService"/></beans>

在这里并没有注册SomeServiceImpl类，而是通过ServiceFactory工厂的getSomeService方法获取的。

测试：

    @Test
    publicvoid testFactory1() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ISomeService service = (ISomeService) ac.getBean("myService");
        service.doSomeThing();
    }

运行成功。

## 三、静态工厂Bean

 静态工厂和动态工厂不同的是，静态工厂中使用的是静态方法创建对象，如：

    package com.ietree.spring.basic.ioc;
    /**
     * 工厂类
     * 
     * @author Root
     */publicclass ServiceFactory {
        // 使用静态方法创建对象publicstatic ISomeService getSomeService() {
            returnnew SomeServiceImpl();
        }
    }

对应的配置文件修改如下：

    <?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="
            http://www.springframework.org/schema/beans 
            http://www.springframework.org/schema/beans/spring-beans.xsd"><!-- 注册Service：静态工厂Bean --><bean id="myService" class="com.ietree.spring.basic.ioc.ServiceFactory" factory-method="getSomeService"/></beans>

测试：

    @Test
    publicvoid testFactory1() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ISomeService service = (ISomeService) ac.getBean("myService");
        service.doSomeThing();
    }

成功创建SomeServiceImpl对象。

## 四、容器中的Bean的作用域

 Bean的作用域（scope）分为四种，分别是singleton、prototype、request、session。

scope： 　　singleton（默认）：单例模式，其对象的创建时机是在Spring容器初始化时创建，是默认值 　　prototype：原型模式，其对象的创建时机不是在Spring容器初始化时创建，而是在代码中真正访问时才创建，每次使用getBean方法获取的同一个<bean/>的实例都是一个新的实例 　　request：对于每次HTTP请求，都将会产生一个不同的Bean实例 　　session：对于每个不同的HTTP session，都将会产生一个不同的Bean实例

验证：

首先配置作用域为singleton：

    <bean id="myService" class="com.ietree.spring.basic.ioc.SomeServiceImpl" scope="singleton"/>

测试：

    @Test
    publicvoid test05() {
        ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext.xml");
        ISomeService service1 = (ISomeService) ac.getBean("myService");
        ISomeService service2 = (ISomeService) ac.getBean("myService");
        System.out.println("service1 = service2吗？" + (service1 == service2));
    }

程序输出：

    调用无参构造器
    service1 = service2吗？true

结论：当作用域为singleton单例模式时，只会创建一个对象实例，并且对象是在Spring容器初始化时创建。

同样，当配置为prototype原型模式时：

    <bean id="myService" class="com.ietree.spring.basic.ioc.SomeServiceImpl" scope="prototype"/>

程序输出：

    调用无参构造器
    调用无参构造器
    service1 = service2吗？false

结论：构造器被调用了两次，说明创建的service1和service2不是同一个对象，并且对象是在被使用到时才创建的。

## 五、Bean后处理器

## 六、定制Bean的生命周期

## 七、<bean/>标签的id属性与name属性
{% endraw %}
