<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Retroactive.reason')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/jquery-2.1.1.min.js"></script>
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 .xubox_tabmove{
	background:#EEE;
}
.xubox_tabnow{
    color:#31708f;
}
</style>
</head>
<body style="background:#eff2f4">
    <div class="chat-message1">
      <div class="buqian">
    	<form action="" method="post" id="signedForm">
	       	<input type="hidden" id ="courseplan_id" name = "courseplan_id" value="${courseplan_id}">
	       	<label style="font-weight:100">${_res.get('to.50.characters')}</label>
	       	<textarea rows="5" cols="85" class="buqian-texar" id="signedcause" name="signedcause" ></textarea>
	       	<c:if test="${operator_session.qx_coursetosaveSignedCause }">
				<a style="float:right"  href="" onclick="saveSignedCause()" class="btn btn-outline btn-primary">${_res.get('save')}</a>
	       	</c:if>
			<div style="clear:both"></div>
		</form>
	  </div>	
	 </div>
    
    <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script type="text/javascript">
      var index = parent.layer.getFrameIndex(window.name);
		  parent.layer.iframeAuto(index);  
		  function saveSignedCause(){
		    	  var courseplan_id  = $("#courseplan_id").val();
		    	  var signedcause = $("#signedcause").val();
		    	  if(signedcause =="" ){
		    		  parent.layer.msg("请填写补签原因",2,8);
		    	  }else{
		    		   $.ajax({
		       			url:"${cxt}/course/tosaveSignedCause",
		       			type:"post",
		       			data:{"courseplan_id":courseplan_id,"signedcause":signedcause},
		       			async: false,
		       			success:function(data){
		       					parent.layer.msg(data.msg,3,1);
		       				if(data.code=="1"){
		       					parent.window.document.getElementById('searchForm').submit();
				    			setTimeout("parent.layer.close(index)",4000);
		       				}
		       			}
		    		   });	
		    	   }
		    }
    </script>
    
</body>
</html>