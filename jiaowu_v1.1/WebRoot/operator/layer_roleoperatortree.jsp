<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>角色功能选择</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/zTreeStyle.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet"/>
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">

<!-- Morris -->
<script src="/js/js/ztree/jquery-1.4.4.min.js"></script>
<script src="/js/js/ztree/jquery.ztree.core-3.5.js"></script>
<script src="/js/js/ztree/jquery.ztree.excheck-3.5.js"></script>
<script src="/js/js/ztree/jquery.ztree.exhide-3.5.js"></script>

	<SCRIPT type="text/javascript">
		
		var setting = {
				async: {
					enable : true,
					dataFilter : filter
				},
			check: {
				enable: true
			},
			data: {
				key: {
					title: "title"
				},
				simpleData: {
					enable: true
				}
			},
			callback: {
				onCheck: onCheck
			}
		};

	 	 var zNodes = ${list};
	 
	
		 	var moduleIds = 'init';
			var operatorIds = '';
			function filter(treeId, parentNode, childNodes) {
				alert(moduleIds);
				if(moduleIds == 'init'){
					getCheckedByRole();
				}
				if (!childNodes) {
					return null;
				}
				var childNode;
				var childNodeId;
				var childNodeName;
				var zTree = $.fn.zTree.getZTreeObj("zTreeContent");
				for (var i=0, l=childNodes.length; i<l; i++) {
					childNode = childNodes[i];
					childNodeId = childNode.id;
					childNodeName = childNode.name;
					
					childNode.name = childNodeName.replace(/\.n/g, '.');
					
					if(moduleIds.indexOf(childNodeId + ',') != -1){
						zTree.checkNode(childNode, true, false, false);
					}else if(operatorIds.indexOf(childNodeId + ',') != -1){
						zTree.checkNode(childNode, true, false, false);
					}
				}
				return childNodes;
			}
	

	////////////////////////////////////////////////
	var className = "dark", checkedModuleNodeIds = "", checkedOperatorNodeIds = "";
	
	function beforeCheck(treeId, treeNode) {
		className = (className === "dark" ? "":"dark");
		return (treeNode.doCheck !== false);
	}
	
	function parentChecked(parentNode, checked){
		if(parentNode == null) return;
		var childrenNodes = parentNode.children;
		var length = childrenNodes.length;
		var checkedCount = 0;
		for (var i=0; i<length; i++) {
			var treeNode = childrenNodes[i];
			var checked = treeNode.checked;
			if(checked){
				checkedCount += 1;
			}
		}
		
		if(length == checkedCount){
			var id = parentNode.id + ",";
			if(checked && checkedModuleNodeIds.indexOf(id) == -1){
				checkedModuleNodeIds += id;
			}else{
				checkedModuleNodeIds = checkedModuleNodeIds.replace(id, "");
			}
			parentChecked(parentNode.getParentNode(), checked);
		}
	}
	
	function childrenCheck(nodes, checked) {
		if (!nodes) {
			return;
		}
		for (var i=0, l=nodes.length; i<l; i++) {
			var treeNode = nodes[i];
			var treeNodeId = treeNode.id;
			var id = treeNodeId + ",";
			
			if(treeNodeId.indexOf('module_') != -1){
				if(checked && checkedModuleNodeIds.indexOf(id) == -1){
					checkedModuleNodeIds += id;
				}else{
					checkedModuleNodeIds = checkedModuleNodeIds.replace(id, "");
				}
			}else if(treeNodeId.indexOf('operator_') != -1){
				if(checked && checkedOperatorNodeIds.indexOf(id) == -1){
					checkedOperatorNodeIds += id;
				}else{
					checkedOperatorNodeIds = checkedOperatorNodeIds.replace(id, "");
				}
			}
			
			childrenCheck(treeNode.children, checked);
		}
	}
	
	function onCheck(e, treeId, treeNode) {
		//alert(treeNode.tId + ", " + treeNode.name + "," + treeNode.checked);
		var treeNodeId = treeNode.id;
		var checked = treeNode.checked;
			
		var id = treeNode.id + ",";
		
		if(treeNodeId.indexOf('module_') != -1){
			if(checked && checkedModuleNodeIds.indexOf(id) == -1){
				checkedModuleNodeIds += id;
			}else{
				checkedModuleNodeIds = checkedModuleNodeIds.replace(id, "");
			}
		}else if(treeNodeId.indexOf('operator_') != -1){
			if(checked && checkedOperatorNodeIds.indexOf(id) == -1){
				checkedOperatorNodeIds += id;
			}else {
				checkedOperatorNodeIds = checkedOperatorNodeIds.replace(id, "");
			}
		}
		
		parentChecked(treeNode.getParentNode(), checked);
		childrenCheck(treeNode.children, checked);
	}
	
	function getCheckedByRole(){
		$.ajax({
		   	type: "POST",
		   	url: "/operator/getRoleOperator",
		   	data: 'ids=${ids}',
			async : false,
		   	success: function(data){
		   		if(data != "error"){
					//var json = eval(data);
					moduleIds = (data.MODULEIDS == null? '': data.MODULEIDS); 
					operatorIds = (data.OPERATORIDS == null? '': data.OPERATORIDS);
					checkedModuleNodeIds = moduleIds;
					checkedOperatorNodeIds = operatorIds;
		     	}else{
		     		alert("获取角色拥有的功能失败！");
		     	}
		   	}
		});
	}

	var index = parent.layer.getFrameIndex(window.name);
	function setCheckValue(){
		if(moduleIds != checkedModuleNodeIds || operatorIds != checkedOperatorNodeIds){
			$.ajax({
			   	type: "POST",
			   	url: "${cxt}/operator/setRoleOperator",
			   	data: { "ids" : "${ids}", "moduleIds" : checkedModuleNodeIds, "operatorIds" : checkedOperatorNodeIds},
				async : false,
				dataType:"json",
			   	success: function(data){
			   		if(data.code=="1"){
			   			parent.layer.msg("设置成功",2,6);
						parent.layer.close(index);
			     	}else{
			     		alert("设置角色拥有的功能失败！");
			     	}
			   	}
			});
		}else{
			alert("没有修改");
		}
	}
	////////////////////////////////////////

		/* function setTitle(node) {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			var nodes = node ? [node]:zTree.transformToArray(zTree.getNodes());
			for (var i=0, l=nodes.length; i<l; i++) {
				var n = nodes[i];
				n.title = "[" + n.id + "] isFirstNode = " + n.isFirstNode + ", isLastNode = " + n.isLastNode;
				zTree.updateNode(n);
			}
		}
		function count() {
			function isForceHidden(node) {
				if (!node.parentTId) return false;
				var p = node.getParentNode();
				return !!p.isHidden ? true : isForceHidden(p);
			}
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			checkCount = zTree.getCheckedNodes(true).length,
			nocheckCount = zTree.getCheckedNodes(false).length,
			hiddenNodes = zTree.getNodesByParam("isHidden", true),
			hiddenCount = hiddenNodes.length;

			for (var i=0, j=hiddenNodes.length; i<j; i++) {
				var n = hiddenNodes[i];
				if (isForceHidden(n)) {
					hiddenCount -= 1;
				} else if (n.isParent) {
					hiddenCount += zTree.transformToArray(n.children).length;
				}
			}

			$("#isHiddenCount").text(hiddenNodes.length);
			$("#hiddenCount").text(hiddenCount);
			$("#checkCount").text(checkCount);
			$("#nocheckCount").text(nocheckCount);
		} */

		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			getCheckedByRole();
		});
		
	</SCRIPT>
	<style>
	.baocun{
	  border-radius: 3px;
	  font-size:15px;
	  text-align:center;
	  line-height:30px;
	  width:50px;
	  height:30px;
	  color:#1c84c6;
	  display:block;
	  background: #fff;
	  border:1px solid #1c84c6;
	  cursor: pointer
	}
	.baocun:hover{
	  color:#fff;
	  background: #1c84c6;
	  text-decoration: none;
	}
	</style>
</head>
<body>
	<div class="margin-nav" style="width:100%;margin-left:0;">
	<div class="ibox-content">
		<div class="content_wrap">
			<div class="zTreeDemoBackground left">
				<ul id="treeDemo" class="ztree"></ul>
			</div>
		</div>
    </div>
    </div>
    <div style="margin:0 0 0 200px">
    	<input type="button" value="${_res.get('save')}" onclick="setCheckValue();" class="baocun" />
    </div>
</body>
</html>