---
layout: post
title:  "Hadoop MR &MRv2（YARN）编程模型"
title2:  "Hadoop MR &MRv2（YARN）编程模型"
date:   2017-01-01 23:52:54  +0800
source:  "http://www.jfox.info/hadoopmrmrv2yarn%e7%bc%96%e7%a8%8b%e6%a8%a1%e5%9e%8b.html"
fileName:  "20170101074"
lang:  "zh_CN"
published: true
permalink: "hadoopmrmrv2yarn%e7%bc%96%e7%a8%8b%e6%a8%a1%e5%9e%8b.html"
---
{% raw %}
**1 MapReduce编程模型**

      MapReduce将作业的整个运行过程分为两个阶段：Map阶段和Reduce阶段
      Map阶段由一定数量的Map Task组成
          输入数据格式解析：InputFormat
          输入数据处理：Mapper
          数据分组：Partitioner
      Reduce阶段由一定数量的Reduce Task组成
          数据远程拷贝
          数据按照key排序
          数据处理：Reducer
          数据输出格式：OutputFormat
    

**2 MapReduce工作原理**

如下图所示：

![](/wp-content/uploads/2017/07/1499261600.png)

Map阶段 

        InputFormat（默认TextInputFormat） 
        Mapper 
        Combiner（local reducer） 
        Partitioner 
    
    Reduce阶段  
        Reducer 
        OutputFormat（默认TextOutputFormat） 
    

InputFormat 

     1 数据文件分片（Input Split），按照固定块划分 
     2 处理跨行问题 
     3 将分片数据解析成key/value对 
     4 默认实现是TextInputFormat 
    

TextInputFormat 

      Key是行在文件中的偏移量，value是行内容 
      若行被截断，则读取下一个block的前几个字符 
    

Split与Block 

    Block： HDFS中最小的数据存储单位 默认是64MB 
    
    Spit：MapReduce中最小的计算单元，默认与Block一一对应 
    
    Split与Block是对应关系是任意的，可由用户控制 
    

Combiner 

       Combiner可做看local reducer 合并相同的key对应的value通常与Reducer逻辑一样 
    好处： 
        减少Map Task输出数据量（磁盘IO） 
        减少Reduce-Map网络传输数据量(网络IO) 
    

Partitioner 

    Partitioner决定了Map Task输出的每条数据交给哪个Reduce Task处理 
    
    默认实现：hash(key) mod R 
    
    R是Reduce Task数目允许用户自定义很多情况需自定义Partitioner 比如“hash(hostname(URL)) mod R”确保相同域名的网页交给同一个Reduce Task处理 
    

**3 MapReduce编程模型—内部逻辑**

![](/wp-content/uploads/2017/07/1499261609.png)

**4 MapReduce编程模型—外部物理结构**

![](/wp-content/uploads/2017/07/1499261612.png)

**5 MapReduce作业运行流程**

![](/wp-content/uploads/2017/07/1499261616.png)

流程分析：

1.客户端启动一个作业；

2.向JobTracker请求一个Job ID；

3.将运行作业所需要的资源文件复制到HDFS上，包括MapReduce程序打包的JAR文件、配置文件和客户端计算所得的输入划分信息。这些文件都存放在JobTracker专门为该作业创建的文件夹中，文件夹名为该作业的Job ID，其中：JAR文件默认会有10个副本（mapred.submit.replication属性控制）；输入划分信息告诉了JobTracker应该为这个作业启动多少个map任务等信息。 

4.JobTracker接收到作业后，将其放在一个作业队列里，等待作业调度器对其进行调度。当作业调度器根据自己的调度算法调度到该作业时，会根据输入划分信息为每个划分创建一个map任务，并将map任务分配给TaskTracker执行。对于map和reduce任务，TaskTracker根据主机核的数量和内存的大小有固定数量的map槽和reduce槽。需要强调的是：map任务按照数据本地化（Data-Local）分配给某个TaskTracker的。数据本地化（Data-Local）意思是：将map任务分配给含有该map处理的数据块的TaskTracker上，同时将程序JAR包复制到该TaskTracker上来运行，这叫“运算移动，数据不移动”。而分配reduce任务时并不考虑数据本地化。 

5.TaskTracker每隔一段时间会给JobTracker发送一个心跳，告诉JobTracker它依然在运行，同时心跳中还携带着很多的信息，比如当前map任务完成的进度等信息。当JobTracker收到作业的最后一个任务完成信息时，便把该作业设置成“成功”。当JobClient查询状态时，它将得知任务已完成，便显示一条消息给用户。

**6 Map、Reduce任务中Shuffle和排序的具体过程**

如下图所示： 

![](/wp-content/uploads/2017/07/1499261693.png)

流程分析： 

Map端： 

