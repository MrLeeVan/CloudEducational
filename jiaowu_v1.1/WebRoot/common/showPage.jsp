<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:if test="${pages>0}">
   <!-- 分页开始 -->
    <div class="clearfix" id="show_page">
			<div id="show_page2">
				<ul style="margin:0 0 0 400px;width:200px;">
					<li id="liupxia" class=""><a href="#" id="upxia" onclick="goPage(${page-1})">${_res.get("course.lastPage") }</a>&nbsp;</li>
					<li id="lidownxia" class="">&nbsp;<a href="#" id="downxia" onclick="goPage(${page+1})">${_res.get("course.nextPage") }</a></li>
				</ul>
			</div>
		<div class="fr pageDesc" style="margin-top:-15px;">${_res.format("course.record.splitmsg",count,page,pages) }</div>
	</div>
	<!-- 分页结束 -->
</c:if>
<script type="text/javascript">
	var page='${page}';//当前页
	var totalPageSize='${pages}';//总页码
	$(document).ready(function(){
		if(page == 1){
			$("#up").attr("onclick","");
			$("#upxia").attr("onclick","");
			$("#liup").attr("class","disabled");
			$("#liupxia").attr("class","disabled");
		}
		if(page == totalPageSize){
			$("#down").attr("onclick","");
			$("#downxia").attr("onclick","");
			$("#lidown").attr("class","disabled");
			$("#lidownxia").attr("class","disabled");
		}
	});
    function goPage(pageNum){
    	if(pageNum < 1) {
    		pageNum = 1;
    	}
    	if(pageNum > totalPageSize) {
    		if(totalPageSize>0){
    			pageNum = totalPageSize;
    		}else{
    			pageNum=1;
    		}
    	}
		$("#wherepage").val(pageNum);
		$("#searchForm").submit();
    }
	function search()
	{
		$("#wherepage").val(1);
		$("#searchForm").submit();
	}
</script>
