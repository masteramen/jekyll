---
layout: post
title:  "springmvc(三) 参数绑定、"
title2:  "springmvc(三) 参数绑定、"
date:   2017-01-01 23:57:12  +0800
source:  "http://www.jfox.info/springmvc%e4%b8%89%e5%8f%82%e6%95%b0%e7%bb%91%e5%ae%9a.html"
fileName:  "20170101332"
lang:  "zh_CN"
published: true
permalink: "springmvc%e4%b8%89%e5%8f%82%e6%95%b0%e7%bb%91%e5%ae%9a.html"
---
{% raw %}
前面两章就介绍了什么是springmvc，springmvc的框架原理，并且会简单的使用springmvc以及ssm的集成，从这一章节来看，就开始讲解springmvc的各种功能实现，慢慢消化

　　　　　　　　　　　　　　　　　　　　　　　　　　–WH

一、参数绑定

1.1、什么是参数绑定？

　　　　　　　　客户在浏览器端会提交一些参数到服务器端，比如用户的登录等，就会传username 和 password过来，springmvc则通过参数绑定组件将请求参数的内容进行数据转换，然后将转换后的值覆给controller方法的形参，这就是参数绑定的过程，其实，springmvc就是使用controller方法形参来接收请求的参数

1.2、springmvc默认支持的参数类型

　　　　　　　　可以在Controller方法的形参中直接使用以下类型

**HttpServletRequest、HttpServletResponse、HttpSession:**这三个很熟悉，不做解释

**　　　　　　　　　　Model/ModelMap：**将model数据填充到request域，比如之前的ModelAndView对象添加list，其实就是将list添加到request作用域，只是ModelAndView对象不仅能够添加model数据，还能够添加视图。而Model对象的功能就只有将model数据填充到request作用域

![](/wp-content/uploads/2017/07/1500039978.png)

　　　　　　　　如图所示，就是这样，在形参中使用这几个对象，那么在方法中就能直接用这几个对象了。有了request对象，就能够使用我们以前学过的老方法获取请求参数等一些信息了。

1.3、绑定简单类型的参数

　　　　　　　　上面讲解的只是默认支持的参数类型，有request等一些对象，必然是很好很方便的一件事，比如获取请求参数就可以得到解决了，但是springmvc提供更强大一些的功能。

绑定简单类型的参数规则：

1.3.1、如果请求参数的key和Controller类中方法的形参名称一致，那么就直接绑定；

　　　　　　　　　　　　请求url：http://localhost:8080/ssm_test/editItems.do?id=2   模拟客户端发送了一个id=2的请求参数过来，这里使用的是get方式，如果post方式也是一样的道理

　　　　　　　　　　　　Controller方法：

![](/wp-content/uploads/2017/07/15000399781.png)

　　　　　　　　　　　　分析：形参中的名称与请求参数的名称相同，固可以直接绑定。

1.3.2、如果请求参数的key和Controller类中方法的形参名称不一致，那么就需要使用@RequestParam注解来进行参数绑定

　　　　　　　　　　　　请求url：http://localhost:8080/ssm_test/editItems.do?itemsId=2   模拟客户端发送了一个id=2的请求参数过来

　　　　　　　　　　　　Controller方法：

![](/wp-content/uploads/2017/07/1500039979.png)

　　　　　　　　　　　　分析：使用@RequestParam(“itemsId”)注解将名为itemsId的请求参数的值赋值给形参中名为id的参数。注意，在对应的形参前面加该注解。

1.4、绑定pojo

　　　　　　　　使用springmvc绑定pojo的参数时，要求jsp中input框的name值要和Controller方法形参的pojo对象中的属性名称一致，如下图

　　　　　　　　　　jsp页面

![](/wp-content/uploads/2017/07/15000399791.png)

　　　　　　　　　　controller方法

![](/wp-content/uploads/2017/07/15000399792.png)

　　　　　　　　　　Items类

![](/wp-content/uploads/2017/07/1500039980.png)

1.5、参数绑定时日期类型转换问题

　　　　　　　　在我们从jsp页面传过来的参数的类型都是object的，而我们自己编写的是有具体类型的，比如id是需要int型，name是需要string型，而springmvc就会帮我们将这些简单的类型自动进行类型转换，但是当遇到Date类型的时候，就转换不了，需要我们自己写一个类型转换器，然后给适配器配上，从而jsp传过来的参数能够转换成我们需要的日期类型，如果不自定义类型转换器的话，会报错　　　　　　　　　　　　　即把请求中的日期字符串转成java的日期类型，该日期类型与pojo中日期属性的类型保持一致　

　　　　　　　　1.5.1、自定义Converter

![](/wp-content/uploads/2017/07/15000399801.png)
![](/wp-content/uploads/2017/07/1500039981.gif)![](/wp-content/uploads/2017/07/15000399811.gif)
    package com.wuhao.ssm.util;
    
    import java.text.SimpleDateFormat;
    import java.util.Date;
    
    import org.springframework.core.convert.converter.Converter;
    
    
    publicclass DateConverter implements Converter<String,Date> {
    
        @Override
        public Date convert(String source) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
                return sdf.parse(source);
            } catch (Exception e) {
                e.printStackTrace();
            }
            returnnull;
        }
    
    
    }

DateConverter.java
　　　　　　　　1.5.2、在springmvc.xml中配置该转换器

　　　　　　　　　　第一种方式(推荐)：两步搞定

　　　　　　　　　　　　修改mvc:annotation-driven的配置

　　　　　　　　　　　　配置自定义转换器绑定

