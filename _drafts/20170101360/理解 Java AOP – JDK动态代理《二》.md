---
layout: post
title:  "理解 Java AOP – JDK动态代理《二》"
title2:  "理解 Java AOP – JDK动态代理《二》"
date:   2017-01-01 23:57:40  +0800
source:  "https://www.jfox.info/%e7%90%86%e8%a7%a3javaaopjdk%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e4%ba%8c.html"
fileName:  "20170101360"
lang:  "zh_CN"
published: true
permalink: "2017/%e7%90%86%e8%a7%a3javaaopjdk%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e4%ba%8c.html"
---
{% raw %}
### 业务接口: `IBiz`

    public interface IBiz {
        void doSomething();
    }

### 业务实现类: `BizImpl`

    public class BizImpl implements IBiz {
    
        public void doSomething() {
            System.out.println("做一些业务逻辑");
        }
    }

### 横切逻辑: `PerformanceMonitor `

    public class PerformanceMonitor {
    
        public void start() {
            System.out.println("开始时间: " + String.valueOf(System.currentTimeMillis()));
        }
    
        public void end() {
            System.out.println("结束时间: " + String.valueOf(System.currentTimeMillis()));
        }
    }

### 代理调用处理器: `BizInvocationHandler`

为接口生成的模板代理类，所有方法调用时都会委托给`InvocationHandler.invoke(...)`代为处理，它根据传入的`Method`信息，使用反射机制调用真实的方法。

    public class BizInvocationHandler implements InvocationHandler {
    
        private IBiz target;
        private PerformanceMonitor monitor;
    
        public BizInvocationHandler(IBiz target) {
            this.target = target;
            this.monitor = new PerformanceMonitor();
        }
    
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            monitor.start();
            method.invoke(target);
            monitor.end();
            return null;
        }
    }

