---
layout: post
title: "Javascript：负面的 lookbehind 相当于？"
title2: "Javascript: negative lookbehind equivalent?"
date: 2018-08-24 15:13:11 +0800
source: "https://stackoverflow.com/questions/641407/javascript-negative-lookbehind-equivalent"
fileName: "javascript-fu-mian-de-lookbehind-xiang-dang-yu-"
published: true
---

{% raw %}
遵循 Mijoja 的想法，并从 JasonS 暴露的问题中汲取灵感，我有了这个想法;我检查了一下，但我不确定自己，所以在 js 正则表达式中比我更专业的人验证会很棒:)

    var re = /(?=(..|^.?)(ll))/g
             // matches empty string position
             // whenever this position is followed by
             // a string of length equal or inferior (in case of "^")
             // to "lookbehind" value
             // + actual value we would want to match

    ,   str = "Fall ball bill balll llama"

    ,   str_done = str
    ,   len_difference = 0
    ,   doer = function (where_in_str, to_replace)
        {
            str_done = str_done.slice(0, where_in_str + len_difference)
            +   "[match]"
            +   str_done.slice(where_in_str + len_difference + to_replace.length)

            len_difference = str_done.length - str.length
                /*  if str smaller:
                        len_difference will be positive
                    else will be negative
                */

        }   /*  the actual function that would do whatever we want to do
                with the matches;
                this above is only an example from Jason's */



            /*  function input of .replace(),
                only there to test the value of $behind
                and if negative, call doer() with interesting parameters */
    ,   checker = function ($match, $behind, $after, $where, $str)
        {
            if ($behind !== "ba")
                doer
                (
                    $where + $behind.length
                ,   $after
                    /*  one will choose the interesting arguments
                        to give to the doer, it's only an example */
                )
            return $match // empty string anyhow, but well
        }
    str.replace(re, checker)
    console.log(str_done)

我的个人输出：

    Fa[match] ball bi[match] bal[match] [match]ama

原则是打电话`checker` 在任何两个字符之间的字符串中的每个点，只要该位置是起点：

--- 任何不想要的大小的子串（这里`'ba'`, 从而`..`) (如果这个尺寸已知;否则它可能更难做到）

--- --- 或者小于它的字符串的开头：`^.?`

并且，在此之后，

--- 什么是实际寻求（这里`'ll'`).

At each c
每次电话会议`checker`, 将有一个测试来检查之前的值`ll` 不是我们不想要的（`!== 'ba'`); 如果是这种情况，我们会调用另一个函数，它必须是这个函数（`doer`) 这将对 str 进行更改，如果目的是这一个，或更一般地，将输入必要的数据来手动处理扫描的结果`str`.

在这里我们改变字符串，所以我们需要保持长度差异的痕迹，以便抵消给定的位置`replace`, 全部计算`str`, 它本身永远不会改变。

因为原始字符串是不可变的，所以我们可以使用该变量`str` 存储整个操作的结果，但我认为已经因重新替换而复杂化的例子会更清楚另一个变量（`str_done`).

我想在表演方面它必须非常苛刻：所有那些毫无意义的“进入”替代品，`this str.length-1` 时间，加上这里由 doer 手动更换，这意味着很多切片......
可能在这个特定的上述情况下可以分组，通过将字符串仅切割成我们想要插入的部分一次`[match]` 和`.join()`用它`[match]` 本身。

另一件事是，我不知道它将如何处理更复杂的情况，即假看守的复杂价值......长度可能是最有问题的数据。

并且，在`checker`, 如果$ behind 的非多余值的多种可能性，我们将不得不使用另一个正则表达式对其进行测试（在外部进行缓存（创建）`checker` 最好，避免在每次调用时创建相同的正则表达式对象`checker`) 知道这是否是我们想要避免的。

希望我已经清楚了;如果不是不犹豫，我会更好。 :)
{% endraw %}