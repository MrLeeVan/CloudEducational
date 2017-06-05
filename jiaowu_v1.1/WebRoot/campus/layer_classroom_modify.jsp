<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>教室修改</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>教室修改</title>

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
			<form id="classroom" action="" method="post">
				<input type="hidden" name="classRoom.id" id="id" value="${classRoom.id}"> <input type="hidden" name="campusId" id="campusId" value="${classRoom.CAMPUS_ID}">
				<fieldset style="width: 100%; padding-top: 15px;">
					<p>
						<label>教室名称:</label> 
						<input type="text" id="roomName" name="classRoom.name" onchange="checname(this.value)" value="${classRoom.name }" size="20" maxlength="15" /><font color="red"> * </font><br> 
						<span id="classAddrMsg" style="color: red"></span>
					</p>
					<p>
						<label>教室地址:</label>
						<input type="text" id="address" name="classRoom.address" value="${classRoom.address }" size="20" maxlength="15" /><br> 
						<span id="classAddrMsg" style="color: red"></span>
					</p>
					<p>
						<label>最大人数:</label>
						<input type="text" id="maxpeople" name="classRoom.maxpeople" value="${classRoom.maxpeople }" size="20" maxlength="15" /><font color="red"> * </font> 
					</p>
					<c:if test="${operator_session.qx_campustoSaveModifyClassRoom }">
						<p>
							<input type="button" value="${_res.get('save')}" onclick="toSaveModifyClassRoom()" class="btn btn-outline btn-primary" />
						</p>
					</c:if>
				</fieldset>
			</form>
		</div>
	</div>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>

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
	</script>
	<script>
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		function toSaveModifyClassRoom() {
			var classAddr = $("#address").val();
			if (classAddr.trim() == "") {
				alert("名字不能为空");
				return false;
			} else if ($("#classAddrMsg").html() != "") {
				alert("请检查教室名称");
				return false;
			} else {
				if (confirm("确定提交？")) {
					$.ajax({
						cache : true,
						type : "POST",
						url : "${cxt}/campus/toSaveModifyClassRoom",
						data : {
							classAddr : $("#address").val(),
							id : $("#id").val(),
							maxpeople : $("#maxpeople").val()
						},
						async : false,
						error : function(request) {
							parent.layer.msg(data.msg, 1, 1);
						},
						success : function(data) {
							parent.layer.msg(data.msg, 9, 2);
							if (data.code == '1') {//成功
								setTimeout("parent.layer.close(index)", 3000);
								parent.window.location.reload();
							}
						}
					});
				}
			}
		}
		function checname(name) {
			var id = $("#id").val();
			var campusId = $("#campusId").val();
			$.ajax({
				url : "/campus/checkClassAddr",
				type : "post",
				data : {
					"roomName" : name,
					"campusId" : campusId,
					"id" : id
				},
				dataType : "json",
				success : function(data) {
					if (data) {
						$("#classAddrMsg").html("教室名称已存在");
					} else {
						$("#classAddrMsg").html("");
					}
				}
			});
		}
	</script>
	<script>
		$('li[ID=nav-nav1]').removeAttr('').attr('class', 'active');
	</script>
</body>
</html>