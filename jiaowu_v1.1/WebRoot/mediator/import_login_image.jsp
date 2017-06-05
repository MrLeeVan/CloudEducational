<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="/js/js/jquery-2.1.1.min.js"></script>
<style>
.btn {
    -moz-user-select: none;
    background-image: none;
    border: 1px solid transparent;
    border-radius: 4px;
    cursor: pointer;
    display: inline-block;
    font-size: 14px;
    font-weight: 400;
    line-height: 1.42857;
    margin-bottom: 0;
    padding: 6px 12px;
    text-align: center;
    vertical-align: middle;
    white-space: nowrap;
    background-color: #1dc5a3;
    border-color: #1dc5a3;
    color: #ffffff;
}
</style>
<img src="${url}/images/logo/logo_login.png"  width="190px" alt="请上传登陆log">
<div >
	<div style="font-weight: bold;color: #F00;">提示1:上传的图片必须使用PNG格式透明底色<br/>提示2:分辨率:300*57 文件大小:50KB以内</div>
	<div id="mmsg" style="font-weight: bold;color: #F00;">${msg }</div>
		
	<form action="${cxt}/organization/saveUpdateImage" method="post" id="searchForm" enctype="multipart/form-data"> 
		<div style="margin-bottom: 20px;">
			<samp>请选择文件：</samp> 
			<input type="file" name="fileField" class="file" id="fileField" accept="image/x-png"/> 
		</div>
		<div>
			<input type="hidden" name="type" id="type" value="login">
			<input type="button" id="importButton" class="btn" value="保存图片" />
		</div>
	</form>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#importButton").click(function (){
			var fileField=$("#fileField").val();
			var mmsg = $("#mmsg");
			if(fileField.trim()==""||fileField==null){
				mmsg.text("重要提示:请点击【浏览】按钮选择上传的png文件");
				return false;
			}
			$("#searchForm").submit();
		});
	});
</script>