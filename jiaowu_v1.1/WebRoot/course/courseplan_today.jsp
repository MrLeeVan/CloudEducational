<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/style.css" rel="stylesheet" /> 
<link type="text/css" href="/css/jquery.cleditor.css" rel="stylesheet" />
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<title>${_res.get('courses_roadmap')}</title>

</head>
<body style="background:#f3f3f4;">
<div style= "width:90%;margin:0 auto">
<div id="primary_right">
<div class="inner" >
<h1 style="font-weight: 100;">${date1}
<script type="text/javascript">
	var now=new Date(Date.parse("${date1}".replace(/-/g,"/"))); 
	var day=now.getDay();  
	var week;
	var arr_week=new Array("${_res.get('system.Sunday')}","${_res.get('system.Monday')}","${_res.get('system.Tuesday')}","${_res.get('system.Wednesday')}","${_res.get('system.Thursday')}","${_res.get('system.Friday')}","${_res.get('system.Saturday')}");
	document.write("("+arr_week[day]+")");
</script>
</h1> 
<table style="margin: 0 auto;width: 100%;height:100%;overflow: hidden;">
	<tr  style="background: #ccc">
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:80px;" align="center">时间</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:60px;" align="center">${_res.get('system.campus')}</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">1教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">2教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">3教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">4教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">5教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">6教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">7教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">8教室</td>
		<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:110px;" align="center">9教室</td>
	</tr>
<c:forEach items="${timeRankMap}" var="timeRank">
<tr>
	<td style="border:solid 1px #fff; " valign="middle" align="center">
	   ${timeRank.key }
	</td>
	<c:forEach items="${timeRank.value }" var="campus">
	<td style="height: 70px;width:60px; border:solid 1px #fff; " align="center">
	    ${campus.key }
	</td>
	  <c:forEach items="${campus.value }" var="course">
	<td style=" height: 70px; width:110px; background:#E1ECF6;  border:solid 1px #fff;" align="left">
	     <c:choose>
	         <c:when test="${course == null }">
			     无
			 </c:when>
			 <c:otherwise>
					${course.teach_type}<br>
					S:${course.S_NAME}<br>
					<c:if test="${!empty course.T_NAME}">T:${course.T_NAME}<br></c:if>
					C:${course.COURSE_NAME}<br>
					${_res.get("course.remarks")}：${course.REMARK}
			 </c:otherwise>
	     </c:choose>
	</td>
	   </c:forEach>
   </c:forEach>
</tr>
</c:forEach>
</table>
</div></div></div>
</body>
</html>