<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">

<title>${_res.get('student')} ${_res.get('courses_statistics')}</title>

<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
</style>
</head>
<body id="body">   
	<div id="wrapper" style="background: #2f4050;height:100%;">
	 <%@ include file="/common/left-nav.jsp"%>
	 <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
			<%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>

        <div class="margin-nav" style="margin-left:0;min-width:1000px;">

			<div class="col-lg-12" style="padding-left:0;">
				<div class="ibox float-e-margins">
				    <div class="ibox-title" style="margin-bottom:20px">
				        <h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; ${_res.get('student_management')}&gt; <a href="/student/index">${_res.get("student_list")}</a>&gt; ${_res.get('courses_statistics')}
					   </h5>
					   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
					</div>
					<div class="ibox-title">
						<h5>${_res.get('courses_statistics')} (${student.REAL_NAME })</h5>
						<a href="javascript:void(0)" onclick="window.history.go(-1)" class="btn btn-outline btn-primary" style="margin:-10px 10px 0 0;float: right">${_res.get('system.reback')}</a>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
							<tr align="center">
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("index")}</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('type.of.class')}</th>
								<th colspan="2" style="height:15px;line-height: 15px;border-bottom-width: 0;padding:2px 0;">${_res.get('total.sessions')}</th>
								<th colspan="2" style="height:15px;line-height: 15px;border-bottom-width: 0;padding:2px 0;">${_res.get('course.subject')}</th>
								<th colspan="2" style="height:15px;line-height: 15px;border-bottom-width: 0;padding:2px 0;">${_res.get('course.course')}</th>
							</tr>
							<tr style="font-size: 12px;line-height: 15px;">
								<th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get("purchases.in.advance")}(${_res.get("session")})</th>
								<th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get("scheduled.classes")}(${_res.get("session")})</th>
								<th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get('admin.dict.property.name')}</th>
								<!-- <th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get("purchases.in.advance")}(${_res.get("session")})</th> -->
								<th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get("scheduled.classes")}(${_res.get("session")})</th>
								<th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get('admin.dict.property.name')}</th>
								<!-- <th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get("purchases.in.advance")}(${_res.get("session")})</th> -->
								<th style="height:15px;line-height: 15px;font-weight: normal;padding:2px 0;">${_res.get("scheduled.classes")}(${_res.get("session")})</th>
							</tr>
							</thead>
							<tbody>
								<c:if test="${student.zksvip>0 }">
									<tr align="center">
										<td rowspan="${student.vlength }" style="line-height:${student.vlength };vertical-align: middle;">1</td>
										<td rowspan="${student.vlength }" style="line-height:${student.vlength };vertical-align: middle;">${_res.get("IEP")}</td>
										<td rowspan="${student.vlength }" style="line-height:${student.vlength };vertical-align: middle;">${student.zksvip }</td> 
										<td rowspan="${student.vlength }" style="line-height:${student.vlength };vertical-align: middle;">${student.ypvip }</td>
										<c:forEach items="${student.vsubject}" var="vsubject" varStatus="sindex" >
											<tr align="center">
												<td rowspan="${vsubject.subjectlength }" style="line-height:${student.vlength };vertical-align: middle;">${vsubject.SUBJECT_NAME }</td>
												<%-- <td rowspan="${vsubject.subjectlength }" >${vsubject.chour }</td> --%>
												<td rowspan="${vsubject.subjectlength }" style="line-height:${student.vlength };vertical-align: middle;">${vsubject.ypcourse==null?0:vsubject.ypcourse }</td>
												<c:forEach items="${vsubject.vcourselist}" var="course" varStatus="cindex">
													<tr align="center">
														<td style="vertical-align: middle;">${course.COURSE_NAME }</td>
														<%-- <td>${course.chour }</td> --%>
														<td style="vertical-align: middle;">${course.ypcourse==null?0:course.ypcourse }</td>
													</tr>
												</c:forEach> 
											</tr>
										</c:forEach>
									</tr>
								</c:if>
								<c:if test="${student.zksxb>0 }">
									<tr align="center">
										<td rowspan="${student.xblength }" style="line-height:${student.vlength };vertical-align: middle;"><c:if test="${student.zksvip>0 }">2</c:if><c:if test="${student.zksvip==0 }">1</c:if></td>
										<td rowspan="${student.xblength }" style="line-height:${student.vlength };vertical-align: middle;">${_res.get('course.classes')}
												<c:forEach items="${student.classordername }" var="classname" >
													<div style="height:15px; line-height: 15px;">${classname.classNum }</div>
												</c:forEach>
										</td>
										<td rowspan="${student.xblength }" style="line-height:${student.vlength };vertical-align: middle;">${student.zksxb }</td>
										<td rowspan="${student.xblength }" style="line-height:${student.vlength };vertical-align: middle;">${student.ypxb }</td>
										<c:forEach items="${student.xbsubject}" var="subject" varStatus="index" >
											<tr align="center">
												<td rowspan="${subject.xbcourselength }" style="line-height:${student.vlength };vertical-align: middle;">${subject.SUBJECT_NAME }</td>
												<%-- <td rowspan="${subject.xbcourselength }" >${subject.chour }</td> --%>
												<td rowspan="${subject.xbcourselength }" style="line-height:${student.vlength };vertical-align: middle;">${subject.ypcourse==null?0:subject.ypcourse }</td>
												<c:forEach items="${subject.xbcourselist}" var="course" varStatus="xbindex">
													<tr align="center">
														<td style="vertical-align: middle;">${course.COURSE_NAME }</td>
														<%-- <td>${course.chour }</td> --%>
														<td style="vertical-align: middle;">${course.ypcourse==null?0:course.ypcourse }</td>
													</tr>
												</c:forEach> 
											</tr>
										</c:forEach>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div style="clear:both "></div>
		</div>
	   </div>
	</div>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
    <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script>
    $('li[ID=nav-nav1]').removeAttr('').attr('class','active');
    //$(".left-nav").css("height", window.screenLeft);
    //alert($("#wrapper").outerHeight(true));
    </script>
</body>
</html>