<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">

    <link href='/fullcalendar/fullcalendar.css' rel='stylesheet'/>
    <link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet"/>
    <link type="text/css" href="/css/css/style.css" rel="stylesheet"/>
    <link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
    <link href="/css/css/animate.css" rel="stylesheet">
    <link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
    <link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
    <link href="/css/css/layer/need/laydate.css" rel="stylesheet">
    <!-- 回到顶部 -->
    <link type="text/css" href="/css/lrtk.css" rel="stylesheet"/>
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/js/js.js"></script>
    <!-- Morris -->
    <link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
    <!-- Gritter -->
    <link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
    <link href="/css/css/animate.css" rel="stylesheet">

    <script src='/js/js/jquery-2.1.1.min.js'></script>
    <script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
    <script src='/fullcalendar/fullcalendar.min.js'></script>
    <script src="/js/js/plugins/layer/layer.min.js"></script>
    <link rel="shortcut icon" href="/images/ico/favicon.ico"/>
    <title>${_res.get("courses.roadmap") }</title>
    <style type="text/css">
        .header {
            font-size: 12px
        }

        body {
            font-size: 12px;
            font-family: "Lucida Grande", Helvetica, Arial, Verdana, sans-serif
        }

        #calendar {
            width: 100%;
            margin: 0 auto
        }

        .student_list_wrap {
            position: absolute;
            top: 170px;
            left: 8em;
            width: 140px;
            overflow: hidden;
            z-index: 2012;
            background: #09f;
            border: 1px solide;
            border-color: #e2e2e2 #ccc #ccc #e2e2e2;
            padding: 6px
        }

        ul, li {
            list-style-type: none;
            margin: 0
        }

        .pk_info {
            width: 128px;
            float: left;
            height: 68px;
            padding: 0 4px
        }

        .fc-event {
            padding: 1px 0;
            margin-left: 2.5px
        }

        .fc-event-inner span {
            display: block;
            margin-left: 2px
        }

        .bgTips span {
            display: inline-block
        }

        .bgTips span em {
            display: inline-block;
            height: 12px;
            width: 12px;
            vertical-align: middle;
            border: 1px solid #fff;
            margin-right: 5px
        }

        .bgTips span em.BT-1 {
            background-color: #71b62d
        }

        .bgTips span em.BT-2 {
            background-color: #54a4ff
        }

        .bgTips span em.BT-3 {
            background-color: #c288f2
        }

        .bgTips span em.BT-4 {
            background-color: #e68a4e
        }

        .bgTips span em.BT-5 {
            background-color: #33c0aa
        }

        .chosen-container-single .chosen-single {
            border-radius: 0 !important;
            border: 1px solid #E5E6E7 !important
        }
    </style>
    <script>
        Date.prototype.Format = function (fmt) {
            var o = {
                "M+": this.getMonth() + 1, //月份
                "d+": this.getDate(), //日
                "h+": this.getHours(), //小时
                "m+": this.getMinutes(), //分
                "s+": this.getSeconds(), //秒
                "q+": Math.floor((this.getMonth() + 3) / 3), //季度
                "S": this.getMilliseconds() //毫秒
            };
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
                if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            return fmt;
        };


        $(document).ready(function () {
           calendarInit();
           teacherListInit();
        });
		//获取教师列表
        function teacherListInit(){
            var tchname = '${tchid}';
            $.ajax({
                url: "${cxt}/teacher/getAllTeachers",
                type: "post",
                dataType: "json",
                success: function (result) {
                    var str2 = "";
                    for (var i = 0; i < result.teacherlist.length; i++) {
                        var teacherId = result.teacherlist[i].ID;
                        var teacherName = result.teacherlist[i].REAL_NAME;
                        if (tchname == teacherName) {
                            str2 += "<option selected='selected' value='" + teacherName + "'>" + teacherName + "</option>";
                        } else {
                            str2 += "<option value='" + teacherName + "'>" + teacherName + "</option>";
                        }
                    }
                    $("#teacherName").append(str2);
                    $("#teacherName").trigger("chosen:updated");
                }
            });
        };
        //接收子页面参数
		   function retValue(param){
        		var i = param ;
        		if(i!=null&&i.length>0){
        			return true;
        		}else{
        			return false;
        		}
       	 };
        //初始化日历内容
        function calendarInit(){ 
            var tchid = $("#teacherid").val();
            var date1 = $("#startDate").val();
            var date2 = $("#endDate").val();
            var oDate1 = new Date();
            if (date1 != '' && date1 != null) {
                var str = date1.toString();
                str = str.replace(/-/g, "/");
                oDate1 = new Date(str);
            }
            var year = oDate1.getFullYear();
            var month = oDate1.getMonth();
            $('#calendar').fullCalendar({
                editable: true,
                year: year,
                month: month,
                allDayDefault: false,
                events: function (start, end, callback) {
                    var startTime = $.fullCalendar.formatDate(start, "yyyy-MM-dd");
                    var endTime = $.fullCalendar.formatDate(end, "yyyy-MM-dd");
                    if (date1 == '' || date1 == null) {
                        startTime = $.fullCalendar.formatDate(start, "yyyy-MM-dd");
                    } else {
                        startTime = date1;
                    }
                    if (date2 == '' || date2 == null) {
                        endTime = $.fullCalendar.formatDate(end, "yyyy-MM-dd");
                    } else {
                        endTime = date2;
                    }
                    $.ajax({
                        type: "post",
                        url: "/courseplan/findCourseScheduleList",
                        success: function (result) {
                            //str = result.replace(new RegExp("<br>", 'g'), "\\n\\r");
                           // callback(eval(str)); //填写信息
                        	callback(result);
                        },
                        data: {
                            "flag": "0",
                            "tchid": tchid,
                            "startDate": startTime,
                            "endDate": endTime,
                            "starthour": $("#starthour").val(),
                            "endhour": $("#endhour").val(),
                            "startmin": $("#startmin").val(),
                            "endmin": $("#endmin").val(),
                            "campusid": $("#campusid").val()
                        },
                        cache: false,
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                        }
                    });
                },
                eventMouseover: function (event) {
                    var massage = event.msg;
                    var classId = event.classId;
                    var stu = event.student;
                    var net = event.netCourse;

                    var strMsg = "";
                    if (event.plantype == 2) {//教师休息
                        strMsg = "${_reg.get('course.rest')}"
                        if (event.rechargecourse == 1)
                            strMsg = strMsg + "(${_reg.get('Complement.row')})";
                    } else {//课程
                        if ( event.ctname == null || event.ctname == "" ) {//一对一 （ctname版型名称）
                            strMsg += "${_res.get('one-on-one_tutoring')}<br>";
                        }
                        strMsg += "${_res.get('subject')}:" + event.couse_name +"<br>";
                        strMsg += "${_res.get('location')}:" + event.campus_name + "/" + event.name +"<br>";
                        strMsg += "${_res.get('date')}:" + event.kcrq +"<br>";
                        if ( event.ctname != "" && event.ctname != null ) {//班课
                            strMsg += "${_res.get('class.class.type')}:" + event.ctname +"<br>";
                        }
                        if (stu != "null") {
                            strMsg += "${_res.get('student')}:" + event.student + "<br>";
                        } else {
                            strMsg += "${_res.get('student')}:" + event.stuName + "<br>";
                        }
                        if (massage != "暂无") {
                            strMsg += "${_res.get('course.remarks')}:" + event.msg + "<br>";
                        }
                        if (net == 1) {
                            strMsg += " ${_res.get('course.netcourse')} ";
                        }
                    }
                    layer.tips(strMsg, this, {
                        style: ['background-color:#78BA32; color:#fff', '#78BA32'],
                        maxWidth: 185,
                        guide: 1,
                        time: 6,
                        closeBtn: [0, true]
                    });
                },
                eventDrop:  function( event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view ) { 
				 		var view = $('#calendar').fullCalendar('getView').name; 
	  			var index = $.layer({
							shade : [ 0 ], //不显示遮罩
							area : [ 'auto', 'auto' ],
							dialog : {
								msg : "确定要调整课程上课的日期吗",
								btns : 2,
								type : 4,
								 btn : ["确定","取消"],
								yes : function() {
									if(view=='agendaDay'){//日视图
										$.ajax({
				                            type: "post",
				                            url: "/courseplan/check", 
				                            data:{
				                            	"id" : event.cpid,
				                            	"minInterval" :minuteDelta,
				                            	"type" : event.plantype,
				                            },
				                            success : function (data){
				                            	if(data.code==1){
				                            		layer.msg(data.result,5,2);
				                            		revertFunc();
				                            	}else{
				                    				if(event.plantype=='2'){//教师休息
														$.layer({
															type : 2,
															shadeClose : true,
															maxmin : false,
															title : "请选择休息时间",
															shade : [ 0.8, '#000' ],
															area : [ '480px','500px'],
															 closeBtn: false,
															iframe : { src : '${cxt}/courseplan/adjustmentCourse?id=' +event.cpid+'&minInterval='+minuteDelta+'&type='+event.plantype+'&view='+view},
															end : function(){
																var value = $("#status").val(); 
																if(value=='1'){
																	revertFunc();
																}
															}
														});
													}else{//课程
														$.layer({
															type : 2,
															shadeClose : true,
															maxmin : false,
															title : "请选择需要调整的时段",
															shade : [ 0.8, '#000' ],
															area : [ '480px','500px'],
															 closeBtn: false,
															iframe : { src : '${cxt}/courseplan/adjustmentCourse?id=' +event.cpid+'&minInterval='+minuteDelta+'&type='+event.plantype+'&view='+view},
															end : function(){
																var value = $("#status").val(); 
																if(value=='1'){
																	 revertFunc();
																	 layer.close(index);
																	
																}
															}
														});
												} 
				                            	}
				                            },
				                            error : function (){
				                            	layer.msg(data.result,1,2);
				                            }
										})				                           
								}else{//月、周视图
											$.ajax({
					                            type: "post",
					                            url: "/courseplan/adjustmentCourse", 
					                            data:{
					                            	"id" : event.cpid,
					                            	"dateInterval" : dayDelta,//相差的天数
					                            	"minInterval" :minuteDelta,
					                            	"isAllDay":allDay,
					                            	"type" : event.plantype,
					                            	"view": view
					                            },
					                            success: function (data) {
					                            	if(data.code==1){//失败
					                            		revertFunc();
					                            		layer.msg(data.result.replace('{0}',data.date.replace(" 00:00:00","")).replace("{1}",data.teacher).replace("{2}",data.student).replace("{3}",data.ranktime));
					                            	}
					                            	if(data.code==2){//课程超期
					                            		layer.msg(data.result,6,2);
					                            		revertFunc();
					                            	}
					                            	if(data.code==0){//成功
					                            		layer.msg(data.result,2,1);
					                            	}
		                           				 } 
		                  	 				 })	
									}
								},
								no : function(){
									revertFunc();
								}
							}
						})
						
/* 							if(confirm("确定要调整课程上课的日期吗？")){
								if(view=='agendaDay'){//日视图
									if(event.plantype=='2'){//教师休息
										$.layer({
											type : 2,
											shadeClose : true,
											maxmin : false,
											title : "请选择休息时间",
											shade : [ 0.8, '#000' ],
											area : [ '480px','500px'],
											 closeBtn: false,
											iframe : { src : '${cxt}/courseplan/adjustmentCourse?id=' +event.cpid+'&minInterval='+minuteDelta+'&type='+event.plantype+'&view='+view},
											end : function(){
												var value = $("#status").val(); 
												if(value=='1'){
													revertFunc();
												}
											}
										});
									}else{//课程
										$.layer({
											type : 2,
											shadeClose : true,
											maxmin : false,
											title : "请选择需要调整的时段",
											shade : [ 0.8, '#000' ],
											area : [ '480px','500px'],
											 closeBtn: false,
											iframe : { src : '${cxt}/courseplan/adjustmentCourse?id=' +event.cpid+'&minInterval='+minuteDelta+'&type='+event.plantype+'&view='+view},
											end : function(){
												var value = $("#status").val(); 
												if(value=='1'){
													revertFunc();
												}
											}
										});
								} 
							}else{//月、周视图
										$.ajax({
				                            type: "post",
				                            url: "/courseplan/adjustmentCourse", 
				                            data:{
				                            	"id" : event.cpid,
				                            	"dateInterval" : dayDelta,//相差的天数
				                            	"minInterval" :minuteDelta,
				                            	"isAllDay":allDay,
				                            	"type" : event.plantype,
				                            	"view": view
				                            },
				                            success: function (data) {
				                            	if(data.code==1){//失败
				                            		revertFunc();
				                            		layer.msg(data.result.replace('{0}',data.date.replace(" 00:00:00","")).replace("{1}",data.teacher).replace("{2}",data.student).replace("{3}",data.ranktime));
				                            	}
				                            	if(data.code==0){//成功
				                            		layer.msg(data.result);
				                            	}
	                           				 } 
	                  	 				 })	
								}
						}else{
								revertFunc();
							} */
                	
                },
                eventAfterRender: function (event, element, view) {
                    if (event.plantype == 2) {
                        if (event.campustype == 1) {
                            if (event.netCourse == 1) {
                                element.css("background-color", "#54a4ff");
                                element.css("border-color", "#54a4ff");
                            } else if (event.classId > 0) {
                                element.css("background-color", "#c288f2");
                                element.css("border-color", "#c288f2");
                            } else {
                                element.css("background-color", "#e68a4e");
                                element.css("border-color", "#e68a4e");
                            }
                        } else {
                            element.css("background-color", "#33c0aa");
                            element.css("border-color", "#33c0aa");
                        }
                        element.css("background-color", "#71b62d");
                        element.css("border-color", "#71b62d");
                    } else {
                        if (event.campustype == 1) {
                            if (event.netCourse == 1) {
                                element.css("background-color", "#54a4ff");
                                element.css("border-color", "#54a4ff");
                            } else if (event.classId > 0) {
                                element.css("background-color", "#c288f2");
                                element.css("border-color", "#c288f2");
                            } else {
                                element.css("background-color", "#e68a4e");
                                element.css("border-color", "#e68a4e");
                            }
                        } else {
                            element.css("background-color", "#33c0aa");
                            element.css("border-color", "#33c0aa");
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
                //weekNumbers:true,
                //aspectRatio:10,
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,basicWeek,agendaDay'
                },
            });
        };

    </script>
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1250px;">
    <%@ include file="/common/left-nav.jsp" %>
    <div class="gray-bg dashbard-1" id="page-wrapper">
        <div class="row border-bottom">
            <nav class="navbar navbar-static-top fixtop" role="navigation">
                <%@ include file="/common/top-index.jsp" %>
            </nav>
        </div>

        <div class="ibox float-e-margins margin-nav" style="margin-left:0;">
            <div class="ibox-title">
                <h5>
                    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a
                        href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a>
                    &gt; ${_res.get("courses.roadmap") }
                </h5>
            </div>
            <div class="ibox-content">
                <form action="/courseplan/courseSchedule" method="post">
                    <fieldset id="searchTable">
                    	<input id="status" name = "status" type="hidden" value="${status}">
                        <c:if test="${account_session.user_type!=1}">
                        <span class="m-r-sm text-muted welcome-message">
                          <label>${_res.get("teacher") }：</label>
                          
                            <select name="teacherid" id="teacherid" class="chosen-select" style="width:120px;">
                                <option value="">${_res.get("system.alloptions") }</option>
                                <c:forEach items="${teacherList}" var="teacher">
                                	<option value="${teacher.id }" <c:if test="${teacher.id == tchid}" >selected="selected"</c:if> >${teacher.real_name }</option>
                                 </c:forEach>
                            </select>
                         
                        </span>
                        </c:if>
                        <span class="m-r-sm text-muted welcome-message">
                          <label>${_res.get("system.campus") }：</label>
                          <select id="campusid" name="campusid" class="chosen-select" style="width:150px;">
                            <option value="">${_res.get("system.alloptions")}</option>
                            <c:forEach items="${campusList}" var="campus">
                                <option value="${campus.Id }"
                                        <c:if test="${campus.Id == campusid }">selected="selected"</c:if> >${campus.CAMPUS_NAME }</option>
                            </c:forEach>
                          </select>
                        </span>
                        <div class="form-group" style="margin-top:15px;">
                            <div style="float: left;margin:6px 5px 0 0">
                                <label style="float: left;margin-top:0px">${_res.get("course.class.date") }：</label>
                                <div style="float: left">
                                    <input type="text" class="form-control layer-date date_double" readonly="readonly"
                                           id="startDate" name="startDate" value="${startDate}"
                                           style="background-color:#fff; width:150px;"/>
                                </div>
                                <div style="width:30px;height:30px;line-height:30px;text-align:center;background:#E5E6E7;float: left;margin-top:-7px">${_res.get('to')}</div>
                                <div style="float: left">
                                    <input type="text" readonly="readonly" class="form-control layer-date date_double"
                                           id="endDate" name="endDate" value="${endDate}"
                                           style="background-color:#fff; width:150px;"/>
                                </div>
                            </div>
                            <div class="m-r-sm text-muted welcome-message">
                                <label style="float: left;margin-top:6px">${_res.get("system.time") }：</label>
                                <div style="float: left">
                                    <select id="starthour" name="starthour" class="chosen-select" style="width:70px;">
                                        <c:forEach items="${hourList}" var="starthour">
                                            <option value="${starthour.key }"
                                                    <c:if test="${starthour.key eq starthours}">selected="selected"</c:if> >${starthour.value }</option>
                                        </c:forEach>
                                    </select>&nbsp;:&nbsp;
                                    <select id="startmin" name="startmin" class="chosen-select" style="width:70px;">
                                        <c:forEach items="${minuList}" var="startmin">
                                            <option value="${startmin.key }"
                                                    <c:if test="${startmin.key == startmins }">selected="selected"</c:if> >${startmin.value }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div style="width:30px;height:30px;line-height:30px;text-align:center;background:#E5E6E7;float: left;margin-top:0px">${_res.get('to')}</div>
                                <div style="float: left">
                                    <select id="endhour" name="endhour" class="chosen-select" style="width:70px;">
                                        <c:forEach items="${hourList}" var="endhour">
                                            <option value="${endhour.key }"
                                                    <c:if test="${endhour.key == endhours }">selected="selected"</c:if> >${endhour.value }</option>
                                        </c:forEach>
                                    </select>&nbsp;:&nbsp;
                                    <select id="endmin" name="endmin" class="chosen-select" style="width:70px;">
                                        <c:forEach items="${minuList}" var="endmin">
                                            <option value="${endmin.key }"
                                                    <c:if test="${endmin.key == endmins}">selected="selected"</c:if> >${endmin.value }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <span style="clear: both;"></span>
                        </div>
                <span class="m-r-sm welcome-message">
                  &nbsp;&nbsp;<input type="submit" value="${_res.get('admin.common.select') }"
                                     class="btn btn-outline btn-primary" style="margin-top:-2px"/>&nbsp;&nbsp;
                </span>
                    </fieldset>
                </form>
            </div>

            <div class="col-lg-12" style="margin:20px 0 0;padding:0">
                <div class="ibox float-e-margins" style="min-width:1000px;">
                    <div class="ibox-title">
                        <h5>${_res.get("course.list") }</h5>
                        <div class="bgTips" style="margin-left:100px;">
				<span> <em class="BT-1"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.rest") }
					</span>
				<span> <em class="BT-2"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.netcourse") }
					</span>
				<span> <em class="BT-4"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.course") }
					</span>
				<span> <em class="BT-3"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.classes") }
					</span>
				<span> <em class="BT-5"> &nbsp; </em> ${_res.get("course.indicates") }：${_res.get("course.outcourse") }
					</span>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div id='calendar' class="fc fc-ltr"></div>
                    </div>
                </div>
            </div>
            <div style="clear: both;"></div>
        </div>
    </div>
</div>
<div id="tbox" style="z-index: 9999;">
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
    $('li[ID=nav-nav4]').removeAttr('').attr('class', 'active');
</script>
<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
<script>
    //日期范围限制
    var startDate = {
        elem: '#startDate',
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: false,
        istoday: false,
    };
    var endDate= {
        elem: '#endDate',
        format: 'YYYY-MM-DD',
        max: '2099-06-16',
        istime: false,
        istoday: false,
    };
    laydate(startDate);
    laydate(endDate);
</script>
<!-- Chosen -->
<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
<script>
    $(".chosen-select").chosen({disable_search_threshold: 10});
    var config = {
        '.chosen-select': {},
        '.chosen-select-deselect': {
            allow_single_deselect: true
        },
        '.chosen-select-no-single': {
            disable_search_threshold: 10
        },
        '.chosen-select-no-results': {
            no_results_text: 'Oops, nothing found!'
        },
        '.chosen-select-width': {
            width: "95%"
        }
    }
    for (var selector in config) {
        $(selector).chosen(config[selector]);
    }
</script>
</body>
</html>