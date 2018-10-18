---
layout: post
title:  "核心技术"
title2:  "Core Technologies"
date:   2018-10-18 15:49:09  +0800
source:  "https://docs.spring.io/spring/docs/5.1.1.RELEASE/spring-framework-reference/core.html#beans-dependencies"
fileName:  "6ffd6bd"
lang:  "en"
published: false

---
{% raw %}
Letting qualifier values select against target bean names, within the type-matching candidates, does not require a `@Qualifier` annotation at the injection point. If there is no other resolution indicator (such as a qualifier or a primary marker), for a non-unique dependency situation, Spring matches the injection point name (that is, the field name or parameter name) against the target bean names and choose the same-named candidate, if any.
在类型匹配候选者中，根据目标bean名称选择限定符值，不需要a`@Qualifier` 注入点注释。如果没有其他解析指示符（例如限定符或主标记），则对于非唯一依赖性情况，Spring会将注入点名称（即字段名称或参数名称）与目标bean名称进行匹配，然后选择同名的候选人，如果有的话。(zh_CN)

That said, if you intend to express annotation-driven injection by name, do not primarily use `@Autowired`, even if it is capable of selecting by bean name among type-matching candidates. Instead, use the JSR-250 `@Resource` annotation, which is semantically defined to identify a specific target component by its unique name, with the declared type being irrelevant for the matching process. `@Autowired` has rather different semantics: After selecting candidate beans by type, the specified `String` qualifier value is considered within those type-selected candidates only (for example, matching an `account` qualifier against beans marked with the same qualifier label).
也就是说，如果您打算按名称表达注释驱动注入，请不要主要使用`@Autowired`, 即使它能够在类型匹配候选者中通过bean名称进行选择。相反，使用JSR-250`@Resource` 注释，在语义上定义为通过其唯一名称标识特定目标组件，声明的类型与匹配过程无关。`@Autowired` 具有相当不同的语义：按类型选择候选bean后，指定`String` 限定符值仅在那些类型选择的候选者中被考虑（例如，匹配`account` 针对标有相同限定符标签的bean的限定符）。(zh_CN)

For beans that are themselves defined as a collection, `Map`, or array type, `@Resource` is a fine solution, referring to the specific collection or array bean by unique name. That said, as of 4.3, collection, you can match `Map`, and array types through Spring’s `@Autowired` type matching algorithm as well, as long as the element type information is preserved in `@Bean` return type signatures or collection inheritance hierarchies. In this case, you can use qualifier values to select among same-typed collections, as outlined in the previous paragraph.
对于自身定义为集合的bean，`Map`, 或数组类型，`@Resource` 是一个很好的解决方案，通过唯一名称引用特定的集合或数组bean。也就是说，截至4.3，收藏，你可以匹配`Map`, 和Spring的数组类型`@Autowired` 类型匹配算法也是如此，只要保留元素类型信息即可`@Bean` 返回类型签名或集合继承层次结构。在这种情况下，您可以使用限定符值在相同类型的集合中进行选择，如上一段所述。(zh_CN)

As of 4.3, `@Autowired` also considers self references for injection (that is, references back to the bean that is currently injected). Note that self injection is a fallback. Regular dependencies on other components always have precedence. In that sense, self references do not participate in regular candidate selection and are therefore in particular never primary. On the contrary, they always end up as lowest precedence. In practice, you should use self references as a last resort only (for example, for calling other methods on the same instance through the bean’s transactional proxy). Consider factoring out the effected methods to a separate delegate bean in such a scenario. Alternatively, you can use `@Resource`, which may obtain a proxy back to the current bean by its unique name.
截至4.3，`@Autowired` 也考虑自我引用注入（即，引用回到当前注入的bean）。请注意，自我注入是一种后备。对其他组件的常规依赖性始终具有优先权。从这个意义上说，自我引用并不参与常规的候选人选择，因此特别是不是主要的。相反，它们总是最低优先级。在实践中，您应该仅使用自引用作为最后的手段（例如，通过bean的事务代理调用同一实例上的其他方法）。考虑在这种情况下将受影响的方法分解为单独的委托bean。或者，您可以使用`@Resource`, 它可以通过其唯一名称获取代理回到当前bean。(zh_CN)

`@Autowired` applies to fields, constructors, and multi-argument methods, allowing for narrowing through qualifier annotations at the parameter level. By contrast, `@Resource` is supported only for fields and bean property setter methods with a single argument. As a consequence, you should stick with qualifiers if your injection target is a constructor or a multi-argument method.
`@Autowired` 适用于字段，构造函数和多参数方法，允许在参数级别缩小限定符注释。相比之下，`@Resource` 仅支持具有单个参数的字段和bean属性setter方法。因此，如果您的注入目标是构造函数或多参数方法，则应该使用限定符。(zh_CN)
{% endraw %}
