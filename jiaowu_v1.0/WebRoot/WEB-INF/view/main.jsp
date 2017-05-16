<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<title>云教务排课系统</title>

<link href="/css/bootstrap.min.css?v=3.3.0" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=4.3.0" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<link href="/css/css/animate.css" rel="stylesheet" />
<link href="/css/css/style.css" rel="stylesheet" />
	<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<style type="text/css">
  .ibox-content{
     padding:15px 10px !important
  }
  .font-align{
     padding:15px 0;
     text-align: center;
     color:#fff;
     font-size: 18px
  }
  @media (max-width: 700px) {
     .font-align{
	     text-align: center;
	     color:#fff;
	     font-size: 12px
     }
     .ibox-content{
         padding:0 10px !important
     }
     .col-lg-2{
         padding:0 3px
     }
     #nav-topwidth .guojihua{
         position: static;
         display:block;
         float: right;
         height:60px;
         line-height:50px
     }
     #nav-topwidth .dropdown{
        position: static;
        display:block;
         float: left;
     }
     .navbar-top-links .dropdown-alerts{
        margin-left:30px
     }
     .navbar-top-links li:last-child{
        margin-right:0
     }
     .minimalize-styl-2{
        margin:10px 3px 5px 10px !important
     }
  }
  .market-main{
    background:#6DD4E3;
  }
  .market-main:hover{
    background:#61B6C2
  }
  .sale-main{
    background:#F8A4C5;
  } 
  .sale-main:hover{
    background:#C2849D
  }
  .teach-main{
    background:#A0CCFE;
  }
  .teach-main:hover{
    background:#81A5CC
  }
  .money-main{
    background:#A9DD8E;
  }
  .money-main:hover{
    background:#8BB276
  }
  .campus-main{
    background:#EABDA0;
  }
  .campus-main:hover{
    background:#C29E88
  }
  .minimalize-styl-2{
    margin: 10px 5px 5px 20px;
  }
  .navbar{
    height:50px;
    border-bottom: 1px solid #e7eaec !important;
  }
  .border-bottom{
    height:50px
  }
  #nav-topwidth > li{
    top:-5px
  }
  .count-info .label{
    top:18px !important  
  }	
    .ss{
  	display: none
  }
  .cc{
 	 color: #F00
  }
</style>

</head>
<body class="fixed-sidebar full-height-layout gray-bg pace-done">
	<div id="wrapper" style="background: #2f4050; height: 100%;">
		<%@ include file="/common/left-nav.jsp"%>
		<div id="page-wrapper" class="gray-bg dashbard-1">
			<div class="row border-bottom">
				<nav class="navbar navbar-static-top fixtopmain" role="navigation" style="margin-bottom: 0">
				    <%@ include file="/common/top-index.jsp"%>
				</nav>
			</div>
			<div class="wrapper wrapper-content">
<!--综合统计信息《包含年、季度、月、周》 -->
				<c:if test="${operator_session.qx_maingetMonth}">
					<div class="row"> 
						<div style="margin-left:14px">
							<!-- 查找收入，销售机会，入学人数 -->
							<input type="button" class="btn btn-primary btn-outline btn-sm" id="week" onclick ="zhou()" value="本周">
							<input type="button" class="btn btn-danger btn-outline btn-sm" id="month" onclick ="yigeyue()" value="本月">
							<input type="button" class="btn btn-warning btn-outline btn-sm" id="thMonth" onclick ="sangeyue()" value="本季度">
							<input type="button" class="btn btn-success btn-outline btn-sm" id="year" onclick ="yinian()" value="本年度">
							<div style="height:10px"></div>
						</div>	
						<div class="col-lg-12">
							<div class="ibox float-e-margins">
								<div class="ibox-title">
									<h5>订单</h5>
									<div class="pull-right">
										<div class="btn-group">
											<button type="button" class="btn btn-xs btn-white active">天</button>
										</div>
									</div>
								</div>
								<div class="ibox-content">
									<div class="row">
										<div class="col-lg-9">
											<div class="flot-chart">
												<div class="flot-chart-content" id="flot-dashboard-chart"></div>
											</div>
										</div>
										<div class="col-lg-3">
											<ul class="stat-list">
												<li>
													<h2 class="no-margins" id="userOrders" ></h2> <small id="dingdan">订单总数(周、月、年/单)</small>
													<div class="stat-percent">
													</div>
													<div class="progress progress-mini">
														<div style="width: 0;" class="progress-bar"></div>
													</div>
												</li>
												<li>
													<h2 class="no-margins" id="totalOrders" ></h2> <small id="fukuan">付款总数(周、月、年/单)</small>
													<div class="stat-percent">
													</div>
													<div class="progress progress-mini">
														<div style="width: 0;" class="progress-bar"></div>
													</div>
												</li>
												<li>
													<h2 class="no-margins" id="totalNum"></h2> <small id="jine">付款金额（周.月.年/RMB）</small>
													<div class="stat-percent">
													</div>
													<div class="progress progress-mini">
														<div style="width: 0;" class="progress-bar"></div>
													</div>
												</li>
											</ul>
										</div>
									</div>
								</div>
	
							</div>
						</div>
					</div>
				</c:if>
		
