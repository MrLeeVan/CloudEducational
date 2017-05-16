<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<!-- Mainly scripts -->
<script src="/js/js/bootstrap.min.js?v=1.7"></script>
<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<!-- Custom and plugin javascript -->
<script src="/js/js/hplus.js?v=1.7"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>教案库</title>
<!-- Mainly scripts -->
<style type="text/css">
ul, ol, li {
	list-style: none;
}

.header {
	font-size: 12px;
}

.kechengjilu {
	display: inline;
	width: 60px;
	height: 34px;
	line-height: 34px;
	margin-top: 10px;
}

select {
	margin: 0px 0 0 10px;
}

.dengemail:hover {
	text-decoration: none;
}

#sign {
	width: 150px;
}
</style>
</head>
<script language="javascript" type="text/javascript">
	$(document).ready(
			function() {
				if ($('#returnMsg').html().length > 5) {
					$('#returnMsg').show();
				} else {
					$('#returnMsg').hide();
				}
				var coursename = $("#coursename").val();
				$("#mingcheng").html("" + coursename);
				var course_id = $("#course_id").val();
				var courseplan_id = $("#courseplan_id").val();
				//回显打分的信息
				$.ajax({
					type : "post",
					url : "/teachergrade/getTeachergrade",
					dataType : "json",
					data : {
						"courseplan_id" : courseplan_id
					},
					success : function(value) {
						if (value[0].ROLE == 1) {
							$("#zhuyili1").text(value[0].ATTENTION);
							$("#lijieli1").text(value[0].UNDERSTAND);
							$("#xuxitaidu1").text(value[0].STUDYMANNER);
							$("#beizhu1").text(value[0].REMARK);
							$("#bencikecheng1").text(value[0].COURSE_DETAILS);
							$("#bencizuoye1").text(value[0].HOMEWORK);
							$("#shangcizuoye1").text(value[0].STUDYTASK);
							$("#question").text(value[0].QUESTION);
							$("#method").text(value[0].METHOD);
							$("#tutormsg").text(value[0].TUTORMSG);
						} else if (value[0].ROLE == 2) {
							$("#zhuyili2").text(value[0].ATTENTION);
							$("#lijieli2").text(value[0].UNDERSTAND);
							$("#xuxitaidu2").text(value[0].STUDYMANNER);
							$("#beizhu2").text(value[0].REMARK);
							$("#shangcizuoye2").text(value[0].STUDYTASK);
							$("#beizhu2").text(value[0].REMARK);
						} else {
							$("#zhuyili1").text(value[0].ATTENTION);
							$("#lijieli1").text(value[0].UNDERSTAND);
							$("#xuxitaidu1").text(value[0].STUDYMANNER);
							$("#beizhu1").text(value[0].REMARK);
							$("#bencikecheng1").text(value[0].COURSE_DETAILS);
							$("#bencizuoye1").text(value[0].HOMEWORK);
							$("#shangcizuoye1").text(value[0].STUDYTASK);
							$("#zhuyili2").text(value[0].ATTENTION);
							$("#lijieli2").text(value[0].UNDERSTAND);
							$("#xuxitaidu2").text(value[0].STUDYMANNER);
							$("#beizhu2").text(value[0].REMARK);
							$("#shangcizuoye2").text(value[0].STUDYTASK);
							$("#beizhu2").text(value[0].REMARK);
						}
					}
				});
				var course_id = $("#course_id").val();
				$.ajax({
					type : "post",
					url : "/course/getSignMessage?studentId=" + $("#studentId").val() + "&&courseplan_id=" + $("#courseplan_id").val(),
					dataType : "json",
					success : function(value) {
						$("#course").html(value.record4);
						$("#coursePlan").html(value.record1.COURSENUM);
						$("#signCourse").html(value.record2.SIGNNUM);
						$("#noSignCourse").html(value.record3);
						$("#happen").html(value.record6.HAPPEN);
						$("#late").html(value.record5);

					},
					error : function(error) {
						// alert(error);
					}
				});
				$.ajax({
					type : "post",
					url : "/account/getStudentMessage?studentId=" + $("#studentId").val(),
					dataType : "json",
					success : function(value) {
						if (value.errorMessage != null) {
							alert(value.errorMessage);
							window.location.href = "/course/courseSort_month.jsp";
						}
						if (value.remark == null) {
							$("#remark").append("<li>${_res.get('course.remarks')}：${_res.get('courselib.nomessage')}</li>");
						} else {
							$("#remark").append("<li class='clearfix'><span class='fl'>${_res.get('course.remarks')}：</span><span style='display: block;width: 230px;' class='fl SM-Num'>" + value.remark + "</span></li>");
						}
						if (value.pqList == null) {
							$("#grade1").append("<li>暂无分数信息</li>");
						} else {
							for (i in value.pqList) {
								$("#grade1").append("<div><li>" + value.pqList[i].SUBJECTNAME + "培前分数：");
								for (j in value.pqList[i].DETAIL) {
									$("#grade1").append("<br><span><label class='duiqi'>" + value.pqList[i].DETAIL[j].COURSENAME + ":</label>" + value.pqList[i].DETAIL[j].SCORE + "</span></div></li><br>");
								}
							}
						}
						if (value.phList == null) {
							$("#grade2").append("<li>暂无分数信息</li>");
						} else {
							for (i in value.phList) {
								$("#grade2").append("<div><li>" + value.phList[i].SUBJECTNAME + "培后分数：");
								for (j in value.phList[i].DETAIL) {
									$("#grade2").append( "<br><span><label class='duiqi'>" + value.phList[i].DETAIL[j].COURSENAME + ":</label>" + value.phList[i].DETAIL[j].SCORE + "</span></li></div><br>");
								}
							}
						}
					},
					error : function(error) {
						// alert(error);
					}
				});

			});
