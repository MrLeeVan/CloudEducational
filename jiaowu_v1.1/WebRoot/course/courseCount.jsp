<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">

    <title>${_res.get("statistics_details")}</title>
    <link href="/css/css/bootstrap.min.css?v=3.3.0" rel="stylesheet">
    <link href="/css/css/style.css?v=2.1.0" rel="stylesheet">
    <link href="/css/css/animate.css" rel="stylesheet">
    <link href="/font-awesome/css/font-awesome.css?v=4.3.0" rel="stylesheet">
    <link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
    <link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
    <link href="/css/css/layer/need/laydate.css" rel="stylesheet">
    <!-- Data Tables -->
    <link href="/css/css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">
    <!-- Morris -->
	<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
	<!-- Gritter -->
	<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
	
	<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>
    <link rel="shortcut icon" href="/images/ico/favicon.ico" />
    
    
<style type="text/css">
.header {font-size: 12px}
.tongji_fanhui{background-color:#F5F5F6;color:#1a7bb9;border:0}
.tongji_fanhui:hover{background-color:#1a7bb9;color:#fff}
.tongji_fanhui2{background-color:#fff;color:#1a7bb9;border:0px}
.tongji_fanhui2:hover{background-color:#1a7bb9;color:#fff}
#return-count{padding:1px 0 0;background-color:#fff}
h5{font-weight: 100 !important}
</style>
</head>
<body>
    <div id="wrapper" style="height:100%;background: #2f4050;min-width:1100px">
       <%@ include file="/common/left-nav.jsp"%>
        <div id="page-wrapper" class="gray-bg dashbard-1" style="height:100%;min-width:600px;">
            <div class="row border-bottom">
                 <nav class="navbar navbar-static-top fixtop" role="navigation">
			        <%@ include file="/common/top-index.jsp"%>
			     </nav>
            </div>
            
      <div class="ibox float-e-margins margin-nav" style="margin-left:0;">
           <div class="ibox-title">
			   <h5>
				   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> 
				    &gt;<a href='/course/getCourseCount'>${_res.get('courses_statistics')}</a> &gt; ${_res.get("statistics_details")}
			   </h5>
			   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
		   </div>      
           <div class="ibox-content">
		          <form action="/course/getCourseCount" method="post">
					<p>
					   <div style="float: left">
							<label>${_res.get('teacher')}：</label>
							<select name="teacherId" id="teacherId" class="chosen-select" style="width:120px;" >
								<option value="" >${_res.get('system.alloptions')}</option>
							  <c:forEach items="${teachers}" var="teacher">
								<option id="teacher${teacher.id}"  <c:if test="${teacher.id ==teacherId }">selected = "selected"</c:if> value="${teacher.id}">${teacher.real_name}</option>
							  </c:forEach>
							</select>
							<label>${_res.get("student")}/${_res.get("group.class")}：</label><input type="text" name="studentName" value="${studentName}" maxlength="10" size="12"/>
							<label>${_res.get('system.campus')}:</label>
								<select name="campus" id="campus" style="width:120px;" class="chosen-select" >
								  <option  value="">--${_res.get('system.alloptions')}--</option>
								  <c:forEach items="${campus}" var="campus">
									<option id="campus${campus.ID }" value="${campus.ID}">${campus.CAMPUS_NAME}</option>
								  </c:forEach>
								</select>
							<%-- <label>${_res.get("course.status")}</label>	
								<select id="iscancel" name="iscancel" class="chosen-select" style="width:100px;">
									<option value=""  selected="selected">${_res.get('system.alloptions')}</option>
									<option value="0" <c:if test="${'0' eq iscancel}">selected = "selected"</c:if>>${_res.get("normal")}</option>
									<option value="1" <c:if test="${'1' eq iscancel}">selected = "selected"</c:if>>${_res.get('Cancelled')}</option>
								</select>
								<br> --%>
						 </div>
						 <div style="float: left;margin:3px 5px 0 3px">		
						    <label style="float: left;margin-top:6px">${_res.get('course.class.date')}：</label>
						    <div style="float: left">
								<input type="text" class="form-control layer-date" readonly="readonly" id="date1" name="date1" size="12" value="${date1}"  style="background-color: #fff;"/>
							</div>
							<div style="width:30px;height:30px;line-height:30px;text-align:center;background:#E5E6E7;float: left;margin-top:1px">${_res.get('to')}</div>
							<div style="float: left">	
								<input type="text" class="form-control layer-date" readonly="readonly" id="date2" name="date2" size="12" value="${date2}"  style="background-color: #fff;"/>
						    </div>
						</div>
						<div style="float: left;margin:2px 0 0">		
							<input type="submit" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-info"/>
					    </div>
					    <div style="clear: both;"></div>
					</p>
				 </form>
		  </div>
            
            <div class="col-lg-12" style="margin: 20px 0 0;padding:0">
                <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>${_res.get('Hit.list')}</h5>
                            </div>
                            <div class="ibox-content">

                                <table class="table table-striped table-bordered table-hover dataTables-example">
                                    <thead>
                                        <tr align="center" style="font-weight: bold;">
											<th><input type="button" onclick="window.history.go(-1)" class="tongji_fanhui" value="${_res.get('system.reback')}"  style="width:100%;height:100%;"></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<c:set var="studentSum" value="0"></c:set>
											<c:set var="countSum" value="0"></c:set>
											<c:set var="myStudentId" value="0"></c:set>
											<th>${_res.get('IEP')}(${_res.get('total')})：${plan1} ${_res.get('session')}</th>
											<th>${_res.get('course.classes')}(${_res.get('total')})：${plan2} ${_res.get('session')}</th>
											<th>${_res.get('session')}(${_res.get('total')})：${plan1+plan2} ${_res.get('session')}</th>
											<th></th>
										</tr>
                                        <tr>
											<th>${_res.get("index")}</th>
											<th>${_res.get('teacher')}</th>
											<th>${_res.get('student')}/${_res.get("group.class")}</th>
											<th>${_res.get('system.campus')}</th>
											<th>${_res.get("name.of.the.program")}</th>
											<th>${_res.get('course.class.date')}</th>
											<th>${_res.get("class.time.session")}</th>
											<th>${_res.get('session')}</th>
											<th>${_res.get("course.status")}</th>
										</tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="entity" varStatus="s">
											<tr align="center">
												<td>${s.count}</td>
												<td>${entity.teacherName}</td>
												<td>${entity.studentName }</td>
												<td>${entity.CAMPUS_NAME }</td>
												<td>${entity.course_name}</td>
												<td>${entity.course_time }</td>
												<td>${entity.courseRankTime}</td>
												<td>${entity.iscancel==0?entity.class_hour:entity.teacherhour}</td>
												<td>${entity.iscancel==0?_res.get("normal"):_res.get('Cancelled')}</td>
												<c:set var="countSum" value="${countSum+1}"></c:set>
												<c:if test="${entity.studentId!=myStudentId}">
													<c:set var="studentSum" value="${studentSum+1}"></c:set>
												</c:if>
												<c:set var="myStudentId" value="${entity.studentId}"></c:set>
											</tr>
										</c:forEach>
                                    </tbody>
                                </table>

                            </div>
                </div>
            </div>
            <div style="clear: both;"></div>
        </div>
        </div>
    </div>
    <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=3.3.0"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <script src="/js/js/plugins/jeditable/jquery.jeditable.js"></script>

    <!-- Data Tables -->
    <script src="/js/js/plugins/dataTables/jquery.dataTables.js"></script>
    <script src="/js/js/plugins/dataTables/dataTables.bootstrap.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=2.0.0"></script>
    <script src="/js/js/plugins/pace/pace.min.js"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/teach.js"></script>
    
    <script type="text/javascript">
    	window.onload = function(){
    		var id = "teacher"+${teacherId};
    		$("#"+id).attr("selected",true); 
    		var cid = "campus"+${campusid} ;
    		$("#"+cid).attr("selected",true);
    		$("#teacherId").val(${teacherId});
    		$("#teacherId").trigger("chosen:updated");
    		$("#campus").val(${campusid});
    		$("#campus").trigger("chosen:updated");
    	}
    	
    </script>

    <!-- Page-Level Scripts -->
    <script>
        $(document).ready(function () {
            $('.dataTables-example').dataTable();

            /* Init DataTables */
            var oTable = $('#editable').dataTable();

            /* Apply the jEditable handlers to the table */
            oTable.$('td').editable('../example_ajax.php', {
                "callback": function (sValue, y) {
                    var aPos = oTable.fnGetPosition(this);
                    oTable.fnUpdate(sValue, aPos[0], aPos[1]);
                },
                "submitdata": function (value, settings) {
                    return {
                        "row_id": this.parentNode.getAttribute('id'),
                        "column": oTable.fnGetPosition(this)[2]
                    };
                },

                "width": "90%",
                "height": "100%"
            });


        });

        function fnClickAddRow() {
            $('#editable').dataTable().fnAddData([
                "Custom row",
                "New row",
                "New row",
                "New row",
                "New row"]);

        }
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
 
    <!-- layerDate plugin javascript -->
<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
 <script>
         //日期范围限制
        var date1 = {
            elem: '#date1',
            format: 'YYYY-MM-DD',
            max: '2099-06-16', //最大日期
            istime: false,
            istoday: false,
            choose: function (datas) {
                date2.min = datas; //开始日选好后，重置结束日的最小日期
                date2.start = datas //将结束日的初始值设定为开始日
            }
        };
        var date2 = {
            elem: '#date2',
            format: 'YYYY-MM-DD',
            max: '2099-06-16',
            istime: false,
            istoday: false,
            choose: function (datas) {
                date1.max = datas; //结束日选好后，重置开始日的最大日期
            }
        };
        laydate(date1);
        laydate(date2);
 </script>  
</body>
     <script type="text/javascript">
	      $("#teacherId").val("${teacherId}");
	</script>
	<script>
       $('li[ID=nav-nav5]').removeAttr('').attr('class','active');
    </script>
</html>
