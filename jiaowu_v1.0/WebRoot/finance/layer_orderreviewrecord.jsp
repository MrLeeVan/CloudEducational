<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>审核</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<style type="text/css">
body {
	background-color: #eff2f4;
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
	padding: 6px;
}
.student_list_wrap li {
	display:block;
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: pointer;
	margin-right:38px;
}
</style>
</head>
<body>
	<div id="wrapper">
		<div class="ibox-content">
			<input type="hidden" id="realsum" name="payment.id" value="${orders.realsum }"/>
			<input type="hidden" id="paidamount" name="payment.id" value="${orders.paidamount==null?0:orders.paidamount }"/>
			<table width="80%" class="table table-hover table-bordered">
				<thead>
					<tr>
						<th>${_res.get("student.name")}</th>
						<th>${_res.get('type.of.class')}</th>
						<th>${_res.get('course.subject')}/${_res.get('classNum')}</th>
						<th>${_res.get('total.amount')}</th>
						<th>${_res.get('actual.amount')}</th>
						<th>${_res.get('discount.amount')}</th>
						<th>${_res.get('total.sessions')}</th>
						<th>交费次数</th>
						<th>已交金额</th>
					</tr>
				</thead>
				<tr align="center">
					<td>${orders.studentname}</td>
					<td>${orders.teachtype==1?_res.get("IEP"):_res.get('course.classes')}</td>
					<td>${orders.teachtype==1?orders.subjectname:orders.classnum}</td>
					<td>${orders.totalsum}</td>
					<td>${orders.realsum}</td>
					<td>${orders.rebate}</td>
					<td>${orders.classhour}</td>
					<td>${orders.paycount}</td>
					<td>${orders.paidamount}</td>
				</tr>
			</table>
			<c:if test="${orders.checkstatus==1 }">
				审核记录<br>
				<table width="80%" class="table table-hover table-bordered" align="center">
					<thead>
						<tr>
							<th>审核人</th>
							<th >审核日期</th>
							<th>${_res.get("course.remarks")}</th>
						</tr>
					</thead>
					<tbody>
						<tr align="center"><td>${orders.operatorname }</td><td>${orders.checktime }</td><td>通过</td></tr>
						<c:if test="${msg==1 }">
							<c:forEach items="${reject}" var="reject" varStatus="index">
								<tr align="center">
									<td >${reject.operatorname }</td>
									<td >${reject.rejecttime }</td>
									<td >${reject.reason }</td>
								</tr>
							</c:forEach>
						</c:if>
					</tbody>
				</table>
			</c:if>
			<c:if test="${orders.delflag eq true }">
				取消信息<br>
				<table width="80%" class="table table-hover table-bordered">
					<thead>
						<tr>
							<th>操作人</th>
							<th>取消日期</th>
							<th>取消原因</th>
						</tr>
					</thead>
					<tbody>
						<tr align="center" valign="bottom">
							<td width="10%">${orders.delusername }</td>
							<td width="25%">${orders.deltime }</td>
							<td align="left">${orders.delreason }</td>
						</tr>
					</tbody>
				</table>
			</c:if>			
		</div>
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script>
	 $(".chosen-select").chosen({disable_search_threshold: 30});
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : true
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 10
			},
			'.chosen-select-no-results' : {
				no_results_text : 'Oops, nothing found!'
			},
			'.chosen-select-width' : {
				width : "95%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
		
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		
	</script>
</body>
</html>