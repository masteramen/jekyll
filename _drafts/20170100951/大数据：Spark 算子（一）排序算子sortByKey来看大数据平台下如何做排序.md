---
layout: post
title:  "大数据：Spark 算子（一）排序算子sortByKey来看大数据平台下如何做排序"
title2:  "大数据：Spark 算子（一）排序算子sortByKey来看大数据平台下如何做排序"
date:   2017-01-01 23:50:51  +0800
source:  "http://www.jfox.info/%e5%a4%a7%e6%95%b0%e6%8d%ae-spark-%e7%ae%97%e5%ad%90-%e4%b8%80-%e6%8e%92%e5%ba%8f%e7%ae%97%e5%ad%90sortbykey%e6%9d%a5%e7%9c%8b%e5%a4%a7%e6%95%b0%e6%8d%ae%e5%b9%b3%e5%8f%b0%e4%b8%8b%e5%a6%82%e4%bd%95.html"
fileName:  "20170100951"
lang:  "zh_CN"
published: true
permalink: "%e5%a4%a7%e6%95%b0%e6%8d%ae-spark-%e7%ae%97%e5%ad%90-%e4%b8%80-%e6%8e%92%e5%ba%8f%e7%ae%97%e5%ad%90sortbykey%e6%9d%a5%e7%9c%8b%e5%a4%a7%e6%95%b0%e6%8d%ae%e5%b9%b3%e5%8f%b0%e4%b8%8b%e5%a6%82%e4%bd%95.html"
---
{% raw %}
# 大数据：Spark 算子（一）排序算子sortByKey来看大数据平台下如何做排序 


在前面一系列博客中，特别在Shuffle博客系列中，曾描述过在生成ShuffleWrite的文件的时候，对每个partition会先进行排序并spill到文件中，最后合并成ShuffleWrite的文件，也就是每个Partition里的内容已经进行了排序，在最后的action操作的时候需要对每个executor生成的shuffle文件相同的Partition进行合并，完成Action的操作。  
 
 **排序算子和常见的reduce算子算法有何区别？** 
 

  常见的一些聚合算子，reduce算子，并不需要排序，需要做的是 
 
 
 
- 将相同的hashcode分配到同一个partition，哪怕是不同的executor
- 在做最后的合并的时候，只需要合并不同的executor里相同的partition就可以了
- 对每个partition进行排序，考虑的是内存因数，解决的是最后的多文件使用外排序堆相同的key合并的问题

# 2 排序
 

  先给个排序的小例子： 
 
 
 
    package spark.sort
    import org.apache.spark.SparkConf
    import org.apache.spark.SparkContext
    object sortsample {
      def main(args: Array[String]) {
        val conf = new SparkConf().setAppName("sortsample")
        val sc = new SparkContext(conf)
        var pairs = sc.parallelize(Array(("a",0),("b",0),("c",3),("d",6),("e",0),("f",0),("g",3),("h",6)), 2);
        pairs.sortByKey(true, 3).collect().foreach(println);
      }
    }

 核心代码： 
 OrderedRDDFunctions.scala 
  

  会很奇怪么？RDD里面并没有sortByKey的方法？在这里和前面博客里提到的PairRDDFunctions一样，隐式转换： 
  
 
 
      implicit def rddToOrderedRDDFunctions[K : Ordering : ClassTag, V: ClassTag](rdd: RDD[(K, V)])
        : OrderedRDDFunctions[K, V, (K, V)] = {
        new OrderedRDDFunctions[K, V, (K, V)](rdd)
      }

 调用的是OrderedRDDFunctions.scala里的方法 
 

     def sortByKey(ascending: Boolean = true, numPartitions: Int = self.partitions.length)
          : RDD[(K, V)] = self.withScope
      {
        val part = new RangePartitioner(numPartitions, self, ascending)
        new ShuffledRDD[K, V, V](self, part)
          .setKeyOrdering(if (ascending) ordering else ordering.reverse)
      }

 对Partition采用了范围分配的策略，为何要使用范围分配的策略？这还是比较容易理解，对其它非排序类型的算子，使用散列算法，只要保证相同的key是分配在相同的partition就可以了，并不会影响相同的key的合并，计算。 
 

  而对排序来说，如果只是保证相同的key在相同的Partition并不足够，最后的排序还是需要合并所有的Partition进行排序合并，如果这发生在Driver端做这件事，将会非常可怕，那么我们该做些策略改变，制定一些Range，将排序上临近的分成同一个Rang，使排序相近的key分配到同一个Range上，在把Range扩大化，一个Partition管理一个Range 
 
