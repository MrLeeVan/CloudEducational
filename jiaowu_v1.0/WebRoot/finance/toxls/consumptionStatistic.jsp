<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<table border='1' cellspacing="0" cellpadding="0"  >
	<caption><b>总课时：</b>${totalHour } <b>/总消耗额：</b>${totalAmount }</caption>
	<thead>
		<tr>
			<th>序号</th>
			<th>课程日期</th>
			<th>时段</th>
			<th>科目</th>
			<th>课程</th>
			<th>学生/班次</th>
			<th>授课教师</th>
			<th>校区/教室</th>
			<th>课时</th>
			<th>金额</th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${showPages.list}" var="coursePlan" varStatus="index">
		<tr>
			<td>${index.count }</td>
			<td>${coursePlan.courseTime}</td>
			<td>${coursePlan.rank_name}</td>
			<td>${coursePlan.subject_name}</td>
			<td>${coursePlan.course_name}</td>
			<td>${coursePlan.studentname}</td>
			<td>${coursePlan.teachername}</td>
			<td>${coursePlan.campus_name}/${coursePlan.roomname}</td>
			<td>${coursePlan.class_hour}</td>
			<td>${coursePlan.totalfee}</td>
		</tr>
	</c:forEach>
	</tbody>
</table>