<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 

<style type="text/css">
body {
	background-color: #eff2f4;
	
}

label {
	width: 150px;
}

textarea {
	width: 80%;
	margin-left: 15px;
}
.student_list_wrap li {
    
	display: block;
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: pointer;
	margin-right: 38px;
}
</style>
</head>
<body style="background: white;">
			<div class="ibox float-e-margins margin-nav1">
				<div class="col-lg-12" style="margin-left: -14px;">
						
						<div class="ibox-content">
							<form id="courseOrderForm" action="" method="post">
								<input type="hidden" id="studentId" name="courseOrder.studentid" value="${student.id }" /> 
								<input type="hidden" id="orderId" name="courseOrder.id" value="${courseOrder.id }" />
								<c:if test="${operateType != 'buy' }">
									<input type="hidden" name="courseOrder.version" value="${courseOrder.version + 1}"/>
								</c:if>
								<input type="hidden" id="operateType" name="type" value="${operateType}"/>
								<fieldset style="width: 100%; padding-top: 15px;">
									<p>
										<label>${_res.get("student.name")}：</label> 
										<input type="text" id="studentName" name="studentName" value="${student.real_name }" readonly="readonly" size="20" maxlength="15" /> <span id="studentInfo" style="color: red;"></span>
									</p>
									<p>
										<label>${_res.get('type.of.class')}：</label>
										<c:choose>
											<c:when test="${courseOrder == null }">
												<input type="radio" id="teachtype" name="courseOrder.teachtype" value="1" checked='checked'/>${_res.get("IEP")}
												<input type="radio" id="teachtype" name="courseOrder.teachtype" value="2"/>${_res.get('course.classes')}
											</c:when>
											<c:otherwise>
												<c:if test="${courseOrder.teachtype == 1 }">
													<input type="radio" id="teachtype" name="courseOrder.teachtype" value="1" checked='checked'/>${_res.get("IEP")}
												</c:if>
												<c:if test="${courseOrder.teachtype == 2 }">
													<input type="radio" id="teachtype" name="courseOrder.teachtype" value="2" checked='checked'/>${_res.get('course.classes')}
												</c:if>
											</c:otherwise>
										</c:choose>
									</p>
									<p id="km" ${courseOrder==null||courseOrder.teachtype==1?"":"style='display: none;'"}>
										<label>${_res.get('course.subject')}： </label> 
										<select id="subject_ids" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 480px;" tabindex="4" onchange="getCourse(0)">
											<c:forEach items="${subjectList}" var="subject">
												<option value="${subject.id}" class="options">${subject.SUBJECT_NAME}</option>
											</c:forEach>
										</select> 
										<input id="subjectids" name="subjectids" value="" type="hidden"/>
									</p>
									<p id="course" ${courseOrder==null||courseOrder.teachtype==1?"":"style='display: none;'"}>
										<label>${_res.get('course.course')}：</label> 
										<select id="course_ids" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 480px;" tabindex="4">
										</select> 
										<input id="courseids" name="courseids" value="${studentCourseIds}" type="hidden"/>
									</p>
									<p id="bc" >
										<label>${_res.get('The.selected.shifts')}：</label> 
										<select name="courseOrder.classorderid" id="classorderid" class="chosen-select" style="width: 400px;" onchange="chooseBanci()">
											<c:if test="${operateType eq 'buy' }">
												<option value="">${_res.get('Please.select')}</option>
											</c:if>
											<c:forEach items="${banciList }" var="banci">
												<option value="${banci.id }" <c:if test="${banci.id eq courseOrder.classorderid}"> selected="selected" </c:if>>
													${banci.classTypeName }-${banci.classnum }
													<c:choose> 
														<c:when test="${banci.chargeType == 0}">-${_res.get('byTeachingHours') }</c:when> 
														<c:otherwise>-${banci.totalfee }${_res.get('RMB')}-${banci.lessonnum}${_res.get('session')}</c:otherwise>
													</c:choose>
												</option>
											</c:forEach>
										</select>
										<c:forEach items="${banciList }" var="banci">
											<input id="chargeType_${banci.id }" type="hidden" value="${banci.chargeType }"/>
											<input id="bcfee_${banci.id }" type="hidden" value="${banci.totalfee }"/>
											<input id="bcks_${banci.id }" type="hidden" value="${banci.lessonnum }"/>
										</c:forEach>
										<span id="chooseBuyType" style="display: none;">
											<input type="radio" id="buyType" name="buyType" value="0" checked='checked'/>单科购
											<input type="radio" id="buyType" name="buyType" value="1" />整班购
										</span>
										<span id="bcInfo" style="color: red;"></span>
										<input id="chargeType" name="chargeType" value="" type="hidden"/>
									</p>
									<p id="banciCourse">
										<c:forEach items="${banciCourseList }" var="banci">
											<p>
											<label></label>
											<span style='padding:10px;'>
												<input type="checkbox" id="courseId_${banci.course_id }" name="course_id" checked="checked" onclick="check(${banci.course_id })" value="${banci.course_id }"/>
												${banci.course_name }(${banci.lesson_num }<c:if test="${banci.chargeType eq 0 }">${_res.get("RMB")}/</c:if> ${_res.get("session") })
												<input type="text" id="keshi${banci.course_id }" name="keshi"  onblur="checkblur(${banci.course_id })" value="${banci.oldClassHour}" size="5" />${_res.get('session')}
												<input type="hidden" id="hiddenkeshi${banci.course_id }" name="hiddenkeshi" value="${banci.lesson_num }" />
											</span>
											</p>
										</c:forEach>
									</p>
									<p id="hiddenBanciCourse">
									</p>
									<p>
										<label>${_res.get('total.sessions')}：</label> 
										<input id="totalClasshour" type="text" style="text-align: right;" name="courseOrder.classhour" value="${courseOrder.classhour }" ${(payCount > 0||courseOrder.teachtype == 2) ?"readonly='readonly'":""} />
										&nbsp;${_res.get('session')}
										<span id="classhourInfo" style="color: red;">${payCount > 0?"已有交费，禁止修改课时数和金额":"" }</span>
									</p>
									<p>
										<label>${_res.get('total.amount')}：</label> 
										<input id="totalsum" type="text" style="text-align: right;" name="courseOrder.totalsum" value="${courseOrder.totalsum }" ${payCount > 0 ?"readonly='readonly'":""} />
										&nbsp;${_res.get('RMB')}
										<c:if test="${student.temprealbalance+student.temprewardbalance>0 }">
											<input type="checkbox" id="useYucun" name="useYucun" value="1">${_res.get('Use.pre-deposit')}${student.temprealbalance+student.temprewardbalance }${_res.get('RMB')}
											<label>${_res.get('The.remaining.pre-deposit')}：</label>
											<input id="yck" type="text" style="text-align: right;" name="yck" value="${student.temprealbalance+student.temprewardbalance }" size='6' readonly="readonly" />&nbsp;${_res.get('RMB')}
											<input id="yck_hidden" type="hidden" name="yck_hidden" value="${student.temprealbalance+student.temprewardbalance }" />
										</c:if>
										<span id="realsumInfo" style="color: red;"></span>
									</p>
									
									<p>
										<span id="sum">
											<label>${_res.get('actual.amount')}：</label>
											<input id="realsum" type="text" style="text-align: right;" name="courseOrder.realsum" value="${courseOrder.realsum }" size='6' readonly="readonly" />&nbsp;${_res.get('RMB')}
										</span>
									</p>
									<p>
										<label>${_res.get('course.remarks')}：</label>
										<textarea rows="5" cols="85" id="'remark'" name="courseOrder.remark" style="width: 440px; overflow-x: hidden; overflow-y: scroll;">${courseOrder.remark }</textarea>
										<!--${fn:trim(student.intro)}  -->
									</p>
									<p>
										<c:if test="${operator_session.qx_orderssave || operator_session.qx_ordersupdate }">
											<input type="button" value="${_res.get('save')}" onclick="return saveCourseOrder();" class="btn btn-outline btn-success" />
										</c:if>
									</p>
								</fieldset>
							</form>
						</div>
					</div>
				</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 10
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
	<script>
		$(function(){
			var teachType = $("input[id='teachtype']:checked").val();
			if(teachType==1){//1对1
				$("#bc").hide();
				getCourse(0);
			}else{
				$("#bc").show();
			}
		});
	
		$(function() {
			$('#classorderid').change(
					function() {
						$('#showcourse').show();
						$.ajax({
							url : "/classtype/getCourseListByClassId",
							data : {
								"classOrderId" : $('#classorderid').val()
							},
							type : "post",
							dataType : "json",
							success : function(data) {
								$("#bcInfo").html("");
								$('#banciCourse').empty();
								$('#hiddenBanciCourse').empty();
								$('#showcourse').show();
								var chargeType = data.result.chargeType;
								var unit=""
								if(chargeType == 1){// 按期
									$("#chooseBuyType").show();
									$("input[name=keshi]").each(function(index){
										$(this).attr("readonly","readonly");
									})
								}else{
									unit="${_res.get('RMB')}/";
									$("#chooseBuyType").hide();
								}
								for (var i = 0; i < data.result.courseList.length; i++) {
									var courseName = data.result.courseList[i].COURSE_NAME;
									var courseId = data.result.courseList[i].COURSE_ID;
									var id = data.result.courseList[i].ID;
									var lessonNum = data.result.courseList[i].LESSON_NUM;
									var coursePlanCount = data.result.courseList[i].COURSEPLANCOUNT;
									var str = "<p><label></label><span style='padding:10px;'>"
											+ "<input type='checkbox' id='courseId_" + courseId + "' name='course_id' checked='checked' onclick='check(" + courseId + ")' value='" + courseId + "'>"  
											+ courseName+"("+lessonNum+unit+"${_res.get('session')})</span>"
											+ "<input type='text' id='keshi" + courseId + "' name='keshi'  onblur='checkblur(" + courseId + ")' value='' size='5'>${_res.get('session')}</p>";
									var hiddenCourse = "<input type='hidden' id='hiddenkeshi" + courseId + "' name='hiddenkeshi' value='"+lessonNum+"' size='5'>";
									$("#banciCourse").append(str);
									$("#hiddenBanciCourse").append(hiddenCourse);
								}
								$("#chargeType").val(chargeType);
							}
						});
					});
		});
		
		$(function() {
			$("input[id='buyType']").click(function() {
				var banciId = $("#classorderid").val();
				var fee = $("#bcfee_" + banciId).val();
				var ks = $("#bcks_" + banciId).val();
				var buyType = $(this).val();
				if (buyType == 1) {// 整班购
					$("input[name=keshi]").each(function(index){
						var defaultValue=$("#hidden"+$(this).attr("id")).val();
						$(this).val(defaultValue);
						$(this).attr("readonly","readonly");
						$("#totalClasshour").attr("readonly","readonly");
						$("#totalClasshour").val(ks);
						$("#totalsum").val(fee);
						$("#realsum").val(fee);
					})
					$("input[name=course_id]").each(function(index){
						$(this).prop('checked',true);
						$(this).attr("disabled","disabled");
					})
				} else { // 单科购
					$("input[name=course_id]").each(function(index){
						$(this).removeAttr("disabled");
					})
					$("input[name=keshi]").each(function(index){
						$(this).val(0);
						$(this).removeAttr("readonly");
						$("#totalClasshour").removeAttr("readonly");
						$("#totalClasshour").val(0);
						$("#totalsum").val(0);
						$("#realsum").val(0);
					})
				}
			});
		});
		
		// 计算输入的课程的总节数填入到排课节数中
		function checkblur(course_id) {
			var hours = $('#keshi' + course_id).val();
			var banciId = $("#classorderid").val();
			var result = hours.match(/^[0-9]+(.[0-9]{1,2})?$/);
			if (result == null) {
				$("#bcInfo").html("课时数只能为整数或两位小数");
				return false;
			} else {
				$("#bcInfo").html("");
				var buyType = $("input[name='buyType']:checked").val();
				var chargeType = $("#chargeType_"+banciId).val();
				if (buyType == 0 || chargeType == 0) {// 单科购或按课时
					var defaultValue=$("#hiddenkeshi"+course_id).val();
					if(Number(hours) > Number(defaultValue) && chargeType == 1){
						$("#keshi"+course_id).val(defaultValue);
						$("#bcInfo").html("课时不能超出该班课已设课时数");
					}
					var totalHour = 0;
					var totalSum = 0 ; 
					$("input[name=keshi]").each(function(index){
						var keshi = $(this).val();
						if(isNaN(keshi)){
							keshi = 0;
						}
						if(chargeType == 0){
							var fee=$("#hidden"+$(this).attr("id")).val();
							totalSum += Number(fee)*Number(keshi);
						}
						totalHour +=Number(keshi);
					})
					$("#totalClasshour").val(totalHour);
					$("#totalsum").val(totalSum);
					$("#realsum").val(totalSum);
				}
			}
		}
		
		function check(courseId){
			if($("#courseId_"+courseId).is(':checked')){
				$("#keshi"+courseId).removeAttr("disabled"); 
			}else{
				$("#keshi"+courseId).attr("disabled","disabled");
			}
		}
		
		$(function() {
			$('#totalsum').keyup(function() {
				var totalsum = $(this).val();
				if (totalsum == "") {
					$("#realsum").val(0);
					$("#realsumInfo").text("");
				} else {
					var result = totalsum.match(/^[0-9]+(.[0-9]{1,2})?$/);
					if (result == null) {
						$("#realsumInfo").text("请输入正确的总金额");
					} else {
						$("#realsumInfo").text("");
						var yck_hidden = $("#yck_hidden").val();
						if ($("#useYucun").prop("checked")) {
							if (Number(totalsum) == 0) {
								$("#realsum").val(0);
								$("#yck").val(yck_hidden);
								$("#realsumInfo").text("总金额不能为0");
							} else {
								if (Number(totalsum) <= Number(yck_hidden)) {
									$("#yck").val(yck_hidden - totalsum);
									$("#realsum").val(0);
								} else {
									$("#yck").val(0);
									$("#realsum").val(Number(totalsum) - Number(yck_hidden));
									$("#rebate").val(0);
									$("#realsumInfo").text("");
								}
							}
						} else {
							$("#realsum").val(totalsum);
							$("#yck").val(yck_hidden);
						}
					}
				}
			});
		});
		
		$(function() {
			$("input[id='useYucun']").click(function() {
				var totalsum = $("#totalsum").val();
				var yck_hidden = $("#yck_hidden").val();
				if ($(this).prop("checked")) {
					if (Number(totalsum) == 0) {
						$("#realsum").val(0);
						$("#yck").val(yck_hidden);
						$("#realsumInfo").text("总金额不能为0");
					} else {
						$("#realsumInfo").text("");
						if (Number(totalsum) <= Number(yck_hidden)) {
							$("#yck").val(yck_hidden - totalsum);
							$("#realsum").val(0);
						} else {
							$("#realsum").val(totalsum - yck_hidden);
							$("#yck").val(0);
						}
					}
				} else {
					$("#realsumInfo").text("");
					$("#realsum").val(totalsum);
					$("#yck").val(yck_hidden);
				}
			});
		});


		function chooseBanci() {
			var banciId = $("#classorderid").val();
			var fee = $("#bcfee_" + banciId).val();
			var ks = $("#bcks_" + banciId).val();
			var buyType = $("input[name='buyType']:checked").val();
			var chargeType = $("#chargeType_"+banciId).val();
			if (buyType == 0 || chargeType ==0) {// 单科购或按课时购买
				$("#totalClasshour").val(0);
				$("#totalsum").val(0);
				$("#realsum").val(0);				
			}else{
				$("#totalClasshour").val(ks);
				$("#totalsum").val(fee);
				$("#realsum").val(fee);
			}
		}

		$(function() {
			$("input[id='teachtype']").click(function() {
				var teachType = $(this).val();
				if (teachType == 1) {
					$("#totalClasshour").val(0);
					$("#totalsum").val(0);
					$("#rebate").val(0);
					$("#realsum").val(0);
					$("#classorderid").val('');
					$("#km").show();
					$("#course").show();
					$("#bc").hide();
					$('#totalClasshour').attr("readonly", false);
					$('#totalsum').attr("readonly", false);
					$('#realsum').attr("readonly", true);
					$("#banciCourse").hide();
				} else {
					$("#km").hide();
					$("#course").hide();
					$("#bc").show();
					$("#totalClasshour").val(0);
					$("#totalsum").val(0);
					$("#realsum").val(0);
					$('#totalClasshour').attr("readonly", true);
					$('#totalsum').attr("readonly", false);
					$('#realsum').attr("readonly", false);
					$("#banciCourse").show();
				}
				$("#bcInfo").text("");
				$("#classhourInfo").text("");
				$("#subjectInfo").text("");
				$("#realsumInfo").text("");
			});
		});

		function getCourse(ids) {
			$("#subject_ids").trigger("chosen:updated");
			var courseIds = $("#course_ids");
			var course_ids_clone = getCourseids(); 
			courseIds.html('');
			var subjectids = "";
			if (ids == 0) {
				subjectids = getSubjects();
			}
			if (subjectids != "") {
				var cs = "";
				$.ajax({
					url : "/course/getCourseBySubjectIds",
					data : {
						"ids" : subjectids.substr(1, subjectids.length)
					},
					type : "post",
					dataType : "json",
					success : function(data) {
						var str = "";
						if (data.length > 0) {
							for (var i = 0; i < data.length; i++) {
								str += '<option class="optionsss" value="'+data[i].COURSEID+'">' + data[i].COURSENAME + '</option>'
							}
						}
						courseIds.append(str);
						$.each(course_ids_clone.split("|"), function(i,n){
							courseIds.find("option[value='"+ n +"']").attr('selected', 'selected');
						});
						courseIds.trigger("chosen:updated");
					}
				});
			}else{
				courseIds.html('');
				courseIds.trigger("chosen:updated");
			}
		}
		function getCourseids() {
			$("courseids").val("");
			var courseids = '';
			var lists = $("#course_ids_chosen").find(".search-choice");
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
		function getSubjects() {
			$("subjectids").val("");
			var subjectids = '';
			var lists = $("#subject_ids_chosen").find(".search-choice");
			for (var i = 0; i < lists.length; i++) {
				var name = lists[i].children[0].innerHTML;
				var olist = document.getElementsByClassName("options");
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						subjectids += "|" + olist[j].getAttribute('value');
						break;
					}
				}
			}
			return subjectids;
		}

		function saveCourseOrder() {
			var subjectids = getSubjects();
			$("#subjectids").val(subjectids.substr(1, subjectids.length));
			var courseids = getCourseids();
			$("#courseids").val(courseids.substr(1, courseids.length));
			var classorderid = $("#classorderid").val();
			var teachType = $('input[id="teachtype"]:checked').val();
				var zks = $("#totalClasshour").val();
				var zksResult = zks.match(/^[0-9]+(.[0-9]{1,2})?$/);
				if (zksResult==null) {
					$("#classhourInfo").text("课时必须为数字");
					return false;
				} else {
					$("#classhourInfo").text("");
				}
			if (teachType == 1) {
				if (subjectids == "") {
					$("#subjectInfo").text("请选择科目");
					return false;
				} else {
					$("#subjectInfo").text("");
				}
			} else {
				if (classorderid == "") {
					$("#bcInfo").text("请选择班次");
					return false;
				} else {
					$("#bcInfo").text("");
					$("input[name=keshi]").each(function(index){
						var keshi = $(this).val();
						if(isNaN(keshi) || keshi == ""){
							$(this).val(0);
						}
					})
				}
			}

			var realsum = $("#realsum").val();
			var totalsum = $("#totalsum").val();
			var result = totalsum.match(/^[0-9]+(.[0-9]{1,2})?$/);
			if (result == null) {
				$("#realsumInfo").text("只能为数字！");
				return false;
			} else {
				var yck_hidden = $("#yck_hidden").val();
				if ($(this).prop("checked")) {
					if (Number(totalsum) == 0) {
						$("#realsum").val(0);
						$("#yck").val(yck_hidden);
						$("#realsumInfo").text("总金额不能为0");
					} else {
						$("#realsumInfo").text("");
						if (Number(totalsum) <= Number(yck_hidden)) {
							$("#yck").val(yck_hidden - totalsum);
							$("#realsum").val(0);
						} else {
							$("#realsum").val(totalsum - yck_hidden);
							$("#yck").val(0);
						}
					}
				} else {
					$("#realsumInfo").text("");
					$("#realsum").val(realsum);
					$("#yck").val(yck_hidden);
				}
			}
			var operateType = $("#operateType").val();
			var url = "";
			if (operateType == 'buy') {
				url = "${cxt}/orders/save";
			} else {
				url = "${cxt}/orders/update";
			}
			if (confirm("如信息无误，请确认您要提交的请求！")) {
				var ischoose = false;
				$("input[name=course_id]").each(function(index){
					$(this).removeAttr("disabled");
						if($(this).prop("checked") == true){
							ischoose=true;
						}
				})
				if(teachType == 2&&!ischoose){
					alert("请选择要购买的小班课程");
					return false;
				}
				$.ajax({
					type : "POST",
					url : url,
					data : $('#courseOrderForm').serialize(),// 你的formid
					datatype : "json",
					async : false,
					error : function(request) {
						layer.msg("网络异常，请稍后重试。", 1, 1);
					},
					success : function(data) {
						/* layer.msg(data.msg, 3, 0);
						if (data.code == '1') {//成功
							setTimeout("history.go(-1)",3000);
							parent.window.location.reload();
						}else{
							
						} */
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
		
		function hideMessage() {
			$("#sum").hide();
			chose_mult_set_ini("#subject_ids", '${courseOrder.subjectids}');
		}

		$(document).ready(hideMessage());

		function chose_mult_set_ini(select, values) {
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
			setTimeout(function() {
				chose_mult_set_ini('#course_ids', '${studentCourseIds}');
				$(".chosen-select").chosen();
			}, 1000);
		});
	</script>
	<script src="/js/utils.js"></script>
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script>
       $('li[ID=nav-nav8]').removeAttr('').attr('class','active');
    </script>
</body>
</html>