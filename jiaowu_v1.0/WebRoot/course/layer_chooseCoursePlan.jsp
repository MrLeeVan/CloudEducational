<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<!-- Mainly scripts -->
<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>设置课程</title>
</head>
<body>
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
					<div class="ibox-title">
						<h5>
							<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp; <a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; <a href="/classtype/findClassOrder">${_res.get("class.group.class.management")}</a> &gt; 设置课程
						</h5>
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right"> ${_res.get("system.reback")} </a>
						<div style="clear: both;"></div>
					</div>
					<div class="ibox-content">
						<input type="hidden" id="studentId" value="${student.id }" />
						<table class="table table-hover table-bordered">
							<caption>${student.real_name }的${classOrder.classNum }班课订单</caption>
							<thead>
								<tr>
									<th>序号</th>
									<th>订单日期</th>
									<th>状态</th>
									<th>${_res.get('actual.amount')}</th>
									<th>${_res.get('total.sessions')}</th>
								</tr>
							</thead>
							<c:forEach items="${courseOrderList }" var="orders" varStatus="s">
								<tr align="center">
									<td>${s.count}</td>
									<td><fmt:formatDate value="${orders.createtime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
									<td><c:choose>
											<c:when test="${orders.delflag}">
									已删除
								</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test="${orders.status==0 }">未支付</c:when>
													<c:when test="${orders.status==1 }">已支付</c:when>
													<c:when test="${orders.status==2 }">欠费</c:when>
												</c:choose>
											</c:otherwise>
										</c:choose></td>
									<td>${orders.realsum}</td>
									<td>${orders.classhour}</td>
								</tr>
								<c:if test="${!empty orders.coursePriceList }">
									<tr align="left">
										<td colspan="5">
											<c:forEach items="${orders.coursePriceList}" var="coursePrice" varStatus="index">
												${index.count}、${coursePrice.course_name}：${coursePrice.classhour}(课时)&nbsp;
												<c:if test="${index.count == 4}">
													<br />
												</c:if>
											</c:forEach>
										</td>
									</tr>
								</c:if>
								<c:if test="${!empty orders.remark }">
									<tr align="left">
										<td colspan="5">备注：${orders.remark }</td>
									</tr>
								</c:if>
							</c:forEach>
						</table>
						<span id="errormsg" style="color: red;"></span>
						<form action="/classtype/chooseCoursePlan/${accountBanciId }" method="post" id="searchForm">
						<table class="table table-hover table-bordered">
							<thead>
								<tr align="center">
									<th><input ${showChooseAll?'type="checkbox"':'type="hidden"' } id="chooseAll" ${chooseAll?'checked="checked"':''} /></th>
									<th>课程</th>
									<th>校区</th>
									<th>教室</th>
									<th>日期</th>
									<th>时段</th>
									<th>老师</th>
								</tr>
							</thead>
							<c:if test="${empty coursePlanList.list }">
								<tr>
									<td colspan="7">还没有安排课程，请先 <c:if test="${operator_session.qx_courseaddCourseWeekPlan }">
											<a href="javascript:void(0)" onclick="window.location.href='/course/addCourseWeekPlan?studentId=${classOrder.accountid}&banjiType=2'">${_res.get('course.arranging')}</a>
										</c:if>
								</tr>
							</c:if>
							<tbody id="coursePlans">
								<c:forEach items="${coursePlanList.list }" var="coursePlan" varStatus="s">
									<tr align="center">
										<td>
											<c:choose>
												<c:when test="${coursePlan.isConflict}">
													<a href="/course/queryCoursePlansManagement?studentName=${student.real_name }&date1=${fn:substring(coursePlan.courseTime, 0, 10)}&date2=${fn:substring(coursePlan.courseTime, 0, 10)}">
														1对1占用
													</a>
												</c:when>
												<c:otherwise>
													<input type="checkbox" id="coursePlanId" name="coursePlanId" value="${coursePlan.id}" ${coursePlan.choose?'checked="checked"':'' } onclick="chooseAndCancel(this)" />
												</c:otherwise>
											</c:choose>
										</td>
										<td>${coursePlan.courseName }</td>
										<td>${coursePlan.campusName }</td>
										<td>${coursePlan.roomName }</td>
										<td><fmt:formatDate value="${coursePlan.courseTime }" pattern="yyyy-MM-dd" /></td>
										<td>${coursePlan.timeName }</td>
										<td>${coursePlan.teacherName }</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
							<div id="splitPageDiv">
								<jsp:include page="/common/splitPage.jsp" />
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script>
		$("#chooseAll").click(function() {
			var studentId = $("#studentId").val();
			if (this.checked) {
				$("input[name='coursePlanId']").each(function() {
					$(this).prop("checked", true);
					var coursePlanId = $(this).val();
					addAndCancel(coursePlanId, studentId, 'add',this);
				});
			} else {
				$("input[name='coursePlanId']").each(function() {
					$(this).prop('checked', false);
					var coursePlanId = $(this).val();
					addAndCancel(coursePlanId, studentId, 'cancel',this);
				});
			}
		});

		function chooseAndCancel(obj) {
			var studentId = $("#studentId").val();
			var coursePlanId = $(obj).val();
			var operateType;
			if (obj.checked) {
				operateType = "add";
			} else {
				operateType = "cancel";
			}
			addAndCancel(coursePlanId, studentId, operateType,obj);
		}

		function addAndCancel(coursePlanId, studentId, operateType,obj) {
			$.ajax({
				url : "/teachergrade/add",
				data : {
					"coursePlanId" : coursePlanId,
					"studentId" : studentId,
					"operateType" : operateType
				},
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result.code == 1) {
						$("#errormsg").html(result.msg); 
						$(obj).prop('checked', false);
					}else{
						$("#errormsg").html("");
					}
				}
			});
		}
		//弹出后子页面大小会自动适应
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
	</script>
</body>
</html>