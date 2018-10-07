---
layout: post
title:  "回眸Spring – 事物运行原理机制"
title2:  "回眸Spring – 事物运行原理机制"
date:   2017-01-01 23:59:59  +0800
source:  "http://www.jfox.info/%e5%9b%9e%e7%9c%b8spring%e4%ba%8b%e7%89%a9%e8%bf%90%e8%a1%8c%e5%8e%9f%e7%90%86%e6%9c%ba%e5%88%b6.html"
fileName:  "20170101499"
lang:  "zh_CN"
published: true
permalink: "%e5%9b%9e%e7%9c%b8spring%e4%ba%8b%e7%89%a9%e8%bf%90%e8%a1%8c%e5%8e%9f%e7%90%86%e6%9c%ba%e5%88%b6.html"
---
{% raw %}
H2M_LI_HEADER Spring的事物是通过哪些原理实现的?
H2M_LI_HEADER Spring的事物机制是如何提交和回滚的?

**==希望你有阅读过Spring源码的经历,不然有的东西可能理解不清楚..==**

### Spring的事物是通过哪些原理实现的?

首先给大家布置一个代码场景(以项目代码为例):

spring-dataSource.xml文件

         <bean id="db1" class="com.alibaba.druid.pool.DruidDataSource"     destroy-method="close">
             ....
        </bean>
        <!-- 数据源配置 -->
        <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="db1"/>
        <qualifier value=""/>
    </bean>
    
    <!-- 事物管理器 -->
        <tx:annotation-driven transaction-manager="transactionManager"
        proxy-target-class="true"></tx:annotation-driven>
    

Spring-service.xml

    <!-- 注解扫描包 -->
     <context:component-scan base-package="com.elab.execute.services,com.elab.execute.dao,com.elab.execute.utils">
            <context:include-filter type="annotation" expression="org.springframework.stereotype.Service"/>
            <context:include-filter type="annotation" expression="org.springframework.stereotype.Repository"/>
            <context:include-filter type="annotation" expression="org.springframework.stereotype.Component"/>
            <context:exclude-filter type="annotation" expression="org.springframework.stereotype.Controller"/>
        </context:component-scan>
    

Serivce.java

        //方法上只要加上@Transactional方法就行了,一个DML操作
        @Transactional
        public void testTransactional() throws Exception {
            System.out.println("=====================开始处理事物");
            TGirl girl = new TGirl();
            girl.setAge(11);
            girl.setGirl_name("hah");
            girl.setStatus(1);
            int insert = girlMapper.insert(girl);
            System.out.println("=====================结束处理事物");
            System.out.println("处理完成...");
            // 模拟程序报错
    //        int i = 1 / 0;
        }
    

**==注意我们这只是模拟一个简单的事物管理配置场景,大概就是这么一些要配置的东西==**

测试类: 我没有用Junit,不过效果是差不多的

    String xml[] = new String[]{"applicationContext-service.xml", "applicationContext-datasource.xml", };
            ApplicationContext app = new ClassPathXmlApplicationContext(xml);
            IDemoService demoService = (IDemoService) app.getBean("demoService");
            // DML操作
            demoService.testTransactional();
    

首先我们的目的是想知道Spring事物的运行流程,这时候可能就需要Debug调试,我们也就只关注事物这块初始化和执行的情况,我们可以采用**倒推**的方式
**先看spring事物的执行过程,再看初始化过程**

1. debug断点打在 demoService.testTransactional(); 这块,然后F5进去
![](/wp-content/uploads/2017/08/1502376394.png)
image 
    
   
进入到的是一个CglibAopProxy内部类**DynamicAdvisedInterceptor**的**intercept**方法,从这里看的话,其实这个类就是一个责任链类型的处理类

注意这一块是一个**责任链模式**,表示需要经过一系列链条之后才会到达最终的方法,**当然这三个类切入点类型的类,是通过动态代理加入到责任链中的,下面初始化的时候会讲到**

          // 这一段代码表示获取到你将要执行最终方法前要经过的一系列拦截类的处理,也就是责任链类的中的核心集合
        List<Object> chain = this.advised.getInterceptorsAndDynamicInterceptionAdvice(method, targetClass);
    

