---
layout: post
title:  "高仿 ios 相册地图功能"
title2:  "高仿 ios 相册地图功能"
date:   2017-01-01 23:57:44  +0800
source:  "https://www.jfox.info/%e9%ab%98%e4%bb%bfios%e7%9b%b8%e5%86%8c%e5%9c%b0%e5%9b%be%e5%8a%9f%e8%83%bd.html"
fileName:  "20170101364"
lang:  "zh_CN"
published: true
permalink: "2017/%e9%ab%98%e4%bb%bfios%e7%9b%b8%e5%86%8c%e5%9c%b0%e5%9b%be%e5%8a%9f%e8%83%bd.html"
---
{% raw %}
老规矩先上图
最近 没有什么时间，后面项目再补上详细说明

![](/wp-content/uploads/2017/07/1500560442.png)

百度地图SDK新增点聚合功能。通过该功能，可通过缩小地图层级，将定义范围内的多个标注点，聚合显示成一个标注点，解决加载大量点要素到地图上产生覆盖现象的问题，并提高性能。
 
 
本demo 修改算法流程： 
 
 
1. 
加入异步添加屏幕上图片，

2. 
只加载屏幕范围内的图片

3. 
优化渲染逻辑
大大减少运算的时间（经过测试1W张不同经纬度的图片 300-500ms 可以计算完毕）

 
 
讲解点聚合功能，整个分析过程分为三部分： 
 
 
1、如何添加点聚合功能到项目中；

2、整体结构分析；

3、核心算法分析。
 
 
一、添加点聚合功能 
 
 
如官网所示，添加点聚合的方法分为三步：
1、声明点聚合管理类为全局变量，并初始化。核心代码如下图：

    MarkerOptions opts = new MarkerOptions().position(cluster.getPosition())
                .icon(BitmapDescriptorFactory.fromBitmap(XX));
    Marker marker = (Marker) mMap.addOverlay(opts);

 
二、整体结构分析 
先上一个思维导图： 

![](/wp-content/uploads/2017/07/1500560445.png)

如上图，点聚合有四个类

1、Cluster数据：主要是聚合后的数据类型

2、四叉树：记录初始范围内的所有图片并以四叉树的数据结构组织。核心算法需要用到的数据结构，后面再讲；

3、点聚合算法：基于四叉树的核心算法。后面讲；

4、Cluster管理：对外接口，通过调用核心算法实现点聚合功能、

整个功能的主要流程有两条：

1、添加item：Cluster管理类添加item接口 算法类添加item接口：记录所有的图片信息 四叉树类添加item接口：已四叉树的结构记录所有图片信息

