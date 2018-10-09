---
layout: post
title:  "关于java的二维码的生成与解析"
title2:  "关于java的二维码的生成与解析"
date:   2017-01-01 23:56:51  +0800
source:  "https://www.jfox.info/%e5%85%b3%e4%ba%8ejava%e7%9a%84%e4%ba%8c%e7%bb%b4%e7%a0%81%e7%9a%84%e7%94%9f%e6%88%90%e4%b8%8e%e8%a7%a3%e6%9e%90.html"
fileName:  "20170101311"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%85%b3%e4%ba%8ejava%e7%9a%84%e4%ba%8c%e7%bb%b4%e7%a0%81%e7%9a%84%e7%94%9f%e6%88%90%e4%b8%8e%e8%a7%a3%e6%9e%90.html"
---
{% raw %}
本文说的是通过zxing实现二维码的生成与解析，看着很简单，直接上代码

    import java.io.File;
    import java.io.IOException;
    import java.nio.file.Path;
    import java.util.HashMap;
    import com.google.zxing.BarcodeFormat;
    import com.google.zxing.EncodeHintType;
    import com.google.zxing.MultiFormatWriter;
    import com.google.zxing.WriterException;
    import com.google.zxing.client.j2se.MatrixToImageWriter;
    import com.google.zxing.common.BitMatrix;
    import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
    
    publicclass TestZXing {
        publicstaticvoid main(String[] args) {
            int width=300;
            int height=300;
            String format="png";
            String contents="www.baidu.com";
            HashMap map=new HashMap();
            map.put(EncodeHintType.CHARACTER_SET, "utf-8");
            map.put(EncodeHintType.ERROR_CORRECTION,ErrorCorrectionLevel.M);
            map.put(EncodeHintType.MARGIN, 0);
            try {
                BitMatrix bm = new MultiFormatWriter().encode(contents, BarcodeFormat.QR_CODE, width, height);
                Path file=new File("D:/img.png").toPath();
                MatrixToImageWriter.writeToPath(bm, format, file);
            } catch (WriterException e) {
                e.printStackTrace();
            } catch (IOException e) {            e.printStackTrace();
            }
        }
    }

通过上面的代码则会生成一个内容链接为www.baidu.com的二维码

![](/wp-content/uploads/2017/07/1500290132.png)

对这个二维码的解析的代码如下

    import java.awt.image.BufferedImage;
    import java.io.File;
    import java.io.IOException;
    import java.util.HashMap;
    
    import javax.imageio.ImageIO;
    
    import com.google.zxing.BinaryBitmap;
    import com.google.zxing.EncodeHintType;
    import com.google.zxing.MultiFormatReader;
    import com.google.zxing.NotFoundException;
    import com.google.zxing.Result;
    import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
    import com.google.zxing.common.HybridBinarizer;
    
    publicclass TestRead {
        publicstaticvoid main(String[] args) {
            try {
                MultiFormatReader reader=new MultiFormatReader();//[需要详细了解MultiFormatReader的小伙伴可以点我一下官方去看文档](https://www.jfox.info/go.php?url=https://zxing.github.io/zxing/apidocs/com/google/zxing/MultiFormatReader.html)
                File f=new File("D:/img.png");
                BufferedImage image=ImageIO.read(f);
                BinaryBitmap bb=new BinaryBitmap(new HybridBinarizer(new BufferedImageLuminanceSource(image)));
                HashMap map =new HashMap();
                map.put(EncodeHintType.CHARACTER_SET, "utf-8");
                Result result = reader.decode(bb,map);
                System.out.println("解析结果："+result.toString());
                System.out.println("二维码格式类型："+result.getBarcodeFormat());
                System.out.println("二维码文本内容："+result.getText());
            } catch (NotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
    
        }
    }

执行的结果如下

    解析结果：www.baidu.com
    二维码格式类型：QR_CODE
    二维码文本内容：www.baidu.com
{% endraw %}
