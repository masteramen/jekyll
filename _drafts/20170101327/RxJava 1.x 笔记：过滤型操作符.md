---
layout: post
title:  "RxJava 1.x 笔记：过滤型操作符"
title2:  "RxJava 1.x 笔记：过滤型操作符"
date:   2017-01-01 23:57:07  +0800
source:  "https://www.jfox.info/rxjava1x%e7%ac%94%e8%ae%b0%e8%bf%87%e6%bb%a4%e5%9e%8b%e6%93%8d%e4%bd%9c%e7%ac%a6.html"
fileName:  "20170101327"
lang:  "zh_CN"
published: true
permalink: "2017/rxjava1x%e7%ac%94%e8%ae%b0%e8%bf%87%e6%bb%a4%e5%9e%8b%e6%93%8d%e4%bd%9c%e7%ac%a6.html"
---
{% raw %}
过滤型操作符即对 Observable 的数据进行过滤，选择性地发射出去。

## Debounce

`Debounce` 的作用是：控制发射速率。

每产生一个数据后，如果在规定的间隔时间内没有别的数据产生，就会发射这个数据，否则忽略该数据。

![](/wp-content/uploads/2017/07/1500287890.png)

RxJava 的实现有两种：`debounce` 和 `throttleWithTimeout`。

### debounce

![](/wp-content/uploads/2017/07/1500287672.png)

`debounce` 接收两个参数，第一个指定过滤的时间间隔，第二个参数指定单位。

    publicfinal Observable<T> debounce(long timeout, TimeUnit unit) {
        return debounce(timeout, unit, Schedulers.computation());
    }
    publicfinal Observable<T> debounce(long timeout, TimeUnit unit, Scheduler scheduler) {
        return lift(new OperatorDebounceWithTime<T>(timeout, unit, scheduler));
    }

使用例子：

    privatevoidfilteringWithDebounce() {
        Observable
                .unsafeCreate(new Observable.OnSubscribe<Integer>() {
                    @Overridepublicvoidcall(Subscriber<? super Integer> subscriber) {
                        for (int i = 0; i < 10; i++) {
                            SystemClock.sleep(i % 5 * 1000);
                            subscriber.onNext(i);
                        }
                        subscriber.onCompleted();
                    }
                })
                .subscribeOn(Schedulers.computation())
                .debounce(2, TimeUnit.SECONDS)
                .subscribe(this.<Integer>getPrintSubscriber());
    
    }

在上面的例子中，我们发射 0 到 9 共 10 个数据，每个延迟 i % 5 秒，也就是延迟 0 到 4 秒，过滤时间为 2 秒，所以最终发射结果：

![](/wp-content/uploads/2017/07/1500287679.png)

### throttleWithTimeout

![](/wp-content/uploads/2017/07/1500287896.png)

`throttleWithTimeout` 和 `debounce` 作用一样，通过源码可以看到，它也是调用的 `debounce`:

    publicfinal Observable<T> throttleWithTimeout(long timeout, TimeUnit unit) {
        return debounce(timeout, unit);
    }

例子就不演示了。

## Distinct

![](/wp-content/uploads/2017/07/1500287898.png)

`Distinct` 即“去重”，很好理解。

RxJava 中的实现有 4 种。

### distinct()

![](/wp-content/uploads/2017/07/1500287903.png)

第一种就是最简单的无参数 `distinct()`:

    publicfinal Observable<T> distinct() {
        return lift(OperatorDistinct.<T> instance());
    }

使用也很简单：

    privatevoidfilteringWithDistinct() {
        Observable.from(Arrays.asList(1,3,1,3,4))
                .distinct()
                .subscribe(this.<Integer>getPrintSubscriber());
    }

结果就和我们期望的一样：

![](/wp-content/uploads/2017/07/1500288061.png)

### distinct(keySelector)

![](/wp-content/uploads/2017/07/1500288065.png)

第二种，`distinct(keySelector)` 允许我们传入一个函数作为参数，这个函数返回了决定是否重复的 Key。

    publicfinal <U> Observable<T> distinct(Func1<? super T, ? extends U> keySelector) {
        return lift(new OperatorDistinct<T, U>(keySelector));
    }

