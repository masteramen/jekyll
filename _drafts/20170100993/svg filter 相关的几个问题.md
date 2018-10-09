---
layout: post
title:  "svg filter 相关的几个问题"
title2:  "svg filter 相关的几个问题"
date:   2017-01-01 23:51:33  +0800
source:  "https://www.jfox.info/svg-filter-%e7%9b%b8%e5%85%b3%e7%9a%84%e5%87%a0%e4%b8%aa%e9%97%ae%e9%a2%98.html"
fileName:  "20170100993"
lang:  "zh_CN"
published: true
permalink: "2017/svg-filter-%e7%9b%b8%e5%85%b3%e7%9a%84%e5%87%a0%e4%b8%aa%e9%97%ae%e9%a2%98.html"
---
{% raw %}
<p> 在用 <a href=”http://leafletjs.com/” rel=”nofollow”> Leaflet </a> 处理 <a href=”http://geojson.org/” rel=”nofollow”> GeoJSON </a> 格式的地理信息时，解析结果被以内联的 SVG 格式嵌入网页中。为了使地图更有质感，希望通过添加阴影获得视觉上的高低效果，尝试过程记录如下。 </p> <h1> css </h1> <p> 首先， 内的元素是支持 css 样式的，用法也和普通的 css 一样，可以通过 id 或 class 来套用样式，但是 svg 元素具体支持的规则和普通 DOM 元素相差很大 </p> <h2> box-shadow </h2> <p> box-shadow 不支持 svg 内部的元素 </p> <h2> filter </h2> <p> filter 的 drop-shadow 也可以制造阴影效果，但是目前只有 Edge 支持对 svg 内部元素使用 </p> <h1> 元素 </h1> <pre><code>&lt;defs&gt; &lt;filter id=”shadow-water”&gt; &lt;feGaussianBlur out=”blurOut” in=”SourceGraphic” stdDeviation=”5″&gt;&lt;/feGaussianBlur&gt; &lt;feBlend in=”SourceGraphic” in2=”blurOut” mode=”normal”&gt;&lt;/feBlend&gt; &lt;/filter&gt; &lt;/defs&gt; </code></pre> <p> 本身就是 svg 标准的一部分，也是目前兼容性最好的，为 svg 元素添加阴影的方法，但是其本身并没有提供一个直接的添加阴影的方法，上面的例子里是通过将模糊后的图像和原始图像叠加实现的 </p> <p> 需要放置在 元素内 </p> <p> 需要使用此效果的元素，需要设置属性 filter=“url(#shadow-water)” 来应用 </p> <h1> svg 元素的操作 </h1> <p> 在我的环境里，svg 是由 leaflet 生成的，因此自定义的 只能通过代码动态的插入到已有的 标签内，但是这里不能使用 jQuery 来操作，类似 </p> <pre><code>$(‘svg’).prepend(‘&lt;defs&gt; &lt;filter id=”shadow-water”&gt; &lt;feGaussianBlur out=”blurOut” in=”SourceGraphic” stdDeviation=”5″&gt;&lt;/feGaussianBlur&gt; &lt;feBlend in=”SourceGraphic” in2=”blurOut” mode=”normal”&gt;&lt;/feBlend&gt; &lt;/filter&gt; &lt;/defs&gt;’); </code></pre> <p> 是行不通的，因为 内的元素类型需要是 SVGElement 才能正常工作，而 jQuery 会将 defs 等元素当作普通 DOM 元素加入到 svg 内部，因此会出现从调试工具里看到代码和手动编写的 svg 文件一致，但实际上无法发挥作用的情况。 </p> <p> 这里有一篇文章描述了这个问题，并提供了一个 <a href=”http://http://chubao4ever.github.io/tech/2015/07/16/jquerys-append-not-working-with-svg-element.html” rel=”nofollow”> 动态创建 svg 元素的方法 </a> </p> <h1> 两个 svg 标签 </h1> <p> 但是上面提到的方法写起来比较麻烦，尤其是需要动态插入的标签数量比较多，并且有嵌套的情况。 </p> <p> 最后我尝试了将 defs 写在另一 svg 里来解决这个问题。一个 svg 里的元素是可以引用另一个 svg 里的 filter 的，我预先创建了一个只包含 defs 的 svg 标签，内部只包含了几个需要用到的 filter 效果，而没实质性的元素。这个 svg 默认也会占据一定的屏幕空间，150×300，因此需要加上样式将其隐藏。 </p> <h1> 隐藏提供特效的 svg 标签 </h1> <p> 首先尝试 style=“display: none”，svg 标签被隐藏了，但是特效也一起消失； </p> <p> 然后尝试 style=“width: 0; height: 0”，特效得以保留，但仍占据了屏幕大约一行文字的高度； </p> <p> 最终改成 style=“position: absolute; width: 0; height: 0”，问题解决 </p>
{% endraw %}
