---
layout: post
title:  "guava eventbus代码分析(一)"
title2:  "guava eventbus代码分析(一)"
date:   2017-01-01 23:50:13  +0800
source:  "https://www.jfox.info/guava-eventbus%e4%bb%a3%e7%a0%81%e5%88%86%e6%9e%90-%e4%b8%80.html"
fileName:  "20170100913"
lang:  "zh_CN"
published: true
permalink: "2017/guava-eventbus%e4%bb%a3%e7%a0%81%e5%88%86%e6%9e%90-%e4%b8%80.html"
---
{% raw %}
分析guava eventbus之前，先看一下传统观察者模式的写法：

Subject接口是抽象主题，相当于被观察者，它持有一个监听者observer的列表，attach方法往这个列表里面注册监听者，detach方法注销监听者，notify方法用于事件发生时通知到列表中的监听者

通常在notify的实现方法中会调用监听者的update方法。

Observer是抽象观察者，带一个update方法，update方法被具体主题的notify方法调用。

这是一种传统的针对接口的编程方法。与之不同的是eventbus里面采用“”隐式接口”，一种基于java Annotation的编程方式。

区别在于：这种“隐式接口”的对应关系是在程序运行时产生的，而基于真正意义接口与实现的是在编译时就建立的对应关系，相比之下，“隐式接口”则更加灵活

我们分析下隐式接口以及实现是怎么建立绑定关系的，看代码：

     1##SubscriberRegistry类的register方法
     2void register(Object listener) {
     3**Multimap<Class<?>, Subscriber> listenerMethods = findAllSubscribers(listener); ** 4 5for (Map.Entry<Class<?>, Collection<Subscriber>> entry : listenerMethods.asMap().entrySet()) {
     6       Class<?> eventType = entry.getKey();
     7       Collection<Subscriber> eventMethodsInListener = entry.getValue();
     8 9       CopyOnWriteArraySet<Subscriber> eventSubscribers = subscribers.get(eventType);
    1011if (eventSubscribers == null) {
    12         CopyOnWriteArraySet<Subscriber> newSet = new CopyOnWriteArraySet<Subscriber>();
    13         eventSubscribers = MoreObjects.firstNonNull(
    14            subscribers.putIfAbsent(eventType, newSet), newSet);
    15      }
    1617      eventSubscribers.addAll(eventMethodsInListener);
    18    }
    19   }

这个方法中有用的就是第3行，其余的代码大致分析一下，就是便利这个Mutimap,将同一类型的事件的监听者Subsriber添加到对应的set当中，如果当前类型事件的Subsriber的set是空，那么先添加一个空的set.

跟进以上第3行的方法：

     1/** 2   * Returns all subscribers for the given listener grouped by the type of event they subscribe to.
     3*/ 4private Multimap<Class<?>, Subscriber> findAllSubscribers(Object listener) {
     5     Multimap<Class<?>, Subscriber> methodsInListener = HashMultimap.create();
     6     Class<?> clazz = listener.getClass();
     7for (Method method : getAnnotatedMethods(clazz)) {
     8       Class<?>[] parameterTypes = method.getParameterTypes();
     9       Class<?> eventType = parameterTypes[0];
    10      methodsInListener.put(eventType, Subscriber.create(bus, listener, method));
    11    }
    12return methodsInListener;
    13   }

这个方法中核心的方法是第7行，获取特定class的带Subscribe注解的所有方法，其余代码的意思是拿到这些方法后，放到多值map当中，然后返回。

跟进以上第7行的方法：

    1privatestatic ImmutableList<Method> getAnnotatedMethods(Class<?> clazz) {
    2return subscriberMethodsCache.getUnchecked(clazz);
    3   }

跟倒这里后，eclipse没得跟了，怀疑是内部匿名类调用了某个方法相关联（eclipse对内部匿名类的调用链路也显示不全）

我们看看这个

    subscriberMethodsCache
    

    1privatestaticfinal LoadingCache<Class<?>, ImmutableList<Method>> subscriberMethodsCache =
    2      CacheBuilder.newBuilder()
    3          .weakKeys()
    4           .build(new CacheLoader<Class<?>, ImmutableList<Method>>() {
    5            @Override
    6public ImmutableList<Method> load(Class<?> concreteClass) throws Exception {
    7return getAnnotatedMethodsNotCached(concreteClass);
    8            }
    9           });

load方法被调用的时候，调用了 当前类的 getAnnotatedMethodsNOtCached方法，跟进去这个方法：

     1privatestatic ImmutableList<Method> getAnnotatedMethodsNotCached(Class<?> clazz) {
     2     Set<? extends Class<?>> supertypes = TypeToken.of(clazz).getTypes().rawTypes();
     3     Map<MethodIdentifier, Method> identifiers = Maps.newHashMap();
     4for (Class<?> supertype : supertypes) {
     5for (Method method : supertype.getDeclaredMethods()) {
     6if (method.isAnnotationPresent(Subscribe.class) && !method.isSynthetic()) {
     7// TODO(cgdecker): Should check for a generic parameter type and error out 8           Class<?>[] parameterTypes = method.getParameterTypes();
     9           checkArgument(parameterTypes.length == 1,
    10               "Method %s has @Subscribe annotation but has %s parameters."
    11                   + "Subscriber methods must have exactly 1 parameter.",
    12              method, parameterTypes.length);
    1314           MethodIdentifier ident = new MethodIdentifier(method);
    15if (!identifiers.containsKey(ident)) {
    16            identifiers.put(ident, method);
    17          }
    18        }
    19      }
    20    }
    21return ImmutableList.copyOf(identifiers.values());
    22   }

第2行的意思是拿到当前类自己+当前类的父类货接口 的所有类，放在一个Set中

第4行遍历这个Set

第5行遍历每个类的所有方法

第6行调用Method的isAnnotationPresent方法判断目标方法带有 @Subscribe注解,并且 该方法不能是 “复合方法”

第16行把复合条件的方法放到map中去，并在21行返回！
{% endraw %}
