<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Adding.channels')}</title>
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
<link rel="stylesheet" type="text/css" href="/css/css/plugins/simditor/simditor.css" />

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
		<div style="height:440px">
			<div style="margin-top: 10px;padding:15px;background:#fff">
				<form id="mediatorForm" action="${cxt }/mediator/save" method="post">
					<fieldset>
						<input type="hidden" id="mediatorId" name="mediator.id" value="${mediator.id }"/>
						<c:if test="${!empty mediator.id }">
							<input type="hidden" name="mediator.version" value="${mediator.version + 1}">
						</c:if>
						<p>
							<label>类型：</label>
							
							<input type="radio" id="type" onclick="changeMessage(1)" <c:if test="${mediator.type==1||mediator.type==0||mediator.type==null}">checked="checked"</c:if> name="mediator.type" value="1" >个人
							<input type="radio" id="type" onclick="changeMessage(2)" <c:if test="${mediator.type==2}">checked="checked"</c:if> name="mediator.type" value="2" >公司						
						</p>
						<p>
							<label>渠道：</label>
							<input type="text" id="realname" name="mediator.realname" value="${mediator.realname }" size="20" maxlength="15" vMin="2" vType="checkTestName" onblur="onblurVali(this);" onchange="checkExist('realname')"/>
							<span class="spanred">*</span>
						    <span id="realnameMes" class="spanred"></span>
						</p>
						<p>
							<label>${_res.get("admin.user.property.telephone")}：</label>
							<input type="text" id="phonenumber" name="mediator.phonenumber" value="${mediator.phonenumber }" size="20" maxlength="15" vMin="11" vType="tel" onblur="onblurVali(this);" onchange="checkExist('phonenumber')"/>
							<span class="spanred">*</span>
							<span id="phonenumberMes" class="spanred"></span>
						</p>
						<p>
							<label>${_res.get('admin.user.property.email')}：</label>
							<input type="text" id="email" name="mediator.email" value="${mediator.email }" size="20" maxlength="100" vMin="6" vType="email" onblur="onblurVali(this);" onchange="checkExist('email')"/>
							<span class="spanred"></span>
							<span id="emailMes" class="spanred"></span>
						</p>
						<p id="changea">
							<label>${_res.get('Affiliation')}：</label>
							<input id="mediatorid" name="companynames" onblur="onblurmediator()" 
									oninput="getLikeMediator(this.value)"  onpropertychange="getLikeMediator(this.value)" value="${companynames}" type="text">
									<div id="showSelectMessage" class="student_list_wrap" style="display: none">
										<ul style="margin-bottom: 10px;" id="mediaorlist"></ul>
									</div>
						</p>
						<p id="changeb">
							<label>${_res.get('Date.of.birth')}：</label> 
							<input type="text" id="birthday" name="mediator.birthday" readonly="readonly" value="${mediator.birthday}" size="15"/>
						</p>
						<p id="changeg">
							<label>${_res.get('gender')}：</label>
							<input type="radio" id="sex" name="mediator.sex" value="1" checked="checked">${_res.get('student.boy')}
							<input type="radio" id="sex" name="mediator.sex" value="0" >${_res.get('student.girl')}
						</p>
						<p id="changeadd">
							<label>公司地址：</label>
							<input type="text" name="mediator.address"  value="${mediator.address}">
						</p>
						<p>
							<label>${_res.get("marketing.specialist")}：</label> 
							<select name="mediator.sysuserid" id="sysuserid" class="chosen-select" style="width: 180px" tabindex="2">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${sysUserList }" var="sysUser">
									<option value="${sysUser.id }" <c:if test="${sysUser.id==mediator.sysuserid}">selected='selected'</c:if> >${sysUser.real_name }</option>
								</c:forEach>
							</select>
							<span class="spanred">*</span>
	                        <span id="sysuserInfo" class="spanred"></span>
						</p>
						<p>
							<label>推荐渠道：</label> 
							<select name="mediator.parentid" id="parentid" class="chosen-select" style="width: 180px" tabindex="2">
								<option value="">--${_res.get('Please.select')}--</option>
								<c:forEach items="${mediatorList }" var="parent">
									<option value="${parent.id }" <c:if test="${parent.id==mediator.parentid }">selected='selected'</c:if> >${parent.realname }</option>
								</c:forEach>
							</select>
						</p>
						<p>
							<textarea id="record" name="mediator.record" placeholder="记录本">${mediator.record }</textarea>
						</p>
						<p>
						<c:if test="${operator_session.qx_mediatorsave }">
						<c:if test="${operatorType eq 'add'}">
							<input type="button" value="${_res.get('save')}" onclick="return save();" class="btn btn-outline btn-primary" />
						</c:if>
						</c:if>
						<c:if test="${operator_session.qx_mediatorupdate }">
						<c:if test="${operatorType eq 'update'}">
							<input type="button" value="${_res.get('update')}" onclick="return save();" class="btn btn-outline btn-primary" />
						</c:if>
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
		function checkExist(checkField) {
			var checkValue = $("#"+checkField).val();
		    if (checkValue != "") {
		    	var flag = true;
		        $.ajax({
		            url: '${cxt}/mediator/checkExist',
		            type: 'post',
		            data: {
		                'checkField': checkField,
		                'checkValue': checkValue,
		                'mediatorId': $("#mediatorId").val()
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
		        $("#"+checkField).focus();
		    	$("#"+checkField+"Mes").text("该字段不能为空。");
		        return true;
		    }
		}
		
		function save() {
			if(checkExist('realname'))
				return false;
			if(checkExist('phonenumber'))
				return false;
			/* if(checkExist('email'))
				return false; */
			var realname = $("#realname").val().trim;
			if ($("#realname").val() == "" || $("#realname").val() == null) {
				$("#realname").focus();
				$("#realnameMes").text("渠道名称不能为空！");
				return false;
			}else{
				$("#realnameMes").text("");
				var mediatorId = $("#mediatorId").val();
				var sysuserid = $("#sysuserid").val();
				if(mediatorId==""){
					if(sysuserid==""){
						$("#sysuserInfo").text("请选择所属市场");
					}else{
						 $.ajax({
	                        	type:"post",
								url:"${cxt}/mediator/save",
								data:$('#mediatorForm').serialize(),
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
				}else{
					if(confirm("确定要修改该顾问信息吗？")){
						 $.ajax({
	                        	type:"post",
								url:"${cxt}/mediator/update",
								data:$('#mediatorForm').serialize(),
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
		/*模糊查询渠道*/
		function getLikeMediator(name){
			if(name.trim()!=""){
				$.ajax({
					url:'/company/getCompanyByNameLike',
					type:'post',
					data:{'companyname':name},
					dataType:'json',
					success:function(data){
						var str="";
							if(data.companys.length>0){
								for(var i=0;i<data.companys.length;i++){
									str+='<li onclick="showSelectName(\''+data.companys[i].COMPANYNAME+'\')">'+data.companys[i].COMPANYNAME+'</li>'
								}
							}
						if(str!=""){
							$("#mediaorlist").html(str);
							$("#showSelectMessage").show();
						}
					}
					
				})
			}
		}
		/*回填选中的数据*/
		function showSelectName(name){
			$("#mediatorid").val(name);
			$("#showSelectMessage").hide();
		}
		/*隐藏*/
		function onblurmediator(){
			var flag = true;
			$("#showSelectMessage li").click(function(){
				flag = false;
			});
			setTimeout(function(){
				if(flag){
					$("#showSelectMessage").hide();
				}
			},100);
			
		}
		/*改变其显示内容*/
		function changeMessage(num){
			if(num==1){
				$("#changeb").show();
				$("#changeg").show();
				$("#changea").show();
				$("#changeadd").hide();
			}else{
				$("#changeadd").show();
				$("#changeb").hide();
				$("#changeg").hide();
				$("#changea").hide();
			}
		}
	$(document).ready(changeMessage('${mediator.type}'==''?1:'${mediator.type}'==0?1:'${mediator.type}'));
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
    <!-- simditor -->
    <script type="text/javascript" src="/js/js/plugins/simditor/module.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/uploader.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/hotkeys.js"></script>
    <script type="text/javascript" src="/js/js/plugins/simditor/simditor.js"></script>
    <script>
        $(document).ready(function () {
            var editor = new Simditor({
                textarea: $('#record')
            });
        });
    </script>
    <script>
       $('li[ID=nav-nav8]').removeAttr('').attr('class','active');
    </script>
</body>
</html>