<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>${_res.get('student_list') }</title>
<meta name="save" content="history">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet"/>
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
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
 h5{
   font-weight: 100 !important
 }
</style>
</head>
<body id="body" style="min-width:1100px;">   
	<div id="wrapper" style="background: #2f4050;height:100%;">
	 <%@ include file="/common/left-nav.jsp"%>
	 <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			   <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>

        <div class="margin-nav2">
		<form action="/reservation/index" method="post" id="searchForm" >
			<input type="text" id="state" name="_query.state" value="${paramMap['_query.state']}"  style="display:none; ">
			<div  class="col-lg-12 m-t-xzl" style="padding-left:0;">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
						<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a>
						&gt;<a href='/reservation'>${_res.get('Appointment_Test') }</a> &gt; ${_res.get('Reservation_information') }
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
					<label>${_res.get("student.name") }：</label>
					<input type="text" id="studentname" name="_query.studentname" style="width:150px;" value="${paramMap['_query.studentname']}">
					<label>${_res.get("telphone") }：</label>&nbsp;
					<input type="text" id="phonenumber" name="_query.phonenumber" style="width:150px;" value="${paramMap['_query.phonenumber']}">
					<label> ${_res.get("course.consultant")}： </label>
					<select name="_query.kcuserid" id="kcuserId" class="chosen-select" style="width:100px;" tabindex="2">
						<option value="">${_res.get('system.alloptions')}</option>
						<c:forEach items="${kcgwList}" var="sysuser">
							<option value="${sysuser.id}" ${paramMap['_query.kcuserid']==sysuser.id?"selected='selected'":""}>${sysuser.real_name}</option>
						</c:forEach>
					</select>
				 <input type="button" onclick="search()" value="${_res.get('admin.common.select') }" class="btn btn-outline btn-info">
				 <c:if test="${operator_session.qx_reservationtoExcel}">
					 <input type="button" onclick="toExcel()" value="${_res.get('Output')}" class="btn btn-outline btn-info">
				 </c:if>
			      <div style="clear: both;"></div>
			   </div>
			 </div>
		   </div>

			<div class="col-lg-12" style="padding-left:0;">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>${_res.get("student_list") }</h5>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
							<tr align="center">
								<th style="height:15px;line-height: 34px;">${_res.get("index") }</th>
								<th style="height:15px;line-height: 34px;">${_res.get('student.name')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('course.class.date')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('time.session')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('system.campus')}</th>
								<th  style="height:15px;line-height: 34px;">${_res.get('class.classroom')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('teacher.name')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('admin.dict.property.status')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('Order_Placed')}</th>
								<th style="height:10px;line-height: 34px;">${_res.get('type')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('Operator')}</th>
								<th style="height:15px;line-height: 34px;">${_res.get('operation')}</th>
							</thead>
							<c:forEach items="${showPages.list}" var="student" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${student.studentname}</td>
									<td>${student.reservationtime}</td>
									<td>${student.rank_name}</td>
									<td>${student.campus_name}</td>
									<td>${student.classroomname}</td>
									<td>${student.teachername}</td>
									<td>${student.isstate==1?'待确认':student.isstate==2?'已同意':'已拒绝'}</td>
									<td>${student.type==0?"线下":"线上"}</td>
									<td>${student.state==0?_res.get('Is.a.single'):student.state==3?_res.get('Not.a.single'):''}</td>
									<td>${student.username}</td>
										<td align="center">
											<c:if test="${student.isstate==1}">
												<%-- <c:if test="${operator_session.qx_reservationreservationTest}">
													<a href="/reservation/reservationTest?${student.id}" >${_res.get('admin.common.edit')}&nbsp;|</a>
												</c:if> --%>
												<c:if test="${operator_session.qx_reservationisReservation}">
													<a href="javascript:void(0)" onclick="isReservation(${student.id})" >${_res.get('Agree')}&nbsp;|</a>
												</c:if>
												<c:if test="${operator_session.qx_reservationrefuseReservation}">
													<a href="javascript:void(0)" onclick="refuseReservation(${student.id})" >${_res.get('Refuse')}</a>
												</c:if>
											</c:if>
											<c:if test="${student.isstate==2}">	
												<c:if test="${operator_session.qx_reservationaddTestScores}">
													<a href="javascript:void(0)" onclick="testScores(${student.id})" >${_res.get('Test_scores')}&nbsp;|</a>
												</c:if>
												<c:if test="${operator_session.qx_reservationdeleteReservation}">
													<a href="javascript:void(0)" onclick="deleteReservation(${student.id})" >${_res.get('admin.common.delete')}</a>
												</c:if>
											</c:if>	
											<c:if test="${student.isstate==3}">	
												<c:if test="${operator_session.qx_reservationaddTestScores}">
													<a href="javascript:void(0)"  >已被拒绝&nbsp;|</a>
												</c:if>
												<c:if test="${operator_session.qx_reservationdeleteReservation}">
													<a href="javascript:void(0)" onclick="deleteReservation(${student.id})" >${_res.get('admin.common.delete')}</a>
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
			<div style="clear:both "></div>
		</form>
		</div>
	   </div>
	</div>
