---
layout: post
title:  "基于alpine用dockerfile创建的ssh镜像"
title2:  "基于alpine用dockerfile创建的ssh镜像"
date:   2018-10-14 09:35:07  +0800
source:  "http://www.cnblogs.com/zhujingzhi/p/9740423.html"
fileName:  "0b4576e"
lang:  "zh_CN"
published: false

---
{% raw %}
## 1、下载alpine镜像

    [root@docker43 ~]# docker pull alpine
     Using default tag: latest
     Trying to pull repository docker.io/library/alpine ... 
     latest: Pulling from docker.io/library/alpine
     4fe2ade4980c: Pull complete 
     Digest: sha256:621c2f39f8133acb8e64023a94dbdf0d5ca81896102b9e57c0dc184cadaf5528
     Status: Downloaded newer image for docker.io/alpine:latest
     [root@docker43 ~]# docker images
     REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
     docker.io/alpine    latest              196d12cf6ab1        3 weeks ago         4.41 MB

## 2、编写dockerfile

#### 2.1.创建一个工作目录

    [root@docker43 ~]# cd /opt/
     [root@docker43 opt]# mkdir alpine_ssh && cd alpine_ssh && touch Dockerfile
     
     [root@docker43 alpine_ssh]# ll
     总用量 4
     -rw-r--r-- 1 root root 654 10月  3 23:21 Dockerfile

#### 2.2.编写Dockerfile

    # 指定创建的基础镜像
     FROM alpine
     
     # 作者描述信息
     MAINTAINER alpine_sshd (zhujingzhi@123.com)
     
     # 替换阿里云的源
     RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories
     RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories
     
     # 同步时间
     
     # 更新源、安装openssh 并修改配置文件和生成key 并且同步时间
     RUN apk update && \
         apk add --no-cache openssh-server tzdata && \
         cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
         sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
         ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
         ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
         ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key && \
         echo "root:admin" | chpasswd
     
     # 开放22端口
     EXPOSE 22
     
     # 执行ssh启动命令
     CMD ["/usr/sbin/sshd", "-D"]

#### 2.3.创建镜像

    # 在dockerfile所在的目录下
     [root@docker43 alpine_ssh]# pwd
     /opt/alpine_ssh
     [root@docker43 alpine_ssh]# docker build -t alpine:sshd .

## 3、创建容器测试

　　创建容器

    [root@docker43 alpine_ssh]# docker run -itd -p 10022:22 --name alpine_ssh_v1 alpine:sshd
     [root@docker43 alpine_ssh]# docker ps 
     CONTAINER ID        IMAGE               COMMAND               CREATED             STATUS              PORTS                   NAMES
     b353f5f3b703        alpine:sshd         "/usr/sbin/sshd -D"   17 minutes ago      Up 17 minutes       0.0.0.0:10022->22/tcp   alpine_ssh_v1
     

　　测试

    [root@docker43 alpine_ssh]# ssh root@127.0.0.1 -p10022
     root@127.0.0.1's password: 
     Welcome to Alpine!
     
     The Alpine Wiki contains a large amount of how-to guides and general
     information about administrating Alpine systems.
     See <http://wiki.alpinelinux.org>.
     
     You can setup the system with the command: setup-alpine
     
     You may change this message by editing /etc/motd.
     
     b353f5f3b703:~# 

## 4、问题总结

　　这些都是我在手动测试的时候遇见的，已经在写Dockerfile的时候加进去了处理方法

    1. apk add --no-cache openssh-server   # 安装openssh的问题
     
     / # apk add --no-cache openssh-server
     fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/main/x86_64/APKINDEX.tar.gz
     fetch http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/APKINDEX.tar.gz
     (1/3) Installing openssh-keygen (7.7_p1-r2)
     ERROR: openssh-keygen-7.7_p1-r2: package mentioned in index not found (try 'apk update')
     (2/3) Installing openssh-server-common (7.7_p1-r2)
     (3/3) Installing openssh-server (7.7_p1-r2)
     ERROR: openssh-server-7.7_p1-r2: package mentioned in index not found (try 'apk update')
     2 errors; 4 MiB in 14 packages
     
     原因是：提示源没有这个openssh的包
     
     解决方式：
     在dockerfile中改为国内的源
     http://mirrors.aliyun.com/alpine/latest-stable/main/
     http://mirrors.aliyun.com/alpine/latest-stable/community/
     
     创建容器文件修改
     [root@docker43 ~]# docker run -it alpine
     / # vi /etc/apk/repositories 
     http://mirrors.aliyun.com/alpine/latest-stable/main/
     http://mirrors.aliyun.com/alpine/latest-stable/community/
                                                         
     #http://dl-cdn.alpinelinux.org/alpine/v3.8/main     
     #http://dl-cdn.alpinelinux.org/alpine/v3.8/community
     
     # 注释或者删除原来的默认源，添加阿里云的源，然后执行apk update，在进行安装就OK了
     
     
     2、ssh 启动问题
     / # /etc/init.d/sshd start
     /bin/sh: /etc/init.d/sshd: not found
     
     这样的方式不能启动，需要安装一个alpine的管理工具
     apk add --no-cache openrc
     / # /etc/init.d/sshd start
      * WARNING: sshd is already starting
      所以使用 /usr/sbin/sshd -D 方式启动。但是又出现如下错误
      / # /usr/sbin/sshd -D
     Could not load host key: /etc/ssh/ssh_host_rsa_key
     Could not load host key: /etc/ssh/ssh_host_ecdsa_key
     Could not load host key: /etc/ssh/ssh_host_ed25519_key
     sshd: no hostkeys available -- exiting.
     解决方式：
     ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key
     ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key
     ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key
     
     再次启动
     / # /usr/sbin/sshd -D
     
     启动成功
     
     
     3、创建容器后的网络问题
     [root@docker43 opt]# docker run -it alpine
     WARNING: IPv4 forwarding is disabled. Networking will not work.
     
     解决方式：
     [root@docker43 ~]# vim /usr/lib/sysctl.d/00-system.conf 
     # Kernel sysctl configuration file
     #
     # For binary values, 0 is disabled, 1 is enabled.  See sysctl(8) and
     # sysctl.conf(5) for more details.
     
     # Disable netfilter on bridges.
     net.bridge.bridge-nf-call-ip6tables = 0
     net.bridge.bridge-nf-call-iptables = 0
     net.bridge.bridge-nf-call-arptables = 0
     
     net.ipv4.ip_forward=1    # 添加这一行
     
     
     [root@docker43 ~]# systemctl restart network
     [root@docker43 ~]# docker rm 719f5a1f1ffd
     [root@docker43 ~]# docker run -it alpine
     / #
{% endraw %}
