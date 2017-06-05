<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">


<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet" />
<link href="/css/css/laydate.css" rel="stylesheet" />

<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css"
	rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript"
	src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript"
	src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<title>${_res.get('tuition.fee')}</title>
<style>
label {
	width: 170px;
}
.course-money{
   background:#EBEBEB;
   padding:5px;
   margin-bottom:20px
}
</style>
</head>
<body style="background:#fff">
	<div class="ibox float-e-margins" style="margin-bottom:0">
		<div class="ibox-content" style="height:350px">
		<c:if test="${!empty msg }">
					${msg}
		</c:if>
		<c:if test="${empty msg }">
				<div class="course-money"><h4>${_res.get('teacher.name')}：${teacher.REAL_NAME}</h4></div>
		</c:if>			
			<form action="" method="post" id="coursecostForm">
			<fieldset>
					<input id="teacherid" type="hidden" name="coursecost.teacherid" value="${teacher.id }"/>
							<p>
							<label>${_res.get('IEP')}${_res.get('tuition.fee')}：</label>
							<input id="yicost" type="text" name="coursecost.yicost" /><span id="yicostMes"> </span>
						    </p>
						    <p>
							<label>${_res.get('course.classes')}${_res.get('tuition.fee')}：</label>
							<input id="xiaobancost" type="text" name="coursecost.xiaobancost" /><span id="xiaobancostMes"> </span>
						    </p>
						    <p><label>${_res.get('Commencement.date')}：</label>
							<input type="text" readonly="readonly" id="date1" name="coursecost.startdate"
									style="width: 130px; cursor: not-allowed" /><span id="date1Mes"> </span>
							<input type="button" value="${_res.get('teacher.group.add')}" onclick="return saveAccount();" class="btn btn-outline btn-primary" />
							</p>
				</fieldset>
			
			<table class="table table-hover table-bordered" width="100%" style="margin-top:20px">
							<thead>
								<tr>
									<th rowspan="2">${_res.get("index")}</th>
									<th rowspan="2">${_res.get('IEP')}${_res.get('tuition.fee')}</th>
									<th rowspan="2">${_res.get('course.classes')}${_res.get('tuition.fee')}</th>
									<th rowspan="2">${_res.get('Commencement.date')}</th>
									<th rowspan="2">${_res.get('Date.due')}</th>
									<th rowspan="2">${_res.get("student.buildtime")}</th>
									<th rowspan="2">${_res.get('person.who.add')}</th>
									<!--  <th rowspan="2">${_res.get("course.remarks")}</th>  -->
									<th rowspan="2">${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${costList}" var="coursecost" varStatus="status">
								<tr class="odd" align="center">
									<td>${status.count}</td>
									<td>${coursecost.yicost}</td>
									<td>${coursecost.xiaobancost}</td>
									<td>${coursecost.startdate}</td>
									<td>${coursecost.enddate}</td>
									<td><fmt:formatDate value="${coursecost.creattime}" type="time" timeStyle="full" pattern="yy-MM-dd  HH:mm:ss"/></td>
									<td>${coursecost.REAL_NAME}</td>
									<!--	<td>${coursecost.REMARK}</td> -->
									<td><a href="javascript:void(0);" onclick="delcoursecost(${coursecost.id})" >${_res.get('admin.common.delete')}</a></td>
								</tr>
							</c:forEach>
			</table>
				
			</form>
		</div>
	</div>
	<!-- Mainly scripts -->
	<script src="/js/js/jquery-2.1.1.min.js"></script>

	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<script src="/js/utils.js"></script>
	<!-- Mainly scripts -->
	<script src="/js/js/bootstrap.min.js?v=1.7"></script>
	<script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
	<script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<!-- Custom and plugin javascript -->
	<script src="/js/js/hplus.js?v=1.7"></script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script>
		$(".chosen-select").chosen({
			disable_search_threshold : 20
		});
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
	</script>
	<script type="text/javascript">
		function checkExist() {
		var date = $("#date1").val();
	    if (date != "") {
	    	var flag = true;
	        $.ajax({
	            url: '${cxt}/teacher/coursecost/checkExist',
	            type: 'post',
	            data: {
	                'date': date,
	                'tid': $("#teacherid").val()
	            },
	            async: false,
	            dataType: 'json',
	            success: function(data) {
	                if (data.result >= 1) {
	                	$("#date1").focus();
                    	$("#date1Mes").text("您填写的数据已存在。");
	                }else{
	                	$("#date1Mes").text("");
	                	flag = false;
	                } 
	            }
	        });
	        return flag;
	    } else {
	        $("#date1").focus();
	    	$("#date1Mes").text("该字段不能为空。");
	        return true;
	    }
	}
	
	function checkempty(checkField) {
		var checkValue = $("#"+checkField).val();
	    if (checkValue != "") {
	    	var flag = false; 
	    	return flag;
	    } else {
	    	flag = true;
	    	$("#"+checkField+"Mes").text("该字段不能为空。");
	    	return flag;
	    }
	}
	
		function saveAccount() {
			if (checkempty('yicost')||checkempty('xiaobancost')||checkempty('date1')) {
				return false;
			}else{
				if(checkExist()){
					return false;
			}else{
				$.ajax({
					type : "post",
					url : "${cxt}/teacher/coursecost/save",
					data : $('#coursecostForm').serialize(),
					datatype : "json",
					success : function(data) {
						if (data.code == '0') {
							layer.msg(data.msg, 2, 5);
						} else {
							location.reload();
						}
					}
				});
			}
		}
	}
		function delcoursecost(id){
    		if(confirm("确定删除？")){
    			$.ajax({
    				url:"${cxt}/teacher/coursecost/delete",
    	   			data:{"id":id},
    	   			type:"post",
    	   			dataType:"json",
    	   			success:function(data){
    	   				location.reload();
    	   			}
    			});
    		}
    	}
	</script>
	<script>
		$('li[ID=nav-nav2]').removeAttr('').attr('class', 'active');
	</script>
	
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
        laydate(date1);
 </script>
</body>
</html>
