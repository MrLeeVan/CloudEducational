<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>教室管理</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" /> 
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">

	function chongzhi() {
		$('#classAddr').val('');
	}
	function delRoom(roomId,state)
	{  
		if(confirm('确认修改教室使用状态吗？')){
			$.ajax({
				url:"/campus/delClassroom",
				type:"post",
				data:{"roomId":roomId,"state":state},
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
<style type="text/css">
.stu_name {
	position: relative;
	margin-bottom: 15px;
}

.stu_name label {
	display: inline-block;
	font-size: 12px;
	vertical-align: middle;
	width: 170px;
}

.student_list_wrap {
	position: absolute;
	top: 28px;
	left: 14.8em;
	width: 130px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 8px;
}

.student_list_wrap li {
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: text;
}

.teacherTimeRankWrap {
	position: absolute;
	left: 37em;
	top: 16em;
	padding: 10px;
	overflow: hidden;
	z-index: 2013;
	background: #FCF2CF;
	border: 1px solid #F8BD81;
	box-shadow: 2px 2px 3px #DDD;
}

.teacherTimeRankWrap h1 {
	line-height: 24px;
	text-align: center;
	font-size: 14px;
	font-weigth: bold;
	margin-bottom: 10px;
	padding-bottom: 6px;
	border-bottom: 1px dotted #F8BD81;
}

#timeRankCloseBtn {
	display: inline-block;
	float: right;
	width: 18px;
	height: 18px;
	cursor: pointer;
}

#teacherTimeRank p {
	line-height: 24px;
	margin: 0;
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;">
  <div class="left-nav"><%@ include file="/common/left-nav.jsp"%></div>
   <div class="gray-bg dashbard-1" id="page-wrapper">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
   </div>
   
   <div class="margin-nav1">
   <div class="ibox float-e-margins">
   <div class="ibox-title">
	  <h5>
		<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
		&gt;<a href='/sysuser/index'>机构管理</a> &gt;<a href="/campus/findCampusManager">校区管理</a>&gt; 教室管理
	  </h5>
	  <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
      <div style="clear:both"></div>
   </div>
   <div class="ibox-content" style="height:auto;">
     <form action="/campus/findClassroomManager" method="post" id="searchForm">
			<input type="hidden" id="wherepage" name="page" value="1"/>
			<input type="hidden"  name="campusId" value="${campusId}"/>
			<fieldset>
				教室名称：<input type="text" id="classAddr" name="classAddr" value="${classAddr}">
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary"/>
				<input type="button" value="${_res.get('Reset')}" onclick="chongzhi()" class="btn btn-outline btn-success"/>
				<c:if test="${operator_session.qx_campusaddClassroomManager }">
				<input type="button" value="${_res.get('teacher.group.add')}" onclick="addRoom(${campusId})" class="btn btn-outline btn-success"/>
				</c:if>
			</fieldset>
	</form>
   </div>	
  </div>
   
   <div style="margin-top:20px;">
     <div class="ibox float-e-margins">
        <div class="ibox-title">
           <h4>${campus.CAMPUS_NAME }校区教室列表</h4>
        </div>
        <div class="ibox-content">
           <fieldset>
					<table class="table table-hover table-bordered">
					   <thead>
						<tr align="center">
							<th>${_res.get("index")}</th>
							<th>教室名称</th>
							<th>教室地址</th>
							<th>最大人数</th>
							<th>状态</th>
							<th>操 作</th>
						</tr>
					   </thead>	
						<c:forEach items="${classPage}" var="classroom" varStatus="s">
							<tr align="center">
								<td>${s.count }</td>
								<td>${classroom.NAME }</td>
								<td>${classroom.address }</td>
								<td>${classroom.maxpeople }</td>									
								<td>
								<c:choose>
									<c:when test="${classroom.state==1}">停用</c:when>
									<c:otherwise>正常</c:otherwise>
								</c:choose>
								</td>									
								<td>
									<%-- <a href="javascript:void(0)" onclick="window.location.href='/campus/editClassroomManager?classroom_id=${classroom.id }'" >${_res.get('Modify')}</a>
								  &nbsp;|&nbsp; --%>
								  <c:if test="${operator_session.qx_campusdelClassroom }">
								  <c:choose>
									<c:when test="${classroom.state==1}">
									  <a href="javascript:void(0)" onclick="delRoom(${classroom.id },0)" >${_res.get('admin.dict.property.status.start')}</a>&nbsp;|&nbsp;								  
									</c:when>
									<c:otherwise>
									  <a href="javascript:void(0)" onclick="delRoom(${classroom.id },1)" >${_res.get('admin.dict.property.status.stop')}</a>&nbsp;|&nbsp;									  
									</c:otherwise>
								</c:choose>
								  </c:if>
								  <c:if test="${operator_session.qx_campustoModifyClassroom }">
									<a href="#" onclick="modify(${classroom.id})">${_res.get('Modify')}</a>
								  </c:if>
								</td>
							</tr>
						</c:forEach>
					</table>
					<div style="margin-top:20px;"><jsp:include page="/common/showPage.jsp" /></div>
				</fieldset>          
        </div>
     </div>
   </div>     
  </div>  
</div>
</div>
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
    
    function modify(id){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "修改教室信息",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    area: ['400px', '280px'],
    	    //把获得的数据（id）传到controller
    	    iframe: {src: '${cxt}/campus/toModifyClassroom/'+id}//对应的controller的方法
    	});
    }
    function addRoom(id){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "修改教室信息",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    area: ['400px', '280px'],
    	    //把获得的数据（id）传到controller
    	    iframe: {src: '${cxt}/campus/addClassroomManager/'+id}//对应的controller的方法
    	});
    }
    </script>
    <script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
</body>
</html>