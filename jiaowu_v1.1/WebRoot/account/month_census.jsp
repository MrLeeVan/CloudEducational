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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src='/js/js/jquery-2.1.1.min.js'></script>
<script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
<script src='/fullcalendar/fullcalendar.min.js'></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get("course.tongji.teacherdetail") }</title>
<script type="text/javascript">
$(function(){
	var tid = $("#tId").val();
	$.ajax({
		url:"/teacher/getTeacherNameById",
		data:{
			"tid" : tid
		},
		type:"post",
		dataType:"json",
		success:function(data){
			if(data.teacherName!=null){
				$("#teacherName").val(data.teacherName);
			}
		}
	});
	
	$("#courseName").val($("#courseId").val());
	$("#sign").val($("#signin").val());
	$("#tplun").val($("#pinglun").val());
	$("#kemu").val($("#subId").val());
	changeKemu($("#subId").val());
	
});
function getStuId(){
	var stuName = $("#stuName").val();
	$("#stuId").val("");
	$.ajax({
		url:"/student/getStudentIdByName",
		data:"stuName="+stuName,
		type:"post",
		dataType:"json",
		success:function(data){
			if(data.student!=null){
				$("#stuId").val(data.student.ID);
			}
		}
		
	});
}

function getTeacherId(){
	var tname = $("#teacherName").val();
	$("#tId").val("");
	$.ajax({
		url:"/teacher/getTeacherIdByName",
		data:"tname="+tname,
		type:"post",
		dataType:"json",
		success:function(data){
			if(data.teacher!=null){
				$("#tId").val(data.teacher.ID);
			}
		}
	});
	
}


function changeKemu(subjId){
	$("#courseName").html("<option value=''>${_res.get('system.alloptions')}</option>");
	var courseId = $("#courseId").val();
	$.ajax({
		url:"/courseplan/getCoursesBySubjectId",
		data:"subId="+subjId,
		type:"post",
		dataType:"json",
		success:function(data){
			var str = "";
			if(data.course.length>0){
				for(var i=0;i<data.course.length;i++){
					if(data.course[i].ID==courseId){
						str += "<option value='"+data.course[i].ID+"' selected='selected'>"+data.course[i].COURSE_NAME+"</option>";
					}else{
						str += "<option value='"+data.course[i].ID+"' >"+data.course[i].COURSE_NAME+"</option>";
					}
				}
			}else{
				str += "";
				$("#courseName").val("");
			}
			$("#courseName").append(str);
			$("#kemu").trigger("chosen:updated");
			$("#courseName").trigger("chosen:updated");
		}
		
	});
}


