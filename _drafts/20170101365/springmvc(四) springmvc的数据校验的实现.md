---
layout: post
title:  "springmvc(四) springmvc的数据校验的实现"
title2:  "springmvc(四) springmvc的数据校验的实现"
date:   2017-01-01 23:57:45  +0800
source:  "http://www.jfox.info/springmvc%e5%9b%9bspringmvc%e7%9a%84%e6%95%b0%e6%8d%ae%e6%a0%a1%e9%aa%8c%e7%9a%84%e5%ae%9e%e7%8e%b0.html"
fileName:  "20170101365"
lang:  "zh_CN"
published: true
permalink: "springmvc%e5%9b%9bspringmvc%e7%9a%84%e6%95%b0%e6%8d%ae%e6%a0%a1%e9%aa%8c%e7%9a%84%e5%ae%9e%e7%8e%b0.html"
---
{% raw %}
so easy~

　　　　　　　　　　　　　　–WH

一、什么是数据校验？

　　　　　　这个比较好理解，就是用来验证客户输入的数据是否合法，比如客户登录时，用户名不能为空，或者不能超出指定长度等要求，这就叫做数据校验。

　　　　　　数据校验分为客户端校验和服务端校验

　　　　　　　　客户端校验：js校验

　　　　　　　　服务端校验：springmvc使用validation校验，struts2使用validation校验。都有自己的一套校验规则。

二、springmvc的validation校验

　　　　　　Springmvc本身没有校验功能，它使用hibernate的校验框架，hibernate的校验框架和orm没有关系

2.1、添加jar包

![](/wp-content/uploads/2017/07/1500289947.png)

2.2、在springmvc.xml中配置validator校验器，基本上直接复制拿过去用即可。

　　　　　　　　　　配置以下这些，相当于有人帮我们写好了校验代码，我们拿过来直接用就行了，所以需要进行配置。

![](/wp-content/uploads/2017/07/1500289948.png)

　　　　　　　　　　将validator注册到适配器中

　　　　　　　　　　方式一(推荐)

![](/wp-content/uploads/2017/07/15002899481.png)

　　　　　　　　　　方式二：如果配置文件中使用的是非注解方式编写的适配器，则这样配置

![](/wp-content/uploads/2017/07/15002899482.png)
![](/wp-content/uploads/2017/07/1500289949.gif)![](/wp-content/uploads/2017/07/15002899491.gif)
        <!-- 校验器，配置validator -->
        <bean id="validator" class="org.springframework.validation.beanvalidation.LocalValidatorFactoryBean">
            <property name="providerClass" value="org.hibernate.validator.HibernateValidator"></property>
            <property name="validationMessageSource" ref="validationMessageSource"></property>
        </bean>
        
        <!-- 配置validationMessageSource -->
        <bean id="validationMessageSource" class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
            <!-- 指定校验信息的资源文件的基本文件名称，不包括后缀，后缀默认是properties -->
            <property name="basenames">
                <list>
                    <value>classpath:validationMessageSource</value>
                </list>
            </property>
            <!-- 指定文件的编码 -->
            <property name="fileEncodings" value="utf8"></property>
            <!-- 对资源文件内容缓存的时间，单位秒 -->
            <property name="cacheSeconds" value="120"></property>
        </bean>

springmvc.xml配置校验器
2.3、validationMessageSource.properties

　　　　　　　　该配置文件的作用就是存储校验失败时的提示文字信息的，也就是相当于将其提取出来放到配置文件中，

![](/wp-content/uploads/2017/07/1500289949.png)

2.4、在pojo中指定校验规则

　　　　　　　　列举两个校验规则(使用的是注解校验)，notnull和size

![](/wp-content/uploads/2017/07/15002899491.png)

　　　　　　　　1、items.name.size和items.createtime.notnull:就是读取validationMessageSource.properties中的配置信息。从这里就可以理解该配置文件的意义，防止硬编码。

　　　　　　　　2、使用注解对需要进行校验的属性进行绑定，而能够使这些注解生效的前提就是配置此前的几个步骤，2.1、2.2、2.3都必不可少

　　　　　　　　　　其他校验规则摘抄自网上

![](/wp-content/uploads/2017/07/1500289950.png)

![](/wp-content/uploads/2017/07/1500289951.png)

2.5、controller中对其校验绑定进行使用

![](/wp-content/uploads/2017/07/15002899511.png)

　　　　　　　　1、@Validated作用就是将pojo内的注解数据校验规则(@NotNull等)生效，如果没有该注解的声明，pojo内有注解数据校验规则也不会生效

　　　　　　　　2、BindingResult对象用来获取校验失败的信息(@NotNull中的message)，与@Validated注解必须配对使用，一前一后

　　　　　　　　3、代码中的逻辑应该很容易看懂，就是将result中所有的错误信息取出来，然后到原先的页面将错误信息进行显示，注意，要使用model对象，则需要在形参中声明Model model，然后菜能使用

2.6、jsp页面

![](/wp-content/uploads/2017/07/15002899512.png)

2.7、总结

　　　　　　　　其实非常简单，直接使用注解对其进行校验就完事了，校验代码都替我们写好了，只需要配置一下即可。傻瓜式操作。不会的看上面步骤，一步步来。

三、分组校验

3.1、什么是分组校验？

　　　　　　　　校验规则是在pojo 制定的，而同一个pojo可以被多个Controller使用，此时会有问题，即：不同的Controller方法对同一个pojo进行校验，此时这些校验信息是共享在这不同的Controller方法　　　　　　　　　　　中，但是实际上每个Controller方法可能需要不同的校验，在这种情况下，就需要使用分组校验来解决这种问题，

　　　　　　　　通俗的讲，一个pojo中有很多属性，controller中的方法1可能只需要校验pojo中的属性1，controller中的方法2只需要校验pojo中的属性2，但是pojo中的校验注解有很多，怎样才能使方法1只校　　　　　　　　　　验属性1，方法二只校验属性2呢？就需要用分组校验来解决了。

3.2、定义分组

![](/wp-content/uploads/2017/07/1500289952.png)![](/wp-content/uploads/2017/07/15002899521.png)

　　　　　　　　就是定义空的接口，接口类只作为这个分组标识来使用，看下面的用法，就知道其意义何在了

3.3、使用分组

![](/wp-content/uploads/2017/07/15002899522.png)

3.4、controller方法

　　　　　　　　　在这个方法中，那么就只会校验items这个pojo中有ValidationGroup1这个分组的校验注解，而不会在校验其他的

![](/wp-content/uploads/2017/07/1500289953.png)

四、总结

　　　　　　数据校验就这样讲完了，非常简单吧，拿过来就是一顿用即可。
{% endraw %}
