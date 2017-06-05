<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	<div class="ibox-content" style="width: 100%; height: 380px;">
		<div id="wrapper" style="background: #2f4050;">
			<div class="gray-bg dashbard-1" id="page-wrapper" style="padding-left: 0; padding-right: 0; min-height: auto">
				<form action="" method="post" id="/courseplan/UpdateTeachers" name="form1">
					<input type="hidden" value="${id}" id="id">
					<!--ID列表  -->
					<div id="update" style="disabled: disabled;">
						<div class="col-lg-12" style="padding-left: 0; padding-right: 0">
							<div class="ibox float-e-margins" style="margin-bottom: 0">
								<div class="ibox-content">
									<label>${_res.get('course.class.date')}:</label> 
									<input type="text" class="form-control layer-date" readonly="readonly" id="dateTime" 
									value='<fmt:formatDate value="${coursePlan.COURSE_TIME }" type="time" timeStyle="full" pattern="yyyy-MM-dd"/>' 
									name="_query.courseTime" style="margin-top: 1px; width: 200px; background-color: #fff;" />
								</div>
								<div class="ibox-content">
									<span class="m-r-sm text-muted welcome-message"> 
									<label>${_res.get('Please.select')}：</label>&nbsp;${_res.get('All.day.long')} 
									<input type="radio" id="all_tues1" name="all_tues" value="1" onclick="checkdaymon(this.value)">${_res.get('admin.common.yes')} 
									<input type="radio" id="all_tues2" name="all_tues" value="0" checked="checked" onclick="checkdaymon(this.value)" />${_res.get('admin.common.no')} 
									<span id="tues_time" style="padding-left: 50px;"><br> <br>休息开始时间： 
										<select id="tuesstarthour" name="tuesstarthour" class="chosen-select" style="width: 80px;">
											<c:forEach items="${hourlist}" var="starthourlist">
												<option value="${starthourlist.key }">${starthourlist.value }</option>
											</c:forEach>
										</select>&nbsp;:&nbsp; 
										<select id="tuesstartmin" name="tuesstartmin" class="chosen-select" style="width: 80px;">
											<option value="00">00</option>
											<option value="30">30</option>
										</select>&nbsp;<br>休息结束时间： 
										<select id="tuesendhour" name="tuesendhour" class="chosen-select" style="width: 80px;">
											<c:forEach items="${hourlist}" var="endhourlist">
												<option value="${endhourlist.key }">${endhourlist.value }</option>
											</c:forEach>
										</select>&nbsp;:&nbsp; <select id="tuesendmin" name="tuesendmin" class="chosen-select" style="width: 80px;">
											<option value="00">00</option>
											<option value="30">30</option>
										</select>
										<span id="tuesdaydata" style="display: none;"></span> </span>
									</span>
								</div>
								<hr>
						<div style="float:left">
							<input id="btn" type="button" value = "确认" style="width:40px;height:30px;" onclick="saveTimeRank()">
						</div>
						<div style="float:right">
							<input id="closeBtn" type="button" value = "关闭" style="width:40px;height:30px; " onclick="closeBox()">
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
		//关闭框 此处采用刷新并不好
		function closeBox(){
			 parent.$("#status").val("1");
		 	 var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
             parent.layer.close(index); 
			// parent.location.reload();
		}
	</script>
	<script type="text/javascript">
		//修改教师休息单条记录
		function saveTimeRank() {
			var ids = $('#id').val();
			var message = "${_res.get('selectCorrectTime')}";
			if (addMonTime(message)) {
				var timeMsg = $("#tuesdaydata").text();
				$.layer({
							shade : [ 0 ], //不显示遮罩
							area : [ 'auto', 'auto' ],
							dialog : {
								msg : "${_res.get('updateConfirm')}",
								btns : 2,
								type : 4,
								btn : [
										"${_res.get('admin.common.determine')}",
										"${_res.get('Cancel')}" ],
								yes : function() {
									$.ajax({
												url : "${cxt}/courseplan/batchUpdateTeacherRest",
												dataType : "json",
												type : "post",
												data : {
													"ids" : ids,
													"timeMsg" : timeMsg
												},
												success : function(data) {//成功
													if (data.code == 0) {
														parent.$("#status").val("0");
														var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
														parent.layer.close(index);
														layer.msg("更新成功",2,1);
													} else if (data.code == 1) {//失败
														parent.$("#status").val("1");
														var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
														var sysMessage = "${_res.get('layer.message')}";
														var errorMessage = sysMessage
																.replace("{1}",data.teacher.REAL_NAME)
																.replace("{2}",data.time)
																.replace("00:00:00",'');
														alert(errorMessage);
														parent.layer.close(index);
													} else if (data.code == "2") {//异常
														parent.$("#status").val("1");
														var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
														parent.layer.close(index);
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
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#dateTime',
			format : 'YYYY-MM-DD',
			min : '1970-01-01',
			//max : laydate.now(), //最大日期
			istime : false,
			istoday : false,
		/* 		choose : function(datas) {
					dianBegintime(datas);
				} */
		};
		var date2 = {
			elem : '#date2',
			format : 'YYYY-MM-DD',
			min : '1970-01-01',
			//max : laydate.now(), //最大日期
			istime : false,
			istoday : false,
		/* 	choose : function(datas) {
				dianBegintime(datas);
			} */
		};
		laydate(date1);
		laydate(date2);
	</script>
</body>
</html>