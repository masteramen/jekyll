---
layout: post
title:  "sbc(二)高可用Eureka+声明式服务调用"
title2:  "sbc(二)高可用Eureka+声明式服务调用"
date:   2017-01-01 23:57:54  +0800
source:  "https://www.jfox.info/sbc%e4%ba%8c%e9%ab%98%e5%8f%af%e7%94%a8eureka%e5%a3%b0%e6%98%8e%e5%bc%8f%e6%9c%8d%e5%8a%a1%e8%b0%83%e7%94%a8.html"
fileName:  "20170101374"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/sbc%e4%ba%8c%e9%ab%98%e5%8f%af%e7%94%a8eureka%e5%a3%b0%e6%98%8e%e5%bc%8f%e6%9c%8d%e5%8a%a1%e8%b0%83%e7%94%a8.html"
---
{% raw %}
这次会按照实际生产要求来搭建这套服务。

## Swagger应用

 上次提到我们调用自己的 `http` 接口的时候采用的是 `PostMan` 来模拟请求，这个在平时调试时自然没有什么问题，但当我们需要和前端联调开发的时候效率就比较低了。 

#### 通常来说现在前后端分离的项目一般都是后端接口先行。

后端大大们先把接口定义好(入参和出参),前端大大们来确定是否满足要求，可以了之后后端才开始着手写实现，这样整体效率要高上许多。

但也会带来一个问题:在接口定义阶段频繁变更接口定义而没有一个文档或类似的东西来记录，那么双方的沟通加上前端的调试都是比较困难的。

 基于这个需求网上有各种解决方案，比如阿里的rap就是一个不错的例子。 

 但是 `springCould` 为我们在提供了一种在开发 `springCloud` 项目下更方便的工具 `swagger` 。 

实际效果如下:
![](/wp-content/uploads/2017/07/1500647517.png) 
 
   01.png 
  
 

## 配置swagger

 以 `sbc-order` 为例我将项目分为了三个模块: 

    ├── order                                    // Order服务实现  
    │   ├── src/main
    ├── order-api                                // 对内API
    │   ├── src/main
    ├── order-client                             // 对外的clientAPI
    │   ├── src/main
    ├── .gitignore                               
    ├── LICENSE                
    ├── README.md

 因为实现都写在 `order` 模块中，所以只需要在该模块中配置即可。 

 首先需要加入依赖，由于我在 `order` 模块中依赖了: 

    <dependency>
        <groupId>com.crossoverJie</groupId>
        <artifactId>order-api</artifactId>
        <version>${target.version}</version>
    </dependency>

`order-api` 又依赖了： 

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <scope>compile</scope>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
        <scope>compile</scope>
    </dependency>

 接着需要配置一个 `SwaggerConfig`

    @Configuration
    @EnableSwagger2
    /** 是否打开swagger **/
    @ConditionalOnExpression("'${swagger.enable}' == 'true'")
    public class SwaggerConfig {
    
    
        @Bean
        public Docket createRestApi() {
            return new Docket(DocumentationType.SWAGGER_2)
                    .apiInfo(apiInfo())
                    .select()
                    .apis(RequestHandlerSelectors.basePackage("com.crossoverJie.sbcorder.controller"))
                    .paths(PathSelectors.any())
                    .build();
        }
    
        private ApiInfo apiInfo() {
            return new ApiInfoBuilder()
                    .title("sbc order api")
                    .description("sbc order api")
                    .termsOfServiceUrl("http://crossoverJie.top")
                    .contact("crossoverJie")
                    .version("1.0.0")
                    .build();
        }
    
    }

 其实就是配置 `swagger` 的一些基本信息。 

 之后启动项目，在地址栏输入 `http://ip:port/swagger-ui.html#/` 即可进入。 

可以看到如上图所示的接口列表,点击如下图所示的参数例子即可进行接口调用。
![](/wp-content/uploads/2017/07/1500647518.png) 
 
   02.jpg 
  
 

## 自定义开关Swagger

`swagger` 的便利能给我们带来很多好处，但稍有不慎也可能出现问题。 

 比如如果在生产环境还能通过IP访问 `swagger` 的话那后果可是不堪设想的。 

 所以我们需要灵活控制 `swagger` 的开关。 

 这点可以利用 `spring的条件化配置(条件化配置可以配置存在于应用中,一旦满足一些特定的条件时就取消这些配置)` 来实现这一功能: 

    @ConditionalOnExpression("'${swagger.enable}' == 'true'")

 该注解的意思是 `给定的SpEL表达式计算结果为true` 时才会创建 `swagger` 的 `bean` 。 

