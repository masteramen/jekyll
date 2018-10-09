---
layout: post
title:  "IO(File 递归)"
title2:  "IO(File 递归)"
date:   2017-01-01 23:50:43  +0800
source:  "https://www.jfox.info/iofile-%e9%80%92%e5%bd%92.html"
fileName:  "20170100943"
lang:  "zh_CN"
published: true
permalink: "2017/iofile-%e9%80%92%e5%bd%92.html"
---
{% raw %}
**File概述** java.io.File类:文件和目录路径名的抽象表示形式。  用来描述电脑中文件,文件夹,以及路径类  **常用的3个和File有关的单词:** file:文件 directory:文件夹(目录) path:路径 File是一个与系统无关的类

File类的3个重载的构造方法路径: window系统的目录分隔符是一个 java中的目录分隔符是:或者/ **路径的分类**: **绝对路径**:以盘符开始的路径 例如:D:ase20170514day10 D:Work_EE_266day10src **相对路径:**相对于当前项目来说,路径编写的时候可以省略盘符到项目之间的路径 D:Work_EE_266day10–>src  注意:路劲不区分大小写的 File(File parent, String child) 传递路径,传递 File 类型父路径,字符串类型子路径 好处:父路径是 File 类型,父路径可以直接调用 File 类的方法 File(String parent, String child) 传递路径,传递字符串类型父路径,字符串类型的子路径 好处:单独操作父路径和子路径,使用起来比较灵活,可以把路径单独作为参数传递过来 File(String pathname) 传递路径名:可以写文件夹,也可以写到一个文件 c:abc c:abcDemo.java 路径存不存在都可以创建,路径不区分大小写

     1publicstaticvoid main(String[] args) {
     2/* 3         * static String pathSeparator 与系统有关的路径分隔符，为了方便，它被表示为一个字符串。 
     4         * static char pathSeparatorChar  与系统有关的路径分隔符。 
     5         * static String separator  与系统有关的默认名称分隔符，为了方便，它被表示为一个字符串。 
     6         * static char separatorChar  与系统有关的默认名称分隔符。 
     7*/ 8         String pathSeparator = File.pathSeparator;
     9         System.out.println(pathSeparator);//路径分隔符 windows 分号; linux 冒号:1011         String separator = File.separator;
    12         System.out.println(separator);//目录名称分隔符windows 反斜杠  linux 正斜杠/1314/*15         * System类中的方法
    16         * static String getProperty(String key) 获取指定键指示的系统属性。 
    17         * file.separator 文件分隔符（在 UNIX 系统中是“/”） 
    18         * path.separator 路径分隔符（在 UNIX 系统中是“:”） 
    19         * line.separator 行分隔符（在 UNIX 系统中是“/n”） 
    20*/21         System.out.println(System.getProperty("file.separator"));
    22         System.out.println(System.getProperty("line.separator"));
    23         System.out.println(System.getProperty("path.separator"));
    24     }

