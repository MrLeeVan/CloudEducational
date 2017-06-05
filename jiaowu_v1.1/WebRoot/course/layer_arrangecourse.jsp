<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/style.css" rel="stylesheet" /> 
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/css/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet"> 

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script src="/js/js/plugins/layer/layer.min.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style>
  label{
    width:120px
  }
  tbody tr td{
    text-align: center;
  }
  .chosen-results{
  	max-height:150px !important
  }
</style>
</head>
<body style="background: white;">
     <div class="ibox float-e-margins" style="margin-bottom:0">
        <div class="ibox-content">
            <form action="" method="post" id="arrangeCourseForm">
            	<input type="hidden" id="courseid" name="courseId" value="${courseid }" >
            	<input type="hidden" id="coursetime" name="dayTime" value="${coursetime }" >
            	<input type="hidden" id="studentid" name="stuId" value="" >
            	<input type="hidden" id="classtype" name="type" value="" >
            	<input type="hidden" id="classorderid" name="classorderid" value="" >
            	<input type="hidden" id="plantype" name="plantype" value="" >
            	<input type="hidden" id="netcourse" name="netCourse" value="" >
            	<input type="hidden" id="campusid" name="campusId" value="" >
            	<input type="hidden" id="roomId" name="roomId" value="" >
            	<input type="hidden" id="rankId" name="rankId" value="" >
            	<input type="hidden" id="subjectid" name="subjectid" value="${course.subject_id }" >
            	<input type="hidden" id="banci_id" name="banci_id" value="" >
					<fieldset>
						<p>
							<label> 
								${_res.get('teacher')}:
							</label>
							<select name="teacherId" id="teacherid" class="chosen-select" style="width:199px;" tabindex="2" onchange="changeTeachergetCourse(this.value,'','')">
							   <option value="" >--${_res.get('Please.select')}--</option>
							   <c:forEach items="${teacherlists }" var= "teacher" >
							   		<option id="tch_${teacher.id }" value="${teacher.id }" >${teacher.real_name }</option>
							   </c:forEach>
							</select>
						</p>
						<c:if test="${fn:length(teacherlists)<= 0}">
							<p> 
								<span><a href="/teacher/index" target="_blank">跳转教师列表设置该课程老师</a></span>
							</p>
						</c:if> 
						<p>
							<label> 
								${_res.get('assistant')}:
							</label>
							<select name="assistants" class="chosen-select" style="width:199px;" multiple="multiple" >
							   <c:forEach items="${isAssistantTeachers }" var= "teacher" >
							   		<option id="tch_${teacher.id }" value="${teacher.id }" >${teacher.real_name }</option>
							   </c:forEach>
							</select>
						</p>
						<p>
							<label> 
								${_res.get('system.time')}:
							</label>
							<select name="timerankid" id="timerankid" class="chosen-select" style="width:199px;" tabindex="2" onchange="changeTimeGetRoom(this.value,'')" >
							   <option value="" >--${_res.get('Please.select')}--</option>
							</select>
						</p>
						<p>
							<label> 
								${_res.get('class.classroom')}:
							</label>
							<select name="classroom" id="classroom" class="chosen-select" style="width:199px;" tabindex="2" onchange="changeRoomGetRoomPlans(this.value)" >
							   <option value="" >--${_res.get('Please.select')}--</option>
							</select>
						</p>
						<p>
							<label>OverTime(OT)：</label>
							<input type="radio" name="isovertime" value="0" checked = "checked">No
							<input type="radio" name="isovertime" value="1">Yes 
						</p>
						<!-- 课时费_开启否 -->
						<p ${organization.teacherFeeCustomSwitch == 'open' ? "":"hidden='hidden'" }>
							<label>${_res.get('tuition.fee')}：</label>
							<select id="coursecost" class="chosen-select" style="display: inline; width: 150px;" name="coursecost">
							</select>
						</p>
						<p>
						    <label> 
								${_res.get('course.remarks')}:
							</label>
						    <textarea rows="3" cols="" name="remark" style="width:300px"></textarea>
						</p>
						<p>
							 <input type="button" value="${_res.get('admin.common.submit')}" onclick="saveCoursePlan()" class="btn btn-outline btn-primary" />
						</p>
						
					</fieldset>
					
					<div>
					  <table id="rankchakan" class="table table-bordered"></table>
					  <table id="roomchakan" class="table table-bordered"></table>
					</div>
					
				</form>
				<div hidden="hidden">
					<c:forEach items="${stuleaves }" var="stuleave">
						<c:forEach items="${stuleave.DAYTIMES }" var="daytime">
							<c:forEach items="${daytime.TIMERANKID }" var="timerankid">
								<div class="stuleaves_timerankid" data-timerankid="${timerankid }"></div>
							</c:forEach>
						</c:forEach>
					</c:forEach>
				</div>
        </div>
     </div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<script src="/js/utils.js"></script>
 	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
 <!-- layer javascript -->
 <script src="/js/js/plugins/layer/layer.min.js"></script>
 <script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
 </script>
 <script type="text/javascript">

	$(function(){
		$("#studentid").val(parent.$("#studentId").val());
		$("#classorderid").val(parent.$("#banci_id").val());
		$("#campusid").val(parent.$("#campusId").val());
		$("#classtype").val(parent.$("input:radio[name='banjiType']:checked").val());
		$("#plantype").val(parent.$("input:radio[name='coursePlan.plan_type']:checked").val());
		$("#netcourse").val(parent.$("input:radio[name='netCourse']:checked").val());
		$("#banci_id").val(parent.$("#banci_id").val());
		
		var tchid = "tch_"+'${lastcp.teacher_id}';
		var timerankid= '${lastcp.timerank_id}';
		var roomid= '${lastcp.room_id}';
		$("#teacherid").val('${lastcp.teacher_id}');
		$("#teacherid").trigger("chosen:updated");
		changeTeachergetCourse('${lastcp.teacher_id}',timerankid,roomid);
		setTimeout(function(){
			var room_id = "room_"+roomid;
			$("#"+room_id).attr("selected","selected");
			$("#"+room_id).trigger("chosen:updated");
			if($("#classroom").val().split("_")[2]!="0"){
				if(!room_id=="room_"){
					changeRoomGetRoomPlans(room_id);
				}
			}
		},500);
		
		
	});
	
	function changeTeachergetCourse(tchid,timerankid,roomid){
		/* 重选老师 ；更改课程及其他选择 */
		$("#timerankid").html("<option value=\"\" >--${_res.get('Please.select')}--</option>");
		$("#timerankid").trigger("chosen:updated");
		$("#classroom").html("<option value=\"\" >--${_res.get('Please.select')}--</option>");
		$("#classroom").trigger("chosen:updated");
		if(tchid==null||tchid=="")
			return false;
		
		var coursetime = $("#coursetime").val();
		$.ajax({
			url:"/course/getTimeRankByTeacherId",
			type:"post",
			dataType:"json",
			data:{
				"tchid":tchid,
				"coursetime":coursetime,
				"stuid":$("#studentid").val(),
				"courseid":$("#courseid").val()
			},
			async:false,
			success:function(data){
				var result = data.ranklist;
				var str ="";
				if(result.length>0){
					for(var i=0;i<result.length;i++){
						str += "<option id=\"time_"+result[i].ID+"\"";
						if(timerankid!=""){
							if((result[i].ID)==timerankid.split("_")[0]){
								str += " selected=\"selected\"  ";
								changeTimeGetRoom(result[i].ID+"_"+result[i].CODE,roomid);
							}
						}
						str +=" value=\""+result[i].ID+"_"+result[i].CODE+"\">"+result[i].RANK_NAME;
						if(result[i].CODE=='1')
							str += "(被占用)";
						if(result[i].CODE=='2')
							str += "(有课程)";
						str += "</option>"
					}
					$("#timerankid").append(str);
					stuleavestimerank();
				}
				$("#timerankid").trigger("chosen:updated");
				
				//课时费
				$("#coursecost").empty();
				if(data.coursecosts != null){
					
					//小班于一对一的取值不同
					var type = parent.$("input:radio[name='banjiType']:checked").val();
					var optionStr;
					
					for (var i = 0; i < data.coursecosts.length; i++) {
						var value_i = ( (data.coursecosts[i].COURSEID != null && type != 0 ) ? (data.coursecosts[i].XIAOBANCOST) : (data.coursecosts[i].YICOST) );
						optionStr += "<option value='" + value_i + "'>" + value_i + "</option>";
						//console.log("value_i : ", i, value_i);
					}
					$("#coursecost").append(optionStr);
				}
				$("#coursecost").trigger("chosen:updated");
				
			}
		});
	}
	
	//学生请假的 时间 不能选
	function stuleavestimerank(){
		$(".stuleaves_timerankid").each(function(){
			var timerankid = $(this).data("timerankid");
			$("#time_" + timerankid).attr("disabled", "disabled").append("(学生请假)");
		});
		//$("#timerankid").trigger("chosen:updated");
	}
	
	function changeTimeGetRoom(idcode,roomid){
		$("#classroom").html("<option value=\"\" >--${_res.get('Please.select')}--</option>");
		$("#classroom").trigger("chosen:updated");
		$("#rankchakan").html("");
		$("#roomchakan").html("");
		var rankid = idcode.split("_")[0];
		var type= idcode.split("_")[1];
		/* if(type=='0'){ */
			//查教室数据,先判断时段是否够用
			$.ajax({
				url:"/course/getClassRoomForRanktime",
				type:"post",
				dataType:"json",
				data:{
					"tchid":$("#teacherid").val(),
					"coursetime":$("#coursetime").val(),
					"stuid":$("#studentid").val(),
					"rankid":rankid,
					"campusid":$("#campusid").val(),
					"courseId":$("#courseid").val(),
					"plantype":$("#plantype").val()
				},
				async:false,
				success:function(result){
					$("#rankchakan").html("");
					$("#roomchakan").html("");
					$("#rankchakan").trigger("chosen:updated");
					$("#classroom").trigger("chosen:updated");
					$("#rankchakan").show();
					$("#roomchakan").hide();
					if(result.normal=="1"){
						//时段课程
							var rankplans = "";
							if(result.planlist.length>0){
								rankplans += "<thead><tr><th>${_res.get('system.time')}</th><th>${_res.get('course.course')}</th><th>${_res.get('student')}</th><th>${_res.get('teacher')}</th><th>${_res.get('class.classroom')}</th><th>${_res.get('operation')}</th></tr></thead>";
								rankplans += "<tbody>";
								for(var i=0;i<result.planlist.length;i++){
									if(result.planlist[i].PLAN_TYPE=="2"){
										rankplans += "<tr id='rank_"+result.planlist[i].ID+"'><td>"+result.planlist[i].STARTREST+"-"+result.planlist[i].ENDREST+"</td>";
										rankplans += "<td>${_res.get('Rest')}</td><td>--</td><td>"+result.planlist[i].TCHNAME+"</td><td>--</td>";
									}
									if(result.planlist[i].PLAN_TYPE=="0"){
										rankplans += "<tr id='rank_"+result.planlist[i].ID+"'><td>"+result.planlist[i].RANK_NAME+"</td><td>"+result.planlist[i].COURSE_NAME+"</td>";
										rankplans += "<td>"+result.planlist[i].STUNAME+"</td><td>"+result.planlist[i].TCHNAME+"</td><td>"+result.planlist[i].CAMPUS_NAME+"-"+result.planlist[i].ROOMNAME+"</td>";
									}
									if(result.planlist[i].PLAN_TYPE=="1"){
										rankplans += "<tr id='rank_"+result.planlist[i].ID+"'><td>"+result.planlist[i].RANK_NAME+"</td><td>"+result.planlist[i].SUBJECT_NAME+"</td>";
										rankplans += "<td>"+result.planlist[i].STUNAME+"</td><td>${_res.get('mock.test')}</td><td>"+result.planlist[i].CAMPUS_NAME+"-"+result.planlist[i].ROOMNAME+"</td>";
									}
									rankplans += "<td><a href='#' onclick='delCoursePlan("+result.planlist[i].ID+",\""+result.planlist[i].COURSE_TIME+"\")'>${_res.get('admin.common.delete')}</a></td></tr>";
								}
								rankplans += "</tbody>";
							}
							$("#rankchakan").html(rankplans);
							$("#rankchakan").trigger("chosen:updated");
							$("#rankchakan").show();
						
						//课时不足
						if(result.enough=="0"){
							layer.alert("学员购买的[" +(result.subjectname)+ "]科目课时,不够您选的时段,请重新购买 或在财务中查看订单是否交费 ");
						}
						//课时足够
						if(result.enough=="1"){
							var chooseRoomValue="";
							//遍历教室
							var roomstr = "";
							if(result.room.roomlists.length>0){
								for(var i=0;i<result.room.roomlists.length;i++){
									roomstr += "<option id=\"room_"+result.room.roomlists[i].ID+"\" "; 
									if(roomid!=""){
										if(result.room.roomlists[i].ID==roomid.split("_")[1]){
											chooseRoomValue="room_"+result.room.roomlists[i].ID+"_"+result.room.roomlists[i].CODE;
										}
									}
									roomstr += " value=\"room_"+result.room.roomlists[i].ID+"_"+result.room.roomlists[i].CODE+"\">"+result.room.roomlists[i].NAME;
									if(result.room.roomlists[i].CODE=='1'){
										roomstr += "(有课程)"
									}
									roomstr += "</option>"
								}
							}
							$("#classroom").html(roomstr);
							changeRoomGetRoomPlans(chooseRoomValue);
							$("#classroom").val(chooseRoomValue);
							$("#classroom").trigger("chosen:updated");
						}
					}
				}
			});
	}
	
	function delCoursePlan(planId,deltime,type){
		var reason = "";
		if(confirm("确定要排此次课程？")){
			var deltime = deltime.replace(new RegExp("-", "g"),"");
			var nd = new Date();
			var today = nd.getFullYear()+(nd.getMonth()+1 <10?"0"+(nd.getMonth()+1):nd.getMonth()+1)+nd.getDate();
			if(today<deltime){
				$.ajax({
					async:false,
					cache : true,
					type : 'post',
					dataType : 'json',
					url : '/course/delCoursePlan',
					data : { "planId" : planId, "delmsg" : "delete" },
					success :function(data) {
						//删除该行
						if(data.code=="1"){
							$("#rank_"+planId).empty();
							changeTeachergetCourse($("#teacherid").val(),$("#timerankid").val(),$("#classroom").val());
							if(data.plan.STUDENT_ID==($("#studentid").val())){
								if($("#classtype").val()==1)
									parent.getStudentInfo();
								else
									parent.getClassInfo();
								var classstr = "courseplan_"+data.plan.ID;
								parent.$("."+classstr).empty();
							}
							layer.msg(data.msg, 1,1);
						}else if(data.code=="0"){
							layer.msg(data.msg,2,2);
						}
					},
					error :function(data){
						layer.msg("网络异常!",2,5);
					}
				});
			}else{
				var index = layer.prompt({title: '填写删除原因',type: 3}, function(val){
				    reason = val;
				    $.ajax({
						async:false,
						cache : true,
						type : 'post',
						dataType : 'json',
						url : '/course/delCoursePlan',
						data : { "planId" : planId, "delmsg" : reason },
						success :function(data) {
							//getCalender();
							if(data.code=="1"){
								$("#rank_"+planId).empty();
								changeTeachergetCourse($("#teacherid").val(),$("#timerankid").val(),$("#classroom").val());
								if(data.plan.STUDENT_ID==($("#studentid").val())){
									if($("#classtype").val()==1)
										parent.getStudentInfo();
									else
										parent.getClassInfo();
									var classstr = "courseplan_"+data.plan.ID;
									parent.$("."+classstr).empty();
								}
								layer.msg(data.msg, 3,1);
							}else if(data.code=="0"){
								layer.msg(data.msg,3,2);
							}else if(data.code=="2"){
								layer.msg(data.msg,3,2);
							}
						},
						error :function(data){
							layer.msg("网络异常!",2,5);
						}
					});
				    layer.close(index);
				});
			}
				
		}
	}
	
	
	function changeRoomGetRoomPlans(roomstr){
		var rankid = $("#timerankid").val().split("_")[0];
		var coursetime = $("#coursetime").val();
		var roomid = roomstr.split("_")[1];
		$("#rankchakan").html("");
		$("#roomchakan").html("");
		$("#rankchakan").trigger("chosen:updated");
		$("#roomchakan").trigger("chosen:updated");
		$("#roomchakan").show();
		$.ajax({
			url:"/course/changeRoomGetRoomPlans",
			dataType:"json",
			type:"post",
			data:{"coursetime":coursetime,"roomid":roomid,"rankid":rankid},
			async:false,
			success:function(result){
				if(result!=null&&result.length>0){
					$("#rankchakan").hide();
					var str = "";
					str = "<thead><tr><th>${_res.get('system.time')}</th><th>${_res.get('teacher')}</th><th>${_res.get('course.course')}</th><th>${_res.get('student')}</th><th>${_res.get('operation')}</th></tr></thead>";
					str += "<tbody>";
					for(var i=0;i<result.length;i++){
						if(result[i].PLAN_TYPE=="1"){
							str += "<tr id='rank_"+result[i].ID+"'><td>"+result[i].RANK_NAME+"</td><td>--</td><td>"+result[i].COURSE_NAME+"</td><td>"+result[i].STUNAME+"</td>";
						}
						if(result[i].PLAN_TYPE=="0"){
							str += "<tr id='rank_"+result[i].ID+"'><td>"+result[i].RANK_NAME+"</td><td>"+result[i].TCHNAME+"</td>";
							str += "<td>"+result[i].COURSE_NAME+"</td><td>"+result[i].STUNAME+"</td>";
						}
						str += "<td><a href='#' onclick='delCoursePlan("+result[i].ID+",\""+result[i].COURSE_TIME+"\")'>${_res.get('admin.common.delete')}</a></td></tr>";
					}
					str += "</tbody>";
					$("#roomchakan").html(str);
					$("#roomchakan").trigger("chosen:updated");
					$("#roomchakan").show();
			
				}
				
			}
		});
		
	}
	
	
	function saveCoursePlan(){
		var teacherids = $("#teacherid").val();
		if(teacherids==""||teacherids==null){
			alert("请选择老师");
			return false;
		}
		var timerankid = $("#timerankid").val();
		if(timerankid==""||timerankid==null){
			alert("请选择时段");
			return false;
		}else{
			var rankid = timerankid.split("_")[0];
			var ranktype = timerankid.split("_")[1];
			if(ranktype!="0"){
				alert("时段不可用.");
				return false;
			}
			$("#rankId").val(rankid);
		}
		var roomId=0;
		var obj=null;
		var value=parent.document.getElementsByName("netCourse");
		for(var i=0;i<value.length;++i){
		    if(value[i].checked){
		    	obj=value[i].value;
		    }
		}
		if(obj=="0"){
			  var classroomid = $("#classroom").val();
			  if(classroomid==""||classroomid==null){
				   alert("请选择教室");
				   return false;
		      }else{
		    	    roomId = classroomid.split("_")[1];
		    	    var roomtype = classroomid.split("_")[2];
		    	    if(roomtype!="0"){
		    	       	alert("教室不可用");
		    	        return false;
		            	}
	      	}
		}
		  $("#roomId").val(roomId);
		var index_load = layer.load();
		$.ajax({
				cache : true,
				url : '/course/addCoursePlans',
				type : "post",
				dataType : "json",
				async : false,
				data : $("#arrangeCourseForm").serialize(),
				error : function(request) {
					parent.layer.msg("网络异常，请稍后重试。", 1, 1);
				},
				success : function(data) {
					layer.close(index_load);
					if (data.havecourse == '1') {
						parent.layer.msg("已有课程.", 1, 2);
					} else {
						if (data.code == '1') {//成功
							if($("#classtype").val()==1)
								parent.getStudentInfo();
							else
								parent.getClassInfo();
							var courseid = data.plan.COURSE_ID;
							var coursetime = data.plan.COURSE_TIME;
							var planid = data.plan.ID;
							var tchname = data.plan.TCHNAME;
							var ranktime = data.plan.RANK_NAME;
							var campusname = data.plan.CAMPUS_NAME;
							var roomname = data.plan.ROOMNAME;
							var planstr = "<div id='coursedaylist' class='courseplan_"+planid+"'><label class='fontweig'>"+ranktime+"</label><span class='delcol' onclick='delCoursePlan("+planid+",\""+coursetime+"\");'>X</span><br>";
								planstr += "<label class='fontweig'>"+tchname+"</label><br><label class='fontweig'>" +campusname+ "--"+roomname +"</label></div>";
							var tdid = courseid+"_"+coursetime.substring(0,10);
							parent.$("#"+tdid).prepend(planstr);
							parent.layer.close(index);
						}else{
							parent.layer.msg(data.msg, 1, 1);							
						}
					}
				}
		});
	}

 //弹出后子页面大小会自动适应
   var index = parent.layer.getFrameIndex(window.name);
   parent.layer.iframeAuto(index);
</script>
<!-- Chosen -->
<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
 <script>     
        $(".chosen-select").chosen({disable_search_threshold: 10});
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
</body>
</html>
