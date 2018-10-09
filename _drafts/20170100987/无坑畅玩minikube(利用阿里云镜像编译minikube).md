---
layout: post
title:  "无坑畅玩minikube(利用阿里云镜像编译minikube)"
title2:  "无坑畅玩minikube(利用阿里云镜像编译minikube)"
date:   2017-01-01 23:51:27  +0800
source:  "https://www.jfox.info/%e6%97%a0%e5%9d%91%e7%95%85%e7%8e%a9minikube-%e5%88%a9%e7%94%a8%e9%98%bf%e9%87%8c%e4%ba%91%e9%95%9c%e5%83%8f%e7%bc%96%e8%af%91minikube.html"
fileName:  "20170100987"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e6%97%a0%e5%9d%91%e7%95%85%e7%8e%a9minikube-%e5%88%a9%e7%94%a8%e9%98%bf%e9%87%8c%e4%ba%91%e9%95%9c%e5%83%8f%e7%bc%96%e8%af%91minikube.html"
---
{% raw %}
`Kubernetes`占据容器编排的霸主地位，我们一般都会通过`minikube`实验`kubernetes`功能，但是`minikube`是不能直接安装成功的,网上解决方案有2种：
– 科学上网
– 手动通过阿里云下载所需的google镜像

今天我在这里提供第三种方案，这种方案的优势是，我在本文编译的`minikube`，大家下载回去无需多余设置即可使用。本方法原理是修改`minikube`源码，将google镜像修改为阿里云镜像.
目前我只在MacOS下做了编译，Windows下原理一样，有时间我会编译一个windows版本供大家下载，大家有兴趣也可以自己编译.

### 1.安装go并配置GOPATH

- 使用`Homebrew`安装go语言：`brew install go`
- 在环境变量中配置`GOPATH`,`.bash_profile`中添加`export GOPATH=~/Documents/go`,使用`source ~/.bash_profile`使配置生效

### 2.安装docker toolbox

    docker-machine create --engine-registry-mirror=https://*.mirror.aliyuncs.com -d virtualbox default
    docker-machine env default
    eval "$(docker-machine env default)"
    docker info
    

- 建议将Virtualbox的docker虚拟机的内存至少分配4G

### 3.下载代码

在`$GOPATH/src/k8s.io/`目录下克隆代码:

    cd $GOPATH/src/k8s.io/
    git clone https://github.com/kubernetes/minikube.git
    

大家不要克隆本文的源码，本文的源码只是参考演示作用。

### 4.替换镜像

用开发工具打开`minikube`目录，我使用的是`Intellij Idea`,全局替换`gcr.io/google_containers`为`registry.cn-hangzhou.aliyuncs.com/google_containers`
因为我这次使用的`minikube`版本较新，阿里云没有最新版本的`kube-dns`和`kube-dashboard`，所以`kube-dns-controller.yaml`中的image版本由`1.14.2`改为`1.14.1`,`dashboard-rc.yaml`中的image版本由`v1.6.1`，改为`v1.6.0`,大家以后自己编译的时候可以在[https://dev.aliyun.com/search.html](https://www.jfox.info/go.php?url=https://dev.aliyun.com/search.html)检索下阿里云中最新镜像版本。

### 5.编译

在minikube目录下执行`make`命令进行编译,可执行文件将生成在当前目录下的out目录下，其中`minikube`,`minikube-darwin-amd64`均可。

### 6.使用

    ./minikube start
    

    minikube start
    

    wangyunfeideMBP:k8s.io wangyunfei$ kubectl get pod --all-namespaces
    NAMESPACE     NAME                          READY     STATUS    RESTARTS   AGE
    kube-system   kube-addon-manager-minikube   1/1       Running   0          33m
    kube-system   kube-dns-3197702416-st4zq     3/3       Running   0          32m
    kube-system   kubernetes-dashboard-n883k    1/1       Running   0          32m
    

镜像全部成功运行.

    wangyunfeideMBP:out wangyunfei$ kubectl proxy
    Starting to serve on 127.0.0.1:8001
    

浏览器访问[http://127.0.0.1:8001/ui](https://www.jfox.info/go.php?url=http://127.0.0.1:8001/ui)
![](/wp-content/uploads/2017/06/dashboard.png)

### 7.源码地址与二进制文件下载
{% endraw %}
