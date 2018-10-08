---
layout: post
title:  "深入 JVM 分析 spring-boot 应用 hibernate-validator NoClassDefFoundError"
title2:  "深入 JVM 分析 spring-boot 应用 hibernate-validator NoClassDefFoundError"
date:   2017-01-01 23:49:42  +0800
source:  "http://www.jfox.info/%e6%b7%b1%e5%85%a5-jvm-%e5%88%86%e6%9e%90-spring-boot-%e5%ba%94%e7%94%a8-hibernate-validator-noclassdeffounderror.html"
fileName:  "20170100882"
lang:  "zh_CN"
published: true
permalink: "%e6%b7%b1%e5%85%a5-jvm-%e5%88%86%e6%9e%90-spring-boot-%e5%ba%94%e7%94%a8-hibernate-validator-noclassdeffounderror.html"
---
{% raw %}
Caused by: java.lang.NoClassDefFoundError: Could not initialize class org.hibernate.validator.internal.engine.ConfigurationImpl
    at org.hibernate.validator.HibernateValidator.createGenericConfiguration(HibernateValidator.java:33) ~[hibernate-validator-5.3.5.Final.jar:5.3.5.Final]
    at javax.validation.Validation$GenericBootstrapImpl.configure(Validation.java:276) ~[validation-api-1.1.0.Final.jar:na]
    at org.springframework.boot.validation.MessageInterpolatorFactory.getObject(MessageInterpolatorFactory.java:53) ~[spring-boot-1.5.3.RELEASE.jar:1.5.3.RELEASE]
    at org.springframework.boot.autoconfigure.validation.DefaultValidatorConfiguration.defaultValidator(DefaultValidatorConfiguration.java:43) ~[spring-boot-autoconfigure-1.5.3.RELEASE.jar:1.5.3.RELEASE]
    at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_112]
    at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_112]
    at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_112]
    at java.lang.reflect.Method.invoke(Method.java:498) ~[na:1.8.0_112]
    at org.springframework.beans.factory.support.SimpleInstantiationStrategy.instantiate(SimpleInstantiationStrategy.java:162) ~[spring-beans-4.3.8.RELEASE.jar:4.3.8.RELEASE]
    ... 32 common frames omitted

这个错误信息表面上是NoClassDefFoundError，但是实际上ConfigurationImpl这个类是在hibernate-validator-5.3.5.Final.jar里的，不应该出现找不到类的情况。

那为什么应用里抛出这个NoClassDefFoundError ？

有经验的开发人员从Could not initialize class 这个信息就可以知道，实际上是一个类在初始化时抛出的异常，比如static的静态代码块，或者static字段初始化的异常。

但是当我们在HibernateValidator 这个类，创建ConfigurationImpl的代码块里打断点时，发现有两个线程触发了断点：

    public class HibernateValidator implements ValidationProvider<HibernateValidatorConfiguration> {
    	@Override
    	public Configuration<?> createGenericConfiguration(BootstrapState state) {
    		return new ConfigurationImpl( state );
    	}

其中一个线程的调用栈是：

    Thread [background-preinit] (Class load: ConfigurationImpl)
    	HibernateValidator.createGenericConfiguration(BootstrapState) line: 33
    	Validation$GenericBootstrapImpl.configure(
{% endraw %}
