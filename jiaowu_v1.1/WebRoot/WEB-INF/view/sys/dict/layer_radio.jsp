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

	<script type="text/javascript">
		
		var setting = {
			async: {
				enable : true,
				url : '/system/dict/treeData',
				autoParam : ["id=id"], 
				dataFilter : filter,
				type : "post"
			},
			view: {
				fontCss: getFont,
				expandSpeed:"",
				selectedMulti: false
			},
			check: {
				enable: true,
				chkStyle: "radio",
				radioType: "all"
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
				beforeAsync: beforeAsync,	//用于捕获异步加载之前的事件回调函数,zTree 根据返回值确定是否允许进行异步加载
				onAsyncSuccess: onAsyncSuccess,	//用于捕获异步加载出现异常错误的事件回调函数
				onAsyncError: onAsyncError,	//用于捕获异步加载正常结束的事件回调函数
				
				beforeCheck: beforeCheck,
				onCheck: onCheck
			}
		};
		
		//节点数据过滤 + 默认选中
		var deptIds = '${checkedIds},';
		function filter(treeId, parentNode, childNodes) {
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
				
				if(deptIds != '' && deptIds.indexOf(childNodeId + ',') != -1){
					zTree.checkNode(childNode, true, false, false);
				}
			}
			return childNodes;
		}
		
		//字体设置
		function getFont(treeId, node) {
			return { 'font-weight' : 'bold' };
		}
		
		

		//用于捕获异步加载之前的事件回调函数,zTree 根据返回值确定是否允许进行异步加载
		function beforeAsync() {
			curAsyncCount++;
		}
		
		//用于捕获异步加载出现异常错误的事件回调函数
		function onAsyncSuccess(event, treeId, treeNode, msg) {
			curAsyncCount--;
			if (curStatus == "expand") {
				expandNodes(treeNode.children);
			} else if (curStatus == "async") {
				asyncNodes(treeNode.children);
			}

			if (curAsyncCount <= 0) {
				if (curStatus != "init" && curStatus != "") {
					//$("#demoMsg").text((curStatus == "expand") ? "全部展开完毕" : "后台异步加载完毕");
					asyncForAll = true;
				}
				curStatus = "";
			}
		}

		//用于捕获异步加载正常结束的事件回调函数
		function onAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {
			curAsyncCount--;

			if (curAsyncCount <= 0) {
				curStatus = "";
				if (treeNode!=null) asyncForAll = true;
			}
		}
		
		var curStatus = "init", curAsyncCount = 0, asyncForAll = false, goAsync = false;
		function expandAll() {
			if (!check()) {
				return;
			}
			var zTree = $.fn.zTree.getZTreeObj("zTreeContent");
			if (asyncForAll) {
				//$("#demoMsg").text("已经异步加载完毕，使用 expandAll 方法");
				zTree.expandAll(true);
			} else {
				expandNodes(zTree.getNodes());
				if (!goAsync) {
					//$("#demoMsg").text("已经异步加载完毕，使用 expandAll 方法");
					curStatus = "";
				}
			}
		}
		
		function expandNodes(nodes) {
			if (!nodes) {
				return;
			}
			curStatus = "expand";
			var zTree = $.fn.zTree.getZTreeObj("zTreeContent");
			for (var i=0, l=nodes.length; i<l; i++) {
				zTree.expandNode(nodes[i], true, false, false);
				if (nodes[i].isParent && nodes[i].zAsync) {
					expandNodes(nodes[i].children);
				} else {
					goAsync = true;
				}
			}
		}

		function asyncAll() {
			if (!check()) {
				return;
			}
			var zTree = $.fn.zTree.getZTreeObj("zTreeContent");
			if (asyncForAll) {
				//$("#demoMsg").text("已经异步加载完毕，不再重新加载");
			} else {
				asyncNodes(zTree.getNodes());
				if (!goAsync) {
					//$("#demoMsg").text("已经异步加载完毕，不再重新加载");
					curStatus = "";
				}
			}
		}
		function asyncNodes(nodes) {
			if (!nodes) {
				return;
			}
			curStatus = "async";
			var zTree = $.fn.zTree.getZTreeObj("zTreeContent");
			for (var i=0, l=nodes.length; i<l; i++) {
				if (nodes[i].isParent && nodes[i].zAsync) {
					asyncNodes(nodes[i].children);
				} else {
					goAsync = true;
					zTree.reAsyncChildNodes(nodes[i], "refresh", true);
				}
			}
		}

		function reset() {
			if (!check()) {
				return;
			}
			asyncForAll = false;
			goAsync = false;
			//$("#demoMsg").text("");
			$.fn.zTree.init($("#zTreeContent"), setting);
		}

		function check() {
			if (curAsyncCount > 0) {
				//$("#demoMsg").text("正在进行异步加载，请等一会儿再点击...");
				return false;
			}
			return true;
		}

		//////////////////选中事件处理////////////////////
		
		var className = "dark", checkedNodeIds = "${checkedIds}", checkedNodeName = "${checkedName}";
		
		function beforeCheck(treeId, treeNode) {
			className = (className === "dark" ? "":"dark");
			return (treeNode.doCheck !== false);
		}
		
		function onCheck(e, treeId, treeNode) {
			checkedNodeIds = treeNode.id;
			checkedNodeName = treeNode.name;
		}
		
		function setCheckValue(){
			parent.setCheckValue(checkedNodeIds,checkedNodeName);
			
		}
		
		//////////////////初始化////////////////////

		$(document).ready(function(){
			$.fn.zTree.init($("#zTreeContent"), setting);
			
			//$("#expandAllBtn").bind("click", expandAll);	//全部展开
			//$("#asyncAllBtn").bind("click", asyncAll);	//背后展开
			//$("#resetBtn").bind("click", reset);	//重置
			
				
			
		});

		setTimeout(function(){
			asyncAll();
		}, 500);

		
		function changeWindowHeight(){
			var contentHeight = $("#divContent").height();
			var newHeight = Number(contentHeight) + 50;
			
			parent.changeIframeHeight(newHeight);
		}
		
</script>
	<style>
	.baocun{
	  border-radius: 3px;
	  font-size:15px;
	  text-
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
	body{background: #fff none repeat scroll 0 0;}
	</style>
</head>
<body  >
	<div class="margin-nav" style="width:100%;margin-left:0;">
    <div style="margin:0 0 0 200px">
    	<input type="button" value="选择" onclick="setCheckValue();" class="baocun" />
    </div>
	<div class="ibox-content" id="divContent">
		<div class="content_wrap">
			<div class="modal-body" >
				<ul id="zTreeContent" class="ztree"></ul>
			</div>
		</div>
    </div>
    <div style="margin:0 0 0 200px">
    	<input type="button" value="选择(快捷键)" onclick="setCheckValue();" class="baocun" style="width: 100px;"/>
    </div>
    </div>
</body>
</html>