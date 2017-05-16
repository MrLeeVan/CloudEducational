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
<body style="background: white;">
	<div id="wrapper">
		<div class="ibox-content">
			<div style="float: right; margin-left: 68%">
				<h2>Invoice</h2>
				<h6>
					Invoice Number:
					<fmt:formatDate value="${date}" type="time" timeStyle="full" pattern="yyyy-MM-dd" />
				</h6>
			</div>
			<h2>Bespoke Programme:${student.real_name}</h2>
			<h4>定制教育咨询服务：${student.real_name}</h4>
			<table class="table table-hover table-bordered">
				<thead>
					<tr>
						<th>Description描述</th>
						<th>Quantity数量</th>
						<th>Unit Price单价</th>
						<th>Total总价</th>
					</tr>
				</thead>
				<c:forEach items="${list}" var="orders">
					<tr align="center">
						<td>${orders.paymessage.teachtype==1?orders.paymessage.subjectname:orders.paymessage.classnum}</td>
						<td>${orders.paymessage.classhour}</td>
						<td>${orders.paymessage.avgprice}</td>
						<td>${orders.paymessage.realsum-orders.paymessage.paidamount}</td>
					</tr>
				</c:forEach>
			</table>
			<div style="float: right; margin-left: 100%;">Total:${totelqfe}(RMB)</div>
			<div style="width: 100%">
				<h3>汇款账户名称：${organization.bankAccountName }</h3>
				<h3>账号：${organization.bankAccountNumber }</h3>
				<h3>${organization.bankAddress }</h3>
				<h3>
					付款日期：<input type="text" id="paydate" width="100px;">
				</h3>
				<h3>
					收件人： <select id="emailid" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 600px;" tabindex="4">
						<option value="${student.email}" ${student.email==null?"disabled='disabled'":""} class="options">学生（${student.email==null?'邮箱未添加':student.email}）</option>
						<option value="${student.fatheremail}" ${student.fatheremail==null?"disabled='disabled'":""} class="options">父亲（${student.fatheremail==null?'邮箱未添加':student.fatheremail}）</option>
						<option value="${student.motheremail}" ${student.motheremail==null?"disabled='disabled'":""} class="options">母亲（${student.motheremail==null?'邮箱未添加':student.motheremail}）</option>
					</select>
				</h3>
				<h3>
					抄送人： <select id="userid" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 600px;" tabindex="4">
						<c:forEach items="${ulist}" var="user">
							<option value="${user.email}" class="optionss">${user.real_name}</option>
						</c:forEach>
					</select>
				</h3>
			</div>
			<div style="float: right; margin-left: 68%">
				<a onclick="preview()" class="btn btn-outline btn-primary">预览</a> 
				<input type="button" class="btn btn-outline btn-primary" onclick="send()" value="发送"> 
				<input type="hidden" id="studentid" value="${student.id}">
			</div>
		</div>
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
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
			min : laydate.now(), //最大日期
			istime : false,
			istoday : true
		};
		laydate(paydate);

		var index = parent.layer.getFrameIndex(window.name);

		function getIds(str) {
			var ids = '';
			var lists = document.getElementsByClassName("search-choice");
			for (var i = 0; i < lists.length; i++) {
				var name = lists[i].children[0].innerHTML;
				var olist = document.getElementsByClassName(str);
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						ids += "," + olist[j].getAttribute('value');
						break;
					}
				}
			}
			return ids;
		}

		function preview() {
			var studentid = $("#studentid").val();
			var paydate = $("#paydate").val();
			if (paydate == "") {
				layer.msg("请选择日期", 1, 2);
				return false;
			}
			window.open("/orders/preview?studentid="+studentid+"&paydate="+paydate);
		}
		function send() {
			var toemails = getIds("options");
			if (toemails == "") {
				layer.msg("请选择收件人", 1, 2);
				return false;
			}
			var ccemails = getIds("optionss");
			var studentid = $("#studentid").val();
			var paydate = $("#paydate").val();
			if (paydate == "") {
				layer.msg("请选择日期", 1, 2);
				return false;
			}
			$.ajax({
				url : '/orders/sendPaymentMessage',
				type : 'post',
				data : {
					'studentid' : studentid,
					'paydate' : paydate,
					'toemails' : toemails,
					'ccemails' : ccemails
				},
				dataType : 'json',
				success : function(data) {
					if (data.code == 1) {
						layer.msg("发送成功", 1, 1);
					} else {
						layer.msg("发送失败", 1, 2);
					}
					setTimeout("parent.window.location.reload();", 1000)
				}
			})
		}
	</script>
</body>
</html>