---
layout: post
title:  "实现excel导入导出功能，excel导入数据到页面中，页面数据导出生成excel文件"
title2:  "实现excel导入导出功能，excel导入数据到页面中，页面数据导出生成excel文件"
date:   2017-01-01 23:52:12  +0800
source:  "https://www.jfox.info/%e5%ae%9e%e7%8e%b0excel%e5%af%bc%e5%85%a5%e5%af%bc%e5%87%ba%e5%8a%9f%e8%83%bd-excel%e5%af%bc%e5%85%a5%e6%95%b0%e6%8d%ae%e5%88%b0%e9%a1%b5%e9%9d%a2%e4%b8%ad-%e9%a1%b5%e9%9d%a2%e6%95%b0%e6%8d%ae.html"
fileName:  "20170101032"
lang:  "zh_CN"
published: true
permalink: "2017/%e5%ae%9e%e7%8e%b0excel%e5%af%bc%e5%85%a5%e5%af%bc%e5%87%ba%e5%8a%9f%e8%83%bd-excel%e5%af%bc%e5%85%a5%e6%95%b0%e6%8d%ae%e5%88%b0%e9%a1%b5%e9%9d%a2%e4%b8%ad-%e9%a1%b5%e9%9d%a2%e6%95%b0%e6%8d%ae.html"
---
{% raw %}
今天接到项目中的一个功能，要实现excel的导入，导出功能。这个看起来思路比较清楚，但是做起了就遇到了不少问题。

不过核心的问题，大家也不会遇到了。每个项目前台页面，以及数据填充方式都不一样，不过大多都是以json数据填充的。在导入excel填充json数据到页面时，真的让我差点吐血了。在做这个导入导出的时候，那一个礼拜都是黑暗的。

好了，废话不多说了，我今天就给大家展示这个两个功能的核心点，excel生成json数据和json数据生成excel文件。

一：从上传文件到服务器，后台java解析，返回excel的json数据到前台。我自己从新做了一个简单的测试项目，需要演示项目的（struts2），下面评论出来，谢谢大家支持。

1.excel生成json数据，用于导入excel文件到页面中。

2.可以使用jxl，或者poi去实现这个，我两种方式都采用了，下面是jar包(标记的jar是核心excel转json数据的，包括jxl和poi，其它jar是项目的)

 3.还是和上传文件一样，使用ajax，formdata对象将文件传输到后台，此时生成的是二进制文件，需要在服务器上生成所要的文件。

4.调用方法将上传的文件转化为json数据，使用poi要注意了，03版和07版使用的对象不一样，代码中有说明。

4.将得到的json数据返回前台。

5.下面是效果图，最后面就附上源码。

