---
layout: post
title:  "Spring学习之Bean的装配"
title2:  "Spring学习之Bean的装配"
date:   2017-01-01 23:54:46  +0800
source:  "http://www.jfox.info/spring%e5%ad%a6%e4%b9%a0%e4%b9%8bbean%e7%9a%84%e8%a3%85%e9%85%8d.html"
fileName:  "20170101186"
lang:  "zh_CN"
published: true
permalink: "spring%e5%ad%a6%e4%b9%a0%e4%b9%8bbean%e7%9a%84%e8%a3%85%e9%85%8d.html"
---
{% raw %}
Java开发者一般会听过JavaBean这个概念，所谓的JavaBean，其实就是符合sun规范的一种普通的Java对象，这种对象需要有一个空构造器，为属性添加set/get方法等，之所以这么设计，是为了方便使用反射技术对其进行操作，而在Spring中的Bean的概念则相对比较广泛一些，Spring中的Bean基本上可以包括所有需要使用到的对象，也就是说，基本上在Spring中的对象，都可以称之为Bean。

## Bean的装配

在学习依赖注入的时候，提到一个概念，就是把对象的创建交给第三方，并且由第三方进行注入，Spring中的Ioc容器就扮演者这样的一个角色，也就是说，通过Spring的Ioc容器，就可以实现控制的反转，将对象的创建等交给Spring，而服务对象只管使用即可。配置Bean的过程其实也就是告诉Spring我们所要创建的对象以及他们之间的依赖关系，然后Spring的Ioc容器会在启动之后，根据配置信息，将Bean进行创建以及注入到对应的服务中。

## Bean的配置方式

Spring为开发者提供了多种配置Bean的方式，包括了XML配置，注解配置，Java代码配置，以及Groovy配置等，虽然配置方式有多样，但是这多种方式的目的都是一致的，那就是告诉Spring创建什么对象以及它们之间的依赖关系。接下来，我们主要来看下基于XML的配置以及基于注解的配置，这两种配置方式目前来说还是使用得比较广泛的。

### 基于XML的配置

在前面Spring开发环境搭配中，我们使用的装配Bean的方式就是基于XML的配置方式，这种配置方式是使用Spring最原始的装配方式，主要是用过XML来描述对象以及对象之间的依赖关系，接下来通过一个小案例来具体看下在Spring中如何使用XML配置Bean

    /**
     * 位置类，用于描述学校的位置信息
     */
    class Location{
        private String country;
        private String city;
    
        // 省略set/get方法
    
        // 省略toString方法
    }
    
    /**
     * 学校信息
     */
    public class School {
    
        // 用于演示基本数据类型的注入
        private String name;
        // 学校位置，依赖于Location对象
        private Location location;
        // 用于演示集合类的注入
        private List<String> teachers;
        private Set<String> buildings;
        private Map<String, String> departments;
    
    
        public School() {
            teachers = new ArrayList<>();
            buildings = new HashSet<>();
            departments = new HashMap<>();
        }
        // 用于演示构造器注入
        public School(String name) {
            this();
            this.name = name;
        }
    
        // 省略set/get方法
    
        // 省略toString方法
    
    }

编写对应的配置文件，`beanConfig.xml` 如下所示

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
    
        <!--声明Location bean，并且为其两个属性注入对应的字面值-->
        <bean id="location" class="cn.xuhuanfeng.domain.Location">
            <property name="city" value="china"/>
            <property name="country" value="ShenZhen"/>
        </bean>
    
        <!--配置School bean，并为其注入对象的属性-->
        <bean id="school" class="cn.xuhuanfeng.domain.School">
    
            <!--构造器注入 index用于指定所要注入的参数的位置，type用于指定注入的参数的类型-->
            <constructor-arg index="0" type="java.lang.String" value="SZU"/>
    
            <!--由于location依赖于Location对象，所以这里使用的是ref，用于表示引用另一个bean-->
            <property name="location" ref="location"/>
    
            <!--注入set内容-->
            <property name="buildings">
                <set>
                    <value>Domain A</value>
                    <value>Domain B</value>
                    <value>Domain C</value>
                </set>
            </property>
    
            <!--注入list内容-->
            <property name="teachers">
                <list>
                    <value>Dr.Wang</value>
                    <value>Pro.Chen</value>
                    <value>Miss.Wu</value>
                </list>
            </property>
    
            <!--注入map内容-->
            <property name="departments">
                <map>
                    <entry key="cs" value="Dr.ming"/>
                    <entry key="se" value="Dr.liu"/>
                </map>
            </property>
        </bean>
    
    </beans>

可以看到，Spring为我们提供了非常方便的Bean的配置方式以及对应的注入方式

### 基于注解的配置

通过注解方式的配置Bean信息以及Bean之间的依赖关系，是Spring2.5以后引入的新功能，主要的原因在于XML的配置过程比较麻烦，配置少量的信息却需要编写大量的代码。当然其好处就是能够描述完整的配置信息，这是其他配置方式所缺乏的

在Spring中，提供了多种配置Bean的注解,`@Component` 是最基础的声明方式，Spring会将声明为Component的对象初始化并且将其进行装配，同时，为了更好地进行分层管理，Spring还提供了`@Controller`,`@Service`,`@Repository`，这三者的本质还是@Component，只不过为了更好地进行管理而进行的额外的声明。

    @Component
    public class Location{
        private String country;
        private String city;
    }
    
    @Component
    public class School {
    
        @Value("SZU")
        private String name;
    
        @Autowired // 自动注入
        private Location location;
    
        // ....
    }

可以看到通过注解进行声明是非常方便的，只需要在对应的Bean上加上`@Component`即可，在需要注入的地方加上`Autowired`即可

不过，声明完注解之后，Ioc容器是无法感知到Bean的存在的，所以还需要在配置文件中加上开启IoC容器进行自动扫描的代码，如下所示

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
           xmlns:context="http://www.springframework.org/schema/context"
           xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">
    
        <!--开启自动扫描， base-package指定所要扫描的包 -->  
        <context:component-scan base-package="cn.xuhuanfeng.domain" />
    
    </beans>

通过注解的方式进行装配的好处是比较方便，但同时由于注解本身用于描述复杂一点的配置信息还是不太方便，所以一般来说，会配合XML进行配置，一些简单的配置则使用注解，而比较复杂的配置则使用XML进行配置。
{% endraw %}
