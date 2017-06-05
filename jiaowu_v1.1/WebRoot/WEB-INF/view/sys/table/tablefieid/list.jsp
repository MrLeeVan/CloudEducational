<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>系统表字段结构</title>
<%@ include file="/common/headExtraction.jsp" %>
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
	      <form action="/system/tablefieid/list" method="post" id="searchForm">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
				    <div class="ibox-title">
					   <h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
						<a href="javascript:window.parent.location='/system/index'"><jf:i18n key="common.mainPage" /></a>
						&gt;<a href='#'>数据管理</a> &gt;系统数据表字段
					   </h5>
					</div>
					<div class="ibox-content">
						<h4>筛选查询</h4>
						<input type="hidden" name="_query.TABLE_NAME" value="${paramMap['_query.TABLE_NAME']}">
						<label>字段名：</label>
						<input type="text" name="_query.COLUMN_NAME" value="${paramMap['_query.COLUMN_NAME']}">
						<label>界面展示名称(注释)：</label>
						<input type="text" name="_query.COLUMN_COMMENT" value="${paramMap['_query.COLUMN_COMMENT']}">
						<button type="submit" class="btn btn-default btn-rounded">搜索一下</button>
					</div>
				</div>
			</div>
				
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<%@ include file="/common/toolButtonExtraction.jsp" %>
						<c:if test="${operator_session.qx_systemtablefieidsave}">
							<%-- <button class="btn btn-primary btn-sm layerIframe" type="button" data-url="/system/tablefieid/add?tableName=${paramMap['_query.tableName']}" data-title="新建一个字段">新建一个字段</button> --%>
						</c:if>
					</div>
					<div class="ibox-content">
						<table class="table table-striped" width="100%">
							<thead>
								<tr>
									<th width="40px">序号</th>
									<th>字段名</th>
									<th>界面展示名称(注释)</th>
									<th>表名</th>
									<th>类型</th>
									<th>长度</th>
									<th>小数点</th>
									<th>可空吗</th>
									<th>主键</th>
									<th>默认值</th>
									<th>字符集</th>
									<th>排序规程</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="v" varStatus="i">
								<tr class="odd" align="center">
									<td >
										<div class="btn-group">
			                                <button class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${i.count} &nbsp;操作<span class="caret"></span></button>
			                                <ul class="dropdown-menu">
			                                    <c:if test="${operator_session.qx_systemtablefieidupdate}">
			                                   		<li><a data-url="/system/tablefieid/edit?id=${v.id}" data-title="修改字段" class="layerIframe">修改这个字段</a></li>
			                                    </c:if>
			                                    <c:if test="${operator_session.qx_systemtablefieiddelete}">
			                                    	<li><a data-url="${cxt }/system/tablefieid/delete?id=${v.id}" data-title="删除" class="customAjax">删除这个字段</a></li>
			                                    </c:if>
			                                </ul>
			                            </div>
		                            </td>
									<td >${v.COLUMN_NAME}</td>
									<td >${v.COLUMN_COMMENT}</td>
									<td >${v.TABLE_NAME}</td>
									<td >${v.DATA_TYPE}</td>
									<td >${v.CHARACTER_MAXIMUM_LENGTH}</td>
									<td >${v.NUMERIC_PRECISION}</td>
									<td >${v.IS_NULLABLE}</td>
									<td >${v.COLUMN_KEY}</td>
									<td >${v.COLUMN_DEFAULT}</td>
									<td >${v.CHARACTER_SET_NAME}</td>
									<td >${v.COLLATION_NAME}</td>
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
	<script type="text/javascript">
		/* 自定义函数开始 */
		$(document).ready(function() {
			//新建
			$(".layerIframe").on("click", function() {
				var _this = $(this);
				$.layer({
					type : 2,
					shadeClose : true,
					title : _this.attr("data-title"),
					closeBtn : [ 0, true ],
					shade : [ 0.5, '#000' ],
					border : [ 0 ],
					offset : [ '20px', '' ],
					area : [ '400px', '600px' ],
					iframe : {
						src : _this.attr("data-url")
					}
				});
			});

			//删除
			$(".customAjax").on("click", function() {
				var _this = $(this);
				$.ajax({
					type : "post",
					url : _this.attr("data-url"),
					datatype : "json",
					success : function(returnValue) {
						if (1 == returnValue) {
							parent.window.location.reload();
						} else if ((-1) == returnValue) {
							layer.msg(_this.attr("data-title") + "异常", 1, 2);
						} else {
							layer.msg(_this.attr("data-title") + "失败", 1, 2);
						}
					}
				});
			});

		});
		
	</script>
</body>
</html>