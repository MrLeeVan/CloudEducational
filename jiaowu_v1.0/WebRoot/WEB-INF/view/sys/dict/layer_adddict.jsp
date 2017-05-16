<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<%@ include file="/common/headExtraction.jsp" %>
</head>
<body style="background:#fff;">
      <div class="ibox-content" >
         <form action="" method="post" id="dictForm">
			<input type="hidden" id="id" name="dict.id" value="${dict.id}"/>
			<c:if test="${!empty dict.id }">
				<input type="hidden" name="dict.version" value="${dict.version +1}">
			</c:if>
			<fieldset>
			<input type="hidden" id="oldParentId" name="oldParentId" value="${dict.parentid}" />
				<div class="control-group m-t-sm">
					<label class="input-s-sm">父级字典：&nbsp;</label>
						<input type="hidden" id="parentId" name="dict.parentid" value="${dict.parentid}"/>
						<input type="text" id="parentName" value="${dict.parentname }" 
							class="input-xlarge focused" readonly="readonly" maxlength="100" vMin="1"/>
						<button class="btn" type="button" onclick="dictRadioDiaLog('parentId', 'parentName', '${dict.parentid }');">选择</button>
						<span class="help-inline"></span>
				</div>
				<div style="clear:both;" ></div>
				<div class="control-group m-t-sm">
					<label class="input-s-sm" >名称：</label>
						<input type="text" name="dict.dictname" value="${dict.dictname }" id="dictname" class="input-xlarge" maxlength="30" vMin="1"/>
				</div>
				<div style="clear:both;" ></div>
				<div class="control-group m-t-sm" >
					<label class="input-s-sm" >编号：</label>
						<input type="text" id="numbers" name="dict.numbers" value="${dict.numbers }" 
							class="input-xlarge" maxlength="50" vMin="1"  onchange="checkExit(this.value)" />
						<span id="nummsg" style="color:red;" ></span>
						<input type="hidden" value="0" id="numCount" />
				</div>
				<div style="clear:both;" ></div>
				<div class="control-group m-t-sm" >
					<label class="input-s-sm" >状态：</label>
					<select name="dict.state" id="state"  class="btn btn-white" style="width: 208px" >
						<option value="1" <c:if test="${dict.state == 1 ||dict.state == null }" >selected="selected"</c:if>  >启用</option>
						<option value="0" <c:if test="${dict.state == 0 }" >selected="selected"</c:if>  >停用</option>
					</select>
				</div>
				<div style="clear:both;" ></div>
				<div class="control-group m-t-sm" >
					<label class="input-s-sm" >值：</label>
						<input type="text" id="val" name="dict.val" value="${dict.val}" class="input-xlarge" maxlength="25" >
				</div>
				<p>
					<c:if test="${operatorType eq 'add'}">
						<input type="button" value="保存" onclick="return save();" class="btn btn-outline btn-success" />
						<input type="checkbox" id="checkboxChecked">不关闭窗口,继续添加
					</c:if>
					<c:if test="${operatorType eq 'update'}">
						<input type="button" value="更新" onclick="return save();" class="btn btn-outline btn-success" />
					</c:if>
				</p>
			</fieldset>
		</form>
		<div id="mytishikuang" style="color: #0F0;background-color: #000;width: 100%;" ></div>
     </div>

    <script type="text/javascript">
    var mjici=0;
    
    $(function(){
    	var index = parent.layer.getFrameIndex(window.name);
    });
    
    /**
     * 字典单选
     * @param dictId 数据回填
     * @param dictName 数据回填
     * @param checkedIds 默认选中
     * @param rootNumbers 根节点编号
     * @param callback 回调
     */
    function dictRadioDiaLog(dictId, dictName, checkedIds ){
    	$.layer({
    		type: 2,
       	    shadeClose: true,
       	    title: "字典单选",
       	    closeBtn: [0, true],
       	    shade: [0.5, '#000'],
       	    border: [0],
       	    offset:['20px', ''],
       	    area: ['320px', '550px'],
       	    iframe: {src: "/system/dict/choiceParentDict?dictId="+dictId+"&&dictName="+dictName+"&&checkedIds="+checkedIds}
    		
    	});
    }
    
    function changeIframeHeight(newHeight){
    	$(".xubox_iframe").height(newHeight);
    }
    function setCheckValue(parentId,parentName){
    	$("#parentId").val(parentId);
    	$("#parentName").val(parentName);
    	
    	layer.closeAll('iframe');
    }
    
    function checkExit(val){
    	$.ajax({
    		url:"/system/dict/checkExit",
    		data:{"dictid":$("#id").val(),"numbers":val},
    		dataType:"json",
    		async:false,
    		success:function(result){
    			$("#numCount").val(result);
    			if(result!="0"){
    				$("#numbers").css("border","1px solid #ed5565");
    				layer.msg("编号已存在，请更换.");
    			}
    		}
    	});
    }
    
    function save(){
  		if($("#numbers").val()==null||$("#numbers").val()==""||$("#numCount").val()!="0"){
			$("#numbers").css("border","1px solid #ed5565");
			$("#numbers").focus();
  			return false;
  		}
  		
  		if($("#dictname").val()=="" || $("#dictname").val()==null){
			layer.msg("名称不能为空");
  			return false;
  		}
  		
  		if($("#val").val()=="" || $("#val").val()==null){
			layer.msg("名称不能为空");
  			return false;
  		}
  		
  		var dictid = $("#id").val();
  		var murl = "/system/dict/save";
    	if(!(Number(dictid))>0){
  			murl = "/system/dict/save";
    	}else{
  			murl = "/system/dict/update";
    	}
    	
    	mytishikuang("．·°∴ ☆．．·°．·°∴ ☆．．·°．·°∴ ☆．．·°．·°∴ ☆．．·°．·°∴ ☆．．·°");
		mytishikuang(" 名称:"+$('#dictname').val()+" 编码:"+$("#numbers").val() );
    	
    	var _serialize = $("#dictForm").serialize();
    	$.post(murl, _serialize,
  			   function(result){
		    		if(result){
		    			if($("#checkboxChecked").is(":checked")){
							 mytishikuang("．·°∴ ☆．．·°恭喜保存成功O(∩_∩)O~恭喜保存成功．·°∴ ☆．．·°");
							// $("#dictname").val("");
							 //$("#numbers").val("");
							 $("#val").val("");
						 }else{
							parent.search();
							var index = parent.layer.getFrameIndex(window.name);
					    	parent.layer.close(index);
						 }
					}else{
						parent.search();
						layer.msg("操作异常");
					}
  			   });
    }
    
    function mytishikuang(mhtml){
		$('#mytishikuang').prepend((mjici)+">&nbsp;&nbsp;"+mhtml+("<br/>"));
		mjici=mjici+1;
	}
    
    </script>
    
</body>
</html>
