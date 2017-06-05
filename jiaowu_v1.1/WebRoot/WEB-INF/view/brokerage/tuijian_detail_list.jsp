<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>消耗详情</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<!-- Data Tables -->
<link href="/css/css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">
<!-- Morris -->
<link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/css/css/animate.css" rel="stylesheet">
<link type="text/css" href="/css/css/style.css" rel="stylesheet" />

<script src="/js/js/jquery-2.1.1.min.js"></script>
<link rel="shortcut icon" href="/images/ico/favicon.ico" /> 
<style type="text/css">
 .chosen-container{
   margin-top:-3px;
 }
h5{
   font-weight: 100 !important
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1100px">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%;">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="margin-nav">
  <div class="col-lg-12" style=" margin-top:10px;">
     <div class="ibox float-e-margins">
         <div class="ibox-title" style="margin-bottom:20px">
            <h5><img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>&gt;<a href='/finance/index'>佣金管理</a>&gt; <a href="/brokerage/tuijian"> 佣金结算</a> &gt; 消耗详情</h5>
            <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get('system.reback')}</a>
            <div style="clear:both"></div>
         </div>
         <div class="ibox-title">
            <h5>统计信息</h5>
         </div>
         <div class="ibox-content">
             <table class="table table-striped table-bordered table-hover dataTables-example">
						<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>渠道姓名</th>
									<th>${_res.get("student.name")}</th>
									<th>消耗日期</th>
									<th>${_res.get('type.of.class')}</th>
									<th>结算状态</th>
									<th>消耗课时</th>
									<th>实消耗</th>
									<th>虚消耗</th>
								</tr>
							</thead>
							<tbody>
							<c:forEach items="${mediator.accountbookList}" var="accountbook" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${accountbook.mediatorname}</td>
									<td>${accountbook.studentname}</td>
									<td>${accountbook.statmonth}</td>
									<td>${accountbook.teachtype}</td>
									<td>${accountbook.isclearing eq false?"未结算":"已结算"}</td>
									<td>${accountbook.ks}</td>
									<td>${accountbook.sxh}</td>
									<td>${accountbook.xxh}</td>
								</tr>
							</c:forEach>
							</tbody>
							<tfoot>
							<tr align="center">
								<td colspan="6">合计</td>
								<td>${mediator.kssum }</td>
								<td>${mediator.sxhsum }</td>
								<td>${mediator.xxhsum }</td>
							</tr>
							<tr align="center">
								<td colspan="6">结算金额</td>
								<td colspan="2">${mediator.sxhsum }*${mediator.ratio }%=${mediator.sum }元</td>
								<td>
									<a href="javascript:void(0)" style="color: #515151" onclick="jiesuan('${mediator.id}','${mediator.statmonth}')">去结算？</a>
								</td>
							</tr>
							</tfoot>
			</table>
		</div>
	</div>
 </div>
	<div style="clear: both;"></div>
 </div>
	 </div>
			</div>
		</table>
		      </div>
         </div>
         
     </div>
  </div>
  <div style="clear: both;"></div>  
</div>
</div>
</div>

	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>

	<script src="/js/js/demo/layer-demo.js"></script>
	
	<!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Data Tables -->
    <script src="/js/js/plugins/dataTables/jquery.dataTables.js"></script>
    <script src="/js/js/plugins/dataTables/dataTables.bootstrap.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/money.js"></script>
    <script src="/js/js/plugins/pace/pace.min.js"></script>
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
    
    <script>
       $('li[ID=nav-nav14]').removeAttr('').attr('class','active');
    </script>
    
    <script type="text/javascript">
    	function jiesuan(mediatorId,statMonth){
    		$.ajax({
    			url:'/brokerage/tuijianSubmit',
    			data:{
    				'mediatorId':mediatorId,
    				'statMonth':statMonth
    			},
    			type:'post',
    			dataType:'json',
    			success:function(data){
    				layer.msg(data.msg,2,0);
    			}
    		});
    		/* window.location.href='/brokerage/tuijianSubmit?mediatorId='+mediatorId+"&statMonth="+statMonth; */
    	}
    </script>
</body>
</html>