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
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet" />
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script src="/js/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
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
<body style="background: #fff">
	<div class="ibox-content" style="width: 100%; height: 100%;">
		<div id="wrapper" style="background: #2f4050;">
			<div class="gray-bg dashbard-1" id="page-wrapper" style="padding-left: 0; padding-right: 0; min-height: auto">
				<form action="" method="post" id="/courseplan/UpdateTeachers" name="form1">
					<input type="hidden" value="${ids }" id="ids">
					<!--ID列表  -->
					<div id="update" style="disabled: disabled;">
						<div class="col-lg-12" style="padding-left: 0; padding-right: 0">
							<div class="ibox float-e-margins" style="margin-bottom: 0">
								<div class="ibox-content">
									<span class="m-r-sm text-muted welcome-message"> 
										<label>${_res.get('Please.select')}：</label>&nbsp;${_res.get('All.day.long')} 
										<input type="radio" id="all_tues1" name="all_tues" value="1" onclick="checkdaymon(this.value)">${_res.get('admin.common.yes')} 
										<input type="radio" id="all_tues2" name="all_tues" value="0" checked="checked" onclick="checkdaymon(this.value)" />${_res.get('admin.common.no')} 
										<span id="tues_time" style="padding-left: 50px;"><br>
										<label>${_res.get('Please.select')}：</label>&nbsp; 
										<select id="tuesstarthour" name="tuesstarthour" class="chosen-select" style="width: 80px;">
											<c:forEach items="${hour}" var="starthourlist">
												<option value="${starthourlist.key }">${starthourlist.value }</option>
											</c:forEach>
										</select>&nbsp;:&nbsp; 
										<select id="tuesstartmin" name="tuesstartmin" class="chosen-select" style="width: 80px;">
											<option value="00">00</option>
											<option value="30">30</option>
										</select>&nbsp;--&nbsp; 
										<select id="tuesendhour" name="tuesendhour" class="chosen-select" style="width: 80px;">
											<c:forEach items="${hour}" var="endhourlist">
												<option value="${endhourlist.key }">${endhourlist.value }</option>
											</c:forEach>
										</select>&nbsp;:&nbsp; 
										<select id="tuesendmin" name="tuesendmin" class="chosen-select" style="width: 80px;">
											<option value="00">00</option>
											<option value="30">30</option>
										</select> 
										</span> <br> 
										<label></label><span id="tuesdaydata" style="display: none;"></span>
									</span>
								</div>
								<div class="ibox-content">
									<span class="m-r-sm text-muted welcome-message"> 
										<input type="button" value="${_res.get('Modify')}" onclick="batchUpdateTeacher()" class="btn btn-outline btn-primary"/>
									</span>
								</div>
							</div>
						</div>
					</div>
				</form>
			</div>
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
		 *	批量修改教师排休
		 *
		 */
	function batchUpdateTeacher() {
		var ids = $('#ids').val(); 
		var message = "${_res.get('selectCorrectTime')}";
		if(addMonTime(message)){
			var timeMsg = $("#tuesdaydata").text();
					$.layer({
					shade : [ 0 ], //不显示遮罩
					area : [ 'auto', 'auto' ],
					dialog : {
						msg : "${_res.get('updateConfirm')}",
						btns : 2,
						type : 4,
						btn : [ "${_res.get('admin.common.determine')}",
								"${_res.get('Cancel')}" ],
						yes : function() {
						$.ajax({
							url : "${cxt}/courseplan/batchUpdateTeacherRest",
							dataType :  "json",
							type : 			"post",
							 data : {
								"ids" : ids,
								"timeMsg" : timeMsg
							},
							success : function(data) {
								if (data.code == 0) {
									parent.layer.msg(data.result, 2, 1);
									parent.search();
								}else if (data.code == 1) {
									var sysMessage ="${_res.get('layer.message')}";
									var 	errorMessage = sysMessage.replace("{1}", data.teacher.REAL_NAME).replace("{2}",data.time).replace("00:00:00",'');
									alert(errorMessage);
									parent.search();
								}else if (data.code == "2") {
									parent.layer.msg("${_res.get('server_error')}", 2, 5);
								}
							}
						});
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
			disable_search_threshold : 10
		});
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : false
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 10
			},
			'.chosen-select-no-results' : {
				no_results_text : 'Oops, nothing found!'
			},
			'.chosen-select-width' : {
				width : "50%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
	</script>
</body>
</html>