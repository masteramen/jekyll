---
layout: post
title:  "基于EBNF语法的描述"
title2:  "基于EBNF语法的描述"
date:   2017-01-01 23:52:56  +0800
source:  "https://www.jfox.info/%e5%9f%ba%e4%ba%8eebnf%e8%af%ad%e6%b3%95%e7%9a%84%e6%8f%8f%e8%bf%b0.html"
fileName:  "20170101076"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%9f%ba%e4%ba%8eebnf%e8%af%ad%e6%b3%95%e7%9a%84%e6%8f%8f%e8%bf%b0.html"
---
{% raw %}
# 基于EBNF语法的描述 


# 基于JavaCC的语法描述

使用JavaCC从token序列中识别出”语句” “表达式” “函数调用” 等语法单位的方法。

只要为JavaCC描述“语句” “表达式” “函数调用” 这样的语法单位各自是由怎样的token序列构成的，就能够对该语法进行分析(parse)。

例如：最简单的赋值表达式可以描述为“符号” “ “=” ” ”表达式“ 的排列。 换言之， 如果存在”符号“ ” ”=“ “ ”表达式“ 这样的排列 那就是赋值表达式。这个规则在JavaCC中表示成下面这样：

    assign(): {} { 　　<IDENTIFIER> "=" expr() } 

  assign()对应赋值表达式,<IDENTIFIER>对应token标示符，”=”对应”=”token。
像<IDENTIFIER>这样已经在扫描器中定义的token，在描述解析器时可以直接使用。其他的如”=”这样的固定字符串也因为可以表示token，所以也能在规则中使用。 另外，表达式expr()自身也是多个token构成的，这样的情况下需要进一步对expr()的规则进行描述，以下是伪描述:

    expr(): {} { expr() "+" expr() 或expr() "-" expr() 或expr() "*" expr() .. . } 

# 终端符与非终端符

JavaCC中将”语句” “函数调用” “表达式” 等非token的语法单位称为非终端符，并将非终端符像java的函数调用一样在后面加上括号写成stmt()或expr()。
终端符可以归纳为token。使用在扫描器中定义的名称，可以写成<INDENTIFIER>或<LONG>。并且JavaCC中除了扫描器中定义的token以外， “=”、”+”、”==” 这样的字符串字面量也可以作为终端符来使用
种类含义例终端符token<IDENTIFIER>、<LONG>、”=”、”==”非终端符由终端符排列组成的语法单位stmt()、expr()、assign()
在画语法时，终端符位于树的枝干的末端(终端),非终端符由于是由其他符号的列组成的，所以位于分叉处。

# JavaCC的ENBF表示法

JavaCC使用ENBF(Extended Backus-Naur-Form)的表示法来描述语法规则。下表中罗列了JavaCC的解析器生成所使用的EBNF表示法。
种类例子终端符<IDENTIFIER>或”,”非终端符name()连接<UNISGNED><LONG>重复0次或多次(“,”expr())*重复1次或多次(stmt())+选择<CHAR>丨<SHORT>丨<INT>丨<LONG>可以省略[<ELSE>stmt()]
### 1. 连接

连接是指特定符号相连续的模式。例如C语言continue语句是保留字continue和分号的排列。JavaCC中将该规则写成如下形式:

    <CONTINUE> ";" 

<CONTINUE>是表示保留字continue的终端符，“:”是表示字符自身的终端符。

### 2. 重复0次或多次

下面的写法表示0个或多个语句排列:

    (stmt())* 

下面的例子，函数的参数是由逗号分隔的表达式排列组成的，即expr之后排列着0个或多个逗号和expr的组合:

    expr() ("," expt())* 

#### 3. 重复1次或多次

    (stmt())+ 

上面的代码描述了非终端符stmt()重复1次或多次。

### 4. 选择

选择即为从多个选项中选择1个的规则。例如cflat的类型由void、char、unsigned、char等:

    <VOID> | <CHAR> | <UNSIGNED> | <CHAR> | ... 

### 5. 可以省略

定义变量时可以设置初始值也可以不设置，这种在JavaCC中可以写成:

    storage() typeref() name() ["=" expr()] ";"
{% endraw %}
