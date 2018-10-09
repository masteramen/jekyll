---
layout: post
title:  "U盘使用Windows10的磁盘管理工具划分多分区"
title2:  "U盘使用Windows10的磁盘管理工具划分多分区"
date:   2017-01-01 23:51:42  +0800
source:  "https://www.jfox.info/u%e7%9b%98%e4%bd%bf%e7%94%a8windows10%e7%9a%84%e7%a3%81%e7%9b%98%e7%ae%a1%e7%90%86%e5%b7%a5%e5%85%b7%e5%88%92%e5%88%86%e5%a4%9a%e5%88%86%e5%8c%ba.html"
fileName:  "20170101002"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/u%e7%9b%98%e4%bd%bf%e7%94%a8windows10%e7%9a%84%e7%a3%81%e7%9b%98%e7%ae%a1%e7%90%86%e5%b7%a5%e5%85%b7%e5%88%92%e5%88%86%e5%a4%9a%e5%88%86%e5%8c%ba.html"
---
{% raw %}
U盘的容量越来越大，速度也是与日俱增，对Windows系统稍有认知的人都知道，在安装时都会产生一个100——500M不等的隐藏分区，由于所占硬盘空间不大，一般很少会在意此分区，Windows 10内建的磁盘管理可以让你轻松管理与建立硬盘的分割区，但对于U盘似乎不是那么友善，想要将U盘划分多分区需要借助第三方工具，如今Windows 10 Creators Update (1703)版已支持USB设备的划分分区功能，不过需要一些些技巧，来看看如何使用磁盘管理将U盘划分成多分区。

想要使用Widnows 10内建的磁盘管理工具来将U盘划分成多个分区么？Windows 10 Creators Update (创意者更新1703)版后，不用再借助第三方工具了，已经支持U盘分区分割功能，不过唯一的条件的就是必须先格式化成NTFS后才能进行分割。
首先，将U盘放入运行Windows 10 Creators Update（v1703）版的Windows 10 PC，并将此U盘以NTFS方式格式化。

其次，打开Win 10的磁盘管理工具，找到U盘点击右键菜单中的“压缩卷”

在红色框内输入你想要分割的空间大小（以MB计算）。

在未配置分割区上按下鼠标右键，选择「新建简单卷」。

随即进入新建简单卷向导的画页，点选〔下一步〕来继续。

根据向导的步骤，对未分割卷添加卷并进行格式化，最后可以看到一个U盘被划分成多个分区了。![](/wp-content/uploads/2017/06/win10-u-disk-05.jpg)
{% endraw %}
