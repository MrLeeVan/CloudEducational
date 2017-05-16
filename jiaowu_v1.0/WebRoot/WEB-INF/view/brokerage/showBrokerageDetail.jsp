<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>结算明细</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<!-- Data Tables -->
<link href="/css/css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1100px">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%;width:auto">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="margin-nav">
<form action="/brokerage/showBrokerageDetail" method="post" id="searchForm">
	<input type="hidden"  id="brokerageid" name="brokerageid" value="${brokerage.id }" >
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
				<div class="ibox-title" style="margin-bottom:20px">
					  <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a href='/finance/index'>佣金管理</a>&gt;<a href='javascript:history.go(-1);'>佣金结算</a> &gt; 结算明细
				    <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get('system.reback')}</a>
	            	<div style="clear:both"></div>
				</div>
			  </div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>结算明细</h5>
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
						<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>${_res.get("student.name")}</th>
									<th>${_res.get("Opp.Channel")}</th>
									<th>消耗课程</th>
									<th>消耗时间</th>
									<th>消耗费用</th>
								</tr>
							</thead>
							<c:forEach items="${detail}" var="list" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${list.studentname}</td>
									<td>${list.mediatorname}</td>
									<c:choose>
										<c:when test="${list.classorderid==null }">
											<td>${list.coursename}</td>
										</c:when>
										<c:otherwise>
											<td>${list.classnum}</td>
										</c:otherwise>
									</c:choose>
									<td>${list.coursetime}</td>
									<td>${list.amount}</td>
								</tr>
							</c:forEach>
							<tr align="center">
								<td colspan="5" align="right">支付佣金</td>
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