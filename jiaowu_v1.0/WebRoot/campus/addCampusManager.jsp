<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>添加校区</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" />

<style type="text/css">
label {
	width: 120px;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<div class="left-nav"><%@ include file="/common/left-nav.jsp"%></div>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
				<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav1" style="margin-left: -14px;">
				<div class="col-lg-12">
					<div class="ibox float-e-margins">
					    <div class="ibox-title">
							<h5>
							     <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					&gt;<a href='/sysuser/index'>机构管理</a> &gt;<a <c:if test="${operator_session.qx_campusfindCampusManager }"> href="/campus/findCampusManager" </c:if>>校区管理</a>&gt; ${_res.get('teacher.group.add')}&amp;修改校区
							</h5>
							<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
            				<div style="clear:both"></div>
						</div>
						<div class="ibox-content">
							<form action="" method="post" id="addCampusForm">
								<input type="hidden" name="campus.id" id="campus.id" value="${campus.id }">
								<fieldset>
									<p>
										<label><font color="red"> * </font>校区名称:</label> 
										<input type="text" id="campusName" name="campus.campus_name" value="${campus.campus_name}" onchange="checkCampusName()" onfocus="clearMsg()" />
										<span id="campusNameMsg" style="color: red"></span>
									</p>
									<p>
										<label>校区负责人:</label> 
										<select id="presidentName" class="chosen-select" style="display: inline; width: 186px;" name="campus.presidentid">
											<c:forEach items="${users }" var="president">
												<option value="${president.ID }" <c:if test="${president.ID == campus.presidentid }">selected="selected"</c:if>>${president.REAL_NAME }</option>
											</c:forEach>
										</select>
									</p>
									<p>
										<label>教务负责人:</label> 
										<select id="jwuserid" class="chosen-select" style="display: inline; width: 186px;" name="campus.jwuserid"">
											<!-- <option value="">请选择教务负责任</option> -->
											<c:forEach items="${users }" var="president">
												<option value="${president.ID }" <c:if test="${president.ID == campus.jwuserid }">selected="selected"</c:if>>${president.REAL_NAME }</option>
											</c:forEach>
										</select>
									</p>
									<p>
										<label>市场负责人:</label> 
										<select id="scuserid" class="chosen-select" style="display: inline; width: 186px;" name="campus.scuserid"">
											<!-- <option value="">请选择市场负责任</option> -->
											<c:forEach items="${users }" var="president">
												<option value="${president.ID }" <c:if test="${president.ID == campus.scuserid }">selected="selected"</c:if>>${president.REAL_NAME }</option>
											</c:forEach>
										</select>
									</p>
									<p>
										<label>课程顾问负责人:</label> 
										<select id="scuserid" class="chosen-select" style="display: inline; width: 186px;" name="campus.kcuserid"">
											<!-- <option value="">请选择教务负责任</option> -->
											<c:forEach items="${users }" var="president">
												<option value="${president.ID }" <c:if test="${president.ID == campus.kcuserid }">selected="selected"</c:if>>${president.REAL_NAME }</option>
											</c:forEach>
										</select>
									</p>
									<c:if test="${empty campus.id}">
										<p>
											<label>教室数量:</label> <input type="text" id="roomNum" name="roomNum" />
										</p>
									</c:if>
									<p>
										<label>校区电话:</label> <input type="text" id="campusTel" name="campus.tel" value="${campus.tel}" />
									</p>
									<p>
										<label>校区类型:</label>
										<input type="radio"  id = "campustype" name="campus.campustype" value="1" ${campus.campustype==null?"checked='checked'":campus.campustype==1?"checked='checked'":"" }/> 本校&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="radio" id = "campustype" name="campus.campustype" value="0"  ${campus.campustype==null?"":campus.campustype==0?"checked='checked'":"" }/> 合作院校
									</p>
									<p>
										<label>签到IP限制:</label>
										<input type="radio" id = "limitip" name="campus.limitip" value="1" ${campus.limitip==null?"checked=checked'":(campus.limitip eq true?"checked=checked'":"") }/> ${_res.get('admin.common.yes')} 
										<input type="radio" id = "limitip" name="campus.limitip" value="0" ${campus.limitip eq false ? "checked=checked'":"" }/> ${_res.get('admin.common.no')}
									</p>
									<p>
										<label>是否全职签到:</label>
										<input type="radio" id = "fullsign" name="campus.fullsign" value="1" ${campus.fullsign==null?"checked=checked'":(campus.fullsign eq true?"checked=checked'":"") }/> ${_res.get('admin.common.yes')} 
										<input type="radio" id = "fullsign" name="campus.fullsign" value="0" ${campus.fullsign eq false ? "checked=checked'":"" }/> ${_res.get('admin.common.no')}
									</p>
									<p>
										<label>是否兼职签到:</label>
										<input type="radio"  id = "partsign" name="campus.partsign" value="1" ${campus.partsign==null?"checked=checked'":(campus.partsign eq true?"checked=checked'":"") }/> ${_res.get('admin.common.yes')}
										<input type="radio" id = "partsign" name="campus.partsign" value="0" ${campus.partsign eq false ? "checked=checked'":"" }/> ${_res.get('admin.common.no')}
									</p>
									<p>
										<label>校区地址:</label>
										<input type="text" name="campus.campus_addr" value="${campus.campus_addr}" size="50">
									</p>
									<p>
									<c:if test="${operator_session.qx_campusdoAddCampusManager }">
										<input type="button" value="${_res.get('save')}" onclick="doAddCampusManager();" class="btn btn-outline btn-primary" /> 
									</c:if>
										<input type="button" onclick="window.history.go(-1)" value="${_res.get('system.reback')}" class="btn btn-outline btn-success" />
									</p>
								</fieldset>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
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
	</script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/campus.js"></script>
	<script type="text/javascript">
		function doAddCampusManager() {
			if ($("#campusNameMsg").html() != "") {
				alert("请检查校区名称");
				return false;
			}
			if ($("#campusName").val() == "" || $("#campusName").val() == null) {
				alert("请填写校区名称");
				return false;
			}
			$("#addCampusForm").attr("action", "/campus/doAddCampusManager");
			$("#addCampusForm").submit();

		}
		function checkCampusName() {
			var campusName = $("#campusName").val();
			if (campusName != null && campusName != "") {
				if ('${campusName}' != null && campusName == '${campusName}') {
					return;
				}
				$.ajax({
					url : "/campus/checkCampusName",
					type : "post",
					data : {
						"campusName" : campusName
					},
					dataType : "json",
					success : function(data) {
						if (data)//校区名已存在
						{
							$("#campusNameMsg").html("校区名称已存在");
						}
					}
				});
			}
		}
		function clearMsg() {
			$("#campusNameMsg").html("");
		}
	</script>
	<script>
		$('li[ID=nav-nav11]').removeAttr('').attr('class', 'active');
	</script>
</body>
</html>