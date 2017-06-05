<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE   html   PUBLIC   "-//W3C//DTD   XHTML   1.0   Transitional//EN "   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd "> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/style.css" rel="stylesheet" /> 
<link type="text/css" href="/css/jquery.cleditor.css" rel="stylesheet" />
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<title>${_res.get('courses_roadmap')}</title>
<script type="text/javascript">
$(function(){
	if($('#campusId').val() == 0){
		$('#mainDiv').hide();
	}else{
		$('#mainDiv').show();
	}
});

function clean(){
	$("#studentName").val("");
	$("#teacherName").val("");
	$("#campusId").val(0);
	$("#date1").val("");
	$("#date2").val("");
}
function delKeng(planId,kengId,data){
	if(confirm("确定要删除？")){
	$.ajax({
		url :  "/course/delCoursePlan",
		data :{"planId":planId,"state":"1"},
		type : "post",
		dataType : "json",
		success : function(result) {
			if(result.result=="ok")
			{
			$(data).remove();
			$("#"+kengId).attr("style","background:#E1ECF6; border-bottom: 2px solid #f5f5f5;");
			$("#pk_info_"+planId).html("");
			$("#"+kengId).append("<a href='javascript:void(0)' onclick=\"addplan('${day.simCourseTime}','${tables}')\" title='添加课程' style='margin:0px 0 0 10px;vertical-align:middle;display: inline-block;'><img src='/images/icons/notifications/tip.png' width='16' height='16' /></a>");
			}
			else
			alert("操作失败");	
		}
	});
	}
}
function addplan(courseTime,rankId){
	location.href="/course/addCoursePlan";
}
function exportCourseSort()
{
	$("#returnType").val(3);
	$("#myform").submit();
}
</script>
<style type="text/css">
	ul,li { list-style-type: none;margin: 0; }
	.pk_info {
		width: 128px;
		float: left;
		height: 150px;
		padding: 0 4px;
	}
	table.normal tbody tr.odd_time td {
		height: 150px;
		line-height: 150px;
		border-bottom: 2px solid #f5f5f5;
	}
	table {
		border-collapse: collapse; 
		border: medium none; 
	}
