---
layout: post
title:  "微服务架构-Spring Cloud"
title2:  "微服务架构-Spring Cloud"
date:   2017-01-01 23:59:18  +0800
source:  "http://www.jfox.info/%e5%be%ae%e6%9c%8d%e5%8a%a1%e6%9e%b6%e6%9e%84springcloud.html"
fileName:  "20170101458"
lang:  "zh_CN"
published: true
permalink: "%e5%be%ae%e6%9c%8d%e5%8a%a1%e6%9e%b6%e6%9e%84springcloud.html"
---
{% raw %}
1 为什么需要服务发现

简单来说，服务化的核心就是将传统的一站式应用根据业务拆分成一个一个的服务，而微服务在这个基础上要更彻底地去耦合（不再共享DB、KV，去掉重量级ESB），并且强调DevOps和快速演化。这就要求我们必须采用与一站式时代、泛SOA时代不同的技术栈，而Spring Cloud就是其中的佼佼者。

DevOps是英文Development和Operations的合体，他要求开发、测试、运维进行一体化的合作，进行更小、更频繁、更自动化的应用发布，以及围绕应用架构来构建基础设施的架构。这就要求应用充分的内聚，也方便运维和管理。这个理念与微服务理念不谋而合。

接下来我们从服务化架构演进的角度来看看为什么Spring Cloud更适应微服务架构。

1.1 从使用nginx说起

最初的服务化解决方案是给提供相同服务提供一个统一的域名，然后服务调用者向这个域名发送HTTP请求，由Nginx负责请求的分发和跳转。NginxArch.png

![](/wp-content/uploads/2017/08/1501770297.png)

这种架构存在很多问题:

Nginx作为中间层，在配置文件中耦合了服务调用的逻辑，这削弱了微服务的完整性，也使得Nginx在一定程度上变成了一个重量级的ESB。

服务的信息分散在各个系统，无法统一管理和维护。每一次的服务调用都是一次尝试，服务消费者并不知道有哪些实例在给他们提供服务。这不符合DevOps的理念。

无法直观的看到服务提供者和服务消费者当前的运行状况和通信频率。这也不符合DevOps的理念。

消费者的失败重发，负载均衡等都没有统一策略，这加大了开发每个服务的难度，不利于快速演化。

为了解决上面的问题，我们需要一个现成的中心组件对服务进行整合，将每个服务的信息汇总，包括服务的组件名称、地址、数量等。服务的调用方在请求某项服务时首先通过中心组件获取提供这项服务的实例的信息（IP、端口等），再通过默认或自定义的策略选择该服务的某一提供者直接进行访问。所以，我们引入了Dubbo。

1.2 基于Dubbo实现微服务

Dubbo是阿里开源的一个SOA服务治理解决方案，文档丰富，在国内的使用度非常高。

使用Dubbo构建的微服务，已经可以比较好地解决上面提到的问题：DubboArch.png

![](/wp-content/uploads/2017/08/1501770298.png)

调用中间层变成了可选组件，消费者可以直接访问服务提供者。

服务信息被集中到Registry中，形成了服务治理的中心组件。

通过Monitor监控系统，可以直观地展示服务调用的统计信息。

Consumer可以进行负载均衡、服务降级的选择。

但是对于微服务架构而言，Dubbo也并不是十全十美的：

Registry严重依赖第三方组件（zookeeper或者redis），当这些组件出现问题时，服务调用很快就会中断。

DUBBO只支持RPC调用。使得服务提供方与调用方在代码上产生了强依赖，服务提供者需要不断将包含公共代码的jar包打包出来供消费者使用。一旦打包出现问题，就会导致服务调用出错。

最为重要的是，DUBBO现在已经停止维护了，对于技术发展的新需求，需要由开发者自行拓展升级。这对于很多想要采用微服务架构的中小软件组织，显然是不太合适的。

目前Github社区上有一个DUBBO的升级版，叫DUBBOX，提供了更高效的RPC序列化方式和REST调用方式。但是该项目也基本停止维护了。

1.3 新的选择——Spring Cloud

作为新一代的服务框架，Spring Cloud提出的口号是开发“面向云环境的应用程序”，它为微服务架构提供了更加全面的技术支持。

结合我们一开始提到的微服务的诉求，我们把Spring Cloud与DUBBO进行一番对比：

![](/wp-content/uploads/2017/08/15017702981.png)

Spring Cloud抛弃了Dubbo的RPC通信，采用的是基于HTTP的REST方式。严格来说，这两种方式各有优劣。虽然从一定程度上来说，后者牺牲了服务调用的性能，但也避免了上面提到的原生RPC带来的问题。而且REST相比RPC更为灵活，服务提供方和调用方的依赖只依靠一纸契约，不存在代码级别的强依赖，这在强调快速演化的微服务环境下，显得更加合适。