### 代理生成器: `ProxyBuilder`

    public class ProxyBuilder {
    
        private Class [] interfaces;
        private InvocationHandler handler;
        private ClassLoader classLoader = ProxyBuilder.class.getClassLoader();
    
        public static ProxyBuilder newProxyBuilder() {
            return new ProxyBuilder();
        }
    
        public ProxyBuilder setInterFaces(Class<?>[] interFaces) {
            this.interfaces = interFaces;
            return this;
        }
    
        public ProxyBuilder setClassLoader(ClassLoader classLoader) {
            this.classLoader = classLoader;
            return this;
        }
    
        public ProxyBuilder setInvocationHandler(InvocationHandler handler) {
            this.handler = handler;
            return this;
        }
    
        public Object build() {
            return Proxy.newProxyInstance(classLoader, interfaces, handler);
        }
    
        public void buildClassFile(String className, String dir) {
            byte[] proxyClassFile = ProxyGenerator.generateProxyClass(className, interfaces);
    
            StringBuilder strBuilder = new StringBuilder();
            strBuilder.append(dir).append("/").append(className).append("class");
            String classFileName = strBuilder.toString();
    
            FileOutputStream out = null;
            try {
                out = new FileOutputStream(classFileName);
                out.write(proxyClassFile);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (out != null) {
                        out.close();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    

其中`build()`生成代理对象；`buildClassFile(...)`生成代理类的class文件。

### 测试

    public class JDKProxyTest {
    
        @Test
        public void testBiz() {
            IBiz biz = new BizImpl();
            BizInvocationHandler hander = new BizInvocationHandler(biz);
    
            IBiz proxy = (IBiz)ProxyBuilder.newProxyBuilder()
                .setClassLoader(Thread.currentThread().getContextClassLoader())
                .setInterFaces(new Class[] {IBiz.class})
                .setInvocationHandler(hander)
                .build();
            proxy.doSomething();
        }
    }

执行输出:

    开始时间: 1500530510627
    做一些业务逻辑
    结束时间: 1500530510628

### 使用小结

JDK动态代理使用步骤如下:

1. 
实现`InvocationHandler`接口，为其载入代理的目标实例&横切逻辑，通过实现`invoke`方法实现横切逻辑织入。

2. 
通过`Proxy.newProxyInstance(...)`把要代理的接口和`InvocationHandler`实例联系起来生成最终的代理实例。

3. 
通过强制类型转换可以把生成的代理实例转换成任何一个代理的接口类型，从而调用接口方法。

## 原理

JDK动态代理要求代理目标必须是接口的实现类，通过接口生成 **模板类** ，模板类实现所有接口方法，实现方法是一个个 **模板方法** ，只是简单的通过反射把请求委托给`InvocationHandler.invoke(...)`处理。

回头看下`ProxyBuilder.buildClassFile(...)`，它通过`ProxyGenerator.generateProxyClass(...)`生成IBiz的代理类。

### 生成代理类

    public class JDKProxyTest {
    
        @Test
        public void testBuildClassFile() {
            IBiz biz = new BizImpl();
            BizInvocationHandler hander = new BizInvocationHandler(biz);
    
            ProxyBuilder.newProxyBuilder()
                .setClassLoader(Thread.currentThread().getContextClassLoader())
                .setInterFaces(new Class[] {IBiz.class})
                .setInvocationHandler(hander)
                .buildClassFile("proxy", ".");
        }
    }

### 反编译生成的代理类

直接通过Idea打开生成的proxy.class文件即可，反编译后的代码一下(注意：这里去掉了`hashCode`、`toString`等无强关联性代码):

    public final class proxy extends Proxy implements IBiz {
        private static Method m1;
        
        ...
    
        public proxy(InvocationHandler var1) throws  {
            super(var1);
        }
    
        public final void doSomething() throws  {
            try {
                super.h.invoke(this, m1, (Object[])null);
            } catch (RuntimeException | Error var2) {
                throw var2;
            } catch (Throwable var3) {
                throw new UndeclaredThrowableException(var3);
            }
        }
    
        static {
            try {
                m1 = Class.forName("jdkproxy.IBiz").getMethod("doSomething", new Class[0]);
                
                ...
            } catch (NoSuchMethodException var2) {
                throw new NoSuchMethodError(var2.getMessage());
            } catch (ClassNotFoundException var3) {
                throw new NoClassDefFoundError(var3.getMessage());
            }
        }
    }
    

哈哈，代码非常简单，无谓多说。

### 代理类实例化过程

- 
入口: `Proxy.newProxyInstance(...)`

        public static Object newProxyInstance(ClassLoader loader,
                                              Class<?>[] interfaces,
                                              InvocationHandler h)
            throws IllegalArgumentException
        {
            ...
            
            final Class<?>[] intfs = interfaces.clone();
            
            // 获取或生成指定接口的代理类，这里会对生成的代理类进行缓存，下面展开。
            Class<?> cl = getProxyClass0(loader, intfs);
    
            /*
             * Invoke its constructor with the designated invocation handler.
             */
            try {
                ...
    
                // 获取代理类的构造方法
                final Constructor<?> cons = cl.getConstructor(constructorParams);
                final InvocationHandler ih = h;
                if (!Modifier.isPublic(cl.getModifiers())) {
                    // 构造方法不为public的话，修改其访问属性
                    AccessController.doPrivileged(new PrivilegedAction<Void>() {
                        public Void run() {
                            cons.setAccessible(true);
                            return null;
                        }
                    });
                }
                
                // 通过反射调用代理类的构造方法实例化代理对象返回。
                return cons.newInstance(new Object[]{h});
            } catch ...
            
            ...
        }

- 
`Proxy.getProxyClass0(...)`

        private static Class<?> getProxyClass0(ClassLoader loader,
                                               Class<?>... interfaces) {
            // 限制接口数量
            if (interfaces.length > 65535) {
                throw new IllegalArgumentException("interface limit exceeded");
            }
    
            // 这是一个WeakCach。
            // 如果cache中存在由loader加载并且实现了interfaces接口的代理类，就直接返回。
            // 否则就通过ProxyClassFactory创建代理类
            // proxyClassCache = (new WeakCache<>(new KeyFactory(), new ProxyClassFactory());)
            return proxyClassCache.get(loader, interfaces);
        }

- 
`ProxyClassFactory.apply(...)`

最终生成代理类的逻辑就在这里

            public Class<?> apply(ClassLoader loader, Class<?>[] interfaces) {
                ....
                // 生成代理类的字节码，buildClassFile.buildClassFile也是这样生成代理类的。
                byte[] proxyClassFile = ProxyGenerator.generateProxyClass(
                    proxyName, interfaces, accessFlags);
                try {
                    // 返回定义的代理类
                    return defineClass0(loader, proxyName,
                                        proxyClassFile, 0, proxyClassFile.length);
                } catch (ClassFormatError e) {
                    ...
                }
            }

## 总结

通过JDK代理生成的代理类是一个模板类，它通过反射找到接口的所有方法，并为每一个方法生成模板方法，通过反射调`InvocationHandler.invoke(...)`，通常业务逻辑和横切都在这里被调用。

由于JDK代理生成的代理类相对cglib生成子类要轻量级一些，所以在生成代理的效率上要优于cglib代理，但是在调用时，GDK代理通过反射的方式调用，相对cglib直接调用效率上要低。
{% endraw %}
