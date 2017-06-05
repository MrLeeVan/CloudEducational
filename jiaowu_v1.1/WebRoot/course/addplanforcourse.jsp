<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>
<script src="/js/js/plugins/layer/layer.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('According.to.the.course.arrangement')}</title>
<style type="text/css">
	.addcourse{
      background:#eff2f4;
      padding:3px;
      cursor: pointer;
      text-align:center
   }
   #coursedaylist{
      padding:5px;
      margin:5px 0;
      background:#d9edf7
   }
   #coursedaylists{
      padding:5px;
      margin:5px 0;
      background:#D28EFF
   }
   th,td{
      width:120px;
      padding:4px !important
   }
   .fontweig{
      weight:90%;
      font-weight: 100
   }
</style>
<script type="text/javascript">
$(function(){ 
	var planType = $("input:radio[name='coursePlan.plan_type']:checked").val();
	$("#planType").val(planType);
	$('#studentName').keyup(function(){
		$("#studentInfo").html("");
		$("#planType0").prop('checked','checked');
		$("#netCourse0").prop('checked','checked');
		$("#getcalendar").html("");
		var class_type = $("input:radio[name='banjiType']:checked").val();
		var studentName = $("#studentName").val().trim();
		if (studentName != "") {
			if(class_type == 1){ // 如果选择了一对一则搜索学生姓名
				var studentName=$("#studentName").val();
					$.ajax({
						url :  "${cxt}/account/getAccountByNameLike",
						data :"studentName="+studentName,
						type : "post",
						dataType : "json",
						success : function(result) {
							if(result.accounts!=null){
								if(result.accounts.length==0){
									$("#studentName").focus();
									$("#studentInfo").text("学生不存在！");
									return false;
								}else{
									var str="";
									for(var i=0;i<result.accounts.length;i++){
										var studentId = result.accounts[i].ID;
										var realName = result.accounts[i].REAL_NAME;
										if(studentName==realName){
											$("#studentId").val(studentId);
											$("#mohulist").hide();
											dianstu(studentId);
											return;
										}else{
											str += "<li onclick='dianstu(" + studentId + ")'>" + realName + "</li>";
										}
									}
									$("#stuList").html(str);
									$("#mohulist").show();
								}
							}else{
								$("#stuList").html("");
								$("#mohulist").hide();
								$("#studentName").focus();
								$("#studentInfo").text("学生不存在！");
							}
							
						}
					});
			}else{
				$.ajax({
					url :  "/account/getAccountByClassLike",
				   	data :"class_id="+studentName,
				   	type : "post",
				   	dataType : "json",
				   	success : function(data) {
				   		if(data.classes!=null){
				   			if(data.classes.length==0){
				   				$("#studentName").focus();
								$("#studentInfo").text("班次不存在！");
				   			}else{
				   				var str="";
				   				for(var i=0;i<data.classes.length;i++){
				   					var banciid = data.classes[i].BANCI_ID;
									var classnum = data.classes[i].CLASSNUM;
									if(studentName==classnum){
										$("#studentId").val(studentId);
										$("#mohulist").hide
										dianclass(banciid,data.classes[i].ID);
										return;
				   					}else{
				   					   str+="<li onclick='dianclass("+banciid+","+data.classes[i].ID+")'>"+data.classes[i].CLASSNUM + "<br>" + data.classes[i].NAME +"</li>";
				   					}
				   				}
				   				$("#stuList").html(str);
				   				$("#mohulist").show();
				   				$("#studentInfo").text("");
				   			}
				   		}else{
				   			$("#studentName").focus();
							$("#studentInfo").text("班次不存在！");
				   		}
					},
				   	error:function(result){
				   		alert("页面已超时或发生了错误，请刷新页面重试!");
					}
				});
		    }
		}else{
			$("#studentInfo").text("");
			$("#studentId").val("");
			$("#studentName").val("");
			$("#stuList").html("");
			$("#mohulist").hide();
		}
	});	
});

