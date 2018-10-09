---
layout: post
title:  "Mybatis-Plus和bootstrap-table集成 demo"
title2:  "Mybatis-Plus和bootstrap-table集成 demo"
date:   2017-01-01 23:52:28  +0800
source:  "https://www.jfox.info/mybatisplus%e5%92%8cbootstraptable%e9%9b%86%e6%88%90demo.html"
fileName:  "20170101048"
lang:  "zh_CN"
published: true
permalink: "2017/https://www.jfox.info/mybatisplus%e5%92%8cbootstraptable%e9%9b%86%e6%88%90demo.html"
---
{% raw %}
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    <html>
    <head>
        <title>用户列表</title>
        <!-- Jquery -->
        <script src="${ctx}/static/jquery/jquery-1.11.3.min.js" type="text/javascript"></script>
        
        <!-- Bootstrap -->
        <link href="${ctx}/static/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
        <script src="${ctx}/static/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
        
        <!-- Bootstrap table -->
        <link href="${ctx}/static/bootstrap-table/css/bootstrap-table.min.css" rel="stylesheet"/>
        <script src="${ctx}/static/bootstrap-table/js/bootstrap-table.min.js" type="text/javascript"></script>
        <script src="${ctx}/static/bootstrap-table/js/bootstrap-table.min.js" type="text/javascript"></script>
        <script src="${ctx}/static/bootstrap-table/js/locale/bootstrap-table-zh-CN.min.js" type="text/javascript"></script>
    </head>
    <body>
        <div class="container">
        
            <div class="row">
                <div class="col-lg-8">
                    <br/>
                    <div class="panel panel-default">
                        <!-- 展示的table列表 -->
                        <table id="dataTable"></table>
                    </div>
                </div>
            </div>
        </div>
        <script>
            $(function () {
                //1.初始化Table
                var oTable = new TableInit();
                oTable.Init();
            })
            
            var TableInit = function () {
                var oTableInit = new Object();
                //初始化Table
                oTableInit.Init = function () {
                    $('#dataTable').bootstrapTable({
                        method: 'post',
                        url: dataUrl,
                        dataType: "json",
                        striped: true,     //使表格带有条纹
                        pagination: true,    //在表格底部显示分页工具栏
                        pageSize: 10,
                        pageNumber: 1,
                        pageList: [10, 20, 50, 100, 200, 500],
                        idField: "id",  //标识哪个字段为id主键
                        showToggle: false,   //名片格式
                        cardView: false,//设置为True时显示名片（card）布局
                        showColumns: true, //显示隐藏列  
                        showRefresh: true,  //显示刷新按钮
                        singleSelect: true,//复选框只能选择一条记录
                        search: false,//是否显示右上角的搜索框
                        clickToSelect: true,//点击行即可选中单选/复选框
                        sidePagination: "server",//表格分页的位置
                        queryParamsType: "limit", //参数格式,发送标准的RESTFul类型的参数请求
                        toolbar: "#toolbar", //设置工具栏的Id或者class
                        columns: dataColumns, //列
                        silent: true,  //刷新事件必须设置
                        formatLoadingMessage: function () {
                            return "请稍等，正在加载中...";
                        },
                        formatNoMatches: function () {  //没有匹配的结果
                            return '无符合条件的记录';
                        },
                        onLoadSuccess: function () {
                            
                        },
                        onLoadError: function (data) {
                            //$('#reportTable').bootstrapTable('removeAll');
                        },
                        onClickRow: function (row) {
                            //window.location.href = "/qStock/qProInfo/" + row.ProductId;
                        },
                        responseHandler: function(res) {
                            if(res.code == 1){
                                return {
                                    "total": res.data.total,//总页数
                                    "rows": res.data.rows   //数据
                                 };
                                
                            }
                        }
                    });
                    
                };
            
                //得到查询的参数
                oTableInit.queryParams = function (params) {
                    return dataQueryParams(params);
                };
                return oTableInit;
            };
            
            var dataUrl = "${ctx}/sys/user/getUserList";
            var dataColumns = [{
                field: 'id',
                title: '序号'
            }, {
                field: 'loginName',
                title: '登录名'
            },  {
                field: 'userName',
                title: '用户姓名'
            }, {
                field: 'mobile',
                title: '手机号'
            }];
            
            function dataQueryParams(params) {
                return {
                    _size: params.limit,  //页面大小
                    _index: params.offset, //页码
                };
            }
        
        </script>
    </body>
    </html>
    

## 服务端代码

        @ResponseBody
        @RequestMapping("/getUserList")
        public AjaxResult getUserList() {
            Page<User> page = getPage();
            page = userService.selectPage(page, null);
            
            Map<String, Object> resObj = new HashMap<String, Object>();
            resObj.put("total", page.getTotal());
            resObj.put("rows", page.getRecords());
            
            return json(resObj);
        }
        
        public AjaxResult json(Object data) {
            return new AjaxResult().success(data);
        }

## AjaxResult对象

    public class AjaxResult {
    
        // 返回状态码   (默认1:成功,其它:失败)
        private int code = 1;
    
        // 返回的中文消息
        private String message;
    
        // 成功时携带的数据
        private Object data;
    
        public int getCode() {
            return code;
        }
    
        public AjaxResult setCode(int code) {
            this.code = code;
            return this;
        }
    
        public String getMessage() {
            return message;
        }
        
        public AjaxResult setMessage(String message) {
            this.message = message;
            return this;
        }
    
        public Object getData() {
            return data;
        }
    
        public AjaxResult setData(Object data) {
            this.data = data;
            return this;
        }
    
        public AjaxResult addSuccess(String message) {
            this.message = message;
            this.code = 1;
            this.data = null;
            return this;
        }
    
        public AjaxResult addError(String message) {
            this.message = message;
            this.code = 999;
            this.data = null;
            return this;
        }
    
        public AjaxResult addFail(String message) {
            this.message = message;
            this.code = 999;
            this.data = null;
            return this;
        }
    
        public AjaxResult addWarn(String message) {
            this.message = message;
            this.code = 333;
            this.data = null;
            return this;
        }
    
        public AjaxResult success(Object data) {
            this.message = "success";
            this.data = data;
            this.code = 1;
            return this;
        }
    
        public boolean isSuccess() {
            return getCode() == 1;
        }
    
        @Override
        public String toString() {
            return JSON.toJSONString(this);
        }

## 静态资源

![](https://segmentfault.com/a/1190000010027339)

## Maven导入

    <!-- Mybatis-Plus -->
            <dependency>
                <groupId>com.baomidou</groupId>
                <artifactId>mybatis-plus</artifactId>
                <version>2.0.9</version>
            </dependency>

具体配置：[http://mp.baomidou.com/#/](https://www.jfox.info/go.php?url=http://mp.baomidou.com/#/)

## 注意事项

- 
Page<T> selectPage(Page<T> page, Wrapper<T> wrapper); 是Mybatis-Plus内置的方法

- 
返回的数据，必须有total和rows，前后数据不一致

    responseHandler: function(res) {
                            if(res.code == 1){
                                return {
                                    "total": res.data.total,//总页数
                                    "rows": res.data.rows   //数据
                                 };
                                
                            }
                        }

- 
返回的数据最好使用对象返回，若使用JSON字符串返回到前端，需要调用 JSON.parse()转换下，否则数据匹配不上，不能展示
{% endraw %}