![](/wp-content/uploads/2017/06/Center15.png)
## 2.1 分配Range
 

  range的非配不合理，会影响数据的不均衡，也就是导致executor在做同Partition排序的时候会不均衡，并行计算的整体性能往往会被单个最糟糕的运行节点所拖累，如果提高运算的速度，需要考虑数据分配的均衡性。 
  

### 2.1.1 每个区块采样大小

 

  获取所有的key，然后在来制定区间，这显然是不明智的，这样会变成一个全量数据的排序，然后在重新划分数据，所需需要采样部分数据进行区间划分 
 

  Partitioner.scala rangeBounds 
 
代码如下： 
 
 
 
    val sampleSize = math.min(20.0 * partitions, 1e6)
          // Assume the input partitions are roughly balanced and over-sample a little bit.
          val sampleSizePerPartition = math.ceil(3.0 * sampleSize / rdd.partitions.length).toInt
          val (numItems, sketched) = RangePartitioner.sketch(rdd.map(_._1), sampleSizePerPartition)

- partitions: 参数在指定sortByKey的时候设置的区块大小：3

    pairs.sortByKey(true, 3)

- rdd.partitions: 指的是在数据的分区块大小:2

    sc.parallelize(Array(("a",0),("b",0),("c",3),("d",6),("e",0),("f",0),("g",3),("h",6)), 2)

需要采样的数量是通过几个固定参数来设计的 
  
 

### 2.1.2 Sketch采样(蓄水池采样法)

      def sketch[K : ClassTag](
          rdd: RDD[K],
          sampleSizePerPartition: Int): (Long, Array[(Int, Long, Array[K])]) = {
        val shift = rdd.id
        // val classTagK = classTag[K] // to avoid serializing the entire partitioner object
        val sketched = rdd.mapPartitionsWithIndex { (idx, iter) =>
          val seed = byteswap32(idx ^ (shift << 16))
          val (sample, n) = SamplingUtils.reservoirSampleAndCount(
            iter, sampleSizePerPartition, seed)
          Iterator((idx, n, sample))
        }.collect()
        val numItems = sketched.map(_._2).sum
        (numItems, sketched)
      }

mapPartitionsWithIndex, collection 都是需要在提交job进行运算的，也就是采样的过程中，是通过executor执行了一次job 
  
 
 
      def reservoirSampleAndCount[T: ClassTag](
          input: Iterator[T],
          k: Int,
          seed: Long = Random.nextLong())
        : (Array[T], Long) = {
        val reservoir = new Array[T](k)
        // Put the first k elements in the reservoir.
        var i = 0
        while (i < k && input.hasNext) {
          val item = input.next()
          reservoir(i) = item
          i += 1
        }
        // If we have consumed all the elements, return them. Otherwise do the replacement.
        if (i < k) {
          // If input size < k, trim the array to return only an array of input size.
          val trimReservoir = new Array[T](i)
          System.arraycopy(reservoir, 0, trimReservoir, 0, i)
          (trimReservoir, i)
        } else {
          // If input size > k, continue the sampling process.
          var l = i.toLong
          val rand = new XORShiftRandom(seed)
          while (input.hasNext) {
            val item = input.next()
            l += 1
            // There are k elements in the reservoir, and the l-th element has been
            // consumed. It should be chosen with probability k/l. The expression
            // below is a random long chosen uniformly from [0,l)
            val replacementIndex = (rand.nextDouble() * l).toLong
            if (replacementIndex < k) {
              reservoir(replacementIndex.toInt) = item
            }
          }
          (reservoir, l)
        }
      }

函数 
 reservoirSampleAndCount采样 
 
 
 
- 当数据小于要采样的集合的时候，可以使用数据为样本
- 当数据集合超过需要采样数目的时候会继续遍历整个数据集合，通过随机数进行位置的随机替换，保证采样数据的随机性 

 
 

  返回的结果里包含了总数据集，区块编号，区块的数量，每个区块的采样集 
  

### 2.1.3 重新采样
 

  为了避免某些区块的数据量过大，设置了一个阈值： 
 
 
 
    val fraction = math.min(sampleSize / math.max(numItems, 1L), 1.0)

