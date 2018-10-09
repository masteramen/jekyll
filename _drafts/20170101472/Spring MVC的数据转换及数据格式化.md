---
layout: post
title:  "Spring MVC的数据转换及数据格式化"
title2:  "Spring MVC的数据转换及数据格式化"
date:   2017-01-01 23:59:32  +0800
source:  "https://www.jfox.info/springmvc%e7%9a%84%e6%95%b0%e6%8d%ae%e8%bd%ac%e6%8d%a2%e5%8f%8a%e6%95%b0%e6%8d%ae%e6%a0%bc%e5%bc%8f%e5%8c%96.html"
fileName:  "20170101472"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springmvc%e7%9a%84%e6%95%b0%e6%8d%ae%e8%bd%ac%e6%8d%a2%e5%8f%8a%e6%95%b0%e6%8d%ae%e6%a0%bc%e5%bc%8f%e5%8c%96.html"
---
{% raw %}
作者[落叶飞逝的恋](/u/24fffffbd71a)2017.08.03 23:01字数 1946
Spring MVC会根据请求方法签名不同，将请求消息中信息以一定方式转换并绑定到请求方法的参数中。

### 1.数据绑定流程

Spring MVC通过反射机制对目标处理方法的签名进行分析，并将请求消息绑定到处理方法的参数上。数据绑定的核心部件是**Databinder**
![](/wp-content/uploads/2017/08/1501895152.png) 
  
    Spring MVC数据绑定机制 
   
  
 
- 
1.Spring MVC框架将ServletRequest对象及处理方法的参数实例传递给DataBinder。

- 
2.DataBinder调用装配在Spring Web上下文中的ConversionService组件进行数据类型转换、
数据格式化工作，并将ServletRequest中的消息填充到参数对象中。

- 
3.然后再调用Validator组件对已经绑定的请求消息数据的参数对象进行数据合法性校验。

- 
4.最终生成数据绑定结果BindingResult对象，BindingResult包含已完成数据绑定的参数对象，还包含相应的校验错误的对象。

- 
5.Spring MVC抽取BindingResult中的参数对象及校验对象，将它们赋给处理方法的相应参数。

### 2.数据转换(ConversionService)

在Java语言中，在java.beans包中提供了一个PropertyEditor接口来进行数据转换(只能用于字符串和Java对象的转换)。其功能就是将一个字符串转换为一个Java对象。

Spring 3.0，添加了一个通用的类型转换模块，位于org.springframework.core.convert包中。

#### 2.1 ConversionServiceboolean canConvert(TypeDescriptor sourceType, TypeDescriptor targetType)

org.springframework.core.convert.ConversionService是Spring类型转换的核心接口。

- boolean canConvert(Class<?> sourceType, Class<?> targetType)

判断是否可以将一个Java类转换为另一个Java类

- boolean canConvert(TypeDescriptor sourceType, TypeDescriptor targetType)

TypeDescriptor不但描述了需要转换类的信息，还描述了类的上下文信息。这样可以利用这些信息做出更多的各种灵活的控制。

- <T> T convert(Object source, Class<T> targetType)

将源类型对象转换为目标类型对象

- Object convert(Object source, TypeDescriptor sourceType, TypeDescriptor targetType)

将源类型从源类型对象转换为目标类型对象，通常利用到类中的上下文信息

可以利用org.springframework.context.support.ConversionServiceFactoryBean在Spring的上下文中定义一个ConversionService。Spring将自动识别出上下文种的ConversionService，并在Spring MVC处理方法的参数绑定中使用它进行数据转换。

    <bean class="org.springframework.context.support.ConversionServiceFactoryBean"/>
    

#### 2.2 Spring支持的转换器

Spring 在org.springframework.core.convert.converter包中定义了3种类型的转换器接口，我们可以实现其中任意一种转换接口，并将它作为自定义转换器注册到ConversionServiceFactoryBean当中。

