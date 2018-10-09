---
layout: post
title:  "log4j动态添加appender"
title2:  "log4j动态添加appender"
date:   2017-01-01 23:51:51  +0800
source:  "https://www.jfox.info/log4j%e5%8a%a8%e6%80%81%e6%b7%bb%e5%8a%a0appender.html"
fileName:  "20170101011"
lang:  "zh_CN"
published: true
permalink: "2017/log4j%e5%8a%a8%e6%80%81%e6%b7%bb%e5%8a%a0appender.html"
---
{% raw %}
除了通过properties，xml等格式的配置文件对log4j进行配置外，log4j还提供了各种接口，可以用代码动态修改log4j的配置，例如给一个logger增加一个appender。方法很简单，就是新建一个appder，然后添加到logger上，示例代码如下：

            KafkaLog4jAppender kafkaAppender = new KafkaLog4jAppender();
            kafkaAppender.setBrokerList(broker);
            kafkaAppender.setTopic(topic);
            kafkaAppender.setCompressionType("gzip");
            kafkaAppender.setSyncSend(false);
            kafkaAppender.setLayout(new PatternLayout(layout));
            kafkaAppender.activateOptions();
            logger.addAppender(kafkaAppender);
            logger.setLevel(Level.INFO);

这里以一个kafkaappender做例子，其他的，例如DailyRollingFileAppender等，都是类似的。
{% endraw %}
