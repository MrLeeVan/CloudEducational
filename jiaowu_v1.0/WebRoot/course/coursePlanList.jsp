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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet" />
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- 回到顶部 -->
<link type="text/css" href="/css/lrtk.css" rel="stylesheet" />
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/js.js"></script>
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/table/jquery.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<!-- layer javascript -->
<script src="/js/js/plugins/layer/layer.min.js"></script>
<script>
	layer.use('extend/layer.ext.js'); //载入layer拓展模块
</script>
<script type="text/javascript">
	function clean() {
		$("#studentName").val("");
		$("#teacherName").val("");
		$("#campusId").val(0);
		$("#date1").val("");
		$("#date2").val("");
		$("#banci").val("");
	}
	function delKeng(planId, kengId, data) {
		var stuId = "";
		if ($("#studentName").val() == "") {
			stuId = "";
		} else {
			stuId = planId;
		}
		studentid = $('#studentId option:selected').val();
		console.info(studentid) ;
		$.ajax({
			url : "/course/checkCoursePlanTime",
			data : {
				"planId" : planId, 
			},
			type : "post",
			dataType : "json",
			success : function(result) {
				if (result.nums == "1") {
					$.layer({
						shade : [ 0 ], //不显示遮罩
						area : [ 'auto', 'auto' ],
						dialog : {
							msg : '确定要删除该排课吗？',
							btns : 2,
							type : 4,
							btn : [ '确定', '取消' ],
							yes : function() {
								$.ajax({
									url : "/course/delCoursePlan",
									data : {
										"planId" : planId, "studentid" : studentid
									},
									type : "post",
									dataType : "json",
									success : function(result) {
										if (result.code == "1") {
											$(data).remove();
											$('#' + kengId).html('');
											layer.msg('成功删除', 1, 1);
										} else if (result.code == "2") {
											$.layer({
												shade : [ 0 ], //不显示遮罩
												area : [ 'auto', 'auto' ],
												dialog : {
													msg : '课程已签到，是否继续取消？',
													btns : 2,
													type : 4,
													btn : [ '是', '否' ],
													yes : function() {
														var str = prompt("请输入课程取消原因(必填)：", "");
														if (str.length > 0) { // 强制删除排课
															$.ajax({
																url : "/course/delCoursePlan",
																data : {
																	"planId" : planId,
																	"enforce" : "yes",
																},
																type : "post",
																dataType : "json",
																success : function(result) {
																	if (result.code == "1") {
																		$(data).remove();
																		$('#' + kengId).html('');
																		layer.msg('课程取消成功。', 1, 1)
																		location.reload();
																	} else if (result.code == "0") {
																		layer.msg(result.msg, 1, 1);
																	}
																},
																error : function(result) {
																	layer.msg("课程取消失败，请刷新页面重试!", 2, 1);
																}
															});
														} else {
															layer.msg("输入不得为空！", 1, 1);
														}
														;
													},
													no : function() {
													}
												}
											});
										} else if (result.code == "0") {
											layer.msg(result.msg, 1, 1);
										}
										return;
									},
									error : function(result) {
										layer.msg("课程取消失败，请刷新页面重试!", 1, 1);
									}
								});

							},
							no : function() {
							}
						}
					});
				} else {
					$.layer({
						type : 2,
						title : '超出规定时间删除排课',
						maxmin : false,
						shadeClose : true, //开启点击遮罩关闭层
						area : [ '380px', '430px' ],
						offset : [ '80px', '' ],
						iframe : {
							src : "/course/fullHourDelCoursePlan/" + planId + ',1'
						}
					});
				}
			}
		});
	}

	function exportCourseSort() {
		$("#returnType").val(3);
		$("#myform").attr("action", "/course/coursePlanList");
		$("#myform").submit();
		$("#myform").attr("action", "/course/queryCoursePlansManagement");
	}
	function deleteMultipleChoice() {
		$("div[name='showDeleteMessage']").each(function(i) {
			$(this).removeClass('hid');
		})
		$("div[name='hideDeleteMessage']").each(function() {
			$(this).addClass('hid');
		})
	}
	function DeleteOne() {
		$("div[name='hideDeleteMessage']").each(function(i) {
			$(this).removeClass('hid');
		})
		$("div[name='showDeleteMessage']").each(function() {
			$(this).addClass('hid');
		})
	}
</script>
<title>${_res.get('curriculum_management')}</title>
<style type="text/css">
ul li {
	display: block;
	padding: 5px
}

.navbar ul li {
	padding: 0
}

.component {
	line-height: 1.5em;
	padding: 2em 0 3em;
	width: 100%;
	width: 1070px;
	overflow: hidden
}