![](/wp-content/uploads/2017/07/1500039981.png)
![](/wp-content/uploads/2017/07/1500039981.gif)![](/wp-content/uploads/2017/07/15000399811.gif)
        <!-- 配置处理器映射器和处理器适配器 -->
    <mvc:annotation-driven conversion-service="conversionService" />
    
    <!-- 自定义参数绑定 -->
    <bean id="conversionService"
        class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
            <property name="converters">
                <list>
                    <!-- 日期类型转换器 -->
                    <bean class="com.wuhao.ssm.util.DateConverter" />
                </list>
            </property>
        </bean>

springmvc.xml中配置日期转换器
　　　　　　　　　　第二种方式：

![](/wp-content/uploads/2017/07/1500039982.png)
![](/wp-content/uploads/2017/07/1500039981.gif)![](/wp-content/uploads/2017/07/15000399811.gif)
        <!--注解适配器,也就是不使用spring标签对注解进行管理 -->
    <bean
        class="org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter">
        <property name="webBindingInitializer" ref="customBinder" />
    </bean>
    
    <!-- 自定义webBinder -->
    <bean id="customBinder"
        class="org.springframework.web.bind.support.ConfigurableWebBindingInitializer">
        <property name="conversionService" ref="conversionService" />
    </bean>
    <!-- conversionService -->
    <bean id="conversionService"
        class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
        <!-- 转换器 -->
        <property name="converters">
            <list>
                <bean class="com.wuhao.ssm.util.DateConverter" />
            </list>
        </property>
    </bean>

View Code
1.6、包装pojo参数绑定

　　　　　　　　与1.4的pojo参数绑定的区别在于，这里将pojo放入一个包装类中，如下图，将Items类放入了ItemsQueryVO类中，ItemsQueryVO就是一个包装pojo

　　　　　　　　　　ItemsQueryVO

![](/wp-content/uploads/2017/07/1500039983.png)

　　　　　　　　　　jsp

![](/wp-content/uploads/2017/07/15000399831.png)

　　　　　　　　　　controller：直接使用包装pojo接收

![](/wp-content/uploads/2017/07/1500039984.png)

1.7、集合参数的绑定

1.7.1、简单类型的集合参数绑定，可以使用数组或者List来接收

　　　　　　　　比如jsp页面有一些多选框，复选框，这样提交过来，就需要使用集合参数的绑定了。

　　　　　　　　jsp

![](/wp-content/uploads/2017/07/15000399841.png)

　　　　　　　　controller

　　　　　　　　　　使用数组来接收

　　　　　　　　　　　　形参中的数组类型要和jsp中值的类型一致，形参中的参数名称要和jsp中name一致。也就是itemsid 

![](/wp-content/uploads/2017/07/1500039985.png)

　　　　　　　　　　使用list来接收

　　　　　　　　　　　　形参中list的泛型跟jsp中的值的类型一致，形参中参数名称要和jsp中name一致。(我们想象中是这样)

![](/wp-content/uploads/2017/07/15000399851.png)

　　　　　　　　　　　　结果，会报错，嘿嘿，因为不能在形参中直接定义List类型的参数，如果想要使用list来接收，需要把List类型的参数定义在包装POJO中，Controller的方法形参使用该包装POJO，下面讲解。所以如果使用接收简单类型的集合参数，使用数组最为方便。

1.7.2、pojo类型的集合参数绑定，可以使用数组或者list来接收

　　　　　　　　　　注意：pojo类型的集合参数绑定时，接收它的数组或者List，都不能直接定义在Controller方法形参上，需要把它定义到一个包装pojo中，如何把这个包装pojo放到形参

　　　　　　　　　　使用list。

　　　　　　　　　　包装pojo类 ItemsQueryVo， 将需要装items集合的对象放入包装类中。

![](/wp-content/uploads/2017/07/1500039986.png)

　　　　　　　　　　jsp

![](/wp-content/uploads/2017/07/15000399861.png)

　　　　　　　　　　这里注意：标记的是name属性，不要与value属性搞混淆了，在ItemsQueryVo中有名为itemsList的list，所以在jsp中的name就需要一层层匹配下去才能正确将其属性值装载到正确的位置，list的格式为：itemsList[下标].name。 就拿这个分析，itemsList就可以找打ItemsQueryVo中的itemsList， itemsList[1]，就可以定位到itemsList中的第一个items，itemsList[1].name就可以定位到itemsList中的第一个items的name属性，这样一来就看得懂了。

　　　　　　　　　　controller

![](/wp-content/uploads/2017/07/15000399862.png)

1.7.3、总结上面两种

　　　　　　　　　　总结一下集合参数的绑定

　　　　　　　　　　　　对于简单类型的集合参数绑定，则使用数组作为形参来接收请求的集合参数

　　　　　　　　　　　　对于pojo类型的集合参数绑定，则使用数组或者list两者都可以，一般常用list。

　　　　　　　　　　　　　　注意：这种pojo类型的集合参数绑定，必须将list或者数组作为一个包装类中的属性，然后使用该包装类对象作为形参来接收请求参数。　　　　　　　

　　　　　　　　1.7.4、map集合类型绑定

　　　　　　　　　　这个用的不多，一般只是用list，这个也稍微了解一下，等需要的时候会用即可，贴出关键代码就行

　　　　　　　　　　同样，需要使用包装pojo类。

　　　　　　　　　　ItemsQueryVo

![](/wp-content/uploads/2017/07/1500039987.png)

　　　　　　　　　　jsp：格式为下面这样。就能够匹配到

![](/wp-content/uploads/2017/07/15000399871.png)

　　　　　　　　　　controller

![](/wp-content/uploads/2017/07/1500039988.png)

二、总结

　　　　　　看了这么多中参数绑定的例子，我觉得用一句话来概括最为准确，万变不离其宗。有耐心看一下就自然就会用了，真的很简单。只是知识比较多比较细，需要理解的也不多。
{% endraw %}
