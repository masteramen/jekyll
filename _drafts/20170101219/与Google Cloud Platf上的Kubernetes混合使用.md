---
layout: post
title:  "与Google Cloud Platf上的Kubernetes混合使用"
title2:  "与Google Cloud Platf上的Kubernetes混合使用"
date:   2017-01-01 23:55:19  +0800
source:  "https://www.jfox.info/%e4%b8%8egooglecloudplatf%e4%b8%8a%e7%9a%84kubernetes%e6%b7%b7%e5%90%88%e4%bd%bf%e7%94%a8.html"
fileName:  "20170101219"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e4%b8%8egooglecloudplatf%e4%b8%8a%e7%9a%84kubernetes%e6%b7%b7%e5%90%88%e4%bd%bf%e7%94%a8.html"
---
{% raw %}
作者Allan Naim,产品GTM负责人,Kubernetes和集装箱发动机

最近,我们宣布[战略合作伙伴关系](https://www.jfox.info/go.php?url=https://www.blog.google/topics/google-cloud/nutanix-and-google-cloud-team-simplify-hybrid-cloud/)[ Nutanix ](https://www.jfox.info/go.php?url=https://www.nutanix.com/)可以帮助企业从混合云部署中消除摩擦。您可以找到公告博客文章[ here ](/) .

混合云允许组织在内部或公共云中运行各种应用程序。通过这种方式,企业可以:

-  Increase the speed  at which they’re releasing products and features 
-  Scale  applications to meet customer demand 
-  Move applications  to the public cloud at their own pace 
-  Reduce time spent on infrastructure  and increase time spent on writing code 
-  Reduce cost  by improving resource utilization and compute efficiency 

绝大多数组织都有不同需求的应用程序组合.在某些情况下,数据主权和合规性要求强制执行部署模式,其中应用程序及其数据必须位于本地环境或国家边界内. 或者,移动和IoT应用程序的特点是具有不可预测的消费模型,使按需付费即付即时云模型成为这些应用程序的最佳部署目标。

混合云部署可以帮助您提供所需的安全性,合规性和计算能力,灵活性,灵活性和规模需求。我们的混合云示例将涵盖三个关键组件:

1.  On-premise:  Nutanix infrastructure 
2.  Public cloud: [ Google Cloud Platform ](https://www.jfox.info/go.php?url=https://cloud.google.com/) (GCP) 
3.  Open source:  Kubernetes and Containers 

容器提供了一个不可变且高度可移植的基础架构,使开发人员能够在容器运行时发动机可以运行的任何环境中预测部署应用程序。这使得可以在裸机,私有云或公共云上运行相同的集装箱化应用程序.但是, 随着开发人员迈向微服务架构,他们必须解决一系列新的挑战,如扩展,滚动更新,发现,日志记录,监控和网络连接。

Google运行我们自己的基于容器的内部系统的经验激励我们创建[ Kubernetes ](https://www.jfox.info/go.php?url=https://kubernetes.io/)和Google集装箱发动机,这是一个开源和Google云端管理平台,用于运行 集装箱化的应用程序跨越一个计算资源池。 Kubernetes抽象出底层基础设施,并为运行容器化应用程序提供一致的体验. Kubernetes介绍了一个声明性部署模型的概念。在这个模型中,一个ops人提供一个模板, 描述应用程序应该如何运行,而Kubernetes确保应用程序的实际状态始终等于所需状态. Kubernetes还可以管理容器调度,扩展,运行状况,生命周期,负载平衡,数据持久性,日志记录和监视。

在第一阶段,Google Cloud-Nutanix合作伙伴关注重点是使用Nutanix Calm将混合操作作为单一控制平面,用于内部部署Nutanix和GCP环境的工作负载管理,使用Kubernetes作为两个容器管理层。 Nutanix 冷静最近是在[在Nutanix .NEXT会议上宣布](https://www.jfox.info/go.php?url=https://www.nutanix.com/2017/06/28/app-centric-infrastructure-cloud/),一旦公开发布,将会 用于在混合云部署中自动配置和生命周期操作。 Nutanix Enterprise Cloud OS支持在云计算发动机上运行的混合Kubernetes环境,以及Nutanix内部的Kubernetes集群。通过此,客户可以部署便携式应用程序 在本地的Nutanix环境以及GCP.中运行的蓝图

我们来介绍使用Nutanix和GCP.设置混合环境的步骤

所涉及的步骤如下:

1.  Provision an on premise 4-node Kubernetes cluster using a Nutanix Calm blueprint 
2.  Provision a Google Compute Engine 4-node Kubernetes cluster using the same Nutanix Calm Kubernetes blueprint, configured for Google Cloud 
3.  Use Kubectl to manage both on premise and Google Cloud Kubernetes clusters 
4.  Using Helm, we’ll deploy the same WordPress chart on both on premise and Google Cloud Kubernetes clusters 

### 使用Nutanix Calm蓝图提供内部部署的Kubernetes集群

您可以使用Nutanix Calm在内部提供Kubernetes集群,以及用于虚拟化数据中心的基础设施管理解决方案Nutanix Prism,以引导一组虚拟化计算和存储.这导致了一个Nutanix管理的计算和存储池 准备由Nutanix Calm策划,用于一键式部署流行的商业和开源软件包.
 The tools used to deploy the Nutanix and Google hybrid cloud stacks. 
然后,您可以选择Kubernetes蓝图来定位Nutanix内部环境.

下面的Calm Kubernetes蓝图配置了一个四节点的Kubernetes集群,其中包含了所有节点和master.上的所有基本软件。我们还定制了我们的Kubernetes蓝图,在集群上配置Helm Tiller,因此您可以使用Helm 部署WordPress chart. Calm蓝图还允许您创建工作流程,以便配置任务可以按照指定的顺序进行,如下所示,“create”action.

现在,推出Kubernetes蓝图:

几分钟后,Kubernetes集群已经启动并运行了五个虚拟机(一个主节点和四个工作节点):

### 在Google Compute Engine上使用相同的Nutanix Calm Kubernetes蓝图提供Kubernetes群集

使用Nutanix Calm,您现在可以将Kubernetes蓝图部署到GCP. Kubernetes群集已经在Compute Engine上运行了几分钟,再次有五个VM(一个主节点+四个工作节点):

您现在可以在混合环境中部署工作负载。在此示例中,您将部署容器化的WordPress stack.

### 使用Kubectl来管理内部部署和Google Cloud Kubernetes集群

Kubectl是Kubernetes自带的命令行界面工具,用于对Kubernetes集群执行命令。

您现在可以在混合环境中定位每个Kubernetes集群,并使用kubectl运行基本命令.首先,将ssh放入您的内部部署环境并运行几个命令.

    # List out the nodes in the cluster
    $ kubectl get nodes
    NAME          STATUS    AGE
    .21.80.54   Ready     16m
    .21.80.59   Ready     16m
    .21.80.65   Ready     16m
    .21.80.67   Ready     16m
    # View the cluster config
    $ kubectl config view
    apiVersion: v1
    clusters:
    - cluster:
        server: http://10.21.80.66:8080
      name: default-cluster
    contexts:
    - context:
        cluster: default-cluster
        user: default-admin
      name: default-context
    current-context: default-context
    kind: Config
    preferences: {}
    users: []
    # Describe the storageclass configured. This is the Nutanix storage volume plugin for Kubernetes
    $ kubectl get storageclass
    NAME      KIND
    silver    StorageClass.v1.storage.k8s.io
    $ kubectl describe storageclass silver
    Name:  silver
    IsDefaultClass: No
    Annotations: storageclass.kubernetes.io/is-default-class=true
    Provisioner: kubernetes.io/nutanix-volume

### 使用Helm,您可以在内部部署和Google Cloud Kubernetes群集上部署相同的WordPress图表

此示例使用Helm,用于安装和管理Kubernetes应用程序的软件包管理器。在此示例中,Calm Kubernetes蓝图包括Helm作为集群设置的一部分.内部部署的Kubernetes集群配置了Nutanix Acropolis,一个存储配置 系统,它会自动为WordPress pods.创建Kubernetes持久卷

我们来部署WordPress内部部署和Google云端:

    # Deploy wordpress
    $ helm install wordpress-0.6.4.tgz
    NAME:   quaffing-crab
    LAST DEPLOYED: Sun Jul  2 03:32:21 2017
    NAMESPACE: default
    STATUS: DEPLOYED
    RESOURCES:
    ==> v1/Secret
    NAME                     TYPE    DATA  AGE
    quaffing-crab-mariadb    Opaque  2     1s
    quaffing-crab-wordpress  Opaque  3     1s
    ==> v1/ConfigMap
    NAME                   DATA  AGE
    quaffing-crab-mariadb  1     1s
    ==> v1/PersistentVolumeClaim
    NAME                     STATUS   VOLUME  CAPACITY  ACCESSMODES  STORAGECLASS  AGE
    quaffing-crab-wordpress  Pending  silver  1s
    quaffing-crab-mariadb    Pending  silver  1s
    ==> v1/Service
    NAME                     CLUSTER-IP     EXTERNAL-IP  PORT(S)                     AGE
    quaffing-crab-mariadb    10.21.150.254         3306/TCP                    1s
    quaffing-crab-wordpress  10.21.150.73       80:32376/TCP,443:30998/TCP  1s
    ==> v1beta1/Deployment
    NAME                     DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
    quaffing-crab-wordpress  1        1        1           0          1s
    quaffing-crab-mariadb  

然后,您可以运行几个kubectl命令来浏览内部部署.

    # Take a look at the persistent volume claims 
    $ kubectl get pvc
    NAME                      STATUS    VOLUME                                                                               CAPACITY   ACCESSMODES   AGE
    quaffing-crab-mariadb     Bound     94d90daca29eaafa7439b33cc26187536e2fcdfc20d78deddda6606db506a646-nutanix-k8-volume   8Gi        RWO           1m
    quaffing-crab-wordpress   Bound     764e5462d809a82165863af8423a3e0a52b546dd97211dfdec5e24b1e448b63c-nutanix-k8-volume   10Gi       RWO           1m
    # Take a look at the running pods
    $ kubectl get po
    NAME                                      READY     STATUS    RESTARTS   AGE
    quaffing-crab-mariadb-3339155510-428wb    1/1       Running   0          3m
    quaffing-crab-wordpress-713434103-5j613   1/1       Running   0          3m
    # Take a look at the services exposed
    $ kubectl get svc
    NAME                      CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    kubernetes                10.254.0.1              443/TCP                      16d
    quaffing-crab-mariadb     10.21.150.254           3306/TCP                     4m
    quaffing-crab-wordpress   10.21.150.73    #.#.#.#     80:32376/TCP,443:30998/TCP   4m

这个内部部署环境没有设置负载平衡器,所以我们使用集群IP浏览WordPress站点。 Google Cloud WordPress部署自动为负载平衡器分配了一个外部IP地址的WordPress服务.

### 概要

-  Nutanix Calm provided a one-click consistent deployment model to provision a Kubernetes cluster on both Nutanix Enterprise Cloud and Google Cloud. 
-  Once the Kubernetes cluster is running in a hybrid environment, you can use the same tools (Helm, kubectl) to deploy containerized applications targeting the respective environment. This represents a “write once deploy anywhere” model. 
-  Kubernetes abstracts away the underlying infrastructure constructs, making it possible to consistently deploy and run containerized applications across heterogeneous cloud environments 

### 下一步

来源:[与Google云平台和Nutanix上的Kubernetes混合](//feedproxy.google.com/~r/ClPlBl/~3/d4Dn_Pqzb-8/going-Hybrid-with-Kubernetes-on-Google-Cloud-Platform-and-Nutanix.html)
[点赞](void(0))[Google](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/Google/)[cloud](https://www.jfox.info/go.php?url=http://ju.outofmemory.cn/tag/cloud/)
{% endraw %}