很明显，Spring Cloud的功能比DUBBO更加强大，涵盖面更广，而且作为Spring的拳头项目，它也能够与Spring Framework、Spring Boot、Spring Data、Spring Batch等其他Spring项目完美融合，这些对于微服务而言是至关重要的。前面提到，微服务背后一个重要的理念就是持续集成、快速交付，而在服务内部使用一个统一的技术框架，显然比把分散的技术组合到一起更有效率。更重要的是，相比于Dubbo，它是一个正在持续维护的、社区更加火热的开源项目，这就保证使用它构建的系统，可以持续地得到开源力量的支持。

2. Spring Cloud Netflix 组件

Netflix和Spring Cloud是什么关系呢？Netflix是一家成功实践微服务架构的互联网公司，几年前，Netflix就把它的几乎整个微服务框架栈开源贡献给了社区。Spring背后的Pivotal在2015年推出的Spring Cloud开源产品，主要对Netflix开源组件的进一步封装，方便Spring开发人员构建微服务基础框架。

对于微服务的治理而言，核心就是服务的注册和发现。所以选择哪个组件，很大程度上要看它对于服务注册与发现的解决方案。在这个领域，开源架构很多，最常见的是Zookeeper，但这并不是一个最佳选择。

在分布式系统领域有个著名的CAP定理：C——数据一致性，A——服务可用性，P——服务对网络分区故障的容错性。这三个特性在任何分布式系统中不能同时满足，最多同时满足两个。

Zookeeper是著名Hadoop的一个子项目，很多场景下Zookeeper也作为Service发现服务解决方案。Zookeeper保证的是CP，即任何时刻对

Zookeeper的访问请求能得到一致的数据结果，同时系统对网络分割具备容错性，但是它不能保证每次服务请求的可用性。从实际情况来分析，在使用Zookeeper获取服务列表时，如果zookeeper正在选主，或者Zookeeper集群中半数以上机器不可用，那么将就无法获得数据了。所以说，Zookeeper不能保证服务可用性。

诚然，对于大多数分布式环境，尤其是涉及到数据存储的场景，数据一致性应该是首先被保证的，这也是zookeeper设计成CP的原因。但是对于服务发现场景来说，情况就不太一样了：针对同一个服务，即使注册中心的不同节点保存的服务提供者信息不尽相同，也并不会造成灾难性的后果。因为对于服务消费者来说，能消费才是最重要的——拿到可能不正确的服务实例信息后尝试消费一下，也好过因为无法获取实例信息而不去消费。所以，对于服务发现而言，可用性比数据一致性更加重要——AP胜过CP。而Spring Cloud Netflix在设计Eureka时遵守的就是AP原则。

Eureka本身是Netflix开源的一款提供服务注册和发现的产品，并且提供了相应的Java封装。在它的实现中，节点之间是相互平等的，部分注册中心的节点挂掉也不会对集群造成影响，即使集群只剩一个节点存活，也可以正常提供发现服务。哪怕是所有的服务注册节点都挂了，Eureka Clients上也会缓存服务调用的信息。这就保证了我们微服务之间的互相调用是足够健壮的。

除此之外，Spring Cloud Netflix背后强大的开源力量，也促使我们选择了Spring Cloud Netflix：

前文提到过，Spring Cloud的社区十分活跃，其在业界的应用也十分广泛（尤其是国外），而且整个框架也经受住了Netflix严酷生产环境的考验。

除了服务注册和发现，Spring Cloud Netflix的其他功能也十分强大，包括Ribbon，hystrix，Feign，Zuul等组件，结合到一起，让服务的调用、路由也变得异常容易。

Spring Cloud Netflix作为Spring的重量级整合框架，使用它也意味着我们能从Spring获取到巨大的便利。Spring Cloud的其他子项目，比如Spring Cloud Stream、Spring Cloud Config等等，都为微服务的各种需求提供了一站式的解决方案。

3. Spring Cloud 服务发现

Spring Cloud Netflix的核心是用于服务注册与发现的Eureka，接下来我们将以Eureka为线索，介绍Eureka、Ribbon、Hystrix、Feign这些Spring Cloud Netflix主要组件。

3.1 服务注册与发现——Eureka

Eureka这个词来源于古希腊语，意为“我找到了！我发现了！”，据传，阿基米德在洗澡时发现浮力原理，高兴得来不及穿上裤子，跑到街上大喊：“Eureka(我找到了)！”。

Eureka由多个instance(服务实例)组成，这些服务实例可以分为两种：Eureka Server和Eureka Client。为了便于理解，我们将Eureka client再分为Service Provider和Service Consumer。如下图所示：EurekaRole.png

![](/wp-content/uploads/2017/08/1501770299.png)

Eureka Server：服务的注册中心，负责维护注册的服务列表。

Service Provider：服务提供方，作为一个Eureka Client，向Eureka Server做服务注册、续约和下线等操作，注册的主要数据包括服务名、机器ip、端口号、域名等等。

Service Consumer：服务消费方，作为一个Eureka Client，向Eureka Server获取Service Provider的注册信息，并通过远程调用与Service Provider进行通信。

Service Provider和Service Consumer不是严格的概念，Service Consumer也可以随时向Eureka Server注册，来让自己变成一个Service Provider。

Spring Cloud针对服务注册与发现，进行了一层抽象，并提供了三种实现：Eureka、Consul、Zookeeper。目前支持得最好的就是Eureka，其次是Consul，最后是Zookeeper。

