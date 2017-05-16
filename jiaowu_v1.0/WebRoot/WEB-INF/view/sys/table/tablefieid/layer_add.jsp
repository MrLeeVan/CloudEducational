<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
 <%@ include file="/common/headExtraction.jsp"%>
<title>添加表字段</title>
</head>
<body style="background: white;">
	<div class="ibox float-e-margins">
		<div class="ibox-content">
			<form action="${cxt}/system/tablefieid/save" method="post" id="submitForm">
				<%@ include file="form.jsp"  %>
				<div class="control-group m-t-sm flt">
					<input type="button" value="保存" id="submitButton" class="btn btn-outline btn-primary" />
				</div>
				<div style="clear:both;" ></div>
			</form>
		</div>
	</div>
</body>
</html>
