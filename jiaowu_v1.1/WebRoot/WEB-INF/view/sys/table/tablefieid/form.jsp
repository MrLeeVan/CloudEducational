<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
label{
   width:170px;
}
.chosen-select{
	width: 173px;
}
</style>
<fieldset>
	<input type="hidden" name="tableField.tableName" value="${tableField.tableName}">
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">字段名： </label>
		<input type="text" name="tableField.fieldName" value="${tableField.fieldName}" class="required" maxlength="50" vMin="2" vType="checkTestName" onblur="onblurVali(this);" />
		<font color="red"> * <span id="tableIntroduction_tableName"></span></font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">界面名称： </label>
		<input type="text" name="tableField.notes" value="${tableField.notes}" maxlength="50" class="required"/>
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">引擎： </label>
		<select name="tableField.type" class="chosen-select">
			<option value="varchar">varchar(可伸缩)</option>
			<option value="int">int(范围±2^31)</option>
			<option value="bigint">bigint(范围±2^63)</option>
			<option value="date">date(年月日)</option>
			<option value="datetime">datetime(带时间)</option>
			<option value="text">text(文本)</option>
			<option value="double">double(带精度)</option>
			<option value="float">float(带精度)</option>
		</select>
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">长度： </label>
		<input type="number" name="tableField.length" value="${tableField.length}" maxlength="11" class="required"/>
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">小数点： </label>
		<input type="number" name="tableField.decimalPoint" value="${tableField.decimalPoint}" maxlength="11" class="required"/>
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">为空： </label>
		<input type="radio" name="tableField.notNull" value="0" checked='checked'/>可以为空&nbsp;&nbsp;
		<input type="radio" name="tableField.notNull" value="1" ${tableField.notNull==1?"checked='checked'":""} />不为空
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">主键： </label>
		<input type="radio" name="tableField.primaryKey" value="0" checked='checked'/>不是&nbsp;&nbsp;
		<input type="radio" name="tableField.primaryKey" value="1" ${tableField.primaryKey==1?"checked='checked'":""} />是主键
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">默认值： </label>
		<input type="text" name="tableField.defaults" value="${tableField.defaults}" maxlength="20" class="required"/>
		<font color="red">  </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">字符集： </label>
		<select name="tableField.characterSet" class="chosen-select">
			<option value="utf8">utf8</option>
			<option value="">不设置</option>
		</select>
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">排序规程： </label>
		<select name="tableField.collate" class="chosen-select">
			<option value="utf8_bin">utf8_bin(区分大小写,可存二进制)</option>
			<option value="utf8_unicode_ci">utf8_unicode_ci(不区分大小写)</option>
			<option value="">不设置</option>
		</select>
		<font color="red"> * </font>
	</div>
	<div style="clear:both;" ></div>
	<div class="control-group m-t-sm flt">
		<label class="input-s-sm">显示顺序： </label>
		<input type="text" name="tableField.orders" value="${tableField.orders}" maxlength="3" class="required"/>
		<font color="red">  </font>
	</div>
	<div style="clear:both;" ></div>
</fieldset>

<script type="text/javascript">
	/* 自定义函数开始 */
	$(document).ready(function() {
		//保存
		$("#submitButton").on("click", function() {
			var submitForm = $('#submitForm');
			$.ajax({
				type : "post",
				url : submitForm.attr("action"),
				data : submitForm.serialize(),
				datatype : "json",
				success : function(returnValue) {
					if (1 == returnValue) {
						parent.window.location.reload();
					} else if ((-1) == returnValue) {
						layer.msg("保存异常", 1, 2);
					} else {
						layer.msg("保存失败", 1, 2);
					}
				}
			});
		});

	});
</script>