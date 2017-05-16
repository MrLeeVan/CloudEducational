<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>模块列表</title>
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

	    <div class="margin-nav" style="min-width:1050px;width:100%;">	
		<form action="/operator/module" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
					    &gt;<a href='/operator/module'>系统管理</a> &gt; 模块列表
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          			<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
				<label>父模块名称：</label>
					<input type="text" id="parentnames" name="_query.parentnames" value="${paramMap['_query.parentnames']}">
				<label>${_res.get('admin.dict.property.name')}：</label>
					<input type="text" id="names" name="_query.names" value="${paramMap['_query.names']}">
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
				<!--  -->
				<c:if test="${config_devMode && operator_session.qx_operatoraddmodule }">
					<input type="button" id="tianjia" value="添加" onclick="addMoudle()" class="btn btn-outline btn-info">
				</c:if>
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>菜单列表</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
							<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>父名称</th>
									<th>${_res.get('admin.dict.property.name')}</th>
									<c:if test="${operator_session.qx_operatorshowthisModuleDetail || operator_session.qx_operatoreditmodule || operator_session.qx_operatordelthisModule }">
										<th>${_res.get("operation")}</th>
									</c:if>
								</tr>
							</thead>
							<tbody  style="text-align:center;">
								<c:forEach items="${showPages.list}" var="module" varStatus="index">
									<tr>
										<td>${index.count }</td>
										<td>${module.parentnames }</td>
										<td>${module.names }</td>
										<c:if test="${operator_session.qx_operatorshowthisModuleDetail || operator_session.qx_operatoreditmodule || operator_session.qx_operatordelthisModule }">
											<td style="text-align:center;" >
											<c:if test="${config_devMode }">
												<c:if test="${operator_session.qx_operatoreditmodule }">
													<a href="javascript:void(0);" onclick="updateMoudle(${module.id })" >${ _res.get('admin.common.edit')}</a>&nbsp;|&nbsp;
												</c:if>
												<c:if test="${operator_session.qx_operatordelthisModule }">
												    <a href="javascript:void(0);" onclick="delModule(${module.id})">${_res.get('admin.common.delete')}</a>
												</c:if>
											</c:if>
											</td>
										</c:if>
									</tr>
								</c:forEach>
							</tbody>
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

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
	$(".chosen-select").chosen({disable_search_threshold:30});
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : true
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 10
			},
			'.chosen-select-no-results' : {
				no_results_text : 'Oops, nothing found!'
			},
			'.chosen-select-width' : {
				width : "95%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
	</script>
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
    <script src="/js/js/top-nav/campus.js"></script>
    <script>
       $('li[ID=nav-nav12]').removeAttr('').attr('class','active');
       function addMoudle(){
       	$.layer({
       	    type: 2,
       	    shadeClose: true,
       	    title: "添加模块",
       	    closeBtn: [0, true],
       	    shade: [0.5, '#000'],
       	    border: [0],
       	    offset:['20px', ''],
       	    area: ['620px', '364px'],
       	    iframe: {src: "/operator/addmodule"}
       	});
       }
       function updateMoudle(id){
       	$.layer({
       	    type: 2,
       	    shadeClose: true,
       	    title: "修改模块",
       	    closeBtn: [0, true],
       	    shade: [0.5, '#000'],
       	    border: [0],
       	    offset:['20px', ''],
       	    area: ['620px', '364px'],
       	    iframe: {src: "/operator/editmodule/"+id}
       	});
       }  
   	function delModule(id){
   		if(confirm("确认删除？")){
	   		$.ajax({
	   			url:"${cxt}/operator/delthisModule",
	   			data:{"id":id},
	   			type:"post",
	   			dataType:"json",
	   			success:function(msg){
	   				layer.msg(msg,2,5);
	   				setTimeout("window.location.reload()",2000);
	   			}
	   		});
   			
   		}
   	}
   	
   	
    </script>
</body>
</html>