阈值＝采样数除于总数据量，当某个区块的数据量＊阈值大于每个区的采样率的时候，认为这个区块的采样率是不足的，需要重新采样 
 
 
 
    val imbalanced = new PartitionPruningRDD(rdd.map(_._1), imbalancedPartitions.contains)
              val seed = byteswap32(-rdd.id - 1)
              val reSampled = imbalanced.sample(withReplacement = false, fraction, seed).collect()
              val weight = (1.0 / fraction).toFloat
              candidates ++= reSampled.map(x => (x, weight))

### 2.1.4 采样集key的权重
 

  上面我们对每个区进行了相同数量的采样，但是每个区的数量有可能是不均衡的，需要对每个区采样的key进行权重设置，尽量分配高权重给数据量多的区 
 

  权重因子： 
 
 
 
    val weight = (n.toDouble / sample.length).toFloat

n 是区的数据数量 
 

  sample 是采样的数量 
 

  这里权重的最小值是1，因为采样的数量肯定是小于等于数据 
  

  当数据量大于采样数量的时候，每个区的采样数量是相同的，那么意味着区的数据量越大，该区块的key的权重也就越大 
  
 
 
### 2.1.5 分配每个区块的range
 
 

  样本已经采集好了，现在需要对依据样本进行区块的range进行分配 
 
 
 
- 先对样本进行排序
- 依据每个样本的权重计算每个区块平均所分配的权重
- 最后通过每个区分配的权重**按照顺序**来决定获取哪些样本用作range，一个区分配一个样本区间

      def determineBounds[K : Ordering : ClassTag](
          candidates: ArrayBuffer[(K, Float)],
          partitions: Int): Array[K] = {
        val ordering = implicitly[Ordering[K]]
        val ordered = candidates.sortBy(_._1)
        val numCandidates = ordered.size
        val sumWeights = ordered.map(_._2.toDouble).sum
        val step = sumWeights / partitions
        var cumWeight = 0.0
        var target = step
        val bounds = ArrayBuffer.empty[K]
        var i = 0
        var j = 0
        var previousBound = Option.empty[K]
        while ((i < numCandidates) && (j < partitions - 1)) {
          val (key, weight) = ordered(i)
          cumWeight += weight
          if (cumWeight >= target) {
            // Skip duplicate values.
            if (previousBound.isEmpty || ordering.gt(key, previousBound.get)) {
              bounds += key
              target += step
              j += 1
              previousBound = Some(key)
            }
          }
          i += 1
        }
        bounds.toArray
      }

## 2.2 ShuffleWriter
 
 
   在前面的一序列的博客里都是介绍了SortShuffleWrite，在sortByKey的情况下使用了BypassMergeSortShuffleWriter，把焦点聚焦到key如何分配到Partitioner和每个Partition的文件将会如何写入key，value 
  
  
  
    while (records.hasNext()) {
          final Product2<K, V> record = records.next();
          final K key = record._1();
          partitionWriters[partitioner.getPartition(key)].write(key, record._2());
        }

### 2.2.1 分配key到Partition
 
  
 
   在函数调用了，partitioner.getPartition方法，还是回到RangePartitioner类中 
  
  
  
     def getPartition(key: Any): Int = {
        val k = key.asInstanceOf[K]
        var partition = 0
        if (rangeBounds.length <= 128) {
          // If we have less than 128 partitions naive search
          while (partition < rangeBounds.length && ordering.gt(k, rangeBounds(partition))) {
            partition += 1
          }
        } else {
          // Determine which binary search method to use only once.
          partition = binarySearch(rangeBounds, k)
          // binarySearch either returns the match location or -[insertion point]-1
          if (partition < 0) {
            partition = -partition-1
          }
          if (partition > rangeBounds.length) {
            partition = rangeBounds.length
          }
        }
        if (ascending) {
          partition
        } else {
          rangeBounds.length - partition
        }
      }
    

- 当Partition的分配数小于128的时候，轮训的查找每个Partition
- 当Partition大于128的时候，使用二分法查找Partition 

### 2.2.2 生成shuffle文件

- 基于前面对key进行排序的partition的分配，写到对应的partition文件中
- 合并Partition文件生成index和data文件（shuffle_shuffleid_mapid_0.index）（shuffle_shuffleid_mapid_0.data）因为Partition已经合并了，最后一位reduceID都是为0

