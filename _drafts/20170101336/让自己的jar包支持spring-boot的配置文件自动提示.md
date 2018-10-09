---
layout: post
title:  "让自己的jar包支持spring-boot的配置文件自动提示"
title2:  "让自己的jar包支持spring-boot的配置文件自动提示"
date:   2017-01-01 23:57:16  +0800
source:  "https://www.jfox.info/%e8%ae%a9%e8%87%aa%e5%b7%b1%e7%9a%84jar%e5%8c%85%e6%94%af%e6%8c%81springboot%e7%9a%84%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6%e8%87%aa%e5%8a%a8%e6%8f%90%e7%a4%ba.html"
fileName:  "20170101336"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e8%ae%a9%e8%87%aa%e5%b7%b1%e7%9a%84jar%e5%8c%85%e6%94%af%e6%8c%81springboot%e7%9a%84%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6%e8%87%aa%e5%8a%a8%e6%8f%90%e7%a4%ba.html"
---
{% raw %}
在使用IDEA编写spring-boot的配置文件的时候，如果是框架再带的配置项，在深入.的时候会有自动提示。虽然，没有自动提示，在使用的时候，也不会有问题，但是，如果有提示的话，会更加稳妥些。

那么怎么让自己jar包中的配置项也支持自动提示呢？

1.需要将配置项写成一个对象。类似这样的

    package com.moensun.cloud.common.utils2.druid;
    
    import org.springframework.boot.context.properties.ConfigurationProperties;
    
    import java.util.List;
    
    /**
     * Created by Bane.Shi.
     * Copyright MoenSun
     * User: Bane.Shi
     * Date: 2017/7/13
     * Time: 16:00
     */
    @ConfigurationProperties(
    		prefix = "spring.datasource.druid",
    		ignoreInvalidFields = true,
    		ignoreNestedProperties = true
    )
    public class DruidProperties {
    
    	private int initialSize;
    	private int maxActive;
    	private int minIdle;
    	private long maxWait;
    	private long timeBetweenEvictionRunsMillis;
    	private long minEvictableIdleTimeMillis;
    	private String validationQuery;
    
    
    	private Boolean testWhileIdle;
    	private Boolean testOnBorrow;
    	private Boolean testOnReturn;
    
    	private Boolean poolPreparedStatements;
    	private int maxPoolPreparedStatementPerConnectionSize;
    
    	private String filters;
    	private List proxyFilters;
    
    
    	public int getInitialSize() {
    		return initialSize;
    	}
    
    	public void setInitialSize(int initialSize) {
    		this.initialSize = initialSize;
    	}
    
    	public int getMaxActive() {
    		return maxActive;
    	}
    
    	public void setMaxActive(int maxActive) {
    		this.maxActive = maxActive;
    	}
    
    	public int getMinIdle() {
    		return minIdle;
    	}
    
    	public void setMinIdle(int minIdle) {
    		this.minIdle = minIdle;
    	}
    
    	public long getMaxWait() {
    		return maxWait;
    	}
    
    	public void setMaxWait(long maxWait) {
    		this.maxWait = maxWait;
    	}
    
    	public long getTimeBetweenEvictionRunsMillis() {
    		return timeBetweenEvictionRunsMillis;
    	}
    
    	public void setTimeBetweenEvictionRunsMillis(long timeBetweenEvictionRunsMillis) {
    		this.timeBetweenEvictionRunsMillis = timeBetweenEvictionRunsMillis;
    	}
    
    	public long getMinEvictableIdleTimeMillis() {
    		return minEvictableIdleTimeMillis;
    	}
    
    	public void setMinEvictableIdleTimeMillis(long minEvictableIdleTimeMillis) {
    		this.minEvictableIdleTimeMillis = minEvictableIdleTimeMillis;
    	}
    
    	public String getValidationQuery() {
    		return validationQuery;
    	}
    
    	public void setValidationQuery(String validationQuery) {
    		this.validationQuery = validationQuery;
    	}
    
    	public Boolean getTestWhileIdle() {
    		return testWhileIdle;
    	}
    
    	public void setTestWhileIdle(Boolean testWhileIdle) {
    		this.testWhileIdle = testWhileIdle;
    	}
    
    	public Boolean getTestOnBorrow() {
    		return testOnBorrow;
    	}
    
    	public void setTestOnBorrow(Boolean testOnBorrow) {
    		this.testOnBorrow = testOnBorrow;
    	}
    
    	public Boolean getTestOnReturn() {
    		return testOnReturn;
    	}
    
    	public void setTestOnReturn(Boolean testOnReturn) {
    		this.testOnReturn = testOnReturn;
    	}
    
    	public Boolean getPoolPreparedStatements() {
    		return poolPreparedStatements;
    	}
    
    	public void setPoolPreparedStatements(Boolean poolPreparedStatements) {
    		this.poolPreparedStatements = poolPreparedStatements;
    	}
    
    	public int getMaxPoolPreparedStatementPerConnectionSize() {
    		return maxPoolPreparedStatementPerConnectionSize;
    	}
    
    	public void setMaxPoolPreparedStatementPerConnectionSize(int maxPoolPreparedStatementPerConnectionSize) {
    		this.maxPoolPreparedStatementPerConnectionSize = maxPoolPreparedStatementPerConnectionSize;
    	}
    
    	public String getFilters() {
    		return filters;
    	}
    
    	public void setFilters(String filters) {
    		this.filters = filters;
    	}
    
    	public List getProxyFilters() {
    		return proxyFilters;
    	}
    
    	public void setProxyFilters(List proxyFilters) {
    		this.proxyFilters = proxyFilters;
    	}
    }

2.还需要在resource下创建文件

resource/META-INFO/spring.factories

    com.moensun.cloud.common.utils2.druid.DruidProperties=

这样，需要的配置基本都有了。但是，还不够，还需要生成 spring-configuration-metadata.json

3.在pom中添加生成 json的配置json的jar包

    <dependency>
    			<groupId>org.springframework.boot</groupId>
    			<artifactId>spring-boot-configuration-processor</artifactId>
    		</dependency>

这样，在执行install 就可以了。
{% endraw %}
