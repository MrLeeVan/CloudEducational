<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>

<title>${_res.get('subject_management')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/plugins/layer/layer.min.js"></script>
<script>
       layer.use('extend/layer.ext.js'); //载入layer拓展模块
</script>
<script type="text/javascript">
	function addSubjectManager() {
		if($("#subjectName").val() == ""||$("#subjectName").val() == null) {
			alert("请填写科目名称");
			return false;
		}
		if($("#subjectNameMsg").html()!="")
		{
			alert("请检查科目名称");
			return false;
		}
		$.ajax({
			url:'/subject/doAddSubjectManager',
			type:'post',
			data:$("#addSubjectForm").serialize(),
			dataType:'json',
			success:function(data){
				if(data==1){
					layer.msg("成功",1,1);
				}else{
					layer.msg("失败",1,2);
				}
				setTimeout("parent.window.location.reload()",1000);
			}
		});
	}
	function checkSubjectName()
	{
		var subjectName=$("#subjectName").val();
		if(subjectName!=null&&subjectName!="")
		{
			if('${subjectName}'!=null&&subjectName=='${subjectName}')
			{
				return;
			}
			$.ajax({
				url:"/subject/checkSubjectName",
				type:"post",
				data:{"subjectName":subjectName},
				dataType:"json",
				success:function(data)
				{
					if(data)//科目名已存在
					{
						$("#subjectNameMsg").html("科目名称已存在");
					}
				}
			});	
		}
	}
	function clearMsg()
	{
		$("#subjectNameMsg").html("");
	}
</script>
<style type="text/css">
label{
  width:80px;
}
</style>
</head>
<body>
     <div class="float-e-margins">
        <div class="ibox-content">
           <form action="/subject/doAddSubjectManager" method="post" id="addSubjectForm">
					<input type="hidden" name="id" id="id" value="${id}">
					<fieldset>
						<p>
							<label><font color="red"> * </font>${_res.get('name.of.subject')}:</label> 
							<input type="text" id="subjectName" name="subjectName" value="${subjectName}" onblur="checkSubjectName()" onfocus="clearMsg()"/>
							<span id="subjectNameMsg" style="color:red"></span>
						</p>
						<p>
						<c:if test="${operator_session.qx_subjectdoAddSubjectManager }">
							<input type="button" value="${_res.get('save')}" onclick="return addSubjectManager();"  class="btn btn-outline btn-success"/>
						</c:if>
						</p>
					</fieldset>
			</form>
        </div>
     </div>
<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script>
       $('li[ID=nav-nav7]').removeAttr('').attr('class','active');
    </script>        
</body>
</html>