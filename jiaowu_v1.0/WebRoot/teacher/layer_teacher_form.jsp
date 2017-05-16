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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/css/css/plugins/simditor/simditor.css" />

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>添加教师</title>
<style>
label {
	width: 120px;
}

.select-course {
	float: left;
	margin-right: 15px
}

p {
	margin: 0 0 8px !important
}

.chosen-container-multi, .search-field input {
	width: 440px !important
}
</style>
</head>
<body>
	<div class="ibox float-e-margins" style="margin-bottom: 0">
		<div class="ibox-content" style="padding-bottom: 0">
			<form action="" method="post" id="teacherForm">
				<input type="hidden" name="teacher.id" id="teacherId" value="${teacher.id}" /> <input type="hidden" name="examIndex" id="examIndex" value="${examScores!=null?examScores.size():0}" />
				<c:if test="${!empty teacher.id }">
					<input type="hidden" name="teacher.version" value="${teacher.version + 1}">
				</c:if>
				<fieldset>
					<p>
						<label> ${_res.get("sysname")}： </label> 
						<input type="text" name="teacher.real_name" id="real_name" value="${teacher.real_name}" maxlength="20" class="required" maxlength="15" vMin="2" vType="checkTestName" onblur="onblurVali(this);" onchange="checkExist('real_name')" /> 
						<font color="red"> * <span id="real_nameMes"> </span></font>
					</p>
					<p>
						<label> ${_res.get("admin.user.property.email")}：</label> <input type="text" name="teacher.email" value="${teacher.email}" id="email" maxlength="100" vMin="6" vType="email" onblur="onblurVali(this);" onchange="checkExist('email')" />
						<font color="red">*<span id="emailMes"></span></font>
					</p>
					<p>
						<label>${_res.get("admin.user.property.qq")}：</label> <input id="qq" type="text" name="teacher.qq" value="${teacher.qq}" maxlength="15" vMin="0" vType="qq" onblur="onblurVali(this);" />
					</p>
					<p><label> ${_res.get('WeChat')}： </label> <input type="text" name="teacher.WeChat" value="${teacher.WeChat}" /></p>
					<p><label> Skype： </label> <input type="text" name="teacher.Skype" value="${teacher.Skype}" /></p>
					<p>
						<label> ${_res.get('job.category')}： </label>
						<input type="radio" name="teacher.tworktype" value="1" checked="checked" />${_res.get("Full-time")}&nbsp;&nbsp; 
						<input type="radio" name="teacher.tworktype" value="0" ${teacher.tworktype=='0'?'checked="checked"':''}>${_res.get("Part-time.job")}
					</p>
					<p>
						<label>是否是助教： </label>
						<input type="radio" name="teacher.isAssistantTeacher" value="0" checked="checked" />老师&nbsp;&nbsp;
						<input type="radio" name="teacher.isAssistantTeacher" value="1" ${teacher.isAssistantTeacher==1 ? 'checked="checked"':'' }>助教&nbsp;&nbsp;
						<input type="radio" name="teacher.isAssistantTeacher" value="2" ${teacher.isAssistantTeacher==2 ? 'checked="checked"':'' }>老师兼助教
					</p>
					<p>
						<label>${_res.get("If.a.foreign.teacher")}： </label>
						<input type="radio" name="teacher.isforeignteacher" checked="checked" value="0" />${_res.get("admin.common.no")} &nbsp;&nbsp;
						<input type="radio" name="teacher.isforeignteacher" ${teacher.isforeignteacher==1?'checked="checked"':''} value="1" />${_res.get("admin.common.yes")} 
					</p>
					<p>
						<label>是否接收短信： </label>
						<input id="receiveSmsTeacher" type="radio" name="teacher.receive_sms_teacher" value="1" checked='checked' />${_res.get('admin.common.yes')} &nbsp;&nbsp;
						<input id="receiveSmsTeacher" type="radio" name="teacher.receive_sms_teacher" value="0" ${teacher.receive_sms_teacher==0 ? "checked=checked'":"" } />${_res.get('admin.common.no')}
					</p>
					<p>
						<label> ${_res.get("admin.user.property.telephone")}： </label> <input name="teacher.tel" type="text" id="tel" value="${teacher.tel}" maxlength="15" vMin="0" vType="tel" onblur="onblurVali(this);" onchange="checkExist('tel')" />
					</p>
					<p>
						<label>${_res.get('District')}</label>
						<c:forEach items="${campus}" var="campus">
							<input type="checkbox" name="checkboxs" <c:if test="${fn:contains(campusids,campus.ids)}">checked="checked"</c:if> value="${campus.id}">${campus.campus_name}
						</c:forEach>
						<input type="hidden" id="campusids" name="campusids">
					</p>
					<p>
						<label> ${_res.get('gender')}： </label>
						<c:if test="${teacher.sex==0||teacher.sex==null}">
							<input type="radio" name="teacher.sex" value="1" />${_res.get('student.boy')}
										<input type="radio" name="teacher.sex" value="0" checked="checked" /> ${_res.get('student.girl')}
							        </c:if>
						<c:if test="${teacher.sex==1}">
							<td><input type="radio" name="teacher.sex" value="1" checked="checked" /> ${_res.get('student.boy')} <input type="radio" name="teacher.sex" value="0" /> ${_res.get('student.girl')}</td>
						</c:if>
						<font color="red"> * </font>
					</p>
					<c:if test="${empty teacher.id}">
						<%-- <p>
										<label>${_res.get('course.subject')}: </label>
										<div style="width:500px;margin:-35px 0 0 120px">
										<c:forEach items="${subjects}" var="subject" varStatus="s">
										  <div style="float:left;margin-right:15px">
											<input type="checkbox" id="subject${subject.id}" name="subject_id" value="${subject.id}" onclick="checkSubject()">
	                                         ${subject.subject_name }
										  </div>
										</c:forEach>
										<div style="clear: both;"></div>
										</div>
										<span id="subjectMes"></span>
									</p> --%>
						<p>
							<label>${_res.get('course.subject')}： </label> <select id="sub" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 440px;" tabindex="4" onchange="checkSubject()">
								<c:forEach items="${subjects}" var="subject">
									<option value="${subject.id}" class="options">${subject.subject_name}</option>
								</c:forEach>
							</select> <font color="red"> * </font> <input id="subjectids" name="teacher.subject_id" value="" type="hidden"> <br> <span id="subjectMes"></span>
						</p>
						<p id="showcourse" style="display: none">
							<label>${_res.get('course.course')}：</label> <select id="coursees" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 440px;" tabindex="4">

							</select> <input id="courseids" name="teacher.class_type" value="" type="hidden"> <span id="courseMes"></span>
						</p>
					</c:if>
					<p>
						<label> ${_res.get('Teaching.style')}： </label>
						<textarea rows="4" cols="85" name="teacher.style" style="width: 440px; overflow-x: hidden; overflow-y: scroll;">${fn:trim(teacher.style)}</textarea>
					</p>
					<p>
						<label> ${_res.get('Teaching.ability')}： </label>
						<textarea rows="4" cols="85" name="teacher.ability" style="width: 440px; overflow-x: hidden; overflow-y: scroll;">${fn:trim(teacher.ability)}</textarea>
					</p>
					<p>
						<label> ${_res.get("Brief.introduction")}： </label>
						<textarea rows="4" cols="85" name="teacher.intro" style="width: 440px; overflow-x: hidden; overflow-y: scroll;">${fn:trim(teacher.intro)}</textarea>
					</p>
					<div>
						<textarea id="remark" name="teacher.remark" placeholder="记录本">${teacher.remark }</textarea>
					</div>
					
					<c:if test="${operator_session.qx_teachersave || operator_session.qx_teachersave }">
						<p>
							<input type="button" value="${_res.get('save')}" onclick="return saveAccount();" class="btn btn-outline btn-primary" />
						</p>
					</c:if>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/utils.js"></script>
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

	<script type="text/javascript">
		/**登陆邮箱使用QQ邮箱*/
		function useQQEmail() {
			var qq = $('#qq').val();
			if (qq == '') {
				alert("请填写QQ号码");
			} else {
				$("#email").val(qq + "@qq.com");
				if (checkExist('email')) {
					$("#emailMes").text("Email不能为空和重复");
					$("#email").focus();
				}
			}
		}
		function checkExist(checkField) {
			var checkValue = $("#" + checkField).val();
			if (checkValue != "") {
				var flag = true;
				$.ajax({
					url : '${cxt}/teacher/checkExist',
					type : 'post',
					data : {
						'checkField' : checkField,
						'checkValue' : checkValue,
						'id' : $("#teacherId").val()
					},
					async : false,
					dataType : 'json',
					success : function(data) {
						if (data.result >= 1) {
							$("#" + checkField).focus();
							$("#" + checkField + "Mes").text("您填写的数据已存在。");
						} else {
							$("#" + checkField + "Mes").text("");
							flag = false;
						}
					}
				});
				return flag;
			} else {
				if(checkField=='qq'||checkField=='tel'){
		    		return false;
		    	}else{
					$("#" + checkField).focus();
					$("#" + checkField + "Mes").text("该字段不能为空。");
					return true;	
		    	}
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
		function checkSubject() {
			$("#showcourse").show();
			$("#sub").trigger("chosen:updated");
			var cou = getCourseids();
			$("#coursees").html('');
			$("#coursees").trigger("chosen:updated");
			var subjectids = "";
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

			$("#subjectids").val(subjectids.substr(1, subjectids.length));
			if (subjectids.substr(1, subjectids.length) == "") {
				$("#showcourse").hide();
			}
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

		function saveAccount() {
			$("#courseids").val(getCourseids().substr(1, getCourseids().length - 1));
			//var campusids=[];
			var campusid = "";
			$('input[name="checkboxs"]:checked').each(function() {
				//campusids.push($(this).val());
				campusid += "|" + $(this).val();
			});
			$("#campusids").val(campusid.substr(1, campusid.length - 1));
			if (checkExist('real_name')) {
				$("#nameMes").text("姓名不能为空和重复");
				$("#realName").focus();
				return false;
			} else {
				if (checkExist('tel')) {
					$("#telMes").text("电话号码不能为空和重复");
					$("#tel").focus();
				} else {
					if (checkExist('email')) {
						$("#emailMes").text("Email不能为空和重复");
						$("#email").focus();
					} else {
						var teacherId = $("#teacherId").val()
						if (teacherId == "") {
							if ($("#subjectids").val() == "") {
								/* $("#subjectMes").text("请选择要上的科目"); */
								layer.msg("请选择要上的科目", 1, 2);
								return false;
							} else if ($("#courseids").val() == "") {
								/* $("#coursetMes").text("请选择要上的课程"); */
								layer.msg("请选择要上的课程", 1, 2);
								return false;
							}
							$.ajax({
								type : "post",
								url : "${cxt}/teacher/save",
								data : $('#teacherForm').serialize(),
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
						} else {
							if (confirm("确定要修改该教师信息吗？")) {
								$.ajax({
									type : "post",
									url : "${cxt}/teacher/update",
									data : $('#teacherForm').serialize(),
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
					}
				}
			}
		}
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
	</script>
	<!-- simditor -->
    <script type="text/javascript" src="/js/js/plugins/simditor/module.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/uploader.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/hotkeys.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/simditor.js"></script>
    <script>
        $(document).ready(function () {
            var editor = new Simditor({
                textarea: $('#remark')
            });
        });
    </script>
	
	<script>
		$('li[ID=nav-nav2]').removeAttr('').attr('class', 'active');
	</script>
</body>
</html>
