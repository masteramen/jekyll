---
layout: post
title:  "org.apache.commons.io——FileUtils学习笔记"
title2:  "org.apache.commons.io——FileUtils学习笔记"
date:   2017-01-01 23:52:20  +0800
source:  "https://www.jfox.info/orgapachecommonsiofileutils%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0.html"
fileName:  "20170101040"
lang:  "zh_CN"
published: true
permalink: "2017/orgapachecommonsiofileutils%e5%ad%a6%e4%b9%a0%e7%ac%94%e8%ae%b0.html"
---
{% raw %}
FileUtils类的应用

1、写入一个文件；

2、从文件中读取；

3、创建一个文件夹，包括文件夹；

4、复制文件和文件夹；

5、删除文件和文件夹；

6、从URL地址中获取文件；

7、通过文件过滤器和扩展名列出文件和文件夹；

8、比较文件内容；

9、文件最后的修改时间；

10、计算校验和。

一、 复制文件或文件夹方法：

示例：

     1 public class CopyFileorDirectory {
     2     public static void main(String[] args) throws Exception { 3 File file1 =new File("path1"); 4 File file2 =new File("path2"); 5 File file3 =new File("path3"); 6 File file4 =new File("path4"); 7 File file5 =new File("path5"); 8 //将文件复制到指定文件夹中,保存文件日期的时间。 9 // 该方法将指定源文件的内容复制到指定目标目录中相同名称的文件中。 10 // 如果不存在，则创建目标目录。如果目标文件存在，则该方法将覆盖它。 11 FileUtils.copyFileToDirectory(file1,file2);//文件不重命 12 //将文件复制到一个新的地方(重命名文件)并保存文件日期的时间。 13  FileUtils.copyFile(file1,file3); 14 15 //复制文件夹到指定目录下,如果指定目录不存在则创建 16  FileUtils.copyDirectoryToDirectory(file2,file4); 17 18 //复制文件夹到指定目录下并重命名 19  FileUtils.copyDirectory(file4,file5); 20 21 //该方法将指定的源目录结构复制到指定的目标目录中。 22  FileUtils.copyDirectory(file4,file5, DirectoryFileFilter.DIRECTORY); 23 24 // 复制文件夹下第一级内容中指定后缀文件 25 IOFileFilter txtSuffixFilter = FileFilterUtils.suffixFileFilter(".txt"); 26 IOFileFilter txtFiles = FileFilterUtils.and(FileFileFilter.FILE, txtSuffixFilter); 27  FileUtils.copyDirectory(file4,file5, txtFiles); 28 29 // 复制文件目录结构及文件夹下第一级目录内指定后缀文件 30 FileFilter filter = FileFilterUtils.or(DirectoryFileFilter.DIRECTORY, txtFiles); 31 FileUtils.copyDirectory(file4,file5, filter,false);//preserveFileDate参数默认为true。 32 33 //将字节从URL源复制到文件目的地。如果它们还不存在，则将创建到目的地的目录。如果已经存在，文件将被覆盖。 34 URL source = new URL("http://imgsrc.baidu.com/baike/pic/ewe.jpg"); 35 FileUtils.copyURLToFile(source,file5,1000,1000); 36 37 // 等待NFS传播文件创建，并强制执行超时。该方法重复测试File.exists()，直到它返回true，或直到秒内指定的最大时间。 38 File file = new File("/abc/"); 39 boolean d = FileUtils.waitFor(file,100); 40  System.out.println(d); 41  } 42 }

 二、删除文件或文件方法

     1 public class FileorDirectoryDelete {
     2     public static void main(String[] args) throws Exception{ 3 File file = new File("path1"); 4 File directory = new File("path2"); 5 //递归删除一个目录(包括内容)。 6  FileUtils.deleteDirectory(directory); 7 8 //删除一个文件，不会抛出异常。如果文件是一个目录，删除它和所有子目录。 9  FileUtils.deleteQuietly(file); 10 11 //清理内容而不删除它。 12  FileUtils.cleanDirectory(directory); 13 14 //删除一个文件，会抛出异常 15 //如果file是文件夹，就删除文件夹及文件夹里面所有的内容。如果file是文件，就删除。 16 //如果某个文件/文件夹由于某些原因无法被删除，会抛出异常 17  FileUtils.forceDelete(file); 18  } 19 }

三、创建目录

     1 public class CreatDirectory {
     2     public static void main(String[] args) throws Exception { 3 File file = new File("path"); 4 //创建一个文件夹，如果由于某些原因导致不能创建，则抛出异常 5 //一次可以创建单级或者多级目录 6 FileUtils.forceMkdir(new File("/Users/wuguibin/Downloads/folder")); 7 //为指定文件创建文件的父级目录 8  FileUtils.forceMkdirParent(file); 9  } 10 }

四、移动文件或文件夹

    //移动文件夹,并重新命名
    FileUtils.moveDirectory(new File("/Users/Downloads/file1"),
           new File("/Users/Downloads/file2/file3")); //移动文件夹，并给定是否重命名 FileUtils.moveDirectoryToDirectory(new File("/Users/Downloads/file1"), new File("/Users/Downloads/file2/"),false);
    //移动文件到指定文件夹中,并重新命名 FileUtils.moveFile(file1,new File("/Users/Downloads/海葡萄.jpen"));
    //移动文件到指定文件夹中，并给定是否创建文件夹 FileUtils.moveFileToDirectory(new File("/Users/Downloads/海葡萄.jpeg"), new File("/Users/Downloads/file2"),false);

五、判断文件是否相同或包含关系、获取文件或文件夹大小

    //确定父目录是否包含指定子元素(一个文件或目录)。即directory是否包含file2,在比较之前，文件是标准化的。
    boolean a = FileUtils.directoryContains(directory,file2);
    //比较两个文件的内容，以确定它们是否相同。
    boolean b = FileUtils.contentEquals(file1, file2)
    

//获取指定文件或文件夹大小，有可能溢出，变为负值
long l = FileUtils.sizeOf(file1);
System.out.println(l+”KB”);
//获取指定文件或文件夹大小，不溢出
BigInteger bi= FileUtils.sizeOfAsBigInteger(file1);
System.out.println(bi+”kb”);

//递归地计算一个目录的大小(所有文件的长度的总和)。
//注意，sizeOfDirectory（）没有检测溢出，如果溢出发生，返回值可能为负。sizeOfDirectoryAsBigInteger()方法则不溢出。
FileUtils.sizeOfDirectory(file1);
FileUtils.sizeOfDirectoryAsBigInteger(file1);

 六、比较文件新旧

      //比较指定文件是否比参考文件创建或修改后时间晚
      boolean b = FileUtils.isFileNewer(file1,file2));
     
      //如果指定的文件比指定的日期更新。
      SimpleDateFormat date = new SimpleDateFormat("yyyy/MM/dd"); String date1 = "2017/06/20"; boolean c = FileUtils.isFileNewer(file1,date.parse(date1)); boolean d = FileUtils.isFileNewer(file1,23243); //指定文件创建或修改后的时间是否比参考文件或日期早 FileUtils.isFileOlder(file1,232434); FileUtils.isFileOlder(file1,System.currentTimeMillis());

七、写入文件

     //把集合里面的内容写入文件，以指定字符串结束写入
    //void writeLines(File file,Collection<?> lines,String lineEnding,boolean append)
    ArrayList<String> list = new ArrayList<>();
     String str1 = "Java"; String str2 = "JSP"; list.add(str1); list.add(str2); FileUtils.writeLines(file8,"GBK",list,"java",true);
    //把字符串写入文件 //参数1：需要写入的文件，如果文件不存在，将自动创建。 参数2：需要写入的内容 //参数3：编码格式 参数4：是否为追加模式（ ture: 追加模式，把字符串追加到原内容后面） String data1 = "认真"; FileUtils.writeStringToFile(file,data1, "UTF-8", true); //把字节数组写入文件 byte [] buf = {13,123,34}; System.out.println(new String(buf)); FileUtils.writeByteArrayToFile(file13,buf,0,buf.length,true);

八、读取文件及获取输入输出流

     //将文件的内容读入一个字符串中。
     String str =  FileUtils.readFileToString(file,"UTF-16" ); FileUtils.readFileToByteArray(file); //把文件读取到字节数组里面 byte[] readFileToByteArray(final File file) //把文件读取成字符串 ；Charset encoding：编码格式 String readFileToString(final File file, final Charset encoding) //把文件读取成字符串集合 ；Charset encoding：编码格式  List<String> list4 =FileUtils.readLines( new File("/Users/Shared/笔记/java.txt"),"UTF-8"); Iterator it = list4.iterator(); while (it.hasNext()){ Object obj=it.next(); System.out.println(obj); } //获取输入流 FileUtils.openInputStream(file); //获取输出流 FileUtils.openOutputStream(file);
{% endraw %}