![](/wp-content/uploads/2017/08/1502376395.png) 
 
   image 
  
 

图中chain集合有三个类,表示执行到目的方法之前需要经过这几个类

我们来看到执行到目标方法的执行轨迹:

![](/wp-content/uploads/2017/08/15023763951.png)
 
 
   image 
  
 

 确实是经过了三个拦截链 

 我们直接看事物相关的拦截链类 

 下面代码是不是似曾相识,这都是开启事物的操作和异常情况下,回滚和提交操作 

![](/wp-content/uploads/2017/08/1502376396.png) 
 
   image 
  
 

经过这些代理类之后到达最终的方法,这是一个大概的运行过程.异常会被事物捕获到,没有则提交… 都是通过这个TransactionAspectSupport的invokeWithinTransaction方法去做的

### 那Spring又是如何初始化这一系列的代理类操作的呢?

回到运行的第一步我们在那个Aop的拦截器类中(CglibApoProxy),想一想既然spring运行这个方法的时候会执行这个拦截器方法,那么初始化的时候应该也和这个类相关,然后从上面实例化的地方和可以的地方打打断点…

果然,初始化的方法断点被触发了…

![](/wp-content/uploads/2017/08/1502376397.png)
 
 
   image 
  
 

 这时候我们可以看断点的运行轨迹 

![](/wp-content/uploads/2017/08/15023763971.png) 
 
   image 
  
 

我们发现,触发到这个断点的时候,会经过一系列的方法执行,这些执行的方法链都是创建bean的时候必须经过的过程,也就是说每个bean创建的时候,都会经过这一系列的链路的检查(applyBeanPostProcessorsAfterInitialization方法里面的getBeanPostProcessors()方法),才会生成最终的bean,这时候我们需要定位到执行这个CglibAopProxy初始化的方法这块,**在什么情况下**,会执行这个创建代理的类

![](/wp-content/uploads/2017/08/15023763972.png) 
 
   image 
  
 

我们现在已经知道他创建了代理类的过程,现在需要知道在什么情况下会为某些bean创建代理。了解了getAdvicesAndAdvisorsForBean这个方法运行做了什么事情,就大概知道创建代理类bean的条件

首先我们一步步看这个方法的代码:

        /**
            这是一个获取切入点和包含切入点的bean方法
        /*
        protected Object[] getAdvicesAndAdvisorsForBean(Class<?> beanClass, String beanName, TargetSource targetSource) {
            // 查询当前的bean是否包含切入点
            List<Advisor> advisors = findEligibleAdvisors(beanClass, beanName);
            if (advisors.isEmpty()) {
                return DO_NOT_PROXY;
            }
            return advisors.toArray();
        }
    

findEligibleAdvisors方法

    
        /**
         * 大概意思是为这个bean找到合适的自动代理类
         * Find all eligible Advisors for auto-proxying this class.
         * @param beanClass the clazz to find advisors for
         * @param beanName the name of the currently proxied bean
         * @return the empty List, not {@code null},
         * if there are no pointcuts or interceptors
         * @see #findCandidateAdvisors
         * @see #sortAdvisors
         * @see #extendAdvisors
         */
        protected List<Advisor> findEligibleAdvisors(Class<?> beanClass, String beanName) {
            // 找到当前已经注册好的代理类bean
            List<Advisor> candidateAdvisors = findCandidateAdvisors();
            //将注册好的bean和当前bean的类型进行搜索查询,是否有合适的切入点类
            List<Advisor> eligibleAdvisors = findAdvisorsThatCanApply(candidateAdvisors, beanClass, beanName);
            extendAdvisors(eligibleAdvisors);
            if (!eligibleAdvisors.isEmpty()) {
                eligibleAdvisors = sortAdvisors(eligibleAdvisors);
            }
            return eligibleAdvisors;
        }
    
    

