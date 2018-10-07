---
layout: post
title:  "Java你应该懂点多线程1-Stream、Executor、CompletableFuture"
title2:  "Java你应该懂点多线程1-Stream、Executor、CompletableFuture"
date:   2017-01-01 23:58:29  +0800
source:  "http://www.jfox.info/java%e4%bd%a0%e5%ba%94%e8%af%a5%e6%87%82%e7%82%b9%e5%a4%9a%e7%ba%bf%e7%a8%8b1streamexecutorcompletablefuture.html"
fileName:  "20170101409"
lang:  "zh_CN"
published: true
permalink: "java%e4%bd%a0%e5%ba%94%e8%af%a5%e6%87%82%e7%82%b9%e5%a4%9a%e7%ba%bf%e7%a8%8b1streamexecutorcompletablefuture.html"
---
{% raw %}
作者[Mr_AG](/u/86feb75a6296)2017.07.29 07:05字数 2580
# Stream

## Stream常用操作

集合扩展类，通过`Collection.stream()`和`Collection.parallelStream()`来创建一个Stream。

## Stream常用操作

下边操作例子数据源

    List<String> stringCollection = new ArrayList<>();
    stringCollection.add("ddd2");
    stringCollection.add("aaa2");
    stringCollection.add("bbb1");
    stringCollection.add("aaa1");
    stringCollection.add("bbb3");
    stringCollection.add("ccc");
    stringCollection.add("bbb2");
    stringCollection.add("ddd1");
    

过滤通过一个predicate接口来过滤并只保留符合条件的元素，该操作属于中间操作，所以我们可以在过滤后的结果来应用其他Stream操作（比如forEach）。forEach需要一个函数来对过滤后的元素依次执行。forEach是一个最终操作，所以我们不能在forEach之后来执行其他Stream操作。

    stringCollection
        .stream()
        .filter((s) -> s.startsWith("a"))
        .forEach(System.out::println);
    

排序是一个中间操作，返回的是排序好后的Stream。如果你不指定一个自定义的Comparator则会使用默认排序。需要注意的是，排序只创建了一个排列好后的Stream，而不会影响原有的数据源，排序之后原数据是不会被修改的。

    stringCollection
        .stream()
        .sorted()
        .filter((s) -> s.startsWith("a"))
        .forEach(System.out::println);
    
    

中间操作map会将元素根据指定的Function接口来依次将元素转成另外的对象，下面的示例展示了将字符串转换为大写字符串。你也可以通过map来讲对象转换成其他类型，map返回的Stream类型是根据你map传递进去的函数的返回值决定的。

    stringCollection
        .stream()
        .map(String::toUpperCase)
        .sorted((a, b) -> b.compareTo(a))
        .forEach(System.out::println);
    

Stream提供了多种匹配操作，允许检测指定的Predicate是否匹配整个Stream。所有的匹配操作都是最终操作，并返回一个boolean类型的值。

    boolean anyStartsWithA = 
        stringCollection
            .stream()
            .anyMatch((s) -> s.startsWith("a"));
    System.out.println(anyStartsWithA);      // true
    
    boolean allStartsWithA = 
        stringCollection
            .stream()
            .allMatch((s) -> s.startsWith("a"));
    System.out.println(allStartsWithA);      // false
    
    boolean noneStartsWithZ = 
        stringCollection
            .stream()
            .noneMatch((s) -> s.startsWith("z"));
    System.out.println(noneStartsWithZ);      // true
    

计数是一个最终操作，返回Stream中元素的个数，返回值类型是long。

    long startsWithB = 
        stringCollection
            .stream()
            .filter((s) -> s.startsWith("b"))
            .count();
    System.out.println(startsWithB);    // 3
    

这是一个最终操作，允许通过指定的函数来讲stream中的多个元素规约为一个元素，规越后的结果是通过Optional接口表示的。

    Optional<String> reduced =
        stringCollection
            .stream()
            .sorted()
            .reduce((s1, s2) -> s1 + "#" + s2);
    reduced.ifPresent(System.out::println);
    

前面提到过Stream有串行和并行两种，串行Stream上的操作是在一个线程中依次完成，而并行Stream则是在多个线程上同时执行。

首先我们创建一个没有重复元素的大表,然后我们计算一下排序这个Stream要耗时多久

    int max = 1000000;
    List<String> values = new ArrayList<>(max);
    for (int i = 0; i < max; i++) {
        UUID uuid = UUID.randomUUID();
        values.add(uuid.toString());
    }
    

串行排序：

    long t0 = System.nanoTime();
    long count = values.stream().sorted().count();
    System.out.println(count);
    long t1 = System.nanoTime();
    long millis = TimeUnit.NANOSECONDS.toMillis(t1 - t0);
    System.out.println(String.format("sequential sort took: %d ms", millis));
    // 串行耗时: 899 ms
    

