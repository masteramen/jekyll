---
layout: post
title:  "JavaScript MVC前端框架选择, Angular、Backbone、CanJS与Ember对比PK"
title2:  "JavaScript MVC前端框架选择, Angular、Backbone、CanJS与Ember对比PK"
date:   2017-01-01 23:43:08  +0800
source:  "http://www.jfox.info/javascript-mvc-qian-duan-kuang-jia-xuan-ze-angularbackbonecanjs-yu-ember-dui-bi-pk.html"
fileName:  "20170100488"
lang:  "zh_CN"
published: true
permalink: "javascript-mvc-qian-duan-kuang-jia-xuan-ze-angularbackbonecanjs-yu-ember-dui-bi-pk.html"
---
{% raw %}
By Lee - Last updated: 星期二, 十一月 12, 2013

选择JavaScript MVC框架很难。一方面要考虑的因素非常多，另一方面这种框架也非常多，而要从中选择一个合适的，还真得费一番心思。想知道有哪些JavaScript MVC框架可以选择？

我用过其中4个框架：**Angular**、 **Backbone**、 **CanJS**和 **Ember**。因此，可以对它们作一比较，供大家参考。本文会涉及框架选型过程中需要考虑的一系列因素，我们逐一讨论。

每一个因素我们都会按照1到5分来打分，1分代表很差，5分代表很好。我会尽量保持客观，但也不敢保证真能“一碗水端平”，毕竟这些分数都是根据我个人经验给出的。

## 功能

[![01YLCrGEGh2](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrGEGh2C)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrGEGh2C)

作为构建应用的基础，框架必须具备一些重要的功能。比如，视图绑定、双向绑定、筛选、可计算属性（computed property）、脏属性（dirty attribute）、表单验证，等等。还能罗列出一大堆来。下面比较了一些我认为MVC框架中比较重要的功能：
功能AngularBackboneCanJSEmber可观察对象（observable）是是是是路由（routing）是是是是视图绑定（view binding）是 是是双向绑定（two way binding）是––是部分视图（partial view）是–是是筛选列表视图（filtered list view）是–是是
- **可观察对象**：可以被监听是否发生变化的对象。
- **路由**：把变化通过浏览器URL的参数反映出来，并监听这些变化以便执行相应的操作。
- **视图绑定**：在视图中使用可观察对象，让视图随着可观察对象的变化而自动刷新。
- **双向绑定**：让视图也能把变化（如表单输入）自动推送到可观察对象。
- **部分视图**：包含其他视图的视图。
- **筛选列表视图**：用于显示根据某些条件筛选出来的对象的视图。

### 得分

根据上述功能，我打出的分数如下：
AngularBackboneCanJSEmber5245
有一点必须指出，使用Backbone也能实现上述大多数功能，只是手工编码量挺大的，有时候还要借助插件。这里的打分只考虑了框架核心是否支持某一功能。

## 灵活性

[![01YLCrKJb8F](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKJb8FR)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKJb8FR)

有时候，框架配合一些现成的插件和库来使用，可能要比使用框架原生同类功能效果更好，而这种插件和库几乎遍地都是（不下数百个），又各有特色。因此，能够把这些库和插件整合到MVC框架中也非常重要。

Backbone是其中最灵活的一个框架，因为它的约定和主张最少。使用Backbone需要你自己作出很多决定。

