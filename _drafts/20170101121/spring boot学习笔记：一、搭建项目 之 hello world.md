---
layout: post
title:  "spring boot学习笔记：一、搭建项目 之 hello world"
title2:  "spring boot学习笔记：一、搭建项目 之 hello world"
date:   2017-01-01 23:53:41  +0800
source:  "https://www.jfox.info/springboot%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0%e4%b8%80%e6%90%ad%e5%bb%ba%e9%a1%b9%e7%9b%ae%e4%b9%8bhelloworld.html"
fileName:  "20170101121"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/springboot%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0%e4%b8%80%e6%90%ad%e5%bb%ba%e9%a1%b9%e7%9b%ae%e4%b9%8bhelloworld.html"
---
{% raw %}
### spring boot学习笔记之一：搭建项目 之 hello world

最近在学习spring boot开发java后台项目，在网上搜集了一系列资料搭建过程中还是会遇到问题，今天把搭建过程一步步记录下来，分享出来给初学者，在入门时可以解决一些时间。
使用Intellij IDEA 开发，它自带有 Spring Initializr 工具，可以快速创建出spring boot工程项目。

- 
步骤1:File——New————project————，选择spring Initializr————next

- 
步骤2:接下来输入工程名字，自己设置就可以，选择Maven Project————next

- 
步骤3:选择web依赖，如果没有选择web依赖，后面启动项目时，会找不到容器——next

- 
步骤4:设置工程名，点击完成

此时在目录中有一个XXXApplication文件，执行main入口即可启动项目，看到端口号8080启动成功

项目搭建完成！

#### 写一个简单的接口：

在浏览器中请求：[http://localhost:8080/demo/test](https://www.jfox.info/go.php?url=http://localhost:8080/demo/test)

    @RestController
    @RequestMapping(value = "/demo")// 通过这里配置使下面的映射都在/demo下
    public class test {
    
        @GetMapping("/test")
        public String sayHello(){
            return "Hello World! ";
        }
    }
{% endraw %}
