---
layout: post
title:  "Shiro实战（三）Shiro授权（上）"
title2:  "Shiro实战（三）Shiro授权（上）"
date:   2017-01-01 23:58:01  +0800
source:  "http://www.jfox.info/shiro%e5%ae%9e%e6%88%98%e4%b8%89shiro%e6%8e%88%e6%9d%83%e4%b8%8a.html"
fileName:  "20170101381"
lang:  "zh_CN"
published: true
permalink: "shiro%e5%ae%9e%e6%88%98%e4%b8%89shiro%e6%8e%88%e6%9d%83%e4%b8%8a.html"
---
{% raw %}
① Permissions
Permissions是Shiro安全框架中最原子性的元素，它用来描述能够做什么或者说Subject能够执行什么样的操作，比如删除用户、查看用户详情、查看商品详情等。

② Roles
Roles大家应该都很清楚了，某人具有某个角色，那么就对应具有怎样的行为或责任，也就是一个角色代表一组行为或责任。比如我们的后台管理系统，用户的角色常常会有超级管理员、普通管理员之分，它们对应的权限是不相同的，一般超级管理员会具有更多的权限。

③ 用户
Users就是我们之前提到的Shiro三大核心概念之一的Subject。用户与角色、权限的关系取决于我们的应用，可以选择直接将权限赋给用户，也可以选择将权限赋给角色，然后将角色赋给用户，本篇我们将通过后者来讲述。

1.2 授权常见操作

我们首先来回顾下INI配置文件，看下我们如何通过INI配置文件指定用户、角色、权限

    #对象以及对象的属性，比如SecurityManager、Realms
    [main]
    #hashedMatcher = org.apache.shiro.authc.credential.HashedCredentialsMatcher
    #hashedMatcher.hashAlgorithmName = MD5
    
    #riversRealm = com.rivers.study.RiversRealm
    #riversRealm.credentialsMatcher = $hashedMatcher
    
    #securityManager.realms = $riversRealm
    
    #用户名以及该用户对应的密码以及角色
    #username = password, role1, role2..., roleN
    [users]
    rivers = secret, admin
    calabash = warrior, guest
    
    #角色以及该角色可以拥有的权限
    #rolename = permission1, permission2..., permissionN
    [roles]
    admin = UserManagerment:*
    guest = UserManagerment:getUserInfo
    
    [urls]

在上面的配置文件中，我们指定了两个用户rivers、calabash，用户rivers的密码是secret，具有admin角色，而用户calabash的密码是warrior，具有guest角色；角色admin具有`UserManagerment:*`下的所有操作，而guest只有`UserManagerment:getUserInfo`权限。

① 角色判断

那么我们如何判断用户（Subject）是否具有某种角色或者某些角色呢？Subject提供了`hasRole*`方法来帮助我们进行处理。

    Subject currentUser = SecurityUtils.getSubject();
    UsernamePasswordToken token = new UsernamePasswordToken("calabash", "warrior");
    currentUser.login(token);
    
    if (currentUser.hasRole("admin")) {
        logger.info("用户【" + currentUser.getPrincipal() + "】具有【admin】角色");
    }
    
    List<String> roleList = new ArrayList<String>();
    roleList.add("admin");
    roleList.add("guest");
    boolean[] results = currentUser.hasRoles(roleList);
    for (int i = 0; i < results.length; i++) {
        String tmp = results[i] ? "具有" : "不具有";
        logger.info("用户【" + currentUser.getPrincipal() + tmp + "【" + roleList.get(i) + "】角色");
    }

另外我们也可以通过`hasAllRoles(Collection<String> roleNames)`来判断用户是否具有所有集合中指定的角色，都存在返回true，否则返回false。

如果我们不想做太多的逻辑处理，用户存在角色就执行，不存在就直接抛出异常，那么我们可以checkRole*系列方法。

    currentUser.checkRole("admin");

② 权限判断

那么我们如何判断用户（Subject）是否具有某种权限或者某些权限呢？Subject提供了`isPermitted*`方法来帮助我们进行处理。

    if (currentUser.isPermitted("UserManagerment:deleteUser")) {
        logger.info("用户【" + currentUser.getPrincipal() + "】具有【UserManagerment:deleteUser】权限");
    }
    
    if (currentUser.isPermitted("UserManagerment:getUserInfo")) { 
        logger.info("用户【" + currentUser.getPrincipal() + "】具有【UserManagerment:getUserInfo】权限");
    }

Shiro还提供了其他的方法供我们使用，当然也包括checkPermission*系列，有兴趣的朋友可以去到Subject接口了解。
{% endraw %}