findAdvisorsThatCanApply :

    
           /**
           大概意思就是搜索给定的切入点集合,以用于找到可以应用到当前bean的合适的切入点集合
         * Search the given candidate Advisors to find all Advisors that
         * can apply to the specified bean.
         * @param candidateAdvisors the candidate Advisors
         * @param beanClass the target's bean class
         * @param beanName the target's bean name
         * @return the List of applicable Advisors
         * @see ProxyCreationContext#getCurrentProxiedBeanName()
         */
        protected List<Advisor> findAdvisorsThatCanApply(
                List<Advisor> candidateAdvisors, Class<?> beanClass, String beanName) {
                    // 设置代理的上下文,只针当前线程
            ProxyCreationContext.setCurrentProxiedBeanName(beanName);
            try {
                // 这是一个AOP的工具类,用于
                return AopUtils.findAdvisorsThatCanApply(candidateAdvisors, beanClass);
            }
            finally {
                ProxyCreationContext.setCurrentProxiedBeanName(null);
            }
        }
    
    

AopUtils.findAdvisorsThatCanApply

    
        /**
         * 确定能应用到当前clazz的List<Advisor>
         * Determine the sublist of the {@code candidateAdvisors} list
         * that is applicable to the given class.
         * @param candidateAdvisors the Advisors to evaluate
         * @param clazz the target class
         * @return sublist of Advisors that can apply to an object of the given class
         * (may be the incoming List as-is)
         */
        public static List<Advisor> findAdvisorsThatCanApply(List<Advisor> candidateAdvisors, Class<?> clazz) {
            if (candidateAdvisors.isEmpty()) {
                return candidateAdvisors;
            }
            List<Advisor> eligibleAdvisors = new LinkedList<Advisor>();
            for (Advisor candidate : candidateAdvisors) {
                if (candidate instanceof IntroductionAdvisor && canApply(candidate, clazz)) {
                    eligibleAdvisors.add(candidate);
                }
            }
            boolean hasIntroductions = !eligibleAdvisors.isEmpty();
            for (Advisor candidate : candidateAdvisors) {
                if (candidate instanceof IntroductionAdvisor) {
                    // already processed
                    continue;
                }
                             // 这个方法很关键,用于判断是否能将当前Advisor应用到这个bean上
                if (canApply(candidate, clazz, hasIntroductions)) {
                    // 如果验证通过,则会将当前切入点加入进来
                    eligibleAdvisors.add(candidate);
                }
            }
            return eligibleAdvisors;
        }
    
    

我们来看看canApply做了些什么?

    // 大概就是比较了Advisor的类型
    public static boolean canApply(Advisor advisor, Class<?> targetClass, boolean hasIntroductions) {
            if (advisor instanceof IntroductionAdvisor) {
                return ((IntroductionAdvisor) advisor).getClassFilter().matches(targetClass);
            }
            else if (advisor instanceof PointcutAdvisor) {
                PointcutAdvisor pca = (PointcutAdvisor) advisor;
                // 最终会执行到这个方法
                return canApply(pca.getPointcut(), targetClass, hasIntroductions);
            }
            else {
                // It doesn't have a pointcut so we assume it applies.
                return true;
            }
        }
    
        public static boolean canApply(Pointcut pc, Class<?> targetClass, boolean hasIntroductions) {
            Assert.notNull(pc, "Pointcut must not be null");
            if (!pc.getClassFilter().matches(targetClass)) {
                return false;
            }
                    // 获取当前切入点的类型
            MethodMatcher methodMatcher = pc.getMethodMatcher();
            IntroductionAwareMethodMatcher introductionAwareMethodMatcher = null;
                    //比较类型  
            if (methodMatcher instanceof IntroductionAwareMethodMatcher) {
                introductionAwareMethodMatcher = (IntroductionAwareMethodMatcher) methodMatcher;
            }
            
            
                    // !!!!! 这一部分的代码很关键!!!!
                    // 获取所有相关的类
            Set<Class<?>> classes = new LinkedHashSet<Class<?>>(ClassUtils.getAllInterfacesForClassAsSet(targetClass));
            classes.add(targetClass);
                    // 遍历这些类
            for (Class<?> clazz : classes) {
                            // 获取类的所有方法
                Method[] methods = clazz.getMethods();
                          // 遍历这些方法
                for (Method method : methods) {
                        //methodMatcher.matches(method, targetClass) 这个方法很重要
                    if ((introductionAwareMethodMatcher != null &&
                            introductionAwareMethodMatcher.matches(method, targetClass, hasIntroductions)) ||
                            methodMatcher.matches(method, targetClass)) {
                        return true;
                    }
                }
            }
    
            return false;
        }
    

