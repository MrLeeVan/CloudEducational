<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/jquery-2.1.1.min.js"></script>
<title>${_res.get('Cancelled.Courses.List')}</title>
<script  type="text/javascript">
	function restoreCoursePlan(id){
		if(confirm("确定恢复该课程吗?")){
			$.ajax({
				url:'/coursecancel/restoreCoursePlan',
				type:'post',
				data:{"id":id},
				dataType:'json',
				success:function(data){
					if(data.code==1){
						layer.msg("恢复失败，教师在这个时间段已有其他排课",1,2);
					}else if(data.code==2){
						layer.msg("恢复失败，学生在这个时间段已有其他排课",1,2);
					}else if(data.code==3){
						layer.msg("恢复失败，该教室在这个时间段已有其他排课",1,2);
					}else if(data.code==4){
						layer.msg("恢复失败，学生课时数不足",1,2);
					}else if(data.code==0){
						layer.msg("恢复成功",1,1);
					}
					setTimeout("window.location.reload();",1000);
				}
			})
		}
	}
	
</script>
<style type="text/css">
.header {font-size: 12px}
.th_height {line-height: 34px;height: 34px}
.student_list_wrap {position: absolute;top: 53px;left: 57.8em;width: 140px;overflow: hidden;z-index: 2012;background: #09f;border: 1px solide;border-color: #e2e2e2 #ccc #ccc #e2e2e2;padding: 6px}
.table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td{padding:8px 5px}
.floalet{float: left}
.zhi{width:30px;height:30px;line-height:30px;text-align:center;background:#E5E6E7;float: left;margin-top:1px}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;min-width:1100px;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav">
				<form action="/coursecancel" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;<a
										href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a
										href='/course/queryAllcoursePlans?loginId=${account_session.columns.id}&returnType=1'>${_res.get('curriculum_management')}</a> &gt; ${_res.get('Cancelled.Courses.List')}
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          						<div style="clear:both"></div>
							</div>
							<div class="ibox-content">
							   <div class="floalet">
									<label style="float: left;margin:8px 0 0">${_res.get("class.time.session")}：</label> 
									<div class="floalet">
										<input type="text" class="form-control layer-date" readonly="readonly" id="date1" name="_query.startCourseDate" value="${paramMap['_query.startCourseDate']}" style="width:120px; background-color: #fff"  /> 
									</div>
									<div class="zhi">${_res.get('to')}</div>
									<div class="floalet">
										<input type="text" class="form-control layer-date" readonly="readonly" id="date2" name="_query.endCourseDate" value="${paramMap['_query.endCourseDate']}" style="width:120px; background-color: #fff"  /> &nbsp;&nbsp;&nbsp;&nbsp; 
							        </div>
							   </div>
							   <div class="floalet">
									<label style="float: left;margin:8px 0 0">${_res.get('Delete.Time')}：</label>
									<div class="floalet"> 
										<input type="text" class="form-control layer-date" readonly="readonly" id="date3" name="_query.startDelDate" value="${paramMap['_query.startDelDate']}" style="width:120px; background-color: #fff "  />
									</div>
									<div class="zhi">${_res.get('to')}</div>
									<div class="floalet">	
										<input type="text" class="form-control layer-date" readonly="readonly" id="date4" name="_query.endDelDate" value="${paramMap['_query.endDelDate']}" style="width:120px; background-color: #fff " /> 
							        </div>
							   </div>
							   <div style="clear: both;"></div>
							   <div style="margin-top:10px">
									<label>${_res.get('system.campus')}：</label> 
									<select id="campusid" class="chosen-select" style="width: 120px;" tabindex="2" name="_query.campusid">
										<option value="">${_res.get('system.alloptions')}</option>
										<c:forEach items="${campuslist}" var="campus">
											<option value="${campus.id }" <c:if test="${campus.id == paramMap['_query.campusid'] }">selected="selected"</c:if>>${campus.CAMPUS_NAME }</option>
										</c:forEach>
									</select> 
									<label>${_res.get("student.name")}：</label><input type="text" id="studentname" name="_query.studentname" value="${paramMap['_query.studentname']}" />
									<div id="mohulist" class="student_list_wrap" style="display: none">
										<ul style="margin-bottom: 10px;" id="stuList"></ul>
									</div>
									&nbsp;&nbsp;&nbsp; 
									<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary"> 
							   </div>
							</div>
							
							<div class="ibox-title" style="margin-top: 20px">
								<h5>${_res.get('Cancelled.Courses.List')}</h5>
							</div>
							<div class="ibox-content" style="width: 100%">
								<table class="table table-hover table-bordered">
									<thead>
										<tr>
											<th class="th_height" style="width: 4%;">${_res.get("index")}</th>
											<th class="th_height" style="width: 6%;">${_res.get("student")}</th>
											<th class="th_height" style="width: 6%;">${_res.get("teacher")}</th>
											<th class="th_height" style="width: 8%;">${_res.get('course.course')}</th>
											<th class="th_height" style="width: 9%;">${_res.get('time.session')}</th>
											<th class="th_height" style="width: 7%;">${_res.get('class.classroom')}</th>
											<th class="th_height" style="width: 6%;">${_res.get('system.campus')}</th>
											<th class="th_height" style="width: 8%;">${_res.get("class.time.session")}</th>
											<th class="th_height" style="width: 5%;">${_res.get('type')}</th>
											<th class="th_height" style="width: 9%;">${_res.get('classNum')}</th>
											<th class="th_height" style="width: 6%;">${_res.get("courselib.sign")}</th>
											<th class="th_height" style="width: 6%;">${_res.get('Person.Who.Deletes')}</th>
											<th class="th_height" style="width: 10%;">${_res.get('Delete.Time')}</th>
											<th class="th_height" style="width: 6%;">${_res.get("course.remarks")}</th>
											<th class="th_height" style="width: 10%;">${_res.get("reason.of.deleting")}</th>
											<!-- <th class="th_height" style="width: 10%;">操作</th> -->
										</tr>
									</thead>
									<c:forEach items="${showPages.list}" var="list" varStatus="ls">
										<tr align="center">
											<td>${ls.count}</td>
											<td>${list.student_name }</td>
											<td>${list.teacher_name }</td>
											<td>${list.COURSE_NAME }</td>
											<td>${list.RANK_NAME }</td>
											<td>${list.NAME }</td>
											<td>${list.CAMPUS_NAME }</td>
											<td>${list.COURSE_TIME }</td>
											<td><c:if test="${list.PLAN_TYPE eq 0 }">${_res.get('course.course')}</c:if>
											 <c:if test="${list.PLAN_TYPE eq 1 }">${_res.get('mock.test')}</c:if></td>
											<td>${list.classNum=='无'?_res.get("Tsl.no"):list.classNum}</td>
											<td>
												<c:if test="${list.SIGNIN == 0}">${_res.get('courselib.notSignin')}</c:if> 
												<c:if test="${list.SIGNIN == 1}">${_res.get("courselib.sign")}</c:if> 
												<c:if test="${list.SIGNIN == 2}">${_res.get('courselib.late')}</c:if></td>
											<td>${list.deluserid }</td>
											<td>${list.UPDATE_TIME }</td>
											<td>${list.REMARK=='暂无'?_res.get('Tsl_no'):list.REMARK}</td>
											<td align="left">${list.del_msg }</td>
											<%-- <td>
												<a href="" onclick="restoreCoursePlan(${list.id})">恢复</a>
											</td> --%>
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
	<!-- layerDate plugin javascript -->
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
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
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
		var date3 = {
			elem : '#date3',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				date4.min = datas; //开始日选好后，重置结束日的最小日期
				date4.start = datas //将结束日的初始值设定为开始日
			}
		};
		var date4 = {
			elem : '#date4',
			format : 'YYYY-MM-DD',
			max : '2099-06-16',
			istime : false,
			istoday : false,
			choose : function(datas) {
				date3.max = datas; //结束日选好后，重置开始日的最大日期
			}
		};
		laydate(date1);
		laydate(date2);
		laydate(date3);
		laydate(date4);
	</script>

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
	<script src="/js/js/top-nav/teach.js"></script>
</body>
</html>