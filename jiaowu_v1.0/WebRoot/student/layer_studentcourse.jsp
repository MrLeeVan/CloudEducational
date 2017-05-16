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
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style>
  .chosen-container .chosen-results{max-height:100px !important}
</style>
</head>
<body style="background-color:#EFF2F4">
	<div style="padding:10px">
			<div class="ibox-title">
				<h5>${student.real_name }${_res.get('Students.course.choice')}</h5>
			</div>
			<div class="ibox-content">
				<form action="" method="post" id="courseSelectForm">
				<input id="studentid" name="studentid" type="hidden" value="${student.id }" >
					<fieldset >
					<c:forEach items="${subjectlist }" var="subject" varStatus="index" >
						<div class="form-group">
						<label class="col-sm-2 control-label">${subject.SUBJECT_NAME }</label>
						<c:if test="${empty subject.courseList }">
						<label class="checkbox-inline ">无课程</label>
						</c:if>
						<c:forEach items="${subject.courseList}" var="course">
							<label class="checkbox-inline ">
								<input type="checkbox" id="courseId" name="courseId" value="${course.id }"
								${course.choose?"checked='checked'":'' } ${course.isUse?"disabled='disabled'":'' } />${course.course_name}
								<c:if test="${course.isUse }">(已排课)</c:if>
							</label>
						</c:forEach>
						</div>
						<div class="hr-line-dashed"></div>
					</c:forEach> 
					<p>
						<input type="button" value="${_res.get('save')}" onclick="updateUserCourse()" class="btn btn-outline btn-primary" />
					</p>
					</fieldset>
				</form>
			</div>
		<div style="clear: both;"></div>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>

	<script>
		var index = parent.layer.getFrameIndex(window.name);

		function updateUserCourse() {
			$("input[type='checkbox']").attr('disabled', false);
			$.ajax({
				url:"/student/setStudentCourse",
				dataType:"json",
				type:"post",
				data:$("#courseSelectForm").serialize(),
				success:function(result){
					if(result.code=="1"){
						parent.layer.msg("保存成功",2,1);
					}else{
						parent.layer.msg("未保存成功",2,2);
					}
					parent.layer.close(index);
				}
				
			});
		}
	</script>
</body>
</html>
