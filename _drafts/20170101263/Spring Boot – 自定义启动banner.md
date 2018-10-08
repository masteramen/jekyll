---
layout: post
title:  "Spring Boot – 自定义启动banner"
title2:  "Spring Boot – 自定义启动banner"
date:   2017-01-01 23:56:03  +0800
source:  "http://www.jfox.info/springboot%e8%87%aa%e5%ae%9a%e4%b9%89%e5%90%af%e5%8a%a8banner.html"
fileName:  "20170101263"
lang:  "zh_CN"
published: true
permalink: "springboot%e8%87%aa%e5%ae%9a%e4%b9%89%e5%90%af%e5%8a%a8banner.html"
---
{% raw %}
这段时间较忙，有些想念“小红”，为了表达我对小红的思念之情，决定将spring boot启动的banner研究一下，看看是否能够自定义，让我天天能够看到她。

### 展示

经过调研，发现自定义banner是一个轻松愉快的过程，忍不住让我多启动几次，先看看效果：（省略了一些启动日志）

    [INFO] 
    [INFO] --- spring-boot-maven-plugin:1.5.1.RELEASE:run (default-cli) @ com.wanye.springboot ---
              $$                     $$
              __|                    $$ |
    $$   $$ $$  $$$$$$   $$$$$$  $$$$$$$   $$$$$$  $$$$$$$   $$$$$$
    $$ $$  |$$ | ____$$ $$  __$$ $$  __$$ $$  __$$ $$  __$$ $$  __$$
     $$$$  / $$ | $$$$$$$ |$$ /  $$ |$$ |  $$ |$$ /  $$ |$$ |  $$ |$$ /  $$ |
     $$  $$<  $$ |$$  __$$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |
    $$  /$$ $$ |$$$$$$$ |$$$$$$  |$$ |  $$ |$$$$$$  |$$ |  $$ |$$$$$$$ |
    __/  __|__| _______| ______/ __|  __| ______/ __|  __| ____$$ |
                                                                    $$   $$ |
                                                                    $$$$$$  |
                                                                     ______/
    2017-07-14 12:02:16,555 [background-preinit]  INFO org.hibernate.validator.internal.util.Version - HV000001: Hibernate Validator 5.3.4.Final
    2017-07-14 12:02:21,038 [main]  INFO com.wanye.Start - Starting Start on wanyedeMacBook-Pro.local with PID 1857 (/Users/wanye/Code/springboot/target/classes started by wanye in /Users/wanye/Code/springboot)
    

### 实现

实现的方式非常简单，我们只需要在Spring Boot工程的/src/main/resources目录下创建一个banner.txt文件，然后将ASCII字符画复制进去，就能替换默认的banner了。

### 工具

[生成ASCII字符画](http://www.jfox.info/go.php?url=http://patorjk.com/software/taag/#p=display&amp;f=Big%20Money-nw&amp;t=xiaohong)

### 参数属性

banner.txt中还可以增加一些参数配置，如下

    ${AnsiColor.BRIGHT_RED} #设置控制台中输出内容的颜色
    ${application.version}#用来获取MANIFEST.MF文件中的版本号
    ${application.formatted-version}#格式化后的${application.version}版本信息
    ${spring-boot.version}#Spring Boot的版本号
    ${spring-boot.formatted-version}#格式化后的${spring-boot.version}版本信息

### 最后

如果觉得文章还有点意思，请点赞、收藏。您的支持将鼓励我继续创作！
{% endraw %}
