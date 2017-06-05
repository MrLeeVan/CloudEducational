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
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('Add.the.research.group')}</title>
<style>
label {
	width: 170px;
}
</style>

</head>
<body>
	<div id="wrapper" style="background: #2f4050; height: 100%;">
		<div class="left-nav"><%@ include file="/common/left-nav.jsp"%></div>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff;border:0">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav1">
				<div class="ibox float-e-margins">
				    <div class="ibox-title" style="margin-bottom:20px">
						<h5>
						   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
						  &gt;<a href='/teacher/index?_query.state=0'>${_res.get('teacher_management')}</a> &gt;<a href='javascript:history.go(-1);'>${_res.get('teaching_and_research_section')}</a>&gt; ${_res.get('Add.the.research.group')}
						</h5>
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get('system.reback')}</a>
			            <div style="clear: both;"></div>
					</div>
					<div class="ibox-title">
						<h5>${_res.get('teacher.group.add')} &amp; ${_res.get('Modify')}</h5>
					</div>
					<div class="ibox-content">
						<form action="" method="post" id="groupForm">
							<fieldset style="width: 850px">
								<p>
									<label> ${_res.get('group.name')}： </label> <input type="hidden" id="tab" name="teachergroup.id"  value="${teacheredit.id }"> 
									<input type="text" name="teachergroup.groupname" id="real_name"  onchange ="checkNmame(this.value)"  value="${teacheredit.groupname==null?'':teacheredit.groupname}" maxlength="20" class="required"
										maxlength="15" vMin="2" vType="chinaLetterNumber"  /> <font color="red">
										* <span id="real_nameMes"> </span>
									</font>
								</p>
			
								<p>
									<label> ${_res.get('person.in.charge')}： </label> 
									<select name="teachergroup.leaderid" id="leaderid" class="chosen-select" style="width: 150px" tabindex="2">
										<option value="">--${_res.get('Please.select')}--</option>
										<c:forEach items="${teacher }" var="teacher">
											<option value="${teacher.id }" <c:if test="${teacher.id == teacheredit.leaderid }">selected="selected"</c:if>>${teacher.real_name}</option>
										</c:forEach>
									</select> <font color="red">* <span id="real_nameMes"> </span>
									</font>
								</p>
								<p>
									<label> ${_res.get('group.member')}： </label>
									<select id="teacherids" name="teacherids" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple
										style="width: 340px;" tabindex="4">
										<c:forEach items="${teacher}" var="teacher">
											<option value="${teacher.id}" class="options" id="tid_${teacher.id }">${teacher.real_name}</option>
										</c:forEach>
									</select> <input id="tids" name="teachergroup.teacherids" value="" type="hidden">
									<font color="red">*</font>
								</p>
								<p>
								<c:if test="${operator_session.qx_teachersavegroup }">
								<div id="savegroups">
									<input type="button" value="${_res.get('save')}" onclick="saveGroup()" class="btn btn-outline btn-primary" />
								</div>
								</c:if>
								<c:if test="${operator_session.qx_teacherupdategroup }">
								<div id="updategroups">
									<input type="button" value="${_res.get('update')}" onclick="updateGroup()" class="btn btn-outline btn-primary" />
								</div>
								</c:if>
								</p>
							</fieldset>
						</form>
					</div>

				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/teach.js"></script>


	<script>
		//保存和更新按钮隐藏
		var tab = $("#tab").val();
		if (tab == '') {
			$("#updategroups").hide();
		}
		if (tab != '') {
			$("#savegroups").hide();
		}
		
		
		//验证名字的唯一性
		function checkNmame(name){
			$.ajax({
				url : "${cxt}/teacher/checkGroupName",
				type : "post",
				data:{"name":name},
				dataType : "json",
				success : function(data) {
					if(data.code=='0'){
						alert(data.msg);
						$("#real_name").val("");
				}
			}
			});
		}
		//验证保存表单
		function saveGroup() {
			var real_name = $("#real_name").val();
			var leaderid = $("#leaderid").val();
			var teacherids = $("#teacherids").val();
			console.log("real_name=",real_name,"leaderid=",leaderid,"teacherids",teacherids);
			if(real_name == null || real_name.trim()== ""){
				alert("请填写组名称");
			}else if(leaderid == ""){
				alert("请选择负责人");
			}else if(teacherids == null || teacherids == ""){
				alert("请选择组成员");
			}else{
			    getIds();
			    $("#groupForm").attr("action", "/teacher/savegroup");
			    $("#groupForm").submit();
			}
		}
		//验证修改表单
		function updateGroup() {
			getIds();
			$("#groupForm").attr("action", "/teacher/updategroup");
			$("#groupForm").submit();
		}

		//-----------------下拉菜单插件
		$(".chosen-select").chosen({
			disable_search_threshold : 20
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

	<script type="text/javascript">
		//获取下拉菜单的值
		function getIds() {
			var teacherids = "";
			var list = document.getElementsByClassName("search-choice");
			for (var i = 0; i < list.length; i++) {
				var name = list[i].children[0].innerHTML;
				var olist = document.getElementsByClassName("options");
				for (var j = 0; j < olist.length; j++) {
					var oname = olist[j].innerHTML;
					if (oname == name) {
						teacherids += "|" + olist[j].getAttribute('value');
						break;
					}
				}
			}
			$("#tids").val(teacherids);
		}
	</script>
	<script type="text/javascript">
	var ids = '${teacheredit.teacherids}';
    //多选select 数据初始化
    function chose_mult_set_ini(select, values){
        var arr = values.split('|');
        var length = arr.length;
        var value = '';
        for(i=0;i<length;i++){
            value = arr[i];
            $(select+" [value='"+value+"']").attr('selected','selected');
        }
        $(select).trigger("chosen:updated");
    }

     $(document).ready(function () {
         chose_mult_set_ini('#teacherids',ids);
         $(".chosen-select").chosen();
     });
	</script>
	<script>
		$('li[ID=nav-nav2]').removeAttr('').attr('class', 'active');
	</script>
	<script type="text/javascript">
		
	</script>
</body>
</html>
