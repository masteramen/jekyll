---
layout: post
title:  "mybatis springmvc批量删除 2最新"
title2:  "mybatis springmvc批量删除 2最新"
date:   2017-01-01 23:54:34  +0800
source:  "http://www.jfox.info/mybatisspringmvc%e6%89%b9%e9%87%8f%e5%88%a0%e9%99%a42%e6%9c%80%e6%96%b0.html"
fileName:  "20170101174"
lang:  "zh_CN"
published: true
permalink: "mybatisspringmvc%e6%89%b9%e9%87%8f%e5%88%a0%e9%99%a42%e6%9c%80%e6%96%b0.html"
---
{% raw %}
service层：

@Override

public void batchDeletes(List list) {

creditDao.batchDeletes(list);

}

控制层controller:

/** * 批量删除 batch */ @RequestMapping(value=”/batchDeletes”) @ResponseBody public List<Credit> batchDeletes(HttpServletRequest request,HttpServletResponse response){ String items = request.getParameter(“creditIdbox”); List<String> delList = new ArrayList<String>(); String[] strs = items.split(“,”); for (String str : strs) { delList.add(str); } creditService.batchDeletes(delList); List<Credit> list=creditService.queryUserInfo(null); ModelAndView mv = new ModelAndView(); Map<String, Object> model = new HashMap<String, Object>(); model.put(“creditVOList”, list); mv.addAllObjects(model); mv.setViewName(“queryregister”); return list; }

mapper.xml:

<!–批量删除 –>

    <delete id=”batchDeletes” parameterType=”java.util.List”>

            DELETE FROM t_credit where t_credit_id in

        <foreach collection=”list” index=”index” item=”item” open=”(” separator=”,” close=”)”>   

            #{item}   

         </foreach>

    </delete>

页面：

<script type=”text/javascript” src=”../jquery/jquery-2.1.3.js”></script>

<script type=”text/javascript” src=”../easyui/jquery.easyui.min.js”></script>

<script type=”text/javascript” src=”../easyui/locale/easyui-lang-zh_CN.js” ></script>

<script type=”text/javascript” src=”../easyui/js/index.js”></script>

<link rel=”stylesheet” type=”text/css” href=”../easyui/themes/default/easyui.css” />

<link rel=”stylesheet” type=”text/css” href=”../easyui/themes/icon.css” />

<script type=”text/javascript” >

 $(function(){

 $(“#button”).click(function(){

    var form=$(“#registerform”);

    form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/intiqu.do”);

    form.submit(); 

});

 //方式二：

 /*$(function(){

     $(“#button”).click(function(){

     document.registerform.action=”http://localhost:8080/ssmy/CreditController/intiqu.do”;

     document.registerform.submit();

    });**/

 //对查询按钮定死状态

  $(“#status”).val($(“#statushidden”).val());

});

   function selectAll(){

     if ($(“#SelectAll”).is(“:checked”)) {

         $(“:checkbox”).prop(“checked”, true);//所有选择框都选中

     } else {

         $(“:checkbox”).prop(“checked”, false);

     }

 }

   $(function(){

    $(“#deleteuser”).click(function(){

     //判断至少写了一项

           var checkedNum = $(“input[name=’creditIdbox’]:checked”).length;

    console.log(checkedNum);

           if(checkedNum==0){

               alert(“请至少选择一项!”);

               return false;

        }

           if(confirm(“确定删除所选项目?”)){

                var checkedList = new Array();

                $(“input[name=’creditIdbox’]:checked”).each(function(){

                    checkedList.push($(this).val());

                });

                console.log(checkedList[0]);

                $.ajax({

                    type:”POST”,

                    url:”http://localhost:8080/ssmy2/CreditController/batchDeletes.do”,

                    data:{“creditIdbox”:checkedList.toString()},

                    datatype:”json”,

                    success:function(data){

                        $(“[name=’creditIdbox’]:checkbox”).attr(“checked”,false);

                        alert(‘删除成功!’);

                        setTimeout(“location.reload()”,1000);//页面刷新

                    },

                    error:function(data){

                    alert(‘删除失败!’);

                    }

                });

                } 

    /* var form=$(“#registerform”);

    form.prop(“action”,”http://localhost:8080/ssmy/CreditController/deleteuser.do”);

    form.submit();  */

 });

    $(“#exports”).click(function(){

    var form =$(“#registerform”);

    form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/exprotExcel.do”);

    form.submit();

    });

     $(“#delete”).click(function(){

    var form =$(“#registerform”);

    form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/batchDeletes.do?creditIdbox=${credit.creditId}”);

    form.submit();

    }); 

    $(“#uploadFile”).click(function(){

    var form =$(“#registerform”);

    form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/uploadFile.do”);

    form.submit();

    });

  });   

</script>

</head>

<body>

