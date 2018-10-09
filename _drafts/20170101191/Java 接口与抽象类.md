---
layout: post
title:  "Java 接口与抽象类"
title2:  "Java 接口与抽象类"
date:   2017-01-01 23:54:51  +0800
source:  "https://www.jfox.info/java%e6%8e%a5%e5%8f%a3%e4%b8%8e%e6%8a%bd%e8%b1%a1%e7%b1%bb.html"
fileName:  "20170101191"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/java%e6%8e%a5%e5%8f%a3%e4%b8%8e%e6%8a%bd%e8%b1%a1%e7%b1%bb.html"
---
{% raw %}
如果你对接口和抽象类的使用场景比较模煳，这篇文章或许会对你有所帮助。

首先看抽象类，它介于普通类和接口之间，尽管在构建某些未实现方法的类时，很多时候 往往会去创建接口，但抽象类仍然很重要，因为你不可能总是使用纯接口。

## 一. 抽象类

“**在面向对象的概念中，我们知道所有的对象都是通过类来描绘的，但是反过来却不是这样。并不是所有的类都是用来描绘对象的，如果一个类中没有包含足够的信息来描绘一个具体的对象，这样的类就是抽象类。抽象类往往用来表征我们在对问题领域进行分析、设计中得出的抽象概念，是对一系列看上去不同，但是本质上相同的具体概念的抽象。**比如：如果我们进行一个图形编辑软件的开发，就会发现问题领域存在着圆、三角形这样一些具体概念，它们是不同的，但是它们又都属于形状这样一个概念，形状这个概念在问题领域是不存在的，它就是一个抽象概念。正是因为抽象的概念在问题领域没有对应的具体概念，所以用以表征抽象概念的抽象类是不能够实例化的。”

**抽象类的特征：**

1. 如果从一个抽象类继承，并想创建该类的对象，那么就必须全部实现此抽象类的所有抽象方法。如果不这样做（可以不做），那么继承后得到的便也是抽象类，且编译器会强制我们用**abstract**来修饰此类。
2. 我们也可以创建一个没有任何抽象方法的抽象类，用来阻止产生这个类的任何对象。
3. 抽象类可以有方法体，也就是实现的方法，

**来个例子：**
具体类：低级程序猿 高级程序猿
共性：姓名 工号 薪水
差异： 做事 奖金

    abstract class  Programmer{
        private String name;
        private String id;
        private int salary;
    
        public  Programmer(){}
    
        public  Programmer(String name,String id,int salary){
            this.name=name;
            this.id=id;
            this.salary=salary;
        }
        public void setname(String name){
            this.name=name;
        }
        public String getname(){
            return name;
        }
    
        public void setid(String id){
            this.id=id;
        }
        public String getid(){
            return id;
        }
    
        public void setsalary(int salary){
            this.salary=salary;
        }
        public int getsalary(){
            return salary;
        }
        public abstract void work();
    }
    
    class BasicProgrammer extends  Programmer{
        public BasicProgrammer(){}
        public BasicProgrammer(String name,String id,int salary){
            super(name,id,salary);
        }   
        public void work(){
            System.out.println("写曾删改查");
        }
    }
    
    class GoodProgrammer extends  Programmer{
        private int money;
    
        public Goodprogrammer() {}
        public GoodProgrammer(String name,String id,int salary,int money){
            super(name,id,salary);
            this.money=money;
        }
        public void setmoney(int money){
            this.money=money;
        }
        public int getmoney(){
            return money;
        }
        public void work(){
            System.out.println("写架构");
        }   
    }
    
    class AbstractTest{
        public static void main(String[] args){
    
        Programmer bp=new BasicProgrammer();
        bp.setname("Basicprogrammer");
        bp.setid("00531");
        bp.setsalary(8000);
        System.out.println(bp.getname()+"----"+bp.getid()+"----"+bp.getsalary());
    
        //这里不能向上转型，向上转型后不能调用子类特有的方法，多态的弊端
        GoodProgrammer gp=new GoodProgrammer();
        gp.setname("Goodprogrammer");
        gp.setid("00111");
        gp.setsalary(20000);
        gp.setmoney(10000);
        System.out.println(gp.getname()+"----"+gp.getid()+"----"+gp.getsalary()+"----"+gp.getmoney());
        }
    }

结果：
Basicprogrammer—-00531—-8000
Goodprogrammer—-00111—-20000—-10000

再加一句——–**在代码重构方面，抽象类很有用，因为它可以使我们很容易的将公共方法沿着继承层次结构向上移动**

## 二. 接口

