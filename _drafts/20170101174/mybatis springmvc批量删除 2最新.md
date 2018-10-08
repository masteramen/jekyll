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

     if ($(“#SelectAll”).is
{% endraw %}