<div id=”head”>

     <form id=”registerform” name =”registerform” action=”” method=”post” enctype=”multipart/form-data”>

     <div class=”search-box” style=”width:100%;height:40px;”>

        <label> 登录名: </label>

        <input type=”text” name=”loginName” id=”loginName” />

        <label style=”margin-left:10px;”>身份证:</label> 

        <input type=”text” name=”IDCard” id=”IDCard” />

                <label style=”margin-left:10px;”> 提交状态:</label>  

                <select id=”status” name=”status” style=”width:100px;height:20px;”>

            <option value=””>全部</option>

            <option value=”0″>已提交</option>

            <option value=”1″>未提交</option>

         </select>

          <input type=”button”  id=”button” value=”查询” style=”width:65px;height:22px;margin-left:20px;”/>

          <input type=”submit”  id=”exports” value=”导出” style=”width:65px;height:22px;margin-left:20px;”/>

        </div>

        <input type=”hidden” name=”status” id=”statushidden” value=”${status }” />

        <input type=”hidden” name=”totalcount” id=”totalcount” value=”${totalcount }” />

        <table border=”0″ cellpadding=”0″ cellspacing=”0″>

           <tr style=”width:100%; height: 50px;”>

             <td>

             <input type=”checkbox” id=”SelectAll” name=”SelectAll” onclick=”selectAll();” style=”margin-right:5px;”/>全选</td>

             <td>序列</td>

             <td >登录名</td>

             <td >登录密码</td>

             <td >确认密码</td>

             <td >身份证号</td>

             <td >固定电话</td>

             <td >手机号码</td>

             <td >邮箱</td>

             <td >居住地址</td>

             <td id=”address”>提交状态</td>

             <td >创建时间</td>

             <td >操作</td>

           </tr>

           <c:forEach var=”credit” items=”${creditVOList}” varStatus=”status”>

           <tr style=”width: 300px;”>

           <td><input type=”checkbox” name=”creditIdbox” id=”creditIdbox” value=”${credit.creditId }”></td>

           <td>${status.index}</td>

           <td>${credit.loginName}</td>

           <td>${credit.loginPwd}</td>

           <td>${credit.againPwd}</td>

           <td>${credit.IDCard}</td>

           <td>${credit.fixedTelephoneNumber}</td>

           <td>${credit.telephoneNumber}</td>

           <td>${credit.email}</td>

           <td id=”address”>${credit.address}</td>

           <td>${credit.status ==0 ? ‘已提交’:’未提交’}</td>

           <td>${creditVO.createtime}</td>

           <td>

       <!–  <a id=”delete” href=”http://localhost:8080/ssmy/CreditController/deleteuser.do?creditIdbox=${credit.creditId}”>删除</a>–>

         <a id=”delete” href=”http://localhost:8080/ssmy2/CreditController/deleteuser.do?creditIdbox=${credit.creditId}”>删除</a>

           </td>

           </tr>

           </c:forEach>

   </table>

      <c:if test=”${empty creditVOList }”>

      没有任何员工信息.

     </c:if> <br/>

      <input type=”button” value=”删除” id =”deleteuser” >

      <input type=”text” name=”username”/>

      <input type=”file” name=”uploadFile”/>

      <input type=”submit” id=”uploadFile” name=”开始上传文件” value=”开始上传文件”/>

         <div id=”box” style=”border: 1px solid #ccc;”></div      

 </form>

