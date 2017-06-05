<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>流水账目</title>
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

<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/jquery-2.1.1.min.js"></script>
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 .xubox_tabmove{
	background:#EEE;
}
.xubox_tabnow{
    color:#31708f;
}
</style>
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

		<div class="margin-nav" style="min-width:1000px;width:100%;">
		<form action="/accountbook/index?_query.accountid=${paramMap['_query.accountid']}" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
					 &gt;<a href='/finance/index'>财务管理</a>&gt; <a href='/finance/index'>财务列表</a>&gt;流水账目
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
            	   <div style="clear:both"></div>
				</div>
				<div class="ibox-content" style="height:auto;">
					<label>${_res.get("student.name")}：</label>
						<input type="text" id="studentname" name="_query.studentname" value="${paramMap['_query.studentname']}">
					<label>${_res.get('admin.user.property.telephone')}：</label>
						<input type="text" id="phonenumber" name="_query.phonenumber" value="${paramMap['_query.phonenumber']}">
					<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
					
			     </div>
			  </div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>订单列表</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
							<thead>
								<tr align="center">
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >${_res.get("index")}</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >操作时间</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >操作员</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >${_res.get('student')}</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >${_res.get('type')}</th>
									<th class="header" colspan="4" style="height:15px;line-height:15px;border-bottom-width: 0;padding:2px 0;"  >操作金额</th>
									<th class="header" colspan="4" style="height:15px;line-height:15px;border-bottom-width: 0;padding:2px 0;"  >剩余金额</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >${_res.get('course.course')}</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >${_res.get('admin.dict.property.status')}</th>
									<th class="header" rowspan="2" style="height:15px;line-height:34px" >${_res.get("operation")}</th>
								</tr>
								<tr align="center">
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">主账户</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">副账户</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">预存主</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">预存副</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">主账户</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">副账户</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">预存主</th>
									<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">预存副</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="account" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td><fmt:formatDate value="${account.createtime}" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/> </td>
									<td>${account.operateName}</td>
									<td>${account.stuName}</td>
									<td>
										<c:if test="${account.operatetype==1 }">交费</c:if>
										<c:if test="${account.operatetype==2 }">赠送</c:if>
										<c:if test="${account.operatetype==3 }">退费</c:if>
										<c:if test="${account.operatetype==5 }">回退</c:if>
										<c:if test="${account.operatetype==4 }">扣减</c:if>
										<c:if test="${account.operatetype==6 }">${_res.get('Deposit')}</c:if>
										<c:if test="${account.operatetype==7 }">转预存</c:if>
										<c:if test="${account.operatetype==8 }">转主副</c:if>
									</td>
									<td>${account.realamount}</td>
									<td>${account.rewardamount}</td>
									<td>${account.temprealamount}</td>
									<td>${account.temprewardamount}</td>
									<td>${account.realbalance}</td>
									<td>${account.rewardbalance}</td>
									<td>${account.temprealbalance}</td>
									<td>${account.temprewardbalance}</td>
									<td><c:if test="${account.operatetype==4 || account.operatetype==5 }">
									${account.xiaobanName==null?account.courseName:account.xiaobanName}</c:if></td>
									<td><c:if test="${account.status==0 }">${_res.get("normal")}</c:if>
									<c:if test="${account.status==1 }">已回退</c:if></td>
									<td>
									<c:if test="${operator_session.qx_accountbookshowCoursePlanDelete }">
									<c:if test="${account.operatetype==5 }">
										<a href="#" onclick="showCoursePlanDelete(${account.cpid})">${_res.get("admin.common.see")}</a>
									</c:if>
									</c:if>
									<c:if test="${operator_session.qx_accountbookshowCoursePlan }">
										<c:if test="${account.operatetype==4 }">
										<a href="#" onclick="showCoursePlan(${account.cpid})">${_res.get("admin.common.see")}</a>
										</c:if>
									</c:if>
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
	
    <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/money.js"></script>
    <script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script type="text/javascript">
    
    	function showCoursePlanDelete(id){
    		$.ajax({
    			url:"${cxt}/accountbook/showCoursePlanDelete",
    			data: {
    				"courseplanid":id
    			},
    			type:"post",
    			dataType:"json",
    			success:function(data){
    				var msg = "删除课程:"+data.planback.COURSE_NAME+"<br/>删除原因:"+data.planback.DEL_MSG;
    				//删除课程  
    				layer.alert(msg,-1,!msg);
    			}
    		});
    	}
    	function showCoursePlan(id){
    		$.ajax({
    			url:"${cxt}/accountbook/showCoursePlan",
    			data: {
    				"courseplanid":id
    			},
    			type:"post",
    			dataType:"json",
    			success:function(data){
    				var msg = "消耗课程:"+data.planback.COURSE_NAME+"<br/>消耗时间:"+data.planback.CREATE_TIME;
    				layer.alert(msg,-1,!msg);
    			}
    		});
    	}
    
    </script>
    
    <script>
       $('li[ID=nav-nav10]').removeAttr('').attr('class','active');
    </script>
</body>
</html>