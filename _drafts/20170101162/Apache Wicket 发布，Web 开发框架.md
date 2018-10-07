---
layout: post
title:  "Apache Wicket 发布，Web 开发框架"
title2:  "Apache Wicket 发布，Web 开发框架"
date:   2017-01-01 23:54:22  +0800
source:  "http://www.jfox.info/apachewicket%e5%8f%91%e5%b8%83web%e5%bc%80%e5%8f%91%e6%a1%86%e6%9e%b6.html"
fileName:  "20170101162"
lang:  "zh_CN"
published: true
permalink: "apachewicket%e5%8f%91%e5%b8%83web%e5%bc%80%e5%8f%91%e6%a1%86%e6%9e%b6.html"
---
{% raw %}
Apache Wicket 是一个开源的面向 Java 组件的 Web 应用框架，为政府、商店、大学、城市、银行、电子邮件提供商等提供数千个 Web 应用和网站。

6.27.0 是 Wicket 6 的一个小版本，Apache Wicket  采用的是语义版本，因此与 6.0.0 相比，本版本没有出现大的 API 变化。

 但值得注意的是，随着该版本的发布，Wicket 已将其内部 JSON 实现（org.apache.wicket.ajax.json 包）从 [JSON-java](http://www.jfox.info/go.php?url=https://github.com/stleary/JSON-java) 切换至  [Open JSON](http://www.jfox.info/go.php?url=http://https：//github.com/openjson/openjson) 。 这也是必然的，因为 JSON-java 的许可证不再与 Apache License 2.0 兼容。 

[具体更新细节可查阅发行说明](http://www.jfox.info/go.php?url=http://mail-archives.apache.org/mod_mbox/www-announce/201707.mbox/%3CCAPoOxge5WNvWW80Vr7ZMJ97CK9A82kKkRj3iJar-9bRFwx6trQ@mail.gmail.com%3E)

下载方法：

    <dependency>
        <groupId>org.apache.wicket</groupId>
        <artifactId>wicket-core</artifactId>
        <version>6.27.0</version>
    </dependency>
{% endraw %}
