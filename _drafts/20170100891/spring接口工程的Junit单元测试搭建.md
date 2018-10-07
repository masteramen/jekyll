---
layout: post
title:  "spring接口工程的Junit单元测试搭建"
title2:  "spring接口工程的Junit单元测试搭建"
date:   2017-01-01 23:49:51  +0800
source:  "http://www.jfox.info/spring%e6%8e%a5%e5%8f%a3%e5%b7%a5%e7%a8%8b%e7%9a%84junit%e5%8d%95%e5%85%83%e6%b5%8b%e8%af%95%e6%90%ad%e5%bb%ba.html"
fileName:  "20170100891"
lang:  "zh_CN"
published: true
permalink: "spring%e6%8e%a5%e5%8f%a3%e5%b7%a5%e7%a8%8b%e7%9a%84junit%e5%8d%95%e5%85%83%e6%b5%8b%e8%af%95%e6%90%ad%e5%bb%ba.html"
---
{% raw %}
**引言**

前段时间对我们系统进行了微服务化拆分，最终出现几个单独的纯接口工程（没有web界面）；最近又在搞一个基于国际化的纯接口转换工程。这些工程都有一个共同的特点，就是没有web界面，只是单纯的对外提供服务。没有界面，对应研发人员来说，很难进行自测。

以前我们研发的自测方式无非就两种：1、把接口工程部署到测试环境，在调用方的测试环境页面上进行测试；2、自己开发一个servlet的测试界面，进行测试。第一种方式，无法进行断点联调；第二种方式工作量大，需要为每个接口开发单独的页面，但这些页面对业务来说又没啥用。

基于以上原因，准备通过JUnit+spring bean的装配方式，搭建一个适用于纯接口工程的测试demo工程 给新同事作为参考。简单的说最终的效果就是要求不启动接口工程，采用非侵入的方式，就可以实现JUnit测试方法调用。这里所谓的非侵入，指的是不要影响业务代码。

本章所有示例代码，都已上传GitHub，地址详见文章结尾。

**spring bean装配方式**

由于我们的接口工程都是采用的spring作为Bean容器搭建的，要想使用Junit单元测试，就必须把所有相关的bean先进行装配，在测试方法调用前 被注入到spring容器。也就是说要为接口工程实现Junit单元测试，最主要的就是要自己实现bean的装配。这里有一定的工作量，所以很多系统都不愿去做。但如果设计得好，形成一个模式，就可以在各个接口工程中复用。

首先我们来分析下Spring提供的三种bean装配机制：

1、显式XML装配：在XML中进行显示的配置。这种方式一般是用在对jdbc连接池的配置，以及外部依赖接口的配置。还有一些老系统采用的老版本的spring，这些老系统基本都是采用的XMl配置的方式。

2、隐式自动装配：隐式的bean发现机制和自动装配。这是spring目前比较推崇的方式，目前对于我们内部能控制的业务bean都是采用的这种自动装配方式。但对于依赖参数或者外部bean，无法进行自动装配，我们系统一般采用的是第1种XML配置方式。其实这种情况spring更推崇我们使用第3种方式。

3、显式java装配：在java中进行显示的配置。这种方式在我们系统中目前基本没有使用，但相比第1种方式会更加灵活，spring也推荐我们使用这种方式。

由于不同的适用场景，以及不同开发人员的习惯，我们的接口工程中可能同时存在这三类装配方式。我们的首要工作就是要在执行JUnit单元测试方法之前，把这些通过不同装配方式的bean自动注入到容器。下面分别对整合这三类方式进行讲解

**整合“隐式自动装配”**

Spring的隐式自动装配有两种形式：java、xml，java方式比较灵活可以分为三种，对应隐式自动装配的方式大致如下：

下面我们分别对每种方式的使用简单讲解，再运用到Junit单元测试创建中。

**1、基于java****注解**：@ComponentScan标记，标记在扫描类上（非业务类）。三种典型的使用方式：

a、@ComponentScan不带参数：会扫描该被标记类根目录、以及所有子目录下bean类，并把扫描到的所有包含@Component标记的bean类自动装配并注入容器。这种方式侵入性，会在业务代码目录下创建一个扫描类，尽量避免使用，如下的UserServiceConfig类，只是为了扫描使用，类体为空：

    @ComponentScan
    public class UserServiceConfig {
    }

所在目录为：

所在的目录中UserService为接口类跳过，子目录中UserServiceImpl类被Component标记，会被扫描到，进行自动装配，UserServiceImpl代码如下：

    @Component("us")
    public class UserServiceImpl implements UserService {
        @Autowired(required = false)
        private UserDao userDao;
        @Override
        public void add() {
            if (userDao != null){
                userDao.add();
            }
            System.out.println("service层:用户添加成功");
        }
    }