<!--教师相关数据信息-->
				<c:if test="${operator_session.qx_mainteachermessage}">
					<div> 
						<div class="ibox-title" style="height:52px; ">
							<h5><span id="teacher">${_res.get('Your_course_information_today')}</span></h5>
							<div id="showcourseplanmessage" style="float: right;"></div>
						</div>
						<div class="ibox-content">
							<table id="coursemessage" class="table table-hover table-bordered" width="100%">
								</table>
						</div>
					</div>
				</c:if>			
			<div class="footer">
				<div class="pull-right">
					<a href="http://www.yunjiaowu.cn" target="_blank">BY：YunJiaoWu.CN</a>
				</div>
				<div>
					<strong>Copyright</strong> 云教务 &copy; 2015-${copyrighYear }
				</div>
			</div>
		</div>
	</div>

	<!-- Mainly scripts -->

	<script src="/js/js/bootstrap.min.js?v=3.3.0"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

	<!-- Flot -->
	<script src="/js/js/plugins/flot/jquery.flot.js"></script>
	<script src="/js/js/plugins/flot/jquery.flot.tooltip.min.js"></script>
	<script src="/js/js/plugins/flot/jquery.flot.spline.js"></script>
	<script src="/js/js/plugins/flot/jquery.flot.resize.js"></script>
	<script src="/js/js/plugins/flot/jquery.flot.pie.js"></script>
	<script src="/js/js/plugins/flot/jquery.flot.symbol.js"></script>
	
    <!-- Peity -->
	<script src="/js/js/plugins/peity/jquery.peity.min.js"></script>
	<script src="/js/js/demo/peity-demo.js"></script>

	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=2.0.0"></script>
	<script src="/js/js/plugins/pace/pace.min.js"></script>

	<!-- jQuery UI -->
	<script src="/js/js/plugins/jquery-ui/jquery-ui.min.js"></script>

	<!-- Jvectormap -->
	<script src="/js/js/plugins/jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
	<script
		src="/js/js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

	<!-- EayPIE -->
	<script src="/js/js/plugins/easypiechart/jquery.easypiechart.js"></script>

	<!-- Sparkline -->
	<script src="/js/js/plugins/sparkline/jquery.sparkline.min.js"></script>

	<!-- Sparkline demo data  -->
	<script src="/js/js/demo/sparkline-demo.js"></script>
	
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/plugins/layer/layer.min.js"></script>
    <script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <!-------- 自定义部分 -------------->
    	
	<script type="text/javascript">
		//其他
		function gd(year, month, day) { //返回年月日
			return new Date(year, month - 1, day).getTime();
		}
		function feedbackmouseover(id){
			$("#"+id).show();
		}
		 function feedbackmove(id){
			$("#"+id).hide();
		} 
	
	</script>
	
    <script type="text/javascript">
     
	//周
	function zhou(){
		$("#dingdan").text("订单总数(周/单)");
		$("#fukuan").text("付款 总数(周/单)");
		$("#jine").text("付款 总数(周/RMB)");
		$("#shouru").text("周");
		$("#jihui").text("周");
		$("#xuesheng").text("周");
		$("#keshi").text("周");
		$("#week").addClass("btnback-week");
		$("#month").removeClass("btnback-month");
		$("#thMonth").removeClass("btnback-thMonth");
		$("#year").removeClass("btnback-year");
		myajax("/main/getWeek/week");
	}
	</script>
    <script type="text/javascript">
	//一个月
	function yigeyue(){
		$("#dingdan").text("订单总数(月/单)");
		$("#fukuan").text("付款 总数(月/单)");
		$("#jine").text("付款 总数(月/RMB)");
		$("#shouru").text("月");
		$("#jihui").text("月");
		$("#xuesheng").text("月");
		$("#keshi").text("月");
		$("#month").addClass("btnback-month");
		$("#week").removeClass("btnback-week");
		$("#thMonth").removeClass("btnback-thMonth");
		$("#year").removeClass("btnback-year");
		myajax("/main/getWeek/month");
	}
	</script>
    <script type="text/javascript">
	//三个月
	function sangeyue(){
		$("#dingdan").text("订单总数(季度/单)");
		$("#fukuan").text("付款 总数(季度/单)");
		$("#jine").text("付款 总数(季度/RMB)");
		$("#shouru").text("季度");
		$("#jihui").text("季度");
		$("#xuesheng").text("季度");
		$("#keshi").text("季度");
		$("#thMonth").addClass("btnback-thMonth");
		$("#month").removeClass("btnback-month");
		$("#week").removeClass("btnback-week");
		$("#year").removeClass("btnback-year");
		myajax("/main/getWeek/quarter");
	}
	</script>
    <script type="text/javascript">
	//一年
	function yinian(){
		$("#dingdan").text("订单总数(年/单)");
		$("#fukuan").text("付款 总数(年/单)");
		$("#jine").text("付款 总数(年/RMB)");
		$("#shouru").text("年");
		$("#jihui").text("年");
		$("#xuesheng").text("年");
		$("#keshi").text("年");
		$("#year").addClass("btnback-year");
		$("#thMonth").removeClass("btnback-thMonth");
		$("#month").removeClass("btnback-month");
		$("#week").removeClass("btnback-week");
		myajax("/main/getYear");
	}
	</script>
	
	<script type="text/javascript">
	function myajax(uri){
		$.ajax({
			url : "${cxt}"+uri,
			type : "post",
			dataType : "json",
			success : function(r){
				$("#income1").text(r.income);//收入
				$("#saleyear1").text(r.saleyear);//销售机会
				$("#stunum1").text(r.stunum);//学生人数
				$("#coursenum1").text(r.coursenum);//课时
				////////////////////////
				$("#userOrders").text(r.userOrders);//订单总数(x/单)
				$("#totalOrders").text(r.totalOrders);//付款总数(x/单)
				$("#totalNum").text(r.totalNum);//付款总数(x/RMB)
				//图表///////////////////
				$('.chart').easyPieChart({
					barColor : '#f8ac59',
					//scaleColor: false,
					scaleLength : 5,
					lineWidth : 4,
					size : 80
				});
				$('.chart2').easyPieChart({
					barColor : '#1c84c6',
					//scaleColor: false,
					scaleLength : 5,
					lineWidth : 4,
					size : 80
				});
				var obj1 = new Array();
				var obj2 = new Array();
				for(var i=0;i<r.data1.length;i++){
					var omap = new Array();
					omap.push(r.data1[i].time);
					omap.push(r.data1[i].value);
					obj1.push(omap);
				}
				for(var j=0;j<r.data2.length;j++){
					var pmap = new Array();
					pmap.push(r.data2[j].time);
					pmap.push(r.data2[j].value);
					obj2.push(pmap);
					
				}
				
				var data1 = obj1;
				var data2 = obj2; 
				var dataset = [ {
					label : "订单数",
					data : data1,
					color : "#1ab394",
					bars : {
						show : true,
						align : "center",
						barWidth : 24 * 60 * 60 * 600,
						lineWidth : 0
					}

				}, {
					label : "付款数",
					data : data2,
					yaxis : 2,
					color : "#464f88",
					lines : {
						lineWidth : 1,
						show : true,
						fill : true,
						fillColor : {
							colors : [ {
								opacity : 0.2
							}, {
								opacity : 0.2
							} ]
						}
					},
					splines : {
						show : false,
						tension : 0.6,
						lineWidth : 1,
						fill : 0.1
					},
				} ];
				
				var options = {
						xaxis : { //月份显示
							mode : "time",
							tickSize : [ 1, "day" ],
							tickLength : 0,
							axisLabel : "Date",
							axisLabelUseCanvas : true,
							axisLabelFontSizePixels : 12,
							axisLabelFontFamily : 'Arial',
							axisLabelPadding : 10,
							color : "#838383"
						},
						yaxes : [ { //付款额
							position : "left",
							max : r.maxdata1,
							color : "#838383",
							axisLabelUseCanvas : true,
							axisLabelFontSizePixels : 12,
							axisLabelFontFamily : 'Arial',
							axisLabelPadding : 3
						}, {
							position : "right",//订单数
							clolor : "#838383",
							axisLabelUseCanvas : true,
							axisLabelFontSizePixels : 12,
							axisLabelFontFamily : ' Arial',
							axisLabelPadding : 67
						} ],
						legend : { //订单数、付款数图片说明
							noColumns : 1,
							labelBoxBorderColor : "#000000",
							position : "nw"
						},
						grid : {//图表总的外围
							hoverable : false,
							borderWidth : 0,
							color : '#838383'
						}
					};
				
				var previousPoint = null, previousLabel = null;

				$.plot($("#flot-dashboard-chart"), dataset, options);
				
			}
		});
	}
	</script>
	<script type="text/javascript">
	//反馈消息
	function fankui(){
		$.ajax({
			url:"${cxt}/feedback/queryFeedbackJson",
			data : {
				"count" : 7
			},
			type:"post",
			dataType:'json',
			success:function(data){
				if (data.code == '1'){
					var str="";
					$("#feedbacklength").html("你有"+data.list.length+"条最新反馈消息。");
					for(var i = 0; i < data.list.length; i++){
						str += "<div class='feed-element' onmouseout='feedbackmove("+data.list[i].ID+")' onmouseover='feedbackmouseover("+data.list[i].ID+")'><div><small class='pull-right text-navy' id='"+data.list[i].ID+"'>反馈人："+data.list[i].FEEDNAME+"</small><strong></strong>"
						var feedbackmsg = data.list[i].CONTENT;
						str += "<div>"+feedbackmsg+"</div><small class='text-muted'>"+data.list[i].CREATETIME+"</small></div></div>"
					}
					$("#feedbackmsg").html(str);
					
				}else{
					str += "<div class='feed-element'><div><small class='pull-right text-navy'></small><strong></strong><div>暂无反馈消息</div><small class='text-muted'></small></div></div>"
					$("#feedbackmsg").html(str);
				}
			}
		});
	}
		//今日回访销售机会信息
		function jihui(){
			$.ajax({
				url:"${cxt}/opportunity/checkTodayReturnMessage",
				type : 'post',
				data : {
					"count" : 11
				},
				dataType : 'json',
				success : function(data) {
					if(data.length != 0){
						var str = "";
						for(var i=0;i<data.length;i++){
							str += "<tr style='text-align:center'>";
							var isconver = data[i].ISCONVER;
							var name = data[i].REAL_NAME;
							var campusname = data[i].CAMPUS_NAME;
							var subname = data[i].NAMES;
							var client = data[i].CONTACTER;
							var sumroll = data[i].SUM;
							var a="";
							a+="\""+data[i].ID;
							a+=","+0+"\"";
							var sss = "";
							if(parseInt(sumroll)>0){
								sss+="<a onclick='feedBackRecord("+data[i].ID+")'>";
							}else{
								sss+="<a>";
							}
							str += "<td>"
									//+ "<span class='label label-primary'>"+(isconver==0?"${_res.get('Opp.No.follow-up')}":isconver==1?"已成单":isconver==2?"跟进中":isconver==3?"考虑中":isconver==4?"无意向":isconver==6?"有意向":"")+"<span>"
									+"<label id ='z_"+data[i].ID+"' "
									+" class="+(isconver==0?'"btn btn-info btn-xs"':isconver==1?'"btn btn-success btn-xs"':isconver==2?'"btn btn-primary btn-xs"':isconver==3?'"btn btn-danger btn-xs"':isconver==4?'"btn btn-default btn-xs"':isconver==6?'"btn btn-warning btn-xs"':'"btn btn-default btn-xs"')+">"
									+(isconver==0?"${_res.get('Opp.No.follow-up')}":isconver==1?"${_res.get('Is.a.single')}":isconver==2?"${_res.get('Opp.Followed.up')}":isconver==3?'考虑中':isconver==4?'无意向':isconver==6?'有意向':'')+""
									+"</label>"
									+ "</td><td>"
									+ name
									+ "</td><td>"
									+ campusname
									+ "</td><td>"
									+ subname
									+ "</td><td>"
									+ client + "</td><td>"
									+data[i].PHONENUMBER 
									+"</td><td>"
									+sss
									+"<input type='button' readonly class='btn btn-success btn-outline btn-xs' id ='s_"+data[i].ID+"' value='"+sumroll+"'/>"
									+ "</a></td><td>"
									+ "<a onclick='writeFeedBack("+a+")' >回访</a>"
									+"</td></tr>"; 
						}
						$("#returnvisit").html(str);
					}else {
						str += "<tr><td colspan='6'>今日没有需要回访客户</td></tr>";
						$("#returnvisit").html(str);
					}
				}
			});	
		}
		
	</script>
	<script type="text/javascript">
	function queryCoTM(code){
		$.ajax({
			url : "/teacher/getTeacherCourHour",
			data : {"code":code},
			type : "post",
			dataType : "json",
			async : false,
			success : function(result) {
				/* $("#teacher").text(result.teacher.REAL_NAME); */
				$("#income3").text(result.month.CLASSHOUR==null?'0':result.month.CLASSHOUR);
				$("#saleyear3").text(result.today.CLASSHOUR==null?'0':result.today.CLASSHOUR);
				$("#coursenum3").text(result.sign0.TDCOUNT);
				$("#stunum3").text(result.sign1.TDCOUNT);
				if(code==1){
					$("#kehsi").text("周");
					$("#yiqiandao").text("周");
					$("#weiqiandao").text("周");
				}else if(code==2){
					$("#kehsi").text("月");
					$("#yiqiandao").text("月");
					$("#weiqiandao").text("月");
				}else if(code==3){
					$("#kehsi").text("季度");
					$("#yiqiandao").text("季度");
					$("#weiqiandao").text("季度");
				}else if(code==4){
					$("#kehsi").text("年");
					$("#yiqiandao").text("年");
					$("#weiqiandao").text("年");
				}else{
					$("#kehsi").text("月");
					$("#yiqiandao").text("月");
					$("#weiqiandao").text("月");
				}
			}
		});
	}
	function sendNews(){
		$.layer({
    		type:2,
    		shadeClose:true,
    		title:"公告信息",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['900px','620px'],
    		iframe:{src:'${cxt}/teacher/sendMessage'}
    	});
	}
	function shows(id){
		$.ajax({
			url : "/teacher/updateState",
			data : {'arid':id},
			type : "post",
			dataType : "json",
			success:function(data){
				if(data==0){
					$("#c_"+id).removeClass('cc');
				}
			}
		})
		$("#i_"+id).addClass('ss');
		$("#s_"+id).removeClass('ss');
		$("#ii_"+id).removeClass('ss');
	}
	function updateStates(){
		$.ajax({
			url : "/teacher/updateStates",
			data : {},
			type : "post",
			dataType : "json",
			success:function(data){
				if(data==0){
					layer.msg("已全部标记为已读",1,1);
				}
				setTime("getReceiveMessage();",1000);
			}
		})
	 }
	function hides(id){
		$("#s_"+id).addClass('ss');
		$("#i_"+id).removeClass('ss');
		$("#ii_"+id).addClass('ss');
	}
	function showsend(id){
		$("#y_"+id).addClass('ss');
		$("#r_"+id).removeClass('ss');
		$("#yy_"+id).removeClass('ss');
	}
	function hidesend(id){
		$("#y_"+id).removeClass('ss');
		$("#r_"+id).addClass('ss');
		$("#yy_"+id).addClass('ss');
	}
	/*获取接收信息*/
		function getReceiveMessage(){
			$.ajax({
					url : "/teacher/getTeacherReceiveMessage",
					data : {},
					type : "post",
					dataType : "json",
					success:function(result){
						var str="";
						if (result.lista.length!=0){
							$("#feedbacklengths").html("你有"+result.newmessage+"条信息未读");
							for(i in result.lista){
								str +=  "<div class='feed-element'>";
								str +="<small class='pull-right text-navy'>发送人："+result.lista[i].REAL_NAME;
								str +="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								str +="<span  id='i_"+result.lista[i].ARID+"'><a onclick='shows("+result.lista[i].ARID+")'> 查看</a></span>";
								str +="<span class='ss' id='ii_"+result.lista[i].ARID+"'><a onclick='hides("+result.lista[i].ARID+")'> 收起</a></span>";
								str +="<a  onclick='replyMessage("+result.lista[i].ARID+")' >&nbsp;|&nbsp;回复</a>";
								str +="</small><strong></strong>";
								if(result.lista[i].STATE=='0'){
									str += "<div class='cc' id='c_"+result.lista[i].ARID+"'>标题:"+result.lista[i].TITLE+"</div> ";
								}else{
									
									str += "<div >标题:"+result.lista[i].TITLE+"</div><br>";
								}
								str +=  "<div class='ss'  id='s_"+result.lista[i].ARID+"'><small class='text-muted' ><span style='font-family:华文中宋; color:blue;'>内容:</span>"+result.lista[i].CONTENT+"</small></div></div><br>";
							}
							$("#feedbackmsgs").html(str);
						}else{
							str += "<div class='feed-element'><div><small class='pull-right text-navy'></small><strong></strong><div>暂无公告消息</div><small class='text-muted'></small></div></div>"
							$("#feedbacklengths").html("你有0条信息未读");
							$("#feedbackmsgs").html(str);
						}
					}
				})
		 }
	
	/*获取发送公告信息*/
	function getSendMessage(){
		$.ajax({
			url : "/teacher/getTeacherSendMessage",
			data : {},
			type : "post",
			dataType : "json",
			success:function(data){
				var str="";
				if(data.length!=0){
					$("#sends").html("你已发送"+data.length+"条公告");
					for(i in data){
						if(i<=10){
							var s="";
							str +=  "<div class='feed-element'>";
							str +=	"<small class='pull-right text-navy' >发送时间："+data[i].SENDTIME;
							str +=	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
							str +=  "<span  id='y_"+data[i].ID+"'><a onclick='showsend("+data[i].ID+")'>查看</a></span>";
							str +=  "<span class='ss' id='yy_"+data[i].ID+"'><a onclick='hidesend("+data[i].ID+")'>收起</a></span>";
							//str +=  "<input type='button' class='btn btn-outline btn-info'  onclick='updateMessage("+data[i].ID+")' value='编辑'>";
							str +=  "<a  onclick='deleteMessage("+data[i].ID+")' >&nbsp;|&nbsp;删除</a>";
							str +=	"</small><strong></strong>";
							str += "<div >标题:"+data[i].TITLE+"</div><br>";
							str +=  "<div class='ss'  id='r_"+data[i].ID+"'><small class='text-muted' ><span style='font-family:华文中宋; color:blue;'>内容:</span>"+data[i].CONTENT+"</small><br>";
							for(j in data[i].USERS){
								if(data[i].USERS[j].STATE==0){
									s+="<span>"+data[i].USERS[j].REAL_NAME+"(未读)、</span>";
								}else{
									s+="<span>"+data[i].USERS[j].REAL_NAME+"(已读)、</span>";
								}
							}
							
							str +="<span style='font-family:华文中宋; color:blue;'>接收人："+s+"</span></div></div><br>";
						}else{
							break;
						}
					}
					$("#sendmessage").html(str);
				}else{
					$("#sends").html("你已发送0条公告");
					str += "<div class='feed-element'><div><small class='pull-right text-navy'></small><strong></strong><div>暂未发送过公告</div><small class='text-muted'></small></div></div>"
					$("#sendmessage").html(str);
				}
			}
		})
	}
	/*获取课程信息*/
	function getTeacherCourseMessage(){
		$.ajax({
			url : "/teacher/getTeacherCourseMessage",
			data : {},
			type : "post",
			dataType : "json",
			success:function(data){
				var course="";
				if(data.tlist.length!=0){
					var vu ="";
					course+="<tr>";
					course+="<th>${_res.get('course.course')}</th>";
					course+="<th>${_res.get('student.name')}</th>";
					course+="<th>${_res.get('system.campus')}</th>";
					course+="<th>${_res.get('class.classroom')}</th>";
					course+="<th>${_res.get('date')}</th>";
					course+="<th>${_res.get('time')}</th>";
					course+="<th>${_res.get('operation')}</th>";
					course+="</tr>";
					for(i in data.tlist){
						vu+="<input type='hidden' id='rr_"+data.tlist[i].ID+"' value='"+data.tlist[i].RANKTIME+"'>";
						vu+="<input type='hidden' id='cc_"+data.tlist[i].ID+"' value='"+data.tlist[i].CTIME+"'>";
						course+="<tr align='center'><td>"+data.tlist[i].COURSENAME+"</td>";
						course+="<td>"+data.tlist[i].STUDENTNAME+"</td>";
						course+="<td>"+data.tlist[i].CAMPUSNAME+"</td>";
						course+="<td>"+data.tlist[i].CRNAME+"</td>";
						course+="<td>"+data.tlist[i].CTIME+"</td>";
						course+="<td>"+data.tlist[i].RANKTIME+"</td>";
						course+="<td>";
						if(data.tlist[i].SIGNIN==0){
							course+='<a  href="javascript:void(0)" onclick="signin('+data.tlist[i].ID+')">签到&nbsp|&nbsp</a>';
						}
						course+='<a  href="/knowledge/educationalManage?courseplanId='+data.tlist[i].ID+'" >日报</a>';
						course+="</td>";
						course+="</tr>";
					}
					if(data.t.KCUSERID==0){
						$("#showcourseplanmessage").append('<a class="btn btn-outline btn-info"  href="/course/courseSortListForMonth">您的排课信息有变动、请查看</a>');
					}
					$("#coursemessage").append(course);
					$("#hid").append(vu);
				}else{
					$("#coursemessage").append("<tr align='center'><td colspan='7'><span class='cc'>今日暂无课程</span></td></tr>");
				}
			}
		})	
	}
	/*获取预约信息*/
	function getReservationMessage(){
		/* $("#reservation").html(""); */
		$.ajax({
			url : "/teacher/getReservationMessage",
			data : {},
			type : "post",
			dataType : "json",
			success:function(data){
				var course="";
				if(data.length!=0){
					course+="<tr>";
					course+= "<th>${_res.get('student.name')}</th> <th>${_res.get('system.campus')}</th> <th>${_res.get('class.classroom')}</th>";
					course+= "<th>${_res.get('date')}</th>";
					course+= "<th>${_res.get('time')}</th>";
					course+= "<th>操作人</th>";
					course+= "<th>操作</th>";
					course+=  "</tr>";
					for(i in data){
						course+="<tr align='center'>";
						course+="<td>"+data[i].STUDENTNAME+"</td>";
						course+="<td>"+data[i].CAMPUSNAME+"</td>";
						course+="<td>"+data[i].ROOMNAME+"</td>";
						course+="<td>"+data[i].RESERVATIONTIME+"</td>";
						course+="<td>"+data[i].RANKNAME+"</td>";
						course+="<td>"+data[i].USERNAME+"</td>";
						course+="<td>";
						if(data[i].STATE==1){
							course+='<a  href="javascript:void(0)" onclick="isReservation('+data[i].ID+')">同意&nbsp|&nbsp</a>';
							course+='<a  href="javascript:void(0)" onclick="refuseReservation('+data[i].ID+')">拒绝</a>';
						}else if(data[i].STATE==2){
							course+='<a  href="/reservation/index" >详情</a>';
						}else{
							course+='<a  href="javascript:void(0)" >已拒绝</a>';
						}
						
						course+="</td>";
						course+="</tr>";
					}
					$("#reservation").append(course);
				}else{
					$("#reservation").append("<tr align='center'><td colspan='7'><span class='cc'>暂无信息</span></td></tr>");
				}
			}
		})
	}
	/*删除*/
	function deleteMessage(id){
		if(confirm("确定删除吗?")){
			$.ajax({
				url : "/teacher/deleteTeacherSendMessage",
				data : {'id':id},
				type : "post",
				dataType : "json",
				success:function(data){
					if(data==0){
						layer.msg("删除成功",1,1);
					}else{
						layer.msg("删除失败，请联系管理员",2,1);
					}
					setTimeout("getSendMessage();",1000);
				}
			})
		}
	}
	/*编辑*/
	function updateMessage(id){
		$.layer({
    		type:2,
    		shadeClose:true,
    		title:"公告信息",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['900px','620px'],
    		iframe:{src:'${cxt}/teacher/updateTeacherSendMessage/'+id}
    	});
	}
	/*回复*/
	 function replyMessage(id){
    	$.layer({
    		type:2,
    		shadeClose:true,
    		title:"回复",
    		closeBtn:[0,true],
    		shade:[0.5,'#000'],
    		border:[0],
    		area:['400px','160px'],
    		iframe:{src:'${cxt}/teacher/replyReceiver/'+id}
    	});
    }
	/*签到*/
	function signin(id) {
		var TIMENAME = $("#rr_"+id).val();
		var courseplan_id = id;
		var courseTime = $("#cc_"+id).val();
		$.ajax({
			url : "/course/siGninCourese?courseplan_id=" + courseplan_id + "&&TIMENAME=" + TIMENAME + "&&courseTime=" + courseTime,
			dataType : "json",
			type : "post",
			success : function(result) {
				if (result.message == "no") {
					alert('${_res.get("educational_manage_1") }');
				} else if (result.message == "notearly") {
					alert('${_res.get("educational_manage_2") }');
				} else if (result.message == "NotDay") {
					alert('${_res.get("educational_manage_3") }');
				} else if (result.message == "short") {
					alert('${_res.get("educational_manage_4") }');
				} else if (result.message == "campusfullno") {
					alert('${_res.get("educational_manage_5") }');
				} else if (result.message == "campuspartno") {
					alert('${_res.get("educational_manage_6") }');
				} else if (result.message == "ok") {
					layer.msg("签到成功",1,1);
				} else if (result.message == "not") {
					layer.msg("签到成功",2,1);
				} else if (result.message.late != "") {
					layer.msg("已迟到",2,1);
				}
				$("#coursemessage").html("");
				getTeacherCourseMessage();
			}
		})
	}
	/*同意*/
	function isReservation(studentid){
    	if(confirm("确认同意预约吗?")){
    		$.ajax({
    			url:'/reservation/isReservation',
    			type:'post',
    			data:{'id':studentid},
    			dataType:'json',
    			success:function(data){
    				if(data==0){
    					layer.msg("确认成功，信息已添加到查课表",1,1);
    				}else{
    					layer.msg("确认失败，请联系管理员",2,1);
    				}
    				$("#reservation").html("");
    				getReservationMessage();
    			}
    		})
    	}
    }
	/*拒绝*/
  function refuseReservation(){
    	if(confirm("确认拒绝预约吗?")){
    		$.ajax({
    			url:'/reservation/refuseReservation',
    			type:'post',
    			data:{'id':id},
    			dataType:'json',
    			success:function(data){
    				if(data==0){
    					layer.msg("已拒绝，并且此次预约测试信息已删除",1,1);
    				}else{
    					layer.msg("拒绝失败，请联系管理员",2,1);
    				}
    				$("#reservation").html("");
    				getReservationMessage();
    			}
    		})
    	}
    }
