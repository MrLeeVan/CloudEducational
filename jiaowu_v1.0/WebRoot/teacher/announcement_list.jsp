<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>已发消息</title>
<meta name="save" content="history">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet"/>
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 h5{
   font-weight: 100 !important
 }
</style>
</head>
<body id="body" style="min-width:1100px;">   
	<div id="wrapper" style="background: #2f4050;height:100%;">
	 <%@ include file="/common/left-nav.jsp"%>
	 <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			   <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>

        <div class="margin-nav2">
		<form action="/teacher/queryAllAnnouncement" method="post" id="searchForm" >
			<div  class="col-lg-12 m-t-xzl" style="padding-left:0;">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
						<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a>
						&gt;<a href='/teacher/queryAllAnnouncement'>消息中心</a> &gt; 已发消息
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
					<label>标题：</label>&nbsp;
					<input type="text"  name="_query.title" style="width:150px;" value="${paramMap['_query.title']}">
					<label>发送日期：</label>&nbsp;
					<input type="text" class="layer-date" readonly="readonly" id="date1" name="_query.data1" value="${paramMap['_query.data1']}" style="margin-top: -8px; width:120px" /> 
				    <input type="button" onclick="search()" value="${_res.get('admin.common.select') }" class="btn btn-outline btn-info">
			      	<input type="button" onclick="sendNews()" class="btn btn-outline btn-info" value="${_res.get('Send_announcement')}">
			      <div style="clear: both;"></div>
			   </div>
			 </div>
		   </div>

			<div class="col-lg-12" style="padding-left:0;">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>已发消息</h5>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
							<tr align="center">
								<th width="5%;" >${_res.get("index") }</th>
								<th width="10%;" style="height:10%;line-height: 34px;">发送人</th>
								<th width="10%;" style="height:10%;line-height: 34px;">发送时间</th>
								<th width="10%;" style="height:10%;line-height: 34px;">接收人</th>
								<th width="10%;" style="height:5%;line-height: 34px;">状态</th>
								<th width="20%;" style="height:20%;line-height: 34px;">回复</th>
								<th width="20%;" style="height:20%;line-height: 34px;">标题</th>
								<th width="15%;" style="height:10%;line-height: 34px;">操作</th>
							</thead>
							<c:forEach items="${showPages.list}" var="c" varStatus="index">
								<tr align="center">
									<td rowspan="${c.row}">${index.count }</td>
									<td rowspan="${c.row}">${c.fsr}</td>
									<td rowspan="${c.row}">
									<fmt:formatDate value="${c.sendtime}" type="time" 
									timeStyle="full" pattern="yyyy-MM-dd hh:mm:ss"/>
									</td>
									<td rowspan="1">${c.firstmessage.REAL_NAME}</td>
									<td rowspan="1"> ${c.firstmessage.state==0?'未读':'已读'}</td>
									<td rowspan="1">${c.firstmessage.reply}</td>
									<td rowspan="${c.row}">${c.title}</td>
									<td align="center" rowspan="${c.row}">
										<a href="javascript:void(0)" onclick="viewMessage(${c.id})" >详情</a>&nbsp;|
										<a href="javascript:void(0)" onclick="deleteMessage(${c.id})" >删除</a>
									</td>
								</tr>
								<c:forEach items="${c.rlist}" var="r"> 
									<tr align="center">
										<td>${r.REAL_NAME}</td>
										<td>${r.state==0?'未读':'已读'}</td>
										<td>${r.reply}</td>
									</tr>
								</c:forEach>
							</c:forEach>
						</table>
						<div id="splitPageDiv">
							<jsp:include page="/common/splitPage.jsp" />
						</div>
					</div>
				</div>
			</div>
			<div style="clear:both "></div>
		</form>
		</div>
	   </div>
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
	
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
    <script type="text/javascript">
    /*发送*/
    function sendNews(){
		$.layer({
    		type:2,
    		shadeClose:true,
    		title:"发送信息",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['900px','620px'],
    		iframe:{src:'${cxt}/teacher/sendMessage'}
    	});
	}
    /*详情*/
    function viewMessage(id){
		$.layer({
    		type:2,
    		shadeClose:true,
    		title:"详情",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['900px','620px'],
    		iframe:{src:'${cxt}/teacher/viewAnnouncement/'+id}
    	});
	}
    /*删除*/
    function deleteMessage(id){
		if(confirm("确定删除吗?")){
			$.ajax({
				url : "/teacher/deleteTeacherSendMessage",
				data : {'id':id},
				type : "post",
				dataType : "json",
				success:function(data){
					if(data==0){
						layer.msg("删除成功",1,1);
					}else{
						layer.msg("删除失败，请联系管理员",2,1);
					}
					setTimeout("window.location.reload();",1000);
				}
			})
		}
	}
    </script>
  		<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				date2.min = datas; //开始日选好后，重置结束日的最小日期
				date2.start = datas //将结束日的初始值设定为开始日
			}
		};
		laydate(date1);
	</script>
	
  	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
</body>
</html>