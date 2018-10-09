---
layout: post
title:  "Kotlin接口，你知道还能写代码吗？"
title2:  "Kotlin接口，你知道还能写代码吗？"
date:   2017-01-01 23:51:46  +0800
source:  "https://www.jfox.info/kotlin%e6%8e%a5%e5%8f%a3%ef%bc%8c%e4%bd%a0%e7%9f%a5%e9%81%93%e8%bf%98%e8%83%bd%e5%86%99%e4%bb%a3%e7%a0%81%e5%90%97%ef%bc%9f.html"
fileName:  "20170101006"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/kotlin%e6%8e%a5%e5%8f%a3%ef%bc%8c%e4%bd%a0%e7%9f%a5%e9%81%93%e8%bf%98%e8%83%bd%e5%86%99%e4%bb%a3%e7%a0%81%e5%90%97%ef%bc%9f.html"
---
{% raw %}
# Kotlin接口，你知道还能写代码吗？ 


![](/images/editorUpload/17-06/uploadImg_958671497237191.jpg)
与Java相比，Kotlin接口允许你重用更多的代码。

原因非常简单：**你能够向你的接口加代码**。如果你已经试用过Java8，这非常类似。

能够在接口中包括代码的好处在于，你能够用更强大的方式使用组合。

# Java 6的接口

# Java接口的问题是我们仅仅能描述行为，但不能实现它。

这在许多情况下，这足够了。由于我们想实现一个很好的组合时，它会强制我们将这个接口的实现委托给个别对象，这样有些情况我们就无法解决。

也使得简单的组合类代码重用相当复杂。

# Kotlin的接口

Kotlin给我们带来好消息：接口可以有代码。

这意味着我们可以实现一种多重继承（在某种程度上有限）。我们可以让一个类实现几个接口，并继承每个接口的行为。

要编写一个包含一些实现方法的接口，你不需要做任何特殊的是：

    1interface Interface1 {
    2    fun function1() {
    3         Log.d("Interface1", "function1 called")
    4    }
    5 }

另一个接口2实现另一功能：

    1interface Interface2 {
    2    fun function2() {
    3         Log.d("Interface2", "function2 called")
    4    }
    5 }

一个实现它们的类，可以同时使用这两者：

    1class MyClass : Interface1, Interface2 {
    2    fun myFunction() {
    3        function1()
    4        function2()
    5    }
    6 }

非常棒！在组织我们的代码时，这给我们提供了更多的多功能性。

# 接口不能保持状态

请记住这个很重要的限制。**我们能够在接口中添加代码，却不能有状态**。

这就是说我们不能在接口中创建属性，用来存储状态。如果我们在接口中定义了属性，实现这个接口的类就需要重写这个接口。

让我们来看一个例子。假设接口需要一个上下文：

    1interface Toaster {
    2    val context: Context
    34    fun toast(message: String) {
    5        Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
    6    }
    7 }

这段代码比较简单。这是一个实现显示Toast方法的接口。它要求上下文来做到这点。

如果我们有一个activity要用这个接口，它就需要重写这个上下文：

    1class MyActivity : AppCompatActivity(), Toaster {
    2     override val context = this34     override fun onCreate(savedInstanceState: Bundle?) {
    5super.onCreate(savedInstanceState)
    6         toast("onCreate")
    7    }
    8 }

我们将Activity本身指定为上下文，接口使用它。就这么简单。

现在，你就可以在Activity中使用Toaster函数，且无任何问题。

# 接口委托

Kotlin另一个非常有趣的特性是接口委托。它是一个非常强大的工具用来实现更清洁的组合。

假设，你有一个类C，由A和B两个类的对象组成：

     1interface A {
     2    fun functionA(){}
     3}
     4 5interface B {
     6    fun functionB(){}
     7}
     8 9class C(val a: A, val b: B) {
    10    fun functionC(){
    11        a.functionA()
    12        b.functionB()
    13    }
    14 }

类C在自己的代码中使用函数A和B。

如果对象是由其它组件组合而成的，它能够很好直接使用那些组件的函数。

这段代码还有另一种写法，可以得到相同的结果，就是用接口委托：

    1class C(a: A, b: B): A by a, B by b {
    2    fun functionC(){
    3        functionA()
    4        functionB()
    5    }
    6 }

你能够看到类C实现了A和B，但是，它实际上是委托实现给对象，以参数方式接收。

通过用接口委托，该类可以直接使用来自实现类的函数，**并且仍然将该实现委托给其他对象**。
{% endraw %}
