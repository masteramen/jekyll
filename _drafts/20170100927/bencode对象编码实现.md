---
layout: post
title:  "bencode对象编码实现"
title2:  "bencode对象编码实现"
date:   2017-01-01 23:50:27  +0800
source:  "https://www.jfox.info/bencode%e5%af%b9%e8%b1%a1%e7%bc%96%e7%a0%81%e5%ae%9e%e7%8e%b0.html"
fileName:  "20170100927"
lang:  "zh_CN"
published: true
permalink: "2017/bencode%e5%af%b9%e8%b1%a1%e7%bc%96%e7%a0%81%e5%ae%9e%e7%8e%b0.html"
---
{% raw %}
承接上文，使用递归可以很简单的就实现了一个bencode编码函数 

    package com.norkts.torrents;
    import org.junit.Assert;
    import java.util.*;
    /**
     * bencode文件编码
     * @author norkts<norkts@gmail.com>
     * @date 2017-06-23
     * @version 1.0
     */
    public class Bencoder {
        /**
         * 将对象使用bencode格式编码
         * @param target
         * @return
         */
        public static String encode(Object target){
            StringBuilder sb = new StringBuilder();
            if(target instanceof Map){
                //字典类型
                sb.append("d");
                for(Map.Entry<String, Object> entry : ((Map<String, Object>)target).entrySet()){
                    String key = entry.getKey();
                    Object value = entry.getValue();
                    sb.append(encode(key));
                    sb.append(encode(value));
                }
                sb.append("e");
            }else if(target instanceof List){
                //列表类型处理
                sb.append("l");
                for(Object item : (List<Object>)target){
                    sb.append(encode(item));
                }
                sb.append("e");
            }else if(target instanceof String){
                //字符串类型处理
                sb.append(((String)target).length() + ":" + target);
            }else{
                //数字处理
                sb.append("i" + Integer.toString((Integer)target, 10) + "e");
            }
            return sb.toString();
        }
        public static void main(String[] argv){
            Object target = new LinkedHashMap<String, Object>();
            ((Map<String, Object>)target).put("a", "1");
            ((Map<String, Object>)target).put("b", 2);
            ((Map<String, Object>)target).put("c", -3);
            Assert.assertEquals("d1:a1:11:bi2e1:ci-3ee", encode(target));
            target = new LinkedHashMap<String, Object>();
            ((Map<String, Object>) target).put("key1", "val1");
            ((Map<String, Object>) target).put("key2", 100);
            List<Object> li = new ArrayList<Object>();
            li.add("item1");
            li.add(-100);
            li.add(((ArrayList<Object>) li).clone());
            li.add(((LinkedHashMap<String, Object>) target).clone());
            ((Map<String, Object>) target).put("key3", li);
            System.out.println(encode(target));
            Assert.assertEquals("d4:key14:val14:key2i100e4:key3l5:item1i-100el5:item1i-100eed4:key14:val14:key2i100eeee", encode(target));
            System.out.println(BencodeDecoder.decode(encode(target).getBytes()));
        }
    }
{% endraw %}
