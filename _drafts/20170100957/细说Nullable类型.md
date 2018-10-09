---
layout: post
title:  "细说Nullable类型"
title2:  "细说Nullable类型"
date:   2017-01-01 23:50:57  +0800
source:  "https://www.jfox.info/%e7%bb%86%e8%af%b4nullable-t-%e7%b1%bb%e5%9e%8b.html"
fileName:  "20170100957"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e7%bb%86%e8%af%b4nullable-t-%e7%b1%bb%e5%9e%8b.html"
---
{% raw %}
众所周知，值类型变量不能null，这也是为什么它们被称为值类型。但是，在实际的开发过程中，也需要值为`null`的一些场景。例如以下场景：

　　场景1：您从数据库表中检索可空的整数数据列，数据库中的`null`值没有办法将此值分配给C#中Int32类型；

　　场景2：您在UI绑定属性，但是某些值类型的字段不是必须录入的（例如在人员管理中的死亡日期）；

　　场景3：在Java中，`java.Util.Date`是一个引用类型，因此可以将此类型的字段设置为`null`。但是，在CLR中，`System.DateTime`是一个值类型，DateTime 变量不能`null`。如果使用Java编写的应用程序要将日期/时间传达给在CLR上运行的Web服务，如果Java应用程序发送是`null`， CLR中没有供对应的类型；

　　场景4：在函数中传递值类型时，如果参数的值无法提供并且不想传递，可以使用默认值。但有时默认值并不是最佳的选择，因为默认值实际也传递了一个默认的参数值，逻辑需要特殊的处理；

　　场景5：当从xml或json反序列化数据时，数据源中缺少某个值类型属性的值，这种情况很不方便处理。

　　当然，我们日常工作中还有很多类似的情况。

　　为了摆脱这些情况，Microsoft在CLR中增加了可为空值类型的概念。为了更清楚理解这一点，我们看一下`System.Nullable<T>`类型的逻辑定义：
![](/wp-content/uploads/2017/06/ContractedBlock4.gif)![](/wp-content/uploads/2017/06/ExpandedBlockStart4.gif)
     1namespace System
     2{
     3    [Serializable]
     4publicstruct Nullable<T> where T : struct 5    {
     6privatebool hasValue;
     7internal T value;
     8 9public Nullable(T value) {
    10this.value = value; 
    11this.hasValue = true;
    12        }
    1314publicbool HasValue { 
    15get {
    16return hasValue; 
    17            } 
    18        }
    1920public T Value { 
    21get {
    22if (!HasValue) { 
    23                    ThrowHelper.ThrowInvalidOperationException(ExceptionResource.InvalidOperation_NoValue); 
    24                }
    25return value; 
    26            }
    27        }
    2829public T GetValueOrDefault() { 
    30return value;
    31        } 
    3233public T GetValueOrDefault(T defaultValue) {
    34return HasValue ? value : defaultValue;
    35        } 
    3637publicoverridebool Equals(object other) { 
    38if (!HasValue) return other == null; 
    39if (other == null) returnfalse;
    40return value.Equals(other); 
    41        }
    4243publicoverrideint GetHashCode() {
    44return HasValue ? value.GetHashCode() : 0; 
    45        }
    4647publicoverridestring ToString() { 
    48return HasValue ? value.ToString() : "";
    49        } 
    5051publicstaticimplicitoperator Nullable<T>(T value) {
    52returnnew Nullable<T>(value);
    53        } 
    5455publicstaticexplicitoperator T(Nullable<T> value) { 
    56return value.Value; 
    57        }
    58    }
    59 } 

查看Nullable的定义
　　从上面的定义可以总结如下几点：

- Nullable<T> 类型也是一个值类型；
- Nullable<T> 类型包含一个Value属性用于表示基础值，还包括一个`Boolean`类型的HasValue属性用于表示该值是否为`null` ；
- Nullable<T> 是一个轻量级的值类型。Nullable<T>类型的实例占用内存的大小等于一个值类型与一个`Boolean`类型占用内存大小之和；
- Nullable<T> 的泛型参数T必须是值类型。您只能将Nullable<T>类型与值类型结合使用，您也可以使用用户定义的值类型。

## 二、语法和用法

　　使用Nullable<T>类型，只需指定一个其它值类型的泛型参数T。

