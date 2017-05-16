<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<table border='1' cellspacing="0" cellpadding="0"  >
	<caption><b>xxxxx</b></caption>
	<thead>
		<tr align="left" valign="top" >
			<th> xxx</th>
			<th>Comments</th>
			<th>Teacher</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${record.commentLists}" var="comment" varStatus="index">
			<tr>
				<td> ${comment.courseClassesName } </td>
				<td> ${comment.comments } </td>
				<td> ${comment.courseTeacherName } </td>
			</tr>
		</c:forEach>
	</tbody>
</table>
