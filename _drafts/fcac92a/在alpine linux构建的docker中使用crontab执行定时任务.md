---
layout: post
title:  "在alpine linux构建的docker中使用crontab执行定时任务"
title2:  "在alpine linux构建的docker中使用crontab执行定时任务"
date:   2018-10-14 09:47:50  +0800
source:  "https://blog.csdn.net/bigheadsnake/article/details/78392539"
fileName:  "fcac92a"
lang:  "zh_CN"
published: false

---
{% raw %}
版权声明：本文为博主原创文章，未经博主允许不得转载。					https://blog.csdn.net/bigheadsnake/article/details/78392539				

最近使用使用docker部署程序时，发现基于alpine的docker里面crond命令都不能正确执行，同事建议使用两个docker后link起来读取，个人感觉还是比较占用资源，经过一番google，发现alpine这个发行版还是和centos，rethat等有一些不同，整理一下部署心得。

1. 首先发现docker时间和宿主机时间不一致，需要调整成一致crontab任务提高可读性，其中加载tzdata包，注意加载完不要删除，注意红色字体，进入docker后输入date看看时间一致不一致，Docker File命令：

RUN apk add --update libc-dev g++ python-dev openldap-dev py-pyldaptzdata \

    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \

2. alpine的crontab运行机制和其他linux有点差异，在docker中，似乎只能运行root的crontab命令，其路径在/var/spool/cron/crontabs/root中，并不是扫描cron.d/文件夹下面的所有文件，将自己的crontab脚本先copy到docker，再cat到docker的root脚本后面才可以运行，或者直接写脚本到Docker  File也可以，如下：

COPY scripts/cron.d/your_job_dir /etc/cron.d/

RUN cat /etc/cron.d/your_job_file>>/var/spool/cron/crontabs/root \
&& echo '* * * * * /bin/echo 'helloword' >> /var/log/cron'>>/var/spool/cron/crontabs/root

3. 运行时直接加上后台的crond即可，我的运行程序是python server.py，在前面加上crond即可，默认后台运行。

CMD crond && python server.py
{% endraw %}
