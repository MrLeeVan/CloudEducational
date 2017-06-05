<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>佣金结算_v2</title>
<link href="/css/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<%@ include file="/common/headExtraction.jsp" %>
</head>
<body>

	<div id="wrapper" style="background: #2f4050;min-width:1100px">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			    <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>
		
		<div class="margin-nav" style="width:100%">
			<form action="/commission/settlement" id="searchForm" method="get">
				
				<div class="col-lg-12" >
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<div>
								<h5><img width="16px" alt="" src="/images/img/currtposition.png" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.localtion='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a href="/commission/settlement">佣金管理</a> &gt; 佣金结算_v2</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" style="float:right" class="btn btn-outline btn-primary btn-xs">${_res.get("system.reback")}</a>
								<div style="clear:both"></div>
							</div>
						</div>
						<div class="ibox-content">
							<div class="form-group flolet" id="data_4" >
								<label style="float: left; margin-top:6px;">选择月份：</label>
								<div class="input-group date" style="width:180px;float: left;">
									<input id="startMonth" type="text" name="_query.startMonth" value="${ paramMap['_query.startMonth']}"  >
									<span class="input-group-addon" style="display: none;"></span>
								</div>&nbsp;&nbsp;&nbsp;&nbsp;
								<label > 渠道  : </label>
								<input type="text" id="realName" name="_query.realName" value="${ paramMap['_query.realName']}"/>&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
							</div>
						</div>
					</div>
				</div>
				
				<div class="col-lg-12">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<h5>佣金结算_v2</h5>
						</div>
						
						<div class="ibox-content">
							<table class="table table-hover table-triped table-bordered">
								<thead>
									<tr>
										<th>${_res.get("index")}</th>
										<th>渠道</th>
										<th>统计月份</th>
										<th>推荐学生数</th>
										<th>返佣比例</th>
										<th>${_res.get("operation")}</th>
									</tr>
								</thead>
								<c:forEach items="${showPage.list}"  var="mediator" varStatus="index">
									<tr align="center">
										<td>${index.count }</td>
										<td>${mediator.realname}</td>
										<td>${mediator.createTime}</td>
										<td>${mediator.stuNum }</td>
										<td>${mediator.ratio}</td>
										<td>
											<a href="javascript:void(0)" onclick="queryDetail('${mediator.id}','${mediator.createTime}')">${_res.get('admin.common.see')}</a>
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
				
				
			</form>
		</div>
		
	</div>
	
</div>
<script src="/js/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script type="text/javascript">
	
	$(document).ready(function () {
		$('#data_4 .input-group.date').datepicker({
			format:'yyyy-mm',
			minViewMode: 1,
			keyboardNavigation: false,
			forceParse: false,
			autoclose: true,
			todayHighlight: true
		});
	});

	$("#startMonth").change(function(){
		var d = new Date();
		var mon = d.getFullYear()+'-'+(d.getMonth()+1)+'-01 00:00:00';
		var mon2 = $("#startMonth").val()+'-01 00:00:00';
		mon =  mon.replace(/-/g,"/");
		mon2 =  mon2.replace(/-/g,"/");
		var oDate1 = new Date(mon);
		var oDate2 = new Date(mon2);
		if(oDate1 < oDate2){
			alert("所选月份不能大于当前月份");
			$("#startMonth").val('');
		}
	});
	
	function queryDetail( mediatorId,startMonth ){
		window.location.href='/commission/commissionStatDetail?mediatorId='+mediatorId+"&statMonth="+startMonth;
	}
</script>
</body>
</html>