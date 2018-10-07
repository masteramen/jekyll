---
layout: post
title:  "笔记：MyBatis XML配置详解"
title2:  "笔记：MyBatis XML配置详解"
date:   2017-01-01 23:50:00  +0800
source:  "http://www.jfox.info/%e7%ac%94%e8%ae%b0-mybatis-xml%e9%85%8d%e7%bd%ae%e8%af%a6%e8%a7%a3.html"
fileName:  "20170100900"
lang:  "zh_CN"
published: true
permalink: "%e7%ac%94%e8%ae%b0-mybatis-xml%e9%85%8d%e7%bd%ae%e8%af%a6%e8%a7%a3.html"
---
{% raw %}
MyBatis 的配置文件包含了影响 MyBatis 行为甚深的设置（settings）和属性（properties）信息。文档的顶层结构如下： 

- configuration 配置 
- properties 属性 
- settings 设置 
- typeAliases 类型命名 
- typeHandlers 类型处理器 
- objectFactory 对象工厂 
- plugins 插件 
- environments 环境 
- environment 环境变量 
- transactionManager 事务管理器 
- dataSource 数据源 

- databaseIdProvider 数据库厂商标识 
- mappers 映射器 

1. properties属性 
这些属性都是可外部配置且可动态替换的，既可以在典型的 Java 属性文件中配置，亦可通过 properties 元素的子元素来传递，配置示例： 

<!– resource 表示 properties 文件路径，引用该文件的 property –> 

<propertiesresource=“org/mybatis/example/config.properties”>

<propertyname=“username”value=“dev_user”/>

<propertyname=“password”value=“F2Fa3!33TYyg”/>

</properties> 

配置properties后，可以在其他配置中使用property，示例如下： 

<dataSourcetype=“POOLED”>

<propertyname=“driver”value=“${driver}”/>

<propertyname=“url”value=“${url}”/>

<propertyname=“username”value=“${username}”/>

<propertyname=“password”value=“${password}”/>

</dataSource> 

这个例子中的 username 和 password 将会由 properties 元素中设置的相应值来替换。 

如果属性在不只一个地方进行了配置，那么 MyBatis 将按照下面的顺序来加载： 

- 在 properties 元素体内指定的属性首先被读取。 
- 然后根据 properties 元素中的 resource 属性读取类路径下属性文件或根据 url 属性指定的路径读取属性文件，并覆盖已读取的同名属性。 
- 最后读取作为方法参数传递的属性，并覆盖已读取的同名属性。 

因此，通过方法参数传递的属性具有最高优先级，resource/url 属性中指定的配置文件次之，最低优先级的是 properties 属性中指定的属性 

MyBatis3.4.2增加了默认值，可以通过 ${username:ut_user} 来设置默认值，可以通过配置property来启用默认值，或者设置默认值的分隔符，如下配置： 

<!– 启用默认值 –> 

<propertyname=“org.apache.ibatis.parsing.PropertyParser.enable-default-value”value=“true”/>

<!– 设置默认值分隔符 –> 

<propertyname=“org.apache.ibatis.parsing.PropertyParser.default-value-separator”value=“:”/>

1. settings属性 
这是 MyBatis 中极为重要的调整设置，它们会改变 MyBatis 的运行时行为，完整属性及说明表可以参考[链接](82-Mybatis.one)。一个配置完整的示例如下： 

<settings> 

<!– 该配置影响的所有映射器中配置的缓存的全局开关 –>

<settingname=“cacheEnabled”value=“true”/>

<!– 延迟加载的全局开关 –>

<settingname=“lazyLoadingEnabled”value=“true”/>

<!– 是否允许单一语句返回多结果集（需要兼容驱动） –>

<settingname=“multipleResultSetsEnabled”value=“true”/>

<!– 使用列标签代替列名 –>

<settingname=“useColumnLabel”value=“true”/>

<!– 允许 JDBC 支持自动生成主键，需要驱动兼容 –>

