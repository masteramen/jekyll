---
layout: post
title:  "RMAN备份与恢复（一）–认识RMAN"
title2:  "RMAN备份与恢复（一）–认识RMAN"
date:   2017-01-01 23:49:10  +0800
source:  "https://www.jfox.info/rman-bei-fen-yu-hui-fu-yi-ren-shi-rman.html"
fileName:  "20170100850"
lang:  "zh_CN"
published: true
permalink: "2017/rman-bei-fen-yu-hui-fu-yi-ren-shi-rman.html"
---
{% raw %}
RMAN（Recovery Manager）是Oracle恢复管理器的简称，是集数据库备份（backup）、修复（restore）和恢复（recover）于一体的工具。接下来了解一下RMAN中的几个重要概念。 

（1）RMAN档案资料库

–目标数据据库数据文件的镜像复制信息； 

–目标数据库中表空间与数据文件的关系； 

–存储用户建立的RMAN脚本，可以重复使用； 

–永久性的RMAN预定义配置参数信息。 

（2）RMAN通道

在RMAN中进行任何类型的备份、修复或恢复操作时，都需要为这些操作分配通道，一个RMAN通道表示到一个存储设备的数据流，对应目标数据库的一个进程，由服务器进程来完成数据库的备份与恢复工作。RMAN支持的通道设备类型包括磁盘（Disk）与SBT（System Backup To Tape）。SBT是指第三方介质管理器管理与控制的存储备份，主要是磁带库和磁带驱动器。 

（3）RMAN预定义配置参数

RMAN环境中有一系列的预定义配置参数，又称为RMAN环境变量，自动作用于所有的RMAN会话。可以使用show all命令查看预定义参数的配置

    RMAN> show all; 使用目标数据库控制文件替代恢复目录 db_unique_name 为 ORCL 的数据库的 RMAN 配置参数为: CONFIGURE RETENTION POLICY TO REDUNDANCY 2; #设置备份保留策略 CONFIGURE BACKUP OPTIMIZATION OFF; # default #启用或禁用优化功能 CONFIGURE DEFAULT DEVICE TYPE TO DISK; # default #设置默认的备份类型 CONFIGURE CONTROLFILE AUTOBACKUP OFF; # default #设置控制文件自动备份 CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '%F'; # default #控制文件自动备份的格式 CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET; # default #设置备份并行度 CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default #设置数据文件备份集的副本数量 CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1; # default #设置归档重做日志文件备份集的数量 CONFIGURE MAXSETSIZE TO UNLIMITED; # default #设置备份集的最大尺寸 CONFIGURE ENCRYPTION FOR DATABASE OFF; # default #设置启用加密功能 CONFIGURE ENCRYPTION ALGORITHM 'AES128'; # default #如果启用加密功能，设置采用的加密算法 CONFIGURE COMPRESSION ALGORITHM 'BASIC' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE ; # default #设置备份的压缩算法 CONFIGURE ARCHIVELOG DELETION POLICY TO NONE; # default #设置归档重做日志文件备份后的处理策略 CONFIGURE SNAPSHOT CONTROLFILE NAME TO '/home/app/oracle/product/11.2.0/dbhome_1/dbs/snapcf_orcl.f'; # default   #设置控制文件快照

可预先对这些参数进行配置，设置后的结果作用于所有RMAN会话，也可以在数据库备份与恢复过程中，对特定的参数进行配置。 

接下来将对RMAN中的常用操作进行学习。
{% endraw %}
