<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<title>导入课程</title>
<style>
   body{
    color:#555;
    background:#fff
   }
  .font-med{
    font-size: 16px;
    font-weight: 500
  }
  .file-box{ position:relative;width:480px;margin-top:10px} 
  .txt{ height:22px; border:1px solid #cdcdcd; width:180px;} 
  .file{ position:absolute; top:0; right:80px; height:50px; filter:alpha(opacity:0);opacity: 0;width:260px } 
</style>
<%@ include file="/common/headExtraction.jsp" %>
</head>
<body>
     <div class="ibox-content">
         <div class="file-box"> 
			<form action="" method="post" id="searchForm" enctype="multipart/form-data"> 
				<div style="margin-top:10px">
					  <p>
						<label>科目：</label>
						<select name="subjectids" id="subjectids" data-placeholder="请选择(可多选)" class="chosen-select" multiple style="width: 300px;" tabindex="1" >
							<c:forEach items="${subjects }" var="subject">
								<option value="${subject.id }" ${subjectid == subject.id ? 'selected="selected"':''}>${subject.SUBJECT_NAME }</option>
							</c:forEach>
						</select> <font color="red"> * <span id="courseidMes"> </span></font>
					</p>
				    <p>
						<label>${_res.get('Select.the.file')}：</label>
						<input type="text" placeholder="${_res.get('Click.Choose.File')}" name='textfield' id='textfield' class='txt'/> 
						<div hidden="hidden"><input type="file" name="fileField" id="fileField" 
						 onchange="document.getElementById('textfield').value=this.value" accept="application/vnd.ms-excel" /></div>
					</p>
					<div style="font-weight: bold;color: #F00;font-size:10px;">${msg}</div>
					<input type='button' onclick="importBook()" class='btn btn-outline btn-primary' value="${_res.get('Opp.Import')}课程" /> 
					<a class='btn btn-outline btn-primary' href="/excle/subject/courses_info.xls">  下载导入模版</a>
					<input type="button" onclick="colseRefresh()" class='btn btn-outline btn-primary' value="${_res.get('admin.common.close')}"/>
				</div> 
			</form> 
		  </div>  
		<div style="clear: both;"></div>
     </div>
<script type="text/javascript">

		$(document).ready(function(){
			if("${msg}" == ""){
				$("#fileField").trigger("click");
			}
			$("#textfield").click( function () { $("#fileField").trigger("click"); });
		});
		
		function importBook(){
			if($("#fileField").val().trim()==""||$("#fileField").val()==null){
				alert("请选择文件");
				return false;
			}
			//保存导入
			$("#searchForm").attr("action", "${cxt}/subject/saveImportCourses");
		    $("#searchForm").submit();	
		}
		
		function colseRefresh(){
			window.parent.location.reload();
		}
</script>

</body>
</html>
