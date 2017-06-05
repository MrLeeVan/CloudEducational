<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('courses_signin') }</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet" />

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet" />
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet" />
<link href="/css/css/animate.css" rel="stylesheet" />

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
.chosen-container {
	margin-top: -3px;
}

.xubox_tabmove {
	background: #EEE;
}

.xubox_tabnow {
	color: #31708f;
}
</style>
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

			<div class="margin-nav" style="width: 100%;">
				<form action="/course/showAllCourseMessage" method="post" id="searchForm">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp; <a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> &gt;<a href='/course/courseSortListForMonth?loginId=${account_session.id}'>${_res.get("curriculum") }</a> &gt;${_res.get('courses_signin') }
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          						<div style="clear:both"></div>
							</div>
							<div class="ibox-content">
								<label>${_res.get("teacher.name") }：</label> <input type="text" id="teachername" name="_query.teachername" value="${paramMap['_query.teachername']}"> <label>${_res.get("student.name") }：</label> <input type="text" id="studentname" name="_query.studentname" value="${paramMap['_query.studentname']}"> 
								<label>上课日期：</label>
								<input type="text" class="layer-date" readonly="readonly" id="date1" name="_query.startTime" value="${splitPage.queryParam['startTime']}" style="margin-top: -8px; width: 150px;" />
								
								<input type="text" class="layer-date" readonly="readonly" id="date2" name="_query.endTime" value="${paramMap['_query.endTime']}" style="margin-top: -8px; width: 150px;" />
								<input type="button" onclick="search()" value="${_res.get('admin.common.select') }" class="btn btn-outline btn-primary">
							</div>
						</div>
					</div>

					<div class="col-lg-12" style="min-width: 680px">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>${_res.get("course.signedlist") }</h5>
							</div>
							<div class="ibox-content">
								<table class="table table-hover table-bordered" width="100%">
									<thead>
										<tr>
											<th>${_res.get("index") }</th>
											<th>${_res.get("teacher") }</th>
											<th>${_res.get('type.of.class')}</th>
											<th>${_res.get("course.course") }</th>
											<th>${_res.get("classroom")}</th>
											<th>${_res.get("course.class.date") }</th>
											<%-- <th>${_res.get('Course.hours')}</th> --%>
											<th>教师考勤</th>
											<th>${_res.get("time.of.sign-up")}</th>
											<th>学生考勤</th>
											<th>点名时间</th>
											<th>${_res.get("operation")}</th>
										</tr>
									</thead>
									<c:forEach items="${showPages.list}" var="course" varStatus="status">
										<tr class="odd" align="center">
											<td>${status.count}</td>
											<td>${course.teacher_name}</td>
											<td>${course.class_id==0?_res.get("IEP").concat('/').concat(course.student_name):course.type_name.concat('<br/>').concat(course.classNum)}</td>
											<td>${course.subject_name}<br/>${course.COURSE_NAME }</td>
											<td>${course.campus_name}<br/>${course.room_name}</td>
											<td><fmt:formatDate value="${course.courseplan_time}" type="time" timeStyle="full" pattern="yyyy-MM-dd" /><br/>${course.rank_name}</td>
											<td>
												<c:choose>
													<c:when test="${course.SIGNIN eq 1}">正常</c:when>
													<c:when test="${course.SIGNIN eq 2}">${_res.get('courselib.late')}</c:when>
													<c:when test="${course.SIGNIN eq 3}">${_res.get("replenish.sign")}</c:when>
													<c:when test="${course.SIGNIN eq 0}">未签到</c:when>
												</c:choose>
											</td>
											<td><fmt:formatDate value="${course.signedtime}" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss" /></td>
											<td>
												<c:choose>
													<c:when test="${course.singn eq 1}">正常</c:when>
													<c:when test="${course.singn eq 2}">迟到</c:when>
													<c:when test="${course.singn eq 3}">旷课</c:when>
													<c:when test="${course.singn eq 4}">旷课</c:when>
													<c:otherwise>未考勤</c:otherwise>
												</c:choose>
											</td>
											<td><fmt:formatDate value="${course.demohour}" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss" /></td>
											<td align="center">
											<a onclick="callName(${course.courseplan_id})">点名</a>&nbsp; 
											<c:if test="${operator_session.qx_coursesignMessage }">
												<c:if test="${course.SIGNIN ==0 && course.SIGNIN !=1 && logintype !=1}">
													<a onclick="signToCoursePlan(${course.courseplan_id})">${_res.get("courselib.sign")}</a> &nbsp;
												</c:if>
											</c:if>
											<c:if test="${operator_session.qx_coursesignedCause }">
												<c:if test="${course.SIGNIN !=3 && course.SIGNIN !=1 &&course.SIGNIN !=2}">
													<a onclick="signedSupplement(${course.courseplan_id})">${_res.get("replenish.sign")}</a>
												</c:if>
											</c:if>
											<c:if test="${course.SIGNIN == 3}">
												<a style="color: #a4a4a4" onclick="getRetroactiveReason(${course.courseplan_id})">${_res.get('Has.retroactive')}</a>
											</c:if>
											</td>
										</tr>
										<input type="hidden" value="${course.signcause }" id="signcause${course.courseplan_id }" />
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
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script type="text/javascript">
	
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
	
		function signToCoursePlan(courseplan_id){
			//alert(courseplan_id);
			if(checkTime(courseplan_id,0)){
				$.layer({
					 type: 2,
			    	    shadeClose: true,
			    	    title: "${_res.get('Registration.Information')}",
			    	    closeBtn: [0, true],
			    	    shade: [0.5, '#000'],
			    	    border: [0],
			    	    area: ['200px', '140px'],
			    	    iframe: {src: '${cxt}/course/signMessage/'+courseplan_id}
					
				});
			}
		}
		function signedSupplement(courseplan_id){
			if(checkTime(courseplan_id,1)){
				$.layer({
					 type: 2,
			    	    shadeClose: true,
			    	    title: "${_res.get('Retroactive.reason')}",
			    	    closeBtn: [0, true],
			    	    shade: [0.5, '#000'],
			    	    border: [0],
			    	    area: ['460px', '480px'],
			    	    iframe: {src: '${cxt}/course/signedCause/'+courseplan_id}
					
				});
			}
		}
		
		 function checkTime(courseplan_id,type){
			  var flag = false;
			  $.ajax({
				  url:"${cxt}/course/checkSignCourseTime",
				  type:"post",
				  async: false,
				  data:{"id":courseplan_id,"type":type},
				  success:function(data){
					  if(data.code=="1"){
						  flag = true;
					  }else{
						  layer.msg(data.msg,2,5);
						  flag = false;
					  }
				  }
			  });
			  return flag;
		  }
		 
		 function getRetroactiveReason(id){
			 var content = $("#signcause"+id).val();
				var pageii = $.layer({
				    type: 1,
				    title: "${_res.get('Retroactive.reason')}",
				    area: ['auto', 'auto'],
				    border: [0], //去掉默认边框
				    shade: [0], //去掉遮罩
				    closeBtn: [0, false], //去掉默认关闭按钮
				    shift: 'left', //从左动画弹出
				    page: {
				        html: '<div style="width:480px; padding:10px; border:1px solid #ccc; background-color:#FFF;"><p><table class="table-chakan table-bordered">'+content+'</table></p><button id="pagebtn" class="btn btn-outline btn-warning" onclick="">关闭</button></div>'
				    }
				});
				//自设关闭
				$('#pagebtn').on('click', function(){
				    layer.close(pageii);
				});
		 }
		 
			//点名方法
		 function callName(courseplan_id){
			var TIMENAME = $("#TIMENAME").val();
			var courseTime = $("#courseTime").val();
			var courseid = $("#course_id").val();
			var campusid = $("#campusId").val();
			var courseDate =$("#courseDate").val(); 
			var rankTime =$("#rankTime").val(); 
			var teaId =$("#teaId").val(); 
			$.ajax({
				url : "/course/siGninCourese?courseplan_id=" + courseplan_id,
				dataType : "json",
				type : "post",
				success : function(result) {
					if (result.message == "no") {
						alert("非校区内不支持此功能");
						return;
					} /* else if (result.message == "NotDay") {
						alert("只能记录当天的点名情况");
						return ;
					} */ else{
						$.layer({
					   	    type: 2,
					   	    title: "${_res.get('student_attendence') }",
					   	 	closeBtn:[0,true],
				      		shade:[0.5,'#000'],
				      		shadeClose:true,
				      		area:['500px','300px'],
					   	    iframe: {src: "/course/callNameMessage/?coursePlanId="+courseplan_id+"&refresh=true"}
					   	}); 
					}
				}
			});
			
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
       $('li[ID=nav-nav4]').removeAttr('').attr('class','active');
    </script>
</body>
</html>