3.1.1 Eureka Server

Eureka Server作为一个独立的部署单元，以REST API的形式为服务实例提供了注册、管理和查询等操作。同时，Eureka Server也为我们提供了可视化的监控页面，可以直观地看到各个Eureka Server当前的运行状态和所有已注册服务的情况。

3.1.1.1 Eureka Server的高可用集群

Eureka Server可以运行多个实例来构建集群，解决单点问题，但不同于ZooKeeper的选举leader的过程，Eureka Server采用的是Peer to Peer对等通信。这是一种去中心化的架构，无master/slave区分，每一个Peer都是对等的。在这种架构中，节点通过彼此互相注册来提高可用性，每个节点需要添加一个或多个有效的serviceUrl指向其他节点。每个节点都可被视为其他节点的副本。

如果某台Eureka Server宕机，Eureka Client的请求会自动切换到新的Eureka Server节点，当宕机的服务器重新恢复后，Eureka会再次将其纳入到服务器集群管理之中。当节点开始接受客户端请求时，所有的操作都会进行replicateToPeer（节点间复制）操作，将请求复制到其他Eureka Server当前所知的所有节点中。

一个新的Eureka Server节点启动后，会首先尝试从邻近节点获取所有实例注册表信息，完成初始化。Eureka Server通过getEurekaServiceUrls()方法获取所有的节点，并且会通过心跳续约的方式定期更新。默认配置下，如果Eureka Server在一定时间内没有接收到某个服务实例的心跳，Eureka Server将会注销该实例（默认为90秒，通过eureka.instance.lease-expiration-duration-in-seconds配置）。当Eureka Server节点在短时间内丢失过多的心跳时（比如发生了网络分区故障），那么这个节点就会进入自我保护模式。下图为Eureka官网的架构图

什么是自我保护模式？默认配置下，如果Eureka Server每分钟收到心跳续约的数量低于一个阈值（instance的数量*(60/每个instance的心跳间隔秒数)*自我保护系数），就会触发自我保护。在自我保护模式中，Eureka Server会保护服务注册表中的信息，不再注销任何服务实例。当它收到的心跳数重新恢复到阈值以上时，该Eureka Server节点就会自动退出自我保护模式。它的设计哲学前面提到过，那就是宁可保留错误的服务注册信息，也不盲目注销任何可能健康的服务实例。该模式可以通过eureka.server.enable-self-preservation = false来禁用，同时eureka.instance.lease-renewal-interval-in-seconds可以用来更改心跳间隔，eureka.server.renewal-percent-threshold可以用来修改自我保护系数（默认0.85）。

![](/wp-content/uploads/2017/08/1501770300.png)

3.1.1.2 Eureka Server的Region、Zone

Eureka的官方文档对Regin、Zone几乎没有提及，由于概念抽象，新手很难理解。因此，我们先来了解一下Region、Zone、Eureka集群三者的关系，如下图所示：

![](/wp-content/uploads/2017/08/1501770302.png)

region和zone（或者Availability Zone）均是AWS的概念。在非AWS环境下，我们可以先简单地将region理解为Eureka集群，zone理解成机房。上图就可以理解为一个Eureka集群被部署在了zone1机房和zone2机房中。

3.1.2 Service Provider

3.1.2.1 服务注册

Service Provider本质上是一个Eureka Client。它启动时，会调用服务注册方法，向Eureka Server注册自己的信息。Eureka Server会维护一个已注册服务的列表，这个列表为一个嵌套的hash map：

第一层，application name和对应的服务实例。

第二层，服务实例及其对应的注册信息，包括IP，端口号等。

当实例状态发生变化时（如自身检测认为Down的时候），也会向Eureka Server更新自己的服务状态，同时用replicateToPeers()向其它Eureka Server节点做状态同步。

![](/wp-content/uploads/2017/08/15017703021.png)

![Uploading EurekaServerEvict_655129.png . . .]

3.1.2.2 续约与剔除

前面提到过，服务实例启动后，会周期性地向Eureka Server发送心跳以续约自己的信息，避免自己的注册信息被剔除。续约的方式与服务注册基本一致：首先更新自身状态，再同步到其它Peer。

如果Eureka Server在一段时间内没有接收到某个微服务节点的心跳，Eureka Server将会注销该微服务节点（自我保护模式除外）。

![](/wp-content/uploads/2017/08/15017703021.png)

3.1.3 Service Consumer

Service Consumer本质上也是一个Eureka Client（它也会向Eureka Server注册，只是这个注册信息无关紧要罢了）。它启动后，会从Eureka Server上获取所有实例的注册信息，包括IP地址、端口等，并缓存到本地。这些信息默认每30秒更新一次。前文提到过，如果与Eureka Server通信中断，Service Consumer仍然可以通过本地缓存与Service Provider通信。

实际开发Eureka的过程中，有时会遇见Service Consumer获取到Server Provider的信息有延迟，在Eureka Wiki中有这么一段话:

All operations from Eureka client may take s
{% endraw %}
