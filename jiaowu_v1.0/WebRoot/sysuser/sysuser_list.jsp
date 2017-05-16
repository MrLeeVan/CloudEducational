<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>${_res.get('admin.user.list.table')}</title>
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
				<form action="/sysuser/index" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a href='/sysuser/index'>机构管理</a> &gt;${_res.get('admin.user.list.table')}
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback")}</a>
								<div style="clear: both"></div>
							</div>
							<div class="ibox-content">
							<!-- 查询块 -->
								<label>用户姓名：</label> 
								<input type="text" id="sysusername" name="_query.sysusername" 
								value="${paramMap['_query.sysusername']}"> 
								<label>角色：</label> 
								<select class="chosen-select" name="_query.roleids">
								  <option value="">请选择</option>
								    <c:forEach items="${roles}" var="role" >
								        <option value="${role.id }" ${paramMap['_query.roleids']==role.id?"selected='selected'":""} >${role.names}</option>
								    </c:forEach>
								</select>
								<label>Email：</label> <input type="text" id="email" name="_query.email" value="${paramMap['_query.email']}"> 
								<label>${_res.get("admin.user.property.telephone")}：</label> <input type="text" id="phonenumber" name="_query.phonenumber" value="${paramMap['_query.phonenumber']}"> <input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
								<c:if test="${operator_session.qx_sysuseradd }">
									<input type="button" value="${_res.get('teacher.group.add')}" class="btn btn-outline btn-success" onclick="addSysuser()" />
								</c:if>
							</div>
						</div>
					</div>

					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>${_res.get('admin.user.list.table')}</h5>
							</div>
							<div class="ibox-content">
								<table class="table table-hover table-bordered" width="100%">
									<thead>
										<tr>
											<th>${_res.get("index")}</th>
											<th>${_res.get("sysname")}</th>
											<th>Email</th>
											<th>${_res.get("admin.user.property.telephone")}</th>
											<th>校区</th>
											<!-- <th rowspan="2">${_res.get('rest.day')}</th> -->
											<th>${_res.get('createtime')}</th>
											<th>角色</th>
											<th>${_res.get("operation")}</th>
										</tr>
									</thead>
									<c:forEach items="${showPages.list}" var="sysuser" varStatus="status">
										<tr class="odd" align="center">
											<td rowspan="${sysuser.row}">${status.count}</td>
											<td rowspan="${sysuser.row}">${sysuser.real_name}</td>
											<td rowspan="${sysuser.row}">${sysuser.email}</td>
											<td rowspan="${sysuser.row}">${sysuser.tel}</td>
											<td rowspan="${sysuser.row}">${sysuser.CAMPUS_NAME}</td>
											<%-- <td rowspan="${sysuser.row}">${sysuser.sex==1?"男":"女"}</td> --%>
											<td rowspan="${sysuser.row}">${fn:substring(sysuser.create_time,0,10)}</td>
											<td rowspan="1">${sysuser.firstRole.names}</td>
											<td align="center" rowspan="${sysuser.row}"><c:choose>
													<c:when test="${sysuser.state==1}">
														<c:if test="${operator_session.qx_sysuserfreeze }">
															<a style="color: #515151" href="javascript:void(0)" onclick="freezeAccount(${sysuser.id},0)">${_res.get('Recover')}</a>
														</c:if>
													</c:when>
													<c:otherwise>
														<c:if test="${operator_session.qx_sysuseredit }">
															<a href="javascript:void(0)" onclick="eidtSysuser(${sysuser.id})">${ _res.get('admin.common.edit')}</a>
														</c:if>
														<c:if test="${operator_session.qx_sysuserchangePassword }">
															<a href="javascript:void(0)" onclick="changePassword(${sysuser.id})" title="修改密码">${_res.get("passWord")}</a>
														</c:if>
														<c:if test="${operator_session.qx_sysuserfreeze }">
															<a href="javascript:void(0)" onclick="freezeAccount(${sysuser.id},1)">${_res.get('Suspending')}</a>
														</c:if>
														<c:if test="${operator_session.qx_operatorsetSysUserGroup }">
															<a href="javascript:void(0)" onclick="setSysUserGroup(${sysuser.id})">角色</a>
														</c:if>
													</c:otherwise>
												</c:choose></td>
										</tr>
										<c:forEach items="${sysuser.roleNames}" var="n">
											<tr align="center">
												<td>${n.names}</td>
											</tr>
										</c:forEach>
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
	<script type="text/javascript">
    function addSysuser(){
  	  $.layer({
		    type: 2,
		    shadeClose: true,
		    title: "添加系统用户",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    area: ['700px', '650px'],
		    iframe: {src: "/sysuser/add"}
		});
  }
  function eidtSysuser(id){
	  $.layer({
		    type: 2,
		    shadeClose: true,
		    title: "修改系统用户",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    area: ['700px', '650px'],
		    iframe: {src: "${cxt}/sysuser/edit/"+id}
		});
}
    function changePassword(id){
    	layer.prompt({title: '修改密码',type: 1,length: 200}, function(val,index){
    		$.ajax({
    			url:"${cxt}/sysuser/changePassword",
    			type:"post",
    			data:{"id":id,"password":val},
    			dataType:"json",
    			success:function(data){
    				if(data.result){
    					 layer.msg('密码修改成功！', 1, 1);
    					 layer.close(index)
    				}else{
    					alert("密码修改失败！");
    				}
    			}
    		});
		});
    }
function freezeAccount(sysuserId,state){
	if(confirm('确认要暂停/恢复该用户账号吗？')){
		$.ajax({
			url:"/sysuser/freeze",
			type:"post",
			data:{"sysuserId":sysuserId,"state":state},
			dataType:"json",
			success:function(result)
			{
				if(result.result=="true")
				{
					alert("操作成功");
					window.location.reload();
				}
				else
				{
					alert(result.result);
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
	<script src="/js/js/top-nav/campus.js"></script>
	<script type="text/javascript">
    function setSysUserGroup(id){
	    $.layer({
		    type: 2,
		    shadeClose: true,
		    title: "角色选择",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['378px', '440px'],
		    iframe: {src: "${cxt}/operator/setGroupToRoles/"+id}
		});
    }
    </script>
</body>
</html>