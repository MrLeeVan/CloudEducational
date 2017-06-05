<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>${_res.get("student_list")}</title>
<meta name="save" content="history">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 h5{
   font-weight: 100 !important
 }
</style>
</head>
<body id="body" style="min-width:1100px">   
	<div id="wrapper" style="background: #2f4050;height:100%;">
	 <%@ include file="/common/left-nav.jsp"%>
	 <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			   <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>

        <div class="margin-nav2" style="min-width:1000px;">
		<form action="/finance/applyRefund" method="post" id="searchForm" >
			<input type="text" id="state" name="_query.state" value="${paramMap['_query.state']}"  style="display:none; ">
			<div  class="col-lg-12 m-t-xzl" style="padding-left:0;">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					        当前位置：<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					         &gt;<a href='/finance/index'>财务管理</a>&gt;<a href='/finance/index'>财务列表</a>&gt; 退费申请
					 </h5>
					 <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
	            	 <div style="clear:both"></div>
				</div>
				<div class="ibox-content">
					<label>${_res.get("student.name")}：</label>
					<input type="text" id="studentname" name="name" style="width:150px;" value="${name }">
					<input type="hidden" id="stuid" name="id" style="width:150px;"  value="">
					<%-- <label>${_res.get("admin.user.property.telephone")}：</label>
					<input type="text" id="phonenumber" name="_query.phonenumber" style="width:150px;" value="${ phonenumber }"> --%>
				    <input type="button" onclick="search()" value="${_res.get('admin.common.select')}"  class="btn btn-outline btn-info">
				    
			   </div>
			 </div>
		   </div>

			<div class="col-lg-12" style="padding-left:0;">
				<div class="ibox float-e-margins" >
					<div class="ibox-title">
						<h5>列表</h5>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
								<tr align="center">
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("index")}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('student')}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">订单日期</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('admin.dict.property.status')}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('Teach')}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("course.subject")}/${_res.get("group.class")}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">应收</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">实收</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('total.sessions')}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("scheduled.classes")}</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">已上</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">未排</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">未上</th>
									<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("operation")}</th>
								</tr>
							</thead>
							<tbody id="ids" >
								<c:forEach items="${stulist }" var="order" varStatus="index" >
									<tr align="center">
										<td>${index.count }</td>
										<td>${order.real_name }</td>
										<td>${order.createtime }</td>
										<td><c:if test="${order.status=='0' }">未支付</c:if> 
											<c:if test="${order.status==1 }">已支付</c:if> 
											<c:if test="${order.status==2 }">欠费</c:if> </td>
										<td><c:if test="${order.teachtype==1 }">${_res.get("IEP")}</c:if>
											<c:if test="${order.teachtype==2 }">${_res.get("group.class")}</c:if></td>
										<td><c:if test="${order.teachtype==1 }">${order.subjectname }</c:if>
											<c:if test="${order.teachtype==2 }">${order.classnum }</c:if></td>
										<td>${order.totalsum }</td>
										<td>${order.realsum }</td>
										<td>${order.classhour }</td>
										<td>${order.planedhours }</td>
										<td>${order.usedhours }</td>
										<td>${order.classhour-order.planedhours }</td>
										<td>${order.classhour-order.usedhours }</td>
										<td>
											<c:choose>
												<c:when test="${order.status==1 }">
													<c:if test="${(order.classhour-order.usedhours) >0 }"><a href="#" onclick="toDoRefund(${order.id})" >退费</a></c:if>
													<c:if test="${(order.classhour-order.usedhours) <=0 }">不可退</c:if>
												</c:when>
												<c:otherwise>
													不可退
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<%-- <div id="splitPageDiv">
							<jsp:include page="/common/splitPage.jsp" />
						</div> --%>
					</div>
				</div>
			</div>
			<div style="clear:both "></div>
		</form>
		</div>
	   </div>
	</div>
<!-- Chosen -->
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

    <script>
  <!--   $(".chosen-select").chosen({disable_search_threshold: 20});
        var config = {
            '.chosen-select': {},
            '.chosen-select-deselect': {
                allow_single_deselect: true
            },
            '.chosen-select-no-single': {
                disable_search_threshold: 10
            },
            '.chosen-select-no-results': {
                no_results_text: 'Oops, nothing found!'
            },
            '.chosen-select-width': {
                width: "95%"
            }
        }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }   
    </script>	 -->
	
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
    <script>
       $('li[ID=nav-nav10]').removeAttr('').attr('class','active');
    </script>
    
    <script type="text/javascript">
    	function toDoRefund(orderid){
    		$.layer({
        	    type: 2,
        	    shadeClose: true,
        	    title: "申请退费",
        	    closeBtn: [0, true],
        	    shade: [0.5, '#000'],
        	    border: [0],
        	    offset:['60px', ''],
        	    area: ['750px', 'auto'],
        	    iframe: {src: '${cxt}/finance/toDoRefund/'+orderid}
        	});
    	}
    </script>
</body>
</html>