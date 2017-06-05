<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
	<title>云教务</title>	
	<link href="/css/css/bootstrap.min.css?v=3.3.0" rel="stylesheet">
    <link href="/font-awesome/css/font-awesome.css?v=4.3.0" rel="stylesheet">
    <link href="/css/css/animate.css" rel="stylesheet">
    <link href="/css/css/style.css" rel="stylesheet">
    <script src="/js/js/jquery-2.1.1.min.js"></script>
	<script type='text/javascript' src='/js/iphone-style-checkboxes.js'></script>
	<style type="text/css">
	   img{
	     width:300px;
	   }
	</style>
</head>

<body class="gray-bg" id="index-body">
     <div class="middle-box text-center loginscreen  animated fadeInDown">
       <div>
          <div>
              <h1><img alt="logo.png" src="/images/logo/logo_login.png"></h1>
           </div>     
            <p>做互联网时代“智者”，让你的学校“智能”起来！</p> 
 
            <form class="m-t" role="form" action="${cxt }/company/saveExpiration" method="POST">
                <div class="form-group">
                    <input type="text" name="licenseKey" class="form-control" placeholder="请填写授权码" value="${licenseKey }" />
                </div>
                <div class="form-group">
                    <input type="text" name="expirationDateKeys" class="form-control" placeholder="请填写系统激活码" required="" onblur="if (jQuery(this).val() == &quot;&quot;) { jQuery(this).val(&quot;&quot;); }" onFocus="jQuery(this).val(&quot;&quot;);"/>
                </div>
                <input type="submit" value="激活系统" class="btn btn-primary block full-width m-b" id="dianji"/>

                <p>建议使用<a href="http://www.google.cn/intl/zh-CN/chrome/browser/" title="谷歌" target="_blank">谷歌</a>或IE7及以上版本浏览器访问！</p>

            </form>
         </div>
    </div>
</body>

</html>
