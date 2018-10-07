---
layout: post
title:  "【 keepalive + Nginx实现高可用性及负载均衡原理介绍】"
title2:  "【 keepalive + Nginx实现高可用性及负载均衡原理介绍】"
date:   2017-01-01 23:55:57  +0800
source:  "http://www.jfox.info/keepalivenginx%e5%ae%9e%e7%8e%b0%e9%ab%98%e5%8f%af%e7%94%a8%e6%80%a7%e5%8f%8a%e8%b4%9f%e8%bd%bd%e5%9d%87%e8%a1%a1%e5%8e%9f%e7%90%86%e4%bb%8b%e7%bb%8d.html"
fileName:  "20170101257"
lang:  "zh_CN"
published: true
permalink: "keepalivenginx%e5%ae%9e%e7%8e%b0%e9%ab%98%e5%8f%af%e7%94%a8%e6%80%a7%e5%8f%8a%e8%b4%9f%e8%bd%bd%e5%9d%87%e8%a1%a1%e5%8e%9f%e7%90%86%e4%bb%8b%e7%bb%8d.html"
---
{% raw %}
keepalive，是在TCP中一个可以检测死连接的机制。

**keepalive原理：**

TCP会在空闲了一定时间后发送数据给对方：

1.如果主机可达，对方就会响应ACK应答，就认为是存活的。

2.如果可达，但应用程序退出，对方就发RST应答，发送TCP撤消连接。

3.如果可达，但应用程序崩溃，对方就发FIN消息。

4.如果对方主机不响应ack, rst，继续发送直到超时，就撤消连接。这个时间就是默认

的二个小时。

Keepalived是一个基于VRRP协议来实现的WEB 服务高可用方案，可以利用其来避免单点故障。一个WEB服务至少会有2台服务器运行Keepalived，一台为主服务器（MASTER），一台为备份服务器（BACKUP），但是对外表现为一个虚拟IP，主服务器会发送特定的消息给备份服务器，当备份服务器收不到这个消息的时候，即主服务器宕机的时候，备份服务器就会接管虚拟IP，继续提供服务，从而保证了高可用性。

![](/wp-content/uploads/2017/07/1500041182.png)

**keepalived理论工作原理**

keepalived可提供vrrp以及health-check功能，可以只用它提供双机浮动的vip（vrrp虚拟路由功能），这样可以简单实现一个双机热备高可用功能。

keepalived是一个类似于layer3, 4 & 5交换机制的软件，也就是我们平时说的第3层、第4层和第5层交换。Keepalived的作用是检测web 服务器的状态。 Layer3,4&5工作在IP/TCP协议栈的IP层，TCP层，及应用层,原理分别如下：

**Layer3**：Keepalived使用Layer3的方式工作式时，Keepalived会定期向服务器群中的服务器

发送一个ICMP的数据包（既我们平时用的Ping程序）,如果发现某台服务的IP地址没有激活，Keepalived便报告这台服务器失效，并将它从服务器群中剔除，这种情况的典型例子是某台服务器被非法关机。Layer3的方式是以服务器的IP地址是否有效作为服务器工作正常与否的标准。在本文中将采用这种方式。

**Layer4:**如果您理解了Layer3的方式，Layer4就容易了。Layer4主要以TCP端口的状态来决定服务器工作正常与否。如web server的服务端口一般是80，如果Keepalived检测到80端口没有启动，则Keepalived将把这台服务器从服务器群中剔除。

**Layer5**：Layer5就是工作在具体的应用层了，比Layer3,Layer4要复杂一点，在网络上占用的带宽也要大一些。Keepalived将根据用户的设定检查服务器程序的运行是否正常，如果与用户的设定不相符，则Keepalived将把服务器从服务器群中剔除。

vip即虚拟ip，是附在主机网卡上的，即对主机网卡进行虚拟，此IP仍然是占用了此网段的某个IP。

最简单配置示例：

–全局配置

global_defs {

   notification_email {

     admin@centos.bz

   }

   notification_email_from keepalived@domain.com

   smtp_server 127.0.0.1

   smtp_connect_timeout 30

   router_id LVS_DEVEL

}

vrrp_script chk_http_port {

                script “/opt/nginx_pid.sh”

                interval 2

                weight 2

}

–虚拟示例配置

vrrp_instance VI_1 {

    state MASTER              ############ 辅机为 BACKUP

    interface eth0

    virtual_router_id 51      #虚拟路由ID，主备相同

    mcast_src_ip 192.168.1.103

    priority 102                  # 权值要比 back 高

    advert_int 1

    authentication {          #口令，主备相同

        auth_type PASS

        auth_pass 1111

    }

   track_script {

        chk_http_port ### 执行监控的服务

    }

   virtual_ipaddress { #VIP 切换漂移的VIP

       192.168.1.110

   }

}

vi /opt/nginx_pid.sh

#!/bin/bash

A=`ps -C nginx –no-header |wc -l`              

if [ $A -eq 0 ];then                                      

                /usr/local/nginx/sbin/nginx

                sleep 3

                if [ `ps -C nginx –no-header |wc -l` -eq 0 ];then

                       killall keepalived

                fi

fi
{% endraw %}
