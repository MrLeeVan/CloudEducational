<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script id=clientEventHandlersVBS type="text/javascript">
var isrun;
function readcard(){
	var strls =  IDCardReader.getcardid();
	if(strls != ""){
		$("#cardNumber").val(strls);
		IDCardReader.pcdbeep (100);//100表示响100毫秒
	}
}
</script>
<OBJECT CLASSID="clsid:E64532A5-6F77-4967-9774-3D2141854991" id="IDCardReader" VIEWASTEXT width="0" height="0"></OBJECT>
<p>
	<label>校园卡卡号:</label> 
	<input type="text" id="cardNumber" name="cardNumber" value="${student.cardNumber}"/>
	<INPUT type="button" value="读卡" onclick="javascript:readcard()" class="btn btn-outline btn-primary">
	<span id="cardNumberMsg" style="color:red">*读卡功能必须使用IE11浏览器进行操作</span>
</p>
