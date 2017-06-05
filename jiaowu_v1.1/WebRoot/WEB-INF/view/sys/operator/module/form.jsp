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
<!-- Mainly scripts -->
<script src="/js/js/jquery-2.1.1.min.js"></script>
<script src="/js/common.js"></script>
<title>添加&修改模块</title>
<style>
label{
   width:170px;
}
</style>
</head>
<body style="background:#fff;">
      <div class="ibox-content" >
      	<div style="height: 10px;" id="showicon">
				<p>
					<iframe id="ifstu" name="ifstu" width=100% height=200px;  frameborder=0 scrolling=no src="/operator/icon.jsp"> </iframe>
				</p>
			</div>
         <form action="" method="post" id="operatorForm">
         		<input type="hidden" id="operatortype" name="operatortype" value="${operatorType }" >
					<input type="hidden" id="id" name="module.id" value="${module.id}"/>
					<c:if test="${!empty sysuser.id }">
						<input type="hidden" name="module.version" value="${module.version + 1}">
					</c:if>
					<fieldset>
						<p>
							<label >系统平台:</label>
								<select name="module.systemsids" id="systemsids"  class="chosen-select" style="width: 150px" >
									<c:forEach items="${systemlist }" var="system" >
										<option value="${system.id }" <c:if test="${system.id == module.systemsids }" >selected="selected"</c:if>  >${system.names }</option>
									</c:forEach>
								</select>
						</p>
						<p>
							<label >父模块：</label>
								<select name="module.parentmoduleids" id="fatherids"  class="chosen-select" style="width: 150px" onchange="addchildmodule(this.value)" >
									<option value="" >-请选择-</option>
									<c:forEach items="${modulelist }" var="pamodule" >
										<option value="${pamodule.id }" <c:if test="${pamodule.id == module.parentmoduleids }" >selected="selected"</c:if>  >${pamodule.names }</option>
									</c:forEach>
								</select>
								<!-- <span class="help-inline">当作为首模块时不用选择，其他为必选</span> -->
							</p>
						<p>
							<label >模块名称：</label>
								<input type="text" name="module.names" value="${module.names }" 
									class="input-xlarge" maxlength="25" vMin="2" vType="length" onblur="onblurVali(this);">
								<span class="help-inline">2-10位任意字符</span>
						</p>
						<p >
							<label >英文名称：</label>
							<input type="text" id="globalization" name="module.globalization" value="${module.globalization}" >
						</p>
						<p >
							<label >日文名称：</label>
							<input type="text" id="japanese" name="module.japanese" value="${module.japanese}" >
						</p>
						<p id="num" >
							<label >number：</label>
								<input type="text" id="numbers" name="module.numbers" value="${module.numbers }" 
									class="input-xlarge" maxlength="25" vMin="2" vType="length" onblur="onblurVali(this);" onchange="checkExit(this.value)" >
								<span class="help-inline">2-10位任意字符</span>
								<span id="nummsg" style="color:red;" ></span>
						</p>
						<p >
							<label >路径：</label>
								<input type="text" id="url" name="module.url" value="${module.url }" >
						</p>
						<input type="hidden" id="iconid" name="module.iconid" value="${module.iconid}">
						<p>
							<c:if test="${operatorType eq 'add'}">
								<input type="button" value="保存" onclick="return save();" class="btn btn-outline btn-success" />
							</c:if>
							<c:if test="${operatorType eq 'update'}">
								<input type="button" value="更新" onclick="return save();" class="btn btn-outline btn-success" />
							</c:if>
						</p>
					</fieldset>
				</form>
     </div>
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
       $('li[ID=nav-nav12]').removeAttr('').attr('class','active');
    </script>
    	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script type="text/javascript">
    	
    	function save(){
    		if($("#ifstu").contents().find("#url").val()!=""){
				$("#iconid").val($("#ifstu").contents().find("#url").val());
			}
    		var ids = $("#id").val();
    		/* if(!checkExit($("#numbers").val())){
    			return false;
    		} */
    		if($("#globalization").val()==''){
    			layer.msg("英文名不能为空",1,2);
    			return false;
    		}
    		if(ids==""){
    			if(confirm("确定保存该信息吗？")){
                    $.ajax({
                    	url:'/operator/moduleSave',
                    	type:'post',
                    	data:$("#operatorForm").serialize(),
                    	dataType:'json',
                    	success:function(data){
                    		if(data){
                    			layer.msg("保存成功",1,1);
                    		}else{
                    			layer.msg("保存异常",1,2);
                    		}
                    		setTimeout("parent.window.location.reload()",1000);
                    	}
                    })
				}
    		}else{
    			if(confirm("确认修改该信息吗？")){
    				$.ajax({
                    	url:'/operator/moduleUpdate',
                    	type:'post',
                    	data:$("#operatorForm").serialize(),
                    	dataType:'json',
                    	success:function(data){
                    		if(data){
                    			layer.msg("更新成功",1,1);
                    		}else{
                    			layer.msg("更新异常",1,2);
                    		}
                    		setTimeout("parent.window.location.reload()",1000);
                    	}
                    })
    			}
    		}
    		
    	}
    	
    	function addchildmodule(value){
    		if(value==""){
    			$("#num").show();
    			$("#showicon").show();
    		}else{
    			$("#num").hide();
    			$("#showicon").hide();
    		}
    	}
    	
    	function checkExit(value){
    		$("#urlmsg").html("");
    		var flag = false;
    		$.ajax({
    			url : "${cxt}/operator/checkModulenumExit",
    	   		type : "post",
    	   		data:{"num":value,"id":$("#id").val()},
    	   		dataType : "json",
    	   		async:false,
    	   		success : function(code) {
    	   			if(code==0){
    	   				$("#nummsg").html("");
    	   				flag = true;
    	   			}else{
    	   				$("#numbers").focus();
    	   				$("#nummsg").html(data.msg);
    	   				flag =  false;
    	   			}
    	   		}
    		});
    		return flag;
    	}
    	$(document).ready(function() {
			setTimeout("sss()",1000);
		});
		function sss(){
			var name='${name}';
			if(name!=""&&name!=null){
				$("#ifstu").contents().find("#pic").html('<img  src="/images/lefticon/'+name+'" style="width: 62px; height: 62px;">');
				$("#ifstu").contents().find("#common").hide();
			}
		}
    </script>
    
</body>
</html>