matches 方法

         public boolean matches(Method method, Class<?> targetClass) {
            TransactionAttributeSource tas = getTransactionAttributeSource();
            // tas.getTransactionAttribute(method, targetClass)  这是个获取事物注解的方法
            return (tas == null || tas.getTransactionAttribute(method, targetClass) != null);
        }
        
        
        
        
        // 获取事务属性的方法
        public TransactionAttribute getTransactionAttribute(Method method, Class<?> targetClass) {
            // First, see if we have a cached value.
            Object cacheKey = getCacheKey(method, targetClass);
            Object cached = this.attributeCache.get(cacheKey);
            if (cached != null) {
                // Value will either be canonical value indicating there is no transaction attribute,
                // or an actual transaction attribute.
                if (cached == NULL_TRANSACTION_ATTRIBUTE) {
                    return null;
                }
                else {
                    return (TransactionAttribute) cached;
                }
            }
            else {
                // We need to work it out.
                // 获取事物属性的方法
                TransactionAttribute txAtt = computeTransactionAttribute(method, targetClass);
                // Put it in the cache.
                if (txAtt == null) {
                    this.attributeCache.put(cacheKey, NULL_TRANSACTION_ATTRIBUTE);
                }
                else {
                    if (logger.isDebugEnabled()) {
                        Class<?> classToLog = (targetClass != null ? targetClass : method.getDeclaringClass());
                        logger.debug("Adding transactional method '" + classToLog.getSimpleName() + "." +
                                method.getName() + "' with attribute: " + txAtt);
                    }
                    this.attributeCache.put(cacheKey, txAtt);
                }
                return txAtt;
            }
        }
        
        private TransactionAttribute computeTransactionAttribute(Method method, Class<?> targetClass) {
            // Don't allow no-public methods as required.
            if (allowPublicMethodsOnly() && !Modifier.isPublic(method.getModifiers())) {
                return null;
            }
    
            // Ignore CGLIB subclasses - introspect the actual user class.
            Class<?> userClass = ClassUtils.getUserClass(targetClass);
            // The method may be on an interface, but we need attributes from the target class.
            // If the target class is null, the method will be unchanged.
            Method specificMethod = ClassUtils.getMostSpecificMethod(method, userClass);
            // If we are dealing with method with generic parameters, find the original method.
            specificMethod = BridgeMethodResolver.findBridgedMethod(specificMethod);
    
            // First try is the method in the target class.
            // 查找该方法的事物属性
            TransactionAttribute txAtt = findTransactionAttribute(specificMethod);
            if (txAtt != null) {
                return txAtt;
            }
    
            // Second try is the transaction attribute on the target class.
            txAtt = findTransactionAttribute(specificMethod.getDeclaringClass());
            if (txAtt != null) {
                return txAtt;
            }
    
            if (specificMethod != method) {
                // Fallback is to look at the original method.
                txAtt = findTransactionAttribute(method);
                if (txAtt != null) {
                    return txAtt;
                }
                // Last fallback is the class of the original method.
                return findTransactionAttribute(method.getDeclaringClass());
            }
            return null;
        }
    

