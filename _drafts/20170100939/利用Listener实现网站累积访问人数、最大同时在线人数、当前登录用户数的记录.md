---
layout: post
title:  "利用Listener实现网站累积访问人数、最大同时在线人数、当前登录用户数的记录"
title2:  "利用Listener实现网站累积访问人数、最大同时在线人数、当前登录用户数的记录"
date:   2017-01-01 23:50:39  +0800
source:  "https://www.jfox.info/%e5%88%a9%e7%94%a8listener%e5%ae%9e%e7%8e%b0%e7%bd%91%e7%ab%99%e7%b4%af%e7%a7%af%e8%ae%bf%e9%97%ae%e4%ba%ba%e6%95%b0-%e6%9c%80%e5%a4%a7%e5%90%8c%e6%97%b6%e5%9c%a8%e7%ba%bf%e4%ba%ba%e6%95%b0-%e5%bd%93.html"
fileName:  "20170100939"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%88%a9%e7%94%a8listener%e5%ae%9e%e7%8e%b0%e7%bd%91%e7%ab%99%e7%b4%af%e7%a7%af%e8%ae%bf%e9%97%ae%e4%ba%ba%e6%95%b0-%e6%9c%80%e5%a4%a7%e5%90%8c%e6%97%b6%e5%9c%a8%e7%ba%bf%e4%ba%ba%e6%95%b0-%e5%bd%93.html"
---
{% raw %}
1package com.lt.listener;
     2 3import java.util.Date;
     4import java.util.HashMap;
     5import java.util.Map;
     6 7import javax.servlet.http.HttpSession;
     8/** 9 * 网站全局变量类
    10 * @author LIUTIE
    11 *
    12*/13publicabstractclass ApplicationConstants {
    1415/**16     * 用户登录session名称
    17*/18publicstaticfinal String LOGIN_SESSION_NAME = "userInfo";
    1920/**21     * 索引所有的session  
    22     * 用于单一登录
    23*/24publicstatic Map<String,HttpSession> SESSION_MAP = new HashMap<>();
    2526/**27     * 当前在线用户数
    28*/29publicstaticint CURRENT_LOGIN_COUNT = 0;
    3031/**32     * 历史访客总数
    33*/34publicstaticint TOTAL_HISTORY_COUNT = 0;
    3536/**37     * 最高同时在线人数
    38*/39publicstaticint MAX_ONLINE_COUNT = 0;
    4041/**42     * 服务器启动时间
    43*/44publicstatic Date SERVER_START_DATE = new Date();
    4546/**47     * 最高在线人数时间
    48*/49publicstatic Date MAX_ONLINE_COUNT_DATE = new Date();
    50515253 }

View Code
2.实现servletContext监听，用于记录服务器信息
![](/wp-content/uploads/2017/06/ContractedBlock.gif)![](/wp-content/uploads/2017/06/ExpandedBlockStart.gif)
     1package com.lt.listener;
     2 3import java.util.Date;
     4 5import javax.servlet.ServletContextEvent;
     6import javax.servlet.ServletContextListener;
     7 8/**
     9 * servletContext监听
    10 * 记录服务器信息 启动关闭时间等
    11 * @author LIUTIE
    12 *
    13 */
    14public class MyContextListener implements ServletContextListener {
    1516    /**
    17     * 服务器启动时被调用
    18     */
    19    @Override
    20    public void contextDestroyed(ServletContextEvent arg0) {
    21        //记录启动时间
    22        ApplicationConstants.SERVER_START_DATE = new Date();
    23    }
    2425    /**
    26     * 服务器关闭时被调用
    27     */
    28    @Override
    29    public void contextInitialized(ServletContextEvent arg0) {
    30        //保存数据到硬盘
    31        // TODO Auto-generated method stub
    32    }
    3334 }

