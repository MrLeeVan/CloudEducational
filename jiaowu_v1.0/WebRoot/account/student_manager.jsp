<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="d" uri="/common/jfinal.tld"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=4.3.0" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet" />

<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet" />

<link href="/css/css/animate.css" rel="stylesheet" />
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get("courselib.studentMsg") }</title>
<style>
table {
	width: 100%;
	border: 1px solid #ccc;
	border-collapse: collapse;
}

table td {
	border: 1px solid #ccc;
	border-collapse: collapse;
	color: #999;
}
</style>
</head>
<body style="background: white;">
	<div class="ibox-content">
		<div id="wrapper">
			<div align="center">
				<c:forEach items="${slist}" var="s">
					<input type="button" id="ca_${s.ID}" class="btn btn-outline btn-primary" onclick="replaceStudent(${s.ID})" value="${s.REAL_NAME}">
				</c:forEach>
			</div>
			<input type="hidden" id="replaceid" value="${student.ID}"> <input type="hidden" id="courseplanid" value="${cp.ID}"> <label>学生信息：</label>
			<form action="" method="post" id="accountForm">
				<fieldset>
					<c:if test="${isadmins }">
						<table class="table table-bordered">
							<tr align="center">
								<td width="10%">${_res.get("admin.user.property.email") }：</td>
								<td width="12%">${student.EMAIL}</td>
								<td width="10%">${_res.get("sysname") }：</td>
								<td width="10%">${student.REAL_NAME}</td>
								<td width="10%">${_res.get("gender") }：</td>
								<td width="10%">${student.sex==0?_res.get("student.girl"):student.sex==1?_res.get("student.boy"):"未知"}</td>
								<td width="10%">${_res.get("telphone") }：</td>
								<td width="10%">${student.TEL}</td>
							</tr>
							<tr align="center">
								<td>${_res.get('admin.user.property.qq')}：</td>
								<td>${student.QQ}</td>
								<td>${_res.get("student.parentphone") }：</td>
								<td>${student.PARENTS_TEL}</td>
								<td>${_res.get("admin.common.place") }：</td>
								<td>${student.ADDRESS}</td>
								<td>${_res.get('Academy')}：</td>
								<td>${student.SCHOOL}</td>
							</tr>
							<tr align="center">
								<td>督导：</td>
								<td>${accountEntity.qq}</td>
								<td>课程顾问：</td>
								<td>${accountEntity.parents_tel}</td>
								<td>市场：</td>
								<td>${accountEntity.address}</td>
								<td>留学顾问：</td>
								<td>${accountEntity.school}</td>
							</tr>
							<tr align="center">
								<td>购买课程：</td>
								<td colspan="7">${accountEntity.EXAM_CONTENT}</td>
							</tr>
							<tr align="center">
								<td>备注：</td>
								<td colspan="7">${student.REMARK}</td>
							</tr>
						</table>
					</c:if>
					<c:if test="${isadmins?false:true }">
						<p>
							${_res.get("sysname") }：${student.REAL_NAME}<br>
							${_res.get('Academy')}：${student.SCHOOL}<br>
							备注：${student.REMARK}<br>
						</p>
					</c:if>
					<!-- 学生专用属性 -->
							<c:if test="${!empty pqList }">
								<div>
									<p style="overflow: hidden; margin-top: 15px;">
										<label style="float: left;">${_res.get('Reference.scores.before.training')}：</label> <span style="background: #fff; display: inline-block; padding: 10px; overflow: hidden;">
											<c:forEach items="${pqList }" var="record" varStatus="r">
												<span style="display: block; overflow: hidden;"> ${_res.get('course.subject')}：${record.subjectname} ${_res.get("Exam.time")}：${record.examdate} </span>
												<span style="display: block;"> ${_res.get('Test.scores')}： <c:if test="${!empty record.detail }">
														<c:forEach items="${record.detail }" var="detail">
															${detail.coursename}:${detail.score}
														</c:forEach>
													</c:if>
												</span>
											</c:forEach>
										</span>
									</p>
								</div>
							</c:if>
							<c:if test="${!empty phList }">
								<div>
									<p style="overflow: hidden; margin-top: 15px;">
										<label style="float: left;">${_res.get('Reference.score.after.training')}：</label> <span style="background: #fff; display: inline-block; padding: 10px; overflow: hidden;">
											<c:forEach items="${phList }" var="record" varStatus="r">
												<span style="display: block; overflow: hidden;"> ${_res.get('course.subject')}：${record.subjectname} ${_res.get("Exam.time")}：${record.examdate} </span>
												<span style="display: block;"> ${_res.get('Test.scores')}： <c:if test="${!empty record.detail }">
														<c:forEach items="${record.detail }" var="detail">
															${detail.coursename}:${detail.score}
														</c:forEach>
													</c:if>
												</span>
											</c:forEach>
										</span>
									</p>
								</div>
							</c:if>
				</fieldset>
			</form>
		</div>
	</div>
	<div id="wrapper" style="overflow-y: scoll; text-align: center; height: 500px;">
		<c:choose>
			<c:when test="${!empty coursePlanList }">
				<div class="ibox-content">
					<table class="table table-hover table-bordered">
						<thead>
							<tr>
								<th>${_res.get("index") }</th>
								<th>${_res.get("courselib.trainee") }/${_res.get("course.classes") }</th>
								<th>${_res.get("teacher") }</th>
								<th>${_res.get("courselib.location") }</th>
								<th>${_res.get('course.course')}</th>
								<th>${_res.get('type')}</th>
								<th>${_res.get("course.class.date") }</th>
								<th>${_res.get("system.time") }</th>
								<th>${_res.get('session')}</th>
							</tr>
						</thead>
						<c:forEach items="${coursePlanList }" var="list" varStatus="index">
							<tr>
								<td>${index.count }</td>
								<td>${list.studentname }</td>
								<td>${list.teachername }</td>
								<td>${list.campus_name }-${list.roomname }</td>
								<td>${list.course_name }</td>
								<td><c:choose><c:when test="${list.class_id eq 0 }">一对一</c:when><c:otherwise>班课</c:otherwise> </c:choose> </td>
								<td><fmt:formatDate value="${list.course_time}" type="time" timeStyle="full" pattern="yyyy-MM-dd" /> (${list.weekname })</td>
								<td>${list.rankname }</td>
								<td>${list.classhour }</td>
							</tr>
						</c:forEach>
						<tr>
							<td colspan="4">${_res.get("total")}：</td>
							<td colspan="3">${courseCount}</td>
							<td colspan="2">${sumClassHour}</td>
						</tr>
					</table>
					<input type="hidden" id="size" value="${list.size()}">
				</div>

			</c:when>
			<c:otherwise>
				<div>${_res.get('No.Timetable.record')}</div>
			</c:otherwise>
		</c:choose>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script type="text/javascript">
	//选择学生
	function replaceMessage(studentid){
		var replaceid = $("#replaceid").val();
		$("#ca_"+replaceid).addClass("btn-outline");
		$("#ca_"+studentid).removeClass("btn-outline");
		$("#replaceid").val(studentid);
		var courseplanid = $("#courseplanid").val();
		$.ajax({
			url:'',
			
		})
	}
	replaceMessage('${student.ID}');
	</script>
</body>
</html>