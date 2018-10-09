---
layout: post
title:  "netty 简单Inbound信道处理器（SimpleChannelInboundHandler）"
title2:  "netty 简单Inbound信道处理器（SimpleChannelInboundHandler）"
date:   2017-01-01 23:58:49  +0800
source:  "https://www.jfox.info/netty%e7%ae%80%e5%8d%95inbound%e4%bf%a1%e9%81%93%e5%a4%84%e7%90%86%e5%99%a8simplechannelinboundhandler.html"
fileName:  "20170101429"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/netty%e7%ae%80%e5%8d%95inbound%e4%bf%a1%e9%81%93%e5%a4%84%e7%90%86%e5%99%a8simplechannelinboundhandler.html"
---
{% raw %}
Netty 通道处理器ChannelHandler和适配器定义ChannelHandlerAdapter： 

[http://donald-draper.iteye.com/blog/2386891](https://www.jfox.info/go.php?url=http://donald-draper.iteye.com/blog/2386891)Netty Inbound/Outbound通道处理器定义： 
[http://donald-draper.iteye.com/blog/2387019](https://www.jfox.info/go.php?url=http://donald-draper.iteye.com/blog/2387019)**引言：**
前面一篇文章我们看了Inbound/Outbound通道处理器定义先来回顾一下先： 

       通道Inbound处理器，主要是处理从peer发送过来的字节流；通道处理器上下文关联的通道注册到事件循环EventLoop时，触发channelRegistered方法；通道处理器上下文关联的通道激活时，触发channelActive方法；通道从peer读取消息时，触发channelRead方法；当上一消息通过#channelRead方法，并被当先读操作消费时，触发channelReadComplete方法，如果通道配置项 

#AUTO_READ为关闭状态，没有进一步尝试从当前通道读取inbound数据时，直到ChannelHandlerContext#read调用，触发；当用户事件发生时，触发userEventTriggered方法；异常抛出时，触发exceptionCaught方法；当通道可写状态改变时，触发channelWritabilityChanged方法；通道处理器上下文关联的通道注册到事件循环EventLoop，但处于非激活状态，达到生命周期的末端时，触发channelInactive方法；通道处理器上下文关联的通道从事件循环EventLoop移除时，触发channelUnregistered方法。 

        Inbound通道handler适配器ChannelInboundHandlerAdapter，提供的Inbound通道处理器的所有方法的实现，但实现仅仅是，转发操作给Channel管道线的下一个通道处理器，子类必须重写方法。需要注意的是，在#channelRead方法自动返回后，消息并没有释放。如果你寻找ChannelInboundHandler的实现，可以自动释放接受的到消息可以使用SimpleChannelInboundHandler。 

        Outbound通道处理器ChannelOutboundHandler主要处理outbound IO操作。当绑定操作发生时，调用bind方法；当连接操作发生时，调用connect方法；read方法拦截通道处理器上下文读操作；当写操发生时，调用write方法，写操作通过Channel管道线写消息，当通道调用#flush方法时，消息将会被刷新，发送出去；当一个刷新操作发生时，调用flush方法，刷新操作将会刷新所有先前已经写，待发送的消息。 

        Outbound通道Handler适配器ChannelOutboundHandlerAdapter为Outbound通道处理器的基本实现，这个实现仅仅通过通道处理器上下文转发方法的调用。 

子类必须重写Outbound通道Handler适配器的相关方法。 

        在Mina中，通道读写全部在一个通道Handler，Mina提供的通道Handler适配器，我们在使用通道处理器时继承它，实现我们需要关注的读写事件。而Netty使用InBound和OutBound将通道的读写分离，同时提供了InBound和OutBound通道Handler的适配器。 

今天来看一下SimpleChannelInboundHandler： 

    package io.netty.channel;
    
    import io.netty.util.ReferenceCountUtil;
    import io.netty.util.internal.TypeParameterMatcher;
    
    /**
     * {@link ChannelInboundHandlerAdapter} which allows to explicit only handle a specific type of messages.
     *简单Inbound通道处理器SimpleChannelInboundHandler，允许明确处理一种特殊类型的消息。
     * For example here is an implementation which only handle {@link String} messages.
     *下面是一个处理String类型数据Inbound通道处理器实现
     * <pre>
     *     public class StringHandler extends
     *             {@link SimpleChannelInboundHandler}<{@link String}> {
     *
     *         {@code @Override}
     *         protected void channelRead0({@link ChannelHandlerContext} ctx, {@link String} message)
     *                 throws {@link Exception} {
     *             System.out.println(message);
     *         }
     *     }
     * </pre>
     *
     * Be aware that depending of the constructor parameters it will release all handled messages by passing them to
     * {@link ReferenceCountUtil#release(Object)}. In this case you may need to use
     * {@link ReferenceCountUtil#retain(Object)} if you pass the object to the next handler in the {@link ChannelPipeline}.
     *需要注意的是，是否通过转递消息给ReferenceCountUtil#release方法，释放处理过的消息，依赖于构造参数autoRelease（boolean）。
     如果你需要将消息传递给Channle管道线的下一个通道处理器，你需要调用ReferenceCountUtil#retain(Object)方法；
     * <h3>Forward compatibility notice</h3>
     * 转发兼容性提醒
     * Please keep in mind that {@link #channelRead0(ChannelHandlerContext, I)} will be renamed to
     * {@code messageReceived(ChannelHandlerContext, I)} in 5.0.
     * 
    
     请注意：#channelRead0方法在Netty5，中将被命名为消息messageReceived。
     */
    public abstract class SimpleChannelInboundHandler<I> extends ChannelInboundHandlerAdapter {
    
        private final TypeParameterMatcher matcher;//类型参数匹配器
        private final boolean autoRelease;//是否自动释放
    
        /**
         * see {@link #SimpleChannelInboundHandler(boolean)} with {@code true} as boolean parameter.
         默认自动释放处理过的消息
         */
        protected SimpleChannelInboundHandler() {
            this(true);
        }
    
        /**
         * Create a new instance which will try to detect the types to match out of the type parameter of the class.
         *创建一个实例，尝试探测接受消息类型与SimpleChannelInboundHandler的I的类型是否相同。
         * @param autoRelease   {@code true} if handled messages should be released automatically by passing them to
         *                      {@link ReferenceCountUtil#release(Object)}.
         是否通过ReferenceCountUtil#release方法释放消息
         */
        protected SimpleChannelInboundHandler(boolean autoRelease) {
            matcher = TypeParameterMatcher.find(this, SimpleChannelInboundHandler.class, "I");
            this.autoRelease = autoRelease;
        }
    
        /**
         * see {@link #SimpleChannelInboundHandler(Class, boolean)} with {@code true} as boolean value.
         */
        protected SimpleChannelInboundHandler(Class<? extends I> inboundMessageType) {
            this(inboundMessageType, true);
        }
    
        /**
         * Create a new instance
         *
         * @param inboundMessageType    The type of messages to match
         * @param autoRelease           {@code true} if handled messages should be released automatically by passing them to
         *                              {@link ReferenceCountUtil#release(Object)}.
         */
        protected SimpleChannelInboundHandler(Class<? extends I> inboundMessageType, boolean autoRelease) {
            matcher = TypeParameterMatcher.get(inboundMessageType);
            this.autoRelease = autoRelease;
        }
    
        /**
         * Returns {@code true} if the given message should be handled. If {@code false} it will be passed to the next
         * {@link ChannelInboundHandler} in the {@link ChannelPipeline}.
         判断跟定的消息类型是否可以被处理，如果返回false，则将消息转递给Channel管道线的下一个通道处理器
         */
        public boolean acceptInboundMessage(Object msg) throws Exception {
            return matcher.match(msg);
        }
        //读取消息对象
        @Override
        public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
            boolean release = true;
            try {
                if (acceptInboundMessage(msg)) {
                    @SuppressWarnings("unchecked")
                    I imsg = (I) msg;
    		//如果消息属于本Handler可以处理的消息类型，则委托给channelRead0
                    channelRead0(ctx, imsg);
                } else {
                    release = false;
    		//当前通道Handler，不可处理消息，通过通道上下文，通知管道线中的下一个通道处理器，接受到一个消息
                    ctx.fireChannelRead(msg);
                }
            } finally {
                if (autoRelease && release) {
    	        //如果autoRelease为自动释放消息，且消息已处理则释放消息
                    ReferenceCountUtil.release(msg);
                }
            }
        }
    
        /**
         * [b]Please keep in mind that this method will be renamed to
         * {@code messageReceived(ChannelHandlerContext, I)} in 5.0.[/b]
         *注意此方法在5.0以后将命名为messageReceived
         * Is called for each message of type {@link I}.
         *
         * @param ctx           the {@link ChannelHandlerContext} which this {@link SimpleChannelInboundHandler}
         *                      belongs to
         * @param msg           the message to handle
         * @throws Exception    is thrown if an error occurred
         */
        protected abstract void channelRead0(ChannelHandlerContext ctx, I msg) throws Exception;
    }
    

来看读取消息对象方法： 

    //读取消息对象
        @Override
        public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
            boolean release = true;
            try {
                if (acceptInboundMessage(msg)) {
                    @SuppressWarnings("unchecked")
                    I imsg = (I) msg;
    		//如果消息属于本Handler可以处理的消息类型，则委托给channelRead0
                    channelRead0(ctx, imsg);
                } else {
                    release = false;
    		//当前通道Handler，不可处理消息，通过通道上下文，通知管道线中的下一个通道处理器，接受到一个消息
                    ctx.fireChannelRead(msg);
                }
            } finally {
                if (autoRelease && release) {
    	        //如果autoRelease为自动释放消息，且消息已处理则释放消息
                    ReferenceCountUtil.release(msg);
                }
            }
        }

 其中有两点需要关注： 

 1. 

    //当前通道Handler，不可处理消息，通过通道上下文，通知管道线中的下一个通道处理器，接受到一个消息
     ctx.fireChannelRead(msg);

 //ChannelHandlerContext 

    public interface ChannelHandlerContext extends AttributeMap, ChannelInboundInvoker, ChannelOutboundInvoker {
     @Override
        ChannelHandlerContext fireChannelRead(Object msg);
    }
    

