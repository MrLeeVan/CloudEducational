<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="d" uri="/common/jfinal.tld"%>
<style type="text/css">
.fa {
    display: inline-block;
    font-family: FontAwesome;
    font-style: normal;
    font-weight: normal;
    line-height: 1;
    font-size-adjust: none;
    font-stretch: normal;
    font-feature-settings: normal;
    font-language-override: normal;
    font-kerning: auto;
    font-synthesis: weight style;
    font-variant: normal;
    font-size: inherit;
    text-rendering: auto;
}
</style>

<div class="navbar-header">
   <a class="navbar-minimalize minimalize-styl-2 btn btn-primary" href="#">
     <i class="fa fa-bars"></i>
   </a>
	<ul class="topright-nav" id ="topMessage">
	</ul>
</div>

<div class="top-index" >
	<ul class="nav navbar-top-links navbar-right nav-topwidth" id="nav-topwidth">
		
		<li class="dropdown">
			<a class="dropdown-toggle count-info" data-toggle="dropdown" href="index.html#"> 
				<i class="fa fa-bell"></i> 
				<span class="label label-primary" id="total" style="background:#1ab394;"></span>
			</a>
			<ul class="dropdown-menu dropdown-alerts">
				<c:if test="${operator_session.qx_studentbirthday}">
				<li><a href="#" onclick="toStudentBirthday()" id="tobirthday">
						<div>
							<i class="fa fa-birthday-cake"></i>&nbsp;学生生日提醒
							<!-- 所有 -->
							<span class="pull-right text-muted small" id="birthcounts"></span>
						</div>
				</a></li>
				<li class="divider"></li>
				</c:if>
				<c:if test="${operator_session.qx_reportteacherReports}">
					<li>
						<a href="/teacher/queryAllReceiver"  >
							<div>
								<i class="fa fa-comment"></i>&nbsp;消息提醒
								<span class="pull-right text-muted small" id="recvertions"></span>
							</div>
						</a>
					</li>
					<li class="divider"></li>
				</c:if>
				<c:if test="${operator_session.qx_leavemyAwaiting}">
					<li>
						<a href="/leave/myAwaiting"  >
							<div>
								<i class="fa fa-pencil"></i>&nbsp;学生请假审批
								<span class="pull-right text-muted small" id="approval"></span>
							</div>
						</a>
					</li>
					<li class="divider"></li>
				</c:if>
				
				<c:if test="${operator_session.qx_remindManagerlist}">
					<li><a href="/remindManager/list?_query.read=0">
							<div>
								<i class="fa fa-birthday-cake"></i>&nbsp;提醒记录
								<span class="pull-right text-muted small" id="remind"></span>
							</div>
					</a></li>
				</c:if>
			</ul>
		</li>
		
		<c:if test="${operator_session.qx_sysuserloginToWord }">
			 <li> <a href="http://u.yunjiaowu.cn"  target="view_window"> 旗舰版</a></li> 
		</c:if>
		
		<li class="guojihua">
			<span class="m-r-sm text-muted" style="margin-right:0px;">
				<d:dictList class_="btn btn-success btn-outline btn-xs" numbers="language" changefuc="" name="" defaultnumber="" style="" type="languagebutton" id=""></d:dictList>
			</span>
		</li>
        <li style="margin-right: 0px;"><a href="/account/exit"><i class="fa fa-sign-out"></i></a></li>
	</ul>
	
	<!-- 服务器 js 需要值  -->
	<input type="hidden" id="head" value="${head }">
	<input type="hidden" id="en" value="${en }">
</div>

<script type="text/javascript" src="/js/jquery.cookie.js"></script>
<!-- 本页面js 摘取  -->
<script type="text/javascript" src="/js/_view/common/top-index_jsp.js"></script>
