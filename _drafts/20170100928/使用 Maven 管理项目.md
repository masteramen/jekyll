---
layout: post
title:  "使用 Maven 管理项目"
title2:  "使用 Maven 管理项目"
date:   2017-01-01 23:50:28  +0800
source:  "http://www.jfox.info/%e4%bd%bf%e7%94%a8-maven-%e7%ae%a1%e7%90%86%e9%a1%b9%e7%9b%ae.html"
fileName:  "20170100928"
lang:  "zh_CN"
published: true
permalink: "%e4%bd%bf%e7%94%a8-maven-%e7%ae%a1%e7%90%86%e9%a1%b9%e7%9b%ae.html"
---
{% raw %}
最近的练手项目使用的是 Maven 在管理项目，在使用 Maven 管理项目时，三层的开发时分模块开发的，parent-dao-service-web，所有的spring+struts + Hibernate的依赖都是加在 parent 上，dao-service-web都是作为子模块，在模块之间的关系处理的时候出现了几个问题：

1. junit测试包的传递依赖失效了
2. 多个配置文件的读取问题

 我在 parent 工程没有添加 Junit 的依赖，在编写 dao 模块是添加了 Junit 的 jar 包，理所当然的在 scope 中写了 test 范围，但是在 service 模块中进行 Junit 测试时，显示没有依赖上 Junit 包，那是为什么呢？百度了才想通，原来是 service 依赖的 dao 模块的 install 之后的 jar 包，当 dao 模块 install 时，scope 为 test 的 Junit包当然没有被发布出来，service中也就不能传递依赖到 Junit了，这样的解决办法只能在 service 中添加 Junit 包的依赖。

 因为采取的是模块式的开发，spring的配置文件就被分布在各个模块中了，在测试项目时需要读取多个模块中的 spring 配置文件时，使用到了之前没有使用到的一个注解：

@ContextConfiguration(locations={“classpath*:applicationContext-*.xml”}) 这个注解中的*号通配符表示会加载本模块和依赖的jar包中的类路径下的applicationContext-开头的配置文件（只有spring配置文件才会这样命名）

    //@ContextConfiguration(locations={"classpath*:applicationContext-*.xml"})
    @ContextConfiguration(locations={"classpath:applicationContext-dao.xml","classpath:applicationContext-service.xml"})
    @RunWith(SpringJUnit4ClassRunner.class)
    publicclass CustomerServiceImplTest {
        @Autowired
        private CustomerService customerService;
        @Test
        publicvoid test() {
            Customer customer = customerService.findById(1L);
            System.out.println("********************"+customer.getCustName());
        }
    }
{% endraw %}
