<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
 <%@ include file="/common/headExtraction.jsp"%>
<title>添加表</title>
<style>
label{
   width:170px;
}
.chosen-select{
	width: 173px;
}
</style>
</head>
<body style="background: white;">
	<div class="ibox float-e-margins">
		<div class="ibox-content">
			<form action="${cxt}/system/table/save" method="post" id="submitForm">
				<fieldset>
					<div class="control-group m-t-sm flt">
						<label class="input-s-sm">表名： </label>
						<input type="text" name="tableIntroduction.tableName" value="${tableIntroduction.tableName}" maxlength="50" class="required" vMin="2" vType="checkTestName" onblur="onblurVali(this);" />
						<font color="red"> * <span id="tableIntroduction_tableName"></span></font>
					</div>
					<div style="clear:both;" ></div>
					<div class="control-group m-t-sm flt">
						<label class="input-s-sm">简介： </label>
						<input type="text" name="tableIntroduction.briefIntroduction" value="${tableIntroduction.briefIntroduction}" maxlength="50" class="required"/>
						<font color="red"> * </font>
					</div>
					<div style="clear:both;" ></div>
					<div class="control-group m-t-sm flt">
						<label class="input-s-sm">引擎： </label>
						<select name="tableIntroduction.tableEngine" class="chosen-select">
							<option value="InnoDB" selected="selected" >InnoDB</option>
						</select>
						<font color="red"> * </span></font>
					</div>
					<div style="clear:both;" ></div>
					
					<div class="control-group m-t-sm flt">
						<input type="button" value="保存" id="pageSave" class="btn btn-outline btn-primary" />
					</div>
					<div style="clear:both;" ></div>
				</fieldset>
			</form>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script type="text/javascript" src="/jquery/jquery-2.1.1.min.js"></script>

	<!-- Chosen -->
	<script type="text/javascript"
		src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script type="text/javascript">
		$(".chosen-select").chosen({
			disable_search_threshold : 20
		});
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
	<script type="text/javascript" src="/js/js/plugins/layer/layer.min.js"></script>
	<!-- //载入layer拓展模块  -->
	<script>
		layer.use('extend/layer.ext.js');
	</script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script type="text/javascript" src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script type="text/javascript"
		src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script type="text/javascript" src="/js/js/hplus.js?v=1.7"></script>

	<script type="text/javascript">
		/* 自定义函数开始 */
		$(document).ready(function() {
			//保存
			$("#pageSave").on("click", function() {
				var submitForm = $('#submitForm');
				$.ajax({
					type : "post",
					url : submitForm.attr("action"),
					data : submitForm.serialize(),
					datatype : "json",
					success : function(returnValue) {
						if (1==returnValue) {
							parent.window.location.reload();
						}else if((-1)==returnValue){
							layer.msg("保存异常",1,2);
						}else{
							layer.msg("保存失败",1,2);
						}
					}
				});
			});

		});
	</script>
</body>
</html>
