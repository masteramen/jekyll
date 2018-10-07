---
layout: post
title:  "Java设置一段代码执行的超时时间"
title2:  "Java设置一段代码执行的超时时间"
date:   2017-01-01 23:56:18  +0800
source:  "http://www.jfox.info/java%e8%ae%be%e7%bd%ae%e4%b8%80%e6%ae%b5%e4%bb%a3%e7%a0%81%e6%89%a7%e8%a1%8c%e7%9a%84%e8%b6%85%e6%97%b6%e6%97%b6%e9%97%b4.html"
fileName:  "20170101278"
lang:  "zh_CN"
published: true
permalink: "java%e8%ae%be%e7%bd%ae%e4%b8%80%e6%ae%b5%e4%bb%a3%e7%a0%81%e6%89%a7%e8%a1%8c%e7%9a%84%e8%b6%85%e6%97%b6%e6%97%b6%e9%97%b4.html"
---
{% raw %}
作者[一只好奇的茂](/u/257a3ed73535)2017.07.11 20:34字数 90
最近在项目中，需要调用其他APP提供的AIDL接口，项目要求必须执行完该操作，才能执行后续的程序，所以必须设置代码执行的超时时间，找到如下代码可以满足需求：

    public class ThreadTest {
        public static void main(String[] args) throws InterruptedException,
                ExecutionException {
    
            final ExecutorService exec = Executors.newFixedThreadPool(1);
    
            Callable<String> call = new Callable<String>() {
                public String call() throws Exception {  
                    //开始执行耗时操作  
                    Thread.sleep(1000 * 2);
                    return "线程执行完成.";  
                }  
            };  
    
            try {  
                Future<String> future = exec.submit(call);
                String obj = future.get(1000 * 1, TimeUnit.MILLISECONDS); //任务处理超时时间设为 1 秒
                System.out.println("任务成功返回:" + obj);  
            } catch (TimeoutException ex) {  
                System.out.println("处理超时啦....");  
                ex.printStackTrace();  
            } catch (Exception e) {  
                System.out.println("处理失败.");  
                e.printStackTrace();  
            }  
            // 关闭线程池  
            exec.shutdown();  
        }  
    }
{% endraw %}
