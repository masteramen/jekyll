---
layout: post
title:  "Intel芯片再次出现超线程bug，主要影响Debian系统"
title2:  "Intel芯片再次出现超线程bug，主要影响Debian系统"
date:   2017-01-01 23:51:44  +0800
source:  "https://www.jfox.info/intel%e8%8a%af%e7%89%87%e5%86%8d%e6%ac%a1%e5%87%ba%e7%8e%b0%e8%b6%85%e7%ba%bf%e7%a8%8bbug-%e4%b8%bb%e8%a6%81%e5%bd%b1%e5%93%8ddebian%e7%b3%bb%e7%bb%9f.html"
fileName:  "20170101004"
lang:  "zh_CN"
published: true
permalink: "2017/intel%e8%8a%af%e7%89%87%e5%86%8d%e6%ac%a1%e5%87%ba%e7%8e%b0%e8%b6%85%e7%ba%bf%e7%a8%8bbug-%e4%b8%bb%e8%a6%81%e5%bd%b1%e5%93%8ddebian%e7%b3%bb%e7%bb%9f.html"
---
{% raw %}
一个超线程的重要问题已经在Intel芯片上被发现，这家芯片制造公司已经发售超线程CPU芯片有近十年时间。但是新发现的缺陷在型号为Kaby Lake和Skylake中出现。

Intel超线程技术的问题首先由windows 2000和windows xp用户发现，随后这个问题被一系列的软件更新所修复。但是，现在这个问题主要影响Debian系统。

该超线程漏洞会导致不可预知的系统行为，该行为会破坏数据，甚至破坏整个系统。Debian已经发现专门页面来解释如何识别会受影响的CPU以及如何手动修复问题。

微码更新

Intel已经发布了Kaby Lake和Skylake芯片的更新微码，以修复超线程缺陷。更新微码已经同UEFI集成，以方便其工作，但是更新微码只向系统供应商提供。

Kaby Lake和Skylake芯片的用户可以查看主板芯片更新来解决芯片问题，当然，也可以关闭芯片的超线程功能来避免出现问题。
{% endraw %}
