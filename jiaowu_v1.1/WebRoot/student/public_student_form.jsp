<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="d" uri="/common/jfinal.tld" %>
<style>
p {
	height: 30px
}

label {
	width: 200px;
	display: block;
	float: left;
	line-height: 30px
}

.flyleft {
	float: left
}

.marfly {
	margin-left: 30px
}

.clerlt {
	clear: left;
}

input[type="text"] {
	width: 199px
}

input[type="radio"] {
	margin-top: 8px
}
</style>
<div class="ibox float-e-margins" style="margin-bottom: 0">
		<div class="ibox-content">
			<div style="height: 300px;">
				<p>
					<iframe id="ifstu" name="ifstu" width=100% height=200px;  frameborder=0 scrolling=no src="/student/head.jsp"> </iframe>
				</p>
			</div>
			<div style="margin-top: -300px;">
				<form action="" method="post" id="studentForm" enctype="multipart/form-data">
					<input type="hidden" name="student.id" id="studentId" value="${student.id}" />
					<c:if test="${!empty student.id }">
						<input type="hidden" name="student.version" value="${student.version + 1}">
					</c:if>
					<fieldset>
						<%-- <div>
							<p class="flyleft">
								<label> ${_res.get('Sales.opportunities')}: </label> <select name="student.opportunityid" id="opportunityid" class="chosen-select" style="width: 199px;" tabindex="2">
									<option value="">所属销售机会</option>
									<c:forEach items="${olist}" var="o">
										<option value="${o.id}" ${o.id==student.opportunityid?"selected='selected'":"" }>${o.contacter}-${o.phonenumber }</option>
									</c:forEach>
								</select>
							</p>
							<p class="flyleft marfly"></p>
							<div style="clear: both;"></div>
						</div> --%>
						<p >
							<label> ${_res.get("sysname")}： </label> <input type="text" name="student.real_name" id="real_name" value="${student.real_name}" maxlength="20" class="required" vMin="2" vType=checkTestName onblur="onblurVali(this);" onchange="checkExist('real_name')" /> <font color="red"> * </font><br>
						</p>
						<p >
							<label>英文名字： </label> <input type="text" name="student.EN_NAME" id="EN_NAME" value="${student.EN_NAME}" maxlength="20" class="required" />
						</p>
						<p class="flyleft"></p>
						
						<p class="">
							<label>${_res.get('admin.user.property.qq')}：</label>
							 <input id="qq" type="text" name="student.qq" value="${student.qq}" maxlength="15" vMin="0" vType="qq" onblur="onblurVali(this);" onchange="checkExist('qq')" />
						</p>
						
						<p class="">
							<label>学生学号：</label>
							 <input id="studentid" type="text" name="student.studentid" value="${student.studentid}" onblur="onblurVali(this);" />
						</p>
						
						<p style="padding-left:-20px">
							<label> Skype： </label> <input type="text" name="student.Skype" value="${student.Skype}" />
						</p>
						
						<p class="" style="width: 400px">
							<label> ${_res.get('gender')}： </label> 
							<input type="radio" name="student.sex" value="1" checked='checked' />${_res.get('student.boy')} &nbsp;&nbsp;
							<!-- 注意  数据库 int 类型的字段 长度 是 1 的话   这里取值 是 true和false  -->
							<input type="radio" name="student.sex" value="0" ${(student.id==null ? student.sex==0 : ( student.sex== 1  ? false : true ) ) ? "checked='checked'" : ""}/>${_res.get('student.girl')}
						</p>
						<p class="flyleft">
							<label> ${_res.get('admin.user.property.email')}：</label> <input type="text" name="student.email" value="${student.email}" id="email" maxlength="100" vMin="0" vType="email" onblur="onblurVali(this);" onchange="checkExistkong('email')" /> <font color="red"> <span id="emailMes"></span></font>
						</p>
						<p class="flyleft marfly">
							<label>企业名称： </label> <input type="text" name="student.enterprise" id="enterprise" value="${student.enterprise}" maxlength="40" class="required" /> 
						</p>
						<div style="clear: both;"></div>
						<%-- <%@ include file="/student/clock/layer_student_binding.jsp"%> --%>
						<p class="flyleft">
							<label> ${_res.get("admin.user.property.telephone")}： </label> <input name="student.tel" type="text" id="tel" value="${student.tel}" maxlength="15" vMin="0" vType="tel" onblur="onblurVali(this);" onchange="checkExistkong('tel')" /> <font color="red"> <span id="telMes"></span></font>
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('WeChat')}： </label> <input type="text" name="student.WeChat" value="${student.WeChat}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label>${_res.get('ID.Type')}：</label> <select name="student.zjtype" id="zjtype" class="chosen-select" style="width: 199px" tabindex="2" onchange="choosezjtype(2)">
								<option value="">${_res.get('Please.select')}</option>
								<option value="1" ${student.zjtype==1?"selected='selected'":""}>${_res.get('admin.user.property.idcard')}</option>
								<option value="2" ${student.zjtype==2?"selected='selected'":""}>${_res.get('Driving.licence')}</option>
								<option value="3" ${student.zjtype==3?"selected='selected'":""}>${_res.get('Protection')}</option>
								<option value="4" ${student.zjtype==4?"selected='selected'":""}>${_res.get('Else')}</option>
							</select>
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('ID.Number')}： </label> <input type="text" name="student.zjnumber" id="zjnumber" value="${student.zjnumber}" onchange="checkzjnumber('zjnumber')" /> <font color="red"> <span id="zjnumberMes"></span></font>
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('rest.day')}：</label><select name="student.rest_day" id="restDay" class="chosen-select" style="width: 199px;" tabindex="2">
								<option value="-1" <c:if test="${student.rest_day==-1}">selected="selected"</c:if>>--${_res.get('Please.select')}--</option>
								<option value="1" <c:if test="${student.rest_day==1}">selected="selected"</c:if>>${_res.get('system.Monday')}</option>
								<option value="2" <c:if test="${student.rest_day==2}">selected="selected"</c:if>>${_res.get('system.Tuesday')}</option>
								<option value="3" <c:if test="${student.rest_day==3}">selected="selected"</c:if>>${_res.get('system.Wednesday')}</option>
								<option value="4" <c:if test="${student.rest_day==4}">selected="selected"</c:if>>${_res.get('system.Thursday')}</option>
								<option value="5" <c:if test="${student.rest_day==5}">selected="selected"</c:if>>${_res.get('system.Friday')}</option>
								<option value="6" <c:if test="${student.rest_day==6}">selected="selected"</c:if>>${_res.get('system.Saturday')}</option>
								<option value="0" <c:if test="${student.rest_day==0}">selected="selected"</c:if>>${_res.get('system.Sunday')}</option>
							</select>
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('admin.common.place')}： </label> <input type="text" name="student.address" value="${student.address}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('Nationality')}： </label> <input type="text" name="student.nationality" value="${student.nationality}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Date.of.birth')}： </label> <input type="text" name="student.birthday" readonly="readonly" value="${student.birthday}" id="birthday" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('Age')}： </label> <input type="text" id="age" name="student.age" value="${student.age}" vMin="0" vType="number" onblur="onblurVali(this);" /> <font color="red"> <span id="ageMes"></span></font>
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Grade')}： </label> <input type="text" name="student.grade_name" value="${student.grade_name}" />
						</p>
						<div style="clear: both;"></div>
						<p style="clear: both">
							<label> ${_res.get('Academy')}： </label> <input type="text" name="student.school" value="${student.school}" style="width: 630px" />
						</p>
						<p>
							<label> ${_res.get('Address')}： </label> <input name="student.stuaddress" type="text" value="${student.stuaddress}" maxlength="100" style="width: 630px" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft" style="width: 400px">
							<label> 课表需要确认： </label>
							<input type="radio" name="student.release" value="0" checked='checked' />
							${_res.get('admin.common.no')}
							<input type="radio" name="student.release" value="1" ${student.release==1 ? "checked='checked'":"" } />
							${_res.get('admin.common.yes')} 
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft" style="width: 400px">
							<label> ${_res.get('Receive.SMS')}： </label>
							<input id="receiveSmsStudent" type="radio" name="student.receive_sms_student" value="0" ${student.receive_sms_student==0 ? "checked='checked'":"" } />
							${_res.get('admin.common.no')}
							<input id="receiveSmsStudent" type="radio" name="student.receive_sms_student" value="1" ${student.receive_sms_student==null?"checked='checked'":(student.receive_sms_student==1?"checked='checked'":"") } />
							${_res.get('admin.common.yes')} 
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Ranged')}： </label> <input type="radio" name="student.remote" value="0" ${student.remote==null?"checked='checked'":(student.remote==0?"checked='checked'":"") } />${_res.get('admin.common.no')} <input type="radio" name="student.remote" value="1" ${student.remote==1 ? "checked='checked'":"" } />${_res.get('admin.common.yes')}
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('The.head.teachers')}： </label> <input type="text" name="student.classteacher" value="${student.classteacher}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('The.teacher.in.charge.the.phone')}： </label> <input type="text" name="student.classteachertel" value="${student.classteachertel}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('The.teacher.in.charge.the.email')}： </label> <input type="text" name="student.classteacheremail" value="${student.classteacheremail}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('English.teacher')}： </label> 
							<input type="text" name="student.englishteacher" value="${student.englishteacher}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Mathematics.teacher')}： </label> 
							<input type="text" name="student.mathematicsteacher" value="${student.mathematicsteacher}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('The.English.teacher.call')}： </label> 
							<input type="text" name="student.englishteachertel" value="${student.englishteachertel}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('The.Mathematics.teacher.call')}： </label> 
							<input type="text" name="student.mathematicsteachertel" value="${student.mathematicsteachertel}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('The.English.teacher.email')}： </label> 
							<input type="text" name="student.englishteacheremail" value="${student.englishteacheremail}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('The.Mathematics.teacher.email')}： </label> 
							<input type="text" name="student.mathematicsteacheremail" value="${student.mathematicsteacheremail}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('Father.Name')}： </label> 
							<input type="text" name="student.fathername" value="${student.fathername}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Mother.Name')}： </label> 
							<input type="text" name="student.mothername" value="${student.mothername}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('Father.Tel')}： </label> 
							<input type="text" name="student.fathertel" value="${student.fathertel}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Mother.Tel')}： </label> 
							<input type="text" name="student.mothertel" value="${student.mothertel}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('Father.Email')}： </label> 
							<input type="text" name="student.fatheremail" value="${student.fatheremail}" />
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get('Mother.Email')}： </label> 
							<input type="text" name="student.motheremail" value="${student.motheremail}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft" style="width: 400px">
							<label>父亲接收短信： </label> 
							<input id="receiveSmsFather" type="radio" name="student.receive_sms_father" value="0" ${student.receive_sms_father==0 ? "checked='checked'":"" } />
							${_res.get('admin.common.no')}
							<input id="receiveSmsFather" type="radio" name="student.receive_sms_father" value="1" ${student.receive_sms_father==null?"checked='checked'":(student.receive_sms_father==1?"checked='checked'":"") } />
							${_res.get('admin.common.yes')} 
						</p>
						<p class="flyleft marfly">
							<label>母亲接收短信： </label>
							<input id="receiveSmsMother" type="radio" name="student.receive_sms_mother" value="0" ${student.receive_sms_mother==0 ? "checked='checked'":"" } />
							${_res.get('admin.common.no')}
							<input id="receiveSmsMother" type="radio" name="student.receive_sms_mother" value="1" ${student.receive_sms_mother==null?"checked='checked'":(student.receive_sms_mother==1?"checked='checked'":"") } />
							${_res.get('admin.common.yes')} 
						</p>
						<div style="clear: both;"></div>
						<p style="clear: both;">
							<label> ${_res.get('Accommodation')}： </label> 
							<input id="radio1" onclick="zhusu(this.value);" type="radio" name="student.board" value="0" ${student.board==null?"checked='checked'":(student.board==0?"checked='checked'":"")} />${_res.get('admin.common.no')} 
							<input id="radio2" onclick="zhusu(this.value);" type="radio" name="student.board" value="1" ${student.board==1 ? "checked='checked'":"" } />${_res.get('admin.common.yes')}
						</p>
						<p id="zhusushijian" class="flyleft" <c:if test="${student.board==0||student.board==null}">style="display: none"</c:if>>
							<label> ${_res.get('Stay.time')}： </label> 
							<input type="text" name="student.board_time" id="date1" readonly="readonly" value="${student.board_time}" />- <input type="text" name="student.board_endtime" id="date2" readonly="readonly" value="${student.board_endtime}" />
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label>${_res.get("class.location")}：</label> 
							<select name="student.campusid" id="campusid" class="chosen-select" style="width: 199px" tabindex="2" onchange="chooseTutor(this.value)">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${campusList }" var="campus">
									<option value="${campus.id }" ${campus.id==student.campusid?"selected='selected'":""}>${campus.campus_name }</option>
								</c:forEach>
							</select> <font color="red"> * <span id="campusidMes"> </span></font>
						</p>
						<p class="flyleft" style="margin-left: 22px">
							<label> ${_res.get("Supervisor")}： </label> <select name="student.supervisor_id" id="supervisor" class="chosen-select" style="width: 199px;" tabindex="2">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${supervisors}" var="supervisor">
									<option value="${supervisor.id}" ${student.supervisor_id==supervisor.id?"selected='selected'":""}>${supervisor.real_name}</option>
								</c:forEach>
							</select>
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> 行业： </label>
							<d:dictList class_="chosen-select" numbers="business" changefuc="" name="student.business" defaultnumber="${student.business}" style="width: 199px;" type="selectchange" id="industry"></d:dictList>
						</p>
						<p class="flyleft marfly">
							<label> 国家： </label>
							<d:dictList class_="chosen-select" numbers="country" changefuc="chooseCountry" name="student.country" defaultnumber="${student.country}" style="width: 199px;" type="selectchange" id="country"></d:dictList>
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> 城市： </label>
							<select name="student.city" id="city" class="chosen-select" style="width: 199px;" tabindex="2">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${city}" var="cityid">
									<option value="${cityid.numbers}" ${student.city==cityid.numbers?"selected='selected'":""}>${cityid.val}</option>
								</c:forEach>
							</select>
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get('Their.academic')}： </label> <select name="student.jwuserid" id="jiaowu" class="chosen-select" style="width: 199px;" tabindex="2">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${jwuserid}" var="jwuserid">
									<option value="${jwuserid.id}" ${student.jwuserid==jwuserid.id?"selected='selected'":""}>${jwuserid.real_name}</option>
								</c:forEach>
							</select>
						</p>
						<p class="flyleft marfly">
							<label> ${_res.get("marketing.specialist")}： </label> <select name="student.scuserid" id="shichang" class="chosen-select" style="width: 199px;" tabindex="2">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${scuserid}" var="scuserid">
									<option value="${scuserid.id}" ${student.scuserid==scuserid.id?"selected='selected'":""}>${scuserid.real_name}</option>
								</c:forEach>
							</select>
						</p>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get("course.consultant")}： </label>
							<select id="kcgw" name="kcgw_ids" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 630px;" tabindex="4">
							</select> <input id="kcgwids" name="kcgwids" value="" type="hidden"><font color="red"> * <span id="campusidMes"> </span></font> 
							<input type="hidden" id="htkcgwids" value="${kcgws}">
						</p>
						<c:if test="${difference eq '0'}">
							<p>
								<label> ${_res.get('course.subject')}： </label> <input name="subject" type="text" value="${subjectlist}" maxlength="15" style="width: 630px" disabled='disabled' />
							</p>
							<p class="flyleft">
								<label> ${_res.get("course.course")}： </label> 
								<select id="courseid" name="courseid" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 630px;" tabindex="4">
									<c:forEach items="${courselist}" var="course">
										<option value="${course.courseid}" class="optionss" id="cou_${course.courseid }">${course.coursename}</option>
									</c:forEach>
								</select> 
								<input id="courseids" name="student.class_type" value="" type="hidden">
							</p>
							<input type="hidden" value="0" id="difference" name="difference">
						</c:if>
						<div style="clear: both;"></div>
						<p class="flyleft">
							<label> ${_res.get("course.remarks")}： </label>
							<textarea rows="5" cols="85" name="student.intro" style="width: 630px; overflow-x: hidden; overflow-y: scroll;">${fn:trim(student.intro)}</textarea>
						</p>
						<div style="clear: both;"></div>
						<!-- 学生专属课程结束 -->
							<p style="margin-top: 70px">
								<c:if test="${operator_session.qx_studentsave || operator_session.qx_studentupdate }">
									<input type="button" value="${_res.get('save')}" onclick="return saveAccount();" class="btn btn-outline btn-primary" />
								</c:if>
							</p>
						<input type="hidden" id="picurl" name="student.headpictureid" value="${student.headpictureid}">
					</fieldset>
				</form>
			</div>
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

	<script type="text/javascript">
		$("#supervisor").val('${student.supervisor_id}');
		$("#sellId").val('${student.sell_id}');
		$("#restDay").val('${student.REST_DAY}');
		/**登陆邮箱使用QQ邮箱*/
		function useQQEmail() {
			var qq = $('#qq').val();
			if (qq == '') {
				alert("请填写QQ号码");
			} else {
				$("#email").val(qq + "@qq.com");
				checkExist('email');
			}
		}
		/**住宿显示日期*/
		function zhusu(iszhusu) {
			if (iszhusu == 1) {
				$('#radio2').attr('checked', true);
				$('#zhusushijian').show();
			} else {
				$('#radio1').attr('checked', true);
				$('#zhusushijian').hide();
			}
		}
		function checkExistkong(checkField) {
			var checkValue = $("#" + checkField).val();
			if (checkValue != "") {
				var flag = true;
				$.ajax({
					url : '${cxt}/student/checkExist',
					type : 'post',
					data : {
						'checkField' : checkField,
						'checkValue' : checkValue,
						'id' : $("#studentId").val()
					},
					async : false,
					dataType : 'json',
					success : function(data) {
						if (data.result >= 1) {
							$("#" + checkField).focus();
							$("#" + checkField + "Mes").text(
									"您填写的数据已存在。");
						} else {
							$("#" + checkField + "Mes").text("");
							flag = false;
						}
					}
				});
				return flag;
			} else {
				return false;
			}
		}
		$(document).ready(function() {
			setTimeout("sss()",1000);
		});
		function sss(){
			var name='${url}';
			if(name!=""&&name!=null){
				$("#ifstu").contents().find("#pic").html('<img id="pic" src="/images/headPortrait/'+name+'" style="width: 144px; height: 144px;">');
			}else{
				$("#ifstu").contents().find("#pic").html('<img id="pic" src="/images/touxiang1.png" style="width: 144px; height: 144px;">');
			}
		}

		function checkExist(checkField) {
			var checkValue = $("#" + checkField).val();
			if (checkValue != "") {
				var flag = true;
				$.ajax({
					url : '${cxt}/student/checkExist',
					type : 'post',
					data : {
						'checkField' : checkField,
						'checkValue' : checkValue,
						'id' : $("#studentId").val()
					},
					async : false,
					dataType : 'json',
					success : function(data) {
						if (data.result >= 1) {
							$("#" + checkField).focus();
							$("#" + checkField + "Mes").text(
									"您填写的数据已存在。");
						} else {
							$("#" + checkField + "Mes").text("");
							flag = false;
						}
					}
				});
				return flag;
			} else {
				$("#" + checkField).focus();
				$("#" + checkField + "Mes").text("该字段不能为空。");
				return true;
			}
		}

		function checkCampus(checkField) {
			var checkValue = $("#" + checkField).val();
			if (checkValue != "") {
				var flag = false;
				return flag;
			} else {
				flag = true;
				return flag;
			}
		}

		function checkzjnumber(checkField) {
			var checkValue = $("#" + checkField).val();
			if (checkValue.length > 50) {
				$("#zjnumberMes").text("您填写的字段有误。");
				var flag = true;
				return flag;
			} else {
				flag = false;
				return flag;
			}
		}
		function getCourseids() {
			var courseids = "";
			var list = document
					.getElementsByClassName("search-choice");
			for (var i = 0; i < list.length; i++) {
				var name = list[i].children[0].innerHTML;
				var olist = document
						.getElementsByClassName("optionss");
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						courseids += "|"
								+ olist[j].getAttribute('value');
						break;
					}
				}
			}
			$("#courseids").val(courseids);
		}

		function saveAccount() {
			if($("#ifstu").contents().find("#url").val()!=""){
				$("#picurl").val($("#ifstu").contents().find("#url").val());
			}
			getCourseids();
			var kcgwids = "";
			var list = document
					.getElementsByClassName("search-choice");
			for (var i = 0; i < list.length; i++) {
				var name = list[i].children[0].innerHTML;
				var olist = document
						.getElementsByClassName("options");
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						kcgwids += "|"
								+ olist[j].getAttribute('value');
						break;
					}
				}
			}
			$("#kcgwids").val(kcgwids);
			var supervisor = $("#supervisor").val();
			var kcgwids = $("#kcgwids").val();
			var jiaowu = $("#jiaowu").val();
			if (checkExist('real_name')) {
				layer.msg("姓名不能为空和重复",1,2);
				$("#realName").focus();
				return false;
			} else {
				if (checkExistkong('tel')) {
					layer.msg("电话号码不能重复",1,2);
					$("#tel").focus();
				} else {
					if (checkExistkong('email')) {
						layer.msg("Email不能重复",1,2);
						$("#email").focus();
					} else {
						if (checkCampus('campusid')) {
							layer.msg("上课地点不能为空",1,2);
							$("#campusid").focus();
							return false;
						} else
					
						if (kcgwids == "") {
							layer.msg("请选择课程顾问", 1, 2);
							$("#kcgwids").focus();
						} else {
							if (checkzjnumber('zjnumber')) {
								$("#zjnumber").focus();
							} else {
								var studentId = $("#studentId").val()
								if (studentId == "") {
									$ .ajax({
										type : "post",
										url : "${cxt}/student/save",
										data : $('#studentForm').serialize(),
										datatype : "json",
										success : function(data) {
											if (data.code == '0') {
												layer.msg(data.msg,2,5);
											} else {
												layer.msg(data.msg,2,6);
												setTimeout("parent.layer.closeAll()",3000);
												if("${viewType}"==""){
													window.location.href="/student";
												}
											}
										}
									});
								} else {
									if (confirm("确定要保存该学生信息吗？")) {
										$.ajax({
											type : "post",
											url : "${cxt}/student/update",
											data : $('#studentForm').serialize(),
											datatype : "json",
											success : function(data) {
												if (data.code == '0') {
													layer.msg(data.msg,2,5);
												} else {
													layer.msg(data.msg,2,6);
													setTimeout("parent.layer.closeAll()",3000);
													if("${viewType}"==""){
														window.location.href="/student";
													}
												}
											}
										});
									}
								}
							}
						}
					}
				}
			}
		}
		function chooseTutor(id) {
			var htkcgwids = $("#htkcgwids").val();
			if(id==""||id==null){
				return false;
			}
			$ .ajax({
						url : '${cxt}/student/getCampusTutors',
						type : 'post',
						data : {'campusid' : id},
						dataType : "json",
						success : function(data) {
							$("#supervisor").html("");
							$("#jiaowu").html("");
							$("#shichang").html("");
							$("#kcgw").html("");
							if (data.tutors.length > 0) {
								for (var i = 0; i < data.tutors.length; i++) {
									var str = "<option value='"+data.tutors[i].ID+"' > "
											+ data.tutors[i].REAL_NAME
											+ "</option>";
									$("#supervisor").append(str);
								}
								$("#supervisor").trigger(
										"chosen:updated");
							} else {
								str = "<option value='0'>${_res.get('Please.select')}</option>";
								$("#supervisor").append(str);
								$("#supervisor").trigger(
										"chosen:updated");
							}
							if (data.jiaowu.length > 0) {
								for (var i = 0; i < data.jiaowu.length; i++) {
									var str = "<option value='"+data.jiaowu[i].ID+"' > "
											+ data.jiaowu[i].REAL_NAME
											+ "</option>";
									$("#jiaowu").append(str);
								}
								$("#jiaowu").trigger("chosen:updated");
							} else {
								str = "<option value='0'>${_res.get('Please.select')}</option>";
								$("#jiaowu").append(str);
								$("#jiaowu").trigger("chosen:updated");
							}
							if (data.kcgw.length > 0) {
								for (var i = 0; i < data.kcgw.length; i++) {
									if (htkcgwids.indexOf(data.kcgw[i].KCGWIDS) != -1) {
										var str = "<option value='"+data.kcgw[i].ID+"' class='options' id='tid_"+data.kcgw[i].ID+"'selected='selected'>"
												+ data.kcgw[i].REAL_NAME
												+ "</option>";
									} else {
										var str = "<option value='"+data.kcgw[i].ID+"' class='options' id='tid_"+data.kcgw[i].ID+"'>"
												+ data.kcgw[i].REAL_NAME
												+ "</option>";
									}
									$("#kcgw").append(str);
								}
								$("#kcgw").trigger("chosen:updated");
							} else {
								str = "";
								$("#kcgw").append(str);
								$("#kcgw").trigger("chosen:updated");
							}
							if (data.shichang.length > 0) {
								for (var i = 0; i < data.shichang.length; i++) {
									var str = "<option value='"+data.shichang[i].ID+"' > "
											+ data.shichang[i].REAL_NAME
											+ "</option>";
									$("#shichang").append(str);
								}
								$("#shichang").trigger(
										"chosen:updated");
							} else {
								str = "<option value='0'>${_res.get('Please.select')}</option>";
								$("#shichang").append(str);
								$("#shichang").trigger(
										"chosen:updated");
							}
						}
					});
		}
		function chooseCountry() {
			var id = $("#country").val();
			$("#city").html("");
			$("#city").append("<option value='0'>${_res.get('Please.select')}</option>");
			if(id==""||id==null){
			}else{
				$ .ajax({
					url : '${cxt}/student/getityByCountry',
					type : 'post',
					async: false,
					data : {'countryid' : id},
					dataType : "json",
					success : function(data) {
						if (data.city.length > 0) {
							for (var i = 0; i < data.city.length; i++) {
								var str ="<option value='"+data.city[i].NUMBERS+"' > "
									+ data.city[i].VAL
									+ "</option>";
								$("#city").append(str);
							}
						}
					}
				});
			}
			$("#city").trigger("chosen:updated");
		}
		function choosezjtype(id) {
			var zjtype = $("#zjtype").val();
			if (id == 2) {
				$("#zjnumber").val("");
			}
			if (zjtype == "") {
				$("#zjnumber").attr("readonly", true);
				$("#zjnumber").trigger("chosen:updated");
			} else {
				$("#zjnumber").attr("readonly", false);
				$("#zjnumber").trigger("chosen:updated");
			}
		}
		$(document).ready(chooseTutor($("#campusid").val()))
		$(document).ready(choosezjtype(1))
	</script>

	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script>
		//生日日期范围限制
		var birthday = {
			elem : '#birthday',
			format : 'YYYY-MM-DD',
			max : laydate.now(), //最大日期
			istime : false,
			istoday : false
		};
		laydate(birthday);

		//住宿时间
		var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				date2.min = datas; //开始日选好后，重置结束日的最小日期
				date2.start = datas //将结束日的初始值设定为开始日
			}
		};
		var date2 = {
			elem : '#date2',
			format : 'YYYY-MM-DD',
			max : '2099-06-16',
			istime : false,
			istoday : false,
			choose : function(datas) {
				date1.max = datas; //结束日选好后，重置开始日的最大日期
			}
		};
		laydate(date1);
		laydate(date2);
	</script>
	<script src="/js/utils.js"></script>

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script>
		$('li[ID=nav-nav1]').removeAttr('').attr('class', 'active');
	</script>