使用例子：

    privatevoidfilteringWithDistinct2() {
    
        Observable.from(Arrays.asList(1,3,1,3,4))
                .distinct(new Func1<Integer, Integer>() {
                    @Override
                    public Integer call(Integer item) {
                        return item % 2;
                    }
                })
                .subscribe(this.<Integer>getPrintSubscriber());
    }

在函数中我们以 item % 2 的结果作为判断是否重复的依据，源 Observable 发射的数据中，对二求余的结果只有 1 和 0，因此输出结果为：

![](/wp-content/uploads/2017/07/1500288066.png)

### distinctUntilChanged()

![](/wp-content/uploads/2017/07/1500288222.png)

`distinctUntilChanged()` 也是去重，不过每个元素只跟前面一个元素比较，如果和前面的一样就去除，否则就发射，不会和其他位置的比较。

    publicfinal Observable<T> distinctUntilChanged() {
        return lift(OperatorDistinctUntilChanged.<T> instance());
    }

使用例子：

    privatevoidfilteringWithDistinctUntilChanged() {
        Observable.from(Arrays.asList(1,1,3,1,3,4,4))
                .distinctUntilChanged()
                .subscribe(this.<Integer>getPrintSubscriber());
    }

运行结果：

![](/wp-content/uploads/2017/07/1500288225.png)

可以看到，输出的结果还是有重复，去掉的是和前一个元素重复的元素。

### distinctUntilChanged(keySelector)

![](/wp-content/uploads/2017/07/1500288232.png)

`distinctUntilChanged(keySelector)` 就是 `distinct(keySelector)` 和 `distinctUntilChanged()` 的结合体，传入的参数决定是否重复，并且只和前一个元素比较。

就不写例子了。

## ElementAt

![](/wp-content/uploads/2017/07/1500288356.png)

`ElementAt` 和名字一样，只发射指定位置的元素（从 0 开始）。

RxJava 对应的实现有 2 种。

### elementAt

![](/wp-content/uploads/2017/07/1500288361.png)

`elementAt` 和规范一样，只发射指定位置的元素，

    publicfinal Observable<T> elementAt(intindex) {
        return lift(new OperatorElementAt<T>(index));
    }
    private OperatorElementAt(intindex, T defaultValue, boolean hasDefault) {
        if (index < 0) {
            thrownew IndexOutOfBoundsException(index + " is out of bounds");
        }
        this.index = index;
        this.defaultValue = defaultValue;
        this.hasDefault = hasDefault;
    }

从 `OperatorElementAt` 的构造函数我们可以看到当指定的位置小于 0 时，会抛出 `java.lang.IndexOutOfBoundsException` 异常。 
当 index > 数据总数时，会发射　`onError` 事件：

    privatevoidfilteringWithElementAt() {
        Observable.range(0, 10)
                .elementAt(12)
                .subscribe(this.<Integer>getPrintSubscriber());
    }

运行结果：

    07-1522:00:52.42511596-11596/top.shixinzhang.rxjavademo I/System.out: onError: 12 is out of bounds

### elementAtOrDefault

![](/wp-content/uploads/2017/07/1500288587.png)

`elementAtOrDefault` 和 `elementAt` 的区别在于，当指定的 index 大于源 Observable 发射的数据长度时，不会发射 onError 事件，而是发射预备的默认值；不过 index < 0 时还是会抛出异常。

    publicfinal Observable<T> elementAtOrDefault(intindex, T defaultValue) {
        return lift(new OperatorElementAt<T>(index, defaultValue));
    }
    private OperatorElementAt(intindex, T defaultValue, boolean hasDefault) {
        if (index < 0) {
            thrownew IndexOutOfBoundsException(index + " is out of bounds");
        }
        this.index = index;
        this.defaultValue = defaultValue;
        this.hasDefault = hasDefault;
    }

使用例子：

    privatevoidfilteringWithElementAtDefault() {
        Observable.range(0, 10)
                .elementAtOrDefault(12, 222)
                .subscribe(this.<Integer>getPrintSubscriber());
    
    }

运行结果：

    07-1522:06:27.88216870-16870/top.shixinzhang.rxjavademo I/System.out: onNext: 22207-1522:06:27.88216870-16870/top.shixinzhang.rxjavademo I/System.out: onCompleted

## Filter

![](/wp-content/uploads/2017/07/1500288364.png)

`Filter` 只发射符合要求的元素。

