---
layout: post
title:  "Spring+SpringMVC+MyBatis+easyUI集成进阶篇(二)RESTful API实战笔记(接口设计及Java后端实现)"
title2:  "Spring+SpringMVC+MyBatis+easyUI集成进阶篇(二)RESTful API实战笔记(接口设计及Java后端实现)"
date:   2018-09-07 02:13:02  +0800
source:  "http://www.jfox.info/springspringmvcmybatiseasyui%e9%9b%86%e6%88%90%e8%bf%9b%e9%98%b6%e7%af%87%e4%ba%8crestfulapi%e5%ae%9e%e6%88%98%e7%ac%94%e8%ae%b0%e6%8e%a5%e5%8f%a3%e8%ae%be%e8%ae%a1%e5%8f%8ajava%e5%90%8e%e7%ab%af.html"
fileName:  "9a21044"
lang:  "zh_CN"
published: false
---
{% raw %}
By  - Last updated: 星期四, 八月 10, 2017

原计划这部分代码的更新也是上传到ssm-demo仓库中，因为如下原因并没有这么做：

- 
有些使用了该项目的朋友建议重新创建一个仓库，因为原来仓库中的项目太多，结构多少有些乱糟糟的。

- 
而且这次的代码改动较大，与原来的目录结构及代码风格相比都有很大的差别。

- 
同时也考虑到不同的人所处的学习阶段不同，担心有人不习惯也不适应这种风格及后面的更新，有的朋友甚至可能是初学者，更适合学习ssm-demo这个基础项目。