这是后台java处理代码。

    package com.pan.files.action;
    
    import java.io.BufferedInputStream;
    import java.io.BufferedOutputStream;
    import java.io.File;
    import java.io.FileInputStream;
    import java.io.FileNotFoundException;
    import java.io.FileOutputStream;
    import java.io.IOException;
    import java.io.InputStream;
    import java.io.OutputStream;
    import java.io.PrintWriter;
    import java.text.SimpleDateFormat;
    import java.util.ArrayList;
    import java.util.Date;
    import java.util.HashMap;
    import java.util.LinkedHashMap;
    import java.util.LinkedList;
    import java.util.List;
    import java.util.Map;
    
    import javax.servlet.http.HttpServletResponse;
    
    import com.alibaba.fastjson.JSON;
    
    import org.apache.commons.io.FileUtils;
    import org.apache.poi.hssf.usermodel.*;
    import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
    import org.apache.poi.poifs.filesystem.POIFSFileSystem;
    import org.apache.poi.ss.usermodel.*;
    import org.apache.poi.xssf.usermodel.XSSFDataFormat;
    import org.apache.poi.xssf.usermodel.XSSFWorkbook;
    import org.apache.struts2.ServletActionContext;
    /*import org.springframework.web.multipart.MultipartFile;*/
     
    
    
    public class ImportExcel  {
    
    	private File  files; //上传的文件路径
    	private String filesFileName; //文件名
    	
    	
    	
    	
    
    	public File getFiles() {
    		return files;
    	}
    
    
    	public void setFiles(File files) {
    		this.files = files;
    	}
    
    
    	public String getFilesFileName() {
    		return filesFileName;
    	}
    
    
    	public void setFilesFileName(String filesFileName) {
    		this.filesFileName = filesFileName;
    	}
      /*
    	这个是jxl方式
    	dir:文件地址
    	
      */
    	/*public static String excelToJson(File dir ) throws BiffException, IOException {  
                    jxl.Workbook wb =jxl.Workbook.getWorkbook(dir); // 从文件流中获取Excel工作区对象（WorkBook）  
                    jxl.Sheet sheet = wb.getSheet(0); // 从工作区中取得页（Sheet）  
                    jxl.Cell[] header = sheet.getRow(0);  
                    String json1 = "";
                    String[] arry = new String[sheet.getRows()];
                    for (int i = 1; i < sheet.getRows(); i++) { // 循环打印Excel表中的内容  
                        Map hashMap = new HashMap();
                        ArrayList List = new ArrayList();
                        for (int j = 0; j < sheet.getColumns(); j++) {  
                        	jxl.Cell cell = sheet.getCell(j, i);  
                            List.add(cell.getContents()); 
                        }  
                        // 这个json字符串就是我们想要的，实际应用中可以直接返回该字符串  
                       // String json = JSONObject.toJSONString(hashMap); 
                    //    String json = JSONObject.toJSONString(List); 
                        String json = com.alibaba.fastjson.JSONArray.toJSONString(List); 
                        json1 += json+",";
                    
                    } 
      
                  
                    return "["+ json1.substring(0,json1.length()-1)+"]excel";
                } */
    	
    	  
    	    public  void targetFile() throws Exception { 
    	        //根据服务器的文件保存地址和原文件名创建目录文件全路径 
    	        String dirs= ServletActionContext.getServletContext() 
                        .getRealPath("/image");
    	        if (files != null){
    	            File savedir = new File(dirs) ;
    	            if (! savedir.exists()) {
    	                savedir.mkdirs() ;
    	            }
    	        }
    	       //将上传到服务器上的二进制文件写成实际文件
    	           File savefile = new File(dirs, filesFileName); 
    	           FileUtils.copyFile(files, savefile) ;
    	       //      String paremt =  excelToJson(savefile);
    	     LinkedHashMap<String, String> sjson =   excelTojson(savefile);
    	           HttpServletResponse response = ServletActionContext.getResponse();
    	           response.setHeader("Content-type", "text/html;charset=UTF-8");  
    	         //这句话的意思，是告诉servlet用UTF-8转码，而不是用默认的ISO8859  
    	         response.setCharacterEncoding("UTF-8");  
    	           PrintWriter out = response.getWriter();
    	//        copy(this.files, di); 
    	         out.println(sjson);
    	    } 
    	   
    	    public static LinkedHashMap<String,String> excelTojson(File file) throws IOException, Exception {
    	        // 返回的map
    	        LinkedHashMap<String,String> excelMap = new LinkedHashMap<>();
    	        // Excel列的样式，主要是为了解决Excel数字科学计数的问题
    	        CellStyle cellStyle;
    	        // 根据Excel构成的对象
    	        Workbook wb;
    	        // 如果是2007及以上版本，则使用想要的Workbook以及CellStyle
    	        if(file.getName().endsWith("xlsx")){   //07及07以后版本
    	            wb = new XSSFWorkbook(new FileInputStream(file));
    	            XSSFDataFormat dataFormat = (XSSFDataFormat) wb.createDataFormat();
    	            cellStyle = wb.createCellStyle();
    	            // 设置Excel列的样式为文本
    	            cellStyle.setDataFormat(dataFormat.getFormat("@"));
    	        }else{    //03版本
    	            POIFSFileSystem fs = new POIFSFileSystem(file);
    	            wb = new HSSFWorkbook(fs);
    	            HSSFDataFormat dataFormat = (HSSFDataFormat) wb.createDataFormat();
    	            cellStyle = wb.createCellStyle();
    	            // 设置Excel列的样式为文本
    	            cellStyle.setDataFormat(dataFormat.getFormat("@"));
    	        }
    	 
    	        // sheet表个数
    	        int sheetsCounts = wb.getNumberOfSheets();
    	        // 遍历每一个sheet
    	        for (int i = 0; i < sheetsCounts; i++) {
    	            Sheet sheet = wb.getSheetAt(i);
    	            // 一个sheet表对于一个List
    	            List list = new LinkedList();
    	            // 将第一行的列值作为正个json的key
    	            String[] cellNames;
    	            // 取第一行列的值作为key
    	            Row fisrtRow = sheet.getRow(0);
    	            // 如果第一行就为空，则是空sheet表，该表跳过
    	            if(null == fisrtRow){
    	                continue;
    	            }
    	            // 得到第一行有多少列
    	            int curCellNum = fisrtRow.getLastCellNum();
    	            // 根据第一行的列数来生成列头数组
    	            cellNames = new String[curCellNum];
    	            // 单独处理第一行，取出第一行的每个列值放在数组中，就得到了整张表的JSON的key
    	            for (int m = 0; m < curCellNum; m++) {
    	                Cell cell = fisrtRow.getCell(m);
    	                // 设置该列的样式是字符串
    	                cell.setCellStyle(cellStyle);
    	                cell.setCellType(Cell.CELL_TYPE_STRING);
    	                // 取得该列的字符串值
    	                cellNames[m] = cell.getStringCellValue();
    	            }
    	            for (String s : cellNames) {
    	            }
    	 
    	            // 从第二行起遍历每一行
    	            int rowNum = sheet.getLastRowNum();
    	            System.out.println("总共有 " + rowNum + " 行");
    	            for (int j = 1; j <= rowNum; j++) {
    	                // 一行数据对于一个Map
    	                LinkedHashMap rowMap = new LinkedHashMap();
    	                // 取得某一行
    	                Row row = sheet.getRow(j);
    	                int cellNum = row.getLastCellNum();
    	                // 遍历每一列
    	                for (int k = 0; k < cellNum; k++) {
    	                    Cell cell = row.getCell(k);
    	 
    	                    cell.setCellStyle(cellStyle);
    	                    cell.setCellType(Cell.CELL_TYPE_STRING);
    	                    // 保存该单元格的数据到该行中
    	        rowMap.put(cellNames[k],cell.getStringCellValue());
    	                }
    	                // 保存该行的数据到该表的List中
    	                list.add(rowMap);
    	            }
    	            // 将该sheet表的表名为key，List转为json后的字符串为Value进行存储
    	            excelMap.put(sheet.getSheetName(),JSON.toJSONString(list,false));
    	        }
    	        wb.close();
    	        return excelMap;
    	    }
    	 
    	
    	   
    	      
    	    public static void main(String [] args) throws FileNotFoundException{
    	   // 	createJson();
    	    	
    	    }
    	}   
    	
    	
    	
    	
    

