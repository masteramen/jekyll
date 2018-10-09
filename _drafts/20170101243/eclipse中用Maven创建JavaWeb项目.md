---
layout: post
title:  "eclipse中用Maven创建JavaWeb项目"
title2:  "eclipse中用Maven创建JavaWeb项目"
date:   2017-01-01 23:55:43  +0800
source:  "https://www.jfox.info/eclipse%e4%b8%ad%e7%94%a8maven%e5%88%9b%e5%bb%bajavaweb%e9%a1%b9%e7%9b%ae.html"
fileName:  "20170101243"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/eclipse%e4%b8%ad%e7%94%a8maven%e5%88%9b%e5%bb%bajavaweb%e9%a1%b9%e7%9b%ae.html"
---
{% raw %}
最近学到在eclipse中用Maven创建java web项目，总结一下创建步骤。 

### 下载Maven压缩包和配置相关信息。 

[下载地址：http://maven.apache.org/download.cgi](https://www.jfox.info/go.php?url=http://maven.apache.org/download.cgi)

选择如下图所示的解压包即可

下载完成后将压缩包解压。

找到conf文件夹下的setting.xml文件，在文件中配置相关的信息。

localRepository为本地仓库的地址，默认的是C:Users.m2repository可以根据自己的实际情况添加以下语句，进行修改。

    <localRepository>路径地址</localRepository>
    

如果是在自己电脑上测试用，下载架包的速度可能会特别慢，可以设置mirror来修改远程仓库，在mirrors中添加如下代码 

    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
    

如下图所示

### 配置eclipse 

确保eclipse中有Maven插件，如果没有，可以在Help–>Eclipse Marketplace中下载相关的插件。

确保有相关的插件后，在Windows–>Prefereces中选择Maven下的User Settings,选择settings.xml的文件地址。如下图所示。

### 创建java web项目 

新建项目选择Maven项目 如下图所示

选择web项目 如图所示

填写GroupID和ArtifactID

GroupID是项目组织唯一的标识符，实际对应JAVA的包的结构，是main目录里java的目录结构。

ArtifactID就是项目的唯一的标识符，实际对应项目的名称，就是项目根目录的名称。

最后点击Finish即可。
{% endraw %}
