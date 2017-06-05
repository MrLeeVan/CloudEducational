<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Authorities.list')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

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

      <div class="margin-nav" style="width:100%;">
		<form action="/company/index" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					     <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
					     &gt;<a href='/mediator/index'>${_res.get('Channel.Management')}</a> &gt; ${_res.get('Authorities.list')}
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
				<label>${_res.get("Company.Name")}：</label>
					<input type="text" id="companyname" name="_query.companyname" value="${paramMap['_query.companyname']}">
				<label>${_res.get("Contacts")}：</label>
					<input type="text" id="contacts" name="_query.contacts" value="${paramMap['_query.contacts']}">
				<label>${_res.get("admin.user.property.telephone")}：</label>
					<input type="text" id="phonenumber" name="_query.phonenumber" value="${paramMap['_query.phonenumber']}">
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
				
				<c:if test="${operator_session.qx_companyadd }">
				<input type="button" id="tianjia" value="${_res.get('teacher.group.add')}" onclick="addCompany()" class="btn btn-outline btn-info">
				</c:if>
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>${_res.get('Authorities.list')}</h5>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
								<tr>
									<th width="5%">${_res.get("index")}</th>
									<th width="15%">${_res.get("Company.Name")}</th>
									<th width="10%">${_res.get("Contacts")}</th>
									<th width="10%">${_res.get("admin.user.property.telephone")}</th>
									<th width="20%">${_res.get("Company.address")}</th>
									<th width="20%">${_res.get("course.remarks")}</th>
									<th width="10%">${_res.get("person.who.add")}</th>
									<th width="10%">${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="company" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${company.companyname}</td>
									<td>${company.contacts}</td>
									<td>${company.phonenumber}</td>
									<td>${company.address}</td>
									<td>${company.remark}</td>
									<td>${company.createusername}</td>
									<td>
									<c:if test="${operator_session.qx_companyedit }">
										<a href="#" onclick="updateCompany(${company.id})">${_res.get('Modify')}</a>
									</c:if>
									<c:if test="${operator_session.qx_companydelete }">
										<a href="#" onclick="deleteFunc(${company.id})">${_res.get('admin.common.delete')}</a>
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
			<div style="clear:both;"></div>
		</form>
		</div>
	</div>
  </div>
  <script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>	
	<script>
	function updateCompany(id){
		$.layer({
			type:2,
			shadeClose:true,
			title:"${_res.get('Modify.agencies')}",
			closeBtn:[0,true],
			shade:[0.5,'#000'],
			border:[0],
			area:['500px','468px'],
			iframe:{src:'${ctx}/company/edit/'+id}
		});
	}
	function addCompany(){
		$.layer({
			type:2,
			shadeClose:true,
			title:"${_res.get('Add.organization')}",
			closeBtn:[0,true],
			shade:[0.5,'#000'],
			border:[0],
			area:['500px','468px'],
			iframe:{src:'${ctx}/company/add'}
		});
	}
	function deleteFunc(companyId){
		if(confirm('确认对该机构进行删除吗？')){
			$.ajax({
				type:"post",
				url:"${cxt}/company/delete",
				data:{"companyId":companyId},
				dataType : "json",
				success:function(result){
					alert(result.msg);
					if(result.code==0){
						window.location.href="${cxt}/company/index";
					}
				}
			 });
		}
	}
	</script>
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/market.js"></script>
    <script>
       $('li[ID=nav-nav8]').removeAttr('').attr('class','active');
    </script>
</body>
</html>