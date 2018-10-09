---
layout: post
title:  "【设计模式】不同设计模式体现IOC控制反转"
title2:  "【设计模式】不同设计模式体现IOC控制反转"
date:   2017-01-01 23:53:44  +0800
source:  "https://www.jfox.info/%e8%ae%be%e8%ae%a1%e6%a8%a1%e5%bc%8f%e4%b8%8d%e5%90%8c%e8%ae%be%e8%ae%a1%e6%a8%a1%e5%bc%8f%e4%bd%93%e7%8e%b0ioc%e6%8e%a7%e5%88%b6%e5%8f%8d%e8%bd%ac.html"
fileName:  "20170101124"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e8%ae%be%e8%ae%a1%e6%a8%a1%e5%bc%8f%e4%b8%8d%e5%90%8c%e8%ae%be%e8%ae%a1%e6%a8%a1%e5%bc%8f%e4%bd%93%e7%8e%b0ioc%e6%8e%a7%e5%88%b6%e5%8f%8d%e8%bd%ac.html"
---
{% raw %}
使用过Spring的开发者应该都对IOC控制反转功能有所了解，最开始学习时应该都知道使用依赖注入来实现IOC的功能，本文来介绍使用IOC控制反转思想的几种设计模式。

**依赖注入来实现IOC**

注入依赖是IOC最基本的一种实现方式，也是最常用的一种面向对象设计方式之一。注入依赖如何达到控制反转效果，先以一个例子开始：

    publicinterface UserQueue {
    
        void add(User user);
    
        void remove(User user);
    
        User get();
    
    }
    
    publicabstractclass AbstractUserQueue implements UserQueue {
    
        protected LinkedList<User> queue = new LinkedList<>();
    
        @Override
        publicvoid add(User user) {
            queue.addFirst(user);
        }
    
        @Override
        publicvoid remove(User user) {
            queue.remove(user);
        }
    
        @Override
        publicabstract User get();
    
    }
    
    publicclass UserFifoQueue extends AbstractUserQueue {
    
        public User get() {
            return queue.getLast();
        }
    
    }
    
    publicclass UserLifoQueue extends AbstractUserQueue {
    
        public User get() {
            return queue.getFirst();
        }
    
    }

`UserQueue` 接口定义了公共的方法，用于在一个队列中去存放User对象。`AbstractUserQueue则是为后续的继承类，提供了一些公用的方法实现。最后的UserFifoQueue` 和 `UserLifoQueue，则是分别实现了FIFO 和 LIFO 队列。`

这是实现子类多态性的一种有效方式。

