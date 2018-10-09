---
layout: post
title:  "RxJava源码分析之线程调度（一）"
title2:  "RxJava源码分析之线程调度（一）"
date:   2017-01-01 23:59:22  +0800
source:  "https://www.jfox.info/rxjava%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90%e4%b9%8b%e7%ba%bf%e7%a8%8b%e8%b0%83%e5%ba%a6%e4%b8%80.html"
fileName:  "20170101462"
lang:  "zh_CN"
published: true
permalink: "2017/rxjava%e6%ba%90%e7%a0%81%e5%88%86%e6%9e%90%e4%b9%8b%e7%ba%bf%e7%a8%8b%e8%b0%83%e5%ba%a6%e4%b8%80.html"
---
{% raw %}
作者[TripleZ](/u/adb7c6deb713)2017.08.03 16:52*字数 1097
RxJava强大的地方之一是他的链式调用，轻松地在线程之间进行切换。这几天也大概分析了一下RxJava的线程切换的主流程于是打算写一篇文章及记录一下。

我们使用RxJava进行线程切换的场景很多时候都是在进行网络请求的时候，在IO线程进行网络数据的请求处理，最后在Android的主线程进行请求数据的结果处理。

    .subscribeOn(Schedulers.io())
                    .observeOn(AndroidSchedulers.mainThread())
    

当然因为这段代码的使用场景太多我们还可以利用ObservableTransformer操作符对其进行简化

       public static <T>ObservableTransformer<T,T> io_main()
        {
            return new ObservableTransformer<T, T>() {
                @Override
                public ObservableSource<T> apply(@NonNull Observable<T> upstream) {
                    return upstream.subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread());
                }
            };
        }
    

这样我们在使用的时候就是这样的：

    .compose(RxTransformUtil.<Object>io_main())
    

是不是感觉方便了一丢丢

好了扯远了，现在来分析一下RxJava是如何做到线程的轻松调度的。
首先有几个概念是非常重要的：
Scheduler官方的解释是这样的

    A Scheduler is an object that specifies an API for scheduling units of work with or without delays or periodically. 
    

初步看来Scheduler就是一个任务调度器相当于就是一个调度中心的指挥者。当然它是一个抽象类就肯定了Scheduler有很多具体的实现类，例如IO线程的具体调度器就是IoScheduler。就像调度中心指挥者有客运中心的指挥者，有机场中心的指挥者一样分别有不同的实现类。
当然现在只有指挥者是肯定不行的，光头司令怎么得行？这个时候关键的Worker类出现了，Worker官方的解释是这样的

    Sequential Scheduler for executing actions on a single thread or event loop.
    Disposing the Scheduler.Worker cancels all outstanding work and allows resource cleanup.
    

可以看到Worker就是线程任务的具体执行者了。和Scheduler一样Worker同样也是抽象类，在不同的Scheduler具体实现类里面Worker也有自己的具体实现类，例如在IoScheduler类里面，Worker的具体实现类就是EventLoopWorker，它负责管理IO线程的具体操作，接下来我们就找到切入点看一看RxJava源码里面都做了什么。

这里我们就以最典型的IO线程和主线程之间的切换为例来分析,线程切换的代码就是上面的代码。
Scheduler是以工厂方法对外提供它具体的实现类的。Schedulers.io()可以提供一个IoScheduler的对象。你可以往里面看最后源码是如何进行IoScheduler的创建的

    //创建IoScheduler
    static final class IoHolder {
            static final Scheduler DEFAULT = new IoScheduler();
        }
    //接着就行了IoScheduler的一系列初始化，CachedWorkerPool地初始化 ，并由RxThreadFactory进行线程地创建，线程优先级别设置，是否是守护进程等等
    

现在IoScheduler有了，我们就看subscribe里面到底做了什么

    public final Observable<T> subscribeOn(Scheduler scheduler) {
            ObjectHelper.requireNonNull(scheduler, "scheduler is null");
            return RxJavaPlugins.onAssembly(new ObservableSubscribeOn<T>(this, scheduler));
        }
    

