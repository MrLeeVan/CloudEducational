<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('courses_record')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
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
<link rel="shortcut icon" href="/images/ico/favicon.ico" />

<style type="text/css">
body {
	background-color: #eff2f4;
}
</style>
<style type="text/css">
.stu_name {
	position: relative;
	margin-bottom: 15px;
}

.stu_name label {
	display: inline-block;
	font-size: 12px;
	vertical-align: middle;
	width: 100px;
}

.student_list_wrap {
	position: absolute;
	top: 28px;
	left: 14.8em;
	width: 100px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
}

label {
	width: 70px;
}

.tds {
	text-align: left;
}

.chosen-results {
	max-height: 80px !important
}
</style>
</head>
<body>
	<div id="wrapper" style="overflow-y: scoll; text-align: center; height: 500px;">
		<div class="ibox-content">
			<div class="ibox float-e-margins">
				<c:choose>
					<c:when test="${has eq 'yes' }">
						<div class="ibox-content">
							<table class="table table-hover table-bordered">
								<thead>
									<tr>
										<th>${_res.get("index") }</th>
										<th>${_res.get("courselib.trainee") }/${_res.get("course.classes") }</th>
										<th>${_res.get("teacher") }</th>
										<th>${_res.get("courselib.location") }</th>
										<th>${_res.get('course.course')}</th>
										<th>${_res.get('type')}</th>
										<th>${_res.get("course.class.date") }</th>
										<th>${_res.get("system.time") }</th>
										<th>${_res.get('session')}</th>
									</tr>
								</thead>
								<c:forEach items="${list }" var="list" varStatus="index">
									<tr>
										<td>${index.count }</td>
										<td>${list.stuname }</td>
										<td>${list.teaname }</td>
										<td>${list.campus_name }-${list.roomname }</td>
										<td>${list.course_name }</td>
										<td><c:if test="${list.netCourse == '1' }">${_res.get('course.netcourse')}</c:if> <c:if test="${list.netCourse == '0' }">${_res.get('course.course')}</c:if></td>
										<td><fmt:formatDate value="${list.course_time}" type="time" timeStyle="full" pattern="yyyy-MM-dd" /> (${list.weekname })</td>
										<td>${list.rank_name }</td>
										<td id="sumhours_${index.count}">${list.class_hour }</td>
									</tr>
								</c:forEach>
								<tr>
									<td colspan="4">${_res.get("total")}：</td>
									<td colspan="3">${list.size()}${_res.get("classes")}</td>
									<td id="sum" colspan="2"></td>
								</tr>
							</table>
							<input type="hidden" id="size" value="${list.size()}">
						</div>

					</c:when>
					<c:otherwise>
						<div>${_res.get('No.Timetable.record')}</div>
					</c:otherwise>
				</c:choose>
			</div>
			<div style="clear: both"></div>
		</div>
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layer javascript -->
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
	</script>

	<script type="text/javascript">
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		function submitRuleForm() {
			parent.window.location.reload();
			setTimeout("parent.layer.close(index)", 3000);
		}
		function sumHour() {
			var size = $("#size").val();
			var array = new Array(size);
			for (var i = 1; i <= size; i++) {
				array[i - 1] = i;
			}
			var sum = parseFloat(0.0);
			for (var i = 0; i < array.length; i++) {
				sum += parseFloat($("#sumhours_" + (i + 1)).text());
			}
			$("#sum").text(sum.toFixed(1) + '${_res.get("session")}');
		}

		$(document).ready(sumHour());
		//$(document).ready(sumHour());
	</script>


	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script>
		$('li[ID=nav-nav4]').removeAttr('').attr('class', 'active');
	</script>
</body>
</html>