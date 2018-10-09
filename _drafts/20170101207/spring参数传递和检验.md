---
layout: post
title:  "spring参数传递和检验"
title2:  "spring参数传递和检验"
date:   2017-01-01 23:55:07  +0800
source:  "https://www.jfox.info/spring%e5%8f%82%e6%95%b0%e4%bc%a0%e9%80%92%e5%92%8c%e6%a3%80%e9%aa%8c.html"
fileName:  "20170101207"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/spring%e5%8f%82%e6%95%b0%e4%bc%a0%e9%80%92%e5%92%8c%e6%a3%80%e9%aa%8c.html"
---
{% raw %}
在spring请求时，要对参数进行检查，以前一直使用如下方式来获取参数，在参数特别多的时候，代码很不简洁。

    String userId= request.getParameter("userId");

后来使用注解@RequestParam代码整洁了好多

    @RequestParam(value = "userId",required=true) String userId

后来对于参数比较多的情况，使用一个bean来接收请求参数

    @RequestMapping(value="/saveUser")
    public String saveUser(User user) {}

对于比较复杂，有层级关系情况，使用注解@RequestBody实现

    public String setUser(@RequestBody String userInfo) {
        //使用fastjson转换为实体类
    }

不管使用以上的哪种方式都要对参数进行校验，如果一个个参数的检查是否为空，检查边界范围，会导致代码很多。使用@Valid注解来对参数进行校验能让代码更整洁。

本文以实体类接收请求参数为例简单讲解，validation一共有hibernate-validator，javax.validation和spring-validator三种注解，本文主要是简单讲解一下javax.validation的使用

    @RequestMapping(value="/saveUser")
    @ResponseBody
    public JSONObject saveUser(@Valid User user, BindingResult result){
            JSONObject jsonObject = new JSONObject();
            //判断是否检验错误信息
            if(result.hasErrors()){
                //取出第一条错误信息返回
                List<FieldError> list = result.getFieldErrors();
                String errorMessage = CollectionUtils.isEmpty(list)?
                        "参数错误！":list.get(0).getDefaultMessage();
                jsonObject.put("errorMessage",errorMessage );
                return jsonObject;
            }
            //saveUser保存用户信息模块省略
            jsonObject.put("errorMessage","success");
            return jsonObject;
        }

    //使用lombok
    @Data
    public class User implements Serializable{
        @NotNull(message = "用户id不能为空")
        @Pattern(regexp="^d{12}$",message = "用户id非法")
        private String userId;
        private String userName;
        private int age;
    }

1. 
使用@Valid注解进行参数检查

2. 
在没有使用BindingResult时，程序会抛出空指针等异常信息，不能返回自定义信息，网上查了一下需要使用BindingResult来处理Error信息，自定义返回错误数据。

3. 
@NotNull，@Pattern，@Size，@Max，@Min，@Digits是我在项目中经常使用的注解

大家可以关注我的公众号：不知风在何处，相互沟通，共同进步。
{% endraw %}