.component .filler {
	color: #d3d3d3
}

table {
	border-collapse: collapse;
	margin-bottom: 3em;
	background: #fff
}

td, th {
	padding: 2px
}

th {
	background-color: #31bc86;
	font-weight: bold;
	color: #fff;
	white-space: nowrap
}

tbody th {
	background-color: #2ea879
}

tbody tr:nth-child(2n-1) {
	background-color: #f5f5f5;
	transition: all .125s ease-in-out
}

tbody tr:hover {
	background-color: rgba(129, 208, 177, .3);
}
/* For appearance */
.sticky-wrap {
	overflow-x: auto;
	overflow-y: auto;
	max-height: 500px;
	position: relative;
	width: 1030px
}

.sticky-wrap .sticky-thead, .sticky-wrap .sticky-col, .sticky-wrap .sticky-intersect
	{
	opacity: 0;
	position: absolute;
	top: 0;
	left: 0;
	transition: all .125s ease-in-out;
	z-index: 50;
	width: auto
}

.sticky-wrap .sticky-thead {
	box-shadow: 0 0.25em 0.1em -0.1em rgba(0, 0, 0, .125);
	z-index: 100;
	width: 100%
}

.sticky-wrap .sticky-intersect {
	opacity: 1;
	z-index: 150
}

.sticky-wrap .sticky-intersect th {
	background-color: #666;
	color: #eee
}

.sticky-wrap td, .sticky-wrap th {
	box-sizing: border-box
}
/* Not needed for sticky header/column functionality */
td.user-name {
	text-transform: capitalize
}

.sticky-wrap.overflow-y {
	overflow-y: auto;
	max-height: 50vh
}

#laydate_table>thead>tr>th {
	background-color: #fff !important;
	color: #00625A !important;
}

ul li {
	padding: 0
}

