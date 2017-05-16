<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>logo管理</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- CSS to style the file input field as button and adjust the Bootstrap progress bars -->
<link rel="stylesheet" href="/css/css/jquery.fileupload.css">
<link rel="stylesheet" href="/css/css/jquery.fileupload-ui.css">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 .img-width{
   width:150px
 }
 .zhuyi{
   width:215px;
   float: right;
   margin-right: 80px
 }
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
	  <%@ include file="/common/left-nav.jsp"%>
       <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;">
			<div class="navbar-header">
			   <a class="navbar-minimalize minimalize-styl-2 btn btn-primary" id="btn-primary" href="#" style="margin-top:10px;"><i class="fa fa-bars"></i> </a>
				<div style="margin:20px 0 0 70px;"><h5>
					当前位置：<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a href='/sysuser/index'>机构管理</a> &gt; logo管理
				</h5>
				<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
			</div>
			<div class="top-index"><%@ include file="/common/top-index.jsp"%></div>
			</nav>
		</div>

      <div class="margin-nav" style="min-width:1050px;width:100%;">
		<form>
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
					  <h5>${_res.get('admin.common.mainPage')}logo</h5>
					</div>
					<div class="ibox-content">
					    <div class="forum-item">
                                <div class="row">
                                    <div class="col-md-9">
                                        <div style="background:#ddd"><img class="img-width" alt="${_res.get('admin.common.mainPage')}logo" src="/images/logo/logo_login.png"/></div>
                                    </div>
                                        <form action="" method="post">
                                            <div>
									        <span class="btn btn-info fileinput-button">
									            <span>上传文件</span>
									            <input type="file" name="files[]" id="imgIds" multiple onchange="previewImage(this)">
									        </span>
									        </div>
									        <div class="zhuyi"><span style="color:red">*</span>请上传png格式的图片，建议190*36</div>
									    </form>
                                </div>
                            </div>
					</div>
				</div>
				
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>菜单logo</h5>
					</div>
					<div class="ibox-content">
					    <div class="forum-item">
                                <div class="row">
                                    <div class="col-md-9">
                                        <div style="background:#ddd"><img class="img-width" alt="菜单logo" src="/images/logo/logo_login.png"/></div>
                                    </div>
                                    <form action="" method="POST">
									        <span class="btn btn-info fileinput-button">
									            <span>上传文件</span>
									            <input type="file" name="files[]" multiple id="imgIds" onchange="previewImage(this)">
									        </span><div class="zhuyi"><span style="color:red">*</span>请上传png格式的图片，建议300*57</div>
									</form>
                                </div>
                            </div>
					</div>
				</div>
			</div>
			<div style="clear:both;"></div>
		</form>
		</div>
	</div>
  </div>
  
  	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script>
    var index = parent.layer.getFrameIndex(window.name);
	  parent.layer.iframeAuto(index);
      function previewImage(imgIds){
    	 $.ajax({
    	   		url : "",
    	   		type : "post",
    	   		dataType : "json",
    	   		data:{"imgIds":imgIds},
    	   		success : function(data) {
    	   			parent.layer.msg(data.msg,3,1);
    	   			if(data=="1"){
    	   				parent.window.location.reload();
		    			setTimeout("parent.layer.close(index)",4000);
    	   			}
    	   		}
    	   	});
      }
    </script>

    <script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
</body>
</html>