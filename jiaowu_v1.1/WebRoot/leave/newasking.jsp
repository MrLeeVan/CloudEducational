<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibfile.jsp" %>
<!DOCTYPE html>
<html>
	<head>
		<title>请假申请</title>
		<jsp:include page="/common/headcssfile.jsp" />
		<style type="text/css">
			#approverSelector_chosen {
				margin-top: -12px;
			}
			#mohulist {
				box-shadow: 0 0 50px #7c7c7c; 
				border-radius: 5px; 
				margin-left: 122px;
				width: 250px;
				position: absolute;
				z-index: 100;
			}
			.mohu_list_wrap li {
				display:block;
				line-height: 20px;
				padding: 4px 0;
				border-bottom: 1px dashed #676a6c;
				cursor: pointer;
				text-align:center;
				width:100%
			}
			.dayInput {
				width:200px;
				text-align: center;
			}
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
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5> <img alt="" src="/images/img/currtposition.png" width="16" style="margin-top:-1px" />&nbsp;&nbsp;
								    <a href="javascript:window.parent.location='/system/index'">主页</a>&gt; 账号 &gt; 请假管理 &gt;请假申请
								</h5>
								 <input type="button" onclick="window.history.go(-1)" value="返回"  class="btn btn-xs btn-danger rlt m-r-xl " />
							</div>
							<div class="ibox-content">
								<div class="let1" >
					    		<form action="/teaching/students/leaveasking/newAsking" method="post" id="editForm">
									<div class="control-group m-t-sm " >
										<!-- 学号 -->
										<label class="input-s-sm" >学生姓名</label>
										<input type="hidden" name="studentAskingLeave.studentid" id="studentId" value="" />
										<input type="text" name="" id="studentNum" class="input-s-lg" onclick="keyInResetName()" />
										<div id="mohulist" class="mohu_list_wrap" style="display: none">
											<ul style="margin-bottom: 10px;" id="studentList"></ul>
										</div>
									</div>
									
									<div class="control-group m-t-md " >
										<!-- 开始时间 -->
										<label class="input-s-sm" >开始时间</label>
										<input type="text" readonly="readonly" class="dayInput" id="startDay" 
											name="studentAskingLeave.starttime" value="" />
									</div>
									<div class="control-group m-t-md " >
										<!-- 结束时间 -->
										<label class="input-s-sm" >结束时间</label>
										<input type="text" readonly="readonly" class="dayInput" id="endDay" 
											name="studentAskingLeave.endtime"  value="" />
									</div>
									<div class="control-group m-t-md" >
										<label class="input-s-sm" >请假类型</label>
										<select class="chosen-select input-s" name="studentAskingLeave.type" id=""  >
											<option value="businessleave" >事假</option>
											<option value="sickleave" >病假</option>
											<option value="others" >其它</option>
										</select>
									</div>
									<div style="clear:both;" ></div>
									<div class="control-group m-t-md" >
										<label class="flt input-s-sm" >请假事由</label>
										<textarea rows="3" cols="80" name="studentAskingLeave.content" ></textarea>
									</div>
									<div style="clear:both;" ></div>
									<div class="control-group m-t-md" >
										<label class="input-s-sm flt" >审批人</label>
										<div class="approverInfo flt" id="approverOrders"  ></div>
										<div class="flt " >
											<span class="fa fa-plus-circle" onclick="plusApprover()" 
												style="font-size:28px;cursor: pointer;" ></span>
											<span id="selector" style="display:none;" >
												<select class="input-s" id="approverSelector" onchange="choiceNewSelector( this.value )"  > 
													<option value="" >请选择</option>
													<c:forEach items="${sysUserLists }" var="userList" >
														<option value="${userList.id }" >${userList.real_name }</option>
													</c:forEach>
												</select>
											</span>
										</div>
										<div style="clear:both;" ></div>
									</div>
									<div style="clear:both;" ></div>
									<div class="m-t-md" >
										<input type="button" onclick="submitAsking()" 
											value="提交" class="btn btn-sm btn-success" />
									</div>
								</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		
		<jsp:include page="/common/headjsfile.jsp" />
		<script type="text/javascript">
			
			$( document ).ready( function() {
				
				$( "#studentNum" ).keyup( function() {
					var studentNum = $( this ).val().trim();
					if ( studentNum != "" ) {
						$.ajax( {
							url : "/student/queryStudentByName" ,
							data : { "studentName" : studentNum } ,
							type : "post" ,
							dataType : "json" ,
							async : false ,
							success : function( result ) {
								if( result.userLists != null ) {
									if( result.userLists.length == 0 ) {
										setUserEmpty();
										return false ;
									} else {
										var str = "" ;
										var userListSize = result.userLists.length
										for ( var i = 0 ; i < userListSize ; i++ ) {
											var userId = result.userLists[i].ID ;
											var dbUserName = result.userLists[i].REAL_NAME ;
											str += "<li idval='" + userId +"' nameval='"+ dbUserName + "' ";
											str += " onclick='clickListUser( this )' >" + dbUserName + " </li> ";
										}
										$( "#studentList" ).html( str );
										$( "#mohulist" ).show();
									}
								} else {
									setUserEmpty();
								}
							}
						} );
					} else {
						setUserEmpty();
					}
				} );	
				
				var startdate = {
	                 elem: '#startDay',
	                 format: 'YYYY-MM-DD hh:mm:ss',
	                 istime: true,
	                 istoday: false,
	                 choose : function(datas) {
	                	 enddate.min = datas; 
	        		}
	          	};
				laydate( startdate );
				var enddate = {
	                 elem: '#endDay',
	                 format: 'YYYY-MM-DD hh:mm:ss',
	                 istime: true,
	                 istoday: false,
	                 choose : function(datas) {
	                	 startdate.max = datas; 
	        		}
		        };
		        laydate( enddate );
				
			} );
		
			function setUserEmpty() {
				$( "#studentId" ).val("");
				$( "#studentList" ).html( "" );
				$( "#mohulist" ).hide();
				$( "#studentNum" ).focus();
			}
			function keyInResetName() {
				setUserEmpty();
				$( "#studentNum" ).val("");
			}
			
			function clickListUser( domObj ) {
				$( "#studentId" ).val( $( domObj ).attr( "idval" ) );
				$( "#studentNum" ).val( $( domObj ).attr( "nameval" ) );
				$( "#studentList" ).html( "" );
				$( "#mohulist" ).hide();
			}
			
			function plusApprover() {
				var flag =  $( "#approverSelector" ).hasClass( "chosen-select" );
				if( !flag ) {
					$( "#selector" ).show();
					$( "#approverSelector" ).addClass( "chosen-select" );
					$( "#approverSelector" ).trigger( "chosen:updated" );
					$( "#approverSelector" ).chosen();
				} else {
					$( "#approverSelector" ).removeClass( "chosen-select" );
					$( "#selector" ).hide();
					$( "#approverSelector option:selected " ).attr( "selected" , false );
				}
			}
			
			/* 选择审核人员之后 */
			function choiceNewSelector( objVal ) {
				if( objVal != "" ) {
					var existFlag = true ;
					$( "#approverOrders .userId" ).each( function() {
						//查看当前选择的人是否已经选过了，选过不进行以下操作
						if( objVal == $( this ).val() ) {
							existFlag = false;
						}
					} );
					if( existFlag ) {
						//选择的当前审核人没被选过，加入到最后
						var userName = $( "#approverSelector option:selected" ).text();
						var lastOrder = $( "input[name='approverOrder']:last" ).val();
						if( lastOrder == null || lastOrder == "" ) {
							lastOrder = 0 ;
						} else {
							lastOrder = Number( lastOrder ) + 1;
						}
						
						var approverInfoStr = '<span class="currentUser" onclick="removeCurrentApprover( this )" > ' + 
							' <input type="hidden" value="' + lastOrder + '" name="approverOrder" id="approverOrder" /> ' +
							' <input type="hidden" class="userId" name="userId_' + lastOrder + '" value="' + objVal + '" id="userId"  /> ' +
							' <b class="btn btn-xs btn-primary " >' + userName + '</b> …… </span>';
						$( "#approverOrders" ).append( approverInfoStr );
						
					}
				}
				/* 选择器关闭 */
				$( "#approverSelector" ).removeClass( "chosen-select" );
				$( "#selector" ).hide();
				$( "#approverSelector option:selected" ).attr( "selected" , false );
			}
			
			/* 点击审核人删除 */
			function removeCurrentApprover( domObj ) {
				var lastOrder = $( "input[name='approverOrder']:last" ).val();
				var currentOrder = $( domObj ).find( "input[name='approverOrder']" ).val();
				$( domObj ).remove();
				//比较：当前删除人不是最后一个审核者时，更改后续的审核人顺序
				if( lastOrder != currentOrder ) {
					$( ".currentUser" ).each( function() {
						var checkOrder = $( this ).find( "input[name='approverOrder']" ).val();
						if( checkOrder > currentOrder ) {
							//审核人order 减  1
							$( this ).find( "#approverOrder" ).val( Number( checkOrder ) - 1 );
							$( this ).find( "#userId" ).attr( "name" , "userId_" + ( Number( checkOrder ) - 1 ) );
						}
					} );
				}
			}
			
			function submitAsking() {
				var stuId = $( "#studentId" ).val();
				if( stuId == "" || stuId == null ) {
					layer.msg( "学生姓名不能为空" , 2 , 2 );
					return false;
				}
				var dayFlag = true;
				$( ".dayInput" ).each( function() {
					var datas = $( this ).val();
					if( datas == null || datas == "" ) {
						layer.msg( "请假日期不能为空" , 2 , 2 );
						dayFlag = false;
					}
				} );
				if( dayFlag ) {
					var approverText = $( "#approverOrders" ).text();
					if( approverText == null || approverText.trim() == "" ) {
						layer.msg( "请选择审批人" , 2 , 2 );
						return false;
					}
					
					if( confirm( "确定要提交申请吗？" ) ) {
						$.ajax( {
							url : "/leave/saveApplication",
							data : $( "#editForm" ).serialize(),
							type : "post",
							dataType : "json",
							success : function( result ) {
								if( result.flag ) {
									window.location.href = "/leave/list" ;
								} else {
									layer.msg( result.msg , 3 , 2 );
								}
							}
						} );
					}
					
				}
				
				
				
			}
			
		</script>
	</body>
</html>
