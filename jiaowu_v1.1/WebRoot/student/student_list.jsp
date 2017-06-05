<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<title>${_res.get('student_list') }</title>
<meta name="save" content="history">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet" />
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
.chosen-container {
	margin-top: -3px;
}

h5 {
	font-weight: 100 !important
}
.bgTips span {display: inline-block;}
.bgTips span em {display: inline-block;height: 12px;width: 12px;vertical-align: middle;border: 1px solid #fff;margin-right: 5px;}
.bgTips span em.BT-1 {background-color: #FFF68F;}
</style>
</head>
<body id="body" style="min-width: 1100px;">
	<div id="wrapper" style="background: #2f4050; height: 100%;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper" style="height: 100%">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtop" role="navigation">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="margin-nav2">
				<form action="${formAction }" method="post" id="searchForm">
					<input type="text" id="state" name="_query.state" value="${paramMap['_query.state']}" style="display: none;">
					<div class="col-lg-12 m-t-xzl" style="padding-left: 0;">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>
									<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp; 
									<a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> &gt;
									<a href='/student/index'>${_res.get('student_management') }</a> &gt; ${_res.get('student_list') }
								</h5>
								<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          					<div style="clear:both"></div>
							</div>
							<div class="ibox-content">
								<label>${_res.get("student.name") }：</label> 
								<input type="text" id="studentname" name="_query.studentname" style="width: 150px;" value="${paramMap['_query.studentname']}"> 
								<%-- <label>${_res.get("telphone") }：</label>&nbsp; 
								<input type="text" id="phonenumber" name="_query.phonenumber" style="width: 150px;" value="${paramMap['_query.phonenumber']}">  --%>
								<label> ${_res.get("course.consultant")}： </label> 
								<select name="_query.kcuserid" id="kcuserId" class="chosen-select" style="width: 150px;" tabindex="2">
									<option value="">${_res.get('system.alloptions')}</option>
									<c:forEach items="${kcgwList}" var="sysuser">
										<option value="${sysuser.id}" ${paramMap['_query.kcuserid']==sysuser.id?"selected='selected'":""}>${sysuser.real_name}</option>
									</c:forEach>
								</select> 
								<label>所属班次： </label> 
								<select name="_query.classorderid" id="classorderid" class="chosen-select" style="width: 190px;" tabindex="2">
									<option value="">${_res.get('system.alloptions')}</option>
									<c:forEach items="${classorders}" var="order">
										<option value="${order.id}" ${paramMap['_query.classorderid']==order.id?"selected='selected'":""}>${order.classnum}</option>
									</c:forEach>
								</select> <br> <br>
								<label>${_res.get("student.buildtime") }：</label>
								<input type="text" class="layer-date" readonly="readonly" id="date1" name="_query.begindate" value="${paramMap['_query.begindate']}" style="margin-top: -8px; width: 150px;" />
								-
								<input type="text" class="layer-date" readonly="readonly" id="date2" name="_query.enddate" value="${paramMap['_query.enddate']}" style="margin-top: -8px; width: 150px;" />
								
									<input type="button" onclick="search()" value="${_res.get('admin.common.select') }" class="btn btn-outline btn-info">
									<c:if test="${operator_session.qx_studentadd }">
										<input type="button" value="${_res.get('teacher.group.add')}" onclick="window.location.href='/student/add'"  class="button btn btn-outline btn-success">
									</c:if>
									<input type="button" value="${_res.get('Opp.Import')}" onclick="toImportBook()"  class="button btn btn-outline btn-success">
									<input type="button" value="${_res.get('Output')}" onclick="toExcel()" class="button btn btn-outline btn-success">
								<div style="clear: both;"></div>
							</div>
						</div>
					</div>

					<div class="col-lg-12" style="padding-left: 0;">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>${_res.get("student_list") }</h5>
								<div class="bgTips" style="margin-left:100px;">
									<span><em class="BT-1"> &nbsp; </em>未排/未上课程小于4课时</span>
								</div>
							</div>
							<div class="ibox-content">
								<table class="table table-hover table-bordered">
									<thead>
										<tr align="center">
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="6%">${_res.get("sysname") }</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="8%">${_res.get("system.campus") }</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="8%">${_res.get("student.buildtime") }</th>
											<th colspan="5" style="height: 15px; line-height: 15px; border-bottom-width: 0; padding: 2px 0;">${_res.get("IEP")}/${_res.get("group.class") }(${_res.get("session")})</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="10%">${_res.get('classNum')}</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="6%">${_res.get("marketing.specialist")}</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="6%">${_res.get("Supervisor")}</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="6%">${_res.get("Their.academic")}</th>
											<th rowspan="2" style="height: 15px; line-height: 34px;" width="6%">${_res.get("course.consultant")}</th>
											<c:if test="${operator_session.qx_student }">
												<th rowspan="2" style="height: 15px; line-height: 34px;" width="6%">${_res.get("operation") }</th>
											</c:if>
										</tr>
										<tr style="font-size: 10px; line-height: 15px;">
											<th style="height: 15px; line-height: 15px; font-weight: normal; padding: 2px 0;">${_res.get("purchases.in.advance")}</th>
											<th style="height: 15px; line-height: 15px; font-weight: normal; padding: 2px 0;">${_res.get("scheduled.classes")}</th>
											<th style="height: 15px; line-height: 15px; font-weight: normal; padding: 2px 0;">${_res.get("Not.ranked") }</th>
											<th style="height: 15px; line-height: 15px; font-weight: normal; padding: 2px 0;">已上</th>
											<th style="height: 15px; line-height: 15px; font-weight: normal; padding: 2px 0;">未上</th>
										</tr>
									</thead>
									<c:forEach items="${showPages.list}" var="student" varStatus="index">

										<tr align="center">
											<td>
												<c:if test="${operator_session.qx_studentshowStudentDetail }">
													<a href="javascript:void(0)" onclick="window.location.href='/student/showStudentDetail/'+${student.id}" title="${_res.get('admin.common.see')}">${student.real_name}</a>
												</c:if>
											</td>
											<td>${student.campusname }</td>
											<td><fmt:formatDate value="${student.create_time}" type="time" timeStyle="full" pattern="yyyy-MM-dd" /></td>
											<td>${student.zksvip==null?'0':student.zksvip}/${student.zksban==null?'0':student.zksban}</td>
											<td>${student.ypksvip==null?'0':student.ypksvip}/${student.ypksban==null?'0':student.ypksban}</td>
											<td ${(student.zksvip-student.ypksvip)+(student.zksban-student.ypksban)<=4?"style='background-color: #FFF68F;'":""}>${student.zksvip-student.ypksvip}/${student.zksban-student.ypksban}</td>
											<td>${student.ysksvip==null?'0':student.ysksvip}/${student.ysksban==null?'0':student.ysksban}</td>
											<td ${(student.zksvip-student.ysksvip)+(student.zksban-student.ysksban)<=4?"style='background-color: #FFF68F;'":""}>${student.zksvip-student.ysksvip}/${student.zksban-student.ysksban}</td>
											
											<td>
												<c:forEach items="${student.classList }" var="classOrder" varStatus="banIndex">
													<c:if test="${banIndex.count ne 1 }"><br/></c:if>
													<a href="/classtype/showBanciDetail?id=${classOrder.id }">
														${classOrder.classNum}
														<c:choose>
															<c:when test="${classOrder.status eq 0 }">(未付)</c:when>
															<c:when test="${classOrder.status eq 1 }">(已付)</c:when>
															<c:when test="${classOrder.status eq 2 }">(欠费)</c:when>
														</c:choose>
													</a>
												</c:forEach>
											</td>
											<td>${student.scusername }</td>
											<td>${student.dudaoname }</td>
											<td>${student.jwusername }</td>
											<td>
												<c:forEach items="${student.kcgwList }" var="kcgw" varStatus="kcgwIndex">
													<c:if test="${kcgwIndex.count ne 1 }"><br/></c:if>${kcgw.real_name}
												</c:forEach>
											</td>
											<td align="center">
												<c:choose>
													<c:when test="${student.STATE==1}">
														<c:if test="${operator_session.qx_teacherfreezestu }">
															<a href="javascript:void(0)" onclick="freezeAccount(${student.id},0)">${_res.get('Recover')}</a>
														</c:if>
													</c:when>
													<c:otherwise>
														<div class="btn-group">
															<button data-toggle="dropdown" class="btn btn-warning btn-xs dropdown-toggle">
																操作<span class="caret"></span>
															</button>
															<ul class="dropdown-menu">
															<c:if test="${operator_session.qx_studentedit }">
																<li><a href="javascript:void(0)" onclick="window.location.href='/student/edit/'+${student.id}" >${ _res.get('admin.common.edit')}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_studentgoBuyCoursePage }">
																<li><a href="javascript:void(0)" onclick="buyCourse(${student.id})">${_res.get('Purchase')}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_studentshowCourseUsedCount }">
																<li><a href="/student/showCourseUsedCount/${student.id}" title="${_res.get('courses_statistics')}">${_res.get('add.up')}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_studentgetStudentCourse }">
																<li><a href="javascript:void(0);" onclick="getStudentCourse(${student.id})">${_res.get('course.course')}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_studentpassword }">
																<li><a href="javascript:void(0)" onclick="changePassword(${student.id})" title="${_res.get('Change.password')}">${_res.get("passWord")}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_teacherfreezestu }">
																<li><a href="javascript:void(0)" onclick="freezeAccount(${student.id},1)">${_res.get('Suspending')}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_courseaddCourseWeekPlan }">
																<li><a href="javascript:void(0)" onclick="window.location.href='/course/addCourseWeekPlan?studentId=${student.id}'">${_res.get('course.arranging')}</a></li>
															</c:if>
															<c:if test="${operator_session.qx_remindManageradd }">
																<li><a href="javascript:void(0)" onclick="addRemind(${student.id})">提醒</a></li>
															</c:if>
															</ul>
														</div>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</table>
								<div id="splitPageDiv">
									<jsp:include page="/common/splitPage.jsp" />
								</div>
							</div>
						</div>
					</div>
					<div style="clear: both"></div>
				</form>
			</div>
		</div>
	</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 10
		});
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

	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script src="/js/js/demo/layer-demo.js"></script>
	<script type="text/javascript">

    /*购课*/ 
    function buyCourse(id){
    	 $.layer({
    		type:2,
    		title:"${_res.get('Purchase.of.course')}",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		shadeClose:true,
    		area:['700px','460px'],
    		iframe:{src:'${cxt}/orders/goBuyCoursePage/'+id}
    	}); 
    }
      
    /*修改学生信息*/
    function updateStudent(studentid){
    	$.layer({
    		type:2,
    		shadeClose:true,
    		title:"${_res.get('Modify')}",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['900px','620px'],
    		iframe:{src:'${cxt}/student/edit/'+studentid}
    	});
    }
    
    /*添加学生iframe形式*/
    function addStudent(){
    	$.layer({
    		type:2,
    		shadeClose:true,
    		title:'添加学生',
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['900px','620px'],
    		iframe:{src:'${cxt}/student/add'}
    	});
    }
    
    /*查看学生信息ifrname形式*/
    function showDetail(id){
    	var message = "${_res.get('courselib.studentMsg')}";
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: message,
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    offset:['100px', ''],
    	    area: ['700px', '380px'],
    	    iframe: {src: '${cxt}/student/showStudentDetail/'+id}
    	});
    }
    function toExcel(){
   	 $("#searchForm").attr("action", "${cxt}/student/toExcel");
     $("#searchForm").submit();
	
    }
    
    function changePassword(id){
    	layer.prompt({title: "${_res.get('Change.password')}",type: 1,length: 200}, function(val,index){
    		$.ajax({
    			url:"${cxt}/sysuser/changePassword",
    			type:"post",
    			data:{"id":id,"password":val},
    			dataType:"json",
    			success:function(data){
    				if(data.result){
    					 layer.msg('密码修改成功！', 1, 1);
    					 layer.close(index)
    				}else{
    					alert("密码修改失败！");
    				}
    			}
    		});
		});
    }
    function freezeAccount(studentId,state){
    	if(confirm('确认要暂停/恢复该学员账号吗？')){
    		$.ajax({
    			url:"/student/freeze",
    			type:"post",
    			data:{"studentId":studentId,"state":state},
    			dataType:"json",
    			success:function(result)
    			{
    				if(result.result=="true")
    				{
    					alert("操作成功");
    					window.location.reload();
    				}
    				else
    				{
    					alert(result.result);
    				}
    			}
    		});
    	}
    }
    
    function payFrontMoney(accountId){
    	$.layer({
    	    type: 2,
    	    shadeClose: true,
    	    title: "${_res.get('Collection.deposit')}",
    	    closeBtn: [0, true],
    	    shade: [0.5, '#000'],
    	    border: [0],
    	    offset:['100px', ''],
    	    area: ['700px', '800px'],
    	    iframe: {src: '${cxt}/account/toPayFrontMoney/'+accountId}
    	});
    }    
    </script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#date1',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
				date2.min = datas; //开始日选好后，重置结束日的最小日期
				date2.start = datas //将结束日的初始值设定为开始日
			}
		};
		var date2 = {
			elem : '#date2',
			format : 'YYYY-MM-DD',
			max : '2099-06-16',
			istime : false,
			istoday : false,
			choose : function(datas) {
				date1.max = datas; //结束日选好后，重置开始日的最大日期
			}
		};
		laydate(date1);
		laydate(date2);
	</script>

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<script src="/js/js/top-nav/top-nav.js"></script>
	<script src="/js/js/top-nav/teach.js"></script>
	<script>
    $('li[ID=nav-nav1]').removeAttr('').attr('class','active');
    //$(".left-nav").css("height", window.screenLeft);
    //alert($("#wrapper").outerHeight(true));
    </script>
	<script type="text/javascript">
    
    //修改课程
    function getStudentCourse(studentid){
    	$.layer({
    		type:2,
    		title:'${_res.get("Modify.the.program")}',
       		closeBtn:[0,true],
       		shade:[0.5,'#000'],
       		shadeClose:true,
       		area:['800px','500px'],
    		iframe:{src:'${cxt}/student/getStudentCourse/'+studentid}
    	});
    }
    
    
    
    function setSysUserGroup(ids){
	    $.layer({
		    type: 2,
		    shadeClose: true,
		    title: "分组选择",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['700px', ($(window).height() - 50) +'px'],
		    iframe: {src: "${cxt}/operator/setSysUserGroup/"+ids}
		});
    }
    
    //添加提醒
    function addRemind(id){
    	$.layer({
    		type:2,
    		shadeClose:true,
    		title:"添加提醒",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['450px','400px'],
    		iframe:{src:'${ctx}/remindManager/add/'+id}
    	});
    }
    

    //导入学生
    function toImportBook(){
		$.layer({
		    type: 2,
		    shadeClose: true,
		    title: "导入学生",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['500px', '300px'],
		    iframe: {src: "${cxt}/student/importStudents"}
		});
	}
    </script>
</body>
</html>