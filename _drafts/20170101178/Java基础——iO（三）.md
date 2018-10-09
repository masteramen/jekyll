---
layout: post
title:  "Java基础——iO（三）"
title2:  "Java基础——iO（三）"
date:   2017-01-01 23:54:38  +0800
source:  "https://www.jfox.info/java%e5%9f%ba%e7%a1%80io%e4%b8%89.html"
fileName:  "20170101178"
lang:  "zh_CN"
published: true
permalink: "2017/java%e5%9f%ba%e7%a1%80io%e4%b8%89.html"
---
{% raw %}
演示：PipedInputStream  , PipedOutputStream

注意：管道流本身就不建议在一个线程中使用，这是因为向输出流中写的数据，都会存到输入流内部的一个1024字节大小的数组中，如果写的内容超过这个数组的大小，而且没有被输入流读取的话，输出流所在的线程就会等待，如果这时是在同一个线程中，该线程就会死锁，不推荐在同一个线程中使用。（API）

    import java.io.IOException;
    import java.io.PipedInputStream;
    import java.io.PipedOutputStream;
    
    publicclass Test17 {
        publicstaticvoid main(String[] args) throws IOException,
                InterruptedException {
            Sender sender = new Sender();
            Receiver receiver = new Receiver();
    
            PipedOutputStream out = sender.getOut();
            PipedInputStream in = receiver.getIn();
    
            in.connect(out);
            // out.connect(in); //这样也可以
            sender.start();
    
            Thread.sleep(10);
            receiver.start();
        }
    }
    
    // 发送者class Sender extends Thread {
        private PipedOutputStream out = new PipedOutputStream();
    
        publicvoid run() {
            try {
                int i = 1;
                while (true) {
                    Thread.sleep(2000);
                    String msg = "你好,这是发送端发的第" + i++ + "条信息";
                    out.write(msg.getBytes());
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    
        public PipedOutputStream getOut() {
            returnthis.out;
        }
    }
    
    // 接收者class Receiver extends Thread {
        private PipedInputStream in = new PipedInputStream();
    
        publicvoid run() {
            try {
                while (true) {
                    byte[] buff = newbyte[1024];
                    int len = in.read(buff);
                    String str = new String(buff, 0, len);
                    System.out.println(str);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    
        public PipedInputStream getIn() {
            returnthis.in;
        }
    }
    
    // Pipe closed 发生在管道关了,发送者还在发的情况下

**二、文件切割和合并**

    publicstaticvoid merget2() throws Exception {
            OutputStream out=new FileOutputStream("c:/src_new.zip");
            BufferedOutputStream bos=new BufferedOutputStream(out);
            
            for(int i=1;i<=20;i++){
                InputStream in=new FileInputStream("c:/src_"+i);
                byte [] buff=newbyte[in.available()];    
                in.read(buff);
                bos.write(buff);    
                in.close();    
            }
            
            bos.close();
            
            System.out.println("合并成功");
        }
        
        
        publicstaticvoid merge()throws Exception{
            OutputStream out=new FileOutputStream("c:/src_new.zip");
            for(int i=1;i<=20;i++){
                
                InputStream in=new FileInputStream("c:/src_"+i);
                
                byte [] buff=newbyte[in.available()];
                
                in.read(buff);
                out.write(buff);
                
                in.close();
                
            }
            
            out.close();
            
            System.out.println("合并成功");
        }

**四、File 类概述**

流只能操作数据

File 类 是IO包中,唯一代表磁盘文件本身的类

File 定义了一些与平台无关的方法来操作文件

File: 文件和目录路径名的抽象表示形式。//路径也是一种文件

用来将文件或文件夹封装成对象

方便对文件及文件夹的属性信息进行操作

File对象.经常做为参数传给流的构造函数

File类不能访问文件内容,即不能从文件中读数据,也不能写入数据,它只能对文件本身的属性进行操作

**五、File 类的常见操作**

boolean createNewFile() //创建一个新文件,成功返回true ,否则返回false ,如果文件已经存在,则返回false,和流不一样,流是覆盖

mikdir()  mikdirs  //创建目录,后者可以创建多级目录

boolean delete ()  //删除 删除此抽象路径名表示的文件或目录。如果此路径名表示一个目录，则该目录必须为空才能删除。 否则返回false

void deleteOnExit() //在虚拟机终止时,删除文件或目录 注意它的返回类型是void 因为虚拟机都终止了,当然要返回值也没用了

exists() // 测试此抽象路径名表示的文件或目录是否存在。

isDirectory() // 判断是否是目录

isFile() //判断是否是文件

isHidden() //判断是否是隐藏文件

    staticvoid fileDemo() throws IOException{
            File f1=new File("1.txt"); //当前路径下
            File f2=new File("c:2.txt");
            File f3=new File("c:","3.txt");
            File f4=new File("c:");
            File f5=new File(f4,"5.txt");  //File(File parent,String child)/*f1.createNewFile();
            f2.createNewFile();
            f3.createNewFile();
            System.out.println(f4.createNewFile());    //返回false
            f5.createNewFile();
    *//*    System.out.println(f1.delete());  //true
            System.out.println(f2.delete());  //true
            System.out.println(f3.delete());  //true
            System.out.println(f4.delete());  //false
            System.out.println(f5.delete());  //true
            *///System.out.println(    new File("c:/aaa").delete()); //(aaa是个文件夹)如果aaa下有内容,则返回false,否则返回true,并将文件夹删除/*    File f=new File("c:BBBSSS1.txtccdd");  //这样写,1.txt也会被做为文件夹的名称
            f.mkdirs();  //创建多级的时候,用mkdirs();
            
            new File("c:/forlder1").mkdir();  //只能创建一级目录
         *//*File ff=new File("c:不存在的文件.txt");
            System.out.println(ff.isDirectory()); //false
            System.out.println(ff.isFile()); //false
            System.out.println(ff.isHidden()); //false
            *//*    
            File ff=new File("c:不存在的文件.txt");
            ff.createNewFile();
            System.out.println(ff.isDirectory()); //false
            System.out.println(ff.isFile());  //true
            System.out.println(ff.isHidden()); //false
       */    
            
            File ff=new File("c:不存在的文件.txt");
            ff.mkdir();
            System.out.println(ff.isDirectory()); //true
            System.out.println(ff.isFile());  //false
            System.out.println(ff.isHidden()); //false
            
            //注意,对于还没有创建的文件,或文件夹,isDirectory,isFile 都会返回false 要想得到正确结果,必须先用 exists判断            
        }

**六、File 类获取文件信息类操作**

String getName(); //返回文件或目录的名称

String getParent(); //返回父目录的名字,没有则返回null

String getPath(); //返回路径字串 ??? 含文件名

String getAbsolutePath(); // 返回绝对路径名字符串

//File getAbsoluteFile(); //返回绝对路径名形式。等同于 new File(this.getAbsolutePath())

long length(); //返回文件长度,以字节为单位

static File[] listRoots() //列出可用的文件系统根 在windows下即列出C D E等盘符

String [] list()  //返回目录中的文件和目录 (即连文件名一起返回)(隐藏文件也会被返回)

String [] list(FilenameFilter filter) //返回经过指定过滤器过滤的文件和目录。

File [] listFiles() //返回当前目录下所有的文件

File[] listFiles(FilenameFilter filter)

    publicstaticvoid fileInfoDemo(){    
                    File f=new File("c:Test1.txt");
                    System.out.println("getName--"+f.getName()); //1.txt
                    System.out.println("getParent()--"+f.getParent()); //c:Test
                    System.out.println("getPath()--"+f.getPath()); //c:Test1.txt
                    System.out.println("getAbsolutePath--"+f.getAbsolutePath()); //c:Test1.txt
                    System.out.println("length()--"+f.length()); //1234                
                   File[] fileList=File.listRoots();
                   for(File file : fileList)  {     
                           System.out.println (file); //打印出 C:  D: 等               }
                }
    

     如果把上面的文件路径换成     File f=new File("1.txt"); //使用的是相对路径,则结果为:
                    getName--1.txt
                    getParent()--null
                    getPath()--1.txt
                    getAbsolutePath--C:workspaceLession211.txt
                    length()--0
                    A:
                    C:
                    D:
                    E:

    //例 显示全部staticvoid listDemo(){
        File f=new File("C:/文件夹A/大学毕业论文收集");
        String [] nameList=f.list();
            for(String str:nameList){
            System.out.println(str);
        }    
    }

    //例子,带过滤的staticvoid filterDemo(){
            File f=new File("C:/文件夹A/大学毕业论文收集/中文系");
            File [] fileList=f.listFiles(new FilenameFilter() {
        publicboolean accept(File dir, String name) {
            return !name.endsWith(".exe"); //只看exe文件        }
            });
            for (File item: fileList) {
            System.out.println(item.getName());
            }
    }

**七、递归操作**递归的查看目录中的内容

    publicstaticvoid main(String[] args) {
        recuDir(new File("C:作业8.13"));
    }
                
        staticvoid recuDir(File dir){
        System.out.println("------------------");
        File [] fileList= dir.listFiles();
                    
        for(File f:fileList){
            if(f.isDirectory()){
            recuDir(f);  //递归调用
            }else{
            System.out.println(f.getName());
            }
        }
    }

**八、RandomAccessFile**

java 语言中功能最丰富的文件访问类

支持 “随机访问” 方式

可以跳转到文件的任意位置读写数据

该类对象有个指示器,指向当前读写的位置,当读写n个字节后,文件指示器将指向这n个字节的下一个字节处

刚打开文件的时候,指示器指向指向文件开头,可以移动指示器到新的位置

在等长记录格式文件的随机读取时有极大优势,但它只限于操作文件,不能访问其他io设备,如网络,内存图像等

**RandomAccessFile的构造函数**

new RandomAccessFile(f,”rw”);  //读写方式 (如果文件不存在,会创建)

new RandomAccessFile(f,”r”);    //只读方式

    publicstaticvoid main(String[] args) throws IOException {
                    finalint LEN=8;
                    /*Student stu1=new Student(20,"cat");
                    Student stu2=new Student(21,"sheep");
                    Student stu3=new Student(15,"duck");
                    
                    RandomAccessFile r=new RandomAccessFile("c:/stu.txt","rw");
                    
                    r.write(stu1.name.getBytes());
                    r.writeInt(stu1.age);
                    
                    r.write(stu2.name.getBytes());
                    r.writeInt(stu2.age);
                    
                    r.write(stu3.name.getBytes());
                    r.writeInt(stu3.age);
                    
                    r.close();*/
                    
                    RandomAccessFile read=new RandomAccessFile("c:/stu.txt","rw");
                    
                    read.skipBytes(12);  //跳过第一个学生的信息,其中年龄是4个字节,姓名是8个字节
                    System.out.println("第二个学生的信息:");
                        
                    String str="";
                    for(int i=0;i<LEN;i++){
                        str+=(char)read.readByte();
                    }
                    System.out.println("name:"+str);
                    System.out.println("age:"+read.readInt());
                    
                    System.out.println("第一个学生的信息:");
                    read.seek(0);
                    str="";
                    for(int i=0;i<LEN;i++){
                        str+=(char)read.readByte();
                    }
                    System.out.println("name:"+str);
                    System.out.println("age:"+read.readInt());
                    
                    System.out.println("第三个学生的信息:");
                    read.skipBytes(12);
                    str="";
                    for(int i=0;i<LEN;i++){
                        str+=(char)read.readByte();
                    }
                    System.out.println("name:"+str);
                    System.out.println("age:"+read.readInt());
                    
                    read.close();
            
                }

**九、Properties 类详解**

Properties是 HashTable 的子类，它增加了将键和值保存到流中,或从流中读取的功能。如果要用 properties.store()方法存储其对象内容,则关键字和值必须是String型。可以从流中载入键值对信息 void load(InputStream inStream) 从输入流中读取属性列表（键和元素对）。Set<String> stringPropertyNames() 返回此属性列表中的键集。注意：尽量不要用中文

    publicstaticvoid main(String[] args) throws  IOException {
                Properties settings =new Properties();
                settings.load(new FileInputStream("c:/config.ini"));
                
                System.out.println(settings.getProperty("port"));  //8080
                    
                //从流中取
                Set<String> set=settings.stringPropertyNames(); //取所有属性for(String key:set){
                    System.out.println(key+":"+settings.getProperty(key));
                }
                
                //输入
                settings.setProperty("niceCat", "this is a niceCat"); 
                settings.store(new FileOutputStream("c:/config.ini"),"this is note");
                
                System.out.println("ok");
                
            }

 

  posted @ 
 2017-07-09 13:50[zzbd4444](https://www.jfox.info/go.php?url=http://www.cnblogs.com/1693977889zz/) 阅读( 
 …) 评论( 
 …)
{% endraw %}
