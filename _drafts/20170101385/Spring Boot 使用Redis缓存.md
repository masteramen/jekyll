---
layout: post
title:  "Spring Boot 使用Redis缓存"
title2:  "Spring Boot 使用Redis缓存"
date:   2017-01-01 23:58:05  +0800
source:  "https://www.jfox.info/springboot%e4%bd%bf%e7%94%a8redis%e7%bc%93%e5%ad%98.html"
fileName:  "20170101385"
lang:  "zh_CN"
published: true
permalink: "2017/springboot%e4%bd%bf%e7%94%a8redis%e7%bc%93%e5%ad%98.html"
---
{% raw %}
Spring 提供了很多缓存管理器，例如：

- SimpleCacheManager
- EhCacheCacheManager
- CaffeineCacheManager
- GuavaCacheManager
- CompositeCacheManager
这里我们要用的是除了核心的Spring框架之外，Spring Data提供的缓存管理器：**RedisCacheManager**

在Spring [Boot中通过@EnableCaching注解自动化配置合适的缓存管理器](mailto:Boot%E4%B8%AD%E9%80%9A%E8%BF%87@enablecaching注解自动化配置合适的缓存管理器)（CacheManager），默认情况下Spring Boot根据下面的顺序自动检测缓存提供者：

- Generic
- JCache (JSR-107)
- EhCache 2.x
- Hazelcast
- Infinispan
- Redis
- Guava
- Simple

但是因为我们之前已经配置了redisTemplate了，Spring Boot无法就无法自动给RedisCacheManager设置redisTemplate了，所以接下来要自己配置CacheManager 。

1. 首先修改RedisConfig配置类，[添加@EnableCaching注解](mailto:%E6%B7%BB%E5%8A%A0@enablecaching注解)，并继承CachingConfigurerSupport，重写CacheManager 方法

    ...
    @Configuration
    @EnableCaching
    public class RedisConfig extends CachingConfigurerSupport {
    
        @Bean
        public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory factory) {
            RedisTemplate<String, String> redisTemplate = new RedisTemplate<String, String>();
            redisTemplate.setConnectionFactory(factory);
            redisTemplate.afterPropertiesSet();
            setSerializer(redisTemplate);
            return redisTemplate;
        }
    
        private void setSerializer(RedisTemplate<String, String> template) {
            Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
            ObjectMapper om = new ObjectMapper();
            om.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
            om.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
            jackson2JsonRedisSerializer.setObjectMapper(om);
            template.setKeySerializer(new StringRedisSerializer());
            template.setValueSerializer(jackson2JsonRedisSerializer);
        }
    
    @Bean
        public CacheManager cacheManager(RedisTemplate redisTemplate) {
            RedisCacheManager rcm = new RedisCacheManager(redisTemplate);
            // 设置缓存过期时间，秒
            rcm.setDefaultExpiration(60);
            return rcm;
        }
    ...

Spring提供了如下注解来声明缓存规则：

- @Cacheable triggers cache population
- @CacheEvict triggers cache eviction
- @CachePut updates the cache without interfering with the method execution
- @Caching regroups multiple cache operations to be applied on a method
- @CacheConfig shares some common cache-related settings at class-level

