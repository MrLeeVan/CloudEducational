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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
  label{
    width:160px
  }
  .text-font{
    background:#EFF2F4;
    padding:10px;
    margin-bottom:20px;
    text-align: center;
  }
  .padding-ten{
  
  }
</style>
<title>超出规定时间删除排课</title>
</head>
<body style="background:#fff">
        <div class="ibox-content" style="padding:20px">
            <form action="" method="post" id="callNameMessage" name="form">
            	<input type="hidden" id="planid" name ="planid" value="${cp.id}">
            	<input type="hidden" id="techerhour" name ="planid" value="${cp.teacherhour}">
            	<input type="hidden" id = "num" value="${num}">
            		
				<div class="text-font">由于删除课时时间超出规定的时间， 所以请选择以下操作：选择取消则老师计算课酬   选择移除则按正常删除排课</div>
				<div class="padding-ten">
					<p>
						<label>请选择您的操作:</label><br>
						<input type="radio" name="del" onchange="checkTname()" ${cp.iscancel==0?"checked=checked'":(cp.iscancel == 1?"checked=checked'":"") } value="1" /> 取消(计算学生课时)<br>   
						<input type="radio" name="del"  onchange="clearTname()" ${cp.iscancel == 2 ? "checked=checked'":"" }  value="2" /> 移除(不计算学生课时)
					</p>
					<hr>
					<p>
						<span id="control">
						</span>
					</p>
					<p>
						<label>原因： </label>
						<textarea rows="3" cols="28"  id ="remark" name="remark"  style="display: inline;margin-left: 0;width:100%">${fn:trim(cp.del_msg)}</textarea>
					</p>
				</div>
				<div style="width:100%;text-align: center;margin-top:20px">					
					<input type="button" value="${_res.get('admin.common.submit')}"  onclick="saveDelCoursePlanMessage();" class="btn btn-outline btn-primary"/>
			    </div>
			</form>
        </div>

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script>
    	function checkTname(){
    		var planid = $("#planid").val();
    		var techerhour =$("#techerhour").val()
    		$.ajax({
    			 	url : "/course/checkClassHours",
					type : "post",
					data : { "planid" : planid},
					dataType : "json",
					success : function(data){
						var s = "";
						for(var i=0;i<data.hour.length;i++){
							if(data.hour[i]==techerhour){
								s+="<option value='"+data.hour[i]+"' selected='selected'>"+data.hour[i]+"${_res.get('session')}</option>";
							}else{
								s+="<option value='"+data.hour[i]+"' >"+data.hour[i]+"${_res.get('session')}</option>";
							}
						}
						var str = "<label>老师课酬：</label> "
							+"<select  id='hours' class='chosen-select' style='width: 95px' tabindex='2'>"
							+ s
							+"</select>";
			    		$("#control").html(str);
					}
    		});
    	}
    	function clearTname(){
    		$("#control").html("");
    	}
    	function saveDelCoursePlanMessage(){
    		var index = parent.layer.getFrameIndex(window.name);
    		var remark = $("#remark").val();
    		var temp = document.getElementsByName("del");
    		var num = $("#num").val();
    		var del;
    		 for(var i=0;i<temp.length;i++){
    		     if(temp[i].checked)
    		            del = temp[i].value;
    		  }
    		var planid = $("#planid").val()
    		var hours = $("#hours").val();
    		if(remark.trim()==''){
  			  layer.msg("请填写删除排课的原因",1,2);
  			  return false;
  		 	 }else if(del ==1){
    					  $.ajax({
         				 	 url : "/course/saveFullHourDelCoursePlan",
     						type : "post",
     						data : {
     							"planid" : planid,
     							"remark":remark,
     							"hours":hours,
     							"delcode":del
     						},
     						dataType : "json",
     						success : function(result){
     							if(num==0){
    								window.parent.window.getCalender();
    								window.parent.window.getStudentInfo();
    							}
     							 if(result.code==1){
     								parent.layer.msg("课程已成功取消",1,1);
     								window.parent.searchCoursePlan();
     								parent.layer.close(index);
     							}else{
     								parent.layer.msg("删除信息异常 请联系管理员");
     							}
     						}
     				  }); 
    			  }else{
	    				  $.ajax({
	        					url : "/course/saveFullHourDelCoursePlans",
	    						type : "post",
	    						data : {
	    							"planid" : planid,
	    							"remark":remark
	    						},
	    						dataType : "json",
	    						success : function(result){
	    							 if(result.code==1){
	    								parent.layer.msg("删除成功",1,1);
	    								 if(num==0){//按课程排课页面进来的
			    								window.parent.window.getCalender();
			    								window.parent.window.getStudentInfo();
			    							}
			    							if(num==1){//删除排课（排课管理）页面进来的
			    								window.parent.searchCoursePlan();
		    								}
	    								parent.layer.close(index);
	    							}else{
	    								parent.layer.msg(result.msg);
	    							}
	    						}
	    				  });
    			  }
    	}
    	$(document).ready(checkTname());
    </script>
</body>
</html>