详细看下findTransactionAttribute方法,由于比较深我就直接贴最终执行的方法了

    public TransactionAttribute parseTransactionAnnotation(AnnotatedElement ae) {
            // 查看是否方法上面有@Transactional注解
            AnnotationAttributes ann = AnnotatedElementUtils.getAnnotationAttributes(ae, Transactional.class.getName());
            if (ann != null) {
                return parseTransactionAnnotation(ann);
            }
            else {
                return null;
            }
        }
        // 处理这个注解所包含的属性如传播途径和隔离级别
        protected TransactionAttribute parseTransactionAnnotation(AnnotationAttributes attributes) {
            RuleBasedTransactionAttribute rbta = new RuleBasedTransactionAttribute();
            Propagation propagation = attributes.getEnum("propagation");
            rbta.setPropagationBehavior(propagation.value());
            Isolation isolation = attributes.getEnum("isolation");
            rbta.setIsolationLevel(isolation.value());
            rbta.setTimeout(attributes.getNumber("timeout").intValue());
            rbta.setReadOnly(attributes.getBoolean("readOnly"));
            rbta.setQualifier(attributes.getString("value"));
            ArrayList<RollbackRuleAttribute> rollBackRules = new ArrayList<RollbackRuleAttribute>();
            Class<?>[] rbf = attributes.getClassArray("rollbackFor");
            for (Class<?> rbRule : rbf) {
                RollbackRuleAttribute rule = new RollbackRuleAttribute(rbRule);
                rollBackRules.add(rule);
            }
            String[] rbfc = attributes.getStringArray("rollbackForClassName");
            for (String rbRule : rbfc) {
                RollbackRuleAttribute rule = new RollbackRuleAttribute(rbRule);
                rollBackRules.add(rule);
            }
            Class<?>[] nrbf = attributes.getClassArray("noRollbackFor");
            for (Class<?> rbRule : nrbf) {
                NoRollbackRuleAttribute rule = new NoRollbackRuleAttribute(rbRule);
                rollBackRules.add(rule);
            }
            String[] nrbfc = attributes.getStringArray("noRollbackForClassName");
            for (String rbRule : nrbfc) {
                NoRollbackRuleAttribute rule = new NoRollbackRuleAttribute(rbRule);
                rollBackRules.add(rule);
            }
            rbta.getRollbackRules().addAll(rollBackRules);
            return rbta;
        }
    

这时候我们就可以大概的清楚知道哪些bean需要被事物代理的原因了
这时候我们在回过头来看spring是如何构建代理类的,这里我就不在详细各种贴流程代码了,只贴关键的

    DefaultAopProxyFactory 默认的AOP代理工厂
    

    // 创建一个AopProxy的代理类,它这里提供了两种代理方式,一种是JDK代理,一种是CGlib代理
    public AopProxy createAopProxy(AdvisedSupport config) throws AopConfigException {
                if (config.isOptimize() || config.isProxyTargetClass() ||  
                hasNoUserSuppliedProxyInterfaces(config)) {
                Class<?> targetClass = config.getTargetClass();
                if (targetClass == null) {
                    throw new AopConfigException("TargetSource cannot determine target class: " +
                            "Either an interface or a target is required for proxy creation.");
                }
                // 如果需要代理的类是接口的时候采用JDK
                if (targetClass.isInterface()) {
                    return new JdkDynamicAopProxy(config);
                }
                // 普通类用CGlib代理
                return new ObjenesisCglibAopProxy(config);
            }
            else {
                return new JdkDynamicAopProxy(config);
            }
        }
    

ObjenesisCglibAopProxy 的 父类是 CglibAopProxy 所以初始化ObjenesisCglibAopProxy 的构造方法时会调用super(config);

        /**
        * 实例化Cglib对象时,会初始化他的父类方法,并且把拦截器传递给父类,告诉他的需要加上代理的拦截器,也就是我们的TransactionInterceptor,如果有多个的话可能就会代理多个,这里我们只看事物的
        *
        */
        public ObjenesisCglibAopProxy(AdvisedSupport config) {
            super(config);
            this.objenesis = new ObjenesisStd(true);
        }
    

初始化完成之后会调用它的ObjenesisCglibAopProxy的getProxy()方法,这个方法是它的父类实现的,这里面才是真正实现了真正代理的对象,原理是构成一个责任链,将代理一个个链接起来

    public Object getProxy(ClassLoader classLoader) {
            if (logger.isDebugEnabled()) {
                logger.debug("Creating CGLIB proxy: target source is " + this.advised.getTargetSource());
            } 
            try {
                Class<?> rootClass = this.advised.getTargetClass();
                Assert.state(rootClass != null, "Target class must be available for creating a CGLIB proxy"); 
                Class<?> proxySuperClass = rootClass;
                if (ClassUtils.isCglibProxyClass(rootClass)) {
                    proxySuperClass = rootClass.getSuperclass();
                    Class<?>[] additionalInterfaces = rootClass.getInterfaces();
                    for (Class<?> additionalInterface : additionalInterfaces) {
                        this.advised.addInterface(additionalInterface);
                    }
                } 
                // Validate the class, writing log messages as necessary.
                validateClassIfNecessary(proxySuperClass, classLoader);
{% endraw %}
