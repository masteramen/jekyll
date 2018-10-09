---
layout: post
title:  "瞎扯: 让 CPU 占用率呈正弦变化"
title2:  "瞎扯 让 CPU 占用率呈正弦变化"
date:   2017-01-01 23:50:59  +0800
source:  "https://www.jfox.info/%e7%9e%8e%e6%89%af-%e8%ae%a9-cpu-%e5%8d%a0%e7%94%a8%e7%8e%87%e5%91%88%e6%ad%a3%e5%bc%a6%e5%8f%98%e5%8c%96.html"
fileName:  "20170100959"
lang:  "zh_CN"
published: true
permalink: "2017/%e7%9e%8e%e6%89%af-%e8%ae%a9-cpu-%e5%8d%a0%e7%94%a8%e7%8e%87%e5%91%88%e6%ad%a3%e5%bc%a6%e5%8f%98%e5%8c%96.html"
---
{% raw %}
# 瞎扯: 让 CPU 占用率呈正弦变化 


让 CPU 占有率呈正弦变化是《编程之美》书中的一道题。这道题早在两年多前笔者参与校招时候就见过，一直没有去实践。今天早上抽时间实现了一下，在本文介绍一下思路，其实这个东西真的很简单，并没有什么神奇的东西。

# 来个简单的例子

笔者是电子工程相关专业出身，几乎所有相关专业的本科生都做过这么一道题：利用单片机和数模转换芯片来输出正弦波、三角波和其他波形。考虑到读者大部分并不是硬件相关专业的，因此简单介绍一下。

单片机可以理解为一块可编程的没有操作系统的处理器。在这里暂时忽略掉其他细节，可以理解为在给单片机上电以后，它就会根据用户烧录进去的C语言程序开始跑，从 main 函数开始跑，一直跑到结束。对于要持续输出正弦波这问题，一般会利用单片机内部的定时器去实现，这是基于硬件的，但在这里主要探讨程序方面的因素，笔者只考虑利用软件去解决这个问题。

知道单片机是个什么东西了以后，输出正弦值的程序大概长这样：

    void outputSin() {
        double angle = 0;
        while (true) {
            double sinValue = sin(angle);
            //由于正弦的值域为-1~1，因此需要对sinValue处理，例如值域变为0~2：
            sinValue += 1;
            //操作io口去输出模拟电量对应的数字值
            output(sinValue);
            //累加角度
            angle += 1.0 / 180.0 * M_PI;
            //跑for循环去延时
            for (int i = 0; i < 1000000; i++) ;
        }
    }

调整电压输出到目标值后需要延时一段时间，然后再调整到下一个电压值。在不需要 CPU 计算时，使用了无意义的 for 循环来消耗时间。这时候，输出的值大概长这样(图是随手搜的，忽略坐标轴)：

在需要电压保持恒定的那一段时间里，使用无意义的代码去延时，看上去很傻，但事实上，处理器一旦开始跑，是不能停的，所以它的占用率一直都会是 100%。

# CPU占用率

在认知上，这跟我们使用的手机、电脑等设备有明显区别。确实两者在硬件上是有区别，但有一点是一样的，处理器一个核心只有两种状态，100% 和 0%，要么在干活，要么没在干活(断电了或者忙别的去了)。所谓占用率百分比，只是在这个周期里干活的时间的百分比罢了。

这个概念想必大多数读者都清楚，我们用的操作系统是分时复用的操作系统，其内核会管理各个进程的 CPU 时间，占用率是根据活跃时间计算出来的。知道 CPU 占用率是怎么来的的时候，剩下的工作就很简单了。根据正弦值来计算程序活跃和不活跃的时间就可以了。

Xcode 中 CPU 曲线的更新时间是1秒，因此只要把握操作1秒内进程活跃时间和不活跃时间的比例，就可以操作 CPU 使用率了。

文章开头的图的完整代码如下：

    #import <UIKit/UIKit.h>
    #import <dispatch/dispatch.h>
    dispatch_queue_t queue;
    void step(double busyValue, double sleepValue) {
        __block bool stopFlag = false;
        dispatch_async(queue, ^{
            usleep(busyValue * 1000000);
            stopFlag = true;
        });
        while (!stopFlag) ;
        usleep(sleepValue * 1000000);
    }
    int main(int argc, char * argv[]) {
        queue = dispatch_queue_create("worker", DISPATCH_QUEUE_SERIAL);
        double angle = 0;
        while (true) {
            double busyValue = (sin(angle) + 1) / 2;
            double sleepValue = 1 - busyValue;
            step(busyValue, sleepValue);
            angle += 10.0 / 180.0 * M_PI;
        }
        return 0;
    }

# 结语

写了一半实在是写不下去了，完全没有技术含量是不是。对了，这个可以拿去画爱心表白，知乎上有代码。

Thanks for reading.

All the best wishes for you! 💕
{% endraw %}
