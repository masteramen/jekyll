---
layout: post
title:  "php从url中提取参数名和参数值的方法"
title2:  "php从url中提取参数名和参数值的方法"
date:   2017-01-01 23:46:18  +0800
source:  "http://www.jfox.info/php-cong-url-zhong-ti-qu-can-shu-ming-he-can-shu-zhi-de-fang-fa.html"
fileName:  "20170100678"
lang:  "zh_CN"
published: true
permalink: "php-cong-url-zhong-ti-qu-can-shu-ming-he-can-shu-zhi-de-fang-fa.html"
---
{% raw %}
By Lee - Last updated: 星期日, 八月 24, 2014

php从url中提取参数名和参数值的实现方法：

php的preg_match_all方法把匹配的结果存放在第三个指定的参数中，是一个二维数组。第一维度是分组信息的数组，即第一个数组存放的是所有匹配的完整字符串，第二个数组存放的是第一个()对应的值得，第二维度是分组的值。

    function getKeyValue($url) {

$result = array();

$mr = preg_match_all(‘/(\?|&)(.+?)=([^&?]*)/i’, $url, $matchs);

if ($mr !== FALSE) {

for ($i = 0; $i < $mr; $i++) {

$result[$matchs[2][$i]] = $matchs[3][$i];

}

}

return $result;

}
{% endraw %}
