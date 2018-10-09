---
layout: post
title:  "Spring源码：IOC原理解析（二）"
title2:  "Spring源码：IOC原理解析（二）"
date:   2017-01-01 23:54:13  +0800
source:  "https://www.jfox.info/spring%e6%ba%90%e7%a0%81ioc%e5%8e%9f%e7%90%86%e8%a7%a3%e6%9e%90%e4%ba%8c.html"
fileName:  "20170101153"
lang:  "zh_CN"
published: true
permalink: "2017/spring%e6%ba%90%e7%a0%81ioc%e5%8e%9f%e7%90%86%e8%a7%a3%e6%9e%90%e4%ba%8c.html"
---
{% raw %}
版权声明：本文为博主原创文章，转载请注明出处，欢迎交流学习！

       接着上一章节的内容，我们来分析当new一个FileSystemXmlApplicationContext对象的时候，spring到底做了那些事。FileSystemXmlApplicationContext类的内容主要是定义了若干重载的构造方法，核心构造方法如下：

    /**
         * Create a new FileSystemXmlApplicationContext with the given parent,
         * loading the definitions from the given XML files.
         * 
         * loading all bean definitions and creating all singletons.
         * Alternatively, call refresh manually after further configuring the context.
         * 
         */public FileSystemXmlApplicationContext(
                String[] configLocations, boolean refresh, @Nullable ApplicationContext parent)
                throws BeansException {
    
            super(parent);
            setConfigLocations(configLocations);
            if (refresh) {
                refresh();
            }
        }

       从方法说明可以看出，在这个构造方法里加载所有bean定义并创建bean单例实例。其中的refresh()方法就是IOC容器初始化的入口，refresh()方法位AbstractApplicationContext类中，这是一个抽象类，它实现了ApplicationContext的基础功能，这里使用了模版方法模式，给实现它的子类提供了统一的模板：

    @Override
        publicvoid refresh() throws BeansException, IllegalStateException {
            synchronized (this.startupShutdownMonitor) {
                // Prepare this context for refreshing.            prepareRefresh();
    
                // Tell the subclass to refresh the internal bean factory.告诉子类刷新内部bean工厂
                ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();
    
                // Prepare the bean factory for use in this context.            prepareBeanFactory(beanFactory);
    
                try {
                    // Allows post-processing of the bean factory in context subclasses.                postProcessBeanFactory(beanFactory);
    
                    // Invoke factory processors registered as beans in the context.                invokeBeanFactoryPostProcessors(beanFactory);
    
                    // Register bean processors that intercept bean creation.                registerBeanPostProcessors(beanFactory);
    
                    // Initialize message source for this context.                initMessageSource();
    
                    // Initialize event multicaster for this context.                initApplicationEventMulticaster();
    
                    // Initialize other special beans in specific context subclasses.                onRefresh();
    
                    // Check for listener beans and register them.                registerListeners();
    
                    // Instantiate all remaining (non-lazy-init) singletons.                finishBeanFactoryInitialization(beanFactory);
    
                    // Last step: publish corresponding event.                finishRefresh();
                }
    
                catch (BeansException ex) {
                    if (logger.isWarnEnabled()) {
                        logger.warn("Exception encountered during context initialization - " +
                                "cancelling refresh attempt: " + ex);
                    }
    
                    // Destroy already created singletons to avoid dangling resources.                destroyBeans();
    
                    // Reset 'active' flag.                cancelRefresh(ex);
    
                    // Propagate exception to caller.throw ex;
                }
    
                finally {
                    // Reset common introspection caches in Spring's core, since we
                    // might not ever need metadata for singleton beans anymore...                resetCommonCaches();
                }
            }
        }

       refresh()方法里列出了IOC容器初始化的步骤，第一个方法是初始化准备，这里只是设置启动日期和活动标识以及执行属性源的初始化。我们重点看第二个方法obtainFreshBeanFactory()，它告诉子类刷新内部bean工厂，返回了一个ConfigurableListableBeanFactory，跟踪这个方法：

    /**
         * Tell the subclass to refresh the internal bean factory.
         * @return the fresh BeanFactory instance
         * @see #refreshBeanFactory()
         * @see #getBeanFactory()
         */protected ConfigurableListableBeanFactory obtainFreshBeanFactory() {
            refreshBeanFactory();
            ConfigurableListableBeanFactory beanFactory = getBeanFactory();
            if (logger.isDebugEnabled()) {
                logger.debug("Bean factory for " + getDisplayName() + ": " + beanFactory);
            }
            return beanFactory;
        }

    protectedabstractvoid refreshBeanFactory() throws BeansException, IllegalStateException;

    /**
         * Return the internal bean factory of this application context.
         * Can be used to access specific functionality of the underlying factory.
         * 
         */
        ConfigurableListableBeanFactory getBeanFactory() throws IllegalStateException;

       obtainFreshBeanFactory()方法的第一行调用了refreshBeanFactory()方法，这是一个抽象方法，由它的子类来实现，方法的第二行调用了getBeanFactory()，这是在其父接口中定义的一个空方法。抽象方法refreshBeanFactory()在其子类子类AbstractRefreshableApplicationContext中实现：

       这个方法被final关键字修饰，也就是说不可以被重写，IOC容器的初始化就是在这个方法中完成的。第一步先判断有没有现有的工厂，有的话就销毁掉，然后创建一个默认的工厂，也就是DefaultListableBeanFactory ，接下来两行代码是设置bean工厂的一些属性，注意看loadBeanDefinitions(beanFactory)这行，当创建了一个默认的bean工厂后，加载bean定义，这跟我们上一章节使用原始方式初始化bean工厂类似。从这里不难看出，FileSystemXmlApplicationContext的构造方法中其实已经包含了我们上一章节中原始的初始化过程。接下来我们跟踪一下loadBeanDefinitions(beanFactory)的实现，这个方法是由AbstractXmlApplicationContext抽象类实现的：

    /**
         * Loads the bean definitions via an XmlBeanDefinitionReader.装载bean定义通过XmlBeanDefinitionReader
         *
         */
        @Override
        protectedvoid loadBeanDefinitions(DefaultListableBeanFactory beanFactory) throws BeansException, IOException {
            // Create a new XmlBeanDefinitionReader for the given BeanFactory.
            XmlBeanDefinitionReader beanDefinitionReader = new XmlBeanDefinitionReader(beanFactory);
    
            // Configure the bean definition reader with this context's
            // resource loading environment.
            beanDefinitionReader.setEnvironment(this.getEnvironment());
            beanDefinitionReader.setResourceLoader(this);
            beanDefinitionReader.setEntityResolver(new ResourceEntityResolver(this));
    
            // Allow a subclass to provide custom initialization of the reader,
            // then proceed with actually loading the bean definitions.        initBeanDefinitionReader(beanDefinitionReader);
            loadBeanDefinitions(beanDefinitionReader);
        }

       方法的第一行首先定义了一个Reader，这个Reader就是用来读取xml配置文件的，最后一行就是真正载入bean定义的实现过程，代码如下：

    /**
         * Load the bean definitions with the given XmlBeanDefinitionReader.
         * 
         */protectedvoid loadBeanDefinitions(XmlBeanDefinitionReader reader) throws BeansException, IOException {
            Resource[] configResources = getConfigResources();
            if (configResources != null) {
                reader.loadBeanDefinitions(configResources);
            }
            String[] configLocations = getConfigLocations();
            if (configLocations != null) {
                reader.loadBeanDefinitions(configLocations);
            }
        }

       上面的方法调用了XmlBeanDefinitionReader类的loadBeanDefinitions(EncodedResource encodedResource)方法：

    /**
         * Load bean definitions from the specified XML file.
         * rows BeanDefinitionStoreException in case of loading or parsing errors
         */publicint loadBeanDefinitions(EncodedResource encodedResource) throws BeanDefinitionStoreException {
            Assert.notNull(encodedResource, "EncodedResource must not be null");
            if (logger.isInfoEnabled()) {
                logger.info("Loading XML bean definitions from " + encodedResource.getResource());
            }
    
            Set<EncodedResource> currentResources = this.resourcesCurrentlyBeingLoaded.get();
            if (currentResources == null) {
                currentResources = new HashSet<>(4);
                this.resourcesCurrentlyBeingLoaded.set(currentResources);
            }
            if (!currentResources.add(encodedResource)) {
                thrownew BeanDefinitionStoreException(
                        "Detected cyclic loading of " + encodedResource + " - check your import definitions!");
            }
            try {
                InputStream inputStream = encodedResource.getResource().getInputStream();
                try {
                    InputSource inputSource = new InputSource(inputStream);
                    if (encodedResource.getEncoding() != null) {
                        inputSource.setEncoding(encodedResource.getEncoding());
                    }
                    return doLoadBeanDefinitions(inputSource, encodedResource.getResource());
                }
                finally {
                    inputStream.close();
                }
            }
            catch (IOException ex) {
                thrownew BeanDefinitionStoreException(
                        "IOException parsing XML document from " + encodedResource.getResource(), ex);
            }
            finally {
                currentResources.remove(encodedResource);
                if (currentResources.isEmpty()) {
                    this.resourcesCurrentlyBeingLoaded.remove();
                }
            }
        }

       从方法说明可以看出，这个方法是从指定的xml文件中加载bean定义，try块中的代码才是载入bean定义的过程。spring将资源返回的输入流包装以后传给了doLoadBeanDefinitions()方法，我们进入这个方法，代码如下：

    /**
         * Actually load bean definitions from the specified XML file.
         * 
         */protectedint doLoadBeanDefinitions(InputSource inputSource, Resource resource)
                throws BeanDefinitionStoreException {
            try {
                Document doc = doLoadDocument(inputSource, resource);
                return registerBeanDefinitions(doc, resource);
            }
            catch (BeanDefinitionStoreException ex) {
                throw ex;
            }
            catch (SAXParseException ex) {
                thrownew XmlBeanDefinitionStoreException(resource.getDescription(),
                        "Line " + ex.getLineNumber() + " in XML document from " + resource + " is invalid", ex);
            }
            catch (SAXException ex) {
                thrownew XmlBeanDefinitionStoreException(resource.getDescription(),
                        "XML document from " + resource + " is invalid", ex);
            }
            catch (ParserConfigurationException ex) {
                thrownew BeanDefinitionStoreException(resource.getDescription(),
                        "Parser configuration exception parsing XML from " + resource, ex);
            }
            catch (IOException ex) {
                thrownew BeanDefinitionStoreException(resource.getDescription(),
                        "IOException parsing XML document from " + resource, ex);
            }
            catch (Throwable ex) {
                thrownew BeanDefinitionStoreException(resource.getDescription(),
                        "Unexpected exception parsing XML document from " + resource, ex);
            }
        }

    /**
         * Actually load the specified document using the configured DocumentLoader.
         * 
         */protected Document doLoadDocument(InputSource inputSource, Resource resource) throws Exception {
            returnthis.documentLoader.loadDocument(inputSource, getEntityResolver(), this.errorHandler,
                    getValidationModeForResource(resource), isNamespaceAware());
        }

       从try块中的代码可以看出，spring使用documentLoader将资源转换成了Document资源，spring使用的documentLoader为DefaultDocumentLoader，loadDocument方法定义在此类中：

    /**
         * Load the {@link Document} at the supplied {@link InputSource} using the standard JAXP-configured
         * XML parser.
         */
        @Override
        public Document loadDocument(InputSource inputSource, EntityResolver entityResolver,
                ErrorHandler errorHandler, int validationMode, boolean namespaceAware) throws Exception {
    
            DocumentBuilderFactory factory = createDocumentBuilderFactory(validationMode, namespaceAware);
            if (logger.isDebugEnabled()) {
                logger.debug("Using JAXP provider [" + factory.getClass().getName() + "]");
            }
            DocumentBuilder builder = createDocumentBuilder(factory, entityResolver, errorHandler);
            return builder.parse(inputSource);
        }

       从这里不难看出，这就是我们非常熟悉的DOM解析xml了，可以想象spring是根据XSD文件规定的格式解析了xml文件的各节点及属性。我们再来回头看看registerBeanDefinitions(doc, resource)方法，

    /**
         * Register the bean definitions contained in the given DOM document.
         * Called by {@code loadBeanDefinitions}.
         * 
         */publicint registerBeanDefinitions(Document doc, Resource resource) throws BeanDefinitionStoreException {
            BeanDefinitionDocumentReader documentReader = createBeanDefinitionDocumentReader();
            int countBefore = getRegistry().getBeanDefinitionCount();
            documentReader.registerBeanDefinitions(doc, createReaderContext(resource));
            return getRegistry().getBeanDefinitionCount() - countBefore;
        }

       方法说明很明确的告诉我们，这个方法是注册给定的DOM文档中包含的bean定义。到这里思路就很明确了，spring将包装的输入流解析成DOM文档，然后将DOM中包含的bean定义信息注册到IOC容器持有的Map<String，BeanDefinition>对象中。只要我们的IOC容器持有了bean定义，就能正确的生产bean实例。

       通过阅读源码，我们分析了Spring IOC的实现原理。有些实现细节并没有去深究，更重要的是去理解它的核心思想和实现思路。
{% endraw %}