并行排序：

    long t0 = System.nanoTime();
    long count = values.parallelStream().sorted().count();
    System.out.println(count);
    long t1 = System.nanoTime();
    long millis = TimeUnit.NANOSECONDS.toMillis(t1 - t0);
    System.out.println(String.format("parallel sort took: %d ms", millis));
    // 并行排序耗时: 472 ms
    

上面两个代码几乎是一样的，但是并行版的快了50%之多，唯一需要做的改动就是将stream()改为parallelStream()。

# Lumbda 、Executors处理线程并发

    new Thread(() -> System.out.println("Single Thread Run.............")).start(); 
    

- ExecutorService管理无返回值的线程（ExecutorService+runnable）

Executos支持运行异步任务，通常管理一个线程池，这样一来我们就不需要手动去创建新的线程。

    ExecutorService executorService = Executors.newSingleThreadExecutor();  
    executorService.submit(() -> {  
        try {  
            TimeUnit.SECONDS.sleep(4);  
        } catch (InterruptedException e1) {  
            e1.printStackTrace();  
        }  
        System.out.println("thread managed by executorservice……");  
    });  
    try {  
        System.out.println("尝试关闭ExecutorService");  
        executorService.shutdown();  
        //指定一段时间温和关闭  
        executorService.awaitTermination(5, TimeUnit.SECONDS);  
    }  
    catch (InterruptedException e) {  
        System.out.println("任务中断……");  
    }  
    finally {  
        if (!executorService.isTerminated()) {  
            System.out.println("结束未完成的任务……");  
        }  
        executorService.shutdownNow();  
        System.out.println("ExecutorService被停止……");  
    }  
    

**注**：Java进程从没有停止！Executors必须显式的停止-否则它们将持续监听新的任务。如果执行executorService.shutdown();时任务未终止，会报java.lang.InterruptedException: sleep interrupted异常。

- ExecutorService管理有返回值的线程（ExecutorService+callable+future）

    Callable<String>callable = ()-> {  
        TimeUnit.SECONDS.sleep(4);  
        return "managed by executor and have result to return";  
    };   
    ExecutorService executorService = Executors.newSingleThreadExecutor();  
    Future<String> future = executorService.submit(callable);  
    try {  
         String result = future.get();  
         System.out.print(result);   
    } catch (Exception e) {  
        e.printStackTrace();  
    }   
    

**注**：future.get()是一个阻塞的方法，上述代码中大约4s之后值才输出出来

- Executors批量处理多个callable并返回所有callable的运行结果（Executor+callable+future+invokeAll）

    private static void testInvokeAll(){  
     ExecutorService executorService = Executors.newWorkStealingPool();  
     List<Callable<String>> callables = Arrays.asList(getCallable("download apk...........", 4),getCallable("download files...........", 10),getCallable("download pictures...........", 6));  
     try {  
        executorService.invokeAll(callables)  
         .stream()  
         .map(future ->{  
             try{  
                 return future.get();  
             }catch (Exception e) {  
                e.printStackTrace();  
                return "";  
            }  
         })  
         .forEach(System.out::println);  
    } catch (InterruptedException e) {  
        e.printStackTrace();  
    }  
    }  
      
    private static Callable<String> getCallable(String s,long time){  
     Callable<String> callable = ()-> {  
         TimeUnit.SECONDS.sleep(time);  
         return s;  
     };   
     return callable;  
    }  
    

**注**：三个任务执行的时间分别为4s、10s、6s，invokeAll会在所有的任务都执行完也就是10s之后才输出结果

- Executors批量处理多个callable并返回运行最快的callable的运行结果（Executor+invokeAny）

    
    long startTime = System.currentTimeMillis(); 
    ExecutorService executorService = Executors.newWorkStealingPool();  
    List<Callable<String>> callables = Arrays.asList(getCallable("download apk...........", 4),getCallable("download files...........", 10),getCallable("download pictures...........", 6));  
    try {  
        String result = executorService.invokeAny(callables);  
        System.out.println("执行..."+result+"...花了........."+(System.currentTimeMillis() - startTime)/1000 +"s..............");  
    } catch (Exception e) {  
        e.printStackTrace();  
    }  
    

**注**：invokeAll返回集合中所有callable的结果，invokeAny只返回一个值，即运行最快的那个callable的值

- Executors延迟一段时间执行任务（executorService.schedule(task,time,timeUnit)）

    ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);  
             executorService.schedule(() -> System.out.println("test delay runnable.............."), 3, TimeUnit.SECONDS);  
    

- Executors以固定时间执行任务（executorService.scheduleAtFixedRate()）

    ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);  
     executorService.scheduleAtFixedRate(() -> System.out.println("test fixed delay runnable.............."), 3,5, TimeUnit.SECONDS);  
    

