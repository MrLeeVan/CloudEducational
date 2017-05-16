<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>${_res.get('courselib.studentMsg')}</title>
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
 .table{
   margin-bottom:0
 }
</style>
</head>
<body >  
<div class="ibox-content"> 
	<table class="table table-bordered">
		<tr  align="center">
			<td class="table-bg1" width="25%">${_res.get("sysname")}</td>
			<td class="table-bg2" width="25%">${result.REAL_NAME}</td>
			<td rowspan="4" colspan="2" width="50%" height="180px;">
				<c:if test="${result.url!=null && !empty result.url}">
					<IMG src="/images/headPortrait/${result.url}" style="width: 144px; height: 144px;" >
				</c:if>
				<c:if test="${result.url==null || empty result.url}">
					<IMG src='${cxt }/images/student/student_${result.SEX==0?"female":"male"}.jpg' style="width: 144px; height: 144px;" >
				</c:if>
			</td>
		</tr>
		<tr  align="center">
			<td class="table-bg1">${_res.get('gender')}</td>
			<td class="table-bg2">${result.SEX==0?_res.get('student.girl'):_res.get('student.boy')}</td>
		</tr>
		<tr  align="center">
			<td class="table-bg1">${_res.get('admin.common.place')}</td>
			<td class="table-bg2">${result.ADDRESS==null?'':result.ADDRESS}</td>
		</tr>
		<tr  align="center">
			<td class="table-bg1">${_res.get('Date.of.birth')}</td>
			<td class="table-bg2">${result.BIRTHDAY==null?'':result.BIRTHDAY}</td>
		</tr>
	<tr  align="center">
		<td class="table-bg1" >${_res.get("admin.user.property.telephone")}</td>
		<td class="table-bg2">${result.TEL}</td>
		<td class="table-bg1" width="25%">Email</td>
		<td class="table-bg2" width="25%">${result.EMAIL}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get('student.parentphone')}</td>
		<td class="table-bg2">${result.PARENTS_TEL}</td>
		<td class="table-bg1" >${_res.get('Patriarch')}Email</td>
		<td class="table-bg2" >${result.PARENTS_EMAIL}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get('Ranged')}</td>
		<td class="table-bg2">${result.REMOTE==0?'面授':'远程'}</td>
		<td class="table-bg1">${_res.get('Accommodation')}</td>
		<td class="table-bg2">${result.BOARD==0?'不住宿':'寄宿'}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get('rest.day')}</td>
		<td class="table-bg2">${day}</td>
		<td class="table-bg1">${_res.get('Sales.opportunities')} </td>
		<td class="table-bg2">${result.CONTACTER}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get("Supervisor")}</td>
		<td class="table-bg2">${result.DUNAME==null?'':result.DUNAME}</td>
		<td class="table-bg1">${_res.get("course.consultant")}</td>
		<td class="table-bg2">${kcgwname.REAL_NAME==null?'':kcgwname.REAL_NAME}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get("marketing.specialist")}</td>
		<td class="table-bg2">${result.SCNAME==null?'':result.SCNAME}</td>
		<td class="table-bg1">${_res.get("Overseas.study.consultant")}</td>
		<td class="table-bg2">${result.MEDNAME==null?'':result.MEDNAME}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get("The.head.teachers")}</td>
		<td class="table-bg2">${result.CLASSTEACHER==null?'':result.CLASSTEACHER}</td>
		<td class="table-bg1">${_res.get("The.teacher.in.charge.the.phone")}</td>
		<td class="table-bg2">${result.CLASSTEACHERTEL==null?'':result.CLASSTEACHERTEL}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get("English.teacher")}</td>
		<td class="table-bg2">${result.ENGLISHTEACHER==null?'':result.ENGLISHTEACHER}</td>
		<td class="table-bg1">${_res.get("The.English.teacher.call")}</td>
		<td class="table-bg2">${result.ENGLISHTEACHERTEL==null?'':result.ENGLISHTEACHERTEL}</td>
	</tr>
	<tr  align="center">
		<td class="table-bg1">${_res.get("course.remarks")}</td>
		<td class="table-bg2" colspan="3">${result.INTRO==null?'无':result.INTRO}</td>
	</tr>
	</table>
	</div>
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
		
    <script>
    $(".chosen-select").chosen({disable_search_threshold: 20});
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
        
      //弹出后子页面大小会自动适应
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.iframeAuto(index);
    </script>	
</body>
</html>