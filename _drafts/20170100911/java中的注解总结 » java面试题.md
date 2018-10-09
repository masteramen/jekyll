---
layout: post
title:  "java中的注解总结 » java面试题"
title2:  "java中的注解总结 » java面试题"
date:   2017-01-01 23:50:11  +0800
source:  "https://www.jfox.info/java%e4%b8%ad%e7%9a%84%e6%b3%a8%e8%a7%a3%e6%80%bb%e7%bb%93.html"
fileName:  "20170100911"
lang:  "zh_CN"
published: true
permalink: "2017/java%e4%b8%ad%e7%9a%84%e6%b3%a8%e8%a7%a3%e6%80%bb%e7%bb%93.html"
---
{% raw %}
注解是java5引入的特性，在代码中插入一种注释化的信息，用于对代码进行说明，可以对包、类、接口、字段、方法参数、局部变量等进行注解。注解也叫元数据（meta data）。这些注解信息可以在编译期使用预编译工具进行处理（pre-compiler tools），也可以在运行期使用 Java 反射机制进行处理。
它主要的作用有以下四方面：

- 生成文档，通过代码里标识的元数据生成javadoc文档。

- 编译检查，通过代码里标识的元数据让编译器在编译期间进行检查验证。

- 编译时动态处理，编译时通过代码里标识的元数据动态处理，例如动态生成代码。

- 运行时动态处理，运行时通过代码里标识的元数据动态处理，例如使用反射注入实例。

一般注解可以分为三类：

- 一类是Java自带的标准注解，包括`@Override`、`@Deprecated`和`@SuppressWarnings`，分别用于标明重写某个方法、标明某个类或方法过时、标明要忽略的警告，用这些注解标明后编译器就会进行检查。

- 一类为元注解，元注解是用于定义注解的注解，包括`@Retention`、`@Target`、`@Inherited`、`@Documented`，`@Retention`用于标明注解被保留的阶段，`@Target`用于标明注解使用的范围，@Inherited用于标明注解可继承，`@Documented`用于标明是否生成javadoc文档。

- 一类为自定义注解，可以根据自己的需求定义注解，并可用元注解对自定义注解进行注解。

## 2. 注解的原理

为什么在类、方法上加一个注解，就可以通过getAnnotation()获取到申明的注解的值？
比如：

    @Test("test")
    public class AnnotationTest {
        public void test(){
        }
    }

对于注解test就可以在运行时通过AnnotationTest.class.getAnnotation(Test.class)获取注解声明的值。

1. 注解信息保存在哪儿？

2. 注解信息如何获取？

在AnnotationTest类被编译后，在对应的AnnotationTest.class文件中会包含一个RuntimeVisibleAnnotations属性，由于这个注解是作用在类上，所以此属性被添加到类的属性集上。即Test注解的键值对value=test会被记录起来。而当JVM加载AnnotationTest.class文件字节码时，就会将RuntimeVisibleAnnotations属性值保存到AnnotationTest的Class对象中，于是就可以通过AnnotationTest.class.getAnnotation(Test.class)获取到Test注解对象，进而再通过Test注解对象获取到Test里面的属性值。
这里可能会有疑问，Test注解对象是什么？其实注解被编译后的本质就是一个继承Annotation接口的接口，所以`@Test`其实就是“public interface Test extends Annotation”，当我们通过AnnotationTest.class.getAnnotation(Test.class)调用时，JDK会通过动态代理生成一个实现了Test接口的对象，并把将RuntimeVisibleAnnotations属性值设置进此对象中，此对象即为Test注解对象，通过它的value()方法就可以获取到注解值。

## 3. 四种类型注解

注解可以通过作用的类型可分为：类注解、方法注解、参数注解、变量注解。

**类注解**
访问类注解的例子：

    Class aClass = TheClass.class;
    Annotation[] annotations = aClass.getAnnotations();
    for(Annotation annotation : annotations){
        if(annotation instanceof MyAnnotation){
            MyAnnotation myAnnotation = (MyAnnotation) annotation;
            System.out.println("name: " + myAnnotation.name());
            System.out.println("value: " + myAnnotation.value());
        }
    }

此方法获取到的是该类的所有注解，也可指定某一个类：

    Class aClass = TheClass.class;
    Annotation annotation = aClass.getAnnotation(MyAnnotation.class);
    if(annotation instanceof MyAnnotation){
        MyAnnotation myAnnotation = (MyAnnotation) annotation;
        System.out.println("name: " + myAnnotation.name());
        System.out.println("value: " + myAnnotation.value());
    }

Spring中的`@Service``@Controller`即是如此。

**方法注解**

    public class TheClass {
      @MyAnnotation(name="someName",  value = "Hello World")
      public void doSomething(){}
    }

获取方法对象的指定注解：

    Method method = ... // 获取方法对象
    Annotation annotation = method.getAnnotation(MyAnnotation.class);
    if(annotation instanceof MyAnnotation){
        MyAnnotation myAnnotation = (MyAnnotation) annotation;
        System.out.println("name: " + myAnnotation.name());
        System.out.println("value: " + myAnnotation.value());
    }

SpringMVC中的`@RequestMapping`即是如此。

**参数注解**
方法的参数也可以添加注解：

    public class TheClass {
      public static void doSomethingElse(
            @MyAnnotation(name="aName", value="aValue") String parameter){
      }
    }

访问注解：

    Method method = ... //获取方法对象
    Annotation[][] parameterAnnotations = method.getParameterAnnotations();
    Class[] parameterTypes = method.getParameterTypes();
    int i=0;
    for(Annotation[] annotations : parameterAnnotations){
      Class parameterType = parameterTypes[i++];
      for(Annotation annotation : annotations){
        if(annotation instanceof MyAnnotation){
            MyAnnotation myAnnotation = (MyAnnotation) annotation;
            System.out.println("param: " + parameterType.getName());
            System.out.println("name : " + myAnnotation.name());
            System.out.println("value: " + myAnnotation.value());
        }
      }
    }

Mybatis中的`@Param`即是如此

**变量注解**
使用注解：

    public class TheClass {
      @MyAnnotation(name="someName",  value = "Hello World")
      public String myField = null;
    }

获取注解：

    Field field = ...//获取方法对象</pre>
    <pre>
    Annotation annotation = field.getAnnotation(MyAnnotation.class);
    if(annotation instanceof MyAnnotation){
     MyAnnotation myAnnotation = (MyAnnotation) annotation;
     System.out.println("name: " + myAnnotation.name());
     System.out.println("value: " + myAnnotation.value());
    }
{% endraw %}
