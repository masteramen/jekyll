---
layout: post
title:  "quartz定时执行任务，并配置web.xml"
title2:  "quartz定时执行任务，并配置web.xml"
date:   2017-01-01 23:52:51  +0800
source:  "https://www.jfox.info/quartz%e5%ae%9a%e6%97%b6%e6%89%a7%e8%a1%8c%e4%bb%bb%e5%8a%a1%e5%b9%b6%e9%85%8d%e7%bd%aewebxml.html"
fileName:  "20170101071"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/quartz%e5%ae%9a%e6%97%b6%e6%89%a7%e8%a1%8c%e4%bb%bb%e5%8a%a1%e5%b9%b6%e9%85%8d%e7%bd%aewebxml.html"
---
{% raw %}
离职四个多月，毕业办完之后6月13日又回到公司上班，一直有想法把自己学的东西记录整理分享做出来，一直没动过，今天开始第一篇，这是今天项目上需要做个定时任务，临时学的，quartz的功能还是很强大用起来也方便，这里的demo只是实现每天定时执行一次，其他功能可以在此基础上继续深入学习，哈哈 睡觉，明天继续。

一、maven依赖：

    <dependency><groupId>org.quartz-scheduler</groupId><artifactId>quartz</artifactId><version>2.2.3</version></dependency><dependency><groupId>org.quartz-scheduler</groupId><artifactId>quartz-jobs</artifactId><version>2.2.3</version></dependency>

二、Doem：

TimingTaskSchedule需要实现ServletContextListener接口，监听后启动项目时的启动类

    package com.thinkgem.jeesite.modules.sys.listener;
    
    import javax.servlet.ServletContextEvent;
    import javax.servlet.ServletContextListener;
    
    publicclass TimingTaskSchedule implements ServletContextListener{
    
        // 服务器启动时执行该事件    @Override
        publicvoid contextInitialized(ServletContextEvent arg0) {
            try {
                QuartzLoad.run();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // 服务器停止时执行该事件    @Override
        publicvoid contextDestroyed(ServletContextEvent arg0) {
            try {
                QuartzLoad.stop();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    
    }

这里的 0 0 0 ? * * 表示每天00：00：00执行一次

从左到右分别表示 秒 分 时 日 月 周 年

？表示不关心 *表示每 年可以忽略不写

    package com.thinkgem.jeesite.modules.sys.listener;
    
    import org.quartz.CronScheduleBuilder;
    import org.quartz.CronTrigger;
    import org.quartz.Job;
    import org.quartz.JobBuilder;
    import org.quartz.JobDetail;
    import org.quartz.Scheduler;
    import org.quartz.SchedulerFactory;
    import org.quartz.TriggerBuilder;
    import org.quartz.impl.StdSchedulerFactory;
    import com.thinkgem.jeesite.modules.sys.listener.job;
    
    publicclass QuartzLoad {
        privatestatic Scheduler sched; 
        publicstaticvoid run() throws Exception { 
            System.out.println("定时任务启动");
            JobDetail jobDetail = JobBuilder.newJob((Class<? extends Job>) job.class)
                    .withIdentity("myjob", "group1").build();
            /*Trigger trigger = TriggerBuilder.newTrigger().withIdentity("myTrigger", "group1").startNow()
                    .withSchedule(SimpleScheduleBuilder.simpleSchedule()
                    .withIntervalInSeconds(2).repeatForever()).build();*/
            CronTrigger trigger =(CronTrigger) TriggerBuilder.newTrigger()
                    .withIdentity("trigger", "group1")
                    .withSchedule(CronScheduleBuilder.cronSchedule("0 0 0 ? * *"))
                    .build();
            SchedulerFactory sfact = new StdSchedulerFactory();
            Scheduler schedule = sfact.getScheduler();
            schedule.start();
            schedule.scheduleJob(jobDetail, trigger);
        }
        //停止  publicstaticvoid stop() throws Exception{  
               sched.shutdown();  
         }  
    }

Job中就是自己的业务处理

    package com.thinkgem.jeesite.modules.sys.listener;
    
    import java.text.SimpleDateFormat;
    import java.util.Date;import org.apache.shiro.authz.annotation.RequiresPermissions;
    import org.quartz.Job;
    import org.quartz.JobExecutionContext;
    import org.quartz.JobExecutionException;
    
    publicclass job implements Job{
    publicvoid execute(JobExecutionContext arg0) throws JobExecutionException {
            Date date=new Date();
            SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            System.out.println("Time:"+sf.format(date));
            System.out.println("Hello");
    
                }
            }
        }
    }
{% endraw %}
