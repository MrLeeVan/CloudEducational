<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户登录</title>
</head>
<body>
<form action="/account/doLogin" method="post">
${_res.get("userName")}:<input name="email"/><br/>
&nbsp;&nbsp;${_res.get("passWord")}:<input name="userPwd"/><br/>
<input type="submit" value="登录"/>
<input type="reset" value="${_res.get('Reset')}"/>
</form>
</body>
</html>