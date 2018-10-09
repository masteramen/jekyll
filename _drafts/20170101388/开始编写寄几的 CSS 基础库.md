---
layout: post
title:  "开始编写寄几的 CSS 基础库"
title2:  "开始编写寄几的 CSS 基础库"
date:   2017-01-01 23:58:08  +0800
source:  "https://www.jfox.info/%e5%bc%80%e5%a7%8b%e7%bc%96%e5%86%99%e5%af%84%e5%87%a0%e7%9a%84css%e5%9f%ba%e7%a1%80%e5%ba%93.html"
fileName:  "20170101388"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%bc%80%e5%a7%8b%e7%bc%96%e5%86%99%e5%af%84%e5%87%a0%e7%9a%84css%e5%9f%ba%e7%a1%80%e5%ba%93.html"
---
{% raw %}
**前言**

在现在的互联网业务中，前端开发人员往往需要支持比较多的项目数量。很多公司只有 1-2 名前端开发人员，这其中还不乏规模比较大的公司。这时前端同学就需要独挡一面支持整个公司上下的前端业务，项目如流水一般从手里流过，此时更需要前端开发人员将工作工程化、流水线化。

本博文在发布之后有些争议，有人认为如此书写 css 并不规范。这点我认同，但不少框架也采用了这种方式，提升的开发效率也是明显的。希望大家对这种思想去其糟粕，取其精华，过度使用必然导致可维护性下降，但绝对使用单一类名也不现实。最后祝大家工作顺利。

**一个栗子**

现在需要编写页面中的一个按钮，结构与样式如下：

    <div class='button'>开始</div>

![](/wp-content/uploads/2017/07/1500911668.png)

有人说，这有什么难的，不到1分钟就能写好了：

    .button {
        width: 100px;
        height: 40px;
        font-size: 16px;
        text-align: center;
        line-height: 40px;
        color: #fff;
        background-color: #337ab7;
        border-radius: 6px;
        cursor: pointer;
    }

但如果这个项目中有50个大小不一的这样按钮怎么办？有人会说，那把 button 抽象成公共类名的不就好喽，就像下面这样：

    <div class="button btn-begin"></div> 

    .button {
        font-size: 16px;
        text-align: center;
        line-height: 40px;
        color: #fff;
        background-color: #337ab7;
        border-radius: 6px;
        cursor: pointer;
    }
    
    .btn-begin {
        width: 100px;
        height: 40px;
    }

没错，这种确实是比较普遍的方法。但问题是，下一个项目风格改变，我们用不到 button 的公共样式了。所以这种方式不适合流水线作业，也不在本篇的讨论范畴中。

现在我们编写了一个 base.css，它也就是标题所说的我们寄几的基础 css 库，也是真正意义上的公共样式。假设 base.css 中已经定义好了以下几个样式类：

    .f-16 {
        font-size: 16px;
    }
    
    .c-white {
        color: #fff;
    }
    
    .text-center {
        text-align: center;
    }
    
    .radius-6 {
        border-radius: 6px;
    }
    
    .cursor {
        cursor: pointer;
    }

更改结构：

    <div class="f-16 c-white text-center radius-6 cursor button">开始</div>

这样我们只需写少许 css 就能完成 button 的样式。

    .button {
        width: 100px;
        height: 40px;
        line-height: 40px;
        background-color: #337ab7;
    }

**·** 如上，当公共的样式定义的足够多时，可以极大的增加我们的开发效率，尤其是官网以及 CMS 这样较大的项目，效果更加明显。甚至某些结构只需要通过已有的样式类名进行组合就能完整实现，而不需要另外起名并单独编写 css。

**·** 在实际生产中，你还可以动态扩展 base.css，比如项目的设计刚到手上时，发现使用 #c9c9c9 颜色的字体比较多，就可以在 base.css 中加入 .c-c9 { color: #c9c9c9 }。

· 市面上的 css 库数都数不清，为什么还要大家寄几编写呢。主要有以下几点：1. 有人可能会这样想：“我 CSS 基础这么好，让我用别人写的？闹呢！”；2. 别人的库可能有很多冗余的、自己用不到的样式，白白增加项目体积；3. 别人的库需要学习成本，自己写的不仅符合自己的 css 书写习惯，起的类名也是自己最好记的。

**抛砖引玉**

上面说了那么多，下面列举下我个人在平常用的比较多的公共样式，先付上[源码](https://www.jfox.info/go.php?url=https://github.com/Darylxyx/css-collection/blob/master/base.css)。

**内外边距初始化**

    html, body, div, h1, h2, h3, h4, h5, h6, p, span, img, input, textarea, ul, ol, li, hr {
        margin: 0;
        padding: 0;
    }

用 * 的同学回炉重造哈，：）

**去除 list 默认样式**

    ul, ol {
        list-style-type: none;
    }

**去除 a 标签默认样式**

    a {
        text-decoration: none;
    }

**左右浮动**

    .l {
        float: left;
    }
    
    .r {
        float: right;
    }

**两种常用背景图展示**

    .bg-img {
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
    }
    
    .ic-img {
        background-position: center;
        background-repeat: no-repeat;
        background-size: contain;
    }

**不同字号字体（实时扩展）**

    .f-13 {
        font-size: 13px;
    }
    
    .f-14 {
        font-size: 14px;
    }
    
    .f-16 {
        font-size: 16px;
    }
    
    .f-18 {
        font-size: 18px;
    }
    
    .f-20 {
        font-size: 20px;
    }

**字体粗细**

    .f-bold {
        font-weight: bold;
    }
    
    .f-bolder {
        font-weight: bolder;
    }

**字体颜色（实时扩展）**

    .c-white {
        color: #fff;
    }
    
    .c-black {
        color: #000;
    }

**行高（实时扩展）**

    .lh-100 {
        line-height: 100%;
    }
    
    .lh-130 {
        line-height: 130%;
    }
    
    .lh-150 {
        line-height: 150%;
    }
    
    .lh-170 {
        line-height: 170%;
    }
    
    .lh-200 {
        line-height: 200%;
    }

**元素类型**

    .inline {
        display: inline;
    }
    
    .block {
        display: block;
    }
    
    .inline-block {
        display: inline-block;
    }

**box-sizing**

    .border-box {
        -webkit-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
    }

**清除浮动**

    .clear {
        clear: both;
    }

**超出隐藏**

    .overflow {
        overflow: hidden;
    }

**字符居左/中/右**

    .text-left {
        text-align: left;
    }
    
    .text-center {
        text-align: center;
    }
    
    .text-right {
        text-align: right;
    }

**字体超出隐藏，以省略号代替**

    .text-overflow {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

**首行缩进2字符**

    .text-indent {
        text-indent: 2em;
    }

**强制文字换行**

    .text-wrap {
        word-wrap: break-word;
        word-break: normal;
    }

**常用的3种定位方式**

    .absolute {
        position: absolute;
    }
    
    .relative {
        position: relative;
    }
    
    .fixed {
        position: fixed;
    }

**浮动光标改变**

    .cusor {
        cursor: pointer;
    }

上面例举了一部分公共样式，希望能给大家一些启发。命名和抽象方式可以按照自己的喜好来，将平常工作中用到的样式慢慢积累，很快就会拥有自己专属的强大 css 基础库。祝大家都能做好自己业务的工程化，流水化，下一篇博文是跟大家分享寄几的公共 JS。

**感谢你的浏览，希望能有所帮助**
{% endraw %}
