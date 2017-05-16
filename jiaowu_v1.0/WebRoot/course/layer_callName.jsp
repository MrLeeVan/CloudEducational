<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link rel="stylesheet" href="/css/rangeSlider/css/normalize.css" />
<link rel="stylesheet" href="/css/rangeSlider/css/ion.rangeSlider.css" />
<link rel="stylesheet" href="/css/rangeSlider/css/ion.rangeSlider.skinFlat.css" />
<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<!-- 点名页面 -->
<title>${_res.get('courselib.name')}</title>
<style>
label {
	width: 100px
}
</style>
</head>
<body style="background: #fff">
	<div class="ibox-content" style="padding: 10px；">
		<form action="" method="post" id="callNameMessage" name="form">
			<input type="hidden" id="courseplanid" value="${cp.id}" />
			<input type="hidden" id="studentids" value="${studentids}" />
			<input type="hidden" id="refresh" value="${refresh}" />
			<c:forEach items="${stu}" var="stu">
				<div>
					<label>${stu.REAL_NAME}</label>
					<input type="radio" onclick="showRemark(${stu.studentid})" ${stu.sign==1?"checked='checked'":stu.sign==null?"checked='checked'":""} name="singn_${stu.studentid}" value="1">正常
					<input type="radio" onclick="showRemark(${stu.studentid})" ${stu.sign==2?"checked='checked'":""} name="singn_${stu.studentid}" value="2">迟到 
					<input type="radio" onclick="showRemark(${stu.studentid})" ${stu.sign==3?"checked='checked'":""} name="singn_${stu.studentid}" value="3">旷课 
					<input type="radio" onclick="showRemark(${stu.studentid})" ${stu.sign==4?"checked='checked'":""} 
																			   ${stu.leave?"checked='checked'":""} name="singn_${stu.studentid}" value="4">请假 
					<div id="late_${stu.studentid}" style="position: relative; padding: 10px 50px 10px 100px;">
						<input type="text" id="minutesLate_${stu.studentid}" name="minutesLate_${stu.studentid}" value="0" />
						<script type="text/javascript">
						   $(function () {
							   $("#minutesLate_${stu.studentid}").ionRangeSlider({
						        	hide_min_max: true,
						            keyboard: true,
						            keyboard_step:2,
						            postfix:"${_res.get('minutes')}",
						            min: 1,
						            max: 60,
						            from: "${stu.lateMinutes}",
						            grid: true,
						            grid_num:6
						        });
						    }
						   );
						</script>
					</div>
					<input type="hidden" id="remark_${stu.studentid}" value="${stu.remark}" />
					<div id="${stu.studentid}"></div>
				</div>
			</c:forEach>
			<br>
			<input type="button" value="${_res.get('admin.common.submit')}" onclick="saveCallNameMessage();" class="btn btn-outline btn-primary" />
		</form>
	</div>

	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<!-- 范围拖拽 -->
	<script src="/js/ion-rangeSlider/ion.rangeSlider.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script>
	  //弹出后子页面大小会自动适应
	    var index = parent.layer.getFrameIndex(window.name);
		/* parent.layer.iframeAuto(index); */
    </script>
	<script type="text/javascript">
	function showRemark(stuid){
		var sign = $("input:radio[name='singn_"+stuid+"']:checked").val();
		var remark = $("#remark_"+stuid).val()=="暂无备注"?"":$("#remark_"+stuid).val();
		$("#"+stuid).html("");
		if(sign!=1){
			var str = '<label> ${_res.get("course.remarks")}： </label><textarea rows="2" cols="28" id="n_'+stuid+'"  >'+remark+'</textarea>';
			$("#"+stuid).append(str);	
		}
		if(sign==2){
			$("#late_"+stuid).show();	
		}else{
			$("#late_"+stuid).hide();
			$("#minutesLate_"+stuid).val(0);
		}
	}
	
	function saveCallNameMessage(){
		var studentids = $("#studentids").val();
		var refresh = $("#refresh").val();
		var ids = studentids.substr(0,studentids.length-1).split(",");
		var singn = "";
		var remark="";
		var lateMinutes="";
		for(var i=0;i<ids.length;i++){
			 var ck = $("input:radio[name='singn_"+ids[i]+"']:checked").val();
			 var cr = $("#n_"+ids[i]).val();
			 var minutes = $("#minutesLate_"+ids[i]).val();
			 remark+=(cr==null?"暂无备注":cr==""?"暂无备注":cr)+"|";
			 singn+=ck+",";
			 lateMinutes+=minutes+",";
		}
		console.log(lateMinutes);
		$.ajax({
        	type:"post",
			url:"${cxt}/course/saveCallNameMessage",
			data:{"singn":singn,"remark":remark,"studentids":studentids,"cpid":$("#courseplanid").val(),"lateMinutes":lateMinutes},
			datatype:"json",
			success : function(data) {
				 if(data.code=='0'){
					layer.msg("保存信息异常",1,2);
				}else{
					if(refresh=='true'){
						parent.window.document.getElementById('searchForm').submit();
					}
					setTimeout("parent.layer.close(index)", 1000);
				} 
			}
        });
	}
	var studentids = $("#studentids").val();
	var ids = studentids.substr(0,studentids.length-1).split(",");
	for(var i=0;i<ids.length;i++){
		showRemark(ids[i]);
	}
</script>
</body>
</html>