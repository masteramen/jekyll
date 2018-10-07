---
layout: post
title:  "基于Spring的最简单的定时任务实现与配置（一）"
title2:  "基于Spring的最简单的定时任务实现与配置（一）"
date:   2017-01-01 23:49:45  +0800
source:  "http://www.jfox.info/%e5%9f%ba%e4%ba%8espring%e7%9a%84%e6%9c%80%e7%ae%80%e5%8d%95%e7%9a%84%e5%ae%9a%e6%97%b6%e4%bb%bb%e5%8a%a1%e5%ae%9e%e7%8e%b0%e4%b8%8e%e9%85%8d%e7%bd%ae-%e4%b8%80.html"
fileName:  "20170100885"
lang:  "zh_CN"
published: true
permalink: "%e5%9f%ba%e4%ba%8espring%e7%9a%84%e6%9c%80%e7%ae%80%e5%8d%95%e7%9a%84%e5%ae%9a%e6%97%b6%e4%bb%bb%e5%8a%a1%e5%ae%9e%e7%8e%b0%e4%b8%8e%e9%85%8d%e7%bd%ae-%e4%b8%80.html"
---
{% raw %}
朋友的项目中有点问题。他那边是Spring架构的，有一个比较简单的需要定时的任务执行。在了解了他的需求之后，于是提出了比较简单的Spring+quartz的实现方式。

 注意本文只是讨论，在已搭建完毕的Spring工程下，完成最简单的定时任务。

 第一步，要知道Spring这个架构，很有趣很有意思。可以做到自由插拔功能模块的效果。工程项目是基于MAVEN包依赖管理的，所以把这次需要的依赖包引用列出来：

     1<!-- 定时器依赖 开始 --> 2<dependency> 3<groupId>org.springframework</groupId> 4<artifactId>spring-context-support</artifactId> 5<version>4.0.2.RELEASE</version> 6</dependency> 7 8 910<dependency>11<groupId>org.quartz-scheduler</groupId>12<artifactId>quartz</artifactId>13<version>2.2.1</version>14</dependency>15<!-- 定时器依赖 结束 -->

当然，这是要跟对应的Spring的版本是要匹配的。我们这里的工程是4.0.2。前一个包spring-context-support，主要的作用是作为Spring与quartz的沟通管理的部件，如果注释掉就会报这样的错误

 在MAVEN配置完所需要添加的包之后（其他的包，这里暂时不扩展开说了，本文只讨论在完整Spring工程项目下的配置），我们就可以开始动手给这个项目添加，定时任务的功能模块了。

第二步，从web的项目的起源，web.xml 中改动做起。由于原本的项目Spring的配置文件是Spring-mvc.xml,我这里就把定时任务的配置文件改成了spring-time.xml。这样就可以通过同一个扫描的配置在启动的时候去读取了。具体的代码如下：

    1<context-param>2<param-name>contextConfigLocation</param-name>3<param-value>classpath:spring-*.xml</param-value>4</context-param>

然后给大家看一下我的工程结构：

 通过这样的配置，项目就会知道怎么去调用了。实现了这一步接下来我们就可以继续往下走了；

 第三步，就是要完成spring-timer.xml这个定时任务的核心配置了。在这个文件配置中，我们主要是完成三件事情：

 1.配置启动的设置，关于懒加载（简单说一下，比如把某个变量初始化为null，也是一种懒加载，即在服务启动之后，只有在实际被调用的时候才会实例化，否则是不会在内存中存在的，只是逻辑上的。可以省空间，但是也可能会导致，问题延迟很久才会被发现，此处不再详细解说），以及触发器的配置；

 2.quartz-2.x的配置，包含定时任务触发之后要调用的job的名字，以及corn表达式（即定时表达式，控制程序在何时重复执行的原因，本次在会在后续补充关于cron表达式的内容）；

 3.配置job的内容和job对应的具体的类。

好了逻辑流程解说完毕，上代码：

     1<?xml version="1.0" encoding="UTF-8"?> 2<beans xmlns="http://www.springframework.org/schema/beans" 3    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 4    xmlns:p="http://www.springframework.org/schema/p" 5    xsi:schemaLocation="http://www.springframework.org/schema/beans  
     6     http://www.springframework.org/schema/beans/spring-beans-3.0.xsd"> 7 8<!-- 启动触发器的配置开始 --> 9<bean name="startQuertz" lazy-init="false" autowire="no"10        class="org.springframework.scheduling.quartz.SchedulerFactoryBean">11<property name="triggers">12<list>13<ref bean="myJobTrigger"/>14</list>15</property>16</bean>17<!-- 启动触发器的配置结束 -->1819<!-- 调度的配置开始 -->20<!--21        quartz-1.8以前的配置   
    22    <bean id="myJobTrigger"  
    23        class="org.springframework.scheduling.quartz.CronTriggerBean">  
    24        <property name="jobDetail">  
    25            <ref bean="myJobDetail" />  
    26        </property>  
    27        <property name="cronExpression">  
    28            <value>0/1 * * * * ?</value>  
    29        </property>  
    30    </bean>  
    31-->32<!-- quartz-2.x的配置 -->33<bean id="myJobTrigger"34        class="org.springframework.scheduling.quartz.CronTriggerFactoryBean">35<property name="jobDetail">36<ref bean="myJobDetail"/>37</property>38<property name="cronExpression">3940<value>0/10 * *  * * ?</value>41<!--   <value>1 52 * * * ?</value>  -->42</property>43</bean>44<!-- 调度的配置结束 -->4546<!-- job的配置开始 -->47<bean id="myJobDetail"48        class="org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean">49<property name="targetObject">50<ref bean="myJob"/>51</property>52<property name="targetMethod">53<value>work</value>54</property>55</bean>56<!-- job的配置结束 -->5758<!-- 工作的bean -->59<bean id="myJob" class="com.tec.kevin.quartz.jobTest"/>6061</beans>

完成这里的配置文件配置之后，就可以开始下一步，具体的业务逻辑实现了；

第四步 具体业务逻辑实现。

这里要注意的是下图中的两个点

上图是具体的业务实现的类，里面的名字和下图定时任务配置的要相同。

完成上述之后，我们可以启动项目看看实际效果了。

这里可以看到，定时任务按照我们之前在配置中的 <value>0/10 * * * * ?</value> 每10秒执行一次 来运行了。

 要注意的是，在实现这个方法的过程中，我遇到了重复执行的情况。就是同一个时间，执行了两次。后来找到的原因是在配置web.xml的时候，重复配置了定时任务，这样导致执行了多次。要是有遇到这个情况的，可以参考我的解决方法。

 接来下会有两篇文章，一篇是写定时任务的更简单的实现方法，另外一篇讲解cron 表达式。
{% endraw %}
