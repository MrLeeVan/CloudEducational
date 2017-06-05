<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>周报模板2</title>
<%@include file="/common/headExtraction.jsp" %>
<link href="/css/rangeSlider/css/ion.rangeSlider.css" rel="stylesheet">
<link href="/css/rangeSlider/css/ion.rangeSlider.skinFlat.css" rel="stylesheet">
<style type="text/css">
<!--
body table tr td {
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-bottom-style: solid;
	border-left-style: solid;
	border-bottom-color: #000;
	border-left-color: #000;
	/* line-height: 0; */
}

#border {
	background-color: #FFF;
	width: 715px;
}

.right-1 {
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #000;	
}

.not_bottom td{
	border-bottom-width: 0px;
}

.not_lerf{
	border-left-width: 0px;
}

.title1 {
 	background: rgb(99, 184, 108) none repeat scroll 0 0;
    padding: 0 5.4pt;
	color: rgb(204, 232, 207);
}

.title2 {
 	background: rgb(159, 211, 164) none repeat scroll 0 0;
    padding: 0 5.4pt;
}

.line-height_100{
	line-height: 100%;
}
-->
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
			  <div class="ibox "><!-- float-e-margins -->
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
						<h1>模版 2</h1>
					</div>
					<div class="container">
<!-- 模版内容  开始 -->
<table id="border" cellspacing="0" cellpadding="0">
  <tr>
    <td width="100%" class="not_lerf">
	    <div class="head-pic" style="width: 100%;height: 320px;">
			<iframe style="width:120%;height:600px;border-style: none;" src="${cxt }/teacher/report/import_replace_head_2.jsp"></iframe>
		</div>
	    <!-- <img src="/images/sendmail/logo_2.png" alt="" name="" width="715" height="168" /> -->
    </td>
  </tr>
  <tr>
    <td class="title1 right-1"><p ><strong>BASIC INFORMATION</strong></p></td>
  </tr>
  <tr>
    <td><table width="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td width="25%" class="not_lerf title2"><p >Student Name:</p></td>
        <td width="25%"><p ></p></td>
        <td width="25%" class="title2"><p >Course:</p></td>
        <td width="25%" class="right-1"><p ></p></td>
      </tr>
      <tr>
        <td class="not_lerf title2"><p >Student No.:</p></td>
        <td>&nbsp;</td>
        <td class="title2"><p >Teacher:</p></td>
        <td class="right-1">&nbsp;</td>
      </tr>
      <tr>
        <td class="not_lerf title2"><p >Student Grade:</p></td>
        <td>&nbsp;</td>
        <td class="title2"><p  >Date of Report:</p></td>
        <td class="right-1">&nbsp;</td>
      </tr>
      <tr class="not_bottom">
        <td class="not_lerf title2"><p>Current School:</p></td>
        <td>&nbsp;</td>
        <td class="title2">&nbsp;</td>
        <td class="right-1">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td class="title1 right-1"><p  ><strong>TAUGHT CONTENT</strong></p></td>
  </tr>
  <tr>
    <td><table width="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td width="50%" class="not_lerf title2"><p >Topics Covered From: </p></td>
        <td width="50%" class="title2 right-1"><p  >Topics to be Covered:</p></td>
      </tr>
      <tr class="not_bottom">
        <td class="not_lerf line-height_100">
        	<div>
              <p><u></u></p>
                <ul>
                    <li></li>
                    <li></li>
                    <li></li>
                    <li></li>
                </ul>
            </div>
         </td>
        <td class="right-1">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td class="title1 right-1"><p  ><strong>ACADEMIC PERFORMANCE:</strong></p></td>
  </tr>
  <tr>
    <td><table width="100%" cellspacing="0" cellpadding="0">
      <tr>
        <td width="34%" class="not_lerf title2"><p>Mastery of Course Content </p></td>
        <td width="66%" class="title2 right-1"><input class="ionrange" value="2"></td>
      </tr>
      <tr class="not_bottom">
        <td class="title2"><p >Class Participation and Attitude </p></td>
        <td class="title2 right-1"><input class="ionrange" value="2"></td>
      </tr>
    </table></td>
  </tr>
  <tr>
    <td class="title1 right-1"><p ><strong>COMMENTS:</strong></p></td>
  </tr>
  <tr>
    <td class="line-height_100 right-1"><p ></p></td>
  </tr>
  <tr>
    <td class="title1 right-1"><p ><strong>RECOMMENDATIONS:</strong></p></td>
  </tr>
  <tr>
    <td class="line-height_100 right-1">
    <ul>
      <li></li>
      <li></li>
    </ul></td>
  </tr>
  
</table>
<!-- 模版内容  结束 -->
							</div>
			     	  </div>
			     </div>
			</div>
			<div style="clear:both;"></div>
		</div>
	</div>
</div>
<script type="text/javascript" src="/js/ion-rangeSlider/ion.rangeSlider.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$(".ionrange").ionRangeSlider({
	    values: [
	        "Poor", "Unsatisfactory", "Satisfactory", "Good", "Excellent"
	    ],
	    type: 'single',
	    hasGrid: true
	});
	
});
</script>
</body>
</html>