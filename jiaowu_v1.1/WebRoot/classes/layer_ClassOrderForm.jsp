<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>添加班次</title>
<style>
p {
	width: 350px;
	height: 30px;
	margin-right: 10px;
	float: left;
}

label {
	width: 120px;
	display: block;
	float: left;
	line-height: 30px
}

input[type="text"] {
	width: 199px
}

input[type="radio"] {
	margin-top: 8px
}

select {
	width: 199px;
}
</style>
</head>
<body>
	<div class="ibox float-e-margins" style="margin-bottom: 0">
		<div class="ibox-content">
			<form action="" method="post" id="addClassOrder">
				<input type="hidden" id="classOrderId" name="classOrder.id" value="${classOrder.id }"> 
				<input type="hidden" id="addorder" name="addorder" value="${addorder }"> 
				<input type="hidden" id="editname" name="editname" value="${editname }"> 
				<input type="hidden" id="orderid" name="orderid" value="${orderid }">
				<fieldset>
					<p>
						<label>${_res.get("class.location")}:</label> 
						<select id="campusId" onchange="getKcgw()" name="classOrder.campusId" class="chosen-select">
							<option value="0">${_res.get('Please.select')}</option>
							<c:forEach items="${campusList}" var="campus">
								<option value="${campus.ID }" <c:if test="${campus.id eq classOrder.campusId }">selected="selected"</c:if>>${campus.CAMPUS_NAME }</option>
							</c:forEach>
						</select>
					</p>
					<p>
						<label>${_res.get('course.consultant')}:</label> 
						<select id="pcid" name="classOrder.pcid" class="chosen-select">
							<option value="">${_res.get('Please.select')}</option>
							<c:forEach items="${kcgwList}" var="cc">
								<option value="${cc.ID }" <c:if test="${cc.id eq classOrder.pcid }">selected="selected"</c:if>>${cc.real_name }</option>
							</c:forEach>
						</select>
					</p>
					<p>
						<label>${_res.get('class.number')}:</label>
						<input type="text" id="classNum" name="classOrder.classNum" value="${classNum }" onblur="checkClassNameUsed()" />
					</p>
					<div style="clear: both;"></div>
					<p>
						<label>${_res.get('chargeType')}</label> 
						<input id="chargeType" type="radio" name="classOrder.chargeType" onclick="chooseChargeType()" value="1" ${empty classOrder.chargeType?"checked='checked'":(classOrder.chargeType==1?"checked='checked' disabled='disabled'":"disabled='disabled'") } />
						${_res.get('onTime')}
						<input id="chargeType" type="radio" name="classOrder.chargeType" onclick="chooseChargeType()" value="0" ${empty classOrder.chargeType?"":(classOrder.chargeType==0 ? "checked='checked' disabled='disabled'":"disabled='disabled'")}/> 
						${_res.get('byTeachingHours')}
					</p>
					<div style="clear: both;"></div>
					<p>
						<label>${_res.get('class.class.type')}:</label>
						<select id="classtype_id" name="classOrder.classtype_id" class="chosen-select" tabindex="2" 
							${empty classOrder.id ? "":"disabled='disabled'" }>
							<option value="0">${_res.get('Please.select')}</option>
							<c:forEach items="${classTypeList}" var="classType">
								<option value="${classType.id }" <c:if test="${classType.id eq class_type }">selected="selected"</c:if>>${classType.name }</option>
							</c:forEach>
						</select>
					</p>
					<div style="clear: both;"></div>
					<p id="showcourse" style="width:auto; height: auto;">
						<c:if test="${!empty banciCourseList }">
							<c:forEach items="${banciCourseList}" var="banciCourse">
								<label></label>
								<input type="checkbox" id="classtype${banciCourse.course_id }" ${banciCourse.coursePlanCount==0?"":"disabled='disabled'"} checked='checked'
								name="course_id" onclick="check(${banciCourse.course_id })" value="${banciCourse.course_id}">${banciCourse.COURSE_NAME }
								<input type="text" style="width: 50px" id="keshi${banciCourse.course_id }" name="keshi" onclick="clearVal(${banciCourse.course_id })" onblur="checkblur(${banciCourse.course_id })" value="${banciCourse.lesson_num }" size="5">
								<c:choose> 
									<c:when test="${classOrder.chargeType == 0}">   
									  ${_res.get("RMB")}/${_res.get("session")}
									</c:when> 
									<c:otherwise>   
									   ${_res.get("session")}
									</c:otherwise> 
								</c:choose>
								<span>${_res.get("scheduled.classes")}${banciCourse.coursePlanCount}${_res.get("session")}</span><br/>
							</c:forEach>
						</c:if>
					</p>
					<div style="clear: both;"></div>
					<p id="classHour" ${classOrder.chargeType==0?'style="display: none;"':'' } >
						<label>${_res.get('Total.hours')}:</label> 
						<input type="text" id="lessonNum" name="classOrder.lessonNum" readonly="readonly" value="${classOrder.lessonNum }">
					</p>
					<div style="clear: both;"></div>
					<p id="students" ${classOrder.chargeType==0?'style="width:auto; height: auto;display: none;"':'style="width:auto; height: auto;"' }>
						<label>${_res.get("class.number.of.students")}:</label> 
						<input type="text" id="stuNum" name="classOrder.stuNum" value="${stuNum }"><span id="stuNumMsg"></span>
					</p>
					<div style="clear: both;"></div>
					<p id="classFee" ${classOrder.chargeType==0?'style="display: none;"':'' }>
						<label>${_res.get('Course.fee.ban')}:</label> 
						<input type="text" id="totalfee" name="classOrder.totalfee" value="${totalfee }">${_res.get('RMB')}/人
					</p>
					<div style="clear: both;"></div>
					<p>
						<label>${_res.get('Evaluate.whether')}:</label> 
						<input type="radio" value="1" name="classOrder.is_assesment" id="is_assesment" ${isassesment==null?"checked='checked'":isassesment==1?"checked='checked'":""}>${_res.get('admin.common.yes')}
						<input type="radio" value="0" name="classOrder.is_assesment" id="is_assesment" ${isassesment==null?"":isassesment==0?"checked='checked'":""}>${_res.get('admin.common.no')}
						<font style="color: red">*${_res.get('Students.evaluate.teachers')}</font>
					</p>
					<div style="clear: both;"></div>
					<p>
					<c:if test="${operator_session.qx_classtypedoAddClassOrder }">
							<input type="button" value="${_res.get('save')}" class="btn btn-outline btn-primary" onclick="return addClassOrder()" />
					</c:if>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 15
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

	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script src="/js/utils.js"></script>

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script type="text/javascript">
		var flag = true;

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
							if (data.code != 1) {
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
						"classOrderId" : $('#classOrderId').val(),
						"course_id" : course_id
					},
					type : "post",
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.plancount != null) {
							if (data.plancount > $('#keshi' + course_id).val()) {
								$('#keshi' + course_id).val(data.plancount);
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
					return false;
				}
			}
			checkUsedCourse();
			if (flag) {
				if (checkbox()) {
					var chargeType = $('input[id="chargeType"]:checked').val();
					if ($("#classtype_id").val() == 0 ) {
						layer.msg("请选择班型", 1, 2);
						return false;
					} 
					if ($("#stuNum").val() == "" || $('#teachTime').val() == "" || $('#lessonNum').val() == "" || $('#is_assesment').val() == "") {
						$("#stuNum").val(0);
					} 
					if ($('#lessonNum').val() == "") {
						$("#lessonNum").val(0);
					} 
					$("input[type='checkbox']").attr('disabled', false);
					var totalfee = $("#totalfee").val();
					if (totalfee.match(/^([1-9]\d*|[0]{1,1})$/) == null && chargeType==1) {
						$("#totalfee").val("");
						layer.msg("请输入正确的费用", 1, 2);
					} else {
						if (checkClassNameUsed()) {
							if(confirm("确定要提交保存？")){
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
						var chargeType = $('input[id="chargeType"]:checked').val();
						$.ajax({
							url : "/classtype/getCourseListByClassType",
							data : {
								"type_id" : $('#classtype_id').val()
							},
							type : "post",
							dataType : "json",
							success : function(result) {
								$('#showcourse').empty();
								$('#showcourse').show();
								for (var i = 0; i < result.record.length; i++) {
									var courseName = result.record[i].COURSE_NAME;
									var courseId = result.record[i].COURSE_ID;
									var id = result.record[i].ID;
									var lessonNum = result.record[i].LESSON_NUM;
									var lessonCount = result.record[i].LESSON_COUNT;
									var str = "<label></label><input type='checkbox' id='classtype" + courseId + "' name='course_id' checked='checked' onclick='check(" + courseId + ")' value='" + courseId + "'>" + courseName
											+ "<input type='text' style='width: 50px' id='keshi" 
											+ courseId 
											+ "' name='keshi' onclick='clearVal(" + courseId + ")' onblur='checkblur(" + courseId + ")' value='0' size='5'>";
									if(chargeType == 0){//按课时收费
										str +="${_res.get('RMB')}/${_res.get('session')}<br/>";
									}else{
										str +="${_res.get('session')}<br/>";
									}
									$("#showcourse").append(str);
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
			var campusId = $("#campusId").val();
			$("#pcid").html("");
			$.ajax({
				url : '/classtype/getKcgwBySchoolid',
				type : 'post',
				data : {
					'scid' : campusId
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
					$("#pcid").trigger("chosen:updated");
				}
			})
		}
		
		function chooseChargeType(){
			var chargeType = $('input[id="chargeType"]:checked').val();
			if(chargeType==0){//按课时
				$("#classtype_id").val(0);
				$('#stuNum').val('');
				$('#lessonNum').val('');
				$('#totalfee').val('');
				$('#students').hide();
				$('#classHour').hide();
				$('#classFee').hide();
				$("#showcourse").append('');
				$("#showcourse").hide();
			}else{//按期
				$("#classtype_id").val(0);
				$('#stuNum').val('');
				$('#lessonNum').val('');
				$('#totalfee').val('');
				$('#students').show();
				$('#classHour').show();
				$('#classFee').show();
				$("#showcourse").append('');
				$("#showcourse").hide();
			}
			$("#classtype_id").trigger("chosen:updated");
		}
	</script>
	<script>
		$('li[ID=nav-nav6]').removeAttr('').attr('class', 'active');
		//弹出后子页面大小会自动适应
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
	</script>
</body>
</html>