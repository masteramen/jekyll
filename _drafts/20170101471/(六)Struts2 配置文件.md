---
layout: post
title:  "(六)Struts2 配置文件"
title2:  "(六)Struts2 配置文件"
date:   2017-01-01 23:59:31  +0800
source:  "https://www.jfox.info/%e5%85%adstruts2%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6.html"
fileName:  "20170101471"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%85%adstruts2%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6.html"
---
{% raw %}
本章节将带你学习Struts2 应用程序所需的基本配置。在这里可以看到哪些将被配置到一些重要的配置文件中：**web.xml**、**struts.xml**、**struts-config.xml**以及**struts.properties**。

实际上，你可以继续依赖于使用web.xml和struts.xml配置文件，并且你已经在前面的章节中了解到，我们的示例是使用这两个文件运作的，不过为了让你了解更多，我们还是再来说明一下其他的文件。

## web.xml文件
 

  web.xml配置文件是一种J2EE配置文件，决定servlet容器的HTTP元素需求如何进行处理。它严格来说不是一个Struts2 配置文件，但它是Struts2 运作所需要进行配置的文件。 
 

正如前面所讨论的，这个文件为每个web应用程序提供接入点。在部署描述符（web.xml）中，Struts2 应用程序的接入点将会定义为一个过滤器。因此我们将在web.xml里定义一个FilterDispatcher类的接入点，而这个web.xml文件需要在**WebContent/WEB-INF**文件夹下创建。

