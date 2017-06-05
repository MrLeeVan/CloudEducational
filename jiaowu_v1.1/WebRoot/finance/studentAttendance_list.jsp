<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">
<title>学生考勤</title>
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
 .chosen-container{
   margin-top:-3px;
 }
 h5{
   font-weight: 100 !important
 }
</style>
</head>
<body id="body">   
	<div id="wrapper" style="background: #2f4050;height:100%;min-width:1100px">
	 <%@ include file="/common/left-nav.jsp"%>
	 <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top fixtop" role="navigation">
			   <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>

        <div class="margin-nav2" style="min-width:1000px;">
		<form action="" method="post" id="searchForm" >
			<input type="text" id="state" name="_query.state" value="${paramMap['_query.state']}"  style="display:none; ">
			<div  class="col-lg-12 m-t-xzl" style="padding-left:0;">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					&gt;<a href='/attendance/studentIndex'>考勤管理</a> &gt; 学生考勤
				   </h5>
				</div>
				<div class="ibox-content">
					<label>${_res.get("student.name")}：</label>
					<input type="text" id="studentname" name="_query.studentname" style="width:150px;" value="${paramMap['_query.studentname']}">
					<label>时间段：</label> 
					<input type="text" class="form-control layer-date" readonly="readonly" id="date1" name="_query.begindate" value="${paramMap['_query.begindate']}" style="margin-top: -8px; width:186px; background-color: #fff;" /> -- 
					<input type="text" class="form-control layer-date" readonly="readonly" id="date2" name="_query.enddate" value="${paramMap['_query.enddate']}" style="margin-top: -8px; width:186px; background-color: #fff;" /> 
				    <input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-info">
				    
			   </div>
			 </div>
		   </div>

			<div class="col-lg-12" style="padding-left:0;">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>${_res.get("student_list")}</h5>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
							<tr align="center">
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("index")}</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('sysname')}</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("admin.user.property.telephone")}</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("normal")}(次)</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('courselib.late')}(${_res.get("frequency")})</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('Ask.for.leave')}(${_res.get("frequency")})</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get('Absenteeism')}(${_res.get("frequency")})</th>
								<th rowspan="2" style="height:15px;line-height: 34px;">${_res.get("operation")}</th>
							</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="student" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${student.real_name}</td>
									<td>${student.tel}</td>
									<td>${student.normal}</td>
									<td>${student.late}</td>
									<td>${student.leaveing}</td>
									<td>${student.truancy}</td>
									<td>
										<a href="/attendance/checkStudentAttendance/${student.id}"  title="考勤信息">详细信息</a>
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
			<div style="clear:both "></div>
		</form>
		</div>
	   </div>
	</div>
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
	
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
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
    <script src="/js/js/top-nav/money.js"></script>
    <script>
    $('li[ID=nav-nav15]').removeAttr('').attr('class','active');
    //$(".left-nav").css("height", window.screenLeft);
    //alert($("#wrapper").outerHeight(true));
    </script>
</body>
</html>