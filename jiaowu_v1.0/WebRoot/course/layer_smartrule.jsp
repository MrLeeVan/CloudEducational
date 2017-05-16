<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('new.regulation')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
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

.tds{
	text-align : left;
}
.chosen-results{
   max-height:80px !important
}
</style>
</head>
<body>
	<div id="wrapper" style="overflow-y:hidden;text-align: center; ">
				<div class="ibox-content">
				<form id="smartrule" action="/smartplan/saveRulePlan" method="post">
					<input type="hidden" id="id" name="smartPlan.id" value="${id }" />
					<input type="hidden" id="studentId" name="smartPlan.studentid" value="${stuid }"/>
					<fieldset style="width: 100%; padding-top:15px;">
					<div class="paikegz" style="padding:0 10px">
						<div class="jizhun-mar m-b">
							<label>${_res.get("student")}/${_res.get("group.class")}：</label>
							<input type="text" readonly="readonly" id="studentName" name="studentName" style="width: 150px;" value="${studentName }" />
								<div id="mohulist" class="student_list_wrap" style="display: none">
									<ul style="margin-bottom: 10px;" id="stuList"></ul>
								</div>&nbsp;&nbsp;
						</div>
						<div class="jizhun-mar m-b">
							<label>${_res.get('Week')}：</label>
								<input type="checkbox" id="weekday1" class="" name="weekdays" value="1" >${_res.get('system.Monday')}&nbsp;
								<input type="checkbox" id="weekday2" class="" name="weekdays" value="2" >${_res.get('system.Tuesday')}&nbsp;
								<input type="checkbox" id="weekday3" class="" name="weekdays" value="3" >${_res.get('system.Wednesday')}&nbsp;
								<input type="checkbox" id="weekday4" class="" name="weekdays" value="4" >${_res.get('system.Thursday')}&nbsp;
								<input type="checkbox" id="weekday5" class="" name="weekdays" value="5" >${_res.get('system.Friday')}&nbsp;
								<input type="checkbox" id="weekday6" class="" name="weekdays" value="6" >${_res.get('system.Saturday')}&nbsp;
								<input type="checkbox" id="weekday7" class="" name="weekdays" value="7" >${_res.get('system.Sunday')}&nbsp;
						</div>
						<div class="jizhun-mar m-b">
						    <label>${_res.get('time.session')}：</label>
						    <select id="timerankid" class="chosen-select" style="width: 150px;" tabindex="2" name="smartPlan.timerankid"  >
								<c:forEach items="${trlist }" var="time"  >
									<option value="${time.id }" <c:if test="${time.id == rankid }">selected="selected"</c:if> >${time.RANK_NAME }</option>
								</c:forEach>
							</select>&nbsp;&nbsp;&nbsp;
						<label>${_res.get('system.campus')}：</label>
						   <select id="campusid" class="chosen-select" style="width: 150px;" tabindex="2" name="smartPlan.campusid"  >
								<c:forEach items="${campus }" var="campus"  >
									<option value="${campus.id }" <c:if test="${campus.id == campusid }">selected="selected"</c:if> >${campus.CAMPUS_NAME }</option>
								</c:forEach>
							</select>
						</div>
						<div class="jizhun-mar m-b">
							<label>${_res.get('course.course')}：</label>
						    <select id="courseid" class="chosen-select" style="width: 150px;" tabindex="2" name="smartPlan.courseid" onchange="queryTeacher(this.value)"  >
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${stucourse }" var="course"  >
									<option value="${course.courseid }" <c:if test="${course.courseid == courseid }">selected="selected"</c:if> >${course.course_name }</option>
								</c:forEach>
							</select>&nbsp;&nbsp;&nbsp;
						    <label>${_res.get('teacher')}：</label>
						    <select id="teacherid" class="chosen-select" style="width: 150px;" tabindex="2" name="smartPlan.teacherid"  >
								<option value="">--${_res.get('Please.select')}--</option>
							</select>
						</div>
						<div class="jizhun-mar m-b">
							<!-- 助教 -->
						    <label>${_res.get('assistant')}：</label>
						    <input type="hidden" name="smartPlan.assistantids" id="assistantids" value="">
						    <select id="assistants" class="chosen-select" style="width: 385px;" multiple="multiple">
					   		 	<option value=""></option>
								<c:forEach items="${isAssistantTeachers }" var="tch">
									<option value="${tch.id }">${tch.REAL_NAME }</option>
								</c:forEach>
							</select>
						</div>
						<div style="margin-top:30px">
							<c:if test="${operator_session.qx_smartplansaveRulePlan }">
							   <input type="button" id ="submitForm" name="submitForm" onclick="submitRuleForm()" value="${_res.get('teacher.group.add')}" style="float:right" class="btn btn-outline btn-primary"/>
							</c:if>
					    </div>
					<div style="clear:both" ></div>
					</div>
					</fieldset>
				</form>
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
	 $(".chosen-select").chosen({disable_search_threshold: 30});
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

		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		
	</script>
	
	<script type="text/javascript">
		$(function(){
			$('#studentName').keyup(function(){
				$("#courseid").html("<option value=''>--${_res.get('Please.select')}--</option>");
				$("#teacherid").html("<option value=''>--${_res.get('Please.select')}--</option>");
				$("#studentId").val("");
				var studentName = $("#studentName").val().trim();
				if (studentName != "") {
					var studentName=$("#studentName").val();
						$.ajax({
							url :  "${cxt}/smartplan/getAccountByNameLike",
							data :"studentName="+studentName,
							type : "post",
							dataType : "json",
							success : function(result) {
								if(result.accounts!=null){
									if(result.accounts.length==0){
										$("#studentName").focus();
										$("#studentInfo").text("学生不存在！");
										return false;
									}else{
										var str="";
										for(var i=0;i<result.accounts.length;i++){
											var studentId = result.accounts[i].ID;
											var realName = result.accounts[i].REAL_NAME;
											if(studentName==realName){
												$("#studentId").val(studentId);
												$("#studentName").val(realName); 
												$("#mohulist").hide();
												dianstu(studentId,realName);
												return;
											}else{
												str += "<li onclick='dianstu(\"" + studentId+"\",\""+realName+"\")'>" + realName + "</li>";
											}
										}
										$("#stuList").html(str);
										$("#mohulist").show();
									}
								}else{
									$("#stuList").html("");
									$("#mohulist").hide();
									$("#studentName").focus();
									$("#studentInfo").text("学生不存在！");
								}
							}
						});
			}else{
				$("#studentInfo").text("");
				$("#studentId").val("");
				$("#studentName").val("");
				$("#stuList").html("");
				$("#mohulist").hide();
			}
			});	
			
			$("#courseid").focus(function(){
				var studentid = $("#studentId").val();
				$.ajax({
					url:"/smartplan/studentCourse"
				});
			});
			
			
		});
		
		function dianstu(studentid,name){
			$("#studentId").val(studentid);
			$("#studentName").val(name); 
			$("#courseid").html("<option value=''>--${_res.get('Please.select')}--</option>");
			$.ajax({
				url:"/smartplan/getRuleStudentCourses",
				data:{"stuid":studentid},
				type:"post",
				dataType:"json",
				async:false,
				success:function(data){
					$("#courseid").html("");
					var str = "<option value=''>--${_res.get('Please.select')}--</option>";
					if(data.length>0){
						for(var i=0;i<data.length;i++){
							str += "<option value='"+data[i].COURSEID+"'>"+data[i].COURSENAME+"</option>";
						}
					}
					$("#courseid").html(str);
					$("#courseid").trigger("chosen:updated");
				}
			});
			$("#mohulist").hide();
		}
		
		function queryTeacher(courseid){
			$("#teacherid").html("<option value=''>--${_res.get('Please.select')}--</option>");
			var studentid = $("#studentId").val();
			$.ajax({
				url:"/smartplan/getCourseTeachers",
				data:{"stuid":studentid,"courseid":courseid},
				type:"post",
				dataType:"json",
				async:false,
				success:function(data){
					$("#teacherid").html("");
					$("#assistants").html("");
					var str = "<option value=''>--${_res.get('Please.select')}--</option>";
					var opStr = "";
					if(data.length>0){
						for(var i=0;i<data.length;i++){
							opStr += "<option value='"+data[i].ID+"'>"+data[i].REAL_NAME+"</option>";
						}
					}
					$("#teacherid").html(str + opStr);
					$("#teacherid").trigger("chosen:updated");
					$("#assistants").html(opStr);
					$("#assistants").trigger("chosen:updated");
				}
			});
		}
		
	</script>
	<script type="text/javascript">
		var index = parent.layer.getFrameIndex(window.name);
	  	parent.layer.iframeAuto(index); 
		function submitRuleForm(){
			var stuid = $("#studentId").val();
			var rankid = $("#timerankid").val();
			var courseid = $("#courseid").val();
			var teacherid = $("#teacherid").val();
			var assistants = $("#assistants").val();
			var campusid = $("#campusid").val();
			if(stuid==null||stuid==""){
				alert("${_res.get('student')}");
				return false;
			}
			var weekIdValue = [];
			$('input[name="weekdays"]:checked').each(function() {
				weekIdValue.push($(this).val());
			});
			if(weekIdValue.length==0){
				alert("没有星期。");
				return false;
			}
			if(rankid==null||rankid==""){
				alert("时段");
				$("#timerankid").focus();
				return false;
			}
			if(courseid==null||courseid==""){
				alert("${_res.get('course.course')}");
				return false;
			}
			if(teacherid==null||teacherid==""){
				alert("老师");
				return false;
			}
			if(campusid==null||campusid==""){
				alert("${_res.get('system.campus')}");
				return false;
			}
			if(assistants != null && assistants != ''){
				console.log("助教老师assistants= ", assistants);
				$("#assistantids").val(assistants.join(","));
			}
			if(confirm("如信息无误，请确认您要提交的请求！")){
				$.ajax({
		            cache: true,
		            type: "POST",
		            url:"/smartplan/saveRulePlan",
		            data:$('#smartrule').serialize(),// 你的formid
		            async: false,
		            error: function(request) {
		            	layer.msg("网络异常，请稍后重试。", 1,1);
		            },
		            success: function(data) {
		            	parent.layer.msg(data.msg,2,1);
			    		if(data.code=='1'){//成功
			    			parent.window.location.reload();
			    			setTimeout("parent.layer.close(index)",3000);
			    		}
		            }
		        });
			}
		}
	</script>
	
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script>
       $('li[ID=nav-nav3]').removeAttr('').attr('class','active');
    </script>
</body>
</html>