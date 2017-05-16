<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('new.regulation')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" />

<style type="text/css">
body {
	background-color: #eff2f4;
}
</style>
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
	display:block;
	line-height: 20px;
	padding: 4px 0;
	border-bottom: 1px dashed #E2E2E2;
	color: #FFF;
	cursor: pointer;
	margin-right:38px;;
}

label {
	width: 100px;
}

.tds{
	text-align : left;
}
.chosen-results{
   max-height:80px !important
}
</style>
</head>
<body>
	<div id="wrapper">
		<form action="" id="actionForm" name="">
			<div class="ibox-content" style="height:470px">
				<input type="hidden" id="smartruleid" name="smartPlan.id" value="${smartrule.id }" >
				<input type="hidden" id="studentid" name="coursePlan.STUDENT_ID" value="${smartrule.studentid }" >
				<input type="hidden" id="teacherid" name="coursePlan.TEACHER_ID" value="${smartrule.teacherid }" >
				<input type="hidden" id="rankid" name="coursePlan.TIMERANK_ID" value="${smartrule.timerankid }" >
				<input type="hidden" id="campusid" name="coursePlan.CAMPUS_ID" value="${smartrule.campusid }" >
				<input type="hidden" id="courseid" name="coursePlan.COURSE_ID" value="${smartrule.courseid }" >
				<input type="hidden" id="canday" name="smartPlan.coursedays" value="" >
				<input type="hidden" id="weekday" name="smartPlan.weekday" value="${smartrule.weekday }" >
				<input type="hidden" id="assistantids" name="smartPlan.assistantids" value="${smartrule.assistantids }" >
				
				<input type="hidden" id="netCourse" name="netCourse" value="0" >
				<div class="jzpaike">
					<div>
						<table class="table table-bordered">
				        	<tr>
					        	<td class="table-bg1">${_res.get('student')}</td>
					        	<td class="table-bg2">${smartrule.stuname }</td>
					        	<td class="table-bg1">${_res.get('Week')}</td>
					        	<td class="table-bg2">${smartrule.weeknames }</td>
					        	<td class="table-bg1">${_res.get('system.campus')}</td>
					        	<td class="table-bg2">${smartrule.CAMPUS_NAME }</td>
				        	</tr>
				        	<tr>
					        	<td class="table-bg1">${_res.get('time.session')}</td>
					        	<td class="table-bg2">${smartrule.RANK_NAME }</td>
					        	<td class="table-bg1">${_res.get('course.course')}</td>
					        	<td class="table-bg2">${smartrule.COURSE_NAME }</td>
					        	<td class="table-bg1">${_res.get('teacher')}</td>
					        	<td class="table-bg2">${smartrule.teachername }</td>
				        	</tr>
				        	<tr>
					        	<td class="table-bg1"></td>
					        	<td class="table-bg2"></td>
					        	<td class="table-bg1">${_res.get('assistant')}</td>
					        	<td class="table-bg2">${smartrule.assistantnames }</td>
					        	<td class="table-bg1"></td>
					        	<td class="table-bg2"></td>
				        	</tr>
			        	</table>
			        </div>
			        	
		        	<div>
			        	<table class="table table-bordered">
				        	<tr>
					        	<td class="tablehead">${_res.get("index")}</td>
					        	<td class="tablehead">${_res.get("Arranging.the.date")}</td>
					        	<td class="tablehead">${_res.get("Timetable.people")}</td>
					        	<td class="tablehead">${_res.get("admin.sysLog.property.startdate")}</td>
					        	<td class="tablehead">${_res.get("Date.due")}</td>
					        	<td class="tablehead">${_res.get("Cycle")}</td>
				        	</tr>
				        	<tr class="znzhong">
					        	<td>1</td>
					        	<td><fmt:formatDate value="${planday }" type="time" timeStyle="full" pattern="yyyy-MM-dd"/></td>
					        	<td>${createuser }</td>
					        	<td><span id="starttime">${smartrule.firstday}</span></td>
					        	<td><span id="endtime"></span></td>
					        	<td><span id="days"></span></td>
				        	</tr>
			        	</table>
		        	</div>
			        			        	
		        	<div class="m-b-sm"><label class="label-wid">${_res.get("admin.sysLog.property.startdate")}：</label>
		        		<input type="text" name="start" readonly="readonly" value="${smartrule.firstday}" id="date" /></div>
		        	<div class="m-b-sm"><label class="label-wid">${_res.get("Cycle")}：</label>
		        		<input type="text" id="alldayid" name="" value="" class="addday" style="width:30px;height:30px"/> X <input type="text" readonly="readonly" id="classhour" name="classhour" value="${smartrule.class_hour }" class="addday" style="border:0"/>&nbsp;
		        		${_res.get('session')}= <input readonly="readonly" type="text" id="allhours" name="" value="" class="addday" style="border:0"/>&nbsp;${_res.get("session")}</div>
		        	<div>
		        	   <label class="label-wid">${_res.get('class.classroom')}：</label>
		        	   <select id="rooms" name="coursePlan.ROOM_ID" class="chosen-select" style="width: 150px;" >
			        	   <option value="">--${_res.get('system.alloptions')}--</option>
		        	   </select>
		        	</div>
		        	<p>
						<label class="label-wid" >${_res.get("course.netcourse")}：</label> 
							<input id="planType0" name="netCoursetype" value="0" type="radio" checked="checked" onchange="changeNetType(this.value)">${_res.get('admin.common.no')}&nbsp; 
							<input id="planType1" name="netCoursetype" value="1" type="radio"  onchange="changeNetType(this.value)">${_res.get('admin.common.yes')}
						</p>
					<c:if test="${operator_session.qx_smartplansaveSmartCoursePlan }">
			        	<input type="button" id="" name="" onclick="saveSmartCoursePlan()" value="${_res.get('course.arranging')}" class="btn btn-outline btn-primary" style="float:right"/>
					</c:if>
		        	<div style="clear:both"></div>
		        	</div>
	 		</div>	
	 	</form>
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script>
	 $(".chosen-select").chosen({disable_search_threshold: 30});
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

		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		
	</script>
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    
    <script src="/js/js/plugins/layer/laydate/laydate.js"></script>
    <script>
         //日期范围限制
         $(function(){
        	 var minday = '${smartrule.firstday}';
	        var date = {
	            elem: '#date',
	            format: 'YYYY-MM-DD',
	            min: minday,
	            max: '2099-06-16', //最大日期
	            istime: false,
	            istoday: false,
	            choose: function (datas) {
	            	$("#starttime").text(datas);
	            	getLastTime();
	            }
	        };
	        laydate(date);
         });
 </script>
    
    
    <script>
       $('li[ID=nav-nav3]').removeAttr('').attr('class','active');
    </script>
    
    <script type="text/javascript">
    $(function(){
		$('#alldayid').blur(function(){
				var allday = $("#alldayid").val();
				$("#days").text(allday);
				var hour = parseFloat($("#classhour").val());
				var day = parseInt(allday);
				var weekday = $("#weekday").val().replace(new RegExp("\\|","g"),"");
				$("#allhours").val((hour*day*weekday.length));
				getLastTime();
    		});
    	});
    
    
		function getLastTime(){
			$("#rooms").html("<option value='' >--${_res.get('Please.select')}--</option>");
			$("#rooms").trigger("chosen:updated");
			var stime = $("#starttime").text();
			var alldays = $("#alldayid").val();
			var allhours = $("#allhours").val();
			var weekday = $("#weekday").val();
			if(stime==""||alldays==""||allhours==""||stime==""){
				return false;	
			}else{
				$.ajax({
					url:"/smartplan/sureEnoughHours",
					data:{"stime":stime,"alldays":alldays,"allhours":allhours,"weekday":weekday,
							"teacherid":$("#teacherid").val(),"stuid":$("#studentid").val(),
							"rankid":$("#rankid").val(),"campusid":$("#campusid").val(),"courseid":$("#courseid").val()},
					dataType:"json",
					async:true,
					success:function(data){
						$("#rooms").html("<option value=\"\" >--${_res.get('Please.select')}--</option>");
						$("#rooms").trigger("chosen:updated");
						if(data.code=="0"){
							parent.layer.msg(data.msg,2,5);
						}
						if(data.code=="1"){
							if(data.map.code=="1"){
								$("#canday").val("");
								$("#endtime").text("");
								parent.layer.msg(data.map.msg,2,5);
							}else{
								$("#canday").val(""+data.map.canlist);
								$("#endtime").text(data.map.lastday);
								if(data.map.rooms.length>0){
									var optionstr = "<option value=\"\" >--${_res.get('Please.select')}--</option>";
									for(var i=0;i<data.map.rooms.length;i++){
										var used = data.map.rooms[i].USED;
										var dis = ""
										if(used =="yes"){
											dis = " disabled='disabled' ";
										}
										optionstr += "<option value=\""+data.map.rooms[i].ID+"\""+dis+">"+data.map.rooms[i].NAME+"</option>"
									}
									$("#rooms").html(optionstr);
									$("#rooms").trigger("chosen:updated");
								}
							}
						}
					}
				});
			}
		}
	</script>
	<script type="text/javascript">
		var index = parent.layer.getFrameIndex(window.name);
	  	parent.layer.iframeAuto(index); 
	  	
	  	function saveSmartCoursePlan(){
	  		var roomids = $("#rooms").val();
	  		var candays = $("#canday").val();
	  		if(roomids==null||roomids==""){
	  			alert("请选择教室");
	  			return false;
	  		}
	  		if(candays==null||candays==""){
	  			alert("请选择时间");
	  			return false;
	  		}
	  		if(confirm("确定信息无误，添加本次排课?")){
	  			$.ajax({
		            cache: true,
		            type: "POST",
		            url:"/smartplan/saveSmartCoursePlan",
		            data:$('#actionForm').serialize(),// 你的formid
		            async: false,
		            error: function(request) {
		            	layer.msg("网络异常，请稍后重试。", 1,1);
		            },
		            success: function(data) {
		            	parent.layer.msg(data.msg,2,1);
			    		if(data.code=='1'){//成功
			    			parent.window.location.reload();
			    			setTimeout("parent.layer.close(index)",3000);
			    		}
		            }
		        });
	  		}
	  		
	  	}
	  	
	  	function changeNetType(value){
	  		$("#netCourse").val(value);
	  	}
	  	
	</script>
    
    
</body>
</html>