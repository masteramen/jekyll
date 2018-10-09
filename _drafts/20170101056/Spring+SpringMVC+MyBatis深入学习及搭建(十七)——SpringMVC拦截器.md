---
layout: post
title:  "Spring+SpringMVC+MyBatis深入学习及搭建(十七)——SpringMVC拦截器"
title2:  "Spring+SpringMVC+MyBatis深入学习及搭建(十七)——SpringMVC拦截器"
date:   2017-01-01 23:52:36  +0800
source:  "https://www.jfox.info/springspringmvcmybatis%e6%b7%b1%e5%85%a5%e5%ad%a6%e4%b9%a0%e5%8f%8a%e6%90%ad%e5%bb%ba%e5%8d%81%e4%b8%83springmvc%e6%8b%a6%e6%88%aa%e5%99%a8.html"
fileName:  "20170101056"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springspringmvcmybatis%e6%b7%b1%e5%85%a5%e5%ad%a6%e4%b9%a0%e5%8f%8a%e6%90%ad%e5%bb%ba%e5%8d%81%e4%b8%83springmvc%e6%8b%a6%e6%88%aa%e5%99%a8.html"
---
{% raw %}
# Spring+SpringMVC+MyBatis深入学习及搭建(十七)——SpringMVC拦截器 


Spring Web MVC的处理器拦截器类似于Servlet开发中的过滤器Filter，用于对处理器进行预处理和后处理。

定义拦截器，实现HandlerInterceptor接口。接口中提供三个方法。

    package joanna.yan.ssm.interceptor;
    
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import org.springframework.web.servlet.HandlerInterceptor;
    import org.springframework.web.servlet.ModelAndView;
    
    publicclass HandlerInterceptor1 implements HandlerInterceptor{
    
        //执行Handler完成执行此方法
        //应用场景：统一异常处理，统一日志处理    @Override
        publicvoid afterCompletion(HttpServletRequest request,
                HttpServletResponse response, Object handler, Exception ex)
                throws Exception {
            System.out.println("HandlerInterceptor1......afterCompletion");
        }
    
        //进入Handler方法之后，返回modelAndView之前执行
        //应用场景从modelAndView出发：将公用的模型数据（比如菜单导航）在这里传到视图，也可以在这里同意指定视图    @Override
        publicvoid postHandle(HttpServletRequest request, HttpServletResponse response,
                Object handler, ModelAndView modelAndView) throws Exception {
            System.out.println("HandlerInterceptor1......postHandle");
        }
    
        //进入Handler方法之前执行
        //用于身份认证、身份授权
        //比如身份认证，如果认证不通过表示当前用户没有登录，需要此方法拦截不再向下执行。    @Override
        publicboolean preHandle(HttpServletRequest request, HttpServletResponse response,
                Object handler) throws Exception {
            System.out.println("HandlerInterceptor1......preHandle");
            //return false表示拦截，不向下执行
            //return true表示放行returntrue;
        }
    
    }

# 2.拦截器配置

struts中是有一个大的拦截器链，它是一个共享的东西，可以把它添加到任何的action链接，都让它拦截。但是spring的拦截器不是全局的。

## 2.1针对某种mapping配置拦截器

springmvc拦截器针对HandlerMapping进行拦截设置，如果在某个HandlerMapping中设置拦截，经过该HandlerMapping映射成功的handler最终使用该拦截器。

    <bean
        class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping"><property name="interceptors"><list><ref bean="handlerInterceptor1"/><ref bean="handlerInterceptor2"/></list></property></bean><bean id="handlerInterceptor1" class="joanna.yan.ssm.interceptor.HandlerInterceptor1"/><bean id="handlerInterceptor2" class="joanna.yan.ssm.interceptor.HandlerInterceptor2"/>

一般不推荐使用。

## 2.2针对所有mapping配置全局拦截器

