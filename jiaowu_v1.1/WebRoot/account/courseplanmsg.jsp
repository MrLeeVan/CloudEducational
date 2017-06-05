<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="save" content="history">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>课程信息</title>
<!-- Mainly scripts -->
<style type="text/css">
ul, ol, li {
	list-style: none;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
			<div class="row border-bottom yincang" style="margin: 0 0 60px;">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff;">
					   <%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="margin-nav">
				<div class="wrapper wrapper-content animated fadeInRight" style="padding:0 10px 40px">
					<div class="row">
					      <div class="ibox-title" style="margin-bottom: 20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
								<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> &gt;
								${_res.get("curriculum") } &gt; ${_res.get("curriculum_arrangement") }  <span id="mingcheng"></span>

							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback") }</a>
		  				    <div style="clear: both;"></div>
						  </div>
							<div class="col-lg-4 ui-sortable" style="padding-left:0">
								<div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>${_res.get("courselib.courseMsg") }</h5>
									</div>
									<div class="ibox-content">
									<ol>
										<li>
											<p>
												<span>${_res.get("teacher") }：</span> <span>${record.TEACHERNAME}</span>
											</p>
											<p>
												<span>${_res.get("course.course") }：</span> <span>${record.COURSENAME}</span>
											</p>
											<p>
												<span>${_res.get("course.class.date") }：</span> <span>${record.coursetime}</span>
											</p>
											<p>
												<span>${_res.get("system.time") }：</span> <span>${record.TIMENAME}</span>
											</p>
											<p>
												<span>${_res.get("courselib.location") }：</span> <span>${record.campusName}-${record.CLASSNAME}</span>
											</p> 
											<input type="hidden" id="courseTime" value="${record.coursetime}"> 
											<input type="hidden" id="teaId" value="${record.teatcherId}">
											<input type="hidden" id="TIMENAME" value="${record.TIMENAME}"> 
											<input type="hidden" id="stuId" value="${record.studentId}">
											<input type="hidden" id="signstate" value="${record.SIGNIN}">
										</li>
										</ol>
									</div>
								</div>
							</div>

							<div class="col-lg-4 ui-sortable">
								<div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>${_res.get("courselib.studentMsg") }</h5>
									</div>
									<div class="ibox-content">
										<c:choose>
											<c:when test="${!empty record.classNum }">
												<li>${_res.get("course.classes") }：${record.classNum }</li>
											</c:when>
											<c:otherwise>
												<li>${_res.get("courselib.trainee") }:${record.studentname }</li>
											</c:otherwise>
										</c:choose>
										<div style="text-align: right; margin-top: 50px;">
										<c:if test="${operator_session.qx_accountqueryStudentCourseInfo }">
											<a style="margin-down: 10px;" href="javascript: void(0)" class="dengemail" onclick="detail()">${_res.get("courselib.studentrecord") }</a>
										</c:if>
										</div>
									</div>
								</div>
							</div>
						<div style="clear: both;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
	<script type="text/javascript">
		function detail(){
			var studentid = $("#stuId").val();
	   		$.layer({
	   			type: 2,
			    shadeClose: true,
			    title: "${_res.get('courses_record')}",
			    closeBtn: [0, true],
			    shade: [0.5, '#000'],
			    border: [0],
			    offset:['50px', ''],
			    area: ['700px', '500px'],
	       	    iframe: {src: "/account/queryStudentCourseInfo/" + studentid}
	       	});
	    }
	</script>
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>

<script>
	$('li[ID=nav-nav4]').removeAttr('').attr('class', 'active');
</script>
</html>