3s后第一次输出结果，然后每5s执行一次任务
注：scheduleAtFixedRate()并不考虑任务的实际用时。所以，如果你指定了一个period为1分钟而任务需要执行2分钟，那么线程池为了性能会更快的执行。

- Executors两次任务之间以固定的间隔执行（executorService.scheduleWithFixedDelay()）

    ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);  
    executorService.scheduleWithFixedDelay(() -> 
    {
        System.out.println("test fixed delay runnable..............");  
        try {  
            TimeUnit.SECONDS.sleep(2);  
        } catch (InterruptedException e) {  
            e.printStackTrace();  
        }
    }, 3,5, TimeUnit.SECONDS);  
    

**注**：该方法是在3s后第一次执行任务输出结果，然后在任务执行完后的时间间隔是5，即以后每隔7s输出一次结果（执行任务的时间+任务间隔）

# CompletableFuture

CompletableFuture有两个主要的方面优于ol中的Future – 异步回调/转换，这能使得从任何时刻的任何线程都可以设置CompletableFuture的值。

手动地创建CompletableFuture是我们唯一的选择吗？不一定。就像一般的Futures，我们可以关联存在的任务，同时CompletableFuture使用工厂方法：

    static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier);
    static <U> CompletableFuture<U> supplyAsync(Supplier<U> supplier, Executor executor);
    static CompletableFuture<Void> runAsync(Runnable runnable);
    static CompletableFuture<Void> runAsync(Runnable runnable, Executor executor);
    

runAsync()易于理解，注意它需要Runnable，因此它返回`CompletableFuture<Void>`作为Runnable不返回任何值。如果你需要处理异步操作并返回结果，使用`Supplier<U>`:

    final CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
        //...long running...
        return "42";
    }, executor);
    //或
    final CompletableFuture<String> future =
        CompletableFuture.supplyAsync(() -> longRunningTask(params), executor);
    

    CompletableFuture<String> safe =
        future.exceptionally(ex -> "We have a problem: " + ex.getMessage());
    

exceptionally()接受一个函数时，将调用原始future来抛出一个异常。我们会有机会将此异常转换为和Future类型的兼容的一些值来进行恢复。safe进一步的转换将不再产生一个异常而是从提供功能的函数返回一个String值。

一个更加灵活的方法是handle()接受一个函数，它接收正确的结果或异常：

    CompletableFuture<Integer> safe = future.handle((ok, ex) -> {
        if (ok != null) {
            return Integer.parseInt(ok);
        } else {
            log.warn("Problem", ex);
            return -1;
        }
    });
    

- 转换和作用于CompletableFuture(thenApply)

    <U> CompletableFuture<U> thenApply(Function<? super T,? extends U> fn);
    <U> CompletableFuture<U> thenApplyAsync(Function<? super T,? extends U> fn);
    <U> CompletableFuture<U> thenApplyAsync(Function<? super T,? extends U> fn, Executor executor);
    

例子：

    CompletableFuture<String> f1 = //...
    CompletableFuture<Integer> f2 = f1.thenApply(Integer::parseInt);
    CompletableFuture<Double> f3 = f2.thenApply(r -> r * r * Math.PI);
    

- 运行完成的代码（thenAccept/thenRun）

    CompletableFuture<Void> thenAccept(Consumer<? super T> block);
    CompletableFuture<Void> thenRun(Runnable action);
    

在future的管道里有两种典型的“最终”阶段方法。他们在你使用future的值的时候做好准备，当 thenAccept()提供最终的值时，thenRun执行 Runnable，这甚至没有方法去计算值。例如：

    future.thenAcceptAsync(dbl -> log.debug("Result: {}", dbl), executor);
    log.debug("Continuing");
    

…Async变量也可用两种方法，隐式和显式执行器，我不会过多强调这个方法。
thenAccept()/thenRun()方法并没有发生阻塞（即使没有明确的executor)。它们像一个事件侦听器/处理程序，你连接到一个future时，这将执行一段时间。”Continuing”消息将立即出现，尽管future甚至没有完成。

- 结合（链接）这两个futures（thenCompose()）

时你想运行一些future的值（当它准备好了），但这个函数也返回了future。CompletableFuture足够灵活地明白我们的函数结果现在应该作为顶级的future，对比`CompletableFuture<CompletableFuture>`。方法 thenCompose()相当于Scala的flatMap：

    <U> CompletableFuture<U> thenCompose(Function<? super T,CompletableFuture<U>> fn);
    

…Async变化也是可用的，在下面的事例中，仔细观察thenApply()(map)和thenCompose()（flatMap）的类型和差异，当应用calculateRelevance()方法返回CompletableFuture：

    CompletableFuture<Document> docFuture = //...
    
    CompletableFuture<CompletableFuture<Double>> f =
        docFuture.thenApply(this::calculateRelevance);
    
    CompletableFuture<Double> relevanceFuture =
        docFuture.thenCompose(this::calculateRelevance);
    
    //...
    
    private CompletableFuture<Double> calculateRelevance(Document doc)  //...
    

