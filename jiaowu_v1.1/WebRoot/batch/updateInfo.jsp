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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">


<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">


<script src="/js/js/jquery-2.1.1.min.js"></script>

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">
	
</script>
<title>${_res.get('class_type_management')}</title>

<style type="text/css">
label {
	height: 34px;
	width: 80px;
}

.subject_name {
	width: 520px;
	margin: -50px 0 0 82px;
}

.class_type {
	margin: -50px 0 40px 82px;
}

#classtype div {
	float: left;
	margin-right: 15px
}

.student_list_wrap {
	position: absolute;
	top: 100px;
	left: 9.5em;
	width: 100px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
}
</style>
</head>
<body style="background: #fff">
	<div class="ibox-content">
		<form action="" method="post" id="/courseplan/UpdateTeachers" name="form1">
			<input type="hidden" value="${coursePlan.ID}" id="id"> 
			<input id="studentId" type="hidden" value="${student.ID}">
			<input id="userstate" type="hidden" value="${coursePlan.USERSTATE}">
			
			<c:choose>
				<c:when test="${coursePlan.USERSTATE eq '2'}"> 
					<label>${_res.get('classNum')}:</label>&nbsp;<input type="text" id="class" name="class_num" value="${coursePlan.STUDENT_NAME}" disabled="disabled" readonly="readonly" style="width: 200px;">
				</c:when>
				<c:otherwise> 
				    <label>${_res.get('student')}:</label>&nbsp;&nbsp;<input type="text" id="student" name="student_name" value="${coursePlan.STUDENT_NAME}" disabled="disabled" readonly="readonly" style="width: 200px ;">
				</c:otherwise>
			</c:choose>
			<label>${_res.get('course.remarks')}:</label><input type="text" id="remark" name="remark" value="${coursePlan.remark}"    style="width: 200px;  display: inline; ">
			<label>${_res.get('system.campus')}:</label> 
			<select id="campusIds" class="chosen-select" style="width: 200px;" tabindex="2" name="_query.campusId"  onchange="changeTimeGetRoom()"  >
				<option value=''>${_res.get('Please.select')}</option>
				<c:forEach items="${campusList}" var="campus">
					<option value="${campus.id }" <c:if  test="${coursePlan.CAMPUSID==campus.id }">selected="selected"</c:if>>${campus.CAMPUS_NAME }</option>
				</c:forEach>
			</select> 
			<label>${_res.get('subject')}:</label> 
			<select id="courseids" class="chosen-select" style="width: 200px;" onchange='getTeacherByCourse()' tabindex="2" name="_query.courseId">
				<option value=''>${_res.get('Please.select')}</option>
				<c:forEach items="${courseList}" var="course">
					<option value="${course.id }" <c:if  test="${coursePlan.COURSEID==course.ID }">selected="selected"</c:if>>${course.COURSE_NAME }</option>
				</c:forEach>
			</select> 
			<label>${_res.get('date')}:</label>
			<input type="text" class="form-control layer-date" readonly="readonly" id="date1" value='<fmt:formatDate value="${coursePlan.COURSE_TIME }" type="time" timeStyle="full" pattern="yyyy-MM-dd"/>' name="_query.courseTime"
				style="margin-top: 1px; width: 200px; background-color: #fff;" onclick="getTeacherByCourse()"/>
			<label>${_res.get('teacher')}:</label> 
			<select id="teacherids" class="chosen-select" style="width: 200px;"
				onchange='getEnableRankList()' tabindex="2" name="_query.teacherId">
				<option value="">${_res.get('Please.select')}</option>
		 		<c:forEach items="${teacherList}" var="teacher">
					<option value="${teacher.id}" <c:if  test="${coursePlan.TCHID==teacher.id  }">selected="selected"</c:if>>${teacher.REAL_NAME }</option>
				</c:forEach>  
			</select>
			<label>${_res.get('time')}:</label> 
			<select id="rankids" class="chosen-select" style="width: 200px; " onchange="changeTimeGetRoom()" tabindex="2" name="_query.timeRankId">
				<option value="">${_res.get('Please.select')}</option>
				<c:forEach items="${ranklist}" var="rank">
			 		<option value="${rank.ID}" ${coursePlan.TRID==rank.ID?'selected="selected"':''} ${rank.code ne 0 ? 'disabled="disabled"' : '' }>
					${rank.RANK_NAME }
					<c:if test="${coursePlan.TRID ne rank.ID }">
						${rank.code eq 1?'('.concat(_res.get("timeUnavailable")).concat(')'):(rank.code eq 2?'('.concat(_res.get("courseConflicted")).concat(')'):"") }
					</c:if>
					</option>  
				</c:forEach>
			</select> 
			<!-- 课时费_开启否 -->
			<div ${organization.teacherFeeCustomSwitch == 'open' ? "":"hidden='hidden'" }>
				<label>${_res.get('tuition.fee')}：</label>
				<select id="coursecost" class="chosen-select" style="width: 200px;" name="_query.coursecost">
				</select>
			</div>
			<label>${_res.get('class.classroom')}:</label> 
			<select id="roomIds" class="chosen-select" style="width: 200px;  " tabindex="2" name="_query.roomId">
				<option value="">${_res.get('Please.select')}</option>
		 		<c:forEach items="${roomList}" var="room"> 
					<option value="${room.ID}" ${room.code eq 1 ? 'disabled="disabled"' : '' }  <c:if  test="${coursePlan.ROOMID==room.ID}">selected="selected"</c:if>  >
						${room.NAME }
					<c:if test="${coursePlan.roomid ne room.ID }">	
						${room.code eq 1?'('.concat(_res.get("timeUnavailable")).concat(')'):""}
					</c:if>
					</option>
				</c:forEach>  
			</select>
			<br/>
			<div style="float: left; margin-right: 10px">
				<input type="button" onclick='updateInfo()' id="vallot" value="${_res.get('Modify')}" class="btn btn-outline btn-primary">
			</div>
			<br>
		</form>
		<div style="display: none" id="piaoo">
			<h5 onclick="closepiao();">
				<span id="updateinfo" title="${_res.get('admin.common.close')}">X</span> 
			</h5>
		</div>
	</div>
	<script>
		//根据课程获取教师列表
		function getTeacherByCourse() {
			$("#teacherids").html("<option value=\"\" >${_res.get('Please.select')}</option>");
			$("#teacherids").trigger("chosen:updated");
			var courseId = $('#courseids').val();
			var studentId = $('#studentId').val();
			var teacherId = $('#teacherids').val();
			$.ajax({
				type : "post",
				url : "/courseplan/getTeacherByCourse",
				data : {
					'courseid' : courseId,
					'studentId' : studentId
				},
				cache : false,
				success : function(data) {
					$("#teacherids").find("option").remove();
					$("#teacherids").append("<option value=''>${_res.get('Please.select')}</option>")
					$.each(data.teacherList, function(i, item) {
						$('#teacherids').append("<option value=" +item.ID + ">" + item.REAL_NAME + "</option>");
						$('#teacherids').trigger("chosen:updated");
					})
				}
			});
		}
		//教师改变根据当前日期获取当前日期可用时段
		function getEnableRankList(){
			$("#rankids").html("<option value=\"\" >${_res.get('Please.select')}</option>");
			$("#rankids").trigger("chosen:updated");
			var stuid = $('#studentId').val();
			var tchid = $('#teacherids').val();
			var courseId = $('#courseids').val();
			var cpid = $('#id').val();
			var coursetime = $('#date1').val();
			var rankid = $('rankids').val();
			$.ajax({
				url : "/courseplan/getEnableRankList",
				type : "post",
				dataType : "json",
				data : {
					"cpid" : cpid,
					"tchid" : tchid,
					"coursetime" : coursetime,
					"stuid" : stuid,
					"courseid":courseId
				},
				async : false,
				success : function(data) {
					var str = "";
					$("#rankids").find("option").remove();
					$("#rankids").append("<option value=''>${_res.get('Please.select')}</option>")
					$.each(data.ranklist, function(i, item) {
						str += "<option id=\"time_" + item.ID + "\"";
						if (item.CODE == '1' || item.CODE == '2') {
							str += "disabled='disabled'  readonly='readonly' ";
						}
						str += " value=\"" + item.ID + "_" + item.CODE + "\">" + item.RANK_NAME;
						if (item.CODE == '1')
							str += "( ${_res.get('timeUnavailable') } )";
						if (item.CODE == '2')
							str += "( ${_res.get('courseConflicted')} )";
						str += "</option>"
					})
					$("#rankids").append(str);
					$('#rankids').trigger("chosen:updated");
					
					//console.log("data  : " , data);
					//课时费
					$("#coursecost").empty();
					if(data.coursecosts != null){
						
						//小班于一对一的取值不同
						var type = $("#userstate").val();
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
		 //时段改变获取教室
		function changeTimeGetRoom(){
			$("#roomIds").html("<option value=\"\" >${_res.get('Please.select')}</option>");
			$("#roomIds").trigger("chosen:updated");
			var coursetime = $('#date1').val(); //获取时间
			var campusid = $('#campusIds').val(); //获取校区
			var rankid = $('#rankids').val().split("_")[0]; //获取时段id
			var cpid = $('#id').val();
			$.ajax({
				url : "/courseplan/getClassRoomByRankTime",
				type : "post",
				dataType : "json",
				data : {
					"coursePlanId" : cpid,
					"coursetime" : coursetime,
					"rankid" : rankid,
					"campusid" : campusid
				},
				async : false,
				success : function(result) {
					if (result.normal == "1") {
						var rankplans = "";
						var chooseRoomValue = "";
						//遍历教室
						var roomstr = "";
						if (result.room.roomlists.length > 0) {
							for (var i = 0; i < result.room.roomlists.length; i++) {
								roomstr += "<option id=\"room_" + result.room.roomlists[i].ID + "\" ";
								if (result.room.roomlists[i].CODE == '1') {
									roomstr += "disabled='disabled'  readonly='readonly' ";
								}
								roomstr += " value='" + result.room.roomlists[i].ID + "'>" + result.room.roomlists[i].NAME;
								if (result.room.roomlists[i].CODE == '1') {
									roomstr += "( ${_res.get('courseConflicted')} )"
								}
								roomstr += "</option>"
							}
						}
						$("#roomIds").append(roomstr);
						$("#roomIds").val(chooseRoomValue);
						$("#roomIds").trigger("chosen:updated");

					}
				}
			}

			)
		}
		function updateInfo() {
			var coursetime = $('#date1').val(); //获取时间
			var campusid = $('#campusIds').val(); //获取校区
			var rankid = $('#rankids').val().split("_")[0]; //获取时段id
			var roomid = $('#roomIds').val();
			var courseid = $('#courseids').val();
			var coursetime = $('#date1').val();
			var teacherid = $('#teacherids').val();
			var theme = $('#theme').val() ;
			var remark = $('#remark').val() ;
			var cpid = $('#id').val();
			 if (campusid == null || campusid == "") {
				layer.msg("${_res.get('pleaseSelect.district')}");
				return false;
			} else if (courseid == null || courseid == "") {
				layer.msg("${_res.get('pleaseSelect.class')}");
				return false;
			} else if (coursetime == null || coursetime == "") {
				layer.msg("${_res.get('pleaseSelect.date')}");
				return false;
			} else if (teacherid == null || teacherid == "") {
				layer.msg("${_res.get('pleaseSelect.teacher')}");
				return false;
			} else if (rankid == null || rankid == "") {
				layer.msg("${_res.get('pleaseSelect.session')}");
				return false;
			} else if (roomid == null || roomid == "") {
				layer.msg("${_res.get('pleaseSelect.room')}");
				return false;
			} else {
				$.ajax({
					url : "/courseplan/updateInfo",
					type : "post",
					dataType : "json",
					data : {
						"coursetime" : coursetime,
						"rankid" : rankid,
						"teacherid" : teacherid,
						"courseid" : courseid,
						"roomid" : roomid,
						"cpid" : cpid,
						"campusid" : campusid,
						"theme" : theme ,
						"remark" :remark
					},
					async : false,
					success : function(result) {
						if (result.code == '0') {
							layer.msg("${_res.get('update.success')}", 2, 1);
						window.parent.window.search();
						}
						if (result.code == '1') {
							layer.msg("${_res.get('server_error')}", 2, 2);
						}
					}
				})
			}

		}
		$('li[ID=nav-nav6]').removeAttr('').attr('class', 'active');
		//弹出后子页面大小会自动适应
		var index = parent.layer.getFrameIndex(window.name);
	</script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 10
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
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			min : '1970-01-01',
			istime : false,
			istoday : false
		};
		laydate(date1);
	</script>
</body>
</html>
