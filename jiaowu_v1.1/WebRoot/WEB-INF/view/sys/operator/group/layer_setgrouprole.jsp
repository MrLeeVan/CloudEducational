<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>角色管理</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet"/>
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">

<!-- Morris -->
<script src="/js/js/ztree/jquery-1.4.4.min.js"></script>
<script src="/js/js/ztree/jquery.ztree.core-3.5.js"></script>
<script src="/js/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script src="/js/js/ztree/jquery.ztree.exhide-3.5.js"></script>

<script type="text/javascript">
		
</script>
<script type="text/javascript">
	
	function addChecked(sNode){
		var index = sNode.selectedIndex;
		var option = sNode.options[index];
		option.selected = false;
		document.getElementById("checkedRole").add(option);
		setRole();
	}

	function delChecked(sNode){
		var index = sNode.selectedIndex;
		var option = sNode.options[index];
		option.selected = false;
		document.getElementById("allRole").add(option);
		setRole();
	}
	
	function setRole(){
		var checkedRole = document.getElementById("checkedRole");
		var length = checkedRole.length;
		var roleIds = "";
		for (var i=0; i<length; i++){
			roleIds += checkedRole.options[i].value + ",";
	    }
		
		var userIds = "${ids}";
		$.ajax({
			type : "post",
			url : "/operator/setGroupRoles",
			data : { "ids" : userIds, "roleIds" : roleIds },
			async: false,
			dataType:"json",
			success:function(code){
				if(code){
		   			parent.layer.msg("设置成功",2,6);
					parent.layer.close(index);
		     	}else{
		     		alert("设置角色失败！");
		     	}
			}
		});
	}
	
	var index = parent.layer.getFrameIndex(window.name);
	function setSaveValue(){
		parent.window.location.reload();
	}
	
</script>
<style type="text/css">
.boxes{
	padding:5px 30px
} 
.boxes .box_span4{
	float:left;
	width:140px;
}
.boxes .box_span5{
	float:left;
	width:140px;
	margin-left:20px
}
.boxes .box_span4 select{
	border: 1px solid #BBB;
	width:100%;
}
.boxes .box_span5 select{
	width:100%;
	border: 1px solid #BBB;
}
p{
  font-size:15px;
  font-weight: 900;
  margin:3px 0
}
.chev-lt{
  position: absolute;
  top:170px;
  left:175px
}
.chev-rt{
  position: absolute;
  top:190px;
  left:175px
}
</style>
</head>
<body style="background:#fff">
		<div class="boxes" >
			<div class="box_span4">
				<p>
					<i class="fa fa-user"></i> ${_res.get('admin.role.select.noChecked')}
				</p>
				<div class="box-content">
					<select id="allRole" multiple size="18" ondblclick="addChecked(this);" style="height:311px">
						<c:forEach items="${map.noCheckedList }" var="role" >
							<option value='${role.id}'>${role.names}</option>
						</c:forEach>
				  	</select>
				</div>
			</div>
			<span class="chev-lt"><i class="fa fa-chevron-right"></i></span>
			<span class="chev-rt"><i class="fa fa-chevron-left"></i></span>
			<div class="box_span5">
				<p>
					<i class="fa fa-user"></i> ${_res.get('admin.role.select.checked')}
				</p>
				<div class="box-content">
					<select id="checkedRole" multiple size="18" ondblclick="delChecked(this);" style="height:311px">
						<c:forEach items="${map.checkedList }" var="role" >
							<option value='${role.id}'>${role.names}</option>
						</c:forEach>
				  	</select>
				</div>
			</div>
		</div>
		<div style="clear: both;"></div>
		<div style="width:28px;margin:10px 0 0 280px;">
		    	<input type="button" value="${_res.get('save')}" onclick="setSaveValue();" class="btn btn-outline btn-primary" />
		</div>
    
</body>
</html>