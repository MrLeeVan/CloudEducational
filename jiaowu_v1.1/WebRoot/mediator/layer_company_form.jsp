<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Add.organization')}</title>
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
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<style type="text/css">
body {
	background-color: #eff2f4;
}
textarea {
	width: 50%;
	font-size:16px;
}
label {
	width: 80px;
}
</style>
</head>
<body>
		<div class="row wrapper border-bottom white-bg page-heading">
			<div class="col-lg-12" style="margin-top: 20px;">
				<form id="companyForm" action="${cxt }/company/save" method="post">
					<fieldset style="width: 100%; padding-top:15px;">
						<input type="hidden" id="companyId" name="company.id" value="${company.id }"/>
						<c:if test="${!empty company.id }">
							<input type="hidden" name="company.version" value="${company.version + 1}">
						</c:if>
						<p>
							<label>${_res.get("Company.Name")}：</label>
							<input type="text" id="companyname" name="company.companyname" value="${company.companyname }" size="20" maxlength="100" vMin="4" vType="checkTestName" onblur="onblurVali(this);" onchange="checkExist('companyname')"/>
							<span id="companynameMes" style="color:red;" >*</span>
						</p>
						<p>
							<label>${_res.get("Company.address")}：</label>
							<input type="text" id="address" name="company.address" value="${company.address }" size="20" maxlength="200" vMin="0" vMax="75" vType="length" onblur="onblurVali(this);" />
							<span id="addressMes" style="color:red;"></span>
						</p>
						<p>
							<label>${_res.get("Contacts")}：</label>
							<input type="text" id="contacts" name="company.contacts" value="${company.contacts }" size="20" maxlength="15" vMin="0" vType="chinaLetterNumber" onblur="onblurVali(this);"/>
							<span id="contactsMes" style="color:red;"></span>
						</p>
						<p>
							<label>${_res.get("admin.user.property.telephone")}：</label>
							<input type="text" id="phonenumber" name="company.phonenumber" value="${company.phonenumber }" size="20" maxlength="15" vMin="0" vType="tellphone" onblur="onblurVali(this);" onchange="checkExist('phonenumber')"/>
							<span id="phonenumberMes" style="color:red;"></span>
						</p>
						<p>
							<label>${_res.get('course.remarks')}：</label> 
							<textarea rows="5" cols="85" name="company.remark"  style="width:440px;overflow-x: hidden; overflow-y: scroll;">${fn:trim(company.remark)}</textarea>
						</p>
						<p>
						<c:if test="${operator_session.qx_companysave }">
						<c:if test="${operatorType eq 'add'}">
							<input type="button" value="${_res.get('save')}" onclick="return save();" class="btn btn-outline btn-primary" />
						</c:if></c:if>
						<c:if test="${operator_session.qx_companyupdate }">
						<c:if test="${operatorType eq 'update'}">
							<input type="button" value="${_res.get('update')}" onclick="return save();" class="btn btn-outline btn-primary" />
						</c:if>
						</c:if>
							<input type="button" onclick="window.history.go(-1)" value="${_res.get('system.reback')}" class="btn btn-outline btn-success">
						</p>
					</fieldset>
				</form>
			</div>
		</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<script>
		function checkExist(checkField) {
			var checkValue = $("#"+checkField).val();
		    if (checkValue != "") {
		    	var flag = true;
		        $.ajax({
		            url: '${cxt}/company/checkExist',
		            type: 'post',
		            data: {
		                'checkField': checkField,
		                'checkValue': checkValue,
		                'companyId': $("#companyId").val()
		            },
		            async: false,
		            dataType: 'json',
		            success: function(data) {
		                if (data.result >= 1) {
		                	$("#"+checkField).focus();
	                    	$("#"+checkField+"Mes").text("您填写的数据已存在。");
		                }else{
		                	$("#"+checkField+"Mes").text("");
		                	flag = false;
		                } 
		            }
		        });
		        return flag;
		    } else {
		        $("#"+checkField).focus();
		    	$("#"+checkField+"Mes").text("该字段不能为空。");
		        return true;
		    }
		}
		
		function save() {
			if(checkExist('companyname'))
				return false;
			var companyId = $("#companyId").val();
			if(companyId==""){
				//$("#companyForm").submit();
				$.ajax({
                	type:"post",
					url:"${cxt}/company/save",
					data:$('#companyForm').serialize(),
					datatype:"json",
					success : function(data) {
						 if(data.code=='0'){
							layer.msg(data.msg,2,5);
						}else{
							setTimeout("parent.layer.close(index)", 3000);
							parent.window.location.reload();
						} 
					}
                });
			}else{
				if(confirm("确定要修改该机构信息吗？")){
					/* $("#companyForm").attr("action", "/company/update");
					$("#companyForm").submit(); */
					$.ajax({
	                	type:"post",
						url:"${cxt}/company/update",
						data:$('#companyForm').serialize(),
						datatype:"json",
						success : function(data) {
							 if(data.code=='0'){
								layer.msg(data.msg,2,5);
							}else{
								setTimeout("parent.layer.close(index)", 3000);
								parent.window.location.reload();
							} 
						}
	                });
				}
			}
		}
		
		
	</script>
	<script src="/js/utils.js"></script>
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script>
       $('li[ID=nav-nav8]').removeAttr('').attr('class','active');
       
     //弹出后子页面大小会自动适应
       var index = parent.layer.getFrameIndex(window.name);
       parent.layer.iframeAuto(index);
    </script>
</body>
</html>