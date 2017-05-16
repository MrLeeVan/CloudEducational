<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
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
  width:60px;
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
<body style="background:#eff2f4">   
	  <div class="margin-nav1" style="width:100%;">	
       <form action="/report/submitDayreportFixed" method="post" id="fixdayreportForm">
		<div class="col-lg-12" style="min-width:680px">
		 <div class="ibox float-e-margins">
			<div class="col-lg-12" style="min-width:680px">
				<div class="ibox float-e-margins">
					<div class="ibox-content">
					    <div>
					    	<h4>${_res.get('Student.progress.reports')}</h4>
						</div>
						<div class="basicme">
							<h5>${_res.get('Basic.Information')}</h5>
						</div>
						<div class="basicme-cotent">
					       <input type="hidden" value="${tg.id }" name="gradeUpdate.id" id="tgid" >
						
							<div class="bascotent">	
								<label>${_res.get("student.name")}:</label>
								<input type="text" readonly="readonly" name="studentname" value="${corder.real_name }" >&nbsp;&nbsp;&nbsp;
								<label>${_res.get('course.course')}:</label>
								<input type="text" readonly="readonly" name="teachername" value="${plan.course_name }" >&nbsp;&nbsp;&nbsp;
							</div>
							<div class="bascotent">	
								<span>${_res.get('total.sessions')}:</span>
								<input type="text" readonly="readonly"  value="${corder.allhour }" >${_res.get("session")}&nbsp;&nbsp;&nbsp;&nbsp;
								<span>${_res.get('Already.in.class')}:</span>
								<input type="text" readonly="readonly" value="${usedHours }" >${_res.get("session")}&nbsp;&nbsp;&nbsp;&nbsp;
								<span>${_res.get('The.remaining.hours')} :</span>
								<input type="text" readonly="readonly" value="${leftHours }" >${_res.get("session")}&nbsp;&nbsp;&nbsp;&nbsp;
							</div>	
						</div>
					<div>
					    <div class="basicme">
						   <h5>${_res.get('Academic.Performance')}</h5>
						</div>
						<div>
							<ul>
								<li>
									<div class="col-lg-3" style="margin: 10px 0;float:left;">
										<span class="kechengjilu">${_res.get("attention")}:</span> <select name="gradeUpdate.ATTENTION" id="zhuyili1" class="chosen-select" style="width:100px">
											<option value="优" <c:if test="${record.ATTENTION eq '优' }"> selected="selected"</c:if> >--优--</option>
											<option value="良" <c:if test="${record.ATTENTION eq '良' }"> selected="selected"</c:if> >--良--</option>
											<option value="中" <c:if test="${record.ATTENTION eq '中' }"> selected="selected"</c:if> >--中--</option>
											<option value="差" <c:if test="${record.ATTENTION eq '差' }"> selected="selected"</c:if> >--差--</option>
										</select>
									</div>
									<div class="col-lg-3" style="margin: 10px 0;float:left;">
										<span class="kechengjilu">${_res.get("understanding")}:</span> <select name="gradeUpdate.UNDERSTAND" id="lijieli1" class="chosen-select" style="width:100px">
											<option value="优" <c:if test="${record.UNDERSTAND eq '优' }"> selected="selected"</c:if> >--优--</option>
											<option value="良" <c:if test="${record.UNDERSTAND eq '良' }"> selected="selected"</c:if> >--良--</option>
											<option value="中" <c:if test="${record.UNDERSTAND eq '中' }"> selected="selected"</c:if> >--中--</option>
											<option value="差" <c:if test="${record.UNDERSTAND eq '差' }"> selected="selected"</c:if> >--差--</option>
										</select>
									</div>
									<div class="col-lg-3" style="margin: 10px 0;float:left;">
										<span class="kechengjilu">${_res.get("study.attitude")}:</span> <select name="gradeUpdate.STUDYMANNER" id="xuxitaidu1" class="chosen-select" style="width:100px">
											<option value="优" <c:if test="${record.STUDYMANNER eq '优' }"> selected="selected"</c:if> >--优--</option>
											<option value="良" <c:if test="${record.STUDYMANNER eq '良' }"> selected="selected"</c:if> >--良--</option>
											<option value="中" <c:if test="${record.STUDYMANNER eq '中' }"> selected="selected"</c:if> >--中--</option>
											<option value="差" <c:if test="${record.STUDYMANNER eq '差' }"> selected="selected"</c:if> >--差--</option>
										</select>
									</div>
									<div class="col-lg-3" style="margin: 10px 0;float:left;">
										<span class="kechengjilu">${_res.get("last.homework")}:</span> <select name="gradeUpdate.STUDYTASK" id="shangcizuoye1" class="chosen-select" style="width:120px">
											<option value="未布置" <c:if test="${record.STUDYTASK eq '未布置' }"> selected="selected"</c:if> >--未布置--</option>
											<option value="完成较好" <c:if test="${record.STUDYTASK eq '完成较好' }"> selected="selected"</c:if> >--完成较好--</option>
											<option value="完成较差" <c:if test="${record.STUDYTASK eq '完成较差' }"> selected="selected"</c:if> >--完成较差--</option>
											<option value="未完成" <c:if test="${record.STUDYTASK eq '未完成' }"> selected="selected"</c:if> >--未完成--</option>
										</select>
									</div>
									<div style="clear: both;"></div>
								</li>
							</ul>
					   </div>
					</div>
					
					 <div>
						<div class="basicme">
							<h5>${_res.get('The.course')}</h5>
						</div>
						<div class="basictop">
							<ul class="marginlt">
								<li>
									<textarea id="question" name="gradeUpdate.course_details" rows="5">${record.COURSE_DETAILS }</textarea>
								</li>
							</ul>
						</div>
					  </div>
					  <div>	
						<div class="basicme">
							<h5>${_res.get('This.job')} </h5>
						</div>
						<div class="basictop">
							<ul class="marginlt">
								<li>
									<textarea id="method" name="gradeUpdate.homework" rows="5">${record.HOMEWORK }</textarea>
								</li>
									
							</ul>
						</div>
					 </div>	
					
					<div>
						<div class="basicme">
							<h5>${_res.get("qs.in.homework")}（Homework Assigned）</h5>
						</div>
						<div class="basictop">
							<ul class="marginlt">
								<li>
									<textarea id="question" name="gradeUpdate.question" rows="5">${record.question }</textarea>
								</li>
							</ul>
						</div>
					</div>
					
					<div>
						<div class="basicme">
							<h5>${_res.get('Suggestions.program')}（What to  Prepare for Next Session）</h5>
						</div>
						<div class="basictop">
							<ul class="marginlt">
								<li>
									<textarea id="method" name="gradeUpdate.method" rows="5">${record.method }</textarea>
								</li>
							</ul>
						</div>
					</div>	
					
					<div align="center" class="form-group">
						<input class="btn btn-outline btn-primary" type="button" onclick="submitUpdate()"  value="${_res.get('update') }">&nbsp;&nbsp; 
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary" >${_res.get('system.reback')}</a>
					</div>
						
					</div>
				</div>
			</div>
		</div>
			<div style="clear:both;"></div>
		</div>
	</form>
	</div>
  
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
	
	<script type="text/javascript">
	var index = parent.layer.getFrameIndex(window.name);
    /* parent.layer.iframeAuto(index); */
    
		function submitUpdate(){
			$.ajax({
				url:"/report/submitDayreportFixed",
				dataType:"json",
				type:"post",
				data:$("#fixdayreportForm").serialize(),
				success:function(result){
					parent.layer.msg(result.msg,2,1);
					if(result.code=="1"){
						parent.layer.close(index);
					}
				}
			});
		}
	</script>
 
</body>
</html>
