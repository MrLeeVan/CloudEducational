<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/style.css" rel="stylesheet" /> 
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/css/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/laydate.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet"> 

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>添加学生</title>
<style>
  label{
    width:60px
  }
  tbody tr td{
    text-align: center;
  }
</style>
</head>
<body>
     <div class="ibox float-e-margins" style="margin-bottom:0">
        <div class="ibox-content">
            <form action="" method="post" id="">
					<fieldset>
						<p>
							<label> 
								老师:
							</label>
							<select name="" id="teacher" class="chosen-select" style="width:199px;" tabindex="2">
							   <option value="1">张老师</option>
							   <option value="2">李老师</option>
							   <option value="3">赵老师</option>
							   <option value="4">冯老师</option>
							</select>
						</p>
						<p>
							<label> 
								时间:
							</label>
							<select name="" id="time" class="chosen-select" style="width:199px;" tabindex="2">
							   <option value="1" disabled>8:00-9:00(不可用)</option>
							   <option value="2">9:00-10:00</option>
							   <option value="3">10:00-11:00</option>
							   <option value="4">13:00-14:00</option>
							</select>
							<input type="button" class="btn btn-info btn-sm" onclick="timeline()" value="按时间段查看">
						</p>
						<p>
							<label> 
								教室:
							</label>
							<select name="" id="classroom" class="chosen-select" style="width:199px;" tabindex="2">
							   <option value="1">一教室</option>
							   <option value="2">二教室</option>
							   <option value="3">三教室</option>
							   <option value="4">四教室</option>
							</select>
							<input type="button" class="btn btn-info btn-sm" onclick="classroomview()" value="按教室查看">
						</p>
						<p>
						    <label> 
								${_res.get('course.remarks')}:
							</label>
						    <textarea rows="3" cols="" style="width:300px">这个地方请加备注</textarea>
						</p>
						<p>
							 <input type="button" value="${_res.get('admin.common.submit')}" onclick="saveAccount()" class="btn btn-outline btn-primary" />
						</p>
					</fieldset>
					
					<div>
					  <table id="chakan" class="table table-bordered"></table>
					</div>
					
				</form>
        </div>
     </div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<script src="/js/utils.js"></script>
 	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
 <!-- layer javascript -->
 <script src="/js/js/plugins/layer/layer.min.js"></script>
 <script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
 </script>
<script>
   function timeline(){
	   var coursedates = "";
	   coursedates = "<thead><tr><th>时间</th><th>${_res.get('course.course')}</th><th>${_res.get('student')}</th><th>教室</th><th>操作</th></tr></thead>"
	                 +"<tbody><tr id='deltimeline'><td>08:00-10:00</td><td>托福听力</td><td>赵晓明</td><td>中关村-1教室</td><td><a href='#' onclick='deltimeline()'>删除</a></td></tr></tbody>";
	   $("#chakan").html(coursedates);
   }
   
   function classroomview(){
	   var coursedates = "";
	   coursedates = "<thead><tr><th>教室</th><th>${_res.get('teacher')}</th><th>${_res.get('course.course')}</th><th>${_res.get('student')}</th><th>操作</th></tr></thead>"
	                 +"<tbody><tr id='deltimeline'><td>1教室</td><td>方老师</td><td>托福听力</td><td>赵小明</td><td><a href='#' onclick='deltimeline()'>删除</a></td></tr></tbody>";
	   $("#chakan").html(coursedates);
   }
   
   function deltimeline(){
	   $("#deltimeline").empty();
   }
   
   function saveAccount(){
	   var t = document.getElementById("teacher"); 
	   var teacher = t.options[t.selectedIndex].text;
	   var b = document.getElementById("time"); 
	   var time = b.options[b.selectedIndex].text;
	   var c = document.getElementById("classroom"); 
	   var classrooms = c.options[c.selectedIndex].text;
	   parent.document.getElementById("add").innerHTML = "<div id='del'><label class='fontweig'>"+time+"</label><span class='delcol' onclick='del()'>X</span><br>"+teacher+"<br>"+classrooms+"</div>";
	   parent.layer.close(index);
   }
   
 //弹出后子页面大小会自动适应
   var index = parent.layer.getFrameIndex(window.name);
   parent.layer.iframeAuto(index);
</script>
<!-- Chosen -->
<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
 <script>     
        $(".chosen-select").chosen({disable_search_threshold: 10});
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
<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
    <script>
         //生日日期范围限制
        var birthday = {
            elem: '#birthday',
            format: 'YYYY-MM-DD',
            max: laydate.now(), //最大日期
            istime: false,
            istoday: false
        };
        laydate(birthday);
        
      //住宿时间
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
</html>
