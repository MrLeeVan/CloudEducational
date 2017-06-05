<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Change.password')}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" /> 
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet"/>
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet"/>
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style>
label{
  width:80px;
}
input{
  height:34px;
}
body{
  background-color:#E7EAEC
}
</style>
<script type="text/javascript">
	function doSubmit(){
		var newPwd=$("#newPwd").val();
		var accountId=$("#accountId").val();
		if(newPwd.length<6){
			alert("密码长度须大于6位");
			return;
		}
		if(newPwd!=$("#newPwd2").val()){
			$("#newPwd2").val("");
			alert("密码不一致，请重新输入");
			return;
		}
		$.ajax({
			url:"/account/doUpdateUserPwd",
			type:"post",
			dataType:"json",
			data:{"newPwd":newPwd,"accountId":accountId},
			async:false, 
			success:function(data)
			{
				if(data)
				{
					$("#successMsg").html("操作成功");
				}
				else
				{
					$("#successMsg").html("操作失败");
				}
			}
		});
	}
</script>
</head>
<body>
  <div style="margin-left:0;margin-top:20px;">
   <div class="m-l-14" style="width:350px;">
     <div class="float-e-margins">
        <div class="ibox-title">
           <h4>${_res.get('Modify')}</h4>
        </div>
        <div class="ibox-content">
           	<form action="" method="post" name="updateForm" id="updateForm">
	<fieldset>
		<c:if test="${param.accountId==null}">
		<p>
			<label><font color="red">*</font>登录名:</label>
			<input  type="text" disabled="disabled" name="account.email" id="email" value="${account_session.email}"  />
		</p>
		</c:if>
		<p>
			<label><font color="red">*</font>${_res.get("passWord")}:</label>
			<input  type="password" name="newPwd" id="newPwd"  maxlength="20" class="required" />
		</p>
		<p>
			<label><font color="red">*</font>重复密码:</label>
			<input  type="password" name="newPwd2" id="newPwd2"  maxlength="20" class="required" />
		</p>
		<p>
			<span id="successMsg" style="color:red"></span>
		</p>
		<p>
			<c:choose>
				<c:when test="${param.accountId!=null}">
					<input type="hidden" id="accountId" name="accountId" value="${param.accountId}"/>
				</c:when>
				<c:otherwise>
					<input type="hidden" id="accountId" name="accountId" value="${account_session.id}"/>
				</c:otherwise>
			</c:choose>
		    <c:if test="${operator_session.qx_accountdoUpdateUserPwd }">
				<input type="button" onclick="doSubmit()" value="${_res.get('save')}" class="btn btn-success btn-outline btn-sm"/>
		    </c:if>
		</p>
	</fieldset>
	</form>
        </div>
     </div>
   </div>
   <div style="clear: both;"></div>     
  </div> 

 <!-- Mainly scripts -->
    <script src="/js/js/jquery-2.1.1.min.js"></script>
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
</body>
</html>