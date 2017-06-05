<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<title>${_res.get('courselib.studentMsg')}</title>
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
</head>
<body style="background: white;">
	<div class="ibox float-e-margins" style="margin-bottom: 0">
		<div class="ibox-content" style="padding-bottom: 0">
			<form action="" method="post" id="teacherForm">
				<input type="hidden" id="id" value="${r.id}" />
				<fieldset>
					<p>
						<label>回复信息： </label> 
						<input type="text" style="width: 400px;" id="reply" value="${r.reply}" />
					</p>
				</fieldset>
				<input type="button"  onclick="replyMessage()" class="btn btn-outline btn-info " value="回复">
			</form>
		</div>
	</div>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script>
		function replyMessage(){
			var id=$("#id").val();
			var reply=$("#reply").val();
			$.ajax({
				url:'/teacher/replyMessage',
				type:'post',
				data:{'id':id,'reply':reply},
				dataType:'json',
				success:function(data){
					if(data==1){
						layer.msg("回复成功",1,1);
					}else{
						layer.msg("回复失败",1,2);
					}
					setTimeout("parent.window.location.reload();",1000);
				}
			})
		}
	</script>
</body>
</html>