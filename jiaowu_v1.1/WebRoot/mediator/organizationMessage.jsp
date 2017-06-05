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
<title>机构信息 </title>
<!-- Mainly scripts -->
<style type="text/css">
ul, ol, li {
	list-style: none;
}
.basicmess{
    font-weight: 100;
    margin:5px 15px
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
			<div class="row border-bottom yincang" style="margin: 0 0 60px;">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff;">
					   <%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="margin-nav">
				<div class="wrapper wrapper-content animated fadeInRight" style="padding:0 10px 40px">
					<div class="row">
					      <div class="ibox-title" style="margin-bottom: 20px">
							<h5>
								<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
								<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> 
								&gt;<a href='/sysuser/index'>机构管理</a> &gt;机构信息 

							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          					<div style="clear:both"></div>
						  </div>
							<c:forEach items="${org}" var="org">
							<div style="width:100%;background:#fff;padding:15px;margin-top:20px">
							  <input type="button" onclick="update(${org.ID}+',3')" class="btn btn-outline btn-success" value="信息编辑">	
							  <div style="padding:10px">	
								<div>
									<div style="border-bottom:1px solid #E7EAEC;padding:3px;font-weight: 900">基本信息</div>
									<div style="padding:10px">
											<label class="basicmess">
												<span>机构名字：</span> <span>${org.NAME}</span>
											</label>
											<label class="basicmess">
												<span>英文名：</span> <span>${org.ENGLISH_NAME}</span>
											</label>
											<label class="basicmess">
												<span>邮箱：</span> <span><a href="${org.EMAIL}" target="_"></a>${org.EMAIL}</span>
											</label><br>
											<label class="basicmess">
												<span>收款人户名：</span> <span>${org.bankAccountName}</span>
											</label>
											<label class="basicmess">
												<span>收款银行账号：</span> <span>${org.bankAccountNumber}</span>
											</label>
											<label class="basicmess">
												<span>开户银行地址：</span> <span>${org.bankAddress}</span>
											</label><br>
											<label class="basicmess">
												<span>官网：</span> <span><a href="${org.WEB}" target="_">${org.WEB}</a></span>
											</label>
											<label class="basicmess">
												<span>客服电话：</span> <span>${org.TEL}</span>
											</label>
											<%-- <label class="basicmess">
												<span>系统到期日期：</span> <span>${org.expirationDate}</span>
											</label>
											<label class="basicmess">
												<span>使用系统剩余：</span> <span>${org.closeCountdown}天</span>
											</label> --%>
											
											<%-- <p>
												<input type="button" onclick="update(${org.ID}+',1')" value="信息设置">
											</p> --%>
									</div>
								</div>
							</div>
							<div style="padding:10px">
								<div>
									<div style="border-bottom:1px solid #E7EAEC;padding:3px;font-weight: 900">参数信息</div>
									<div style="padding:10px">
											<label class="basicmess">
												<span>学生默认可拖欠课时数：</span> <span>${org.BASIC_MAXDEFAULTCLASS}${_res.get('session')}</span>
											</label>
											<label class="basicmess">
												<span>课程顾问最大未成单数：</span> <span>${org.BASIC_MAXSINGULAR}</span>
											</label>
											<label class="basicmess">
												<span>提前提醒取消排课的时间：</span> <span>${org.BASIC_CANCELCOURSEPLANMAXTIME}小时</span>
											</label>
											<label class="basicmess">
												<span>到达该课时数时进行审核：</span> <span>${org.BASIC_AUDITHOURMAXNUMBER}${_res.get("session")}</span>
											</label><br>
											<label class="basicmess">
												<span>提前签到时间：</span> <span>${org.BASIC_MAXREGISTRATION}</span>分钟
											</label>
											<label class="basicmess">
												<span>课前签到算迟到时间：</span> <span>${org.BASIC_MINREGISTRATION}</span>分钟
											</label>
											<label class="basicmess">
												<span>提交日报的最大时间：</span> <span>${org.BASIC_MAXDAILY}</span>小时
											</label><br>
											<label class="basicmess">
												<span>默认返佣比率：</span> <span>${org.BASIC_DEFAULTPROMO}</span>
											</label>
											<br>
											<label style="width:100%" class="basicmess">
												<span>推广返佣比率配置：</span>
												 <span>Lv1:&nbsp;${org.BASIC_PROMOLV1}</span>&nbsp;&nbsp;
												 <span>Lv2:&nbsp;${org.BASIC_PROMOLV2}</span>&nbsp;&nbsp;
												 <span>Lv3:&nbsp;${org.BASIC_PROMOLV3}</span>&nbsp;&nbsp;
												 <span>Lv4:&nbsp;${org.BASIC_PROMOLV4}</span>&nbsp;&nbsp;
												 <span>Lv5:&nbsp;${org.BASIC_PROMOLV5}</span>
											</label>
											<br>
											<label class="basicmess">
												<span>学生初始密码：</span> <span>${org.STULNITIALPASSWORD}</span>
											</label>
											<label class="basicmess">
												<span>老师初始密码：</span> <span>${org.TCHLNITIALPASSWORD}</span>
											</label>
											<%-- <p>
												<input type="button" onclick="update(${org.ID}+',2')" value="参数设置">
											</p> --%>
									</div>
								</div>
							</div>
							<div style="padding:10px">
								<div>
									<div style="border-bottom:1px solid #E7EAEC;padding:3px;font-weight: 900">邮件配置信息</div>
									<div style="padding:10px">
											<label class="basicmess">
												<span>邮件发送开关：</span> <span>${org.email_state}</span>
											</label>
											<label class="basicmess">
												<span>服务器主机：</span> <span>${org.email_serverhost}</span>
											</label>
											<label class="basicmess">
												<span>服务器端口：</span> <span>${org.email_serverport}</span>
											</label>
											<label class="basicmess">
												<span>发送邮箱：</span> <span>${org.email_senderemail}</span>
											</label>
											<label class="basicmess">
												<span>发送密码：</span> <span>${org.email_senderpassword}</span>
											</label>
											<label class="basicmess">
												<span>地址：</span> <span>${org.email_fromaddress}</span>
											</label>
											<label class="basicmess">
												<span>默认标题：</span> <span>${org.email_title}</span>
											</label>
									</div>
								</div>
							</div>
							<div style="padding:10px">
								<div>
									<div style="border-bottom:1px solid #E7EAEC;padding:3px;font-weight: 900">短信配置信息</div>
									<div style="padding:10px">
												<%-- <label class="basicmess">
													<span>${_res.get("userName")}：</span> <span>${org.SMS_USERNAME}</span>
												 </label>
												<label class="basicmess">
													<span>${_res.get("passWord")}：</span> <span>${org.SMS_PASSWORD}</span>
												</label> --%>
												<label class="basicmess">
													<span>短信发送定时开关：</span> <span>${org.SMS_CONTROL==0?_res.get('admin.dict.property.status.start'):'未启用'}</span>
												</label>
												<br>
												<label class="basicmess">
													<span>每日课表发送信息接收人</span> 
														<c:if test="${!empty org.nametels}">
															<c:forEach items="${org.nametels}" var="nt" varStatus="s">
																	<span>姓名：</span>
																	<span>${fn:substring(nt,0,fn:indexOf(nt,','))}</span>
																	<span>电话号：</span>
																	<span>${fn:substring(nt,fn:indexOf(nt,',')+1,fn:length(nt))}</span>
															</c:forEach>
														</c:if>
												</label>
									</div>
								</div>
							</div>
							</div>
							</c:forEach>
						<div style="clear: both;"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
	<script type="text/javascript">
	//添加机构信息
		 function addOrg(){
		    	$.layer({
		    	    type: 2,
		    	    shadeClose: true,
		    	    title: "${_res.get('Add.organization')}",
		    	    closeBtn: [0, true],
		    	    shade: [0.5, '#000'],
		    	    border: [0],
		    	    offset:['40px', ''],
		    	    area: ['744px', '635px'],
		    	    iframe: {src: "/organization/addOrganization"}
		    	});
		    }
	//修改机构信息
		 function update(num){
			 var code = num.substr(num.length-1,num.length);
			var str ="";
 			if(code==1){
				str+="修改机构基本信息";
			}else if(code==2){
				str+="修改机构配置信息";
			}else if(code==3){
				str+="修改机构信息";
			}else{
				str+="修改机构邮件信息";
			}
 			window.location.href="/organization/updateOrganization/"+num;
	    }
	</script>
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/campus.js"></script>

<script>
	$('li[ID=nav-nav11]').removeAttr('').attr('class', 'active');
</script>
</html>