</style>
</head>
<body style="width:auto;" >
	<div >
		<div id="primary_right">
			<div class="inner" >
				<h3><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
				 &gt; ${_res.get('curriculum_management')}(按日)</h3>
				
				<!-- 查询	开始 -->
				<form action="/course/coursePlanList" id="myform" method="post" >
					<input type="hidden" name="returnType" id="returnType" value="2">
					<fieldset style="width: auto" id="searchTable">
						<p>
							<label>${_res.get('student')}:</label>
							<input type="text" name="studentName" id="studentName" value="${studentName}"/>
						</p>
						<p>
							<label>${_res.get('classNum')}:</label>
							<input type="text" name="banci" id="banci" value="${banci}"/>
						</p>
						<p>
							<label>${_res.get('course.class.date')}:</label>
							<input type="text" readonly="readonly" id="date1" name="date1"  value="${date1}"
							onfocus="WdatePicker({startDate:'%y-%M-01',dateFmt:'yyyy-MM-dd',alwaysUseStartDate:true,autoPickDate:true})"/>
							--
							<input type="text" readonly="readonly"   id="date2"  name="date2"  value="${date2}"
							onfocus="WdatePicker({startDate:'%y-%M-01',dateFmt:'yyyy-MM-dd',alwaysUseStartDate:true,autoPickDate:true})"/>
						</p>
						<p>
							<label>${_res.get('teacher')}:</label>
							<input type="text" name="teacherName" id="teacherName" value="${teacherName}"/>
						</p>
						<p>
							<label>${_res.get('system.campus')}:</label>
							<select name="campusId" id="campusId">
								<c:forEach items="${campus}" var="campus_entity">
									<option value="${campus_entity.id}">${campus_entity.campus_name}</option>
								</c:forEach>
							</select>
						</p>
						<p>
						&nbsp;&nbsp;<input type="submit" value="${_res.get('admin.top.search')}"/>&nbsp;&nbsp;<input type="reset" class="button" value="清空" onclick="clean()"/>
						&nbsp;&nbsp;<input type="button" class="button" value="${_res.get('Output')}" onclick="exportCourseSort()"/>
						</p>
					</fieldset>
				</form>
				<!-- 查询	结束 -->
				
				<!-- 表格内容		开始 -->
				<div id="mainDiv">
					<input type="hidden" id ="englishname" value="${_res.get('class.class.type')}">
					<table border="1" class="normal tablesorter">
						<thead>
						<tr>
							<th class="header">时间/${_res.get("classroom")}</th>
							
							<c:forEach items="${timeMap.value.value.rooms}" var="room" varStatus="roomIndex">
								<th class="header" id="th_room_${roomIndex.index }">
									<span style="float: right;margin-right: 1em;cursor: pointer;" onclick="javascript:$('#room_${roomIndex.index}').hide();$('#th_room_${roomIndex.index }').hide()">
										<img src="/images/close.png" width="19" height="19" title="隐藏">
									</span>${room.name}
								</th>
							</c:forEach>
						</tr>
						</thead>
						
						<tr>
							<td>
								<c:forEach items="${days}" var="day" >
								
									<table style="width: 190px;overflow: hidden;">
										<tr style="background: #ccc">
											<td style="background-color: #DAE3EB;border-bottom: 1px solid #AAA;font-weight: bold;" align="center">${day.courseTime}
												<script type="text/javascript">
													var now=new Date(Date.parse("${day.simCourseTime}".replace(/-/g,"/"))); 
													 var day=now.getDay();  
													 var week;
													 var arr_week=new Array("${_res.get('system.Sunday')}","${_res.get('system.Monday')}","${_res.get('system.Tuesday')}","${_res.get('system.Wednesday')}","${_res.get('system.Thursday')}","${_res.get('system.Friday')}","${_res.get('system.Saturday')}");
													 document.write("("+arr_week[day]+")");
												</script>
											</td>
										</tr>
										
										<c:forEach items="${timeRanks}" var="timeRank">
											<tr  class="odd_time">
												<td valign="middle" align="center">${timeRank.rank_name}</td>
											</tr>
										</c:forEach>
									</table>
								</c:forEach>
							</td>
							
							<c:forEach items="${plans}" var="roomFiled" varStatus="roomindex">
								<td id="room_${roomindex.index}">
									<table style="margin: 0 0 0px;width: 170px;overflow: hidden;" background="#234328">
										<c:set var="planDays" value="0"></c:set>
										<c:forEach items="${days}" var="day" varStatus="dayIndex" >
											<tr>
												<td style="background-color: #DAE3EB;border-bottom: 2px solid #CCC;"
												 align="center">&nbsp;${classRooms[roomindex.index].name }</td>
											</tr>
											
											<c:forEach begin="1" end="5" var="tables">
												<tr>
													<td style="background:#E1ECF6; border-bottom: 2px solid #f5f5f5;" 
														id="planDay_${roomindex.index}_${day.simCourseTime}_${tables}" >
														<div class="pk_info"></div>
													</td>
												</tr>
											</c:forEach>
										</c:forEach>
										
										<c:forEach items="${roomFiled}" var="plan" begin="0" varStatus="idxStatus">
											<script>
												var s = $("#englishname").val();
												var myRemark = "${plan.remark}";
												if(myRemark != ""){
													myRemark = "<li>备注：${plan.remark}</li>";
												}
												var class_order_type = "${plan.classNum}";
												if(class_order_type != ""){
													class_order_type = "<li>"+s+"：${plan.type_name}</li><li>${_res.get('classNum')}：${plan.classNum}</li>";
												}
												var studentName = "${plan.studentName}";
												/* if(studentName.length > 9 && studentName.indexOf("LD", 0) != -1 ){
													studentName = studentName.substring(37, studentName.length);
												}else if(studentName.indexOf("LD", 0) != -1){
													studentName = "无";
												} */
												var str="<div id='pk_info_${plan.planId}' class='pk_info'><ul>"+class_order_type+"<li>S："+studentName+"</li><li>T：${plan.teacherName}</li><li>C：${plan.courseName}</li>"+myRemark+"</ul></div>";
												
												if("${plan.planType}"=="1"){
													str="<div id='pk_info_${plan.planId}' class='pk_info'><ul><li>【${_res.get('mock.test')}】</li><li>S：${plan.studentName}</li><li>C：${plan.courseName}</li>"+myRemark+"</ul></div>";
												}
												if("${plan.state}"=="2") {
													$("#planDay_${roomindex.index}_${plan.course_time}_${plan.rankId}").attr("style","background:#ddd;cursor:default;color:#999;");
													str+="&nbsp;<a href='javascript:void(0)' style='margin:0px 0 0 5px;vertical-align:middle;'  onclick=addplan(${plan.course_time},${plan.rankId})><img src='/images/icons/actions_small/Pencil.png' width='16' height='16' title='修改' /></a>";
												}else{
													str+="作废";
												}
												$("#planDay_${roomindex.index}_${plan.course_time}_${plan.rankId}").html(str);
											</script>
										</c:forEach>
									</table>
								</td>
							</c:forEach>
						</tr>
					</table>
				</div>
				<!-- 表格内容		结束 -->
				
			</div>
		</div>
	</div>
	<script type="text/javascript">
	$("#campusId").val('${campusId}');
	</script>
</body>
</html>