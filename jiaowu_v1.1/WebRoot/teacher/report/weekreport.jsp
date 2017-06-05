<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>报告模板</title>
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
.container {width: 860px; margin: 0 auto;}
html,body,div,span,applet,object,iframe,h1,h2,h3,h4,h5,h6,p,blockquote,pre,a,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,q,s,samp,small,strike,strong,sub,sup,tt,var,b,u,i,center,dl,dt,dd,ol,ul,li,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	vertical-align: baseline;
	background: transparent;
}
ol, ul { list-style: none; }
blockquote, q { quotes: none; }

blockquote:before, blockquote:after, q:before, q:after { content: ''; content: none; }
/* remember to define focus styles! */
:focus { outline: 0; }
/* remember to highlight inserts somehow! */
ins,s { text-decoration: none; }
del { text-decoration: line-through;}
em,i {font-style:normal;}
/* Remove annoying border on linked images. */
a,img { border: none; text-decoration:none; }
a{text-decoration:none;}
a:hover{text-decoration:underline;}a:focus{outline:none;-moz-outline:none;}
a:active{outline:none;blr:expression(this.onFocus=this.blur())}
h1 {font-size: 36px;line-height: 45px;font-weight:normal;}
h2 {font-size: 24px;line-height: 30px;font-weight:normal;}
h3 {font-size: 18px;line-height: 22px;font-weight:normal;}
h4 {font-size: 16px;line-height: 20px;font-weight:normal;}
h5 {font-size: 14px;line-height: 18px;font-weight:normal;}
h6 {font-size: 12px;line-height: 16px;font-weight:normal;}
article, aside, details, figcaption, figure, footer, header, hgroup, menu, nav, section{display:block;}
.clearfix:before, .clearfix:after { content: ""; display: table; font-size:0 !important; line-height:0!important; height:0!important;}  
.clearfix:after { clear: both; }
.clear {clear: both;display: block;overflow: hidden;visibility: hidden;width: 0;height: 0;}
.fl {float: left;}.fr {float: right;}
.pr {position: relative; }.pa {position: absolute; }
.f-fH {font-family: 'SimHei';}.f-fM {font-family: 'Microsoft YaHei';}.f-fA {font-family: 'SimSun';}.f-fG {font-family: 'Georgia';}
.dis{display:block;}
.undis{display:none;}
.disIb {display:inline-block;}
.of{overflow: hidden;}
.vam {vertical-align: middle;}
.w1200 {margin-left: auto;margin-right: auto;width: 1200px;}
.tac {text-align:center;}
.mt30 {margin-top:30px;}
.ml30 {margin-left:35px;}
.mb30 {margin-bottom:30px;}
.mt15 {margin-top:13px;}
.ml20 {margin-left:20px;}
.mt7 {margin-top:7px;}
.c-master {color:#3278b7;}
.ml100 {margin-left:110px;}
.mb130 {margin-bottom:130px;margin-top:-24px;}
.vap {vertical-align:top;}
.head-pic {width: 861px;height: 179px;}
		.c-top-cont {margin-top: 15px;}
		.c-top-cont p,.c-title p { font: 16px/40px "Microsoft YaHei";color: #333;font-weight: bold;}
		.c-title {margin-top: 10px;}
		.c-title p {line-height: 30px;}
		.tar {text-align: right;}
		.c-middle-cont {margin-top: 20px;}
		.c-content {padding-left:35px;}
		.c-content ul li { list-style-image: url("./img/dot1.png");padding-left: 20px;padding-bottom: 5px;}
		.c-content ul li p {font: 16px/28px "Microsoft YaHei";color: #333;}
		.c-content ul li ol {padding-left: 25px;margin-top:5px;}
		.c-content ul li ol li { list-style-image: url("./img/dot2.png");padding-left: 15px;}
		th{
			border-right-width: 1px;
			border-bottom-width: 1px;
			border-right-style: solid;
			border-bottom-style: solid;
			border-right-color: #000;
			border-bottom-color: #000;
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000;
		}
		td{
			border-right-width: 1px;
			border-bottom-width: 1px;
			border-right-style: solid;
			border-bottom-style: solid;
			border-right-color: #000;
			border-bottom-color: #000;
		}
		
		table{
			border-left-width: 1px;
			border-left-style: solid;
			border-left-color: #000;
		}
		#s{
			white-space:pre-wrap;
		}
		tr{
			align=center;	
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
					<div>
						<%@include file="/teacher/report/menu.jsp" %>
						<h1>模版 1</h1>
					</div>
					<div class="container">
						<div class="head-pic" style="width: 100%;height: 320px;">
							<iframe style="width:120%;height:600px;border-style: none;" src="${cxt }/teacher/report/import_replace_head.jsp"></iframe>
						</div>
						<div class="clearfix c-top-cont of">
							<div class="fl">
								<p>Teachers:</p>
								<p>${teachername}</p>
							</div>
							<div class="fr tar">
								<p>Danny Weekly Report (Week)</p>
								<p>${studentname}</p>
							</div>
						</div>
						<div class="c-middle-cont">
							<div class="c-title">
								<h2>COMPLETED:</h2>
								<h2>已完成的内容:</h2>
							</div>
							<div>
								<div class="c-title">
									<p>Structure</p>
									<p>概要综述</p>
									<div id="s" >${teacherfeedback}</div>
								</div>
								<div class="c-title">
									<p>Academic Content</p>
									<p>学术方面</p>
									<div id="s" >${question}</div>
								</div>
								<div class="c-title">
									<p>Study Habits</p>
									<p>学习习惯</p>
									<div id="s" > ${method}</div>
								</div>
								<div class="c-title">
									<p>Behavior</p>
									<p>行为表现</p>
									<div id="s" >${homework}</div>
								</div>
								<div>
									<div class="c-title">
										<h2>TO DO:</h2>
										<h2>接下来的计划:</h2>
									</div>
									<div class="c-title">
										<p>Structure</p>
										<p>概要综述</p>
										<div id="s" >${nextteacherfeedback}</div>
									</div>
									<div class="c-title">
										<p>Academic Content</p>
										<p>学术方面</p>
										<div id="s" >${nextquestion}</div>
									</div>
									<div class="c-title">
										<p>Study Habits</p>
										<p>学习习惯</p>
										<div id="s" >${nextmethod}</div>
									</div>
									<div class="c-title">
										<p>Behavior</p>
										<p>行为表现</p>
										<div id="s" >${nexthomework}</div>
									</div>
								</div>
							</div>
							<div>
								<iframe style="width:120%;height:600px;border-style: none;" src="${cxt }/teacher/report/import_replace_tail.jsp"></iframe>
							</div>
						</div>
					</div>
			    </div>
			</div>
			</div>
			<div style="clear:both;"></div>
	</div>
	</div>	  
</div>  

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