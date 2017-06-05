<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
        <nav class="navbar-default navbar-static-side" id="nav-nav" role="navigation" style="background:#2f4050;">
            <div class="sidebar-collapse" >
                <ul class="nav" id="side-menu">
                    <li class="nav-header" style="background-image:url('${cxt}/images/img/header-profile.png');">
                        <div class="dropdown profile-element"> 
                             <span>
                                <a href="javascript:window.parent.location='/account'">
                                	<img alt="image" src="/images/logo/logo_menu.png" style="width:190px;margin:0 0 10px -10px;"/>
                                </a>
                             </span>
                            <a data-toggle="dropdown" class="dropdown-toggle" href="index.html#">
                             <span class="text-muted text-xs block">${_res.get("userName")}:${account_session.real_name}<b class="caret"></b></span> 
                            </a>
                            <ul class="dropdown-menu animated fadeInRight m-t-xs">
                               <c:if test="${operator_session.qx_accountupdateUserPwd }">
	                                <li><a href="#" onclick="editpwd()">${_res.get("admin.top.passChange") }</a></li>                              
                               </c:if>
                                <li class="divider"></li>
                                <c:if test="${operator_session.qx_accountexit }">
	                                <li><a href="/account/exit" target="_parent">${_res.get("admin.top.exitSystem") }</a> </li>
                                </c:if>
                            </ul>
                        </div>
                        <div class="logo-element" style="padding:40px 0;">
                            <a href="javascript:window.parent.location='/account'">
                            	<img alt="image" src="/images/ico/favicon.png" width="40px">
                            </a>
                            <div style="font-size: 12px;font-weight: 100;margin-top:10px">
                            <c:if test="${operator_session.qx_accountexit }">
	                          <a href="/account/exit" target="_parent">${_res.get("admin.top.exitSystem") }</a>
                            </c:if>
                           </div>
                        </div>
                    </li>
                    <c:forEach items="${modules}" var="f">
                    	<c:set var='numbers' value="${f.numbers}" scope="page"/>
                    	<c:set var='globalization' value="${f.globalization}" scope="page"/>
                    	<c:if test="${operator_session[numbers]}">
	                    	 <li id="left_${f.id}"  <c:if test="${f.id==left}">class="active"</c:if>>
		                        <a href="#">
		                        <img alt="image" src="/images/lefticon/${f.iconname}" style="width:30px;margin:0 10px 0 -5px;">
		                        <c:if test="${en==1}">
		                        	<span class="nav-label">${f.names}</span>
		                        </c:if>	 
		                        <c:if test="${en==2}">
		                        	<span class="nav-label">${f.globalization}</span>
		                        </c:if>	
		                        <c:if test="${en==3}">
		                        	<span class="nav-label">${f.japanese}</span>
		                        </c:if>	
		                        <c:if test="${en==null || empty en}">
		                        	<span class="nav-label">${f.names}</span>
		                        </c:if>	
		                        <span class="fa arrow"></span></a>
		                        <ul class="nav nav-second-level" >
		                         	<c:forEach items="${f.smail}" var="m">
		                         		<c:set var='number' value="qx_${m.urls}" scope="page"/>
		                         		<c:if test="${operator_session[number]}">
		                         			<li id="sl_${m.id}" <c:if test="${m.id==smailleft}">style="background: #000;"</c:if>>
	                         					<c:if test="${en==1}">
						                        	<a href="${m.url}" class="nav_a nav_font">${m.names}</a>
						                        </c:if>	 
						                        <c:if test="${en==2}">
						                       	 <a href="${m.url}" class="nav_a nav_font">${m.globalization}</a>
						                        </c:if>	
						                        <c:if test="${en==3}">
						                       	 <a href="${m.url}" class="nav_a nav_font">${m.japanese}</a>
						                        </c:if>	
						                        <c:if test="${en==null || empty en}">
						                        	 <a href="${m.url}" class="nav_a nav_font">${m.names}</a>
						                        </c:if>	
		                         			</li>
		                         		 </c:if>
		                         	</c:forEach>
		                        </ul>
		                       </li>
	                       </c:if>
                    </c:forEach>
                </ul>

            </div>
        </nav>
        <script>
         function editpwd(){
	        $.layer({
	    	    type: 2,
	    	    shadeClose: true,
	    	    title: "修改密码",
	    	    closeBtn: [0, true],
	    	    shade: [0.5, '#000'],
	    	    border: [0],
	    	    offset:['150px', '500px'],
	    	    area: ['380px', '350px'],
	    	    iframe: {src: '/account/updateUserPwd'}
	    	});
         }
        </script>
    