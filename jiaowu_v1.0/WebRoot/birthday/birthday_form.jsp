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
<style>
label{
  width:80px
}
.floalet{
  float: left
}
.clear{
  clear: both
}
</style>
</head>
<body>
     <div>
        <div class="ibox-content">
            <form action="" method="post" id="">
					<fieldset>
						<input type="hidden" id="id" name="id" value="${student.id}">
						<p>
							<label>${_res.get('student')}：</label> 
							<input type="text" name="name" id="name" value="${student.real_name}" disabled style="cursor: not-allowed;color:#b2b2b2;font-size:14px"/>
						</p>
						<p class="clear">
							<label>${_res.get('telphone')}：</label>
							<input id="tel" type="text" name="tel" value="${student.tel}" disabled style="cursor: not-allowed;color:#b2b2b2;font-size:14px"/>
						</p>
						<p class="clear">
							<label class="floalet">${_res.get('Greetings')}： </label>
							<textarea rows="4" cols="55" id="birthdayMessage" name="birthdayMessage" class="floalet" style="margin-left:3px"></textarea>
						</p>
						<input type="button" value="${_res.get('Sent')}" onclick="sendMessage()" class="btn btn-outline btn-info" style="float: right;margin-top:10px">
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
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script>
        //弹出后子页面大小会自动适应
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.iframeAuto(index);
 	</script>
 	 <script>
 	 	function sendMessage(){
 	 		var str = $("#birthdayMessage").val();
 	 		if(str.trim()==''){
 	 			layer.msg("请填写祝福信息",1,2);
 	 			return false;
 	 		}else{
 	 			$.ajax({
 	 				url:'/student/sendMessage',
 	 				type:'post',
 	 				data:{
 	 					"id":$("#id").val(),
 	 					"studentname":$("#name").val(),
 	 					"tel":$("#tel").val(),
 	 					"message":str
 	 					},
 	 				dataType:'json',
 	 				success:function(data){
 	 					if(data.code==1){
 	 						layer.msg("短信祝福发送成功",1,1);
		        			setTimeout("parent.window.location.reload()",1000);
 	 					}else{
 	 						layer.msg("短信发送失败",2,2);
 	 						setTimeout("parent.window.location.reload()",1000);
 	 					}
 	 				}
 	 			});
 	 		}
 	 	}
 	 
 	 
 	 </script>
</body>
</html>
