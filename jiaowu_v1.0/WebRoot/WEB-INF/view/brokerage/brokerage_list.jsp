<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>结算纪录</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
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
<style>
#chaxun{
   color:#18a689
}
#chaxun:hover{
   color:#fff
}
</style>
</head>
<body>
<div id="wrapper" style="background: #2f4050;min-width:1100px">
  <%@ include file="/common/left-nav.jsp"%>
   <div class="gray-bg dashbard-1" id="page-wrapper" style="height:100%;width:auto">
    <div class="row border-bottom">
     <nav class="navbar navbar-static-top fixtop" role="navigation">
        <%@ include file="/common/top-index.jsp"%>
     </nav>
  </div>
  
  <div class="margin-nav">
<form action="/brokerage/index" method="post" id="searchForm">
			<div  class="col-lg-12">
			  <div class="ibox float-e-margins">
			    <div class="ibox-title">
					<h5>
					   <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px">&nbsp;&nbsp;<a href="javascript:window.parent.location='/account'">${_res.get('admin.common.mainPage')}</a>&gt;<a href='/finance/index'>财务管理</a>&gt; 结算纪录
				   </h5>
				   <a onclick="window.history.go(-1)" href="javascript:void(0)" class="btn btn-outline btn-primary btn-xs" style="float:right">${_res.get("system.reback")}</a>
          		<div style="clear:both"></div>
				</div>
				<div class="ibox-content" style="height:auto;">
				<label>${_res.get("Opp.Channel")}：</label>
				<select id="mediatorId" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.mediatorId">
					<option value="">请选择</option>
					<c:forEach items="${mediators}" var="mediator">
						<option value="${mediator.id }" <c:if test="${mediator.id == paramMap['_query.mediatorId'] }">selected="selected"</c:if>>${mediator.realname }</option>
					</c:forEach>
				</select>
				<label>支付状态：</label>
				<select id="ispay" class="chosen-select" style="width: 150px;" tabindex="2" name="_query.ispay">
					<option value="">请选择</option>
					<option value="0" <c:if test="${paramMap['_query.ispay']==0 }">selected="selected"</c:if>>未支付</option>
					<option value="1" <c:if test="${paramMap['_query.ispay']==1 }">selected="selected"</c:if>>已支付</option>
				</select>
				<input type="button" onclick="search()" value="${_res.get('admin.common.select')}" class="btn btn-outline btn-primary" id="chaxun">
				
			</div>
			</div>
			</div>

			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-title">
						<h5>结算记录</h5>
					</div>
					<div class="ibox-content">
						<table width="80%" class="table table-hover table-bordered">
						<thead>
								<tr>
									<th>${_res.get("index")}</th>
									<th>渠道姓名</th>
									<th>${_res.get("monthly.statistics")}</th>
									<th>${_res.get('total.sessions')}</th>
									<th>实消耗</th>
									<th>返佣比例</th>
									<th>佣金</th>
									<th>${_res.get("operation")}</th>
								</tr>
							</thead>
							<c:forEach items="${showPages.list}" var="brokerage" varStatus="index">
								<tr align="center">
									<td>${index.count }</td>
									<td>${brokerage.mediatorname}</td>
									<td>${brokerage.clearingmonth}</td>
									<td>${brokerage.coursetotal}</td>
									<td>${brokerage.realsum}</td>
									<td>${brokerage.ratios}%</td>
									<td>${brokerage.moneysum}</td>
									<td>
										<a href="javascript:void(0)" style="color: #515151" onclick="showBrokerageDetail(${brokerage.id})">${_res.get("details")}</a>
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


	<!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>

	<script src="/js/js/demo/layer-demo.js"></script>
	
	 <!-- Mainly scripts -->
    <script src="/js/js/bootstrap.min.js?v=3.3.0"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Data Tables -->
    <script src="/js/js/plugins/dataTables/jquery.dataTables.js"></script>
    <script src="/js/js/plugins/dataTables/dataTables.bootstrap.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
    <script src="/js/js/plugins/pace/pace.min.js"></script>
    <script src="/js/js/top-nav/top-nav.js"></script>
    <script src="/js/js/top-nav/money.js"></script>
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
    	function showBrokerageDetail(brokerageId){
    		window.location.href="${cxt}/brokerage/showBrokerageDetail?brokerageId="+brokerageId;
    	}
    </script>
</body>
</html>