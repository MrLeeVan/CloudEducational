<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>${_res.get('Channel.Intelligence')}</title>
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
<link rel="stylesheet" type="text/css" href="/css/css/plugins/simditor/simditor.css" />

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 .table{
    margin-bottom:0 !important 
 }
</style>
</head>
<body style="background:#eff2f4">   
	<div class="ibox-content">
		<table class="table table-bordered">
			<tr align="center">
				<td class="table-bg1">渠道</td>
				<td class="table-bg2">${mediator.REALNAME}</td>
				<td class="table-bg1">${_res.get('gender')}</td>
				<td class="table-bg2">${mediator.type==1?(mediator.SEX eq '0'?_res.get('student.girl'):_res.get('student.boy')):'-'}</td>
			</tr>
			<tr align="center">
				<td class="table-bg1">${_res.get("admin.user.property.telephone")}</td>
				<td class="table-bg2">${mediator.PHONENUMBER}</td>
				<td class="table-bg1">Email</td>
				<td class="table-bg2">${mediator.EMAIL}</td>
			</tr>
    	  	<tr align="center">
    	  		<td class="table-bg1">${_res.get('Rebate.rate')}</td>
    	  		<td class="table-bg2">${bili}</td>
    	  		<td class="table-bg1">${_res.get('Bank.card.number')}</td>
    	  		<td class="table-bg2">${mediator.CARDHOLDER==null?'':mediator.CARDHOLDER}</td>
    	  	</tr>
    	  	<tr align="center">
    	  		<td class="table-bg1">${_res.get('Cardholder')}</td>
    	  		<td class="table-bg2">${mediator.CARDHOLDER==null?'':mediator.CARDHOLDER}</td>
    	  		<td class="table-bg1">${_res.get('Bank.name')}</td>
    	  		<td class="table-bg2">${mediator.BANKNAME==null?'':mediator.BANKNAME}</td>
    	  	</tr>
    	  	<tr align="center">
    	  		<td class="table-bg1">${_res.get("marketing.specialist")}</td>
    	  		<td class="table-bg2">${mediator.SYSNAME}</td>
    	  		<td class="table-bg1">${_res.get('Recommended')}</td>
    	  		<td class="table-bg2">${mediator.PARENTNAME==null?'':mediator.PARENTNAME}</td>
    	  	</tr>
    	  	<tr align="center">
    	  		<td class="table-bg1">类型</td>
				<td class="table-bg2">${mediator.type==1?'个人':mediator.type==2?'公司':'未知'}</td>
    	  		<td class="table-bg1">${_res.get('Affiliation')}</td>
    	  		<td class="table-bg2">${mediator.COMPANYNAME==null?'':mediator.COMPANYNAME}</td>
    	  	</tr>
   	  		<tr align="center">
    	  		<td class="table-bg1">公司地址</td>
    	  		<td class="table-bg2" colspan="3">${mediator.type==2?mediator.address:'-'}</td>
    	  	</tr>
		</table>
		<div>
  			${mediator.record }
		</div>
	</div>
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
    <!-- simditor -->
    <script type="text/javascript" src="/js/js/plugins/simditor/module.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/uploader.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/hotkeys.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/simditor.js"></script>
    <script>
        $(document).ready(function () {
            var editor = new Simditor({
                textarea: $('#record')
            });
            
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
        });
    </script>
</body>
</html>