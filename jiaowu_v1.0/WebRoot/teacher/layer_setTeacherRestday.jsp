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

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet"/>
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet"/>
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet"/>
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet"/>
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet"/>
<link href="/css/css/animate.css" rel="stylesheet"/>

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 

</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<div class="gray-bg dashbard-1" id="page-wrapper" style="padding-left:0;padding-right:0;min-height:auto" >
       <form action="" method="post" id="searchForm">
       		<input type="hidden" id="oldid" name="teacherrest.id" value="${teacherrest.id }" >
       		<input type="hidden" id="tid" name="teacherrest.teacherid" value="${teacherid }" >
       		<div id="resthistory" <c:if test="${fn:length(restlist)==0 }">style="display:none;"</c:if> >
				<div  class="col-lg-12" style="padding-left:0;padding-right:0">
				  <div class="ibox float-e-margins">
				  	<div class="ibox-title">
						<h5>${tname }老师 休息日记录:</h5>
						<div id="addbutton"  style="disabled:disabled;float:right;height:auto;">
						<input type="button" value="${_res.get('teacher.group.add')}" onclick="addTeacherRestDay()" class="btn btn-outline btn-primary">
					</div>
					</div>
				  </div>
				</div>
       		</div>
       		
       		<div id="datashow" >
				<div  class="col-lg-12" style="padding-left:0;padding-right:0">
				  <div class="ibox float-e-margins">
				  	<div class="ibox-title">
						<h5>${teacherrest.tname }${_res.get('The.latest.plan.to.rest')}:</h5>
					</div>
					<div class="ibox-title" style="height:auto;">
						<c:if test="${teacherrest.Mon != '' }"><label>${_res.get('system.Monday')}：</label>&nbsp;${teacherrest.Mon eq '1'?_res.get('All.day.long'):teacherrest.Mon }<br></c:if>
						<c:if test="${teacherrest.Tues != '' }"><label>${_res.get('system.Tuesday')}：</label>&nbsp;${teacherrest.Tues eq '1'?_res.get('All.day.long'):teacherrest.Tues }<br></c:if>
						<c:if test="${teacherrest.Wed != '' }"><label>${_res.get('system.Wednesday')}：</label>&nbsp;${teacherrest.Wed eq '1'?_res.get('All.day.long'):teacherrest.Wed }<br></c:if>
						<c:if test="${teacherrest.Thur != '' }"><label>${_res.get('system.Thursday')}：</label>&nbsp;${teacherrest.Thur eq '1'?_res.get('All.day.long'):teacherrest.Thur }<br></c:if>
						<c:if test="${teacherrest.Fri != '' }"><label>${_res.get('system.Friday')}：</label>&nbsp;${teacherrest.Fri eq '1'?_res.get('All.day.long'):teacherrest.Fri }<br></c:if>
						<c:if test="${teacherrest.Sat != '' }"><label>${_res.get('system.Saturday')}：</label>&nbsp;${teacherrest.Sat eq '1'?_res.get('All.day.long'):teacherrest.Sat }<br></c:if>
						<c:if test="${teacherrest.Sun != '' }"><label>${_res.get('system.Sunday')}：</label>&nbsp;${teacherrest.Sun eq '1'?_res.get('All.day.long'):teacherrest.Sun }<br></c:if>
					</div>
					<div id="onbutton"  style="float:right;height:auto;padding-right:50px;">
						<input type="button" value="${_res.get('Modify')}" onclick="updateTeacherRestDay()" class="btn btn-outline btn-primary">
						<input type="button" value="${_res.get('Row.Hugh')}" onclick="arrangeTeacherRestDay()" class="btn btn-outline btn-primary">
					</div>
					<span id="msg"></span>
				  </div>
				</div>
       		</div>
       		
       		<div id="arrangerestday" style="disabled:disabled;" >
       			<div class="col-lg-12" style="padding-left:0;padding-right:0">
					<div class="ibox float-e-margins" style="height:auto;" >
						<div class="ibox-title">
							<h5>${tname }${_res.get('Row.Hugh')}:</h5>
						</div>
						<div class="ibox-content">
						<div class="form-group" style="margin-top:15px;">
							<label>${_res.get('course.class.date')}:</label>
								<input type="text" class="form-control layer-date date_double" readonly="readonly" id="date1" name="date1" value="${date1}" style="background-color:#fff; width:180px" />&nbsp;--&nbsp;
								<input type="text" readonly="readonly" class="form-control layer-date date_double" id="date2" name="date2" value="${date2}" style="background-color:#fff; width:180px" />
						</div>
						<div class="form-group" style="margin-top:15px;">
							<input type="button" value="${_res.get('Row.Hugh')}" onclick="arrangeRestday()"  class="btn btn-outline btn-info" />
						</div>
						
						</div>
					</div>
				</div>
       		</div>

			<div id="update"  style="disabled:disabled;" >
				<div class="col-lg-12" style="padding-left:0;padding-right:0">
					<div class="ibox float-e-margins" style="margin-bottom:0">
						<div class="ibox-title">
							<h5>${tname }${_res.get('Rest.day.changes')}:</h5>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Monday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_mon1" name="all_mon" value="1"  onclick="checkallday(this.value,'mon')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_mon2" name="all_mon" value="0" checked="checked" onclick="checkallday(this.value,'mon')"> ${_res.get('admin.common.no')}
									<span id="mon_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="monstarthour" name="monstarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="monstartmin" name="monstartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="monendhour" name="monendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }" >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="monendmin" name="monendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('mon')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="monDay"></span> 
									 <br><span id="mondaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Tuesday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_tues1" name="all_tues" value="1"  onclick="checkallday(this.value,'tues')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_tues2" name="all_tues" value="0" checked="checked" onclick="checkallday(this.value,'tues')"> ${_res.get('admin.common.no')}
									<span id="tues_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="tuesstarthour" name="tuesstarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="tuesstartmin" name="tuesstartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="tuesendhour" name="tuesendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }"  >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="tuesendmin" name="tuesendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('tues')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="tuesDay"></span> 
									 <br><span id="tuesdaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Wednesday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_wed1" name="all_wed" value="1"  onclick="checkallday(this.value,'wed')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_wed2" name="all_wed" value="0" checked="checked" onclick="checkallday(this.value,'wed')"> ${_res.get('admin.common.no')}
									<span id="wed_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="wedstarthour" name="wedstarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="wedstartmin" name="wedstartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="wedendhour" name="wedendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }"  >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="wedendmin" name="wedendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('wed')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="wedDay"></span> 
									 <br><span id="weddaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Thursday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_thur1" name="all_thur" value="1"  onclick="checkallday(this.value,'thur')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_thur2" name="all_thur" value="0" checked="checked" onclick="checkallday(this.value,'thur')"> ${_res.get('admin.common.no')}
									<span id="thur_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="thurstarthour" name="thurstarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="thurstartmin" name="thurstartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="thurendhour" name="thurendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }"  >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="thurendmin" name="thurendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('thur')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="thurDay"></span> 
									 <br><span id="thurdaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Friday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_fri1" name="all_fri" value="1"  onclick="checkallday(this.value,'fri')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_fri2" name="all_fri" value="0" checked="checked" onclick="checkallday(this.value,'fri')"> ${_res.get('admin.common.no')}
									<span id="fri_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="fristarthour" name="fristarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="fristartmin" name="fristartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="friendhour" name="friendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }"  >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="friendmin" name="friendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('fri')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="friDay"></span> 
									 <br><span id="fridaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Saturday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_sat1" name="all_sat" value="1"  onclick="checkallday(this.value,'sat')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_sat2" name="all_sat" value="0" checked="checked" onclick="checkallday(this.value,'sat')"> ${_res.get('admin.common.no')}
									<span id="sat_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="satstarthour" name="satstarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="satstartmin" name="satstartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="satendhour" name="satendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }"  >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="satendmin" name="satendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('sat')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="satDay"></span> 
									 <br><span id="satdaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content">
							<span class="m-r-sm text-muted welcome-message">
								<label>${_res.get('system.Sunday')}：</label>&nbsp;${_res.get('All.day.long')}
									<input type="radio" id="all_sun1" name="all_sun" value="1"  onclick="checkallday(this.value,'sun')"> ${_res.get('admin.common.yes')}
									<input type="radio" id="all_sun2" name="all_sun" value="0" checked="checked" onclick="checkallday(this.value,'sun')"> ${_res.get('admin.common.no')}
									<span id="sun_time" style="padding-left:50px;" >${_res.get('Please.select')}：
									<select id="sunstarthour" name="sunstarthour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="starthourlist">
											<option value="${starthourlist.key }" >${starthourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="sunstartmin" name="sunstartmin" class="chosen-select" style="width:50px;">
									 	<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>&nbsp;--&nbsp;
									<select id="sunendhour" name="sunendhour" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<c:forEach items="${hour}" var="endhourlist">
											<option value="${endhourlist.key }"  >${endhourlist.value }</option>
										</c:forEach>
									 </select>&nbsp;:&nbsp;
									 <select id="sunendmin" name="sunendmin" class="chosen-select" style="width:50px;">
										<option value=""></option>
										<option value="00">00</option>
										<option value="30">30</option>
									 </select>
									 <input type="button" class="button btn btn-outline btn-warning" value="${_res.get('Rule')}" onclick="addMonsTime('sun')" >
									 </span>
									 <br><label></label>${_res.get('The.selected.period.of.time')}：&nbsp;<span id="sunDay"></span> 
									 <br><span id="sundaydata"  style="display:none;" ></span>
							</span>
						</div>
						<div class="ibox-content" >
							<span class="m-r-sm text-muted welcome-message" >
							<%-- <c:if test="${code=='1' }">
								<input type="button" value="确认" onclick="submitupdateTeacherRestMsg()" class="btn btn-outline btn-primary">
							</c:if> --%>
							<%-- <c:if test="${code=='0' }"> --%>
								<input type="button"  value="${_res.get('admin.common.submit')}" onclick="submitTeacherRestMsg()" class="btn btn-outline btn-primary">
							<%-- </c:if> --%>
							</span>
						</div>
					</div>
				</div>
				<div style="clear:both;"></div>
				<div></div>
			</div>
			<div class="ibox-title"  style="height:auto;">
						<c:forEach items="${restlist }" var="list" >
							<label>${fn:substring(list.starttime,0,10)}${_res.get('to')}${fn:substring(list.endtime,0,10)}期间休息记录:</label><br>
							<c:if test="${list.Mon != '' }">
								<label>${_res.get('system.Monday')}：</label>&nbsp;${list.Mon eq '1'?_res.get('All.day.long'):list.Mon }<br>
							</c:if>
							<c:if test="${list.Tues != '' }"><label>${_res.get('system.Tuesday')}：</label>&nbsp;${list.Tues eq '1'?_res.get('All.day.long'):list.Tues }<br></c:if>
							<c:if test="${list.Wed != '' }"><label>${_res.get('system.Wednesday')}：</label>&nbsp;${list.Wed eq '1'?_res.get('All.day.long'):list.Wed }<br></c:if>
							<c:if test="${list.Thur != '' }"><label>${_res.get('system.Thursday')}：</label>&nbsp;${list.Thur eq '1'?_res.get('All.day.long'):list.Thur }<br></c:if>
							<c:if test="${list.Fri != '' }"><label>${_res.get('system.Friday')}：</label>&nbsp;${list.Fri eq '1'?_res.get('All.day.long'):list.Fri }<br></c:if>
							<c:if test="${list.Sat != '' }"><label>${_res.get('system.Saturday')}：</label>&nbsp;${list.Sat eq '1'?_res.get('All.day.long'):list.Sat }<br></c:if>
							<c:if test="${list.Sun != '' }"><label>${_res.get('system.Sunday')}：</label>&nbsp;${list.Sun eq '1'?_res.get('All.day.long'):list.Sun }<br></c:if>
						</c:forEach>
					</div>
		</form>
		</div>
	  </div>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script type="text/javascript">
    	$(function(){
    		if(${code==1}){
    			if(${teacherrest==null}){
	    			$("#datashow").hide();
    			}else{
	    			$("#datashow").show();
	    			$("#addbutton").hide();
    			}
    			$("#update").hide();
    			$("#arrangerestday").hide();
    		}else if(${code==0}){
    			$("#resthistory").hide();
    			$("#datashow").hide();
    			$("#update").show();
    			$("#arrangerestday").hide();
    		}
    	});
    	
    	function checkallday(id,day){
    		if(id==1){
    			$("#"+day+"Day").html("<span id='"+day+"allday' onclick='delTime(this)' >${_res.get('All.day.long')}</span>");
    			$("#"+day+"daydata").html("<span id='"+day+"allday'  >${_res.get('All.day.long')}</span>")
    			$("#"+day+"_time").hide();
    			$("#all_"+day+"1").attr("checked",true);
    		}else{
    			if($("#"+day+"Day").text()=="${_res.get('All.day.long')}"){
    				$("#"+day+"allday").remove();
    				$("#"+day+"allday").remove();
    			}
    			$("#"+day+"_time").show();
    			$("#all_"+day+"2").attr("checked",true);
    		}
    	}
    	function addMonsTime(day){
    		var shour = $("#"+day+"starthour").val();
    		var smin = $("#"+day+"startmin").val();
    		var ehour = $("#"+day+"endhour").val();
    		var emin = $("#"+day+"endmin").val();
    		if( ehour!="" && emin!=""&& parseInt(shour,10)<parseInt(ehour,10)||(parseInt(shour,10)==parseInt(ehour,10)&&parseInt(smin,10)<parseInt(emin,10))){
	    		var time = day+shour+smin+ehour+emin;
	    		var x = document.getElementsByName(""+time);
	    		if(x.length>=2){
	    			return false;
	    		}
	    		var str = "<span id='"+time+"' name='"+time+"' onclick='delTime(this)' ><span style='padding-left:5px;'>"+shour+":"+smin+"--"+ehour+":"+emin+"</span></span>&nbsp;";
	    		$("#"+day+"Day").append(str);
	    		var strdat = "<span id='"+time+"' name='"+time+"' >|<span style='padding-left:5px;'>"+shour+":"+smin+"--"+ehour+":"+emin+"</span></span>";
	    		$("#"+day+"daydata").append(strdat);
    		}else{
    			parent.layer.msg("请正确选择时间段",2,5);
    		} 
    	}
    	function delTime(obj){
    		obj.remove();
    		$("#"+obj.id).remove();
    	}
    	function arrangeTeacherRestDay(){
    		$("#update").hide();
    		$("#arrangerestday").show();
    	}
    	function addTeacherRestDay(){
    		$("#addbutton").hide();
    		$("#update").show();
    	}
    </script>
    <script src="/js/js/plugins/layer/laydate/laydate.js"></script>
    <script>
         //日期范围限制
        var date1 = {
            elem: '#date1',
            format: 'YYYY-MM-DD',
            max: '2099-06-16', //最大日期
            istime: false,
            istoday: false,
            choose: function (datas) {
                date2.min = datas; //开始日选好后，重置结束日的最小日期
                date2.start = datas //将结束日的初始值设定为开始日
            }
        };
        var date2 = {
            elem: '#date2',
            format: 'YYYY-MM-DD',
            max: '2099-06-16',
            istime: false,
            istoday: false,
            choose: function (datas) {
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
    <script type="text/javascript">
    
    function updateTeacherRestDay(){
		$("#update").show();
		$("#arrangerestday").hide();
	}
    
    var index = parent.layer.getFrameIndex(window.name);
    	function arrangeRestday(){
    		if(confirm("是否确认提交")){
    			$.ajax({
    				url:"${cxt}/teacher/submitTeacherRestArrange",
    				dataType:"json",
    				type:"post",
    				data:{
    					"restId":$("#oldid").val(),
    					"tid":$("#tid").val(),
    					"stime":$("#date1").val(),
    					"endtime":$("#date2").val()
    				},
    				success:function(data){
    					if(data.code=="1"){
    						setTimeout("parent.layer.close(index)", 50);
    					}else{
	    					parent.layer.msg(data.msg, 10, 5);
    					}
    				}
    				
    			});
    		}
    	}
    </script>
    
    <script type="text/javascript">
    var index = parent.layer.getFrameIndex(window.name);
    function submitTeacherRestMsg(){
	    if(confirm("是否确认提交")){
			$.ajax({
				url:"${cxt}/teacher/submitTeacherRestMsg",
				dataType:"json",
				type:"post",
				data:{
					"restId":$("#oldid").val(),
					"tid":$("#tid").val(),
					"monMsg":$("#mondaydata").text(),
					"tuesMsg":$("#tuesdaydata").text(),
					"wedMsg":$("#weddaydata").text(),
					"thurMsg":$("#thurdaydata").text(),
					"friMsg":$("#fridaydata").text(),
					"satMsg":$("#satdaydata").text(),
					"sunMsg":$("#sundaydata").text(),
					"updateadd":"add"
				},
				success:function(data){
					if(data.code=="1"){
						parent.theacherRestDay($("#tid").val());
						setTimeout("parent.layer.close(index)", 50);
					}else{
						parent.layer.msg(data.msg, 2, 5);
						parent.theacherRestDay($("#tid").val());
						setTimeout("parent.layer.close(index)", 50);
					}
				}
			});
		}
    }
    </script>
    
    
</body>
</html>