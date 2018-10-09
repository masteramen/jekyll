---
layout: post
title:  "【漏洞分析】Struts2高危漏洞S分析"
title2:  "【漏洞分析】Struts2高危漏洞S分析"
date:   2017-01-01 23:54:29  +0800
source:  "https://www.jfox.info/%e6%bc%8f%e6%b4%9e%e5%88%86%e6%9e%90struts2%e9%ab%98%e5%8d%b1%e6%bc%8f%e6%b4%9es%e5%88%86%e6%9e%90.html"
fileName:  "20170101169"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%bc%8f%e6%b4%9e%e5%88%86%e6%9e%90struts2%e9%ab%98%e5%8d%b1%e6%bc%8f%e6%b4%9es%e5%88%86%e6%9e%90.html"
---
{% raw %}
本次漏洞触发点在：

org.apache.struts2.s1.Struts1Action.execute() 方法中，如下图所示。

![](/wp-content/uploads/2017/07/1499444725.png)

org.apache.struts2.s1.Struts1Action 类为一个 Wrapper 类，用于将 Struts1 时代的 Action 包装成为 Struts2 中的 Action，以让它们在 struts2 框架中继续工作。

在 Struts1Action 的 execute 方法中，会调用对应的 Struts1 Action 的 execute 方法（第一个红色箭头处）。在调用完后，会检查 request 中是否设置了 ActionMessage，如果是，则将会对 action messages 进行处理并回显给客户端。处理时使用了 getText 方法，这里就是漏洞的触发点。所以漏洞的触发条件是：在 struts1 action 中，将来自客户端的参数值设置到了 action message 中。

在官方提供的 Showcase 中，就存在漏洞，如下图：

![](/wp-content/uploads/2017/07/1499444726.png)

getText 方法的主要作用就是实现网站语言的国际化，它会根据不同的 Locale 去对应的资源文件里面获取相关文字信息（这些文件信息一般保存在 .properties 文件中），这些文字信息往往会回显至客户端。

 Action messages 会通过 getText 方法最终进入 com.opensymphony.xwork2.util.LocalizedTextUtil.getDefaultMessage (String, Locale, ValueStack, Object[], String) 方法，如下： 

![](/wp-content/uploads/2017/07/1499444727.png)

此方法会将 action message 传入 com.opensymphony.xwork2.util.TextParseUtil.translateVariables(String, ValueStack)。com.opensymphony.xwork2.util.TextParseUtil.translateVariables(String, ValueStack) 方法主要用于扩展字符串中由 ${} 或 %{} 包裹的 OGNL 表达式，这里也就是 OGNL 的入口，随后 action message 将进入 OGNL 的处理流程，漏洞被触发。

关于 POC

    暂不公布

#### 总结

 该漏洞触发需要 非默认插件 struts2-struts1-plugin

需要手动寻找程序中将客户端参数值添加入 action message 的点

![](/wp-content/uploads/2017/07/14994447271.png)![](/wp-content/uploads/2017/07/1499444728.png)
{% endraw %}
