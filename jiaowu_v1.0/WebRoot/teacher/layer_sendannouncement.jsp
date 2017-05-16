<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="/css/css/bootstrap.min.css" rel="stylesheet" />
<link type="text/css" href="/css/css/style.css" rel="stylesheet" /> 
<link href="/css/css/plugins/chosen/chosen.css" rel="stylesheet">
<link href="/css/css/plugins/chosen/chosen_style.css" rel="stylesheet">
<!-- Morris -->
<link href="/js/js/plugins/layer/skin/layer.css" rel="stylesheet"/>
<!-- Gritter -->
<link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">

<script type="text/javascript" src="/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/lib/jquery.js"></script>
<script type="text/javascript" src="/js/jquery-validation-1.8.0/jquery.validate.js"></script>
<style>
.chosen-container .chosen-results{max-height:100px}
label{
   width:170px;
}
</style>
</head>
<body style="background-color:#EFF2F4">
      <div style="padding:10px">
        <div class="ibox-content" style="max-height:300px">
             	<form action="" method="post" id="sendMessage">
					<input type="hidden" name="teacherId" id="teacherId" value="${teacher.id}" />
					<fieldset>
						<p>
							<label>${_res.get('Sender')}：</label>${teacher.real_name}
							<input type="hidden" name="announcement.teacherid" value="${teacher.id}">
						</p>
						 <p>
								<label>${_res.get('Receiver')}：</label> 
								<select id="sub" data-placeholder="${_res.get('Please.select')}（${_res.get('Multiple.choice')}）" class="chosen-select" multiple
									style="width: 480px;" tabindex="4" onchange="checkSubject()">
									<c:forEach items="${userlist}" var="user">
										<c:if test="${user.flag}">
											<option value="${user.id}" class="options" >${user.real_name}</option>
										</c:if>
									</c:forEach>
								</select> 
								<a class="btn btn-white btn-bitbucket" onclick="allPeople()">所有人</a>
								<input id="subjectids" name="userids" value="" type="hidden">
						</p>
						<p>
							<label>${_res.get('Title')}：</label>
							<input type="text" id="title" name="announcement.title" value="">
						</p>
						<p>
							<label>${_res.get('Content')}：</label>
							<textarea rows="5" cols="85" name="announcement.content" id="content"  style="width: 630px; overflow-x: hidden; overflow-y: scroll;"></textarea>
						</p>
						<p>				
							<a class="btn btn-outline btn-primary pull-right m-t-n-xs" onclick="saveMessage()"> ${_res.get('save')} </a>
						</p>
					</fieldset>
				</form>
        </div>
     </div>   
    <!-- Mainly scripts -->
    <script src='/js/js/jquery-2.1.1.min.js'></script>
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/plugins/chosen/chosen.jquery.js"></script>
    <!-- layer javascript -->
	<script src="/js/js/plugins/layer/layer.min.js"></script>
	<script>
        layer.use('extend/layer.ext.js'); //载入layer拓展模块
    </script>
<script type="text/javascript">
	
	function checkSubject(){
		var subjectids = "";
		var list = document.getElementsByClassName("search-choice");
		for (var i = 0; i < list.length; i++) {
			var name = list[i].children[0].innerHTML;
			var olist = document.getElementsByClassName("options");
			for (var j = 0; j < olist.length; j++) {
				var oname = olist[j].innerHTML;
				if (oname == name) {
					subjectids += "|" + olist[j].getAttribute('value');
					break;
				}
			}
		}
		
	$("#subjectids").val(subjectids.substr(1,subjectids.length)); 
	}
	function saveMessage(){
		var subjectids = $("#subjectids").val();
		var title = $("#title").val();
		var content = $("#content").val();
		if(subjectids==""){
			layer.msg("请选择接收人",1,2);
			return false;
		} 
		if(title==""){
			layer.msg("标题不能为空",1,2);
			return false;
		}
		if(content==""){
			layer.msg("公告信息不能为空",1,2);
			return false;
		}
		if(confirm("确定发布此公告信息吗?")){
           $.ajax({
            	type:"post",
				url:"${cxt}/teacher/saveSendMessage",
				data:$("#sendMessage").serialize(),
				dataType:"json",
				success : function(data) {
					 if(data=='0'){
						layer.msg("信息发布成功",1,2);
					}else{
						layer.msg("信息发布失败",2,2);
					} 
					 setTimeout("parent.layer.close(index)",1000);
					  window.parent.window.getSendMessage();
				}
            });
		}
	}
	function allPeople(){
		var list  ='${ids}';
		 chose_mult_set_ini('#sub',list.substr(0,list.length-1));
         $(".chosen-select").chosen();
         checkSubject();
	}
    //多选select 数据初始化
    function chose_mult_set_ini(select, values){
        var arr = values.split('|');
        var length = arr.length;
        var value = '';
        for(i=0;i<length;i++){
            value = arr[i];
            $(select+" [value='"+value+"']").attr('selected','selected');
        }
        $(select).trigger("chosen:updated");
    }
     
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
     <!-- layer javascript -->
    <script>
     //弹出后子页面大小会自动适应
       var index = parent.layer.getFrameIndex(window.name);
       parent.layer.iframeAuto(index);
    </script>
</body>
</html>
