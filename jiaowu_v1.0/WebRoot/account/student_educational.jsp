<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<!-- Mainly scripts -->
<script src="/js/js/bootstrap.min.js?v=1.7"></script>
<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<!-- Custom and plugin javascript -->
<script src="/js/js/hplus.js?v=1.7"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>教案库</title>
<!-- Mainly scripts -->
<style type="text/css">
ul, ol, li {
	list-style: none;
}

.header {
	font-size: 12px;
}

.kechengjilu {
	display: inline;
	width: 60px;
	height: 34px;
	line-height: 34px;
	margin-top: 10px;
}

select {
	margin: 0px 0 0 10px;
}

.dengemail:hover {
	text-decoration: none;
}

#sign {
	width: 150px;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom yincang" style="margin: 0 0 60px;">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff; border: 0">
					<div class="navbar-header"></div>
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="col-lg-12 ui-sortable" style="padding-left: 0; padding-right: 0">
				<div class="zsd-cont-r">
					<!-- <fieldset id="searchTable" style="width: auto;"> -->
					<div class="ibox-content" id="jiaowu_pingjia" style="margin-bottom: 20px">
						<form action="" method="post">
							<input type="hidden" id="courseplanid" value="${courseplan_id}" name="courseplanid" /> <span id="returnMsg" style="color: red; font-size: 20px;">消息提示：${message }</span>
							<h5>
								<font>${_res.get("courselib.teacher.evaluation") }(${_res.get("courselib.comment.remark") })</font>
							</h5>
							<hr>
							<span>${_res.get("understanding")}:${t.UNDERSTAND}</span> 
							<span>${_res.get("attention")}:${t.ATTENTION}</span> 
							<span>${_res.get("study.attitude")}:${t.STUDYTASK}</span> 
							<span>${_res.get("student's.comments")}:${t.STUDYMANNER}</span> 
							<span>点名情况:${t.singn==1?"正常":t.singn==2?"迟到":t.singn==3?"旷课":t.singn==4?"请假":"未点名"}</span> 
							<hr>
							<ol>
								<li><span>${_res.get('The.course')}:</span> 
								<textarea disabled="disabled" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 100%;" rows="5">${t.COURSE_DETAILS}</textarea></li>
								<li><span>${_res.get('This.job')}:</span> 
								<textarea disabled="disabled" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 100%;" rows="5">${t.HOMEWORK}</textarea></li>
								<li><span>${_res.get("qs.in.homework")}:</span> 
								<textarea disabled="disabled" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 100%;" rows="5">${t.QUESTION}</textarea></li>
								<li><span>${_res.get("solutions")}:</span> 
								<textarea disabled="disabled" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 100%;" rows="5">${t.METHOD}</textarea></li>
								<li><span>${_res.get("course.remarks")}/${_res.get("reminder")}:</span> 
								<textarea disabled="disabled" name="teachergrade.tutormsg" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 100%;" rows="5"></textarea>${t.TUTORMSG}</li>
							</ol>
							<hr>
							<div>
								<h5>教师课堂表现：</h5>

							</div>
							<hr>
							<ol class="teacher-comment-sele" style="padding: 0">
								<li>
									<div class="col-lg-3" style="margin: 10px 0;">
										<span class="kechengjilu">${_res.get("logic")}:</span> 
										<select id="LJX">
											<option ${t.LJX=="优"?"selected='selected'":""}value="优">--${_res.get("excellent")}--</option>
											<option ${t.LJX=="良"?"selected='selected'":""} value="良">--${_res.get("good")}--</option>
											<option ${t.LJX=="中"?"selected='selected'":""} value="中">--${_res.get("average")}--</option>
											<option ${t.LJX=="差"?"selected='selected'":""} value="差">--${_res.get("poor")}--</option>
										</select>
									</div>
									<div class="col-lg-3" style="margin: 10px 0;">
										<span class="kechengjilu">${_res.get("knowledge")}:</span> 
										<select id="ZSD">
											<option ${t.ZSD=="优"?"selected='selected'":""} value="优">--${_res.get("excellent")}--</option>
											<option ${t.ZSD=="良"?"selected='selected'":""} value="良">--${_res.get("good")}--</option>
											<option ${t.ZSD=="中"?"selected='selected'":""} value="中">--${_res.get("average")}--</option>
											<option ${t.ZSD=="差"?"selected='selected'":""} value="差">--${_res.get("poor")}--</option>
										</select>
									</div>
									<div class="col-lg-3" style="margin: 10px 0;">
										<span class="kechengjilu">${_res.get("responsibility")}:</span> 
										<select  id="ZRX">
											<option ${t.ZRX=="优"?"selected='selected'":""} value="优">--${_res.get("excellent")}--</option>
											<option ${t.ZRX=="良"?"selected='selected'":""} value="良">--${_res.get("good")}--</option>
											<option ${t.ZRX=="中"?"selected='selected'":""} value="中">--${_res.get("average")}--</option>
											<option ${t.ZRX=="差"?"selected='selected'":""} value="差">--${_res.get("poor")}--</option>
										</select>
									</div>
									<div class="col-lg-3" style="margin: 10px 0;">
										<span class="kechengjilu">${_res.get("amiableness")}:</span> 
										<select  id="QHL">
											<option ${t.QHL=="优"?"selected='selected'":""} value="优">--${_res.get("excellent")}--</option>
											<option ${t.QHL=="良"?"selected='selected'":""} value="良">--${_res.get("good")}--</option>
											<option ${t.QHL=="中"?"selected='selected'":""} value="中">--${_res.get("average")}--</option>
											<option ${t.QHL=="差"?"selected='selected'":""} value="差">--${_res.get("poor")}--</option>
										</select>
									</div>
									<span>${_res.get("course.remarks")}:</span> 
									<textarea id="SBZ" style="background: #f2f2f2; border-radius: 6px; border: 1px solid #e2e2e2; padding: 3px; width: 100%;" rows="5">${t.SBZ}</textarea>
									<div style="clear: both;"></div>
								</li>
							</ol>
							<hr>
						</form>
						<c:if test="${operator_session.qx_teachergradesaveTeachergrade }">
							<div align="center" class="form-group">
								<c:if test="${t!=null}">
									<input class="btn btn-outline btn-primary" type="button" onclick="saveTeachergrade()" value="${_res.get('admin.common.submit') }">&nbsp;&nbsp;
								</c:if>
								<c:if test="${t==null}">
									<input class="btn btn-outline btn-primary" type="button"  value="未点名或教师未评价，暂时不能对老师评价">&nbsp;&nbsp;
								</c:if>
							</div>
							<div style="clear: both;"></div>
						</c:if>
					</div>
					<!-- </fieldset> -->
				</div>
			</div>
			<div style="clear: both;"></div>
		</div>
	</div>
</body>
<!-- layer javascript -->
<script src="/js/js/plugins/layer/layer.min.js"></script>
<script>
	layer.use('extend/layer.ext.js'); //载入layer拓展模块
</script>
<script type="text/javascript">
	//提交老师对学生的评价
	function saveTeachergrade() {
		var studentid = $("#replaceid").val();
		var courseplanid = $("#courseplanid").val();
		var LJX = $("#LJX").val();
		var ZSD = $("#ZSD").val();
		var ZRX = $("#ZRX").val();
		var QHL = $("#QHL").val();
		var SBZ = $("#SBZ").val();
		$.ajax({
			url : '/teachergrade/saveTeachergrade',
			type : 'post',
			data : {
				'studentid' : studentid,
				'courseplanid' : courseplanid,
				'LJX' : LJX,
				'ZSD' : ZSD,
				'ZRX' : ZRX,
				'QHL' : QHL,
				'SBZ' : SBZ
			},
			dataType : 'json',
			success : function(data) {
				layer.msg(data.message, 1, 2);
				setTimeout("window.reload.location();", 1000);
			}
		})
	}
</script>

<script src="/js/js/top-nav/top-nav.js"></script>
<script src="/js/js/top-nav/teach.js"></script>
</html>