.hid {
	display: none;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050; min-width: 1100px;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav" style="margin-left: 0;">
				<div class="ibox float-e-margins" style="width: 1070px">
					<div class="ibox-title">
						<h5>
							<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;<a
								href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; ${_res.get('curriculum_management')}
						</h5>
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">
							${_res.get("system.reback")} </a>
						<div style="clear: both;"></div>
					</div>
					<div class="ibox-content">
						<form action="/course/queryCoursePlansManagement" id="myform" method="post">
							<input type="hidden" name="returnType" id="returnType" value="1">
							<fieldset id="searchTable">
								<div class="form-group" style="margin-top: 15px;">
									<div style="float: left;">
										<label>${_res.get('student')}：</label>
										<select name="studentId" id="studentId" class="chosen-select" style="width: 150px;">
											<option value="">${_res.get('Please.select')}</option>
											<c:forEach items="${studentList}" var="student">
												<option id = "stu_id" value="${student.id}" <c:if test="${student.id eq studentId}">selected="selected"</c:if>>${student.real_name}</option>
											</c:forEach>
										</select> 
										<label>${_res.get('teacher')}：</label> 
										<select name="teacherId" id="teacherId" class="chosen-select" style="width: 150px;">
											<option value="">${_res.get('Please.select')}</option>
											<c:forEach items="${teacherList}" var="teacher">
												<option value="${teacher.id}" <c:if test="${teacher.id eq teacherId}">selected="selected"</c:if>>${teacher.real_name}</option>
											</c:forEach>
										</select>  
										<label>${_res.get('classNum')}：</label> 
										<select name="banciId" id="banciId" class="chosen-select" style="width: 150px;">
											<option value="">${_res.get('Please.select')}</option>
											<c:forEach items="${banciList}" var="banci">
												<option value="${banci.id}" <c:if test="${banci.id eq banciId}">selected="selected"</c:if>>${banci.classNum}-${banci.ctname }</option>
											</c:forEach>
										</select>  
									</div>
									<div style="float: left;">
										<label style="float: left; margin: 9px 0 0 2px">${_res.get('course.class.date')}：</label>
										<div style="float: left;">
											<input type="text" class="form-control layer-date" readonly="readonly" id="date1" name="date1" value="${date1}"
												style="width: 160px; background-color: #fff;" />
										</div>
										<div style="width: 30px; height: 30px; line-height: 30px; text-align: center; background: #E5E6E7; float: left; margin-top: 1px">至</div>
										<div style="float: left;">
											<input type="text" class="form-control layer-date" readonly="readonly" id="date2" name="date2" value="${date2}"
												style="width: 160px; background-color: #fff;" />
										</div>
									</div>
									<div style="clear: both;"></div>
									<div style="margin-top: 10px">
										<label>${_res.get('system.campus')}：</label> 
										<select name="campusId" id="campusId" class="chosen-select" style="width: 150px;">
											<option value="">${_res.get('Please.select')}</option>
											<c:forEach items="${campus}" var="campus_entity">
												<option value="${campus_entity.id}" <c:if test="${campus_entity.id eq campusId}">selected="selected"</c:if>>${campus_entity.campus_name}</option>
											</c:forEach>
										</select> 
										<label>类型：</label> 
										<select name="classtype" id="classtype" class="chosen-select" style="width: 150px;">
											<option value="2">全部</option>
											<option value="0" <c:if test="${classtype eq 0}">selected="selected"</c:if>>一对一</option>
											<option value="1" <c:if test="${classtype eq 1}">selected="selected"</c:if>>小班</option>
										</select> 
										<input type="submit" class="btn btn-outline btn-primary" value="${_res.get('admin.top.search')}" id="search" /> 
										<input type="reset" class="button btn btn-outline btn-warning " value="清空" onclick="clean()" />
										<c:if test="${operator_session.qx_coursecoursePlanList }">
											<input type="button" class="btn btn-outline btn-info" value="${_res.get('Output')}" onclick="exportCourseSort()" />
										</c:if>
									</div>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
				<div class="component" style="background: #fff; padding: 20px">
					<table>
						<thead>
							<tr id="flagRow">
								<c:if test="${!empty timeMap}">
									<c:if test="${operator_session.qx_coursedeleteCoursePlans}">
										<div>
											<input type="button" value="${_res.get('Delete_multiple_choice')}" onclick="deleteMultipleChoice()" class="btn btn-outline btn-info">
											<div name="showDeleteMessage" class="hid" style="float: right;">
												<input type="button" value="${_res.get('Remove_the_radio')}" onclick="DeleteOne()" class="btn btn-outline btn-info"> <input type="button"
													value="${_res.get('Confirm_deletion')}" onclick="isDeleteMultipleChoice()" class="btn btn-outline btn-info">
											</div>
										</div>
									</c:if>
									<c:forEach items="${timeMap }" var="courseDate" varStatus="tm">
										<th id="col${tm.count }" style="" valign="top">
											${courseDate.key }
											<script type="text/javascript">
												var now = new Date(Date.parse("${courseDate.key}".replace(/-/g, "/")));
												var day = now.getDay();
												var week;
												var arr_week = new Array("${_res.get('system.Sunday')}", "${_res.get('system.Monday')}", "${_res.get('system.Tuesday')}",
														"${_res.get('system.Wednesday')}", "${_res.get('system.Thursday')}", "${_res.get('system.Friday')}",
														"${_res.get('system.Saturday')}");
												document.write("(" + arr_week[day] + ")");
											</script>
										</th>
									</c:forEach>
								</c:if>
								<c:if test="${empty timeMap}">
								${_res.get('This_time_no_course_information')}
							</c:if>
							</tr>
						</thead>
						<tbody>
							<tr>
								<c:forEach items="${timeMap }" var="courseDate" varStatus="tm">
									<td style="background: #f3f3f4" valign="top">
										<ul>
											<c:forEach items="${courseDate.value }" var="course" varStatus="cId">
												<li style="background: #D9EDF7; color: #676A6C; margin: 3px 0; padding: 5px; min-width: 140px"
												 class="plantype_${course.PLAN_TYPE }" id="planDay_${course.ROOM_ID}_${courseDate.key}_${course.RANK_ID}_${course.CAMPUS_ID}">
													 <c:if test="${operator_session.qx_coursedelCoursePlan }">
														<div name="showDeleteMessage" class="hid">
															<input type="checkbox" name="checkbox" value="${course.ID}">
														</div>
														<div name="hideDeleteMessage" class="">
															<a href='javascript:void(0)' style='vertical-align: middle; display: inline-block; float: right;'
																onclick="delKeng('${course.ID}','planDay_${course.ROOM_ID}_${courseDate.key}_${course.RANK_ID}_${course.CAMPUS_ID}',this);">
																<img src='/images/img/error.png' width='12' height='12' title='取消' />
															</a>
														</div>
													 </c:if>
												     <c:choose>
														<c:when test="${course.PLAN_TYPE==2 }">
										<!--修改   --> 	 	${_res.get('type')}：${_res.get('Rest')}
															<c:if test="${course.rechargecourse eq '1' }">
																(${_res.get('Complement.row')})
															</c:if>
															<br>
										 					<c:if test="${!empty course.T_NAME}">
																${_res.get('teacher')}:${course.T_NAME}<br>
															</c:if>
															<c:if test="${!empty course.assistantName}">
																${_res.get('assistant')}:${course.assistantName}<br>
															</c:if>
															<c:choose>
																<c:when test="${course.startrest eq '00:00' && course.endrest eq '23:59' }">
											 						${_res.get('course.class.date')}：${_res.get('All.day.long')}<br>
																</c:when>
																<c:otherwise>
												 					${_res.get('course.class.date')}：${course.startrest }-${course.endrest }<br>
																</c:otherwise>
															</c:choose>
															<br>
															<br>
														</c:when>
														<c:otherwise>
															<span style="color: red;">${course.iscancel==1?"已取消(计算课时)<br>":''}</span>
															${_res.get("classroom")}:${course.CAMPUS_NAME}-${course.ROOM_NAME}<br>
											 	 			${_res.get('time.session')}:${course.RANK_NAME}<br>
															<c:choose>
																<c:when test="${course.PLAN_TYPE == 1 }">
																	${_res.get('mock.test')}<br>
																</c:when>
																<c:when test="${course.PLAN_TYPE == 2 }">
																	${_res.get('course.rest')}<br>
																</c:when>
															</c:choose>
								<!--  修改-->				${_res.get('course.course')}:${course.COURSE_NAME} <%-- ${course.rechargecourse }  --%> 
															<c:if test="${course.rechargecourse eq '1'} ">
																(${_res.get('Complement.row')})
															</c:if> 
															<br>
															<c:if test="${!empty course.T_NAME}">
																${_res.get('teacher')}:${course.T_NAME}<br>
															</c:if>
															<c:if test="${!empty course.assistantName}">
																${_res.get('assistant')}:${course.assistantName}<br>
															</c:if>
															<c:choose>
																<c:when test="${course.class_id == 0 }">
																		${_res.get('student')}:${course.S_NAME}<br>
																		${course.confirm == 0?"学生待确认":""}
																</c:when>
																<c:otherwise>
																		${_res.get('classNum')}:${course.CLASSNUM}<br>
																</c:otherwise>
															</c:choose>

														</c:otherwise>
													</c:choose>
													</li>

											</c:forEach>
										</ul>
									</td>
								</c:forEach>
							</tr>
						</tbody>
					</table>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
	<div id="tbox">
		<a id="gotop" href="javascript:void(0)"></a>
	</div>
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
	<script src="/js/js/top-nav/teach-1.js"></script>
	<!-- /table-top -->
	<script type="text/javascript" src="/js/table/jquery.ba-throttle-debounce.min.js"></script>
	<script type="text/javascript" src="/js/table/jquery.stickyheader.js"></script>
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#headerRow").hide();
			//初始化浮动标题的列宽
			$("th[id^='header']").each(function() {
				var index = this.id.substring(this.id.length - 1, this.id.length);
				$(this).css("width", $("#col" + index).css("width"));
			});

			//当页面scroll时,如果标题高于页面，显示浮动标题
			$(window).scroll(function() {
				if (parseInt($("#flagRow").offset().top) - parseInt($(window).scrollTop()) < 0) {
					console.log($("#flagRow").offset().top);
					document.getElementById("headerRow").style.marginBottom = "1000px";
					$("#headerRow").show();
				} else {
					$("#headerRow").hide();
				}
			});

			//窗口缩放时重置标题行的列宽
			$(window).resize(function() {
				$("th[id^='header']").each(function() {
					var index = this.id.substring(this.id.length - 1, this.id.length);
					$(this).css("width", $("#col" + index).css("width"));
				});
			});

			//区分休息颜色
			$(".plantype_2").css("background-color", "#DFF0D8");
			$(".plantype_2").css("color", "#676A6C");

		});
		function isDeleteMultipleChoice() {
			var str = "";
			$("input[name='checkbox']:checkbox:checked").each(function() {
				str += $(this).val() + ",";
			})
			if (str == "") {
				layer.msg("请选择需要删除的课程", 1, 2);
				return false;
			}
			if (confirm("您确定删除课程信息吗？课程将会全部删除")) {
				$.ajax({
					url : '/course/deleteCoursePlans',
					type : 'post',
					data : {
						'str' : str
					},
					dateType : 'json',
					success : function(data) {
						if (data.code == 1) {
							layer.msg("已成功删除", 1, 1);
						} else {
							layer.msg("删除异常丶请联系管理员", 1, 2);
						}
						$("#myform").submit();
					}
				})
			}
		}
		function searchCoursePlan(){
			$("#myform").submit();
		}
	</script>
</body>
</html>