function findAccountByName(){
	$("#courseId").val("");
	$("#teacherId").val("");
	$("#getcalendar").html("");
	var studentName=$("#studentName").val();
	var class_type = $("input:radio[name='banjiType']:checked").val();
	if(studentName=="" && class_type == 1){
		alert("请输入姓名。");
	}else if(studentName=="" && class_type == 2){
		alert("请输入班次编号。");
	}else if(class_type == 1){ // 一对一查询
		$.ajax({
			url :  "${cxt}/account/getAccountByNameLike",
			data :"studentName="+studentName,
			type : "post",
			dataType : "json",
			success : function(result) {
				if(result.accounts!=null){
					if(result.accounts.length==0){
						alert("查询的学员不存在");
						$("#studentName").val("");
						return false;
					}
					if(result.accounts.length==1){
						dianstu(result.accounts[0].ID);
					}else{
						var str="";
						for(var i=0;i<result.accounts.length;i++){
							str+="<li onclick='dianstu("+result.accounts[i].ID+")'>"+result.accounts[i].REAL_NAME+"</li>";
						}
						$("#stuList").html(str);
						$("#mohulist").show();
					}
				}else{
					alert("此学员不存在");
				}
			},
			error:function(result){
				alert("页面已超时或发生了错误，请刷新页面重试!");
			}
		});
	}else{ // 小班查询
		$.ajax({
			url :  "/account/getAccountByClassLike",
			data :"class_id="+studentName,
			type : "post",
			dataType : "json",
			success : function(data) {
				if(data.classes!=null){
					if(data.classes.length==0){
						alert("查询的班次尚未关联学生。");
						$("#studentName").val("");
						return false;
					}
					if(data.classes.length==1){
						dianclass(data.classes[0].BANCI_ID,data.classes[i].ID);
					}else{
						var str="";
						for(var i=0;i<data.classes.length;i++){
							str+="<li onclick='dianclass("+data.classes[i].BANCI_ID+","+data.classes[i].ID+")'>"+data.classes[i].CLASSNUM + "  " + data.classes[i].NAME +"</li>";
						}
						$("#stuList").html(str);
						$("#mohulist").show();
					}
				}else{
					alert("班次不存在.");
				}
			},
			error:function(result){
				alert("页面已超时或发生了错误，请刷新页面重试!");
			}
		});
	}
}

function dianclass(classId,stuId){
	$("#planType0").click();
	$("#mohulist").hide();
	$("#mohulist").html();
	$.ajax({
		url :  "/course/getClassInfo",
		data :{
			"classId" : classId,
			"studentId" : stuId
		},
		type : "post",
		dataType : "json",
		success : function(result) {
			if(result.account!="noResult"){
				$("#studentId").val(result.account.studentId);
				$("#banci_id").val(classId);
				$("#courseUseNum").val(result.account.courseUseNum);
				$("#studentName").val(result.account.stuName);
				$("#studentInfo").html(result.account.stuMsg);
				$("#sumCourse").val(result.account.sumCourse);
				$("#useCourse").val(result.account.useCourse);
			}else{
				alert("班次不存在");
			}
		},
		error:function(result){
			alert("ERROR! 请重新登录或刷新页面重试！");
		}
	});
}

function dianstu(stuId){
	$("#planType0").click();
	$("#mohulist").hide();
	$("#mohulist").html();
	$.ajax({
		url :  "/student/queryCourseInfo",
		data :"studentId="+stuId,
		type : "post",
		dataType : "json",
		success : function(result) {
			if(result.account!="noResult"){
				$("#studentId").val(result.account.studentId);
				$("#courseUseNum").val(result.account.courseUseNum);
				$("#studentName").val(result.account.stuName);
				$("#studentInfo").html(result.account.stuMsg);
				$("#sumCourse").val(result.account.sumCourse);
				$("#useCourse").val(result.account.useCourse);
			}else{
				alert("此学员不存在");
			}
		},
		error:function(result){
			alert("ERROR! 请重新登录或刷新页面重试！");
		}
	});
}

