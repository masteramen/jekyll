---
layout: post
title:  "arduino多任务库processSchedule在线程中设置延迟的方法"
title2:  "arduino多任务库processSchedule在线程中设置延迟的方法"
date:   2017-01-01 23:50:23  +0800
source:  "https://www.jfox.info/arduino%e5%a4%9a%e4%bb%bb%e5%8a%a1%e5%ba%93processschedule%e5%9c%a8%e7%ba%bf%e7%a8%8b%e4%b8%ad%e8%ae%be%e7%bd%ae%e5%bb%b6%e8%bf%9f%e7%9a%84%e6%96%b9%e6%b3%95.html"
fileName:  "20170100923"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/arduino%e5%a4%9a%e4%bb%bb%e5%8a%a1%e5%ba%93processschedule%e5%9c%a8%e7%ba%bf%e7%a8%8b%e4%b8%ad%e8%ae%be%e7%bd%ae%e5%bb%b6%e8%bf%9f%e7%9a%84%e6%96%b9%e6%b3%95.html"
---
{% raw %}
我先引用一下这个项目介绍的部分内容，然后再来说我选择的理由 

###  Basic 

-  Control Over How Often a Process Runs (Periodically, Iterations, or as Often as Possible) 
-  Process Priority Levels (Easily make custom levels as well) 
-  Dynamically Add/Remove and Enable/Disable Processes 
-  Interrupt safe (add, disable, destroy, etc.. processes from interrupt routines) 
-  Process concurrency protection (Process will always be in a valid state) 

###  Advanced 

-  Spawn new processes from within running processes 
-  Automatic Process Monitoring Statistics (calculates % CPU time for process) 
-  Truly object oriented (a Process is its own object) 
-  Exception Handling (wait what?!) 
-  Scheduler can automatically interrupt stuck processes 

 上述引用是这个 [ 多任务 ](https://www.jfox.info/go.php?url=http://www.asymt.com/tag/%e5%a4%9a%e4%bb%bb%e5%8a%a1) 库的一些特点，我把每条都翻译一下 基本的 

-  控制Process如何运行（定期，迭代或尽可能多的） 
-  支持定义Process优先级（轻松创建自定义级别） 
-  动态的添加/删除和允许/禁止一个Process 
-  中断安全的（从中断程序增加，禁止，销毁Process等等） 
-  Process并发保护（Process总是处于有效状态） 高级的 
-  允许从运行的Process中产生新的Process 
-  自动统计监测Process（每个Process使用的CPU时间的百分比） 
-  真正的面向对象（一个Process就是一个对象） 
-  异常处理（等什么?!） 
-  调度程序可以自动中断卡住的Process 上述的特点是我选择使用这个多任务库的一个原因，最主要的原因就是他是使用面向对象的方式开发，这是一种比较友好的方式，使用更简单。 

 在开始描述怎么做之前，我默认正在读这篇文章的人都是对这个多任务库有过初步了解通读过这个项目的wiki页面的。如果你还没有进入这个开源项目了解过，可以先去这个项目的主页了解后再回来读这篇文章。 

 现在开始正式介绍在Process是怎么实现延迟，其实方法也很简单，就是在你想要设置延迟之前先记录一下你当前Process的运行状态，然后调用Process对象的setPeriod(delay_ms)方法重新设置当前Process对象的循环周期，然后return等待下次循环。如果我的描述无法让你理解，那么下面的一个小例子应该能帮助你。 

    
    virtual void service()
        {
            int lengh=sizeof(tune)/sizeof(tune[0]);
            noTone(_tonePin);
            for(int i=state;i<lengh;i++){
                tone(_tonePin,tune[i]);
                state=x+1;
                /**设置该Process对象新的执行周期，
                这样在设置的这个新周期时间之后都会再次调用该对象的service()方法**/
                setPeriod(400*durations[i]);  
                return;
            }
            state=0;
            setPeriod(5000);
        }

 对于这种所有过程代码都写在service()方法的案例应该比较容易理解，然而我在实际的应用中可能 会在service()方法中顺序执行多个方法，这些被调用的方法可能会有不同的延迟需要，这样想保存运行状态就会比较复杂了，我们需要给不同的方法定义一种状态，这样当service()方法再次被调用的时候我就能知道该从哪个方法开始执行了，就像下面这个例子一样处理： 

    
    //可以先定义一个状态的枚举类，定义出所有的状态
    typedef enum processState
    {
        STATE_F1,
        STATE_F2,
        STATE_F3,
    ...etc
    } processState_t;
    class toneProcess : public process
    {
            toneProcess(Scheduler &manager, ProcPriority pr, unsigned int period)
            :  Process(manager, pr, period)
            {
                state = STATE_F1; //initialize the current state
            }
            //在每次进入到service()方法的时候都检查一下运行状态，确定本次需要执行哪个方法
            virtual void service() override {
                switch(state) {
                    case STATE_F1:
                        function1();
                        break;
                   case STATE_F2:
                        function2();
                        break;
                   case STATE_F3:
                        function3();
                        break;
            }
            void function1(){
                Serial.println("this is function1");
                //start delay
                setPeriod(500); // Will resume at function 2 in 500ms
                state = STATE_F2; //state transition to state 2
            }
    }
    private:
    processState_t state;
    };
{% endraw %}
