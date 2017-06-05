<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
.error {
	color: red;
	width: 150px;
}

label {
	width: 100px;
}
</style>
<title>IP地址修改</title>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<div class="ibox-content">
			<form action="" name="address" method="post" id="accountForm">
				<fieldset style="width: 100%">
					<input type="hidden" id="id" value="${ipaddress.id}">
					<p style="margin-top: 15px;">
						<label class="tac"><font color="red">*</font>IP地址：</label> 
						<input type="text" style="font-size: 12px; color: #0099FF" id="name" value="${ipaddress.name}">
					</p>
					<p style="margin-top: 15px;">
						<label>校区选择:</label> <select id="campus_name" class="chosen-select" style="display: inline; width: 132px;">
							<option value="">--${_res.get('Please.select')}--</option>
							<c:forEach items="${campus}" var="campus">
								<c:if test="${campus.Id == ipaddress.campus_id}">
									<option value="${campus.Id }" selected="selected">${campus.CAMPUS_NAME }</option>
								</c:if>
								<c:if test="${campus.Id != ipaddress.campus_id}">
									<option value="${campus.Id }">${campus.CAMPUS_NAME }</option>
								</c:if>
							</c:forEach>
						</select>
					</p>
					<p style="margin-top: 15px;">
						<label class="tac"> ${_res.get("student.buildtime")}: </label>
						<input type="text" id="ipaddress" class="required email" style="font-size: 12px" value="${ipaddress.create_time}" readonly="readonly" />
					</p>
					<p>
						<a id="savebutton" class="btn btn-outline btn-primary">${_res.get('save')}</a>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 10
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
	</script>
	<script>
		function doAddipaddress() {
			if ($("#name").html() != "") {
				alert("请检查IP");
				return false;
			}
			if ($("#name").val() == "" || $("#name").val() == null) {
				alert("请填写IP地址");
				return false;
			}
			if ($("#campus_name").val() == "" || $("#campus_name").val() == null) {
				alert("请选择校区");
				return false;
			}
			return true;
			//$("#addCampusForm").attr("action", "/campus/doAddCampusManager");
			//$("#addCampusForm").submit();

		}
	</script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script type="text/javascript">
		$("#savebutton").click(function() {
			var id = $("#id").val();
			var name = $("#name").val();
			var campusid = $("#campus_name").val();
			var falg = doAddipaddress();
			if (!falg) {
				return false;
			} else {
				$.ajax({
					cache : true,
					type : "POST",
					url : "/address/updateIpAddress",
					data : {
						'ipaddressId' : id,
						'campusid' : campusid,
						'name' : name
					},// 你的formid
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
		});
	</script>
	<script>
		$('li[ID=nav-nav11]').removeAttr('').attr('class', 'active');
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
	</script>
</body>
</html>