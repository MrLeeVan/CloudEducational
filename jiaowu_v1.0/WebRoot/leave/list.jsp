<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibfile.jsp" %>

<!DOCTYPE html>
<html>
<head>
	<title>学生请假列表</title>
	<jsp:include page="/common/headcssfile.jsp" />
	<style type="text/css">
		td{ text-align: center; }
		.control-label{ text-align: right; padding-left:15px;}
	</style>
	
	<script type="text/javascript" src="/jquery/jquery-2.1.1.min.js"></script>
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
	    		<form action="/leave/list" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
								    <a href="javascript:window.parent.location='/system/index'">首页</a> 
								    &gt;请假管理&gt;请假记录
				   				</h5>
							</div>
							<div class="ibox-content">
								<input type="hidden" name="_query.queryType" id="queryType" value="${paramMap['_query.queryType'] }" />
								<div class="flt m-r-10" >
									<label >学生姓名：</label>
									<input type="text" id="queryName" class=" input-xlarge input-s-sm" name="_query.stuName" 
										value="${paramMap['_query.stuName']}" />
								</div>
								<div class="flt m-r-10" >
									<label class="control-label" >请假日期：</label>
									<input type="text" id="queryLeaveDay" class="znzhong input-s-sm" name="_query.queryLeaveDay" 
										value="${paramMap['_query.queryLeaveDay']}" readonly="readonly" />
								</div>
								<div class="flt m-r-10" >
									<label class="control-label" >申请状态：</label>
									<select class="chosen-select input-s-sm" name="_query.queryStatus" id="queryStatus" >
										<option value="" >请选择</option>
										<option value="0" ${paramMap['_query.queryStatus'] eq '0' ? 'selected="selected"':'' }  
											class="askingState" stateCode="awaitingReview" ></option>
										<option value="4" ${paramMap['_query.queryStatus'] eq '4' ? 'selected="selected"':'' } 
											class="askingState" stateCode="underReview" ></option>
										<option value="2" ${paramMap['_query.queryStatus'] eq '2' ? 'selected="selected"':'' } 
											class="askingState" stateCode="approval" ></option>
										<option value="3" ${paramMap['_query.queryStatus'] eq '3' ? 'selected="selected"':'' }  
											class="askingState" stateCode="reviewFail" ></option>
										<c:if test="${paramMap['_query.queryType'] eq '0' }" >
											<option value="1" ${paramMap['_query.queryStatus'] eq '1' ? 'selected="selected"':'' }  
												class="askingState" stateCode="revocation" ></option>
										</c:if>
									</select>
								</div>
								<div class="flt m-r-10" >
									<input type="button" onclick="search()" value="查询" class="btn btn-outline btn-primary m-l" />
									<c:if test="${operator_session.qx_leavenewAsking }">
				         				<input type="button" id="tianjia" class="btn btn-outline btn-primary" value="添加申请" 
				         					onclick="javascript:window.location.href='/leave/newAsking'" />
				        			</c:if>
								</div>
								<div style="clear:both;" ></div>
							</div>
						</div>
					</div>
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<c:if test="${paramMap['_query.queryType'] ne '0' }">
									<h5>请假记录</h5>
									<input type="button" onclick="viewMyApplicationLists(0)" 
										value="我的申请" class="btn btn-xs btn-primary m-l-xl " />
								</c:if>
								<c:if test="${paramMap['_query.queryType'] eq '0' }">
									<h5>我的申请</h5>
									<input type="button" onclick="viewMyApplicationLists(1)" 
										value="请假记录" class="btn btn-xs btn-primary m-l-xl " />
								</c:if>
								<c:if test="${operator_session.qx_leavemyAwaiting }">
			         				<input type="button" class="btn btn-xs btn-info " value="待我审批" 
			         					onclick="javascript:window.location.href='/leave/myAwaiting'" />
								</c:if>
							</div>
							<div class="ibox-content">
								<table width="80%" class="table table-striped textcenter" >
									<thead>
										<tr>
											<th>序号</th>
											<th>申请日期</th>
											<th>学生姓名</th>
											<th>请假类型</th>
											<th>开始时间</th>
											<th>结束时间</th>
											<th>申请状态</th>
											<th>操作</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${splitPage.page.list }" var="asking" varStatus="index" >
											<tr>
												<td >${index.count }</td>
												<td>${asking.createdate }</td>
												<td>${asking.stuName }</td>
												<td>${asking.type }</td>
												<td>${asking.starttime }</td>
												<td>${asking.endtime }</td>
												<td class="askingState" stateCode="${asking.stateCode }" ></td>
												<td id="${asking.id}" >
													<a href="/leave/viewAskingDetail/${asking.id }" 
														 class="btn btn-info btn-xs" >详情</a>
													<c:if test="${paramMap['_query.queryType'] eq '0' && asking.state == 0  }"  >
														<a onclick="revocation( ${asking.id} )" class="btn btn-xs btn-danger" >
															<jf:i18n key="common.revocation"/> </a>
													</c:if>
												</td>
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
				</form>
				<div style="clear: both;"></div>
			</div>
			<div style="clear: both;"></div>
		</div>	
	</div>
	<script src='/jquery/jquery.i18n.properties-1.0.9.js'></script>
	<script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
	<jsp:include page="/common/headjsfile.jsp" />
    <script type="text/javascript">

		$( document ).ready( function () {
				
			jQuery.i18n.properties( {
		            name : 'strings', //资源文件名称
		            path : '/i18n/', //资源文件路径
		            mode : 'map', //用Map的方式使用资源文件中的值
		            language : '${i18nstate}' ,
		            callback : function() {
		    		$( ".askingState" ).each( function() {
		    			 $( this).html( $.i18n.prop( $( this ).attr( "stateCode" ) ) );
		    		} );
		            }
				} );
			
			$( "#queryStatus" ).trigger( "chosen:updated" );
			
			laydate( {
	            elem: '#queryLeaveDay',
	            format: 'YYYY-MM-DD',
	            istime: false,
	            istoday: false,
	        } );
				
		} );
    	function viewMyApplicationLists( type ) {
    		$( "#queryType" ).val( type );
    		search();	
    	}
    	
    	
    	function revocation( askingId ) {
    		if( confirm( "<jf:i18n key='common.suretorevocation' />" ) ) {
    			$.ajax( {
    				url : "/teaching/students/leaveasking/revocation",
    				data: { "askingId" : askingId },
    				dataType : "json",
    				type : "post",
    				async : false,
    				success : function( result ) {
    					$( "#searchForm" ).submit();
    				}
    			} );
    		}
    	}
    	
    	
    </script>
</body>
</html>