<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>订单审核</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
.chosen-container {
	margin-top: -3px;
}

.xubox_tabmove {
	background: #EEE;
}

.xubox_tabnow {
	color: #31708f;
}

.btn-pad {
	padding: 9px 12px !important;
}

.minimalize-styl-2 {
	padding: 7px 12px !important
}

.count-info .label {
	top: 8px
}

#nav-topwidth>li {
	top: 4px
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050; min-width: 1100px">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation"> <%@ include file="/common/top-index.jsp"%> </nav>
			</div>
			<div class="margin-nav" style="min-width: 1000px; width: 100%;">
				<form action="/orders/orderreview" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;
									<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;
									<a href='/finance/index'>财务管理</a>&gt; 交费管理
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
							</div>
							<div class="ibox-content" style="height: auto;">
								<label>${_res.get("student.name")}：</label> 
								<input type="text" id="studentname" name="_query.studentname" value="${paramMap['_query.studentname']}"> 
								<label>${_res.get("admin.user.property.telephone")}：</label> 
								<input type="text" id="phonenumber" name="_query.phonenumber" value="${paramMap['_query.phonenumber']}"> 
								<input type="submit" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary"> 
							</div>
						</div>
					</div>

					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-content">
								<table width="80%" class="table table-hover table-bordered">
									<thead>
										<tr>
											<th>${_res.get("index")}</th>
											<th>${_res.get("student.name")}</th>
											<th>订单号</th>
											<th>订单日期</th>
											<th>${_res.get('admin.dict.property.status')}</th>
											<th>提交人</th>
											<th>${_res.get('Teach')}</th>
											<th>${_res.get('course.subject')}/${_res.get('classNum')}</th>
											<th>${_res.get('actual.amount')}</th>
											<th>${_res.get('total.sessions')}</th>
											<th>课时费</th>
											<th>${_res.get("operation")}</th>
										</tr>
									</thead>
									<c:forEach items="${showPages.list}" var="orders" varStatus="index">
										<tr align="center">
											<td>${index.count }</td>
											<td>${orders.studentname}</td>
											<td>${orders.ordernum}</td>
											<td><fmt:formatDate value="${orders.createtime}" type="time" timeStyle="full" pattern="yyyy-MM-dd" /></td>
											<td>
												<c:choose>
												<c:when test="${orders.delflag eq true }">
													${_res.get('Cancelled')}
												</c:when>
												<c:otherwise>
													${orders.status==0?'待收':orders.status==1?'已收':'欠费'}
												</c:otherwise>
												</c:choose>
											</td>
											<td>${orders.operatorname}</td>
											<td>${orders.teachtype==1?_res.get("IEP"):_res.get('course.classes')}</td>
											<td>${orders.teachtype==1?orders.subjectname:orders.classnum}</td>
											<td>${orders.realsum}</td>
											<td>${orders.classhour}</td>
											<td>${orders.avgprice}</td>
											<td>
												<c:choose>
													<c:when test="${orders.delflag eq true }">
														<c:if test="${operator_session.qx_ordersshowOrderReviews }">
															<a href="#" onclick="showDelReason(${orders.id})">取消原因</a>
														</c:if>
													</c:when>
													<c:otherwise>
														<c:choose>
															<c:when test="${orders.needcheck eq true}">
																<c:if test="${orders.checkstatus==0 }">
																	<c:if test="${operator_session.qx_ordersorderFirstReviews }">
																		<a href="#" onclick="showPayment(${orders.id})">待审核</a>
																	</c:if>
																</c:if>
																<c:if test="${orders.checkstatus==2 }">
																	<c:if test="${operator_session.qx_ordersorderFirstReviews }">
																		<a href="#" onclick="showPayment(${orders.id})">未通过</a>
																	</c:if>
																</c:if>
															</c:when>
														</c:choose>
														<c:if test="${operator_session.qx_orderstiaoke }">
															<a href="#" onclick="modify(${orders.id})">${_res.get('Modify')}</a>
														</c:if>
														<c:if test="${operator_session.qx_ordersdelOrder }">
															<a href="#" onclick="delOrder(${orders.id})">取消</a>
														</c:if>
													</c:otherwise>
												</c:choose>
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

	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
	<script src="/js/js/top-nav/money.js"></script>
	<script type="text/javascript">
	function toExcel(){
		$("#searchForm").attr("action","/orders/toExcel");
		$("#searchForm").submit();
	}
    function showOrderReview(orderId){
    	$.layer({
    	    type:2,
      		title: "订单信息",
      		closeBtn:[0,true],
      		shade:[0.5,'#000'],
      		shadeClose:true,
      		area:['800px','500px'],
    	    iframe: {src: '${cxt}/orders/showOrderReviews/'+orderId}
    	});
    }
    
    function orderReview(orderId,type){
    	if(type==1){
    		layer.msg("审核已通过。",1,10);
    	}else{
    		//直接进入审核页:
    		$.layer({
	    	    type: 2,
	    	    shadeClose: true,
	    	    title: "订单审核",
	    	    closeBtn: [0, true],
	    	    shade: [0.5, '#000'],
	    	    border: [0],
	    	    offset:['200px', ''],
	    	    area: ['700px', 'auto'],
	    	    iframe: {src: '${cxt}/orders/orderFirstReviews/'+orderId}
	    	});
    	}
    }
    
    function delOrder(id){
    	layer.prompt({title: '取消订单',type: 3,length: 200}, function(val,index){
    		$.ajax({
    			url:"${cxt}/orders/delOrder",
    			type:"post",
    			data:{"orderId":id,"reason":val},
    			dataType:"json",
    			success:function(data){
    				if(data.code=='1'){
    					layer.msg(data.msg, 2, 1);
    					layer.close(index)
    					window.location.reload();				
    				}else{
    					layer.msg(data.msg, 2, 5);
    				}
    			}
    		});
		});
    }
    /*购课*/ 
    function tiaoke(orderId){
    	$.layer({
    		type:2,
    		title:"${_res.get('Purchase.of.course')}",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		shadeClose:true,
    		area:['700px','460px'],
    		iframe:{src:'${cxt}/orders/tiaoke/'+orderId}
    	});
    }
    function modify(orderId){
    	window.location.href="${cxt}/orders/edit/"+orderId;
    }
    function showPayment(orderId){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "订单信息",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    offset:['100px', ''],
    	    area: ['800px', '100px'],
    	    iframe: {src: '${cxt}/payment/paymentList/'+orderId}
    	});
    }
    
    function showDelReason(orderId){
    	$.layer({
    		type: 2,
    	    shadeClose: true,
    	    title: "订单信息",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    offset:['100px', ''],
    	    area: ['800px', 'auto'],
    	    iframe: {src: '${cxt}/orders/showOrderReviews/'+orderId}
    	});
    }
    </script>
	<script>
       $('li[ID=nav-nav10]').removeAttr('').attr('class','active');
    </script>
</body>
</html>