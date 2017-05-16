<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>字典数据</title>
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

	    <div class="margin-nav" style="min-width:1050px;width:100%;">	
		<form action="/system/dict/list" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
					    <a href="javascript:window.parent.location='/system/index'">${_res.get('admin.common.mainPage')}</a> 
					    &gt;<a href=''>系统管理</a> &gt; 字典参数
				   </h5>
				</div>
				<div class="ibox-content">
				<%-- <input type="button" onclick="search()" value="<jf:i18n key='common.select' />" class="btn btn-outline btn-primary"> --%>
				<input type="button" id="tianjia" value="添加" onclick="addDict()" class="btn btn-outline btn-info">
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>数据字典</h5>
					</div>
					<div class="ibox-content">
						<table id="treeTable" class="table table-striped copy" style="width:100%">
							<tr >
								<td  > <span controller="true">层级</span>  </td>
								<td >名称 </td>
								<td >VAL  </td>
								<td >NUMBERS  </td>
								<td >状态  </td>
								<td >操作  </td>
							</tr>
							
							<c:forEach items="${dictlist}" var="dict" varStatus="index">
								<tr id="${dict.id }" pId="" hasChild="true" >
									<td class="textleft"> <span controller='true'> ${dict.levels } 级 </span></td>
									<td>${dict.dictname }</td>
									<td>${dict.val }</td>
									<td>${dict.numbers }</td> 
									<td>${dict.state == 1?"启用":"停用" }</td>
									<td><a class='btn btn-xs btn-primary' onclick="fastAddDict('${dict.id}')" >添加子级</a>
										<a class="btn btn-xs btn-primary" onclick="editDict('${dict.id}')" >编辑</a></td>
								</tr>
							</c:forEach>
						
						</table>
					</div>
				</div>
			</div>
			<div style="clear: both;"></div>
		</form>
	 </div>
	 </div>	
	</div>
<script type="text/javascript" src="/js/treeTable/script/treeTable/jquery.treeTable.js"></script>
<script type="text/javascript">

	$(function(){
	    var option = {
	        theme:'vsStyle',
	        expandLevel : 1,
	        beforeExpand : function($treeTable, id) {
	            if ($('.' + id, $treeTable).length) {
	             return;
	            }
	            $.post("/system/dict/treeTable", { pId: id }, function(data){
	             if(data.indexOf("tr") != -1){
	              $treeTable.addChilds(data);
	             }
	            }, "text");
	        },
	        onSelect : function($treeTable, id) {
	            window.console && console.log('onSelect:' + id);
	        }
	    };
	    option.theme = 'default';
	    $('#treeTable').treeTable(option);
	});

    function addDict(){
    	$.layer({
       	    type: 2,
       	    shadeClose: true,
       	    title: "添加字典项",
       	    closeBtn: [0, true],
       	    shade: [0.5, '#000'],
       	    border: [0],
       	    offset:['20px', ''],
       	    area: ['620px', '710px'],
       	    iframe: {src: "/system/dict/addDict"}
       	});
    }
    
    function editDict(id){
    	$.layer({
       	    type: 2,
       	    shadeClose: true,
       	    title: "修改字典项",
       	    closeBtn: [0, true],
       	    shade: [0.5, '#000'],
       	    border: [0],
       	    offset:['20px', ''],
       	    area: ['620px', '710px'],
       	    iframe: {src: "/system/dict/editDict/"+id}
       	});
    	
    }
    
    function fastAddDict(id){
    	$.layer({
       	    type: 2,
       	    shadeClose: true,
       	    title: "添加子级字典项",
       	    closeBtn: [0, true],
       	    shade: [0.5, '#000'],
       	    border: [0],
       	    offset:['20px', ''],
       	    area: ['620px', '710px'],
       	    iframe: {src: "/system/dict/fastAddDict/"+id}
       	});
    	
    }
    
    function search(){
    	$("#searchForm").submit();
    }
    
    </script>
</body>
</html>