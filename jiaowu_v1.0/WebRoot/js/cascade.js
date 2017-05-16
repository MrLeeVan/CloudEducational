$(document).ready(function() {
	
	$(".querycascade").change(function() {
		console.log("------------querycascade-change----------------------");
		var _this = $(this);
		var _this_val = _this.val();
		var _this_id = _this.attr("id");
		console.log("子级联触发:"+(_this_id));
		if(_this_val != ""){
			console.log("为它的子级联加载数据:");
			$(".querycascade[data-sqlval='"+(_this_id)+"']").each(function(){
				var _each_this = $(this);
				_each_this.html('<option value="">加载中...</option>');
				var _each_this_id = _each_this.attr("id");
				var backfill_val = _each_this.attr("data-backfill");
				var _sqltable = _each_this.attr("data-sqltable");
				var _sql = _each_this.attr("data-sql");
				if(null==_sqltable) return;
				var _url = null == _sql ? "/front/reserve/queryExpression" : "/template/query";
				$.getJSON(_url, { "sqltable": _sqltable, "sql": _sql, "val": _this_val }, function(expression){
					
					var _html_option = '';
					if(expression.length <= 0){
						_html_option = '<option value="">没有更多数据</option>';
					}else{
						_html_option = '<option value="">全部</option>';
					}
					for (var i = 0; i < expression.length; i++) {
						_html_option = _html_option 
						+ '<option value="'+ (expression[i].VAL) +'" '+ (expression[i].VAL==backfill_val?'selected="selected"':'') +'>'+(expression[i].TEXT) +'&nbsp;'+ (i+1) +'</option>';
					}
					_each_this.html(_html_option);
					if(backfill_val !=null && backfill_val != ""){
						_each_this.attr("data-backfill","");
						setTimeout(function(){
							_each_this.trigger("change");
						}, 400);
					}else{
						$(".querycascade[data-sqlval='"+(_each_this_id)+"']").html('<option value="">全部</option>');
					}
				});
			});
		}else{
			$(".querycascade[data-sqlval='"+(_this_id)+"']").html('<option value="">全部</option>');
		}
	});
	
	//查询的级联
	$(".querycascade").not(".querycascadeKey").on("click", function() {
		var _this = $(this);
		var _sqlval = $("#" + (_this.attr("data-sqlval")));
		var _val = _sqlval.val();
		if(null==_val || ""==_val){
			layer.msg((_sqlval.prev().text())+"没有选择!", 1, 2);
		}
	});
	
	//回填
	$(".querycascadeKey").each(function (i){
		console.log("---------querycascadeKey-each-------------------------");
		var _this = $(this);
		var mKeyVal = _this.val();
		console.log("回填级联触发判断:");
		if(null!=mKeyVal && ""!=mKeyVal){
			console.log("回填级联已触发!");
			setTimeout(function(){
				_this.trigger("change");
			}, 300 * i);
		}
	});
	
});