<settingname=“useGeneratedKeys”value=“false”/>

<!– 当检测出未知列（或未知属性）时，如何处理 –>

<settingname=“autoMappingUnknownColumnBehavior”value=“WARNING”/>

<!– 配置默认的执行器 –>

<settingname=“defaultExecutorType”value=“SIMPLE”/>

<!– 设置超时时间 –>

<settingname=“defaultStatementTimeout”value=“25”/>

<!– 为驱动的结果集获取数量 –>

<settingname=“defaultFetchSize”value=“100”/>

<!– 允许在嵌套语句中使用分页 –>

<settingname=“safeRowBoundsEnabled”value=“false”/>

<!– 是否开启自动驼峰命名规则（camel case）映射,即从数据库列名 A_COLUMN 到经典 Java 属性名 aColumn 的类似映射 –>

<settingname=“mapUnderscoreToCamelCase”value=“false”/>

<!– 利用本地缓存机制 –>

<settingname=“localCacheScope”value=“SESSION”/>

<!– 当没有为参数提供特定的 JDBC 类型时，为空值指定 JDBC 类型 –>

<settingname=“jdbcTypeForNull”value=“OTHER”/>

<!– 指定哪个对象的方法触发一次延迟加载 –>

 <setting name=”lazyLoadTriggerMethods” value=”equals,clone,hashCode,toString” />

</settings> 

2. typeAliases属性 
类型别名是为 Java 类型设置一个短的名字。它只和 XML 配置有关，存在的意义仅在于用来减少类完全限定名的冗余。指定别名配置如下： 

<typeAliases> 

<typeAliasalias=“Author”type=“domain.blog.Author”/>

<typeAliasalias=“Blog”type=“domain.blog.Blog”/>

<typeAliasalias=“Comment”type=“domain.blog.Comment”/>

<typeAliasalias=“Post”type=“domain.blog.Post”/>

<typeAliasalias=“Section”type=“domain.blog.Section”/>

<typeAliasalias=“Tag”type=“domain.blog.Tag”/>

</typeAliases> 

也可以指定一个包名，MyBatis会搜索包名下面的需要的JavaBean，比如： 

<typeAliases> 

<packagename=“domain.blog”/>

</typeAliases> 

每一个在包 domain.blog 中的 Java Bean，在没有注解的情况下，会使用 Bean 的首字母小写的非限定类名来作为它的别名。 比如 domain.blog.Author 的别名为 author；若有注解，则别名为其注解值。看下面的例子： 

@Alias(“author”) 

public class Author { 

 … 

} 

已经为许多常见的 Java 类型内建了相应的类型别名。它们都是大小写不敏感的，需要注意的是由基本类型名称重复导致的特殊处理，内建相应的类型表参见[链接](82-Mybatis.one)。 

3. typeHandlers属性 
无论是 MyBatis 在预处理语句（PreparedStatement）中设置一个参数时，还是从结果集中取出一个值时， 都会用类型处理器将获取的值以合适的方式转换成 Java 类型，默认的类型处理器参考[链接](82-Mybatis.one)。可以重写类型处理器或创建自己的类型处理器来处理不支持的或非标准的类型。 具体做法为：实现 org.apache.ibatis.type.TypeHandler 接口， 或继承一个很便利的类 org.apache.ibatis.type.BaseTypeHandler， 然后可以选择性地将它映射到一个 JDBC 类型，示例代码： 

- 自定义TypeHandler 代码 
package org.mybatisExamples.simple; 

import java.sql.*; 

import org.apache.ibatis.type.BaseTypeHandler; 

import org.apache.ibatis.type.JdbcType; 

//继承基类重写方法，通过类型处理器的泛型，MyBatis 可以得知该类型处理器处理的 Java 类型 