`swagger.enable` 这个配置则是配置在 `application.properties` 中: 

    # 是否打开swagger
    swagger.enable = true

 这样当我们在生产环境时只需要将该配置改为 `false` 即可。 

 ps:更多 `spring条件化配置` : 

    @ConditionalOnBean                 //配置了某个特定Bean
    @ConditionalOnMissingBean          //没有配置特定的Bean
    @ConditionalOnClass                //Classpath里有指定的类
    @ConditionalOnMissingClass         //Classpath里缺少指定的类
    @ConditionalOnExpression           //给定的Spring Expression Language(SpEL)表达式计算结果为true
    @ConditionalOnJava                 //Java的版本匹配特定值或者一个范围值
    @ConditionalOnJndi                 //参数中给定的JNDI位置必须存在一个，如果没有给参数，则要有JNDI InitialContext
    @ConditionalOnProperty             //指定的配置属性要有一个明确的值
    @ConditionalOnResource             //Classpath里有指定的资源
    @ConditionalOnWebApplication       //这是一个Web应用程序
    @ConditionalOnNotWebApplication    //这不是一个Web应用程序
    (参考SpringBoot实战)

## 高可用Eureka

 在上一篇中是用 `Eureka` 来做了服务注册中心，所有的生产者都往它注册服务，消费者又通过它来获取服务。 

 但是之前讲到的都是单节点，这在生产环境风险巨大，我们必须做到注册中心的高可用，搭建 `Eureka` 集群。 

 这里简单起见就搭建两个 `Eureka` ,思路则是这两个Eureka都把自己当成应用向对方注册，这样就可以构成一个高可用的服务注册中心。 

在实际生产环节中会是每个注册中心一台服务器，为了演示起见，我就在本地启动两个注册中心，但是端口不一样。

 首先需要在本地配置一个 `host` : 

    127.0.0.1 node1 node2

 这样不论是访问 `node1` 还是 `node2` 都可以在本机调用的到( `当然不配置host也可以，只是需要通过IP来访问，这样看起来不是那么明显` )。 

 并给 `sbc-service` 新增了两个配置文件: 

application-node1.properties:

    spring.application.name=sbc-service
    server.port=8888
    eureka.instance.hostname=node1
    
    ## 不向注册中心注册自己
    #eureka.client.register-with-eureka=false
    #
    ## 不需要检索服务
    #eureka.client.fetch-registry=false
    eureka.client.serviceUrl.defaultZone=http://node2:9999/eureka/

application-node2.properties:

    spring.application.name=sbc-service
    server.port=9999
    eureka.instance.hostname=node2
    
    ## 不向注册中心注册自己
    #eureka.client.register-with-eureka=false
    #
    ## 不需要检索服务
    #eureka.client.fetch-registry=false
    eureka.client.serviceUrl.defaultZone=http://node1:8888/eureka/

其中最重要的就是:

    eureka.client.serviceUrl.defaultZone=http://node2:9999/eureka/
    eureka.client.serviceUrl.defaultZone=http://node1:8888/eureka/

两个应用互相注册。

启动的时候我们按照:

`java -jar sbc-service-1.0.0-SNAPSHOT.jar --spring.profiles.active=node1` 启动，就会按照传入的node1或者是node2去读取 `application-node1.properties,application-node2.properties` 这两个配置文件( `配置文件必须按照application-{name}.properties的方式命名` )。 

分别启动两个注册中心可以看到以下: 
![](/wp-content/uploads/2017/07/15006475181.png) 
 
   03.jpg 
  
 
 
 ![](/wp-content/uploads/2017/07/1500647519.png) 
 
   04.jpg 
  
 

可以看到两个注册中心以及互相注册了。

在服务注册的时候只需要将两个地址都加上即可:

`eureka.client.serviceUrl.defaultZone=http://node1:8888/eureka/,http://node2:9999/eureka/`

在服务调用的时候可以尝试关闭其中一个，正常情况下依然是可以调用到服务的。