/**
 *  20150814没有开放模考
 */
function changePlanType(data){
	$("#netCourse0").prop('checked','checked');
	$("#getcalendar").html("");
	var teach_type = $("input:radio[name='banjiType']:checked").val();
	$("#planType").val(data);
	if(data==0) {
		findAccountByName(); 
		$('#kechengAndKemu').html("${_res.get('course.course')}:");
	} else{	
		$("#getcalendar").html('');
		$('#kechengAndKemu').html("${_res.get('course.subject')}：");
	}
	
}

function campusChange(campusId){
	$("#getcalendar").html("");
	$("#campusId").val(campusId);
}

function getCalender(){
	var class_type = $("input:radio[name='banjiType']:checked").val();//授课类型1：一对一,2:小班
	var course_type = $("input:radio[name='coursePlan.plan_type']:checked").val();//1:模考 0:课程
	var stuId = $("#studentId").val();//学生id（包括虚拟人Id）
	var banciId = $("#banci_id").val();//班次id
	var campus = $("#campusId").val();//校区
	if(stuId==""){
		if(class_type == 1){
			alert("请先填写学生！");
		}else if(class_type == 2){
			alert("请先填写班次！");
		}
		return false;
	}
	if(campus=='' ){
		alert("请选择校区！");
		return false;
	}
	$.ajax({
		url : '/course/getCourseCalender',
		data : {
			'stuId' : stuId,
			'banciId' : banciId,
			'startDay' : $('#date1').val(),
			'endDay' : $('#date2').val(),
			'type' : class_type,
			'coursetype' : course_type
		},
		type:'post',
		dataType:'json',
		success:function(date){
			if(date.result=="0"){
				layer.msg("获取课程失败.",2,5);
			}
			if(date.result=="1"){
				$("#stuLeavesmsg").html("");
				var stuLeaves = date.stuLeaves;
				if(stuLeaves.length >0 ){
					var stuLeavesmsghtml = "学生请假时间: <br>";
					for ( var stuLeaveK in stuLeaves) {
						stuLeavesmsghtml = stuLeavesmsghtml + 
						stuLeaves[stuLeaveK].STARTTIME + " 到 " + stuLeaves[stuLeaveK].ENDTIME + "<br>";
					}
					$("#stuLeavesmsg").html(stuLeavesmsghtml);
				}
				
				var str = "";
				var sdate = date.dayLists[0];
				var edate = date.dayLists[date.dayLists.length-1];
				str +="<table  class='table-bordered'><thead>"+
					"<tr style='font-size:14px;'>"+
					"<th  style='background-color: #28bb9d;color:#fff; border-bottom: 1px solid #AAA; font-weight: bold; border: solid 2px #fff; width: 80px;height:30px;' align='center'>${_res.get('Cycle')}</th>"+	
					"<th colspan='"+date.dayLists.length+"' style='background-color: #28bb9d;color:#fff; border-bottom: 1px solid #AAA; font-weight: bold;height:30px; border: solid 2px #fff;' align='center'>"+sdate+"  ▬▬  "+edate+"</th>"+
					"</tr>"+
					"<tr>"+
						"<th style='background-color: #a8d894;color:#3c763d; border-bottom: 1px solid #AAA; font-weight: bold; border: solid 2px #fff; width: 80px;height:30px;' align='center'>${_res.get('course.course')}</th>";	
						for(var i=0;i<date.dayLists.length;i++){
							str += "<th style='background-color: #A8D894;color:#3c763d; border-bottom: 1px solid #AAA; font-weight: bold; border: solid 2px #fff; width: 150px;height:30px;' align='center'>"+ date.dayLists[i].substring(5,10).replace(/-/g,"/") +"("+date.dayweek[date.dayLists[i]]+")</th>";				
						}
						
				str +=	"</tr></thead><tbody>";
				
				for(var k in date.courseMap){
					str += "<tr> <th style='height: 70px; width: 80px;background-color:#A8D894;color:#3c763d;border: solid 1px #fff;text-align: center;'>"
					+date.courseMap[k][k]+"</th>";
					for(var j=0;j<date.dayLists.length;j++){
						str += "<td id=\""+k+"_"+date.dayLists[j]+"\" >";
						 for(var dl=0;dl<date.courseMap[k][date.dayLists[j]].length;dl++){
							/* 	 if(checkString( date.courseMap[k][date.dayLists[j]][dl].CLASSNUM))
					      	    	str += "<div id='coursedaylists' style='color :#FFFFFF' class='courseplan_'" ;
					      	    else
					      	    	str += "<div id='coursedaylist'  class='courseplan_'"	 ;
					      	    str+=date.courseMap[k][date.dayLists[j]][dl].CPID+"'><label class='fontweig'>"
				      	    	+date.courseMap[k][date.dayLists[j]][dl].RANK_NAME+"</label><span class='delcol' style='color :#FF0000'  onclick='delCoursePlan("
				      	    			+date.courseMap[k][date.dayLists[j]][dl].CPID+",\""
				      	    			+date.courseMap[k][date.dayLists[j]][dl].COURSE_TIME+"\");'>X</span><br>";
			      	    		if(checkString(date.courseMap[k][date.dayLists[j]][dl].CLASSNUM)){
			      	    				str += "<label class='fontweig'>"+date.courseMap[k][date.dayLists[j]][dl].CLASSNUM+"</label><br>" 
			      	    			} */
			      	    			if(checkString( date.courseMap[k][date.dayLists[j]][dl].CLASSNUM)){
			      	    				str += "<div id='coursedaylists' style='color :#FFFFFF' class='courseplan_" 
			      	    				 +date.courseMap[k][date.dayLists[j]][dl].CPID+"'><label class='fontweig'>"
			      	    				+date.courseMap[k][date.dayLists[j]][dl].RANK_NAME+"</label>"
			      	    				+"<span class='delcol' style='color :#FF0000'  onclick='deleteInXbCoursePlan("
			      	    				+date.courseMap[k][date.dayLists[j]][dl].CPID+"\);'>X</span><br>";
			      	    				str += "<label class='fontweig'>"+date.courseMap[k][date.dayLists[j]][dl].CLASSNUM+"</label><br>" ;
			      	    			}else{
			      	    				str += "<div id='coursedaylist'  class='courseplan_"	
			      	    				 	+date.courseMap[k][date.dayLists[j]][dl].CPID+"'><label class='fontweig'>"
							      	    	+date.courseMap[k][date.dayLists[j]][dl].RANK_NAME+"</label>"
							      	    	+"<span class='delcol' style='color :#FF0000'  onclick='delCoursePlan("
							      	    	+date.courseMap[k][date.dayLists[j]][dl].CPID+",\""
							      	    	+date.courseMap[k][date.dayLists[j]][dl].COURSE_TIME+"\");'>X</span><br>";
			      	    			}
			      	    	str += "<label class='fontweig'>"+ date.courseMap[k][date.dayLists[j]][dl].TCHNAME + "</label><br>"
		      	    			+  "<label class='fontweig'>"+ date.courseMap[k][date.dayLists[j]][dl].CAMPUS_NAME + "--"+date.courseMap[k][date.dayLists[j]][dl].ROOMNAME +"</label>"
		      	    			+  (date.courseMap[k][date.dayLists[j]][dl].CONFIRM == 0 ? " <label class='fontweig'>学生待确认</label>" : "")
	      	    				+ "</div>";
						 }
						str += "<div class='addcourse'  title='"+date.courseMap[k][k]+"-"+date.dayLists[j]+"' onclick='addcourse("+k+",\""+date.dayLists[j]+"\")'>+${_res.get('teacher.group.add')}</div></td>";
						
					} 
					str += "</tr>";
				}
				str += "</tbody></table>";
				
				str +="<p><font color=\"red\" size=\"2\" >如需给未出现在该列表下的课程添加排课,请先确保在学生列表下操作该学生的课程中关联上需要添加排课的课程</font></p>";
			}
			
			$("#getcalendar").html(str);
		}
	});
}

