---
layout: post
title:  "springboot 使用fastJson解析json数据的两种方式"
title2:  "springboot 使用fastJson解析json数据的两种方式"
date:   2017-01-01 23:49:40  +0800
source:  "https://www.jfox.info/springboot-%e4%bd%bf%e7%94%a8fastjson%e8%a7%a3%e6%9e%90json%e6%95%b0%e6%8d%ae%e7%9a%84%e4%b8%a4%e7%a7%8d%e6%96%b9%e5%bc%8f.html"
fileName:  "20170100880"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springboot-%e4%bd%bf%e7%94%a8fastjson%e8%a7%a3%e6%9e%90json%e6%95%b0%e6%8d%ae%e7%9a%84%e4%b8%a4%e7%a7%8d%e6%96%b9%e5%bc%8f.html"
---
{% raw %}
1.搭建环境(可以参考前面的springboot入门)

 maven

 sts

 java8

2.在pom.xml中引入fastjson对应的坐标(注意:version最好是1.2以上的)

com.alibaba

fastjson

1.2.28

3.编写解析返回json数据的方法

 方法一:启动类继承extends WebMvcConfigurerAdapter

 

  @SpringBootApplication 
 

public class App extends WebMvcConfigurerAdapter{ 
 

 /** 
 

 * 重写转换方法 
 

 * @author yimeidaoren77 
 

 */ 
 

 public void configureMessageConverters(List> converters) { 
 

 super.configureMessageConverters(converters); 
 

 //1.创建一个convert消息转换对象 
 

 FastJsonHttpMessageConverter fastConvert = new FastJsonHttpMessageConverter(); 
 

 //2.创建一个fastJson的配置对象,然后配置格式化信息 
 

 FastJsonConfig config = new FastJsonConfig(); 
 

 config.setSerializerFeatures(SerializerFeature.PrettyFormat); 
 

 //3.在convert中添加配置信息 
 

 fastConvert.setFastJsonConfig(config); 
 

 //4.将convert添加到converts里面 
 

 converters.add(fastConvert); 
 

 } 
 

 方法二:覆盖方法configureMessageConverters

 

  public HttpMessageConverters fastJsonHttpMessageConverters(){ 
 

 //1.创建一个convert消息转换对象 
 

 FastJsonHttpMessageConverter fastConverter = new FastJsonHttpMessageConverter(); 
 

 //2.创建一个fastJson的配置对象,然后配置格式化信息 
 

 FastJsonConfig fastJsonConfig = new FastJsonConfig(); 
 

 fastJsonConfig.setSerializerFeatures(SerializerFeature.PrettyFormat); 
 

 //3.在convert中添加配置信息 
 

 fastConverter.setFastJsonConfig(fastJsonConfig); 
 

 HttpMessageConverter converters = fastConverter; 
 

 return new HttpMessageConverters(converters); 
 
 } 
 

4.编写pojo类

    public class City {
    	private Long id;
    	private Long provinceId;
    	private String cityName;
    	private String description;
    	@JSONField(format="yyyy-MM-dd HH:mm:ss")
    	private Date createTime;
    ...
    }
{% endraw %}
