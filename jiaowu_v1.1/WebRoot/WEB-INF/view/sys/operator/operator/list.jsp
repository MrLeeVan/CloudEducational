<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>功能管理</title>
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
		<form action="/operator/index" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					     <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
					      &gt;<a href='/operator/module'>系统管理</a> &gt; 功能管理
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
				<label>${_res.get('admin.dict.property.name')}：</label>
					<input type="text" id="names" name="_query.names" value="${paramMap['_query.names']}">
				<label>url：</label>
					<input type="text" id="url" name="_query.url" value="${paramMap['_query.url']}">
				<label>权限控制：</label>
				<select id="privilege" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.privilege"  onchange="" >
					<option value="" selected="selected" >--${_res.get('Please.select')}--</option>
					<option value="0" <c:if test="${'0' == paramMap['_query.privilege'] }">selected="selected"</c:if> >${_res.get('admin.common.no')}</option>
					<option value="1" <c:if test="${'1' == paramMap['_query.privilege'] }">selected="selected"</c:if> >${_res.get('admin.common.yes')}</option>
				</select>
				<br/><br/>
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
				<!--  -->
				<c:if test="${config_devMode }">
					<input type="button" id="tianjia" value="${_res.get('teacher.group.add')}" onclick="addUrl()" class="btn btn-outline btn-info">
				</c:if>
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>功能列表</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
							<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>模块名称</th>
									<th>${_res.get('admin.dict.property.name')}</th>
									<th>url</th>
									<th>编码</th>
									<!-- <th>行级过滤</th> -->
									<th>是否分页</th>
									<!-- <th>重复提交验证</th> -->
									<th>权限验证</th>
									<th>${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="operator" varStatus="index">
								<tr>
									<td>${index.count }</td>
									<td>${operator.modulenames }</td>
									<td>${operator.names }</td>
									<td>${operator.url }</td>
									<td>${operator.formaturl }</td>
								<%-- 	<td><c:if test="${operator.rowFilter == 0 }">${_res.get('admin.common.no')}</c:if>
										<c:if test="${operator.rowFilter == 1 }">${_res.get('admin.common.yes')}</c:if></td> --%>
									<td><c:if test="${operator.splitPage == 0 }">${_res.get('admin.common.no')}</c:if>
										<c:if test="${operator.splitPage == 1 }">${_res.get('admin.common.yes')}</c:if></td>
									<%-- <td><c:if test="${operator.formtoken == 0 }">${_res.get('admin.common.no')}</c:if>
										<c:if test="${operator.formtoken == 1 }">${_res.get('admin.common.yes')}</c:if></td> --%>
									<td><c:if test="${operator.privilege == 0 }">${_res.get('admin.common.no')}</c:if>
										<c:if test="${operator.privilege == 1 }">${_res.get('admin.common.yes')}</c:if></td>
									<td style="text-align:center;" >
									<c:if test="${config_devMode }">
										<%-- 需要的时候将注释去掉  不要改uri
										 <c:if test="${operator_session.qx_operatorshowthisOperator }">
											<a href="javascript:void(0);" onclick="showOperator(${operator.id})" >${_res.get("admin.common.see")}</a>&nbsp;|&nbsp;
										</c:if> --%>
										<c:if test="${operator_session.qx_operatoreditthisOperator }">
											<a href="javascript:void(0);" onclick="updateUrl(${operator.id})" >${ _res.get('admin.common.edit')}</a>&nbsp;|&nbsp;
										</c:if>
										<c:if test="${operator_session.qx_operatordelthisOperator }">
											<a href="javascript:void(0);" onclick="delOperator(${operator.id})" >${_res.get('admin.common.delete')}</a>
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
	
    <script type="text/javascript">
    function addUrl(){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "添加URL",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    offset:['20px', ''],
    	    area: ['600px', '410px'],
    	    iframe: {src: "/operator/add"}
    	});
    }
    function updateUrl(id){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "修改URL",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    offset:['20px', ''],
    	    area: ['600px', '410px'],
    	    iframe: {src: "/operator/editthisOperator/"+id}
    	});
    }
    	/* $(function(){
    		$("#privilege").trigger("chosen:updated");
    	}); */
    
    	function showOperator(id){
    		$.ajax({
       			url:"/operator/showthisOperator",
       			data:{"id":id},
       			dataType:"json",
       			type:"post",
       			success:function(result){
       				layer.tab({
    					data:[
    					      {
    					    	  title: '查看该url信息',
    					    	  content: ''
    					      }],
    					      offset:['150px', ''],
    						  area: ['400px', 'auto']
    				
    				});
       				
       			}
       			
       		});
    	}
    	
    	function delOperator(id){
    		if(confirm("确定删除？")){
    			$.ajax({
    				url:"${cxt}/operator/delthisOperator",
    	   			data:{"id":id},
    	   			type:"post",
    	   			dataType:"json",
    	   			success:function(data){
    	   				layer.msg(data.msg,2,5);
    	   				setTimeout("window.location.reload()",2000);
    	   			}
    			});
    		}
    	}
    	
    </script>
</body>
</html>