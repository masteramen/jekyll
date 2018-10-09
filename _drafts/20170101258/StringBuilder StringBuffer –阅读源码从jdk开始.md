---
layout: post
title:  "StringBuilder StringBuffer –阅读源码从jdk开始"
title2:  "StringBuilder StringBuffer –阅读源码从jdk开始"
date:   2017-01-01 23:55:58  +0800
source:  "https://www.jfox.info/stringbuilderstringbuffer%e9%98%85%e8%af%bb%e6%ba%90%e7%a0%81%e4%bb%8ejdk%e5%bc%80%e5%a7%8b.html"
fileName:  "20170101258"
lang:  "zh_CN"
published: true
permalink: "2017/stringbuilderstringbuffer%e9%98%85%e8%af%bb%e6%ba%90%e7%a0%81%e4%bb%8ejdk%e5%bc%80%e5%a7%8b.html"
---
{% raw %}
**引言**

最近我的同事分享了一个页面渲染过程中，字符串拼接的优化处理。我们系统的页面渲染是分模块渲染，每个模块渲染完成后都是一个String型的html片段，最终我们需要把所有模块的html片段拼接成一个完整html页面。老代码逻辑大致如下：

            List<String> moudleHtmls = new ArrayList<>(moduleSize);
            for(int i=0;i<moduleSize;i++){
                String tempHtml = null;
                //模块内容渲染 省略代码
                moudleHtmls.set(i, tempHtml);//把每个模块html片段放入List
            }
           
            String pageString="";
            for (int i=0;i <moduleSize; i++){
                pageString+=moudleHtmls.get(i);//遍历把所有模块的html片段拼接成一个页面
            }

通过反编译发现第二个for循环，每次拼接操作都会自动生成一个StringBuilder对象，反编译的代码如下（第二个for循环部分）：

            String pageString="";
            for (int i=0;i <moduleSize; i++){
                pageString=new StringBuilder().append(pageString).append(moudleHtmls.get(i)).toString();
            }
     

每次for循环都会生成一个StringBuilder，其默认容量为16，超过16又需要自动扩容（后面源码详细讲解），势必会影响性能。改进后的代码如下：

    StringBuilder pageString = new StringBuilder(pageTemplate.length * 2);//预估页面长度
    for (int i=0;i <moduleSize; i++){
                pageString.append(moudleHtmls.get(i));//遍历把所有模块的html片段拼接成一个页面
            }

通过对比发现改造后的拼接性能大幅提升。我们系统每天都有上百万次的页面渲染，这个小小的改动带来的收益是可想而知的。

为了对StringBuilder有更深入的了解，决定阅读其相关源码，做一次全面的总结。

**字符串连接的三种方式**

1、字符串连接操作符（+），是把多个字符串合并为一个字符串的便利途径。

2、StringBuilder，创建该类对象，调用其append方法实现字符串连接，从jdk1.5开始支持。

3、StringBuffer，用法和StringBuilder相同，从jdk1.0就开始支持。

通过阅读源码发现StringBuilder、StringBuffer都是继承自AbstractStringBuilder，方式实现也是基本相同，只是StringBuffer的每个方式都是synchronized修饰的，也就是说StringBuffer适合使用在多线程并发环境下的字符串拼接。单线程环境下使用StringBuilder的性能会更好些。

String t=“123”+“456”；

这种方式每次执行，本质上是创建一个新String，然后把两个String的的内容复制到这个新String，性能非常差。但从jdk1.5开始，该操作做了优化，执行过程中会自动new 一个StringBuilder，真实的执行过程变为：String t=new StringBuilder().append(“123”).append(“456”)。

也就是说在拼接后的字符串总长度比较短的情况下（总长度不超过16），直接使用“(+)”符号拼接是最佳选择。

如果拼接后的字符串总长度大于16，最好新建一个指定预估容量的StringBuilder，调用其append方法进行拼接。如上述优化中：

StringBuilder pageString = new StringBuilder(pageTemplate.length * 2);//预估页面长度

另外如果在for循环中也不建议直接使用(+)操作，因为这会导致每次循环都会新创建一个StringBuilder，如上述优化中主要就是优化这个问题。

为什么要指定StringBuilder容量，其实跟ArrayList、HashMap等原理相同，都存在自动扩容的问题，看下源码就一目了然。

**StringBuilder、StringBuffer、AbstractStringBuilder 源码解析**

StringBuilder、StringBuffer都是继承自AbstractStringBuilder抽象类，每个方法的实现基本相同，都是调用AbstractStringBuilder中的方法。唯一的差异，就是toString方法，方法也是AbstractStringBuilder中唯一的抽象方法。

成员变量是一个char性的数组，StringBuilder、StringBuffer的所有操作基本都是围绕这个数组进行：

    char[] value;//在AbstractStringBuilder中定义

该字符数组在StringBuilder、StringBuffer的初始默认容量都是16，方法操作完全相同，以StringBuilder为例：

    //默认构造方法
    public StringBuilder() {
            super(16);//默认容量
    }
    //指定容量构造方法
    public StringBuilder(int capacity) {
            super(capacity);
    }
    //指定初始字符串构造方法
    public StringBuilder (String str) {
            super(str.length() + 16); //初始容量为字符串长度+16
            append(str);
    }
    

这里通过super调用AbstractStringBuilder的构造方法：

    AbstractStringBuilder(int capacity) {
            value = new char[capacity];//指定数组容量，初始化字节数组
    }

成员变量字节数组value初始化完成。

