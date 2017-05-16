<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script src="/js/js/jquery-2.1.1.min.js"></script>
<script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
<script src='/fullcalendar/fullcalendar.min.js'></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />

<title>${_res.get('Details.s')}</title>

<style type="text/css">
.stu_name {
	position: relative;
	margin-bottom: 15px;
}

.stu_name label {
	display: inline-block;
	font-size: 12px;
	vertical-align: middle;
	width: 170px;
}

.student_list_wrap {
	position: absolute;
	top: 28px;
	left: 14.8em;
	width: 130px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 8px;
}

.student_list_wrap li {
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: text;
}

.teacherTimeRankWrap {
	position: absolute;
	left: 37em;
	top: 16em;
	padding: 10px;
	overflow: hidden;
	z-index: 2013;
	background: #FCF2CF;
	border: 1px solid #F8BD81;
	box-shadow: 2px 2px 3px #DDD;
}

.teacherTimeRankWrap h1 {
	line-height: 24px;
	text-align: center;
	font-size: 14px;
	font-weigth: bold;
	margin-bottom: 10px;
	padding-bottom: 6px;
	border-bottom: 1px dotted #F8BD81;
}

#timeRankCloseBtn {
	display: inline-block;
	float: right;
	width: 18px;
	height: 18px;
	cursor: pointer;
}