　这是前台js文件：

    $(function () {
    
    	$("#confirm").on("click",function(){
    		var files =  $("input").eq(0).val();
    		if(files==""){
    			alert("请先上传文件");
    		}
    	});
    	$("#cancel").on("click",function(){
    	//	webform.close();
    	});
    
    	$("#fileUpload").change(function(){ 
    		var val = $(this).val();
    		var fileName  = val.split("")[val.split("").length-1];
    		if (val.indexOf("xls") != -1 || val.indexOf("xlsx") != -1) {
    			$("input").eq(0).val(fileName);
    	
    			$('#formFile').ajaxSubmit({
    				url:'excel_targetFile.action',
    				type:'POST',
    			//	data:{scmd:''}, 需要传什么参数自己配置
    				success:function(data){
    
    					$("#confirm").on("click",function(){
    
    					
    						alert("导入成功");
    					});
    					$("#cancel").on("click",function(){
    
    						alert("取消导入");
    					});
    				},
    				error:function(xhr){
    				      alert("上传出错");
    				}                              
    			});
    
    		} else {
    			alert("请选择正确的文件格式！");
    			//清空上传路径
    			$(this).val("");
    			return false;
    		}
    
    	});
    
    
    
    	
    	
    })
    

　　这是jsp页面代码：

    <%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <script src="./js/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="./js/jquery.form.js" type="text/javascript"></script>
    <script src="./js/excelJs.js" type="text/javascript"></script>
    <style type="text/css">
    .file {
        position: relative;
        display: inline-block;
        background: #D0EEFF;
        border: 1px solid #99D3F5;
        border-radius: 4px;
      /*   padding: 4px 12px; */
        overflow: hidden;
        color: #1E88C7;
        text-decoration: none;
        text-indent: 0;
        line-height: 20px;
        top:6px;
    }
    .file input {
        position: absolute;
        font-size: 100px;
        right: 0;
        top: 0;
        opacity: 0;
    } 
    .file:hover {
        background: #AADFFD;
        border-color: #78C3F3;
        color: #004974;
        text-decoration: none;
    }
    .positionFile{
    margin-left: 10px;
    margin-top: 30px;
    }
    .poConfirm{
    margin-top: 40px;
    margin-left: 65px;
    }
    
    </style>
    </head>
    <body >
    
    <form id="formFile">
    <input id="textId" type="text" value="" class="positionFile"  readonly="readonly">
    <a href="javascript:;" class="file">点击上传文件
    <input type="file" id="fileUpload" name="files" >
    </a>
    <br>
    <input type="button" id="confirm" value="确定" class="co-win-button poConfirm">
    <input type="button" id="cancel" value="取消" class="co-win-button poConfirm">
    </form>
    </body>
    </html>
    