**File类的创建和删除功能**  File 类的删除功能 boolean delete() 删除文件或者文件夹,在 File 构造方法中给出 删除成功返回 true,删除失败返回 false(不存在,文件夹中有内容) 删除方法不走回收站,直接从硬盘删除 删除有风险,运行需谨慎   **File 创建文件夹功能** boolean mkdir() 只能创建单层文件夹 boolean mkdirs() 既能创建单层文件夹,又能创建多层文件夹 创建的路径也在 File 构造方法中给出 如果文件夹已经存在,不在创建   **File 创建文件的功能** boolean createNewFile() 创建的文件路径和文件名,在 File 构造方法中给出 如果文件已经存在,不在创建返回 false 只能创建文件,不能创建文件夹(看类型,不要看后缀) 创建文件夹的路径,必须存在 **File类的判断功能 **  boolean isDirectory() 判断 File 构造方法中封装的路径是不是文件夹 如果是文件夹就返回 true,如果不是文件夹就返回 false boolean isFile() 判断 File 构造方法中封装的路径是不是文件 boolean exists() 判断 File 构造方法中封装路径是否存在 存在就返回 true,不存在就返回 false  File类的获取功能 String getParent() 返回 String 对象 File getParentFile() 返回 File 对象 获取父路径,返回的是文件末尾的父路径  long length() 返回路径中表示的文件的字节数,文件夹没有大小  String getPath() 将此抽象路径名转换为一个路径名字符串。 和 toString 一样  String getName() 返回路径中表示的文件或者文件夹名 获取路径中最后部分的名字  File getAbsoluteFile() 返回此抽象路径名的绝对路径名形式。 String getAbsolutePath() 返回此抽象路径名的绝对路径名字符串。 获取绝对路径   **遍历目录的方法list和listFiles** 注意事项: 1.被遍历的路径只能是一个目录 2.被遍历的目录必须存在 否则就会抛空指针异常  static File[] listRoots() 获取系统中所有根目录  File[] listFiles() 获取到 File 构造方法中封装的路径中的文件和文件夹名(遍历一个目录) 返回的是目录或者文件的全路径  String[] list() 获取到 File 构造方法中封装的路径中的文件和文件夹名(遍历一个目录) 返回的只有名字  **递归** 递归:方法自己调用自己 **分类:** 递归分为两种，直接递归和间接递归。 直接递归称为方法自身调用自己。间接递归可以A方法调用B方法，B方法调用C方法，C方法调用A方法。  **注意：** 1.递归一定要有条件限定，保证递归能够停止下来，否则会发生栈内存溢出。 2.在递归中虽然有限定条件，但是递归次数不能太多。否则也会发生栈内存溢出。 3.构造方法,禁止递归

     1 使用递归计算1-n之间的和
     2       n + (n-1)+ (n-2)+(n-3)+...+1
     3       5 +(5-1)+(4-1)+(3-1)+(2-1)
     4       结束条件:n=1的时候结束
     5       方法自己调用自己目的:获取n-1,获取到n=1的时候结束
     6publicstaticint DGSum(int n){
     7//添加结束条件 8if(n==1){
     9return 1;
    10        }
    11return n+DGSum(n-1);
    12    } 
    1314使用递归计算阶乘
    15privatestaticlong DGJC(int n) {
    16//递归的结束条件 n==117if(n==1){
    18return 1;
    19        }
    20return n*DGJC(n-1);
    21    }
    2223使用递归计算斐波那契数列    
    24privatestaticint fbnq(int month) {
    25//结束条件如果month是1,2直接返回126if(month==1 || month==2){
    27return 1;
    28        }
    29//3月以上:兔子数量是前两个月之和30return fbnq(month-1)+fbnq(month-2);
    31     } 

**文件过滤器** 文件的过滤器: 需求:遍历hello文件夹,只获取文件夹中的.java结尾的文件 c:hello c:hellodemo.txt c:helloHello.java  在File类中listFiles()方法是遍历文件夹的方法 有两个和 listFiles重载的方法,参数传递的就是过滤器 File[] listFiles(FileFilter filter)  File[] listFiles(FilenameFilter filter) 返回抽象路径名数组，这些路径名表示此抽象路径名表示的目录中满足指定过滤器的文件和目录。  发现方法的参数FileFilter和FilenameFilter是接口 所有我们需要自己定义接口的实现类,重写接口中的方法accept,实现过滤功能

     1publicclass FileFilterImpl implements FileFilter{
     2/* 3     * 实现过滤的方法:
     4        1.把传递过来的路径pathname,变成字符串
     5            Stirng s  = pathname.toString(); "c:hellodemo.txt"
     6            String s  = pathname.getPaht(); "c:hellodemo.txt"
     7            String s = pathname.getName(); "demo.txt"
     8        2.使用String类中的方法endsWith判断字符串是否以指定的字符串结尾
     9            boolean b = s.endsWith(".java");
    10            return b;
    11*/12    @Override
    13publicboolean accept(File pathname) {
    14/*String s = pathname.getName();
    15        boolean b = s.endsWith(".java");
    16        return b;*/17return pathname.getName().toLowerCase().endsWith(".java");
    18    }
    19}
    20publicclass FilenameFilterImpl implements FilenameFilter{
    2122    @Override
    23publicboolean accept(File dir, String name) {
    24return name.toUpperCase().endsWith(".JAVA");
    25    }
    2627 }

**断点调试** debug断点调试 f6:逐行执行 f5:进入到方法中 f7:结束方法 f8:跳到下一个断点 watch:捕获
{% endraw %}
