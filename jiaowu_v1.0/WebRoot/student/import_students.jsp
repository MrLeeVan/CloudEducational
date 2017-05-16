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

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<title>导入学生</title>
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
  .file{ position:absolute; top:0; right:80px; height:24px; filter:alpha(opacity:0);opacity: 0;width:260px } 
</style>
</head>
<body>
     <div class="ibox-content">
      
         <div class="file-box"> 
			<form action="" method="post" id="searchForm" enctype="multipart/form-data"> 
				<div style="margin-top:10px">
					<p>
						<label>${_res.get('Select.the.file')}：</label>
						<input type='text' placeholder="${_res.get('Click.Choose.File')}" name='textfield' id='textfield' class='txt' /> 
						<input type="file" name="fileField" class="file" id="fileField" size="10"  style="left: 76px; width:180px;height:28px;"
						 onchange="document.getElementById('textfield').value=this.value" accept="application/vnd.ms-excel" /> 
					</p>
					<p>
						<label>${_res.get("system.campus")}：</label>
						<select name="campusid" id="campusid" class="chosen-select" style="left: 76px; width:180px;height:28px;">
							<c:forEach items="${campusList }" var="campus">
								<option value="${campus.id }">${campus.campus_name }</option>
							</c:forEach>
						</select> <font color="red"> * <span id="campusidMes"> </span></font>
					</p>
					<div style="font-weight: bold;color: #F00;font-size:10px;">${msg}</div>
					<input type='button' onclick="importBook()" class='btn btn-outline btn-primary' value="${_res.get('Opp.Import')}${_res.get('student')}" /> 
					<a href="/excle/students/students_info.xls" class="btn btn-outline btn-success" >${_res.get('Download')}${_res.get('student')}</a>
					<input type="button" onclick="colseRefresh()" class='btn btn-outline btn-primary' value="${_res.get('admin.common.close')}"/>
				</div> 
			</form> 
		  </div>  
     </div>
<!-- Mainly scripts -->
<script src="/js/js/jquery-2.1.1.min.js"></script>
<script src="/js/utils.js"></script>

<script>
		function importBook(){
			if($("#fileField").val().trim()==""||$("#fileField").val()==null){
				alert("请选择文件");
				return false;
			}
			//保存导入
			$("#searchForm").attr("action", "${cxt}/student/saveImportStudents");
		    $("#searchForm").submit();	
		}
		
		function colseRefresh(){
			window.parent.location.reload();
		}
</script>
<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/utils.js"></script>
<script src="/js/dist/timelineOption.js"></script>
	<script>
		
		//-----------------下拉菜单插件
		$(".chosen-select").chosen({
			disable_search_threshold : 20
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

 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
</body>
</html>