- 两个futures的转换值(thenCombine())
当thenCompose()用于链接一个future时依赖另一个thenCombine，当他们都完成之后就结合两个独立的futures：

    <U,V> CompletableFuture<V> thenCombine(CompletableFuture<? extends U> other, BiFunction<? super T,? super U,? extends V> fn)
    

…Async变量也是可用的，假设你有两个CompletableFuture，一个加载Customer另一个加载最近的Shop。他们彼此完全独立，但是当他们完成时，您想要使用它们的值来计算Route。这是一个可剥夺的例子：

    CompletableFuture<Customer> customerFuture = loadCustomerDetails(123);
    CompletableFuture<Shop> shopFuture = closestShop();
    CompletableFuture<Route> routeFuture =
        customerFuture.thenCombine(shopFuture, (cust, shop) -> findRoute(cust, shop));
    
    //...
    
    private Route findRoute(Customer customer, Shop shop) //...
    

你也知道，我们有customerFuture 和 shopFuture。那么routeFuture包装它们然后“等待”它们完成。当他们准备好了，它会运行我们提供的函数来结合所有的结果(findRoute())。当两个基本的futures完成并且 findRoute()也完成时，这样routeFuture将会完成。

- 等待所有的 CompletableFutures 完成
如果不是产生新的CompletableFuture连接这两个结果，我们只是希望当完成时得到通知，我们可以使用thenAcceptBoth()/runAfterBoth()系列的方法，（…Async 变量也是可用的）。它们的工作方式与thenAccept() 和 thenRun()类似，但是是等待两个futures而不是一个：

    <U> CompletableFuture<Void> thenAcceptBoth(CompletableFuture<? extends U> other, BiConsumer<? super T,? super U> block)
    CompletableFuture<Void> runAfterBoth(CompletableFuture<?> other, Runnable action)
    

- 等待第一个 CompletableFuture 来完成任务

另一个有趣的事是CompletableFutureAPI可以等待第一个（与所有相反）完成的future。当你有两个相同类型任务的结果时就显得非常方便，你只要关心响应时间就行了，没有哪个任务是优先的。API方法(…Async变量也是可用的）：

    CompletableFuture<Void> acceptEither(CompletableFuture<? extends T> other, Consumer<? super T> block)
    CompletableFuture<Void> runAfterEither(CompletableFuture<?> other, Runnable action)
    

作为一个例子，你有两个系统可以集成。一个具有较小的平均响应时间但是拥有高的标准差，另一个一般情况下较慢，但是更加容易预测。为了两全其美（性能和可预测性）你可以在同一时间调用两个系统并等着谁先完成。通常这会是第一个系统，但是在进度变得缓慢时，第二个系统就可以在可接受的时间内完成：

    CompletableFuture<String> fast = fetchFast();
    CompletableFuture<String> predictable = fetchPredictably();
    fast.acceptEither(predictable, s -> {
        System.out.println("Result: " + s);
    });
    

s代表了从fetchFast()或是fetchPredictably()得到的String。我们不必知道也无需关心。

applyToEither()算是 acceptEither()的前辈了。当两个futures快要完成时，后者只是简单地调用一些代码片段，applyToEither()将会返回一个新的future。当这两个最初的futures完成时，新的future也会完成。API有点类似于(…Async 变量也是可用的)：

    <U> CompletableFuture<U> applyToEither(CompletableFuture<? extends T> other, Function<? super T,U> fn)
    

这个额外的fn功能在第一个future被调用时能完成。我不确定这个专业化方法的目的是什么，毕竟一个人可以简单地使用：fast.applyToEither(predictable).thenApply(fn)。因为我们坚持用这个API，但我们的确不需要额外功能的应用程序，我会简单地使用Function.identity()占位符：

    CompletableFuture<String> fast = fetchFast();
    CompletableFuture<String> predictable = fetchPredictably();
    CompletableFuture<String> firstDone =
        fast.applyToEither(predictable, Function.<String>identity());
    

第一个完成的future可以通过运行。请注意，从客户的角度来看，两个futures实际上是在firstDone的后面而隐藏的。客户端只是等待着future来完成并且通过applyToEither()使得当最先的两个任务完成时通知客户端。

我们现在知道如何等待两个future来完成（使用thenCombine()）并第一个完成(applyToEither())。但它可以扩展到任意数量的futures吗？的确，使用static辅助方法：

    static CompletableFuture<Void< allOf(CompletableFuture<?<... cfs)
    static CompletableFuture<Object< anyOf(CompletableFuture<?<... cfs)
{% endraw %}
