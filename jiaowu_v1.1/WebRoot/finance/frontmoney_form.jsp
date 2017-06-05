<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>收取定金</title>
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
	display: block;
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: pointer;
	margin-right: 38px;
}
</style>
</head>
<body>
	<div id="wrapper">
		<div class="ibox-content">
			<table width="80%" class="table table-hover table-bordered">
				<thead>
					<tr>
						<th>${_res.get("student.name")}</th>
						<td>${account.real_name}</td>
						<th>${_res.get("Date.Added")}</th>
						<td><fmt:formatDate value="${account.create_time}" type="time" timeStyle="full" pattern="yyyy-MM-dd" /></td>
					</tr>
				</thead>
			</table>
			<form id="paymentForm" action="" method="post">
				<fieldset style="width: 100%;">
					<input type="hidden" id="accountId" name="accountBook.accountid" value="${account.id }" />
					<input type="hidden" id="accountBookId" name="accountBook.id" value="${accountBook.id }" />
					<p>
						<label>${_res.get("Amount.being.paid")}：</label>
						<input type="text" id="amount" name="accountBook.temprealamount" value="${accountBook.temprealamount}" size="20" maxlength="15" />
						<span id="amountInfo"></span>
					</p>
					<p id="jffs">
						<label>${_res.get("Billing.method")}：</label>
						<input type="radio" id="payType" name="accountBook.paytype" value="1" checked='checked'>${_res.get("Cash")} 
						<input type="radio" id="payType" name="accountBook.paytype" value="2">${_res.get("Transfer")} 
						<input type="radio" id="payType" name="accountBook.paytype" value="3">${_res.get("POS")}
						<input type="radio" id="payType" name="accountBook.paytype" value="4">${_res.get('Else')}
					</p>
					<p id="jfrq">
						<label>${_res.get('Collection.days')}：</label>
						<input id="paydate" type="text" name="accountBook.paydate" readonly="readonly" value="${accountBook.paydate}" size="20" size="15" />
						<span id="paydateInfo" style="color: red;"></span>
					</p>
					<p>
						<label>${_res.get('course.remarks')}：</label>
						<textarea id="gross" name="accountBook.remark" cols="50" rows="7"></textarea>
						<span id="grossInfo" style="color: red;"></span>
					</p>
					<c:if test="${operator_session.qx_accountpayFrontMoney }">
					<p>
						<input id="saveButton" type="button" value="${_res.get('save')}" class="btn btn-outline btn-primary" />
					</p>
					</c:if>
				</fieldset>
			</form>
		</div>
		<script src="/js/js/jquery-2.1.1.min.js"></script>
		<!-- Chosen -->
		<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
		<!-- layerDate plugin javascript -->
		<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
		<script>
			$(".chosen-select").chosen({
				disable_search_threshold : 30
			});
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
				isclear : false,
				max : laydate.now(), //最大日期
				istime : false,
				istoday : true
			};
			laydate(paydate);

			var index = parent.layer.getFrameIndex(window.name);
			$("#paydate").val(laydate.now());

			parent.layer.iframeAuto(index);
			$('#saveButton').click(function() {
				var amount = $("#amount").val();
				var path = "${cxt}/account/payFrontMoney";
				if (amount.match(/^([1-9]\d*|[0]{1,1})$/) == null) {
					$("#amountInfo").text("请输入正确的收费金额，不能含有小数");
				} else {
					if (amount == 0) {
						$("#amountInfo").text("收费金额不能为0.");
					} else {
						if (confirm("请再次确认收款金额是否确定！")) {
							$.ajax({
								cache : true,
								type : "POST",
								url : path,
								data : $('#paymentForm').serialize(),// 你的formid
								async : false,
								error : function(request) {
									parent.layer.msg("网络异常，请稍后重试。", 1, 1);
								},
								success : function(data) {
									parent.layer.msg(data.msg, 6, 0);
									if (data.code == '1') {//成功
										parent.window.location.reload();
										setTimeout("parent.layer.close(index)", 1000);
									}
								}
							});
						}
					}
				}
			});

		</script>
</body>
</html>