<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 

<style type="text/css">
body {
	background-color: #eff2f4
}
select {
	margin-left: 22px;
}
textarea {
	width: 50%;
	margin-left: 15px;
}
label {
	width: 100px;
}
.chosen-container .chosen-results{
    max-height:80px !important
}
.spanred{
    color:red
}
</style>
</head>
<body style="background: white;">
		<div style="height:350px">
			<div style="margin-top: 10px;padding:15px;background:#fff">
				<form id="remindForm" action="${cxt }/remindManager/save" method="post">
					<fieldset>
						<input type="hidden" id="remindId" name="remind.id" value="${remind.id }"/>
						<c:if test="${empty remind.id }">
							<input type="hidden" name="remind.stuid" value="${stuId}">
						</c:if>
						<c:if test="${!empty remind.id }">
							<input type="hidden" name="remind.version" value="${remind.version}">
						</c:if>
						<p>
							<label>标题：</label>
							<input type="text" id="title" name="remind.title" value="${remind.title }" size="20" />
							<span class="spanred">*</span>
						    <span id="realnameMes" class="spanred"></span>
						</p>
						<p>
							<label>提醒时间：</label>
							<input type="text" class="layer-date" readonly="readonly" id="remindtime" name="remind.remindtime" value="<fmt:formatDate value="${remind.remindtime}" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/>" size="20" />
						
						</p>
						<p>
							<label>${_res.get('course.remarks')}：</label> 
							<textarea rows="3" cols="85" name="remind.remark" style="width:280px;margin-left: 0px;">${fn:trim(remind.remark)}</textarea>
						</p>
						<p>
						<c:if test="${operatorType eq 'add'}">
							<input type="button" value="${_res.get('save')}" onclick="return save();" class="btn btn-outline btn-primary" />
						</c:if>
						<c:if test="${operatorType eq 'update'}">
							<input type="button" value="${_res.get('update')}" onclick="return save();" class="btn btn-outline btn-primary" />
						</c:if>
							<!-- <input type="button" onclick="window.history.go(-1)" value="${_res.get('system.reback')}" class="btn btn-outline btn-success"> -->
						</p>
					</fieldset>
				</form>
			</div>
		</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
		var config = {
			'.chosen-select' : {},
			'.chosen-select-deselect' : {
				allow_single_deselect : true
			},
			'.chosen-select-no-single' : {
				disable_search_threshold : 10
			},
			'.chosen-select-no-results' : {
				no_results_text : 'Oops, nothing found!'
			},
			'.chosen-select-width' : {
				width : "95%"
			}
		}
		for ( var selector in config) {
			$(selector).chosen(config[selector]);
		}
	</script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script>
		
		function save() {
			var title = $("#title").val().trim;
			if ($("#title").val() == "" || $("#title").val() == null) {
				$("#title").focus();
				$("#title").text("标题不能为空！");
				return false;
			}else{
				$("#realnameMes").text("");
				var remindId = $("#remindId").val();
				if(remindId==""){
					$.ajax({
                    	type:"post",
						url:"${cxt}/remindManager/save",
						data:$('#remindForm').serialize(),
						datatype:"json",
						success : function(data) {
							 if(data.code=='0'){
								layer.msg(data.msg,2,5);
							}else{
								setTimeout("parent.layer.close(index)", 3000);
								parent.window.location.reload();
							} 
						}
                    });
				}else{
					if(confirm("确定要修改提醒信息吗？")){
						 $.ajax({
	                        	type:"post",
								url:"${cxt}/remindManager/update",
								data:$('#remindForm').serialize(),
								datatype:"json",
								success : function(data) {
									 if(data.code=='0'){
										layer.msg(data.msg,2,5);
									}else{
										setTimeout("parent.layer.close(index)", 3000);
										parent.window.location.reload();
									} 
								}
	                        });
					}
				}
			}
		}
	</script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script>
		//日期范围限制
		var remindtime = {
			elem : '#remindtime',
			format : 'YYYY-MM-DD hh:mm:ss',
			max : '2099-06-16', //最大日期
			min : laydate.now(),
			istime : true,
			istoday : true
		};
		laydate(remindtime);
	</script>
	<script src="/js/utils.js"></script>
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script>
       $('li[ID=nav-nav8]').removeAttr('').attr('class','active');
    </script>
</body>
</html>