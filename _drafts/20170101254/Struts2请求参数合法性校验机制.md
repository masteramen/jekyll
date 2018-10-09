---
layout: post
title:  "Struts2请求参数合法性校验机制"
title2:  "Struts2请求参数合法性校验机制"
date:   2017-01-01 23:55:54  +0800
source:  "https://www.jfox.info/struts2%e8%af%b7%e6%b1%82%e5%8f%82%e6%95%b0%e5%90%88%e6%b3%95%e6%80%a7%e6%a0%a1%e9%aa%8c%e6%9c%ba%e5%88%b6.html"
fileName:  "20170101254"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/struts2%e8%af%b7%e6%b1%82%e5%8f%82%e6%95%b0%e5%90%88%e6%b3%95%e6%80%a7%e6%a0%a1%e9%aa%8c%e6%9c%ba%e5%88%b6.html"
---
{% raw %}
##  在Action中通过代码执行数据校验

**请求参数的输入校验途径一般分两种：客户端校验 ：通过JavaScript 完成 （jquery validation插件），目的：过滤正常用户的误操作。**

** 服务器校验 ：通过java代码完成 ，目的：整个应用阻止非法数据的最后防线**

**列如：**

    <h1>登录：请求数据校验--代码手动校验</h1><s:fielderror/><form action="${pageContext.request.contextPath }/login.action" method="post">
            用户名：<input type="text" name="username"/><s:fielderror fieldName="username"/><br/>
            密    码：<input type="password" name="password"/><br/><input type="submit" value="登录"/></form>

### **1.全局校验 （对当前Action的所有方法进行校验 ）**

**如果要执行校验 ，Action必须继承ActionSupport 类 （因为它实现 Validateable接口）**

    //手动校验publicvoid validate() {
    //StringUtils.isBlank（）方法判断输入是否为空if(StringUtils.isBlank(username)){
      /*将错误信息写入Map<String,List<String>> fieldErrors;
        当遇到workflow拦截器时，会判断错误集合的size的大于0，
        如果大于0，则向input的视图跳转*/super.addFieldError("username", "用户不能为空");
          }
    }

**StringUtils 方法的操作对象是 java.lang.String 类型的对象，是 JDK 提供的 String 类型操作方法的补充，并且是 null 安全的(即如果输入参数 ****String 为 null则不会抛出 NullPointerException ，而是做了相应处理。**

    **JSP显示错误信息配置Struts2的特有标签S标签**

**在jsp增加显示错误信息 <s:fielderror /**>

## **校验机制原理分析：**

### 2.局部校验 （校验Action中指定业务方法—校验一个方法 ）

** 在Action 添加 validateXxx 方法（约定）， 这里XXX 是要校验目标方法名 （只会对指定方法校验）**

**提示：**

**1．被校验方法首字母 要大写。**

**2．全局校验一直会执行，即使有局部校验。且先走的局部校验。**

**——————————————————————————————————————————————————————————————————————————**

## ** 基于XML配置实现校验**

### 1.  全局校验 （校验当前Action 所有方法-是针对某一个action中的所有方法）—-在Action类所在包，创建 Action类名-validation.xml

### JSP页面同上

### Action代码： Action 必须继承ActionSupport 类 （为了实现 **Validateable接口** ）

    publicclass LoginAction extends ActionSupport {
        privatestaticfinallong serialVersionUID = 1L;
        private String username;
        private String password;
        public String getUsername() {
            return username;
        }
        publicvoid setUsername(String username) {
            this.username = username;
        }
        public String getPassword() {
            return password;
        }
        publicvoid setPassword(String password) {
            this.password = password;
        }
    
        public String execute() throws Exception {
            System.out.println(this);
            return INPUT;
        }
        @Override
        public String toString() {
            return "LoginAction [username=" + username + ", password=" + password
                    + "]";
        }
        

### XML代码：（必须和 action在容一个包下，Action类名-validation.xml）

    <!DOCTYPE validators PUBLIC
              "-//Apache Struts//XWork Validator 1.0.3//EN"
              "http://struts.apache.org/dtds/xwork-validator-1.0.3.dtd"><validators><!-- 校验用户 --><field name="username"><field-validator type="requiredstring"><message>用户不能为空</message></field-validator></field><!-- 校验密码 --><field name="password"><field-validator type="requiredstring"><message>密码不能为空</message></field-validator></field></validators>

###  **局部校验 ****（校验当前Action ****指定方法 ****）**

**在Action****类所在包，创建 Action****类名-<action>name****属性-validation.xml**

**JSP页面代码：**

    <h1>登录：请求数据校验--xml配置校验--局部</h1><s:fielderror/><form action="${pageContext.request.contextPath }/login3.action" method="post">
            用户名：<input type="text" name="username"/>(非空，且长度为3-10位)<br/>
            密    码：<input type="password" name="password"/>(必须，且长度为6-12)<br/>
            重复密码：<input type="password" name="repassword"/>(必须和密码一致)<br/>
            年龄：<input type="text" name="age"/>(数字，且必须是18-100)<br/>
            手机号码：<input type="text" name="mobile"/>(手机号规则，11位数字)<br/>
            邮箱：<input type="text" name="email"/>(邮箱格式)<br/><input type="submit" value="登录"/></form>

**Action代码：**

    publicclass User2Action extends ActionSupport{
        privatestaticfinallong serialVersionUID = 1L;
        private String username;
        private String password;
        private String repassword;
        privateint age;
        private String mobile;
        private String email;
        
        public String login2(){
            System.out.println(this);
            return NONE;
        }
    /*
    
           GET和SET 方法略去...............
           toString方法略去..................
    
    */

**XML代码：**

    <!DOCTYPE validators PUBLIC
              "-//Apache Struts//XWork Validator 1.0.3//EN"
              "http://struts.apache.org/dtds/xwork-validator-1.0.3.dtd"><validators><field name="username"><field-validator type="stringlength"><param name="minLength">3</param><param name="maxLength">10</param><message>用户名必须在3-10位</message></field-validator></field><field name="password"><field-validator type="stringlength"><param name="minLength">6</param><param name="maxLength">12</param><message>密码必须在6-12位</message></field-validator></field><field name="repassword"><field-validator type="fieldexpression"><param name="expression">password==repassword</param><message>两次输入密码不一致</message></field-validator></field><field name="age"><field-validator type="int"><param name="min">18</param><param name="max">100</param><message>年龄必须是18-100</message></field-validator></field><field name="mobile"><field-validator type="regex"><param name="regex"><![CDATA[^1[3|5|8|4]d{9}$]]></param><message>用户名必须在3-10位</message></field-validator></field><field name="email"><field-validator type="email"><message>邮箱格式不正确</message></field-validator></field></validators>

**如果检测错误Action会自动跳转到input视图。**

其他校验器可参考：
{% endraw %}
