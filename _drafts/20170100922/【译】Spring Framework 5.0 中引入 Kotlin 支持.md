---
layout: post
title:  "【译】Spring Framework 5.0 中引入 Kotlin 支持"
title2:  "【译】Spring Framework 5.0 中引入 Kotlin 支持"
date:   2017-01-01 23:50:22  +0800
source:  "https://www.jfox.info/%e8%af%91-spring-framework-5-0-%e4%b8%ad%e5%bc%95%e5%85%a5-kotlin-%e6%94%af%e6%8c%81.html"
fileName:  "20170100922"
lang:  "zh_CN"
published: true
permalink: "2017/%e8%af%91-spring-framework-5-0-%e4%b8%ad%e5%bc%95%e5%85%a5-kotlin-%e6%94%af%e6%8c%81.html"
---
{% raw %}
## 用 Kotlin 进行函数式 bean 注册

Spring Framework 5.0 引入了一种新的方式来注册 bean：使用 lambda 表达式作为 XML 方式或者用 `@Configuration` 与 `@Bean` 的 JavaConfig 方式的替代。 简而言之，它能够用 `Supplier` lambda 表达式充当 `FactoryBean` 来注册 Bean。

例如在 Java 中你这么写：

    GenericApplicationContextcontext=newGenericApplicationContext();context.registerBean(Foo.class);context.registerBean(Bar.class,()->newBar(context.getBean(Foo.class)));

而在 Kotlin 中，具体化的类型参数可以让我们简写为：

    valcontext=GenericApplicationContext{registerBean<Foo>()registerBean{Bar(it.getBean<Foo>())}}

`ApplicationContext` 相关的 Kotlin 扩展有 [BeanFactoryExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-beans/src/main/kotlin/org/springframework/beans/factory/BeanFactoryExtensions.kt)、 [ListableBeanFactoryExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-beans/src/main/kotlin/org/springframework/beans/factory/ListableBeanFactoryExtensions.kt)、 [GenericApplicationContextExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-context/src/main/kotlin/org/springframework/context/support/GenericApplicationContextExtensions.kt) 以及 [AnnotationConfigApplicationContextExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-context/src/main/kotlin/org/springframework/context/annotation/AnnotationConfigApplicationContextExtensions.kt)。

## Spring Web 函数式 API，Kotlin 的方式

