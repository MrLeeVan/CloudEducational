<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- Chosen -->
	<script type="text/javascript" src="${cxt }/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
	$(".chosen-select").chosen({disable_search_threshold:10});
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
	<script type="text/javascript" src="${cxt }/js/js/plugins/layer/layer.min.js"></script>
	<script type="text/javascript" >
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    
    <!-- Mainly scripts -->
    <script type="text/javascript" src="${cxt }/js/js/bootstrap.min.js?v=1.7"></script>
    <script type="text/javascript" src="${cxt }/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script type="text/javascript" src="${cxt }/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script type="text/javascript" src="${cxt }/js/js/hplus.js?v=1.7"></script>
    <script type="text/javascript" src="${cxt }/js/js/plugins/layer/laydate/laydate.dev.js"></script>
    <script type="text/javascript" src="${cxt }/js/utils.js" ></script>