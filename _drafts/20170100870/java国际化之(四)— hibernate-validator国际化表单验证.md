---
layout: post
title:  "java国际化之(四)— hibernate-validator国际化表单验证"
title2:  "java国际化之(四)— hibernate-validator国际化表单验证"
date:   2017-01-01 23:49:30  +0800
source:  "https://www.jfox.info/java%e5%9b%bd%e9%99%85%e5%8c%96%e4%b9%8b-%e5%9b%9b-hibernate-validator%e5%9b%bd%e9%99%85%e5%8c%96%e8%a1%a8%e5%8d%95%e9%aa%8c%e8%af%81.html"
fileName:  "20170100870"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e5%9b%bd%e9%99%85%e5%8c%96%e4%b9%8b-%e5%9b%9b-hibernate-validator%e5%9b%bd%e9%99%85%e5%8c%96%e8%a1%a8%e5%8d%95%e9%aa%8c%e8%af%81.html"
---
{% raw %}
/**
     * Created by gantianxing on 2017/6/8.
     */
    public class User implements Serializable {
        private static final long serialVersionUID = 1L;
        @NotNull
        @Size(min=2,max = 5)
        private String name;//姓名
        @NotNull
        @Past
        private Date birthday;//生日
        @NotNull
        @Digits(integer=3,fraction=2)
        private BigDecimal money;//资产
        @NotNull
        @Pattern(regexp="d{11}")
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
    }

具体注解含义就不解释了，根据上面的规则讲解，一目了然。

启动tomcat，访问[http://localhost/add](https://www.jfox.info/go.php?url=http://localhost/add)，如下：

每个字段都不填写值，直接点击”添加”按钮：

切换化到英文：

可以看到验证框架，有一套自己默认的错误提示信息，并且已经支持了国际化（这里我只试了中文和英文）。

**整合国际化配置文件**

一般情况下你对默认的错误提示信息会不满意，别紧张，Spring MVC可以很好的把hibernate-validator验证器与国际化配置整合起来。整合分三步：

第一步：首先我们要修改User类的注解，把错误消息的key指定为国际化属性配置文件中的key，如下：

    public class User implements Serializable {
        private static final long serialVersionUID = 1L;
        @NotNull(message="{user.name.null}")
        @Size(min=2,max =5,message = "{user.name.error}")
        private String name;//姓名
        @NotNull(message="{user.birthday.null}")
        @Past(message="{user.birthday.error}")
        private Date birthday;//生日
        @NotNull(message="{user.money.null}")
        @Digits(integer=3,fraction=2,message="{user.money.error}")
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
    }

第二步：再修改spring-mvc.xml配置文件，整合hibernate-validator验证器与国际化配置：

    <mvc:annotation-driven validator="validator" conversion-service="formatService" />
        <bean id="validator" class="org.springframework.validation.beanvalidation.LocalValidatorFactoryBean">
            <property name="providerClass"  value="org.hibernate.validator.HibernateValidator"/>
            <!--指定国际化配置文件 不设置则默认为classpath下的 ValidationMessages.properties -->
            <property name="validationMessageSource" ref="messageSource"/>
        </bean>
    <!-- formatter转换配置 -->
        <bean id="formatService"
              class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
            <property name="formatters">
                <set>
                    <bean class="com.sky.locale.demo.formatter.MyDateFormatter" />
                    <bean class="com.sky.locale.demo.formatter.MyCurrencyFormatter" />
                </set>
            </property>
    </bean>
    <!-- 国际化资源文件 -->
        <bean id="messageSource"
              class="org.springframework.context.support.ReloadableResourceBundleMessageSource">
            <property name="basenames" >
                <list>
                    <value>/WEB-INF/resource/usermsg</value>
                    <value>/WEB-INF/resource/userlabels</value>
                </list>
            </property>
            <property name="defaultEncoding" value="UTF-8"/>
        </bean>

第三步：在属性配置文件中添加自定义的国家化消息，在中文usermsg_zh_CN.properties配置中添加：

    user.name.null=请输入用户名
    user.name.error=用户名长度必须在{min}到{max}之间
    user.birthday.null=请输入生日
    user.birthday.error=生日必须小于当前时间
    user.money.null=请输入资产
    user.money.error=资产不能超过1000000
    user.phoneNum.null=请输入手机号
    user.phoneNum.error=手机号必须为11位

在英文配置文件usermsg_en_GB.properties中添加：

    user.name.null=Please enter a name
    user.name.error=name length must between{min} and {max}
    user.birthday.null=Please enter a birthday
    user.birthday.error=birthday is a past time
    user.money.null=Please enter a money
    user.money.error=money < 1000000
    user.phoneNum.null=Please enter a phoneNum
    user.phoneNum.error=phoneNum length is 11
{% endraw %}