　　示例：　

    1     Nullable<int> i = 1;
    2     Nullable<int> j = null;
    3     Nullable<Nullable<int>> k; //这是一个错误语法，编译会报错。

　　CLR还提供了一种简写的方式。

    1int? i = 1;
    2int? j = null;

　　可以通过 Value 属性来获取基础类型的值。如下所示，如果不为`null`，则将返回实际的值，否则将抛出`InvalidOperationException`异常；您可以在调用Value属性的时，需要检查是否为`null`。

     1     Nullable<int> i = 1;
     2     Nullable<int> j = null;
     3 4    Console.WriteLine(i.HasValue);
     5//输出结果：True 6 7    Console.WriteLine(i.Value);
     8//输出结果：1 910    Console.WriteLine(j.HasValue);
    11//输出结果：False1213    Console.WriteLine(j.Value);
    14//抛异常： System.InvalidOperationException    

## 三、类型的转换和运算

　　C#还支持简单的语法来使用Nullable<T>类型。它还支持Nullable<T>实例的隐式转换和转换。如下示例演示：

     1// 从System.Int32隐式转换为Nullable<Int32>  2int? i = 5;
     3 4// 从'null'隐式转换为Nullable<Int32>  5int? j = null;
     6 7// 从Nullable<Int32>到Int32的显式转换 8int k = (int)i;
     910// 基础类型之间的转换11     Double? x = 5; // 从Int到Nullable<Double> 的隐式转换12     Double? y = j; // 从Nullable<Int32> 隐式转换Nullable<Double>

　　对Nullable<T> 类型使用操作符，与包含的基础类型使用方法相同。

- 一元运算符（++、–、 – 等），如果Nullable<T>类型值是`null`时，返回`null`；
- 二元运算符（+、-、*、/、％、^等）任何操作数是`null`，返回`null`；
- 对于==运算符，如果两个操作数都是`null`，则表达式计算结果为`true`，如果任何一个操作数是`null`，则表达式计算结果为false；如果两者都不为`null`，它照常比较。
- 对于关系运算符（>、<、>=、<=），如果任何一个操作数是`null`，则运算结果是`false`，如果操作数都不为`null`，则比较该值。

　　见下面的例子：　　

     1int? i = 5;
     2int? j = null;
     3 4// 一元运算符 5     i++; // i = 6  6     j = -j; // j = null
     7 8// 二元运算符 9     i = i + 3; // i = 9 10     j = j * 3; // j = null;
    1112// 等号运算符（==、!=）13var r = i == null; //r = false14     r = j == null; //r = true15     r = i != j; //r = true
    1617// 比较运算符（<、>、<=、>=）18     r = i > j; //r = false1920     i = null;
    21     r = i >= j; //r = false，注意，i=null、j=null，但是>=返回的结果是false

　　Nullable<T>也可以像引用类型一样，支持三元操作符。

    1// 如果雇员的年龄返回null（出生日期可能未输入），请设置值0. 2int age = employee.Age ?? 0;
    34// 在聚合函数中使用三元操作符。5int?[] numbers = {};
    6int total = numbers.Sum() ?? 0;

## 四、装箱与拆箱

　　我们已经知道了Nullable<T>是一个值类型，现在我们再来聊一聊它的装箱与拆箱。
CLR采用一个特殊的规则来处理Nullable<T>类型的装箱与拆箱。当一个Nullable<T>类型的实例装箱时，CLR会检查实例的HasValue属性：如果是`true`，则将实例Value属性的值进行装箱后返回结果；如果返回`false`，则直接返回`null`，不做任何的处理。
在拆箱处理时，与装箱处反。CLR会检查拆箱的对象是否为`null`，如果是直接创建一个新的实例 new Nullable<T>()，如果不为`null`，则将对象拆箱为类型T，然后创建一个新实例 new Nullable<T>(t)。 

     1int? n = null;
     2object o = n; //不会进行装箱操作，直接返回null值 3 4     Console.WriteLine("o is null = {0}", object.ReferenceEquals(o, null));
     5//输出结果：o is null = True 6 7 8     n = 5;
     9     o = n; //o引用一个已装箱的Int321011     Console.WriteLine("o's type = {0}", o.GetType());
    12//输出结果：o's type = System.Int321314     o = 5;
    1516//将Int32类型拆箱为Nullable<Int32>类型17int? a = (Int32?)o; // a = 5 
    18//将Int32类型拆箱为Int32类型19int b = (Int32)o; // b = 5
    2021// 创建一个初始化为null22     o = null;
    23// 将null变为Nullable<Int32>类型24     a = (Int32?)o; // a = null 25     b = (Int32)o; // 抛出异常：NullReferenceException