function checkString(checkStr){
	if(checkStr ==""||checkStr==null||checkStr=="undefined"){
		return false ; 
	}else{
		return  true;
	}
	
}
 function addcourse(courseid,daytime){
	//在这里判断是否排完课，排完课程弹出提示不可以再添加课程了；未排完课程就不弹出；
	var plantype = $("input:radio[name='coursePlan.plan_type']:checked").val();
	var studentId = $("#studentId").val();
	var campusid = $("#campusId").val();
	$.ajax({
		url : "/orders/checkEnoughCoursehours",
		data :{"studentId":studentId,"plantype":plantype,"courseId":courseid},
		type : "post",
		dataType : "json",
		success : function(data) {
			if(data.code=="0" ){//课时够用
				 $.layer({
			        type: 2,
			        shadeClose: true,
				    title: "${_res.get('add_courses')}",
				    closeBtn: [0, true],
				    shade: [0.5, '#000'],
				    border: [0],
			        area: ['650px', '600px'],
			        iframe: {src: '/course/toArrangeCoursePlan?courseid='+courseid+"&daytime="+daytime+"&stuid="+studentId+"&campusid="+campusid}
				 });
			}else{
				layer.msg(data.msg,2,5);
			}
		},
		error:function(result){
			alert("ERROR! 请重新登录或刷新页面重试！");
		}
	});
	 
 }
 
 
 