public class StringTypeHandler extends BaseTypeHandler<String> { 

@Override

public String getNullableResult(ResultSet arg0, String arg1) throws SQLException { 

 System.out.printf(“getNullableResult arg1=%s%n”, arg1); 

return arg0.getString(arg1); 

 } 

@Override

public String getNullableResult(ResultSet arg0, int arg1) throws SQLException { 

 System.out.printf(“getNullableResult arg1=%d%n”, arg1); 

return arg0.getString(arg1); 

 } 

@Override

public String getNullableResult(CallableStatement arg0, int arg1) throws SQLException { 

 System.out.printf(“getNullableResult arg1=%d%n”, arg1); 

return arg0.getString(arg1); 

 } 

@Override

publicvoidsetNonNullParameter(PreparedStatement arg0, int arg1, String arg2, JdbcType arg3) throws SQLException { 

 System.out.printf(“Index=%d Value=%s JdbcType=%s%n”, arg1, arg2, arg3); 

 arg0.setString(arg1, arg2); 

 } 

} 

- 配置文件代码： 
<typeHandlers> 

<typeHandlerhandler=“org.mybatisExamples.simple.StringTypeHandler”/>

</typeHandlers> 

通过类型处理器的泛型，MyBatis 可以得知该类型处理器处理的 Java 类型，不过这种行为可以通过两种方法改变： 

- 在类型处理器的配置元素（typeHandler element）上增加一个 javaType 属性（比如：javaType=”String”）； 
- 在类型处理器的类上（TypeHandler class）增加一个 @MappedTypes 注解来指定与其关联的 Java 类型列表。 如果在 javaType 属性中也同时指定，则注解方式将被忽略。 

可以通过两种方式来指定被关联的 JDBC 类型： 

- 在类型处理器的配置元素上增加一个 jdbcType 属性（比如：jdbcType=”VARCHAR”）； 
- 在类型处理器的类上（TypeHandler class）增加一个 @MappedJdbcTypes 注解来指定与其关联的 JDBC 类型列表。 如果在 jdbcType 属性中也同时指定，则注解方式将被忽略。 

当决定在 <ResultMap…/> 中使用某一TypeHandler时，此时java类型是已知的（从结果类型中获得），但是JDBC类型是未知的。 因此Mybatis使用javaType=[TheJavaType], jdbcType=null的组合来选择一个TypeHandler。 这意味着使用@MappedJdbcTypes注解可以限制TypeHandler的范围，同时除非显示的设置，否则TypeHandler在ResultMap中将是无效的。 如果希望在ResultMap中使用TypeHandler，那么设置@MappedJdbcTypes注解的includeNullJdbcType=true即可。 然而从Mybatis 3.4.0开始，如果只有一个注册的TypeHandler来处理Java类型，那么它将是ResultMap使用Java类型时的默认值（即使没有includeNullJdbcType=true）。 

1. typeHandlers 属性处理枚举类型 
若想映射枚举类型 Enum，则需要从 org.apache.ibatis.type.EnumTypeHandler 或者 org.apache.ibatis.type.EnumOrdinalTypeHandler 中选一个来使用。比如说我们想存储取近似值时用到的舍入模式。默认情况下，MyBatis 会利用 EnumTypeHandler 来把 Enum 值转换成对应的名字。 

注意 EnumTypeHandler 在某种意义上来说是比较特别的，其他的处理器只针对某个特定的类，而它不同，它会处理任意继承了 Enum 的类。 

不过，我们可能不想存储名字，相反我们的 DBA 会坚持使用整形值代码。那也一样轻而易举： 在配置文件中把 EnumOrdinalTypeHandler 加到 typeHandlers 中即可， 这样每个 RoundingMode 将通过他们的序数值来映射成对应的整形，配置示例： 

<typeHandlers> 

<typeHandlerhandler=“org.apache.ibatis.type.EnumOrdinalTypeHandler”javaType=“java.math.RoundingMode”/>

</typeHandlers> 

自动映射器（auto-mapper）会自动地选用 EnumOrdinalTypeHandler 来处理， 所以如果我们想用普通的 EnumTypeHandler，就非要为那些 SQL 语句显式地设置要用到的类型处理器不可。 

