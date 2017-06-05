<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>时段管理</title>
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
	function delTime(timeId,state)
	{
		if(confirm('确认对该时段进行修改吗？')){
			$.ajax({
				url:"/time/delTimeManager",
				type:"post",
				data:{"timeRankId":timeId,"state":state},
				dataType:"json",
				success:function(result)
				{
					if(result.result=="true")
					{
						alert("操作成功");
						window.location.reload();
					}
					else
					{
						alert(result.result);
					}
				}
			});
		}
	}
	function modifyOrder(timeRankId){
		var sortorder=$("#sortorder_"+timeRankId).val();
		$.ajax({
			url:"/time/modifyTimeRankOrder",
			type:"post",
			data:{"timeRankId":timeRankId,"sortOrder":sortorder},
			dataType:"json",
			success:function(result){
				if(result.result=="true"){
					$("#successMsg").html("操作成功");
					$("span").fadeOut(1000,function(){
						window.location.reload();
					});
				}else{
					alert(result.result);
				}
			}
		});
	}	
</script>
<style type="text/css">
.stu_name {
	position: relative;
	margin-bottom: 15px;
}

.stu_name label {
	display: inline-block;
	font-size: 12px;
	vertical-align: middle;
	width: 170px;
}

.student_list_wrap {
	position: absolute;
	top: 28px;
	left: 14.8em;
	width: 130px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 8px;
}

.student_list_wrap li {
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: text;
}

.teacherTimeRankWrap {
	position: absolute;
	left: 37em;
	top: 16em;
	padding: 10px;
	overflow: hidden;
	z-index: 2013;
	background: #FCF2CF;
	border: 1px solid #F8BD81;
	box-shadow: 2px 2px 3px #DDD;
}

.teacherTimeRankWrap h1 {
	line-height: 24px;
	text-align: center;
	font-size: 14px;
	font-weigth: bold;
	margin-bottom: 10px;
	padding-bottom: 6px;
	border-bottom: 1px dotted #F8BD81;
}

#timeRankCloseBtn {
	display: inline-block;
	float: right;
	width: 18px;
	height: 18px;
	cursor: pointer;
}
#teacherTimeRank p {
	line-height: 24px;
	margin: 0;
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1100px">
  <%@ include file="/common/left-nav.jsp"%>
  <div class="gray-bg dashbard-1" id="page-wrapper">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
   <div class="margin-nav">	
  <div class="col-lg-12">
	<div class="ibox float-e-margins"">
	    <div class="ibox-title" style="margin-bottom:20px">
			<h5><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
			 &gt;<a href='/sysuser/index'>机构管理</a> &gt;时间段管理</h5>
			 <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
		</div>
		<div class="ibox-title">
			<h5>全部时间段</h5>
			<c:if test="${operator_session.qx_timetoAddTimeManager }">
				<input type="button" id="tianjia" class="navbar-right btn btn-outline btn-primary input_right" style="margin:-10px 10px 0 0;float: right;" value="${_res.get('teacher.group.add')}" onclick="window.location.href='/time/toAddTimeManager'">
			</c:if>
		</div>	
		<div class="ibox-content">
		    <table class="table table-hover table-bordered">
		         <thead>
						<tr>
							<th>${_res.get("index")}</th>
							<th>时间段</th>
							<th>${_res.get("class.number.of.class.sessions")}</th>
							<c:if test="${operator_session.qx_timedelTimeManager || operator_session.qx_timemodifyTimeRankOrder }">
							<th>操 作</th></c:if>
						</tr>
				 </thead>		
						<c:forEach items="${timeRanks}" var="timeRank" varStatus="s">
							<tr align="center">
								<td>${s.count }</td>
								<td>${timeRank.RANK_NAME }</td>
								<td>${timeRank.class_hour }</td>
								<c:if test="${operator_session.qx_timedelTimeManager || operator_session.qx_timemodifyTimeRankOrder }">
								<td>
									<c:if test="${operator_session.qx_timemodifyTimeRankOrder }">
									<a href="javascript:void(0)" style="color:#515151" onclick="window.location.href='/time/editTimeManager?timeRankId=${timeRank.id }'" >${_res.get('Modify')}</a>
									&nbsp;|&nbsp;
									</c:if>
									<c:if test="${operator_session.qx_timedelTimeManager }">
										<c:choose>
											<c:when test="${timeRank.state==1}">
												<a style="color:#515151" href="javascript:void(0)" onclick="delTime(${timeRank.id},0)">${_res.get('admin.dict.property.status.start')}</a>
											</c:when>
											<c:otherwise>
												<a style="color:#515151" href="javascript:void(0)" onclick="delTime(${timeRank.id},1)">${_res.get('Suspending')}</a>
											</c:otherwise>
										</c:choose>									
									</c:if>
								</td>
								</c:if>
							</tr>
						</c:forEach>
					</table>
					<p>
						<span id="successMsg" style="color:red"></span>
					</p>
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