如果你开始时没有模板或工具（比如Eclipse或Maven2）的辅助来生成，那这就是第一个你需要配置的文件。下面是我们在上一个例子中用到的web.xml的内容。

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns="http://java.sun.com/xml/ns/javaee" 
       xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
       xsi:schemaLocation="http://java.sun.com/xml/ns/javaee 
       http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
       id="WebApp_ID" version="3.0">
       
       <display-name>Struts 2</display-name>
       <welcome-file-list>
          <welcome-file>index.jsp</welcome-file>
       </welcome-file-list>
       
       <filter>
          <filter-name>struts2</filter-name>
          <filter-class>
             org.apache.struts2.dispatcher.FilterDispatcher
          </filter-class>
       </filter>
    
       <filter-mapping>
          <filter-name>struts2</filter-name>
          <url-pattern>/*</url-pattern>
       </filter-mapping>
    
    </web-app>
    

注意，我们将Struts2 过滤器映射到 **/* **，而不是** /*.action **，这意味着所有的url都会被Struts过滤器解析。当我们学到关于注解的章节时会对这个进行讨论。

## struts.xml文件
**struts.xml**文件包含有随着Actions的开发你将要修改的配置信息。它可用于覆盖应用程序的默认设置，例如：struts.devMode=false 以及其他定义为属性文件的设置。这个文件可在 
 **WEB-INF/classes**文件夹下创建。 
 

  让我们来看一下在前一章节中阐述的Hello World示例里创建的struts.xml文件。 
 

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE struts PUBLIC
       "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
       "http://struts.apache.org/dtds/struts-2.0.dtd">
    <struts>
       <constant name="struts.devMode" value="true" />
       <package name="helloworld" extends="struts-default">
         
          <action name="hello" 
                class="cn.w3cschool.struts2.HelloWorldAction" 
                method="execute">
                <result name="success">/HelloWorld.jsp</result>
          </action>
          <-- more actions can be listed here -->
    
       </package>
       <-- more packages can be listed here -->
    
    </struts>
    

首先要注意的是**DOCTYPE**（文档类型）。如我们的示例所示，所有的Struts配置文件都需要有正确的doctype。<struts>是根标记元素，在其下，我们使用<package>标签声明不同的包。 这里的<package>标签允许配置的分离和模块化。这在你进行一个大的项目并且项目分为多个不同的模块时，是非常有用的。

如果您的项目有三个域：business_applicaiton、customer_application和staff_application的话，你可以创建三个包，并将相关的Actions存储到相应的包中。 <package>标签具有以下属性：
属性描述name（必需）为package的唯一标识extends指定package继承另一package的所有配置。通常情况下，我们使用struts-default作为package的基础。abstract定义package为抽象的。如果标记为true，则package不能被最终用户使用。namespaceActions的唯一命名空间
**<constant>**标签以及name和value属性将用于覆盖**default.properties**中定义的任一属性，就像我们设置的**struts.devMode**属性一样。设置**struts.devMode**属性允许我们在日志文件中查看更多的调试消息。

我们定义**<action>**标签对应于我们想要访问的每个URL，并且使用execute()方法定义一个访问相应的URL时将要访问的类。

Results（结果）确定在执行操作后返回到浏览器的内容，而从操作返回的字符串应该是结果的名称。 Results按上述方式配置，或作为“全局”结果配置，可用于包中的每个操作。 Results有**name**和**type**属性可选，默认的name值是“success”。
Struts.xml文件可以随着时间的推移而增长，因此通过包打破它是使它模块化的一种方式，但struts提供了另一种模块化struts.xml文件的方法，你可以将文件拆分为多个xml文件，并用以下方式导入它们。

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE struts PUBLIC
        "-//Apache Software Foundation//DTD Struts Configuration 2.0//EN"
        "http://struts.apache.org/dtds/struts-2.0.dtd">
    <struts>
         <include file="my-struts1.xml"/>
         <include file="my-struts2.xml"/>
    </struts>
    

我们没有覆盖的另一个配置文件是struts-default.xml。此文件包含Struts的标准配置设置，你不必再为99.99％的项目重复这些设置。 因此，我们不会深入了解这个文件的太多细节。如果你有兴趣，可以查看在struts2-core-2.2.3.jar文件中可用的**default.properties**文件。

## struts-config.xml文件

struts-config.xml配置文件是Web Client中View和Model组件之间的链接，但在你99.99％的项目里你不必使用这些设置。 struts-config.xml配置文件包含以下主要元素：
序号拦截器和说明1**struts-config**
这是配置文件的根节点。
2**form-beans**
这是你将ActionForm子类映射到name的位置，你可以在struts-config.xml文件的其余部分，甚至在JSP页面上，将这个name用作ActionForm的别名。
3**global forwards**
此部分将你在webapp上的页面映射到name，你可以使用这个name来引用实际页面。这避免了对你网页上的URL进行硬编码。
4**action-mappings**
这是你声明表单处理程序的地方，也被称为**操作映射（action mappings）**。
5**controller**
这部分是配置Struts的内部，在实际情况中很少使用。
6**plug-in**
这部分告诉Struts在哪里找到属性文件，它包含提示和错误消息。

下面是struts-config.xml文件的示例：

    <?xml version="1.0" encoding="ISO-8859-1" ?>
    <!DOCTYPE struts-config PUBLIC
    "-//Apache Software Foundation//DTD Struts Configuration 1.0//EN"
    "http://jakarta.apache.org/struts/dtds/struts-config_1_0.dtd">
    
    <struts-config>
    
       <!-- ========== Form Bean Definitions ============ -->
       <form-beans>
          <form-bean name="login" type="test.struts.LoginForm" />
       </form-beans>
    
       <!-- ========== Global Forward Definitions ========= -->
       <global-forwards>
       </global-forwards>
    
       <!-- ========== Action Mapping Definitions ======== -->
       <action-mappings>
          <action
             path="/login"
             type="test.struts.LoginAction" >
    
             <forward name="valid" path="/jsp/MainMenu.jsp" />
             <forward name="invalid" path="/jsp/LoginView.jsp" />
          </action>
       </action-mappings>
    
       <!-- ========== Controller Definitions ======== -->
       <controller 
          contentType="text/html;charset=UTF-8"
          debug="3"
          maxFileSize="1.618M"
          locale="true"
          nocache="true"/>
    
    </struts-config>
    

有关struts-config.xml文件的更多详细内容，可查看Struts Documentation。

## struts.properties文件

这个配置文件提供了一种机制来改变框架的默认行为。实际上，**struts.properties**配置文件中包含的所有属性也可以在**web.xml**中配置使用**init-param**，以及在**struts.xml**配置文件中使用**constant**标签。 但如果你想保持事件独立以及保留更多struts细节，那么你可以在**WEB-INF/classes**文件夹下创建这个文件。

struts.properties文件中配置的值将覆盖**default.properties**中配置的默认值，这些值包含在struts2-core-x.y.z.jar分布中。有一些属性，你可以考虑改为使用**struts.properties**文件：

    ### When set to true, Struts will act much more friendly for developers
    struts.devMode = true
    
    ### Enables reloading of internationalization files
    struts.i18n.reload = true
    
    ### Enables reloading of XML configuration files
    struts.configuration.xml.reload = true
    
    ### Sets the port that the server is run on
    struts.url.http.port = 8080
    

这里任何以＃（hash）开头的行都将被假定为注释，并且它会被Struts 2默认忽略。
{% endraw %}
