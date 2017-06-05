<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">
	
</script>
<title>${_res.get('class_management')}</title>
</head>
<body>
	<div id="wrapper" style="background: #2f4050; min-width: 1100px">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav" style="min-width: 1000px; width: 100%;">
				<form action="/classtype/findClassOrder" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;
									<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>&gt;
									<a href='/classtype/findClassOrder'>${_res.get("class.group.class.management")}</a>&gt; ${_res.get("class.group.class.management")}
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          						<div style="clear:both"></div>
							</div>
							<div class="ibox-content">
								<label>${_res.get("District")}:</label>
								<select id="campusSelect" name="_query.classCampus" class="chosen-select" style="display:inline; width:120px;" >
									<option value="">${_res.get('Please.select')}</option>
									<c:forEach items="${userCampus}" var="campus">
										<option value="${campus.id}" <c:if test="${campus.id==paramMap['_query.classCampus']}">selected="selected"</c:if>>${campus.campus_name}</option>
									</c:forEach>
								</select>
								<label>${_res.get("class.number")}：</label>
								<input type="text" id="className" name="_query.className" value="${paramMap['_query.className']}">&nbsp; &nbsp; 
								<label>${_res.get('class.class.type')}：</label>
								<select id="banxing" name="_query.classTypeId" class="chosen-select" style="display:inline; width:120px;" >
									<option value="">${_res.get('Please.select')}</option>
									<c:forEach items="${classTypeList }" var="classType">
										<option value="${classType.id}" <c:if test="${classType.id==paramMap['_query.classTypeId']}">selected="selected"</c:if>>${classType.name}</option>
									</c:forEach>
								</select>
								&nbsp; &nbsp; 
								<label>${_res.get('course.consultant')}：</label> 
								<select name="_query.pcid" class="chosen-select" style="display: inline; width: 150px;">
									<option value="">${_res.get('Please.select')}</option>
									<c:forEach items="${userlist}" var="kc">
										<option value="${kc.id}" <c:if test="${kc.id==paramMap['_query.pcid']}">selected="selected"</c:if>>${kc.real_name}</option>
									</c:forEach>
								</select>
								<br>
								<br> <label>${_res.get("class.starting.date")}：</label> <input type="text" name="_query.teachtimefirst" id="date1" readonly="readonly" value="${date1 }" />&nbsp;-- <input type="text" name="_query.teachtimeend" id="date2" readonly="readonly" value="${date2 }" />
								<input type="button" onclick="sendMessage(0)" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">&nbsp;
								<c:if test="${operator_session.qx_classtypeaddClassOrder }">
									<input type="button" id="tianjia" class="btn btn-outline btn-success" value="${_res.get('teacher.group.add')}" onclick="addClassOrder()">
								</c:if>
								<!-- </div> -->
								<input type="hidden" id="jieke" name="_query.jieke" value="">
							</div>
						</div>
					</div>

					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title" style="height: 51px;">
								<h5>${_res.get('All.flights.information')}</h5>
								<div style="float: right;">
									<input type="button" id="s_1" onclick="sendMessage(1)" value="${_res.get('Completed')}" class="btn btn-outline btn-primary btn-xs"> 
									<input type="button" id="s_2" onclick="sendMessage(2)" value="${_res.get('On-going')}" class="btn btn-outline btn-primary btn-xs">
								</div>
							</div>
							<div class="ibox-content">
								<table class="table table-hover table-bordered">
									<thead>
										<tr>
											<th>${_res.get("index")}</th>
											<th>${_res.get('District')}</th>
											<th>${_res.get('class.number')}</th>
											<th>${_res.get('course.consultant')}</th>
											<th>${_res.get('teacher.name')}</th>
											<th>${_res.get("class.name.of.class.type")}</th>
											<th>${_res.get("class.number.of.students")}</th>
											<th>${_res.get("class.number.of.class.sessions")}</th>
											<th>${_res.get("class.expense.in.total")}</th>
											<th>${_res.get("class.starting.date")}</th>
											<th>${_res.get("admin.sysLog.property.enddate")}</th>
											<th>${_res.get("operation")}</tH>
										</tr>
									</thead>
									<c:forEach items="${showPages.list }" var="order" varStatus="c">
										<tr align="center">
											<td>${c.count }</td>
											<td>${order.campus_name}</td>
											<td align="left">
											<c:if test="${operator_session.qx_classtypeshowBanciDetail }">
												<c:choose> 
													<c:when test="${order.chargeType == 0}">   
													  【${_res.get('byTeachingHours')}】
													</c:when> 
													<c:otherwise>   
													   【${_res.get('onTime')}】
													</c:otherwise>
												</c:choose>
												<a href="javascript:void(0)" onclick="window.location.href='/classtype/showBanciDetail?id=${order.ID}'">
												${order.CLASSNAME }
												</a>
											</c:if>
											</td>
											<td>${order.KCGWNAME }</td>
											<td>${order.TEACHERNAME }</td>
											<td align="left">${order.NAME }</td>
											<td>${order.studentCount}<c:if test="${order.chargeType == 1 }">/${order.STUNUM }</c:if>
											</td>
											<td>
												${order.coursePlanCount}<c:if test="${order.chargeType == 1 }">/${order.LESSONNUM }</c:if>
											</td>
											<td>${order.TOTALFEE }</td>
											<td>
												<fmt:formatDate value="${order.TEACHTIME}" type="time" timeStyle="full" pattern="MM-dd(yy)"/>
											</td>
											<td>
												<fmt:formatDate value="${order.ENDTIME}" type="time" timeStyle="full" pattern="MM-dd(yy)"/>
											</td>
											<td>
											<c:if test="${operator_session.qx_classtypeeditClassOrder }">
												<a href="javascript:void(0)" onclick="updateClassOrder(${order.id})">${_res.get('Modify')}</a>
											</c:if> 
											<c:if test="${operator_session.qx_courseaddCourseWeekPlan }">
												<a href="javascript:void(0)" onclick="window.location.href='/course/addCourseWeekPlan?studentId=${order.accountid}&banjiType=2'">${_res.get('course.arranging')}</a>
											</c:if>
											<c:if test="${operator_session.qx_classtypedeleteClassOrder}">
												<a href="javascript:void(0)" onclick="deleteClassOrder(${order.ID})">删除</a>
											</c:if>
											<c:if test="${operator_session.qx_classtypeendClassOrder && order.ENDTIME==null}">
												<a href="javascript:void(0)" onclick="endClassOrder(${order.ID})">结课</a>
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
				</form>
			</div>
			<div style="clear: both;"></div>
		</div>
	</div>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块/classtype/editClassType
    </script>
	<script type="text/javascript">
      
      /*快捷查询*/
      function sendMessage(code){
     	 if(code==0){
     		 $("#jieke").val("");
     	 }else if(code==1){
     		 $("#jieke").val(1);
     	 }else if(code==2){
     		 $("#jieke").val(2);
     	 }
     	 $("#searchForm").attr("action", "/classtype/findClassOrder");
          $("#searchForm").submit();	
      }
      function updateClassOrder(id){
    	  $.layer({
      		type:2,
      		title: "${_res.get('Modify.the.class.lesson')}",
      		closeBtn:[0,true],
      		shade:[0.5,'#000'],
      		shadeClose:true,
      		area:['800px','500px'],
      		iframe: {src: '${cxt}/classtype/editClassOrder/'+id}
      	});
      }
     function addClassOrder(){
    	 $.layer({
       		type:2,
       		title: "${_res.get('Add.class.lesson')}",
       		closeBtn:[0,true],
       		shade:[0.5,'#000'],
       		shadeClose:true,
       		area:['800px','500px'],
       		iframe: {src: '${cxt}/classtype/addClassOrder'}
       	});
     }
     
     //结课
     function endClassOrder(id){
    	 if(confirm("确认结课吗? 注意: 手动结课的 结课日期为昨天")){
    		 $.post(("/classtype/endClassOrder?id=" + id),function(ret){
 				 layer.msg(ret.errmsg , 1 , 1);
    			 setTimeout("window.location.reload();",1000);
    		 });
    	 }
     }
     
     /*删除*/
     function deleteClassOrder(id){
    	 if(confirm("确认删除吗?")){
    		 $.ajax({
    			 url:'/classtype/deleteClassOrder',
    			 type:'post',
    			 data:{'id':id},
    			 dataType:'json',
    			 success:function(data){
    				 if(data.code==0){
    					 layer.msg("班次删除成功",1,1);
    				 }else if(data.code==1&&data.num==1){
    					 layer.msg("班次排课并已有学生购买,删除失败",1,2);
    				 }else if(data.code==1){
    					 layer.msg("班次已有排课，删除失败",1,2);
    				 }else if(data.num==1){
    					 layer.msg("班次已有学生购买，删除失败",1,2);
    				 }else if(data.num==0){
    					 layer.msg("系统异常，删除失败",1,2);
    				 }
    				 setTimeout("window.location.reload();",1000);
    			 }
    		 })
    	 }
     }
     var state = "${paramMap['_query.jieke']}";
     if(state==1){
    	 $("#s_1").removeClass("btn-outline");
     }
     if(state==2||state==""){
    	 $("#s_2").removeClass("btn-outline");
     }
     </script>
	<script>
         //日期范围限制
        var date1 = {
            elem: '#date1',
            format: 'YYYY-MM-DD',
            max: '2099-06-16', //最大日期
            istime: false,
            istoday: false,
            choose: function (datas) {
                date2.min = datas; //开始日选好后，重置结束日的最小日期
                date2.start = datas //将结束日的初始值设定为开始日
            }
        };
        var date2 = {
            elem: '#date2',
            format: 'YYYY-MM-DD',
            max: '2099-06-16',
            istime: false,
            istoday: false,
            choose: function (datas) {
                date1.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        laydate(date1);
        laydate(date2);
 </script>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

	<script>
    $(".chosen-select").chosen({disable_search_threshold: 30});
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

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
	<script src="/js/js/top-nav/teach.js"></script>
	<script>
       $('li[ID=nav-nav6]').removeAttr('').attr('class','active');
    </script>
</body>
</html>