在test包（不会被maven打入部署包中）创建Junit测试代码类UserServiceTest，代码如下：

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(classes=UserServiceConfig.class)
    public class UserServiceTest {
        @Autowired
        private UserService us;
        @Test
        public void usNullTest(){
            Assert.notNull(us);
            us.add();
        }
    }
     

@RunWith(SpringJUnit4ClassRunner.class)，指定使用Junit4与spring一起使用。

@ContextConfiguration(classes=UserServiceConfig.class)，指定spring自动装配路径为UserServiceConfig的跟目录，及其子目录。

执行Junit的usNullTest方法，打印信息为：

    service层:用户添加成功

说明UserServiceImpl自动装配成功，但是它依赖的UserDao没有被注入。

类似的我们可以在UserDao所在的根目录创建一个UserDaoConfig，并标记为@ComponentScan。

把@ContextConfiguration(classes={UserServiceConfig.class,UserDaoConfig.class})添加到junit测试类中：

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(classes={UserServiceConfig.class,UserDaoConfig.class})
    public class UserServiceTest {
        @Autowired
        private UserService us;
        @Test
        public void usNullTest(){
            Assert.notNull(us);
            us.add();
        }
    }

再次执行usNullTest测试方法，打印信息为：

    dao层:用户添加成功
    service层:用户添加成功

说明UserDao被自动装配到UserServiceImpl中，并注入到容器。该方法的Junit单元测试方法创建并测试通过，并无需部署和启动程序就可以完成测试。这里的add测试方法比较简单，正常的业务，可以还需手动传入各种不同的参数，对该方法进行测试。

但这种方法有个弊端，就是需要在每个业务bean跟目录下去创建一个配置扫描类，对业务有侵入性，而且创建配置扫描类多个也非常麻烦。在创建Junit单元测试时，你可以在test包中创建一个跟业务包相同的包路径，并把扫描类放到该路径下，可以减少侵入性，比如上述UserServiceConfig扫描类可以这样创建：

但各个子工程模块test包中的代码是彼此不可见的，所有还是有一定局限。

b、@ComponentScan(basePackages = {“com.xx1″,”com.xx2”,”com.xx3”}) 带basePackages参数，采用这种配置方式，可以完全做到非侵入式：扫描类可以创建在test包中，由Packages指定需要扫描的路径。这是我个人非常建议的方式，具体操作只需要在test包中创建一个PackageScaner类（业务代码包中不会再有扫描类），代码如下：

    @Configuration
    @ComponentScan("com.sky.locale")
    public class PackageAllScaner {
    }

再创建一个全面的Junit测试类（不建议一个系统就建一个测试类，实际根据具体业务进行拆分）AllAutoServiceTest，代码如下：

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(classes=PackageAllScaner.class)
    public class AllAutoServiceTest {
        @Autowired
        private UserService us;
        @Autowired
        private ProductService ps;
        @Autowired
        private OrderService os;
        @Test
        public void usNullTest(){
            Assert.notNull(us);
            us.add();
            Assert.notNull(ps);
            ps.add();
            Assert.notNull(os);
            os.add();
        }
    }

运行测试方法，打印结果如下：

    dao层:用户添加成功
    service层:用户添加成功
    dao层:商品添加成功
    service层:商品添加成功
    dao层:订单添加成功
    service层:订单添加成功

说明所有包下的自动装配都注入成功并测试通过，实际开发中不建议把多个测试写在一个测试方法，根据具体业务调整。

C、@ComponentScan(basePackageClasses = {xxx1.class, xxx2.class })指定basePackageClasses参数：这种方式可以扫描指定xxx1、xxx2类所在的目录及其子目录下被@Component标记bean，并进行自动装配。相比第二种方式，该扫描类也可以创建在test包中，在一定程度上没有侵入性。但如果需要扫描的目录下没有类，就需要自己创建一个空类作为基准，个人不是很推荐。如果一定要创建：可以在test包下创建以一个跟业务包完全相同的路径，并在该路径下创建扫描类。具体使用方式：

扫描类：

@ComponentScan(basePackageClasses = {ServiceScan.class})

public class ClassScaner {

}

ServiceScan类在test包下，上述代码会扫描业务包com.sky.locle.service中所有带@Component标记的bean：

Junit测试类：

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(classes=ClassScaner.class)
    public class UserServiceTest {
        //这里就不写测试方法了，感兴趣的可以自己尝试下
    }

如果待扫描的目录下存在业务类，可以使用，否则需要自己创建一个空的扫描类，具有侵入性，这时不建议使用。

