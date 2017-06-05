<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="save" content="history">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>机构信息</title>
<!-- Mainly scripts -->
<style type="text/css">
ul, ol, li {
	list-style: none;
}

.basicmess {
	font-weight: 100;
	margin: 5px 15px
}

.col-sm-3 {
	width: 15%;
}

body {
	background-color: #fff
}

textarea {
	width: 50%;
}

label {
	width: 100px;
	font-weight: 100
}

.labefont {
	width: 170px
}

.flolt {
	display: block;
	width: 320px;
	float: left;
}

.jgmessage {
	padding: 18px
}

.f {
	font-size: 18px;
	color: blue;
}

.ff {
	font-size: 20px;
	color: red;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height: 100%">
			<div class="row border-bottom yincang" style="margin: 0 0 60px;">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff;">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="margin-nav">
				<div class="wrapper wrapper-content animated fadeInRight" style="padding: 0 10px 40px">
					<div class="row">
						<div class="ibox-title" style="margin-bottom: 20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp; <a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> &gt;<a href='/sysuser/index'>机构管理</a> &gt;编辑机构信息

							</h5>
							<div style="clear: both;"></div>
						</div>
						<div style="width: 100%; background: #fff; padding: 15px; margin-top: 20px">
							<!-- organizationForm	缩进 方便编辑  -->
							<a class="btn btn-outline btn-success" href="${cxt }/organization/index">返回 </a>&nbsp;&nbsp;&nbsp;&nbsp;
							<c:if test="${operator_session.qx_opportunitysave }">
								<c:if test="${code=='0'}">
									<%-- <input id ="save" type="button" onclick="saveOrg()" value="${_res.get('save')}"  class="btn btn-outline btn-primary" /> --%>
								</c:if>
							</c:if>
							<c:if test="${operator_session.qx_opportunitysave }">
								<c:if test="${code=='3'}">
									<input id="save" type="button" onclick="updateOrg()" value="提交保存更新机构信息" class="btn btn-outline btn-primary" />
								</c:if>
							</c:if>
							<form id="organizationForm" action="" method="post">
								<fieldset style="width: 100%; padding-top: 5px;">
									<div style="clear: both; background: #e7eaec; padding: 5px 5px 2px; margin-bottom: 0; font-weight: 600">基本信息</div>
									<input type="hidden" id="id" name="organization.id" value="${org.ID}">
									<div class="jgmessage">
										<p class="flolt">
											<label>机构名：</label> <input type="text" id="name" name="organization.name" value="${org.NAME}" size="20" onchange="checkExist('name')" />
										</p>
										<p class="flolt">
											<label>英文名 ：</label> <input type="text" id="ename" name="organization.english_name" value="${org.ENGLISH_NAME}" size="20" onchange="checkExist('englishname')" />
										</p>
										<p class="flolt">
											<label>邮箱：</label> <input type="text" id="email" name="organization.email" value="${org.EMAIL}" size="20" onchange="checkExist('email')" />
										</p>
										<p class="flolt">
											<label>收款人户名：</label> <input type="text" id="name" name="organization.bankAccountName" value="${org.bankAccountName}" size="20" maxlength="50" />
										</p>
										<p class="flolt">
											<label>收款银行账号：</label> <input type="text" id="ename" name="organization.bankAccountNumber" value="${org.bankAccountNumber}" size="20" maxlength="23"/>
										</p>
										<p class="flolt">
											<label>开户银行地址：</label> <input type="text" id="email" name="organization.bankAddress" value="${org.bankAddress}" size="20" maxlength="200"/>
										</p>
										<p class="flolt" style="height: 34px; line-height: 34px">
											<label>官网：</label> <input type="text" id="web" name="organization.web" value="${org.WEB}" size="20" onchange="checkExist('web')" />
										</p>
										<p class="flolt" style="height: 34px; line-height: 34px">
											<label>客服电话：</label> <input type="text" id="tel" name="organization.tel" value="${org.TEL}" size="20" onchange="checkExist('tel')" />
										</p>
										<p class="flolt" style="height: 0px; line-height: 34px; width: 100%;"></p>
										<%-- <p class="flolt" style="height: 34px; line-height: 34px; width: 435px;">
											<label>授权码：</label> <input type="text" id="tel" name="organization.licenseKey" value="${org.licenseKey}" size="32" />
										</p>
										<p class="flolt" style="height: 0px; line-height: 34px; width: 100%;"></p>
										<p class="flolt" style="height: 34px; line-height: 34px; width: 1300px;">
											<label>系统激活码：</label> <input type="text" id="tel" name="organization.expirationDateKeys" value="${org.expirationDateKeys}" size="80%" />
										</p> --%>
									</div>
									<div style="clear: both; background: #e7eaec; padding: 5px 5px 2px; margin-bottom: 0; font-weight: 600">配置信息</div>
									<div class="jgmessage">
										<p class="flolt">
											<label class="labefont">学生默认可拖欠课时数</label> <input type="text" id="maxdefaultclass" name="organization.basic_maxdefaultclass" value="${org.BASIC_MAXDEFAULTCLASS}" size="4" />${_res.get('session')}
										</p>
										<p class="flolt">
											<label class="labefont">课程顾问最大未成单数 </label> <input type="text" id="maxsingular" name="organization.basic_maxsingular" value="${org.BASIC_MAXSINGULAR}" size="4" />
										</p>
										<p class="flolt">
											<label class="labefont">提前提醒取消排课的时间</label> <input type="text" id="cancelcourseplanmaxtime" name="organization.basic_cancelcourseplanmaxtime" value="${org.BASIC_CANCELCOURSEPLANMAXTIME}" size="4" />小时
										</p>
										<p>
											<label class="labefont">到达该课时数时进行审核</label> <input type="text" id="audithourmaxnumber" name="organization.basic_audithourmaxnumber" value="${org.BASIC_AUDITHOURMAXNUMBER}" size="4" />${_res.get("session")}
										</p>
										<p class="flolt">
											<label class="labefont">提前签到时间 </label> <input type="text" id="maxregistration" name="organization.basic_maxregistration" value="${org.BASIC_MAXREGISTRATION}" size="4" />分
										</p>
										<p class="flolt">
											<label class="labefont">课前签到算迟到时间</label> <input type="text" id="minregistration" name="organization.basic_minregistration" value="${org.BASIC_MINREGISTRATION}" size="4" />分
										</p>
										<p class="flolt">
											<label class="labefont">提交日报的最大时间</label> <input type="text" id="maxdaily" name="organization.basic_maxdaily" value="${org.BASIC_MAXDAILY}" size="4" />小时
										</p>
										<p class="flolt">
											<label class="labefont">默认返佣比率</label> <input type="text" id="defaiultpromo" name="organization.basic_defaultpromo" value="${org.BASIC_DEFAULTPROMO}" size="4" />
										</p>
										<p class="flolt" style="height: 34px; line-height: 34px; width: 100%">
											<label class="labefont">推广返佣比率配置</label> 
											Lv1:<input type="text" id="lv1" name="organization.basic_promolv1" value="${org.BASIC_PROMOLV1}" size="6" />&nbsp; 
											Lv2:<input type="text" id="lv2" name="organization.basic_promolv2" value="${org.BASIC_PROMOLV2}" size="6" />&nbsp; 
											Lv3:<input type="text" id="lv3" name="organization.basic_promolv3" value="${org.BASIC_PROMOLV3}" size="6" />&nbsp; 
											Lv4:<input type="text" id="lv4" name="organization.basic_promolv4" value="${org.BASIC_PROMOLV4}" size="6" />&nbsp; 
											Lv5:<input type="text" id="lv5" name="organization.basic_promolv5" value="${org.BASIC_PROMOLV5}" size="6" />
										</p>
										<p class="flolt">
											<label class="labefont">学生初始密码</label> 
											<input type="text" name="organization.stuLnitialPassword" value="${org.STULNITIALPASSWORD}" size="20" maxlength="23"/>
										</p>
										<p class="flolt">
											<label class="labefont">老师初始密码</label> 
											<input type="text" name="organization.tchLnitialPassword" value="${org.TCHLNITIALPASSWORD}" size="20" maxlength="23"/>
										</p>
										
									</div>
									<div style="clear: both; background: #e7eaec; padding: 5px 5px 2px; margin-bottom: 0; font-weight: 600">短信信息</div>
									<div class="jgmessage">
										<%-- <p class="flolt">
				<label>${_res.get("userName")} </label>
				<input type="text" id="sms_username" name="organization.sms_username"  value="${org.SMS_USERNAME}" size="20"   />
			</p>
			<p class="flolt">
				<label>${_res.get("passWord")}</label>
				<input type="text" id="sms_password" name="organization.sms_password"  value="${org.SMS_PASSWORD}" size="20"  />
			</p> --%>
										<p>
											<label class="labefont">短信发送定时开关</label> <input type="radio" name="organization.sms_control" value="0" ${org.SMS_CONTROL==null?"checked=checked'":(org.SMS_CONTROL=='0'?"checked=checked'":"") } /> ${_res.get('admin.dict.property.status.start')} <input type="radio" name="organization.sms_control" value="1" ${org.SMS_CONTROL=='1'? "checked=checked'":"" } /> 不启用
										</p>
										<p>
											每日课表发送信息接收人&nbsp;&nbsp;&nbsp; <a href="javascript:void(0)" class="f" onclick="addTels()">+</a> <br> <input type="hidden" id="num" value="0"> <input type="hidden" id="smsnames" name="organization.sms_names" value=""> <input type="hidden" id="smstels" name="organization.sms_tels" value="">
							    			<c:if test="${!empty org.nametels}">
												<c:forEach items="${org.nametels}" var="nt" varStatus="s">
													<span id="u_${s.count}"> <label>姓名</label> <input type="text" id="" name="names" value="${fn:substring(nt,0,fn:indexOf(nt,','))}"> <label>电话号</label> <input type="number" id="" name="tels" value="${fn:substring(nt,fn:indexOf(nt,',')+1,fn:length(nt))}">&nbsp;&nbsp; <a href="javascript:void(0)" class="ff" onclick="deleteUTels(${s.count})">-</a>
													</span>
													<br>
												</c:forEach>
											</c:if>
											<span id="messages"></span>
										</p>
									</div>

									<div style="clear: both; background: #e7eaec; padding: 5px 5px 2px; margin-bottom: 0; font-weight: 600">邮件配置信息</div>
									<div class="jgmessage">
										<p class="flolt">
											<label class="labefont">邮件发送开关</label> <input type="radio" name="organization.email_state" value="on" ${org.email_state==null?"checked=checked'":(org.email_state eq 'on'?"checked=checked'":"") } />开 <input type="radio" name="organization.email_state" value="off" ${org.email_state eq 'off'? "checked=checked'":"" } /> 关
										</p>
										<p class="flolt">
											<label>地址</label> <input type="text" id="name" name="organization.email_fromaddress" value="${org.email_fromaddress}" size="20" onchange="checkExist('name')" />
										</p>
										<p class="flolt">
											<label>邮箱服务器主机Ip </label> <input type="text" id="ename" name="organization.email_serverhost" value="${org.email_serverhost}" size="20" />
										</p>
										<p class="flolt">
											<label>邮箱服务器端口</label> <input type="text" id="email" name="organization.email_serverport" value="${org.email_serverport}" size="20" onchange="checkExist('email')" />
										</p>
										<p class="flolt" style="height: 34px; line-height: 34px">
											<label>发送邮箱</label> <input type="text" id="web" name="organization.email_senderemail" value="${org.email_senderemail}" size="20" onchange="checkExist('web')" />
										</p>
										<p class="flolt">
											<label>发送密码</label> <input type="text" id="name" name="organization.email_senderpassword" value="${org.email_senderpassword}" size="20" onchange="checkExist('name')" />
										</p>
										<div style="clear: both;"></div>
										<p>
											<label>默认标题</label> <input type="text" width="540px;" id="name" name="organization.email_title" value="${org.email_title}" size="50" onchange="checkExist('name')" />
										</p>
									</div>

									<div style="clear: both; background: #e7eaec; padding: 5px 5px 2px; margin-bottom: 0; font-weight: 600">登陆log</div>
									<div class="jgmessage">
										<iframe style="width: 120%; height: 230px; border-style: none;" src="${cxt }/mediator/import_login_image.jsp"></iframe>
									</div>
									<div style="clear: both; background: #e7eaec; padding: 5px 5px 2px; margin-bottom: 0; font-weight: 600">菜单log</div>
									<div class="jgmessage">
										<iframe style="width: 120%; height: 300px; border-style: none;" src="${cxt }/mediator/import_menu_image.jsp"></iframe>
									</div>
									<div style="clear: both;"></div>

								</fieldset>
							</form>
							<!-- organizationForm 内容  结束  -->
						</div>
						<div style="clear: both;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<!-- Chosen -->
<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
<script type="text/javascript">
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

		//保存机构基本信息
		function saveOrg(){
			var name = $("#name").val();
			if(name.trim()==''){
				layer.msg("机构名不能为空");
				return false;
			}
			var names =document.getElementsByName("names");
			var smsnames ="";
			if(names.length>0){
				for(var i=0;i<names.length;i++){
					var obj = names[i];
					if(obj.value==''){
						layer.msg("短信接受人姓名不能为空",1,2);
						return false;
					}else{
						smsnames+=obj.value+',';
					}
				}
				$("#smsnames").val(smsnames);
			}
			
			var tels =document.getElementsByName("tels");
			var smstels ="";
			if(tels.length>0){
				for(var i=0;i<tels.length;i++){
					var obj = tels[i];
					if(obj.value==''){
						layer.msg("短信接受人电话不能为空",1,2);
						return false;
					}else{
						smstels+=obj.value+',';
					}
				}
				$("#smstels").val(smstels);
			}
			
				$.ajax({
					url:'/organization/saveOrgMessage',
					type:'post',
					data:$('#organizationForm').serialize(),
					async: false,
		            dataType: 'json',
		            success:function(data){
		            	if(data==1){
		            		setTimeout("parent.layer.close(index)", 3000 );
			    			parent.window.location.reload();
		            	}
		            }
				});
			
		}
		function updateOrg(){
			var name = $("#name").val();
			if(name.trim()==''){
				layer.msg("机构名不能为空");
				return false;
			}
			
			var names =document.getElementsByName("names");
			var smsnames ="";
			if(names.length>0){
				for(var i=0;i<names.length;i++){
					var obj = names[i];
					if(obj.value==''){
						layer.msg("短信接受人姓名不能为空",1,2);
						return false;
					}else{
						smsnames+=obj.value+',';
					}
				}
				$("#smsnames").val(smsnames);
			}
			
			var tels =document.getElementsByName("tels");
			var smstels ="";
			if(names.length>0){
				for(var i=0;i<tels.length;i++){
					var obj = tels[i];
					if(obj.value==''){
						layer.msg("短信接受人电话不能为空",1,2);
						return false;
					}else{
						smstels+=obj.value+',';
					}
				}
				$("#smstels").val(smstels);
			}
			
				$.ajax({
					url:'/organization/saveUpdateOrgMessage',
					type:'post',
					data:$('#organizationForm').serialize(),
					async: false,
		            dataType: 'json',
		            success:function(data){
		            	if(data==1){
		            		window.location.href="${cxt}/organization";
		            	}else{
		            		alert("失败了!请刷新重试");
		            	}
		            }
				});
			
		}
		/*添加短信接收人*/
		function addTels(){
			var num = $("#num").val();
			var str ="";
				str+='<span  id="a_'+num+'"><label>姓名：</label> ';
				str+='<input type="text"  name="names" value=""> ';
				str+='<label>电话号：</label>';
				str+='<input type="number"  name="tels" value="">&nbsp;&nbsp;';
				str+='<a href="javascript:void(0)" class="ff" onclick="deleteTels('+num+')">-</a></span><br>';
			$("#messages").append(str);	
			$("#num").val(parseInt(num)+1);
		}
		/*删除短信接收人*/
		function deleteTels(nums){
			$("#a_"+nums).html('');
			//layer.msg("该接收人已删除",1,1);
		}
		function deleteUTels(nums){
			$("#u_"+nums).html('');
			//layer.msg("该接收人已删除",1,1);
		}
	</script>
<script src="/js/utils.js"></script>
<script src="/js/js/bootstrap.min.js?v=1.7"></script>
<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<!-- Custom and plugin javascript -->
<script src="/js/js/hplus.js?v=1.7"></script>
<script src="/js/js/top-nav/campus.js"></script>

<script type="text/javascript">
	$('li[ID=nav-nav11]').removeAttr('').attr('class', 'active');
</script>
</html>

