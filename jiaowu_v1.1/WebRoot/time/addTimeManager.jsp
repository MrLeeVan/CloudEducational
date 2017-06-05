<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>添加时段</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

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
	$(function() {//时间段初始化
		var startHourStr = "";
		var endHourStr = "";
		var startMinStr = "";
		var endMinStr = "";
		for (var i = 0; i <= 23; i++) {
			if (i < 10) {
				startHourStr += '<option value="0'+i+'">0' + i + '</option>';
				endHourStr += '<option value="0'+i+'">0' + i + '</option>';
			} else {
				startHourStr += '<option value="'+i+'">' + i + '</option>';
				endHourStr += '<option value="'+i+'">' + i + '</option>';
			}
		}
		for (var i = 0; i <= 59; i += 5) {
			if (i < 10) {
				startMinStr += '<option value="0'+i+'">0' + i + '</option>';
				endMinStr += '<option value="0'+i+'">0' + i + '</option>';
			} else {
				startMinStr += '<option value="'+i+'">' + i + '</option>';
				endMinStr += '<option value="'+i+'">' + i + '</option>';
			}
		}
		$("#startHour").append(startHourStr);
		$("#endHour").append(endHourStr);
		$("#startMin").append(startMinStr);
		$("#endMin").append(endMinStr);
		$("#startHour").val('${startHour}');
		$("#endHour").val('${endHour}');
		$("#startMin").val('${startMin}');
		$("#endMin").val('${endMin}');
	});
	function addTimeManager() {
		var code = ${code};
		if (code == 1) {
			$("#timeMsg").text("改时段已被使用禁止修改！");
			return false;
		}
		if(clearMsg()&&hourMsg()){
			var rankname = $("#startHour").val()+":"+ $("#startMin").val()+"-"+$("#endHour").val()+":"+$("#endMin").val();
			var timeRankId = $("#timeRankId").val();
    		$.ajax({
    			url:"${cxt}/time/checkRankname",
    			type:"post",
    			data:{"id":timeRankId,"rankname":rankname},
    			dataType:"json",
    			success:function(data){
    				if(data.result){
    					$("#addTimeForm").attr("action", "/time/doAddTimeManager");
    					$("#addTimeForm").submit();
    				}else{
    					alert("该时段已存在！");
    				}
    			}
    		});
		}
	}
	function clearMsg() {
		var startHour = $("#startHour").val();
		var endHour = $("#endHour").val();
		var startMin = $("#startMin").val();
		var endMin = $("#endMin").val();
		var start = Number(endHour)-Number(startHour);
		var end = Number(endMin)-Number(startMin);
		if(start<0 || (start==0&&end<0)){
			$("#timeMsg").html("结束时间必须大于开始时间");
			return false;
		}else{
			$("#timeMsg").html("");
			return true;
			/* if(start == 0){
				$("#timeMsg").html("课时最少不能小于1课时");
				return false; 
			}else{
				if(end==30){
					$("#class_hour").val(start+0.5);
					$("#timeMsg").text(start+".5课时");
					return true;
				}else if(end == 0){
					$("#class_hour").val(start);
					$("#timeMsg").text(start+"课时");
					return true;
				}else{
					$("#timeMsg").text("开始分钟和结束分钟差为0或30分钟");
					return false;
				} 
			} */
		}
	}
	
	function hourMsg(){
		var classHour = $("#classHour").val();
		if(classHour.indexOf(".")!=-1){
			var str = classHour.split(".");
			if(str.length==2&&(str[1]=="5"||str[1]=="0")){
				$("#class_hour").val(classHour);
				$("#hourMsg").html("");
				return true;
			}else{
				$("#class_hour").val("");
				$("#hourMsg").html("只能填写整数课时或者小数位为5和0的课时");
				return false;
			}
		}else{
			if(classHour==""){
				$("#class_hour").val("");
				$("#hourMsg").html("请填写课时.");
				return false;
			}else{
				$("#class_hour").val(classHour);
				$("#hourMsg").html("");
				return true;
			}
		}
	}
	
</script>
<title>${_res.get('teacher.group.add')}&amp;修改时间段</title>

<style type="text/css">
label {
	width: 100px;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;min-width:1100px;">
	 <%@ include file="/common/left-nav.jsp"%>
     <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			     <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>
		
		<div class="margin-nav">	
		<div class="col-lg-12" style="margin: 0;">
			<div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					     <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					      &gt;<a href='/sysuser/index'>机构管理</a> &gt;<a href="/time/findTimeManager">时间段管理</a> &gt; ${_res.get('teacher.group.add')}&amp;修改时间段
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get('system.reback')}</a>
                   <div style="clear:both"></div>
				</div>
				<div class="ibox-content">
					<form action="" method="post" id="addTimeForm">
						<input type="hidden" name="timeRankId" id="timeRankId" value="${timeRankId }">
						<input type="hidden" name="class_hour" id="class_hour" value="${class_hour }">
						<fieldset>
							<p>
								<label><font color="red"> * </font>${_res.get('admin.sysLog.property.startdate')}:</label> 
								<select id="startHour" name="startHour" onchange="clearMsg()" class="form-control" style="display:inline;width: 80px;"></select>时： 
								<select id="startMin" name="startMin" onchange="clearMsg()" class="form-control" style="display:inline;width: 80px;"></select> 分
							</p>
							<p>
								<label><font color="red"> * </font>${_res.get("admin.sysLog.property.enddate")}:</label> 
								<select id="endHour" name="endHour" onchange="clearMsg()" class="form-control" style="display:inline;width: 80px;"></select>时： 
								<select id="endMin" name="endMin" onchange="clearMsg()" class="form-control" style="display:inline;width: 80px;"></select> 分
							</p>
							<p><label></label><span id="timeMsg" style="color: red"></span></p>
							<p>
								<label><font color="red"> * </font>${_res.get('session')}:</label>
									<input value="${class_hour}" id="classHour" type="text" name="classHour" onblur="hourMsg()"  />
								<span id="hourMsg" style="color: red"></span>
							</p>
							<%-- <p>
								<label><font color="red"> * </font>${_res.get('admin.common.order')}:</label>
								<c:choose>
									<c:when test="${param.rankType!=null}">
										<input value="${param.rankType}" type="text" id="rankType" name="rankType"  />
									</c:when>
									<c:otherwise>
										<input value="${rankType}" id="rankType" type="text" name="rankType"  />
									</c:otherwise>
								</c:choose>
							</p> --%>
							<p style="margin-top: 20px;">
							<c:if test="${operator_session.qx_timedoAddTimeManager }">
								<input type="button" value="${_res.get('save')}" onclick="return addTimeManager();" class="btn btn-outline btn-success" /> 
							</c:if>
							</p>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
		<div style="clear: both;"></div>
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