</script>
<style>
   .laydate_body .laydate_bottom{
       height:30px !important
   }
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
  
  <div class="margin-nav" style="min-width:1000px;">
  
  <form action="/courseplan/getTeacherMessage" method="post" id="searchForm">
  	<input type="hidden" id="stuId" name="_query.stuid" value="${paramMap['_query.stuid'] }" />
  	<input type="hidden" id="tId" name="_query.tid" value="${paramMap['_query.tid'] }" />
  	<input type="hidden" id="courseId" name="query" value="${paramMap['_query.courseid'] }" />
  	<input type="hidden" id="signin" name="signin" value="${paramMap['_query.signin'] }" /> 
  	<input type="hidden" id="pinglun" name="TEACHER_PINGLUN" value="${paramMap['_query.TEACHER_PINGLUN'] }" />
  	<input type="hidden" id="subId" name="SUBJECT_ID" value="${paramMap['_query.SUBJECT_ID'] }" />
  <div class="col-lg-12">
      <div class="ibox-title">
		 <h5>
			<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
			<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a>
			 &gt;<a href='/course/getCourseCount'>${_res.get("courses_statistics") }</a>  &gt;
			 <a href='/teacher/teacherTongji'> ${_res.get("faculty_statistics") }</a> 
			 &gt;  ${_res.get("course.tongji.teacherdetail") }
		 </h5>
		 <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback") }</a>
		 <div style="clear: both;"></div>
	  </div>
	  <div class="ibox-content">
	   		<label>${_res.get("student") }：</label> <input type="text" id="stuName" name="_query.STUNAME" value="${paramMap['_query.STUNAME'] }" onblur="getStuId()" >
			<label>${_res.get("teacher") }：</label>
			 <input type="text" id="teacherName" name="_query.TEACHERNAME" value="${paramMap['_query.TEACHERNAME'] }" onblur="getTeacherId()" >
			<label>${_res.get("course.subject") }：</label>
				<select id="kemu" name="_query.SUBJECT_ID" class="chosen-select" style="width: 130px" onchange="changeKemu(this.value)"> 
					<option value="" selected="selected">${_res.get("system.alloptions")}</option>
					<c:forEach items="${subject }" var="list" varStatus="record">
						<option value="${list.ID }">${list.SUBJECT_NAME }</option>
					</c:forEach>
				</select>
			<label>${_res.get("course.course") }：</label>
				<select id="courseName" name="_query.courseid" class="chosen-select" style="width: 130px">
					<option value="" selected="selected">${_res.get("system.alloptions")}</option>
				</select>
			<p><br><label>${_res.get("class.attendance")}：</label>
				<select id="sign" name="_query.signin"  class="chosen-select" style="width: 100px">
					<option value="" selected="selected">${_res.get("system.alloptions")} </option>
					<option value="1"  <c:if test="${'1' == paramMap['_query.signin'] }">selected="selected"</c:if>>${_res.get("normal")} </option>
					<option value="2"  <c:if test="${'2' == paramMap['_query.signin'] }">selected="selected"</c:if>>${_res.get('courselib.late')} </option>
					<option value="3"  <c:if test="${'3' == paramMap['_query.signin'] }">selected="selected"</c:if>> ${_res.get("replenish.sign")} </option>
					<option value="0"  <c:if test="${'0' == paramMap['_query.signin'] }">selected="selected"</c:if>>${_res.get('courselib.notSignin')} </option>
				</select>
			<label>${_res.get('Evaluation')}：</label>
				<select id="tplun" name="_query.TEACHER_PINGLUN"  class="chosen-select" style="width: 100px">
					<option value="" selected="selected">${_res.get("system.alloptions")}</option>
					<option value="y"  <c:if test="${'y' == paramMap['_query.TEACHER_PINGLUN'] }">selected="selected"</c:if> >${_res.get('Rated')}</option>
					<option value="n"  <c:if test="${'n' == paramMap['_query.TEACHER_PINGLUN'] }">selected="selected"</c:if>>${_res.get('Not.evaluated')}</option>
				</select>
			<label>${_res.get("course.status")}：</label>
				<select id="tplun" name="_query.ISCANCEL"  class="chosen-select" style="width: 100px">
					<option value="" selected="selected">${_res.get('system.alloptions')}</option>
					<option value="0"  <c:if test="${'0' == paramMap['_query.ISCANCEL'] }">selected="selected"</c:if>>${_res.get("normal")}</option>
					<option value="1" <c:if test="${'1' == paramMap['_query.ISCANCEL'] }">selected="selected"</c:if>>${_res.get('Cancelled')}</option>
				</select>
			<label>${_res.get("course.class.date") }：</label><input type="text" id="starttime" name="_query.startTime" readonly="readonly" value="${paramMap['_query.startTime'] }"/>&nbsp;&nbsp;--&nbsp; 
			<input type="text" id="endtime" readonly="readonly" name="_query.endTime" value="${paramMap['_query.endTime'] }" /> &nbsp;&nbsp;&nbsp; 
			<input type="button" id="teacher" class="btn btn-outline btn-primary" value="${_res.get('admin.common.select') }" onclick="search()" />
	 </div>
  </div>
  <div style="clear: both;"></div>
  <div class="col-lg-12" style="margin-top:20px;">
     <div class="ibox float-e-margins">
        <div class="ibox-title">
          <h5>${_res.get("course.tongji.teacherdetail") }</h5>
          <div>
			  <div id="zongjilu"></div>
		 </div>
        </div>
     <div class="ibox-content">
          <table class="table table-hover table-bordered">
						<thead>
							<tr align="center" id="liebiaotou">
								<th class="header">${_res.get("index") }</th>
								<th class="header">${_res.get("teacher") }</th>
								<th class="header">${_res.get("student") }</th>
								<th class="header">OverTime</th>
								<th class="header">${_res.get("course.class.date") }</th>
								<th class="header">${_res.get('time.session')}</th>
								<th class="header">${_res.get("course.course") }</th>
								<th class="header">${_res.get('Teach')}</th>
								<%-- <th class="header" width="6%">${_res.get('Operating.arrangement')}</th>--%>
								<th class="header">${_res.get("course.status")}</th> 
								<th class="header">${_res.get('session')}</th>
								<th class="header">${_res.get('Evaluation')}</th>
								<th class="header">${_res.get("class.attendance")}</th>
							</tr>
						</thead>
						<tbody id="liebiao">
							<c:forEach var="record" items="${list.list }" varStatus="p">
								<tr class="odd" align="center">
									<td>${p.index+1}</td>
									<td>${record.TEACHERNAME}</td>
									<td>${record.STUNAME}</td>
									<td>${record.ISOVERTIME==0?'No':'Yes'}</td>
									<td>${record.COURSETIME}</td> <!--转格式  -->
									<td>${record.RANKTIME}</td>
									<td>${record.courseName}</td>
									<td>
										<c:choose>
											<c:when test="${record.class_id==0 }">
												${_res.get("IEP")}
											</c:when>
											<c:otherwise>
												${_res.get('course.classes')}
											</c:otherwise>
										</c:choose>
									</td>
									<%-- <td>
										<c:if test="${record.HOMEWORK ne null}">${_res.get('It.has.been.arranged')}</c:if>
										<c:if test="${record.HOMEWORK eq null}">${_res.get('Not.furnished')}</c:if>
									</td> --%>
									<td>
										<c:if test="${record.ISCANCEL==0}">${_res.get("normal")}</c:if>
										<c:if test="${record.ISCANCEL==1}">${_res.get('Cancelled')}</c:if>
									</td>
									<td>
										${record.class_hour}
									</td>
									<td>
										<c:if test="${record.TEACHER_PINGLUN=='y'}">${_res.get('Rated')}</c:if>
										<c:if test="${record.TEACHER_PINGLUN!='y'}">${_res.get('Not.evaluated')}</c:if>
									</td>
									<td>
										<c:if test='${record.signin=="1"}'>${_res.get("normal")}</c:if>
										<c:if test='${record.signin=="2"}'>${_res.get('courselib.late')}</c:if>
										<c:if test='${record.signin=="3"}'>${_res.get("replenish.sign")}</c:if>
										<c:if test='${record.signin=="0"}'>${_res.get('courselib.notSignin')}</c:if>
									</td>
								</tr>
							</c:forEach>
						</tbody>
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

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script>
       $('li[ID=nav-nav5]').removeAttr('').attr('class','active');
    </script> 
    <!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
		$(".chosen-select").chosen({disable_search_threshold: 15});
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
    <script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
 <script>
         //日期范围限制
        var starttime = {
            elem: '#starttime',
            format: 'YYYY-MM-DD',
            max: '2099-06-16', //最大日期
            istime: false,
            istoday: false,
            choose: function (datas) {
            	endtime.min = datas; //开始日选好后，重置结束日的最小日期
            	endtime.start = datas //将结束日的初始值设定为开始日
            }
        };
        var endtime = {
            elem: '#endtime',
            format: 'YYYY-MM-DD',
            max: '2099-06-16',
            istime: false,
            istoday: false,
            choose: function (datas) {
            	starttime.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        laydate(starttime);
        laydate(endtime);
 </script>
    
</body>
</html>