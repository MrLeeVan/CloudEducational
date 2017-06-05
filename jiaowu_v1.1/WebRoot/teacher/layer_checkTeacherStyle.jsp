<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
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
 .table{
   margin-bottom:0
 }
</style>
</head>
<body style="background-color:#EFF2F4">   
<div class="ibox-content"> 
	<table class="table table-bordered">
	<tr>
		<td class="table-bg1" width="15%">${_res.get("sysname")}</td>
		<td class="table-bg2" width="35%">${result.REAL_NAME}</td>
		<td class="table-bg1" width="15%">${_res.get('gender')}</td>
		<td class="table-bg2" width="35%">${result.SEX==0?_res.get('student.girl'):_res.get('student.boy')}</td>
	</tr>
	<tr>
		<td class="table-bg1">${_res.get("job.category")}</td>
		<td class="table-bg2">${result.tworktype=='1'?'全职':'兼职'}</td>
		<td class="table-bg1">${_res.get("If.a.foreign.teacher")}</td>
		<td class="table-bg2">${result.isforeignteacher eq '0' ? "否":"是"}</td>
	</tr>
	<tr>
		<td class="table-bg1">${_res.get("admin.user.property.telephone")}</td>
		<td class="table-bg2">${result.TEL}</td>
		<td class="table-bg1">Email</td>
		<td class="table-bg2">${result.EMAIL}</td>
	</tr>
	<tr>
		<td class="table-bg1">${_res.get('WeChat')}</td>
		<td class="table-bg2">${result.wechat}</td>
		<td class="table-bg1">Skype</td>
		<td class="table-bg2">${result.skype}</td>
	</tr>
	<%-- <tr>
		<td class="table-bg1">校区</td>
		<td class="table-bg2" colspan="3">${style}</td>
	</tr> --%>
	<tr>
		<td class="table-bg1"> ${_res.get("Education")}${_res.get("course.subject")}</td>
		<td class="table-bg2" colspan="3">${subject}</td>
	</tr>
	<tr>
		<td class="table-bg1"> ${_res.get("Education")}${_res.get("course.course")}</td>
		<td class="table-bg2" colspan="3">${course}</td>
	</tr>
	<tr>
		<td class="table-bg1">${_res.get('Teaching.style')}</td>
		<td class="table-bg2" colspan="3">${style}</td>
	</tr>
	<tr>
		<td class="table-bg1">${_res.get('Teaching.ability')}</td>
		<td class="table-bg2" colspan="3">${ability}</td>
	</tr>
	<tr>
		<td class="table-bg1">${_res.get("course.remarks")}</td>
		<td class="table-bg2" colspan="3">${result.INTRO==null?'无':result.INTRO}</td>
	</tr>
	</table>
	<div>
		<label class="table-bg1">记录本:</label>
		${result.remark }
	</div>
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