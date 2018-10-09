---
layout: post
title:  "Kotlin和Java EE: 让二者的转换更顺畅"
title2:  "Kotlin和Java EE 让二者的转换更顺畅"
date:   2017-01-01 23:57:19  +0800
source:  "https://www.jfox.info/kotlin%e5%92%8cjavaee%e8%ae%a9%e4%ba%8c%e8%80%85%e7%9a%84%e8%bd%ac%e6%8d%a2%e6%9b%b4%e9%a1%ba%e7%95%85.html"
fileName:  "20170101339"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/kotlin%e5%92%8cjavaee%e8%ae%a9%e4%ba%8c%e8%80%85%e7%9a%84%e8%bd%ac%e6%8d%a2%e6%9b%b4%e9%a1%ba%e7%95%85.html"
---
{% raw %}
翻译：mycstar 

*译者注：* 这篇文章分析了Kotlin和Java EE的关系，讨论了如何利用Kotlin的运算符，可空性和可选项来优化转换的效果。* 

将Java EE应用程序转换为Kotlin开始于框架的战斗，我们成功地超越了java老标准设置的所有障碍。在此过程中，新时代语言Kotlin特定的构造，使的代码更简洁而安全。

如果您没有阅读本系列的前两部分，可以在这里找到：

[Kotlin和Java EE：第一部分 – 从Java到Kotlin](https://www.jfox.info/go.php?url=https://dzone.com/articles/kotlin-jee-part-one-from-java-to-kotlin)

[Kotlin和Java EE：第二部分 – 插件的乐趣](https://www.jfox.info/go.php?url=https://dzone.com/articles/kotlin-and-java-ee-part-2-having-fun-with-plugins)

经过对前面两部分的回顾及修改，这里补充最后一些内容。

## 已有的转换

前两部分中的许多结构已经适用与Kotlin了。 下面我们来看看Set的定义：

    private final Set<Class<?>> classes =
           new HashSet<>(Arrays.asList(KittenRestService.class));

由于Java不支持对象列表中的Set和其他集合的简单构造，我们必须使用Arrays类来创建List，然后将其转换为Set。Kotlin里就变成：

    private val classes = setOf(KittenRestService::class.java)

我们还将Java Bean转换为Kotlin数据类，使得它们简洁了很多。去掉所有的getter和setter，并自动得到了equals（），hashCode（）和toString（）。

    @Entity
         data class KittenEntity private constructor(
                 @Id
                 var id: Int?,
                 override var name: String,
                 override var cuteness: Int // set Int.MAX_VALUE for Nermal
         ) : Kitten {
        constructor(name: String, cuteness: Int) : this(null, name, cuteness)
        }

这里要感谢编译器插件，可以伪造不变的对象，而不需要无参数的构造函数：

    @Path("kitten")
        class KittenRestService 
            @Inject constructor(private val kittenBusinessService: KittenBusinessService) {

用lateinit关键字处理那些由框架初始化的值更容易一些，可以避免不必要的空值检查：

    @Stateless
       class KittenBusinessService {
    
           @PersistenceContext
          private lateinit var entityManager: EntityManager
          ...

让我们看看还有什么可以改进的。

## 空值还是可选项？

这是一个非常棘手的问题。 Kotlin对可空值有很好的支持，当您使用第三方库时，这很有帮助。问题是当您有机会选择一个时，该使用什么？这是我们原来的Optional生产者和消费者对：

    fun find(id: Int): Optional<KittenEntity> =
            Optional.ofNullable(entityManager.find(KittenEntity::class.java, id))
    
    
        fun find(id: Int): KittenRest = 
            kittenBusinessService
               .find(id)
               .map { kittenEntity -> KittenRest(kittenEntity.name, kittenEntity.cuteness) }
               .orElseThrow { NotFoundException("ID $id not found") }

Kotlin解决方案将使用空值，所以变成：

    fun find(id: Int): KittenEntity? =
            entityManager.find(KittenEntity::class.java, id)
    
        fun find(id: Int) = 
            kittenBusinessService.find(id)
                ?.let { KittenRest(it.name, it.cuteness) }
                ?: throw NotFoundException("ID $id not found")

空值可以出现在调用链的每个步骤中，因此您必须对所有调用使用问号。这解决了可空性问题，但它不漂亮。

然而，如果返回类型为Optional，结果为Optional.empty，则将略过该对象的所有未来单调调用，结果将为Optional.empty。对我来说，这看起来是一个更干净的解决方案，如果您打算从Java调用Kotlin代码，它也是一个更安全的解决方案。对于Java互操作，优先于空值。

## 运算符！

find, add , 和 delete是完全合法的方法名称，但是不是使用运算符更好呢？

Method

Operator
service.find(id)service[id]service.add(kittenEntity)service += kittenEntity
 我发现它不只是更短，而且更可读，因为代码不再是一大堆方法调用。小心只使用知名和易理解的操作符，否则，您将会遇到像Scala库一样大的混乱，然后您将需要一个 [操作符周期表](https://www.jfox.info/go.php?url=http://www.flotsam.nl/dispatch-periodic-table.html) 。在数据存储库的情况下，类似MutableMap的接口工作得很好。请注意，我使用“plus assign”（+ =）运算符来持久化一个实体，因为原始集合包含它已经拥有的内容以及一个附加项。 

以下是如何声明它们：

    operator fun plusAssign(kitten: KittenEntity) = 
            entityManager.persist(kitten)
    
       operator fun get(id: Int): KittenEntity? = 
            entityManager.find(KittenEntity::class.java, id)

您可能希望保留原始方法，并对操作符进行包装，因为原始方法可以有返回值，而某些操作符则不能返回值。其他类似的选项是是“remove”和“contains”方法，因为它们可以用“minus assign”（ – =）和Kotlin的in运算符表示。其余的就留给你去探索。

## 结论

以惯用的方式写Kotlin代码的目的是要有更好的可读性和更安全的代码，我希望所提出的例子成功地实现了这一意图。该系列仅显示了几种方法来改进Java代码，同时使某些部分保持不变。值得探索的特点是：扩展函数，如果可能的话何时扩展，try/catch作为函数。探索一下，找出什么适合你的，玩得开心！
{% endraw %}
