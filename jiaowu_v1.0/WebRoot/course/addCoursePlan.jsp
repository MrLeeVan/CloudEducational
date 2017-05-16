<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('add_courses')}</title>
<script type="text/javascript">
$(function(){
	$('#studentName').keyup(function(){
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
									dianclass(banciid);
									return;
			   					}else{
			   					   str+="<li onclick='dianclass("+banciid+")'>"+data.classes[i].CLASSNUM + "  " + data.classes[i].NAME +"</li>";
			   					}
			   				}
			   			/* if(data.classes.length==1){
			   				dianclass(data.classes[0].BANCI_ID);
			   			}else{
			   				var str="";
			   				for(var i=0;i<data.classes.length;i++){
			   					str+="<li onclick='dianclass("+data.classes[i].BANCI_ID+")'>"+data.classes[i].CLASSNUM + "  " + data.classes[i].NAME +"</li>";
			   				} */
			   				$("#stuList").html(str);
			   				$("#mohulist").show();
			   				$("#studentInfo").text("");
			   			//}
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
// 改变科目后查询对应课程
function getCourseListBySubjectId(subjectId){
	$("#teacher").html("<option value='0'>${_res.get('Please.select')}</option>");
//	$("#banci_id").html("<option value='0'>请选择班次</option>");
	$("#timeRank").html("<option value='0'>${_res.get('Please.select')}</option>");
	$("#classroom").html("<option value='0'>${_res.get('Please.select')}</option>");
	$("#courseTime").val("");
	if($("input:radio[name='banjiType']:checked").val() == 2){
		$.ajax({
			url:'/course/getMaxTime2',
			data :{
				"class_num":$("#studentName").val(),
				"course_id":subjectId
			},
			type:'post',
			dataType:'json',
			success:function(data){ // maxTime
				if(data.maxTime != null){
					$('#dateMsg').html('最后排课日期：' + data.maxTime);
					$('#courseTime').attr("onfocus","");
					$('#courseTime').val(data.maxTime);
					dateChange(data.maxTime);
				}else{
					$('#dateMsg').html('尚未排课');
				}
			}
		});
	}else{
		$.ajax({
			url:'/course/getMaxTime1',
			data :{
				"real_name":$("#studentName").val(),
				"course_id":subjectId
			},
			type:'post',
			dataType:'json',
			success:function(data){ // maxTime
				if(data.maxTime != null){
					$('#dateMsg').html('${_res.get("Last.Timetable.Date")}：' + data.maxTime);
					$('#courseTime').attr("onfocus","");
					$('#courseTime').val(data.maxTime);
					dateChange(data.maxTime);
				}else{
					$('#dateMsg').html('${_res.get("Not.Timetable")}');
				}
			}
		});
			
	}
}

function findAccountByName(){
	var studentName=$("#studentName").val();
	var class_type = $("input:radio[name='banjiType']:checked").val();
	$('#dateMsg').html('');
	$('#courseTime').attr("onfocus",'');
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
						dianclass(data.classes[0].BANCI_ID);
					}else{
						var str="";
						for(var i=0;i<data.classes.length;i++){
							str+="<li onclick='dianclass("+data.classes[i].BANCI_ID+")'>"+data.classes[i].CLASSNUM + "  " + data.classes[i].NAME +"</li>";
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

function dianclass(classId){
	$("#mohulist").hide();
	$("#mohulist").html();
	$('#classtype').html('${_res.get("Please.select")}');
	$.ajax({
		url :  "/account/getAccountByClass",
		data :"classId="+classId,
		type : "post",
		dataType : "json",
		success : function(result) {
			if(result.account!="noResult"){
				$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
				$("#studentId").val(result.account.studentId);
				$("#banci_id").val(result.account.banci_id);
				$("#courseUseNum").val(result.account.courseUseNum);
				$("#studentName").val(result.account.banci_name);
				$("#studentInfo").html(result.account.stuMsg);
				var str = "";
				for(var i = 0;i < result.account.courseList.length;i++){
					var course_id = result.account.courseList[i].course_id;
					var course_name = result.account.courseList[i].course_name;
					var status = result.account.courseList[i].status;
					var dis = "";
					// disabled='"+dis+"';
					if(status == 0){
						dis = "disabled='disabled'";
					}else{
						dis = "";
					}
					str += "<option value='"+course_id+"' "+dis+">" + course_name 
							+ " </option>";
				}
				$("#classtype").append(str);
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
	$("#mohulist").hide();
	$("#mohulist").html();
	$('#classtype').html('${_res.get("Please.select")}');
	$.ajax({
		url :  "/student/queryCourseInfo",
		data :"studentId="+stuId,
		type : "post",
		dataType : "json",
		success : function(result) {
				alert(result);
			if(result.account!="noResult"){
				$("#classtype").html("<option value='0'>${_res.get('Please.select')}</option>");
				$("#studentId").val(result.account.studentId);
				$("#courseUseNum").val(result.account.courseUseNum);
				$("#studentName").val(result.account.stuName);
				$("#studentInfo").html(result.account.stuMsg);
				var str = "";
				for(var i = 0;i < result.account.courseList.length;i++){
					var course_id = result.account.courseList[i].ID;
					var course_name = result.account.courseList[i].COURSE_NAME;
					var status = result.account.courseList[i].status;
					var dis = "";
					// disabled='"+dis+"';
					if(status == 0){
						dis = "disabled='disabled'";
					}else{
						dis = "";
					}
					str += "<option value='"+course_id+"' "+dis+">" + course_name + " </option>";
				}
				$("#classtype").append(str);
			}else{
				alert("此学员不存在");
			}
		},
		error:function(result){
			alert("ERROR! 请重新登录或刷新页面重试！");
		}
	});
}

function dianTeacher(teacher){
	var ss=$("#teacherOption"+teacher.value).attr("title");
	$("#teacherNamePiao").html($("#teacherOption"+teacher.value).html());
	if(ss=="不可用")
	{
	
	$.ajax({
		 url :  "/course/getTeacherByIdForTimeRank",
		data :{
			   "teacherId":teacher.value,
			   "time":$("#courseTime").val()
			  },
		type : "post",
		dataType : "json",
		success : function(result) {
		 $("#teacher").val(0);
		 $("#piaoo").show();
		 $("#teacherTimeRank").html("");
		 var str="";
		 for(var i=0;i<result.ranks.length;i++){
			 if(result.ranks[i].PLANID==null)
			 str="<p style='color:#0099FF'>"+result.ranks[i].RANKNAME+"</p>";
			 else
		     str="<p style='color:grey'>"+result.ranks[i].RANKNAME+"</p>";	 
			 $("#teacherTimeRank").append(str);
		 }
		 setTimeout("closepiao()",4000);
		}
	});
	}
}

function getTeacherByCourseId(){
	var courseId = $('#classtype').val();
	$.ajax({
		url :  "/account/getTeacherByCourseId",
		data :{
			   "courseId":courseId,
			   "courseTime":$("#courseTime").val(),
			   "timeRank":$("#timeRank").val()
			  },
		type : "post",
		dataType : "json",
		success : function(result) {
			$("#teacher").html("<option value='0'>${_res.get('Please.select')}</option>");
			for(var i=0;i<result.teacherList.length;i++)
			{
				var teacherName=result.teacherList[i].REAL_NAME;
				var teacherId=result.teacherList[i].ID;
				var restDay=result.teacherList[i].REST_DAY;
			    var date=new Date(Date.parse($("#courseTime").val().replace(/-/g,"/")));
			    var day=date.getDay();//星期几
			    var planId = result.teacherList[i].PLANID;
			    if(restDay==day)//如果是老师的休息日
			    {
			    	$("#teacher").append("<option value='"+teacherId+"' id='teacherOption"+teacherId+"' disabled='disabled'  style='color:grey' >"+teacherName+"(${_res.get('Rest')})</option>");
			    }else{
				if(planId==null){
					$("#teacher").append("<option value='"+teacherId+"' id='teacherOption"+teacherId+"'>"+teacherName+"</option>");
				}else{
					$("#teacher").append("<option value='"+teacherId+"' id='teacherOption"+teacherId+"' title='不可用' disabled='disabled' style='color:grey' >"+teacherName+"</option>");
				}
			    }
			}
		},
		error:function(result){
			alert(result.responseText);
		}
	});
}
function dateChange(date){	
$("#timeRank").html("<option value='0'>${_res.get('Please.select')}</option>");
$("#classroom").html("<option value='0'>${_res.get('Please.select')}</option>");
//以上动作是上一级一动下一级皆重置
if($("#studentId").val()=="" && $("input:radio[name='banjiType']:checked").val() == 1)
{
alert("请输入正确的姓名");
return false;
}
if(date==0){
	return false;
}
var myDate = new Date();
var riqi=myDate.getFullYear()+"-"+(myDate.getMonth()<9?"0"+(myDate.getMonth()+1):(myDate.getMonth()+1))+"-"+(myDate.getDate().toString().length==1?"0"+myDate.getDate():myDate.getDate());
if(new Date(riqi)>(new Date(date))){
	$('#dateMsg').text("请选择今天以后的日期 ");
	$('#courseTime').val("")
	return false;
}
if($('#banci_id').val() == 0 && $("input:radio[name='banjiType']:checked").val() == 2){
	$('#classOrder_idMsg').html('请输入班次！');
	$('#courseTime').val('');
	return false;
}
if($("#studentId").val()!="" && $("input:radio[name='banjiType']:checked").val() == 1){
	$.ajax({
		url :  "/course/getTimeRankByStudentId",
		data :{
			"campusId":$("#campus").val(),
			"studentId":$("#studentId").val(),
			"courseTime":date
		},
		type : "post",
		dataType : "json",
		success : function(result) {
			for(var i=0;i<result.timeRanks.length;i++)
			{
				var timeRankId=result.timeRanks[i].ID;
				var timeRankName=result.timeRanks[i].RANK_NAME;
				if(result.timeRanks[i].PLANID==null){
					var checkTime = timeRankName.split("-");
					var hour1=checkTime[0].split(':')[0];
					var minu1=checkTime[1].split(':')[1];
					var time1 = new Date().Format("yyyy-MM-dd");
					var date = new Date();
					var hour2 = date.getHours();
					var minu2 = date.getMinutes();
					if(time1 == $('#courseTime').val()){
						if(hour1 < hour2){
							$("#timeRank").append("<option value='"+timeRankId+"' disabled='disabled'>"+timeRankName+"</option>");
						}else if(hour2 == hour1 && minu1 <= minu2){
							$("#timeRank").append("<option value='"+timeRankId+"' disabled='disabled'>"+timeRankName+"</option>");
						}else{
							$("#timeRank").append("<option value='"+timeRankId+"' >"+timeRankName+"</option>");
						}
					}else{
						$("#timeRank").append("<option value='"+timeRankId+"' >"+timeRankName+"</option>");
					}
				}else{
			    	if(result.timeRanks[i].PLANTYPE==1){
						timeRankName+="(${_res.get('Mode.test.accounts')})";
						}
			    	$("#timeRank").append("<option value='"+timeRankId+"' disabled='disabled'>"+timeRankName+"</option>");
			    	}
			}
		},
		error:function(result){
			alert(result.responseText);
		}
	});
}else if($("#banci_id").val()!="" && $("input:radio[name='banjiType']:checked").val() == 2){
	$.ajax({
		url :  "/course/getTimeRankByClassId",
		data :{
			"campusId":$("#campus").val(),
			"classId":$("#banci_id").val(),
			"courseTime":date
		},
		type : "post",
		dataType : "json",
		success : function(result) {
			for(var i=0;i<result.timeRanks.length;i++)
			{
				var timeRankId=result.timeRanks[i].ID;
				var timeRankName=result.timeRanks[i].RANK_NAME;
				if(result.timeRanks[i].PLANID==null){
					var checkTime = timeRankName.split("-");
					var hour1=checkTime[0].split(':')[0];
					var minu1=checkTime[1].split(':')[1];
					var time1 = new Date().Format("yyyy-MM-dd");
					var date = new Date();
					var hour2 = date.getHours();
					var minu2 = date.getMinutes();
					if(time1 == $('#courseTime').val()){
						if(hour1 < hour2){
							$("#timeRank").append("<option value='"+timeRankId+"' disabled='disabled'>"+timeRankName+"</option>");
						}else if(hour2 == hour1 && minu1 <= minu2){
							$("#timeRank").append("<option value='"+timeRankId+"' disabled='disabled'>"+timeRankName+"</option>");
						}else{
							$("#timeRank").append("<option value='"+timeRankId+"' >"+timeRankName+"</option>");
						}
					}else{
						$("#timeRank").append("<option value='"+timeRankId+"' >"+timeRankName+"</option>");
					}
				}
			    else
			    	{
			    	if(result.timeRanks[i].PLANTYPE==1){
						timeRankName+="(${_res.get('Mode.test.accounts')})";
						}
			    	$("#timeRank").append("<option value='"+timeRankId+"' disabled='disabled'>"+timeRankName+"</option>");
			    	}
			}
		},
		error:function(result){
			alert(result.responseText);
		}
	});
	
}
}

Date.prototype.Format = function (fmt) { //author: meizz 
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
}

function timeRankChange(rankTime){
	$("#classroom").html("<option value='0'>${_res.get('Please.select')}</option>");
	//以上动作是上一级一动下一级皆重置
	if(rankTime==0){
		return false;
	}
	var hour1 = "";
	var minu1 = "";
	if(rankTime == 1){
		hour1 = "08";
		minu1 = "30";
	}else if(rankTime == 2){
		hour1 = "10";
		minu1 = "40";
	}else if(rankTime == 3){
		hour1 = "13";
		minu1 = "30";
	}else if(rankTime == 4){
		hour1 = "15";
		minu1 = "40";
	}else if(rankTime == 5){
		hour1 = "18";
		minu1 = "30";
	}
	var time1 = new Date().Format("yyyy-MM-dd");
	if(time1 == $('#courseTime').val()){
		var checkText=$("#timeRank").find("option:selected").text();
		var checkTime = checkText.split("-");
		var hour1=checkTime[0].split(':')[0];
		var minu1=checkTime[1].split(':')[1];
		var date = new Date();
		var hour2 = date.getHours();
		var minu2 = date.getMinutes();
		if(hour2 > hour1){
			alert("请选择当前时间之后的时段。");
			$('#timeRank').val(0);
			return false;
		}else if(hour2 == hour1 && minu2 >= minu1){
			alert("请选择当前时间之后的时段。");
			$('#timeRank').val(0);
			return false;
		}
	}
	$.ajax({
		url :  "/course/getClassRoomByDateAndDateRank",
		data :{"timeRank":$("#timeRank").val(),"courseTime":$("#courseTime").val(),"campus_id":$("#campus").val()},
		type : "post",
		dataType : "json",
		success : function(result) {
			for(var i=0;i<result.classRooms.length;i++)
			{
				var roomId=result.classRooms[i].ID;
				var roomName=result.classRooms[i].NAME;
				if(result.classRooms[i].USED == 1){
					$("#classroom").append("<option value='"+roomId+"' disabled='disabled'>"+roomName+"</option>");
				}else {
			    	$("#classroom").append("<option value='"+roomId+"' >"+roomName+"</option>");
			    }
			}
		},
		error:function(result){
			alert("ERROR!");
		}
	});
}


function campusChange(){
	$("#timeRank").html("<option value='0'>${_res.get('Please.select')}</option>");
	$("#classroom").html("<option value='0'>${_res.get('Please.select')}</option>");
}
function addCoursePlan(){
	if(($("#teacher").val()==0 && $('input:radio[name="coursePlan.plan_type"]:checked').val() == 0) || $('#classroom').val() == 0){
		alert("请把信息填写完整。");
		return false;
	}else{
		if(confirm("是否继续添加排课？"))
		{
			if($("input:radio[name='banjiType']:checked").val() == 1){
				$("#goon").val("1");
			}else{
				$("#goon").val("2");
			}
		}
		$("#coursePlan").attr("action","/course/doAddCoursePlan");
		$("#coursePlan").submit();
	}
}
function chongzhi(){
	 document.getElementById("studentName").disabled=false; 
	 $('#stuOrBanci').html("${_res.get('student.name')}:");
	 $("#studentInfo").html("");
}
function closepiao(){
$("#piaoo").hide();
}
$(this).ready(function(){
	if($("#studentName").val() != "" && $("#studentName").val() != null){
		findAccountByName();
	}
	if("${studentId}"!=""&&"${studentId}"!="0"){
		dianstu(${studentId});
	}
});
function changePlanType(data){
	var select = "${_res.get('Please.select')}";
	$("#timeRank").html("<option value='0'>"+select+"</option>");
	$("#classroom").html("<option value='0'>"+select+"</option>");
	$("#campus").val(0);
	if(data==0)
	{
	$("#teahcerP").show();
	$("#classtype").show();
	$('#kechengAndKemu').html("${_res.get('course.course')}:");
	findAccountByName();
	}
	else{	
		$("#teahcerP").hide();
		$('#dateMsg').html('');
		$('#kechengAndKemu').html("${_res.get('course.subject')}：");
		$('#classtype').attr('name','coursePlan.subject_id');
		$.ajax({
			url : '/course/getSubjectForUser',
			type : 'post',
			data : {
				'name' : $('#studentName').val(),
				'teach_type' : $("input:radio[name='banjiType']:checked").val()
			},
			dataType : 'json',
			success : function(data){
				if(data.subject != null){
					var str = "";
					$('#classtype').html("<option value='0'>"+select+"</option>");
					for(var i = 0;i < data.subject.length;i++){ // subject_id
						var sub_id = data.subject[i].SUBJECT_ID;
						var sub_name = data.subject[i].SUBJECT_NAME;
						str += "<option value='"+sub_id+"'>"+sub_name+"</option>";
					}
					$('#classtype').append(str);
				}else{
					$('#classtype').html("<option value='0'>"+select+"</option>");
				}
			}
		});
	}
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
	top: 28px;
	left: 14.8em;
	width: 100px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
}
label {
	width: 100px
}
</style>
</head>
<body>
	<div id="wrapper" style="min-width:1100px">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			<div class="navbar-header" style="margin: 10px 0 0 30px;">
				<h5>
					<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					&gt;<a href='/course/queryAllcoursePlans?loginId=${account_session.id}&returnType=1'>${_res.get('curriculum_management')}</a> &gt;${_res.get('add_courses')}
				</h5>
				<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
			</div>
			</nav>
		</div>


		<div class="col-lg-9 marginxxm" style="min-width:900px;width:100%;">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>${_res.get('add_courses')}</h5>
				</div>
				<div class="ibox-content">
					<form action="" method="post" id="coursePlan">
						<fieldset style="width: 100%; overflow: hidden;">
							<input type="hidden" name="coursePlan.student_id" id="studentId" />
							<input type="hidden" name="banci_id" id="banci_id" /> 
							<input type="hidden" name="goon" id="goon" value="0" /> 
							<input type="hidden" name="course_usenum" id="courseUseNum" value="0" />
							<p>
								<label>${_res.get('type.of.class')}：</label> 
								<input type="radio" name="banjiType" id="banjiType1" value="1" checked="checked">${_res.get("IEP")} 
								<input type="radio" name="banjiType" id="banjiType2" value="2" <c:if test='${banjiType eq 2 }'> checked='checked'</c:if>>${_res.get('course.classes')}
							</p>
							<div class="stu_name" id="stu_name">
								<label>
								<span id="stuOrBanci"> 
									<c:choose>
										<c:when test="${banjiType eq 2 }">${_res.get("class.number")}:</c:when>
										<c:otherwise>${_res.get("student.name")}：</c:otherwise>
									</c:choose>
								</span>
								</label>
								<input type="text" id="studentName" name="studentName" value="${studentName }" />
								<div id="mohulist" class="student_list_wrap" style="display: none">
									<ul style="margin-bottom: 10px;" id="stuList"></ul>
								</div>
								<a href="#" class="dengemail" onclick="findAccountByName()" style="padding: 8px;">${_res.get('admin.common.select')}</a><span id="studentInfo"></span>
							</div>
							<p>
								<label>${_res.get('Arranging.type')}：</label> 
								<input id="planType0" name="coursePlan.plan_type" value="0" type="radio" checked="checked" onchange="changePlanType(this.value)">${_res.get('course.course')}&nbsp; 
								<input id="planType1" name="coursePlan.plan_type" value="1" type="radio" onchange="changePlanType(this.value)">${_res.get('mock.test')}
							</p>
							<p>
								<label><span id="kechengAndKemu">${_res.get('course.course')}：</span></label> 
								<select id="classtype" name="coursePlan.course_id" class="form-control" style="display:inline;width: 150px;" onchange="return getCourseListBySubjectId(this.value);">
									<option value="0">${_res.get('Please.select')}</option>
								</select> 
								<span id="subjectMsg"> </span>
							</p>
							<p>
								<label>${_res.get('system.campus')}：</label> 
								<select id="campus" class="form-control" style="display:inline;width: 150px;" name="coursePlan.campus_id" onchange="campusChange()">
									<option value="0">${_res.get('Please.select')}</option>
									<c:forEach items="${campus}" var="campus_option">
										<option value="${campus_option.id}">${campus_option.CAMPUS_NAME}</option>
									</c:forEach>
								</select>
							</p>
							<p>
								<label>${_res.get('course.class.date')}：</label> 
								<input type="text" name="courseTime" id="courseTime" readonly="readonly" value="${coursePlan.courseTime}"/>
								<span id="dateMsg"></span>
							</p>
							<p>
								<label>${_res.get('time.session')}：</label> 
								<select id="timeRank" class="form-control" style="display:inline;width: 150px;" name="coursePlan.timerank_id" onchange="return timeRankChange(this.value);">
									<option value="0">${_res.get('Please.select')}</option>
								</select>
							</p>
							<p>
								<label>${_res.get("classroom")}：</label> 
								<select id="classroom" class="form-control" style="display:inline;width: 150px;" name="coursePlan.room_id" onchange="getTeacherByCourseId()">
									<option value="0">${_res.get('Please.select')}</option>
								</select>
							</p>
							<p id="teahcerP">
								<label>${_res.get('teacher')}：</label>
								<select id="teacher" class="form-control" style="display:inline; width: 150px;" name="coursePlan.teacher_id" onchange="dianTeacher(this)">
									<option value="0">${_res.get('Please.select')}</option>
								</select>
							</p>
							<p>
								<label>${_res.get("course.remarks")}：</label>
								<textarea rows="3" cols="50" name="coursePlan.remark" style="background-color: #fff; color: #0099FF;"></textarea>
							</p>
							<p>
								<input type="submit" class="btn btn-outline btn-primary" value="${_res.get('save')}" onclick="return addCoursePlan();"  /> 
								<input type="reset" class="button btn btn-outline btn-success" id="cz" onclick="chongzhi()" value="${_res.get('Reset')}" />
							</p>
							<input type="hidden" id="englishclassnumber" value="${_res.get('class.number')}">
						</fieldset>
						
					</form>
					<div class="teacherTimeRankWrap" style="display: none" id="piaoo">
						<h1 onclick="closepiao();">
							<span id="timeRankCloseBtn" title="${_res.get('admin.common.close')}">X</span><label> id="teacherNamePiao"></label>
						</h1>
						<div id="teacherTimeRank"></div>
					</div>
				</div>
			</div>
		</div>

	</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
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
         //日期范围限制
        var courseTime = {
            elem: '#courseTime',
            format: 'YYYY-MM-DD',
            max: '2099-06-16', //最大日期
            istime: false,
            istoday: true,
            choose: function(dates){ //选择好日期的回调
            	dateChange(dates)
            }
        };
        laydate(courseTime);
        
        $(function(){ // 班级类型切换
        	var str = $("#englishclassnumber").val();
        	$(":input[name='banjiType']").click(function(){
        		if($(this).val() == 1){
        			$('#stuOrBanci').html("${_res.get('student.name')}:");
        			$("#studentName").val("");
        			$("#banjiType1").attr('checked','checked');
        		}else{
        			$('#stuOrBanci').html(str+':');
        			$("#studentName").val("");
        			$("#banjiType2").attr('checked','checked');
        		}
        	});
        });
 </script>

</body>
</html>