<!-- Chosen -->
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

    <script>
    $(".chosen-select").chosen({disable_search_threshold: 20});
        var config = {
            '.chosen-select': {},
            '.chosen-select-deselect': {
                allow_single_deselect: true
            },
            '.chosen-select-no-single': {
                disable_search_threshold: 10
            },
            '.chosen-select-no-results': {
                no_results_text: 'Oops, nothing found!'
            },
            '.chosen-select-width': {
                width: "95%"
            }
        }
        for (var selector in config) {
            $(selector).chosen(config[selector]);
        }   
    </script>	
	
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
    <script type="text/javascript">
    function toExcel(){
     	 $("#searchForm").attr("action", "${cxt}/reservation/toExcel");
        $("#searchForm").submit();
        $("#searchForm").attr("action", "${cxt}/reservation/index");
    }
    function isReservation(studentid){
    	if(confirm("确认同意预约吗?")){
    		$.ajax({
    			url:'/reservation/isReservation',
    			type:'post',
    			data:{'id':studentid},
    			dataType:'json',
    			success:function(data){
    				if(data==0){
    					layer.msg("已同意，信息已添加到查课表",1,1);
    				}else{
    					layer.msg("确认失败，请联系管理员",2,1);
    				}
    				window.location.reload();
    			}
    		})
    	}
    }
 	
    function deleteReservation(id){
    	if(confirm("确认删除预约吗?")){
    		$.ajax({
    			url:'/reservation/deleteReservation',
    			type:'post',
    			data:{'id':id},
    			dataType:'json',
    			success:function(data){
    				if(data==0){
    					layer.msg("删除成功，并且此次预约测试信息已删除",1,1);
    				}else{
    					layer.msg("拒绝失败，请联系管理员",2,1);
    				}
    				window.location.reload();
    			}
    		})
    	}
    }
    function testScores(id){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "${_res.get('Test_scores')}",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    offset:['100px', ''],
    	    area: ['700px', '600px'],
    	    iframe: {src: '${cxt}/reservation/addTestScores/'+id}
    	});
    }
    function refuseReservation(id){
    	if(confirm("确认拒绝预约吗?")){
    		$.ajax({
    			url:'/reservation/refuseReservation',
    			type:'post',
    			data:{'id':id},
    			dataType:'json',
    			success:function(data){
    				if(data==0){
    					layer.msg("已拒绝，并且此次预约测试信息已删除",1,1);
    				}else{
    					layer.msg("拒绝失败，请联系管理员",2,1);
    				}
    				window.location.reload();
    			}
    		})
    	}
    }
    </script>
  		<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				date2.min = datas; //开始日选好后，重置结束日的最小日期
				date2.start = datas //将结束日的初始值设定为开始日
			}
		};
		var date2 = {
			elem : '#date2',
			format : 'YYYY-MM-DD',
			max : '2099-06-16',
			istime : false,
			istoday : false,
			choose : function(datas) {
				date1.max = datas; //结束日选好后，重置开始日的最大日期
			}
		};
		laydate(date1);
		laydate(date2);
	</script>
	
  	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script>
    $('li[ID=nav-nav21]').removeAttr('').attr('class','active');
    //$(".left-nav").css("height", window.screenLeft);
    //alert($("#wrapper").outerHeight(true));
    </script>
</body>
</html>