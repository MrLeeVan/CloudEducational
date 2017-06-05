$(document).ready(function() {
	/* 自定义函数开始 */
	
	//-- 注册列表 拖动  --//
	$('.float-e-margins').draggable({ axis: "x" , distance: 40 , cancel: ".copy,input,textarea,select,table" });
	
	//载入layer拓展模块 
	layer.use('extend/layer.ext.js');
	
	$(".chosen-select").chosen({
		disable_search_threshold : 10
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
	
	//弹窗请求
	$(".layerIframe").on("click", function() {
		var _this = $(this);
		var width = _this.attr("data-width");
		var height = _this.attr("data-height");
		
		$.layer({
			type : 2,
			shadeClose : true,
			title : _this.attr("data-title"),
			closeBtn : [ 0, true ],
			shade : [ 0.5, '#000' ],
			border : [ 0 ],
			offset : [ '20px', '' ],
			area : [ (width==null?400:width) + 'px', (height==null?600:height) + 'px' ],
			iframe : {
				src : _this.attr("data-url")
			}
		});
	});

	//0，1，-1 的请求
	$(".customAjax").on("click", function() {
		var _this = $(this);
		if(confirm('确认'+(_this.attr("data-title"))+'吗？')){
			$.ajax({
				type : "post",
				url : _this.attr("data-url"),
				datatype : "json",
				success : function(returnValue) {
					if (1 == returnValue || returnValue == true) {
						layer.msg(_this.attr("data-title") + "成功", 1, 2);
						parent.window.location.reload();
					} else if ((-1) == returnValue) {
						layer.msg(_this.attr("data-title") + "异常", 1, 2);
					} else {
						layer.msg(_this.attr("data-title") + "失败", 1, 2);
					}
				}
			});
		}
	});
	
	//保存
	$(".submitButton").on("click", function() {
		var mthis = $(this);
		var submitForm = $('.submitForm');
		$.ajax({
			type : "post",
			url : submitForm.attr("action"),
			data : submitForm.serialize(),
			datatype : "json",
			success : function(returnValue) {
				if (1 == returnValue || returnValue==true) {
					layer.msg("保存成功", 1, 2);
					if("true"==mthis.attr("data-success")){
						self.location=document.referrer;
					}else{
						parent.window.location.reload();
					}
				} else if ((-1) == returnValue) {
					layer.msg("保存异常", 1, 2);
				} else {
					layer.msg("保存失败", 1, 2);
				}
			}
		});
	});
	
	//压缩预览
	compressionPreview(".compressionPreview");
	
	
});

/**xlsName=xls文件名称, downloadUrl=xls模版渲染路径, downloadDataFormId=查询时的表单id , preview=true是文件预览 */
function excelExport(xlsName, downloadUrl, downloadDataFormId, preview){
	try {
		var downloadDataFormData = $("#"+downloadDataFormId).serialize();
		downloadUrl = downloadUrl + "%3F" + escape(downloadDataFormData);
		var mhref = "/tool/excel/export?name="+ (escape(xlsName)) +"&downloadUrl="+downloadUrl+"&preview="+(preview==false?"false":"preview");
		console.log("导出数据:序列Form表单内容=", mhref);
    	var mhtml = '<form target="_blank" action="'+mhref+'" method="post" id="excelExport_form"></form>'
    	$("#excelExport_form").remove();
    	$("#"+downloadDataFormId).append(mhtml);
    	$("#excelExport_form").trigger("submit");
	} catch (e) {
		console.log("导出数据:序列Form表单出问题了", e);
	}
}

//压缩预览
function compressionPreview(compressionPreview){
	$(compressionPreview).each(function(){
		var mthis = $(this);
		var mhtml = mthis.html();
		if(mhtml.length > 0){
			var sublength = mthis.data("sublength");
			sublength = sublength != null ? sublength : 6;
			if(mhtml.length > sublength){
				mthis.empty();
				mthis.append("<div style='display: none;'>" + mhtml + "<a>[Close]</a></div>");
				var mhtml_sub = mhtml.substr(0,sublength);
				mthis.append("<div>" + mhtml_sub + "...<a>[Open]</a></div>");
				mthis.find("a").click( function () {
					var m_a_this = $(this);
					m_a_this = m_a_this.parent();
					m_a_this.hide();
					m_a_this.siblings().show();
				});
			}
		}
	});
}