function delCoursePlan(planId,deltime){
	var reason = "";
	if(confirm("确定要删除小班课程？")){
		var deltime = deltime.replace(new RegExp("-", "g"),"");
		var nd = new Date();
		var today = nd.getFullYear()+(nd.getMonth()+1 <10?"0"+(nd.getMonth()+1):nd.getMonth()+1)+nd.getDate();
		if(today<deltime){
			$.ajax({
				async:false,
				cache : true,
				type : 'post',
				dataType : 'json',
				url : '/course/delCoursePlan',
				data : { "planId" : planId, "delmsg" : "delete" },
				success :function(data) {
					if(data.code=="1"){
						getStudentInfo();
						var classstr = "courseplan_"+data.plan.ID;
						$("."+classstr).empty();
						layer.msg(data.msg, 1,1);
					}else if(data.code=="0"){
						layer.msg(data.msg,2,2);
					}
				},
				error :function(data){
					layer.msg("网络异常!",2,5);
				}
			});
		}else{
			var index = layer.prompt({title: '填写删除原因',type: 3}, function(val){
			    reason = val;
			    $.ajax({
					async:false,
					cache : true,
					type : 'post',
					dataType : 'json',
					url : '/course/delCoursePlan',
					data : { "planId" : planId, "delmsg" : reason },
					success :function(data) {
						if(data.code=="1"){
							getStudentInfo();
							var classstr = "courseplan_"+data.plan.ID;
							$("."+classstr).empty();
							layer.msg(data.msg, 3,1);
						}else if(data.code=="0"){
							layer.msg(data.msg,1,2);
						}else if(data.code=="2"){
							layer.msg(data.msg,3,2);
						}
					},
					error :function(data){
						layer.msg("网络异常!",2,5);
					}
				});
			    layer.close(index);
			});
		}
			
	}
}

/**
 * 删除小班中学生的课程
 */