Hook我们不用管，可以看到是把当前ObservableCreater对象和IoScheduler一起传进了ObservableSubscribeoOn的构造函数里面。进入到ObservableSubscribeOn里面看看。

    //AbstractObservableWithUpstream只是用来保存上游的源事件流的，就是保存刚刚传入进来的ObservableCreater
    public final class ObservableSubscribeOn<T> extends AbstractObservableWithUpstream<T, T> {
        final Scheduler scheduler;
    
        public ObservableSubscribeOn(ObservableSource<T> source, Scheduler scheduler) {
            super(source);
            this.scheduler = scheduler;
        }
    
        @Override
        public void subscribeActual(final Observer<? super T> s) {
    //装饰模式 把下游的Observer装饰成SubscribeOnObserver
            final SubscribeOnObserver<T> parent = new SubscribeOnObserver<T>(s);     //执行下游Observer的onSubscribe(Disposable disposabel)方法，当前线程是上游的执行线程
            s.onSubscribe(parent);
    //开启的子线程最终是以带Disposable的返回值返回的
    //在这里是将子线程加入管理，因为这里是并发操作所以使用了AtomicReference<Object>的院子操作类，是一种效率高于synchronized的乐观锁，感兴趣的可以自行上网搜索
    //我们只用知道这里加入管理了以后方便在以后我们切断上下游的时候可以将我们的子线程一同dispose().
            parent.setDisposable(scheduler.scheduleDirect(new SubscribeTask(parent)));
        }
    
        static final class SubscribeOnObserver<T> extends AtomicReference<Disposable> implements Observer<T>, Disposable {
    
            private static final long serialVersionUID = 8094547886072529208L;
            final Observer<? super T> actual;
    
            final AtomicReference<Disposable> s;
    
            SubscribeOnObserver(Observer<? super T> actual) {
                this.actual = actual;
                this.s = new AtomicReference<Disposable>();
            }
         
        //这中间的代码和最基本的链式调用关系是一样的，只不过在onNext、onError、onComplete中实际上还是调用的下游真正的onNext、onError、onComplete
    
            @Override
            public void onNext(T t) {
                actual.onNext(t);
            }
            @Override
            public void onError(Throwable t) {
                actual.onError(t);
            }
            @Override
            public void onComplete() {
                actual.onComplete();
            }
                  void setDisposable(Disposable d) {
                DisposableHelper.setOnce(this, d);
            }
        }
    //这就是实际执行的Runnable 会把其传入IoScheduler中供Worker使用。
        final class SubscribeTask implements Runnable {
            private final SubscribeOnObserver<T> parent;
    
            SubscribeTask(SubscribeOnObserver<T> parent) {
                this.parent = parent;
            }
    
            @Override
            public void run() {
    /*看到了吧，SubscribeOnObserver 作用其实就是将源事件流发生的地点和下游的事件流处理的地点订阅在了子线程中进行处理。
    这样上游发送事件流的地方就被切换到了子线程中。*/
                source.subscribe(parent);
            }
        }
    }
    

接下来我们仔细看一下上面代码的这一段：

     @Override
        public void subscribeActual(final Observer<? super T> s) {
            final SubscribeOnObserver<T> parent = new SubscribeOnObserver<T>(s);
            s.onSubscribe(parent);
    //这里scheduler.schedlerDirect非常的重要，可以看到RxJava把刚刚包装好的Runnable对象传入了方法里
            parent.setDisposable(scheduler.scheduleDirect(new SubscribeTask(parent)));
        }
    

我们跟进去看一下里面的具体实现

     @NonNull
        public Disposable scheduleDirect(@NonNull Runnable run) {
    //实际上是调用的下面3个参数的方法，延迟时间为0
            return scheduleDirect(run, 0L, TimeUnit.NANOSECONDS);
        }
     @NonNull
        public Disposable scheduleDirect(@NonNull Runnable run, long delay, @NonNull TimeUnit unit) {
    //创建具体的Worker类
            final Worker w = createWorker();
    //hook函数我们不用管，只要没有设置依旧返回的是传入的Runnable
            final Runnable decoratedRun = RxJavaPlugins.onSchedule(run);
    //将runnable和worker封装到DisposeTask中
            DisposeTask task = new DisposeTask(decoratedRun, w);
    //执行Worker的schedule方法具体的就是EventLoopWorker里面的schedule方法
            w.schedule(task, delay, unit);
    
            return task;
        }
    

