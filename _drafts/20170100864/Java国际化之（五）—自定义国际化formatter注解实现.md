---
layout: post
title:  "Java国际化之（五）—自定义国际化formatter注解实现"
title2:  "Java国际化之（五）—自定义国际化formatter注解实现"
date:   2017-01-01 23:49:24  +0800
source:  "https://www.jfox.info/java_guo_ji_hua_zhi_wu_-_zi_ding_yi_guo_ji_hua_formatter_zhu_jie_shi_xian.html"
fileName:  "20170100864"
lang:  "zh_CN"
published: true
permalink: "2017/java_guo_ji_hua_zhi_wu_-_zi_ding_yi_guo_ji_hua_formatter_zhu_jie_shi_xian.html"
---
{% raw %}
**引言**

由于Spring MVC自带的@NumberFormat和@DateTimeFormat格式化不能很好的支持国际化，在《java国际化之—springMVC+Freemaker demo(三)》[http://moon-walker.iteye.com/blog/2379940](/blog/2379940)的demo中我们实现了自定的formatter：MyDateFormatter、MyCurrencyFormatter分别支持国际化的日期、货币处理。但有个弊端，表单对象中所有的Date、BigDecimal类型都会进行相同规则的转换，不能像Spring MVC自带的@NumberFormat和@DateTimeFormat对指定属性添加注解，只对指定对象进行转换。

创建过程分为三步：

第一步：首先我们看下@DateTimeFormat注解在Spring MVC中的实现，并模拟创建自己的@MyDateFormat注解，内容如下：

    /**
     * Created by gantianxing on 2017/6/17.
     */
    @Documented
    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE})
    public @interface MyDateFormat {
    }

第二步：仿照Spring MVC中的DateTimeFormatAnnotationFormatterFactory创建自己AnnotationFormatterFactory实现类MyDateFormatAnnotationFormatterFactory，内容如下：

    /**
     * Created by gantianxing on 2017/6/17.
     */
    public class MyDateFormatAnnotationFormatterFactory implements AnnotationFormatterFactory<MyDateFormat> {
        private static final Set<Class<?>> FIELD_TYPES;
        static {
            Set<Class<?>> fieldTypes = new HashSet<Class<?>>(4);
            fieldTypes.add(Date.class);//这里只处理Date类型
            FIELD_TYPES = Collections.unmodifiableSet(fieldTypes);
        }
        @Override
        public Set<Class<?>> getFieldTypes() {
            return FIELD_TYPES;//返回支持的类型列表
        }
        @Override
        public Printer<?> getPrinter(MyDateFormat myDateFormat, Class<?> aClass) {
            return getFormatter(myDateFormat, aClass);
        }
        @Override
        public Parser<?> getParser(MyDateFormat myDateFormat, Class<?> aClass) {
            return getFormatter(myDateFormat, aClass);
        }
        protected Formatter<Date> getFormatter(MyDateFormat annotation, Class<?> fieldType) {
            MyDateFormatter formatter = new MyDateFormatter();
            return formatter;
        }
    }

第三步：将自定义的MyDateFormatAnnotationFormatterFactory注入到spring mvc，在spring-mvc.xml中的配置代码如下：

    <!-- formatter转换配置 -->
        <bean id="formatService"
              class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
            <property name="formatters">
                <set>
                    <!-- 采用自定义的AnnotationFormatterFactory注入，可以使用注解 -->
                    <bean class="com.sky.locale.demo.formatter.factory.MyDateFormatAnnotationFormatterFactory" />
                    <!-- 直接注入自定义Formatter无法使用注解 -->
                    <bean class="com.sky.locale.demo.formatter.MyCurrencyFormatter" />
                </set>
            </property>
    </bean>

为了对比，这里MyCurrencyFormatter没有采用自定义注解方式实现，感觉兴趣的朋友可以参照上述三个步骤自己实现。

**使用自定义注解**

为了方便对比，在User类中同时使用自带的@DateTimeFormat注解、自定义的@MyDateFormat注解。在上一篇代码的基础上，对birthday字段添加@DateTimeFormat注解，新增regTime字段并添加@DateTimeFormat(pattern=”yyyy-MM-dd”),修改后的代码如下：

    /**
     * Created by gantianxing on 2017/6/8.
     */
    public class User implements Serializable {
        private static final long serialVersionUID = 1L;
        @NotNull(message="{user.name.null}")
        @Size(min=2,max =5,message = "{user.name.error}")
        private String name;//姓名
        @NotNull(message="{user.birthday.null}")
        @Past(message="{user.birthday.error}")
        @MyDateFormat
        private Date birthday;//生日
        @DateTimeFormat(pattern="yyyy-MM-dd")
        private Date regDate;//注册时间
        @NotNull(message="{user.money.null}")
        @Digits(integer=3,fraction=2,message="{user.money.error}")
        @NumberFormat(pattern = "￥#.##")
        private BigDecimal money;//资产
        @NotNull(message="{user.phoneNum.null}")
        @Pattern(regexp="d{11}",message="{user.phoneNum.error}")
        private String phoneNum;//手机号
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public Date getBirthday() {
            return birthday;
        }
        public void setBirthday(Date birthday) {
            this.birthday = birthday;
        }
        public BigDecimal getMoney() {
            return money;
        }
        public void setMoney(BigDecimal money) {
            this.money = money;
        }
        public String getPhoneNum() {
            return phoneNum;
        }
        public void setPhoneNum(String phoneNum) {
            this.phoneNum = phoneNum;
        }
        public Date getRegDate() {
            return regDate;
        }
        public void setRegDate(Date regDate) {
            this.regDate = regDate;
        }
    }
    

启动tomcat，访问http://localhost/add页面，填写表单，Register Date的格式必须为yyyy-MM-dd，输入错误的情况下，报如下错误：

这种错误提示不能直接暴露给用户，我们可以通过打印器错误码，并在国际化配置文件中进行配置。比如这里的打印的错误码为：typeMismatch，在中文和英文的属性配置文件中分别配置：

typeMismatch.user.regDate=格式:yyyy-MM-dd

typeMismatch.user.regDate=Style:yyyy-MM-dd

重启tomcat，重新提交错误格式的regDate表单，显示如下：

再切换到中文（ps:如果切换不成功，tomcat版本请换成tomcat8以上）：

同时在birthday字段上使用的自定义注解@MyDateFormat，也已经生效。

如果在同一个表单对象中，有多个Date类型，只需要对其中部分Date字段进行自定义格式化转换，另外的采用Spring MVC默认的格式化转换，这个时候就不得不用到自定义注解实现。

ok，关于“自定义国际化formatter注解实现”方法讲解完毕，最后奉上代码 GitHub地址：[https://github.com/gantianxing/locale-demo2.git](https://www.jfox.info/go.php?url=https://github.com/gantianxing/locale-demo2.git)。
{% endraw %}
