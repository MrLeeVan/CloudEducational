<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>

<script type="text/javascript">
	$(function() {
		var index = parent.layer.getFrameIndex(window.name);
		var stuId = parent.$("#studentId").val();
		var courseId = parent.$("#courseId").val();
		var teacherId = parent.$("#teacherId").val();
		$("#studentName").html(parent.$("#studentName").val());
		var dayTime = parent.$("#dayTime").val();
		var rankName = parent.$("#rankName").val();
		var time = dayTime + "   " + rankName;
		var planType = parent.$("input:radio[name='coursePlan.plan_type']:checked").val();
		if(planType==0){
			$("#tc").html(parent.$("#teacher").find("option:selected").text());
		}else{
			$("#ls").hide();	
		}
		var typename = planType==0?'${_res.get("course.course")}':'${_res.get("mock.test")}';
		$("#time").html(time);
		$("#course").html(parent.$("#classtype").find("option:selected").text());
		$("#type").html(typename);

		$.ajax({
			url : '/course/getClassRoom',
			data : {
				"studentId":stuId,
				"courseId":courseId,
				"day" : dayTime,
				"teacherId" : teacherId,
				"rankId" : parent.$("#rankTime").val(),
				"rankName" : parent.$("#rankName").val(),
				"campusId" : parent.$("#xqid").val(),
				"type" : parent.$("#type").val()
			},
			type : "post",
			dataType : "json",
			success : function(data) {
				var str = "";
				for (var i = 0; i < data.result.length; i++) {
					var roomId = data.result[i].room.ID;
					var roomName = data.result[i].room.NAME;
					var maxp = data.result[i].room.MAXPEOPLE;
					var status = data.result[i].can;
					var last = data.result[i].last;
					var dis = "";
					var lastselect ="";
					// disabled='"+dis+"';
					if (status == "cant") {
						dis = "disabled='disabled'";
					} else {
						dis = "";
					}
					if (last == "canlast") {
						lastselect = "selected='selected'";
					} else {
						lastselect = "";
					}
					str += "<option value='"+roomId+"' "+dis+" "+lastselect+">" + roomName
							+ "(可容纳" + maxp + "人)" + " </option>";
				}
				$("#classroom").append(str);
				$("#course").html(data.courseMsg);
				
				//课时费
				if(data.coursecosts != null){
					
					//小班于一对一的取值不同
					var type = parent.$("input:radio[name='banjiType']:checked").val();
					var optionStr;
					
					for (var i = 0; i < data.coursecosts.length; i++) {
						var value_i = ( (data.coursecosts[i].COURSEID != null && type != 0 ) ? (data.coursecosts[i].XIAOBANCOST) : (data.coursecosts[i].YICOST) );
						console.log("value_i : ", i, value_i);
						optionStr += "<option value='" + value_i + "'>" + value_i + "</option>";
						value_i = 0;
					}
					$("#coursecost").append(optionStr);
				}
				
			}

		});

	});

	function addCoursePlans() {
		var netCourse = parent.$("input:radio[name='netCourse']:checked").val();
		var index = parent.layer.getFrameIndex(window.name);
		var type = parent.$("input:radio[name='banjiType']:checked").val();
		var isovertime = $("input:radio[name='isovertime']:checked").val();
		var assistants = parent.$("#assistants").val();
		assistants = assistants != null ? assistants.join(",") : "";
		
		if ($('#classroom').val() == 0 && netCourse == 0 ) {
			alert("教室为必选项。");
		} else {
			$.ajax({
				cache : true,
				url : '/course/addCoursePlans',
				type : "post",
				dataType : "json",
				async : false,
				data : {
					"planType" : parent.$("input:radio[name='coursePlan.plan_type']:checked").val(),
					"type" : parent.$("input:radio[name='banjiType']:checked").val(),
					"netCourse" : parent.$("input:radio[name='netCourse']:checked").val(),
					"stuId" : parent.$("#studentId").val(),
					"courseId" : parent.$("#courseId").val(),
					"dayTime" : parent.$("#dayTime").val(),
					"rankId" : parent.$("#rankTime").val(),
					"rankName" : parent.$("#rankName").val(),
					"campusId" : parent.$("#xqid").val(),
					"teacherId" : parent.$("#teacherId").val(),
					"plantype" : parent.$("#planType").val(),
					"roomId" : $("#classroom").val(),
					"remark" : $("#remark").val(),
					"isovertime":isovertime,
					"banci_id" : parent.$("#banci_id").val(),
					"subjectid" : parent.$("#subjectid").val(),
					"assistants" : assistants,
					"coursecost" : $("#coursecost").val()
				},
				error : function(request) {
					parent.layer.msg("网络异常，请稍后重试。", 1, 2);
				},
				success : function(data) {
					if (data.havecourse == '1') {
						parent.layer.msg("已有课程.", 2, 2);
					} else {
						if (type == 1) {
							parent.getStudentInfo();
						} else if (type == 2) {
							parent.getClassInfo();
						}
						parent.getCalender();
						if (data.code == '1') {//成功
							parent.layer.close(index);
						}
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
	width: 100px;
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
	padding: 6px;
}

.student_list_wrap li {
	display: block;
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: pointer;
	margin-right: 38px;;
}

label {
	width: 120px;
}
</style>

</head>
<body style="background:#fff">
	<div style="padding:10px">
	  <div style="padding:10px;background:#EFF2F4">
		   <p>
			 <label>${_res.get("sysname")}：</label><span id="studentName"></span>
		  </p>
		  <p>
			<label>${_res.get('type')}:</label><span id="type"></span>
		  </p>
		  <p>
			<label>${_res.get('course.course')}:</label><span id="course"></span>
		  </p>
		  <p id="ls">
			<label>${_res.get('teacher')}:</label><span id="tc"></span>
		  </p>
		  <p>
			<label>${_res.get('system.time')}:</label><span id="time"></span>
		 </p>
	  </div>
	</div>
	<div style="padding:20px">
		<form action="" method="post" id="coursePlan">
			<fieldset>
			<p>
				<label>${_res.get('class.classroom')}：</label> 
				<select id="classroom" class="form-control" style="display: inline; width: 150px;" name="coursePlan.room_id">
					<option value="0">${_res.get('Please.select')}</option>
				</select>
			</p>
			<p>
				<label>OverTime(OT)：</label>
				<input type="radio" name="isovertime" value="0" checked="checked">No
				<input type="radio" name="isovertime" value="1">Yes 
			</p>
			<!-- 课时费_开启否 -->
			<p ${organization.teacherFeeCustomSwitch =='open' ? "":"hidden='hidden'" }>
				<label>${_res.get('tuition.fee')}：</label>
				<select id="coursecost" class="form-control" style="display: inline; width: 150px;" name="coursecost">
				</select>
			</p>
			<p>
				<label>${_res.get("course.remarks")}：</label>
				<textarea id="remark" rows="3" cols="50" name="coursePlan.remark" style="color: #0099FF;"></textarea>
			</p>
			<c:if test="${operator_session.qx_courseaddCoursePlans }">
			<p>
				<input type="button" class="btn btn-outline btn-primary" value="${_res.get('save')}" onclick="addCoursePlans();" />
				<!-- <input type="reset" class="button btn btn-outline btn-success" id="cz" onclick="chongzhi()" value="${_res.get('Reset')}" /> -->
			</p>
			</c:if>
			</fieldset>
		</form>
	</div>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 30
		});
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
</body>
</html>