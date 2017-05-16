<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>系统结构</title>
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
	      <form action="/system/table/list" method="post" id="searchForm">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
				    <div class="ibox-title">
					   <h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
						<a href="javascript:window.parent.location='/system/index'"><jf:i18n key="common.mainPage" /></a>
						&gt;<a href='#'>数据管理</a> &gt;系统数据表
					   </h5>
					</div>
					<div class="ibox-content">
						<h4>筛选查询</h4>
						<label>表名：</label>
						<input type="text" name="_query.TABLE_NAME" value="${paramMap['_query.TABLE_NAME']}">
						<label>简介：</label>
						<input type="text" name="_query.TABLE_COMMENT" value="${paramMap['_query.TABLE_COMMENT']}">
						<button type="submit" class="btn btn-default btn-rounded">搜索一下</button>
					</div>
				</div>
			</div>
				
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
                        <%@ include file="/common/toolButtonExtraction.jsp" %>
						<!-- <button class="btn btn-primary btn-sm" type="button" id="pageAdd">新建一个表</button> -->
					</div>
					<div class="ibox-content">
						<table class="table table-striped" width="100%">
							<thead>
								<tr>
									<th width="40px">序号</th>
									<th>表名</th>
									<th>简介</th>
									<th>引擎</th>
									<th>行数</th>
									<th>数据量</th>
									<th>创建时间</th>
									<th>更新时间</th>
									<th>字符集规则</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="v" varStatus="i">
								<tr class="odd" align="center">
									<td >
										<div class="btn-group">
			                                <button class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown" aria-expanded="false">${i.count} &nbsp;操作<span class="caret"></span></button>
			                                <ul class="dropdown-menu">
			                                    <li><a href="${cxt }/system/tablefieid/list?_query.TABLE_NAME=${v.TABLE_NAME}">表字段结构</a>
			                                    </li>
			                                    <li><a href="buttons.html#">修改表名</a>
			                                    </li>
			                                    <li><a href="buttons.html#">删除这个表</a>
			                                    </li>
			                                </ul>
			                            </div>
		                            </td>
									<td >${v.TABLE_NAME}</td>
									<td >${v.TABLE_COMMENT}</td>
									<td >${v.ENGINE}</td>
									<td >${v.TABLE_ROWS}</td>
									<td >${v.AUTO_INCREMENT}KB</td>
									<td >${v.CREATE_TIME}</td>
									<td >${v.UPDATE_TIME}</td>
									<td >${v.TABLE_COLLATION}</td>
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
			
	       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
			
			//新建
			$("#pageAdd").on("click", function() {
				$.layer({
					type : 2,
					shadeClose : true,
					title : "新建",
					closeBtn : [ 0, true ],
					shade : [ 0.5, '#000' ],
					border : [ 0 ],
					offset : [ '20px', '' ],
					area : [ '400px', '250px' ],
					iframe : {
						src : "/system/table/add"
					}
				});
			});

		});
	</script>
</body>
</html>