service层：@Override public void batchDeletes(List list) { creditDao.batchDeletes(list); } 控制层controller/** * 批量删除 batch */ @RequestMapping(value=”/batchDeletes”) @ResponseBody public List<Credit> batchDeletes(HttpServletRequest request,HttpServletResponse response){ String items = request.getParameter(“creditIdbox”); List<String> delList = new ArrayList<String>(); String[] strs = items.split(“,”); for (String str : strs) { delList.add(str); } creditService.batchDeletes(delList); List<Credit> list=creditService.queryUserInfo(null); ModelAndView mv = new ModelAndView(); Map<String, Object> model = new HashMap<String, Object>(); model.put(“creditVOList”, list); mv.addAllObjects(model); mv.setViewName(“queryregister”); return list; } mapper.xml<!–批量删除 –><deleteid=“batchDeletes“parameterType=“java.util.List“> DELETE FROM t_credit where t_credit_id in<foreachcollection=“list“index=“index“item=“item“open=“(“separator=“,“close=“)“> #{item} </foreach></delete>页面：<scripttype=“text/javascript“src=“../jquery/jquery-2.1.3.js“></script><scripttype=“text/javascript“src=“../easyui/jquery.easyui.min.js“></script><scripttype=“text/javascript“src=“../easyui/locale/easyui-lang-zh_CN.js“></script><scripttype=“text/javascript“src=“../easyui/js/index.js“></script><linkrel=“stylesheet“type=“text/css“href=“../easyui/themes/default/easyui.css“/><linkrel=“stylesheet“type=“text/css“href=“../easyui/themes/icon.css“/><scripttype=“text/javascript“> $(function(){ $(“#button”).click(function(){ var form=$(“#registerform”); form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/intiqu.do“); form.submit();  }); //方式二： /*$(function(){ $(“#button”).click(function(){ document.registerform.action=”http://localhost:8080/ssmy/CreditController/intiqu.do”; document.registerform.submit(); });**/ //对查询按钮定死状态 $(“#status”).val($(“#statushidden”).val()); }); function selectAll(){ if ($(“#SelectAll”).is(“:checked”)) { $(“:checkbox”).prop(“checked”, true);//所有选择框都选中 } else { $(“:checkbox”).prop(“checked”, false); } } $(function(){ $(“#deleteuser”).click(function(){ //判断至少写了一项 var checkedNum = $(“input[name=’creditIdbox’]:checked”).length; console.log(checkedNum); if(checkedNum==0){ alert(“请至少选择一项!”); return false; } if(confirm(“确定删除所选项目?”)){ var checkedList = new Array(); $(“input[name=’creditIdbox’]:checked”).each(function(){ checkedList.push($(this).val()); }); console.log(checkedList[0]); $.ajax({ type:”POST”, url:”http://localhost:8080/ssmy2/CreditController/batchDeletes.do“, data:{“creditIdbox”:checkedList.toString()}, datatype:”json”, success:function(data){ $(“[name=’creditIdbox’]:checkbox”).attr(“checked”,false); alert(‘删除成功!’); setTimeout(“location.reload()”,1000);//页面刷新 }, error:function(data){ alert(‘删除失败!’); } }); }  /* var form=$(“#registerform”); form.prop(“action”,”http://localhost:8080/ssmy/CreditController/deleteuser.do“); form.submit(); */ }); $(“#exports”).click(function(){ var form =$(“#registerform”); form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/exprotExcel.do“); form.submit(); }); $(“#delete”).click(function(){ var form =$(“#registerform”); form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/batchDeletes.do?creditIdbox=${credit.creditId}”); form.submit(); }); $(“#uploadFile”).click(function(){ var form =$(“#registerform”); form.prop(“action”,”http://localhost:8080/ssmy2/CreditController/uploadFile.do”); form.submit(); }); }); </script></head><body><divid=“head“><formid=“registerform“name=“registerform“action=““method=“post“enctype=“multipart/form-data“><divclass=“search-box“style=“width:100%;height:40px;“><label> 登录名: </label><inputtype=“text“name=“loginName“id=“loginName“/><labelstyle=“margin-left:10px;“>身份证:</label><inputtype=“text“name=“IDCard“id=“IDCard“/><labelstyle=“margin-left:10px;“> 提交状态:</label><selectid=“status“name=“status“style=“width:100px;height:20px;“><optionvalue=““>全部</option><optionvalue=“0“>已提交</option><optionvalue=“1“>未提交</option></select><inputtype=“button“id=“button“value=“查询“style=“width:65px;height:22px;margin-left:20px;“/><inputtype=“submit“id=“exports“value=“导出“style=“width:65px;height:22px;margin-left:20px;“/> </div> <input type=”hidden” name=”status” id=”statushidden” value=”${status }” /> <input type=”hidden” name=”totalcount” id=”totalcount” value=”${totalcount }” /> <table border=”0″ cellpadding=”0″ cellspacing=”0″> <tr style=”width:100%; height: 50px;”> <td> <input type=”checkbox” id=”SelectAll” name=”SelectAll” onclick=”selectAll();” style=”margin-right:5px;”/>全选</td> <td>序列</td> <td >登录名</td> <td >登录密码</td> <td >确认密码</td> <td >身份证号</td> <td >固定电话</td> <td >手机号码</td> <td >邮箱</td> <td >居住地址</td> <td id=”address”>提交状态</td> <td >创建时间</td> <td >操作</td> </tr> <c:forEach var=”credit” items=”${creditVOList}” varStatus=”status”> <tr style=”width: 300px;”> <td><input type=”checkbox” name=”creditIdbox” id=”creditIdbox” value=”${credit.creditId }”></td> <td>${status.index}</td> <td>${credit.loginName}</td> <td>${credit.loginPwd}</td> <td>${credit.againPwd}</td> <td>${credit.IDCard}</td> <td>${credit.fixedTelephoneNumber}</td> <td>${credit.telephoneNumber}</td> <td>${credit.email}</td> <td id=”address”>${credit.address}</td> <td>${credit.status ==0 ? ‘已提交’:’未提交’}</td> <td>${creditVO.createtime}</td> <td> <!– <a id=”delete” href=”http://localhost:8080/ssmy/CreditController/deleteuser.do?creditIdbox=${credit.creditId}”>删除</a>–> <a id=”delete” href=”http://localhost:8080/ssmy2/CreditController/deleteuser.do?creditIdbox=${credit.creditId}”>删除</a> </td> </tr> </c:forEach> </table> <c:if test=”${empty creditVOList }”> 没有任何员工信息. </c:if> <br/> <input type=”button” value=”删除” id =”deleteuser” > <input type=”text” name=”username”/> <input type=”file” name=”uploadFile”/> <input type=”submit” id=”uploadFile” name=”开始上传文件” value=”开始上传文件”/> <div id=”box” style=”border: 1px solid #ccc;”></div> </form>
{% endraw %}
