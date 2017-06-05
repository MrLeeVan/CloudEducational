<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('statistics_monthly')}</title>
<style type="text/css">
.header {
	font-size: 12px;
}
.minimalize-styl-2{
  padding:7px 12px !important 
}
.count-info .label{
 top:7px
}
#nav-topwidth > li{
 top:4px
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1100px">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper">
  <div class="row border-bottom" >
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="ibox float-e-margins margin-nav" style="margin-left:0;">
  <div class="ibox-title">
	<h5>
	     <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
	       &gt;<a href='/course/getCourseCount'>${_res.get('courses_statistics')}</a> &gt; ${_res.get('statistics_monthly')}
	</h5>
	<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
  </div>
  <div class="ibox-content">
          <form action="/course/getCourseCountByMonth" method="post" id="submit">
			  <p style="margin-top:10px;">
				<label>${_res.get("search.for")}：</label>
					<c:if test="${queryType=='teacher'}">
						<input type="radio" name="queryType" value="teacher" checked="checked" />
						${_res.get('teacher')}
						<input type="radio" name="queryType" value="student" />
						${_res.get('student')}
					</c:if>
					<c:if test="${queryType=='student'}">
						<input type="radio" name="queryType" value="teacher" /> ${_res.get('teacher')} 
						<input type="radio" name="queryType" value="student" checked="checked" /> ${_res.get('student')}  &nbsp;&nbsp;&nbsp;
						<label>${_res.get('system.campus')}：</label>
						<select id="campusid" name="campusid" style="width:120px;" class="chosen-select">
							<option id="campus-1" value="-1">--${_res.get('system.alloptions')}--</option>
							<c:forEach items="${campus }" var="campus" varStatus="status" >
								<option id="campus${campus.ID }"  value="${campus.ID }">${campus.CAMPUS_NAME }</option>
							</c:forEach>
						</select>&nbsp;&nbsp;&nbsp; 
					</c:if>
						&nbsp;&nbsp;<label>${_res.get('course.class.date')}：</label>
						<input type="text" readonly="readonly" id="queryMonth" name="queryMonth" size="12" value="${date1}"  />
						<input type="submit" class="btn btn-outline btn-success" value="${_res.get('admin.common.select')}" />
				</p>
		</form>
    </div>
    
     <div class="col-lg-12" style="margin:20px 0;padding:0">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>${_res.get('Hit.list')}</h5>
				</div>	
				<div class="ibox-content">
				    <table class="table table-hover table-bordered" width="100%">
					<thead>
						<tr>
							<th colspan="3">${_res.get("total")}：</th>
							<c:if test="${queryType eq 'student'}">
							<th colspan="1"></th>
							</c:if>
							<th class="header" colspan="2" style="height:15px;line-height:34px">${_res.get("IEP")}:${sum[0]}${_res.get("classes")}--${sum[1]}${_res.get('session')}</th>
							<th colspan="2">${_res.get("group.class")}:${sum[2]}${_res.get("classes")}--${sum[3]}${_res.get("session")}</th>
							<th></th>
						<tr>
						<tr align="center">
							<th class="header" rowspan="2" style="height:15px;line-height:34px">${_res.get("index")}</th>
							<th class="header" rowspan="2" style="height:15px;line-${_res.get("classes")}height:34px">${_res.get("sysname")}</th>
							<c:if test="${queryType=='student' }">
								<th class="header" rowspan="2" style="height:15px;line-height:34px">${_res.get('system.campus')}</th>
							</c:if>
							<th class="header" rowspan="2" style="height:15px;line-height:34px">${_res.get("monthly.statistics")}</th>
							<th class="header" colspan="2" style="height:15px;line-height:15px;border-bottom-width: 0;padding:2px 0;">${_res.get("IEP")}</th>
							<th class="header" colspan="2" style="height:15px;line-height:15px;border-bottom-width: 0;padding:2px 0;">${_res.get("group.class")}</th>
							<c:if test="${operator_session.qx_coursegetCourseCount }">
								<th class="header" rowspan="2" style="height:15px;line-height:34px">${_res.get("details")}</th>
							</c:if>
						</tr>
						<tr align="center">
							<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">${_res.get('pitch.number')}</th>
							<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">${_res.get('session')}</th>
							<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">${_res.get('pitch.number')}</th>
							<th class="header" style="height:15px;line-height:15px;font-weight: normal;padding:2px 0;">${_res.get('session')}</th>
						</tr>
					</thead>
					<c:forEach items="${list}" var="entity" varStatus="status">
						<tr class="odd" align="center">
							<td>${ status.index + 1}</td>
							<td>${entity.USERNAME}</td>
							<c:if test="${queryType=='student' }">
								<td>${entity.CAMPUS_NAME}</td>
							</c:if>
							<td>${entity.coursemonth }</td>
							<td>
								<c:choose>
									<c:when test="${empty entity.vip }">
										0
									</c:when>
									<c:otherwise>
										${entity.vip }
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${empty entity.vipzks}">
										0
									</c:when>
									<c:otherwise>
										${entity.vipzks}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<c:choose>
									<c:when test="${empty entity.xb }">
										0
									</c:when>
									<c:otherwise>
										${entity.xb }
									</c:otherwise>
								</c:choose>
							</td>
							<td>								
								<c:choose>
									<c:when test="${empty entity.xbzks }">
										0
									</c:when>
									<c:otherwise>
										${entity.xbzks}
									</c:otherwise>
								</c:choose>
							</td>
								<c:if test="${operator_session.qx_coursegetCourseCount }">
							<td>
								<c:choose>
									<c:when test="${queryType=='teacher'}">
										<a  href="/course/getCourseCount?teacherId=${entity.id }&date1=${queryMonth}-01&date2=${endDate}" title="${_res.get('statistics_details')}" >${_res.get("statistics_details")}</a>
									</c:when>
									<c:otherwise>
										<a  href="/course/getCourseCount?teacherId=-1&date1=${queryMonth}-01&date2=${endDate}&studentName=${entity.USERNAME }" title="${_res.get('statistics_details')}" >${_res.get("statistics_details")}</a>
									</c:otherwise>
								</c:choose>
							</td>
								</c:if>
					</c:forEach>
				</table>
				</div>
			</div>
	 </div>
	 <div style="clear: both;"></div>			
   </div>
   </div>
</div>  
<!-- layerDate plugin javascript -->
<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
 <script>
         //日期范围限制
        var queryMonth = {
            elem: '#queryMonth',
            format: 'YYYY-MM',
            max: '2099-06-16', //最大日期
            istime: false,
            istoday: false
        };
        laydate(queryMonth);
 </script> 
 <script type="text/javascript">
    	window.onload = function(){
    		var cid = "campus"+${campusid} ;
    		$("#"+cid).attr("selected",true);
    		$("#campusid").val(${campusid});
    		$("#campusid").trigger("chosen:updated");
    	}
    	
    </script>
 
<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/plugins/layer/layer.min.js"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <script type="text/javascript">
    	$(function(){
    		$('input[name="queryType"]').change(function(){
    			$("#submit").submit();
    		});
    	});
    </script>
 
    <script>
       $('li[ID=nav-nav5]').removeAttr('').attr('class','active');
    </script>
    
       <!-- Chosen -->
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>

    <script>
    $(".chosen-select").chosen({disable_search_threshold: 25});
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
</body>
</html>