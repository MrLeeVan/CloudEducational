<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<title>登录</title>
<style>
label{
   width:170px;
}
span.campus{
   display:-moz-inline-box; display:inline-block; min-width: 60px; margin-right: 25px;
}
</style>
</head>
<body style="background: white;">
     <div class="ibox float-e-margins">
     <div class="ibox-content">
         <form action="${wordSystemPath}/api/login" method="post" id="sysuserForm">
			<input type="hidden" name="flag" value="${flag}" />
			<input type="hidden" name="isStudent" value="${isStudent}" />
			<input type="hidden" name="timeStamp" value="${timestamp}" />
			<input type="hidden" name="signature" value="${signature}" />
			<input type="hidden" name="jwUserId" value="${jwUserId}" />
			<input type="hidden" name="email" value="${email}" />
			<input type="hidden" name="realName" value="${realName}" />
		</form>
     </div>
     </div>
<!-- Mainly scripts -->
<script src="/js/js/jquery-2.1.1.min.js"></script>

<!-- Chosen -->
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
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script type="text/javascript">
     $(document).ready(function () {
         $("#sysuserForm").submit();
     });
</script>
<script src="/js/utils.js"></script>

 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/campus.js"></script>
    <script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
</body>
</html>