CanJS的灵活性与Backbone差不多，把它跟别的库整合起来很容易。在CanJS中甚至可以更换其他渲染引擎，我在CanJS中就一直用[Rivets](http://www.jfox.info/go.php?url=http://rivetsjs.com/)，没有任何问题。不过，我还是推荐框架自带的组件。

Ember和Angular也都还算灵活，可有时候你会发现，就算不喜欢它们的某些实现方法，你也只能默默忍受。 这是在选择Ember或Angular时必须考虑的。

### 得分
AngularBackboneCanJSEmber3543
## 上手难度

[![01YLCrKX9Zt](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKX9ZtT)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKX9ZtT)

### Angular

Angular一开始会让人大呼过瘾，因为可以利用它干好多意想不到的事，比如双向绑定，而且学习难度不高。乍一看让人觉得很简单。可是，进了门之 后，你会发现后面的路还很长。应该说这个框架比较复杂，而且有不少标新立异之处。想看着它的文档上手并不现实，因为Angular制造的概念很多，而文档 中的例子又很少。

### Backbone

Backbone的基本概念非常容易理解。但很快你会发现它对怎么更好地组织代码并没有太多主张。为此，你得观摩或阅读一些教程，才能知道在Backbone中怎么编码最好。而且，你会发现在有了Backbone的基础上，还得再找一个库（比如[Marionette](http://www.jfox.info/go.php?url=http://marionettejs.com/)或[Thorax](http://www.jfox.info/go.php?url=http://thoraxjs.org/)）跟它配合才能得心应手。正因为如此，我不认为Backbone是个容易上手的框架。

### CanJS

CanJS相对而言是这里面最容易上手的。看看它只有一页的网站（[http://canjs.com/](http://www.jfox.info/go.php?url=http://canjs.com/)），基本上就知道怎么做效率最高了。当然，还得找其他一些资料看，不过我个人很少有这种需求（比如看其他教程、上论坛或讨论组提问呀什么的）。

### Ember

Ember的上手难度与Angular有一拼，我认为学习Ember比学习Angular总体上容易一些，但它要求你一开始就要先搞懂一批基本概念。而Angular呢，一开始不需要这么费劲也能做一些让人兴奋不已的事儿。Ember缺少这种前期兴奋点。

### 得分
AngularBackboneCanJSEmber2453
## 开发效率

[![01YLCrKi3k4](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKi3k4J)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKi3k4J)

比较全面地掌握了一个框架之后，重点就转移到了产出上。什么意思呢？约定啊、戏法啊，反正要尽可能快。

### Angular

熟悉Angular之后，你的效率会非常高，这一点毋庸置疑。之所以我没给它打最高分，主要因为我觉得Ember的开发效率似乎更胜一筹。

### Backbone

Backbone要求你写很多样板（boilerplate ）代码，而我认为这完全没必要。要我说，这是直接影响效率的一个因素。

### CanJS

CanJS的开发效率属于不快不慢的那种。不过，考虑到学习难度很低，因此适合早投入早产出的项目。

### Ember

Ember的开发效率首屈一指。它有很多强制性约束，可以帮你自动完成的事很多。而开发人员要做的，就是学习和应用这些约定，Ember会替你处理到位。

### 得分
AngularBackboneCanJSEmber4245
## 社区支持

[![01YLCrKsztx](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKsztx8)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrKsztx8)

**能轻易找到参考资料和专家帮忙吗？**

Backbone的社区很大，这是人所共知的事实。关于Backbone的教程也几乎汗牛充栋，StackOverflow和IRC社区非常热闹。

Angular和Ember社区也相当大，教程什么的同样不少，StackOverflow和IRC也很热闹，但还是比不上Backbone。

CanJS社区呢，相对小一些，好在社区成员比较活跃，乐于助人。我倒没发现CanJS社区规模小有什么负面影响。

### 得分
AngularBackboneCanJSEmber4534
## 生态系统

[![01YLCrLUjNe](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrLUjNe6)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrLUjNe6)

**有没有插件或库构成的生态系统？**

说起插件和库，Backbone的选择是最多的，可用插件俯拾皆是，这一点让其他框架都望尘莫及。Angular的生态圈加上[Angular UI](http://www.jfox.info/go.php?url=http://angular-ui.github.com/)还是很令人瞩目的。我觉得Ember的下游生态虽然欠发达，但Ember本身很受欢迎， 所以前景十分乐观。CanJS的下游支脉比较少见。

### 得分
AngularBackboneCanJSEmber4524
## 文件大小

[![01YLCrLahoa](http://www.jfox.info/wp-content/uploads/2013/11/01YLCrLahoab)](http://www.jfox.info/go.php?url=http://www.jfox.info/wp-content/uploads/2013/11/01YLCrLahoab)

这个因素有时候很重要，特别是对于移动开发项目。

**自身大小（无依赖，未压缩）**
AngularBackboneCanJSEmber80KB18KB33KB141KB
Backbone最小，这一点也是最为人们
{% endraw %}
