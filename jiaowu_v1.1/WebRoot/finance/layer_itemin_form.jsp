<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>物品入库</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
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
.student_list_wrap {
    position: absolute;
    top: 35px;
    width: 199px;
    overflow: hidden;
    z-index: 2012;
    background: rgba(0, 223, 255, 0.84);
    border: 1px solide;
    border-color: #e2e2e2 #ccc #ccc #e2e2e2;
    padding: 6px;
    margin-top: 177px;
    margin-left: 104px;
}
.student_list_wrap li {
    display: block;
    line-height: 20px;
    padding: 4px 0;
    border-bottom: 1px dashed #676a6c;
    cursor: pointer;
    text-align: center;
    width: 63%;
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
		<div style="height:240px">
			<div style="margin-top: 10px;padding:15px;background:#fff">
				<form id="itemsForm" action="${cxt }/itemsManager/saveItemsIn" method="post">
					<fieldset>
						<input type="hidden" id="handletype" name="itemsOutIn.handletype" value="instorage" >
						<input type="hidden" id="itemsoutinid" name="itemsOutIn.id" value="${items.outinid}" >
						<input type="hidden" id="itemsinid" name="itemsOutIn.itemid" value="${items.itemid}" >
						<input type="hidden" id="operatorType" value="${operatorType }"/>
						<c:if test="${!empty items.id }">
							<input type="hidden" name="items.version" value="${items.version}">
						</c:if>
						<p>
							<label>物品名称：</label>
							${items.itemsname }
						</p>
						<p>
							<label>本次入库：</label>
							<input type="text" id="handlenum" name="itemsOutIn.handlenum" value="${items.handlenum }" size="20" />
						</p>
						<p>
							<label>${_res.get('course.remarks')}：</label> 
							<textarea rows="3" cols="85" name="itemsOutIn.remark" style="width:280px;margin-left: 0px;">${items.remark }</textarea>
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
			var handlenum = $("#handlenum").val().trim;
			if ($("#handlenum").val() == "" || $("#handlenum").val() == null) {
				$("#handlenum").focus();
				alert("请填写数量");
				return false;
			}else{
				var operatorType = $("#operatorType").val();
				if(operatorType=="add"){
					$.ajax({
                    	type:"post",
						url:"${cxt}/itemsManager/saveItemsIn",
						data:$('#itemsForm').serialize(),
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
					if(confirm("确定要修改该顾问信息吗？")){
						 $.ajax({
	                        	type:"post",
								url:"${cxt}/itemsManager/updateItemsOutIn",
								data:$('#itemsForm').serialize(),
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
		var birthday = {
			elem : '#birthday',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : true
		};
		laydate(birthday);
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