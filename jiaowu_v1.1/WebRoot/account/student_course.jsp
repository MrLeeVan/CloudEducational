<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/style.css" rel="stylesheet" />
<link type="text/css" href="/css/jquery.cleditor.css" rel="stylesheet" />
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('student_management')}</title>
<style>
.error {
	color: red;
	width: 150px;
}
</style>
<script type="text/javascript">

	function limitInput(jieshu) {
		var min = $("#yipai").val();
		var max = 500;
		if (parseInt(jieshu) < min) {
			alert('一对一最小节数不能小于已排节数');
			$("#courseSum").val(min);
		}
		if(parseInt(jieshu) > max){
			alert('一对一最大节数不能大于500节数');
			$("#courseSum").val(max);
		}
	}

	var vip="";
	var xb="";
	
	function checkSubject(){
		var teachTypeValue =[]; 
		var subjectIdValue =[];
	    $('input[name="teach_type"]:checked').each(function(){
	    	teachTypeValue.push($(this).val());//将选中的值添加到数组chk_value中 
	    	if($(this).val()==1){
	    		vip="1";
	    		$("#jieshu").show();
	    	}else{
	    		xb="2";
	    	}
	    });
	    $('input[name="subject_id"]:checked').each(function(){
	    	subjectIdValue.push($(this).val());//将选中的值添加到数组chk_value中 
	    });
		if(teachTypeValue.length==0){
			$("#teachTypeMes").text("请选择授课类型");
			$("#courseSum").val(0);
			$("#classtype").empty();
			$("#showcourse").hide();
			$("#jieshu").hide();
			return false;
		}else{
			$("#teachTypeMes").text("");
			if(subjectIdValue.length==0){
				$("#classtype").empty();
				$('#bancishow').empty();
				$("#showcourse").hide();
				$("#showbanci").hide();
				$("#subjectMes").text("请选择授科目");
				return false;
			}else{
				$("#showcourse").show();
				$("#subjectMes").text("");
				var chestr = "";
			    for (i = 0; i < subjectIdValue.length; i++) {
			    	chestr += subjectIdValue[i] + ",";
			    }
			    if (chestr != "") {
			    	if(vip=="1"){
				        $.ajax({
				            url: "/account/getCourseListBySubjectId",
				            data: {
				                "SUBJECT_ID": chestr
				            },
				            type: "post",
				            dataType: "json",
				            success: function(result) {
				                $('#classtype').empty();
				                for (var i = 0; i < result.courses.length; i++) {
				                    var courseName = result.courses[i].COURSE_NAME;
				                    var courseId = result.courses[i].ID;
				                    var subject_name = result.courses[i].SUBJECT_NAME;
				                    var sub_name = "";
				                    if (i == 0) {
				                        sub_name = "<br><label></label>" + "<br>";
				                    }
				                    var str = sub_name + "<label></label>" + "<input type='checkbox' id='classtype" + courseId + "' onclick='checkCourse(" + courseId + ")' name='course_id' value='" + courseId + "'>" + courseName + "<input type='hidden' onclick='clearVal(" + courseId + ")' onchange='checkBlur(" + courseId + ")' id='keshi" + courseId + "' readonly='readonly' disabled='true' name='keshi' size='5'> <span id='courseMsg" + courseId + "'></span>" + "<br>";
				                    $("#classtype").append(str);
				                }
				                $('#showcourse').show();
				                $('#classtype').show();
				                return true;
				            }
				        });
			    	}else{
			    		$("#courseSum").val(0);
						$("#classtype").empty();
						$("#showcourse").hide();
						$("#jieshu").hide();
						return false;
			    	}
			        if(xb=="2"){
			        	$("#showbanci").show();
				        $.ajax({
			                url: "/course/finClassOrder",
			                data: {
			                    "sub_id": chestr,
			                    "stu_id": $('#accountId').val()
			                },
			                type: "post",
			                dataType: "json",
			                success: function(result) {
			                    $('#bancishow').empty();
			                    if (result.record.length > 0) {
			                        for (var i = 0; i < result.record.length; i++) {
			                            var classNum = result.record[i].CLASSNUM;
			                            var class_id = result.record[i].ID;
			                            var class_name = result.record[i].NAME;
			                            var str = "<br>" + "<label></label>" + "<input type='checkbox' id='banci" + class_id + "' name='banci' value='" + class_id + "'>" + classNum + "&nbsp;&nbsp;" + class_name;
			                            $("#bancishow").append(str);
			                            return true;
			                        }
			                    } else {
			                        $("#bancishow").html("<a href='/classtype/addClassOrder'>${_res.get('Add.class.lesson')}</a>");
			                        return false;
			                    }
			                }
			            });
			        }else{
			        	$('#bancishow').empty();
						$("#showbanci").hide();
						return false;
			        }
			    }
			}
		}
	}
</script>
</head>
<body>
<div id="container">
		<div id="primary_right">
			<div class="inner">
				<h3>
					<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;
					 ${_res.get('student_management')}&gt;${_res.get('course_management')}
				</h3>
				<form action="" method="post" id="accountForm">
					<input type="hidden" name="account.id" id="accountId" value="${accountEntity.id}" />
					<fieldset style="width: 850px">
						<h2>${_res.get('courselib.courseMsg')}</h2>
						<c:if test="${empty accountEntity.id}">
							<p id="shoukeleixing">
								<label> 
									 ${_res.get('type.of.class')}:
								</label>
								<input type="checkbox" id="teach_type1" name="teach_type" value="1" onclick="checkSubject()"> ${_res.get("IEP")} 
								<input type="checkbox" id="teach_type2" name="teach_type" value="2" onclick="checkSubject()"> ${_res.get('course.classes')}
								<font color="red"> * 
								<span id="teachTypeMes"></span>
								</font> 
							</p>
							<p id="jieshu" style="display: none" >
								<label>
									${_res.get('IEP')}(${_res.get('pitch.number')})：
								</label>
								<input type="text" name="account.course_sum" id="courseSum" onclick="checkCourseSum2(this.value)"
									${(empty accountEntity.IDS)? "" : "disabled='disabled'"} onchange="checkCourseSum(this.value)"
									
									<c:if test="${empty accountEntity.COURSE_SUM}">value="0"</c:if>
									<c:if test="${!empty accountEntity.COURSE_SUM}">
										value="${accountEntity.COURSE_SUM}"
									</c:if>
									/>
									<font color="red"> * </font> 
							</p>
							<p>
								<label> 
									${_res.get('course.subject')}:
								</label>
								<c:forEach items="${subjects}" var="subject" varStatus="s">
									<input type="checkbox" id="subject${subject.id}" name="subject_id" value="${subject.id}" onclick="checkSubject()">
	                                ${subject.subject_name }
	                                <c:if test="${s.count % 6 == 0 }">
										<br>
										<label></label>
									</c:if>
								</c:forEach>
								<font color="red"> * 
								<span id="subjectMes"></span>
								</font> 
							</p>
							<p id="showcourse" style="display: none" >
								<label> 
									${_res.get('course.course')}:
								</label> 
								<span id="classtype"> </span>
								<font color="red"> * </font> 
							</p>
							<p id="showbanci" style="display: none" >
								<label>${_res.get('Optional.trips')}： </label> <span id="bancishow"> </span>
							</p>
						</c:if>
							<p>
								<a class="button_link" onclick="return saveAccount();"> ${_res.get('save')} </a>
							</p>
					</fieldset>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