“隐式自动装配”基于java的@ComponentScan标记的三种方式就将完了。总结下，我们做非侵入的Junit单元测试，最好选择第二种指定package方式@ComponentScan(basePackages = {“com.xx1″,”com.xx2”,”com.xx3”})

**2、XMl****配置：**基于XML配置实现的“隐式自动装配”配置方式为：<context:component-scan base-package=”com.xxx” />。在实际开发中，我们经常使用的方式，效果等同于java注解的第二种方式：@ComponentScan(basePackages = {“com.xxx”})。

我们在写Junit单元测试时，不需要创建自己的xml配置文件，如果一定要创建可以在test包下，防止侵入业务代码。但我们可以在Junit测试代码中直接引用已有的xml配置文件。

假如，业务代码中已存在一个xml bean配置文件，内容如下：

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:context="http://www.springframework.org/schema/context"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
                               http://www.springframework.org/schema/beans/spring-beans.xsd
                               http://www.springframework.org/schema/context
                                http://www.springframework.org/schema/context/spring-context.xsd">
        <context:component-scan base-package="com.sky.locale.service.product" />
        <context:component-scan base-package="com.sky.locale.dao.product" />
    </beans>

我们Junit测试类可以直接引入使用：

    @RunWith(SpringJUnit4ClassRunner.class)
    @ContextConfiguration(locations = {"classpath:spring-test.xml"})
    public class XmlAutoServiceTest {
        @Autowired
        private ProductService ps;
        @Test
        public void usNullTest(){
            Assert.notNull(ps);
            ps.add();
        }
    }

执行测试方法，打印信息为：

    dao层:商品添加成功
    service层:商品添加成功

测试通过，基于“隐式自动装配”这种方式的Junit单元测试创建方式讲解结束。

**整合“显式XML装配****”**

显式XML装配在spring 2.5以前版本里大量使用。现在一些无法自动装配的bean也会选择使用这种方式，比如配置jdbc连接池以及外部依赖的接口。我们现在常用jdbc配置方式是，把jdbc参数信息放到.properties配置文件中，然后通过XMl装配的方式注入到容器中。

首先我们先看下常用的XML装配方式：

1、不带id的方式：

    <!-- 不指定id，默认id为：com.sky.locale.service.explicit.impl.ExplicitTestServiceImpl#0 -->
           <bean class="com.sky.locale.dao.explicit.impl.ExplicitTestDaoImpl" />

2、带id方式：

    <bean id="explicitTestDao" class="com.sky.locale.dao.explicit.impl.ExplicitTestDaoImpl" />

3、构造方法方式，成员为引用，使用ref；成员为基础类型，使用value。

    <bean id="explicitTestService" class="com.sky.locale.service.explicit.impl.ExplicitTestServiceImpl">
                  <constructor-arg name="explicitTestDao" ref="explicitTestDao"/>
           </bean>
     

4、构造方法c命令空间方式，构造方法方式的简化版：

    <bean id="explicitTestService1" class="com.sky.locale.service.explicit.impl.ExplicitTestServiceImpl"
                 c:explicitTestDao-ref="explicitTestDao" />
     

5、settter方式：

    <!-- setter注入-->
           <bean id="explicitTestService2" class="com.sky.locale.service.explicit.impl.ExplicitTestServiceImpl">
                  <property name="explicitTestDao" ref="explicitTestDao"/>
                  <property name="name" value="123"/>
                  <property name="books">
                         <list>
                                <value>monkeys</value>
                                <value>pigs</value>
                         </list>
                  </property>
           </bean>

6、setter对应的p命名空间方式：

    <!-- p 命名空间注入 -->
           <bean id="explicitTestService3" class="com.sky.locale.service.explicit.impl.ExplicitTestServiceImpl"
                   p:explicitTestDao-ref="explicitTestDao"
                   p:name="123">
                  <property name="books">
                         <list>
                                <value>monkeys</value>
                                <value>pigs</value>
                         </list>
                  </property>
           </bean>

对于这种list，set等集合成员，还可以单独提取出来，变形成这样：

    <!-- 使用util:list把list转移出去 -->
           <bean id="explicitTestService5" class="com.sky.locale.service.explicit.impl.ExplicitTestServiceImpl"
                 p:explicitTestDao-ref="explicitTestDao"
                 p:name="123"
                 p:books-ref="books">
           </bean>
           <util:list id="books">
                  <value>monkeys</value>
                  <value>pigs</value>
           </util:list>

这种提取，同样适用于c命令空间。

对于这种方式的整合到Junit，其实前面已经用到，直接在Junit测试类中指定对应的xml即可：@ContextConfiguration(locations = {“classpath:xxxx.xml”})。这里我们以Junit整合一个jdbc数据源为例进行讲解，首先看下需要装配的数据源类TestJdbcSo
{% endraw %}
