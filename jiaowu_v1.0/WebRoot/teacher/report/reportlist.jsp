<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get("report.list")}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet"/>
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet"/>
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet"/>
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet"/>
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet"/>
<link href="/css/css/animate.css" rel="stylesheet"/>
<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<style type="text/css">
 .chosen-container{
   margin-top:-3px
 }
 .xubox_tabmove{
	background:#EEE
}
.xubox_tabnow{
    color:#31708f
}
.laydate_body .laydate_bottom{
    height:30px !important
}
.laydate_body .laydate_top{
    padding:0 !important
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
	   <%@ include file="/common/left-nav.jsp"%>
	   <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;border:0">
			  <%@ include file="/common/top-index.jsp"%>
			</nav>
		</div>
		
	  <div class="margin-nav" style="width:100%;">	
       <form action="/report/reportList" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					    <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;
					    <a href="javascript:window.parent.location='/account'">${_res.get("admin.common.mainPage") }</a> 
					   &gt;  ${_res.get("report.first.menuname")}&gt;${_res.get("report.list")}
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
					<label>${_res.get('submission.time')}：</label>
						<input type="text" id ="startappointment" readonly="readonly" name="_query.startappointment" value="${paramMap['_query.startappointment']}">${_res.get('to')}
						<input type="text" id ="endappointment" readonly="readonly" name="_query.endappointment" value="${paramMap['_query.endappointment']}">
					<!-- 此处用于学生姓名的查询 -->
					<label>${_res.get("student.name")}：</label>
					<input type="text" name="_query.studentName" value="${paramMap['_query.studentName']}">
					
					<label>${_res.get('teacher')}：</label>
						<select id="teacherid" name="_query.teacherid" class="chosen-select" style="width:120px">
							<option value="" >${_res.get('system.alloptions')}</option>
							<c:forEach items="${teacher }" var="tch"  >
								<c:if test="${paramMap['_query.teacherid']==tch.id }">
									<option value="${tch.id }" selected="selected" >${tch.real_name }</option>
								</c:if>
								<option value="${tch.id }" >${tch.real_name }</option>
							</c:forEach>
						</select><br>
					<label>${_res.get("report.type.of.report")}：</label>
						<select id="typeid" name="_query.typeid" class="chosen-select" style="width:120px">
							<option value="" >${_res.get('system.alloptions')}</option>
							<c:choose>
								<c:when test="${paramMap['_query.typeid'] eq '1' }">
									<option value="1" selected="selected" >${_res.get('Daily')}</option>
									<option value="2" >${_res.get('Weekly')}</option>
								</c:when>
								<c:when test="${paramMap['_query.typeid'] eq '2' }">
									<option value="1"  >${_res.get('Daily')}</option>
									<option value="2" selected="selected" >${_res.get('Weekly')}</option>
								</c:when>
								<c:otherwise>
									<option value="1" >${_res.get('Daily')}</option>
									<option value="2" >${_res.get('Weekly')}</option>
								</c:otherwise>
							</c:choose>
						</select>
						
					<input type="button" onclick="search()" value="${_res.get('admin.common.select') }"  class="btn btn-outline btn-primary">
			    </div>
			</div>
			</div>

			<div class="col-lg-12" style="min-width:680px">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>${_res.get("report.list")}</h5>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered" width="100%">
							<thead>
								<tr>
									<th>${_res.get("index") }</th>
									<th>${_res.get("student") }</th>
									<th>${_res.get("report.consultant.who.submits.the.report")}</th>
									<th>${_res.get('subject')}</th>
									<th>${_res.get('system.time')}</th>
									<th>${_res.get('time.session')}</th>
									<th>${_res.get("report.date.of.submission")}</th>
									<th>${_res.get('Submit_within_24_hours')}</th>
									<th>${_res.get("report.type.of.report")}</th>
									<%-- <th>${_res.get('Transmission.time')}</th> --%>
									<th>${_res.get("operation") }</th>
								</tr>
							</thead>
								<c:forEach items="${showPages}" var="list" varStatus="index">
									<tr class="odd" align="center">
										<td>${index.count }</td>
										<td>${list.studentName}</td>
										<td>${list.teacherName}</td>
										<td>${list.weekorday=='1'?'-':list.course_name}</td>
										<td>${list.weekorday=='1'?'-':list.coursetime}</td>
										<td>${list.weekorday=='1'?'-':list.rank_name}</td>
										<td><fmt:formatDate value="${list.submissiontime}" type="time" timeStyle="full" pattern="yy-MM-dd  HH:mm:ss"/><c:if test="${empty list.submissiontime}"><fmt:formatDate value="${list.createtime}" type="time" timeStyle="full" pattern="yy-MM-dd  HH:mm:ss"/></c:if></td>
										<th>${list.idoneday==1?'是':'否'}</th>
										<td>${list.weekorday=='1'?_res.get('Weekly'):_res.get('Daily')}</td>
										<%-- <td>
											<c:if test="${list.issend=='1'}" ><fmt:formatDate value="${list.sendtime }" type="time" timeStyle="full" pattern="yyyy-MM-dd HH:mm:ss"/></c:if>
											<c:if test="${list.issend=='0'}" >${_res.get('Unsent')}</c:if>
										</td> --%>
										<td>
										   	<c:if test="${list.weekorday=='1' }">
											   	<a href="/report/previewWeekReport/${list.tgid }" target="_blank" title="${_res.get('Preview')} " >${_res.get("Print") }${_res.get('Preview')}</a> &nbsp;
										   	</c:if>
										   	<c:if test="${list.weekorday=='2' }">
											   	<a href="/report/previewDayReport/${list.tgid}" target="_blank"  >${_res.get('Print')}${_res.get('Preview')}</a> &nbsp;
										   	</c:if>
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
			<div style="clear:both;"></div>
		</form>
	</div>
	</div>	  
</div>  
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
    <script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script type="text/javascript">
    var startappointment = {
			elem : '#startappointment',
			format : 'YYYY-MM-DD',
			istime : false,
			istoday : false,
			choose : function(datas) {
				endappointment.min = datas; 
			}
		};
   	var endappointment = {
			elem : '#endappointment',
			format : 'YYYY-MM-DD',
			istime : false,
			istoday : false,
			choose : function(datas) {
				startappointment.max = datas; 
			}
		};
	laydate(startappointment);
	laydate(endappointment);
	
	function toFixDayReport(id){
		$.layer({
   			type: 2,
		    shadeClose: true,
		    title: "${_res.get('Modify.Daily')}",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['50px', ''],
		    area: ['1050px', '500px'],
       	    iframe: {src: "/report/toFixDayReport/" + id}
       	});
	}
	function sendmessage(tgid,type){
		$.layer({
   			type: 2,
		    shadeClose: true,
		    title: "${_res.get('Send.Report')}",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['50px', ''],
		    area: ['500px', '280px'],
       	    iframe: {src: "/report/sendMailMessage?tgid="+tgid+"&type="+type}
       	});		
	}


</script>

<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
	$(".chosen-select").chosen({disable_search_threshold:30});
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
    
    <script>
       $('li[ID=nav-nav17]').removeAttr('').attr('class','active');
    </script>
</body>
</html>