Spring中最简单的一个转换器接口。该方法负责将S类型转换为T类型的对象。

如果希望将一种类型的对象转换为另一种类型及其子类对象，比如将String类型转换为Number以及Number的子类Integer、Double等对象。就需要一系列的Converter。该接口的作用就是将这一系列的相同的Converter封装在一起。

Converter<S，T>只是负责将一个类型的对象转换为另一个类型的对象，它并没有考虑类型对象的上下文信息。因此不能完成复杂类型的转换工作。而该接口会根据源类型的对象及其上下文进行类型转换。

Code

    public class User implements Serializable {
        private String loginname;
    
        private Date birthday;
    
        public String getLoginname() {
            return loginname;
        }
    
        public void setLoginname(String loginname) {
            this.loginname = loginname;
        }
    
        public Date getBirthday() {
            return birthday;
        }
    
        public void setBirthday(Date birthday) {
            this.birthday = birthday;
        }
    }
    

    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>
    <head>
        <title>Sign Up</title>
    </head>
    <body>
    <form action="/user/register" method="post">
        <table>
            <tr>
                <td><label>登录名：</label></td>
                <td><input type="text" id="loginname" name="loginname"></td>
            </tr>
            <tr>
                <td><label>生日：</label></td>
                <td><input type="text" id="birthday" name="birthday"></td>
            </tr>
            <tr>
                <td>
                    <input type="submit" id="submit" value="登录">
                </td>
            </tr>
        </table>
    </form>
    </body>
    </html>
    

    @RequestMapping(value = "register", method = RequestMethod.POST)
    public String register(@ModelAttribute User user, Model model) {
        model.addAttribute("user", user);
        return "success";
    }
    

这时候，前台输入的生日为String格式的。而User实体定义的是Date时间类型的。那么后台再接收的时候，就会报错。