2. objectFactory（对象工厂） 
MyBatis 每次创建结果对象的新实例时，它都会使用一个对象工厂（ObjectFactory）实例来完成。 默认的对象工厂需要做的仅仅是实例化目标类，要么通过默认构造方法，要么在参数映射存在的时候通过参数构造方法来实例化。 如果想覆盖对象工厂的默认行为，则可以通过创建自己的对象工厂来实现，示例代码： 

package org.mybatisExamples.simple; 

import java.util.List; 

import java.util.Properties; 

import org.apache.ibatis.reflection.factory.DefaultObjectFactory; 

@SuppressWarnings(“serial”) 

public class ExampleObjectFactory extends DefaultObjectFactory { 

@Override

public <T> T create(Class<T> type) { 

 System.out.println(“create is type=” + type.getName()); 

return super.create(type); 

 } 

@Override

public <T> T create(Class<T> type, List<Class<?>> constructorArgTypes, List<Object> constructorArgs) { 

 System.out.println(“create is type=” + type.getName()); 

return super.create(type, constructorArgTypes, constructorArgs); 

 } 

@Override

publicvoidsetProperties(Properties properties) { 

 System.out.println(“setProperties is properties=” + properties.toString()); 

super.setProperties(properties); 

 } 

} 

配置文件： 

<objectFactorytype=“org.mybatisExamples.simple.ExampleObjectFactory“>

<propertyname=“someProperty”value=“100”/>

</objectFactory> 

3. 插件（plugins） 
MyBatis 允许你在已映射语句执行过程中的某一点进行拦截调用。默认情况下，MyBatis 允许使用插件来拦截的方法调用包括： 

- Executor接口的方法 update, query, flushStatements, commit, rollback, getTransaction, close, isClosed 
- ParameterHandler接口的方法getParameterObject, setParameters 
- ResultSetHandler接口的方法 handleResultSets, handleOutputParameters 
- StatementHandler 接口的方法prepare, parameterize, batch, update, query 

这些类中方法的细节可以通过查看每个方法的签名来发现，或者直接查看 MyBatis 的发行包中的源代码。 假设你想做的不仅仅是监控方法的调用，那么你应该很好的了解正在重写的方法的行为。 因为如果在试图修改或重写已有方法的行为的时候，你很可能在破坏 MyBatis 的核心模块。 这些都是更低层的类和方法，所以使用插件的时候要特别当心。通过 MyBatis 提供的强大机制，使用插件是非常简单的，只需实现 Interceptor 接口，并指定了想要拦截的方法签名即可，示例代码： 

@Intercepts({@Signature( 

 // type：表示需要拦截的上面列出的接口 

 type= Executor.class, 

 // method：表示拦截接口的方法 

 method = “update”, 

 // args：表示拦截方法的参数 

 args = {MappedStatement.class,Object.class})}) 

public class ExamplePlugin implements Interceptor { 

 // 执行拦截对象的方法 invocation.proceed 表示执行原始方法 

public Object intercept(Invocation invocation) throws Throwable { 

return invocation.proceed(); 

 } 

 // 将目标对象增加拦截器 

public Object plugin(Object target) { 

return Plugin.wrap(target, this); 

 } 

 // 设置拦截器的属性 

publicvoidsetProperties(Properties properties) { 

 } 

} 

配置文件： 

<plugins> 

<plugininterceptor=“org.mybatis.example.ExamplePlugin”>

<propertyname=“someProperty”value=“100”/>

</plugin>

</plugins> 

1. 配置环境（environments） 
MyBatis 可以配置成适应多种环境，这种机制有助于将 SQL 映射应用于多种数据库之中， 现实情况下有多种理由需要这么做。例如，开发、测试和生产环境需要有不同的配置；或者共享相同 Schema 的多个生产数据库， 想使用相同的 SQL 映射。许多类似的用例。 

不过要记住：尽管可以配置多个环境，每个 SqlSessionFactory 实例只能选择其一。 

