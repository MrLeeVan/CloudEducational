<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">
	
</script>
<title>${_res.get('class_type_management')}</title>

<style type="text/css">
label {
	height: 34px;
	width: 80px;
}

.subject_name {
	width: 520px;
	margin: -50px 0 0 82px;
}

.class_type {
	margin: -50px 0 40px 82px;
}

#classtype div {
	float: left;
	margin-right: 15px
}

.student_list_wrap {
	position: absolute;
	top: 100px;
	left: 9.5em;
	width: 100px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
}
</style>
</head>
<body style="background: #fff;">
	<div class="ibox-content"  style="width: 380px; height: 340px;">
		<form action="" method="post" id="#" name="form1">
			<input type="hidden" value="${ids }" id="ids">
			<div class="padding-ten">
			<div style="float:left;height:60px;margin-left: 30px">
					<font style="color:#66CDAA;size:15px"><label>${_res.get("reason.of.deleting") }： </label></font>
			</div>
			<div  style="float:none;height:240px;margin-top: 10px;margin-left: 30px">
					<textarea rows="8" cols="50" id="reason" name="reason"></textarea>
			</div>
			<div style="float:none;height:10px;margin-top: 10px;margin-left: 30px">
				<input type="button" onclick='batchDelete()' id="vallot" value="${_res.get('admin.common.delete')}" class="btn btn-outline btn-primary">
			</div>
			</div>
		</form>
		<div style="display: none" id="piaoo">
			<h5 onclick="closepiao();">
				<span id="timeRankCloseBtn" title="${_res.get('admin.common.close')}">X</span><label id="teacherNamePiao"></label>
			</h5>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script>
		$('li[ID=nav-nav6]').removeAttr('').attr('class', 'active');

		//弹出后子页面大小会自动适应
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
	</script>
	<script type="text/javascript">
		/**
		 *
		 *批量删除记录
		 */
		function batchDelete() {
			var ids = $('#ids').val();
			var reason = $('#reason').val();
			if (reason == null || reason.length<=0) {
				layer.msg("${_res.get('pleaseReason')}");
				return false;
			}else {
				$.layer({
					shade : [ 0 ], //不显示遮罩
					area : [ 'auto', 'auto' ],
					dialog : {
						msg : "${_res.get('deleteConfirm')}",
						btns : 2,
						type : 4,
						 btn : ["${_res.get('admin.common.determine')}","${_res.get('Cancel')}"],
						yes : function() {
							$.ajax({
								url : "${cxt}/courseplan/batchDelete",
								type : "post",
								cache : false,
								data : {
									"selectIdValue" : ids,
									"reason" : reason
								},
								dataType : "json",
								success : function(date) {
									if (date.code == "1") {
										layer.msg(date.result, 2, 2);
										parent.location.reload();

									}
									if (date.code == "0") {
										layer.msg(date.result, 2, 1);
										parent.search();
									}
								}
							})
						}
					}
				})
			}
		}
	</script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
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
</body>
</html>
