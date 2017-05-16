<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>IP地址管理</title>

<style type="text/css">
.button_link {
	font-size: 14px;
	background-color: #FFF;
	border-radius: 4px;
	border: 1px solid #18a689;
	color: #18a689;
	text-decoration: none;
	padding: 8px 12px;
}

.button_link:hover {
	background-color: #18a689;
	border: 1px solid #18a689;
	color: #fff;
	text-decoration: none;
}
</style>

</head>
<body>
	<div id="wrapper" style="background: #2f4050;min-width:1100px;">
		<div class="left-nav"><%@ include file="/common/left-nav.jsp"%></div>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<form action="/address/getAllIpAdress" method="post" id="searchForm">
				<div class="margin-nav1" style="margin-left: -14px; min-width: 850px">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
						    <div class="ibox-title" style="margin-bottom:20px">
								<h5>
								    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
								    &gt;<a href='/sysuser/index'>机构管理</a> &gt;<a href='/address/getAllIpAdress'>IP地址管理</a>&gt;IP地址列表
							   </h5>
							   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          						<div style="clear:both"></div>
							</div>
							<div class="ibox-title" style="height: 60px;">
								<h5 style="margin-top: 5px;">ip名称&nbsp;</h5>
								<div style="margin-top: -4px;">
									<input type="text" name="ipaddress" id="ipaddress" value="${userName}" maxlength="15" /> 
									<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary" />
									<a class="button_link" href="#" onclick="add()">${_res.get('teacher.group.add')}</a>
								</div>
							</div>
							<div class="ibox-content">
								<table class="table table-hover table-bordered">
									<thead>
										<tr align="center">
											<th class="header" width="">${_res.get("index")}</th>
											<th class="header" width="">地址</th>
											<th class="header" width="">所在校区</th>
											<th class="header" width="">修改时间</th>
											<th class="header" width="" align="center">&nbsp;&nbsp;&nbsp;${_res.get("operation")}</th>
										</tr>
									</thead>
									<c:forEach var="Ipaddress" items="${showPages.list}" varStatus="s">
										<tr class="odd" align="center">
											<td>${s.count}</td>
											<td>${Ipaddress.name}</td>
											<td>${Ipaddress.CAMPUS_NAME}</td>
											<td>${Ipaddress.create_time}</td>
											<td align="center">
											<a href="#" onclick="update(${Ipaddress.Id})">${_res.get('Modify')}</a>&nbsp;|&nbsp; 
											<a href="/address/delIpAddress?ipaddressId=${Ipaddress.Id}" onclick="{if(confirm('确定要删除吗?')){return true;}return false;}">${_res.get('admin.common.delete')}</a></td>
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
				</div>
			</form>
		</div>
	</div>

	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/campus.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script type="text/javascript">
        function add(){
        		$.layer({
        	    type: 2,
        	    shadeClose: true,
        	    title: "添加信息",
        	    closeBtn: [0, true],
        	    shade: [0.5, '#000'],
        	    border: [0],
        	    offset: ['100px',''],
        	    area: ['500px', ''],
        	    iframe: {src: '${cxt}/address/getAllCampus'}
        	});
        }
         function update(ipaddressId){
        	 $.layer({
         	    type: 2,
         	    shadeClose: true,
         	    title: "修改信息",
         	    closeBtn: [0, true],
         	    shade: [0.5, '#000'],
         	    border: [0],
         	    offset: ['100px',''],
         	    area: ['500px', ''],
         	    iframe: {src: '${cxt}/address/getIpaddressById/'+ipaddressId}
         	});
         }
   </script>
	<script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
</body>
</html>