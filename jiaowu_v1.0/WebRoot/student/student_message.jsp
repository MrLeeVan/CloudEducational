<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>学生档案</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

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

<script src="/js/js/jquery-2.1.1.min.js"></script>
<script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
<script src='/fullcalendar/fullcalendar.min.js'></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>

<style type="text/css">
body {
	background-color: #eff2f4;
}

.student_list_wrap {
	position: absolute;
	top: 165px;
	left: 7.5em;
	width: 100px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
		<%@ include file="/common/left-nav.jsp"%>
		<div class="gray-bg dashbard-1" id="page-wrapper">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top" role="navigation" style="margin-left: -15px; position: fixed; width: 100%; background-color: #fff; border: 0">
					<%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>

			<div class="col-lg-12" style="margin-top: 80px; padding-left: 0;">
				<div class="ibox float-e-margins" style="margin-bottom: 0px;">
					<div class="ibox-title" style="width: 100%">
						<h5>
							<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top: -1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt;<a href='/student/index'>${_res.get('student_management')}</a> &gt; <a href='javascript:history.go(-1);'>学生列表</a>&gt; 学生档案
						</h5>
						<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float: right">${_res.get("system.reback")}</a>
						<div style="clear: both;"></div>
					</div>
					<div class="ibox-title">
						<h5>基本信息</h5>
						<div class="ibox-tools">
							<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
						</div>
					</div>
					<div class="ibox-content">
						<table class="table table-bordered">
							<tr align="center">
								<td class="table-bg1" width="25%">${_res.get("sysname")}</td>
								<td class="table-bg2" width="25%">${result.REAL_NAME}</td>
								<td rowspan="4" colspan="2" width="50%" height="180px;">
									<c:if test="${result.url!=null && !empty result.url}">
										<IMG src="/images/headPortrait/${result.url}" style="width: 144px; height: 144px;">
									</c:if> <c:if test="${result.url==null || empty result.url}">
										<IMG src='${cxt }/images/student/student_${result.SEX==0?"female":"male"}.jpg' style="width: 144px; height: 144px;">
									</c:if>
									<IMG src="${barcode.imgUrl}" style="width: 144px; height: 144px;">
									<br><samp>微信扫描自动绑定账户</samp>	
								</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">英文名字</td>
								<td class="table-bg2">${result.EN_NAME==null?'':result.EN_NAME}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get('gender')}</td>
								<td class="table-bg2">${result.SEX==0?_res.get('student.girl'):_res.get('student.boy')}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get('admin.common.place')}</td>
								<td class="table-bg2">${result.ADDRESS==null?'':result.ADDRESS}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get('Date.of.birth')}</td>
								<td class="table-bg2">${result.BIRTHDAY==null?'':result.BIRTHDAY}</td>
								<td class="table-bg1">企业</td>
								<td class="table-bg2">${result.ENTERPRISE==null?'':result.ENTERPRISE}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get("admin.user.property.telephone")}</td>
								<td class="table-bg2">${result.TEL}</td>
								<td class="table-bg1" width="25%">Email</td>
								<td class="table-bg2" width="25%">${result.EMAIL}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get('student.parentphone')}</td>
								<td class="table-bg2">${result.PARENTS_TEL}</td>
								<td class="table-bg1">${_res.get('Patriarch')}Email</td>
								<td class="table-bg2">${result.PARENTS_EMAIL}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get('Ranged')}</td>
								<td class="table-bg2">${result.REMOTE==0?'面授':'远程'}</td>
								<td class="table-bg1">${_res.get('Accommodation')}</td>
								<td class="table-bg2">${result.BOARD==0?'不住宿':'寄宿'}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get('rest.day')}</td>
								<td class="table-bg2">${day}</td>
								<td class="table-bg1">${_res.get('Sales.opportunities')}</td>
								<td class="table-bg2">${result.CONTACTER}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get("Supervisor")}</td>
								<td class="table-bg2">${result.DUNAME==null?'':result.DUNAME}</td>
								<td class="table-bg1">${_res.get("course.consultant")}</td>
								<td class="table-bg2">${kcgwname.REAL_NAME==null?'':kcgwname.REAL_NAME}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get("marketing.specialist")}</td>
								<td class="table-bg2">${result.SCNAME==null?'':result.SCNAME}</td>
								<td class="table-bg1">${_res.get("Overseas.study.consultant")}</td>
								<td class="table-bg2">${result.MEDNAME==null?'':result.MEDNAME}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get("The.head.teachers")}</td>
								<td class="table-bg2">${result.CLASSTEACHER==null?'':result.CLASSTEACHER}</td>
								<td class="table-bg1">${_res.get("The.teacher.in.charge.the.phone")}</td>
								<td class="table-bg2">${result.CLASSTEACHERTEL==null?'':result.CLASSTEACHERTEL}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get("English.teacher")}</td>
								<td class="table-bg2">${result.ENGLISHTEACHER==null?'':result.ENGLISHTEACHER}</td>
								<td class="table-bg1">${_res.get("The.English.teacher.call")}</td>
								<td class="table-bg2">${result.ENGLISHTEACHERTEL==null?'':result.ENGLISHTEACHERTEL}</td>
							</tr>
							<tr align="center">
								<td class="table-bg1">${_res.get("course.remarks")}</td>
								<td class="table-bg2" colspan="3">${result.INTRO==null?'无':result.INTRO}</td>
							</tr>
						</table>
					</div>
				</div>
				<div class="ibox float-e-margins" style="margin-bottom: 0px;">
					<div class="ibox-title">
						<h5>咨询信息</h5>
						<div class="ibox-tools">
							<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
						</div>
					</div>
					<div class="ibox-content">
						<table class="table table-bordered">
							<c:if test="${!empty o }">
								<tr>
									<td class="table-bg1 ">${_res.get("Contacts")}</td>
									<td class="table-bg2">${o.CONTACTER}</td>
									<td class="table-bg1 ">${_res.get('gender')}</td>
									<td class="table-bg2">${o.SEX?_res.get('student.boy'):_res.get('student.girl')}</td>
									<td class="table-bg1 ">咨询科目</td>
									<td class="table-bg2">${o.SUBJECTNAMES}</td>
									<td class="table-bg1">${_res.get("admin.user.property.telephone")}</td>
									<td class="table-bg2">${o.PHONENUMBER}</td>
								</tr>
								<tr>
									<td class="table-bg1">学生关系</td>
									<td class="table-bg2">${o.RELATION eq '1'?'本人':(o.RELATION eq '2'?'母亲':o.RELATION eq '3'?'父亲':'其他')}</td>
									<td class="table-bg1">主动联系</td>
									<td class="table-bg2">${o.NEEDCALLED?_res.get('admin.common.yes'):_res.get('admin.common.no')}</td>
									<td class="table-bg1">反馈次数</td>
									<td class="table-bg2">${o.FEEDBACKTIMES}(${_res.get("frequency")})</td>
									<td class="table-bg1">成单状态</td>
									<td class="table-bg2">${o.ISCONVER eq '0'?_res.get("Opp.No.follow-up"):o.ISCONVER eq '1'?_res.get('Is.a.single'): o.ISCONVER eq '2'?_res.get('Opp.Followed.up'):o.ISCONVER eq '3'?'考虑中':o.ISCONVER eq '4'?'无意向': o.ISCONVER eq '5'?'已放弃':'有意向'}</td>
								</tr>
								<tr>
									<td class="table-bg1">成单日期</td>
									<td class="table-bg2">${o.CONVERTIME==null?'':fn:substring(o.CONVERTIME ,"0","10")}</td>
									<td class="table-bg1">${_res.get("Opp.Sales.Source")}</td>
									<td class="table-bg2">${o.CRMSCNAME}</td>
									<td class="table-bg1">咨询课程</td>
									<td class="table-bg2">${o.CLASSTYPE eq '1'?_res.get("IEP"):_res.get('course.classes')}</td>
									<td class="table-bg1">${_res.get("admin.sysLog.property.enddate")}</td>
									<td class="table-bg2">${o.OVERTIME==null?'':fn:substring(o.OVERTIME,"0","10")}</td>
								</tr>
								<tr>
									<td class="table-bg1">所属留学顾问</td>
									<td class="table-bg2">${o.MEDIATORNAME==null?'':o.MEDIATORNAME}</td>
									<td class="table-bg1">${_res.get("marketing.specialist")}</td>
									<td class="table-bg2">${o.SCUSERNAME==null?'':o.SCUSERNAME}</td>
									<td class="table-bg1">${_res.get("course.consultant")}</td>
									<td class="table-bg2">${o.KCUSERNAME==null?'':o.KCUSERNAME}</td>
									<td class="table-bg1">录入时间</td>
									<td class="table-bg2">${fn:substring(o.CREATETIME,"0","10")}</td>
								</tr>
								<tr>
									<td class="table-bg1">更新时间</td>
									<td class="table-bg2">${o.UPDATETIME==null?'':fn:substring(o.UPDATETIME,"0","10")}</td>
									<td class="table-bg1">确认用户</td>
									<td class="table-bg2">${o.CONFIRMUSERNAME==null?'':o.CONFIRMUSERNAME}</td>
									<td class="table-bg1">客户等级</td>
									<td class="table-bg2">${o.customer_rating=='0'?'未知客户':o.customer_rating=='1'?'潜在客户':o.customer_rating=='2'?'目标客户':o.customer_rating=='3'?'发展中客户':o.customer_rating=='4'?'交易客户':o.customer_rating=='5'?'后续交易客户':'非客户'}</td>
									<td class="table-bg1">下次回访日期</td>
									<td class="table-bg2">${o.NEXTVISIT==null?"":fn:substring(o.NEXTVISIT,"0","10")}</td>
								</tr>
								<tr>
									<td class="table-bg1">${_res.get("course.remarks")}</td>
									<td colspan="7" class="table-bg2">${o.NOTE==null?'无':o.NOTE}</td>
								</tr>
							</c:if>
							<c:if test="${!empty fblist }">
								<tr>
									<td colspan="8" align="center">回访信息</td>
								</tr>
								<tr>
									<td class="table-bg1">${_res.get("index")}</td>
									<td class="table-bg1">课程顾问</td>
									<td colspan="2" class="table-bg1">回访时间</td>
									<!--  <td class="table-bg2" width="13%">通话状态</td>-->
									<td class="table-bg1">回访结果</td>
									<td colspan="3" class="table-bg1">回访内容</td>
								</tr>
								<c:forEach items="${fblist}" var="result" varStatus="vs">
									<tr>
										<td class="table-bg2">${vs.count}</td>
										<td class="table-bg2">${result.REAL_NAME}</td>
										<td colspan="2" class="table-bg2">${result.CREATETIME}</td>
										<!-- <td class="table-bg2">${result.CALLSTATUS eq '1'?"已接通":result.CALLSTATUS eq '2'?"未接通":result.CALLSTATUS eq '3'?"再联系":result.CALLSTATUS eq '4'?"通话中":result.CALLSTATUS eq '5'?"空号":""}</td> -->
										<td class="table-bg2">${result.CALLRESULT eq '0'?_res.get("Opp.No.follow-up"):result.CALLRESULT eq '1'?_res.get('Is.a.single'):result.CALLRESULT eq '2'?_res.get('Opp.Followed.up'):result.CALLRESULT eq '3'?'考虑中':result.CALLRESULT eq '4'?'无意向':result.CALLRESULT eq '5'?'已放弃':'有意向'}</td>
										<td colspan="3" class="table-bg2" style="text-align: left">${result.CONTENT}</td>
									</tr>
								</c:forEach>
							</c:if>
							<c:if test="${!empty record }">
								<tr>
									<td colspan="10" align="center">订单信息</td>
								</tr>
								<tr>
									<td class="table-bg1" width="5%">${_res.get("index")}</td>
									<td class="table-bg1" width="10%">姓名</td>
									<td class="table-bg1" width="10%">订单号</td>
									<td class="table-bg1" width="10%">订单日期</td>
									<td class="table-bg1" width="8%">${_res.get('admin.dict.property.status')}</td>
									<td class="table-bg1" width="10%">提交人</td>
									<td class="table-bg1" width="10%">${_res.get('course.subject')}/${_res.get('classNum')}</td>
									<td class="table-bg1" width="10%">${_res.get('actual.amount')}/已收额/欠费额</td>
									<td class="table-bg1" width="10%">${_res.get('total.sessions')}/单价</td>
									<td class="table-bg1" width="10%">${_res.get("operation")}</td>
								</tr>
								<c:forEach items="${record.list}" var="orders" varStatus="index">
									<tr align="center">
										<td>${index.count }</td>
										<td>${orders.studentname}</td>
										<td>${orders.ordernum}</td>
										<td><fmt:formatDate value="${orders.createtime}" type="time" timeStyle="full" pattern="yyyy/MM/dd" /></td>
										<td>${orders.status==0?'待收':orders.status==1?'已收':'欠费'}</td>
										<td>${orders.operatorname}</td>
										<td>${orders.teachtype==1?orders.subjectname:orders.classnum}</td>
										<td>${orders.realsum}/${orders.paidamount}/${orders.realsum-orders.paidamount}</td>
										<td>${orders.classhour}/${orders.avgprice}</td>
										<td><a href="#" onclick="showPayment(${orders.id})">${_res.get("admin.common.see")}</a> <c:if test="${orders.delflag eq true }">
												<a href="#" style="color: #515151" onclick="showDelReason(${orders.id})">取消原因</a>
											</c:if></td>
									</tr>
								</c:forEach>
							</c:if>
						</table>
					</div>
				</div>
				<div class="ibox float-e-margins" style="margin-bottom: 0px;">
					<div class="ibox-title">
						<h5>课程明细</h5>
						<div class="ibox-tools">
							<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
						</div>
					</div>
					<div class="ibox-content">
						<table class="table table-hover table-bordered">
							<thead>
								<tr align="center" id="liebiaotou">
									<th class="header" width="10%">${_res.get("index")}</th>
									<th class="header" width="10%">${_res.get('student')}</th>
									<th class="header" width="10%">${_res.get('course.class.date')}</th>
									<th class="header" width="10%">${_res.get('time.session')}</th>
									<th class="header" width="10%">${_res.get('course.course')}</th>
									<th class="header" width="10%">${_res.get('teacher')}</th>
									<th class="header" width="10%">${_res.get('Teach')}</th>
									<th class="header" width="10%">${_res.get('Operating.arrangement')}</th>
									<th class="header" width="10%">${_res.get("Teacher.Evaluation")}</th>
									<th class="header" width="10%">${_res.get('Teacher.Attendance')}</th>
								</tr>
							</thead>
							<tbody id="liebiao">
								<c:forEach var="record" items="${list.list }" varStatus="p">
									<tr class="odd" align="center">
										<td>${p.index+1}</td>
										<td>${record.STUNAME}</td>
										<td>${record.COURSETIME}</td>
										<td>${record.ranktime}</td>
										<td>${record.courseName}</td>
										<td>${record.teachername}</td>
										<td><c:choose>
												<c:when test="${record.class_id==0 }">
												${_res.get("IEP")}
											</c:when>
												<c:otherwise>
												${_res.get('course.classes')}
											</c:otherwise>
											</c:choose></td>
										<td><c:if test="${record.TEACHER_PINGLUN=='y'}">${_res.get('It.has.been.arranged')}</c:if> <c:if test="${record.TEACHER_PINGLUN!='y'}">${_res.get('Not.furnished')}</c:if></td>
										<td><c:if test="${record.TEACHER_PINGLUN=='y'}">${_res.get('Rated')}</c:if> <c:if test="${record.TEACHER_PINGLUN!='y'}">${_res.get('Not.evaluated')}</c:if></td>
										<td>${record.signin=="1"?"正常":record.signin=="2"?"迟到":record.signin=="3"?"旷课":record.signin=="4"?"请假":"未点名"}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<form action="/student/showStudentDetail" method="post" id="searchForm">
							<input type="hidden" id="stuId" name="_query.stuid" value="${stuid}" />
							<div id="splitPageDiv">
								<jsp:include page="/common/splitPage.jsp" />
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
	 $(".chosen-select").chosen({disable_search_threshold: 30});
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
		  function showOrderReview(orderId){
		    	$.layer({
		    	    type: 2,
		    	    shadeClose: true,
		    	    title: "订单信息",
		    	    closeBtn: [0, true],
		    	    shade: [0.5, '#000'],
		    	    border: [0],
		    	    area:['800px','500px'],
		    	    iframe: {src: '${cxt}/orders/showOrderReviews/'+orderId}
		    	});
		    }
		    
		    function orderReview(orderId,type){
		    	if(type==1){
		    		layer.msg("审核已通过。",1,10);
		    	}else{
		    		//直接进入审核页:
		    		$.layer({
			    	    type: 2,
			    	    shadeClose: true,
			    	    title: "订单审核",
			    	    closeBtn: [0, true],
			    	    shade: [0.5, '#000'],
			    	    border: [0],
			    	    offset:['200px', ''],
			    	    area:['800px','500px'],
			    	    iframe: {src: '${cxt}/orders/orderFirstReviews/'+orderId}
			    	});
		    	}
		    }
		    
		    function delOrder(id){
		    	layer.prompt({title: '取消订单',type: 3,length: 200}, function(val,index){
		    		$.ajax({
		    			url:"${cxt}/orders/delOrder",
		    			type:"post",
		    			data:{"orderId":id,"reason":val},
		    			dataType:"json",
		    			success:function(data){
		    				if(data.code=='1'){
		    					layer.msg(data.msg, 2, 1);
		    					layer.close(index)
		    					window.location.reload();				
		    				}else{
		    					layer.msg(data.msg, 2, 5);
		    				}
		    			}
		    		});
				});
		    }

		    function paying(orderId,zks,yjks){
		    	if(zks==yjks){
			    	layer.msg("该订单费用已交齐。", 2,1);
		    	}else{
			    	$.layer({
			    	    type: 2,
			    	    shadeClose: true,
			    	    title: "交费",
			    	    closeBtn: [0, true],
			    	    shade: [0.5, '#000'],
			    	    border: [0],
			    	    offset:['100px', ''],
			    	    area: ['700px', '600px'],
			    	    iframe: {src: '${cxt}/payment/toPayment/'+orderId}
			    	});
		    	}
		    }
		    /*购课*/ 
		    function tiaoke(orderId){
		    	$.layer({
		    		type:2,
		    		title:"${_res.get('Purchase.of.course')}",
		    		closeBtn:[0,true],
		    		shade:[0.5,'#000'],
		    		shadeClose:true,
		    		area:['700px','460px'],
		    		iframe:{src:'${cxt}/orders/tiaoke/'+orderId}
		    	});
		    }
		    function modify(orderId){
		    	window.location.href="${cxt}/orders/edit/"+orderId;
		    }
		    function showPayment(orderId){
		    	$.layer({
		    	    type: 2,
		    	    shadeClose: true,
		    	    title: "订单信息",
		    	    closeBtn: [0, true],
		    	    shade: [0.5, '#000'],
		    	    offset:['100px', ''],
		    	    area:['800px','500px'],
		    	    iframe: {src: '${cxt}/payment/paymentList/'+orderId}
		    	});
		    }
		    
		    function showDelReason(orderId){
		    	$.layer({
		    	    type: 2,
		    	    shadeClose: true,
		    	    title: "订单取消原因",
		    	    closeBtn: [0, true],
		    	    shade: [0.5, '#000'],
		    	    border: [0],
		    	    offset:['160px', ''],
		    	    area: ['700px', ''],
		    	    iframe: {src: '${cxt}/orders/showOrderReviews/'+orderId}
		    	});
		    }
		    var state = "${paramMap['_query.type']}";
		    if(state==1||state==""){
		   	 $("#xh_1").removeClass("btn-outline");
		    }
		    if(state==2){
		   	 $("#xh_2").removeClass("btn-outline");
		    }
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
    </script>
</body>
</html>