接下来我们来看一下EventLoopWorker里面的schedule方法是怎么实现的

     @NonNull
            @Override
            public Disposable schedule(@NonNull Runnable action, long delayTime, @NonNull TimeUnit unit) {
                //判断是否解除订阅
                if (tasks.isDisposed()) {
                    // don't schedule, we are unsubscribed
                    return EmptyDisposable.INSTANCE;
                }
                return threadWorker.scheduleActual(action, delayTime, unit, tasks);
            }
    

可以看到这里如果没有被解除订阅的话又会执行到NewThreadWorker的scheduleActual方法里面。

    @NonNull
        public ScheduledRunnable scheduleActual(final Runnable run, long delayTime, @NonNull TimeUnit unit, @Nullable DisposableContainer parent) {
            //hook函数我们这里不用管decoratedRun依然是传进来的Runnable对象run
            Runnable decoratedRun = RxJavaPlugins.onSchedule(run);
            //ScheduledRunnable是一个即实现了Runnable接口又实现了Callable接口的对象，为了后面能成功加入到线程池当中    
            ScheduledRunnable sr = new ScheduledRunnable(decoratedRun, parent);
            //将sr加入到CompositeDisposable中，方便管理
            if (parent != null) {
                if (!parent.add(sr)) {
                    return sr;
                }
            }
         
            Future<?> f;
            try {
                if (delayTime <= 0) {
                  //将sr加入到线程池当中 并将线程的执行结果返回给 Future<?> f
                    f = executor.submit((Callable<Object>)sr);
                } else {
                    f = executor.schedule((Callable<Object>)sr, delayTime, unit);
                }
                sr.setFuture(f);//对运行结果进行处理
            } catch (RejectedExecutionException ex) {
                if (parent != null) {
                    //在CompositeDisposable中一处刚刚加入的sr
                    parent.remove(sr);
                }
                RxJavaPlugins.onError(ex);
            }
      
            return sr;
        }
    

接下来看一下ScheduledRunnable是如何对返回的结果进行处理的

      public void setFuture(Future<?> f) {
    //一个死循环会一直判断返回回来的结果 因为其实原子操作类，乐观锁的机制决定了如果不是想要的结果的话会重新执行一次
            for (;;) {
                Object o = get(FUTURE_INDEX);
                if (o == DONE) {
                    //完成直接return
                    return;
                }
                  //如果取消订阅了则直接取消线程任务
                if (o == DISPOSED) {
                    f.cancel(get(THREAD_INDEX) != Thread.currentThread());
                    return;
                }
                //前两者都不满足的话 就将future的值存下来
                if (compareAndSet(FUTURE_INDEX, o, f)) {
                    return;
                }
            }
        }
    

到现在为止上游的线程切换大体的流程就分析的差不多了，我们从源码中也可以分析出很多网上经常说的一些结论，最经典的一条就是上游切换线程只有第一次生效，后面的线程切换都不起作用了，其实分析这点最重要的就是理解 ObservableSubscribeOn类里面下面的这段代码了

    final class SubscribeTask implements Runnable {
            private final SubscribeOnObserver<T> parent;
            SubscribeTask(SubscribeOnObserver<T> parent) {
                this.parent = parent;
            }
            @Override
            public void run() {
                source.subscribe(parent);
            }
        }
    

再结合RxJava的链式操作，处理数据的时候是自下而上，而发射数据的时候是自上而下（这句话网上说的太多了，我最开始也是不理解，只有自己真正看过源码分析了，自己Debug一边才能真正地理解）。
好了先写到这里了，剩下的内容我会放到另外一篇博客里面，感觉文章太长不利于阅读。

这篇文章也是我第一次试着去分析源码最后写出的，很多都是我自己的理解，所以肯定有不妥当或者错误的地方希望大家看到了以后能给我指出来，我一定改正！

最后

没有最后了 大家再见~~~
{% endraw %}