2、获取聚合后的集合：Cluster管理类获取聚合接口 算法类核心算法接口：通过核心算法获取聚合后的集合
 
 
三、核心算法 
 
 
首先要说一个概念：世界宽度。
百度地图是把整个地球是按照一个平面来展开，并且通过[墨卡托投影](https://www.jfox.info/go.php?url=https://zh.wikipedia.org/wiki/%E9%BA%A5%E5%8D%A1%E6%89%98%E6%8A%95%E5%BD%B1%E6%B3%95)投射到xy坐标轴上面。上图：

![](/wp-content/uploads/2017/07/1500560446.png)

![](/wp-content/uploads/2017/07/1500560447.png)

很明显墨卡托投影把整张世界地图投影成

`X∈ [0,1] ; Y∈ [0,1]。`

的一个正方型区域。
X 表示的是经度，Y表示的是纬度。

（其实确认来说是投影一个上下无限延伸的长方体，只是Y属于[0,1]这个范围已经足够我们使用）上图说明：

![](/wp-content/uploads/2017/07/1500560448.png)

从上面看出 -85°的纬度对应Y坐标是1，那么-90°呢，你们自己可以去算一下，是+∞ （正无穷）。

至于为什么讲这个，因为计算搜索范围的时候，所有的经纬度都需要换算成Point 来计算，是不是很方便性，而且不易出错。
真是感叹伟人的强大！
 
 
附注 
转换的公式在下面这个类里面： 

    SphericalMercatorProjection.java

 
接下来说说如何通过四叉树组织数据 
 
 
四叉树的基本思想是把空间递归划分为不同层次的树结构。它把已知的空间等分成四个相等的子空间，如此递归下去，直到满足当层数目量超过50，或者层级数大于40则停止分割。示意图如下：

![](/wp-content/uploads/2017/07/1500560449.png)
 
OK，接下来说说具体流程  

1. 
遍历QuadItem,只加载屏幕内的点，生成四叉树，方便搜索。

2. 
如果图片已被visitedCandidate记录，则continue下面步骤，直到需要处理的图片没有被visitedCandidates记录；

3. 
对上一次屏幕上的点`QuadItem`先进行处理；

4. 
根据MAX_DISTANCE_IN_DP及图片位置计算出searchBounds;

5. 
通过四叉树得到searchBounds内所有的图片；

6. 
如果图片数量为1，记录并跳到步骤2；

7. 
遍历得到的图片；

8. 
依次对得到的图片进行处理，

9. 
如果图片到中心点的距离比distanceToCluster（此图片与包含此图片的前cluster的距离）小，把图片加入结果集，并移除前Cluster拥有该图片的引用，并记录此次更小的距离，跳步骤8继续遍历剩余项。

 
重点源码分析： 

    1.聚合触发口
    ClusterManager.java

    @Override
        public void onMapStatusChangeFinish(MapStatus mapStatus) {
            if (mRenderer instanceof BaiduMap.OnMapStatusChangeListener) {
                ((BaiduMap.OnMapStatusChangeListener) mRenderer).onMapStatusChange(mapStatus);
            }
    
            // 屏幕缩放范围太小，不进行触发聚合功能
            if (mPreviousCameraPosition != null
                    && Math.abs((int) mPreviousCameraPosition.zoom - (int) mapStatus.zoom) < 1
                    && mPreviousCameraPosition.target.latitude == mapStatus.target.latitude
                    && mPreviousCameraPosition.target.longitude == mapStatus.target.longitude) {
                return;
            }
           //记录
            mPreviousCameraPosition = mapStatus;
         
            //算法运算，计算出聚合后结果集，并且addMarker 到屏幕上
            cluster(mapStatus.zoom,mapStatus.bound);
        }

对地图进行手势操作，都会进行触发这个函数，并进行聚合操作

    2.算法运算
    NonHierarchicalDistanceBasedAlgorithm.java

    @Override
        public Set<Cluster<T>> getClusters(double zoom, LatLngBounds visibleBounds) {
        ...
        }

这个函数有点多，不过在github 上面的demo 已经注释满满，请移步github 查看。

    3.渲染UI(addMarker) 
    class DefaultClusterRenderer {
        class CreateMarkerTask {
           ...
        }
    }

    private void perform(MarkerModifier markerModifier) {
                // Don't show small clusters. Render the markers inside, instead.
                markRemoveAndAddLock.lock();
                //真正添加Marker 的地方
    
                Marker marker = mClusterToMarker.get(cluster);
                if (marker == null || (marker != null
                        && mMarkerToCluster.get(marker).getSize() != cluster.getSize())) {
                    //异步加载占时不添加Marker
                    Integer size = onReadyAddCluster.get(cluster);
                    if (size == null || size != cluster.getSize()) {
                        onReadyAddCluster.put(cluster,cluster.getSize());
                        onBeforeClusterRendered(cluster, new MarkerOptions()
                                .position(cluster.getPosition()));
    
                    }
                }
                markRemoveAndAddLock.unlock();
                newClusters.add(cluster);
    
            }

主要添加图片的是`onBeforeClusterRendered `这一个函数， 我们看一下实现：

    public class PersonRenderer extends DefaultClusterRenderer<LocalPictrue> {
      DataSource<CloseableReference<CloseableImage>> target = cancleMap1.get(cluster);
            if(target != null) {
                target.close();
                cancleMap1.remove(target);
            }
    
    
            final LocalPictrue person = cluster.getItems().iterator().next();
    
            ImageRequest imageRequest = ImageRequestBuilder
                    .newBuilderWithSource(Uri.fromFile(new File(person.path)))
                    .setProgressiveRenderingEnabled(false)
                    .setResizeOptions(new ResizeOptions(50, 50))
                    .setPostprocessor(new BadgViewPostprocessor(mContext,cluster))
                    .build();
    
            ImagePipeline imagePipeline = Fresco.getImagePipeline();
            DataSource<CloseableReference<CloseableImage>> dataSource =
                    imagePipeline.fetchDecodedImage(imageRequest,mContext);
    
            dataSource.subscribe(new BaseBitmapDataSubscriber() {
    
                @Override
                public void onNewResultImpl(@Nullable Bitmap bitmap) {
                    // You can use the bitmap in only limited ways
                    // No need to do any cleanup.
                    if(bitmap != null && !bitmap.isRecycled()) {
                        //you can use bitmap here
                        setIconByCluster(person.path,cluster,
                                markerOptions.icon(BitmapDescriptorFactory.fromBitmap(bitmap)));
                    }
                    cancleMap1.remove(cluster);
                }
    
                @Override
                public void onFailureImpl(DataSource dataSource) {
                    // No cleanup required here.
                    System.out.println("shibai");
                }
    
            }, UiThreadImmediateExecutorService.getInstance());
    
            cancleMap1.put(cluster, dataSource);
    
    }

很明显我这边解决了 baiduMap 在UI线程上添加图片阻塞问题， 添加强大的 fresco 第三方加载库，进行异步加载图片，接下来看图片下载完成后 执行`setIconByCluster` 函数：

    //异步回调回来的icon ，需要
        public void setIconByCluster(String path, Cluster<T> cluster, MarkerOptions markerOptions) {
            markRemoveAndAddLock.lock();
            Integer size = onReadyAddCluster.get(cluster);
            if (size != null && cluster.getSize() == size) {
                Marker marker = mClusterToMarker.get(cluster);
                if (marker != null) {
         //如果该图在屏幕上已经打了marker，那么替换icon即可，主要解决图片重新加载闪烁问题    
                  marker.setIcon(markerOptions.getIcon());
                } else {
                //打入新的Marker
                    marker = mClusterManager.getClusterMarkerCollection().addMarker(markerOptions);
                }
    
                mMarkerToCluster.put(marker, cluster);
                mClusterToMarker.put(cluster, marker);
            }
            markRemoveAndAddLock.unlock();
        }

 
总结： 

重点源码分析，基本上到这里结束。我们来撸一撸流程：

1. 
通过`onMapStatusChangeFinish`回调，去执行点聚合运算；

2. 
通过 `getClusters`把聚合后的结果集算出来；

3. 
通过`CreateMarkerTask.perform()` 把 marker打到屏幕上。
{% endraw %}
