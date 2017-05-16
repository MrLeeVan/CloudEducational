<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>账单信息</title>
<meta name="keywords" content="">
<meta name="description" content="">
<meta name="title" content="">
<meta name="author" content="">
<link rel="stylesheet" href="/css/mail/global.css" type="text/css">
<link rel="stylesheet" href="/css/mail/styles.css" type="text/css">
<!--[if lt IE 9]><script src="js/html5.js"></script><![endif]-->
</head>
<body>
	<div class="container" style="width: 861px;">
		<div class="head-pic">
			<img src="/images/sendmail/logo.png">
		</div>
		<div class="clearfix c-top-cont of">
			<div class="fl">
				<p>Bespoke Programme: ${student.real_name}</p>
				<p>定制教育咨询服务：${student.real_name}</p>
			</div>
			<div class="fr tar">
				<p>Invoice</p>
				<p>
					Invoice Number #
					<fmt:formatDate value="${date}" type="time" timeStyle="full" pattern="yyyy-MM-dd" />-${sort}
				</p>
			</div>
		</div>
		<div class="c-middle-cont">
			<div>
				<div class="c-content">
					<table width="100%" border="0" cellspacing="0">
						<thead>
							<tr align="center" height="30px">
								<th><div style="padding-top: 5px;">Description描述</div></th>
								<th>Quantity数量</th>
								<th>Unit Price单价</th>
								<th>Total总价</th>
							</tr>
						</thead>
						<c:forEach items="${list}" var="orders">
							<tr align="center" height="30px">
								<td><div style="padding-top: 5px;">${orders.paymessage.teachtype==1?orders.paymessage.subjectname:orders.paymessage.classnum}</div></td>
								<td>${orders.paymessage.classhour}</td>
								<td>${orders.paymessage.avgprice}</td>
								<td>${orders.paymessage.realsum-orders.paymessage.paidamount}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
			</div>
			<br> <br>
			<div style="float: right; margin-left: 84%">Total:${totelqfe}(RMB)</div>
			<br> <br>
			<h3>汇款账户名称：${organization.bankAccountName }</h3>
			<h3>账号：${organization.bankAccountNumber }</h3>
			<h3>${organization.bankAddress }</h3>
			<h3>付款日期： 请于${paydate }前支付,并备注学生姓名</h3>
		</div>
		<div>
			<img src="/images/sendmail/bottom.png">
		</div>
	</div>
</body>