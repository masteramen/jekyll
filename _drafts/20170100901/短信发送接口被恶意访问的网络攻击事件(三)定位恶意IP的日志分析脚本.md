---
layout: post
title:  "短信发送接口被恶意访问的网络攻击事件(三)定位恶意IP的日志分析脚本"
title2:  "短信发送接口被恶意访问的网络攻击事件(三)定位恶意IP的日志分析脚本"
date:   2017-01-01 23:50:01  +0800
source:  "http://www.jfox.info/%e7%9f%ad%e4%bf%a1%e5%8f%91%e9%80%81%e6%8e%a5%e5%8f%a3%e8%a2%ab%e6%81%b6%e6%84%8f%e8%ae%bf%e9%97%ae%e7%9a%84%e7%bd%91%e7%bb%9c%e6%94%bb%e5%87%bb%e4%ba%8b%e4%bb%b6-%e4%b8%89-%e5%ae%9a%e4%bd%8d%e6%81%b6.html"
fileName:  "20170100901"
lang:  "zh_CN"
published: true
permalink: "%e7%9f%ad%e4%bf%a1%e5%8f%91%e9%80%81%e6%8e%a5%e5%8f%a3%e8%a2%ab%e6%81%b6%e6%84%8f%e8%ae%bf%e9%97%ae%e7%9a%84%e7%bd%91%e7%bb%9c%e6%94%bb%e5%87%bb%e4%ba%8b%e4%bb%b6-%e4%b8%89-%e5%ae%9a%e4%bd%8d%e6%81%b6.html"
---
{% raw %}
# 短信发送接口被恶意访问的网络攻击事件(三)定位恶意IP的日志分析脚本 


H2M_LI_HEADER 
第一步，首先是获取请求了被攻击URL的所有请求中的IP，因为被攻击的URL只有一个，这里的做法是通过grep命令查找请求了此URL的日志行，查找的值为api地址的名称字段，比如此URL的地址为’/message/send/’，而send字段只存在于此URL中，因此在日志文件中查找包含’send’字段的行即可。

H2M_LI_HEADER 
第二步是从所有的行中提取出IP列，统计出所有出现的IP和此IP请求接口URL的次数，存入ip.txt文件。

H2M_LI_HEADER 
接着第三步是通过对ip.txt文件的分析，定位出所有的不正常的IP，分析的比较简陋，做法是请求超过5次的都视为非法IP，其实5次已经算多的了，应该再小一点，但是其实在分析文件ip.txt文件过程中，发现正常的IP访问次数基本为一次、两次，而非法IP则为百次或千次，因此阈值设置为5或者3并没有大的影响，重点是找出访问量较大的一些IP。

H2M_LI_HEADER 
最后一步，得到这些IP值之后，将其加入到iptables的过滤策略中并重启iptables即可。

# 脚本代码

一开始的脚本，能够根据需求统计和记录出访问过多的IP地址了：

    #! /bin/bash
    #author：13
    #date:2017-06
    #desc:找出攻击者IP
    cat /opt/sms-service/logs/access_log.log | awk '{print $1}'|sort|uniq -c|awk '{print $2"="$1;}' > /opt/sms-service/logs/ip.txt
    DEFINE="5"
    for i in `cat  /opt/sms-service/logs/ip.txt`
    do
    IP=`echo $i |awk -F= '{print $1}'`
    NUM=`echo $i|awk -F= '{print $2}'`
    if [ $NUM -gt $DEFINE ];then
    grep $IP /opt/sms-service/logs/black.txt > /dev/null
          if [ $? -gt 0 ];then
            echo "iptables -I INPUT -s $IP -j DROP" >> /opt/sms-service/logs/black.txt
          fi
        fi
    done
    

后面又对脚本做了一些小改动，改进点有：

- 对文件路径进行参数命名，使得代码不是特别臃肿；
- 增加一条判断条件，判断IP是否已经存在于iptables配置文件中，剔除已经统计和记录过的IP。

    #! /bin/bash
    #author：13
    #date:2017-06
    #desc:找出攻击者IP
    LOGFILE="/opt/sms-service/logs/access_log.log"
    IPTXT="/opt/sms-service/logs/ip.txt"
    BLACKTXT="/opt/sms-service/logs/black.txt"
    IPTABLES="/opt/iptables/run.sh"
    DEFINE="5"
    cat $LOGFILE|awk '{print $1}'|sort|uniq -c|awk '{print $2"="$1;}' > $IPTXT
    for i in `cat  $IPTXT`
    do
    IP=`echo $i |awk -F= '{print $1}'`
    NUM=`echo $i|awk -F= '{print $2}'`
    if [ $NUM -gt $DEFINE ];then
    grep $IP $BLACKTXT > /dev/null
          if [ $? -gt 0 ];then
            grep $IP $IPTABLES > /dev/null
            if [ $? -gt 0 ];then
            echo "iptables -I INPUT -s $IP -j DROP" >> $BLACKTXT
            fi
          fi
        fi
    done
{% endraw %}