**append系列重载方法**

AbstractStringBuilder中的append系列重载方法（StringBuilder、StringBuffer 中的append方法通过super直接调用该系列方法），是其核心方法，可以处理处理所有的基础类型（比如boolean、int、long、double等）、引用类型的拼接（String、Object、AbstractStringBuilder自身等），这里以用得最多的append(String)进行讲解：

    public AbstractStringBuilder append(String str) {
            if (str == null)
                return appendNull();//注意如果为str为null，会拼接一个"null"字符串
            int len = str.length();
            ensureCapacityInternal(count + len);//判断容量是否足够，如不够先扩容，再copy到新扩容后的数组
            str.getChars(0, len, value, count);//把str copy到 字符数组中
            count += len;//重新计算字符数组总长度
            return this;
        }
     
    private void ensureCapacityInternal(int minimumCapacity) {
            // overflow-conscious code
            if (minimumCapacity - value.length > 0)
                expandCapacity(minimumCapacity);//容量不够，进行扩容
        }
       
        void expandCapacity(int minimumCapacity) {
            int newCapacity = value.length * 2 + 2;//扩容两倍 + 2
            if (newCapacity - minimumCapacity < 0)
                newCapacity = minimumCapacity;
            if (newCapacity < 0) {//溢出处理
                if (minimumCapacity < 0) // overflow
                    throw new OutOfMemoryError();
                newCapacity = Integer.MAX_VALUE;
            }
            value = Arrays.copyOf(value, newCapacity); //把老数据复制到扩容后的新数组。
        }
     

StringBuilder、StringBuffer的字符串拼接，实际上就是把待拼接的字符串，放到自己的字符数组，如果字符数组的容量不够，需要进行扩容。具体操作是新创建一个字符数组（容量为老数组的2倍+2），再把老数组中的内容copy到新数组。这就是为什么在拼接大量字符串（拼接后超过长度16），最好采用指定容量的方式创建StringBuilder（或StringBuffer），防止拼接过程中不断扩容带来的性能消耗。

**toString方法**

需要注意的是StringBuilder、StringBuffer不是String类型，不能强制转换。只能通过调用其toString方法转换为String。前面已经提到StringBuilder、StringBuffer重要区别就是toString方法的实现不同。

StringBuilder的toString方法，采用自己成员变量value字符数组新建一个String：

    @Override
        public String toString() {
            // Create a copy, don't share the array
            return new String(value, 0, count);
    }
     

StringBuffer的toString方法：

    public synchronized String toString() {
            if (toStringCache == null) {
                toStringCache = Arrays.copyOfRange(value, 0, count);//缓存成员变量value字符数组
            }
            return new String(toStringCache, true);
    }
     

其中toStringCache主要用作缓存。当StringBuffer对成员变量value字符数组有修改时，需要先清理缓存，如StringBuffer的append(String)方法实现：

    @Override
        public synchronized StringBuffer append(String str) {
            toStringCache = null;//清理缓存
            super.append(str);//调用父类AbstractStringBuilder的append方法
            return this;
        }
     

再来看下StringBuilder的append(String)方法实现：

    @Override
        public StringBuilder append(String str) {
            super.append(str);
            return this; //调用父类AbstractStringBuilder的append方法
    }
     

区别有两点：

1、StringBuffer的方法是synchronized修饰。

2、StringBuffer的方法需要清理缓存。

StringBuilder、StringBuffer的append系列方法不再一一讲解，具体操作都差不多，把待拼接类型转换中字符，依次放到其成员变量value字符数组中。

**其他方法：**

AbstractStringBuilder的delete方法，本质上也是对字符数组的copy操作：

    public AbstractStringBuilder delete(int start, int end) {
            if (start < 0)
                throw new StringIndexOutOfBoundsException(start);
            if (end > count)
                end = count;
            if (start > end)
                throw new StringIndexOutOfBoundsException();
            int len = end - start;
            if (len > 0) {
                System.arraycopy(value, start+len, value, start, count-end);//本质上先复制到一个临时数组，再覆盖原数组 无内存泄漏问题
                count -= len;
            }
            return this;
        }
     

AbstractStringBuilder的insert系列方法，这里以String为例：

    public AbstractStringBuilder insert(int offset, String str) {
            if ((offset < 0) || (offset > length()))
                throw new StringIndexOutOfBoundsException(offset);
            if (str == null)
                str = "null";
            int len = str.length();
            ensureCapacityInternal(count + len);//确认容量
            System.arraycopy(value, offset, value, offset + len, count - offset);//通过复制预留出待插入空间
            str.getChars(value, offset);//copy字符串 到指定开始位置
            count += len;
            return this;
        }

举个列子:在“hello!”字符串中插入“pig”字符串，形成“hellopig!”, java代码如下：

    StringBuilder sb = new StringBuilder；
    sb.append(“hello!”)
    sb.insert(4,“pig”);

对应的示意图：

![](/wp-content/uploads/2017/07/1500041303.png)

AbstractStringBuilder的reverse方法，本质上就是把字符数组里每个字符反序排列，不在累述。

最后总结下：

1、拼接完成的字符串长度短的情况下，直接使用(+)操作符即可：如String t = “123”+”456”。

2、不要在for循环中使用(+)操作符，使用StringBuilder代替。

3、单线程环境下，使用StringBuilder拼接一个比较长的字符串，最好先预估容量，采用指定容量的StringBuilder构造方法，构造StringBuilder实例。

4、多线程环境下使用StringBuffer。
{% endraw %}
