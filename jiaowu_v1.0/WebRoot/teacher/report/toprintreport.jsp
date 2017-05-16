<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get("report.my.report")}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet"/>
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet"/>
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet"/>
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet"/>
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet"/>
<link href="/css/css/animate.css" rel="stylesheet"/>
<script src="/js/js/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="/js/jquery.PrintArea.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 .xubox_tabmove{
	background:#EEE;
}
.xubox_tabnow{
    color:#31708f;
}
 h5,h4{
  font-weight: 600
 }
 .basicme{
  background-color:#F3F3F4;
  padding:2px 5px 1px 10px
 }
 .basicme-cotent{
  padding:16px
 }
 .basicme-textarea{
  padding:16px 0
 }
 .bascotent{
  margin-bottom:10px
 }
 label{
  width:200px;
  font-weight: 100
 }
 .basictop{
  margin-top: 10px
 }
 textarea{
  border-radius: 6px;
  border: 1px solid #e2e2e2;
  padding: 3px;
  width: 100%
 }
 .marginlt{
  margin-left: -40px
 }
 .laydate_body .laydate_bottom{
  height:30px !important
 }
 .laydate_body .laydate_top{
  padding:0 !important
 }
 input[type="text"]{
  height:30px
 }
</style> 
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
	   <%@ include file="/common/left-nav.jsp"%>
	   <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
			  <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>
		<a class="btn btn-outline btn-primary btn-xs" style="float: right" href="javascript:void(0)" onclick="window.history.go(-1)">返回</a>
	  <div class="margin-nav my_show" style="width:100%;">	
			<div class="col-lg-12" style="min-width:680px">
				<div class="ibox float-e-margins">
					<div class="ibox-content">
					    <div>
					    	<h4 style="float: left;">学生进度报告</h4>
					    	
						    <div style="clear: both;"></div>
						</div>
					
						<div class="basicme">
							<h5>基本信息</h5>
						</div>
						<div class="basicme-cotent">
							<input type="hidden" id="teachergradeid" name="teachergrade.id" value="${pointgrade.id }" >
							<input type="hidden" id="studentid" name="studentid" value="${baseMsg.studentid }" >
							<input type="hidden" id="teacherid" name="teacherid" value="${baseMsg.teacherid  }" >
							<input type="hidden" id="pointid" name="teachergrade.pointid" value="${baseMsg.id }" >
						
							<div class="bascotent">	
								<label>${_res.get("student.name")}:&nbsp;&nbsp;&nbsp;${baseMsg.studentname }</label>
								<label>${_res.get('teacher')}:&nbsp;&nbsp;&nbsp;${baseMsg.teachername }</label>
								<label>就读学校:&nbsp;&nbsp;&nbsp;${baseMsg.SCHOOL }</label> 
							</div>
							<div class="bascotent">	
								<label>年级:&nbsp;&nbsp;&nbsp;${baseMsg.GRADE_NAME }</label>
								<label>${_res.get('appointment.time')}:&nbsp;&nbsp;&nbsp;${baseMsg.appointment }</label>
								<label>${_res.get('course.course')} :&nbsp;&nbsp;&nbsp;${course }</label>
							</div>	
						</div>
						
						<div>
						   <div class="basicme">
								<h5>教学计划</h5>
							</div>
							<ul class="basicme-cotent">
								<li>
								   <div class="bascotent">
								       <span>课程周期：</span>
								       ${pointgrade.lastcoursebegindate } ${_res.get('to')} 
								       -- ${pointgrade.lastcourseenddate }
								   </div> 
								</li>
								<div style="clear: both;"></div> 
								<li style="float: left;margin-right:50px">
									<div style="float: left">授课内容：</div>
									${pointgrade.lastcoursedetail }
								</li>
								<li style="float: left">
								    <div style="float: left">待授课程内容：</div>
									${pointgrade.COURSE_DETAILS }
								</li>
								<div style="clear: both;"></div>
							</ul>
						</div>
						
						<div>
						  <div class="basicme">
							<h5>${_res.get('Academic.Performance')}</h5>
						  </div>
						  <div>
							    <ul>
								    <li>
										<div class="col-lg-3" style="margin: 10px 0;">
											<span class="kechengjilu">${_res.get("attention")}:${pointgrade.ATTENTION}</span> 
										</div>
										<div class="col-lg-3" style="margin: 10px 0;">
											<span class="kechengjilu">${_res.get("understanding")}:${pointgrade.UNDERSTAND}</span> 
										</div>
										<div class="col-lg-3" style="margin: 10px 0;">
											<span class="kechengjilu">${_res.get("study.attitude")}:${pointgrade.STUDYMANNER}</span> 
										</div>
										<div class="col-lg-3" style="margin: 10px 0;">
											<span class="kechengjilu">${_res.get("last.homework")}:${pointgrade.STUDYTASK}</span> 
										</div>
										<div style="clear: both;"></div>
									</li>
								</ul>
							</div>
						</div>
						
						<div>
						   <div class="basicme">
								<h5>整体评价（Teacher Feedback）</h5>
							</div>
							<div class="basicme-textarea">
								<ul class="marginlt">
									<li> 
										${pointgrade.teacherfeedback }
									</li>
								</ul>
							</div>
						</div>
						
						<div>
						   <div class="basicme">
								<h5>作业问题（Homework Assigned）</h5>
							</div>
							<div class="basicme-textarea">
								<ul class="marginlt">
									<li>
										${pointgrade.question }
									</li>
								</ul>
							</div>
						</div>
						
						<div>
						  <div class="basicme">
							  <h5>${_res.get('Suggestions.program')}（What to  Prepare for Next Session）</h5>
						  </div>
						  <div class="basicme-textarea">
							<ul class="marginlt">
								<li>
									${pointgrade.method }
								</li>
									
							</ul>
						 </div>
						</div>
						
						
					</div>
				</div>
			</div>
			<div style="clear:both;"></div>
	</div>
	<div align="center" class="form-group">
							<input type="button" class="btn btn-outline btn-info" value="打印" id="print" style="margin-top:20px"/> 
						</div>
	</div>	  
</div>  
	<script>
	
	$(document).ready(function(){
		$("#print").click(function(){
		$(".my_show").printArea();
		});
		}); 
	</script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
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
    <script>
       $('li[ID=nav-nav17]').removeAttr('').attr('class','active');
       
   	var begincoursetime = {
			elem : '#begincoursetime',
			format : 'YYYY-MM-DD',
			istime : false,
			istoday : false,
			choose : function(datas) {
				finishcoursetime.min = datas; 
			}
		};
   	var finishcoursetime = {
			elem : '#finishcoursetime',
			format : 'YYYY-MM-DD',
			istime : false,
			istoday : false,
			choose : function(datas) {
				begincoursetime.max = datas; 
			}
		};
	laydate(begincoursetime);
	laydate(finishcoursetime);
	
	
    </script>
</body>
</html>