**注意：在这里并没有象SortShuffleWrite 对每个Partition进行排序,Spill 文件，最后合并文件，而是直接写到了Partition文件中。**
## 2.3 Shuffle Read
 
 
   在 
  BlockStoreShuffleReader的read函数里 
  
  
  
      dep.keyOrdering match {
          case Some(keyOrd: Ordering[K]) =>
            // Create an ExternalSorter to sort the data. Note that if spark.shuffle.spill is disabled,
            // the ExternalSorter won't spill to disk.
            val sorter =
              new ExternalSorter[K, C, C](context, ordering = Some(keyOrd), serializer = dep.serializer)
            sorter.insertAll(aggregatedIter)
            context.taskMetrics().incMemoryBytesSpilled(sorter.memoryBytesSpilled)
            context.taskMetrics().incDiskBytesSpilled(sorter.diskBytesSpilled)
            context.taskMetrics().incPeakExecutionMemory(sorter.peakMemoryUsedBytes)
            CompletionIterator[Product2[K, C], Iterator[Product2[K, C]]](sorter.iterator, sorter.stop())
          case None =>
            aggregatedIter
        }

  
  
    ExternalSorter.insertAll函数 
   

     while (records.hasNext) {
            addElementsRead()
            val kv = records.next()
            buffer.insert(getPartition(kv._1), kv._1, kv._2.asInstanceOf[C])
            maybeSpillCollection(usingMap = false)
          }

 
  ExternalSorter函数，这个函数在前面的 
  [这篇博客](http://www.jfox.info/go.php?url=http://blog.csdn.net/raintungli/article/details/70807376)里介绍的比较清楚，但这里的结构体和博客介绍的不太一样 
  
  
  
     @volatile private var map = new PartitionedAppendOnlyMap[K, C]
      @volatile private var buffer = new PartitionedPairBuffer[K, C]

 
  
 
   在reduceByKey的这些算子，相同的Key是需要合并的，需要使用Map结构处理相同的Key的值的合并问题，但对排序来说，是不需要相同的值合并，使用Array结构就足够了。 
  
 
   在Spark上实现Map、Array都使用了数组的结构，并没有用链表结构。 
       
 
   在上图的PartitionPairBuffer结构中，有几个点要注意 
  
  
  
1. 插入KV结构的时候，并没有进行排序，也就是在处理相同的Partition的时候合并Key值并没有进行
2. 依然会存在当内存不够，Spill到磁盘的情况，关于Spill请具体参考[博客](http://www.jfox.info/go.php?url=http://blog.csdn.net/raintungli/article/details/70807376#t3)链接

### 2.3.1 排序
 
 
   当ExternalSorter.insertAll函数完成后，才会构建一个排序的迭代器 
  
  
  
      def partitionedIterator: Iterator[(Int, Iterator[Product2[K, C]])] = {
             
       
       
    -  val collection: WritablePartitionedPairCollection[K, C] = if (usingMap) map else buffer
    
        val usingMap = aggregator.isDefined
        if (spills.isEmpty) {
          // Special case: if we have only in-memory data, we don't need to merge streams, and perhaps
          // we don't even need to sort by anything other than partition ID
          if (!ordering.isDefined) {
            // The user hasn't requested sorted keys, so only sort by partition ID, not key
            groupByPartition(destructiveIterator(collection.partitionedDestructiveSortedIterator(None)))
          } else {
            // We do need to sort by both partition ID and key
            groupByPartition(destructiveIterator(
              collection.partitionedDestructiveSortedIterator(Some(keyComparator))))
          }
        } else {
          // Merge spilled and in-memory data
          merge(spills, destructiveIterator(
            collection.partitionedDestructiveSortedIterator(comparator)))
        }
      }

这里分成两种情况： 
  
  
  
- 还在内存里没有Spill到文件中去，这时候构建一个内存里的PartitionedDestructiveSortedIterator迭代器，在迭代器中已经排序好了PartitionPairBuffer里的内容

      /** Iterate through the data in a given order. For this class this is not really destructive. */
      override def partitionedDestructiveSortedIterator(keyComparator: Option[Comparator[K]])
        : Iterator[((Int, K), V)] = {
        val comparator = keyComparator.map(partitionKeyComparator).getOrElse(partitionComparator)
        new Sorter(new KVArraySortDataFormat[(Int, K), AnyRef]).sort(data, 0, curSize, comparator)
        iterator
      }

- Spill到文件里的，文件里的已经排好序了，还需要对内存里的PartitionPairBuffer进行排序（和前面相同的处理），然后对文件和内存进行外排序（外排序可参考[博客](http://www.jfox.info/go.php?url=http://blog.csdn.net/raintungli/article/details/70807376#t5)）

## 2.4 最后的归并
在Dag-scheduler-event-loop 线程中会处理每个executor返回的结果，也就是刚才的Partition的结果 
 
 
 
      private[scheduler] def handleTaskCompletion(event: CompletionEvent) {
    ....
      case Success =>
            stage.pendingPartitions -= task.partitionId
            task match {
              case rt: ResultTask[_, _] =>
                // Cast to ResultStage here because it's part of the ResultTask
                // TODO Refactor this out to a function that accepts a ResultStage
                val resultStage = stage.asInstanceOf[ResultStage]
                resultStage.activeJob match {
                  case Some(job) =>
                    if (!job.finished(rt.outputId)) {
                      updateAccumulators(event)
                      job.finished(rt.outputId) = true
                      job.numFinished += 1
                      // If the whole job has finished, remove it
                      if (job.numFinished == job.numPartitions) {
                        markStageAsFinished(resultStage)
                        cleanupStateForJobAndIndependentStages(job)
                        listenerBus.post(
                          SparkListenerJobEnd(job.jobId, clock.getTimeMillis(), JobSucceeded))
                      }
                      // taskSucceeded runs some user code that might throw an exception. Make sure
                      // we are resilient against that.
                      try {
                        job.listener.taskSucceeded(rt.outputId, event.result)
                      } catch {
                        case e: Exception =>
                          // TODO: Perhaps we want to mark the resultStage as failed?
                          job.listener.jobFailed(new SparkDriverExecutionException(e))
                      }
                    }
    }

通过方法taskSucceeded的方法进行每个Partition的合并 
 
 
 
    job.listener.taskSucceeded(rt.outputId, event.result)

      override def taskSucceeded(index: Int, result: Any): Unit = {
        // resultHandler call must be synchronized in case resultHandler itself is not thread safe.
        synchronized {
          resultHandler(index, result.asInstanceOf[T])
        }
        if (finishedTasks.incrementAndGet() == totalTasks) {
          jobPromise.success(())
        }
      }

 调用了resultHandler方法，继续看看resultHandler是怎样定义的 
 
 
 
      def runJob[T, U: ClassTag](
          rdd: RDD[T],
          func: (TaskContext, Iterator[T]) => U,
          partitions: Seq[Int]): Array[U] = {
        val results = new Array[U](partitions.size)
        runJob[T, U](rdd, func, partitions, (index, res) => results(index) = res)
        results
      }

在runJob的方法里 
 
 
 
      def runJob[T, U: ClassTag](
          rdd: RDD[T],
          func: (TaskContext, Iterator[T]) => U,
          partitions: Seq[Int],
          resultHandler: (Int, U) => Unit): Unit = {
        if (stopped.get()) {
          throw new IllegalStateException("SparkContext has been shutdown")
        }
        val callSite = getCallSite
        val cleanedFunc = clean(func)
        logInfo("Starting job: " + callSite.shortForm)
        if (conf.getBoolean("spark.logLineage", false)) {
          logInfo("RDD's recursive dependencies:n" + rdd.toDebugString)
        }
        dagScheduler.runJob(rdd, cleanedFunc, partitions, callSite, resultHandler, localProperties.get)
        progressBar.foreach(_.finishAll())
        rdd.doCheckpoint()
      }

也就是： 
 
    (index, res) => results(index) = res)

构建了一个数组result，将每个Partition的数值保存到result的数组里 
 

  result[0]=partition[0] =array(tuple,tuple…..) 
  
 
 **什么时候对所有的Partition最后合并呢？** 
 

  来看RDD的collect算子 
 
 
 
      def collect(): Array[T] = withScope {
        val results = sc.runJob(this, (iter: Iterator[T]) => iter.toArray)
        Array.concat(results: _*)
      }

runJob返回的是result的数组，每个Partition是管理不同的范围，最后的合并只要简单的将不同的Partition合并就可以了 
 

# 3. 排序完整的流程

- Driver 提交一个采样任务，需要Executor对每个Partition进行数据采样，数据采样是一次全数据的扫描
- Driver 获取采样数据，每个Partition的数据量，依据数据量的权重，进行Range的分配
- Driver 开始进行排序，先提交ShuffleMapTask ，Executor对分配到自己的数据基于Range进行Partition的分配，直接写入Shuffle文件中
- Driver 提交ResultTask，Executor读取Shuffle文件中相同的Partition进行合并（相同的key不做值的合并）、排序
- Driver 接收到ResultTask的值后，最后进行不同的Partition数据合并
{% endraw %}
