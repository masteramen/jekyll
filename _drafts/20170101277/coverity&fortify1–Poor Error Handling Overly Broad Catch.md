---
layout: post
title:  "coverity&fortify1–Poor Error Handling: Overly Broad Catch"
title2:  "coverity&fortify1–Poor Error Handling Overly Broad Catch"
date:   2017-01-01 23:56:17  +0800
source:  "https://www.jfox.info/coverityfortify1poorerrorhandlingoverlybroadcatch.html"
fileName:  "20170101277"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/coverityfortify1poorerrorhandlingoverlybroadcatch.html"
---
{% raw %}
[ganchuanpu](https://www.jfox.info/go.php?url=http://www.cnblogs.com/ganchuanpu/) 阅读( 
…) 评论( 
…) 
[编辑](https://www.jfox.info/go.php?url=https://i.cnblogs.com/EditPosts.aspx?postid=7172997)[收藏](#)
### 1.描述：

　　多个 catch 块看上去既难看又繁琐，但使用一个“简约”的 catch 块捕获高级别的异常类（如 Exception），可能会混淆那些需要特殊处理的异常，或是捕获了不应在程序中这一点捕获的异常。本质上，捕获范围过大的异常与“Java 分类定义异常”这一目的是相违背的。

### 
2.风险：

随着程序的增加而抛出新异常时，这种做法会十分危险。而新发生的异常类型也不会被注意到。

### 3.例子：

    try{
        //IOoperation
        //
    }
    catch(Exception ex){
        Log(ex);
    }
    

Fortify建议你分别处理可能出现的异常，因为不同类型的异常需要不同的处理方法，所以应该把try{}里可能出现的异常都枚举出来，然后分别处理，正确的代码写法如下：

    try {
        //IOoperation
        //
    }
    catch (IOException e) {
        logger.error("doExchange failed", e);
    }
    catch (InvocationTargetException e) {
        logger.error("doExchange failed", e);
    }
    catch (SQLException e) {
        logger.error("doExchange failed", e);
    }
{% endraw %}
