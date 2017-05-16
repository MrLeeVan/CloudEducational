<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css"
	rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 30
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
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		$('#saveModifyScore').click(function(){
			if(confirm("确定更新？")){
				//$("#id").attr('disabled',false);
				$.ajax({
					type:"post",
					url:"${cxt}/grade/saveModifyScores",
					data:$('#gradeScoreForm').serialize(),// 你的formid
					datatype:"json",
					success : function(data) {
						 if(data.code=='0'){
							layer.msg(data.msg,2,5);
						}else{
							setTimeout("parent.layer.close(index)", 3000);
							parent.window.location.reload();
						} 
					}	
				});
			}
		});
	});
	function checkNumber(number){
		var r =/^[0-9]+(.[0-9]{2})?$/;
		if(!r.test(number)||number<0||number>800){
			alert("分数填写不规范");
			return false;
		}
	}
	</script>
<title>${_res.get('Modify')}</title>
<style type="text/css">
body {
	background-color: #eff2f4;
}

.student_list_wrap {
	position: absolute;
	top: 28px;
	left: 14.8em;
	width: 130px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
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
<body>
	<div id="wrapper">
		<div class="ibox-content">
			<form id="gradeScoreForm" action="" method="post">
				<input type="hidden"  id="id"  name="gradeRecord.id"  value="${graderecord.id}">
				 <input type="hidden" id="hasdetail" name="gradeRecord.hasdetail" value="${graderecord.hasdetail}"/>
				<fieldset style="width: 100%; padding-top: 15px;">
					<p>
						<label><font color="red"> * </font>${_res.get("student.name")}:</label> <input type="text" id="studentname" name="gradeRecord.studentname" 
						value="${graderecord.studentname}" disabled size="20" maxlength="15" />
					</p>
					<p>
						<label><font color="red"> * </font>${_res.get("Exam.time")}:</label> <input type="text" id="examdate" name="gradeRecord.examdate"
							value="${graderecord.examdate}" disabled  size="20" maxlength="15" />
					</p>
					<p>
						<label><font color="red"> * </font>${_res.get("course.subject")}:</label> <input type="text" id="subjectname" 
						name="gradeRecord.subjectname" value="${graderecord.subjectname}"  disabled size="20" maxlength="15" /></br>
					</p>
					
					<c:choose>
						<c:when test="${flag==true}">
							<c:forEach items="${gradeList}" var = "grade">
							<label>${grade.COURSENAME}：</label> 
							<input type="text" id="s_${grade.ID}" name="s_${grade.ID}"    value ="${grade.SCORE}"  onchange="checkNumber(this.value)" style="width: 60px;size=10;">
						</c:forEach>
					</c:when>
						<c:when test="${flag!=true}">
							 <label><font color="red"> * </font>${_res.get('total.score')}:</label>
							 <input type="text" id="grossscore" name="gradeRecord.grossscore" value="${graderecord.grossscore}"   size="20" maxlength="15" />
						 </c:when>
					</c:choose>
					<c:if test="${operator_session.qx_gradesaveModifyScores }">
					<p>
						<input id="saveModifyScore" type="button" value="${_res.get('update')}" class="btn btn-outline btn-primary" />
					</p>
					</c:if>
				</fieldset>
			</form>
		</div>
	</div>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script>
		$('li[ID=nav-nav1]').removeAttr('').attr('class', 'active');
	</script>
</body>
</html>