function deleteInXbCoursePlan(courseplanid){
	if(confirm("确定删除小班课程？")){
			$.ajax({
				async:false,
				cache : true,
				type : 'post',
				dataType : 'json',
				url : "/course/delInXbCoursePlan",
				data : { "courseplanid" : courseplanid, "delmsg" : "delete" },
				success :function(data) {
					if(data.code=="1"){//删除成功
						var classstr = "courseplan_"+data.planId ;
						$("."+classstr).remove();
						layer.msg(data.msg, 1,1);
						
					}else if(data.code=="0"){//删除失败
						layer.msg(data.msg,2,2);
					}
				},
				error :function(data){
					layer.msg("网络异常!",2,5);
				}
			});
	}
}

function getClassInfo(){
	var classId = $("#banci_id").val();
	$.ajax({
		url : "/course/getClassInfo",
		data : {
			"classId" : classId,
			"studentId" : $("#studentId").val()
		} ,
		type : "post",
		dataType : "json",
		success : function(result){
			$("#studentInfo").html(result.account.stuMsg);
			$("#useCourse").val(result.account.useCourse);
		},
		error : function(result){
			alert("ERROR!");
		}
		
	});
}

function getStudentInfo(){
	var stuId = $("#studentId").val();
	$.ajax({
		url :  "/student/queryCourseInfo",
		data :"studentId="+stuId,
		type : "post",
		dataType : "json",
		success : function(result) {
			$("#studentInfo").html(result.account.stuMsg);
			$("#useCourse").val(result.account.useCourse);
		},
		error:function(result){
			alert("ERROR! 请重新登录或刷新页面重试！");
		}
	});
}

</script>
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
	top: 35px;
	left: 8.5em;
	width: 199px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px
}
label {
	width: 100px;
}

.tds{
	text-align : left;
}
#getcalendar{
    max-width:1020px;
}

