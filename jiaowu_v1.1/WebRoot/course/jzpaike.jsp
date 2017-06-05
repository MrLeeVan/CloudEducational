<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('intelligent_scheduling')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<script src="/js/js/jquery-2.1.1.min.js"></script>
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
 .xubox_tabmove{
	background:#EEE;
	width:100% !important;
}
.xubox_tabnow{
    color:#31708f;
}
.jizhun-mar{
  margin:10px 0
}
</style>
</head>
<body>
	<div id="wrapper" style="background: #2f4050;">
	  <%@ include file="/common/left-nav.jsp"%>
       <div class="gray-bg dashbard-1" id="page-wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-left:-15px;position:fixed;width:100%;background-color:#fff;">
			<div class="navbar-header">
			  <a class="navbar-minimalize minimalize-styl-2 btn btn-primary" id="btn-primary" href="#" style="margin-top:10px;"><i class="fa fa-bars"></i> </a>
				<div style="margin:20px 0 0 70px;"><h5>
					<img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>
					  &gt;<a href='/course/queryAllcoursePlans?loginId=${account_session.id}&returnType=1'>${_res.get('curriculum_management')}</a> &gt;${_res.get('intelligent_scheduling')}
				</h5>
				<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
			</div>
			<div class="top-index"><%@ include file="/common/top-index.jsp"%></div>
			</nav>
		</div>

	    <div class="margin-nav" style="min-width:1050px;width:100%;">	
		<form action="/smartplan/index" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
				<div class="ibox-title" style="height:auto;">
				<input type="hidden" id="studentid" value="" /> 
				<label> ${_res.get("student")}/${_res.get("group.class")}： </label> <input type="text" id="studentname" name="studentname"  value="" />
				<label>${_res.get('system.campus')}：</label>
				<select id="campusid" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.campusid"  >
					<option value="">--${_res.get('system.alloptions')}--</option>
					<c:forEach items="${campuslist }" var="campus"  >
						<option value="${campus.id }" <c:if test="${campus.id == paramMap['_query.campusid'] }">selected="selected"</c:if> >${campus.CAMPUS_NAME }</option>
					</c:forEach>
				</select>
				&nbsp;
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary">&nbsp;
				<input type="button" value="${_res.get('new.regulation')}" class="btn btn-outline btn-info" onclick="guize()">
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>${_res.get('intelligent_scheduling.list')}</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
							<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>${_res.get('Week')}</th>
									<th>${_res.get('system.campus')}</th>
									<th>${_res.get('time.session')}</th>
									<th>${_res.get('course.course')}</th>
									<th>${_res.get('teacher')}</th>
									<th>${_res.get('student.buildtime')}</th>
									<th>${_res.get('person.who.add')}</th>
									<th>${_res.get('times.of.arrangement')}</th>
									<th>${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list }" var="list" varStatus="index">
								<tr align="center">
									<td>${index.index }</td>
									<td>${list.weekday }</td>
									<td>${list.campusname }</td>
									<td>${list.timerankname }</td>
									<td>${list.coursename }</td>
									<td>${list.teachername }</td>
									<td><fmt:formatDate value="${list.addtime }" type="time" timeStyle="full" pattern="yyyy-MM-dd"/></td>
									<td>${list.username }</td>
									<td>${list.usedtimes }</td>
									<td>
										<a href="#" style="color: #515151" onclick="samePeople()">${_res.get('course.arranging')}</a>|
										<a href="#" style="color: #515151" onclick="">${_res.get('Modify')}</a>|
										<a href="#" style="color: #515151" onclick="">${_res.get('admin.common.delete')}</a>
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
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
    <script src="/js/js/demo/layer-demo.js"></script>
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
		function guize(){
			var stuid = $("#studentid").val();
			var campusid = $("#campusid").val();
			$.layer({
		        type: 2,
		        title:"${_res.get('new.regulation')}",
		        maxmin: false,
		        shadeClose: true, //开启点击遮罩关闭层
		        area : ['360px' , '510px'],
		        offset : ['80px', ''],
		        iframe: {src: "/smartplan/setNewRule?stuid="+stuid+"&campusid="+campusid}
		    });
			
			/* $.ajax({
				url:"/smartplan/setNewRule",
				data:{"stuid":stuid,"campusid":campusid},
				type:"post",
				success:function(result){
					if(result.code="1"){
						var a;
						var a;
						var a;
						layer.tab({
						    data:[
						        {
						        	title: '新建智能排课规则', 
						        	content:'<div class="paikegz">'
						        	+'<div class="jizhun-mar"><label>学生：</label><input type="text" id="" name=""/>&nbsp;&nbsp;&nbsp;'
						        	+'<label>${_res.get("system.campus")}：</label><input type="text" id="" name=""/></div>'
						        	+'<div class="jizhun-mar"><label>星期：</label><input type="text" id="" name=""/>&nbsp;&nbsp;&nbsp;'
						        	+'<label>时段：</label><input type="text" id="" name=""/></div>'
						        	+'<div class="jizhun-mar"><label>课程：</label><input type="text" id="" name=""/>&nbsp;&nbsp;&nbsp;'
						        	+'<label>老师：</label><input type="text" id="" name=""/></div>'
						        	+'<input type="button" id ="" name="" value="添加" class="btn btn-outline btn-primary" style="float:right"/>'
						        	+'<div style="clear:both"></div>'
						        	+'</div>'
						        }
						        
						    ],
							offset:['150px', ''],
						    area: ['510px', 'auto'] //宽度，高度
						});
						
					}
				}
			}); */
		}
		
		function samePeople(){
			layer.tab({
			    data:[
			        {
			        	title: '排课', 
			        	content:'<div class="jzpaike">'
			            +'<div><table class="table table-bordered">'
			        	+'<tr>'
			        	+'<td class="table-bg1">${_res.get("student")}</td><td class="table-bg2">王小蒙</td>'
			        	+'<td class="table-bg1">星期</td><td class="table-bg2">${_res.get("system.Saturday")}</td>'
			        	+'<td class="table-bg1">${_res.get("system.campus")}</td><td class="table-bg2">中关村</td>'
			        	+'</tr>'
			        	+'<tr>'
			        	+'<td class="table-bg1">时段</td><td class="table-bg2">08：30--10：30</td>'
			        	+'<td class="table-bg1">课程</td><td class="table-bg2">托福阅读</td>'
			        	+'<td class="table-bg1">${_res.get("teacher")}</td><td class="table-bg2">张老师</td>'
			        	+'</tr>'
			        	+'</table></div>'
			        	
			        	+'<div><table class="table table-bordered">'
			        	+'<tr>'
			        	+'<td class="tablehead">${_res.get("index")}</td>'
			        	+'<td class="tablehead">${_res.get("Arranging.the.date")}</td>'
			        	+'<td class="tablehead">${_res.get("Timetable.people")}</td>'
			        	+'<td class="tablehead">${_res.get("admin.sysLog.property.startdate")}</td>'
			        	+'<td class="tablehead">${_res.get("Date.due")}</td>'
			        	+'<td class="tablehead">${_res.get("Days")}</td>'
			        	+'</tr>'
			        	+'<tr class="znzhong">'
			        	+'<td>1</td>'
			        	+'<td>2015-05-20</td>'
			        	+'<td>梁小娟</td>'
			        	+'<td>2015-05-30</td>'
			        	+'<td>2015-06-27</td>'
			        	+'<td>5</td>'
			        	+'</tr>'
			        	+'</table></div>'
			        	
			        	+'<div class="m-b-sm"><label class="label-wid">${_res.get("admin.sysLog.property.startdate")}：</label><input type="text" name="start" readonly="readonly" value="" id="data" onclick="data()"/></div>'
			        	+'<div class="m-b-sm"><label class="label-wid">${_res.get("Days")}：</label><input type="text" id="" name="" value="" class="addday"/> X <input type="text" id="" name="" value="" class="addday"/>&nbsp;${_res.get("session")}= <input type="text" id="" name="" value="" class="addday"/>&nbsp;${_res.get("session")}</div>'
			        	+'<div>'
			        	   +'<label class="label-wid">教室：</label>'
			        	   +'<select>教室：'
				        	   +'<option value="">--全部--</option>'
				        	   +'<option value="">1教室</option>'
				        	   +'<option value="">2教室</option>'
				        	   +'<option value="">3教室</option>'
				        	   +'<option value="">4教室</option>'
				        	   +'<option value="">5教室</option>'
			        	   +'</select>'
			        	+'</div>'
			        	+'<input type="button" id="" name="" value="排课" class="btn btn-outline btn-primary" style="float:right"/>'
			        	+'<div style="clear:both"></div>'
			        	+'</div>'
			        }
			        
			    ],
				offset:['150px', ''],
			    area: ['450px', 'auto'] //宽度，高度
			}); 
		}
	</script>	
    <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
     <!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
    <script>
    function data(){
         //开始日期范围限制
        var birthday = {
            elem: '#data',
            format: 'YYYY-MM-DD',
            max : '2099-06-16', //最大日期
            istime: false,
            istoday: false
        };
        laydate(birthday);
    }    
    </script>
    <script>
   	$('li[ID=nav-nav3]').removeAttr('').attr('class','active');
    </script>
</body>
</html>