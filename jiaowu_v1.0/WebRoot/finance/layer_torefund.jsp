<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>申请退费</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<link href="/css/css/layer/need/laydate.css" rel="stylesheet">
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">

<style type="text/css">
body {
	background-color: #eff2f4;
}
</style>
</head>
<body>
		<div class="ibox-content">
			<form action="" id="refundForm" >
				<input type="hidden" id="realsum" name="id" value="${orders.realsum }"/>
				<input type="hidden" id="stuid" name="stuid" value="${orders.studentid }"/>
				<input type="hidden" id="paidamount" name="id" value="${orders.paidamount==null?0:orders.paidamount }"/>
				<table class="table table-hover table-bordered">
					<thead>
						<tr>
							<th width="12%">${_res.get("student.name")}</th>
							<th width="23%">订单时间</th>
							<th width="12%">${_res.get('Teach')}</th>
							<th width="10%">${_res.get('course.subject')}/${_res.get('classNum')}</th>
							<!-- <th width="6%">应收</th> -->
							<th width="5%">实收</th>
							<th width="8%">${_res.get('total.sessions')}</th>
							<th width="6%">${_res.get("scheduled.classes")}</th>
							<th width="6%">已上</th>
							<th width="6%">未排</th>
							<th width="6%">可退</th>
						</tr>
					</thead>
					<tr align="center">
						<td>${orders.real_name}</td>
						<td>${orders.createtime}</td>
						<td>${orders.teachtype==1?_res.get("IEP"):_res.get('course.classes')}</td>
						<td>${orders.teachtype==1?orders.SUBJECTNAME:orders.classnum}</td>
						<%-- <td>${orders.totalsum}</td> --%>
						<td>${orders.realsum}</td>
						<td>${orders.classhour }</td>
						<td>${orders.planedhours }</td>
						<td>${orders.usedhours }</td>
						<td>${orders.classhour-orders.planedhours }</td>
						<td>${orders.classhour-orders.usedhours }</td>
					</tr>
				</table>
				<div>
				    <label>退费课时：</label><input type="text" name="refund.classhours" id="refundhours" value="${remainClassHour }" readonly="readonly">&nbsp;&nbsp;&nbsp;
				    <label>退费金额：</label><input type="text" name="refund.balance" id="balance" value="${remainBalance }" readonly="readonly">&nbsp;&nbsp;
				</div>
				<%-- <div>
				    <label>退费课时：</label><input type="text" name="refund.classhours" id="refundhours" onfocus="setNullToInput('refundhours')" onblur="checkRightNum('refundhours')" >&nbsp;&nbsp;&nbsp;
				    <label>退费金额：</label><input type="text" name="refund.balance" id="balance" onfocus="setNullToInput('balance')" onblur="checkRightNum('balance')" >&nbsp;&nbsp;
				</div>
				<div id="subjects" style="margin:15px 0"><label style="float: left;height:30px;line-height:30px">清空科目:</label>
				<c:if test="${empty subjectList }">
				 <div style="float: left;width:500px;margin-top:6px">&nbsp;&nbsp;  无可清空课程，请选择否</div>
				  </c:if>
				  <div style="float: left;width:500px;margin:0 0 0 10px">
					<c:forEach items="${subjectList }" var="courseids" varStatus="index" >
					  <div style="float: left;width:500px;margin:0 20px 10px 0">
						<input type="checkbox" id="${courseids.SUBJECT_ID }_${courseids.COURSE_ID }" name="coursecheckbox" value="${courseids.SUBJECT_ID }_${courseids.COURSE_ID }" >
						清空<input type="text" size="3" name="fillhours" id="_${courseids.SUBJECT_ID }_${courseids.COURSE_ID }" onblur="checkrighthours('_${courseids.SUBJECT_ID }_${courseids.COURSE_ID }')" />
						${_res.get('session')} ${courseids.course_name }(可退${courseids.SUMHOURS }${_res.get('session')})
						<input type="hidden" id="hours_${courseids.SUBJECT_ID }_${courseids.COURSE_ID }" name="name_${courseids.SUBJECT_ID }_${courseids.COURSE_ID }" value="${courseids.SUMHOURS }" >&nbsp;&nbsp;
					  </div>
					</c:forEach>
				  </div>	
				</div> --%>
				<div style="clear: both"></div>
				<div style="margin-top:20px">
					<label>退费时间：</label><input type="text" readonly="readonly" id="date" id="refundtime" name="refund.refundtime" >&nbsp;&nbsp;&nbsp;
					<label>退费方式：</label><input type="radio"  name="refund.refundtype" value="0" checked="checked" >现金&nbsp;&nbsp;
				    <input type="radio"  name="refund.refundtype" value="1" >银行转账&nbsp;&nbsp;<input type="radio" name="refund.refundtype" value="2" >其他&nbsp;&nbsp;<br>
				</div>
				<br>
				<label>${_res.get('course.remarks')}：</label><textarea name="refund.remark"  cols="50" rows="2"></textarea>
				<div style="margin-top:10px">
					<input type="button" value="${_res.get('save')}" onclick="saveRefund()" class="btn btn-outline btn-info">
				</div>
				<input type="hidden" id="remainsum" name="remainsum" value="${orders.realsum }" >
				<input type="hidden" id="resthours" name="resthours" value="${orders.classhour-orders.usedhours }" >
				<input type="hidden" id="orderid" name="refund.courseorderid" value="${orders.id }" >
				<input type="hidden" name="refund.ordertime" value="${orders.createtime }" >
				<input type="hidden" name="refund.betotlebalance" value="${orders.realsum }" >
				<input type="hidden" name="classorderid" value="${orders.classorderid }" >
				<input type="hidden" name="weipai" value="${orders.classhour-orders.planedhours }" >
				<input type="hidden" id="yescheck"  name="refund.clearplan" checked="checked" value="0" >
			</form>
			<br/>
				<span>
				说明：退费操作会将该学生的所有未排课时和已排未上课时清除,退费含当日已排课程需要手动删除排课。<br/>
				举例：如某订单总课时为20课时，已排15课时，已上10课时。<br/>
				执行退费后将删除掉已排未上的5课时，同时订单总课时数将变成10课时。<br/>
				如果只退部分课时，如4课时，剩余的6课时，您需要在退费完成后，重新提交一个新的购课订单即可。
				</span>
		</div>
	<script src="/js/js/jquery-2.1.1.min.js"></script>
	<!-- Chosen -->
	<script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
	<!-- layerDate plugin javascript -->
	<script src="/js/js/plugins/layer/laydate/laydate.js"></script>
	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
	<script>
	 $(".chosen-select").chosen({disable_search_threshold: 30});
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
		
		$(function(){
			$("#subjects").hide();
		});
		
		function setNullToInput(id){
			$("#"+id).val("");
		}
		function checkRightNum(id){
			var idval = $("#"+id).val();
			var weipai = ${orders.classhour-orders.planedhours };
			if(isNaN(idval)||$.trim(idval)==""){
				$("#"+id).val("0");
			}
			if(id=='refundhours'){
				var remainhours = $("#resthours").val();
				var fillouthours = $("#refundhours").val();
				if($("#refundhours").val() <= weipai){
					$("#subjects").prop("disabled",true);
					$("#subjects").hide();
					$("#yescheck").val("0");
				}else{
					$("#subjects").prop("disabled",false);
					$("#subjects").show();
					$("#yescheck").val("1");
				}
			}
			if(id=='balance'){
				var remainsum = $("#remainsum").val();
				var filloutbalance = $("#balance").val();
				if(parseInt(filloutbalance)>parseInt(remainsum)){
					alert("所退费用不能超过当前订单实收费用");
					$("#balance").val(remainsum);
				}
			}
		}
		
		
		var index = parent.layer.getFrameIndex(window.name);
		parent.layer.iframeAuto(index);
		
		function saveRefund(){
			var refundtime = $("#date").val();
			var hours = $("#refundhours").val();
			var balance = $("#balance").val();
			var remainsum = $("#remainsum").val();
			var remainhour = $("#remainhour").val();
			var qingchu = $("#refundhours").val()-${orders.classhour-orders.planedhours };
			
			if(hours.trim()==""||balance.trim()==""||refundtime.trim()==""){
				layer.msg("数据和时间不能为空");
				return false;
			}
			if(hours=="0"&&balance=="0"){
				layer.msg("课时和所退款不能同时为0");
				return false;
			}
			$.layer({
			    shade : [0], 
			    area : ['auto','auto'],
			    dialog : {
			        msg:'确定提交退费吗?',
			        btns : 2, 
			        type : 4,
			        btn : ['确定','取消'],
			        yes : function(){
			        	$.ajax({
			            	type:"post",
							url:"${cxt}/finance/submitRefundRecord",
							data:$('#refundForm').serialize(),
							datatype:"json",
							success : function(data) {
								layer.msg(data.msg,2,1);
								if(data.code!=3){
									parent.window.location.href="/finance/applyRefund?id="+$("#stuid").val();
									setTimeout("parent.layer.close(index)", 3000);
								}
							}
			            });
			        },
			        no : function(){
			        	parent.layer.close(index);
			        }
			    }
			});
			/*  if(confirm("确定提交退费吗")){
				
			}  */
			
			
		}
		
		
		function checkrighthours(ids){
			var fillhours = $("#"+ids).val();
			var reids = "hours"+ids;
			var rehours = $("#"+reids).val();
			var valid = ids.replace("_","");
			$("#"+valid).val(valid);
			if(parseInt(fillhours)>parseInt(rehours)){
				alert("至多可以清空"+rehours+"${_res.get('session')}");
				$("#"+ids).val(rehours);
				var id = ids.replace("_","");
				var idval = $("#"+id).val()+"_"+$("#"+ids).val();
				$("#"+id).val(idval);
				return ;
			}
			var valid = ids.replace("_","");
			$("#"+valid).val(valid);
			var id = ids.replace("_","");
			var idval = $("#"+id).val()+"_"+$("#"+ids).val();
			$("#"+id).val(idval);
		}
		
		//弹出后子页面大小会自动适应
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.iframeAuto(index);
	</script>
		<script src="/js/js/plugins/layer/laydate/laydate.dev.js"></script>
	<script>
		//日期范围限制
		var date1 = {
			elem : '#date',
			format : 'YYYY-MM-DD',
			max : '2099-06-16', //最大日期
			istime : false,
			istoday : false,
			choose : function(datas) {
			}
		};
		laydate(date1);
	</script>
	
</body>
</html>