## Feign声明式调用

 接下来谈谈服务调用，上次提到可以用 `ribbon` 来进行服务调用，但是明显很不方便，不如像之前 `rpc` 调用那样简单直接。 

 为此这次使用 `Feign` 来进行声明式调用，就像调用一个普通方法那样简单。 

## order-client

 片头说到我将应用分成了三个模块 `order、order-api、order-client` ，其中的 `client` 模块就是关键。 

来看看其中的内容,只有一个接口:

    @RequestMapping(value="/orderService")
    @FeignClient(name="sbc-order")
    @RibbonClient
    public interface OrderServiceClient extends OrderService{
    
    
        @ApiOperation("获取订单号")
        @RequestMapping(value = "/getOrderNo", method = RequestMethod.POST)
        BaseResponse<OrderNoResVO> getOrderNo(@RequestBody OrderNoReqVO orderNoReq) ;
    }

`@FeignClient` 这个注解要注意下，其中的name的是自己应用的应用名称，在 

`application.properties中的spring.application.name配置` 。 

 其中继承了一个 `OrderService` 在 `order-api` 模块中，来看看 `order-api` 中的内容。 

## order-api

其中也只有一个接口:

    @RestController
    @Api("订单服务API")
    @RequestMapping(value = "/orderService")
    @Validated
    public interface OrderService {
    
        @ApiOperation("获取订单号")
        @RequestMapping(value = "/getOrderNo", method = RequestMethod.POST)
        BaseResponse<OrderNoResVO> getOrderNo(@RequestBody OrderNoReqVO orderNoReq) ;
    }

这个接口有两个目的。

1.  给真正的 `controller` 来进行实现。 
2.  给 `client` 接口进行继承。 

类关系如下:
![](/wp-content/uploads/2017/07/15006475191.png) 
 
   05.jpg 
  
 

注解这些都没什么好说的，一看就懂。

## order

`order` 则是具体接口实现的模块，就和平时写 `controller` 一样。 

 来看看如何使用 `client` 进行声明式调用: 

 这次看看 `sbc-user` 这个项目，在里边调用了 `sbc-order` 的服务。 

 其中的 `user模块` 依赖了 `order-client` : 

    <dependency>
        <groupId>com.crossoverJie</groupId>
        <artifactId>order-client</artifactId>
    </dependency>

具体调用:

    @Autowired
        private OrderServiceClient orderServiceClient ;
    
        @Override
        public BaseResponse<UserResVO> getUserByFeign(@RequestBody UserReqVO userReq) {
            //调用远程服务
            OrderNoReqVO vo = new OrderNoReqVO() ;
            vo.setReqNo(userReq.getReqNo());
            BaseResponse<OrderNoResVO> orderNo = orderServiceClient.getOrderNo(vo);
    
            logger.info("远程返回:"+JSON.toJSONString(orderNo));
    
            UserRes userRes = new UserRes() ;
            userRes.setUserId(123);
            userRes.setUserName("张三");
    
            userRes.setReqNo(userReq.getReqNo());
            userRes.setCode(StatusEnum.SUCCESS.getCode());
            userRes.setMessage("成功");
    
            return userRes ;
        }

 可以看到只需要将 `order-client` 包中的Order服务注入进来即可。 

 在 `sbc-client` 的 `swagger` 中进行调用: 
![](/wp-content/uploads/2017/07/15006475192.png) 
 
   06.jpg 
  
 
 
 ![](/wp-content/uploads/2017/07/15006475193.png) 
 
   07.jpg 
  
 

 由于我并没传 `appId` 所以 `order` 服务返回的错误。 

## 总结

 当一个应用需要对外暴露接口时着需要按照以上方式提供一个 `client` 包更消费者使用。 

 其实应用本身也是需要做高可用的，和 `Eureka` 高可用一样，再不同的服务器上再启一个或多个服务并注册到 `Eureka` 集群中即可。 

 后续还会继续谈到 `zuul网关，容错，断路器` 等内容，欢迎拍砖讨论。 

 项目： [https://github.com/crossoverJie/springboot-cloud](https://www.jfox.info/go.php?url=https://link.juejin.im?target=https%3A%2F%2Fgithub.com%2FcrossoverJie%2Fspringboot-cloud)

 博客： [http://crossoverjie.top](https://www.jfox.info/go.php?url=https://link.juejin.im?target=http%3A%2F%2Fcrossoverjie.top) 。
{% endraw %}