注　　解描　　述@Cacheable表明Spring在调用方法之前，首先应该在缓存中查找方法的返回值。如果这个值能够找到，就会返回缓存的值。否则的话，这个方法就会被调用，返回值会放到缓存之中@CachePut表明Spring应该将方法的返回值放到缓存中。在方法的调用前并不会检查缓存，方法始终都会被调用@CacheEvict表明Spring应该在缓存中清除一个或多个条目@Caching这是一个分组的注解，能够同时应用多个其他的缓存注解@CacheConfig可以在类层级配置一些共用的缓存配置
@[Cacheable和@CachePut有一些共有的属性](mailto:Cacheable%E5%92%8C@cacheput有一些共有的属性)：
属　　性类　　型描　　述valueString[]要使用的缓存名称conditionStringSpEL表达式，如果得到的值是false的话，不会将缓存应用到方法调用上keyStringSpEL表达式，用来计算自定义的缓存keyunlessStringSpEL表达式，如果得到的值是true的话，返回值不会放到缓存之中
1. 
[在一个请求方法上加上@Cacheable注解](mailto:%E5%9C%A8%E4%B8%80%E4%B8%AA%E8%AF%B7%E6%B1%82%E6%96%B9%E6%B3%95%E4%B8%8A%E5%8A%A0%E4%B8%8A@cacheable注解)，测试下效果

    @Cacheable(value="testallCache")
    @RequestMapping(value = "/redis/user/{userId}", method = RequestMethod.GET)
    public User getUser(@PathVariable() Integer userId) {
        User user = userService.getUserById(userId);
        return user;
    }

2. 
然后访问这个请求，控制台就报错啦。

    java.lang.ClassCastException: java.lang.Integer cannot be cast to java.lang.String
    at org.springframework.data.redis.serializer.StringRedisSerializer.serialize(StringRedisSerializer.java:33)
    at org.springframework.data.redis.cache.RedisCacheKey.serializeKeyElement(RedisCacheKey.java:74)
    at org.springframework.data.redis.cache.RedisCacheKey.getKeyBytes(RedisCacheKey.java:49)
    at org.springframework.data.redis.cache.RedisCache$1.doInRedis(RedisCache.java:176)
    at org.springframework.data.redis.cache.RedisCache$1.doInRedis(RedisCache.java:172)
    at org.springframework.data.redis.core.RedisTemplate.execute(RedisTemplate.java:207)

原因如下：
先看一下Redis缓存默认的Key生成策略

- If no params are given, return SimpleKey.EMPTY.
- If only one param is given, return that instance.
- If more the one param is given, return a SimpleKey containing all parameters.

