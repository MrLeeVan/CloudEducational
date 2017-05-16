<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('teacher.group.add')}&${_res.get('Modify.course')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">

	function addCourseManager() {
		if($("#courseNameMsg").html()!="")
		{
			alert("请检查课程名称");
			return false;
		}
		if ($("#courseName").val() == ""||$("#courseName").val() == null) {
			alert("请填写课程名称");
			return false;
		}
		if ($("#courseSubject").val() == 0) {
			alert("请选择科目");
			return false;
		}
		$("#addCourseForm").attr("action", "/course/doAddCourseManager");
		$("#addCourseForm").submit();
		
	}
	function checkCourseName()
	{
		var courseName=$("#courseName").val();
		if(courseName!=null&&courseName!="")
		{
			if('${courseName}'!=null&&courseName=='${courseName}')
			{
				return;
			}
			$.ajax({
				url:"/course/checkCourseName",
				type:"post",
				data:{"courseName":courseName},
				dataType:"json",
				success:function(data)
				{
					if(data)//课程名已存在
					{
						$("#courseNameMsg").html("课程名称已存在");
					}
				}
			});
		}
	}
	function clearMsg()
	{
		$("#courseNameMsg").html("");
	}
</script>

<style type="text/css">
body{
 background-color:#eff2f4;
}
select{
 margin-left:22px;
}
textarea{
 width: 50%;
 margin-left:15px;
}
label{
 width: 80px;
}
</style>
</head>
<body>
<div id="wrapper" style="min-width:1100px">
  <div class="row border-bottom">
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <div class="navbar-header" style="margin:10px 0 0 30px;">
            <h5><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; <a href="/course/index"">${_res.get('course_management')}</a>&gt; ${_res.get('teacher.group.add')}&amp;${_res.get('Modify.course')}</h5>
            <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
            <div style="clear:both"></div>
        </div>
     </nav>
  </div>
  
  <div class="row border-bottom white-bg page-heading" style="width:550px;margin-top:100px;margin-left:14px;">
     <div class="col-lg-10" style="margin-top:20px;">
       <form action="" method="post" id="addCourseForm">
		<input type="hidden" name="id" id="id" value="${id }">
		 <fieldset style="width: 820px; overflow: hidden;">
         <p>
		  <label style="width:95px;"><font color="red"> * </font>${_res.get('course.subject')}:</label>
			<select id="courseSubject" name="courseSubject" class="chosen-select" style="width:150px;margin-left:15px;" tabindex="2">
				<option value="0">${_res.get('system.alloptionss')}</option>
			<c:forEach items="${subject}" var="subject">
				<option value="${subject.id }" <c:if test="${subject.id eq subjectId }">selected="selected"</c:if> >${subject.subject_name }</option>
			</c:forEach>
		   </select>
		 </p>
		 <p>
		   <label><font color="red"> * </font>${_res.get('course.course')}:</label> 
			 <input style="margin-left:15px;" type="text" id="courseName" name="courseName" value="${courseName}" onblur="checkCourseName()" onfocus="clearMsg()"/>
				<span id="courseNameMsg" style="color:red"></span>
		</p>
		<p>
		   <label>${_res.get('Brief.introduction')}:</label>
		   <textarea rows="4" name="courseIntro" cols="">${intro}</textarea>
	   </p>
	   <p>
		   <label>${_res.get('course.remarks')}:</label>
		   <textarea rows="4" name="courseRemark" cols="">${remark}</textarea>
	   </p>
	   <p>
	   <c:if test="${operator_session.qx_course/doAddCourseManager }">
		   <input type="submit" value="${_res.get('save')}" onclick="return addCourseManager();" class="btn btn-outline btn-success" />
	   </c:if>
	  </p>
	  </fieldset>
	</form>
   </div>
  </div>  
</div>

    <!-- Mainly scripts -->
    <script src="js/jquery-2.1.1.min.js"></script>
    <!-- Chosen -->
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

    <script>
    $(".chosen-select").chosen({disable_search_threshold:30});
        var config = {
            '.chosen-select': {},
            '.chosen-select-deselect': {
                allow_single_deselect: true
            },
            '.chosen-select-no-single': {
                disable_search_threshold: 10
            },
            '.chosen-select-no-results': {
                no_results_text: 'Oops, nothing found!'
            },
            '.chosen-select-width': {
                width: "95%"
            }
        }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }   
    </script>

</body>
</html>