<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文件下载 File download</title>
</head>
<body>
<h1>文件预览 File Preview</h1>
<input type="button" value="手动导出 export" onclick="myhtmlsubmit()">
<p>注意:打开文件时如果提示"文件格式和扩展名不匹配.... 是否仍要打开它?" 选择: 是(Y) </p>
<p>Note: when you open the file, if the file format and extension do not match... Do you still want to open it? "Select:" (Y)</p>
<form style="display:none" id="toxls" method="post" action="/tool/excel/toxls" enctype="multipart/form-data">
    <textarea id="myhtml" name="html" ></textarea>
    <input type="text" name="name" value="${name }" />
</form>
<div id="preview" style='${preview=="preview"?"":"display:none"}'></div>
<script type="text/javascript" src="/jquery/jquery-2.1.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$.post("${downloadUrl}", 
	   function(data){
			$("#preview").html(data);
			$(document).ready(function(){
				myhtmlsubmit();
			});
	   });
});

function myhtmlsubmit(){
	$("#myhtml").val($("#preview").html());
	$("#toxls").submit();
}

</script>
</body>
</html>