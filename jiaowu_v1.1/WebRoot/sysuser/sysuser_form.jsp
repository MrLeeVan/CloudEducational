<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<title>${_res.get('teacher.group.add')}&修改用户</title>
<style>
label{
   width:170px;
}
span.campus{
   display:-moz-inline-box; display:inline-block; min-width: 60px; margin-right: 25px;
}
</style>
</head>
<body style="background: white;">
     <div class="ibox float-e-margins">
     <div class="ibox-content">
         <form action="" method="post" id="sysuserForm">
					<input type="hidden" name="sysUser.id" id="sysuserId" value="${sysuser.id}" />
					<c:if test="${!empty sysuser.id }">
						<input type="hidden" name="sysuser.version" value="${sysuser.version + 1}">
					</c:if>
					<fieldset>
						<p>
							<label> 
								${_res.get("sysname")}：
							</label> 
							<input type="text" name="sysUser.real_name" id="real_name" value="${sysuser.real_name}" maxlength="20" class="required" maxlength="15" vMin="2" vType="checkTestName" onblur="onblurVali(this);" onchange="checkExist('real_name')"/>
							<font color="red"> * <span id="real_nameMes"> </span></font>
						</p>
						<p>
							<label> 登录邮箱：</label>
							<input type="text" name="sysUser.email" value="${sysuser.email}" id="email" maxlength="100" vMin="6" vType="email" onblur="onblurVali(this);" onchange="checkExist('email')"/>
							<font color="red">*<span id="emailMes"></span></font>
						</p>
						<p>
							<label> ${_res.get("admin.user.property.telephone")}：
							</label> <input name="sysUser.tel" type="text" id="tel" value="${sysuser.tel}" maxlength="15" vMin="0" vType="tel" onblur="onblurVali(this);" onchange="checkExist('tel')"/>
						</p>
						<p>
							<label>
								${_res.get('gender')}：
							</label>
							<c:if test="${sysuser.sex==0||sysuser.sex==null}">
								<input type="radio" name="sysUser.sex" value="1" /> ${_res.get('student.boy')} 
								<input type="radio" name="sysUser.sex" value="0" checked="checked" /> ${_res.get('student.girl')}
							</c:if>
							<c:if test="${sysuser.sex==1}">
								<td><input type="radio" name="sysUser.sex" value="1" checked="checked" /> ${_res.get('student.boy')} 
								<input type="radio" name="sysuser.sex" value="0" /> ${_res.get('student.girl')}</td>
							</c:if>
						</p>
						<p>
							<label>${_res.get('District')}：</label> 
								<c:forEach items="${campusList }" var="campus" varStatus="status">
									${status.count!=1?'<label>&nbsp;</label>':''}
									<input type="checkbox" name="checkbox" <c:if test="${fn:contains(campusids,campus.ids)}">checked="checked"</c:if> value="${campus.id }" /> <span class="campus" >${campus.campus_name}</span>
									<%-- <input type="radio" name="showall_${campus.id }" value="1" <c:if test="${campus.showall==1}">checked="checked"</c:if> /> 查看全部信息
									<input type="radio" name="showall_${campus.id }" value="0" <c:if test="${campus.showall==0}">checked="checked"</c:if> /> 查看本人信息 --%>
									<c:if test="${status.count%2 eq 0 }">
										<br>
									</c:if>
								</c:forEach>
							<input type="hidden" id="campusids" name="campusids"  >
						</p>
						<p>
							<label>数据权限：</label> 
								<input type="radio" name="sysUser.showall" value="1" <c:if test="${sysuser.showall==1}">checked="checked"</c:if> /> 全部数据
								<input type="radio" name="sysUser.showall" value="0" <c:if test="${sysuser.showall==0}">checked="checked"</c:if> /> 本人数据
						</p>
								<p><span style="color:#1AB395;">注：数据权限指的是销售机会和学生的查看权限，<br>如选择“本人数据”则只查看属于本人的销售机会和学生</span></p>
						<p style="margin-top: 15px;">
								<label>角色： </label> 
								<select id="roles" name="roles" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" 
							onchange="checkRole()"	class="chosen-select" multiple style="width: 440px;" tabindex="4">
									<c:forEach items="${roles}" var="r">
										<option value="${r.id}" class="optionss" >${r.names}</option>
									</c:forEach>
								</select> 
								<input id="roleids" name="sysUser.roleids" value="" type="hidden">
						 </p>
						<!-- <p>
							<label> ${_res.get('rest.day')}： </label>
							<select name="sysUser.rest_day" id="restDay" class="chosen-select" style="width:186px;" tabindex="2">
								<option value="-1"<c:if test="${sysuser.rest_day==-1}">selected="selected"</c:if>>${_res.get('Please.select')}</option>
								<option value="1" <c:if test="${sysuser.rest_day==1}">selected="selected"</c:if> >${_res.get('system.Monday')}</option>
								<option value="2" <c:if test="${sysuser.rest_day==2}">selected="selected"</c:if>>${_res.get('system.Tuesday')}</option>
								<option value="3" <c:if test="${sysuser.rest_day==3}">selected="selected"</c:if>>${_res.get('system.Wednesday')}</option>
								<option value="4" <c:if test="${sysuser.rest_day==4}">selected="selected"</c:if>>${_res.get('system.Thursday')}</option>
								<option value="5" <c:if test="${sysuser.rest_day==5}">selected="selected"</c:if>>${_res.get('system.Friday')}</option>
								<option value="6" <c:if test="${sysuser.rest_day==6}">selected="selected"</c:if>>${_res.get('system.Saturday')}</option>
								<option value="0" <c:if test="${sysuser.rest_day==0}">selected="selected"</c:if>>${_res.get('system.Sunday')}</option>
							</select>
						</p> -->
						<p>
							<label> ${_res.get("course.remarks")}： </label>
							<textarea rows="5" cols="85" name="sysUser.intro"  style="width:440px;overflow-x: hidden; overflow-y: scroll;">${fn:trim(sysuser.intro)}</textarea>
						</p>
						<c:if test="${operator_session.qx_sysusersave }">
							<p>
								<input type="button" value="${_res.get('save')}" onclick="return saveAccount();" class="btn btn-outline btn-primary" />
							</p>
						</c:if>
					</fieldset>
				</form>
     </div>
     </div>
