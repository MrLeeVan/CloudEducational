<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('subject_management')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet"/>
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script type="text/javascript">
	function delSubject(subjectId){
		if(confirm('确认删除该科目吗')){
			$.ajax({
				url:"/subject/delSubject1",
				type:"post",
				data:{"subjectId":subjectId},
				dataType:"json",
				success:function(result)
				{
					if(result.result=="true"){
						alert("删除成功");
						window.location.reload();
					}else{
						alert(result.result);
					}
				}
			});
		}
	}
	function modifyOrder(subjectId){
		var sortorder=$("#sortorder_"+subjectId).val();
		$.ajax({
			url:"/subject/modifySubjectOrder",
			type:"post",
			data:{"subjectId":subjectId,"sortOrder":sortorder},
			dataType:"json",
			success:function(result){
				if(result.result=="true"){
					$("#successMsg").html("操作成功");
					$("span").fadeOut(2000,function(){
						window.location.reload();
					});
				}else{
					alert(result.result);
				}
			}
		});
	}
</script>
<style type="text/css">
.btn1{
    margin:-32px 0 0 940px;
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1100px">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
 <div class="margin-nav">	
  <div class="col-lg-12">
     <div class="ibox float-e-margins">
       <div class="ibox-title">
         <h5><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; ${_res.get('subject_management')}</h5>
         <c:if test="${operator_session.qx_subjectaddSubjectManager }">
            <input type="button" value="导入科目" onclick="toImportBook()"  class="btn btn-outline btn-primary btn-xs" style="float:right">
         	<input type="button" id="tianjia" class="btn btn-outline btn-primary btn-xs" style="float:right" value="${_res.get('teacher.group.add')}" onclick="addSubject()"/>
         </c:if>
         <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          <div style="clear:both"></div>
       </div>
     <div class="ibox-content">
        <table class="table table-hover table-bordered">
           <thead>
				<tr>
					<th>${_res.get("index")}</th>
					<th>${_res.get('name.of.subject')}</th>
					<th>课程数量</th>
					<th>${_res.get("operation")}</th>
				</tr>
		   </thead>	
				<c:forEach items="${subject}" var="subject" varStatus="s">
				<tr align="center">
					<td>${s.count }</td>
					<td>${subject.subject_NAME }</td>
					<td>${subject.sumCourse} </td>
					<td>
					<%-- <c:if test="${operator_session.qx_courseadd }">
						<a href="javascript:void(0)" style="color:#515151" onclick="window.location.href='/course/add/${subject.id }'" >${_res.get('Add.courses')}</a>|
					</c:if> --%>
						<a href="/course/index?_query.subjectid=${subject.id}" target="_blank" style="color:#515151"  >课程管理</a>|
					<c:if test="${operator_session.qx_subjecteditSubjectManager }">
						<a href="javascript:void(0)" style="color:#515151" onclick="moditySubject(${subject.id })" >${_res.get('Modify')}</a>|
					</c:if>
					<c:if test="${operator_session.qx_subjectdelSubject1 }">
						<a href="javascript:void(0)" style="color:#515151" onclick="delSubject(${subject.id})" >${_res.get('admin.common.delete')}</a>|
					</c:if>
					<a href="javascript:void(0)" onclick="toImportCourse(${subject.id })" style="color:#515151">${_res.get('Opp.Import')}课程</a>
					</td>	
				</tr>
				</c:forEach>
		</table>
     </div>
    </div>
  </div>
  <div style="clear: both;"></div>
  </div>
  </div>
  
  <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    <!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script>
       $('li[ID=nav-nav7]').removeAttr('').attr('class','active');
    </script>
    <script type="text/javascript">
    function addSubject(){
    	$.layer({
	        type: 2,
	        title: "${_res.get('teacher.group.add')} ${_res.get('course.subject')}",
	        maxmin: false,
	        shadeClose: true, //开启点击遮罩关闭层
	        area : ['400px' , '160px'],
	        offset : ['', ''],
	        iframe: {src: "/subject/editSubjectManager"}
	    });
    }
    function moditySubject(id){
    	$.layer({
	        type: 2,
	        title: "${_res.get('Modify')} ${_res.get('course.subject')}",
	        maxmin: false,
	        shadeClose: true, //开启点击遮罩关闭层
	        area : ['400px' , '300px'],
	        offset : ['80px', ''],
	        iframe: {src: "/subject/editSubjectManager/"+id}
	    });
    }
    
  //导入科目
    function toImportBook(){
		$.layer({
		    type: 2,
		    shadeClose: true,
		    title: "导入科目",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['500px', '300px'],
		    iframe: {src: "${cxt}/subject/importSubjects"}
		});
	}
  
    //导入课程
    function toImportCourse(id){
		$.layer({
		    type: 2,
		    shadeClose: true,
		    title: "导入课程",
		    closeBtn: [0, true],
		    shade: [0.5, '#000'],
		    border: [0],
		    offset:['20px', ''],
		    area: ['500px', '600px'],
		    iframe: {src: "${cxt}/subject/importCourses/"+id}
		});
	}
    </script>
</div>  
</body>
</html>