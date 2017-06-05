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
<title>账户管理</title>
<!-- Mainly scripts -->
<style type="text/css">
ul, ol, li {
	list-style: none;
}
.basicmess{
    font-weight: 100;
    margin:5px 15px
}
</style>
</head>
<body >
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
								&gt;<a href='/operator/personal'>账户管理</a> &gt;个人信息
							</h5>
		  				    <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          					<div style="clear:both"></div>
						  </div>
							<div style="width:100%;background:#fff;padding:15px;margin-top:20px">
								<div style="margin-left: 40%;">
									<h4>账号信息</h4>	
								</div>
								<div style="margin-left: 40%;">
									<input type="hidden" id="id" value="${sys.id}">
									<p>
										<label>姓名：</label>
										<input type="text" id="name" value="${sys.real_name}" onblur="check('name')">
									</p>
									<p>
										<label>职位：</label>${roles}
									</p>
									<p>
										<label>电话：</label>
										<input type="text" id="tel" value="${sys.tel}" onblur="check('tel')">
									</p>
									<p>
										<label>性别：</label>
										<input type="radio" name="sex" <c:if test="${sys.sex==1}">checked="checked"</c:if> value="1">男
										<input type="radio" name="sex" <c:if test="${sys.sex==0}">checked="checked"</c:if> value="0">女
									</p>
									<p>
										<label>邮箱：</label>
										<input type="text" id="email" value="${sys.email}" onchange="check('email')">
									</p>
									<input type="button"  onclick="saves()" class="btn btn-ghost btn-primary" value="保存">
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
    
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/campus.js"></script>
	<script type="text/javascript">
	function check(name){
		var flag= true;
		if(name=="name"){
			if($("#"+name).val().trim()==""){
				flag= false;
			}
		}else{
			if($("#"+name).val().trim()!=""){
				$.ajax({
					type:"post",
					url:"${cxt}/sysuser/checkExist",
					data:{'checkField':name,'checkValue':$("#"+name).val().trim(),'id':$("#id").val()},
					datatype:"json",
					async : false,
					success : function(data) {
							if(data.result>0){
								flag = false;
							}
					}
				})
			}else{
				flag= false;
			}
		}
		return flag;
	}
	function saves(){
		if(!check('name')){
			layer.msg("名称不能为空，请填写",1,2);
			$("#name").focus();
			return false;
		}
		if(!check('tel')){
			layer.msg("电话可能为空或已存在，请检查",1,2);
			$("#tel").focus();
			return false;
		}
		if(!check('email')){
			layer.msg("邮箱可能为空或已存在，请检查",1,2);
			$("#email").focus();
			return false;
		}
		 var sign = $("input:radio[name='sex']:checked").val();

		$.ajax({
			type:"post",
			url:"/sysuser/basePersonMessage",
			data:{'name':$("#name").val().trim(),'tel':$("#tel").val().trim(),
				'id':$("#id").val(),'email':$("#email").val().trim(),'sex':sign},
			datatype:"json",
			success:function(data){
				if(data==1){
					layer.msg("信息更新成功",1,1);
				}else{
					layer.msg("信息更新失败",1,2);
				}			
				setTimeout("window.location.reload();",1000);
			}
		})
	}
		
	</script>
</html>

