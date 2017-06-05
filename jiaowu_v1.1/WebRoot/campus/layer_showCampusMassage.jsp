<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>校区信息</title>
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
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
</style>
</head>
<body id="body">   
	<div style="padding:5px 10px;margin:15px 0 0 20px">
		<table class="table table-bordered">
			<tr>
	        	<td class="table-bg1 table-wh1">校区名称</td>
	        	<td class="table-bg2 table-wh2">${campus.CAMPUS_NAME}</td>
	        	<td class="table-bg1 table-wh1">${_res.get('person.in.charge')}</td>
	        	<td class="table-bg2 table-wh2">${campus.FZRNAME==null?'':campus.FZRNAME}</td>
	        	</tr>
	        	<tr>
	        	<td class="table-bg1 table-wh1">教务负责人</td>
	        	<td class="table-bg2 table-wh2">${campus.JWFZRNAME==null?'':campus.JWFZRNAME}</td>
	        	<td class="table-bg1 table-wh1">市场负责人</td>
	        	<td class="table-bg2 table-wh2">${campus.SCFZRNAME==null?'':campus.SCFZRNAME}</td>
	        	</tr>
	        	<tr>
	        	<td class="table-bg1 table-wh1">课程顾问负责人</td>
	        	<td class="table-bg2 table-wh2">${campus.KCFZRNAME==null?'':campus.KCFZRNAME }</td>
	        	<td class="table-bg1 table-wh1">校区电话</td>
	        	<td class="table-bg2 table-wh2">${campus.TEL==null?'':campus.TEL}</td>
	        	</tr>
	        	<tr>
	        	<td class="table-bg1 table-wh1">校区地址</td>
	        	<td class="table-bg2" colspan=3>${campus.CAMPUS_ADDR==null?'':campus.CAMPUS_ADDR}</td>
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
    </script>	
</body>
</html>