//ChannelInboundInvoker 

    /**
     * A {@link Channel} received a message.
     *通道接收一个消息
     * This will result in having the {@link ChannelInboundHandler#channelRead(ChannelHandlerContext, Object)}
     * method  called of the next {@link ChannelInboundHandler} contained in the  {@link ChannelPipeline} of the
     * {@link Channel}.
     ChannelInboundHandler#channelRead方法调用将会通知，通道所在的Channel管道线中的下一个通道处理器，接受一个消息
     */
    ChannelInboundInvoker fireChannelRead(Object msg);

2. 

    //如果autoRelease为自动释放消息，且消息已处理则释放消息
    ReferenceCountUtil.release(msg);

    //ReferenceCountUtil
        /**
         * Try to call {@link ReferenceCounted#release()} if the specified message implements {@link ReferenceCounted}.
         * If the specified message doesn't implement {@link ReferenceCounted}, this method does nothing.
         如果消息实现了ReferenceCounted，则调用ReferenceCounted#release()，如果不是什么都不做
         */
        public static boolean release(Object msg) {
            if (msg instanceof ReferenceCounted) {
                return ((ReferenceCounted) msg).release();
            }
            return false;
        }

//ReferenceCounted 

     /**
         * Decreases the reference count by {@code 1} and deallocates this object if the reference count reaches at
         * {@code 0}.
         *自减引用计数器，如果计数器为0，则回收对象。
         * @return {@code true} if and only if the reference count became {@code 0} and this object has been deallocated
         */
        boolean release();