通过创建一个依赖于UserQueue抽象类型（也称为DI术语中的服务）的客户端类，可以在运行时注入不同的实现，无需会重构使用客户端类的代码：

    publicclass UserProcessor {
    
        private UserQueue userQueue;
    
        public UserProcessor(UserQueue userQueue) {
            this.userQueue = userQueue;
        }
    
        publicvoid process() {
            // process queued users here    }
    
    }

`UserProcessor展示了依赖注入确实是IOC的一种方式。`

我们可以通过一些硬编码方式 如 new 操作，直接在构造函数中实例化在UserProcessor中获取对队列的依赖关系。但这是典型的代码硬编程，它引入了客户端类与其依赖关系之间的强耦合，并大大降低了可测性。

该类在构造函数中声明对抽象类 `UserQueue` 的依赖。也就是说，依赖关系不再通过在构造函数中使用 new 操作， 相反，通过外部注入的方式，要么使用依赖注入框架，要么使用factory或builders模式。

使用依赖注入，客户端类的依赖关系的控制，不再位于这些类中；而是在注入器中进行，看如下代码：

    publicstaticvoid main(String[] args) {
         UserFifoQueue fifoQueue = new UserFifoQueue();
         fifoQueue.add(new User("user1"));
         fifoQueue.add(new User("user2"));
         fifoQueue.add(new User("user3"));
         UserProcessor userProcessor = new UserProcessor(fifoQueue);
         userProcessor.process();
    }

上述方式达到了预期效果，而且对`UserLifoQueue的注入也简单明了。`

### 观察者模式实现IOC

直接通过观察者模式实现IOC，也是一种常见的直观方式。广义上讲，通过观察者实现IOC，观察者模式通常用于在模型视图的上下文中，跟踪模型对象的状态的变迁。

 在一个典型的实现中，一到多个观察者绑定到可观察对象（也称为模式术语中的主题），例如通过调用addObserver方法进行绑定。一旦定义了被观察者和观察者之间的绑定，则被观察者状态的变迁都会触发调用观察者的操作。看下面例子：

    publicinterface SubjectObserver {
    
        void update();
    
    }

值发生改变时，会触发调用上述这个很简单的观察者。真实情况下，通常会提供功能更丰富的API，如需要保存变化的实例，或者新旧值，但是这些都不需要观察action（行为）模式，所以这里举例尽量简单。

下面，给出一个被观察者类:

    publicclass User {
    
        private String name;
        private List<SubjectObserver> observers = new ArrayList<>();
    
        public User(String name) {
            this.name = name;
        }
    
        publicvoid setName(String name) {
            this.name = name;
            notifyObservers();
        }
    
        public String getName() {
            return name;
        }
    
        publicvoid addObserver(SubjectObserver observer) {
            observers.add(observer);
        }
    
        publicvoid deleteObserver(SubjectObserver observer) {
            observers.remove(observer);
        }
    
        privatevoid notifyObservers(){
            observers.stream().forEach(observer -> observer.update());
        }
    
    }

User类中，当通过setter方法变更其状态事，都会触发调用绑定到它的观察者。

 使用主题观察者和主题，以下是实例给出了观察方式：

    publicstaticvoid main(String[] args) {
        User user = new User("John");
        user.addObserver(() -> System.out.println(
                "Observable subject " + user + " has changed its state."));
        user.setName("Jack");
    }

每当User对象的状态通过setter方法进行修改时，观察者将被通知并向控制台打印出一条消息。到目前为止，给出了观察者模式的一个简单用例。不过，通过这个看似简单的用例，我们了解到在这种情况下控制是如何实现反转的。

观察者模式下，主题就是起到”框架层“的作用，它完全主导何时何地去触发谁的调用。观察者的主动权被外放，因为观察者无法主导自己何时被调用（只要它们已经被注册到某个主题中的话）。这意味着，实际上我们可以发现控制被反转的”事发地“—— 当观察者绑定到主题时：

    user.addObserver(() -> System.out.println(
                "Observable subject " + user + " has changed its state."));

上述用例，简要说明了为什么观察者模式是实现IoC的一种非常简单的方式。正是以这种分散式设计软件组件的形式，使得控制得以发生反转。

### 模板方法模式实现IOC

模板方法模式实现的思想是在一个基类中通过几个抽象方法来定义一个通用的算法，然后让子类提供具体的实现，这样保证算法结构不变。

我们可以应用这个思想，定义一个通用的算法来处理领域实体，看例子：

    publicabstractclass EntityProcessor {
    
        publicfinalvoid processEntity() {
            getEntityData();
            createEntity();
            validateEntity();
            persistEntity();
        }
    
        protectedabstractvoid getEntityData();
        protectedabstractvoid createEntity();
        protectedabstractvoid validateEntity();
        protectedabstractvoid persistEntity();
    
    }

`processEntity()` 方法是个模板方法，它定义了处理实体的算法，而抽象方法代表了算法的步骤，它们必须在子类中实现。通过多次继承 `EntityProcessor 并实现不同的抽象方法，可以实现若干算法版本。`

虽然这说清楚了模板方法模式背后的动机，但人们可能想知道为什么这是 IOC 的模式。

典型的继承中，子类调用基类中定义的方法。而这种模式下，相对真实的情况是：子类实现的方法(算法步骤)被基类的模板方法调用。因此，控制实际是在基类中进行的，而不是在子类中。

总结：

依赖注入：从客户端获得依赖关系的控制不再存在于这些类中。它存由底层的注入器 / DI 框架来处理。

观察者模式：当主体发生变化时，控制从观察者传递到主体。

模板方法模式：控制发生在定义模板方法的基类中，而不是实现算法步骤的子类中。
{% endraw %}
