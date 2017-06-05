<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>课程记录</title>
<%@ include file="/common/headExtraction.jsp" %>
</head>
<body>
	<div id="wrapper" style="background: #2f4050; min-width: 1100px;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<form action="/course/queryTeacherCoursePlanDetail" method="post" id="searchForm">
			<div class="margin-nav" style="min-width: 650px;">
				<div class="col-lg-12">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp; <a
									href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> &gt; ${_res.get("curriculum") }
								&gt;${_res.get("courses_record") }
							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback")}</a>
							<div style="clear: both"></div>
						</div>
						<div class="ibox-content">
								<input type="hidden" id="wherepage" name="page" value="${page}" />
								<fieldset>
									<div class="querydiv">
										<label>${_res.get("teacher.name") }：</label>
										<input type="text" name="_query.teacher_name" style="width: 100px;" value="${splitPage.queryParam['teacher_name']}">
									</div>
									<div class="querydiv">
										<label>${_res.get("student.name") }：</label>
										<input type="text" name="_query.student_name" style="width: 100px;" value="${splitPage.queryParam['student_name']}">
									</div>
									<div class="querydiv">
										<label style="margin-left: 20px;">${_res.get("system.campus") }：</label>
										<select name="_query.campus_id" class="chosen-select" style="width: 150px; border-color: #bababa;">
											<option value="">${_res.get("system.alloptions") }</option>
											<c:forEach items="${campus}" var="campus_entity">
												<option value="${campus_entity.id}" 
												${splitPage.queryParam['campus_id'] eq campus_entity.id?"selected='selected'":""}
												>${campus_entity.campus_name}</option>
											</c:forEach>
										</select>
									</div>
									<div class="querydiv">
										<label style="margin-left: 20px;">老师评价状态：</label>
										<select name="_query.comment_state" class="chosen-select" style="width: 80px;">
											<option value="">${_res.get("system.alloptions") }</option>
											<option value="0"
											${splitPage.queryParam['comment_state'] eq 0 ?"selected='selected'":""}
											>未评论</option>
											<option value="1"
											${splitPage.queryParam['comment_state'] eq 1 ?"selected='selected'":""}
											>已评论</option>
										</select>
									</div>
									<div class="querydiv">
										<label>${_res.get("course.record.firsttime") }：</label>
										<input type="text" id="starttime" name="_query.starttime" readonly="readonly" value="${splitPage.queryParam['starttime']}" style="width: 120px;"/>
										<label>${_res.get("course.record.lasttime") }：</label>
										<input type="text" id="endtime" name="_query.endtime" readonly="readonly" value="${splitPage.queryParam['endtime']}" style="width: 120px;"/>
									</div>
									<div class="querydiv">
										<input type="button" onclick="search()" class="btn btn-outline btn-primary" value="${_res.get('admin.common.select') }"/>
									</div>
									
									<div style="clear: both;"></div>
								</fieldset>
						</div>
					</div>
				</div>

				<div class="col-lg-12"  style="width: 2000px;">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<%@ include file="/common/toolButtonExtraction.jsp" %>
						</div>
						<div class="ibox-content">
							<table class="table table-hover table-bordered copy" >
								<thead>
									<tr align="center">
										<th rowspan="2" width="40px"><label><strong>${_res.get("index") }</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get('Study.subjects')}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("course.class.date") }</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("class.time.session")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("class.location")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("class.consultant.in.charge")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("assistant")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("classNum")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("student.name")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("learning.content")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("student") } ${_res.get("class.attendance") }</strong></label></th>
										<th colspan="5" ><label><strong>${_res.get("consultant's.comments")}</strong></label></th>
										<th colspan="5" ><label><strong>${_res.get("student's.comments")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("homework")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("qs.in.homework")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("solutions")}</strong></label></th>
										<th rowspan="2" ><label><strong>${_res.get("reminder")}/${_res.get("course.remarks")}</strong></label></th>
									</tr>
									<tr>
										<th><label><strong>${_res.get("understanding")}</strong></label></th>
										<th><label><strong>${_res.get("attention")}</strong></label></th>
										<th><label><strong>${_res.get("last.homework")}</strong></label></th>
										<th><label><strong>${_res.get("study.attitude")}</strong></label></th>
										<th><label><strong>${_res.get("achievement")}</strong></label></th>
										<th><label><strong>${_res.get("logic")}</strong></label></th>
										<th><label><strong>${_res.get("knowledge")}</strong></label></th>
										<th><label><strong>${_res.get("responsibility")}</strong></label></th>
										<th><label><strong>${_res.get("amiableness")}</strong></label></th>
										<th><label><strong>${_res.get("course.remarks")}</strong></label></th>
									</tr>
								</thead>
								<tbody>
								<c:forEach items="${splitPage.page.list}" var="course" varStatus="st">
									<tr>
										<td align="center">${st.index+1}</td>
										<td align="center"><a href="/knowledge/educationalManage?courseplanId=${course.cpid}" style="text-decoration: none;"> ${course.COURSE_NAME}</a>
										</td>
										<td align="center">${course.COURSE_TIME}</td>
										<td align="center">${course.RANK_NAME}</td>
										<td align="center">${course.CAMPUS_NAME}</td>
										<td align="center">${course.TNAME}</td>
										<td align="center">${course.ZNAME}</td>
										<td align="center">${course.CLASSNUM}</td>
										<td align="center">${course.SNAME}</td>
										<td align="left">${course.COURSE_DETAILS}</td>
										<td>
										<c:choose>
											<c:when test="${course.singn eq 1}">正常</c:when>
											<c:when test="${course.singn eq 2}">${_res.get('courselib.late')}(${course.lateMinutes}${_res.get("minutes") })</c:when>
											<c:when test="${course.singn eq 3}">${_res.get("replenish.sign")}</c:when>
											<c:when test="${course.singn eq 0}">未签到</c:when>
										</c:choose>
										</td>
										<td align="center">${course.UNDERSTAND}</td>
										<td align="center">${course.ATTENTION}</td>
										<td align="center">${course.STUDYTASK}</td>
										<td align="center">${course.STUDYMANNER}</td>
										<td align="center">${course.ACHIEVEMENT}</td>
										<td align="center">${course.LJX}</td>
										<td align="center">${course.ZSD}</td>
										<td align="center">${course.ZRX}</td>
										<td align="center">${course.QHL}</td>
										<td align="center">${course.SBZ}</td>
										<td align="left">${course.HOMEWORK}</td>
										<td align="left">${course.question}</td>
										<td align="left">${course.method}</td>
										<td align="left" class="compressionPreview">${course.tutormsg}</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
							<hr>
							<div id="splitPageDiv">
								<jsp:include page="/common/splitPage.jsp" />
							</div>
						</div>
					</div>
				</div>
				<div style="clear: both;"></div>
			</div>
			</form>
		</div>
	</div>
<script type="text/javascript">
	$(document).ready(function(){
		
    	 //日期范围限制
		toolDateRangeLimit("starttime", "endtime");
    	 
    	 
	});
</script>

</body>
</html>