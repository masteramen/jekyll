---
layout: post
title:  "Java 机试题：解析命令行参数"
title2:  "Java 机试题：解析命令行参数"
date:   2017-01-01 23:52:22  +0800
source:  "https://www.jfox.info/java%e6%9c%ba%e8%af%95%e9%a2%98%e8%a7%a3%e6%9e%90%e5%91%bd%e4%bb%a4%e8%a1%8c%e5%8f%82%e6%95%b0.html"
fileName:  "20170101042"
lang:  "zh_CN"
published: true
permalink: "2017/java%e6%9c%ba%e8%af%95%e9%a2%98%e8%a7%a3%e6%9e%90%e5%91%bd%e4%bb%a4%e8%a1%8c%e5%8f%82%e6%95%b0.html"
---
{% raw %}
### 一、根据下面的代码，实现 Arguments 类。

如果有需要，你可以根据自己喜好，创建另外的类来帮助实现 `Arguments`。

    /**
     * 计算矩形面积
     */
    public class GetRectangleArea {
    
        public static void main(String[] args) {
        
            Arguments arguments = new Arguments();
            arguments.parse(args);
            
            double width = arguments.getDouble("w");
            double height = arguments.getDouble("h");
            
            System.out.println("矩形的面积为：" + (width * height));
        }
    }

执行结果：

    $ java GetRectangleArea -w 20 -h 30
    矩形的面积为：600.0

### 二、为 Arguments 类添加自我解释功能

当用户没有输入任何参数时，打印帮助信息并退出。

代码示例：

    public static void main(String[] args) {
    
        Arguments arguments = new Arguments();
        arguments.addArg("矩形宽度", "w");
        arguments.addArg("矩形高度", "h");
        arguments.parse(args);
        
        double width = arguments.getDouble("w");
        double height = arguments.getDouble("h");
        
        System.out.println("矩形的面积为：" + (width * height));
    }
    

执行结果：

    $ java GetRectangleArea
    参数：
        -w 矩形宽度
        -h 矩形高度

### 三、允许参数别名

一个参数可以有简称（如 `-w`），也可以有全称（如 `--width`）

代码示例：

    public static void main(String[] args) {
    
        Arguments arguments = new Arguments();
        arguments.addArg("矩形宽度", "w", "width");
        arguments.addArg("矩形高度", "h", "height");
        arguments.parse(args);
        
        double width = arguments.getDouble("width");
        double height = arguments.getDouble("h");
        
        System.out.println("矩形的面积为：" + (width * height));
    }
    

执行结果：

    $ java GetRectangleArea -w 20 --height 30
    矩形的面积为：600.0
{% endraw %}
