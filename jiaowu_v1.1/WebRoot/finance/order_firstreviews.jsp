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
				</tr>
			</table>
			<c:if test="${orders.checkstatus==2 }">
				审核记录<br>
				<table width="80%" class="table table-hover table-bordered">
					<thead>
						<tr>
							<th>审核人</th>
							<th >审核日期</th>
							<th>原因</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${reject}" var="reject" varStatus="index">
							<tr align="center" valign="bottom">
								<td width="10%" >${reject.operatorname }</td>
								<td width="25%" >${reject.rejecttime }</td>
								<td   align="left">${reject.reason }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
				<form id="paymentForm" action="" method="post">
					<fieldset style="width: 100%;">
						<input type="hidden" id="orderId" name="orderid" value="${orders.id }"/>
						<p>
							<label>是否通过：</label>
								<input type="radio" id="isPay" name="ispay" value="1" checked="checked">通过
								<input type="radio" id="isPay" name="ispay" value="0">未通过
						</p>
						<p id="jffs" style="display:none">
							<label>未通过原因：</label>
							<textarea id="gross" name="remark" cols="50" rows="7"></textarea><span id="grossInfo" style="color: red;"></span>
						</p>
						<c:if test="${operator_session.qx_ordersordersPassed || operator_session.qx_ordersordersReject }">
						<p>
							<input id="saveButton" type="button" value="${_res.get('admin.common.determine')}" class="btn btn-outline btn-primary" />
						</p>
						</c:if>
					</fieldset>
				</form>
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
		$('#saveButton').click(function(){
			var index = parent.layer.getFrameIndex(window.name);
			var status = $("input[id='isPay']:checked").val();
			if(confirm("确定此次审核？")){
				var path = "";
				if(status==1){
					path = "/orders/ordersPassed";
				}else{
					path = "/orders/ordersReject"
				}
				 $.ajax({
				        cache: true,
				        type: "POST",
				        url:path,
				        data:{
				        	"orderId" : $("#orderId").val(),
				        	"remark"  : $("#gross").val()
				        },
				        async: false,
				        error: function(request) {
				          	parent.layer.msg("网络异常，请稍后重试。", 2,2);
				        },
				        success: function(data) {
					   		parent.layer.msg(data.msg, 2,data.face);
					   		if(data.face==9){//更新成功
					   			parent.window.location.href="/orders/index?_query.needcheck=1";
					   			parent.layer.close(index);
					   		}
					   		
				        }
				  });
			}
		});
	
	
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