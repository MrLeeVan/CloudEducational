<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<script type="text/javascript" src="/js/js/jquery-2.1.1.min.js"></script>
<title>${_res.get('add_courses')}</title>
<style>
   label{
      width:100px
   }
   .fontweig{
      weight:90%;
      font-weight: 100
   }
   .addcourse{
      background:#eff2f4;
      padding:3px;
      cursor: pointer;
      text-align:center
   }
   .delcol{
      color:red;
      cursor: pointer;
   }
   #del{
      padding:5px;
      margin:5px 0;
      background:#d9edf7
   }
   .iboxcontent{
      padding:3px
   }
   th,td{
      width:120px;
      padding:4px !important
   }
</style>
</head>
<body>
	<div id="wrapper">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0;position:fixed;width:100%;background-color:#fff;">
			<div class="navbar-header" style="margin: 10px 0 0 30px;">
				<h5>
					当前位置：<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a> &gt; ${_res.get('curriculum_management')} &gt; ${_res.get('According.to.the.course.arrangement')}
				</h5>
				<a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
			</div>
			</nav>
		</div>


		<div class="col-lg-12" style="margin-top: 100px">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5>${_res.get('According.to.the.course.arrangement')}</h5>
				</div>
				<div class="ibox-content">
					<form action="" method="post" id="coursePlan">
						<fieldset style="width: 100%; overflow: hidden;">
							<input type="hidden" name="coursePlan.student_id" id="studentId" />
							<input type="hidden" name="banci_id" id="banci_id" /> 
							<input type="hidden" name="goon" id="goon" value="0" /> 
							<input type="hidden" name="course_usenum" id="courseUseNum" value="0" />
							<p>
								<label>${_res.get('type.of.class')}：</label> 
								<input type="radio" name="banjiType" id="banjiType1" value="1" checked="checked">${_res.get('IEP')} 
								<input type="radio" name="banjiType" id="banjiType2" value="2" <c:if test='${banjiType eq 2 }'> checked='checked'</c:if>>${_res.get('course.classes')}
							</p>
							<div class="stu_name" id="stu_name">
								<label>
								<span id="stuOrBanci"> 
									<c:choose>
										<c:when test="${banjiType eq 2 }">${_res.get('Shift.coding')}:</c:when>
										<c:otherwise>${_res.get('student.name')}：</c:otherwise>
									</c:choose>
								</span>
								</label>
								<input type="text" id="studentName" name="studentName" value="${studentName }" />
								<div id="mohulist" class="student_list_wrap" style="display: none">
									<ul style="margin-bottom: 10px;" id="stuList"></ul>
								</div>
								<a href="#" class="dengemail" onclick="findAccountByName()" style="padding: 8px;">${_res.get('Searching')}</a><span id="studentInfo"></span>
							</div>
							<p style="margin-top:15px">
								<label>${_res.get('Arranging.type')}：</label> 
								<input id="planType0" name="coursePlan.plan_type" value="0" type="radio" checked="checked" onchange="changePlanType(this.value)">${_res.get('course.course')}&nbsp; 
								<input id="planType1" name="coursePlan.plan_type" value="1" type="radio" onchange="changePlanType(this.value)">${_res.get('mock.test')}
							</p>
							<p>
								<label>${_res.get('course.netcourse')}：</label> 
								<input id="" name="course" value="0" type="radio" checked="checked">${_rs.get('admin.common.no') }&nbsp; 
								<input id="" name="course" value="1" type="radio">${_rs.get('admin.common.yes') }
							</p>
							<p>
								<label>${_res.get('system.campus')}：</label> 
								<select id="campus" class="form-control" style="display:inline;width: 150px;" name="coursePlan.campus_id" onchange="campusChange()">
									<option value="0">${_res.get('Please.select')}</option>
									<option value="">朝阳校区</option>
									<option value="">昌平校区</option>
									<option value="">通州校区</option>
									<option value="">丰台校区</option>
								</select>
							</p>
							<p class="cenmon">
							    <label>${_res.get('Arranging.the.date')}：</label>
						        <input type="text" id="starttime" name="_query.starttime" readonly="readonly" value="${paramMap['_query.starttime']}" placeholder="${_res.get('Please.choose.the.date')}" class="cursall"/>&nbsp;&nbsp;${_res.get('to')}&nbsp; 
						        <input type="text" id="endtime" name="_query.endtime" readonly="readonly" value="${paramMap['_query.endtime']}" placeholder="${_res.get('Please.choose.the.date')}" class="cursall"/> &nbsp;&nbsp;&nbsp; 	
							<input type="button" class="btn btn-outline btn-primary" value="${_res.get('admin.common.determine')}" onclick="paike();"  /> 
							</p>
						</fieldset>
					</form>
					<div id="piaoo">
					</div>
				</div>
			</div>
		</div>

	</div>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script>
	$(".chosen-select").chosen({disable_search_threshold:30});
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
    var starttime = {
        elem: '#starttime',
        format: 'YYYY-MM-DD',
        max: '2099-06-16', //最大日期
        istime: false,
        istoday: false,
        choose: function (datas) {
        	endtime.min = datas; //开始日选好后，重置结束日的最小日期
        	endtime.start = datas //将结束日的初始值设定为开始日
        }
    };
    var endtime = {
        elem: '#endtime',
        format: 'YYYY-MM-DD',
        max: '2099-06-16',
        istime: false,
        istoday: false,
        choose: function (datas) {
        	starttime.max = datas; //结束日选好后，重置开始日的最大日期
        }
    };
    laydate(starttime);
    laydate(endtime);
     
    function paike(){
   	 var coursedates = "";
   	 coursedates = "<div class='ibox float-e-margins'>"
					  + "<div class='iboxcontent'>"
					  + "<table class='table table-bordered'>"
				      + "<thead><tr align='center'>"
					      +"<th></th>"
					      +"<th>07-13(一)</th>"
					      +"<th>07-14(二)</th>"
					      +"<th>07-15(三)</th>"
					      +"<th>07-16(四)</th>"
					      +"<th>07-17(五)</th>"
					      +"<th>07-18(六)</th>"
					      +"<th>07-19(日)</th>"
				      +"</tr></thead>"
				      + "<tbody><tr align='left'>"
				      	  +"<td align='center' style='vertical-align:middle'>托福听力</td>"
				      	  +"<td>"
				      	      +"<div id='del'><label class='fontweig'>09：00-12：00</label><span class='delcol' onclick='del()'>X</span><br>李小红<br>中关村一教室</div>"
				      	      +"<div id='add'></div>"
				      	      +"<div class='addcourse' onclick='addcourse()'>+添加</div>"
				      	  +"</td>"
				      	  +"<td><div class='addcourse' onclick='addcourse()'>+添加</div></td>"
				      	  +"<td><div class='addcourse' onclick='addcourse()'>+添加</div></td>"
				      	  +"<td><div class='addcourse' onclick='addcourse()'>+添加</div></td>"
				      	  +"<td><div class='addcourse' onclick='addcourse()'>+添加</div></td>"
				      	  +"<td><div class='addcourse' onclick='addcourse()'>+添加</div></td>"
				      	  +"<td><div class='addcourse' onclick='addcourse()'>+添加</div></td>"
				      +"</tr></tbody>"
				      + "</table>"
				      + "</div></div>";
		   $("#piaoo").html(coursedates);
     }
    
    function del(){
    	$("#del").empty();
    }
    
    
     $(function(){ // 班级类型切换
        	$(":input[name='banjiType']").click(function(){
        		if($(this).val() == 1){
        			$('#stuOrBanci').html("${_res.get('student.name')}:");
        			$("#studentName").val("");
        			$("#banjiType1").attr('checked','checked');
        		}else{
        			$('#stuOrBanci').html("${_res.get('Shift.coding')}:");
        			$("#studentName").val("");
        			$("#banjiType2").attr('checked','checked');
        		}
        	});
        });
     
 </script>
 <!-- layer javascript -->
 <script src="/js/js/plugins/layer/layer.min.js"></script>
 <script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
 </script>
 <script>
	 function addcourse(){
		 $.layer({
	 		    type: 2,
	 		    shadeClose: true,
	 		    title: "${_res.get('add_courses')}",
	 		    closeBtn: [0, true],
	 		    shade: [0.5, '#000'],
	 		    border: [0],
	 		    offset:['60px', ''],
	 		    area: ['500px', '360px'],
	 		    iframe: {src: "/course/layer_addcoursepaike.jsp"}
	 		   });
	 }
 </script>
</body>
</html>