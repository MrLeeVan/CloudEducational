<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<title>${_res.get('class_type_management')}</title>
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
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
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
	$().ready(function() {
		if ('${id}' != null) {
			$.ajax({
				url : '/classtype/editClassTypeForJson2',
				type : 'post',
				data : {
					type_id : '${id}'
				},
				dataType : 'json',
				success : function(data) {
					if (data.record.length > 0) {
						for (var i = 0; i < data.record.length; i++) {
							var subject_id = data.record[i].SUBJECT_ID;
							if ($('#subject' + subject_id).val() == subject_id) {
								$('#subject' + subject_id).attr("checked", "checked");
								check(subject_id);
							}
						}
					}
				}
			});
		}
	});

	$(function() {
		$('#name').keyup(function() {
			var input = /^[\u4e00-\u9fa5]{0,}$/;
			if (input.test($('#name').val())) {
				$.ajax({
					'url' : '/classtype/getClassNameByLike',
					'type' : 'post',
					'data' : 'name=' + $('#name').val(),
					'dataType' : 'json',
					'success' : function(data) {
						var str = "";
						for (var i = 0; i < data.className.length; i++) {
							str += "<li>" + data.className[i].NAME + "</li>";
						}
						$("#stuList").html(str);
					}
				});
			}
		});
		$('#name').blur(function() {
			if ($('#name').val().length > 0) {
				$.ajax({
					'url' : '/classtype/getClassName',
					'type' : 'post',
					'data' : 'name=' + $('#name').val(),
					'dataType' : 'json',
					'success' : function(data) {
						if (data.className.length > 0) {
							$('#classTypeMsg').html('班型名称已存在，重新保存将更新班型。');
							//							$('#name').focus();
						} else if ($("#name").val() == 0) {
							$('#classTypeMsg').html('班型名称不能为空。');
						} else {
							$('#classTypeMsg').html('班型名称可以使用。');
						}
					}
				});
			}
		});
	});

	function getCourseListBySubjectId(subjectId) {
		if (subjectId != 0) {
			$.ajax({
				url : "/account/getCourseListBySubjectId",
				data : {
					"SUBJECT_ID" : subjectId
				},
				type : "post",
				dataType : "json",
				success : function(result) {
					$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
					for (var i = 0; i < result.courses.length; i++) {
						var courseName = result.courses[i].COURSE_NAME;
						var courseId = result.courses[i].ID;
						var str = "<option value='"+courseId+"'>" + courseName + "</option>";
						$("#classtype").append(str);
					}
				}
			});
		} else {
			$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
		}
	}

	function check(sub_id) {
		var str = document.getElementsByName("subject_id");
		var objarray = str.length;
		var chestr = "";
		for (var i = 0; i < objarray; i++) {
			if (str[i].checked == true) {
				chestr += str[i].value + ",";
			}
		}
		if (chestr != "") {
			$.ajax({
				url : "/account/getCourseListBySubjectId",
				data : {
					"SUBJECT_ID" : chestr
				},
				type : "post",
				dataType : "json",
				success : function(result) {
					$('#classtype').empty();
					$('#showcourse').show();
					for (var i = 0; i < result.courses.length; i++) {
						var courseName = result.courses[i].COURSE_NAME;
						var courseId = result.courses[i].ID;
						var subject_name = result.courses[i].SUBJECT_NAME;
						var sub_name = "";
						var str = sub_name + "<div><input type='checkbox' id='classtype"+courseId+"' name='course_id' value='"+courseId+"'>&nbsp;" + courseName + "</div>";
						$("#classtype").append(str);
					}
				},
				complete : function(result) {
					$.ajax({
						url : "/classtype/editClassTypeForJson",
						data : {
							"id" : $('#id').val()
						},
						type : "post",
						dataType : "json",
						success : function(result) {
							if (result.courseJson != null) {
								for (var i = 0; i < result.courseJson.length; i++) {
									var course_id = result.courseJson[i].COURSE_ID;
									var box = $("#classtype" + course_id);
									if (box.val() == course_id) {
										box.attr("checked", "checked");
									}
								}
							}
						}
					});
				}
			});
		} else {
			$('#classtype').empty();
		}
	}

	function chongzhi() {
		$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
	}

	function checkbox() {
		var str = document.getElementsByName("course_id");
		var objarray = str.length;
		var chestr = "";
		for (var i = 0; i < objarray; i++) {
			if (str[i].checked == true) {
				chestr += str[i].value + ",";
			}
		}
		if (chestr == "") {
			alert("请选择课程！");
			return false;
		} else {
			return true;
		}
	}

	function addClassType() {
		if (checkbox()) {
			if ($("#name").val() == 0) {
				alert("请把信息填写完整");
				return false;
			} else {
				var str = document.getElementsByName("subject_id");
				var objarray = str.length;
				var chestr = "";
				for (var i = 0; i < objarray; i++) {
					if (str[i].checked == true) {
						chestr += "," + str[i].value;
					}
				}
				$("#subids").val(chestr);
				$.ajax({
					type : "post",
					url : "${cxt}/classtype/doAddClassType",
					data : $('#addClassType').serialize(),
					dataType : "json",
					success : function(date) {
						if (date.code == '1') {
							layer.msg(date.msg, 2, 9);
							setTimeout("parent.layer.close(index)", 3000);
							parent.window.location.reload();
						} else {
							layer.msg(date.msg, 2, 8);
						}
					}
				});
			}
		}
	}