1．每个输入分片会让一个map任务来处理，默认情况下，以HDFS的一个块的大小（默认为64M）为一个分片，当然我们也可以设置块的大小。map输出的结果会暂且放在一个环形内存缓冲区中（该缓冲区的大小默认为100M，由io.sort.mb属性控制），当该缓冲区快要溢出时（默认为缓冲区大小的80%，由io.sort.spill.percent属性控制），会在本地文件系统中创建一个溢出文件，将该缓冲区中的数据写入这个文件。

2．在写入磁盘之前，线程首先根据reduce任务的数目将数据划分为相同数目的分区，也就是一个reduce任务对应一个分区的数据。这样做是为了避免有些reduce任务分配到大量数据，而有些reduce任务却分到很少数据，甚至没有分到数据的尴尬局面。其实分区就是对数据进行hash的过程。然后对每个分区中的数据进行排序，如果此时设置了Combiner，将排序后的结果进行combine操作，这样做的目的是让尽可能少的数据写入到磁盘。

3．当map任务输出最后一个记录时，可能会有很多的溢出文件，这时需要将这些文件合并。合并的过程中会不断地进行排序和combine操作，目的有两个：1.尽量减少每次写入磁盘的数据量；2.尽量减少下一复制阶段网络传输的数据量。最后合并成了一个已分区且已排序的文件。为了减少网络传输的数据量，这里可以将数据压缩，只要将mapred.compress.map.out设置为true就可以了。

4．将分区中的数据拷贝给相对应的reduce任务。reduce任务如何确认自己需要处理的数据来自那个map任务呢？ 其实map任务一直和其父TaskTracker保持联系，而TaskTracker又一直和JobTracker保持心跳。所以JobTracker中保存了整个集群中的宏观信息。只要reduce任务向JobTracker获取对应的map输出位置就好了。

这里还有一个Shuffle，Shuffle的中文意思是“混洗”，如果我们这样看：一个map产生的数据，结果通过hash过程分区却分配给了不同的reduce任务，。

Reduce端： 

1．Reduce会接收到不同map任务传来的数据，并且每个map传来的数据都是有序的。如果reduce端接受的数据量相当小，则直接存储在内存中（缓冲区大小由mapred.job.shuffle.input.buffer.percent属性控制，表示用作此用途的堆空间的百分比），如果数据量超过了该缓冲区大小的一定比例（由mapred.job.shuffle.merge.percent决定），则对数据合并后溢写到磁盘中。

2．随着溢写文件的增多，后台线程会将它们合并成一个更大的有序的文件，这样做是为了给后面的合并节省时间。其实不管在map端还是reduce端，MapReduce都是反复地执行排序，合并操作，现在终于明白了有些人为什么会说：排序是hadoop的灵魂。

3．合并的过程中会产生许多的中间文件（写入磁盘了），但MapReduce会让写入磁盘的数据尽可能地少，并且最后一次合并的结果并没有写入磁盘，而是直接输入到reduce函数。

**MapReduce编程相关—InputFormat**

InputFormat API

![](/wp-content/uploads/2017/07/1499261695.png)

InputFormat 负责处理MR的输入部分有三个作用: 
1验证作业的输入是否规范. 
2把输入文件切分成InputSplit. (处理跨行问题) 
3提供RecordReader 的实现类，把InputSplit读到Mapper中进行处理.

InputFormat类的层次结构

![](/wp-content/uploads/2017/07/1499262316.png)

**MapReduce编程模型—Split与Block**

      Split与Block简介
    
        Block: HDFS中最小的数据存储单位,默认是64MB
        Spit: MapReduce中最小的计算单元,默认与Block一一对应
        Block与Split: Split与Block是对应关系是任意的，可由用户控制.
    
     InputSplit
    
     在执行mapreduce之前，原始数据被分割成若干split，每个split作为一个map任务的输入，在map执行过程中split会被分解成一个个记录（key-value对），map会依次处理每一个记录。
      1.FileInputFormat只划分比HDFS block大的文件，所以FileInputFormat划分的结果是这个文件或者是这个文件中的一部分.                
      2.如果一个文件的大小比block小，将不会被划分，这也是Hadoop处理大文件的效率要比处理很多小文件的效率高的原因。
        3.  当hadoop处理很多小文件（文件大小小于hdfs block大小）的时候，由于FileInputFormat不会对小文件进行划分，所以每一个小文件都会被当做一个split并分配一个map任务，导致效率底下。例如：一个1G的文件，会被划分成16个64MB的split，并分配16个map任务处理，而10000个100kb的文件会被10000个map任务处理。   
    

**TextInputFormat**

       1.TextInputformat是默认的处理类，处理普通文本文件。
       2.文件中每一行作为一个记录，他将每一行在文件中的起始偏移量作为key，每一行的内容作为value。
       3.默认以n或回车键作为一行记录。
       4.TextInputFormat继承了FileInputFormat。
    

