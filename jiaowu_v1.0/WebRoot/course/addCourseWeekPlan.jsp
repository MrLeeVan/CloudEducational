<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>
<script src="/js/js/plugins/layer/layer.min.js"></script>
<script>
	layer.use('extend/layer.ext.js'); //载入layer拓展模块
</script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('add_courses')}</title>
<style type="text/css">
.stu_name {
	position: relative;
	margin-bottom: 15px;
}

.stu_name label {
	display: inline-block;
	font-size: 12px;
	vertical-align: middle;
	width: 100px;
}

.student_list_wrap {
	position: absolute;
	top: 35px;
	left: 8.5em;
	width: 199px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px
}

label {
	width: 100px;
}

.tds {
	text-align: left;
}
/* For appearance */
.sticky-wrap {
	overflow-x: auto;
	overflow-y: auto;
	max-height: 500px;
	position: relative;
	width: 1030px
}

.sticky-wrap .sticky-thead, .sticky-wrap .sticky-col, .sticky-wrap .sticky-intersect
	{
	opacity: 0;
	position: absolute;
	top: 0;
	left: 0;
	transition: all .125s ease-in-out;
	z-index: 50;
	width: auto
}

.sticky-wrap .sticky-thead {
	box-shadow: 0 0.25em 0.1em -0.1em rgba(0, 0, 0, .125);
	z-index: 100;
	width: 100%
}

.sticky-wrap .sticky-intersect {
	opacity: 1;
	z-index: 150
}

.sticky-wrap .sticky-intersect th {
	background-color: #666;
	color: #eee
}

.sticky-wrap td, .sticky-wrap th {
	box-sizing: border-box
}
/* Not needed for sticky header/column functionality */
td.user-name {
	text-transform: capitalize
}

