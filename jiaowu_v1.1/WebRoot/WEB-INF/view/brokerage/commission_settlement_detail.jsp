<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>结算明细</title>
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
  
  <div class="margin-nav">
<form action="/commission/showBrokerageDetail" method="get" id="searchForm">
	<input type="hidden"  id="brokerageid" name="brokerageid" value="${brokerage.id }" >
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
				<div class="ibox-title" style="margin-bottom:20px">
					  <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a href='/finance/index'>佣金管理</a>&gt;<a href='javascript:history.go(-1);'>结算记录_v2</a> &gt; 结算明细
				    <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get('system.reback')}</a>
	            	<div style="clear:both"></div>
				</div>
			  </div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>结算明细</h5>
          		<div style="clear:both"></div>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
						<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>${_res.get("student.name")}</th>
									<th>${_res.get("Opp.Channel")}</th>
									<th>创建时间</th>
									<th>授课类型</th>
									<th>费用</th>	
								</tr>
							</thead>
							<c:forEach items="${detail}" var="list" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${list.studentname}</td>
									<td>${list.mediatorname}</td>
									<td>${list.coursetime}</td>
									<th>${list.teachType }</th>
									<td>${list.amount}</td>
								</tr>
							</c:forEach>
							<tr align="center">
								<td colspan="5">合计</td>
								<td>${brokerage.studentpaidsum}</td>
							</tr>
							<tr align="center">
								<td colspan="3">学生提成</td>
								<td colspan="3">${brokerage.studentpaidsum }*${ratio }%=${brokerage.studentcommission }元</td>
							</tr>
							<tr align="center">
								<td colspan="3">佣金提成</td>
								<td colspan="3">${brokerage.mediatorcommission}元</td>
							</tr>
							<tr align="center">
								<td colspan="3" >支付总佣金</td>
								<td colspan="2">${brokerage.MONEYSUM}元</td>
								<td><a href="javascript:void(0)" onclick="queren(${brokerageid})">确认?</a></td>
							</tr>
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


	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>

	<script src="/js/js/demo/layer-demo.js"></script>
	
	 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=3.3.0"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/money.js"></script>
    <script src="/js/js/plugins/pace/pace.min.js"></script>
    
        <!-- Page-Level Scripts -->
    
    <script>
       $('li[ID=nav-nav14]').removeAttr('').attr('class','active');
    </script>
    
    <script type="text/javascript">
    	function queren(id){
    		var ispay = ${brokerage.ispay};
    		if(!ispay){
	    		$.layer({
			        type: 2,
			        title: '支付确认',
			        maxmin: false,
			        shadeClose: true, //开启点击遮罩关闭层
			        area : ['360px' , '510px'],
			        offset : ['80px', ''],
			        iframe: {src: "/brokerage/turntosurepae"}
			    });
    			
    		}else{
    			layer.msg("已确认.",2,5);
    		}
    	}
    </script>
    
</body>
</html>