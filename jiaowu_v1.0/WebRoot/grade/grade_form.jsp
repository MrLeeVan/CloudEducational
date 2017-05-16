<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Add.Results')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
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
.student_list_wrap {
	position: absolute;
	top: 165px;
	left: 7.5em;
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
<body>
	<div id="wrapper" style="background: #2f4050;">
	 <%@ include file="/common/left-nav.jsp"%>
       <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
		</div>

        <div class="col-lg-12" style="margin-top: 80px;padding-left:0;">
		<div class="ibox float-e-margins">
			<div class="ibox-title" style="width:100%">
				   <h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
						&gt;<a href='/student/index'>${_res.get('student_management')}</a> &gt;
						<a href='javascript:history.go(-1);'>${_res.get('performance_management')}</a>&gt;  ${_res.get('Add.Results')}
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback")}</a>
			       <div style="clear: both;"></div>
				</div>
			<div class="ibox-content">
				<form id="gradeForm" action="" method="post">
					<fieldset style="width: 100%; padding-top:15px;">
					<p>
							<label>${_res.get("student.name")}：</label>
							<input type="hidden" id="studentId" name="gradeRecord.studentid" value="${student.id }"/>
							<input type="text" id="studentName" name="gradeRecord.studentName" value="${student.real_name }" size="20" maxlength="15"/>
							<input type="hidden" id="subjectName" name="gradeRecord.subjectName" value=""/>
							<span id="studentInfo" style="color: red;"></span>
							<div id="mohulist" class="student_list_wrap" style="display: none">
								<ul style="margin-bottom: 10px;" id="stuList"> </ul>
							</div>
						</p>
						<p>
							<label>${_res.get('type.of.score')}：</label>
								<input type="radio" id="scoretype" name="gradeRecord.scoretype" value="0" checked='checked'>${_res.get("score_before_tutoring") }
								<input type="radio" id="scoretype" name="gradeRecord.scoretype" value="1">${_res.get("score_after_tutoring") }
						</p>
						<p>
							<label>${_res.get('type.of.grade')}：</label>
								<input type="radio" id="gradetype" name="gradeRecord.gradetype" value="0" checked='checked'>${_res.get("mock_examination_result") }
								<input type="radio" id="gradetype" name="gradeRecord.gradetype" value="1">${_res.get("test_result") }
								<input type="radio" id="gradetype" name="gradeRecord.gradetype" value="2">${_res.get("other") }
						</p>
						<p>
							<label>${_res.get('grade.exam.date')}：</label> <input id="examTime" type="text" name="gradeRecord.examdate" readonly="readonly" value="${gradeRecord.examdate}" size="15"/>
							<span id="examTimeInfo" style="color: red;"></span>
						</p>
						<p>
							<label>${_res.get('name.of.subject')}：</label> 
							<select name="gradeRecord.subjectId" id="subjectId" class="chosen-select" style="width: 150px" tabindex="2" onchange="searchCourse()">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${subjectList }" var="subject">
									<option value="${subject.id }">${subject.subject_name }</option>
								</c:forEach>
							</select>
							<span id="subjectInfo" style="color: red;"></span>
						</p>
						<p id="fsmx" style="display: none;">
							<label>分数明细：</label>
								<input type="radio" id="hasDetail" name="gradeRecord.hasdetail" value="1" checked="checked">有课程分数
								<input type="radio" id="hasDetail" name="gradeRecord.hasdetail" value="0" >只有总分
						</p>
						<p id="kcfs" style="display: none;">
							<label>课程分数：</label> <span id="course"></span><span id="courseInfo" style="color: red;"></span>
						</p>
						<p id="zfs">
							<label>${_res.get("total_score") }：</label>
							<input id="gross" type="text" name="gradeRecord.grossscore" value=""/><span id="grossInfo" style="color: red;"></span>
						</p>
						<p>
							<label> ${_res.get("course.remarks")}： </label>
							<textarea rows="5" cols="85" id="remark" name="gradeRecord.remark" style="width: 440px; overflow-x: hidden; overflow-y: scroll;">${fn:trim(gradeRecord.remark)}</textarea>
						</p>
						<p>
							<c:if test="${operator_session.qx_gradesaveGradeRecord }">
								<input type="button" value="${_res.get('save')}" onclick="return saveGradeRecord();" class="btn btn-outline btn-primary" />
							</c:if>
							<input type="button" onclick="window.history.go(-1)" value="${_res.get('system.reback')}" class="btn btn-outline btn-success">
						</p>
					</fieldset>
				</form>
			</div>
		</div>
		</div>
	 </div>	
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
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

		$(function() {
			$('#studentName').keyup(function() {
				// 如果选择了一对一则搜索学生姓名
				var studentName = $("#studentName").val().trim();
				if (studentName != "") {
					$.ajax({
						url : "/grade/getAccountByNameLike",
						data : "studentName=" + studentName,
						type : "post",
						dataType : "json",
						success : function(result) {
							if (result.accounts != null) {
								if (result.accounts.length == 0) {
									$("#studentName").focus();
									$("#studentInfo").text("学生不存在！");
									return false;
								}
								var str = "";
								for (var i = 0; i < result.accounts.length; i++) {
									var studentId = result.accounts[i].ID;
									var realName = result.accounts[i].REAL_NAME;
									if(studentName==realName){
										$("#studentId").val(studentId);
										$("#studentName").val(realName);
										$("#mohulist").hide();
										$("#studentInfo").text("");
										return;
									}else{
										str += "<li onclick='dianstu(" + studentId + ")'>" + realName + "</li>";
									}
								}
								$("#stuList").html(str);
								$("#mohulist").show();
								$("#studentInfo").text("");
							} else {
								$("#studentName").focus();
								alert("此学员不存在");
							}
						}
					});
				} else {
					$("#studentInfo").text("");
					$("#studentId").val("");
					$("#studentName").val("");
					$("#stuList").html("");
					$("#mohulist").hide();
				}
			});
		});
		function dianstu(stuId) {
			$("#mohulist").hide();
			$("#mohulist").html();
			$('#classtype').html('${_res.get("Please.select")}');
			$.ajax({
				url : "/account/getAccountByName",
				data : "studentId=" + stuId,
				type : "post",
				dataType : "json",
				success : function(result) {
					if (result.account != "noResult") {
						$("#studentId").val(result.account.studentId);
						$("#studentName").val(result.account.stuName);
					} else {
						alert("此学员不存在");
					}
				},
				error : function(result) {
					alert("ERROR! 请重新登录或刷新页面重试！");
				}
			});
		}
		function searchCourse() {
			var subjectId = $("#subjectId").val();
			if ("" == subjectId) {
				$("#subjectName").val("");
				$("#kcfs").hide();
				$("#fsmx").hide();
				$("#zfs").hide();
			} else {
				var hasDetail = $('input[id="hasDetail"]:checked').val();
				var input = "";
				var queryUrl = "${cxt}/account/getCourseListBySubjectId";
				$.ajax({
					type : "post",
					url : queryUrl,
					data : {
						"SUBJECT_ID" : subjectId
					},
					dataType : "json",
					contentType : "application/x-www-form-urlencoded; charset=UTF-8",
					async : false,
					success : function(data) {
						var subjectName = "";
						for (i in data.courses) {
							var courseId=data.courses[i].ID;
							var courseName=data.courses[i].COURSE_NAME;
							subjectName=data.courses[i].SUBJECT_NAME;
							input += courseName
									+ "：<input id='scores' type='text' name='score_" + courseId + "' value='' size='2' maxlength='5' onblur='computeScore()'>"
						}
						$("#course").html(input);
						if(hasDetail==1)
							$("#kcfs").show();
						else
							$("#kcfs").hide();
						$("#fsmx").show();
						$("#zfs").show();
						$("#gross").val("");
						$("#subjectName").val(subjectName);
						$("#gross").attr("readonly","readonly")//将总分数元素设置为readonly
					}
				});
			}
		}

		$(function() {
			$("input[id='hasDetail']").click(function() {
				var hasDetail = $(this).val();
				if(hasDetail == 1){
					$("#kcfs").show();
					$("#gross").val("");
					$("#gross").attr("readonly","readonly");
				}else{
					$("#kcfs").hide();
					$("#gross").removeAttr("readonly");
				}
			});
		});
		function computeScore() {
			var reg=new RegExp("^[0-9]+(.[0-9]{1,3})?$");
			var totalScore=0;
			var hasChar = 0;
			$("input[id='scores']").each(function() {
				var score = $(this).val();
				if(score!=""){
					if(reg.test(score)){
						totalScore = Number(score)+Number(totalScore);
					}else{
						hasChar=1;
						$(this).val("");
						$(this).focus();
						return false;
					}
				}
			});
			if(hasChar==0){
				$("#couseInfo").text("");
				$("#gross").val(Number(totalScore).toFixed(2));
			}else{
				$("#courseInfo").text("请输入正确的分数");
			}
		}
		
		function saveGradeRecord() {
			var studentName = $("#studentName").val()
			var subjectId = $("#subjectId").val();
			var hasDetail = $('input[id="hasDetail"]:checked').val();
			var remark = $('#remark').val();
			if ($("#studentName").val() == "" || $("#studentName").val() == null) {
				$("#studentName").focus();
				$("#studentInfo").text("学生姓名不能为空！");
				return false;
			}else{
				$("#studentInfo").text("");
			}
			
			if($("#examTime").val() == ""){
				$("#examTimeInfo").text("请选择一个考试日期！");
				return false;
			}else{
				$("#examTimeInfo").text("");
			}
			
			if (subjectId == "") {
				$("#subjectInfo").text("请检查科目名称");
				return false;
			}else{
				$("#subjectInfo").text("");
			}
			if(hasDetail == 1){
				var hasEmpty=0;
				$("input[id='scores']").each(function() {
					if($(this).val()==""){
						hasEmpty = 1;
						return false;
					}
				});
				if(hasEmpty==1){
					$("#courseInfo").text("课程分数不能为空");					
					return false;					
				}else{
					$("#courseInfo").text("");
				}
			}else{
				if($("#gross").val()==""){
					$("#gross").focus();
					$("#grossInfo").text("课程分数不能为空");
					return false;
				}else{
					$("#grossInfo").text("");
				}
			}
			$("#gradeForm").attr("action", "/grade/saveGradeRecord");
			$("#gradeForm").submit();
		}
	</script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script>
		//日期范围限制
		var examTime = {
			elem : '#examTime',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : true
		};
		laydate(examTime);
	</script>
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script>
       $('li[ID=nav-nav1]').removeAttr('').attr('class','active');
    </script>
</body>
</html>