View Code
3.实现 HttpSessionListener, HttpSessionAttributeListener监听，用于记录登录信息、访问总人数、在线人数，实现单一登录等
![](/wp-content/uploads/2017/06/ContractedBlock.gif)![](/wp-content/uploads/2017/06/ExpandedBlockStart.gif)
      1package com.lt.listener;
      2  3import java.util.Date;
      4  5import javax.servlet.http.HttpSession;
      6import javax.servlet.http.HttpSessionAttributeListener;
      7import javax.servlet.http.HttpSessionBindingEvent;
      8import javax.servlet.http.HttpSessionEvent;
      9import javax.servlet.http.HttpSessionListener;
     10 11/** 12 * session监听
     13 * 记录登录信息 访问总人数 在线人数等
     14 * 实现单一登录
     15 * @author LIUTIE
     16 *
     17*/ 18publicclass MySessionListener implements HttpSessionListener, HttpSessionAttributeListener {
     19 20/** 21     * session创建时被调用
     22*/ 23    @Override
     24publicvoid sessionCreated(HttpSessionEvent sessionEvent) {
     25// 获取创建的session 26         HttpSession session = sessionEvent.getSession();
     27// 添加到map 28        ApplicationConstants.SESSION_MAP.put(session.getId(), session);
     29// 访问总人数++ 30         ApplicationConstants.TOTAL_HISTORY_COUNT++;
     31// 如果map总数大于最高同时在线人数则更新最高在线人数及时间 32if (ApplicationConstants.MAX_ONLINE_COUNT < ApplicationConstants.SESSION_MAP.size()) {
     33             ApplicationConstants.MAX_ONLINE_COUNT = ApplicationConstants.SESSION_MAP.size();
     34             ApplicationConstants.MAX_ONLINE_COUNT_DATE = new Date();
     35        }
     36 37    }
     38 39/** 40     * session销毁时被调用
     41*/ 42    @Override
     43publicvoid sessionDestroyed(HttpSessionEvent sessionEvent) {
     44// 获取即将被销毁的session 45         HttpSession session = sessionEvent.getSession();
     46// 在map中根据key移除 47        ApplicationConstants.SESSION_MAP.remove(session.getId());
     48    }
     49 50/** 51     * 添加session属性时被调用
     52*/ 53    @Override
     54publicvoid attributeAdded(HttpSessionBindingEvent event) {
     55// 判断是否添加的用户登录信息session 56if (event.getName().equals(ApplicationConstants.LOGIN_SESSION_NAME)) {
     57// 当前登录用户数++ 58             ApplicationConstants.CURRENT_LOGIN_COUNT++;
     59// 是否在其他机器登录处理 60            isLoginInOtherPlace(event);
     61        }
     62    }
     63 64/** 65     * 移除session属性时被调用
     66*/ 67    @Override
     68publicvoid attributeRemoved(HttpSessionBindingEvent event) {
     69// 判断是否移除的用户登录信息session 70if (event.getName().equals(ApplicationConstants.LOGIN_SESSION_NAME)) {
     71// 当前登录用户数-- 72             ApplicationConstants.CURRENT_LOGIN_COUNT--;
     73// 是否在其他机器登录处理 74            isLoginInOtherPlace(event);
     75        }
     76    }
     77 78/** 79     * 修改session属性时被调用
     80*/ 81    @Override
     82publicvoid attributeReplaced(HttpSessionBindingEvent event) {
     83 84// 判断是否修改的用户登录信息session 85if (event.getName().equals(ApplicationConstants.LOGIN_SESSION_NAME)) {
     86// 是否在其他机器登录处理 87            isLoginInOtherPlace(event);
     88        }
     89    }
     90 91/** 92     * 是否在其他机器登录处理
     93     * 
     94     * @param event
     95*/ 96privatevoid isLoginInOtherPlace(HttpSessionBindingEvent event) {
     97// 获取添加的session 98         HttpSession session = event.getSession();
     99// 遍历查找此用户是否登录100for (HttpSession s : ApplicationConstants.SESSION_MAP.values()) {
    101// 如果已经在其他机器登录则使其失效102if (event.getValue().equals(s.getAttribute(ApplicationConstants.LOGIN_SESSION_NAME))
    103                     && session.getId() != s.getId()) {
    104// 使session失效105                session.invalidate();
    106break;
    107            }
    108        }
    109    }
    110 }