## 五、GetType()方法

　　当调用Nullable<T>类型的`GetType()`方法时，CLR实际返回类型的是泛型参数的类型。因此，您可能无法区分Nullable<Int32>实例上是一个Int32类型还是Nullable<Int32>。见下面的例子：

    1int? i = 10;
    2    Console.WriteLine(i.GetType());
    3//输出结果是：System.Int3245     i = null;
    6     Console.WriteLine(i.GetType()); //NullReferenceException

　　原因分析：

　　这是因为调用`GetType()`方法时，已经将当前实例进行了装箱，根据上一部分装箱与拆箱的内容，这里实际上调用的是Int32类型的`GetType()`方法。

　　调用值类型的`GetType()`方法时，均会产生装箱，关于这一点大家可以自己去验证。

## 六、ToString()方法

 　　当调用Nullable<T>类型的`ToString()`方法时，如果HasValue属性的值为`false`，则返回`String.Empty`，如果该属性的值为`true`，则调用的逻辑是`Value.ToString()`。 见下面的例子：

    1int? i = 10;
    2    Console.WriteLine(i.ToString());
    3//输出结果：1045     i = null;
    6     Console.WriteLine(i.ToString() == string.Empty);
    7//输出结果：True

## 七、System.Nullable帮助类

 　　微软还提供一个同名`System.Nullable`的静态类，包括三个方法： 

     1publicstaticclass Nullable
     2{
     3//返回指定的可空类型的基础类型参数。 4publicstatic Type GetUnderlyingType(Type nullableType);
     5 6//比较两个相对值 System.Nullable<T> 对象。 7publicstaticint Compare<T>(T? n1, T? n2) where T : struct 8 9//指示两个指定 System.Nullable<T> 对象是否相等。10publicstaticbool Equals<T>(T? n1, T? n2) where T : struct11 }

　　在这里面我们重点说明一下`GetUnderlyingType(Type nullableType)`方法，另外两个方法是用来比较值的，大家可以自己研究。

`GetUnderlyingType(Type nullableType)`方法是用来返回一个可为空类型的基础类型，如果 `nullableType` 参数不是一个封闭的Nullable<T>泛型，则反回`null`。 

     1     Console.WriteLine(Nullable.GetUnderlyingType(typeof(Nullable<int>)));
     2//输出结果：System.Int32 3 4     Console.WriteLine(Nullable.GetUnderlyingType(typeof(Nullable<>)) == null);
     5//输出结果：True 6 7     Console.WriteLine(Nullable.GetUnderlyingType(typeof(int)) == null);
     8//输出结果：True 910     Console.WriteLine(Nullable.GetUnderlyingType(typeof(string)) == null);
    11//输出结果：True

## 八、语法糖

 　　微软对Nullable<T>提供了丰富的语法糖来减少开发员的工作量，下面是我想到供您参考。
**简写****编译后的语句**
     1int? i = 5;
     2 3int? j = null;
     4 5var r = i != null;
     6 7var v = (int) i;
     8 9     i++;
    1011     i = i + 3;
    1213     r = i != j;
    1415     r = i >= j;
    1617var k = i + j;
    1819double? x = 5;
    2021double? y = j;

     1int? i = newint?(5);
     2 3int? j = newint?();
     4 5var r = i.HasValue;
     6 7var v = i.Value;
     8 9     i = i.HasValue ? newint?(i.GetValueOrDefault() + 1) : newint?();
    1011     i = i.HasValue ? newint?(i.GetValueOrDefault() + 3) : newint?();
    1213     r = i.GetValueOrDefault() != j.GetValueOrDefault() || i.HasValue != j.HasValue;
    1415     r = i.GetValueOrDefault() >= j.GetValueOrDefault() && i.HasValue & j.HasValue;
    1617int? k = i.HasValue & j.HasValue ? newint?(i.GetValueOrDefault() + j.GetValueOrDefault()) : newint?();
    1819double? x = newdouble?((double) 5);
    2021double? y = j.HasValue ? newdouble?((double) j.GetValueOrDefault()) : newdouble?();
{% endraw %}
