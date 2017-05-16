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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style>
label {
	width: 80px;
}
.chosen-container .chosen-results{
    max-height:100px !important
}
</style>

</head>
<body style="background:#eff2f4">
   <div class="float-e-margins" style="padding:15px">
	   <div class="ibox-content">
		    <form action="" method="post" id="sendMailForm">
				<fieldset>
				<input type="hidden" id="tgid" name="tgid" value="${tgid }" >
				<input type="hidden" id="type" name="type" value="${type }" >
					<p>
						<label> ${_res.get('Addressee')}： </label> 
						<input type="text" name="toMails" id="toMails"  value="${student.EMAIL };${student.fatheremail}" size="32"  class="required"  />
						<br><font color="red">${_res.get('Remind')}</font>
					</p>
					<p>
						<label> ${_res.get('Cc')}： </label> 
						<select id="ccmails" name="ccMails" class="chosen-select" data-placeholder="--${_res.get('Please.select')}(${_res.get('Multiple.choice')})--" multiple style="width: 269px;" tabindex="4">
							<c:forEach items="${userList }" var="user" varStatus="index" >
								<option value="${user.email }" class="options" id="">${user.real_name }</option>
							</c:forEach>
						</select>
						<input id="tids" name="tgccmails" value="" type="hidden">
					</p>
					<p>
						<label> ${_res.get('Theme')}： </label>
						<input type="text" name="mailSubject" id="real_name"  value="${title }" size="32" class="required" />
					</p>
					<p>
						<div id="savegroups">
							<input type="button" value="${_res.get('Sent')}" onclick="sendMail(${tgid},${type })" class="btn btn-outline btn-primary" />
						</div>
					</p>
				</fieldset>
			</form>
		</div>
	</div>
	<div style="clear: both;"></div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script>

		//-----------------下拉菜单插件
		$(".chosen-select").chosen({
			disable_search_threshold : 20
		});
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : true
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 10
			},
			'.chosen-select-no-results' : {
				no_results_text : 'Oops, nothing found!'
			},
			'.chosen-select-width' : {
				width : "95%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
   </script>

	<script type="text/javascript">
   //弹出后子页面大小会自动适应
     var index = parent.layer.getFrameIndex(window.name);
     parent.layer.iframeAuto(index);
     
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
					}
				}
			}
			$("#tids").val(teacherids);
		}
     
     
     
     function sendMail(tgid,type){
    	 getIds();
    	/*  if(type=="2")
    		 uri = "/report/sentDayReport";
    	 if(type=="1")
    		 uri = "/report/sentWeekReport"; */
    	 $.ajax({
    		 url:"/report/sentDayReport",
    		 type:"post",
    		 dataType:"json",
    		 data:$("#sendMailForm").serialize(),
    		 success:function(result){
    			 alert(result.msg);
    			 if(result.code=="1"){
    				 parent.window.location.reload();
    				 parent.layer.close(index);
    			 }
    		 }
    	 });
     }
     
	</script>
</body>
</html>
