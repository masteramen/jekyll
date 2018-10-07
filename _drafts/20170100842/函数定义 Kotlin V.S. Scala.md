---
layout: post
title:  "函数定义 Kotlin V.S. Scala"
title2:  "函数定义 Kotlin V.S. Scala"
date:   2017-01-01 23:49:02  +0800
source:  "http://www.jfox.info/han-shu-ding-yi-kotlin-v-s-scala.html"
fileName:  "20170100842"
lang:  "zh_CN"
published: true
permalink: "han-shu-ding-yi-kotlin-v-s-scala.html"
---
{% raw %}
关注 Kotlin 已有段时日了，真是因为 Google 把它扶正而跑来跟风。因为进行想在 Java 与 Scala 间找一个折中的编程语言，也就是 Kotlin。这是一篇好几月前列的我 [想像中理想编程语言的几个特征](http://www.jfox.info/go.php?url=https://unmi.cc/features-of-ideal-programming-language/)，琢磨来去当今也就 Kotlin 比较符合我的口味。很早就想买 《Kotlin IN ACTION》这本书，因那是 Kotlin 1.1 刚出，而出版的书只涵盖到了 Kotlin, 所以未出手。看看再有一本好的那样的书估计也不是一时半会儿，所以今天还是把那本书弄到手了，至于 Kotlin 1.1 后的特性自个去补充。

尽管书中未提及 Kotlin 语言的设计灵感来自于何种语言, 但我的直觉就是与 Scala 太多相似之处，但没有 Scala 简单，并揉合一些 Swift 的特性，因此我在阅读 《Kotlin IN ACTION》时更多的会和 Scala 相比较。

第一个主题是关于 Kotlin 函数的定义与约定。Kotlin 的基本定义格式与 Scala 是类似的

- 函数体带大括号的叫做 `block body`
- 函数体不带大括号的叫做 `expression body`.

`block body` 中的返回值的 `return` 关键字不能省略，这一点与 Scala 不一样，Scala 中出口变量即为函数返回值，可以省去 `return`. 如果 `block body` 省略了 `return` 是什么效果呢？

    //Kotlin
    >>> fun max(a: Int, b: Int): Int {
    ...     if(a > b) a else b
    ... }
    >>> max(2, 3)
    0

指定函数的返回值类型为 Int 后即意味着没有任何有效 `return` 情况下，默认返回值为 0, 由于以上函数体中没有 `return`，所以调用 max(2, 3) 总是返回 0。这是 Kotlin 及容易出错的地方，英文叫做 error-prone。

不过 Kotlin 在使用 if 和 when 时，每个块中最后一个表达的值即为结果 — the last expression in a block is the result. 这一规则也适用于 try, catch, 还有 Lambda 表达式，可惜就是未能应用到函数本身。

* Kotlin 的 REPL 使用了与 Python 一样的提示符 `>>>`, 这一点没什么创意, 与 Scala 的控制台相比，Kotlin 的控制台中没有那么丰富的色彩显示, 而且也没有 Tab 自动完成功能。

而 Scala 不会有这样的出错可能

    scala> def max(a: Int, b: Int): Int = {
         |   if(a > b) a else b
         | }
    max: (a: Int, b: Int)Int
    scala> max(2, 3)
    res1: Int = 3
    

可以省略大括号的 `expression body`, 由于没有大括号作为边界，所以函数体只可能有一条表达式，而且表达式与函数签名须用等号(=) 分隔。这与 Scala 是一样的

    >>> fun max(a: Int, b: Int): Int = return if(a > b) a else b
    >>> max(3, 4)
    4

`expression body` 的 `return` 可以省去，

    >>> fun max(a: Int, b: Int): Int = if(a > b) a else b
    >>> max(3, 2)
    3

再进一步，等号与其他的表达式可以推断出返回值类型来，所以函数返回值的类型也可以省略，最后是

    >>> fun max(a: Int, b: Int) = if(a > b) a else b
    >>> max(1, 3)
    3

对于返回值类型为 `Unit` 也是一样的, `Unit` 类型返回值相当于 Java 的 `void`

    >>> fun foo(a: Int): Unit = println(a)
    >>> fun bar(a: Int) = println(a)
    >>> foo(2)
    2
    >>> bar(3)
    3

然而似乎 Kotlin 犹豫于 `block body` 是否该该省略 `return` 关键字的原因, 所以搞得函数定义一不留神的变化太多了

    >>> fun max(a: Int, b: Int): Int {  //block body, 返回值必须用 return 关键字
    ...     return if(a > b) a else b
    ... }
    >>> max(2, 3)
    3
    >>>
    >>> fun max(a: Int, b: Int): Int { //block body, 指明了返回类型，但函数体中没有 return 的话就是返回相应类型的默认值，如 String 是 null
    ...     if(a > b) a else b
    ... }
    >>> max(2, 3)
    0
    >>>
    >>> fun max(a: Int, b: Int) {  //block body, 未指明返回值类型的话，默认返回值类型是 Unit, 相当于 fun max(a: Int, b: Int): Unit
    ...     if(a > b) a else b
    ... }
    >>> max(2, 3)
    >>> val c = max(2, 3)
    >>> c
    kotlin.Unit
    >>>
    >>> fun max(a: Int, b: Int) = { //等号后跟大括号，应该要算作是 expression body 了，此处大括号代表的是一个函数, 仅仅是有没有大括号相差那么大
    ...     if(a > b) a else b
    ... }
    >>> max(2, 3)
    () -> kotlin.Int
    >>> max(2, 3)()
    3
    >>>
    >>> fun max(a: Int, b: Int) { //block body 默认返回类型为 Unit, 不能返回 Int
    ...   return if(a > b) a else b
    ... }
    error: type mismatch: inferred type is Int but Unit was expected
      return if(a > b) a else b
                       ^
    error: type mismatch: inferred type is Int but Unit was expected
      return if(a > b) a else b
                              ^
    >>> fun max(a: Int, b: Int) = { //expression body 不能用 return 来返回值
    ...     return if(a > b) a else b
    ... }
    error: 'return' is not allowed here
        return if(a > b) a else b
        ^
    error: type mismatch: inferred type is () -> [ERROR : Return not allowed] but Int was expected
        return if(a > b) a else b
               ^
    >>>
    >>> fun max(a: Int, b: Int) = { x: Int ->  //expression body 返回一个函数
    ...     val c = if(a > b) a else b
    ...     if(x > c) x else c
    ... }
    >>> max(2, 3)(5)
    5
    

在请看下面的注解说明，书写时千万不要搞混了。

相应的 Scala 的函数定义规则更简单

- 没有指定返回值，默认返回 Unit, 并省去函数签名与函数体之间的等号
- 如果指定了返回值，则必须用等号连接签名与函数体
- 函数中的 return 关键字可以省略，任何出口位置上的值都是函数可能的返回值

    scala> def max(a: Int, b: Int) {  //返回值默认为 Unit, 实现中虽有 return 关键字，但会被忽略，Scala 会在此处有警告
     |   return if(a > b) a else b
     | }
    max: (a: Int, b: Int)Unit
    scala>
    scala> def max(a: Int, b: Int): Int = {
         |   return if(a > b) a else b
         | }
    max: (a: Int, b: Int)Int
    scala> max(2, 3)
    res0: Int = 3
    scala> def max(a: Int, b: Int): Int = {
         |   if(a > b) a else b
         | }
    max: (a: Int, b: Int)Int
    scala> max(2, 3)
    res1: Int = 3
    scala>
    scala> def max(a: Int, b: Int) = {
         |   if(a > b) a else b
         | }
    max: (a: Int, b: Int)Int
    scala> max(2, 3)
    res3: Int = 3
    scala>
    scala> def foo:Int = return 23
    foo: Int
    scala> foo   //Scala 的函数，属性访问一致性原则又使得调用函数或使用属性要简单
    res4: Int = 23

Scala 不会因为在 return, 大括号，与 等号 的搭配上搞出问题来。因此在写 Kotlin 的函数时还得特别小心。

小结一下 Kotlin 定义函数的以下几个规则

- 函数签名后紧接着是大括号的是 block body
- 函数签名后紧接着是等号的是 expression body, 等号后可以直接连着大括号，代表返回又一个函数。这与 《Kotlin IN ACTION》中的定义略有不同
- 函数的默认返回值也是 Unit
- block body 中的返回值一定要用 return 关键字
- expression body 中的返回值不能用 return 关键字
- 函数采用默认 Unit 返回值，或是指定了具体返回值类型，但函数体中没有相应的 return 值，函数调用会返回该返回值类型的默认值，这是一个很容易出问题的地方

关于 return 关键字的使用本人就有点不太喜欢 Kotlin 的这种风格。
{% endraw %}
