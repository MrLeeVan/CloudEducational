<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet" />

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/jquery-1.8.2.js"></script>
<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<script type="text/javascript">
	
</script>
<title>${_res.get('class_type_management')}</title>

<style type="text/css">
label {
	height: 34px;
	width: 80px;
}

.subject_name {
	width: 520px;
	margin: -50px 0 0 82px;
}

.class_type {
	margin: -50px 0 40px 82px;
}

#classtype div {
	float: left;
	margin-right: 15px
}

.student_list_wrap {
	position: absolute;
	top: 100px;
	left: 9.5em;
	width: 100px;
	overflow: hidden;
	z-index: 2012;
	background: #09f;
	border: 1px solide;
	border-color: #e2e2e2 #ccc #ccc #e2e2e2;
	padding: 6px;
}
</style>
<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
		<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
		layer.use('extend/layer.ext.js'); //载入layer拓展模块
	</script>
  	<script type="text/javascript">
		//关闭框 此处采用刷新并不好
 	function closeBox(){
			 parent.$("#status").val("1");
		 	 var index = parent.layer.getFrameIndex(window.name);  
             parent.layer.close(index); 
		} 
	</script>  
 <script type="text/javascript">
			//保存时段信息
			function saveTimeRank(){
				var id = $("#id").val();
				var rankid =  $("[name='rank']").val();
				$.ajax({
					url : "/courseplan/saveTimeRank",
					type : "post" , 
					dataType :  "json",
					data: {
						"cpid" : id,
						"rankid" : rankid
					},
				success : function(data){
					if(data.code==0){
						layer.msg("更新成功",2,1);
					 	 var index = parent.layer.getFrameIndex(window.name);  
			             parent.layer.close(index); 
					}
				},
			 error :  function(){
				alert("网路异常，请稍候再试");
		        }
				})
			}
	</script>  
</head>
<body style="background: #fff;">
	<div class="ibox-content"  style="width: 460px; height: 500px;">
			 <span style="color:blue; "><center>请选择更改后的时段</center></span><hr>
			<div>
			  <input id ="id" name = "id"  type = "hidden" value = "${id}">   
			<c:choose>
				<c:when test="${rankList.size()==0}">
					<span> <center>您选择的时间没有课程时段可用，请确认已排课程时段信息 </center></span><hr>
					<div id="btn" style="width:150px;height:100px;margin-left:200px ">
							<input id="closeBtn" type="button" value = "关闭" style="width:40px;height:30px" onclick="closeBox()">
					</div>
				</c:when>
				<c:otherwise>
						<c:forEach items="${rankList}" var = "rank"  varStatus="status">
						<c:choose>
								<c:when test="${rank.code == 1 }">
									 <span  style="display:inline;width:200px;margin-left: 10px"><input type="radio" name = "rank"  disabled="disabled"   value=${rank.id }  > ${rank.RANK_NAME }(被占用) </span> 
									<c:if test="${status.count%2==0}"> <br></c:if>
								</c:when>
								<c:when test="${rank.code == 2 }">
									<span style="display:inline;margin-left: 10px"><input type="radio" name = "rank"  disabled="disabled"    value=${rank.id }  >${rank.RANK_NAME }(有课程) </span>  		
								<c:if test="${status.count%2==0}"><br></c:if>
								</c:when>
								<c:otherwise>
								   <span style= "margin-right: 80px;margin-left: 30px" ><input type="radio" name = "rank"   value=${rank.id } > ${rank.RANK_NAME } </span>  
								<c:if test="${status.count%2==0}"><br></c:if>
								</c:otherwise>
						</c:choose>
						</c:forEach>
						<hr >
						<div style="float:left">
							<input id="btn" type="button" value = "确认" style="width:40px;height:30px;" onclick="saveTimeRank()">
						</div>
						<div style="float:right">
							<input id="closeBtn" type="button" value = "关闭" style="width:40px;height:30px; " onclick="closeBox()">
						</div>
				</c:otherwise>
			</c:choose>
	
			</div>
	</div>
</body>
</html>
