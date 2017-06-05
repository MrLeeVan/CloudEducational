<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link href='/fullcalendar/fullcalendar.css' rel='stylesheet' />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<!-- 回到顶部 -->
<link type="text/css" href="/css/lrtk.css" rel="stylesheet" />
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/js.js"></script>

<script src='/js/js/jquery-2.1.1.min.js'></script>
<script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
<script src='/fullcalendar/fullcalendar.min.js'></script>
<script src="/js/js/plugins/layer/layer.min.js"></script>

<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<title>${_res.get("curriculum_arrangement") }</title>
<style type="text/css">
.header {font-size: 12px;}
body {font-size: 12px;font-family: "Lucida Grande", Helvetica, Arial, Verdana, sans-serif;background-color: #eff2f4;}
#calendar {width: 100%;margin: 0 auto;}
ul, li {list-style-type: none;margin: 0;}
.pk_info {width: 128px;float: left;height: 68px;padding: 0 4px;}
table.normal tbody tr.odd_time td {height: 68px;line-height: 68px;border-bottom: 2px solid #f5f5f5;}
table {border-collapse: collapse;border: medium none;}
.fc-event{padding:4px 0;margin-left:4px;}
.bgTips span {display: inline-block;}
.bgTips span em {display: inline-block;height: 12px;width: 12px;vertical-align: middle;border: 1px solid #fff;margin-right: 5px;}
.bgTips span em.BT-1 {background-color: #d4606e;}
.bgTips span em.BT-2 {background-color: #B68710;}
.bgTips span em.BT-3 {background-color: rgb(104, 168, 52);}
.bgTips span em.BT-4 {background-color: rgb(243, 123, 83);}
</style>
<script>
	//var str="${records}";
	//str=str.replace(new RegExp("<br>", 'g'),"\\n\\r");
	function queryCourse() {
		var teacherName = $("#teacherName").val();
		var studentName = $("#studentName").val();
		var isTeacher = $("#isTeacher").val();
		var banci = $("#banci").val();
		$('#calendar').html("");
		$('#calendar').fullCalendar({
			editable : true,
			events : function(start, end, callback) {
				var startTime = $.fullCalendar.formatDate(start, "yyyy-MM-dd");
				var endTime = $.fullCalendar.formatDate(end, "yyyy-MM-dd");
				
				$.getJSON("/course/courseSortListForMonthGetJson", 
						{
							"flag":"1",
							"banciName" : banci,
							"studentName" : studentName,
							"teacherName" : teacherName,
							"startTime" : startTime,
							"myCourse" : true,
							"endTime" : endTime
						} , function(json){
							
							callback(json)
							
						});
				
			},
			//编辑
			eventClick : function(event, jsEvent, view) {
				if(event.plantype!=2){
					if('${operator_session.qx_knowledgeeducationalManage }'){
						window.location.href = "/knowledge/educationalManage?courseplanId=" + event.courseplanId;
					}
				}
			},
			eventAfterRender : function(event, element, view) {
				//循环添加每一个课程
				if (event.teacherPinglun.indexOf('y') >= 0) {
					if (event.signin == 1) {
						element.css("background-color", "#68A834");
						element.css("border-color", "#68A834"); //绿色
					} else {
						element.css("background-color", "#B68710");
						element.css("border-color", "#B68710"); //黄色
					}
				} else {
					if (event.signin == 1) {
						element.css("background-color", "#f37b53");
						element.css("border-color", "#f37b53"); // 黄色
					} else {
						element.css("background-color", "#d4606e");
						element.css("border-color", "#d4606e"); //红色
					}
				}
			},
			
			monthNames: ["${_res.get('system.monthNames.January')}", "${_res.get('system.monthNames.February')}", "${_res.get('system.monthNames.March')}", 
			             "${_res.get('system.monthNames.April')}", "${_res.get('system.monthNames.May')}", "${_res.get('system.monthNames.June')}", 
			             "${_res.get('system.monthNames.July')}", "${_res.get('system.monthNames.August')}", "${_res.get('system.monthNames.September')}", 
			             "${_res.get('system.monthNames.October')}", "${_res.get('system.monthNames.November')}", "${_res.get('system.monthNames.December')}"],  
			monthNamesShort: ["${_res.get('system.monthNamesShort.Jan')}", "${_res.get('system.monthNamesShort.Feb')}", "${_res.get('system.monthNamesShort.Mar')}", 
			                  "${_res.get('system.monthNamesShort.Apr')}", "${_res.get('system.monthNamesShort.May')}", "${_res.get('system.monthNamesShort.Jun')}", 
			                  "${_res.get('system.monthNamesShort.Jul')}", "${_res.get('system.monthNamesShort.Aug')}", "${_res.get('system.monthNamesShort.Sept')}", 
			                  "${_res.get('system.monthNamesShort.Oct')}", "${_res.get('system.monthNamesShort.Nov')}", "${_res.get('system.monthNamesShort.Dec')}"],  
			dayNames: ["${_res.get('system.Sunday')}", "${_res.get('system.Monday')}", "${_res.get('system.Tuesday')}", "${_res.get('system.Wednesday')}",
			           "${_res.get('system.Thursday')}", "${_res.get('system.Friday')}", "${_res.get('system.Saturday')}"],  
		    dayNamesShort: ["${_res.get('system.dayNamesShort.Sun')}", "${_res.get('system.dayNamesShort.Mon')}", "${_res.get('system.dayNamesShort.Tues')}", "${_res.get('system.dayNamesShort.Wed')}",
		                    "${_res.get('system.dayNamesShort.Thur')}", "${_res.get('system.dayNamesShort.Fri')}", "${_res.get('system.dayNamesShort.Sat')}"],  
		    today: ["今天"],  
            firstDay: 1,  
            buttonText: {  
              today: '${_res.get("course.currentMonth")}',  
              month: '月',  
              week: '周',  
              day: '日',  
              prev: '${_res.get("course.lastMonth")}',  
              next: '${_res.get("course.nextMonth")}'  
			},
			eventMouseover : function(event, jsEvent, view) {
				var massage = event.msg;
				var classId = event.classId;
				var stu = event.student;
				var net = event.netCourse;
				if(classId == 0){
					var str = "";
					if(massage!="暂无"){
						str += "备注:"+event.msg+"<br>";
					}
					if(net==1){
						str += " ${_res.get('course.netcourse')} ";
					}
					if(massage!="暂无" || net == 1 ){
						layer.tips(str, this, {
						    style: ['background-color:#78BA32; color:#fff', '#78BA32'],
						    maxWidth:185,
						    guide: 1,
						    time: 6,
						    closeBtn:[0, true]
						});
					}
				}else{
					var str = "";
					if(stu!="无"){
						str += "${_res.get('student')}:"+event.student+"<br>";
					}
					if(massage!="暂无"){
						str += "备注:"+event.msg+"<br>";
					}
					if(net==1){
						str += " ${_res.get('course.netcourse')} ";
					}
					if(stu!="无" || massage!="暂无" || net=="1"){
						layer.tips(str, this, {
						    style: ['background-color:#78BA32; color:#fff', '#78BA32'],
						    maxWidth:185,
						    guide: 1,
						    time: 6,
						    closeBtn:[0, true]
						});
					}
				}
			}
		});
	}
</script>
</head>
<body onload="queryCourse()">
	<div id="wrapper" style="background: #2f4050;min-width:1100px;">
	<%@ include file="/common/left-nav.jsp"%>
	  <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom" >
     <div>
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
     </div>
  </div>
  
 <div class="ibox float-e-margins margin-nav" style="margin-left:0;">
 <div class="ibox-title">
	<h5>
	   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
	   <a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a>
	   &gt;<a href='/course/courseSortListForMonth?loginId=${account_session.id}'>${_res.get("curriculum") }</a> &gt; ${_res.get("curriculum_arrangement") }
	</h5>
	<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
    <div style="clear:both"></div>
 </div> 
 <div class="ibox-content">
           <form method="post">
              <fieldset id="searchTable">
                <span class="m-r-sm text-muted welcome-message">
                   <label> ${_res.get("student.name") }：</label><input type="text" name="studentName" id="studentName" value="${studentName}"/>
                </span>
                <span class="m-r-sm text-muted welcome-message">
                   <label> ${_res.get("teacher") }：</label><input type="text" name="teacherName" id="teacherName" value="${teacherName}"/>
                </span>
                <span class="m-r-sm text-muted welcome-message">
                   <label> ${_res.get("classNum") }：</label><input type="text" name="banci" id="banci" value="${banci}"/>
                </span>
                <span class="m-r-sm welcome-message">
                  &nbsp;&nbsp;
                  <input type="button" onclick="queryCourse()" value="${_res.get('admin.common.select') }" class="btn btn-outline btn-primary">
                  &nbsp;&nbsp;<input type="reset" class="btn btn-outline btn-success"  value="${_res.get('admin.common.reset') }" onclick="clean()"/>
                </span>
              </fieldset>
           </form>
</div>
		
		<div class="col-lg-12" style="margin: 20px 0 0 0;padding:0;">
			<div class="ibox float-e-margins" style="min-width: 1000px;">
				<div class="ibox-title">
					<h5>${_res.get("course.list") }</h5>
					<div class="bgTips" style="margin-left:100px;">
							<span> <em class="BT-1"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.need.bothNotDone") }
							</span>
							<span> <em class="BT-2"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.need.evaluation") }
							</span>
							<span> <em class="BT-4"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.need.signin") }
							</span>
							<span> <em class="BT-3"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.need.allDone") }
							</span>
							<span> <em class="BT-1"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.need.haventPassed") }
							</span>
							<span> <em class="BT-3"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.need.havenPassed") }
							</span>
					</div>
				</div>
				<div class="ibox-content">
					<input type="hidden" id="biaoji" value="">
					<div id='calendar' class="fc fc-ltr"></div>
				</div>
			</div>
		</div>
		<div style="clear: both;"></div>
		</div>
	  </div>	
	</div>
	
<div id="tbox">
	<a id="gotop" href="javascript:void(0)"></a>
</div>
	    <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/teach-1.js"></script>
    <script>
    $('li[ID=nav-nav4]').removeAttr('').attr('class','active');
    //$(".left-nav").css("height", document.body.scrollHeight);
    //alert('总高度'+window.document.getElementById('right-nav').offsetHeight);alert('可见高度'+document.body.clientHeight );
    //alert('总高度'+$("#right-nav").outerHeight(true));
    </script>
</body>
</html>