</script>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom yincang" style="margin: 0 0 60px;">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff;border:0">
					<div class="navbar-header">
						<input type="hidden" id="course_id" value="${course_id}" /> 
						<input type="hidden" id="courseplan_id" value="${courseplan_id}" /> 
						<input type="hidden" id="coursename" value="${coursename}" /> 
						<input type="hidden" id="returnUrl" value="${returnUrl}" /> 
						<input type="hidden" id="studentId" value="${studentId}" /> 
						<input type="hidden" id="campusId" value="${campusId}" /> 
						<input type="hidden" id="courseDate" value="${courseDate}" /> 
						<input type="hidden" id="rankTime" value="${rankTime}" />
						<input type="hidden" id="understandings" value="${_res.get('understanding')}" />
						<input type="hidden" id="attentions" value="${_res.get('attention')}" />
					</div>
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="margin-nav">
				<div class="wrapper wrapper-content animated fadeInRight" style="padding:0 10px 40px">
					<div class="row">
					   <div class="ibox-title" style="margin-bottom:20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
								<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> &gt;
								${_res.get("curriculum") } &gt; ${_res.get("curriculum_arrangement") } &gt; <span id="mingcheng"></span>
							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback") }</a>
			                <div style="clear: both;"></div>
						</div>
								<div class="col-lg-4 ui-sortable" style="padding-left:0">
									<div class="ibox float-e-margins">
										<div class="ibox-title">
											<h5>${_res.get("courselib.monthCount") }</h5>
										</div>
										<div class="ibox-content">
											<div id="message">
												<li><c:if test="${((record.tworktype eq '1' && record.fullsign==true) || (record.tworktype eq '0'&& record.partsign==true))}">
														<a href="javascript: void(0)" id="sign" onclick="signin()" class="btn btn-outline btn-primary"></a>
													</c:if> 
													<c:if test="${((record.tworktype eq '1' && record.fullsign==true)||(record.tworktype eq '0' && record.partsign==true))}">
														<p>
															<label class="duiqi">${_res.get("courselib.normalCourse") }：</label><span id="course"></span>
														</p>
													</c:if>
													<p>
														<label class="duiqi">${_res.get("courselib.planedCourse") }：</label><span id="coursePlan"></span>节&nbsp;|&nbsp;${_res.get("courselib.finishedCourse") }：<span id="happen"></span>节
													</p> 
													<c:if test="${((record.tworktype eq '1' && record.fullsign==true)||(record.tworktype eq '0' && record.partsign==true))}">
														<p>
															<label class="duiqi">${_res.get("courselib.Signin") }：</label>
															<span id="signCourse" style="color: green;"></span>节&nbsp;|&nbsp;
															${_res.get("courselib.notSignin") }：<span id="noSignCourse" style="color: red;"></span>节 &nbsp;|&nbsp;
															${_res.get("courselib.late") }：<span id="late"></span>节
														</p>
														<c:if test="${operator_session.qx_courseplangetTeacherMessage }">
															<a href="/courseplan/getTeacherMessage?_query.tid=${record.teatcherId}&_query.startTime=${record.courseTime}" class="dengemail">${_res.get("courselib.historycount") }</a>
														</c:if>
													</c:if></li>
											</div>
										</div>
									</div>
								</div>
							<div class="col-lg-4 ui-sortable">
								<div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>${_res.get("courselib.courseMsg") }</h5>
										
									</div>
									<div class="ibox-content">
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
									</div>
								</div>
							</div>

							<div class="col-lg-4 ui-sortable" style="padding-right:0">
								<div class="ibox float-e-margins">
									<div class="ibox-title">
										<h5>${_res.get("courselib.studentMsg") }</h5>
									</div>
									<div class="ibox-content">
									<a href="javascript: void(0)" style="width:150px;" onclick="callName()" class="btn btn-outline btn-primary">${_res.get("courselib.name") }</a>
										<c:if test="${!empty class_num}">
											<li>${_res.get("course.classes") }：${class_num }</li>
										</c:if>
										<li>
										<c:forEach items="${stu }" var="stu" varStatus="s">
												<div style="display: block; margin-bottom: 10px; float: left;">
													<a href="/knowledge/educationalManage?courseplanId=${stu.Id }"> 
													<c:choose>
														<c:when test="${record.STUDENTNAME eq stu.REAL_NAME}">
															<span style="color: blue;">${stu.REAL_NAME }</span>
														</c:when>
													<c:otherwise>
														${stu.REAL_NAME }
													</c:otherwise>
													</c:choose>
													</a>&nbsp;|&nbsp;
												</div>
											</c:forEach></li>
										<li id="grade1"></li>
										<li id="grade2"></li>
										<li id="remark"></li>
										<div style="text-align: right; margin-top: 48px;">
										<c:if test="${operator_session.qx_accountqueryStudentInfo }">
											<a style="margin-down: 10px;" href="javascript: void(0)" class="dengemail" onclick="detail()">${_res.get("courselib.queryDetail") }</a>
										</c:if>
										</div>
									</div>
								</div>
							</div>


						<div class="col-lg-12 ui-sortable" style="padding-left:0;padding-right:0">
							<div class="zsd-cont-r">
								<div id="paihaodiv">
									<h5>
										<!-- <font class="fsize14 c-666">上课内容</font>
							<a href="#" onclick="allMove()" style="text-decoration: none">全部移除</a> 
							-->
									</h5>
									<ul class="op-list" id="paihao">
									</ul>
								</div>
								<!-- <fieldset id="searchTable" style="width: auto;"> -->
								<div class="ibox-content" id="jiaowu_pingjia" style="margin-bottom: 20px">
									<form action="/teachergrade/saveTeachergrade" method="post">
										<input type="hidden" id="stuNum" value="${stuNum}" />
										<input type="hidden" id="courseplanid" value="${courseplan_id}" name="courseplanid"/>
											<span id="returnMsg" style="color: red; font-size: 20px;">消息提示：${message }</span>
											<h5>
												<font>${_res.get("courselib.teacher.evaluation") }(${_res.get("courselib.comment.remark") })</font>
											</h5>
											<hr>
											<ol class="teacher-comment-sele" style="padding: 0">
												<div ${assessment==0?"style='display: none'":""}>
												<c:forEach items="${stu }" var="stu" varStatus="stuCount">
													<div class="student_jiaowu">
														<font>${_res.get("courselib.trainee")}：${stu.REAL_NAME }</font> <input type="hidden" value="${stu.Id }" id="cp${stu.Id}" name="courseplan_id">
													</div>
													<li>
														<div class="col-lg-3" style="margin: 10px 0;">
															<span class="kechengjilu">${_res.get("attention")}:</span> 
															<select name="zhuyili1" id="zhuyili1${stu.Id }">
																<option value="优">--${_res.get("excellent")}--</option>
																<option value="良">--${_res.get("good")}--</option>
																<option value="中">--${_res.get("average")}--</option>
																<option value="差">--${_res.get("poor")}--</option>
															</select>
														</div>
														<div class="col-lg-3" style="margin: 10px 0;">
															<span class="kechengjilu">${_res.get("understanding")}:</span> <select name="lijieli1" id="lijieli1${stu.Id }">
																<option value="优">--${_res.get("excellent")}--</option>
																<option value="良">--${_res.get("good")}--</option>
																<option value="中">--${_res.get("average")}--</option>
																<option value="差">--${_res.get("poor")}--</option>
															</select>
														</div>
														<div class="col-lg-3" style="margin: 10px 0;">
															<span class="kechengjilu">${_res.get("study.attitude")}:</span> <select name="xuxitaidu1" id="xuxitaidu1${stu.Id }">
																<option value="优">--${_res.get("excellent")}--</option>
																<option value="良">--${_res.get("good")}--</option>
																<option value="中">--${_res.get("average")}--</option>
																<option value="差">--${_res.get("poor")}--</option>
															</select>
														</div>
														<div class="col-lg-3" style="margin: 10px 0;">
															<span class="kechengjilu">${_res.get("last.homework")}:</span> <select name="shangcizuoye1" id="shangcizuoye1${stu.Id }">
																<option value="未布置">--${_res.get("Not_furnished")}--</option>
																<option value="完成较好">--${_res.get("Well_completion")}--</option>
																<option value="完成较差">--${_res.get("Completion_poor")}--</option>
																<option value="未完成">--${_res.get("incomplete")}--</option>
															</select>
														</div>
														<div style="clear: both;"></div>
													</li>
													<br>
													<c:if test="${operator_session.qx_coursequeryTeacherCoursePlanDetail }">
														<span> 
															<a style="font-size: 14px;" class="dengemail" href="/course/queryTeacherCoursePlanDetail?studentName=${stu.REAL_NAME}&stuNum=${stuCount.count}" title="${_res.get('courses_record') }">${_res.get("courses_record") }</a>
														</span>
													</c:if>
													<hr>
													<script language="javascript">
														$(function() {
															var cplan_id = "${stu.Id }";
															$.ajax({
																url : '/teachergrade/getTeachergrade',
																type : 'post',
																data : {
																	'courseplan_id' : cplan_id,
																},
																dataType : 'json',
																success : function(data) {
																	$("#zhuyili1" + cplan_id).val(data[0].ATTENTION);
																	$("#lijieli1" + cplan_id).val(data[0].UNDERSTAND);
																	$("#xuxitaidu1" + cplan_id).val(data[0].STUDYMANNER);
																	$("#shangcizuoye1" + cplan_id).val(data[0].STUDYTASK);
																}
															});
														});
													</script>
												</c:forEach>
												</div>
											</ol>
												<li><span>${_res.get('The.course')}:</span> 
												<textarea id="bencikecheng1" name="teachergrade.COURSE_DETAILS" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="5"></textarea></li>
												<li><span>${_res.get('This.job')}:</span> <textarea id="bencizuoye1" name="teachergrade.homework"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="5"></textarea></li>
												<li><span>${_res.get("qs.in.homework")}:</span> <textarea id="question" name="teachergrade.question"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="5"></textarea></li>
												<li><span>${_res.get("solutions")}:</span> <textarea id="method" name="teachergrade.method"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="5"></textarea></li>
												<li><span>${_res.get("course.remarks")}/${_res.get("reminder")}:</span> <textarea id="tutormsg" name="teachergrade.tutormsg"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="5"></textarea></li>
											<div>
												<span id="returnMsg">消息提示：${message }</span> &nbsp;<font>${_res.get('student')}：${record.STUDENTNAME}</font>
												<hr>
												<input type="hidden" id="courseplan_id" name="courseplan_id" value="${courseplan_id}">
												<h5>
													<font>${_res.get('Student.classroom.performance')}</font>
												</h5>
												<br> 
												<span>${_res.get("attention")}:</span> <label id="zhuyili1"></label> <span>${_res.get("understanding")}:</span> <label id="lijieli1"></label> 
												<span>${_res.get("last.homework")}:</span> <label id="shangcizuoye1"></label> <span>${_res.get("study.attitude")}:</span> <label id="xuxitaidu1"></label> <br>
												<li><span>${_res.get('The.course')}:</span> <textarea id="bencikecheng1" name="teachergrade.COURSE_DETAILS"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="10" readonly="readonly"></textarea></li>
												<li><span>${_res.get('This.job')}:</span> <textarea id="bencizuoye1" name="teachergrade.HOMEWORK"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="10" readonly="readonly"></textarea></li>
												<li><span>${_res.get("qs.in.homework")}:</span> <textarea id="question" name="teachergrade.question"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="10" readonly="readonly"></textarea></li>
												<li><span>${_res.get("solutions")}:</span> <textarea id="method" name="teachergrade.method"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="10" readonly="readonly"></textarea></li>
												<li><span>${_res.get("course.remarks")}/${_res.get("reminder")}:</span> <textarea id="tutormsg" name="teachergrade.tutormsg"
														style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 98%;" rows="10" readonly="readonly"></textarea></li>
												<h5>
													<font>教师课堂评价</font>
												</h5>
												<span>${_res.get("knowledge")}:</span> <label id="zhuyili2"></label> <span>${_res.get("logic")}:</span> <label id="lijieli2"></label> <span>${_res.get("responsibility")}:</span> <label
													id="shangcizuoye2"></label> <span>${_res.get("amiableness")}:</span> <label id="xuxitaidu2"></label> <br> <span>${_res.get("course.remarks")}:</span> <label id="beizhu2"></label> <br>
												<hr>
												</div>
											<input type="hidden" id="courseplan_id" value="${courseplan_id}" name="courseplan_id" />
											<input type="hidden" id="stuNum" value="${stuNum - 1}" name="stuNum" />
											<span id="returnMsg">消息提示：${message }</span>
											<hr>
											<h5>
												<font>学生课堂信息</font>
											</h5>
											<span>${_res.get('The.course')}:&nbsp;&nbsp;&nbsp;</span>
											<label id="bencikecheng1"></label>
											<br>
											<br>
											<span>${_res.get('This.job')}:&nbsp;&nbsp;&nbsp;</span>
											<label id="bencizuoye1"></label>
											<br>
											<br>
											<span>${_res.get("qs.in.homework")}:&nbsp;&nbsp;&nbsp;</span>
											<label id="question"></label>
											<br>
											<br>
											<span>${_res.get("solutions")}:&nbsp;&nbsp;&nbsp;</span>
											<label id="method"></label>
											<br>
											<br>
											<span>${_res.get("course.remarks")}/${_res.get("reminder")}:&nbsp;&nbsp;&nbsp;</span>
											<label id="tutormsg"></label>
											<hr>
											<h5>
												<font>教师课堂评价</font>
											</h5>
											<ol>
												<div style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">${_res.get("knowledge")}：</label> 
													<select name="zhuyili1" id="zhuyili1" class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" selected="selected">${_res.get("excellent")}</option>
															<option value="良">${_res.get("good")}</option>
															<option value="中">${_res.get("average")}</option>
															<option value="差">${_res.get("poor")}</option>
													</select>
													</li>
												</div>
												<div class="form-group" style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">${_res.get("logic")}：</label> <select name="lijieli1" id="lijieli1"
														class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" selected="selected">${_res.get("excellent")}</option>
															<option value="良">${_res.get("good")}</option>
															<option value="中">${_res.get("average")}</option>
															<option value="差">${_res.get("poor")}</option>
													</select></li>
												</div>

												<div class="form-group" style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">${_res.get("responsibility")}：</label> <select name="shangcizuoye1" id="shangcizuoye1"
														class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" selected="selected">${_res.get("excellent")}</option>
															<option value="良">${_res.get("good")}</option>
															<option value="中">${_res.get("average")}</option>
															<option value="差">${_res.get("poor")}</option>
													</select></li>
												</div>
												<div class="form-group" style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">${_res.get("amiableness")}：</label> <select name="xuxitaidu1" id="xuxitaidu1"
														class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" selected="selected">${_res.get("excellent")}</option>
															<option value="良">${_res.get("good")}</option>
															<option value="中">${_res.get("average")}</option>
															<option value="差">${_res.get("poor")}</option>
													</select></li>
												</div>
												<div class="form-group" style="margin: 10px 0; margin-left: -6px">
													<label class="col-sm-3 control-label" style="font-weight: normal;">${_res.get("course.remarks")}：</label>
													<div class="col-sm-8">
														<textarea id="beizhu1" name="teachergrade.REMARK" class="form-control" rows="2"></textarea>
													</div>
												</div>
											</ol>
											<div style="clear: both; margin-bottom: 10px;"></div>
									</form>
									<c:if test="${operator_session.qx_teachergradesaveTeachergrade }">
										<div align="center" class="form-group">
											<input class="btn btn-outline btn-primary" type="button" onclick="return saveTeachergrade()" value="${_res.get('admin.common.submit') }">&nbsp;&nbsp; 
											<!-- <input class="btn btn-outline btn-success" type="button" onclick="clearTeachergrade()" value="清空"> -->
										</div>
										<div style="clear: both;"></div>
									</c:if>
								</div>
								<!-- </fieldset> -->
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
<script language="javascript" type="text/javascript">

	//签到方法
	function signin() {
		var TIMENAME = $("#TIMENAME").val();
		var courseplan_id = $("#courseplan_id").val();
		var courseTime = $("#courseTime").val();
		$.ajax({
			url : "/course/siGninCourese?courseplan_id=" + courseplan_id + "&&TIMENAME=" + TIMENAME + "&&courseTime=" + courseTime,
			dataType : "json",
			type : "post",
			success : function(result) {
				if (result.message == "no") {
					alert('${_res.get("educational_manage_1") }');
				} else if (result.message == "notearly") {
					alert('${_res.get("educational_manage_2") }');
				} else if (result.message == "NotDay") {
					alert('${_res.get("educational_manage_3") }');
				} else if (result.message == "short") {
					alert('${_res.get("educational_manage_4") }');
				} else if (result.message == "campusfullno") {
					alert('${_res.get("educational_manage_5") }');
				} else if (result.message == "campuspartno") {
					alert('${_res.get("educational_manage_6") }');
				} else if (result.message == "ok") {
					//在这加签到效果
					$("#sign").html("签到成功");
					$.ajax({
						type : "post",
						url : "/course/getSignMessage?studentId=" + $("#studentId").val() + "&&courseplan_id=" + $("#courseplan_id").val(),
						dataType : "json",
						success : function(value) {
							$("#course").html(value.record4);
							$("#coursePlan").html(value.record1.COURSENUM);
							$("#signCourse").html(value.record5);
							$("#noSignCourse").html(value.record3);
							$("#happen").html(value.record6.HAPPEN);
							$("#late").html(value.record5);

						},
						error : function(error) {
							alert(error);
						}
					});
				} else if (result.message == "not") {

				} else if (result.message.late != "") {
					$("#sign").html("${_res.get('courselib.late')}" + result.message.late + "分钟");
					$.ajax({
						type : "post",
						url : "/course/getSignMessage?studentId=" + $("#studentId").val() + "&&courseplan_id=" + $("#courseplan_id").val(),
						dataType : "json",
						success : function(value) {
							$("#course").html(value.record4);
							$("#coursePlan").html(value.record1.COURSENUM);
							$("#signCourse").html(value.record5);
							$("#noSignCourse").html(value.record3);
							$("#happen").html(value.record6.HAPPEN);
							$("#late").html(value.record5);
						},
						error : function(error) {
							alert(error);
						}
					});
				}
			},
			error : function(error) {
				alert("fault");
			}
		})
	}
	//点名方法
	 function callName(){
		var TIMENAME = $("#TIMENAME").val();
		var courseplan_id = $("#courseplan_id").val();
		var courseTime = $("#courseTime").val();
		var courseid = $("#course_id").val();
		var campusid = $("#campusId").val();
		var courseDate =$("#courseDate").val(); 
		var rankTime =$("#rankTime").val(); 
		var teaId =$("#teaId").val(); 
		$.ajax({
			url : "/course/siGninCourese?courseplan_id=" + courseplan_id + "&&TIMENAME=" + TIMENAME + "&&courseTime=" + courseTime,
			dataType : "json",
			type : "post",
			success : function(result) {
				if (result.message == "no") {
					alert("非校区内不支持此功能");
					return;
				} /* else if (result.message == "NotDay") {
					alert("只能记录当天的点名情况");
					return ;
				} */ else{
					$.layer({
				   	    type: 2,
				   	    shadeClose: true,
				   	    title: "${_res.get('student_attendence') }",
				   	    closeBtn: [0, true],
				   	    shade: [0.5, '#000'],
				   	    border: [0],
				   	    area: ['600px', '200px'],
				   	    iframe: {src: "/course/callNameMessage?campusid=" + campusid
				   	    		+ "&&courseDate=" + courseDate+"&&teaId=" + teaId+"&&rankTime="+rankTime}
				   	}); 
				}
			}
		});
		
	}
	//提交老师打分数据 
	function saveTeachergrade() {
		$("*[name='zhuyili1']").each(function() {
			if ($(this).val() == 0) {
				alert('请选择评语!');
				return false;
			} else {
				$("*[name='lijieli1']").each(function() {
					if ($(this).val() == 0) {
						alert('请选择评语!');
						return false;
					} else {
						$("*[name='xuxitaidu1']").each(function() {
							if ($(this).val() == 0) {
								alert('请选择评语!');
								return false;
							} else {
								$("*[name='shangcizuoye1']").each(function() {
									if ($(this).val() == 0) {
										alert('请选择评语!');
										return false;
									} else {
										document.forms[0].submit();
									}
								});
							}
						});
					}
				});
			}
		});

	}

	function clearTeachergrade() {
		if (confirm("是否清空评论？")) {
			
				$("*[name='zhuyili1']").each(function() {
					$(this).attr("value", "0");
				});
				$("*[name='lijieli1']").each(function() {
					$(this).attr("value", "0");
				});
				$("*[name='xuxitaidu1']").each(function() {
					$(this).attr("value", "0");
				});
				$("*[name='shangcizuoye1']").each(function() {
					$(this).attr("value", "0");
				});
				$("#bencikecheng1").attr("value", "");
				$("#bencizuoye1").attr("value", "");
		}
	}
	//弹出子窗口 
	function childwindow() {
		var mask = $('<div></div>').appendTo($("body")).addClass("black-bg");
		var oEl = $('<div></div>').appendTo($('body')).addClass("modal");
		var doc = $(
				'<div class="modalWrap">' + '<div class="modal_head">' + '<span class="fr">'
						+ '<a href="javascript:void(0)" title="关闭" class="icon14 closeBtn"></a>' + '</span>' + '<table id="tasks" width="100%">'
						+ '<tr>' + '<td>' + '<span>老师布置的作业1</span><input type="checkbox" id="abc0" value="老师布置的作业1"/>' + '</td>' + '</tr>' + '<tr>'
						+ '<td>' + '<span>老师布置的作业2</span><input type="checkbox" id="abc1" value="老师布置的作业2"/>' + '</td>' + '</tr>' + '<tr>' + '<td>'
						+ '<span>老师布置的作业3</span><input type="checkbox" id="abc2" value="老师布置的作业3"/>' + '</td>' + '</tr>' + '<tr>' + '<td>'
						+ '<span>老师布置的作业4</span><input type="checkbox" id="abc3" value="老师布置的作业4"/>' + '</td>' + '</tr>' + '</table>' + '</div>'
						+ '<div class="modal_foot clearfix">' + '<input type="button" value="提交" onclick="tijiao()"/>&nbsp;&nbsp;&nbsp;&nbsp;'
						+ '<input class="btn btn-close" type="button" value="关 闭" />' + '</div>' + '</div>').prependTo($(".modal"));
		$(".closeBtn,.btn-close,.black-bg").bind("click", function() {
			$(".modal").remove();
			$(".black-bg").remove();
		});
	}
	function tijiao() {
		//调用考试系统的接口获取数据
		var count = $("#tasks").find("input");
		$("#selectzuoye").find("label").remove();
		$("#selectzuoye").find("br").remove();
		var selectzuoye = $("#selectzuoye");
		for (var i = 0; i < count.length; i++) {
			if ($("#abc" + i + "").is(":checked")) {
				selectzuoye.append('<label>' + $("#abc" + i + "").val() + '</label><br>');
			}
		}
		closed();
	}
	function closed() {
		$(".modal").remove();
		$(".black-bg").remove();
	}
	$(function() {
		var signin = $("#signstate").val();
 		if (signin == 1) {
			$("#sign").html('${_res.get("courselib.Signin")}');
		} else if (signin == 0) {
			$("#sign").html('${_res.get("courselib.sign")}');
		} else if (signin == 2) {
			$("#sign").html('${_res.get("courselib.late")}');
		}else{
			$("#sign").html('${_res.get("Has.retroactive")}${_res.get("admin.sysLog.property.status.success")}');
		} 
	});

	//弹出子窗口     添加
	function childwindow2() {
		var understanding = $("#understandings").val();
		var attention = $("#attentions").val();
		var mask = $('<div></div>').appendTo($("body")).addClass("black-bg");
		var oEl = $('<div></div>').appendTo($('body')).addClass("modal").css({
			"width" : "1000px",
			"margin-left" : "-550px",
			"top" : "80px"
		});
		var winH = parseInt(document.documentElement.clientHeight, 10);
		var doc = $(
				'<div class="modalWrap">'
						+ '<div class="modal_head"><span class="fr"><a href="javascript:void(0)" title="关闭" class="icon14 closeBtn"></a></span><h4><span>学习科目&gt;${_res.get("grade.Reading")}</span></h4></div>'
						+ '<div class="modal_body" id="modalCont">'
						+ '<table width="100%" border="0" class="student-infor-tab"><thead><tr>'
						+ '<th width="10%">${_res.get("course.course")}</th><th width="9%">场地</th><th width="10%">${_res.get("system.time")}</th><th width="15%">知识点</th><th width="7%">'+attention+'</th><th width="7%">'+understanding+'</th><th width="6%">态度</th><th width="6%">作业</th><th width="15%">${_res.get("Teacher.Evaluation")}</th><th width="15%">备注</th>'
						+ '</tr></thead><tbody  id ="trdetail">'
						+ '<tr><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td><td>sdfs</td>'
						+ '</tr>' + '</tbody></table></div>' + '<div class="modal_foot clearfix"><button class="btn btn-close">关 闭</button></div>'
						+ '</div>').prependTo($(".modal"));
		$(".modal_body").css("height", winH - 240);
		$(".closeBtn,.btn-close,.black-bg").bind("click", function() {
			$(".modal").remove();
			$(".black-bg").remove();
			$(".modal_body").attr("style", "")
		});
	}
	function detail() {

		var studentid = $("#stuId").val();
		var teatcherId = $("#teaId").val();

		window.location.href = "/account/queryStudentInfo/" + studentid;

	}
</script>

<script src="/js/js/top-nav/top-nav.js"></script>
<script src="/js/js/top-nav/teach.js"></script>
<script>
	$('li[ID=nav-nav4]').removeAttr('').attr('class', 'active');
</script>
</html>