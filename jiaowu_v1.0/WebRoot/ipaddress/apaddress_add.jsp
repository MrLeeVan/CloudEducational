<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>添加IP地址</title>
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
		<div class="ibox-content" style="height:200px">
			<form action="" name="ipaddress" method="post" id="accountForm">
				<p style="margin-top: 15px;">
					<label class="tac">
					<font color="red">*</font>ip地址：</label>
					<input type="text" id="ipaddress" name="ipaddress" style="font-size: 12px; color: #0099FF">
				</p>
				<p style="margin-top: 15px;">
					<label>校区选择:</label>
					<select id="campus_name" class="chosen-select" style="display: inline; width: 132px;">
						<option value="">--${_res.get('Please.select')}--</option>
						<c:forEach items="${campus}" var="campus">
							<option value="${campus.Id }">${campus.CAMPUS_NAME }</option>
						</c:forEach>
					</select>
				</p>
					<p>
						<a id="savebutton" class="btn btn-outline btn-primary">${_res.get('save')}</a>
					</p>
			</form>
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
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script>
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);

		$('li[ID=nav-nav11]').removeAttr('').attr('class', 'active');
	</script>
	<script type="text/javascript">
		$("#savebutton").click(function() {
			var ipaddressId = $("#ipaddress").val();
			var campusId = $("#campus_name").val();
			var falg = doAddipaddress();
			if (!falg) {
				return false;
			} else {
				$.ajax({
					cache : true,
					type : "POST",
					url : "/address/createIpAddress",
					data : {
						'ip' : ipaddressId,
						'campusid' : campusId
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
		function doAddipaddress() {
			if ($("#ipaddress").html() != "") {
				alert("请检查IP");
				return false;
			}
			if ($("#ipaddress").val() == "" || $("#ipaddress").val() == null) {
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

</body>
</html>