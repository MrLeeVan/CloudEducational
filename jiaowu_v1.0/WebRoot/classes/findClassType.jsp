<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
.chosen-container {
	margin-top: -4px;
}
</style>
<title>${_res.get('class_type_management')}</title>
</head>
<body>
	<div id="wrapper" style="background: #2f4050; min-width: 1100px;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav" style="min-width: 1000px; width: 100%;">
				<form action="/classtype/index" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;
									<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;
									<a href='/classtype/findClassOrder'>${_res.get("class.group.class.management")}</a> &gt; ${_res.get('class_type_management')}
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          						<div style="clear:both"></div>
							</div>
							<div class="ibox-content">
								<label>${_res.get("District")}:</label>
								<select id="campusSelect" name="_query.classTypeCampus" class="chosen-select" style="display:inline; width:120px;" >
									<option value="">${_res.get('Please.select')}</option>
									<c:forEach items="${userCampus}" var="campus">
										<option value="${campus.id}" <c:if test="${campus.id==paramMap['_query.classTypeCampus']}">selected="selected"</c:if>>${campus.campus_name}</option>
									</c:forEach>
								</select>
								<label>${_res.get("class.name.of.class.type")}：</label> 
								<input type="text" id="typeName" name="_query.typeName" value="${paramMap['_query.typeName']}"> 
								<label>${_res.get('course.subject')}：</label> 
								<select id="subjectid" name="_query.subjectid" class="chosen-select" style="width: 150px;">
									<option value="">${_res.get('Please.select')}</option>
									<c:forEach items="${subject}" var="subject">
										<option value="${subject.id }" 
											<c:if test="${subject.id==paramMap['_query.subjectid'] }">selected="selected"</c:if>>${subject.subject_name }
										</option>
									</c:forEach>
								</select> 
								<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary"> 
								<input type="button" value="${_res.get('Reset')}" onclick="chongzhi()" class="btn btn-outline btn-warning">
								<c:if test="${operator_session.qx_classtypeaddClassType }">
									<input type="button" id="tianjia" value="${_res.get('teacher.group.add')}" onclick="addClassType()" class="btn btn-outline btn-success">
								</c:if>
							</div>
						</div>
					</div>
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>${_res.get('All.class-type.information')}</h5>
							</div>
							<div class="ibox-content">
								<table class="table table-hover table-bordered" width="100%">
									<thead>
										<tr align="center">
											<th class="header">${_res.get("index")}</th>
											<th class="header">${_res.get("District")}</th>
											<th class="header">${_res.get("class.name.of.class.type")}</th>
											<th class="header">${_res.get('course.subject')}</th>
											<th class="header">${_res.get('course.course')}</th>
											<th class="header">${_res.get("operation")}</th>
										</tr>
									</thead>
									<c:forEach items="${showPages.list }" var="ct" varStatus="c">
										<tr class="odd" align="center">
											<td width="3%">${c.count }</td>
											<td width="14%">${ct.campus_name }</td>
											<td width="14%" align="left">${ct.typeName }</td>
											<td width="15%" align="left">${ct.subjectname }</td>
											<td width="39%" align="left">${ct.coursename }</td>
											<td width="15%">
											<c:if test="${operator_session.qx_classtypefindClassOrder }">
												<a href="javascript:void(0)" onclick="window.location.href='/classtype/findClassOrder?_query.typeName=${ct.typeName }&banxing=${ct.id }'">
												${_res.get('classNum')}
												</a>&nbsp;|&nbsp; 
											</c:if> 
											<c:if test="${operator_session.qx_classtypeeditClassType }">
												<a href="javascript:void(0)" onclick="updateClassType(${ct.id }+',2')">${_res.get("Modify")}</a>&nbsp;|&nbsp;
											</c:if> 
											<c:if test="${ct.status == 1 }">
												<a href="javascript:void(0)" onclick="changeClassTypeStatus(${ct.id })">${_res.get("Suspending")}</a>
											</c:if>
											<c:if test="${ct.status == 2 }">
													<a href="javascript:void(0)" onclick="changeClassTypeStatus(${ct.id })">${_res.get('admin.dict.property.status.start')}</a>
											</c:if>
											</td>
											<!-- 	<td><a href="/course/delClassType?type_id=${ct2.id }">删 除</a></td> 
								onclick="window.location.href='/course/editClassType?type_id=${ct2.id }'"
							-->
									</c:forEach>
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
		</div>
	</div>

	<script type="text/javascript">
	
	 function changeClassTypeStatus(id){
	    	if(confirm('确认要暂停/恢复该班型吗？')){
	    		$.ajax({
	    			url:"/classtype/changeClassTypeStatus",
	    			type:"post",
	    			data:{"id":id},
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

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

	<script>
	$(".chosen-select").chosen({disable_search_threshold: 30});
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

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
	<script src="/js/js/top-nav/teach.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块/classtype/editClassType
    </script>

	<script type="text/javascript">
    	function updateClassType(id){
    		$.layer({
        	    type: 2,
        	    shadeClose: true,
        	    title: "${_res.get('Modify.class.type')}",
        	    closeBtn: [0, true],
        	    shade: [0.5, '#000'],
        	    border: [0],
        	    area: ['700px', '300px'],
        	    iframe: {src: '${cxt}/classtype/editClassType/'+id}
        	});
    	}
    	function addClassType(){
    		$.layer({
        	    type: 2,
        	    shadeClose: true,
        	    title: "${_res.get('Add.class.type')}",
        	    closeBtn: [0, true],
        	    shade: [0.5, '#000'],
        	    border: [0],
        	    area: ['700px', '300px'],
        	    iframe: {src: '${cxt}/classtype/addClassType'}
        	});
    	}
    </script>
	<script type="text/javascript">
    	$(function(){
    		$("#subjectid").val("");
    	});
	</script>
	<script>
       $('li[ID=nav-nav6]').removeAttr('').attr('class','active');
    </script>
</body>
</html>