这时候，我们就自定义类型转换器。实现ConversionService里面的最简单的Converter<S,T>

    public class StringToDateConverter implements Converter<String, Date> {
    
        /**
         * 日期类型模板，如yyyy-MM-dd
         */
        private String datePattern;
    
        public void setDatePattern(String datePattern) {
            this.datePattern = datePattern;
        }
    
        @Override
        public Date convert(String date) {
            Date result = null;
            try {
                SimpleDateFormat dateFormat = new SimpleDateFormat(this.datePattern);
                result = dateFormat.parse(date);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return result;
        }
    }
    

    <!--装配自定义的类型转换器-->
    <mvc:annotation-driven conversion-service="conversionService"/>
    
    <!--自定义Date类型转换器-->
    <bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
        <property name="converters">
            <bean class="utils.StringToDateConverter" p:datePattern="yyyy-MM-dd"/>
        </property>
    </bean>
    

#### 注册方法

- 1.InitBinder（不推荐使用java.beans.PropertyEditor）

刚才上面的注册方式是通过xml配置进行的操作，那么我们可以不借助xml配置，使用@InitBinder添加自定义编辑转换数据。这里就用到了Java自身的PropertyEditor类。

- 自定义方法实现PropertyEditor的相关类

    public class DateEditor extends PropertyEditorSupport {
    
        @Override
        public void setAsText(String text) throws IllegalArgumentException {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            try {
                Date date = dateFormat.parse(text);
                setValue(date);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
    

    @InitBinder
    public void initBinder(WebDataBinder binder){
        binder.registerCustomEditor(Date.class,new DateEditor());
    }
    
    

- 2.WebBindingInitializer（不推荐使用java.beans.PropertyEditor）

如果这个数据转换需要在系统多处使用，那么这个自定义转换器方法需要进行全局注册。使用WebBindingInitializer进行全局范围的注册。

### 3.数据格式化（Fommatter<T>）

Spring使用Converter转换器进行源类型对象到目标类型对象的转换。但是Converter并不能够进行输入或输出的信息的格式化。

Spring 3.0引入格式化转换框架，org.springframework.format，Formatte<T>为最重要的接口。

Converter接口是完成任意Object与Object之间的转换，而Formatter是完成任意Object与String的转换。所以Formatter接口更适合在Web层，处理用户表单提交的数据格式化。

Formatter<T>接口，完成T类型对象的格式化和解析功能。

    public interface Formatter<T> extends Printer<T>, Parser<T> {
    
    }
    

#### 3.1重要接口

格式化显示接口

    T parse(String text, Locale locale) throws ParseException;
    

解析接口，参考本地信息，将一个格式化后的字符串转换为T类型的对象。

Formatter<T>继承上面两个接口类，具备所继承接口的所有功能。

注册格式化转换器。一般很少单独用到，我们一般用到的FormattingConversionServiceFactoryBean这个里面已经封装了这个接口对象。

- AnnotationFormatterFactory<A extends Annotation>

注解驱动的字段格式化工厂，用于创建带注解的对象字段的Printer和Parser。即是用于格式化和解析带注释的对象字段。

    //注解A的应用范围，哪些属性类可以标注A注解
    Set<Class<?>> getFieldTypes();
    

    //根据A注解，获取特定属性类型Printer
    Printer<?> getPrinter(A annotation, Class<?> fieldType);
    

    //根据A注解，获取特定属性类型Parser
    Parser<?> getParser(A annotation, Class<?> fieldType);
    

#### 3.2 自定义实现Formatter接口（了解下实现方式）

    public class DateFormatter implements Formatter<Date> {
    
        private String datePattern;
    
        private SimpleDateFormat dateFormat;
    
        public DateFormatter(String datePattern) {
            this.datePattern = datePattern;
            dateFormat = new SimpleDateFormat(datePattern);
    
        }
    
        @Override
        public Date parse(String text, Locale locale) throws ParseException {
            Date result = null;
            try {
                result = dateFormat.parse(text);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return result;
        }
    
        @Override
        public String print(Date object, Locale locale) {
            return dateFormat.format(object);
        }
    }
    

    <!--装配自定义格式转化器-->
    <mvc:annotation-driven conversion-service="conversionService"/>
    

    <!--配置自定义格式化转换器bean-->
    <bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
        <property name="formatters">
            <bean class="utils.DateFormatter" c:datePattern="yyyy-MM-dd"/>
        </property>
    </bean>
    

#### 3.3 使用系统内置的转换器（推荐这种方式）

当然Spring本身就提供了很多内置的转换器，不需要我们再写多余的代码。比如上面我们自定义的时间格式转化器。Spring内置的org.springframework.format.datetime包中就有对应的DateFormatter实现类。

我们只需要定义xml就可以了，如下。

    <bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
        <property name="formatters">
            <bean class="org.springframework.format.datetime.DateFormatter" c:pattern="yyyy-MM-dd"/>
        </property>
    </bean>
    

#### 3.4 自定义使用FormatterRegister注册Formatter(只需要了解，无须掌握，太麻烦) 

前面我们直接在xml里面注册Formatter实现类，那么我们还可以直接在xml里面注册Registrar，来替代直接注册Formatter。

自定义出FormatterRegistrar类

    public class CustomerFormatterRegistrar implements FormatterRegistrar {
    
        private DateFormatter dateFormatter;
    
        public CustomerFormatterRegistrar(DateFormatter dateFormatter) {
            this.dateFormatter = dateFormatter;
        }
    
        @Override
        public void registerFormatters(FormatterRegistry registry) {
            registry.addFormatter(dateFormatter);
        }
    }
    

自定义出DateFormmater类

    public class DateFormatter implements Formatter<Date> {
    
        private String datePattern;
    
        private SimpleDateFormat dateFormat;
    
        public DateFormatter(String datePattern) {
            this.datePattern = datePattern;
            dateFormat = new SimpleDateFormat(datePattern);
    
        }
    
        @Override
        public Date parse(String text, Locale locale) throws ParseException {
            Date result = null;
            try {
                result = dateFormat.parse(text);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return result;
        }
    
        @Override
        public String print(Date object, Locale locale) {
            return dateFormat.format(object);
        }
    }
    

    <!--装配自定义格式转化器-->
    <mvc:annotation-driven conversion-service="conversionService"/>
    

    <!--在Spring上下文定义出自定义的时间转化器组件-->
    <bean id="dateFormatter" class="utils.DateFormatter" c:datePattern="yyyy-MM-dd"></bean>
    
    <bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
        <property name="formatterRegistrars">
            <bean class="utils.CustomerFormatterRegistrar" c:dateFormatter-ref="dateFormatter"></bean>
        </property>
    </bean>
    

#### 3.5 使用注解的方式来进行格式化工作（AnnotationFormatterFactory<A extends Annotation>）

前面的例子无论是自定义实现数据格式工作还是使用系统内置的类，都需要通过进行繁琐的xml配置。现在我们直接使用**注解_Annotation**的方式进行实现格式化工作。

org.springframework.format.annotation 定义了两个格式化的注解类型

@DateTimeFormat 注解可以对java.util.Date、java.util.Calendar等时间类型的属性进行标注。该类支持下面三种互斥属性

==互斥属性指的是只能拥有其一，不然同时具备。==

    //自定义时间格式
    private String pattern;
    
    private String stylePattern;
    
    private ISO iso;
    

stylePattern

    /**
     * Set the two character to use to format date values. The first character used for
     * the date style, the second is for the time style. Supported characters are
     * <ul>
     * <li>'S' = Small</li>短日期/时间的样式
     * <li>'M' = Medium</li>中日期/时间的样式
     * <li>'L' = Long</li>长日期/时间的样式
     * <li>'F' = Full</li>完整日期/时间的样式
     * <li>'-' = Omitted</li>忽略日期/时间的样式
     * <ul>
     * This method mimics the styles supported by Joda-Time.
     * @param stylePattern two characters from the set {"S", "M", "L", "F", "-"}
     * @since 3.2
     */
    public void setStylePattern(String stylePattern) {
        this.stylePattern = stylePattern;
    }
    
    

IOS几种可选值

    formats.put(ISO.DATE, "yyyy-MM-dd");
    formats.put(ISO.TIME, "HH:mm:ss.SSSZ");
    formats.put(ISO.DATE_TIME, "yyyy-MM-dd'T'HH:mm:ss.SSSZ");
    

NumberFormat可对类似数字类型的属性进行标注，它拥有两个互斥的属性。

    String pattern()
    
    Style style()
    

style可选枚举值

    enum Style {
    
        /**
         * The default format for the annotated type: typically 'number' but possibly
         * 'currency' for a money type (e.g. {@code javax.money.MonetaryAmount)}.
         * @since 4.2
         */
        DEFAULT,
    
        /**
         * The general-purpose number format for the current locale.
         */
        NUMBER,
    
        /**
         * The percent format for the current locale.
         */
        PERCENT,
    
        /**
         * The currency format for the current locale.
         */
        CURRENCY
    }
    

#### 代码演示

- 后台代码新建需要进行数据转换及格式化的类。省略了get、set方法

    public class User implements Serializable {
        private String loginname;
    
        @DateTimeFormat(pattern = "yyyy-MM-dd")
        private Date birthday;
    
        /**
         * 薪水，以财务格式接收
         */
        @NumberFormat(style = NumberFormat.Style.NUMBER, pattern = "#,###")
        private double salary;
    
        /**
         * 业绩完成比例
         */
        @NumberFormat(style = NumberFormat.Style.PERCENT)
        private double performance;
    
        /**
         * 薪水的货币类型展示
         */
        @NumberFormat(style = NumberFormat.Style.CURRENCY)
        private double salaryDisplay;
    }
    

    <mvc:annotation-driven/>
{% endraw %}