所以，如果你想连接两个数据库，就需要创建两个 SqlSessionFactory 实例，每个数据库对应一个。而如果是三个数据库，就需要三个实例，依此类推，记起来很简单： 

- 每个数据库对应一个 SqlSessionFactory 实例 

为了指定创建哪种环境，只要将它作为可选的参数传递给 SqlSessionFactoryBuilder 即可。可以接受环境配置的两个方法签名是： 

SqlSessionFactory factory = newSqlSessionFactoryBuilder().build(reader, environment); 

SqlSessionFactory factory = newSqlSessionFactoryBuilder().build(reader, environment,properties); 

如果忽略了环境参数，那么默认环境将会被加载，如下所示： 

 SqlSessionFactory factory = newSqlSessionFactoryBuilder().build(reader); 

 SqlSessionFactory factory = newSqlSessionFactoryBuilder().build(reader,properties); 

环境元素定义了如何配置环境，配置示例如下： 

<environmentsdefault=“development”>

<environmentid=“development”>

<transactionManagertype=“JDBC”>

<propertyname=“…”value=“…”/>

</transactionManager>

<dataSourcetype=“POOLED”>

<propertyname=“driver”value=“${driver}”/>

<propertyname=“url”value=“${url}”/>

<propertyname=“username”value=“${username}”/>

<propertyname=“password”value=“${password}”/>

</dataSource>

</environment>

</environments> 

注意这里的关键点: 

- 默认的环境 ID（比如:default=”development”）。 
- 每个 environment 元素定义的环境 ID（比如:id=”development”）。 
- 事务管理器的配置（比如:type=”JDBC”）。 
- 数据源的配置（比如:type=”POOLED”）。 

默认的环境和环境 ID 是一目了然的。随你怎么命名，只要保证默认环境要匹配其中一个环境ID 

1. 事务管理器（transactionManager） 
在 MyBatis 中有两种类型的事务管理器（也就是 type=”[JDBC|MANAGED]”）： 

- JDBC – 这个配置就是直接使用了 JDBC 的提交和回滚设置，它依赖于从数据源得到的连接来管理事务作用域。 
- MANAGED – 这个配置几乎没做什么。它从来不提交或回滚一个连接，而是让容器来管理事务的整个生命周期（比如 JEE 应用服务器的上下文）。 默认情况下它会关闭连接，然而一些容器并不希望这样，因此需要将 closeConnection 属性设置为 false 来阻止它默认的关闭行为。例如: 
<transactionManagertype=“MANAGED”>

<propertyname=“closeConnection”value=“false”/>

</transactionManager> 

这两种事务管理器类型都不需要任何属性。它们不过是类型别名，换句话说，你可以使用 TransactionFactory 接口的实现类的完全限定名或类型别名代替它们。 

public interface TransactionFactory { 

voidsetProperties(Properties props); 

 Transaction newTransaction(Connection conn); 

 Transaction newTransaction(DataSource dataSource, TransactionIsolationLevel level, boolean autoCommit); 

} 

任何在 XML 中配置的属性在实例化之后将会被传递给 setProperties() 方法。你也需要创建一个 Transaction 接口的实现类，这个接口也很简单： 

public interface Transaction { 

 Connection getConnection() throws SQLException; 

voidcommit() throws SQLException; 

voidrollback() throws SQLException; 

voidclose() throws SQLException; 

 Integer getTimeout() throws SQLException; 

} 

使用这两个接口，你可以完全自定义 MyBatis 对事务的处理。 

1. 数据源（dataSource） 
dataSource 元素使用标准的 JDBC 数据源接口来配置 JDBC 连接对象的资源。 

许多 MyBatis 的应用程序将会按示例中的例子来配置数据源。然而它并不是必须的。要知道为了方便使用延迟加载，数据源才是必须的。 

有三种内建的数据源类型（也就是 type=”[UNPOOLED|POOLED|JNDI]”）： 

