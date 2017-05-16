<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<!-- Morris -->
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet" />
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<style>
.chosen-container .chosen-results {
	max-height: 100px
}
</style>
</head>
<body style="background-color: #EFF2F4">
	<div style="padding: 10px">
		<div class="ibox-content" style="max-height: 300px">
			<form action="" method="post" id="teacherForm">
				<input type="hidden" name="teacherId" id="teacherId" value="${teacher.id}" />
				<c:if test="${!empty teacher.id }">
					<input type="hidden" name="version" id='version' value="${teacher.version + 1}">
				</c:if>
				<fieldset>
					<p>
						<label>${_res.get('course.subject')}： </label>
						<select id="sub" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 600px;" tabindex="4" onchange="checkSubject(0)">
							<c:forEach items="${subjectList}" var="subject">
								<option value="${subject.id}" class="options">${subject.subject_name}</option>
							</c:forEach>
						</select>
						<input id="subjectids" name="teacher.subjectids" value="" type="hidden">
					</p>
					<br>
					<p>
						<label>${_res.get('course.course')}：</label> 
						<select id="coursees" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 600px;" tabindex="4">
						</select> 
						<input id="courseids" name="teacher.courseids" value="" type="hidden">
					</p>
					<c:if test="${operator_session.qx_teachersaveTeacherCourse }">
						<p style="margin-top: 20px">
							<a class="btn btn-outline btn-primary" onclick="saveAccountCourse()"> ${_res.get('save')} </a>
						</p>
					</c:if>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script src='/js/js/jquery-2.1.1.min.js'></script>
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script type="text/javascript">
		function checkSubject(ids) {
			$("#sub").trigger("chosen:updated");
			var cou = "";
			if (ids == 0) {
				cou = getCourseids();
			} else {
				cou = "${courseids}";
			}
			$("#coursees").html('');
			$("#coursees").trigger("chosen:updated");
			var subjectids = "";
			if (ids == 0) {
				var list = document.getElementsByClassName("search-choice");
				for (var i = 0; i < list.length; i++) {
					var name = list[i].children[0].innerHTML;
					var olist = document.getElementsByClassName("options");
					for (var j = 0; j < olist.length; j++) {
						var oname = olist[j].innerHTML;
						if (oname == name) {
							subjectids += "|" + olist[j].getAttribute('value');
							break;
						}
					}
				}
			} else {
				subjectids = "|" + ids;
			}
			$("#subjectids").val(subjectids.substr(1, subjectids.length));
			if (subjectids != "") {
				var cs = "";
				$.ajax({
					url : "/account/getCourseListBySubjectId",
					data : {
						"SUBJECT_ID" : subjectids.substr(1, subjectids.length)
					},
					type : "post",
					dataType : "json",
					success : function(result) {
						for (var i = 0; i < result.courses.length; i++) {
							var courseName = result.courses[i].COURSE_NAME;
							var courseId = result.courses[i].ID;
							var subjectId = result.courses[i].SUBJECT_ID;
							var subject_name = result.courses[i].SUBJECT_NAME;
							var sub_name = "";
							cs += '<option value="'+courseId+'"  class="optionsss"  >' + courseName + '</option>';
						}
						$("#coursees").append(cs);
						$("#coursees").trigger("chosen:updated");
						chose_mult_set_ini('#coursees', cou);
						$(".chosen-select").chosen();
					}
				});

			}
		}
		function saveAccountCourse() {
			$("#courseids").val(getCourseids().substr(1, getCourseids().length));
			var subjectids = $("#subjectids").val();
			var courseids = $("#courseids").val();
			var teacherId = $("#teacherId").val();
			var version = $("#version").val();
			if (subjectids != "") {
				if (courseids == "") {
					layer.msg("课程不能为空", 1, 2);
					return false;
				}
			}
			if (confirm("确定修改教师的课程信息吗？")) {
				/* $("#teacherForm").attr("action", "/teacher/saveTeacherCourse");
				$("#teacherForm").submit(); */
				$.ajax({
					type : "post",
					url : "${cxt}/teacher/saveTeacherCourse",
					data : {
						'tid' : teacherId,
						'subjectids' : subjectids,
						'courseids' : courseids,
						'version' : version
					},
					datatype : "json",
					success : function(data) {
						if (data.code == '0') {
							layer.msg(data.msg, 2, 5);
						} else {
							setTimeout("parent.layer.close(index)", 3000);
							parent.window.location.reload();
						}
					}
				});
			}
		}
		function getCourseids() {
			var courseids = '';
			var lists = document.getElementsByClassName("search-choice");
			for (var i = 0; i < lists.length; i++) {
				var name = lists[i].children[0].innerHTML;
				var olist = document.getElementsByClassName("optionsss");
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						courseids += "|" + olist[j].getAttribute('value');
						break;
					}
				}
			}
			return courseids;
		}
		/*数据回填*/
		var subjectids = '${subjectids}';
		var courseids = '${courseids}';
		//多选select 数据初始化
		function chose_mult_set_ini(select, values) {
			/* alert(select);
			alert(values); */
			var arr = values.split('|');
			var length = arr.length;
			var value = '';
			for (i = 0; i < length; i++) {
				value = arr[i];
				$(select + " [value='" + value + "']").attr('selected', 'selected');
			}
			$(select).trigger("chosen:updated");
		}

		$(document).ready(function() {
			chose_mult_set_ini('#sub', subjectids);
			$(".chosen-select").chosen();
		});
		$(document).ready(function() {
			checkSubject(subjectids);
			setTimeout(function() {
				chose_mult_set_ini('#coursees', courseids);
				$(".chosen-select").chosen();
			}, 200);
		});

		$(".chosen-select").chosen({
			disable_search_threshold : 20
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
	<!-- layer javascript -->
	<script>
		//弹出后子页面大小会自动适应
		// var index = parent.layer.getFrameIndex(window.name);
		// parent.layer.iframeAuto(index);
	</script>
</body>
</html>