RxJava 中的实现有 2 种。

### filter

![](/wp-content/uploads/2017/07/1500288594.png)

`filter(predicate)` 的参数指定了要发射的元素需要满足的条件，不满足就不会发射。

    publicfinal Observable<T> filter(Func1<? super T, Boolean> predicate) {
        return unsafeCreate(new OnSubscribeFilter<T>(this, predicate));
    }

使用例子：

    privatevoidfilteringWithFilter() {
        Observable.range(0, 10)
                .filter(new Func1<Integer, Boolean>() {
                    @Overridepublic Boolean call(Integer item) {
                        return item > 5;
                    }
                })
                .subscribe(this.<Integer>getPrintSubscriber());
    }

例子中，我们只允许大于 5 的数据发射。运行结果：

    07-1522:09:38.77319765-19765/top.shixinzhang.rxjavademo I/System.out: onNext: 607-1522:09:38.77319765-19765/top.shixinzhang.rxjavademo I/System.out: onNext: 707-1522:09:38.77319765-19765/top.shixinzhang.rxjavademo I/System.out: onNext: 807-1522:09:38.77319765-19765/top.shixinzhang.rxjavademo I/System.out: onNext: 907-1522:09:38.77319765-19765/top.shixinzhang.rxjavademo I/System.out: onCompleted

### ofType

![](/wp-content/uploads/2017/07/1500288511.png)

`ofType(klass)` 的参数指定符合要求的数据类型，最终还是调用的 `filter`：

    publicfinal <R> Observable<R> ofType(final Class<R> klass) {
        return filter(InternalObservableUtils.isInstanceOf(klass)).cast(klass);
    }

使用例子：

    privatevoidfilteringWithOfType() {
        Observable.range(0, 10)
                .ofType(String.class)
                .subscribe(this.<String>getPrintSubscriber());
    }

可以看到 `ofType` 返回的 Observable 的数据类型就是参数的类型。运行结果：

    07-1522:14:38.97924199-24199/top.shixinzhang.rxjavademo I/System.out: onCompleted

## First

![](/wp-content/uploads/2017/07/1500288597.png)

`First` 的作用的就是只发射第一个元素（或者是第一个满足要求的元素）。

在RxJava中，这个操作符被实现为 `first`，`firstOrDefault` 和 `takeFirst`。 

### first

![](/wp-content/uploads/2017/07/1500288787.png)

`first()` 只发射第一个数据，如果源 Observable是空的话，会抛出 `NoSuchElementException` 异常。

    publicfinal Observable<T> first() {
        return take(1).single();
    }

可以看到它调用的是 `take(1).single()`，这两个操作符我们这篇文章后面介绍。

运行结果很简单，这里就暂不演示了。

### first(predicate)

![](/wp-content/uploads/2017/07/1500288793.png)

`first(predicate)` 只发射符合要求的第一个元素。 

    publicfinal Observable<T> first(Func1<? super T, Boolean> predicate) {
        return takeFirst(predicate).single();
    }

使用例子：

    privatevoidfilteringWithFirst() {
        Observable.range(4, 10)
                .first(new Func1<Integer, Boolean>() {
                    @Overridepublic Boolean call(Integer integer) {
                        return integer > 5;
                    }
                })
                .subscribe(this.<Integer>getPrintSubscriber());
    }

我们只发射第一个大于 5 的数字，也就是 6 喽。运行结果：

    07-1522:23:02.22831262-31262/top.shixinzhang.rxjavademo I/System.out: onNext: 607-1522:23:02.22831262-31262/top.shixinzhang.rxjavademo I/System.out: onCompleted

### firstOrDefault

![](/wp-content/uploads/2017/07/1500289782.png)

`firstOrDefault` 和名字一样，如果没有第一个元素就发射默认的。

    publicfinal Observable<T> firstOrDefault(T defaultValue) {
        return take(1).singleOrDefault(defaultValue);
    }

使用例子：

    privatevoidfilteringWithFirstOrDefault() {
        Observable.empty()
                .firstOrDefault(33)
                .subscribe(getPrintSubscriber());
    }

运行结果：

    07-1522:26:28.3752910-2910/top.shixinzhang.rxjavademo I/System.out: onNext: 3307-1522:26:28.3752910-2910/top.shixinzhang.rxjavademo I/System.out: onCompleted

