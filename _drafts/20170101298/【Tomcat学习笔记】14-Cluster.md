---
layout: post
title:  "【Tomcat学习笔记】14-Cluster"
title2:  "【Tomcat学习笔记】14-Cluster"
date:   2017-01-01 23:56:38  +0800
source:  "https://www.jfox.info/tomcat%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b014cluster.html"
fileName:  "20170101298"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/tomcat%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b014cluster.html"
---
{% raw %}
Tomcat Cluster 这块代码较多，就不贴代码一步步看了，这里从更宏观的视角分析和总结一下。代码主要在 org.apache.catalina.ha 和 org.apache.catalina.tribes 两个package. ha这个package主要做了两件事，或者说Tomcat cluster 主要就做了这两件事：集群间 Session 同步 和 集群War部署。tribes 则是Tomcat 集群通讯模块。

![](/wp-content/uploads/2017/07/1499954735.png)

###  Tomcat集群搭建 

可以采用Apacha或Ngnix + Tomcat的方式在自己机器上搭建一个简单的集群，这里不做详细介绍，只列一下Tomcat的配置，方便后面分析Tomcat源码。在本机配两个Tomcat实例的话，端口要改一下，两个不一样即可。 

    <ClusterclassName="org.apache.catalina.ha.tcp.SimpleTcpCluster"channelSendOptions="8">  
        <ManagerclassName="org.apache.catalina.ha.session.DeltaManager"expireSessionsOnShutdown="false"notifyListenersOnReplication="true"/>  
            <ChannelclassName="org.apache.catalina.tribes.group.GroupChannel">  
                <MembershipclassName="org.apache.catalina.tribes.membership.McastService"address="228.0.0.4"port="45564"frequency="500"dropTime="3000"/>  
                <ReceiverclassName="org.apache.catalina.tribes.transport.nio.NioReceiver"address="auto"port="4000"autoBind="100"selectorTimeout="5000"maxThreads="6"/>  
                <SenderclassName="org.apache.catalina.tribes.transport.ReplicationTransmitter">  
                  <TransportclassName="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>  
                </Sender>  
                <InterceptorclassName="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>  
                <InterceptorclassName="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>  
            </Channel>  
            <ValveclassName="org.apache.catalina.ha.tcp.ReplicationValve"filter=""/>  
            <ValveclassName="org.apache.catalina.ha.session.JvmRouteBinderValve"/>  
            <DeployerclassName="org.apache.catalina.ha.deploy.FarmWarDeployer"tempDir="/tmp/war-temp/"deployDir="/tmp/war-deploy/"watchDir="/tmp/war-listen/"watchEnabled="false"/>  
            <ClusterListenerclassName="org.apache.catalina.ha.session.ClusterSessionListener"/>  
    </Cluster>
    

 Cluster标签里面所有这些配置都是默认的，如果没有特殊要求，其实也可以不用配，在SimpleTcpCluster启动的时候，回去check，如果没有配置，就用默认的。 

    protected void checkDefaults(){
        if ( clusterListeners.size() == 0 ) {
            addClusterListener(new ClusterSessionListener());
        }
        if ( valves.size() == 0 ) {
            addValve(new JvmRouteBinderValve());
            addValve(new ReplicationValve());
        }
        if ( clusterDeployer != null ) clusterDeployer.setCluster(this);
        if ( channel == null ) channel = new GroupChannel();
        if ( channel instanceof GroupChannel && !((GroupChannel)channel).getInterceptors().hasNext()) {
            channel.addInterceptor(new MessageDispatch15Interceptor());
            channel.addInterceptor(new TcpFailureDetector());
        }
    }
    

###  Session同步 

集群中任何一个node都有可能挂掉，所以session的同步就很必要。Tomcat提供了两种同步机制，DeltaManager 和 BackupManager。

- DeltaManager, 一个 node 的 session 发生变更(新增、过期、属性变更等) 都会 通知所有其他 node，其他 node 得到通知后会更新该 session的备份。即任何一个session，在每个node都有备份。
- BackupManager，DeltaManager在集群规模小的时候还可以，当集群规模大的时候，node之前的网络通信就按 N * (N-1) 平方增长了。使用BackupManager，则每个node的session只在另外一个node有备份。

下面来看下 DeltaManager 这种方式的工作原理，如图所示:

DeltaManager, 所有 Session 的变更都是通过这个 manager 来操作的，新增，过期，属性变更，ID变更，对应这些操作，Tomcat 定义了相应的事件 EVT_SESSION_CREATED, EVT_SESSION_EXPIRED, EVT_CHANGE_SESSION_ID. 当 session 发生变更时， DelataManager 会将变更封装成SessionMessage(包含事件，session Id，session数据等), 然后通过 cluster 发出去。别的 node 收到该消息后，最终也会到 DeltaManager 中来处理该消息，对自己备份的session也完成相应的变更。

SimpleTcpCluster, 它实现了ClannelListener和MembershipListener接口，负责监听Channel来的消息（收到消息事件或者member发生变更的消息），然后将消息转给 ClusterSessionListener 或者 FarmWarDeployer. 它们俩虽然也实现了ChannelListener，但它们不直接监听 Channel 来的消息，而是通过SimpleTcpCluster call 它们了。

GroupChannel, channel 是 Tribes（Tribes是集群通讯模块，这里不关注细节） 对外的一个主要接口，SimpleTcpCluster 通过它可以

- 发送消息
- 接受消息
- 获取集群里的member
- 接收 member 新增或减少的 通知

Channel 下面还有几个 Interceptor, 最终到达 ChannelCoordinator，ChannelCoordinator 里ChannelReceiver、ChannelSender、MembershipService 来完成真正的消息收发操作。整个过程可以看图中红色数据流。

###  集群War部署 

之前的笔记有提过，每个container都有一个background线程，SimpleTcpCluster有一个backgroudProcess方法给后台线程调用，会定时的通过WarWather去check war 包，当一个node的War发生变更（新增、删除、修改），FarmWarDeployer会将变更封装成FileMessage, 发给集群中的其他Node, 由于 War 包比较大，数据是分批发的，每次发 10K. 接收端会收全消息后，会根据消息类型执行redeploy或者undeploy. 具体过程见图中绿色数据流

###  我的看法 

Tomcat 做了个集群的功能，大部分功能主要是解决session在集群中的同步，然而在有点规模的互联网公司都不怎么用它。

1. 对于无状态的应用，通过apache/ngnix 负载均衡到 各个 tomcat就可以了
2. 对于有状态的(session)应用，往往都自研分布式Session应用。分布式系统下用 Tomcat 的 session 会有很多限制。

Tomcat还做了个功能，监控集群中应用的变更，如果有一台的War包发生了变化，会通知其他机器自动重新部署。这个功能，在有点规模的互联网公司应该也不会用它，肯定用自研的运维系统, 可以支持更灵活的应用部署，方便和公司的运维体系打通。
{% endraw %}
