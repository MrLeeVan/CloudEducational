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
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('teacher.group.add')}&amp;${_res.get('Modify.the.class.lesson')}</title>

<style type="text/css">
label {
	width: 100px;
}

#course {
	width: 500px;
	display: block;
	float: left;
}

.subflot {
	float: left;
	width: 260px;
	margin: 0 0 10px 0;
}
</style>
</head>
<body style="background: #fff">
	<div class="ibox-content" style="padding: 30px; margin-top: 28px">
		<form action="" method="post" id="addClassOrder">
			<input type="hidden" id="addorder" name="addorder" value="${addorder }"> 
			<input type="hidden" id="editname" name="editname" value="${editname }"> 
			<input type="hidden" id="orderid" name="orderid" value="${orderid }">
			<fieldset>
				<p>
					<label>${_res.get('class.number')}:</label>
					<c:choose>
						<c:when test="${addorder==1 }">
							<input type="text" id="classNum" name="classNum" value="${classNum }" onblur="checkClassNameUsed()" />
						</c:when>
						<c:otherwise>
							<input type="text" id="classNum" name="classNum" value="${classNum }" onblur="checkClassNameUsed()" />
						</c:otherwise>
					</c:choose>
					<label>${_res.get('class.class.type')}:</label> 
					<select id="classtype_id" name="classtype_id" class="chosen-select" style="width: 150px;">
						<option value="0">${_res.get('Please.select')}</option>
						<c:forEach items="${getClassType}" var="ct">
							<option value="${ct.id }" <c:if test="${ct.id eq class_type }">selected="selected"</c:if>>${ct.name }</option>
						</c:forEach>
					</select>
				</p>
				<p id="showcourse">
					<label style="float: left">${_res.get("course.course")}：</label> <span id="course"></span>
				</p>
				<div style="clear: both;"></div>
				<p style="float: left">
					<label>${_res.get("admin.sysLog.property.enddate")}:</label> 
					<input type="text" name="endTime" id="endTime" readonly="readonly" onchange="return dateChange(this.value);" value="${endTime }" />
				</p>
				<p>
					<label>${_res.get('Total.hours')}:</label> 
					<input type="text" id="lessonNum" name="lessonNum" readonly="readonly" value="">
				</p>
				<p>
					<label>${_res.get("class.number.of.students")}:</label> 
					<input type="text" id="stuNum" name="stuNum" value="${stuNum }"><span id="stuNumMsg"></span>
				</p>
				<p style="float: left">
					<label>${_res.get("class.location")}:</label> 
					<select id="schoolid" onchange="getKcgw()" name="schoolid" class="chosen-select" style="width: 150px;">
						<c:forEach items="${school}" var="sc">
							<option value="${sc.ID }">${sc.CAMPUS_NAME }</option>
						</c:forEach>
					</select>
				</p>
				<p>
					<label>${_res.get('course.consultant')}:</label> 
					<select id="pcid" name="pcid" class="chosen-select" style="width: 199px;">
						<option value="">${_res.get('Please.select')}</option>
					</select>
				</p>
				<p>
					<label>${_res.get('Course.fee.ban')}:</label> 
					<input type="text" id="totalfee" name="totalfee" value="${totalfee }">${_res.get('RMB')}
				</p>
				<p>
					<label>${_res.get('Evaluate.whether')}:</label> 
					<input type="radio" value="1" name="is_assesment" id="is_assesment" ${isassesment==null?"checked='checked'":isassesment==1?"checked='checked'":""}>${_res.get('admin.common.yes')}&nbsp;&nbsp;&nbsp; 
					<input type="radio" value="0" name="is_assesment" id="is_assesment" ${isassesment==null?"":isassesment==0?"checked='checked'":""}>${_res.get('admin.common.no')}&nbsp;&nbsp;&nbsp; 
					<font style="color: red">*${_res.get('Students.evaluate.teachers')}</font>
				</p>
				<p>
					<c:if test="${operator_session.qx_classtypedoAddClassOrder }">
						<input type="button" value="${_res.get('save')}" class="btn btn-outline btn-primary" onclick="return addClassOrder()" />&nbsp;&nbsp;&nbsp;&nbsp; 
					</c:if>
					<input type="button" class="button btn btn-outline btn-success" id="cz" value="${_res.get('Reset')}" onclick="chongzhi()" /> 
					<span id="classOrderMsg"> ${classOrderMsg }</span>
				</p>
			</fieldset>
		</form>
	</div>