#teacherTimeRank p {
	line-height: 24px;
	margin: 0;
}
</style>
</head>
<body>
	<input type="hidden" class="signs" value=${sign } />
	<div id="wrapper" style="background: #2f4050;">
		<div class="left-nav"><%@ include file="/common/left-nav.jsp"%></div>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff; border: 0">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="ibox float-e-margins margin-nav1">
				<div class="col-lg-12" style="margin-left: -14px;">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp; <a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; <a href="/classtype/findClassOrder">${_res.get("class.group.class.management")}</a> &gt; 班课课程详细信息
							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right"> ${_res.get("system.reback")} </a>
							<div style="clear: both;"></div>
						</div>
						<div class="ibox-content">
							<form action="/classtype/showBanciDetail?id=${id}" method="post" id="searchForm">
								<fieldset style="width: 820px; overflow: hidden;">
									<table class="table table-hover table-bordered">
										<thead>
											<tr align="center">
												<th>${_res.get('class.number')}</th>
												<th>${_res.get("class.name.of.class.type")}</th>
												<th>${_res.get("class.number.of.students")}</th>
												<c:if test="${classOrder.chargeType == 1 }">
												<th>${_res.get("class.number.of.class.sessions")}</th>
												</c:if>
												<th>${_res.get('chargeType')}</th>
												<th>${_res.get("class.starting.date")}</th>
												<th>${_res.get("admin.sysLog.property.enddate")}</th>
											</tr>
										</thead>
										<tr align="center">
											<td>${classOrder.classNum }</td>
											<td>${classOrder.classTypeName }</td>
											<td>${classOrder.studentCount }<c:if test="${order.chargeType == 1 }">/${classOrder.stuNum }</c:if></td>
											<c:if test="${classOrder.chargeType == 1 }">
											<td>${classOrder.lessonNum }</td>
											</c:if>
											<td>${classOrder.chargeType == 0?_res.get('byTeachingHours'):_res.get('onTime') }</td>
											<td>${classOrder.teachTime }</td>
											<td>${classOrder.endTime }</td>
										</tr>
									</table>
									<table class="table table-hover table-bordered">
										<thead>
											<tr align="center">
												<th>${_res.get('Selected.course')}</th>
												<th><c:choose>
														<c:when test="${classOrder.chargeType == 0}">   
														${_res.get('RMB')}/${_res.get('session')}
													</c:when>
														<c:otherwise>   
														${_res.get('session')}
													</c:otherwise>
													</c:choose></th>
												<th>${_res.get("scheduled.classes")}(${_res.get("session")})</th>
												<c:if test="${classOrder.chargeType == 1 }">
													<th>${_res.get('Not.ranked')}(${_res.get("session")})</th>
												</c:if>
											</tr>
										</thead>
										<c:forEach items="${courseList }" var="course">
											<tr align="center">
												<td>${course.COURSE_NAME }</td>
												<td>${course.lesson_num }</td>
												<td>${course.coursePlanCount }</td>
												<c:if test="${classOrder.chargeType == 1 }">
													<td>${course.lesson_num - course.coursePlanCount }</td>
												</c:if>
											</tr>
										</c:forEach>
									</table>
									<table class="table table-hover table-bordered">
										<thead>
											<tr align="center">
												<th>ID</th>
												<th>${_res.get("sysname")}</th>
												<th>${_res.get("admin.user.property.telephone")}</th>
												<th>Email</th>
												<th>${_res.get('createtime')}</th>
												<th>${_res.get("class.number.of.class.sessions")}</th>
												<th>状态</th>
												<th>操作</th>
											</tr>
										</thead>
										<c:forEach items="${studentList }" var="stu" varStatus="s">
											<tr align="center" class="${stu.account_id }">
												<td>${s.count }</td>
												<td>${stu.REAL_NAME }</td>
												<td>${stu.TEL }</td>
												<td>${stu.EMAIL }</td>
												<td>
													<fmt:formatDate value="${stu.createDate }" type="time" pattern="yyyy-MM-dd HH:mm:ss"/>
												</td>
												<td>${stu.orderHour }</td>
												<td>${stu.state eq 0?'正常':'已退班' }</td>
												<td>
													<a href="#" onclick="removeAccount(${stu.id})">${stu.state eq 0?'退班':'恢复' }</a>
													<a href="#" onclick="chooseCoursePlan(${stu.id})">课程</a>
												</td>
											</tr>
										</c:forEach>
									</table>
									<table class="table table-hover table-bordered">
										<thead>
											<tr align="center">
												<th>序号</th>
												<th>课程</th>
												<th>校区</th>
												<th>教室</th>
												<th>日期</th>
												<th>时段</th>
												<th>老师</th>
											</tr>
										</thead>
										<c:if test="${empty coursePlanList }">
											<tr>
												<td colspan="7">还没有安排课程，现在就去
												<c:if test="${operator_session.qx_courseaddCourseWeekPlan }">
												<a href="javascript:void(0)" onclick="window.location.href='/course/addCourseWeekPlan?studentId=${classOrder.accountid}&banjiType=2'">${_res.get('course.arranging')}</a>
												</c:if>
												</td>
											</tr>
										</c:if>
										<c:forEach items="${coursePlanList.list }" var="coursePlan" varStatus="s">
											<tr align="center">
												<td>${s.count }</td>
												<td>${coursePlan.courseName }</td>
												<td>${coursePlan.campusName }</td>
												<td>${coursePlan.roomName }</td>
												<td>
													<fmt:formatDate value="${coursePlan.courseTime }" pattern="yyyy-MM-dd"/>
												</td>
												<td>${coursePlan.timeName }</td>
												<td>${coursePlan.teacherName }</td>
											</tr>
										</c:forEach>
									</table>
								</fieldset>
								<div id="splitPageDiv">
									<jsp:include page="/common/splitPage.jsp" />
								</div>
							</form>
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
		<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); 
    </script>
	<script type="text/javascript">
		function removeAccount(accountBanciId){
			if(confirm("确定该学生要恢复/退班吗？")){
				$.ajax({
					url : "/classtype/removeAccountFromClass",
					data : {
						"accountBanciId" : accountBanciId
					},
					type : "post",
					dataType : "json",
					success : function(result){
						if(result.result == "true"){
							window.location.reload();
						}else{
							alert("操作失败请联系管理员");
						}
					}
				});
			}
		}
		
	      function chooseCoursePlan(id){
	    	/*   $.layer({
	      		type:2,
	      		title: "设置课程",
	      		closeBtn:[0,true],
	      		shade:[0.5,'#000'],
	      		shadeClose:true,
	      		area:['800px','500px'],
	      		iframe: {src: '${cxt}/classtype/chooseCoursePlan/'+id}
	      	}); */
	      	window.location.href='${cxt}/classtype/chooseCoursePlan/'+id;
	      }
		
       $('li[ID=nav-nav6]').removeAttr('').attr('class','active');
    </script>
</body>
</html>