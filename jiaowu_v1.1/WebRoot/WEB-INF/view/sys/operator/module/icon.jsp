<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<link href="/css/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<div>
<form action="/operator/unloadIcon" method="post" id="picture" enctype="multipart/form-data">
	<input type="file" id="file" name="file" onchange="variety(this.value)" class="btn" style="display: none;"></input> <span id="showUpload"></span>
	<div onclick="transfer()" style="width: 62px; height: 62px; border: 1px solid #D6D6D6; float: right; margin-right: 96px; margin-top: 7px; background-color: #2f4050; text-align: center;">
		<c:if test="${code!=0}">
			<div id="pic">
			</div>
		</c:if>
		<c:if test="${code==0}">
			<img  src="/images/lefticon/${url}" style="width: 62px; height: 62px;">
		</c:if>
		<c:if test="${code!=0}">
			<img id="common"   src="/images/touxiang1.png" style="width: 62px; height: 62px;">
		</c:if>
	</div>
	<input type="hidden" id="url" name="url" value="${id}">
</form>
</div>

<script src="/js/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript">
	function transfer() {
		$("#file").click();
	}
	function variety(file) {
		if (file != "") {
			$("#picture").submit();
		}
	}
	 
</script>
	</head>
	</html>