**其他输入类**

      CombineFileInputFormat
           相对于大量的小文件来说，hadoop更合适处理少量的大文件。
           CombineFileInputFormat可以缓解这个问题，它是针对小文件而设计的。
      KeyValueTextInputFormat
           当输入数据的每一行是两列，并用tab分离的形式的时候，KeyValueTextInputformat处理这种格式的文件非常适合。
      NLineInputformat 
           NLineInputformat可以控制在每个split中数据的行数。
    
      SequenceFileInputformat  
           当输入文件格式是sequencefile的时候，要使用SequenceFileInputformat作为输入。
    

**自定义输入格式**

        1）继承FileInputFormat基类。
        2）重写里面的getSplits(JobContext context)方法。
        3）重写createRecordReader(InputSplit split,TaskAttemptContext context)方法。
    

**MapReduce编程模型—Combiner**

![](/wp-content/uploads/2017/07/1499262318.png)

1 每一个map可能会产生大量的输出，combiner的作用就是在map端对输出先做一次合并，以减少传输到reducer的数据量。 
2 combiner最基本是实现本地key的归并，combiner具有类似本地的reduce功能，合并相同的key对应的value（wordcount例子），通常与Reducer逻辑一样。 
3 如果不用combiner，那么，所有的结果都是reduce完成，效率会相对低下。使用combiner，先完成的map会在本地聚合，提升速度。

好处：①减少Map Task输出数据量（磁盘IO）②减少Reduce-Map网络传输数据量(网络IO)

【注意：Combiner的输出是Reducer的输入，如果Combiner是可插拔（可有可无）的，添加Combiner绝不能改变最终的计算结果。所以Combiner只应该用于那种Reduce的输入key/value与输出key/value类型完全一致，且不影响最终结果的场景。比如累加，最大值等。】

**MapReduce编程模型—Partitioner**

1.Partitioner决定了Map Task输出的每条数据交给哪个Reduce Task处理 
2.默认实现：HashPartitioner是mapreduce的默认partitioner。计算方法是 reducer=(key.hashCode() & Integer.MAX_VALUE) % numReduceTasks，得到当前的目的reducer。(hash(key) mod R 其中R是Reduce Task数目) 
3.允许用户自定义 
很多情况需自定义Partitioner比如“hash(hostname(URL)) mod R”确保相同域名的网页交给同一个Reduce Task处理

**Reduce的输出**

1. 
TextOutputformat 默认的输出格式，key和value中间值用tab隔开的。 

2. 
SequenceFileOutputformat 将key和value以sequencefile格式输出。 

3. 
SequenceFileAsOutputFormat 将key和value以原始二进制的格式输出。 

4. 
MapFileOutputFormat 将key和value写入MapFile中。由于MapFile中的key是有序的，所以写入的时候必须保证记录是按key值顺序写入的。 

5. 
MultipleOutputFormat 默认情况下一个reducer会产生一个输出，但是有些时候我们想一个reducer产生多个输出，MultipleOutputFormat和MultipleOutputs可以实现这个功能。（还可以自定义输出格式，序列化会说到）

**MapReduce 2.0架构**

![](/wp-content/uploads/2017/07/1499262319.png)

Client 

    与MapReduce 1.0的Client类似，用户通过Client与YARN交互，提交MapReduce作业，查询作业运行状态，管理作业等。 
    

MRAppMaster 

    功能类似于 1.0中的JobTracker，但不负责资源管理； 
    
    功能包括：任务划分、资源申请并将之二次分配个Map Task和Reduce Task、任务状态监控和容错。 
    

**MapReduce 2.0容错性**

    一旦运行失败，由YARN的ResourceManager负责重新启动，最多重启次数可由用户设置，默认是2次。一旦超过最高重启次数，则作业运行失败。 
    
    Map Task/Reduce Task 
    

Task周期性向MRAppMaster汇报心跳；一旦Task挂掉，则MRAppMaster将为之重新申请资源，并运行之。最多重新运行次数可由用户设置，默认4次。 

数据本地性 

    什么是数据本地性（data locality）如果任务运行在它将处理的数据所在的节点，则称该任务具有“数据本地性” 本地性可避免跨节点或机架数据传输，提高运行效率 
    

数据本地性分类 

            同节点(node-local) 
    
            同机架(rack-local) 
    
            其他（off-switch） 
    

推测执行机制 
作业完成时间取决于最慢的任务完成时间 

      一个作业由若干个Map任务和Reduce任务构成 
    
      因硬件老化、软件Bug等，某些任务可能运行非常慢 
    
    推测执行机制 
    
      发现拖后腿的任务，比如某个任务运行速度远慢于任务平均速度 
    
      为拖后腿任务启动一个备份任务，同时运行 
    
       谁先运行完，则采用谁的结果 
    
    不能启用推测执行机制 
    
       任务间存在严重的负载倾斜 
    
       特殊任务，比如任务向数据库中写数据 
    

常见MapReduce应用场景 

     简单的数据统计，比如网站pv、uv统计 
    
     搜索发动机建索引 （mapreduce产生的原因） 
    
     海量数据查找 
    
     复杂数据分析算法实现 
    
            聚类算法 
    
            分类算法 
    
            推荐算法 
    
            图算法
{% endraw %}
