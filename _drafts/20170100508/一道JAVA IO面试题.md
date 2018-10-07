---
layout: post
title:  "一道JAVA IO面试题"
title2:  "一道JAVA IO面试题"
date:   2017-01-01 23:43:28  +0800
source:  "http://www.jfox.info/%e4%b8%80%e9%81%93java-io%e9%9d%a2%e8%af%95%e9%a2%98.html"
fileName:  "20170100508"
lang:  "zh_CN"
published: true
permalink: "%e4%b8%80%e9%81%93java-io%e9%9d%a2%e8%af%95%e9%a2%98.html"
---
{% raw %}
By Lee - Last updated: 星期五, 一月 31, 2014

将一个GBK编码的文本文件转存为一个UTF-8编码的文本文件。

由于很久没用IO流了，当时的代码写的相当混乱，现在整理如下：

import java.io.*;

public class ChangeEncoding {

    public static void changeEncoding (String inEncoding, String outEncoding,

            String inFileName, String outFileName)  throws IOException {

        BufferedReader reader = new BufferedReader(

            new InputStreamReader(

            new FileInputStream(inFileName), inEncoding));

        BufferedWriter writer = new BufferedWriter(

            new OutputStreamWriter(

            new FileOutputStream(outFileName), outEncoding));

        String s = null;

        while ((s = reader.readLine()) != null) {

            writer.write(s, 0, s.length());

            writer.newLine();

        }

        writer.flush();

        writer.close();

        reader.close();

    }

    public static void main(String[] args) {

        try {

            changeEncoding(“GBK”, “UTF-8”, “gbk.txt”, “utf8.txt”);

        } catch (IOException e) {

            System.out.println(“转换失败，原因：” + e.getMessage());

        }

    }

}

PS:BufferedWriter输出的UTF-8文件是无BOM格式编码的。

转自 [一道JAVA IO面试题 – 老马睡不醒 – 博客园](http://www.jfox.info/go.php?url=http://www.cnblogs.com/maxupeng/archive/2010/12/30/1922374.html).
{% endraw %}
