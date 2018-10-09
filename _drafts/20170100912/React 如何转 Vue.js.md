---
layout: post
title:  "React 如何转 Vue.js"
title2:  "React 如何转 Vue.js"
date:   2017-01-01 23:50:12  +0800
source:  "https://www.jfox.info/react-%e5%a6%82%e4%bd%95%e8%bd%ac-vue-js.html"
fileName:  "20170100912"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/react-%e5%a6%82%e4%bd%95%e8%bd%ac-vue-js.html"
---
{% raw %}
如果你是一个 React 开发人员，并决定尝试 Vue.js。欢迎参加这场聚会。

React 和 Vue 就像可口可乐和百事可乐，很多你可以在 React 中做的事，也同样可以在 Vue 中做。不过两者仍然有一些重要的概念上的差异，其中一些反映了 Angular 对 Vue 的影响。

接下来的文章中，我将重点讨论下两者的差异，以便你准备好切换到Vue，并且能马上写出高效的代码。

## React 和 Vue 之间有多大的区别？

React 和 Vue 的相似性多于差异性：

- 都是用于创建 UI 的 JavaScript 库
- 都是快速和轻量级的
- 都有基于组件的架构
- 都使用虚拟 DOM
- 都可以放在单独的 HTML 文件中，或者在更复杂的 Webpack 设置中的一个模块
- 都有独立但常用的路由器和状态管理库

它们最大的区别在于 Vue 通常使用 *HTML 模板文件*，而 React 是完全使用 JavaScript。Vue 还有具有*可变状态*和称为 “reactivity” 的重新渲染的自动系统。

我们将在下面一一道来。

## Components

使用 Vue.js，组件将使用 API 方法 `.component` 进行声明，该方法接收 `id` 和定义对象的参数。你可能会注意到 Vue 组件中熟悉的方面，以及不太熟悉的方面：
JavaScript 
   
  
  
  
Vue.component(‘my-component’, {
  // Props
  props: [ ‘myprop’ ],
  // Local state
  data() {
    return {
      firstName: ‘John’,
      lastName: ‘Smith’
    }
  },
  // Computed property
  computed: {
    fullName() {
      return this.firstName + ‘ ‘ + this.lastName;
    }
  },
  // Template
  template: 
    

Vue components typically have string templates.

Here’s some local state: {{ firstName }}

Here’s a computed value: {{ fullName }}

Here’s a prop passed down from the parent: {{ myprop }}

  ,
  // Lifecycle hook
  created() {
    setTimeout(() => {
      this.message = ‘Goodbye World’  
    }, 2000);
{% endraw %}
