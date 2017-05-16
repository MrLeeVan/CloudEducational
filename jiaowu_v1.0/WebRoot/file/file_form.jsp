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
<link href="/css/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet"> 

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('Adding.document')}</title>
<style>
label{
  width:80px
}
.input-text{ 
height: 23px; 
line-height: 23px; 
vertical-align: middle; 
background: #FAFBFD; 
border:1px solid #d4d4d4; 
} 
.link-btn{
 position: absolute;
 top:0;
 left:290px 
} 
.file-uploader-wrap{ 
position: relative; 
} 
.file-uploader-wrap-fake{ 
position: absolute; 
top: 0px; 
left: -13px; 
z-index: 1; 
_display : none; 
} 
.file-uploader-wrap .file-uploader{ 
position: relative;
top:-15px;
left:85px; 
width: 263px; 
height: 27px; 
text-align: right; 
filter : alpha(opacity = 0); 
opacity: 0; 
z-index: 2; 
cursor: pointer; 
_filter : none; 
_text-align : left; 
_line-height : 27px; 
} 
.chosenfile{
  position: absolute;
  top:10px
}
</style>
<script>
window.onload = function(){ 
	var fileUploader = document.getElementById('FileUploader'); 
	var pathDisplayer = document.getElementById('PathDisplayer'); 
	if(fileUploader.addEventListener){ 
		fileUploader.addEventListener('change', fileUploaderChangeHandler, false); 
	}else if(fileUploader.attachEvent){ 
		fileUploader.attachEvent('onclick', fileUploaderClickHandler); 
	}else{ 
		fileUploader.onchange = fileUploaderChangeHandler; 
	} 
	function fileUploaderChangeHandler(){ 
		pathDisplayer.value = fileUploader.value; 
	} 
	function fileUploaderClickHandler(){ 
		setTimeout(function(){ 
			fileUploaderChangeHandler(); 
		}, 0); 
	} 
} 
</script> 
</head>
<body>
     <div>
        <div class="ibox-content">
            <form action="" method="post" id="">
					<fieldset>
						<p>
							<label>${_res.get('File.name')}：</label> 
							<input type="text" name="" id="" value="默认回填家长邮箱"  style="font-size:14px"/>
						</p>
						<p class="clear">
							<label>${_res.get('student')}：</label>
							<select>
							  <option>张同学</option>
							  <option>李同学</option>
							  <option>王同学</option>
							</select>
						</p>
						<p>
							<label>${_res.get('Document.Type')}：</label> 
							<input type="text" name="" id="" value="成绩单"  style="font-size:14px"/>
						</p>
						<p style="position: relative;">
							<label class="chosenfile">${_res.get('Select.Document')}： </label>
							<div class="file-uploader-wrap"> 
					　　　　　　<input type="file" class="file-uploader" name="uploadDataField" id="FileUploader"/> 
					　　　　　　<div class="file-uploader-wrap-fake"> 
					　　　　　　　　<input type="text" id="PathDisplayer" class="input-text" disabled /> 
					　　　　　　　　<a href="javascript:void(0)" class="btn btn-sm btn-warning link-btn" >${_res.get('Select.the.file')}</a> 
					　　　　　　</div> 
					　　　　</div>
						</p>
						<input type="button" value="${_res.get('Upload')}"  class="btn btn-outline btn-info">
					</fieldset>
				</form>
          </div>
	   </div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/utils.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script>
        //弹出后子页面大小会自动适应
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.iframeAuto(index);
 </script>
 
</body>
</html>