### firstOrDefault(predicate)

![](/wp-content/uploads/2017/07/1500290365.png)

`firstOrDefault(predicate)` 返回第一个符合要求的，没有的话就返回默认的，也很好理解。

    publicfinal Observable<T> firstOrDefault(T defaultValue, Func1<? super T, Boolean> predicate) {
        return takeFirst(predicate).singleOrDefault(defaultValue);
    }

使用例子：

    privatevoidfilteringWithFirstOrDefault() {
        Observable.range(0 , 4)
                .firstOrDefault(33, new Func1<Integer, Boolean>() {
                    @Overridepublic Boolean call(Integer integer) {
                        return integer > 5;
                    }
                })
                .subscribe(getPrintSubscriber());
    }

运行结果：

    07-1522:26:28.3752910-2910/top.shixinzhang.rxjavademo I/System.out: onNext: 3307-1522:26:28.3752910-2910/top.shixinzhang.rxjavademo I/System.out: onCompleted

### takeFirst

![](/wp-content/uploads/2017/07/1500290366.png)

`takeFirst` 与 `first` 基本一致，除了这一点：如果原始 Observable 没有发射任何满足条件的数据，`first` 会抛出一个 `NoSuchElementException`，`takeFist` 会返回一个空的 Observable（不调用 onNext() 但是会调用 onCompleted）。 

也就是说 `takeFirst` 比 `first` 温柔一点，不会抛异常。

### single

![](/wp-content/uploads/2017/07/1500290369.png)

`single` 也是只发射一个数据，但是如果源 Observable 发射多个数据，就会发射 `onError` 事件：

    07-1522:37:15.77412609-12609/top.shixinzhang.rxjavademo I/System.out: onError: Sequence contains too many elements

如果源 Observable 没有数据，也会发射 `onError` 事件：

    07-1522:38:30.70013779-13779/top.shixinzhang.rxjavademo I/System.out: onError: Sequence contains no elements

**也就是说，`single` 是用来检验并获取只有一个元素的 Observable 发射的数据。**

single 也有传递符合要求函数、默认值的变体，这里就暂不赘述了。

## Last

有 First 当然就有 Last。

![](/wp-content/uploads/2017/07/1500290370.png)

`Last` 只发射最后一项（或者满足某个条件的最后一项）数据。 

Last 的变体和 First 差不多，这里就不赘述了。

## Take

![](/wp-content/uploads/2017/07/1500290624.png)

`first` 很多都是使用 `take` 实现的。

`Take` 操作符的作用是：**只保留前面的若干项数据**。

RxJava 对应的实现为 `take`。

### take(count)

![](/wp-content/uploads/2017/07/1500290625.png)

`take(count)` 的参数指定要保留的数据项。

    publicfinal Observable<T> take(finalint count) {
        return lift(new OperatorTake<T>(count));
    }

另外 `limit` 也只是 `take` 的别名：

    publicfinal Observable<T> limit(int count) {
        return take(count);
    }

使用例子：

    privatevoidfilteringWithTake() {
        Observable.range(0 , 10)
                .limit(3)
                .subscribe(this.<Integer>getPrintSubscriber());
    }

运行结果：

    07-1522:51:49.89525751-25751/top.shixinzhang.rxjavademo I/System.out: onNext: 007-1522:51:49.89525751-25751/top.shixinzhang.rxjavademo I/System.out: onNext: 107-1522:51:49.89525751-25751/top.shixinzhang.rxjavademo I/System.out: onNext: 207-1522:51:49.89525751-25751/top.shixinzhang.rxjavademo I/System.out: onCompleted

### take(time, unit)

![](/wp-content/uploads/2017/07/1500289183.png)

另一种变体是 `take(long time, TimeUnit unit)`，参数为时间，即只发射指定时间之内（小于该时间）发射的数据，超时的数据都不会发射。

    publicfinal Observable<T> take(long time, TimeUnit unit) {
        return take(time, unit, Schedulers.computation());
    }
    publicfinal Observable<T> take(long time, TimeUnit unit, Scheduler scheduler) {
        return lift(new OperatorTakeTimed<T>(time, unit, scheduler));
    }

