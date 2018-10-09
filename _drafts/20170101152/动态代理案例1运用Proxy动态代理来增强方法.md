---
layout: post
title:  "动态代理案例1:运用Proxy动态代理来增强方法"
title2:  "动态代理案例1运用Proxy动态代理来增强方法"
date:   2017-01-01 23:54:12  +0800
source:  "https://www.jfox.info/%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e6%a1%88%e4%be%8b1%e8%bf%90%e7%94%a8proxy%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e6%9d%a5%e5%a2%9e%e5%bc%ba%e6%96%b9%e6%b3%95.html"
fileName:  "20170101152"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e6%a1%88%e4%be%8b1%e8%bf%90%e7%94%a8proxy%e5%8a%a8%e6%80%81%e4%bb%a3%e7%90%86%e6%9d%a5%e5%a2%9e%e5%bc%ba%e6%96%b9%e6%b3%95.html"
---
{% raw %}
动态代理案例1:
/*要求：运用Proxy动态代理来增强方法
题目：
1.定义接口Fruit，其中有addFruit方法
2.定义实现类FruitImpl，实现Fruit接口
3.定义测试类，利用动态代理类的方式，增强addFruit方法*/

      1import java.lang.reflect.Proxy;
      2import java.lang.reflect.InvocationHandler;
      3import java.lang.reflect.Method;
      4import java.lang.reflect.InvocationTargetException;
      5  6//接口  7interface Fruit{
      8publicabstractvoid addFruit();
      9  }
     10 11//实现类 12class FruitImpl implements Fruit{
     13      @Override
     14publicvoid addFruit(){
     15          System.out.println("添加水果...");
     16      }
     17  }
     18 19//测试类---编写代理,增强实现类中的方法 20publicclass FruitDemo{
     21publicstaticvoid main(String[] args){
     22//创建动态代理对象 23         Object f = Proxy.newProxyInstance(FruitImpl.class.getClassLoader(), FruitImpl.class.getInterfaces(),
     24new InvocationHandler(){
     25                  @Override
     26public Object invoke(Object Proxy, Method method, Object[] args){
     27                      System.out.println("选择水果.....................");
     28                      Object obj = null;
     29try{
     30                              obj = method.invoke(new FruitImpl(),args);
     31                          }catch(IllegalAccessException | InvocationTargetException | IllegalArgumentException e){
     32                              e.printStackTrace();
     33                          }
     34                      System.out.println("添加成功~~");
     35return obj;
     36                  }
     37              }
     38          );
     39 40//代理对象向下(接口)转型 41         Fruit f1 = (Fruit) f;
     42 43//转型后的对象执行原方法(已增强) 44          f1.addFruit();
     45      }
     46  }
     47
{% endraw %}