好啦，到这里你以及看完了整个过程，重点是要理解其中的思路，尤其是转化方法上面。下面我将介绍导出json数据到excel文件中，其实这个就简单了就在后台将你的json数据调用转化方法，然后写入到excel文件中，返回前台设置响应让其下载即可。

这个是导出excel核心的方法。

       /* 
    	    src:定义下载的文件路径   
    	*/
    	    public static JSONObject createExcel(String src, JSONArray json) {
    	        JSONObject result = new JSONObject(); // 用来反馈函数调用结果
    	        try {
    	            // 新建文件
    	            File file = new File(src);
    	            file.createNewFile();
    
    	            OutputStream outputStream = new FileOutputStream(file);// 创建工作薄
    	            jxl.write.WritableWorkbook writableWorkbook = jxl.Workbook.createWorkbook(outputStream);
    	            jxl.write.WritableSheet sheet = writableWorkbook.createSheet("First sheet", 0);// 创建新的一页
    
    //	            JSONArray jsonArray = json.getJSONArray("dt");// 得到data对应的JSONArray
    	            JSONArray jsonArray = json;// 得到data对应的JSONArray
    	            jxl.write.Label label; // 单元格对象
    	            int column = 0; // 列数计数
    
    	            // 将第一行信息加到页中。如：姓名、年龄、性别
    	            JSONObject first = jsonArray.getJSONObject(0);
    	            Iterator<String> iterator = first.keys(); // 得到第一项的key集合
    	            while (iterator.hasNext()) { // 遍历key集合
    	                String key = (String) iterator.next(); // 得到key
    	                label = new jxl.write.Label(column++, 0, key); // 第一个参数是单元格所在列,第二个参数是单元格所在行,第三个参数是值
    	                sheet.addCell(label); // 将单元格加到页
    	            }
    
    	            // 遍历jsonArray
    	            for (int i = 0; i < jsonArray.size(); i++) {
    	                JSONObject item = jsonArray.getJSONObject(i); // 得到数组的每项
    	                iterator = item.keys(); // 得到key集合
    	                column = 0;// 从第0列开始放
    	                while (iterator.hasNext()) {
    	                    String key = iterator.next(); // 得到key
    	                    String value = item.getString(key); // 得到key对应的value
    	                    label = new jxl.write.Label(column++, (i + 1), value); // 第一个参数是单元格所在列,第二个参数是单元格所在行,第三个参数是值
    	                    sheet.addCell(label); // 将单元格加到页
    	                }
    	            }
    	            writableWorkbook.write(); // 加入到文件中
    	            writableWorkbook.close(); // 关闭文件，释放资源
    	        } catch (Exception e) {
    	            result.put("result", "failed"); // 将调用该函数的结果返回
    	            result.put("reason", e.getMessage()); // 将调用该函数失败的原因返回
    	            return result;
    	        }
    
    //	        result.put("result", "successed");
    	        return result;
    	    }
    

 虽然在项目运用到了这个，昨天自己又从新搭建项目给大家提供一个演示例子，真的又弥补到了很多东西，包括struts2的配置请求方式，json数据转化解析过程，ajax请求机制，poi对excel，word等文件编辑操作等等。如果大家觉得可以请点个赞，你们的赞是我前进的动力。

另外大神们看了有什么问题请指出来，我虚心学习，需要演示项目源码的就在下方评论出来，大家一起分享学习。

需要演示项目的到我github上下载， https://github.com/chenpanpan0809/MyProjcet

别忘了点波推荐哦，大神们(*^_^*)
{% endraw %}