/* For appearance */
 .sticky-wrap {overflow-x: auto;overflow-y: auto;max-height:500px;position: relative;width: 1030px}
 .sticky-wrap .sticky-thead,.sticky-wrap .sticky-col,.sticky-wrap .sticky-intersect {opacity: 0;position: absolute;top: 0;left: 0;transition: all .125s ease-in-out;z-index: 50;width: auto}
 .sticky-wrap .sticky-thead {box-shadow: 0 0.25em 0.1em -0.1em rgba(0,0,0,.125);z-index: 100;width: 100%}
 .sticky-wrap .sticky-intersect {opacity: 1;z-index: 150}
 .sticky-wrap .sticky-intersect th {background-color: #666;color: #eee}
 .sticky-wrap td,.sticky-wrap th {box-sizing: border-box}
/* Not needed for sticky header/column functionality */
 td.user-name {text-transform: capitalize}
 .sticky-wrap.overflow-y {overflow-y: auto;max-height: 50vh}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;height:100%;">
	    <%@ include file="/common/left-nav.jsp"%>
	    <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
			  <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>

		 <div class="margin-nav" style="min-width:720px;width:100%;margin-left:0;">
		<div class="col-lg-12" style="margin-left:-15px;">
			<div class="ibox float-e-margins">
			    <div class="ibox-title" style="margin-bottom:20px">
					<h5>
					    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
					    <a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
					    &gt;<a href='/course/queryAllcoursePlans?loginId=${account_session.columns.id}&returnType=1'>
					    ${_res.get('admin.common.mainPage')}</a> &gt; ${_res.get('According.to.the.course.arrangement')}
					</h5>
					<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          			<div style="clear:both"></div>
				</div>
				<div class="ibox-title">
					<h5>${_res.get('According.to.the.course.arrangement')}</h5>
				</div>
				<div class="ibox-content">
					<form action="" method="post" id="coursePlan">
						<fieldset style="width: 100%;">
							<input type="hidden" name="coursePlan.student_id" id="studentId" />
							<input type="hidden" name="banci_id" id="banci_id" /> 
							<input type="hidden" name="goon" id="goon" value="0" /> 
							<input type="hidden" name="course_usenum" id="courseUseNum" value="0" />
							<input type="hidden" name="dayTime" id="dayTime" />
							<input type="hidden" name="rankTime" id="rankTime" />
							<input type="hidden" name="rankName" id="rankName" />
							<input type="hidden" name="campusId" id="campusId" />
							<input type="hidden" name="planType" id="planType" />
							<input type="hidden" name="sumCourse" id="sumCourse" />
							<input type="hidden" name="useCourse" id="useCourse" />
							<input type="hidden" name="subjectid" id="subjectid" > 
							<p>
								<label>${_res.get('type.of.class')}：</label> 
								<input type="radio" name="banjiType" id="banjiType1" value="1" checked="checked">${_res.get('IEP')}
								<input type="radio" name="banjiType" id="banjiType2" value="2" <c:if test='${banjiType eq 2 }'> checked='checked'</c:if>>${_res.get('course.classes')}
							</p>
							<div class="stu_name" id="stu_name">
								<label>
								<span id="stuOrBanci"> 
									<c:choose>
										<c:when test="${banjiType eq 2 }">${_res.get('Shift.coding')}:</c:when>
										<c:otherwise>${_res.get('student.name')}：</c:otherwise>
									</c:choose> 
								</span>
								</label>
								<input type="text" id="studentName" name="studentName" value="${studentName }" />
								<div id="mohulist" class="student_list_wrap" style="display: none">
									<ul style="margin-bottom: 10px;" id="stuList"></ul>
								</div>
								<a href="#" class="dengemail" onclick="findAccountByName()" style="padding: 8px;">${_res.get('Searching')}</a>
								<div style="margin:10px 0 0 100px;"><span id="studentInfo"></span></div>
							</div>
							<p>
								<label>${_res.get('Arranging.type')}：</label> 
								<input id="planType0" name="coursePlan.plan_type" value="0" type="radio" checked="checked" onchange="changePlanType(this.value)">${_res.get('course.course')}&nbsp; 
								<!-- <input id="planType1" name="coursePlan.plan_type" value="1" type="radio"  onchange="changePlanType(this.value)">模考 -->
							</p>
							<p>
								<label>${_res.get('course.netcourse')}：</label> 
								<input id="netCourse0" name="netCourse" value="0" type="radio" checked="checked" >${_res.get('admin.common.no') }&nbsp; 
								<input id="netCourse1" name="netCourse" value="1" type="radio" >${_res.get('admin.common.yes') }
							</p>
							<p>
								<label>${_res.get('system.campus')}：</label> 
								<select id="campus" class="form-control" style="display:inline;width: 150px;" name="coursePlan.campus_id" onchange="campusChange(this.value)">
									<option value="" >${_res.get('Please.select')}</option>
									<c:forEach items="${campus}" var="campus_option">
										<option value="${campus_option.id}">${campus_option.CAMPUS_NAME}</option>
									</c:forEach>
								</select>
							</p>
							<div class="form-group" style="margin-top: 15px;">
								<p>
									<label>${_res.get('Arranging.the.date')}：</label> 
									<input type="text" class="form-control layer-date" readonly="readonly" id="date1" name="date1" value="${date1}" style="margin-top: -8px; width:114px; background-color: #fff;" /> -- 
									<input type="text" class="form-control layer-date" readonly="readonly" id="date2" name="date2" value="${date2}" style="margin-top: -8px; width:114px; background-color: #fff;" /> 
									<c:if test="${operator_session.qx_coursegetCalender }">
									<a href="#" id="search" class="dengemail" onclick="getCalender()" style="padding: 8px;">${_res.get('admin.common.determine')}</a>
									</c:if>
									<label> ${_res.get('View.Teacher.Timetable')}： </label> 
										<select id="teacherids" name="teacherids" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple style="width: 300px;" tabindex="4">
											<c:forEach items="${teacherList}" var="teacher">
												<option value="${teacher.Id}" class="options" id="tid_${teacher.Id }">${teacher.REAL_NAME}</option>
											</c:forEach>
										</select> 
									<input id="tids" name="allteacherids" value="" type="hidden">&nbsp;&nbsp;
									<input type="button" value="${_res.get('admin.common.see')}" onclick="Form()"  class="btn btn-outline btn-info">
								</p>
							</div>
							<h2 id="stuLeavesmsg"></h2>
							<div id="getcalendar" class="component"></div>
							 
						</fieldset>
					</form>
					<div class="teacherTimeRankWrap" style="display: none" id="piaoo">
						<h1 onclick="closepiao();">
							<span id="timeRankCloseBtn" title="关闭">X</span><label> id="teacherNamePiao"></label>
						</h1>
						<div id="teacherTimeRank"></div>
					</div>
				</div>
			</div>
		</div>
		</div>
 		</div>
	</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script type="text/javascript" src="/js/table/jquery.ba-throttle-debounce.min.js"></script>
	<script type="text/javascript" src="/js/table/jquery.stickyheader.js"></script>
	<script>
	$(".chosen-select").chosen({disable_search_threshold:30});
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

	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
	<script>
         //日期范围限制
        var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				str = datas.replace(/-/g,"/");
				var date = new Date(str);
				var date2 = new Date(laydate.now());
				var day = ((date-date2)/(1000 * 60 * 60)+8)/24 ;
				var betweenday = day + 6;
				$("#date2").val(laydate.now(+betweenday));
				var dat = laydate.now(+betweenday);
				date2.min = dat; 
				var maxday = day +9;
				date2.max = laydate.now(+maxday);
				getCalender();
			}
		};
		var date2 = {
			elem : '#date2',
			format : 'YYYY-MM-DD',
			istime : true,
			istoday : false,
			choose : function(datas) {
				date1.max = datas; //结束日选好后，重置开始日的最大日期
			}
		};
		laydate(date1);
		laydate(date2);
		$("#date2").val(laydate.now(+6));
        
        $(function(){ // 班级类型切换
        	$(":input[name='banjiType']").click(function(){
        		$("#planType").val("");
        		$("#studentId").val("");
       			$("#studentName").val("");
        		$("#studentInfo").html("");
       			$("#planType0").prop('checked','checked');
       			$("#netCourse0").prop('checked','checked');
        		$("#getcalendar").html("");
        		$("#banci_id").val("");
        		$("#courseUserNum").val("");
        		$("#courseId").val("");
        		$("#sumCourse").val("");
        		if($(this).val() == 1){
        			$('#stuOrBanci').html("${_res.get('student.name')}:");
        			$("#banjiType1").attr('checked','checked');
        		}else{
        			$('#stuOrBanci').html("${_res.get('Shift.coding')}:");
        			$("#banjiType2").attr('checked','checked');
        		}
        	});
        });
        
        $(document).ready(function () {
           var studentName = $('#studentName').val();
           if(studentName!=''){
        	   findAccountByName();
           }
        });
 </script>
 
 <script type="text/javascript">
 
 function Form() {
		getIds();
		var tids = $("#tids").val();
		var date1 = $("#date1").val(); 
		var date2 = $("#date2").val();
		var campusid = $("#campusId").val();
		var url = "/course/queryAllcoursePlansByteacher?returnType=2&allteacherids="+tids+"&date1="+date1+"&date2="+date2+"&campusId="+campusid;
		window.open(url,'_blank');
	}
 
 function getIds() {
		var teacherids = "";
		var list = document.getElementsByClassName("search-choice");
		for (var i = 0; i < list.length; i++) {
			var name = list[i].children[0].innerHTML;
			var olist = document.getElementsByClassName("options");
			for (var j = 0; j < olist.length; j++) {
				var oname = olist[j].innerHTML;
				if (oname == name) {
					teacherids += "|" + olist[j].getAttribute('value');
					break;
				}f
			}
		}
		$("#tids").val(teacherids);
	}
 
 </script>
 
 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
</body>
</html>