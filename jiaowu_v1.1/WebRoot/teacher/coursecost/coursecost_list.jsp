<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html >
<html>
<head>
<title>课时费</title>
<%@ include file="/common/headExtraction.jsp" %>
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
		
		<div class="margin-nav" style="min-width:1000px;width:100%;">
	      <form action="" method="post" id="searchForm">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
				    <div class="ibox-title">
					   <h5>
						<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
						<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
						 &gt;<a href='/teacher/index?_query.state=0'>${_res.get("teacher_management")}</a> &gt; ${_res.get("faculty_list")}
						&gt;${_res.get('tuition.fee')}
					   </h5>
					</div>
					<div class="ibox-content">
						<label>${_res.get('tutor') }：</label>
						<input type="hidden" name="_query.teacherid" value="${splitPage.queryParam['teacherid']}" id="teacherid">
						<input type="text" name="_query.teachernames" value="${splitPage.queryParam['teachernames']}">
						<label>${_res.get('subject') }：</label>
						<input type="text" name="_query.coursenames" value="${splitPage.queryParam['coursenames']}">
						<button type="button" onclick="search()" class="btn btn-default">${_res.get('admin.top.search') }</button>
					</div>
				</div>
			</div>
			
			<c:if test="${splitPage.queryParam['teacherid'] != null}">
				<div class="col-lg-12">
					<div class="ibox float-e-margins">
					    <div class="ibox-title">
						   <h5>排课时自定义  ${splitPage.queryParam['teachernameview']}  老师的课时费设置</h5>
						</div>
						<div class="ibox-content">
							<div class="col-md-3 column">
								<label>是否开启排课时自定义课时费(全局)</label>
						 		<div class="onoffswitch">
		                             <input class="onoffswitch-checkbox" name="customSwitch" id="customSwitch" type="checkbox" value="open" ${customSwitch=="open"?"checked='checked'":"" } >
		                             <label class="onoffswitch-label" for="customSwitch">
		                                 <span class="onoffswitch-inner"></span>
		                                 <span class="onoffswitch-switch"></span>
		                             </label>
		                         </div>
		                         <br>
		                         <br>
		                         <button class="btn btn-primary" id="customSubmit" type="button"><i class="fa fa-check"></i>保存排课的课时费设置</button>
							</div>
	                        <div class="col-md-8 column">
								<label>排课时老师课时费下拉框值设置</label>
								<table class="table table-bordered">
									<tr>
										<c:if test="${fn:length(teacherCoursecost) == 0}">
											<td>
												<input type="text" name="customVal" value="0" style="width: 65px;" onblur="this.value=(isNaN(this.value)?0:this.value)"><br>
												<button class="btn btn-success btn-circle custom_add" type="button"><i class="fa fa-link"></i></button>
												<button class="btn btn-warning btn-circle custom_del" type="button"><i class="fa fa-times"></i></button>
											</td>
										</c:if>
										<c:if test="${fn:length(teacherCoursecost) > 0}">
											<c:forEach items="${teacherCoursecost }" var="v">
												<td>
													<input type="text" name="customVal" value="${v.yicost }" style="width: 65px;" onblur="this.value=(isNaN(this.value)?0:this.value)"><br>
													<button class="btn btn-success btn-circle custom_add" type="button"><i class="fa fa-link"></i></button>
													<button class="btn btn-warning btn-circle custom_del" type="button"><i class="fa fa-times"></i></button>
												</td>
											</c:forEach>
										</c:if>
									</tr>
								</table>
							</div>
							<div style="clear: both;"></div>
						</div>
					</div>
				</div>
			</c:if>
			
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>老师可教课程的课时费设置</h5>
					</div>
					<div class="ibox-content">
						<div>
							<label>注意：快速充填"本页"课时费，只＂充填＂不做＂保存＂操作</label>
							<input id="yicost_all" type="text" style="width: 100px;">
							<a id="yicost_all_save">充填一对一</a> &nbsp;&nbsp;&nbsp;&nbsp;
							<input id="xiaobancost_all" type="text" style="width: 100px;">
							<a id="xiaobancost_all_save">充填小班</a> &nbsp;&nbsp;&nbsp;&nbsp;
							<a class="btn btn-default" id="coursecostsave_all">保存本页充填的课时费</a>
							<input type="text" name="coursecost_length" value="0" style="width: 40px;" readonly>条
						</div>
						<table class="table table-striped copy" >
							<thead>
								<tr>
									<th width="40px">${_res.get('index') }</th>
									<th>${_res.get('teacher.name') }</th>
									<th>${_res.get('course.subject') }</th>
									<th>${_res.get('course.course') }</th>
									<th style="width: 120px;">${_res.get('IEP') }</th>
									<th style="width: 120px;">${_res.get('course.classes') }</th>
									<th style="width: 120px;">${_res.get('operation') }</th>
									<th>${_res.get('course.remarks') }</th>
								</tr>
							</thead>
							<c:forEach items="${splitPage.page.list}" var="v" varStatus="i">
								<tr class="odd" align="center">
									<td >${i.count}</td>
									<td >${v.REAL_NAME}</td>
									<td >${v.SUBJECT_NAME}</td>
									<td >${v.COURSE_NAME}</td>
									<td ><input class="yicost_x" id="yicost_${v.teacherid }_${v.courseid }"
										 type="text" value="${v.yicost}" style="width: 100px;"></td>
									<td ><input class="xiaobancost_x" id="xiaobancost_${v.teacherid }_${v.courseid }"
										 type="text" value="${v.xiaobancost}" style="width: 100px;"></td>
									<td >
										<input type="hidden" id="teacherid_${v.teacherid }_${v.courseid }" value="${v.teacherid }">
										<input type="hidden" id="courseid_${v.teacherid }_${v.courseid }" value="${v.courseid }">
										<a class="coursecostsave" 
											data-teacherid="${v.teacherid }" 
											data-courseid="${v.courseid }"
										>${_res.get('save') }</a>
									</td>
									<td ><textarea id="remark_${v.teacherid }_${v.courseid }" rows="1" cols="8">${v.REMARK}</textarea></td>
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
	<script type="text/javascript">
		/* 自定义函数开始 */
		$(document).ready(function() {

			//保存课时费
			$(".coursecostsave").on("click", function() {
				var index_load = layer.load();
				var mthis = $(this);
				var teacherid =  mthis.data("teacherid");
				var courseid =  mthis.data("courseid");
				
				var yicost = $("#yicost_" + teacherid + "_" + courseid).val();
				var xiaobancost = $("#xiaobancost_" + teacherid + "_" + courseid).val();
				var remark = $("#remark_" + teacherid + "_" + courseid).val();
				
				console.log("/teacher/coursecost/save ",
						{ "coursecost.teacherid": teacherid, "coursecost.courseid": courseid,
					"coursecost.yicost": yicost, "coursecost.xiaobancost":xiaobancost });
				
				$.post("/teacher/coursecost/save",
					{ "coursecost_length": 1,
					"coursecost_0.teacherid": teacherid, "coursecost_0.courseid": courseid,
					"coursecost_0.yicost": yicost, "coursecost_0.xiaobancost":xiaobancost,
					"coursecost_0.remark": remark 
					},
					function(ret) {
						if (ret) {
							layer.msg("成功", 1, 6);
							//parent.window.location.reload();
						} else {
							layer.msg("失败", 1, 2);
						}
						layer.close(index_load);
					}
				);
			});
			
			
			//批量保存
			$("#coursecostsave_all").on("click", function() {
				layer.confirm('确认批量保存本页课时费?', function(index){
					var index_load = layer.load();
					var coursecostsave = $(".coursecostsave");
					$('input[name="coursecost_length"]').val(coursecostsave.length);
					coursecostsave.each(function(i){
						//$(this).trigger("click");
						var mthis = $(this);
						var teacherid =  mthis.data("teacherid");
						var courseid =  mthis.data("courseid");
						
						//规则_改名
						var nameTable = "coursecost_" + i;
						var midStr = teacherid + "_" + courseid;
						$("#yicost_" + midStr).attr("name", nameTable+".yicost");
						$("#xiaobancost_" + midStr).attr("name", nameTable+".xiaobancost");
						$("#teacherid_" + midStr).attr("name", nameTable+".teacherid");
						$("#courseid_" + midStr).attr("name", nameTable+".courseid");
						$("#remark_" + midStr).attr("name", nameTable+".remark");
						
					});
					
					$.post("/teacher/coursecost/save", $("#searchForm").serialize(),
						function(ret) {
							if (ret) {
								layer.msg("成功", 1, 6);
								//parent.window.location.reload();
							} else {
								layer.msg("失败", 1, 2);
							}
							layer.close(index_load);
						}
					);
				});
			});
			
			
			$("#yicost_all_save").on("click", function() {
				var yicost = $("#yicost_all").val();
				$(".yicost_x").val(yicost==''?0:yicost);
				console.log("yicost_all_save=", yicost);
			});
			
			$("#xiaobancost_all_save").on("click", function() {
				var xiaobancost = $("#xiaobancost_all").val();
				$(".xiaobancost_x").val(xiaobancost==''?0:xiaobancost);
				console.log("xiaobancost_all_save=", xiaobancost);
			});
			
			$(".custom_add").on("click", function(){
				var mtd = $(this).parent();
				mtd.after(mtd.clone(true));
			});
			
			$(".custom_del").on("click", function(){
				if($(".custom_del").length > 1){
					var mtd = $(this).parent();
					mtd.empty();
					mtd.remove();
				}
			});
			
			$("#customSubmit").on("click", function(){
				if($('#teacherid').val() != ""){
					var index_load = layer.load();
					$.post("/teacher/coursecost/updateTeacheridCustom", $("#searchForm").serialize(),
							function(ret) {
								if (ret.errcode == 0) {
									layer.msg("成功", 1, 6);
									//parent.window.location.reload();
								} else {
									layer.msg("失败", 1, 2);
								}
								layer.close(index_load);
							}
					);
				}
			});

		});
		
	</script>
</body>
</html>