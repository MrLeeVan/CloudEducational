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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />

<script type="text/javascript">

	function save() {
		if(checkExist('course_name'))
			return false;
		var courseid = $("#courseid").val();
		if(courseid==""){
			$.ajax({
				url:'/course/save',
				type:'post',
				data:$("#courseForm").serialize(),
				dataType:'json',
				success:function(data){
					if(data==1){
						layer.msg("添加成功",1,1);
					}else{
						layer.msg("添加失败",1,2);
					}
					setTimeout("parent.window.location.reload()",1000);
				}
			});
		}else{
			if(confirm("确定要修改该课程信息吗？")){
				$.ajax({
					url:'/course/update',
					type:'post',
					data:$("#courseForm").serialize(),
					dataType:'json',
					success:function(data){
						if(data==1){
							layer.msg("修改成功",1,1);
						}else{
							layer.msg("修改失败",1,2);
						}
						setTimeout("parent.window.location.reload()",1000);
					}
				});
			}
		}
	}
	
	function checkExist(checkField) {
		var checkValue = $("#"+checkField).val();
	    if (checkValue != "") {
	    	var flag = true;
	        $.ajax({
	            url: '${cxt}/course/checkExist',
	            type: 'post',
	            data: {
	                'checkField': checkField,
	                'checkValue': checkValue,
	                'courseid': $("#courseid").val(),
	                'subjectId': $("#courseSubject").val(),
	            },
	            async: false,
	            dataType: 'json',
	            success: function(data) {
	                if (data.result >= 1) {
	                	$("#"+checkField).focus();
                    	$("#"+checkField+"Mes").text("您填写的数据已存在。");
	                }else{
	                	$("#"+checkField+"Mes").text("");
	                	flag = false;
	                } 
	            }
	        });
	        return flag;
	    } else {
	        $("#"+checkField).focus();
	    	$("#"+checkField+"Mes").text("该字段不能为空。");
	        return true;
	    }
	}
	
</script>

<style type="text/css">
body {
	background-color: #eff2f4;
}

select {
	margin-left: 22px;
}

textarea {
	width: 70%;
	margin-left: 15px;
}

label {
	width: 80px;
}
.chosen-container .chosen-results{
    max-height:180px !important;
}
</style>
</head>
<body style="background: #2F4050">
		<div class="float-e-margins">
			<div class="ibox-content">
				<form action="/course/save" method="post" id="courseForm">
					<input type="hidden" name="course.id" id="courseid" value="${course.id }">
					<c:if test="${!empty course.id }">
							<input type="hidden" name="course.version" value="${course.version + 1}">
						</c:if>
					<fieldset>
						<p>
							<label style="width: 95px;"><font color="red"> * </font>${_res.get('course.subject')}:</label> 
							<select id="courseSubject" name="course.subject_id" class="chosen-select" style="width: 150px; margin-left: 15px;" tabindex="2">
								<c:forEach items="${subject}" var="subject">
									<option value="${subject.id }" <c:if test="${subject.id eq course.subject_id }">selected="selected"</c:if>>${subject.subject_name }</option>
								</c:forEach>
							</select>
						</p>
						<p>
							<label><font color="red"> * </font>${_res.get('course.course')}:</label> 
							<input style="margin-left: 15px;" type="text" id="course_name" name="course.course_name" value="${course.course_name}" maxlength="125" vMin="1" vType="length" onblur="onblurVali(this);"  onchange="checkExist('course_name')"/>
							<span id="course_nameMes" style="color: red"></span>
						</p>
						<!-- p>
							<label><font color="red"> * </font>课程单价:</label> 
							<input style="margin-left: 15px;" type="text" id="unitPrice" name="course.unit_price" value="${course.unit_price}" maxlength="4" vMin="0" vType="numberZ" onblur="onblurVali(this);"/>元/${_res.get('session')}
							<span id="unitPriceMes"></span>
						</p -->
						<p>
							<label>${_res.get("course.remarks")}:</label>
							<textarea rows="4" name="course.remark" cols="">${course.remark}</textarea>
						</p>
						<p>
						<c:if test="${operator_session.qx_coursesave }">
							<c:if test="${operatorType eq 'add'}">
								<input type="button" value="${_res.get('save')}" onclick="return save();" class="btn btn-outline btn-success" />
							</c:if>
						</c:if>
						<c:if test="${operator_session.qx_courseupdate }">
							<c:if test="${operatorType eq 'update'}">
								<input type="button" value="${_res.get('update')}" onclick="return save();" class="btn btn-outline btn-success" />
							</c:if>
						</c:if>
						</p>
					</fieldset>
				</form>
			</div>
		</div>
		<div style="clear: both;"></div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

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
<script src="/js/utils.js"></script>

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
        var index = parent.layer.getFrameIndex(window.name);
    	parent.layer.iframeAuto(index);
    </script>
    <script>
       $('li[ID=nav-nav7]').removeAttr('').attr('class','active');
    </script>
</body>
</html>