**Java接口是一系列方法的声明，是一些方法特征的集合，一个接口只有方法的特征没有方法的实现，因此这些方法可以在不同的地方被不同的类实现，而这些实现可以具有不同的行为（功能）。**
这是之前对接口的描述，但Java8中添加了接口的新特性——–**接口的默认方法和静态方法**
Java 8使用两个新概念扩展了接口的含义：默认方法和静态方法。默认方法使得接口有点类似traits，不过要实现的目标不一样。默认方法使得开发者可以在 不破坏二进制兼容性的前提下，往现存接口中添加新的方法，即不强制那些实现了该接口的类也同时实现这个新加的方法。
默认方法和抽象方法之间的区别在于抽象方法需要实现，而默认方法不需要。接口提供的默认方法会被接口的实现类继承或者覆写，例子代码如下：

    private interface Defaulable {
        // Interfaces now allow default methods, the implementer may or 
        // may not implement (override) them.
        default String notRequired() { 
            return "Default implementation"; 
        }        
    }
    
    private static class DefaultableImpl implements Defaulable {
    }
    
    private static class OverridableImpl implements Defaulable {
        @Override
        public String notRequired() {
            return "Overridden implementation";
        }
    }

Defaulable接口使用关键字default定义了一个默认方法notRequired()。DefaultableImpl类实现了这个接口，同时默认继承了这个接口中的默认方法；OverridableImpl类也实现了这个接口，但覆写了该接口的默认方法，并提供了一个不同的实现。
Java 8带来的另一个有趣的特性是在接口中可以定义静态方法，例子代码如下：

    private interface DefaulableFactory {
        // Interfaces now allow static methods
        static Defaulable create( Supplier< Defaulable > supplier ) {
            return supplier.get();
        }
    }

下面的代码片段集成了默认方法和静态方法的使用场景：

    public static void main( String[] args ) {
        Defaulable defaulable = DefaulableFactory.create( DefaultableImpl::new );
        System.out.println( defaulable.notRequired() );
    
        defaulable = DefaulableFactory.create( OverridableImpl::new);
        System.out.println( defaulable.notRequired());
    }

这段代码的输出结果如下：
Default implementation
Overridden implementation
由于JVM上的默认方法的实现在字节码层面提供了支持，因此效率非常高。默认方法允许在不打破现有继承体系的基础上改进接口。该特性在官方库中的应用是：给java.util.Collection接口添加新方法，如stream()、parallelStream()、forEach()和removeIf()等等。
尽管默认方法有这么多好处，但在实际开发中应该谨慎使用：在复杂的继承体系中，默认方法可能引起歧义和编译错误。如果你想了解更多细节，可以参考官方文档。

**接口的特征：**

1. 
接口中的方法可以有参数列表和返回类型，但不能有任何方法体。

2. 
接口中可以包含字段，但是会被隐式的声明为 static 和 final 。

3. 
接口中的字段只是被存储在该接口的静态存储区域内，而不属于该接口。

4. 
接口中的方法可以被声明为 public 或不声明，但结果都会按照 public 类型处理。

5. 
当实现一个接口时，需要将被定义的方法声明为 public 类型的，否则为默认访问类型， Java 编译器不允许这种情况。

6. 
如果没有实现接口中所有方法，那么创建的仍然是一个接口。

7. 
扩展一个接口来生成新的接口应使用关键字 extends ，实现一个接口使用 implements 。

**例子：**
定义接口AreaInterface，其中有静态常量pai和求面积的抽象方法area（）。类Circle和类Triangle 实现了AreaInterface接口，即为接口中的抽象方法area（）编写了满足各自要求的方法体，分别求圆形和长方形的面积。

    public  interface  AreaInterface{
        public  double pai =Math.PI;
        public  double area();
    }
    
    public  class Circle implement  AreaInterface{
        private double r;
        public Circle(double x){
            r=x;
        }
        public double area() {
            return pai*r*r;
        }
        public String toString(){
            return "圆：r="+r+"tarea="+area();
        }    
    }
    
    public class Triangle implement AreaInterface{
        private double d;
        private double h;
        public Triangle(double d,double h){
            this.d=d;
            this.h=h;
        }
        public double area() {
            return d*h/2;
        }
        public String toString(){
        return "三角形：d="+d+";h="+h+"tarea="+area();
        }
     public static void main(String[] args) {
         System.out.println(new Triangle(12, 5).toString());
         System.out.println(new Circle(5).toString()); 
    }
    }
    结果：
    三角形：d=12.0;    h=5.0        area=30.0
    圆：r=5.0        area=78.53981633974483

## 三. 接口与抽象类的区别

**1.语法层面上的区别**

　　1）抽象类可以提供成员方法的实现细节，而接口中只能存在 public abstract (可省) 方法；