使用例子：

    privatevoidfilteringWithTake() {
        Observable
                .unsafeCreate(new Observable.OnSubscribe<Integer>() {
                    @Overridepublicvoidcall(Subscriber<? super Integer> subscriber) {
                        for (int i = 0; i < 10; i++) {
                            SystemClock.sleep(1_000);
                            subscriber.onNext(i);
                        }
                        subscriber.onCompleted();
                    }
                })
                .subscribeOn(Schedulers.computation())
                .take(3, TimeUnit.SECONDS)
                .subscribe(this.<Integer>getPrintSubscriber());
    }

每隔一秒发射一个数据，然后指定只要 3 秒内发射的数据。运行结果：

    07-1522:56:01.30429363-29388/top.shixinzhang.rxjavademo I/System.out: onNext: 007-1522:56:02.30629363-29388/top.shixinzhang.rxjavademo I/System.out: onNext: 107-1522:56:03.30229363-29387/top.shixinzhang.rxjavademo I/System.out: onCompleted

## TakeLast

![](/wp-content/uploads/2017/07/1500290372.png)

有从前开始拿，自然就有从后开始拿，`TakeLast` 就是这个作用。

使用 `TakeLast` 操作符可以只发射 Observable 发射的后 N 项数据，忽略前面的数据。

RxJava 中的实现有 `takeLast`，它的参数可以是个数也可以是时间。

还有一种实现是 `takeLastBuffer`：

![](/wp-content/uploads/2017/07/1500289186.png)

`takeLastBuffer` 和 `takeLast` 类似，不同是它把所有的数据项收集到一个 `List` 再发射，而不是依次发射。

## IgnoreElements

![](/wp-content/uploads/2017/07/1500290626.png)

`IgnoreElements` 的作用是不发射任何数据，只发射结束事件（ onError or onCompleted）。

当你不在乎发射的内容，只希望在它完成时或遇到错误终止时收到通知，可以使用这个操作符。

`ignoreElements` 会确保永远不会调用观察者的onNext()方法

RxJava 的实现是 `ignoreElements`：

    publicfinal Observable<T> ignoreElements() {
        return lift(OperatorIgnoreElements.<T> instance());
    }
    @Overridepublic Subscriber<? super T> call(final Subscriber<? super T> child) {
        Subscriber<T> parent = new Subscriber<T>() {
    
            @OverridepublicvoidonCompleted() {
                child.onCompleted();
            }
    
            @OverridepublicvoidonError(Throwable e) {
                child.onError(e);
            }
    
            @OverridepublicvoidonNext(T t) {
                // ignore element
            }
    
        };
        child.add(parent);
        return parent;
    }

可以看到，它的 `onNext()` 方法没有传递事件。

## Sample

`Sample` 的作用是：定时发射 Observable 最新发射的数据。

![](/wp-content/uploads/2017/07/1500290373.png)

`Sample` 操作符会周期性地查看源 Observable，发射自出上次查看以来，最新发射的数据。

RxJava 中有三种实现：`sample`, `throttleFirst`, `throttleLast`。

### sample

![](/wp-content/uploads/2017/07/1500290375.png)

`sample()` 的参数指定定期查看的时间间隔：

    publicfinal Observable<T> sample(long period, TimeUnit unit) {
        return sample(period, unit, Schedulers.computation());
    }
    publicfinal Observable<T> sample(long period, TimeUnit unit, Scheduler scheduler) {
        return lift(new OperatorSampleWithTime<T>(period, unit, scheduler));
    }

`throttleLast` 和 `sample` 一样，只不过名称不同：

    publicfinal Observable<T> throttleLast(long intervalDuration, TimeUnit unit) {
        return sample(intervalDuration, unit);
    }

使用例子：

    privatevoidfilteringWithSample() {
        Observable
                .unsafeCreate(new Observable.OnSubscribe<Integer>() {
                    @Overridepublicvoidcall(Subscriber<? super Integer> subscriber) {
                        for (int i = 0; i < 10; i++) {
                            SystemClock.sleep( i % 5 * 1000);
                            subscriber.onNext(i);
                        }
                        subscriber.onCompleted();
                    }
                })
                .subscribeOn(Schedulers.computation())
                .sample(3, TimeUnit.SECONDS)
                .subscribe(this.<Integer>getPrintSubscriber());
    }

