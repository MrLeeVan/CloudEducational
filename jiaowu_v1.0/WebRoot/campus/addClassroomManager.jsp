<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>添加教室</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">

	function addClassroomManager() {
		if($("#classAddrMsg").html()!="")
		{
			alert("请检查教室名称");
			return false;
		}
		if ($("#classAddr").val() == ""||$("#classAddr").val() == null) {
			alert("请填写教室名称");
			return false;
		}
		
		
		$("#addClassForm").attr("action", "/campus/doAddClassroomManager");
		$("#addClassForm").submit();
		
	}
	function checkClassAddr()
	{
		var classAddr=$("#classAddr").val();
		var campusId=$("#campusId").val();
		if(classAddr!=null&&classAddr!="")
		{
			if('${classAddr}'!=null&&classAddr=='${classAddr}')
			{
				return;
			}
			$.ajax({
				url:"/campus/checkClassAddr",
				type:"post",
				data:{"classAddr":classAddr,"campusId":campusId},
				dataType:"json",
				success:function(data)
				{
					if(data)//同校区教室地址已存在
					{
						$("#classAddrMsg").html("教室名称已存在");
					}
				}
			});
		}
	}
	function clearMsg()
	{
		$("#classAddrMsg").html("");
	}
</script>

<style type="text/css">
label{
  width:80px;
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;">
  <div class="left-nav"><%@ include file="/common/left-nav.jsp"%></div>
   <div class="gray-bg dashbard-1" id="page-wrapper">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="margin-nav1">
  <div class="col-lg-12">
     <div class="ibox float-e-margins">
        <div class="ibox-title" style="margin-bottom:20px">
           <h5><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
           &gt;<a href='/sysuser/index'>机构管理</a> &gt; <a href="/campus/findClassroomManager?campusId=${campusId}">教室管理</a>
					&gt; ${_res.get('teacher.group.add')}&amp;修改教室
		   </h5>
		   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
           <div style="clear:both"></div>
        </div>
        <div class="ibox-title">
           <h5>${_res.get('teacher.group.add')}&amp;修改教室</h5>
        </div>
        <div class="ibox-content">
           <form action="" method="post" id="addClassForm">
					<input type="hidden" name="id" id="id" value="${id }">
					<input type="hidden" name="campusId" id="campusId" value="${campusId}">
					<fieldset>
						<p>
							<label><font color="red"> * </font>教室名称:</label> 
							<input type="text" id="classAddr" name="classAddr" value="${classAddress}" onblur="checkClassAddr()" onfocus="clearMsg()" />
							<span id="classAddrMsg" style="color:red"></span>
						</p>
						<p>
							<label><font color="red"> * </font>最大人数:</label> 
							<input type="text" id="maxpeople" name= "maxpeople"/>
						</p>
						<p>
						<c:if test="${operator_session.qx_campusdoAddClassroomManager }">
							<input type="submit" value="${_res.get('save')}" onclick="return addClassroomManager();"  class="btn btn-outline btn-primary"/>
						</c:if>
							<input type="button" onclick="window.history.go(-1)" value="${_res.get('system.reback')}" class="btn btn-outline btn-success"/>
						</p>
					</fieldset>
				</form>
        </div>
     </div>
   </div>
  </div>
  </div>
</div>        

 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/campus.js"></script>
    <script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
</body>
</html>