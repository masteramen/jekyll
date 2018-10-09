---
layout: post
title:  "在Docker中运行MySQL简介教程"
title2:  "在Docker中运行MySQL简介教程"
date:   2017-01-01 23:53:37  +0800
source:  "https://www.jfox.info/%e5%9c%a8docker%e4%b8%ad%e8%bf%90%e8%a1%8cmysql%e7%ae%80%e4%bb%8b%e6%95%99%e7%a8%8b.html"
fileName:  "20170101117"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%9c%a8docker%e4%b8%ad%e8%bf%90%e8%a1%8cmysql%e7%ae%80%e4%bb%8b%e6%95%99%e7%a8%8b.html"
---
{% raw %}
本文用最直接的方式介绍如何在Docker中运行MySQL，如果你只是想让MySQL运行起来，或者想了解一些相关的知识，这篇文章就能够给你想要的。 

##  1.拉取镜像 

    
    docker pull mysql
    

 如果不显示指定Tag，默认为latest。下面拉取的是Tag为5.7.18的MySQL镜像 

    
    docker pull mysql:5.7.18
    

 Docker商店的地址： [ https://hub.docker.com ](https://www.jfox.info/go.php?url=https://hub.docker.com)
MySQL镜像的地址： [ https://hub.docker.com/_/mysql/ ](https://www.jfox.info/go.php?url=https://hub.docker.com/_/mysql/)

 拉取结束后，可以通过以下命令查看已拉取的镜像 

    
    docker images
    

 如下图所示： 

![](/wp-content/uploads/2017/07/1499443781.png)

##  2. 运行容器 

 执行下面的命令启动一个MySQL容器 

    
    docker run --name bob-mysql -p 3306:3306 -v ~/mysql:/var/lib/mysql --restart=always -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7.18
    

 下面解释一下这条命令 

` docker run ` ——docker从镜像启动一个容器命令 

` --name ` ——这是docker run命令的参数，就是给要启动的容器起个名字 

` -p ` ——端口映射，前面的是宿主端口号，后面的是容器端口号 

` -v ` ——挂载宿主机目录到镜容器里，前面的是宿主机目录，后面的是容器目录，那么后面的目录为什么是/var/lib/mysql呢？执行 ` docker inspect -f {{.Config.Volumes}} bob-mysql ` 就可以看到了 

` --restart ` ——故障或开机重启，显示退出除外 

` -e ` ——指的是环境变量，在启动MySQL镜像时，可以传入一个或多个环境变量修改MySQL实例的配置。这里一定要注意的是启动容器的数据目录已经包含了数据库，这时环境变量就不起作用了。 

 MySQL镜像支持一下环境变量 
` MYSQL_ROOT_PASSWORD ` —— 设置MySQL root用户的密码 
` MYSQL_DATABASE ` —— 指定在镜像启动时创建的数据库名称，如果同时指定了 ` MYSQL_USER ` , ` MYSQL_PASSWORD ` ，则会授予该用户对这个数据库ALL的权限（GRANT ALL) 
` MYSQL_USER ` , ` MYSQL_PASSWORD ` —— 创建一个用户并设置它的密码 
` MYSQL_ALLOW_EMPTY_PASSWORD ` —— 设置为 ` yes ` 允许容器启动时root用户密码留空 
` MYSQL_RANDOM_ROOT_PASSWORD ` —— 为root用户生成随机密码（使用 ` pwgen ` ) 
` MYSQL_ONETIME_PASSWORD ` —— 设置root用户初始化完后过期，强制登录时修改密码。注意这个功能只支持MySQL 5.6+ 

##  进入容器 

 使用下面的命令进入容器 

    
    docker exec -it bob-mysql /bin/bash
    

##  登录MySQL 

 使用下面的命令登录MySQL 

    
    mysql -uroot -p
    

 输入密码后，登录MySQL成功 

![](/wp-content/uploads/2017/07/1499443782.png)

##  创建MySQL用户 

 使用下面的命令可以创建MySQL用户 

    
    mysql> use mysql;
    mysql> create USER 'chengxulvtu'@'%' IDENTIFIED BY '123456';
    

 下面解释以下这条命令 
` chengxulvtu ` —— 这是要创建的用户名称 
` % ` —— 指定用户允许从哪里的主机登录,如果是本地用户可用localhost, 如果想让该用户可以从任意远程主机登录,可以使用通配符%，上面的命令中就是允许chengxulvtu这个用户从任意的主机登录。 
` 123456 ` —— 这个是chengxulvtu用户的密码 

 所以上面的命令用一句话说就是：创建一个名为chengxulvtu的用户，将它的密码设置为123456，并允许从任意的主机登录。 

##  用户授权 

 MySQL授权的命令格式如下： 

    
    GRANT privileges ON databasename.tablename TO 'username'@'host'
    

 下面给出几个例子： 

 1. 授予chengxulvtu所有数据库有所有的权限 

    
    grant all on *.* to 'chengxulvtu'@'%'
    

 2. 授予chengxulvtu只有myql数据库的所有权限 

    
    grant all on mysql.* to 'chengxulvtu'@'%'
    

 3. 授予chengxulvtu只有mysql数据库的查询权限 

    
    grant select on mysql.* to 'chengxulvtu'@'%'
    

 4. 授予chengxulvtu只有mysql数据库user表的查询权限 

    
    grant select on mysql.user to 'chengxulvtu'@'%'
    

 这里就先举这几个例子，详细可自行查阅。 

 如果想让chengxulvtu也有授予其他用户权限的权限，则后面要带上WITH GRANT OPTION 

    
    grant all *.* to 'chengxulvtu'@'%' with grant option;
    

 本文关于在Docker中运行MySQL容器就介绍这些，希望对你有所帮助。
{% endraw %}