例子中，我们每隔 i % 5 秒发射 10 个数据，然后每隔 3 秒去查看一次，发射距离上次查看，最新发射的元素。运行结果：

    07-1523:12:55.91512800-12815/top.shixinzhang.rxjavademo I/System.out: onNext: 007-1523:12:58.91512800-12815/top.shixinzhang.rxjavademo I/System.out: onNext: 207-1523:13:01.91612800-12815/top.shixinzhang.rxjavademo I/System.out: onNext: 307-1523:13:07.91612800-12815/top.shixinzhang.rxjavademo I/System.out: onNext: 607-1523:13:10.91612800-12815/top.shixinzhang.rxjavademo I/System.out: onNext: 707-1523:13:13.91612800-12815/top.shixinzhang.rxjavademo I/System.out: onNext: 807-1523:13:15.49912800-12816/top.shixinzhang.rxjavademo I/System.out: onNext: 907-1523:13:15.49912800-12816/top.shixinzhang.rxjavademo I/System.out: onCompleted

### throttleFirst

![](/wp-content/uploads/2017/07/1500290376.png)

`throttleFirst` 也是隔一段时间去查看一次，不同的是它发射的是这段时间里第一个发射的数据，而不是最新的。

    publicfinal Observable<T> throttleFirst(long windowDuration, TimeUnit unit) {
        return throttleFirst(windowDuration, unit, Schedulers.computation());
    }
    publicfinal Observable<T> throttleFirst(long skipDuration, TimeUnit unit, Scheduler scheduler) {
        return lift(new OperatorThrottleFirst<T>(skipDuration, unit, scheduler));
    }

例子：

    privatevoidfilteringWithThrottleFirst() {
        Observable
                .unsafeCreate(new Observable.OnSubscribe<Integer>() {
                    @Overridepublicvoidcall(Subscriber<? super Integer> subscriber) {
                        for (int i = 0; i < 10; i++) {
                            SystemClock.sleep( i % 5 * 1000);
                            subscriber.onNext(i);
                        }
                        subscriber.onCompleted();
                    }
                })
                .subscribeOn(Schedulers.computation())
                .throttleFirst(3, TimeUnit.SECONDS)
                .subscribe(this.<Integer>getPrintSubscriber());
    }

运行结果：

    07-1523:18:00.79817008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 007-1523:18:03.81317008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 207-1523:18:06.81517008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 307-1523:18:10.81617008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 407-1523:18:13.81817008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 707-1523:18:16.82017008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 807-1523:18:20.82217008-17648/top.shixinzhang.rxjavademo I/System.out: onNext: 907-1523:18:20.82217008-17648/top.shixinzhang.rxjavademo I/System.out: onCompleted

## Skip

`Skip` 的作用是，跳过指定数量的数据，发射后面的数据。

![](/wp-content/uploads/2017/07/1500290627.png)

RxJava 中的实现有两种，都叫 `skip`，不同的是一个是按个数算，一个是按时间算。

### skip(count)

![](/wp-content/uploads/2017/07/1500290628.png)

    publicfinal Observable<T> skip(int count) {
        return lift(new OperatorSkip<T>(count));
    }

使用例子：

    privatevoidfilteringWithSkip() {
        Observable.range(0 , 10)
                .skip(3)
                .subscribe(this.<Integer>getPrintSubscriber());
    }

运行结果：

    07-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 307-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 407-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 507-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 607-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 707-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 807-1523:22:14.47221075-21075/top.shixinzhang.rxjavademo I/System.out: onNext: 907-1523:22:14.47321075-21075/top.shixinzhang.rxjavademo I/System.out: onCompleted

### skip(time, unit)

![](/wp-content/uploads/2017/07/1500290630.png)

`skip(time, unit)` 的参数指定要跳过前指定时间内发射的数据。

    publicfinal Observable<T> skip(long time, TimeUnit unit) {
        return skip(time, unit, Schedulers.computation());
    }
    publicfinal Observable<T> skip(long time, TimeUnit unit, Scheduler scheduler) {
        return unsafeCreate(new OnSubscribeSkipTimed<T>(this, time, unit, scheduler));
    }

## SkipLast

既然有跳过从头开始的数据，自然也有跳过从后开始的数据，这就是 `SkipLast` 的作用。

![](/wp-content/uploads/2017/07/15002903791.png)

RxJava 中的实现也有两种，按时间和按个数，这里就暂不赘述了。
{% endraw %}