- UNPOOLED– 这个数据源的实现只是每次被请求时打开和关闭连接。虽然一点慢，它对在及时可用连接方面没有性能要求的简单应用程序是一个很好的选择。 不同的数据库在这方面表现也是不一样的，所以对某些数据库来说使用连接池并不重要，这个配置也是理想的。UNPOOLED 类型的数据源仅仅需要配置以下 5 种属性： 
- driver – 这是 JDBC 驱动的 Java 类的完全限定名（并不是JDBC驱动中可能包含的数据源类）。 
- url – 这是数据库的 JDBC URL 地址。 
- username – 登录数据库的用户名。 
- password – 登录数据库的密码。 
- defaultTransactionIsolationLevel – 默认的连接事务隔离级别。 

作为可选项，你也可以传递属性给数据库驱动。要这样做，属性的前缀为”driver.”，例如： 

这将通过DriverManager.getConnection(url,driverProperties)方法传递值为 UTF8 的 encoding 属性给数据库驱动。 

- POOLED– 这种数据源的实现利用”池”的概念将 JDBC 连接对象组织起来，避免了创建新的连接实例时所必需的初始化和认证时间。 这是一种使得并发 Web 应用快速响应请求的流行处理方式。 除了上述提到 UNPOOLED 下的属性外，会有更多属性用来配置 POOLED 的数据源： 
- poolMaximumActiveConnections – 在任意时间可以存在的活动（也就是正在使用）连接数量，默认值：10 
- poolMaximumIdleConnections – 任意时间可能存在的空闲连接数。 
- poolMaximumCheckoutTime – 在被强制返回之前，池中连接被检出（checked out）时间，默认值：20000 毫秒（即 20 秒） 
- poolTimeToWait – 这是一个底层设置，如果获取连接花费的相当长的时间，它会给连接池打印状态日志并重新尝试获取一个连接（避免在误配置的情况下一直安静的失败），默认值：20000 毫秒（即 20 秒）。 
- poolPingQuery – 发送到数据库的侦测查询，用来检验连接是否处在正常工作秩序中并准备接受请求。默认是”NO PING QUERY SET”，这会导致多数数据库驱动失败时带有一个恰当的错误消息。 
- poolPingEnabled – 是否启用侦测查询。若开启，也必须使用一个可执行的 SQL 语句设置 poolPingQuery 属性（最好是一个非常快的 SQL），默认值：false。 
- poolPingConnectionsNotUsedFor – 配置 poolPingQuery 的使用频度。这可以被设置成匹配具体的数据库连接超时时间，来避免不必要的侦测，默认值：0（即所有连接每一时刻都被侦测 — 当然仅当 poolPingEnabled 为 true 时适用）。 

通过需要实现接口 org.apache.ibatis.datasource.DataSourceFactory ， 也可使用任何第三方数据源： 

public interface DataSourceFactory { 

voidsetProperties(Properties props); 

 DataSource getDataSource(); 

} 

org.apache.ibatis.datasource.unpooled.UnpooledDataSourceFactory 可被用作父类来构建新的数据源适配器，比如下面这段插入 C3P0 数据源所必需的代码： 

import org.apache.ibatis.datasource.unpooled.UnpooledDataSourceFactory; 

import com.mchange.v2.c3p0.ComboPooledDataSource; 

public class C3P0DataSourceFactory extends UnpooledDataSourceFactory { 

publicC3P0DataSourceFactory() { 

this.dataSource = newComboPooledDataSource(); 

 } 

} 

为了令其工作，为每个需要 MyBatis 调用的 setter 方法中增加一个属性。下面是一个可以连接至 MySQL数据库的例子： 

<dataSource type=“org.myproject.C3P0DataSourceFactory”> 

 <property name=”driverClass” value=”com.mysql.jdbc.driver”/> 

 <property name=”jdbcUrl” value=”jdbc:mysql//localhost:3306/mydb”/> 

 <property name=”user” value=”dev”/> 

 <property name=”password” value=”liyong”/> 

</dataSource>
{% endraw %}