基于以上几点，最终并没有选择把几个项目都放在一个代码仓库中，而是另外花了些时间改动并且重新创建了一个仓库，[perfect-ssm](http://www.jfox.info/go.php?url=https://github.com/ZHENFENG13/perfect-ssm)另起炉灶，项目也在新的服务器和域名下部署。

![](http://www.jfox.info/wp-content/uploads/2017/08/1502376367.png)

## 接口设计

项目共有三个模块:

针对以上三个模块，并结合前文[《设计一套好的RESTful API》](http://www.jfox.info/go.php?url=http://www.cnblogs.com/han-1034683568/p/7196345.html)中所总结的RESTful API设计原则，对api进行改造，目标接口如下：

    图片上传：
    原接口 []      http://ssm-demo.hanshuai.xin/loadimage/upload.do
    现接口 [POST]  http://perfect-ssm.hanshuai.xin/images
    
    文章添加：
    原接口 []      http://ssm-demo.hanshuai.xin/article/save.do
    现接口 [POST]  http://perfect-ssm.hanshuai.xin/articles 
    
    文章修改：
    原接口 []      http://ssm-demo.hanshuai.xin/article/save.do
    现接口 [PUT]  http://perfect-ssm.hanshuai.xin/articles 
    
    文章列表：
    原接口 []      http://ssm-demo.hanshuai.xin/article/list.do
    现接口 [GET]   http://perfect-ssm.hanshuai.xin/articles
    
    文章删除：
    原接口 []      http://ssm-demo.hanshuai.xin/article/delete.do
    现接口 [DELETE]http://perfect-ssm.hanshuai.xin/articles
    
    图片添加：
    原接口 []      http://ssm-demo.hanshuai.xin/picture/save.do
    现接口 [POST]  http://perfect-ssm.hanshuai.xin/pictures
    
    图片修改：
    原接口 []      http://ssm-demo.hanshuai.xin/picture/save.do
    现接口 [PUT]  http://perfect-ssm.hanshuai.xin/pictures
    
    图片列表：
    原接口 []      http://ssm-demo.hanshuai.xin/picture/list.do
    现接口 [GET]   http://perfect-ssm.hanshuai.xin/pictures
    
    图片删除：
    原接口 []      http://ssm-demo.hanshuai.xin/picture/delete.do
    现接口 [DELETE]http://perfect-ssm.hanshuai.xin/pictures
    
    用户登录：
    原接口 []      http://ssm-demo.hanshuai.xin/user/login.do
    现接口 [POST]  http://perfect-ssm.hanshuai.xin/users/cookie 
    
    用户列表：
    原接口 []      http://ssm-demo.hanshuai.xin/user/list.do
    现接口 [GET]   http://perfect-ssm.hanshuai.xin/users 
    
    用户删除：
    原接口 []      http://ssm-demo.hanshuai.xin/user/delete.do
    现接口 [DELETE]http://perfect-ssm.hanshuai.xin/users
    
    用户添加：
    原接口 []      http://ssm-demo.hanshuai.xin/user/save.do
    现接口 [POST]  http://perfect-ssm.hanshuai.xin/users
    
    修改密码：
    原接口 []      http://ssm-demo.hanshuai.xin/user/modifyPassword.do
    现接口 [PUT]   http://perfect-ssm.hanshuai.xin/users

根据不同资源映射成不同的uri，对于资源的具体操作类型，由HTTP动词来表示。

## java后端实现

前文中提到了一些设计原则，这一篇就是将这些原则运用到项目中，但是理论性的知识看看就忘了，我写博客的目的不是为了写理论概念，没有实际项目配合我是不会写的，我觉得通过代码实现出来，配合实战才能让理论知识吸收的更好。

由于是ssm项目，因此主要是通过SpringMVC实现，更多的是使用了SpringMVC的注解来进行简化开发。

#### 整合过程：

- 首先是修改web.xml配置文件，使得URI可以符合RESTful风格。

        <servlet>
            <servlet-name>springMVC</servlet-name>
            <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
            <init-param>
                <param-name>contextConfigLocation</param-name>
                <param-value>classpath:spring-context-mvc.xml</param-value>
            </init-param>
            <!--加载顺序为1 -->
            <load-on-startup>1</load-on-startup>
        </servlet>
    
        <servlet-mapping>
            <servlet-name>springMVC</servlet-name>
            <url-pattern>/</url-pattern>
        </servlet-mapping>

- 修改spring-context-mvc.xml配置文件，配置json消息转换器及动态资源过滤。

        <!-- Start: 配置json消息转换器 & 参数解析-->
        <bean id="objectMapper" class="com.fasterxml.jackson.databind.ObjectMapper">
            <property name="dateFormat">
                <bean class="java.text.SimpleDateFormat">
                    <constructor-arg index="0" type="java.lang.String" value="yyyy-MM-dd HH:mm:ss"/>
                </bean>
            </property>
        </bean>
        <mvc:annotation-driven>
            <mvc:message-converters register-defaults="true">
                <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
                    <property name="supportedMediaTypes">
                        <list>
                            <value>application/json; charset=UTF-8</value>
                        </list>
                    </property>
                    <property name="prettyPrint" value="true"/>
                    <property name="objectMapper" ref="objectMapper"/>
                </bean>
            </mvc:message-converters>
        </mvc:annotation-driven>
        <!-- End: 配置json消息转换器 & 参数解析 -->
    
        <!-- 使用了<url-pattern>/</url-pattern>,所以要对静态资源进行处理 -->
        <mvc:default-servlet-handler/>
    
        <!-- 默认的视图解析器 在上边的解析错误时使用 (默认使用html)- -->
        <bean id="defaultViewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver"
              p:order="1">
            <property name="viewClass" value="org.springframework.web.servlet.view.JstlView"/>
            <property name="contentType" value="text/html"/>
            <property name="prefix" value="/WEB-INF/"/>
            <property name="suffix" value=".jsp"/>
        </bean>

- @RequestMapping注解，规范和限制Http请求的请求方法。

    @RequestMapping(value = "", method = RequestMethod.PUT)
    
    @RequestMapping(value = "/{ids}", method = RequestMethod.DELETE)

- 
@ResponseBody注解，将返回结果转换为JSON格式。

- 
增加common包，其中的工具类规定了返回状态码及返回数据的基本格式。
![](http://www.jfox.info/wp-content/uploads/2017/08/1502376368.png)

    public class Constants {
    
        public static final int RESULT_CODE_SUCCESS = 200;  // 成功处理请求
        public static final int RESULT_CODE_BAD_REQUEST = 412;  // bad request
        public static final int RESULT_CODE_SERVER_ERROR = 500;  // 没有对应结果
    
    }
    
    public class Result<T> implements Serializable {
        private static final long serialVersionUID = 1L;
        private int resultCode;
        private String message;
        private T data;
    
        public Result() {
        }
    }

## 注意事项

几个需要注意的注解：

- @RequestMapping
- @PathVariable
- @ResponseBody
- @RequestParam

代码中大量的出现，本文中也一再强调，因此，给正在看本篇文章的你一个建议就是如果你不熟悉这几个注解，花点时间去认真学习和实践一下，知道这几个注解的用法和注意事项，网上针对这些注解的文章有很多，可以针对性的学习一下，这篇文章就不再占用篇幅去赘述了，需要代码的话，直接去我的GitHub仓库中去下载就好。

[![](http://www.jfox.info/wp-content/uploads/2018/06/ewm2.png)](https://itunes.apple.com/cn/app/学英语听新闻/id1368539116?mt=8)
{% endraw %}
