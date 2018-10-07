---
layout: post
title:  "javaweb服务端跨域支持"
title2:  "javaweb服务端跨域支持"
date:   2017-01-01 23:52:09  +0800
source:  "http://www.jfox.info/javaweb%e6%9c%8d%e5%8a%a1%e7%ab%af%e8%b7%a8%e5%9f%9f%e6%94%af%e6%8c%81.html"
fileName:  "20170101029"
lang:  "zh_CN"
published: true
permalink: "javaweb%e6%9c%8d%e5%8a%a1%e7%ab%af%e8%b7%a8%e5%9f%9f%e6%94%af%e6%8c%81.html"
---
{% raw %}
项目开发为了支持web浏览器ajax的直接请求，涉及到了跨域的需求，通过学习对跨域有了更深入的认识，现在总结一下：

## 1.跨域说明

    跨域指请求和服务的域不一致，浏览器和H5的ajax请求有影响，而对服务端之间的http请求没有限制。
    跨域是浏览器拦截了服务器端返回的相应，不是拦截了请求。

## 2.服务端跨域支持

    服务端的跨域支持主要包括两种方式：
    1.设置response的Header属性

     response.setHeader("Access-Control-Allow-Origin", "*");//允许跨域访问的域，可以是通配符”*”；
     response.setHeader("Access-Control-Allow-Methods", "POST, GET");
     response.setHeader("Access-Control-Max-Age", "1800");
     response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
     response.setHeader("Access-Control-Allow-Credentials", "true");

注：Access-Control-Allow-Origin刚开始认为可以维护一个域的列表，用逗号分隔，后期测试中发现不行，后来在一篇文章中看到此处只允许配置一个域，如果要实现多个域，可以维护一个域列表，与请求中的域进行匹配，匹配成功，则设置跨域为当前域。

    2.通过jsonp来实现跨域
      使用jsonp来实现跨域可以解决ie下不能跨域的问题，仅仅支持get请求
      服务端多加一个参数callback，在返回数据时用callback把具体的数据包裹起来，传回前端。
      例：请求中callback的参数值为jsonpcallback,返回数据为{"code":0,"message":"ok"}
         返回到前端的数据应该是jsonpcallback({"code":0,"message":"ok"})
    

## 3.设置response的Header属性实现

    
    1.springboot实现(较新的版本支持)
    1.1 方法级别
    注解@CrossOrigin支持方法级别的跨域，支持多个不同的域，没有测试过
    

    @CrossOrigin(origins="http://xxx.com.cn",allowCredentials="false",maxAge=3600)

    1.2 应用级别

    @Configuration
    public class WebAppConfig extends WebMvcConfigurerAdapter {
        /**
         * 跨域支持
         */
        @Override
        public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**").allowedOrigins("*").allowedMethods("*").allowCredentials(false).maxAge(3600);
        }
    }

    2.直接使用response来做处理

     response.setHeader("Access-Control-Allow-Origin", "*");//允许跨域访问的域，可以是通配符”*”；
     response.setHeader("Access-Control-Allow-Methods", "POST, GET");
     response.setHeader("Access-Control-Max-Age", "1800");
     response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
     response.setHeader("Access-Control-Allow-Credentials", "true");

## 4.jsonp方式实现

    1.客户端发送ajax请求时，设置datatype为jsonp
    2.服务端处理
    (1)写一个方法实现接口MethodInterceptor，重写invoke方法

    String callback = request.getParameter("callback");
    if(StringUtils.isNotBlank(callback)){
       Object ret = invocation.proceed();
       return callback+"("+ret+")";
    }else{
       Object ret = invocation.proceed();
       return ret;
    }

(2)使用fastjson的JSONPObject 来实现

       JSONPObject ret = new JSONPObject(callback);
       ret.addParameter(data);
       //callback就是参数callback的值
       //addParameter就是要返回的数据
       //调用toJSONString即可看到结果

备注：第一次写技术博客，如果有错误，请指正，共同进步。
{% endraw %}
