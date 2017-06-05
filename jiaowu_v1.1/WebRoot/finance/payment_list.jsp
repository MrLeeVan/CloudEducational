<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>交费</title>
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
			<table class="table table-hover table-bordered">
				<thead>
					<tr>
						<th>${_res.get("student.name")}</th>
						<th>${_res.get('type.of.class')}</th>
						<th>${_res.get('course.subject')}/${_res.get('classNum')}</th>
						<th>${_res.get('actual.amount')}</th>
						<th>${_res.get('total.sessions')}</th>
					</tr>
				</thead>
				<tr align="center">
					<td>${orders.studentname}</td>
					<td>${orders.teachtype==1?_res.get("IEP"):_res.get('course.classes')}</td>
					<td>${orders.teachtype==1?orders.subjectname:orders.classnum}</td>
					<td>${orders.realsum}</td>
					<td>${orders.classhour}</td>
				</tr>
				<c:if test="${!empty orders.coursePriceList }">
					<tr align="left">
						<td colspan="6">
						<c:forEach items="${orders.coursePriceList}" var="coursePrice" varStatus="index">
							${index.count}、${coursePrice.course_name}：${coursePrice.classhour}(课时)&nbsp;
							<c:if test="${index.count == 4}"><br/></c:if>
						</c:forEach>
						</td>
					</tr>
				</c:if>
				<c:if test="${!empty orders.remark }">
					<tr align="left">
						<td colspan="6">
							备注：${orders.remark }
						</td>
					</tr>
				</c:if>
			</table>
			<c:if test="${orders.checkstatus ne 0 }">
				审核记录<br>
				<table class="table table-hover table-bordered" >
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
				<table class="table table-hover table-bordered">
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
			<c:if test="${!empty paymentList }">
				<table class="table table-hover table-bordered">
					<thead>
						<tr>
							<th>${_res.get("index")}</th>
							<th>记录时间</th>
							<th>记录人</th>
							<th>购课日期</th>
							<th>${_res.get("operation")}</th>
						</tr>
					</thead>
					<c:forEach items="${paymentList}" var="payment" varStatus="index">
						<tr align="center">
							<td>${index.count}</td>
							<td><fmt:formatDate value="${payment.createtime}" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${payment.operatorname}</td>
							<td>${payment.paydate}</td>
							<td>
								<c:choose>
									<c:when test="${payment.ispay eq true }">已确认</c:when>
									<c:otherwise>
									<c:if test="${operator_session.qx_paymenttoConfirmPage }">
									<a href="#" style="color: #515151" onclick="queren(${payment.id})">确认收款</a>
									</c:if>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</table>
			</c:if>
			<c:if test="${orders.checkstatus ne 1 }">
				<form id="paymentForm" action="" method="post">
					<fieldset style="width: 100%;">
						<input type="hidden" id="orderId" name="orderid" value="${orders.id }"/>
						<p id="jffs" style="display:none">
							<label>未通过原因：</label>
							<textarea id="gross" name="remark" cols="50" rows="3"></textarea><span id="grossInfo" style="color: red;"></span>
						</p>
					</fieldset>
				</form>
			</c:if>	
			<br/>
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
		//日期范围限制
		var paydate = {
			elem : '#paydate',
			format : 'YYYY-MM-DD',
			isclear: false, 
			max : laydate.now(), //最大日期
			istime : false,
			istoday : true
		};
		laydate(paydate);
		if('${payment}'==''){
			$("#classhour").val('${orders.classhour}');	
			$("#amount").val('${orders.realsum}');	
			$("#paydate").val(laydate.now());	
		}
	</script>
	<script type="text/javascript">
	var index = parent.layer.getFrameIndex(window.name);
	parent.layer.iframeAuto(index);
	function queren(paymentId){
		 window.location.href="${cxt}/payment/toConfirmPage/"+paymentId;
	}
	
	$(function() {
		$("input[id='isPay']").click(function() {
			var ispay = $(this).val();
			if(ispay=='1'){
				$("#jffs").hide();
			}else{
				$("#jffs").show();
			}
		});
	});
	
	</script>
</body>
</html>