.sticky-wrap.overflow-y {
	overflow-y: auto;
	max-height: 50vh
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050; height: 100%; min-width: 1100px;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height: 100%">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav" style="min-width: 720px; width: 100%; margin-left: 0;">
				<div class="col-lg-12" style="margin-left: -15px;">
					<div class="ibox float-e-margins">
						<div class="ibox-title" style="margin-bottom: 20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;
								<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;
								<a href='/course/queryAllcoursePlans?loginId=${account_session.id}&returnType=1'>${_res.get('curriculum_management')}</a> &gt; ${_res.get('add_courses')}
							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          					<div style="clear:both"></div>
						</div>
					</div>
					<div class="ibox-content">
						<form action="" method="post" id="coursePlan">
							<fieldset style="width: 100%;">
								<input type="hidden" name="coursePlan.student_id" id="studentId" /> 
								<input type="hidden" name="banci_id" id="banci_id" /> 
								<input type="hidden" name="goon" id="goon" value="0" /> 
								<input type="hidden" name="course_usenum" id="courseUseNum" value="0" /> 
								<input type="hidden" name="dayTime" id="dayTime" /> 
								<input type="hidden" name="rankTime" id="rankTime" /> 
								<input type="hidden" name="rankName" id="rankName" /> 
								<input type="hidden" name="courseId" id="courseId" /> 
								<input type="hidden" name="teacherId" id="teacherId" /> 
								<input type="hidden" name="campusId" id="campusId" /> 
								<input type="hidden" name="planType" id="planType" /> 
								<input type="hidden" name="sumCourse" id="sumCourse" /> 
								<input type="hidden" name="useCourse" id="useCourse" /> 
								<input type="hidden" name="subjectid" id="subjectid"> 
								<input type="hidden" id="englishclassnumber" value="${_res.get('class.number')}">
								<p>
									<label>${_res.get('type.of.class')}：</label> 
									<input type="radio" name="banjiType" id="banjiType1" value="1" checked="checked">${_res.get("IEP")} 
									<input type="radio" name="banjiType" id="banjiType2" value="2" <c:if test='${banjiType eq 2 }'> checked='checked'</c:if>>${_res.get('course.classes')}
								</p>
								<div class="stu_name" id="stu_name">
									<label> 
										<span id="stuOrBanci"> 
											<c:choose>
												<c:when test="${banjiType eq 2 }">${_res.get('class.number')}:</c:when>
												<c:otherwise>${_res.get("student.name")}：</c:otherwise>
											</c:choose>
										</span>
									</label> 
									<input type="text" id="studentName" name="studentName" value="${studentName }" />
									<div id="mohulist" class="student_list_wrap" style="display: none">
										<ul style="margin-bottom: 10px;" id="stuList"></ul>
									</div>
									<a href="#" class="dengemail" onclick="findAccountByName()" style="padding: 8px;">${_res.get('admin.common.select')}</a>
									<div style="margin: 10px 0 0 100px;">
										<span id="studentInfo"></span>
									</div>
								</div>
								<p>
									<label>${_res.get('Arranging.type')}：</label> 
									<input id="planType0" name="coursePlan.plan_type" value="0" type="radio" checked="checked" onchange="changePlanType(this.value)">${_res.get('course.course')}&nbsp; 
									<input id="planType1" name="coursePlan.plan_type" value="1" type="radio" onchange="changePlanType(this.value)">${_res.get('mock.test')}
								</p>
								<p>
									<label>${_res.get('course.netcourse')}：</label> 
									<input id="netCourse0" name="netCourse" value="0" type="radio" checked="checked">${_res.get('admin.common.no')}&nbsp; 
									<input id="netCourse1" name="netCourse" value="1" type="radio">${_res.get('admin.common.yes')}
								</p>
								<p>
									<label><span id="kechengAndKemu">${_res.get('course.course')}：</span></label> 
									<select id="classtype" name="coursePlan.course_id" class="form-control" style="display: inline; width: 150px;" onchange="getCourseListBySubjectId(this.value);">
										<option value="0">${_res.get('Please.select')}</option>
									</select> 
									<span id="subjectMsg"> </span>
								</p>
								<p id="teahcerP">
									<label>${_res.get('teacher')}：</label> 
									<select id="teacher" class="form-control" style="display: inline; width: 150px;" name="coursePlan.teacher_id" onchange="dianTeacher(this.value)">
										<option value="0">${_res.get('Please.select')}</option>
									</select>
								</p>
								<p hidden="hidden" id="setTeacher">
									<span><a href="/teacher/index" target="_blank">跳转教师列表设置该课程老师</a></span>
								<p>
									<label>助教：</label>
									<select class="chosen-select" style="width: 150px;" id="assistants" multiple="multiple">
										<option value=""></option>
										<c:forEach items="${isAssistantTeachers }" var="tch">
											<option value="${tch.id }">${tch.REAL_NAME }</option>
										</c:forEach>
									</select>
								</p>
								<p>
									<label>${_res.get('system.campus')}：</label> 
									<select id="xqid" class="form-control" style="display: inline; width: 150px;" name="coursePlan.campus_id" onchange="campusChange(this.value)">
										<option value="0">${_res.get('Please.select')}</option>
										<c:forEach items="${campus}" var="campus_option">
											<option value="${campus_option.id}">${campus_option.CAMPUS_NAME}</option>
										</c:forEach>
									</select>
								</p>
								<div class="form-group" style="margin-top: 15px;">
									<p>
										<label>${_res.get('curriculum.period')}：</label> 
										<input type="text" class="form-control layer-date" readonly="readonly" id="date1" name="date1" value="${date1}" style="margin-top: -8px; width: 114px; background-color: #fff;" /> 
										-- 
										<input type="text" class="form-control layer-date" readonly="readonly" id="date2" name="date2" value="${date2}" style="margin-top: -8px; width: 114px; background-color: #fff;" />
										<!-- begin -->
										<c:if test="${operator_session.qx_coursegetCalender }">
											<a href="#" id="search" class="dengemail" onclick="getCalender()" style="padding: 8px;">${_res.get('admin.common.determine')}</a>
										</c:if>
										<!-- end -->
										<label> ${_res.get('View.Teacher.Timetable')}： </label> 
										<select id="teacherids" name="teacherids" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 300px;" tabindex="4">
											<c:forEach items="${teacherList}" var="teacher">
												<option value="${teacher.Id}" class="options" id="tid_${teacher.Id }">${teacher.REAL_NAME}</option>
											</c:forEach>
										</select> 
										<input id="tids" name="allteacherids" value="" type="hidden">&nbsp;&nbsp; 
										<input type="button" value="${_res.get('admin.common.see')}" onclick="Form()" class="btn btn-outline btn-info">
									</p>
								</div>
								<p>
								<div id="getcalendar"></div>
								<p>
							</fieldset>
						</form>
						<div class="teacherTimeRankWrap" style="display: none" id="piaoo">
							<h1 onclick="closepiao();">
								<span id="timeRankCloseBtn" title="${_res.get('admin.common.close')}">X</span><label> id="teacherNamePiao"></label>
							</h1>
							<div id="teacherTimeRank"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 30
		});
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : true
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 10
			},
			'.chosen-select-no-results' : {
				no_results_text : 'Oops, nothing found!'
			},
			'.chosen-select-width' : {
				width : "95%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
	</script>

	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script type="text/javascript">
		$(function() {
			var planType = $("input:radio[name='coursePlan.plan_type']:checked").val();
			$("#planType").val(planType);
			$('#studentName').keyup(
					function() {
						var class_type = $("input:radio[name='banjiType']:checked").val();
						var studentName = $("#studentName").val().trim();
						if (studentName != "") {
							if (class_type == 1) { // 如果选择了一对一则搜索学生姓名
								var studentName = $("#studentName").val();
								$.ajax({
									url : "${cxt}/account/getAccountByNameLike",
									data : "studentName=" + studentName,
									type : "post",
									dataType : "json",
									success : function(result) {
										if (result.accounts != null) {
											if (result.accounts.length == 0) {
												$("#studentName").focus();
												$("#studentInfo").text("学生不存在！");
												return false;
											} else {
												var str = "";
												for (var i = 0; i < result.accounts.length; i++) {
													var studentId = result.accounts[i].ID;
													var realName = result.accounts[i].REAL_NAME;
													if (studentName == realName) {
														$("#studentId").val(studentId);
														$("#mohulist").hide();
														dianstu(studentId);
														return;
													} else {
														str += "<li onclick='dianstu(" + studentId + ")'>" + realName + "</li>";
													}
												}
												$("#stuList").html(str);
												$("#mohulist").show();
	
											}
										} else {
											$("#stuList").html("");
											$("#mohulist").hide();
											$("#studentName").focus();
											$("#studentInfo").text("学生不存在！");
										}
	
									}
								});
							} else {
								$.ajax({
									url : "/account/getAccountByClassLike",
									data : "class_id=" + studentName,
									type : "post",
									dataType : "json",
									success : function(data) {
										if (data.classes != null) {
											if (data.classes.length == 0) {
												$("#studentName").focus();
												$("#studentInfo").text("班次不存在！");
											} else {
												var str = "";
												for (var i = 0; i < data.classes.length; i++) {
													var banciid = data.classes[i].BANCI_ID;
													var classnum = data.classes[i].CLASSNUM;
													if (studentName == classnum) {
														$("#studentId").val(studentId);
														$("#mohulist").hide
														dianclass(banciid);
														return;
													} else {
														str += "<li onclick='dianclass(" + banciid + "," + data.classes[i].ID + ")'>" + data.classes[i].CLASSNUM + "<br>"
																+ data.classes[i].NAME + "</li>";
													}
												}
												$("#stuList").html(str);
												$("#mohulist").show();
												$("#studentInfo").text("");
												//}
											}
										} else {
											$("#studentName").focus();
											$("#studentInfo").text("班次不存在！");
										}
									},
									error : function(result) {
										alert("页面已超时或发生了错误，请刷新页面重试!");
									}
								});
							}
						} else {
							$("#studentInfo").text("");
							$("#studentId").val("");
							$("#studentName").val("");
							$("#stuList").html("");
							$("#mohulist").hide();
						}
					});
		});
		// 改变科目后查询对应课程
		function getCourseListBySubjectId(subjectId) {
			$("#setTeacher").hide();
			var planType = $("input:radio[name='coursePlan.plan_type']:checked").val();
			$("#teacherId").val("");
			$("#getcalendar").html("");
			$("#teacher").html("<option value='0'>${_res.get('Please.select')}</option>");
			$("#courseId").val(subjectId);
			$("#subjectid").val(subjectId);
			if (planType == 0) {
				$.ajax({
					url : '/course/getTeacherByCourseId',
					data : {
						"real_name" : $("#studentName").val(),
						"studentid" : $("#studentId").val(),
						"course_id" : subjectId
					},
					type : 'post',
					dataType : 'json',
					success : function(data) {
						$("#subjectid").val(data.subjectid);
						var str = "";
						var teacherid = data.teacherid;
						var schoolid = data.schoolid;
						
						if(data.teacher.length==0){
							layer.msg("没有能教该课程的老师，请设置",1,2);
							$("#setTeacher").show();
						}else{
							for (var i = 0; i < data.teacher.length; i++) {
								var id = data.teacher[i].ID;
								var name = data.teacher[i].REAL_NAME;
								if (id == teacherid) {
									str += "<option value='"+id+"' selected='selected' >" + name + "</option>";
									$("#teacherId").val(teacherid);
								} else {
									str += "<option value='"+id+"'  >" + name + "</option>";
								}
							}
							$("#teacher").append(str);
							$("#xqid").val(schoolid);
							$("#campusId").val(schoolid);
						}
					}
				});
			}
		}
	
		function findAccountByName() {
			$("#courseId").val("");
			$("#teacherId").val("");
			$("#getcalendar").html("");
			$("#teacher").html("<option value='0'>${_res.get('Please.select')}</option>");
			var studentName = $("#studentName").val();
			var class_type = $("input:radio[name='banjiType']:checked").val();
			if (studentName == "" && class_type == 1) {
				alert("请输入姓名。");
			} else if (studentName == "" && class_type == 2) {
				alert("请输入班次编号。");
			} else if (class_type == 1) { // 一对一查询
				$.ajax({
					url : "${cxt}/account/getAccountByNameLike",
					data : "studentName=" + studentName,
					type : "post",
					dataType : "json",
					success : function(result) {
						if (result.accounts != null) {
							if (result.accounts.length == 0) {
								alert("查询的学员不存在");
								$("#studentName").val("");
								return false;
							}
							if (result.accounts.length == 1) {
								dianstu(result.accounts[0].ID);
							} else {
								var str = "";
								for (var i = 0; i < result.accounts.length; i++) {
									str += "<li onclick='dianstu(" + result.accounts[i].ID + ")'>" + result.accounts[i].REAL_NAME + "</li>";
								}
								$("#stuList").html(str);
								$("#mohulist").show();
							}
						} else {
							alert("此学员不存在");
						}
					},
					error : function(result) {
						alert("页面已超时或发生了错误，请刷新页面重试!");
					}
				});
			} else { // 小班查询
				$.ajax({
					url : "/account/getAccountByClassLike",
					data : "class_id=" + studentName,
					type : "post",
					dataType : "json",
					success : function(data) {
						if (data.classes != null) {
							if (data.classes.length == 0) {
								alert("查询的班次尚未关联学生。");
								$("#studentName").val("");
								return false;
							}
							if (data.classes.length == 1) {
								dianclass(data.classes[0].BANCI_ID);
							} else {
								var str = "";
								for (var i = 0; i < data.classes.length; i++) {
									str += "<li onclick='dianclass(" + data.classes[i].BANCI_ID + "," + data.classes[i].ID + ")'>" + data.classes[i].CLASSNUM + "  "
											+ data.classes[i].NAME + "</li>";
								}
								$("#stuList").html(str);
								$("#mohulist").show();
							}
						} else {
							alert("班次不存在.");
						}
					},
					error : function(result) {
						alert("页面已超时或发生了错误，请刷新页面重试!");
					}
				});
			}
		}
	
		function dianclass(classId, stuId) {
			$("#planType0").click();
			$("#teahcerP").show();
			$("#mohulist").hide();
			$("#mohulist").html();
			$('#classtype').html('${_res.get("Please.select")}');
			$.ajax({
				url : "/course/getClassInfo",
				data : {
					"classId" : classId,
					"studentId" : stuId
				},
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result.account != "noResult") {
						$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
						$("#studentId").val(result.account.studentId);
						$("#banci_id").val(classId);
						$("#courseUseNum").val(result.account.courseUseNum);
						$("#studentName").val(result.account.stuName);
						$("#studentInfo").html(result.account.stuMsg);
						$("#sumCourse").val(result.account.sumCourse);
						$("#useCourse").val(result.account.useCourse);
						var str = "";
						for (var i = 0; i < result.account.courseList.length; i++) {
							var course_id = result.account.courseList[i].course_id;
							var course_name = result.account.courseList[i].course_name;
							var status = result.account.courseList[i].status;
							var dis = "";
							if (status == 0) {
								dis = "disabled='disabled'";
							} else {
								dis = "";
							}
							str += "<option value='"+course_id+"' "+dis+">" + course_name + " </option>";
						}
						$("#classtype").append(str);
					} else {
						alert("班次不存在");
					}
				},
				error : function(result) {
					alert("ERROR! 请重新登录或刷新页面重试！");
				}
			});
		}
	
		function dianstu(stuId) {
			$("#planType0").click();
			$("#teahcerP").show();
			$("#mohulist").hide();
			$("#mohulist").html();
			$('#classtype').html('${_res.get("Please.select")}');
			$.ajax({
				url : "/student/queryCourseInfo",
				data : "studentId=" + stuId,
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result.account != "noResult") {
						$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
						$("#studentId").val(result.account.studentId);
						$("#courseUseNum").val(result.account.courseUseNum);
						$("#studentName").val(result.account.stuName);
						$("#studentInfo").html(result.account.stuMsg);
						$("#sumCourse").val(result.account.sumCourse);
						$("#useCourse").val(result.account.useCourse);
						var str = "";
						for (var i = 0; i < result.account.courseList.length; i++) {
							var course_id = result.account.courseList[i].ID;
							var course_name = result.account.courseList[i].COURSE_NAME;
							var status = result.account.courseList[i].STATUS;
							var dis = "";
							if (status == 0) {
								dis = "disabled='disabled'";
							} else {
								dis = "";
							}
							str += "<option value='"+course_id+"' "+dis+">" + course_name + " </option>";
						}
						$("#classtype").append(str);
					} else {
						alert("此学员不存在");
					}
				},
				error : function(result) {
					alert("ERROR! 请重新登录或刷新页面重试！");
				}
			});
		}
	
		function dianTeacher(teacherId) {
			$("#getcalendar").html("");
			var teacherId = teacherId;
			$("#teacherId").val(teacherId);
		}
	
		function campusChange(campusId) {
			$("#getcalendar").html("");
			$("#campusId").val(campusId);
		}
		function addCoursePlan() {
			if (($("#teacher").val() == 0 && $('input:radio[name="coursePlan.plan_type"]:checked').val() == 0) || $('#classroom').val() == 0) {
				alert("请把信息填写完整。");
				return false;
			} else {
				if (confirm("是否继续添加排课？")) {
					if ($("input:radio[name='banjiType']:checked").val() == 1) {
						$("#goon").val("1");
					} else {
						$("#goon").val("2");
					}
				}
				$("#coursePlan").attr("action", "/course/doAddCoursePlan");
				$("#coursePlan").submit();
			}
		}
		function chongzhi() {
			document.getElementById("studentName").disabled = false;
			$('#stuOrBanci').html("${_res.get('student.name')}:");
			$("#studentInfo").html("");
		}
		function closepiao() {
			$("#piaoo").hide();
		}
		function changePlanType(data) {
			var teach_type = $("input:radio[name='banjiType']:checked").val();
			$("#planType").val(data);
			if (data == 0) {
				findAccountByName();
				$("#teahcerP").show();
				$("#classtype").show();
				$('#kechengAndKemu').html("${_res.get('course.course')}:");
			} else {
				$("#getcalendar").html('');
				$("#teacher").html("<option value='0'>${_res.get('Please.select')}</option>");
				$("#teacherId").val("");
				$("#teahcerP").hide();
				$('#kechengAndKemu').html("${_res.get('course.subject')}：");
				$('#classtype').attr('name', 'coursePlan.subject_id');
				$.ajax({
					url : '/course/getSubjectForUser',
					type : 'post',
					data : {
						'name' : $('#studentName').val(),
						'studentId' : $('#studentId').val(),
						'teach_type' : teach_type
					},
					dataType : 'json',
					success : function(data) {
						if (data.subject != null) {
							var str = "";
							$('#classtype').html("<option value='0'>${_res.get('Please.select')}</option>");
							for (var i = 0; i < data.subject.length; i++) { // subject_id
								var sub_id = data.subject[i].ID;
								var sub_name = data.subject[i].SUBJECT_NAME;
								str += "<option value='"+sub_id+"'>" + sub_name + "</option>";
							}
							$('#classtype').append(str);
						} else {
							$('#classtype').html("<option value='0'>${_res.get('Please.select')}</option>");
						}
					}
				});
			}
	
		}
	
		function getCalender() {
			var cant;
			var class_type = $("input:radio[name='banjiType']:checked").val();
			var course_type = $("input:radio[name='coursePlan.plan_type']:checked").val();
			var stuId = $("#studentId").val();
			var banciId = $("#banci_id").val();
			var teacherId = $("#teacherId").val();
			var classtype = $("#classtype").val();
			var campus = $("#xqid").val();
			if (stuId != "") {
				if ((course_type == 0 && campus != 0) || (course_type == 1 && classtype != 0 && campus != 0)) {
					$.ajax({
								url : '/course/getCalender',
								data : {
									'stuId' : stuId,
									'banciId' : banciId,
									'tId' : teacherId,
									'startDay' : $('#date1').val(),
									'endDay' : $('#date2').val(),
									'type' : class_type,
									'coursetype' : course_type
								},
								type : 'post',
								dataType : 'json',
								success : function(date) {
									if (date.result != "noResult") {
										$("#date1").val(date.result.startDate);
										$("#date2").val(date.result.endDate);
										var flag = false;
										var strArray = new Array() 
										var sdate = date.result.startDate;
										var edate = date.result.endDate;
										strArray.push("<table><thead><tr style='font-size:14px;'>");
										strArray
												.push("<th style='background-color: #28bb9d;color:#fff; border-bottom: 1px solid #AAA; font-weight: bold; border: solid 2px #fff; width: 80px;height:30px;' align='center'>${_res.get('Cycle')}</th>");
										strArray.push("<th colspan='");
										strArray.push(date.result.dayLists.length);
										strArray
												.push("' style='background-color: #28bb9d;color:#fff; border-bottom: 1px solid #AAA; font-weight: bold;height:30px; border: solid 2px #fff;' align='center'>");
										strArray.push(sdate);
										strArray.push("--");
										strArray.push(edate);
										strArray
												.push("</th></tr><tr><th style='background-color: #a8d894;color:#3c763d; border-bottom: 1px solid #AAA; font-weight: bold; border: solid 2px #fff; width: 80px;height:30px;' align='center'>${_res.get('system.time')}</th>");
										for (var i = 0; i < date.result.dayLists.length; i++) {
											strArray
													.push("<th style='background-color: #A8D894;color:#3c763d; border-bottom: 1px solid #AAA; font-weight: bold; border: solid 2px #fff; width: 80px;height:30px;' align='center'>");
											strArray.push(date.result.dayLists[i].dateTime.substring(5, 10).replace(/-/g, "/"));
											strArray.push("(");
											strArray.push(date.result.dayLists[i].dayWeek);
											strArray.push(")</th>");
										}
										strArray.push("</tr><thead><tbody>");
										for (var j = 0; j < date.result.timerank.length; j++) {
											strArray
													.push("<tr><th style='height: 70px; width: 80px;background-color:#A8D894;color:#3c763d;border: solid 1px #fff;text-align: center;'>");
											strArray.push(date.result.timerank[j].RANK_NAME);
											strArray.push("</th>");
											for (var z = 0; z < date.result.dayLists.length; z++) {//添加
												/*需要更改id*/
												strArray.push("<td class='tds' id='planDay_");
												strArray.push(date.result.dayLists[z].dateTime);
												strArray.push("_");
												strArray.push(date.result.timerank[j].ID);
												strArray
														.push("' style='height: 70px; width: 100px; background:#99def9; border: solid 1px #fff;text-align: left;' onclick='addcycCoursePlan(\"");
												strArray.push(date.result.dayLists[z].dateTime);
												strArray.push("\",");
												strArray.push(date.result.timerank[j].ID);
												strArray.push(",\"");
												strArray.push(date.result.timerank[j].RANK_NAME);
												strArray.push("\")'>");
												for (var k = 0; k < date.result.cplist.length; k++) {
													if (date.result.cplist[k].COURSE_TIME == date.result.dayLists[z].dateTime
															&& date.result.timerank[j].ID == date.result.cplist[k].TIMERANK_ID) {
														if (class_type == 1) {
															if (date.result.cplist[k].STUDENT_ID == $("#studentId").val()) {
																strArray.push("<div name='student_course_planed' >");
																strArray.push("<a href='javascript:void(0)' style='vertical-align: middle;  float: right;'onclick='delCoursePlan(");
																strArray.push(date.result.cplist[k].ID);
																strArray.push(",\"");
																strArray.push(date.result.cplist[k].COURSE_TIME);
																strArray.push("\")'><img src='\/images\/img\/error.png' width='12' height='12' title='取消' /></a>");
																strArray.push(date.result.cplist[k].ISCANCEL == 1 ? "已取消<br>" : "");
																strArray.push(date.result.cplist[k].COURSE_NAME);
																strArray.push("<br>");
																strArray.push($("#studentName").val());
																strArray.push("同学<br>");
																strArray.push(date.result.cplist[k].CAMPUS_NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].NAME);
																strArray.push(date.result.cplist[k].CONFIRM == 0 ? "<br>待确认":date.result.cplist[k].CONFIRM == 2 ? "<br>待调剂":"");
																strArray.push("<br></div>");
															} else {
																strArray
																		.push("<div name='teacher_course_planed' ><a href='javascript:void(0)' style='vertical-align: middle;  float: right;'onclick='delCoursePlan(");
																strArray.push(date.result.cplist[k].ID);
																strArray.push(",\"");
																strArray.push(date.result.cplist[k].COURSE_TIME);
																strArray.push("\")'><img src='\/images\/img\/error.png' width='12' height='12' title='取消' /></a>");
																strArray.push(date.result.cplist[k].ISCANCEL == 1 ? "已取消<br>" : "");
																strArray.push(date.result.cplist[k].COURSE_NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].REAL_NAME);
																strArray.push("${_res.get('teacher')}<br>");
																strArray.push(date.result.cplist[k].CAMPUS_NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].CONFIRM == 0 ? "<br>待确认":date.result.cplist[k].CONFIRM == 2 ? "<br>待调剂":"");
																strArray.push("<br></div>");
															}
														} else if (class_type == 2) {
															if (date.result.cplist[k].STUDENT_ID == $("#studentId").val()) {
																strArray
																		.push("<div name='student_course_planed' ><a href='javascript:void(0)' style='vertical-align: middle;  float: right;'onclick='delCoursePlan(");
																strArray.push(date.result.cplist[k].ID);
																strArray.push(",\"");
																strArray.push(date.result.cplist[k].COURSE_TIME);
																strArray.push("\")'><img src='\/images\/img\/error.png' width='12' height='12' title='取消' /></a>");
																strArray.push(date.result.cplist[k].ISCANCEL == 1 ? "已取消<br>" : "");
																strArray.push(date.result.cplist[k].COURSE_NAME);
																strArray.push("<br>");
																strArray.push($("#studentName").val());
																strArray.push("同学<br>");
																strArray.push(date.result.cplist[k].CAMPUS_NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].NAME);
																strArray.push("<br></div>");
															} else {
																strArray
																		.push("<div name='teacher_course_planed' ><a href='javascript:void(0)' style='vertical-align: middle;  float: right;'onclick='delCoursePlan(");
																strArray.push(date.result.cplist[k].ID);
																strArray.push(",\"");
																strArray.push(date.result.cplist[k].COURSE_TIME);
																strArray.push("\")'><img src='\/images\/img\/error.png' width='12' height='12' title='取消' /> </a>");
																strArray.push(date.result.cplist[k].ISCANCEL == 1 ? "已取消<br>" : "");
																strArray.push(date.result.cplist[k].COURSE_NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].REAL_NAME);
																strArray.push("${_res.get('teacher')}<br>");
																strArray.push(date.result.cplist[k].CAMPUS_NAME);
																strArray.push("<br>");
																strArray.push(date.result.cplist[k].NAME);
																strArray.push("<br></div>");
															}
														}
														flag = true;
													}
												}
												if (flag) {
													flag = false;
												} else {
													strArray.push("<div style='color:#FFF;'>");
													strArray.push(date.result.dayLists[z].dateTime.substring(5, 10).replace(/-/g, "/"));
													strArray.push("(" + date.result.dayLists[z].dayWeek + ")");
													strArray.push("<br>");
													strArray.push(date.result.timerank[j].RANK_NAME);
													strArray.push("</div>");
												}
												strArray.push("</td>");
	
											}
											strArray.push("</tr>");
										}
										strArray.push("</tbody></table>");
	
										for (var m = 0; m < date.result.cantDay.length; m++) {
											cant = date.result.cantDay[m];
										}
	
									}
	
									$("#getcalendar").html(strArray.join(""));
									//不可选的置灰；
									for (var m = 0; m < date.result.cantDay.length; m++) {
										var pingId = "planDay_" + date.result.cantDay[m].day + "_" + date.result.cantDay[m].timeId;
										document.getElementById(pingId).style.background = "#DDD";
										document.getElementById(pingId).onclick = function() {
										};
									}
									//console.log("-----------------------------不可选的置灰； 学生请假--------------------------------");
									//console.log(date);
									//不可选的置灰； 学生请假
									 for( stuleaveK in date.result.stuleaves ){
										var stuleave = date.result.stuleaves[stuleaveK];
										for (var dayK = 0; dayK < stuleave.DAYTIMES.length; dayK++) {
											var daytimes = stuleave.DAYTIMES[dayK];
											var day = daytimes.DAY;
											for (var timeIdK = 0; timeIdK < daytimes.TIMERANKID.length; timeIdK++) {
												var timeId = daytimes.TIMERANKID[timeIdK];
												var pingId = "planDay_" + day + "_" + timeId;
												$("#"+pingId).append("请假");
												document.getElementById(pingId).style.background = "#DDD";
												document.getElementById(pingId).onclick = function() {};
											}
										}
									}
	
									distiction();
								}
							});
				} else if (course_type == 0 && campus == '0') {
					alert("请选择课程丶老师和校区！");
				} else if ((course_type == 1 && (classtype == 0 || campus == '0'))) {
					alert("请选择科目和校区！");
				}
			} else {
				if (class_type == 1) {
					alert("请先填写学生！");
				} else if (class_type == 2) {
					alert("请先填写班次！");
				}
	
			}
		}
	
		function distiction() {
			$("div[name='teacher_course_planed']").each(function() {
				$(this).css("background-color", "#e0b65c");
				$(this).css("color", "#ffffff");
			});
			$("div[name='student_course_planed']").each(function() {
				$(this).css("background-color", "#c787e5");
				$(this).css("color", "#ffffff");
			});
		}
	
		function delCoursePlan(planId, deltime) {
			var reason = "";
			var index = parent.layer.getFrameIndex(window.name);
			var deltime = deltime.replace(new RegExp("-", "g"), "");
			var nd = new Date();
			var today = nd.getFullYear() + (nd.getMonth() + 1 < 10 ? "0" + (nd.getMonth() + 1) : nd.getMonth() + 1) + nd.getDate();
			$.ajax({
				url : "/course/checkCoursePlanTime",
				data : {
					"planId" : planId,
				},
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result.nums == "1") {
						$.layer({
							shade : [ 0 ], //不显示遮罩
							area : [ 'auto', 'auto' ],
							dialog : {
								msg : '确定删除该课程吗？',
								btns : 2,
								type : 4,
								btn : [ '确定', '取消' ],
								yes : function() {
									$.ajax({
										async : false,
										cache : true,
										type : 'post',
										dataType : 'json',
										url : '/course/delCoursePlan',
										data : {
											"planId" : planId
										},
										success : function(data) {
											getCalender();
											getStudentInfo();
											if (data.code == "1") {
												layer.msg(data.msg, 1, 1);
											} else if (data.code == "0") {
												layer.msg(data.msg, 1, 1);
											} else if (data.code == "2") {
												layer.msg(data.msg, 1, 1);
											}
										},
										error : function(data) {
											layer.msg("网络异常!", 2, 5);
										}
									});
									parent.layer.close(index);
								},
								no : function() {
								}
							}
						});
					} else {
						$.layer({
							type : 2,
							title : '超出规定时间删除排课',
							maxmin : false,
							shadeClose : true, //开启点击遮罩关闭层
							area : [ '380px', '430px' ],
							offset : [ '80px', '' ],
							iframe : {
								src : "/course/fullHourDelCoursePlan/" + planId + ',0'
							}
						});
					}
	
				}
			});
	
		}
	
		function delClassCoursePlan(classId, courseTime, rankId) {
			var reason = "";
			if (confirm("确定要删除此次课程？")) {
				var index = layer.prompt({
					title : '填写删除原因',
					type : 3
				}, function(val) {
					reason = val;
					$.ajax({
						cache : true,
						type : 'post',
						dataType : 'json',
						url : '/course/delClassWeekCoursePlan',
						data : {
							"classId" : classId,
							"courseTime" : courseTime,
							"rankId" : rankId,
							"delmsg" : reason
						},
						success : function(data) {
							getCalender();
							getClassInfo();//学生姓名后面信息的更改
							if (data.result == "1") {
								layer.msg("课程已删除。", 1, 1);
							} else {
								alert("fail deleted!");
							}
						},
						error : function(data) {
							alert("net wrong!");
						}
					});
					layer.close(index);
				});
			}
		}
		function delTeacherCoursePlan(stuId, courseTime, rankId) {
			var reason = "";
			if (confirm("确定要删除此次课程？")) {
				var index = layer.prompt({
					title : '填写删除原因',
					type : 3
				}, function(val) {
					reason = val;
					$.ajax({
						cache : true,
						type : 'post',
						dataType : 'json',
						url : '/course/delTeacherCoursePlan',
						data : {
							"tId" : stuId,
							"courseTime" : courseTime,
							"rankId" : rankId,
							"delmsg" : reason
						},
						success : function(data) {
							getCalender();
							getStudentInfo();//学生姓名后面信息的更改
							if (data.result == "1") {
								layer.msg("课程已删除。", 1, 1);
							} else {
								alert("fail deleted!");
							}
						},
						error : function(data) {
							alert("net wrong!");
						}
					});
					layer.close(index);
				});
			}
		}
	
		function getClassInfo() {
			var classId = $("#banci_id").val();
			$.ajax({
				url : "/course/getClassInfo",
				data : {
					"classId" : classId,
					"studentId" : $("#studentId").val()
				},
				type : "post",
				dataType : "json",
				success : function(result) {
					$("#studentInfo").html(result.account.stuMsg);
					$("#useCourse").val(result.account.useCourse);
				},
				error : function(result) {
					alert("ERROR!");
				}
	
			});
		}
	
		function getStudentInfo() {
			var stuId = $("#studentId").val();
			$.ajax({
				url : "/student/queryCourseInfo",
				data : "studentId=" + stuId,
				type : "post",
				dataType : "json",
				success : function(result) {
					$("#studentInfo").html(result.account.stuMsg);
					$("#useCourse").val(result.account.useCourse);
				},
				error : function(result) {
					alert("ERROR! 请重新登录或刷新页面重试！");
				}
			});
		}
	
		function addcycCoursePlan(courseTime, timerankId, rankName) {
			$("#dayTime").val(courseTime);
			$("#rankTime").val(timerankId);
			$("#rankName").val(rankName);
			//在这里判断是否排完课，排完课程弹出提示不可以再添加课程了；未排完课程就不弹出；
			var sum = $("#sumCourse").val();
			var used = $("#useCourse").val();
			var plantype = $("input:radio[name='coursePlan.plan_type']:checked").val();
			var studentId = $("#studentId").val();
			var courseId = $("#courseId").val();
			$.ajax({
				url : "/orders/queryUsableHour",
				data : {
					"studentId" : studentId,
					"rankId" : timerankId,
					"courseTime" : courseTime,
					"rankName" : rankName,
					"courseId" : courseId,
					"plantype" : plantype
				},
				type : "post",
				dataType : "json",
				success : function(data) {
					if (data.code == "0") {//课时够用
						$.layer({
							type : 2,
							title : "${_res.get('add_courses')}",
							maxmin : false,
							shadeClose : true, //开启点击遮罩关闭层
							area : [ '416px', '523px' ],
							iframe : {
								src : '/course/addDayCoursePlan'
							}
						});
					} else {
						layer.alert(data.msg);
					}
				},
				error : function(result) {
					layer.alert('请重新登录或刷新页面重试');
				}
			});
		}
	</script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				str = datas.replace(/-/g, "/");
				var date = new Date(str);
				var date2 = new Date(laydate.now());
				var day = ((date - date2) / (1000 * 60 * 60) + 8) / 24;
				var betweenday = day + 6;
				$("#date2").val(laydate.now(+betweenday));
				var dat = laydate.now(+betweenday);
				date2.min = dat;
				var maxday = day + 9;
				date2.max = laydate.now(+maxday);
				getCalender();
			}
		};
		var date2 = {
			elem : '#date2',
			format : 'YYYY-MM-DD',
			istime : true,
			istoday : false,
			choose : function(datas) {
				date1.max = datas; //结束日选好后，重置开始日的最大日期
			}
		};
		laydate(date1);
		laydate(date2);
		$("#date2").val(laydate.now(+6));

		$(function() { // 班级类型切换
			var str = $("#englishclassnumber").val();
			$(":input[name='banjiType']").click(function() {
				var planType = $("input:radio[name='coursePlan.plan_type']:checked").val();
				$("#planType").val(planType);
				$("#getcalendar").html("");
				$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
				$("#teacher").html("<option value='0'>${_res.get('Please.select')}</option>");
				$("#studentId").val("");
				$("#banci_id").val("");
				$("#courseUserNum").val("");
				$("#courseId").val("");
				$("#teacherId").val("");
				$("#sumCourse").val("");
				if ($(this).val() == 1) {
					$('#stuOrBanci').html("${_res.get('student.name')}:");
					$("#studentName").val("");
					$("#banjiType1").attr('checked', 'checked');
				} else {
					$('#stuOrBanci').html(str + ':');
					$("#studentName").val("");
					$("#banjiType2").attr('checked', 'checked');
				}
			});
		});

		$(document).ready(function() {
			var studentName = $('#studentName').val();
			if (studentName != '') {
				findAccountByName();
			}
		});
	</script>
	<script type="text/javascript">
		function Form() {
			getIds();
			var tids = $("#tids").val();
			var date1 = $("#date1").val();
			var date2 = $("#date2").val();
			var url = "/course/queryAllcoursePlansByteacher?returnType=2&allteacherids=" + tids + "&date1=" + date1 + "&date2=" + date2;
			window.open(url, '_blank');
		}

		function getIds() {
			var teacherids = "";
			var list = document.getElementsByClassName("search-choice");
			for (var i = 0; i < list.length; i++) {
				var name = list[i].children[0].innerHTML;
				var olist = document.getElementsByClassName("options");
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						teacherids += "|" + olist[j].getAttribute('value');
						break;
					}
				}
			}
			$("#tids").val(teacherids);
		}
	</script>
	<script type="text/javascript" src="/js/table/jquery.ba-throttle-debounce.min.js"></script>
	<script type="text/javascript" src="/js/table/jquery.stickyheader.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
</body>
</html>