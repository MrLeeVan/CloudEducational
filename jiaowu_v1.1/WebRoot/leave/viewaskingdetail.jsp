<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibfile.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title>请假详情</title>
		<jsp:include page="/common/headcssfile.jsp" />
		<style type="text/css">
			#vertical-timeline {
				margin-left: 9em;
			    margin-bottom: 2em;
			    margin-top: 2em;
			    padding: 0;
			    position: relative;
			    width: 60%;
			}
			#vertical-timeline::before {
			    background: #f1f1f1 none repeat scroll 0 0;
			    content: "";
			    height: 100%;
			    left: 18px;
			    position: absolute;
			    top: 0;
			    width: 4px;
			}
			.vertical-timeline-content {
			    background: #f5f5f5 none repeat scroll 0 0;
			    border-radius: 0.5em;
			    margin-left: 60px;
			    padding: 1em;
			    position: relative;
			}
			.vertical-timeline-content::before {
			    -moz-border-bottom-colors: none;
			    -moz-border-left-colors: none;
			    -moz-border-right-colors: none;
			    -moz-border-top-colors: none;
			    border-color: transparent white transparent transparent;
			    border-image: none;
			    border-style: solid;
			    border-width: 7px;
			    content: "";
			    height: 0;
			    position: absolute;
			    right: 100%;
			    top: 16px;
			    width: 0;
			}
			.vertical-timeline-icon {
			    border: 3px solid #f1f1f1;
			    border-radius: 50%;
			    font-size: 16px;
			    height: 40px;
			    left: 0;
			    position: absolute;
			    text-align: center;
			    top: 0;
			    width: 40px;
			}
			.vertical-timeline-block {
			    margin: 2em 0;
			    position: relative;
			}
			h3{ color: #72860b; font-weight: bold; }
		</style>
		<script type="text/javascript" src="/jquery/jquery-2.1.1.min.js" ></script>
	</head>
	<body>
		<div id="wrapper" style="background: #2f4050;min-width:1100px">
			<%@ include file="/common/left-nav.jsp"%>
			<div class="gray-bg dashbard-1" id="page-wrapper">
				<div class="row border-bottom">
					<nav class="navbar navbar-static-top fixtop" role="navigation">
						<%@ include file="/common/top-index.jsp"%>
					</nav>
				</div>

		    	<div class="margin-nav" style="width:100%;">	
					<div class="col-lg-12">
						<div class="ibox float-e-margins" >
							<div class="ibox-title">
								<h5> <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
								    <a href="javascript:window.parent.location='/system/index'">首页</a> 
								    &gt; 请假管理 &gt; 请假记录 &gt; 请假详情</h5>
								 <input type="button" onclick="window.history.go(-1)" value="返回" 
								 	class="btn btn-xs btn-danger rlt m-r-xl " />
							</div>
							<div class="ibox-content">
					    		<form action="/teaching/students/leaveasking/viewAskingDetail/${studentLeave.id }" method="post" id="viewForm">
									<div class="let1" >
										<div class="control-group m-t-sm " >
											<!-- 学号 -->
											<label class="input-s-sm" >学生姓名</label>
											<span class="" >${studentLeave.stuName }</span>
										</div>
										
										<div class="control-group m-t-md " >
											<!-- 开始时间 -->
											<label class="input-s-sm" >开始时间</label>
											<span class="" ><fmt:formatDate value="${studentLeave.starttime }" pattern="yyyy-MM-dd HH:mm" /> </span>
										</div>
										<div class="control-group m-t-md " >
											<!-- 结束时间 -->
											<label class="input-s-sm" >结束时间</label>
											<span class="" ><fmt:formatDate value="${studentLeave.endtime }" pattern="yyyy-MM-dd HH:mm" /> </span>
										</div>
										<div class="control-group m-t-md" >
											<label class="input-s-sm" >请假类型</label>
											<span class="" >${studentLeave.type }</span>
										</div>
										<div style="clear:both;" ></div>
										<div class="control-group m-t-md" >
											<label class="flt input-s-sm" >请假事由</label>
											<textarea style="border-color:#fff;" name="studentAskingLeave.content" >${studentLeave.content }</textarea>
										</div>
										<div style="clear:both;" ></div>
										<div class="control-group m-t-md" >
											<label class="input-s-sm flt" >审批结果</label>
											<div class="vertical-container light-timeline" id="vertical-timeline">
												<div class="vertical-timeline-block">
			                                        <div class="vertical-timeline-icon navy-bg">
			                                            <i class="fa fa-check-circle" style="padding-top: 9px;" ></i>
			                                        </div>
			                                        <div class="vertical-timeline-content">
			                                            <span> ${studentLeave.realName } </span>
			                                            <h3>发起申请</h3>
			                                            <span class="vertical-date">
					                                        <small><fmt:formatDate value="${studentLeave.createdate }" pattern="yyyy-MM-dd HH:mm" /></small>
					                                    </span>
			                                        </div>
	                                    		</div>
	                                    		<c:choose>
	                                    			<c:when test="${empty leaveReview }">
			                                    		<c:forEach items="${reviewDetail }" var="review" >
															<div class="vertical-timeline-block">
						                                        <div class="vertical-timeline-icon ${review.state == 2 ? 'navy-bg' : 'gray-bg ' }">
						                                            <i class="fa ${review.state == 2 ? 'fa-check-circle' : review.state == 3 ? 'fa-times-circle'
						                                            	 : 'fa-ellipsis-h' } " style="padding-top: 9px;" ></i>
						                                        </div>
						                                        <div class="vertical-timeline-content">
						                                            <span> ${review.realName } </span>
						                                            <h3 class="askingState" stateCode="${review.stateCode }" ></h3>
						                                            <p>${review.reason }</p>
						                                            <span class="vertical-date">
								                                        <small><fmt:formatDate value="${review.Approvaldate }" pattern="yyyy-MM-dd HH:mm" /></small>
								                                    </span>
						                                        </div>
				                                    		</div>
			                                    		</c:forEach>
	                                    			</c:when>
	                                    			<c:otherwise>
			                                    		<c:forEach items="${reviewDetail }" var="review" >
			                                    			<c:if test="${review.state != 1 }">
																<div class="vertical-timeline-block">
							                                        <div class="vertical-timeline-icon ${review.state == 2 ? 'navy-bg' : 'gray-bg ' }">
							                                            <i class="fa ${review.state == 2 ? 'fa-check-circle' : review.state == 3 ? 'fa-times-circle'
							                                            	 : 'fa-ellipsis-h' } " style="padding-top: 9px;" ></i>
							                                        </div>
							                                        <div class="vertical-timeline-content">
							                                            <span> ${review.realName } </span>
							                                            <h3 class="askingState" stateCode="${review.stateCode }" ></h3>
							                                            <p>${review.reason }</p>
							                                            <span class="vertical-date">
									                                        <small><fmt:formatDate value="${review.Approvaldate }" pattern="yyyy-MM-dd HH:mm" /></small>
									                                    </span>
							                                        </div>
					                                    		</div>
			                                    			</c:if>
			                                    		</c:forEach>
			                                    		<c:if test="${leaveReview.state == 1 }">
															<div class="vertical-timeline-block">
						                                        <div class="vertical-timeline-icon gray-bg ">
						                                            <i class="fa fa-ellipsis-h " style="padding-top: 9px;" ></i>
						                                        </div>
						                                        <div class="vertical-timeline-content">
						                                            <label  >审批意见：</label><br>
						                                            <textarea rows="3" cols="60" id="editReason" ></textarea><br>
						                                            <input type="button" value="通过" class="btn btn-xs btn-primary" onclick="approvalLeave(2)" />
						                                            <input type="button" value="拒绝" class="btn btn-xs btn-danger" onclick="approvalLeave(3)" />
						                                        </div>
				                                    		</div>
			                                    		</c:if>
	                                    			</c:otherwise>
	                                    		</c:choose>
											</div>
											<div style="clear:both;" ></div>
										</div>
										
										<div style="clear:both;" ></div>
									</div>
								</form>
							</div>
							<div style="display:none;" >
								<form action="" method="post" id="approvalForm"  >
									<input name="studentLeaveReview.id" value="${leaveReview.id }" />
									<input name="studentLeaveReview.state" value="" id="reviewState" />
									<textarea name="studentLeaveReview.reason" id="reviewReason" ></textarea>
								</form>
							</div>
						</div>
					</div>
					<div style="clear:both;" ></div>
				</div>
				<div style="clear:both;" ></div>
			</div>
		</div>
		
		<script src='/jquery/jquery.i18n.properties-1.0.9.js'></script>
		<script src='/jquery/jquery-ui-1.10.2.custom.min.js'></script>
		<jsp:include page="/common/headjsfile.jsp" />
		<script type="text/javascript">
			$( document ).ready( function () {
	   			
	    		jQuery.i18n.properties( {
	   	            name : 'strings', //资源文件名称
	   	            path : '/i18n/', //资源文件路径
	   	            mode : 'map', //用Map的方式使用资源文件中的值
	   	            language : '${i18nstate}' ,
	   	            callback : function() {
			    		$( ".askingState" ).each( function() {
			    			 $( this).html( $.i18n.prop( $( this ).attr( "stateCode" ) ) );
			    		} );
	   	            }
	   			} );
	    	} );
			
			
			function approvalLeave( stateVal ) {
				$( "#reviewState" ).val( stateVal );
				$( "#reviewReason" ).text( $( "#editReason" ).val() );
				if( confirm( "确认提交吗？" ) ) {
					$.ajax( {
						url : "/leave/saveApprovalResult",
						data : $( "#approvalForm" ).serialize(),
						dataType : "json",
						type : "post",
						success : function( result ) {
							window.location.href = "/leave/approval/${leaveReview.id }" ;
						}
					} )
				}
			}
			
			
			
			
			
		</script>
	</body>
</html>
