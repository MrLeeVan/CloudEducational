<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" /> 
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/jquery-2.1.1.min.js"></script>
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/jquery-2.1.1.min.js"></script>


<script type="text/javascript">
</script>
<title>用户类型</title>
<style>
.error {
	color: red;
	width: 150px;
}
</style>
</head>
<body>
   <div style="background:#fff;height:86px">
		     		<input type="hidden" name="addupdate" id="addupdate" value="${addupdate}" >
					<input type="hidden" name="id" id="id" value="${type.id}" />
					<input type="hidden" name="version" id="version" value="${type.version + 1}" />
						<p style="position:absolute;top:18px;left:20px">
							<label style="font-size: 14px;" >${_res.get('admin.dict.property.name')}：</label> 
							<input type="text" id="name" name="name" value="${type.name }" onchange="checkExist(this.value)" style="font-size: 14px; color: #0099FF">
							<font color="red">*</font>
						</p>
						<c:if test="${addupdate eq 'add'}">
							<input type="button" value="${_res.get('save')}" onclick="save()"  style="position:absolute;top:15px;left:260px"  class="btn btn-outline btn-primary" />
						</c:if>
						<c:if test="${addupdate eq 'update'}">
							<input type="button" value="${_res.get('update')}" onclick="save()"  style="position:absolute;top:15px;left:260px"  class="btn btn-outline btn-primary" />
						</c:if>
  </div>
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/utils.js"></script>
    <script type="text/javascript">
    	function save(){
    		var name = $("#name").val();
    		var addupdate = $("#addupdate").val();
    		var id = $("#id").val();
    		if(name.trim()==""){
    			alert("名称不能为空");
    			return false;
    		}else{
	    		if(id==""){
					if(confirm("确定要添加该名称吗？")){
						$.ajax({
							url:"/sysuser/saveType",
			    			type:"post",
			    			data:{'name':name,'addupdate':addupdate,'id':id},
			    			dataType:"json",
			    			success:function(data) {
			    				if(data.code=='0'){
			    					layer.msg("信息保存异常",2,5);
			    				}else{
			    					setTimeout("parent.layer.close(index)", 3000);
									parent.window.location.reload();
			    				}
			    				
			    			}
						});
					}
				}else{
					if(confirm("确定要修改该名称吗？")){
						$.ajax({
							url:"/sysuser/saveType",
			    			type:"post",
			    			data:{'name':name,'addupdate':addupdate,'id':id},
			    			dataType:"json",
			    			success:function(data) {
			    				if(data.code=='0'){
			    					layer.msg("信息保存异常",2,5);
			    				}else{
			    					setTimeout("parent.layer.close(index)", 3000);
									parent.window.location.reload();
			    				}
			    				
			    			}
						});
					}
				}
    		}
    	}
    	
    	function checkExist(value){
    		if(value!=""){
    			var flag = false;
    			$.ajax({
    				url:"/sysuser/checkExistTypeName",
    				dataType:"json",
    				type:"post",
    				async: false,
    				data:{"name":$("#name").val()},
    				success:function(data){
    					if(data.code=='0'){
    						flag = false;
    					}else{
    						layer.msg("该名称已存在,请更换。",2,2);
    						$("#name").val("");
    						$("#name").focus();
    						flag = true;
    					}
    				}
    			});
    			return flag;
    		}else{
    			return true;
    		}
    	}
    	
    </script>
</body>
</html>