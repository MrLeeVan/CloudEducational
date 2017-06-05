<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>结算记录_v2</title>
<link href="/css/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<%@ include file="/common/headExtraction.jsp" %>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;min-width:1100px">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%;">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			
	 <div class="margin-nav">
		<form action="/commission/index" method="get" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>&gt;<a href='/finance/index'>财务管理</a>&gt; 结算纪录_v2
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content" style="height:auto;">
				<label>${_res.get("Opp.Channel")}：</label>
				<select id="mediatorId" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.mediatorId">
					<option value="">请选择</option>
					<c:forEach items="${mediators}" var="mediator">
						<option value="${mediator.id }" <c:if test="${mediator.id == paramMap['_query.mediatorId'] }">selected="selected"</c:if>>${mediator.realname }</option>
					</c:forEach>
				</select>
				<label>支付状态：</label>
				<select id="ispay" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.ispay">
					<option value="">请选择</option>
					<option value="0" <c:if test="${paramMap['_query.ispay']==0 }">selected="selected"</c:if>>未支付</option>
					<option value="1" <c:if test="${paramMap['_query.ispay']==1 }">selected="selected"</c:if>>已支付</option>
				</select>
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary" id="chaxun">
				
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>结算记录</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
						<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>渠道姓名</th>
									<th>${_res.get("monthly.statistics")}</th>
									<th>学生缴纳金额</th>
									<th>返佣比例</th>
									<th>学生金额提成</th>
									<th>渠道佣金提成</th>
									<th>总金额</th>
									<th>支付状态</th>
									<th>${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="brokerage" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${brokerage.mediatorname}</td>
									<td>${brokerage.clearingmonth}</td>
									<td>${brokerage.studentpaidsum}</td>
									<td>${brokerage.ratios}%</td>
									<td>${brokerage.studentcommission}</td>
									<td>${brokerage.mediatorcommission}</td>
									<td>${brokerage.moneysum}</td>
									<td>${brokerage.payStatus}</td>
									<td>
										<a href="#"  onclick="showBrokerageDetail('${brokerage.id}','${brokerage.clearingmonth}')">${_res.get("details")}</a>
									</td>
								</tr>
							</c:forEach>
						</table>
						<div id="splitPageDiv">
							<jsp:include page="/common/splitPage.jsp" />
						</div>
					</div>
				</div>
			</div>
			<div style="clear: both;"></div>
		</form>
</div>
</div>
</div>
<script type="text/javascript">
	function showBrokerageDetail(brokerageId,statMonth ){
		window.location.href="${cxt}/commission/showBrokerageDetail?brokerageId="+brokerageId+"&statMonth="+statMonth;
	}
</script>
</body>
</html>