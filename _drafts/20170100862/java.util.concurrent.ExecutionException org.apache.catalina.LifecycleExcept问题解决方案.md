---
layout: post
title:  "java.util.concurrent.ExecutionException: org.apache.catalina.LifecycleExcept问题解决方案"
title2:  "java.util.concurrent.ExecutionException org.apache.catalina.LifecycleExcept问题解决方案"
date:   2017-01-01 23:49:22  +0800
source:  "https://www.jfox.info/java_util_concurrent_executionexception_org_apache_catalina_lifecycleexcept_wen_ti_jie_jue_fang_an.html"
fileName:  "20170100862"
lang:  "zh_CN"
published: true
permalink: "2017/java_util_concurrent_executionexception_org_apache_catalina_lifecycleexcept_wen_ti_jie_jue_fang_an.html"
---
{% raw %}
在部署Dynamic Web Project时，如果正确配置web.xml或者标注时，仍然出现以上异常的话，可以尝试以下内容讲解的方法：

　　首先，双击eclipse中的servers，位置如下图“1”所指。

检查位置”2″的General Infomation是否正确，以及位置“3”处的Servlet Path路径信息是否配置正确（一般情况下，正确设置Eclipse的Tomcat配置，这两项没有问题，正确的配置方法参见[http://jingyan.baidu.com/article/870c6fc33e62bcb03fe4be90.html](https://www.jfox.info/go.php?url=http://jingyan.baidu.com/article/870c6fc33e62bcb03fe4be90.html)）

接下来看位置“4”处的路径是否是Tomcat路径下的webapps的匹配路径，如果不是，按照如下步骤操作：

- 　　首先，找到Tomcat安装路径，在此路径下找到webapps的文件夹，可以全部选中，全部delete；
- 接下，进入Eclipse，看到位置“4”显示为可编辑状态，接下来，点击“Browse”，选择正确的Tomcat下的webapps的路径，确定即可；
- 然后，点击位置“5”，进行web Model添加，如下所示：![](/wp-content/uploads/2017/06/945719-20170618140328681-1749256031.png)
- 最后，在当前位置，点击“Add Web Module”，进行添加目录中的目标工程；
- 点击“start”，运行Tomcat。
{% endraw %}
