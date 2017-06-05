<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>校区管理</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">
function delCampus(campusId){
	if(confirm('确认停用该校区吗')){
		//parent.location.reload();  
		$.ajax({
			url:"/campus/delCampus1",
			type:"post",
			data:{"campusId":campusId},
			dataType:"json",
			success:function(result) {
				if(result.result=="true") {
					alert("更改成功");
					window.location.reload();
				}
				else {
					if(confirm(result.result)) {
						$.ajax({
							url:"/campus/delCampus2",
							type:"post",
							data:{"campusId":campusId},
							dataType:"json",
							success:function(result) {
								if(result.result=="true") {
									alert("更改成功");
									window.location.reload();
								}
								else {
									alert(result.result);
								}
							}
						});
					}
				}
			}
		});
	}
}


</script>

</head>
<body>
<div id="wrapper" style="background: #2f4050;">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="margin-nav">	
  <div class="col-lg-12">
	<div class="ibox float-e-margins">
	    <div class="ibox-title" style="margin-bottom:20px">
			<h5>
			     <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
			     &gt;<a href='/sysuser/index'>机构管理</a> &gt; 校区管理
			</h5>
			<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          	<div style="clear:both"></div>
		</div>
		<div class="ibox-title">
			<h5>全部校区信息</h5>
			<div style="float:right;margin:-10px 5px 0 0"><input type="button" class="navbar-right btn btn-outline btn-primary"  value="${_res.get('teacher.group.add')}" onclick="window.location.href='/campus/addCampusManager'"/></div>
		</div>	
		<div class="ibox-content">
		    <table class="table table-hover table-bordered">
		         <thead>
						<tr>
							<th>${_res.get("index")}</th>
							<th>校区名称</th>
							<th>${_res.get('person.in.charge')}</th>
							<th>${_res.get("admin.user.property.telephone")}</th>
							<th>校区地址</th>
							<th>校区类型</th>
							<th>签到IP限制</th>
							<th>全职签到</th>
							<th>兼职签到</th>
							<th>操 作</th>
						</tr>
				 </thead>		
				 <c:forEach items="${campus}" var="campus" varStatus="s">
						<tr align="center">
							<td>${s.count }</td>
							<td>${campus.campus_NAME }</td>
							<td>${campus.REAL_NAME }</td>
							<td>${campus.tel }</td>
							<td>${campus.campus_ADDR }</td>
							<td>${campus.campustype==1?'本校':'合作院校' }</td>
							<td>${campus.limitip==true?_res.get('admin.common.yes'):_res.get('admin.common.no')}</td>
							<td>${campus.fullsign==true?_res.get('admin.common.yes'):_res.get('admin.common.no')}</td>
							<td>${campus.partsign==true?_res.get('admin.common.yes'):_res.get('admin.common.no')}</td>
							<td>
								<c:if test="${operator_session.qx_campusshowCampusMassage }">
								   <a href="javascript:void(0)" onclick="showCampusMassage(${campus.id })" >${_res.get("admin.common.see")}</a>
								</c:if>
							   <c:if test="${operator_session.qx_campusfindClassroomManager }">
								   <a href="javascript:void(0)" onclick="window.location.href='/campus/findClassroomManager?campusId=${campus.id }'" >教室管理</a>
							   </c:if>
							   <c:if test="${operator_session.qx_campuseditCampusManager }">
								   <a href="javascript:void(0)" onclick="window.location.href='/campus/editCampusManager?campusId=${campus.id }'" >${_res.get('Modify')}</a>
							   </c:if>
							   <c:if test="${operator_session.qx_campusdelCampus1 && operator_session.qx_campusdelCampus2 }">
								   <a ${campus.state==1?"style='color:#a94442'":''}href="javascript:void(0)" onclick="delCampus(${campus.id })" >${campus.state==1?_res.get('admin.dict.property.status.start'):campus.state==0?_res.get('admin.dict.property.status.stop'):''}</a>
							   </c:if>
							</td>
						</tr>
				 </c:forEach>
			</table>
		</div>
	</div>
  </div>
  <div style="clear:both;"></div>
  </div>	
  </div>	
</div>  

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/campus.js"></script>
    <script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script type="text/javascript">
    	function showCampusMassage(id){
    		$.layer({
    			 type: 2,
    	    	    shadeClose: true,
    	    	    title: "校区信息",
    	    	    closeBtn: [0, true],
    	    	    shade: [0.5, '#000'],
    	    	    border: [0],
    	    	    offset:['100px', ''],
    	    	    area: ['700px', '240px'],
    	    	    iframe: {src: '${cxt}/campus/showCampusMassage/'+id}
    		});
    	}
	    /* function showCampusMassage(id){
	    	$.ajax({
	    		url:"/campus/showCampusMassage",
	    		type:"post",
	    		dataType:"json",
	    		data:{"campusId":id},
	    		success: function(result){
	    			layer.tab({
	    			    data:[
	    			        {
	    			        	title: '校区基本信息', 
	    			        	content:'<table class="table table-bordered">'
	    			        	+'<tr>'
	    			        	+'<td class="table-bg1 table-wh1">校区名称</td><td class="table-bg2 table-wh2">'+result.campus.CAMPUS_NAME+'</td>'
	    			        	+'<td class="table-bg1 table-wh1">负责人</td><td class="table-bg2 table-wh2">'+(result.campus.FZRNAME==null?'':result.campus.FZRNAME)+'</td>'
	    			        	+'</tr>'
	    			        	+'<tr>'
	    			        	+'<td class="table-bg1 table-wh1">教务负责人</td><td class="table-bg2 table-wh2">'+(result.campus.JWFZRNAME==null?'':result.campus.JWFZRNAME)+'</td>'
	    			        	+'<td class="table-bg1 table-wh1">市场负责人</td><td class="table-bg2 table-wh2">'+(result.campus.SCFZRNAME==null?'':result.campus.SCFZRNAME)+'</td>'
	    			        	+'</tr>'
	    			        	+'<tr>'
	    			        	+'<td class="table-bg1 table-wh1">课程顾问负责人</td><td class="table-bg2 table-wh2">'+(result.campus.KCFZRNAME==null?'':result.campus.KCFZRNAME)+'</td>'
	    			        	+'<td class="table-bg1 table-wh1">校区电话</td><td class="table-bg2 table-wh2">'+(result.campus.TEL==null?'':result.campus.TEL)+'</td>'
	    			        	+'</tr>'
	    			        	+'<tr>'
	    			        	+'<td class="table-bg1 table-wh1">校区地址</td><td class="table-bg2" colspan=3>'+(result.campus.CAMPUS_ADDR==null?'':result.campus.CAMPUS_ADDR)+'</td>'
	    			        	+'</tr>'
	    			        	+'</table>'
	    			        },
	    			    ],
	    				offset:['150px', ''],
	    			    area: ['500px', 'auto'] //宽度，高度
	    			});
	    		}
	    	});
	    } */
    </script>

</body>
</html>