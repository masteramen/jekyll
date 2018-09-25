---
layout: post
title: "Java 8 写入文件示例"
title2: "Java 8 write to file example"
date: 2018-08-25 10:09:02 +0800
source: "https://howtodoinjava.com/java8/java-8-write-to-file-example/"
fileName: "java-8-xie-ru-wen-jian-shi-li"
published: true
---

{% raw %}

## 1. Java 8 write to file using BufferedWriter

## 1. Java 8 使用 BufferedWriter 写入文件(zh_CN)

[BufferedWriter](https://docs.oracle.com/javase/8/docs/api/java/io/BufferedWriter.html) is used to write text to a character or byte stream. Before printing the characters, it stores the characters in buffer and print in bunches. Without buffering, each invocation of a print() method would cause characters to be converted into bytes that would then be written immediately to the file, which can be very inefficient.
[BufferedWriter]（https://docs.oracle.com/javase/8/docs/api/java/io/BufferedWriter.html）用于将文本写入字符或字节流。在打印字符之前，它将字符存储在缓冲区中并以串联方式打印。如果没有缓冲，每次调用print(）方法都会导致字符转换为字节，然后立即写入文件，这可能效率很低。(zh_CN)

Java program to _write content to file using Java 8_ APIs is –
使用 Java 8 API 将内容写入文件的 Java 程序如下： - (zh_CN)

    //Get the file reference
    Path path = Paths.get("c:/output.txt");

    //Use try-with-resource to get auto-closeable writer instance
    try (BufferedWriter writer = Files.newBufferedWriter(path))
    {
        writer.write("Hello World !!");
    }

## 2. Write to file using Files.write()

## 2. 使用 `Files.write()`写入文件(zh_CN)

Using [Files.write()](https://docs.oracle.com/javase/8/docs/api/java/nio/file/Files.html#write-java.nio.file.Path-byte:A-java.nio.file.OpenOption...-) method is also pretty much clean code.
使用[Files.write（）]（https://docs.oracle.com/javase/8/docs/api/java/nio/file/Files.html#write-java.nio.file.Path-byte:A -java.nio.file.OpenOption ...-）方法也是非常干净的代码。(zh_CN)

    String content = "Hello World !!";

    Files.write(Paths.get("c:/output.txt"), content.getBytes());

Above both methods are good for almost all use cases which needs to **write file in Java 8**.
以上两种方法都适用于几乎所有需要在 Java 8 写文件的用例。(zh_CN)

Happy Learning !!
快乐学习!!(zh_CN)

{% endraw %}
