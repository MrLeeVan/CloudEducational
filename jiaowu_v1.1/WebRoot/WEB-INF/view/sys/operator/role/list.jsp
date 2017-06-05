<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>角色列表</title>
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
<script src="/js/common.js"></script>
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
		<form action="/operator/role" method="post" id="searchForm">

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
				    <div class="ibox-title" style="margin-bottom:20px">
						<h5><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
						 &gt;<a href='/operator/module'>系统管理</a> &gt; 角色列表
						</h5>
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
		          		<div style="clear:both"></div>
					</div>
					<div class="ibox-title">
						<h5>角色列表</h5>
						<c:if test="${operator_session.qx_operatoraddRoles }">
						<input type="button"  class="navbar-right btn btn-outline btn-primary input_right" style="margin:-10px 10px 0 0;float: right;" value="${_res.get('teacher.group.add')}" onclick="addRole()">
						</c:if>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered" style="text-align:center;">
							<thead>
								<tr>
									<th width="10%">${_res.get("index")}</th>
									<th>编号</th>
									<th width="20%">${_res.get('admin.dict.property.name')}</th>
									<th width="30%">角色简介</th>
									<th width="20%">类型</th>
									<th width="20%">${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="roles" varStatus="index">
								<tr>
									<td>${index.count }</td>
									<td>${roles.numbers }</td>
									<td>${roles.names }</td>
									<td>${roles.intro}</td>
									<td>${roles.id > 8?'自定义角色':'默认角色'}</td>
									<td style="text-align:center;" >
										<c:if test="${operator_session.qx_operatoreditthisRole }">
											<c:if test="${roles.id > 8}">
												<a href="javascript:void(0);" onclick="eidtRole(${roles.id})" >${ _res.get('admin.common.edit')}</a>&nbsp;|&nbsp;
											</c:if>
										</c:if>
										<c:if test="${operator_session.qx_operatoreditthisRole }">
											<c:if test="${roles.state==0}">
												<a href="javascript:void(0);" onclick="delThisRole(${roles.id})">${_res.get('admin.common.delete')}</a>&nbsp;|&nbsp;
											</c:if>
										</c:if>
										<c:if test="${operator_session.qx_operatorsetRoleOperatorDiaLog }">
											<c:if test="${roles.id > 1 || config_devMode}">
												<a href="#" onclick="setRoleOperatorDiaLog('${roles.id}')" >功能</a>
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
    <script>
       $('li[ID=nav-nav12]').removeAttr('').attr('class','active');
    </script>
    
    <script type="text/javascript">
    function addRole(){
    	  $.layer({
  		    type: 2,
  		    shadeClose: true,
  		    title: "添加角色",
  		    closeBtn: [0, true],
  		    shade: [0.5, '#000'],
  		    border: [0],
  		    offset:['20px', ''],
  		    area: ['520px', '370px'],
  		    iframe: {src: "${cxt}/operator/addRoles"}
  		});
    }
    function eidtRole(id){
  	  $.layer({
		    type: 2,
		    shadeClose: true,
		    title: "添加角色",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['520px', '370px'],
		    iframe: {src: "${cxt}/operator/editthisRole/"+id}
		});
  }
    function setRoleOperatorDiaLog(ids){
	    $.layer({
		    type: 2,
		    shadeClose: true,
		    title: "角色功能选择",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['290px', '500px'],
		    iframe: {src: "${cxt}/operator/setRoleOperatorDiaLog/"+ids}
		});
    }
    
    function delThisRole(id){
    	if(confirm("确认删除？")){
    		$.ajax({
    			url:"${cxt}/operator/delthisRole",
	   			data:{"id":id},
	   			type:"post",
	   			dataType:"json",
	   			success:function(data){
	   				layer.msg(data.msg,2,1);
	   				setTimeout("window.location.reload()",2000);
	   			}
    		});
    	}
    }
    
    </script>
    
    
</body>
</html>