<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="save" content="history">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>账户管理 </title>
<!-- Mainly scripts -->
<style type="text/css">

.lable{
   width: 100px;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
			<div class="row border-bottom yincang" style="margin: 0 0 60px;">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff;">
					   <%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="margin-nav">
				<div class="wrapper wrapper-content animated fadeInRight" style="padding:0 10px 40px">
					<div class="row">
					      <div class="ibox-title" style="margin-bottom: 20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
								<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> 
								&gt;<a href='/operator/personal'>账户管理</a> &gt;账户密码
							</h5>
		  				    <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          					<div style="clear:both"></div>
						  </div>
							<div style="width:100%;background:#fff;padding:15px;margin-top:20px">
								<div style="margin-left: 38%;">
									<h3>账户安全</h3>	
								</div>
								<input type="hidden" id="id" value="${sys.id}">
								<div style="margin-left: 38%;">
									<p>
										<label class="lable">旧密码：</label>
										<input type="password" id="oldpossword" value="">
									</p>
									<p>
										<label  class="lable">新密码：</label>
										<input type="password" id="newpossword" value="">
									</p>
									<p>
										<label  class="lable">确认新密码：</label>
										<input type="password" id="newposswords" value="">
									</p>
									<input type="button" onclick="savePassword()" class="btn btn-ghost btn-primary" value="保存">
								</div>
							</div>
						<div style="clear: both;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
	<script type="text/javascript">
	function savePassword(){
		var oldpossword = $("#oldpossword").val();
		var newpossword = $("#newpossword").val();
		var newposswords = $("#newposswords").val();
		if(oldpossword==""){
			layer.msg("旧密码输入错误，请重新输入",1,2);
			return false;
		} else if(newpossword==""){
			layer.msg("新密码不能为空，请重新输入",1,2);
			return false;
		}else if(newpossword!=newposswords){
			layer.msg("新密码输入不相同，请重新输入",1,2);
			return false;
		}else{
			$.ajax({
				url:'/operator/chackPassword',
				type:'post',
				data:{id:$("#id").val(),'oldpossword':oldpossword},
				dataType:'json',
				success:function(data){
					if(data!=1){
						layer.msg("旧密码输入错误，请重新输入",1,2);
						return false;
					}else{
						$.ajax({
							url:'/operator/savenewPassword',
							type:'post',
							data:{id:$("#id").val(),'newpossword':newpossword},
							dataType:'json',
							success:function(data){
								if(data==1){
									layer.msg("密码修改成功,请重新登陆系统",1,1);
								}else{
									layer.msg("密码修改失败",1,2);
								}
								setTimeout("window.location.href='/account/exit'",1000);
							}
						})
					}
				}
			})
		}
	}
		
	</script>
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/campus.js"></script>

<script>
	$('li[ID=nav-nav11]').removeAttr('').attr('class', 'active');
</script>
</html>

