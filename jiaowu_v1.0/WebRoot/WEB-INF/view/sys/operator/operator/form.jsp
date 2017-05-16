<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
 <%@ include file="/common/headExtraction.jsp"%>
</head>
<body style="background: white;">
     <div class="ibox-content">
         <form action="" method="post" id="operatorForm">
					<input type="hidden" id="id" name="operator.id" value="${operator.id}"/>
					<input type="hidden" name="operator.version" value="${operator.version}">
					<fieldset>
						<p>
							<label >模块名称：</label>
								<input type="hidden" id="modulenames" name="operator.modulenames" value="${operator.modulenames}"/>
								<select name="operator.moduleids" onchange="changemodule(this.value)" class="chosen-select" style="width: 186px" tabindex="2" >
									<option value="" >--${_res.get('Please.select')}--..</option>
									<c:forEach items="${modulelists }" var="module"  >
										<option value="${module.id }" ${operator.moduleids eq module.id ? "selected='selected'" : "" }  >${module.names }</option>
									</c:forEach>
								</select>
								<c:forEach items="${modulelists }" var="modulelist">
								<input id="module_${modulelist.id }" type="hidden" value="${modulelist.names }" >
							</c:forEach>
								
							</p>
						<p>
							<label >${_res.get('admin.dict.property.name')}</label>
								<input type="text" id="operatorNames" name="operator.names" value="${operator.names}" 
									class="input-xlarge" maxlength="25" vMin="2" vType="length" onblur="onblurVali(this);">
							</p>
						<p>
							<label >权限验证</label>
								<select name="operator.privilege" class="combox" id="operatorPrivilege">
									<option value="0" ${operator.privilege == "0" ? "selected='selected'":"" }>${_res.get('admin.common.no')}</option>
									<option value="1" ${operator.privilege == "1" ? "selected='selected'":"" }>${_res.get('admin.common.yes')}</option>
								</select>
								</p>
						<p>
							<label>url</label>
								<input type="text" id="operatorurl" name="operator.url" value="${operator.url}" 
									class="input-xlarge" maxlength="200" vMin="1" vType="length" onblur="onblurVali(this);" >
						</p>
						<p>
							<label >是否分页</label>
								<select name="operator.splitpage" class="combox" id="operatorSplitpage">
									<option value="0" ${operator.splitpage == "0" ? "selected='selected'":"" }>${_res.get('admin.common.no')}</option>
									<option value="1" ${operator.splitpage == "1" ? "selected='selected'":"" }>${_res.get('admin.common.yes')}</option>
								</select>
							</p>
					<%-- 	<p>
							<label >行级过滤</label>
								<select name="operator.rowfilter" class="combox">
									<option value="0" ${operator.rowfilter == "0" ? "selected='selected'":"" }>${_res.get('admin.common.no')}</option>
									<option value="1" ${operator.rowfilter == "1" ? "selected='selected'":"" }>${_res.get('admin.common.yes')}</option>
								</select>
							</p>
						<p>
							<label >重复提交验证</label>
								<select name="operator.formtoken" class="combox">
									<option value="0" ${operator.formtoken == "0" ? "selected='selected'":"" }>${_res.get('admin.common.no')}</option>
									<option value="1" ${operator.formtoken == "1" ? "selected='selected'":"" }>${_res.get('admin.common.yes')}</option>
								</select>
						</p> --%>
						<p>
							<label >IP验证</label>
								<select name="operator.ipblack" class="combox" id="operatorIpblack">
									<option value="0" ${operator.ipblack == "0" ? "selected='selected'":"" }>${_res.get('admin.common.no')}</option>
									<option value="1" ${operator.ipblack == "1" ? "selected='selected'":"" }>${_res.get('admin.common.yes')}</option>
								</select>
							</p>
						<%-- <p>
							<label >返回url</label>
								<input type="text" name="operator.returnurl" value="${operator.returnurl}" 
									class="input-xlarge" maxlength="200" vMin="0" vType="length" onblur="onblurVali(this);">
						</p> --%>
						<c:if test="${operatorType eq 'update'}">
						<p>
							<label>formaturl：</label>
								<input type="text" id="formaturl" name="operator.formaturl" value="${operator.formaturl}" 
									class="input-xlarge" maxlength="100" vMin="0" vType="length" onblur="onblurVali(this);" onchange="checkExit(this.value)" >
								<span id="urlmsg" style="color:red;" >*</span>
						</p>
						</c:if>
						<p>
							<c:if test="${operatorType eq 'add'}">
								<input type="button" value="${_res.get('save')}" onclick="return save();" class="btn btn-outline btn-success" />
								<input type="checkbox" id="checkboxChecked">不关闭窗口,继续添加
								<h3>常用提示:list,add,save,edit,update,delete,checkExit</h3>
							</c:if>
							<c:if test="${operatorType eq 'update'}">
								<input type="button" value="${_res.get('update')}" onclick="return save();" class="btn btn-outline btn-success" />
							</c:if>
						</p>
					</fieldset>
				</form>
				<div id="mytishikuang" style="color: #0F0;background-color: #000;width: 100%;" ></div>
     </div>