从上面的生成策略可以知道，上面的缓存testallCache使用的key是整形的userId参数，但是我们之前在redisTemplate里设置了template.setKeySerializer(new StringRedisSerializer());，所以导致类型转换错误。虽然也可以使用SpEL表达式生成Key（详见[这里](https://www.jfox.info/go.php?url=http://docs.spring.io/spring/docs/current/spring-framework-reference/html/cache.html#cache-spel-context)），但是返回结果还是需要是string类型（比如#root.methodName就是，#root.method就不是），更通用的办法是重写keyGenerator定制Key生成策略。

1. 
修改RedisConfig类，重写keyGenerator方法：

    @Bean
    public KeyGenerator keyGenerator() {
        return new KeyGenerator() {
            @Override
            public Object generate(Object target, Method method, Object... params) {
                StringBuilder sb = new StringBuilder();
                sb.append(target.getClass().getName());
                sb.append(":" + method.getName());
                for (Object obj : params) {
                    sb.append(":" + obj.toString());
                }
                return sb.toString();
            }
        };
    }

2. 再次进行刚才的请求（分别以1,2作为userId参数），浏览器结果如下图：
![](/wp-content/uploads/2017/07/1500908061.png)
![](/wp-content/uploads/2017/07/15009080611.png)
使用redisclient工具查看下：
![](/wp-content/uploads/2017/07/15009080612.png)
![](/wp-content/uploads/2017/07/15009080613.png)
可以看到Redis里保存了：

- 两条string类型的键值对：key就是上面方法生成的结果，value就是user对象序列化成json的结果
- 一个有序集合：[其中key为@Cacheable里的value+~keys](其中key为@Cacheable里的value+~keys)，分数为0，成员为之前string键值对的key

这时候把userId为1的用户的username改为ansel（原来是ansel1），再次进行https://localhost:8443/redis/user/1 请求，发现浏览器返回结果仍是ansel1，证明确实是从Redis缓存里返回的结果。
![](/wp-content/uploads/2017/07/15009080614.png)
![](/wp-content/uploads/2017/07/15009080615.png)

## 缓存更新与删除

1. 
[更新与删除Redis缓存需要用到@CachePut和@CacheEvict](更新与删除Redis缓存需要用到@CachePut和@CacheEvict)。这时候我发现如果使用上面那种key的生成策略，以用户为例：它的增删改查方法无法保证生成同一个key（方法名不同，参数不同），所以修改一下keyGenerator，使其按照缓存名称+userId方式生成key：

    @Bean
    public KeyGenerator keyGenerator() {
        return new KeyGenerator() {
            @Override
            public Object generate(Object target, Method method, Object... params) {
                StringBuilder sb = new StringBuilder();
                String[] value = new String[1];
                // sb.append(target.getClass().getName());
                // sb.append(":" + method.getName());
                Cacheable cacheable = method.getAnnotation(Cacheable.class);
                if (cacheable != null) {
                    value = cacheable.value();
                }
                CachePut cachePut = method.getAnnotation(CachePut.class);
                if (cachePut != null) {
                    value = cachePut.value();
                }
                CacheEvict cacheEvict = method.getAnnotation(CacheEvict.class);
                if (cacheEvict != null) {
                    value = cacheEvict.value();
                }
                sb.append(value[0]);
                for (Object obj : params) {
                    sb.append(":" + obj.toString());
                }
                return sb.toString();
            }
        };
    }

2. 
接下来编写user的增删改查方法：

    @CachePut(value = "user", key = "#root.caches[0].name + ':' + #user.userId")
    @RequestMapping(value = "/redis/user", method = RequestMethod.POST)
    public User insertUser(@RequestBody User user) {
        user.setPassword(SystemUtil.MD5(user.getPassword()));
        userService.insertSelective(user);
        return user;
    }
    
    @Cacheable(value = "user")
    @RequestMapping(value = "/redis/user/{userId}", method = RequestMethod.GET)
    public User getUser(@PathVariable Integer userId) {
        User user = userService.getUserById(userId);
        return user;
    }
    //#root.caches[0].name:当前被调用方法所使用的Cache, 即"user"
    @CachePut(value = "user", key = "#root.caches[0].name + ':' + #user.userId")
    @RequestMapping(value = "/redis/user", method = RequestMethod.PUT)
    public User updateUser(@RequestBody User user) {
        user.setPassword(SystemUtil.MD5(user.getPassword()));
        userService.updateByPrimaryKeySelective(user);
        return user;
    }
    
    @CacheEvict(value = "user")
    @RequestMapping(value = "/redis/user/{userId}", method = RequestMethod.DELETE)
    public void deleteUser(@PathVariable Integer userId) {
        userService.deleteByPrimaryKey(userId);
    }

因为新增和修改传递的参数为user对象，keyGenerator无法获取到userId，只好使用SpEL显示标明key了。

## 然后进行测试：

### 进行insert操作：

![](/wp-content/uploads/2017/07/1500908062.png)

### 插入后，进行get请求：

![](/wp-content/uploads/2017/07/15009080621.png)

### 查看Redis存储：

![](/wp-content/uploads/2017/07/15009080622.png)
![](/wp-content/uploads/2017/07/15009080623.png)

### 进行update操作：

![](/wp-content/uploads/2017/07/15009080624.png)

### 更新后，进行get请求：

![](/wp-content/uploads/2017/07/15009080625.png)

### 查看Redis存储：

![](/wp-content/uploads/2017/07/15009080626.png)

### 进行delete操作：

![](/wp-content/uploads/2017/07/1500908063.png)

### 查看Redis存储：

![](/wp-content/uploads/2017/07/15009080631.png)
发现user:3的记录已经没有了，只剩user:1，user:2了

一直很想知道网上很多用之前那种keyGenerator方法的，他们是怎么进行缓存更新和删除的，有知道的可以告知下。
{% endraw %}