</script>

</head>
<body style="background: #fff">
	<div class="ibox-content" style="height: 266px">
		<form action="" method="post" id="addClassType" name="form1">
			<input type="hidden" name="subids" id="subids"> <input type="hidden" name="id" id="id" value="${id }"> <input type="hidden" name="type" id="type" value="${type }">
			<fieldset>
				<div class="stu_name">
					<label>${_res.get("class.name.of.class.type")}:</label> <input type="text" id="name" name="name" value="${name }" /><span id="classTypeMsg"></span>&nbsp;&nbsp;&nbsp;&nbsp;
					<div id="mohulist" class="student_list_wrap" style="display: none">
						<ul style="margin-bottom: 10px;" id="stuList"></ul>
					</div>
					<label>${_res.get("District")}:</label>
					<select id="campusSelect" name="classTypeCampus" class="chosen-select" style="display:inline;" >
						<option value="">公用</option>
						<c:forEach items="${campusList}" var="campus">
							<option value="${campus.id}" <c:if test="${campus.id==campusid}">selected="selected"</c:if>>${campus.campus_name}</option>
						</c:forEach>
					</select>
				</div>
				<input type="hidden" id="lesson_count" name="lesson_count" value="0">
				<p>
					<label>${_res.get('course.subject')}:</label>
				</p>
				<div class="subject_name">
					<c:forEach items="${subject}" var="subject" varStatus="s">
						<div style="float: left; margin-right: 10px">
							<input type="checkbox" id="subject${subject.id }" name="subject_id" value="${subject.id }" onclick="check(this.value)" />&nbsp;${subject.subject_name }
						</div>
					</c:forEach>
					<div style="clear: both;"></div>
				</div>
				<p id="showcourse">
					<label> ${_res.get('course.course')}: </label>
				</p>
				<div class="class_type">
					<span id="classtype"> </span>
					<div style="clear: both;"></div>
				</div>
				<p>
					<c:if test="${operator_session.qx_classtypedoAddClassType }">
						<input type="button" class="btn btn-outline btn-primary" value="${_res.get('save')}" onclick=" addClassType();" /> 
					</c:if>
					<input type="reset" class="button btn btn-outline btn-success" id="cz" onclick="chongzhi()" value="${_res.get('Reset')}" />
					<span id="returnMsg"> ${returnMsg }</span>
				</p>
			</fieldset>
		</form>
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
		$('li[ID=nav-nav6]').removeAttr('').attr('class', 'active');
		//弹出后子页面大小会自动适应
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
	</script>
</body>
</html>