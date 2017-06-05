<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE   html   PUBLIC   "-//W3C//DTD   XHTML   1.0   Transitional//EN "   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd "> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/style.css" rel="stylesheet" /> 
<link type="text/css" href="/css/jquery.cleditor.css" rel="stylesheet" />
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<title>${_res.get('courses_roadmap')}</title>

</head>
<body style="width:auto;" >
<div >
<div id="primary_right">
<div class="inner" >
<h3 align="left">当前位置：<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; ${_res.get('courses_for_today')}<c:if test="${campusId == 1 }">(中关村)</c:if><c:if test="${campusId == 2 }">(国贸)</c:if></h3><br>
<c:forEach items="${timeMap }" var="timeRankMap">
<h2>${timeRankMap.key}
<script type="text/javascript">
	var now=new Date(Date.parse("${timeRankMap.key}".replace(/-/g,"/"))); 
	var day=now.getDay();  
	var week;
	var arr_week=new Array("${_res.get('system.Sunday')}","${_res.get('system.Monday')}"
			,"${_res.get('system.Tuesday')}","${_res.get('system.Wednesday')}","${_res.get('system.Thursday')}",
			"${_res.get('system.Friday')}","${_res.get('system.Saturday')}");
	document.write("("+arr_week[day]+")");
</script>
</h2> 
<table style="margin: 0 0 0px;width: 1070px;overflow: hidden;">
<tr  style="background: #ccc">
<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:80px;" align="center">时间</td>
<!--
<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold; border:solid 2px #fff; width:60px;" align="center">${_res.get('system.campus')}</td>
-->
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
<c:forEach items="${timeRankMap.value}" var="timeRank">
<tr>
<td style=" border:solid 1px #fff; " valign="middle" align="center">
<table style="margin: 0 0 0px; width: 80px;overflow: hidden;" background="#234328">
<tr>
<td style="width:80px;">
${timeRank.key }
</td>
</tr>
</table>
</td>
<td style=" border:solid 1px #fff; " colspan="10">
<table style="margin: 0 0 0px; width: 990px;overflow: hidden;" background="#234328">
<c:forEach items="${timeRank.value }" var="campus">
<tr>
<!--
<td  style="height: 70px;width:60px; border:solid 1px #fff; " >
${campus.key }
</td>
-->
<c:forEach items="${campus.value }" var="course">
<td style=" height: 70px; width:110px; background:#E1ECF6;  border:solid 1px #fff;" align="left">
<c:choose>
<c:when test="${course == null }">
	无
</c:when>
<c:otherwise>
	${course.attrs['teach_type']}<br>
	S:${course.attrs['S_NAME']}<br>
	T:${course.attrs['T_NAME']}<br>
	C:${course.attrs['COURSE_NAME']}<br>
	${_res.get("course.remarks")}：${course.attrs['REMARK']}
</c:otherwise>
</c:choose>
</td>
</c:forEach>
</tr>
</c:forEach>
</table>
</td>
</tr>
</c:forEach>
</table>
</c:forEach>
</div></div></div>
</body>
</html>