springmvc可以配置类似全局的拦截器，springmvc框架将配置的类似全局的拦截器注入到每个HandlerMapping中。

    <!--拦截器 --><mvc:interceptors><!--多个拦截器,顺序执行 --><mvc:interceptor><!-- /**表示所有url包括子url路径 --><mvc:mapping path="/**"/><bean class="joanna.yan.ssm.interceptor.HandlerInterceptor1"></bean></mvc:interceptor><mvc:interceptor><mvc:mapping path="/**"/><bean class="joanna.yan.ssm.interceptor.HandlerInterceptor2"></bean></mvc:interceptor></mvc:interceptors>

# 3.拦截测试

## 3.1测试需求

测试多个拦截器各个方法的执行时机。

## 3.2编写两个拦截器

![](/wp-content/uploads/2017/07/1499177925.png) 

## 3.3两个拦截器都放行

运行日志信息：

    HandlerInterceptor1...preHandle
    HandlerInterceptor2...preHandle
    
    HandlerInterceptor2...postHandle
    HandlerInterceptor1...postHandle
    
    HandlerInterceptor2...afterCompletion
    HandlerInterceptor1...afterCompletion

总结：

preHandle方法按顺序执行，postHandle和afterCompletion按拦截器配置的逆向顺序执行。

## 3.4拦截器1放行，拦截器2不放行

运行日志信息：

    HandlerInterceptor1...preHandle
    HandlerInterceptor2...preHandle
    HandlerInterceptor1...afterCompletion

总结：

拦截器1放行，拦截器2的preHandle才会执行。

拦截器2的preHandle不放行，拦截器2的postHandle和afterCompletion不会执行。

只要有一个拦截器不放行，postHandle就不会执行。

## 3.5拦截器1不放行，拦截器2不放行

运行日志信息：

    HandlerInterceptor1...preHandle

拦截器1的preHandle不放行，postHandle和afterCompletion不会执行。

拦截器1的preHandle不放行，拦截器2不执行。

# 4.小结

根据测试结果，对拦截器应用。

比如：统一日志处理拦截器，需要改拦截器preHandle一定要放行，且将它放在拦截器链中的第一位置。

比如：登录认证拦截器，放在拦截器链中第一个位置。权限校验拦截器，放在登录拦截器之后。（因为登录通过后才校验权限）

# 5.拦截器应用（实现登录认证）

## 5.1需求

（1）用户请求url

（2）拦截器进行拦截校验

　　如果请求的url是公开地址（无需登录即可访问的url），让放行

　　如果用户session不存在，跳转到登录页面。

　　如果用户session存在，放行，继续操作。

## 5.2登录、退出controller方法

    package joanna.yan.ssm.controller;
    
    import javax.servlet.http.HttpSession;
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.RequestMapping;
    
    @Controller
    publicclass LoginController {
        
        //登录
        @RequestMapping("/login")
        public String login(HttpSession session, String username, String password) throws Exception{
            //调用service进行用户身份认证
            //...
            
            //在session中保存用户身份信息
            session.setAttribute("username", username);
            return "redirect:items/queryItems.action";
        }
        
        //退出
        @RequestMapping("/logout")
        public String logout(HttpSession session) throws Exception{
            //清除session        session.invalidate();
            return "redirect:items/queryItems.action";
        }
        
    }

## 5.3登录认证拦截实现

### 5.3.1LoginInterceptor

    publicclass LoginInterceptor implements HandlerInterceptor{
    
        //执行Handler完成执行此方法
        //应用场景：统一异常处理，统一日志处理    @Override
        publicvoid afterCompletion(HttpServletRequest request,
                HttpServletResponse response, Object handler, Exception ex)
                throws Exception {
            System.out.println("HandlerInterceptor1......afterCompletion");
        }
    
        //进入Handler方法之后，返回modelAndView之前执行
        //应用场景从modelAndView出发：将公用的模型数据（比如菜单导航）在这里传到视图，也可以在这里同意指定视图    @Override
        publicvoid postHandle(HttpServletRequest request, HttpServletResponse response,
                Object handler, ModelAndView modelAndView) throws Exception {
            System.out.println("HandlerInterceptor1......postHandle");
        }
    
        //进入Handler方法之前执行
        //用于身份认证、身份授权
        //比如身份认证，如果认证不通过表示当前用户没有登录，需要此方法拦截不再向下执行。    @Override
        publicboolean preHandle(HttpServletRequest request, HttpServletResponse response,
                Object handler) throws Exception {
            System.out.println("HandlerInterceptor1......preHandle");
            //获取请求的url
            String url=request.getRequestURI();
            //判断url是否是公开地址（实际使用时要将公开地址配置到文件中）
            //这里公开地址是登录提交的地址if(url.indexOf("login.action")>=0){
                //如果进行登录提交，放行returntrue;
            }
            //判断session
            HttpSession session=request.getSession();
            String username=(String) session.getAttribute("username");
            if(username!=null){
                //身份存在，放行returntrue;
            }
            
            //执行到这里，表示用户身份需要认证，跳转登录页面
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            
            //return false表示拦截，不向下执行
            //return true表示放行returnfalse;
        }
    
    }

### 5.3.2拦截器配置

classpath下springmvc.xml中配置：

![](/wp-content/uploads/2017/07/1499177926.png)

如果此文对您有帮助，微信打赏我一下吧~
{% endraw %}
