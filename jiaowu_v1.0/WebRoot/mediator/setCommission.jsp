<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>

<script type="text/javascript">

	function setCommission(){
		var index = parent.layer.getFrameIndex(window.name);
		if(confirm("确定提交此次设置？")){
			$.ajax({
	            type: "post",
	            url:"${cxt}/mediator/setCommission",
	            data:$('#form').serialize(),// 你的formid
	            async: false,
	            error: function(request) {
	                alert("Connection error");
	            },
	            success: function(data) {
	            	if(data.code=="1"){
	            		parent.layer.msg(data.msg,2,6);
	            		parent.layer.close(index);
	            	}else if(data.code=="0"){
	            		parent.layer.msg(data.msg,2,7);
	            		//回填？？？
	            	}
	            }
	        });
		}
	}
	
	function closeIndex(){
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.close(index);
	}
	
</script>

<style type="text/css">
label {
	width: 90px;
}
</style>

</head>
<body style="background: white;">
	<div class="ibox-content">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0;position:fixed;width:100%;background-color:#fff;">
				<div class="navbar-header" style="margin: 15px 0 0 30px;">
					<p>
						<label>渠&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;道:</label>
						<span id="realname">${mediator.REALNAME }</span>
					</p>
				</div>
			</nav>
		</div>
		<div class="col-lg-9" style="margin-top:50px;width:100%;">
			<div class="ibox float-e-margins">
				<div class="ibox-content" >
					<form action="" method="post" id="form">
						<input type="hidden" id="mediatorId" name="mediator.id"  value="${mediator.ID}">
						<fieldset style="width: 100%; overflow: hidden;">
							<p>
								<label>${_res.get('Rebate.rate')}：</label>
								<input type="text" id="proportion" name="mediator.ratio" value="${mediator.ratio }" />%
							</p>
							<p>
								<label>${_res.get('Bank.name')}：</label>
								<input type="text" id="bankname" name="mediator.bankname" value="${mediator.BANKNAME }" />
							</p>
							<p>
								<label>${_res.get('Bank.card.number')}：</label>
								<input type="text" id="cardId" name="mediator.bankcard" value="${mediator.BANKCARD }" />
							</p>
							<p>
								<label>${_res.get('Cardholder')}：</label>
								<input type="text" id="holder" name="mediator.cardholder" value="${mediator.CARDHOLDER }" />
							</p>
							<p>
							<c:if test="${operator_session.qx_mediatorsetCommission }">
								<input type="submit" class="btn btn-outline btn-primary" value="${_res.get('save')}" onclick="setCommission()"  /> 
							</c:if>
								<input type="button" class="btn btn-outline btn-warning" value="${_res.get('system.reback')}" onclick="closeIndex();" value="${_res.get('system.reback')}" /> 
							</p>
						</fieldset>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
	$(".chosen-select").chosen({disable_search_threshold:30});
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

 
</body>
</html>