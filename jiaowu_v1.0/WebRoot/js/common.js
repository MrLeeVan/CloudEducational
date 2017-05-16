/**
 * 分页链接HTML
 * 
 * @param formId
 * @param totalRow
 * @param pageSize
 * @param pageNumber
 * @param totalPages
 * @param isSelectPage
 * @param isSelectSize
 * @param orderColunm
 * @param orderMode
 * @returns {String}
 */
function splitPageHtml(formId, totalRow, pageSize, pageNumber, totalPages, isSelectPage, isSelectSize, orderColunm, orderMode) {
	var splitStr = '<ul>';

	if (pageNumber == 1 || totalPages == 0) {
		splitStr += '<li><a href="javascript:void(0)">上一页</a></li>';
	} else {
		splitStr += '<li><a href="javascript:splitPageLink(\'' + formId + '\', ' + (pageNumber - 1) + ');">上一页</a></li>';
	}

	for (var i = 1; i <= totalPages; i++) {
		if (i == 2 && pageNumber - 4 > 1) {
			splitStr += '<li><a href="javascript:void(0)">...</a></li>';
			i = pageNumber - 4;
		} else if (i == pageNumber + 4 && pageNumber + 4 < totalPages) {
			splitStr += '<li><a href="javascript:void(0)">...</a></li>';
			i = totalPages - 1;
		} else {
			if (pageNumber == i) {
				splitStr += '<li class="active"><a href="javascript:void(0)" style="color: #272727; font-size: 14px; text-decoration: none;">' + pageNumber + '</a></li>';
			} else {
				splitStr += '<li><a href="javascript:splitPageLink(\'' + formId + '\', ' + i + ');" style="color: #898989; font-size: 14px;">';
				splitStr += i;
				splitStr += '</a></li>';
			}
		}
	}

	if (pageNumber == totalPages || totalPages == 0) {
		splitStr += '<li><a href="javascript:void(0)">下一页</a></li>';
	} else {
		splitStr += '<li><a href="javascript:splitPageLink(\'' + formId + '\', ' + (pageNumber + 1) + ');">下一页</a></li>';
	}

	if (isSelectPage == true) {
		splitStr += '&nbsp;&nbsp;<li><select name="pageNumber" onChange="splitPageLink(\'' + formId + '\', this.value);" style="width: 110px; height:35px;">';
		for (var i = 1; i <= totalPages; i++) {
			if (i == pageNumber) {
				splitStr += '<option selected value="' + i + '">跳转到第' + i + '页</option>';
			} else {
				splitStr += '<option value="' + i + '">跳转到第' + i + '页</option>';
			}
		}
		if (totalPages == 0) {
			splitStr += '<option value="0">无跳转数据</option>';
		}
		splitStr += '</select>';
		splitStr += '<li>&nbsp;&nbsp;';
	} else {
		splitStr += '<input type="hidden" name="pageNumber">';
	}

	if (isSelectSize == true) {
		splitStr += '<li><select name="pageSize" onChange="splitPageLink(\'' + formId + '\', 1);" style="width: 90px; height:35px;">';

		var optionStr = '<option value="10">每页10条</option>';
		optionStr += '<option value="20">每页20条</option>';
		optionStr += '<option value="40">每页40条</option>';
		optionStr += '<option value="80">每页80条</option>';
		optionStr += '<option value="100">每页100条</option>';
		optionStr += '<option value="200">每页200条</option>';
		optionStr = optionStr.replace('"' + pageSize + '"', '"' + pageSize + '" selected="selected"');

		splitStr += optionStr;

		splitStr += '</select></li>';
	} else {
		splitStr += '<input type="hidden" name="pageSize">';
	}

	splitStr += '&nbsp;&nbsp;<li>共<strong>' + totalRow + '</strong>条记录</li>';

	splitStr += '</ul>';

	splitStr += '<input type="hidden" name="orderColunm" value="' + orderColunm + '"/>';
	splitStr += '<input type="hidden" name="orderMode" value="' + orderMode + '"/>';

	return splitStr;
}

/**
 * 分页链接处理
 * 
 * @param formId
 * @param toPage
 */
function splitPageLink(formId, toPage) {
	// alert($("#" + formId + "
	// select[name=pageNumber]").attr("name"));//input[name=pageNumber]
	$("#" + formId + " select[name=pageNumber],input[name=pageNumber] ").val(toPage);
	ajaxForm("splitPage");
}

/**
 * 分页列排序点击事件处理
 * 
 * @param formId
 * @param colunmName
 */
function orderbyFun(formId, colunmName) {
	var orderColunmNode = $("#" + formId + " input[name=orderColunm]");
	var orderColunm = orderColunmNode.val();
	var orderModeNode = $("#" + formId + " input[name=orderMode]");
	var orderMode = orderModeNode.val();
	if (colunmName == orderColunm) {
		if (orderMode == "") {
			orderModeNode.val("asc");
		} else if (orderMode == "asc") {
			orderModeNode.val("desc");
		} else if (orderMode == "desc") {
			orderModeNode.val("");
		}
	} else {
		orderColunmNode.val(colunmName);
		orderModeNode.val("asc");
	}
	$("#splitPage").submit();
}

/**
 * ajax提交form替换content
 * 
 * @param formId
 */
function ajaxForm(formId) {
	$("#" + formId).ajaxSubmit({
		cache : false,
		success : function(data) {
			$("#content").html(data);
			$('#loading').remove();
			$('#content').fadeIn();
			docReady();
		}
	});
}

/**
 * ajax请求url替换content
 * 
 * @param url
 * @param data
 */
function ajaxContent(url, data) {
	$.ajax({
		type : "post",
		url : encodeURI(encodeURI(cxt + url)),
		data : data,
		dataType : "html",
		contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		async : false,
		cache : false,
		success : function(returnData) {
			$("#content").html(returnData);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			// 这个方法有三个参数：XMLHttpRequest 对象，错误信息，（可能）捕获的错误对象。
			// 通常情况下textStatus和errorThown只有其中一个有值
			// alert(XMLHttpRequest.status);
			// alert(XMLHttpRequest.readyState);
			// alert(textStatus);
			alert("请求出现错误！");
		},
		complete : function(XMLHttpRequest, textStatus) {
			// 请求完成后回调函数 (请求成功或失败时均调用)。参数： XMLHttpRequest 对象，成功信息字符串。
			// 调用本次AJAX请求时传递的options参数
			$('#loading').remove();
			$('#content').fadeIn();
			docReady();
		}
	});
}