/*获取学生课程信息*/
function getStudentCourseMessage(){
	$.ajax({
		url : "/student/getStudentCourseMessage",
		data : {},
		type : "post",
		dataType : "json",
		success:function(data){
			var course="";
			if(data.length!=0){
				var vu ="";
				course+="<tr>";
				course+="<th>${_res.get('course.course')}</th>";
				course+="<th>${_res.get('teacher.name')}</th>";
				course+="<th>${_res.get('system.campus')}</th>";
				course+="<th>${_res.get('class.classroom')}</th>";
				course+="<th>${_res.get('date')}</th>";
				course+="<th>${_res.get('time')}</th>";
				/* course+="<th>${_res.get('operation')}</th>"; */
				course+="</tr>";
				for(i in data){
					/* vu+="<input type='hidden' id='rr_"+data[i].ID+"' value='"+data[i].RANKTIME+"'>";
					vu+="<input type='hidden' id='cc_"+data[i].ID+"' value='"+data[i].CTIME+"'>"; */
					course+="<tr align='center'><td>"+data[i].COURSE_NAME+"</td>";
					course+="<td>"+data[i].REAL_NAME+"</td>";
					course+="<td>"+data[i].CAMPUS_NAME+"</td>";
					course+="<td>"+data[i].NAME+"</td>";
					course+="<td>"+data[i].COURSE_TIME+"</td>";
					course+="<td>"+data[i].RANK_NAME+"</td>";
				/* 	course+="<td>";
					if(data[i].SIGNIN==0){
						course+='<a  href="javascript:void(0)" onclick="signin('+data[i].ID+')">签到&nbsp|&nbsp</a>';
					}
					course+='<a  href="/knowledge/educationalManage?courseplanId='+data[i].ID+'" >日报</a>';
					course+="</td>"; */
					course+="</tr>";
				}
				$("#studentcoursemessage").append(course);
				//$("#hid").append(vu);
			}else{
				$("#studentcoursemessage").append("<tr align='center'><td colspan='7'><span class='cc'>今日暂无课程</span></td></tr>");
			}
		}
	})	
}
	</script>
	
	<script type="text/javascript">
	$(document).ready(function(){
		setTimeout(function(){
			//预约信息和课程信息
			if('${operator_session.qx_teachergetTeacherSendMessage}'){
				 queryCoTM(2);
				 getReservationMessage();
				 getTeacherCourseMessage();
			}
		}, 4000);
		setTimeout(function(){
			//发送信息和接受信息
			if('${operator_session.qx_mainteachermessage}'){
				 getSendMessage();
				 getReceiveMessage();
			}
		}, 5000);
		setTimeout(function(){
			//综合统计
			if('${operator_session.qx_maingetMonth}'){
				yigeyue();
			}
		}, 500);
		setTimeout(function(){
			//反馈信息
			if('${operator_session.qx_feedbackqueryFeedbackJson}'){
				fankui();
			}
		}, 7000);
		setTimeout(function(){
			//今日回访
			if('${operator_session.qx_opportunitycheckTodayReturnMessage}'){
				jihui();
			}
		}, 8000);
		setTimeout(function(){
			//学生今日课程信息
			if('${isstudent}'){
				getStudentCourseMessage();
			}
		}, 9000);
	});
	</script>

</body>

</html>