<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>testtree</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/demo.css" rel="stylesheet" />
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
		/*  var zNodes =[
			{ id:'a', pId:0, name:"父节点1", title:"", checked:true, open:true},
			{ id:11, pId:'a', name:"父节点11", title:"", checked:true},
			{ id:111, pId:11, name:"叶子节点111", title:"", checked:true, isHidden:true},
			{ id:112, pId:11, name:"叶子节点112", title:""},
			{ id:113, pId:11, name:"叶子节点113", title:""},
			{ id:12, pId:'a', name:"父节点12", title:""},
			{ id:121, pId:12, name:"叶子节点121", title:""},
			{ id:122, pId:12, name:"叶子节点122", title:""},
			{ id:123, pId:12, name:"叶子节点123", title:""},
			{ id:2, pId:0, name:"父节点2", title:""},
			{ id:21, pId:2, name:"父节点21", title:""},
			{ id:211, pId:21, name:"叶子节点211", title:""},
			{ id:212, pId:21, name:"叶子节点212", title:""},
			{ id:213, pId:21, name:"叶子节点213", title:""},
			{ id:22, pId:2, name:"父节点22", title:""},
			{ id:221, pId:22, name:"叶子节点221", title:""},
			{ id:222, pId:22, name:"叶子节点222", title:""},
			{ id:223, pId:22, name:"叶子节点223", title:""}
		]; */ 

		function onCheck(e, treeId, treeNode) {
			count();
		}

		function setTitle(node) {
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
		}

		$(document).ready(function(){
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			$("#hideNodesBtn").bind("click", {type:"rename"}, hideNodes);
			$("#showNodesBtn").bind("click", {type:"icon"}, showNodes);
			setTitle();
			count();
		});
		
	</SCRIPT>
</head>
<body>
		<div class="content_wrap">
			<div class="zTreeDemoBackground left">
				<ul id="treeDemo" class="ztree"></ul>
			</div>
		</div>
	<!-- layer javascript -->
    
    
</body>
</html>