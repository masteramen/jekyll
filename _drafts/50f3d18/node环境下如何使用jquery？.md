---
layout: post
title: "node环境下如何使用jquery？"
title2: "node环境下如何使用jquery？"
date: 2018-09-07 03:07:21  +0800
source: "https://blog.csdn.net/cvper/article/details/79576071"
fileName: "50f3d18"
lang: "zh_CN"
published: true
---

{% raw %}
版权声明：本文为博主原创文章，未经博主允许不得转载。 https://blog.csdn.net/cvper/article/details/79576071

（测试环境：node 7.6.0 npm 5.6.0 jquery 3.3.1 jsdom 11.6.2）

第一步，下载 jquery 包

命令：npm install jquery

第二步 , 下载 jsdom 包

命令：npm install jsdom

第三步，我们新建一个 index.js

代码如下：

```js
const jsdom = require("jsdom");

const { JSDOM } = jsdom;

const { window } = newJSDOM(`<!DOCTYPE html>`);

const $ = require("jQuery")(window);

console.log($); //测试 jquery 是否可以正常工作
```

第四步：执行命令 node index.js

查看输出信息：

![](https://img-blog.csdn.net/20180316010313104?watermark/2/text/Ly9ibG9nLmNzZG4ubmV0L2N2cGVy/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

证明 jquery 可以正常使用了；

{% endraw %}