<script type="text/javascript">
	var mjici=0;
 
 	function changemodule(obj){
 		var ids = "module_"+obj;
 		$("#modulenames").val($("#"+ids).val());
 		/* $("#scuserid").trigger("chosen:updated"); */
 	}
 	
 	function save(){
 		var ids = $("#id").val();
 		var flag = checkExit($("#formaturl").val());
 		if(!flag){
 			return false;
 		} 
 		mytishikuang("．·°∴ ☆．．·°．·°∴ ☆．．·°．·°∴ ☆．．·°．·°∴ ☆．．·°．·°∴ ☆．．·°");
		mytishikuang(" 模块:"+$('#modulenames').val()+" 功能名:"+$("#operatorNames").val() + " URL:"+$('#operatorurl').val()+
				" 权限:"+($('#operatorPrivilege').val()==0?"否":"是")+ " 分页:"+($('#operatorSplitpage').val()==0?"否":"是")+ 
				" IP限制:"+($('#operatorIpblack').val()==0?"否":"是")   );
 		if(ids==""){
 			if(confirm("确定保存该信息吗？")){
 				$.ajax({
				type:"post",
				url:"${cxt}/operator/save",
				data:$('#operatorForm').serialize(),// 你的formid
				datatype:"json",
				success : function(code) {
						 if(code){
							 if($("#checkboxChecked").is(":checked")){
								 mytishikuang("．·°∴ ☆．．·°恭喜保存成功O(∩_∩)O~恭喜保存成功．·°∴ ☆．．·°");
								 $("#operatorNames").val("")
							 }else{
								setTimeout("parent.layer.close(index)", 3000);
								parent.window.location.reload();
							 }
						 }else{
							 layer.msg("保存失败",1,2);
							 mytishikuang("(┬＿┬)保存失败");
						 } 
					 }	
				});
			}
 		}else{
 			if(confirm("确认修改该信息吗？")){
 				$.ajax({
			type:"post",
			url:"${cxt}/operator/update",
			data:$('#operatorForm').serialize(),// 你的formid
			datatype:"json",
			success : function(code) {
				 if(code){
					setTimeout("parent.layer.close(index)", 3000);
					parent.window.location.reload();
				 }else{
					 layer.msg("保存失败",1,2);
				 } 
			}	
		});
 			}
 		}
 		
 	}
 	
 	function checkExit(value){
		$("#urlmsg").html("");
 		var flag = false;
 		$.ajax({
 			url : "${cxt}/operator/checkUrlExit",
 	   		type : "post",
 	   		data:{"url":value,"id":$("#id").val()},
 	   		dataType : "json",
 	   		async:false,
 	   		success : function(code) {
 	   			if(code==0){
 	   				$("#urlmsg").html("");
 	   				flag = true;
 	   			}else{
 	   				$("#operatorurl").focus();
 	   				$("#urlmsg").html("Url系统已存在 ");
 	   				flag =  false;
 	   			}
 	   		}
 		});
 		return flag;
 	}
 
 	function mytishikuang(mhtml){
		$('#mytishikuang').prepend((mjici)+">&nbsp;&nbsp;"+mhtml+("<br/>"));
		mjici=mjici+1;
	}
 </script>
    
</body>
</html>
