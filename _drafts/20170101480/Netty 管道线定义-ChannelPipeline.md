---
layout: post
title:  "Netty 管道线定义-ChannelPipeline"
title2:  "Netty 管道线定义-ChannelPipeline"
date:   2017-01-01 23:59:40  +0800
source:  "https://www.jfox.info/netty%e7%ae%a1%e9%81%93%e7%ba%bf%e5%ae%9a%e4%b9%89channelpipeline.html"
fileName:  "20170101480"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/netty%e7%ae%a1%e9%81%93%e7%ba%bf%e5%ae%9a%e4%b9%89channelpipeline.html"
---
{% raw %}
netty Inboudn/Outbound通道Invoker: 
[http://donald-draper.iteye.com/blog/2388233](https://www.jfox.info/go.php?url=http://donald-draper.iteye.com/blog/2388233)netty 异步任务-ChannelFuture： 
[http://donald-draper.iteye.com/blog/2388297](https://www.jfox.info/go.php?url=http://donald-draper.iteye.com/blog/2388297)
引言: 

上一篇文章我们看了异步任务相关接口的定义，先来回顾一下： 

      netty的异步结果Future继承于JUC的Future，可以异步获取IO操作的结果信息，比如IO操作是否成功完成，如果失败，可以获取失败的原因，是否取消，同时可以使用cancel方法取消IO操作，添加异步结果监听器，、监听IO操作是否完成，并可以移除结果监听器，除这些之外我们还可以异步、同步等待或超时等待IO操作结果。 

      异步结果监听器GenericFutureListener，主要监听一个IO操作是否完成，在异步结果有返回值时，通知监听器。 

      ChannelFuture继承于空异步结果，即没有返回值，所以添加移除监听器，同步异步等待方法为空体。netty所有的IO操作都是异步的，当一个IO操作开始时，不管操作是否完成，一个新的异步操作结果将会被创建。如果因为IO操作没有完成，同时既没有成功，失败，也没有取消，新创建的那么，异步结果并没有完成初始化。如果IO操作完成，不论操作结果成功，失败或取消，异步结果将会标记为完成，同时携带更多的精确信息，比如失败的原因。需要注意的时，失败或取消也属于完成状态。强烈建议使用添加监听器的方式等待IO操作结果，而不await方法，因为监听器模式时非阻塞的，有更好的性能和资源利用率。 

      通道结果监听器ChannelFutureListener内部有3个监听器，分别为在操作完成时，关闭通道任务关联的通道的监听器CLOSE；当IO操作失败时，关闭通道任务关联的通道的监听器CLOSE_ON_FAILURE；转发通道任务异常到Channel管道的监听器FIRE_EXCEPTION_ON_FAILURE。 

       Promise任务继承了任务Future，但多了以便标记成功、失败和不可取消的方法。 

ChannelPromise与ChannelFuture的不同在于ChannelPromise可以标记任务结果。 

ChannelProgressivePromise与ProgressivePromise，ChannelProgressiveFuture的关系与ChannelPromise与Promise，ChannelFuture的关系类似，只不过ChannelPromise表示异步操作任务，ChannelProgressivePromise表示异步任务的进度，同时Promise类型异步任务都是可写的。 

今天来看一下Channel管道线的定义： 

    package io.netty.channel;
    
    import io.netty.buffer.ByteBuf;
    import io.netty.util.concurrent.DefaultEventExecutorGroup;
    import io.netty.util.concurrent.EventExecutorGroup;
    
    import java.net.SocketAddress;
    import java.nio.ByteBuffer;
    import java.nio.channels.SocketChannel;
    import java.util.List;
    import java.util.Map;
    import java.util.Map.Entry;
    import java.util.NoSuchElementException;
    
    
    /**
     * A list of {@link ChannelHandler}s which handles or intercepts inbound events and outbound operations of a
     * {@link Channel}.  {@link ChannelPipeline} implements an advanced form of the
     * [url=http://www.oracle.com/technetwork/java/interceptingfilter-142169.html]Intercepting Filter[/url] pattern
     * to give a user full control over how an event is handled and how the {@link ChannelHandler}s in a pipeline
     * interact with each other.
     *通道处理器集合ChannelPipeline可以处理或拦截关联通道的Inbound事件和Outbound操作。管道线实现了拦截过滤器模式，
     使开发者可以完全控制事件如何处理，以及通道处理器在管道中如何交互。
     * <h3>Creation of a pipeline</h3>
     *创建管道
     * Each channel has its own pipeline and it is created automatically when a new channel is created.
     *每个通道拥有自己的管道，当通道创建时，管道自动创建
     * <h3>How an event flows in a pipeline</h3>
     *管道事件流
     * The following diagram describes how I/O events are processed by {@link ChannelHandler}s in a {@link ChannelPipeline}
     * typically. An I/O event is handled by either a {@link ChannelInboundHandler} or a {@link ChannelOutboundHandler}
     * and be forwarded to its closest handler by calling the event propagation methods defined in
     * {@link ChannelHandlerContext}, such as {@link ChannelHandlerContext#fireChannelRead(Object)} and
     * {@link ChannelHandlerContext#write(Object)}.
     *下图描述事件如何被管道中的通道处理器处理过程。一个IO事件被Inbound或Outbound通道处理器处理时，可以通过通道
     的上下文的相关事件传播方法，将事件转发给相邻的通道处理器，比如 ChannelHandlerContext#fireChannelRead(Object)和
    ChannelHandlerContext#write(Object)方法。
     * <pre>
     *                                                 I/O Request
     *                                            via {@link Channel} or
     *                                        {@link ChannelHandlerContext}
     *                                                      |
     *  +---------------------------------------------------+---------------+
     *  |                           ChannelPipeline         |               |
     *  |                                                  \|/              |
     *  |    +---------------------+            +-----------+----------+    |
     *  |    | Inbound Handler  N  |            | Outbound Handler  1  |    |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |              /|\                                  |               |
     *  |               |                                  \|/              |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |    | Inbound Handler N-1 |            | Outbound Handler  2  |    |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |              /|\                                  .               |
     *  |               .                                   .               |
     *  | ChannelHandlerContext.fireIN_EVT() ChannelHandlerContext.OUT_EVT()|
     *  |        [ method call]                       [method call]         |
     *  |               .                                   .               |
     *  |               .                                  \|/              |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |    | Inbound Handler  2  |            | Outbound Handler M-1 |    |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |              /|\                                  |               |
     *  |               |                                  \|/              |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |    | Inbound Handler  1  |            | Outbound Handler  M  |    |
     *  |    +----------+----------+            +-----------+----------+    |
     *  |              /|\                                  |               |
     *  +---------------+-----------------------------------+---------------+
     *                  |                                  \|/
     *  +---------------+-----------------------------------+---------------+
     *  |               |                                   |               |
     *  |       [ Socket.read() ]                    [ Socket.write() ]     |
     *  |                                                                   |
     *  |  Netty Internal I/O Threads (Transport Implementation)            |
     *  +-------------------------------------------------------------------+
     * </pre>
     * An inbound event is handled by the inbound handlers in the bottom-up direction as shown on the left side of the
     * diagram.  An inbound handler usually handles the inbound data generated by the I/O thread on the bottom of the
     * diagram.  The inbound data is often read from a remote peer via the actual input operation such as
     * {@link SocketChannel#read(ByteBuffer)}.  If an inbound event goes beyond the top inbound handler, it is discarded
     * silently, or logged if it needs your attention.
     在上图中左边，一个inbound事件，由下向上被Inbound通道处理器处理。一个Inbound通道处理器，一般处理来自IO线程的数据。
     Inbound数据，通常通过实际的输入操作，如SocketChannel#read，从远端peer读取。如果inbound事件到达Inbound处理器的顶部，
     默认将会被抛弃，如果需要关注，可以log
     * <p>
     * An outbound event is handled by the outbound handler in the top-down direction as shown on the right side of the
     * diagram.  An outbound handler usually generates or transforms the outbound traffic such as write requests.
     * If an outbound event goes beyond the bottom outbound handler, it is handled by an I/O thread associated with the
     * {@link Channel}. The I/O thread often performs the actual output operation such as
     * {@link SocketChannel#write(ByteBuffer)}.
    在上图中的右边， 一个Outbound事件，被Outbound通道处理器从上到下处理。一个Outbound通道处理器通常产生或者转发Outbound数据，
    不如写请求。如果outbound事件到达Outbound通道处理器的底部，那么将会被通道关联的Io线程处理。IO线程执行实际的输出操作，
    如SocketChannel#write。
     * <p>
     * For example, let us assume that we created the following pipeline:
     来看一个例子，假设创建管道如下
     * <pre>
     * {@link ChannelPipeline} p = ...;
     * p.addLast("1", new InboundHandlerA());
     * p.addLast("2", new InboundHandlerB());
     * p.addLast("3", new OutboundHandlerA());
     * p.addLast("4", new OutboundHandlerB());
     * p.addLast("5", new InboundOutboundHandlerX());
     * </pre>
     * In the example above, the class whose name starts with {@code Inbound} means it is an inbound handler.
     * The class whose name starts with {@code Outbound} means it is a outbound handler.
     在上述示例中，Inbound开头的为Inbound处理器，Outbound开头的为Outbound处理器
     * <p>
     * In the given example configuration, the handler evaluation order is 1, 2, 3, 4, 5 when an event goes inbound.
     * When an event goes outbound, the order is 5, 4, 3, 2, 1.  On top of this principle, {@link ChannelPipeline} skips
     * the evaluation of certain handlers to shorten the stack depth:
     inbound事件处理的顺序为1, 2, 3, 4, 5，outbound事件为5, 4, 3, 2, 1。基于管道的top原则将会跳过一些无用的处理器，
     以缩短通道处理器栈的深度。
     * [list]
     * <li>3 and 4 don't implement {@link ChannelInboundHandler}, and therefore the actual evaluation order of an inbound
     *     event will be: 1, 2, and 5.</li> 
       由于3,4没有实现inbound通道处理器，因此实际inbound通道处理器的顺序为1,2,5.
     * <li>1 and 2 don't implement {@link ChannelOutboundHandler}, and therefore the actual evaluation order of a
     *     outbound event will be: 5, 4, and 3.</li>
        由于1,2没有实现inbound通道处理器，因此实际inbound通道处理器的顺序为5, 4, 3.
     * <li>If 5 implements both {@link ChannelInboundHandler} and {@link ChannelOutboundHandler}, the evaluation order of
     *     an inbound and a outbound event could be 125 and 543 respectively.</li>
     如果5实现了inbound和Outbound，则inbound事件，处理器顺序为125，oubound事件为543.
     * [/list]
     *
     * <h3>Forwarding an event to the next handler</h3>
     *转发事件到下一个处理器
     * As you might noticed in the diagram shows, a handler has to invoke the event propagation methods in
     * {@link ChannelHandlerContext} to forward an event to its next handler.  Those methods include:
     在上图中，你可能已经注意到，一个处理器不得不调用关联的上下文的事件传播方法，将事件传播给下一个处理器。
     这些方法如下：
     * [list]
     * <li>Inbound event propagation methods:
     *     [list]
     *     [*]{@link ChannelHandlerContext#fireChannelRegistered()}
    
     *     [*]{@link ChannelHandlerContext#fireChannelActive()}
    
     *     [*]{@link ChannelHandlerContext#fireChannelRead(Object)}
    
     *     [*]{@link ChannelHandlerContext#fireChannelReadComplete()}
    
     *     [*]{@link ChannelHandlerContext#fireExceptionCaught(Throwable)}
    
     *     [*]{@link ChannelHandlerContext#fireUserEventTriggered(Object)}
    
     *     [*]{@link ChannelHandlerContext#fireChannelWritabilityChanged()}
    
     *     [*]{@link ChannelHandlerContext#fireChannelInactive()}
    
     *     [*]{@link ChannelHandlerContext#fireChannelUnregistered()}
    
     *     [/list]
     * </li>
     * <li>Outbound event propagation methods:
     *     [list]
     *     [*]{@link ChannelHandlerContext#bind(SocketAddress, ChannelPromise)}
    
     *     [*]{@link ChannelHandlerContext#connect(SocketAddress, SocketAddress, ChannelPromise)}
    
     *     [*]{@link ChannelHandlerContext#write(Object, ChannelPromise)}
    
     *     [*]{@link ChannelHandlerContext#flush()}
    
     *     [*]{@link ChannelHandlerContext#read()}
    
     *     [*]{@link ChannelHandlerContext#disconnect(ChannelPromise)}
    
     *     [*]{@link ChannelHandlerContext#close(ChannelPromise)}
    
     *     [*]{@link ChannelHandlerContext#deregister(ChannelPromise)}
    
     *     [/list]
     * </li>
     * [/list]
     *
     * and the following example shows how the event propagation is usually done:
     *下面的实例展示事件如何传播
     * <pre>
     * public class MyInboundHandler extends {@link ChannelInboundHandlerAdapter} {
     *     {@code @Override}
     *     public void channelActive({@link ChannelHandlerContext} ctx) {
     *         System.out.println("Connected!");
     *         ctx.fireChannelActive();
     *     }
     * }
     *
     * public class MyOutboundHandler extends {@link ChannelOutboundHandlerAdapter} {
     *     {@code @Override}
     *     public void close({@link ChannelHandlerContext} ctx, {@link ChannelPromise} promise) {
     *         System.out.println("Closing ..");
     *         ctx.close(promise);
     *     }
     * }
     * </pre>
     *
     * <h3>Building a pipeline</h3>
     * <p>构建管道
     * A user is supposed to have one or more {@link ChannelHandler}s in a pipeline to receive I/O events (e.g. read) and
     * to request I/O operations (e.g. write and close).  For example, a typical server will have the following handlers
     * in each channel's pipeline, but your mileage may vary depending on the complexity and characteristics of the
     * protocol and business logic:
     用户可能在管道中有多个通道处理器，处理IO事件和IO请求操作(write and close)。比如，一个典型的服务器，在每个通道的
     管道中有如下handler，处理过程可能因为不同的协议和业务逻辑而不同
     *
     * [list=1]
     * [*]Protocol Decoder - translates binary data (e.g. {@link ByteBuf}) into a Java object.
    
     * [*]Protocol Encoder - translates a Java object into binary data.
    
     * [*]Business Logic Handler - performs the actual business logic (e.g. database access).
    
     解码器，编码器，业务逻辑Handler
     * [/list]
     *
     * and it could be represented as shown in the following example:
     *下面为一个实例
     * <pre>IO事件操作执行器组
     * static final {@link EventExecutorGroup} group = new {@link DefaultEventExecutorGroup}(16);
     * ...
     *获取通道的管道
     * {@link ChannelPipeline} pipeline = ch.pipeline();
     *添加解码器和编码器
     * pipeline.addLast("decoder", new MyProtocolDecoder());
     * pipeline.addLast("encoder", new MyProtocolEncoder());
     *
     * // Tell the pipeline to run MyBusinessLogicHandler's event handler methods
     * // in a different thread than an I/O thread so that the I/O thread is not blocked by
     * // a time-consuming task.
     * // If your business logic is fully asynchronous or finished very quickly, you don't
     * // need to specify a group.
     告诉管道，在不同于IO线程的事件执行器组中，执行通道处理器的事件执行方法，以保证IO线程不会被
     一个耗时任务阻塞。如果你的业务逻辑完全异步或能够快速的完成，你不要添加一个事件执行器组。
     * pipeline.addLast(group, "handler", new MyBusinessLogicHandler());
     * </pre>
     *
     * <h3>Thread safety</h3>
     * <p>线程安全
     * A {@link ChannelHandler} can be added or removed at any time because a {@link ChannelPipeline} is thread safe.
     * For example, you can insert an encryption handler when sensitive information is about to be exchanged, and remove it
     * after the exchange.
     由于管道时线程安全的，通道处理器可以在任何时候，添加或移除。比如：当有一些敏感数据要交换时，插入加密Handler，
     在交换后，移除。
     */
    public interface ChannelPipeline
            extends ChannelInboundInvoker, ChannelOutboundInvoker, Iterable<Entry<String, ChannelHandler>> {
    
        /**
         * Inserts a {@link ChannelHandler} at the first position of this pipeline.
         *添加通道处理器到管道的头部
         * @param name     the name of the handler to insert first
         * @param handler  the handler to insert first
         *
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified handler is {@code null}
         */
        ChannelPipeline addFirst(String name, ChannelHandler handler);
    
        /**
         * Inserts a {@link ChannelHandler} at the first position of this pipeline.
         *与上面方法不同的是，则增加了一个事件执行器组参数
         * @param group    the {@link EventExecutorGroup} which will be used to execute the {@link ChannelHandler}
         *                 methods
         * @param name     the name of the handler to insert first
         * @param handler  the handler to insert first
         *
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified handler is {@code null}
         */
        ChannelPipeline addFirst(EventExecutorGroup group, String name, ChannelHandler handler);
    
        /**
         * Appends a {@link ChannelHandler} at the last position of this pipeline.
         *添加通道处理器到管道的尾部
         * @param name     the name of the handler to append
         * @param handler  the handler to append
         *
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified handler is {@code null}
         */
        ChannelPipeline addLast(String name, ChannelHandler handler);
    
        /**
         * Appends a {@link ChannelHandler} at the last position of this pipeline.
         *与上面方法不同的是，则增加了一个事件执行器组参数
         * @param group    the {@link EventExecutorGroup} which will be used to execute the {@link ChannelHandler}
         *                 methods
         * @param name     the name of the handler to append
         * @param handler  the handler to append
         *
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified handler is {@code null}
         */
        ChannelPipeline addLast(EventExecutorGroup group, String name, ChannelHandler handler);
    
        /**
         * Inserts a {@link ChannelHandler} before an existing handler of this
         * pipeline.
         *添加通道处理器到管道的指定通道处理器的前面
         * @param baseName  the name of the existing handler
         * @param name      the name of the handler to insert before
         * @param handler   the handler to insert before
         *
         * @throws NoSuchElementException
         *         if there's no such entry with the specified {@code baseName}
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified baseName or handler is {@code null}
         */
        ChannelPipeline addBefore(String baseName, String name, ChannelHandler handler);
    
        /**
         * Inserts a {@link ChannelHandler} before an existing handler of this
         * pipeline.
         *与上面方法不同的是，则增加了一个事件执行器组参数
         * @param group     the {@link EventExecutorGroup} which will be used to execute the {@link ChannelHandler}
         *                  methods
         * @param baseName  the name of the existing handler
         * @param name      the name of the handler to insert before
         * @param handler   the handler to insert before
         *
         * @throws NoSuchElementException
         *         if there's no such entry with the specified {@code baseName}
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified baseName or handler is {@code null}
         */
        ChannelPipeline addBefore(EventExecutorGroup group, String baseName, String name, ChannelHandler handler);
    
        /**
         * Inserts a {@link ChannelHandler} after an existing handler of this
         * pipeline.
         *添加通道处理器到管道的指定通道处理器的后面
         * @param baseName  the name of the existing handler
         * @param name      the name of the handler to insert after
         * @param handler   the handler to insert after
         *
         * @throws NoSuchElementException
         *         if there's no such entry with the specified {@code baseName}
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified baseName or handler is {@code null}
         */
        ChannelPipeline addAfter(String baseName, String name, ChannelHandler handler);
    
        /**
         * Inserts a {@link ChannelHandler} after an existing handler of this
         * pipeline.
         *与上面方法不同的是，则增加了一个事件执行器组参数
         * @param group     the {@link EventExecutorGroup} which will be used to execute the {@link ChannelHandler}
         *                  methods
         * @param baseName  the name of the existing handler
         * @param name      the name of the handler to insert after
         * @param handler   the handler to insert after
         *
         * @throws NoSuchElementException
         *         if there's no such entry with the specified {@code baseName}
         * @throws IllegalArgumentException
         *         if there's an entry with the same name already in the pipeline
         * @throws NullPointerException
         *         if the specified baseName or handler is {@code null}
         */
        ChannelPipeline addAfter(EventExecutorGroup group, String baseName, String name, ChannelHandler handler);
    
        /**
         * Inserts {@link ChannelHandler}s at the first position of this pipeline.
         *添加多个通道处理器到管道的头部
         * @param handlers  the handlers to insert first
         *
         */
        ChannelPipeline addFirst(ChannelHandler... handlers);
    
        /**
         * Inserts {@link ChannelHandler}s at the first position of this pipeline.
         *与上面方法不同的是，则增加了一个事件执行器组参数
         * @param group     the {@link EventExecutorGroup} which will be used to execute the {@link ChannelHandler}s
         *                  methods.
         * @param handlers  the handlers to insert first
         *
         */
        ChannelPipeline addFirst(EventExecutorGroup group, ChannelHandler... handlers);
    
        /**
         * Inserts {@link ChannelHandler}s at the last position of this pipeline.
         *添加多个通道处理器到管道的尾部
         * @param handlers  the handlers to insert last
         *
         */
        ChannelPipeline addLast(ChannelHandler... handlers);
    
        /**
         * Inserts {@link ChannelHandler}s at the last position of this pipeline.
         *与上面方法不同的是，则增加了一个事件执行器组参数
         * @param group     the {@link EventExecutorGroup} which will be used to execute the {@link ChannelHandler}s
         *                  methods.
         * @param handlers  the handlers to insert last
         *
         */
        ChannelPipeline addLast(EventExecutorGroup group, ChannelHandler... handlers);
    
        /**
         * Removes the specified {@link ChannelHandler} from this pipeline.
         *从管道线移除指定的通道处理器
         * @param  handler          the {@link ChannelHandler} to remove
         *
         * @throws NoSuchElementException
         *         if there's no such handler in this pipeline
         * @throws NullPointerException
         *         if the specified handler is {@code null}
         */
        ChannelPipeline remove(ChannelHandler handler);
    
        /**
         * Removes the {@link ChannelHandler} with the specified name from this pipeline.
         根据通道处理器名，从管道中移除对应通道处理器
         *
         * @param  name             the name under which the {@link ChannelHandler} was stored.
         *
         * @return the removed handler
         *
         * @throws NoSuchElementException
         *         if there's no such handler with the specified name in this pipeline
         * @throws NullPointerException
         *         if the specified name is {@code null}
         */
        ChannelHandler remove(String name);
    
        /**
         * Removes the {@link ChannelHandler} of the specified type from this pipeline.
         *移除指定的类型的通道处理器
         * @param <T>           the type of the handler
         * @param handlerType   the type of the handler
         *
         * @return the removed handler
         *
         * @throws NoSuchElementException
         *         if there's no such handler of the specified type in this pipeline
         * @throws NullPointerException
         *         if the specified handler type is {@code null}
         */
        <T extends ChannelHandler> T remove(Class<T> handlerType);
    
        /**
         * Removes the first {@link ChannelHandler} in this pipeline.
         *移除管道线头部的通道处理器
         * @return the removed handler
         *
         * @throws NoSuchElementException
         *         if this pipeline is empty
         */
        ChannelHandler removeFirst();
    
        /**
         * Removes the last {@link ChannelHandler} in this pipeline.
         *移除管道线尾部的通道处理器
         * @return the removed handler
         *
         * @throws NoSuchElementException
         *         if this pipeline is empty
         */
        ChannelHandler removeLast();
    
        /**
         * Replaces the specified {@link ChannelHandler} with a new handler in this pipeline.
         *替换管道中旧的通道处理器
         * @param  oldHandler    the {@link ChannelHandler} to be replaced
         * @param  newName       the name under which the replacement should be added
         * @param  newHandler    the {@link ChannelHandler} which is used as replacement
         *
         * @return itself
    
         * @throws NoSuchElementException
         *         if the specified old handler does not exist in this pipeline
         * @throws IllegalArgumentException
         *         if a handler with the specified new name already exists in this
         *         pipeline, except for the handler to be replaced
         * @throws NullPointerException
         *         if the specified old handler or new handler is
         *         {@code null}
         */
        ChannelPipeline replace(ChannelHandler oldHandler, String newName, ChannelHandler newHandler);
    
        /**
         * Replaces the {@link ChannelHandler} of the specified name with a new handler in this pipeline.
         *与上面方法不同的，指定原始通道处理器的名字
         * @param  oldName       the name of the {@link ChannelHandler} to be replaced
         * @param  newName       the name under which the replacement should be added
         * @param  newHandler    the {@link ChannelHandler} which is used as replacement
         *
         * @return the removed handler
         *
         * @throws NoSuchElementException
         *         if the handler with the specified old name does not exist in this pipeline
         * @throws IllegalArgumentException
         *         if a handler with the specified new name already exists in this
         *         pipeline, except for the handler to be replaced
         * @throws NullPointerException
         *         if the specified old handler or new handler is
         *         {@code null}
         */
        ChannelHandler replace(String oldName, String newName, ChannelHandler newHandler);
    
        /**
         * Replaces the {@link ChannelHandler} of the specified type with a new handler in this pipeline.
         *与上面方法不同的，指定原始通道处理器的类型
         * @param  oldHandlerType   the type of the handler to be removed
         * @param  newName          the name under which the replacement should be added
         * @param  newHandler       the {@link ChannelHandler} which is used as replacement
         *
         * @return the removed handler
         *
         * @throws NoSuchElementException
         *         if the handler of the specified old handler type does not exist
         *         in this pipeline
         * @throws IllegalArgumentException
         *         if a handler with the specified new name already exists in this
         *         pipeline, except for the handler to be replaced
         * @throws NullPointerException
         *         if the specified old handler or new handler is
         *         {@code null}
         */
        <T extends ChannelHandler> T replace(Class<T> oldHandlerType, String newName,
                                             ChannelHandler newHandler);
    
        /**
         * Returns the first {@link ChannelHandler} in this pipeline.
         *返回管道头部的通道处理器
         * @return the first handler.  {@code null} if this pipeline is empty.
         */
        ChannelHandler first();
    
        /**
         * Returns the context of the first {@link ChannelHandler} in this pipeline.
         *返回管道头部的通道处理器的上下文
         * @return the context of the first handler.  {@code null} if this pipeline is empty.
         */
        ChannelHandlerContext firstContext();
    
        /**
         * Returns the last {@link ChannelHandler} in this pipeline.
         *返回管道尾部的通道处理器
         * @return the last handler.  {@code null} if this pipeline is empty.
         */
        ChannelHandler last();
    
        /**
         * Returns the context of the last {@link ChannelHandler} in this pipeline.
         *返回管道尾部的通道处理器的上下文
         * @return the context of the last handler.  {@code null} if this pipeline is empty.
         */
        ChannelHandlerContext lastContext();
    
        /**
         * Returns the {@link ChannelHandler} with the specified name in this
         * pipeline.
         *根据名字获取管道中的对应的通道处理器
         * @return the handler with the specified name.
         *         {@code null} if there's no such handler in this pipeline.
         */
        ChannelHandler get(String name);
    
        /**
         * Returns the {@link ChannelHandler} of the specified type in this
         * pipeline.
         *根据通道处理器类型获取管道中的对应的通道处理器
         * @return the handler of the specified handler type.
         *         {@code null} if there's no such handler in this pipeline.
         */
        <T extends ChannelHandler> T get(Class<T> handlerType);
    
        /**
         * Returns the context object of the specified {@link ChannelHandler} in
         * this pipeline.
         *获取管道中指定通道处理器的上下文
         * @return the context object of the specified handler.
         *         {@code null} if there's no such handler in this pipeline.
         */
        ChannelHandlerContext context(ChannelHandler handler);
    
        /**
         * Returns the context object of the {@link ChannelHandler} with the
         * specified name in this pipeline.
         *获取管道中指定名字对应的通道处理器的上下文
         * @return the context object of the handler with the specified name.
         *         {@code null} if there's no such handler in this pipeline.
         */
        ChannelHandlerContext context(String name);
    
        /**
         * Returns the context object of the {@link ChannelHandler} of the
         * specified type in this pipeline.
         *获取管道中指定类型对应的通道处理器的上下文
         * @return the context object of the handler of the specified type.
         *         {@code null} if there's no such handler in this pipeline.
         */
        ChannelHandlerContext context(Class<? extends ChannelHandler> handlerType);
    
        /**
         * Returns the {@link Channel} that this pipeline is attached to.
         *返回管道所属的Channel
         * @return the channel. {@code null} if this pipeline is not attached yet.
         */
        Channel channel();
    
        /**
         * Returns the {@link List} of the handler names.
         获取管道中所有通道处理器的名字
         */
        List<String> names();
    
        /**
         * Converts this pipeline into an ordered {@link Map} whose keys are
         * handler names and whose values are handlers.
         将管道的中通道处理器，转换为name与Handler的Entry Map
         */
        Map<String, ChannelHandler> toMap();
    
        @Override
        ChannelPipeline fireChannelRegistered();
    
         @Override
        ChannelPipeline fireChannelUnregistered();
    
        @Override
        ChannelPipeline fireChannelActive();
    
        @Override
        ChannelPipeline fireChannelInactive();
    
        @Override
        ChannelPipeline fireExceptionCaught(Throwable cause);
    
        @Override
        ChannelPipeline fireUserEventTriggered(Object event);
    
        @Override
        ChannelPipeline fireChannelRead(Object msg);
    
        @Override
        ChannelPipeline fireChannelReadComplete();
    
        @Override
        ChannelPipeline fireChannelWritabilityChanged();
    
        @Override
        ChannelPipeline flush();
    }

从Channel管道线ChannelPipeline定义来看，Channle管道线继承了Inbound、OutBound通道Invoker和Iterable>接口，Channel管道线主要是管理Channel的通道处理器，每个通道有一个Channle管道线。Channle管道线主要定义了添加移除替换通道处理器的相关方法，在添加通道处理器的相关方法中，有一个事件执行器group参数，用于中Inbound和Outbound的相关事件，告诉管道，在不同于IO线程的事件执行器组中，执行通道处理器的事件执行方法，以保证IO线程不会被一个耗时任务阻塞，如果你的业务逻辑完全异步或能够快速的完成，可以添加一个事件执行器组。 

**
总结：**Channle管道线继承了Inbound、OutBound通道Invoker和Iterable<Entry<String, ChannelHandler>>接口，Channel管道线主要是管理Channel的通道处理器，每个通道有一个Channle管道线。Channle管道线主要定义了添加移除替换通道处理器的相关方法，在添加通道处理器的相关方法中，有一个事件执行器group参数，用于中Inbound和Outbound的相关事件，告诉管道，在不同于IO线程的事件执行器组中，执行通道处理器的事件执行方法，以保证IO线程不会被一个耗时任务阻塞，如果你的业务逻辑完全异步或能够快速的完成，可以添加一个事件执行器组。Channel管道线中的Inbound和Outbound通道处理器，主要通过通道处理器上下文的相关fire-INBOUND_ENT和OUTBOUND_OPR事件方法，传播Inbound和Outbound事件给管道中的下一个通道处理器。
{% endraw %}
