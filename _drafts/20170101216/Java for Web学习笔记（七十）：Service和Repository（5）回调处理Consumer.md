---
layout: post
title:  "Java for Web学习笔记（七十）：Service和Repository（5）回调处理Consumer"
title2:  "Java for Web学习笔记（七十）：Service和Repository（5）回调处理Consumer"
date:   2017-01-01 23:55:16  +0800
source:  "http://www.jfox.info/javaforweb%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0%e4%b8%83%e5%8d%81service%e5%92%8crepository5%e5%9b%9e%e8%b0%83%e5%a4%84%e7%90%86consumer.html"
fileName:  "20170101216"
lang:  "zh_CN"
published: true
permalink: "javaforweb%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0%e4%b8%83%e5%8d%81service%e5%92%8crepository5%e5%9b%9e%e8%b0%83%e5%a4%84%e7%90%86consumer.html"
---
{% raw %}
Consumer可以作为回调函数使用，很是方便，在接下来的学习中会使用到，我们先了解一下Consumer是什么。

## 基本概念

Predicate和Consumer在Java8提供，更多的是一个概念，场景是如果怎么怎么样（predicate），那么怎么怎么做（consumer）。具体的可以去阅读javadoc。我们通过一个小例子来学。

 这是个计算学费的小例子，如果学生成绩达到某个水平，就可以享有某种折扣。 （类似补习班的费用，公知和媒体以及一堆猪头在大力叫嚷，千方百计地降低公共教育的质量，然后一堆补习班，托管班，背后都是巨大的利益）

## 小例子

小例子为提供根据学生的成绩计算费用。

    public class PCTest {
        // 【1】学费类: Student -》 提供简单的根据成绩计算费用的类。
        public static class Student{
            String name;
            Double grade;
            Double feeDiscount = 0.0;
            Double baseFee = 20000.0;
    
            public Student(String name, Double grade) {        
                this.name = name;
                this.grade = grade;
            }        
    
            public void printFee(){
                Double fee = baseFee - ((baseFee * feeDiscount) / 100);
                System.out.println(name + "'s fee after discount(" + feeDiscount + "): " + fee);
           }
        }
    
        //【2】Predicate和Consumer的使用：student如果在某个条件predicate.test()成立，就执行consumer.accept()
        public static void updateStudentFee(Student student, Predicate<Student> predicate, Consumer<Student> consumer){
            if(predicate.test(student))
                consumer.accept(student);
        }
    
        //（方式1）实现Predicate和Consumer，这两个接口也比较简单
        //（方式1.1）实现Predicate接口，具体需要实现条件判断test()方法
        public static class MyPredicate implements Predicate<Student>{
            @Override
            public boolean test(Student t) {            
                return t.grade >= 8.0;
            }        
        }
    
        //（方式1.2）实现Consumer接口，具体需要实现接纳的处理accept()方法    
        public static class MyConsumer implements Consumer<Student>{
            @Override
            public void accept(Student t) {
                t.feeDiscount = 50.0;
            }
        }
    
        //（方式3）方法实现费率设置的处理
        public void mySetDiscount(Student student){
            student.feeDiscount = 10.0;
        }
    
        public static void main(String[] args) {
            //【测试1】传统的书写方式
            Predicate<Student>  p = new MyPredicate();
            Consumer<Student> c = new MyConsumer();
            Student student1 = new Student("Rajat", 8.5);
            updateStudentFee(student1, p, c);
            student1.printFee();
    
            //【测试2】lambada表达方式
            Student student2 = new Student("Ashok", 9.5);
            updateStudentFee(student2, student -> student.grade >8.5, student -> student.feeDiscount = 30.0);
            student2.printFee();
    
            //【测试3】Method References方式，具体可参见 Filter（2）：处理异步请求#再看一个小例子 中的说明
            Student student3 = new Student("Test", 9.0);
            PCTest test = new PCTest();
            updateStudentFee(student3, p, test::mySetDiscount);
            student3.printFee();
        }
    }

这更多的是概念的封装，只要明确如果怎样就怎么处理。
{% endraw %}