　　2）抽象类中的成员变量可以是各种类型的，而接口中的成员变量只能是 public static final (可省) 类型的；

　　3）接口中不能含有静态代码块以及静态方法，而抽象类可以有静态代码块和静态方法；

　　4）一个类只能继承一个抽象类，而一个类却可以实现多个接口。
![](/wp-content/uploads/2017/07/1499484276.png) 
 
   Paste_Image.png 
  
 

**2.设计层面上的区别**

　　1） **抽象类是对一种事物的抽象，即对类抽象，而接口是对行为的抽象。抽象类是对整个类整体进行抽象，包括属性、行为，但是接口却是对类局部（行为）进行抽象。**举个简单的例子，飞机和鸟是不同类的事物，但是它们都有一个共性，就是都会飞。那么在设计的时候，可以将飞机设计为一个类 Airplane，将鸟设计为一个类 Bird，但是不能将飞行 这个特性也设计为类，因此它只是一个行为特性，并不是对一类事物的抽象描述。此时可以将 飞行 设计为一个接口Fly，包含方法fly()，然后Airplane和Bird分别根据自己的需要实现Fly这个接口。然后至于有不同种类的飞机，比如战斗机、民用飞机等直接继承Airplane即可，对于鸟也是类似的，不同种类的鸟直接继承Bird类即可。从这里可以看出，继承是一个 “是不是”的关系，而 接口 实现则是 “有没有”的关系。如果一个类继承了某个抽象类，则子类必定是抽象类的种类，而接口实现则是有没有、具备不具备的关系，比如鸟是否能飞（或者是否具备飞行这个特点），能飞行则可以实现这个接口，不能飞行就不实现这个接口。

　　2） **设计层面不同，抽象类作为很多子类的父类，它是一种模板式设计。而接口是一种行为规范(契约)，它可以跨越不同的类，是一种辐射式设计。**什么是模板式设计？最简单例子，大家都用过ppt里面的模板，如果用模板A设计了ppt B和ppt C，ppt B和ppt C公共的部分就是模板A了，如果它们的公共部分需要改动，则只需要改动模板A就可以了，不需要重新对ppt B和ppt C进行改动。而辐射式设计，比如某个电梯都装了某种报警器，一旦要更新报警器，就必须全部更新。也就是说 对于抽象类，如果需要添加新的方法，可以直接在抽象类中添加具体的实现，子类可以不进行变更；而对于接口则不行，如果接口进行了变更，则所有实现这个接口的类都必须进行相应的改动。

## 四. 什么时候使用抽象类和接口

1. 如果你拥有一些方法并且想让它们中的一些有默认实现，那么使用抽象类。
2.如果你想实现多重继承，那么你必须使用接口。由于Java不支持多继承，子类不能够继承多个类，但可以实现多个接口。因此你就可以使用接口来解决它。
3.如果基本功能在不断改变，那么就需要使用抽象类。如果不断改变基本功能并且使用接口，那么就需要改变所有实现了该接口的类

　　下面看一个网上流传最广泛的例子（我没有想到比这个好的例子）：门和警报的例子：门都有open( )和close( )两个动作，此时我们可以定义通过抽象类和接口来定义这个抽象概念：

    abstract class Door {
        public abstract void open();
        public abstract void close();
    }

或者

    interface Door {
        public abstract void open();
        public abstract void close();
    }

但是现在如果我们需要门具有报警alarm( )的功能，那么该如何实现？下面提供两种思路：
1）将这三个功能都放在抽象类里面，但是这样一来所有继承于这个抽象类的子类都具备了报警功能，但是有的门并不一定具备报警功能；

　　2）将这三个功能都放在接口里面，需要用到报警功能的类就需要实现这个接口中的open( )和close( )，也许这个类根本就不具备open( )和close( )这两个功能，比如火灾报警器。

　　从这里可以看出， Door的open() 、close()和alarm()根本就属于两个不同范畴内的行为，open()和close()属于门本身固有的行为特性，而alarm()属于延伸的附加行为。因此最好的解决办法是单独将报警设计为一个接口，包含alarm()行为,Door设计为单独的一个抽象类，包含open和close两种行为。再设计一个报警门继承Door类和实现Alarm接口。

    interface Alram {
        void alarm();
    }
    
    abstract class Door {
        void open();
        void close();
    }
    
    class AlarmDoor extends Door implements Alarm {
        void oepn() {
          //....
        }
        void close() {
          //....
        }
        void alarm() {
          //....
        }
    }

**小结：**
**类是对事物的抽象**
**抽象类是对特定事物的抽象**
**接口是对抽象的抽象**
{% endraw %}
