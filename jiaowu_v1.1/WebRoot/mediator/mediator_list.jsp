<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Channel.list')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>
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
 .chosen-container{
   margin-top:-3px;
 }
</style>
<script type="text/javascript">
	function resetSearch() {
		$("#realname").val('');
		/* $("#sysuserid").val(""); */
		$("#sysuserid").html("${_res.get('Please.select')}"); 
		$("#sysuserid option[value='']").attr("selected", true);
		$('#phonenumber').val('');
	}
	
	function modifyMediator(id){
		$.ajax({
			url:"/mediator/modifyMediator",
			type:"post",
			data:{"mediatorId":id},
			dataType:"json",
			success:function(result)
			{
				if(result.result=="true"){
					alert("删除成功");
					window.location.reload();
				}else{
					alert(result.result);
				}
			}
		});
	}
	function addMediator(){
		$.layer({
			type:2,
			shadeClose:true,
			title:"${_res.get('Adding.channels')}",
			closeBtn:[0,true],
			shade:[0.5,'#000'],
			border:[0],
			area:['800px','600px'],
			iframe:{src:'${ctx}/mediator/add'}
		});
	}
	
	function showDetail(id){
		$.layer({
			type:2,
			shadeClose:true,
			title:"${_res.get('Channel.Intelligence')}",
			closeBtn:[0,true],
			shade:[0.5,'#000'],
			border:[0],
			offset:['20px',''],
			area:['800px','600px'],
			iframe:{src:'${ctx}/mediator/view/'+id}
		});
		
	}
	
	function editDetail(id){
			$.layer({
				type:2,
				shadeClose:true,
				title:"${_res.get('Modify')}",
				closeBtn:[0,true],
				shade:[0.5,'#000'],
				border:[0],
				area:['800px','600px'],
				iframe:{src:'${ctx}/mediator/edit/'+id}
			});
	}
	
	function commission(id){
		$.layer({
	        type: 2,
	        title: "${_res.get('Rebate.set')}",
	        maxmin: false,
	        shadeClose: true, //开启点击遮罩关闭层
	        area : ['420px' , '420px'],
	        offset : ['', ''],
	        iframe: {src: '/mediator/transferToCommission/'+id}
	    });
	}
</script>
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
		<form action="/mediator/index" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					      &gt;<a href='/mediator/index'>${_res.get('Channel.Management')}</a> &gt;  ${_res.get('Channel.list')}
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
				<label>渠道：</label>
					<input type="text" id="realname" name="_query.realname" value="${paramMap['_query.realname']}">
				<label>${_res.get("admin.user.property.telephone")}：</label>
				<input type="text" id="phonenumber" name="_query.phonenumber" value="${paramMap['_query.phonenumber']}">
				<label>${_res.get("marketing.specialist")}：</label>
				<select id="sysuserid" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.sysuserid">
					<option value="">--${_res.get('Please.select')}--</option>
					<c:forEach items="${sysUserList}" var="sysUser">
						<option value="${sysUser.id }" <c:if test="${sysUser.id == paramMap['_query.sysuserid'] }">selected="selected"</c:if>>${sysUser.real_name }</option>
					</c:forEach>
				</select>
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
				<input type="button" value="${_res.get('Reset')}" onclick="resetSearch()" class="button btn btn-outline btn-warning ">
				<c:if test="${operator_session.qx_mediatoradd }">
					<input type="button" id="tianjia" value="${_res.get('teacher.group.add')}" onclick="addMediator()" class="btn btn-outline btn-info">
				</c:if>
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>${_res.get('Channel.list')}</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
							<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>渠道</th>
									<th>${_res.get('gender')}</th>
									<th>类型</th>
									<th>${_res.get('Date.Added')}</th>
									<th>${_res.get("admin.user.property.telephone")}</th>
									<th>${_res.get('admin.user.property.email') }</th>
									<th>${_res.get('Affiliation')}</th>
									<th>${_res.get('Recommended')}</th>
									<th>${_res.get("marketing.specialist")}</th>
									<th>${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="mediator" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${mediator.realname}</td>
									<td>${mediator.type==1?(mediator.sex==true?_res.get('student.boy'):_res.get('student.girl')):'-'}</td>
									<td>${mediator.type==1?'个人':mediator.type==2?'公司':'未知'}</td>
									<td><fmt:formatDate value="${mediator.createtime}" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/></td>
									<td>${mediator.phonenumber}</td>
									<td>${mediator.email}</td>
									<td>${mediator.type==1?mediator.companyname:'-'}</td>
									<td>${mediator.parentname}</td>
									<td>${mediator.sysusername}</td>
									<td>
									<c:if test="${operator_session.qx_mediatorview }">
										<a href="#" onclick="showDetail(${mediator.id})" style="color: #515151">${_res.get("admin.common.see")}</a>&nbsp;|
									</c:if>
									<c:if test="${operator_session.qx_mediatoredit }">
										<a href="#" onclick="editDetail(${mediator.id})" style="color: #515151">${_res.get('Modify')}</a>
									</c:if>
									<c:if test="${operator_session.qx_mediatortransferToCommission }">
										<a href="#" onclick="commission(${mediator.id})" style="color: #515151">&nbsp;|&nbsp;${_res.get('Commission.set')}</a>
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

	<script src="/js/js/demo/layer-demo.js"></script>
	
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