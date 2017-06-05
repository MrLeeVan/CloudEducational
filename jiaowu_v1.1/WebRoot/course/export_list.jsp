<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/css/courseplanPrint.css" rel="stylesheet" media="print"/>
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet"/>
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet"/>
<link href="/css/css/animate.css" rel="stylesheet"/>

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/jquery.PrintArea.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<title>${_res.get('Export.Data')}</title>
<style type="text/css">
.header{
font-size:12px;
}
</style>
<script type="text/javascript">
var i=0;
</script>
</head>
<body>
<div id="wrapper" style="background: #2f4050;">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="margin-nav my_show">
  <div class="col-lg-12">
     <div class="ibox float-e-margins">
        <div class="ibox-title">
			<h5>
				<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
				&gt; <a href="/course/queryAllcoursePlans?loginId=${account_session.id}&returnType=1&campusId=0" >${_res.get('curriculum_management')}</a> &gt; ${_res.get('Export.Data')}
			</h5>
			<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback")}</a>
			<div style="clear: both;"></div>
		</div>
        <div class="ibox-content ">
            <table border="1" class="normal tablesorter" >
<c:forEach items="${plans}" var="roomFiled">
<c:if test="${roomFiled!=null}">
<c:forEach items="${roomFiled}" var="plan" begin="0" varStatus="idxStatus">
<c:if test="${plan!=null}">
<script>
if(i%5==0){
	document.write('<tr class="odd" align="center" >');
}
i=i+1;
</script>
<td align="left" width="220px" style="border:1px solid;padding-left: 20px" >
${plan.COURSE_TIME }[${_res.get('Week')}${plan.WEEKDAY }]<br/>
${_res.get('Period')}:${plan.RANKNAME}<br/>
${_res.get('student')}:${plan.STUDENTNAME }<br/>
${_res.get('teacher')}:${plan.TEACHERNAME }<br/>
${_res.get('system.campus')}:${plan.CAMPUSNAME }<br/>
${_res.get('classroom')}:${plan.ROOMNAME }<br/>
${_res.get('course.course')}:${plan.COURSENAME }<br/>
<c:if test="${!empty plan.classNum}">
	${_res.get('classNum')}：${plan.classNum}<br>
	${_res.get('class.class.type')}：${plan.type_name}<br>
</c:if>

<div class="bei-zhu" style="word-wrap:break-word; overflow:hidden; ">${_res.get("course.remarks")}:${plan.REMARK }</div>
</td>
<script>
if(i%5==0){
	document.write('</tr>');
}
</script>
</c:if>
</c:forEach>
</c:if>
</c:forEach>
</table>
           <input type="button" class="btn btn-outline btn-info" value="${_res.get('Print')}" id="print" style="margin-top:20px"/>  
        </div>
     </div>
   </div>
   <div style="clear: both;"></div>     
  </div>
 </div>
 
</div> 

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script>
       $('li[ID=nav-nav3]').removeAttr('').attr('class','active');
    </script>
	<script>
	
	$(document).ready(function(){
		$("#print").click(function(){
		$(".my_show").printArea();
		});
		}); 
	</script>
</body>
</html>