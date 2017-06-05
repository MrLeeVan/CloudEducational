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

<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">

<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>

<script src="/js/js/bootstrap.min.js?v=1.7"></script>
<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<script src="/js/js/hplus.js?v=1.7"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>学生评价</title>
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
				<div class="wrapper wrapper-content animated fadeInRight" style="padding:0 10px 40px">
					<div class="row">
					   <div class="ibox-title" style="margin-bottom:20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp; 课堂评价 <span id="mingcheng"></span>
							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
						</div>
						<div class="col-lg-12 ui-sortable" style="padding-left:0;padding-right:0">
							<div class="zsd-cont-r">
								<div class="ibox-content" id="jiaowu_pingjia" style="margin-bottom: 20px">
									<form action="/student/toSaveStudentGrade" id="saveStudentGrade" method="post">
										<input type="hidden" id="tgid" name="teachergrade.id" value="${tg.id}" /> 
											<hr>
											<h5>
												<font>教师课堂评价</font>
											</h5>
											<ol>
												<div style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">知识点：</label> 
													<select name="teachergrade.zsd" id="attention" class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" <c:if test="${empty tg || tg.attention eq '优' }"> selected="selected"</c:if>>优</option>
															<option value="良" <c:if test="${tg.attention eq '良' }">selected="selected"</c:if>>良</option>
															<option value="中" <c:if test="${tg.attention eq '中' }">selected="selected"</c:if>>中</option>
															<option value="差" <c:if test="${tg.attention eq '差' }">selected="selected"</c:if>>差</option>
													</select>
													</li>
												</div>
												<div class="form-group" style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">逻辑性：</label> 
													<select name="teachergrade.ljx" id="understand" class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" <c:if test="${empty tg || tg.understand eq '优' }">  selected="selected"</c:if>>优</option>
															<option value="良" <c:if test="${tg.understand eq '良' }">  selected="selected"</c:if> >良</option>
															<option value="中" <c:if test="${tg.understand eq '中' }">  selected="selected"</c:if> >中</option>
															<option value="差" <c:if test="${tg.understand eq '差' }">  selected="selected"</c:if> >差</option>
													</select></li>
												</div>

												<div class="form-group" style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">责任心：</label> 
													<select name="teachergrade.zrx" id="studytask" class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优" <c:if test="${empty tg || tg.studytask eq '优' }">  selected="selected"</c:if> >优</option>
															<option value="良" <c:if test="${tg.studytask eq '良' }">  selected="selected"</c:if> >良</option>
															<option value="中" <c:if test="${tg.studytask eq '中' }">  selected="selected"</c:if> >中</option>
															<option value="差" <c:if test="${tg.studytask eq '差' }">  selected="selected"</c:if> >差</option>
													</select></li>
												</div>
												<div class="form-group" style="margin: 10px 0;">
													<li><label class="col-sm-3 control-label" style="font-weight: normal;">亲和力：</label>
													<select name="teachergrade.qhl" id="studymanner"
														class="chosen-select" style="width: 120px;" tabindex="2">
															<option value="优"  <c:if test="${empty tg || tg.studymanner eq '优' }">  selected="selected"</c:if> >优</option>
															<option value="良"  <c:if test="${tg.studymanner eq '良' }">  selected="selected"</c:if> >良</option>
															<option value="中"  <c:if test="${tg.studymanner eq '中' }">  selected="selected"</c:if> >中</option>
															<option value="差"  <c:if test="${tg.studymanner eq '差' }">  selected="selected"</c:if> >差</option>
													</select></li>
												</div>
												<div class="form-group"  style="margin: 10px 0; margin-left: -6px;">
													<label class="col-sm-3 control-label" style="font-weight: normal;">意见和建议：</label>
													<div class="col-sm-8">
														<textarea id="beizhu1" name="teachergrade.sbz" class="form-control" rows="2"></textarea>
													</div>
												</div>
											</ol>
											<div style="clear: both; margin-bottom: 10px;"></div>
									</form>
										<div align="center" class="form-group">
											<input class="btn btn-outline btn-primary" type="button" onclick="return saveTeachergrade()" value="${_res.get('admin.common.submit') }">&nbsp;&nbsp; 
											<!-- <input class="btn btn-outline btn-success" type="button" onclick="clearTeachergrade()" value="清空"> -->
										</div>
								</div>
								
							</div>
						</div>
						<div style="clear: both;"></div>
					</div>
				</div>
	</div>
</body>

<script language="javascript" type="text/javascript">

	function saveTeachergrade() {
			document.forms[0].submit();
	}

</script>

</html>