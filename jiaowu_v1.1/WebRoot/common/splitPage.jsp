<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<script type="text/javascript">
	$(document).ready(function() {
		var formId = "searchForm"; //分页formId
		var totalRow = ${splitPage.page.totalRow}; //总行数
		var pageSize = ${splitPage.page.pageSize}; //每页显示多少行 
		var pageNumber = ${splitPage.page.pageNumber}; //当前第几页 
		var totalPages = ${splitPage.page.totalPage}; //总页数 
		var isSelectPage = true; // 是否显示第几页
		var isSelectSize = true; // 是否显示每页显示多少条
		var orderColunm = "${splitPage.orderColunm}"; //表格排序的列
		var orderMode = "${splitPage.orderMode}"; //排序的方式

		// 获取分页HTML信息
		var splitStr = splitPageHtml(formId, totalRow, pageSize, pageNumber, totalPages, isSelectPage, isSelectSize, orderColunm, orderMode);
		// 显示分页信息
		$("#splitPageDiv").html(splitStr);
	});
	function splitPageHtml(formId, totalRow, pageSize, pageNumber, totalPages, isSelectPage, isSelectSize, orderColunm, orderMode) {
		var splitStr = '<div class="btn-group">';

		if (pageNumber == 1 || totalPages == 0) {
			splitStr += '<a href="javascript:void(0)" class="btn btn-white btn-pad" id="btn-white"><i class="fa fa-chevron-left"></i></a>';
		} else {
			splitStr += '<a href="javascript:splitPageLink(\'' + formId + '\', ' + (pageNumber - 1) + ');" class="btn btn-white btn-pad" id="btn-white"><i class="fa fa-chevron-left"></i></a>';
		}

		for (var i = 1; i <= totalPages; i++) {
			if (i == 2 && pageNumber - 4 > 1) {
				splitStr += '<a href="javascript:void(0)" class="btn btn-white" id="btn-white">...</a>';
				i = pageNumber - 4;
			} else if (i == pageNumber + 4 && pageNumber + 4 < totalPages) {
				splitStr += '<a href="javascript:void(0)" class="btn btn-white" id="btn-white">...</a>';
				i = totalPages - 1;
			} else {
				if (pageNumber == i) {
					splitStr += '<a href="javascript:void(0)" class="btn btn-white" id="btn-white">' + pageNumber + '</a>';
				} else {
					splitStr += '<a href="javascript:splitPageLink(\'' + formId + '\', ' + i + ');" class="btn btn-white" id="btn-white">';
					splitStr += i;
					splitStr += '</a>';
				}
			}
		}

		if (pageNumber == totalPages || totalPages == 0) {
			splitStr += '<a href="javascript:void(0)" class="btn btn-white btn-pad" id="btn-white"><i class="fa fa-chevron-right"></i></a>';
		} else {
			splitStr += '<a href="javascript:splitPageLink(\'' + formId + '\', ' + (pageNumber + 1) + ');" class="btn btn-white btn-pad" id="btn-white"><i class="fa fa-chevron-right"></i></a>';
		}

		if (isSelectPage == true) {
			splitStr += '&nbsp;&nbsp;<select name="pageNumber" class="btn btn-white" id="btn-white" onChange="splitPageLink(\'' + formId + '\', this.value);" >';
			for (var i = 1; i <= totalPages; i++) {
				if (i == pageNumber) {
					splitStr += '<option selected value="' + i + '">${_res.format("system.splitpage.turntopage","'+i+'")}</option>';
				} else {
					splitStr += '<option value="' + i + '">${_res.format("system.splitpage.turntopage","'+i+'")}</option>';
				}
			}
			if (totalPages == 0) {
				splitStr += '<option value="0">${_res.get("system.splitpage.nodatatoturn")}</option>';
			}
			splitStr += '</select>';
			splitStr += '&nbsp;&nbsp;';
		} else {
			splitStr += '<input type="hidden" name="pageNumber">';
		}

		if (isSelectSize == true) {
			splitStr += '<select name="pageSize" class="btn btn-white" id="btn-white" onChange="splitPageLink(\'' + formId + '\', 1);">';

			var optionStr = '<option value="10">${_res.format("system.splitpage.setnums","10")}</option>';
			optionStr += '<option value="20">${_res.format("system.splitpage.setnums","20")}</option>';
			optionStr += '<option value="40">${_res.format("system.splitpage.setnums","40")}</option>';
			optionStr += '<option value="80">${_res.format("system.splitpage.setnums","80")}</option>';
			optionStr += '<option value="100">${_res.format("system.splitpage.setnums","100")}</option>';
			optionStr += '<option value="200">${_res.format("system.splitpage.setnums","200")}</option>';
			optionStr = optionStr.replace('"' + pageSize + '"', '"' + pageSize + '" selected="selected"');

			splitStr += optionStr;

			splitStr += '</select></span>';
		} else {
			splitStr += '<input type="hidden" name="pageSize">';
		}

		splitStr += '&nbsp;&nbsp;<span class="btn" style="font-size:14px;color:#676a6c;">${_res.format("system.splitpage.totalnums","<strong>' + totalRow + '</strong>")}</span>';

		splitStr += '</div>';

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
		$("#searchForm").submit();
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
		$("#searchForm").submit();
	}

	/**
	 * ajax提交form替换content
	 * 
	 * @param formId
	 */
	function search() {
		$("#searchForm select[name=pageNumber],input[name=pageNumber] ").val(1);
		$("#searchForm").submit();
	}

</script>
