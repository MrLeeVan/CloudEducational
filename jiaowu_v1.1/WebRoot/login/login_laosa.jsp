<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

    <title>萨缪大叔国际教育 - 登录</title>
    <link href="/css/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="/css/css/animate.css" rel="stylesheet">
    <link href="/css/css/style.css" rel="stylesheet">
    <link href="/css/css/login.css" rel="stylesheet">
    
    <script>
        if (window.top !== window.self) {
            window.top.location = window.location;
        }
    </script>

</head>

<body class="signin">
    <div class="signinpanel" style="color:#000000;">
        <div class="row">
            <div class="col-sm-7">
                <div class="signin-info">
                    <div class="logopanel m-b">
                        <h1>[ 萨缪大叔国际教育 ]</h1>
                    </div>
                    <div class="m-b"></div>
                    <h4>欢迎使用 <strong>教学信息智能管理云系统Beta3.0</strong></h4>
                    <ul class="m-b">
                        <li> 做时间的朋友 , </li>
						<li> 做自己的主人</li>

                    </ul>
                    <strong>还没有账号？ <a href="">立即注册&raquo;</a></strong>
                </div>
            </div>
            <div class="col-sm-5">
                <form action="/account/doLogin" method="POST">
                    <h4 class="no-margins">登录：</h4>
                    <p class="m-t-md">教学信息智能管理云系统Beta3.0</p>
                    <input type="text" class="form-control uname" placeholder="${_res.get('userName') }" name="email" />
                    <input type="password" class="form-control pword m-b" placeholder="${_res.get('passWord') }" name="userPwd" />
                    <a href="">忘记密码了？</a>
                    <button class="btn btn-success btn-block" type="submit" >${_res.get('admin.login.submit') }</button>
                </form>
            </div>
        </div>
        <div class="signup-footer">
            <div class="pull-left">
                &copy; 2016-2017 All rights reserved. Uncle Sarmus (Beijing) Education & Technology LLC. 
            </div>
        </div>
    </div>
</body>

</html>