Spring Framework 5.0 附带了一个 Kotlin 路由 DSL，允许你以干净、惯用的 Kotlin 代码来利用最近宣布的 [Spring 函数式 Web API](https://www.jfox.info/go.php?url=https://spring.io/blog/2016/09/22/new-in-spring-5-functional-web-framework)：

    {("/blog"andaccept(TEXT_HTML)).route{GET("/",this@BlogController::findAllView)GET("/{slug}",this@BlogController::findOneView)}("/api/blog"andaccept(APPLICATION_JSON)).route{GET("/",this@BlogController::findAll)GET("/{id}",this@BlogController::findOne)}}

感谢 Yevhenii Melnyk 的早期原型与帮助！你可以参见一个使用 [函数式 web API](https://www.jfox.info/go.php?url=https://github.com/mix-it/mixit/blob/master/src/main/kotlin/mixit/controller/BlogController.kt) 的 Spring Boot 应用程序的具体示例，该示例在 [https://github.com/mix-it/mixit/](https://www.jfox.info/go.php?url=https://github.com/mix-it/mixit/)。

## 利用 Kotlin 的可空性信息

原本基于 [Raman Gupta](https://www.jfox.info/go.php?url=https://github.com/rocketraman) 的社区贡献，Spring 现在利用 [Kotlin 空安全支持](https://www.jfox.info/go.php?url=https://www.kotlincn.net/docs/reference/null-safety.html)来确定某个 HTTP 参数是否必需，而无需明确定义 `required` 属性。 这意味着 `@RequestParam name: String?` 会被视为非必需而 `@RequestParam name: String` 视为必需。 Spring Messaging 的 `@Header` 注解也支持这点。

类似地，以 `@Autowired` 或者 `@Inject` 注入的 Spring bean 使用这一信息来获悉一个 bean 是必需还是非必需。 `@Autowired lateinit var foo: Foo` 意味着在应用程序上下文中必须注册一个类型为 `Foo` 的 bean，而对于 `@Autowired lateinit var foo: Foo?` 则在这样的 bean 不存在时并不会引发错误。

## 用于 RestTemplate 与函数式 Web API 的扩展

例如，[Kotlin 具体化的类型参数](https://www.jfox.info/go.php?url=https://www.kotlincn.net/docs/reference/inline-functions.html#%E5%85%B7%E4%BD%93%E5%8C%96%E7%9A%84%E7%B1%BB%E5%9E%8B%E5%8F%82%E6%95%B0)为 JVM [泛型类型擦除](https://www.jfox.info/go.php?url=https://docs.oracle.com/javase/tutorial/java/generics/erasure.html)提供了一种解决方法，因此我们引入了一些扩展来利用这一优势尽可能提供更好的 API。

这允许为 `RestTemplate` 提供便利的 API（感谢 Netflix 的 [Jon Schneider](https://www.jfox.info/go.php?url=https://github.com/jkschneider) 对此贡献）。 例如，要在 Java 中检索 `Foo` 对象的列表，你不得不这样写：

    List<Foo>result=restTemplate.exchange(url,HttpMethod.GET,null,newParameterizedTypeReference<List<Foo>>(){}).getBody();

或者，如果你使用一个中间的数组：

    List<Foo>result=Arrays.asList(restTemplate.getForObject(url,Foo[].class));

而用 Spring Framework 5 扩展，在 Kotlin 中，你可以这样够写：

    valresult:List<Foo>=restTemplate.getForObject(url)

Spring Framework 5.0 中提供的 Web API 的 Kotlin 扩展有 [RestOperationsExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-web/src/main/kotlin/org/springframework/web/client/RestOperationsExtensions.kt)、[ServerRequestExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-web-reactive/src/main/kotlin/org/springframework/web/reactive/function/server/ServerRequestExtensions.kt)、 [BodyInsertersExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-web-reactive/src/main/kotlin/org/springframework/web/reactive/function/BodyInsertersExtensions.kt)、 [BodyExtractorsExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-web-reactive/src/main/kotlin/org/springframework/web/reactive/function/BodyExtractorsExtensions.kt)、[ClientResponseExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-web-reactive/src/main/kotlin/org/springframework/web/reactive/function/client/ClientResponseExtensions.kt)、 [ModelExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-context/src/main/kotlin/org/springframework/ui/ModelExtensions.kt) 以及 [ModelMapExtensions](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/blob/master/spring-context/src/main/kotlin/org/springframework/ui/ModelMapExtensions.kt)。

这些扩展还提供了支持 Kotlin 原生 `KClass` 的成员函数，允许你指定 `Foo::class` 参数而不是 `Foo::class.java`。

## Reactor Kotlin 扩展

[Reactor](https://www.jfox.info/go.php?url=https://projectreactor.io/) 是 Spring Framework 5.0 所基于的响应式基础，而在开发响应式 web 应用程序时，你会有很好的机会去使用其 [Mono](https://www.jfox.info/go.php?url=https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Mono.html)、 [Flux](https://www.jfox.info/go.php?url=https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html) 以及 [StepVerifier](https://www.jfox.info/go.php?url=https://projectreactor.io/docs/test/release/api/reactor/test/StepVerifier.html) API。

所以如今我们还通过新的 [reactor-kotlin 扩展](https://www.jfox.info/go.php?url=https://github.com/reactor/reactor-kotlin-extensions) 项目在 Reactor 中引入 Kotlin 支持！ 它提供了能够通过任何类实例这样写 `foo.toMono()` 来创建 `Mono` 实例的扩展，当然很多人倾向于使用 `Mono.just(foo)`。 它也支持例如通过 `stream.toFlux()` 从 Java 8 `Stream` 实例创建 `Flux`。 还提供了 `Iterable`、 `CompletableFuture` 与 `Throwable` 扩展以及 `KClass` 基于 Reactor API 的变体。

目前该项目还在早期阶段，所以如果你发现缺了点什么，不妨[贡献](https://www.jfox.info/go.php?url=https://github.com/reactor/reactor-kotlin-extensions/pulls)自己的扩展。

## 不再需要将你的 bean 类声明为 open

当目前为止，当你使用 Kotlin 构建 Spring Boot 应用程序时遇到的少数痛点之一就是，需要为每个由 CGLIB 如 `@Configuration` 类代理的 Spring bean 类及其成员函数添加 `open` 关键字。 这一要求的根本原因源于 Kotlin 中[类是默认 final](https://www.jfox.info/go.php?url=https://discuss.kotlinlang.org/t/classes-final-by-default/166) 的事实。

幸运的是，Kotlin 1.0.6 现在提供了一个 `kotlin-spring` 插件，对于由以下注解之一标注或元标注（meta-annotated）的类，会默认打开该类及其成员函数：

- `@Component`
- `@Async`
- `@Transactional`
- `@Cacheable`

元注解支持意味着用 `@Configuration`、 `@Controller`、 `@RestController`、 `@Service` 或者 `@Repository` 标注的类会自动打开，鉴于这些注解都已被 `@Component` 注解元标注。

我们已经更新了 [start.spring.io](https://www.jfox.info/go.php?url=http://start.spring.io/#!language=kotlin) 默认启用了该插件。 你可以看下[这篇 Kotlin 1.0.6 的博文](https://www.jfox.info/go.php?url=https://blog.jetbrains.com/kotlin/2016/12/kotlin-1-0-6-is-here/)了解更多详情，其中包括对 Spring Data 实体非常有用的新的 `kotlin-jpa` 与 `kotlin-noarg` 插件。

## 基于 Kotlin 的 Gradle 构建配置

去年 5 月份，Gradle [宣布](https://www.jfox.info/go.php?url=https://blog.gradle.org/kotlin-meets-gradle) 除了支持 Groovy 外，他们还将支持用 Kotlin 编写构建及配置文件。 这使在 IDE 中完整的自动补齐与验证成为可能，因为这些文件都是普通的静态类型的 Kotlin 脚本文件。 这可能会成为基于 Kotlin 的项目的自然选择，但这对 Java 项目也同样有价值。

自去年 5 月以来，[gradle-script-kotlin](https://www.jfox.info/go.php?url=https://github.com/gradle/gradle-script-kotlin) 项目不断演进，现在已经可用，请记住以下两条警告：

- 你需要 Kotlin 1.1-EAP IDEA 插件来获取自动补齐功能（但是如果你要用 `kotlin-spring` 插件就要等到 Kotlin `1.1-M05` 因为 `1.1-M04` 不能与该插件一起可靠运转） 
   
   
【译注】：目前 1.1 已发布，该问题已不存在。

- 其文档不够完整，但是 Gradle 团队对 Kotlin Slack 的 #gradle 频道帮助很大。

[spring-boot-kotlin-demo](https://www.jfox.info/go.php?url=https://github.com/sdeleuze/spring-boot-kotlin-demo) 以及 [mixit](https://www.jfox.info/go.php?url=https://github.com/mix-it/mixit/) 项目都使用这种基于 Kotlin 的 Gradle 构建，所以不妨看看。 我们在[讨论](https://www.jfox.info/go.php?url=https://github.com/spring-io/initializr/issues/334)在 start.spring.io 上添加了这项支持。

## 基于模版的 Kotlin 脚本

从 4.3 版开始，Spring 框架提供了一个 [ScriptTemplateView](https://www.jfox.info/go.php?url=http://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/servlet/view/script/ScriptTemplateView.html)，它使用支持 [JSR-223](https://www.jfox.info/go.php?url=https://www.jcp.org/en/jsr/detail?id=223) 的脚本引擎来渲染模版，而 Spring Framework 5.0 会更进一步支持 [i18n 以及模版嵌套](https://www.jfox.info/go.php?url=https://jira.spring.io/browse/SPR-15064)。 Kotlin 1.1 提供了这样的支持，并允许渲染基于 Kotlin 的模板，详见[这次提交](https://www.jfox.info/go.php?url=https://github.com/spring-projects/spring-framework/commit/badde3a479a53e1dd0777dd1bd5b55cb1021cf9e)。

这带来了一些有趣的使用场景，例如使用 [kotlinx.html](https://www.jfox.info/go.php?url=https://github.com/Kotlin/kotlinx.html) DSL 或者简单使用带有内插的 Kotlin 多行 `String`来编写类型安全的模版，如这个 [kotlin-script-templating](https://www.jfox.info/go.php?url=https://github.com/sdeleuze/kotlin-script-templating) 项目所示。 这可以让你在 IDE 中用完整的自动补齐与重构支持来编写这种模板：

    importio.spring.demo.*""" ${include("header")} <h1>${i18n("title")}</h1> <ul> ${users.joinToLine{ "<li>${i18n("user")} ${it.firstname} ${it.lastname}</li>" }} </ul> ${include("footer")} """
{% endraw %}
