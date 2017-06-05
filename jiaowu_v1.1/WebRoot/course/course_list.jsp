<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('course.list')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">

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
 .xubox_tabmove{
	background:#EEE;
}
.xubox_tabnow{
    color:#31708f;
}
</style>
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
		<form action="/course/${empty teacher.id ?'index':'toManageCoursePage'}" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
				&gt;<a href='/subject/findSubjectManager'>${_res.get('subject_management')}</a> &gt;${_res.get('course.list')}
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content">
				<label>${_res.get('course.course')}：</label>
					<input type="text" id="coursename" name="_query.coursename" value="${paramMap['_query.coursename']}">
				<label>${_res.get('course.subject')}：</label>
				<select id="subjectid" name="_query.subjectid" class="chosen-select" style="width:150px;">
					<option value="">${_res.get('system.alloptions')}</option>
					<c:forEach items="${subject}" var="subject">
						<option value="${subject.id }" ${subject.id == paramMap['_query.subjectid']?"selected='selected'":"" }>${subject.subject_name }</option>
					</c:forEach>
				</select>
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">
				<input type="button" value="${_res.get('Reset')}" onclick="chongzhi()" class="button btn btn-outline btn-warning ">
				<c:if test="${operator_session.qx_courseadd }">
				<input type="button" id="tianjia" value="${_res.get('teacher.group.add')}" onclick="addCourse()" class="btn btn-outline btn-info">
				</c:if>
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<c:if test="${empty teacher.id }">
							<h5>${_res.get('course.list')}</h5>			
						</c:if>
				        <c:if test="${!empty teacher.id }">
						    <div>
						        <label>${teacher.REAL_NAME } 老师的课程设置</label>
							    <input type="hidden" name="teacherId" id="teacherId" value="${teacher.id}" />
									<input type="hidden" name="version" id='version' value="${teacher.version + 1}">
								<input type="button" value="保存设置" class="btn btn-info btn-sm"  onclick="baocun(${teacher.id})">
						  	</div>
						</c:if>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
							<thead>
								<tr>
									<th><label><input type="checkbox" id="check" name="courseids" value="${course.id },${course.SUBJECT_ID}" onchange="xuanze()" >&nbsp;&nbsp;${_res.get("index")}</label></th>
									<th width="18%">${_res.get('course.course')}</th>
									<th width="18%">${_res.get('course.subject')}</th>
									<!-- th width="10%">课程单价</th -->
									<th width="5%">${_res.get('admin.dict.property.status')}</th>
									<th width="34%">${_res.get("course.remarks")}</th>
									<th width="10%">${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="course" varStatus="index">
								<tr>
								   <td align="center"> 
								   		<label>
									     	<input type="checkbox" name="courseids" id="box" onchange="del(this)" value="${course.id },${course.SUBJECT_ID},${teacher.id}" 
									     	${ course.isChoose == 1 ? 'checked="checked"':'' }>
									     	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${index.count}
								   		</label>
								   </td>
									<%-- <td align="center">${index.count }</td> --%>
									<td>${course.course_name}</td>
									<td>${course.subject_name}</td>
									<!-- td>${course.unit_price}元/${_res.get('session')}</td -->
									<td align="center">${course.state==1?_res.get('admin.dict.property.status.stop'):_res.get("normal")}</td>
									<td>${course.remark}</td>
									<td align="center">
									<c:if test="${operator_session.qx_courseedit }">
										<a href="javascript:void(0)" style="color:#515151" onclick="updateCourse(${course.id })"
										 >${_res.get('Modify')}</a>|
									</c:if>
										<c:if test="${operator_session.qx_coursedelCourse }">
										<c:choose>
										<c:when test="${course.state==1}">
											<a style="color:#515151" href="javascript:void(0)" onclick="delCourse(${course.id },0)" >${_res.get('admin.dict.property.status.start')}</a>
										</c:when>
										<c:otherwise>
											<a style="color:#515151" href="javascript:void(0)" onclick="delCourse(${course.id },1)" >${_res.get('admin.dict.property.status.stop')}</a>
										</c:otherwise>
									</c:choose>	
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
			<div style="clear: both;"></div>
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
    <script type="text/javascript">
    function addCourse(){
	  $.layer({
	      	    type: 2,
	      	    shadeClose: true,
	      	    title: "${_res.get('Add.courses')}",   
	      	    closeBtn: [0, true],
	      	    shade: [0.5, '#000'],
	      	    border: [0],
	      	    area: ['460px', '300px'],
	      	    iframe: {src: '${cxt}/course/add'}
	      	});
    }
    function updateCourse(id){
  	  $.layer({
  	      	    type: 2,
  	      	    shadeClose: true,
  	      	    title: "${_res.get('Modify.course')}",   
  	      	    closeBtn: [0, true],
  	      	    shade: [0.5, '#000'],
  	      	    border: [0],
  	      	    area: ['460px', '300px'],
  	      	    iframe: {src: '${cxt}/course/edit/'+id}
  	      	});
      }
	function delCourse(courseId,state){
		if(confirm('确认对该课程状态进行修改吗？')){
			$.ajax({
				url:"/course/delCourse",
				type:"post",
				data:{"courseId":courseId,"state":state},
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
	function del(mthis){
		var courseids  =  "";
		var subjectids =  "";
		var teacherId  =  "";
		
		if(!$(mthis).is(":checked")){
			
			var arr = $(mthis).val().split(",");
    		courseids  = arr[0] ;
    		subjectids = arr[1] ;
    		teacherId  = arr[2] ;
    		
			layer.confirm('确认取消该课程？', function(){
	    		$.ajax({
	    			url:"/course/delAlerdyCourse",
	    			type:"post",
	    			dataType:"json",
	    			data:{
	    				"courseids" : courseids,
	    				"subjectids": subjectids,
	    				"teacherId" : teacherId
	    				},
	    			success:function(data){
	    					layer.msg(data.msg, 2, 1);
	    					parent.window.location.reload();
	    			}
	    		});
	    	});
		}
	}

	function chongzhi() {
		$('#coursename').val('');
	}
    function xuanze(){
    	if($("#check").is(":checked")){
    		$("[id='box']").each(function(){
    			$(this).prop("checked","checked");
    		})
    	}else{
    		$("[id='box']").each(function(){
    			$(this).prop("checked",false);
    		})
    	}
    }
    
    function baocun(teacherid){
    	var courseids="";
    	var subjectids="";
    	$("input[name='courseids']:checked").each(function(){
    		var arr = $(this).val().split(",");
    		courseids  += arr[0] + "|";
    		subjectids += arr[1] + "|";
    	})
    	
    	if(courseids.length==0){
    		layer.msg("没有选择课程");
    		return false;
    	}
    	layer.confirm('确认保存设置吗？', function(){
    		$.ajax({
    			url:"${cxt}/course/teacherCourseSave?teacherid=" + teacherid,
    			type:"post",
    			dataType:"json",
    			data:{
    				"courseids" : courseids,
    				"subjectids": subjectids
    				},
    			success:function(data){
    					layer.msg(data.msg, 2, 1);
    					parent.window.location.reload();
    			}
    		});
    	});
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
       $('li[ID=nav-nav7]').removeAttr('').attr('class','active');
    </script>
</body>
</html>