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
<title>${_res.get('courses_roadmap')}</title>

</head>
<body style="width:auto;">
<div >
<div id="primary_right">
<div class="inner" style="float: none;" >
<form action="/course/allCourseplanToday" method="post" style="text-align: center;" >
<fieldset style="width: auto" id="searchTable" >
<label>${_res.get('student')}:</label>
<input type="text" name="studentName" id="studentName" value="${studentName}"/>
<label>${_res.get('teacher')}:</label>
<input type="text" name="teacherName" id="teacherName" value="${teacherName}"/>
<label>${_res.get('classNum')}:</label>
<input type="text" name="banci" id="banci" value="${banci}"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
<label>${_res.get('course.class.date')}:</label>
<input type="text" readonly="readonly" id="date1" name="date1" value="${date1}"
onfocus="WdatePicker({startDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd'})"/>----&nbsp;
<input type="text" readonly="readonly" id="date2" name="date2" value="${date2}"
onfocus="WdatePicker({startDate:'%y-%M-%d',dateFmt:'yyyy-MM-dd'})"/>
<label>${_res.get('system.campus')}:</label>
<select name="campusId" id="campusId" style="width:150px">
<option value="0">${_res.get('Please.select')}</option>
<c:forEach items="${campus}" var="campus_entity">
<option value="${campus_entity.id}" <c:if test="${campus_entity.id eq campusId}">selected="selected"</c:if> >${campus_entity.campus_name}</option>
</c:forEach>
</select>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value="${_res.get('admin.top.search')}"/>
<br><br>
</fieldset>
</form>

<c:forEach items="${timeMap }" var="timeRankMap">
<br><h1 style="text-align: center;">${timeRankMap.key}
<script type="text/javascript">
	var now=new Date(Date.parse("${timeRankMap.key}".replace(/-/g,"/"))); 
	var day=now.getDay();  
	var week;
	var arr_week=new Array("${_res.get('system.Sunday')}","${_res.get('system.Monday')}","${_res.get('system.Tuesday')}","${_res.get('system.Wednesday')}","${_res.get('system.Thursday')}","${_res.get('system.Friday')}","${_res.get('system.Saturday')}");
	document.write("("+arr_week[day]+")");
</script>
</h1> 
<table style="margin: 0 auto;width: 1130px;overflow: hidden;">
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
<table style="margin: 0 0 0px; width: 1050px;overflow: hidden;" background="#234328">
<c:forEach items="${timeRank.value }" var="campus">
<tr>
<td  style="height: 70px;width:60px; border:solid 1px #fff; " >
${campus.key }
</td>
<c:forEach items="${campus.value }" var="course">
<td style=" height: 70px; width:110px; background:#E1ECF6;  border:solid 1px #fff;" align="left">
<c:choose>
<c:when test="${course == null }">
	无
</c:when>
<c:otherwise>
	${course.attrs['teach_type']}<br>
	S:${course.attrs['S_NAME']}<br>
	<c:if test="${!empty course.attrs['T_NAME']}">T:${course.attrs['T_NAME']}<br></c:if>
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