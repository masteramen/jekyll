---
layout: post
title: "如何捕获express框架app.listen的异常？"
title2: "如何捕获express框架app.listen的异常？"
date: 2018-10-10 14:46:54  +0800
source: "https://cnodejs.org/topic/5a5c33c9afa0a121784a8bd6"
fileName: "458aead"
lang: "zh_CN"
published: true
---

{% raw %}

### 问题背景

由于在启动项目时会出现

uncaught exception: Error: listen EADDRINUSR 155.145.111.11:45621 ... ...

### 解决方法

所以想捕获 listen 的异常。但在网上查了之后都是用的 process.on(‘uncaughtexception’,function)此方法。 有没有直接捕获 listen 的异常的方法呀，求助。

1、process.on(‘uncaughtexception’, callback) 是进程级别的异常捕获；
2、app.listen(port, callback); 这里的 callback 可以理解为，整个框架都是通过一个回调函数来处理 HTTP 请求，里面进程 MVC 等各种设计；

来看看 app.listen 到底做了什么：https://github.com/expressjs/express/blob/master/lib/application.js#L617。

====== 正义分割线

通过 app.listen 我们其实得到一个 server 对象，通过监听 server 对象的错误事件可以获取到错误信息；

```js
server.on("error", e => {
  if (e.code === "EADDRINUSE") {
    console.log("Address in use, retrying...");
    setTimeout(() => {
      server.close();
      server.listen(PORT, HOST);
    }, 1000);
  }
});
```

- 通过 server.listening 方法可以提前判断端口是否被占用；
- listen 时指定端口为 0 ，会随机分配一个可用的端口

{% endraw %}