<!-- Mainly scripts -->
<script src="/js/js/jquery-2.1.1.min.js"></script>

<!-- Chosen -->
<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
 <script>        
 $(".chosen-select").chosen({disable_search_threshold: 20});
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
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script type="text/javascript">
	/**登陆邮箱使用QQ邮箱*/
	function useQQEmail(){
		var qq = $('#qq').val();
		if(qq == ''){
			alert("请填写QQ号码");
		}else{
			$("#email").val(qq+"@qq.com");
			if(checkExist('email')){
				$("#emailMes").text("Email不能为空和重复");
				$("#email").focus();
			}
		}
	}
	function checkExist(checkField) {
		var checkValue = $("#"+checkField).val();
	    if (checkValue != "") {
	    	var flag = true;
	        $.ajax({
	            url: '${cxt}/sysuser/checkExist',
	            type: 'post',
	            data: {
	                'checkField': checkField,
	                'checkValue': checkValue,
	                'id': $("#sysuserId").val()
	            },
	            async: false,
	            dataType: 'json',
	            success: function(data) {
	                if (data.result >= 1) {
	                	$("#"+checkField).focus();
                    	$("#"+checkField+"Mes").text("您填写的数据已存在。");
	                }else{
	                	$("#"+checkField+"Mes").text("");
	                	flag = false;
	                } 
	            }
	        });
	        return flag;
	    } else {
	    	if(checkField=='qq'||checkField=='tel'){
	    		return false;
	    	}else{
		        $("#"+checkField).focus();
		    	$("#"+checkField+"Mes").text("该字段不能为空。");
		        return true;
	    	}
	    }
	}
	
	
	function saveAccount(){
		getRoleids();
		var campusids = "";
		$('input[name="checkbox"]:checked').each(function() {
			campusids += "|"+$(this).val();
		});
		$("#campusids").val(campusids.substr(1,campusids.length-1));
		if(checkExist('real_name')){
			$("#nameMes").text("姓名不能为空和重复");
			$("#realName").focus();
			return false;
		}else{
			if(checkExist('tel')){
				$("#telMes").text("电话号码不能为空和重复");
				$("#tel").focus();
			}else{
				if(checkExist('email')){
					$("#emailMes").text("Email不能为空和重复");
					$("#email").focus();
				}else{
					if($("#roleids").val()==""){
						layer.msg("请选择用户角色",1,2);
						return false;
					}
					var sysuserId = $("#sysuserId").val();
					if(sysuserId == ""){
						if(confirm("确定保存该用户信息吗？")){
							$.ajax({
	                        	type:"post",
								url:"${cxt}/sysuser/save",
								data:$('#sysuserForm').serialize(),
								datatype:"json",
								success : function(data) {
									parent.window.location.reload();
								}
							})
						}
					}else{
						if(confirm("确定要修改该用户信息吗？")){
							$.ajax({
	                        	type:"post",
								url:"${cxt}/sysuser/update",
								data:$('#sysuserForm').serialize(),
								datatype:"json",
								success : function(data) {
									parent.window.location.reload();
								}
							})
                        	
						}
					}
				}
			}
		}
	}
	function getRoleids() {
		var roleids = "";
		var list = document.getElementsByClassName("search-choice");
		for (var i = 0; i < list.length; i++) {
			var name = list[i].children[0].innerHTML;
			var olist = document.getElementsByClassName("optionss");
			for (var j = 0; j < olist.length; j++) {
				var oname = olist[j].innerHTML;
				if (oname == name) {
					roleids +=olist[j].getAttribute('value')+",";
					break;
				}
			}
		}
		$("#roleids").val(roleids);
	}
	function checkRole(){
		var sysuserId = $("#sysuserId").val();
		if(sysuserId!=""){
			var  oldroleids = $("#roleids").val();	
			getRoleids();
			var  newroleids = $("#roleids").val();
		}
	}
	
	var roleids = '${sysuser.roleids}';
    function chose_mult_set_ini(select, values){
    	values = values.substr(0,values.length-1);
        var arr = values.split(',');
        var length = arr.length;
        var value = '';
        for(i=0;i<length;i++){
            value = arr[i];
            $(select+" [value='"+value+"']").attr('selected','selected');
        }
        $(select).trigger("chosen:updated");
    }
     $(document).ready(function () {
         chose_mult_set_ini('#roles',roleids);
         $(".chosen-select").chosen();
     });
</script>
<script src="/js/utils.js"></script>

 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/campus.js"></script>
    <script>
       $('li[ID=nav-nav11]').removeAttr('').attr('class','active');
    </script>
</body>
</html>