View Code
4.实现 request监听，用于记录客户信息 ip、url等
![](/wp-content/uploads/2017/06/ContractedBlock.gif)![](/wp-content/uploads/2017/06/ExpandedBlockStart.gif)
     1package com.lt.listener;
     2 3import javax.servlet.ServletRequestEvent;
     4import javax.servlet.ServletRequestListener;
     5import javax.servlet.http.HttpServletRequest;
     6 7/** 8 * request监听 用于记录客户信息 ip、url等
     9 * 
    10 * @author LIUTIE
    11 *
    12*/13publicclass MyRequestListener implements ServletRequestListener {
    1415/**16     * request销毁时调用
    17*/18    @Override
    19publicvoid requestDestroyed(ServletRequestEvent event) {
    20// TODO Auto-generated method stub2122    }
    2324/**25     * request创建时调用
    26*/27    @Override
    28publicvoid requestInitialized(ServletRequestEvent event) {
    29         HttpServletRequest request = (HttpServletRequest) event;
    30// 客户端ip31         String ip = request.getRemoteAddr();
    32// 访问的URL地址33         String url = request.getRequestURI();
    34// 只做简单后台打印35         System.out.println("The client ip is " + ip);
    36         System.out.println("The address url is " + url);
    37    }
    3839 }

View Code
5.在web.xml中配置队一行的listener
![](/wp-content/uploads/2017/06/ContractedBlock.gif)![](/wp-content/uploads/2017/06/ExpandedBlockStart.gif)
    <listener><listener-class>
                com.lt.listener.MyContextListener
            </listener-class></listener><listener><listener-class>
                com.lt.listener.MySessionListener
            </listener-class></listener><listener><listener-class>
                com.lt.listener.MyRequestListener
            </listener-class></listener>

View Code
Listener种类：

　　1.监听对象的创建与销毁的Listener：

　　HttpSessionListener： sessionCreated(HttpSessionEvent sessionEvent)、sessionDestroyed(HttpSessionEvent sessionEvent)

　　ServletRequestListener： requestInitialized(ServletRequestEvent event)、requestDestroyed(ServletRequestEvent event)

　　ServletContextListener： contextInitialized(ServletContextEvent event)、contextDestroyed(ServletContextEvent event)

　　2.监听对象的属性变化的Listener：

　　HttpSessionAttributeListener：(添加、更新、移除session时触发)

　　attributeAdded(HttpSessionBindingEvent event)、attributeReplaced(HttpSessionBindingEvent event)、attributeRemoved(HttpSessionBindingEvent event)

　　ServletContextAttributeListener：(添加、更新、移除context时触发)

　 attributeAdded(ServletContextAttributeEvent event)、attributeReplaced(ServletContextAttributeEvent event)、attributeRemoved(ServletContextAttributeEvent event) 

　　ServletRequestAttributeListener：(添加、更新、移除request时触发)

　　attributeAdded(ServletRequestAttributeEvent event)、attributeReplaced(ServletRequestAttributeEvent event)、attributeRemoved(ServletRequestAttributeEvent event) 

　　3.监听Session内的对象

　　HttpSessionBindingListener：(对象放入session、对象从session移除时触发)

　　valueBound(HttpSessionBindingEvent event)、valueUnbound(HttpSessionBindingEvent event)

　　HttpSessionActivationListener：(session中的对象被钝化、对象被重新加载时触发ps：将session中的内容保存到硬盘的过程叫做钝化，钝化需实现Serializable序列化接口)

　　sessionWillPassivate(HttpSessionEvent event)、sessionDidActivate(HttpSessionEvent event)
{% endraw %}