<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
<script type="text/javascript">
	var flag = true;
	$().ready(
			function() {
				if ($('#classtype_id').val() == 0) {
					$('#showcourse').hide();
				} else {
					$('#showcourse').show();
					if ($('#classtype_id').val() != 0) {
						$.ajax({
							url : "/classtype/getCourseListByClassType",
							data : {
								"type_id" : $('#classtype_id').val()
							},
							type : "post",
							dataType : "json",
							success : function(result) {
								$('#course').empty();
								$('#showcourse').show();
								if (result.record != null) {
									for (var i = 0; i < result.record.length; i++) {
										var type_id = result.record[0].TYPE_ID;
										var type_name = result.record[0].NAME;
										$('#classtype_id').html('');
										$('#classtype_id').html("<option value='"+type_id+"'>" + type_name + "</option>");
										var courseName = result.record[i].COURSE_NAME;
										var courseId = result.record[i].COURSE_ID;
										var id = result.record[i].ID;
										var lessonNum = result.record[i].LESSON_NUM;
										var lessonCount = result.record[i].LESSON_COUNT;
										// $('#lessonNumMsg').html(lessonCount);
										var sub_name = "";
										var str = sub_name + "<div class='subflot'><input type='checkbox' id='classtype" + courseId + "' name='course_id' onclick='check("
												+ courseId + ")' value='" + id + "'>" + courseName + "<input type='text' id='keshi" + courseId
												+ "' name='keshi' disabled='disabled' onclick='clearVal(" + courseId + ")' onblur='checkblur(" + courseId
												+ ")' value='' size='5'>${_res.get('session')} <span id='courseMsg"+courseId+"'></span>" + "</div>";
										$("#course").append(str);
									}
								}

								if ($('#classNum').val() != null && $('#classNum').val() != "") {
									//	根据班次id查询该班次已经排的课程
									$.ajax({
										url : "/classtype/getCourseListByClassType2",
										data : {
											"class_num" : $('#classNum').val()
										},
										type : "post",
										dataType : "json",
										success : function(result) {
											if (result.record != null) {
												var str = 0;
												for (var i = 0; i < result.record.length; i++) {
													var course_id = result.record[i].COURSE_ID;
													var lesson_num = result.record[i].LESSON_NUM;
													var box = document.getElementById("classtype" + course_id);
													var keshi = document.getElementById("keshi" + course_id);
													box.setAttribute("checked", "checked");
													keshi.removeAttribute("disabled", "disabled");
													keshi.value = parseInt(lesson_num);
													str += parseInt(keshi.value);
													showUsedCourse(course_id);
												}
												$('#lessonNum').val(str);
											}
										}
									});
								}
							}
						});
					}
					if ($('#classNum').val() != null && $('#classNum').val() != "") {
						$.ajax({
							url : "/classtype/stuCount",
							data : {
								"class_num" : $('#classNum').val()
							},
							type : "post",
							dataType : "text",
							success : function(data) {
								if (data != null) {
									$('#stuNumMsg').html(' 实际学生人数：' + data);
								}
							}
						});
					}
				}
			});

	function showUsedCourse(course_id) {
		$.ajax({
			url : "/classtype/verifyUsedCourse",
			data : {
				"class_num" : $('#classNum').val(),
				"course_id" : course_id
			},
			type : "post",
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.plancount != null) {
					if (data.plancount.used > 0) {
						$('#classtype' + course_id).attr("disabled", true);
					}
					$('#courseMsg' + course_id).html(' ${_res.get("scheduled.classes")} ' + data.plancount.used + ' ${_res.get("session")}');
				}
			}
		});
	}

	function checkClassNameUsed() {
		var flag = true;
		if ($("#classNum").val().length > 0) {
			if ($("#classNum").val() != $("#editname").val()) {
				$.ajax({
					async : false,
					url : "${cxt}/classtype/getClassOrderNameSure",
					data : "name=" + $("#classNum").val(),
					type : "post",
					dataType : "json",
					success : function(data) {
						if (data.code == 1) {
							layer.msg(data.msg, 1, 1);
						} else {
							layer.msg(data.msg, 1, 2);
							flag = false;
						}
					}
				});
			} else if ($("#classNum").val() == $("#editname").val()) {

			}
		} else {
			layer.msg("班次编号不能为空", 1, 2);
			flag = false;
		}
		return flag;
	}

	// 计算输入的课程的总节数填入到排课节数中
	function checkblur(course_id) {
		var hours = $('#keshi' + course_id).val();
		if (hours.indexOf(".") != -1) {
			alert("课时只能整数形式.");
			return false;
		} else {
			// 验证用户输入的课程是否小于已排课的课程
			$.ajax({
				url : "/classtype/verifyUsedCourse",
				data : {
					"class_num" : $('#classNum').val(),
					"course_id" : course_id
				},
				type : "post",
				dataType : "json",
				async : false,
				success : function(data) {
					if (data.plancount != null) {
						if (data.plancount.min > $('#keshi' + course_id).val()) {
							$('#keshi' + course_id).val(data.plancount.min);
							if (!$("#addorder").val() == 1) {
								alert("修改课程不能比已排课程少。");
							}
							flag = false;
							return false;
						} else {
							flag = true;
						}
					}
				}
			});
			var strVal = 0;
			$("*[name='keshi']").each(function() {
				var str = 0;
				if ($(this).val() == "" || $(this).val() == null) {
					if ($(this).attr('disabled') != 'disabled') {
						$(this).val('0');
					}
					str = 0;
				} else {
					str = $(this).val();
				}
				strVal += parseInt(str);
			});
			$('#lessonNum').val(parseInt(strVal));
		}
	}

	// 重置输入
	function chongzhi() {
		$('#stuNum').val('');
		$('#lessonNum').val('');
		$('#teachTime').val('');
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
	function checkUsedCourse() {
		// 保存时传入参数判断用户的输入
		$.ajax({
			url : "/classtype/getCourseListByClassType2",
			data : {
				"class_num" : $('#classNum').val()
			},
			type : "post",
			async : false,
			cache : false,
			dataType : "json",
			success : function(result) {
				if (result.record != null) {
					for (var i = 0; i < result.record.length; i++) {
						var course_id = result.record[i].COURSE_ID;
						checkblur(course_id);
					}
				}
			}
		});
	}
	function addClassOrder() {
		var addorder = '${addorder }'
		if (addorder == 1) {
			if (!checkClassNameUsed()) {
				//alert("建议更改班次编号.");
				return false;
			}
		}
		checkUsedCourse();
		if (flag) {
			if (checkbox()) {
				if ($("#classtype_id").val() == 0 || $("#stuNum").val() == "" || $('#teachTime').val() == "" || $('#lessonNum').val() == "" || $('#is_assesment').val() == "") {
					layer.msg("请把信息填写完整", 1, 2);
					return false;
				} else {
					$("input[type='checkbox']").attr('disabled', false);
					var totalfee = $("#totalfee").val();
					if (totalfee.match(/^([1-9]\d*|[0]{1,1})$/) == null) {
						$("#totalfee").val("");
						layer.msg("请输入正确的费用", 1, 2);
					} else {
						if (!checkClassNameUsed()) {
							//alert("建议更改班次编号.");
						} else {
							/* $("#addClassOrder").attr("action", "/classtype/doAddClassOrder");
							$("#addClassOrder").submit(); */
							$.ajax({
								type : "post",
								url : "${cxt}/classtype/doAddClassOrder",
								data : $('#addClassOrder').serialize(),
								datatype : "json",
								success : function(data) {
									if (data.code == '0') {
										alert(data.msg, 2, 5);
									} else {
										alert(data.msg);
										setTimeout("parent.layer.close(index)", 3000);
										parent.window.location.reload();
									}
								}
							});
						}
					}
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
		return false;
	}

	function dateChange(date) {
		if (date == 0) {
			return false;
		}
		var myDate = new Date();
		var riqi = myDate.getFullYear() + "-" + (myDate.getMonth().toString().length == 1 ? "0" + (myDate.getMonth() + 1) : (myDate.getMonth() + 1)) + "-"
				+ (myDate.getDate().toString().length == 1 ? "0" + myDate.getDate() : myDate.getDate());
		if (new Date(riqi) > (new Date(date))) {
			alert("请选择今天以后的日期 ");
			$('#teachTime').val('');
			return false;
		}
	}

	$(function() {
		$('#classtype_id').change(
				function() {
					$('#showcourse').show();
					$.ajax({
						url : "/classtype/getCourseListByClassType",
						data : {
							"type_id" : $('#classtype_id').val()
						},
						type : "post",
						dataType : "json",
						success : function(result) {
							$('#course').empty();
							$('#showcourse').show();
							for (var i = 0; i < result.record.length; i++) {
								var courseName = result.record[i].COURSE_NAME;
								var courseId = result.record[i].COURSE_ID;
								var id = result.record[i].ID;
								var lessonNum = result.record[i].LESSON_NUM;
								var lessonCount = result.record[i].LESSON_COUNT;
								// $('#lessonNumMsg').html(lessonCount);
								var sub_name = "";
								if (i == 0) {
									sub_name = "";
								}
								var str = sub_name + "<div style='float:left;width:500px;margin-bottom:10px'>" + "<input type='checkbox' id='classtype" + courseId
										+ "' name='course_id' checked='checked' onclick='check(" + courseId + ")' value='" + id + "'>" + courseName
										+ "<input type='text' id='keshi" + courseId + "' name='keshi' onclick='clearVal(" + courseId + ")' onblur='checkblur(" + courseId
										+ ")' value='0' size='5'>${_res.get('session')}" + "</div>";
								$("#course").append(str);
							}
						}
					});
					//	根据班次id查询该班次已经排的课程
					$.ajax({
						url : "/classtype/getCourseListByClassType2",
						data : {
							"class_num" : $('#classNum').val()
						},
						type : "post",
						dataType : "json",
						success : function(result) {
							if (result.record != null) {
								var str = 0;
								for (var i = 0; i < result.record.length; i++) {
									var course_id = result.record[i].COURSE_ID;
									var lesson_num = result.record[i].LESSON_NUM;
									var box = document.getElementById("classtype" + course_id);
									var keshi = document.getElementById("keshi" + course_id);
									box.setAttribute("checked", "checked");
									keshi.removeAttribute("disabled", "disabled");
									keshi.value = parseInt(lesson_num);
									str += parseInt(keshi.value);
								}
								$('#lessonNum').val(str);
							}
						}
					});
				});
	});

	function clearVal(str) {
		if ($('#keshi' + str).val() == 0) {
			$('#keshi' + str).val('');
		}
	}

	function check(str) {
		var box = document.getElementById("classtype" + str);
		var text = document.getElementById("keshi" + str);
		if (box.checked) {
			text.value = 0;
			text.disabled = false;
			text.readOnly = false;
		} else {
			text.value = "";
			text.readOnly = true;
			text.disabled = true;
		}
	}
	/*校区关联课程顾问*/
	function getKcgw() {
		var schoolid = $("#schoolid").val();
		$("#pcid").html("");
		$.ajax({
			url : '/classtype/getKcgwBySchoolid',
			type : 'post',
			data : {
				'scid' : schoolid
			},
			dataType : 'json',
			success : function(data) {
				var str = "<option value=''>${_res.get('Please.select')}</option>";
				if (data.length > 0) {
					for (var i = 0; i < data.length; i++) {
						if (data[i].ID == '${ban.PCID}') {
							str += '<option selected="selected" value="'+data[i].ID+'">' + data[i].REAL_NAME + '</option>'
						} else {
							str += '<option value="'+data[i].ID+'">' + data[i].REAL_NAME + '</option>'
						}

					}
				}
				$("#pcid").append(str);
			}
		})
	}
</script>
	
	<script>
		//日期范围限制
		var courseTime = {
			elem : '#endTime',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : true,
			choose : function(dates) { //选择好日期的回调
				dateChange(dates)
			}
		};
		laydate(courseTime);
	</script>

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		$(document).reday(getKcgw());
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
		$('li[ID=nav-nav6]').removeAttr('').attr('class', 'active');
		//弹出后子页面大小会自动适应
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
	</script>
</body>
</html>