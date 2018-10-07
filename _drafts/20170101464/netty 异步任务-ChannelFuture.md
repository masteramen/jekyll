---
layout: post
title:  "netty 异步任务-ChannelFuture"
title2:  "netty 异步任务-ChannelFuture"
date:   2017-01-01 23:59:24  +0800
source:  "http://www.jfox.info/netty%e5%bc%82%e6%ad%a5%e4%bb%bb%e5%8a%a1channelfuture.html"
fileName:  "20170101464"
lang:  "zh_CN"
published: true
permalink: "netty%e5%bc%82%e6%ad%a5%e4%bb%bb%e5%8a%a1channelfuture.html"
---
{% raw %}
netty Inboudn/Outbound通道Invoker: 
[http://donald-draper.iteye.com/blog/2388233](http://www.jfox.info/go.php?url=http://donald-draper.iteye.com/blog/2388233)**引言：**
上一篇看了Channel管道线的父类接口Inboudn/Outbound通道Invoker定义，先来回顾一下： 

每个通道Channel拥有自己的管道Pipeline，当通道创建时，管道自动创建,默认为DefaultChannelPipeline。Inbound通道Invoker ChannelInboundInvoker主要是触发管道线ChannelPipeline上的下一个Inbound通道处理器ChannelInboundHandler的相关方法。ChannelInboundInvoker有点Mina过滤器的意味。Outbound通道Invoker ChannelOutboundInvoker主要是触发触发管道线ChannelPipeline上的下一个Outbound通道处理器ChannelOnboundHandler的相关方法，同时增加了一下通道任务创建方法， 

ChannelOutboundInvoker也有点Mina过滤器的意味，只不过不像ChannelInboundInvoker的方法命名那么相似。 

在Outbound通道Invoker的方法定义中，我们看到有很多类型的返回异步任务， 

比如：ChannelFuture，ChannelPromise，ChannelProgressivePromise，我们来看一下这些异步任务： 

注意异步任务和异步结果的含义要结合上下文来看。 

//ChannelFuture 

    public interface ChannelFuture extends Future<Void> 

再看ChannelFuture之前，先看Future接口定义 

    import java.util.concurrent.CancellationException;
    import java.util.concurrent.TimeUnit;
    /**
     * The result of an asynchronous operation.
     一个异步操作接口，从定义来看继承与JUC的Future
     */
    @SuppressWarnings("ClassNameSameAsAncestorName")
    public interface Future<V> extends java.util.concurrent.Future<V> {
    
        /**
         * Returns {@code true} if and only if the I/O operation was completed
         * successfully.
         如果一个IO操作是否成功完成，返回ture
         */
        boolean isSuccess();
    
        /**
         * returns {@code true} if and only if the operation can be cancelled via {@link #cancel(boolean)}.
         如果一个操作通过cancel方法取消，则返回true
         */
        boolean isCancellable();
    
        /**
         * Returns the cause of the failed I/O operation if the I/O operation has
         * failed.
         *如果IO操作失败，则返回失败原因
         * @return the cause of the failure.
         *         {@code null} if succeeded or this future is not
         *         completed yet.
         */
        Throwable cause();
    
        /**
         * Adds the specified listener to this future.  The
         * specified listener is notified when this future is
         * {@linkplain #isDone() done}.  If this future is already
         * completed, the specified listener is notified immediately.
         添加任务监听器。当操作完成时，通知监听器。如果操作已经完成，则将立刻通知任务监听器。
         */
        Future<V> addListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        /**
         * Adds the specified listeners to this future.  The
         * specified listeners are notified when this future is
         * {@linkplain #isDone() done}.  If this future is already
         * completed, the specified listeners are notified immediately.
         与上述方法类似，可以一次添加多个监听器
         */
        Future<V> addListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        /**
         * Removes the first occurrence of the specified listener from this future.
         * The specified listener is no longer notified when this
         * future is {@linkplain #isDone() done}.  If the specified
         * listener is not associated with this future, this method
         * does nothing and returns silently.
         从异步任务移除监听器。当操作完成时，不在通知监听器。如果监听器与当前异步任务没有关联，
         则此方什么都不做
         */
        Future<V> removeListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        /**
         * Removes the first occurrence for each of the listeners from this future.
         * The specified listeners are no longer notified when this
         * future is {@linkplain #isDone() done}.  If the specified
         * listeners are not associated with this future, this method
         * does nothing and returns silently.
         与上述方法类似，可以一次移动多个监听器
         */
        Future<V> removeListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        /**
         * Waits for this future until it is done, and rethrows the cause of the failure if this future
         * failed.
         等待异步任务，直到操作完成，如果操作失败，则重新抛出失败的原因。
         */
        Future<V> sync() throws InterruptedException;
    
        /**
         * Waits for this future until it is done, and rethrows the cause of the failure if this future
         * failed.
         以不可中断方式，等待异步任务，直到操作完成，如果操作失败，则重新抛出失败的原因。
         */
        Future<V> syncUninterruptibly();
    
        /**
         * Waits for this future to be completed.
         *等待操作完成
         * @throws InterruptedException
         *         if the current thread was interrupted
         */
        Future<V> await() throws InterruptedException;
    
        /**
         * Waits for this future to be completed without
         * interruption.  This method catches an {@link InterruptedException} and
         * discards it silently.
         以不可中断方法等待操作结果，如果遇到中断异常，则直接丢弃
         */
        Future<V> awaitUninterruptibly();
    
        /**
         * Waits for this future to be completed within the
         * specified time limit.
         *超时等待操作完成
         * @return {@code true} if and only if the future was completed within
         *         the specified time limit
         *
         * @throws InterruptedException
         *         if the current thread was interrupted
         */
        boolean await(long timeout, TimeUnit unit) throws InterruptedException;
    
        /**
         * Waits for this future to be completed within the
         * specified time limit.
         *超时等待，单位毫秒
         * @return {@code true} if and only if the future was completed within
         *         the specified time limit
         *
         * @throws InterruptedException
         *         if the current thread was interrupted
         */
        boolean await(long timeoutMillis) throws InterruptedException;
    
        /**
         * Waits for this future to be completed within the
         * specified time limit without interruption.  This method catches an
         * {@link InterruptedException} and discards it silently.
         *超时不可中断等待操作结果
         * @return {@code true} if and only if the future was completed within
         *         the specified time limit
         */
        boolean awaitUninterruptibly(long timeout, TimeUnit unit);
    
        /**
         * Waits for this future to be completed within the
         * specified time limit without interruption.  This method catches an
         * {@link InterruptedException} and discards it silently.
         *超时不可中断等待操作结果，单位毫秒
         * @return {@code true} if and only if the future was completed within
         *         the specified time limit
         */
        boolean awaitUninterruptibly(long timeoutMillis);
    
        /**
         * Return the result without blocking. If the future is not done yet this will return {@code null}.
         *
         * As it is possible that a {@code null} value is used to mark the future as successful you also need to check
         * if the future is really done with {@link #isDone()} and not relay on the returned {@code null} value.
         */
        V getNow();
    
        /**
         * {@inheritDoc}
         *
         * If the cancellation was successful it will fail the future with an {@link CancellationException}.
         如果取消成功，返回一个取消异常的失败结果。
         */
        @Override
        boolean cancel(boolean mayInterruptIfRunning);
    }

从Netty的异步任务Future定义来看，继承于JUC的Future，可以异步获取IO操作的结果信息，比如操作是否成功完成，如果失败，可以获取失败的原因，是否取消，同时可以使用cancel方法取消IO操作，添加异步任务监听器，、监听IO操作是否完成，同时可以移除任务监听器，除这些之外我们可以异步、同步等待或超时等待IO操作结果。 

来看一下结果监听器： 

    import java.util.EventListener;
    
    /**
     * Listens to the result of a {@link Future}.  The result of the asynchronous operation is notified once this listener
     * is added by calling {@link Future#addListener(GenericFutureListener)}.
     监听IO操作异步结果。只要监听器被添加的异步任务中，异步操作完成，将会通知监听器。
     */
    public interface GenericFutureListener<F extends Future<?>> extends EventListener {
    
        /**
         * Invoked when the operation associated with the {@link Future} has been completed.
         当异步任务关联的IO操作完成时，触发operationComplete方法
         *
         * @param future  the source {@link Future} which called this callback
         */
        void operationComplete(F future) throws Exception;
    }

从上面来异步任务监听器，主要监听一个IO操作是否完成，在异步任务有返回值时，通知监听器。 

下面我们来看通道异步任务： 

    import io.netty.bootstrap.Bootstrap;
    import io.netty.util.concurrent.BlockingOperationException;
    import io.netty.util.concurrent.Future;
    import io.netty.util.concurrent.GenericFutureListener;
    
    import java.util.concurrent.TimeUnit;
    
    
    /**
     * The result of an asynchronous {@link Channel} I/O operation.
     ChannelFuture为一个通道的异步IO操作结果
     * <p>
     * All I/O operations in Netty are asynchronous.  It means any I/O calls will
     * return immediately with no guarantee that the requested I/O operation has
     * been completed at the end of the call.  Instead, you will be returned with
     * a {@link ChannelFuture} instance which gives you the information about the
     * result or status of the I/O operation.
     Netty所有的IO操作都是异步的。意味着所有IO操作在不能保证在调用结束后，IO请求操作完成
     情况下，立刻返回。然而，你可以返回一个异步结果实例，可以等待异步IO操作的结果或IO状态。
     * <p>
     * A {@link ChannelFuture} is either [i]uncompleted[/i] or [i]completed[/i].
     * When an I/O operation begins, a new future object is created.  The new future
     * is uncompleted initially - it is neither succeeded, failed, nor cancelled
     * because the I/O operation is not finished yet.  If the I/O operation is
     * finished either successfully, with failure, or by cancellation, the future is
     * marked as completed with more specific information, such as the cause of the
     * failure.  Please note that even failure and cancellation belong to the
     * completed state.
     当一个IO操作开始时，不管操作是否完成，一个新的异步操作结果将会被创建。
     如果因为IO操作没有完成，同时既没有成功，失败，也没有取消，新创建的
     异步结果并没有完成初始化。如果IO操作完成，不论操作结果成功，失败或取消，
     异步结果将会标记为完成，同时携带更多的精确信息，比如失败的原因。需要注意的时，
     失败或取消也属于完成状态。
     * <pre>
     *                                      +---------------------------+
     *                                      | Completed successfully    |
     *                                      +---------------------------+
     *                                 +---->      isDone() = true      |
     * +--------------------------+    |    |   isSuccess() = true      |
     * |        Uncompleted       |    |    +===========================+
     * +--------------------------+    |    | Completed with failure    |
     * |      isDone() = false    |    |    +---------------------------+
     * |   isSuccess() = false    |----+---->      isDone() = true      |
     * | isCancelled() = false    |    |    |       cause() = non-null  |
     * |       cause() = null     |    |    +===========================+
     * +--------------------------+    |    | Completed by cancellation |
     *                                 |    +---------------------------+
     *                                 +---->      isDone() = true      |
     *                                      | isCancelled() = true      |
     *                                      +---------------------------+
     * </pre>
     *
     * Various methods are provided to let you check if the I/O operation has been
     * completed, wait for the completion, and retrieve the result of the I/O
     * operation. It also allows you to add {@link ChannelFutureListener}s so you
     * can get notified when the I/O operation is completed.
     异步结果提供不同的方法，用于检查IO操作是否完成，等待操作完成，获取IO操作结果。
     同时运行添加通道结果监听器，以便可以在IO操作完成时获取通知。
     *
     * <h3>Prefer {@link #addListener(GenericFutureListener)} to {@link #await()}</h3>
     *
     * It is recommended to prefer {@link #addListener(GenericFutureListener)} to
     * {@link #await()} wherever possible to get notified when an I/O operation is
     * done and to do any follow-up tasks.
     强烈建议使用添加监听器的方式，而不是等待方式，等待IO操作完成，同时可以做一下一些任务。
     * <p>
     * {@link #addListener(GenericFutureListener)} is non-blocking.  It simply adds
     * the specified {@link ChannelFutureListener} to the {@link ChannelFuture}, and
     * I/O thread will notify the listeners when the I/O operation associated with
     * the future is done.  {@link ChannelFutureListener} yields the best
     * performance and resource utilization because it does not block at all, but
     * it could be tricky to implement a sequential logic if you are not used to
     * event-driven programming.
     添加监听器是非阻塞的。仅仅简单地添加一个通道结果监听器到异步监听结果，当IO操作关联的 异步任务完成时，IO线程将会通知监听器。通道结果监听器因为是非阻塞的，所以有更好的性能和资源利用率，如果你不使用事件驱动编程，可以实现一个时间顺序的逻辑。
     * <p>
     * By contrast, {@link #await()} is a blocking operation.  Once called, the
     * caller thread blocks until the operation is done.  It is easier to implement
     * a sequential logic with {@link #await()}, but the caller thread blocks
     * unnecessarily until the I/O operation is done and there's relatively
     * expensive cost of inter-thread notification.  Moreover, there's a chance of
     * dead lock in a particular circumstance, which is described below.
     相比之下，await方式是一个阻塞操作。一旦调用，调用线程将会阻塞到IO操作完成。
     使用await可以很容易实现一个时序的逻辑，但是调用线程不需要阻塞到IO操作完成，这种
     方式相对于内部线程通知，代价比较大。更进一步说，在特殊的循环下，有可能出现死锁情况，
     具体描述如下：
     *
     * <h3>Do not call {@link #await()} inside {@link ChannelHandler}</h3>
     * <p>不要在通道处理器中调用await方法
     * The event handler methods in {@link ChannelHandler} are usually called by
     * an I/O thread.  If {@link #await()} is called by an event handler
     * method, which is called by the I/O thread, the I/O operation it is waiting
     * for might never complete because {@link #await()} can block the I/O
     * operation it is waiting for, which is a dead lock.
     在通道处理器内，通常有IO线程调用事件处理方法。如果await方法被IO线程调用事件处理方法调用，IO操作将会等待，同时可能因为await方法阻塞IO操作正在等待的条件，可能导致死锁，进而Io操作不能完成。
     * <pre>
     * // BAD - NEVER DO THIS ，坚决不要用await方式
     * {@code @Override}
     * public void channelRead({@link ChannelHandlerContext} ctx, Object msg) {
     *     {@link ChannelFuture} future = ctx.channel().close();
     *     future.awaitUninterruptibly();
     *     // Perform post-closure operation
     *     // ...
     * }
     *
     * // GOOD
     * {@code @Override} 建议方式，减价通道结果监听器
     * public void channelRead({@link ChannelHandlerContext} ctx, Object msg) {
     *     {@link ChannelFuture} future = ctx.channel().close();
     *     future.addListener(new {@link ChannelFutureListener}() {
     *         public void operationComplete({@link ChannelFuture} future) {
     *             // Perform post-closure operation
     *             // ...
     *         }
     *     });
     * }
     * </pre>
     * <p>
     * In spite of the disadvantages mentioned above, there are certainly the cases
     * where it is more convenient to call {@link #await()}. In such a case, please
     * make sure you do not call {@link #await()} in an I/O thread.  Otherwise,
     * {@link BlockingOperationException} will be raised to prevent a dead lock.
     尽管await方法有诸多缺点，但在其他一些场景中，释放await方法，非常便利。在这些场景中，
     要确保不在IO线程中，调用await方法。否则阻塞操作异常将会抛出，以阻止死锁的产生。
     *
    
     * <h3>Do not confuse I/O timeout and await timeout</h3>
     *不要混淆IO超时和超时等待。
     * The timeout value you specify with {@link #await(long)},
     * {@link #await(long, TimeUnit)}, {@link #awaitUninterruptibly(long)}, or
     * {@link #awaitUninterruptibly(long, TimeUnit)} are not related with I/O
     * timeout at all.  If an I/O operation times out, the future will be marked as
     * 'completed with failure,' as depicted in the diagram above.  For example,
     * connect timeout should be configured via a transport-specific option:
     在await*（*）方法中的超时时间与IO超时一点关系也没有。如果一个IO操作超时，异步结果
     将被标记为失败并完成，如果上图中的描述。比如，连接超时应该通过transport配置。
     * <pre>
     * // BAD - NEVER DO THIS 坚决不要使用这种方式
     * {@link Bootstrap} b = ...;
     * {@link ChannelFuture} f = b.connect(...);
     * f.awaitUninterruptibly(10, TimeUnit.SECONDS);
     * if (f.isCancelled()) {
     *     // Connection attempt cancelled by user
     * } else if (!f.isSuccess()) {
     *     // You might get a NullPointerException here because the future
     *     // might not be completed yet.
     *     f.cause().printStackTrace();
     * } else {
     *     // Connection established successfully
     * }
     *
     * // GOOD 建议方式
     * {@link Bootstrap} b = ...;
     * // Configure the connect timeout option.
     * <b>b.option({@link ChannelOption}.CONNECT_TIMEOUT_MILLIS, 10000);</b>
     * {@link ChannelFuture} f = b.connect(...);
     * f.awaitUninterruptibly();
     *
     * // Now we are sure the future is completed.
     * assert f.isDone();
     *
     * if (f.isCancelled()) {
     *     // Connection attempt cancelled by user
     * } else if (!f.isSuccess()) {
     *     f.cause().printStackTrace();
     * } else {
     *     // Connection established successfully
     * }
     * </pre>
     */
    public interface ChannelFuture extends Future<Void> {
    
        /**
         * Returns a channel where the I/O operation associated with this
         * future takes place.
         返回异步结果关联IO操作所在的通道
         */
        Channel channel();
        //添加移除监听器，同步异步等待方法为空体，因为ChannelFuture继承与空异步结果，即没有返回值
        @Override
        ChannelFuture addListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelFuture addListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelFuture removeListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelFuture removeListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelFuture sync() throws InterruptedException;
    
        @Override
        ChannelFuture syncUninterruptibly();
    
        @Override
        ChannelFuture await() throws InterruptedException;
    
        @Override
        ChannelFuture awaitUninterruptibly();
    
        /**
         * Returns {@code true} if this {@link ChannelFuture} is a void future and so not allow to call any of the
         * following methods:
         如果通道异步结果为void，返回ture，并不允许调用下面方法
         * [list]
         *     [*]{@link #addListener(GenericFutureListener)}
    
         *     [*]{@link #addListeners(GenericFutureListener[])}
    
         *     [*]{@link #await()}
    
         *     [*]{@link #await(long, TimeUnit)} ()}
    
         *     [*]{@link #await(long)} ()}
    
         *     [*]{@link #awaitUninterruptibly()}
    
         *     [*]{@link #sync()}
    
         *     [*]{@link #syncUninterruptibly()}
    
         * [/list]
         */
        boolean isVoid();
    }

从上面可以看出，因为ChannelFuture继承于空异步结果，即没有返回值，所以添加移除监听器，同步异步等待方法为空体。netty所有的IO操作都是异步的，当一个IO操作开始时，不管操作是否完成，一个新的异步操作结果将会被创建。如果因为IO操作没有完成，同时既没有成功，失败，也没有取消，新创建的那么，异步结果并没有完成初始化。如果IO操作完成，不论操作结果成功，失败或取消，异步结果将会标记为完成，同时携带更多的精确信息，比如失败的原因。需要注意的时，失败或取消也属于完成状态。强烈建议使用添加监听器的方式等待IO操作结果，而不await方法，因为监听器模式时非阻塞的，有更好的性能和资源利用率。 

再来看一通道结果监听器： 

    package io.netty.channel;
    import io.netty.util.concurrent.Future;
    import io.netty.util.concurrent.GenericFutureListener;
    
    
    /**
     * Listens to the result of a {@link ChannelFuture}.  The result of the
     * asynchronous {@link Channel} I/O operation is notified once this listener
     * is added by calling {@link ChannelFuture#addListener(GenericFutureListener)}.
     *通道结果监听器ChannelFutureListener，监听通道任务的结果。一旦监听器被添加到通道任务中，
     当通道的异步IO操作完成时，将会通知监听器。
     * <h3>Return the control to the caller quickly</h3>
     *快速地将控制权交给调用者
     * {@link #operationComplete(Future)} is directly called by an I/O
     * thread.  Therefore, performing a time consuming task or a blocking operation
     * in the handler method can cause an unexpected pause during I/O.  If you need
     * to perform a blocking operation on I/O completion, try to execute the
     * operation in a different thread using a thread pool.
    #operationComplete直接通过IO线程调用。因此在IO操作过程中，执行一个耗时的任务或者阻塞操作在处理方法中，可能引起一个不期望的异常抛出。如果你需要执行一个阻塞操作在IO操作完成时，尝试在一个线程池中的不同线程执行操作。
     */
    public interface ChannelFutureListener extends GenericFutureListener<ChannelFuture> {
    
        /**
         * A {@link ChannelFutureListener} that closes the {@link Channel} which is
         * associated with the specified {@link ChannelFuture}.
         在操作完成时，关闭通道任务关联的通道
         */
        ChannelFutureListener CLOSE = new ChannelFutureListener() {
            @Override
            public void operationComplete(ChannelFuture future) {
                future.channel().close();
            }
        };
    
        /**
         * A {@link ChannelFutureListener} that closes the {@link Channel} when the
         * operation ended up with a failure or cancellation rather than a success.
         当IO操作失败时，关闭通道任务关联的通道
         */
        ChannelFutureListener CLOSE_ON_FAILURE = new ChannelFutureListener() {
            @Override
            public void operationComplete(ChannelFuture future) {
                if (!future.isSuccess()) {
                    future.channel().close();
                }
            }
        };
    
        /**
         * A {@link ChannelFutureListener} that forwards the {@link Throwable} of the {@link ChannelFuture} into the
         * {@link ChannelPipeline}. This mimics the old behavior of Netty 3.
         转发通道任务异常到Channel管道。默认Netty3的行为。
         */
        ChannelFutureListener FIRE_EXCEPTION_ON_FAILURE = new ChannelFutureListener() {
            @Override
            public void operationComplete(ChannelFuture future) {
                if (!future.isSuccess()) {
                    future.channel().pipeline().fireExceptionCaught(future.cause());
                }
            }
        };
    
        // Just a type alias
    }

从上面来看，通道结果监听器内部有3个监听器，分别为在操作完成时，关闭通道任务关联的通道的监听器CLOSE；当IO操作失败时，关闭通道任务关联的通道的监听器CLOSE_ON_FAILURE；转发通道任务异常到Channel管道的监听器FIRE_EXCEPTION_ON_FAILURE。 

来看一下可写的通道结果ChannelPromise 

    /**
     * Special {@link ChannelFuture} which is writable.
     */
    public interface ChannelPromise extends ChannelFuture, Promise<Void> {
    在往下看之前，来看Promise接口定义：
    /**
     * Special {@link Future} which is writable.
     可写的Future
     */
    public interface Promise<V> extends Future<V> {
    
        /**
         * Marks this future as a success and notifies all
         * listeners.
         标记任务成功，通知所有监听器
         *
         * If it is success or failed already it will throw an {@link IllegalStateException}.
         如果任务已经成功完成或失败，则抛出非法状态异常
         */
        Promise<V> setSuccess(V result);
    
        /**
         * Marks this future as a success and notifies all
         * listeners.
         *标记任务成功，通知所有监听器
         * @return {@code true} if and only if successfully marked this future as
         *         a success. Otherwise {@code false} because this future is
         *         already marked as either a success or a failure.
         成功标记Future为成功完成，则返回true，如果任务已经标记成功完成或失败，则返回false
         */
        boolean trySuccess(V result);
    
        /**
         * Marks this future as a failure and notifies all
         * listeners.
         *标记任务失败，通知所有监听器
         * If it is success or failed already it will throw an {@link IllegalStateException}.
         如果任务已经成功完成或失败，则抛出非法状态异常
         */
        Promise<V> setFailure(Throwable cause);
    
        /**
         * Marks this future as a failure and notifies all
         * listeners.
         *标记任务失败，通知所有监听器
         * @return {@code true} if and only if successfully marked this future as
         *         a failure. Otherwise {@code false} because this future is
         *         already marked as either a success or a failure.
          成功标记Future为失败完成，则返回true，如果任务已经标记成功完成或失败，则返回false
         */
        boolean tryFailure(Throwable cause);
    
        /**
         * Make this future impossible to cancel.
         *标记任务不可能取消
         * @return {@code true} if and only if successfully marked this future as uncancellable or it is already done
         *         without being cancelled.  {@code false} if this future has been cancelled already.
         如果成功标记不可取消，或在没有取消的情况下已经标记，则返回true，如果任务已经取消，返回false
         */
        boolean setUncancellable();
        //下面方法与Future相同
    
        @Override
        Promise<V> addListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        @Override
        Promise<V> addListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        @Override
        Promise<V> removeListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        @Override
        Promise<V> removeListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        @Override
        Promise<V> await() throws InterruptedException;
    
        @Override
        Promise<V> awaitUninterruptibly();
    
        @Override
        Promise<V> sync() throws InterruptedException;
    
        @Override
        Promise<V> syncUninterruptibly();
    }

从Promise任务定义可以看出，继承了任务Future，但多了以便标记成功、失败和不可取消的方法。 

再来看一下 

    import io.netty.util.concurrent.Future;
    import io.netty.util.concurrent.GenericFutureListener;
    import io.netty.util.concurrent.Promise;
    
    /**
     * Special {@link ChannelFuture} which is writable.
     */
    public interface ChannelPromise extends ChannelFuture, Promise<Void> {
    
        @Override
        Channel channel();
    
        @Override
        ChannelPromise setSuccess(Void result);
    
        ChannelPromise setSuccess();
    
        boolean trySuccess();
    
        @Override
        ChannelPromise setFailure(Throwable cause);
    
        @Override
        ChannelPromise addListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelPromise addListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelPromise removeListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelPromise removeListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelPromise sync() throws InterruptedException;
    
        @Override
        ChannelPromise syncUninterruptibly();
    
        @Override
        ChannelPromise await() throws InterruptedException;
    
        @Override
        ChannelPromise awaitUninterruptibly();
    
        /**
         * Returns a new {@link ChannelPromise} if {@link #isVoid()} returns {@code true} otherwise itself.
         如果isVoid返回true，而不它自己，则返回一个新的ChannelPromise
         */
        ChannelPromise unvoid();
    }

从上可以看出，ChannelPromise与ChannelFuture的不同在于ChannelPromise可以标记任务结果。 

**
总结：**
      netty的异步结果Future继承于JUC的Future，可以异步获取IO操作的结果信息，比如IO操作是否成功完成，如果失败，可以获取失败的原因，是否取消，同时可以使用cancel方法取消IO操作，添加异步结果监听器，、监听IO操作是否完成，并可以移除结果监听器，除这些之外我们还可以异步、同步等待或超时等待IO操作结果。 

      异步结果监听器GenericFutureListener，主要监听一个IO操作是否完成，在异步结果有返回值时，通知监听器。 

      ChannelFuture继承于空异步结果，即没有返回值，所以添加移除监听器，同步异步等待方法为空体。netty所有的IO操作都是异步的，当一个IO操作开始时，不管操作是否完成，一个新的异步操作结果将会被创建。如果因为IO操作没有完成，同时既没有成功，失败，也没有取消，新创建的那么，异步结果并没有完成初始化。如果IO操作完成，不论操作结果成功，失败或取消，异步结果将会标记为完成，同时携带更多的精确信息，比如失败的原因。需要注意的时，失败或取消也属于完成状态。强烈建议使用添加监听器的方式等待IO操作结果，而不await方法，因为监听器模式时非阻塞的，有更好的性能和资源利用率。 

      通道结果监听器ChannelFutureListener内部有3个监听器，分别为在操作完成时，关闭通道任务关联的通道的监听器CLOSE；当IO操作失败时，关闭通道任务关联的通道的监听器CLOSE_ON_FAILURE；转发通道任务异常到Channel管道的监听器FIRE_EXCEPTION_ON_FAILURE。 

       Promise任务继承了任务Future，但多了以便标记成功、失败和不可取消的方法。 

ChannelPromise与ChannelFuture的不同在于ChannelPromise可以标记任务结果。 

ChannelProgressivePromise与ProgressivePromise，ChannelProgressiveFuture的关系与ChannelPromise与Promise，ChannelFuture的关系类似，只不过ChannelPromise表示异步操作任务，ChannelProgressivePromise表示异步任务的进度，同时Promise类型异步任务都是可写的。 

附： 

ChannelProgressivePromise接口，简单看一下： 

//ChannelProgressivePromise 

    package io.netty.channel;
    
    import io.netty.util.concurrent.Future;
    import io.netty.util.concurrent.GenericFutureListener;
    import io.netty.util.concurrent.ProgressivePromise;
    
    /**
     * Special {@link ChannelPromise} which will be notified once the associated bytes is transferring.
     当关联的字节数据正在传输时，ChannelProgressivePromise将会被通知
     */
    public interface ChannelProgressivePromise extends ProgressivePromise<Void>, ChannelProgressiveFuture, ChannelPromise {
    
        @Override
        ChannelProgressivePromise addListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelProgressivePromise addListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelProgressivePromise removeListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelProgressivePromise removeListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelProgressivePromise sync() throws InterruptedException;
    
        @Override
        ChannelProgressivePromise syncUninterruptibly();
    
        @Override
        ChannelProgressivePromise await() throws InterruptedException;
    
        @Override
        ChannelProgressivePromise awaitUninterruptibly();
    
        @Override
        ChannelProgressivePromise setSuccess(Void result);
    
        @Override
        ChannelProgressivePromise setSuccess();
    
        @Override
        ChannelProgressivePromise setFailure(Throwable cause);
    
        @Override
        ChannelProgressivePromise setProgress(long progress, long total);
    
        @Override
        ChannelProgressivePromise unvoid();
    }

//ProgressivePromise 

    /**
     * Special {@link ProgressiveFuture} which is writable.
     可写的过程任务。
     */
    public interface ProgressivePromise<V> extends Promise<V>, ProgressiveFuture<V> {
    
        /**
         * Sets the current progress of the operation and notifies the listeners that implement
         * {@link GenericProgressiveFutureListener}.
         设置当前操作进程，并通知监听器GenericProgressiveFutureListener
         */
        ProgressivePromise<V> setProgress(long progress, long total);
    
        /**
         * Tries to set the current progress of the operation and notifies the listeners that implement
         * {@link GenericProgressiveFutureListener}.  If the operation is already complete or the progress is out of range,
         * this method does nothing but returning {@code false}.
         设置当前操作进程，并通知监听器GenericProgressiveFutureListener。如果此操作已经完成，进度已经超过范围，
         此方法不会做任何事情，仅仅返回false。
         */
        boolean tryProgress(long progress, long total);
    
        @Override
        ProgressivePromise<V> setSuccess(V result);
    
        @Override
        ProgressivePromise<V> setFailure(Throwable cause);
    
        @Override
        ProgressivePromise<V> addListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        @Override
        ProgressivePromise<V> addListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        @Override
        ProgressivePromise<V> removeListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        @Override
        ProgressivePromise<V> removeListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        @Override
        ProgressivePromise<V> await() throws InterruptedException;
    
        @Override
        ProgressivePromise<V> awaitUninterruptibly();
    
        @Override
        ProgressivePromise<V> sync() throws InterruptedException;
    
        @Override
        ProgressivePromise<V> syncUninterruptibly();
    }

//GenericProgressiveFutureListener 

    package io.netty.util.concurrent;
    
    public interface GenericProgressiveFutureListener<F extends ProgressiveFuture<?>> extends GenericFutureListener<F> {
        /**
         * Invoked when the operation has progressed.
         *操作已经达到所设的进度
         * @param progress the progress of the operation so far (cumulative)，操作当前进度
         * @param total the number that signifies the end of the operation when {@code progress} reaches at it.
         *              {@code -1} if the end of operation is unknown.
         total，当操作完成时达到的进度，如果操作的结束点不确定，则为-1
         */
        void operationProgressed(F future, long progress, long total) throws Exception;
    }

//ProgressiveFuture 

    **
     * A {@link Future} which is used to indicate the progress of an operation.
     表示一个操作的进度
     */
    public interface ProgressiveFuture<V> extends Future<V> {
    
        @Override
        ProgressiveFuture<V> addListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        @Override
        ProgressiveFuture<V> addListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        @Override
        ProgressiveFuture<V> removeListener(GenericFutureListener<? extends Future<? super V>> listener);
    
        @Override
        ProgressiveFuture<V> removeListeners(GenericFutureListener<? extends Future<? super V>>... listeners);
    
        @Override
        ProgressiveFuture<V> sync() throws InterruptedException;
    
        @Override
        ProgressiveFuture<V> syncUninterruptibly();
    
        @Override
        ProgressiveFuture<V> await() throws InterruptedException;
    
        @Override
        ProgressiveFuture<V> awaitUninterruptibly();
    }

//ChannelProgressiveFuture 

    /**
     * An special {@link ChannelFuture} which is used to indicate the {@link FileRegion} transfer progress
     表示一个文件region的传输进度
     */
    public interface ChannelProgressiveFuture extends ChannelFuture, ProgressiveFuture<Void> {
        @Override
        ChannelProgressiveFuture addListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelProgressiveFuture addListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelProgressiveFuture removeListener(GenericFutureListener<? extends Future<? super Void>> listener);
    
        @Override
        ChannelProgressiveFuture removeListeners(GenericFutureListener<? extends Future<? super Void>>... listeners);
    
        @Override
        ChannelProgressiveFuture sync() throws InterruptedException;
    
        @Override
        ChannelProgressiveFuture syncUninterruptibly();
    
        @Override
        ChannelProgressiveFuture await() throws InterruptedException;
    
        @Override
        ChannelProgressiveFuture awaitUninterruptibly();
    }
{% endraw %}