从上面来看，读操作，首先判断跟定的消息类型是否可以被处理，如果是，则委托给channelRead0，如果返回false，则将消息转递给Channel管道线的下一个通道处理器；最后，如果autoRelease为自动释放消息，且消息已处理则释放消息。 

在简单Inbound通道处理器的构造方法： 

     protected SimpleChannelInboundHandler(boolean autoRelease) {
            matcher = TypeParameterMatcher.find(this, SimpleChannelInboundHandler.class, "I");
            this.autoRelease = autoRelease;
        }
     protected SimpleChannelInboundHandler(Class<? extends I> inboundMessageType, boolean autoRelease) {
            matcher = TypeParameterMatcher.get(inboundMessageType);
            this.autoRelease = autoRelease;
        }

和acceptInboundMessage方法中 

 //判断跟定的消息类型是否可以被处理，如果返回false，则将消息转递给Channel管道线的下一个通道处理器 

   

     public boolean acceptInboundMessage(Object msg) throws Exception {
            return matcher.match(msg);
        }

涉及到一个参数类型匹配器TypeParameterMatcher，为了理解TypeParameterMatcher花了几天时间， 

学习了一下java Type体系结构，在往下看之前，需要了解java Type体系结构，具体可以参考一下连接: 

Type —— Java类型: 
[http://blog.csdn.net/a327369238/article/details/52621043](https://www.jfox.info/go.php?url=http://blog.csdn.net/a327369238/article/details/52621043)详解Java泛型type体系整理: 
[http://developer.51cto.com/art/201103/250028.htm](https://www.jfox.info/go.php?url=http://developer.51cto.com/art/201103/250028.htm)
 黑马程序员–Java基础加强–13.利用反射操作泛型II【TypeVariable】【GenericArrayType】【WildcardType】【Type及其子接口的来历】【个人总结】 

: 
[http://blog.csdn.net/benjaminzhang666/article/details/9839007](https://www.jfox.info/go.php?url=http://blog.csdn.net/benjaminzhang666/article/details/9839007)泛型通配符extends与super的区别: 
[http://www.cnblogs.com/yepei/p/6591289.html](https://www.jfox.info/go.php?url=http://www.cnblogs.com/yepei/p/6591289.html)另外附上java Type体系结构的示例地址： 
[https://github.com/Donaldhan/java-base-demo](https://www.jfox.info/go.php?url=https://github.com/Donaldhan/java-base-demo)
本身这篇文章应该上个星期就出来呢？由于对java Type体系结构不熟，难以理解参数类型匹配器TypeParameterMatcher，所以推迟到现在，本身同时想写一篇java Type体系结构相关的文章，后来一想算了，网上很多资料，再加上自己写Demo里面有相关的说明，就不写了，一个字懒…… 

言归正传，下面我们来看TypeParameterMatcher 

    package io.netty.util.internal;
    
    import java.lang.reflect.Array;
    import java.lang.reflect.GenericArrayType;
    import java.lang.reflect.ParameterizedType;
    import java.lang.reflect.Type;
    import java.lang.reflect.TypeVariable;
    import java.util.HashMap;
    import java.util.Map;
    
    public abstract class TypeParameterMatcher {
        //默认空参数类型匹配器，匹配方法永远返回true
        private static final TypeParameterMatcher NOOP = new TypeParameterMatcher() {
            @Override
            public boolean match(Object msg) {
                return true;
            }
        };
        //判断消息对象类型是否匹配当前类型匹配器
        public abstract boolean match(Object msg);
        //反射匹配器
        private static final class ReflectiveMatcher extends TypeParameterMatcher {
            private final Class<?> type;
    
            ReflectiveMatcher(Class<?> type) {
                this.type = type;
            }
            //根据对象是为类型Type的实例，来判断是否消息是否匹配
            @Override
            public boolean match(Object msg) {
                return type.isInstance(msg);
            }
        }
    
        TypeParameterMatcher() { }
        //根据Class类型获取类型参数匹配器
        public static TypeParameterMatcher get(final Class<?> parameterType) {
           //从Netty内部线程本地Map，获取当前线程类型参数匹配器缓存
            final Map<Class<?>, TypeParameterMatcher> getCache =
                    InternalThreadLocalMap.get().typeParameterMatcherGetCache();
            //从类型参数匹配器缓存，获取类型parameterType对应的类型参数匹配器
            TypeParameterMatcher matcher = getCache.get(parameterType);
            if (matcher == null) {//如果匹配器为空
                if (parameterType == Object.class) {匹配参数为Object，匹配器为NOOP
                    matcher = NOOP;
                } else {
                    matcher = new ReflectiveMatcher(parameterType);
                }
                getCache.put(parameterType, matcher);
            }
    
            return matcher;
        }
        //跟实例object，类型父类parametrizedSuperclass，类型参数名typeParamName，获取类型参数名object对应的类型参数匹配器
        public static TypeParameterMatcher find(
                final Object object, final Class<?> parametrizedSuperclass, final String typeParamName) {
    	//从Netty内部线程本地Map，获取当前线程类型参数匹配器缓存
            final Map<Class<?>, Map<String, TypeParameterMatcher>> findCache =
                    InternalThreadLocalMap.get().typeParameterMatcherFindCache();
    	//获取object类型
            final Class<?> thisClass = object.getClass();
            //从类型参数匹配器缓存，获取类型thisClass对应的类型参数匹配器映射关系
            Map<String, TypeParameterMatcher> map = findCache.get(thisClass);
            if (map == null) {
    	    //如果不存在object类型对应的类型参数匹配器映射关系，则创建，并添加到缓存中
                map = new HashMap<String, TypeParameterMatcher>();
                findCache.put(thisClass, map);
            }
            //从object类型对应的类型参数匹配器Map中获取，对应的类型参数匹配器
            TypeParameterMatcher matcher = map.get(typeParamName);
            if (matcher == null) {
                //如果object对应的类型参数匹配器为空，则从父类中获取类型参数名对应的类型的参数匹配器
                matcher = get(find0(object, parametrizedSuperclass, typeParamName));
    	    //类型参数名和类型参数匹配器，添加到对应的映射Map中
                map.put(typeParamName, matcher);
            }
    
            return matcher;
        }
        //获取obejct实际类型父类parametrizedSuperclass泛型参数中，类型参数名为typeParamName对应的原始类型
        private static Class<?> find0(
                final Object object, Class<?> parametrizedSuperclass, String typeParamName) {
            //获取object的类型
            final Class<?> thisClass = object.getClass();
            Class<?> currentClass = thisClass;
            for (;;) {
                if (currentClass.getSuperclass() == parametrizedSuperclass) {//如果当前类型父类为parametrizedSuperclass
                    int typeParamIndex = -1;
    		//获取当前类父类的泛型类型变量
                    TypeVariable<?>[] typeParams = currentClass.getSuperclass().getTypeParameters();
                    for (int i = 0; i < typeParams.length; i ++) {
    		     //寻找类型参数名对应的类型变量，如果找到，则记录类型变量索引位置
                        if (typeParamName.equals(typeParams[i].getName())) {
                            typeParamIndex = i;
                            break;
                        }
                    }
                    //如果索引为位置小于0，即，在object类型父类的类型变量中没有找到typeParamName对应的类型变量
                    if (typeParamIndex < 0) {
                        throw new IllegalStateException(
                                "unknown type parameter '" + typeParamName + "': " + parametrizedSuperclass);
                    }
                    //获取当前类的父类泛型类型
                    Type genericSuperType = currentClass.getGenericSuperclass();
                    if (!(genericSuperType instanceof ParameterizedType)) {
    	            //如果父类的泛型类型非参数化类型，则返回Object类型
                        return Object.class;
                    }
                    //获取父类的实际类型参数
                    Type[] actualTypeParams = ((ParameterizedType) genericSuperType).getActualTypeArguments();
                    Type actualTypeParam = actualTypeParams[typeParamIndex];
                    if (actualTypeParam instanceof ParameterizedType) {
    		    //如果实际类型参数为参数化类型，则获取实际类型参数的原始类型RawType（不包括泛型部分）
                        actualTypeParam = ((ParameterizedType) actualTypeParam).getRawType();
                    }
                    if (actualTypeParam instanceof Class) {
    		   //如果实际类型为Class，则直接返回Class
                        return (Class<?>) actualTypeParam;
                    }
                    if (actualTypeParam instanceof GenericArrayType) {
    		    //如果实际类型参数为泛型数组类型，获取泛型数组类型的泛型组件类型GenericComponentType
                        Type componentType = ((GenericArrayType) actualTypeParam).getGenericComponentType();
                        if (componentType instanceof ParameterizedType) {
    			如果组件类型为参数化类型，则组件类型为原始类型RawType
                            componentType = ((ParameterizedType) componentType).getRawType();
                        }
                        if (componentType instanceof Class) {
    		        //如果组件类型为Class，则创建对应的数组实例，并获取实例的类型
                            return Array.newInstance((Class<?>) componentType, 0).getClass();
                        }
                    }
                    if (actualTypeParam instanceof TypeVariable) {
    		   //如果实际类型参数为类型变量，转化实际类型参数为类型变量
                        // Resolved type parameter points to another type parameter.
                        TypeVariable<?> v = (TypeVariable<?>) actualTypeParam;
                        currentClass = thisClass;
                        if (!(v.getGenericDeclaration() instanceof Class)) {
    		        //如果类型变量的声明类不是Class，则返回Object类型
                            return Object.class;
                        }
                        //参数化父类的类型为，类型变量v的声明类
                        parametrizedSuperclass = (Class<?>) v.getGenericDeclaration();
    		    //获取类型变量名称
                        typeParamName = v.getName();
                        if (parametrizedSuperclass.isAssignableFrom(thisClass)) {
    		        //如果参数类型父类为thisClass类型，则跳出当前循环
                            continue;
                        } else {
    		        //否则返回Object类型
                            return Object.class;
                        }
                    }
    
                    return fail(thisClass, typeParamName);
                }
    	    //否则获取当前类型的父类
                currentClass = currentClass.getSuperclass();
                if (currentClass == null) {
                    return fail(thisClass, typeParamName);
                }
            }
        }
        //找不到类型参数名对应的类型，则抛出非法状态异常
        private static Class<?> fail(Class<?> type, String typeParamName) {
            throw new IllegalStateException(
                    "cannot determine the type of the type parameter '" + typeParamName + "': " + type);
        }
    }

这个类型参数匹配器就不说了，各种变量的叫法，容易搞混，要结合代码注释看。 

简单小节一下： 

类型参数匹配器，作用主要主要是判断实例的类型是否为类型参数匹配器对应类型的实例，是则返回ture，否返回false。主要是用于，当通道读取消息对象时，判断通道是不可以处理此消息对象。 

get方法：根据Class类型获取类型参数匹配器，首先从Netty内部线程本地Map，获取当前线程类型参数匹配器缓存，从类型参数匹配器缓存，获取参数类型parameterType对应的类型参数匹配器，如果匹配器为空且匹配参数为Object，则匹配器为NOOP，否则，根据参数类型创建ReflectiveMatcher添加到缓存中。 

find方法：跟实例object，类型父类parametrizedSuperclass，类型参数名typeParamName， 

获取类型参数名object对应的类型参数匹配器，首先从Netty内部线程本地Map，获取当前线程类型参数匹配器缓存，从类型参数匹配器缓存，获取objec类型thisClass对应的类型参数匹配器映射关系，如果不存在object类型对应的类型参数匹配器映射关系，则创建，并添加到缓存中，否则，从object类型对应的类型参数匹配器Map中获取，对应的类型参数匹配器，如果object对应的类型参数匹配器为空，则从父类中获取类型参数名对应的类型的参数匹配器（find0方法获取类型参数名对应的原始类），并将类型与从父类中获取匹配器映射关系，添加到缓存中，否则直接返回匹配器。 

find0方法：获取obejct实际类型父类parametrizedSuperclass泛型参数中，类型参数名为typeParamName对应的原始类型过程为，首先获取object的类型currentClass，如果当前类型currentClass的父类为parametrizedSuperclass，获取当前类父类的泛型类型变量，寻找类型参数名对应的类型变量，如果找到，则记录类型变量索引位置，如果索引为位置小于0，即，在object类型父类的类型变量中没有找到typeParamName对应的类型变量，否则，获取当前类的父类泛型类型，如果父类的泛型类型非参数化类型，则返回Object类型，否则，获取父类的实际类型参数，如果实际类型参数为参数化类型，则获取索引对应实际类型参数的原始类型RawType， 

如果实际类型为Class，则直接返回Class，如果实际类型参数为泛型数组类型，获取泛型数组类型的泛型组件类型GenericComponentType，如果组件类型为参数化类型，则组件类型为原始类型RawType，如果组件类型为Class，则创建对应的数组实例，并获取实例的类型，如果实际类型参数为类型变量，转化实际类型参数为类型变量v，如果类型变量的声明类不是Class，则返回Object类型，否则设置参数化父类的类型为类型变量v的声明类，如果参数类型父类为thisClass类型，则跳出当前循环，否则返回Object类型，这时，当前类型currentClass的父类为parametrizedSuperclas的情况结束；如果父类不为parametrizedSuperclas，则获取currentClass父类，并设置为当前类继续自旋。自旋的目的是，找到与parametrizedSuperclas类型相等的object类型或父类型。 

**
总结：**简单Inbound通道处理器SimpleChannelInboundHandler<I>，内部有连个变量一个为参数类型匹配器，用来判断通道是否可以处理消息，另一个变量autoRelease，用于控制是否在通道处理消息完毕时，释放消息。读取方法channelRead，首先判断跟定的消息类型是否可以被处理，如果是，则委托给channelRead0，channelRead0待子类实现；如果返回false，则将消息转递给Channel管道线的下一个通道处理器；最后，如果autoRelease为自动释放消息，且消息已处理则释放消息。
{% endraw %}
