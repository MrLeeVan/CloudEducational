<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>云教务</title>
    <link href="/css/css/bootstrap.min.css?v=1.7" rel="stylesheet">
    <link href="/font-awesome/css/font-awesome.css?v=1.7" rel="stylesheet">
    <!-- Morris -->
    <link href="/css/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
    <!-- Gritter -->
    <link href="/js/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
    <link href="/css/css/animate.css" rel="stylesheet">
    <link href="/css/css/style.css?v=1.7" rel="stylesheet">
</head>
<body style="width:218px;overflow-x:hidden ">
    <div id="wrapper" style="margin-bottom:20px;">
        <nav class="navbar-default" role="navigation">
            <div class="sidebar-collapse">
                <ul class="nav" id="side-menu">
                    <li class="nav-header" style="background-image:url('../images/img/header-profile.png');">
                        <div class="dropdown profile-element"> <span>
                            <img alt="image" src="/images/logo/logo_menu.png" style="width:190px;margin:0 0 10px -18px;"/>
                             </span>
                            <a data-toggle="dropdown" class="dropdown-toggle" href="index.html#">
                             </span>  <span class="text-muted text-xs block">${_res.get("userName")}:${account_session.real_name}<b class="caret"></b></span> </span>
                            </a>
                            <ul class="dropdown-menu animated fadeInRight m-t-xs">
                               
                                <li><a href="/account/updateUserPwd" target="rightFrame">密码修改</a>
                                </li>                              
                                <li class="divider"></li>
                                <li><a href="/account/exit" target="_parent">安全退出</a>
                                </li>
                            </ul>
                        </div>

                    </li>
                    <li>
                        <a href="#"><img alt="image" src="/images/icons/small_icons_3/xuesheng.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('student_management')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <!-- 0为管理员5为教务 -->
                              <li><a href="/student/index?_query.state=0" class="nav_a" target="rightFrame">${_res.get("student_list")}</a></li>
                              <li><a href="/student/add" class="nav_a" target="rightFrame">添加学生</a></li>
                              <li><a href="/grade/index" class="nav_a" target="rightFrame">${_res.get('student.performance.page')}</a></li>
                              <li><a href="/student/index?_query.state=1" class="nav_a" target="rightFrame">暂停账号</a></li>
							  <li style="margin-top:-10px;"><a href="/account/myStudents" class="nav_a" target="rightFrame">我的学生</a></li>
                        </ul>
                    </li>
                    <li>
                        <a href="#"><img alt="image" src="/images/icons/small_icons_3/yonghu.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">教师管理</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
							<li><a href="/teacher/index?_query.state=0" class="nav_a" target="rightFrame">${_res.get('faculty_list')}</a></li>
							<!-- 0为管理员5为教务 -->
							<li><a href="/teacher/add" class="nav_a" target="rightFrame">添加教师</a></li>
							<li><a href="/teacher/index?_query.state=1" class="nav_a" target="rightFrame">暂停账号</a></li>
                        </ul>
                    </li> 
                    <li>
                        <a href="#"><img alt="image" src="/images/icons/small_icons_3/paike.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('curriculum_management')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li><a href="/course/addCourseWeekPlan" class="nav_a" target="rightFrame">${_res.get('add_courses')}</a></li>
                            <li><a href="/course/queryAllcoursePlans?loginId=${account_session.id}&returnType=1&campusId=0" class="nav_a" target="rightFrame">${_res.get('curriculum_management')}</a></li>
                            <li><a href="/course/queryDelCoursePlan" class="nav_a" target="rightFrame">${_res.get('Cancelled.Courses.List')}</a></li>
                        </ul>
                    </li>
					
                    <li class="active">
                        <a href="#"><img alt="image" src="/images/icons/small_icons_3/chake.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('curriculum')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li style="margin-top:-10px;"><a href="/course/queryAllcoursePlans?loginId=${account_session.id}&returnType=7&campusId=0" class="nav_a" target="rightFrame">${_res.get('courses_for_today')}</a></li>
							<li><a href="/course/courseSortListForMonth?loginId=${account_session.id}" class="nav_a" target="rightFrame">${_res.get('courses_roadmap')}</a></li>
							<li><a href="/course/courseplan_month.jsp" class="nav_a" target="rightFrame">${_res.get('curriculum_arrangement')}(${_res.get('Educational.administration')})</a></li>
							<li><a href="/course/queryTeacherCoursePlanDetail" class="nav_a" target="rightFrame">${_res.get('courses_record')}(${_res.get('Educational.administration')})</a></li>
                        </ul>
                    </li>
                    
					<li>

                    <li>
                        <a href="#"><img alt="image" src="/images/icons/small_icons_3/kecheng.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('courses_statistics')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            	<li><a href="/course/getCourseCountByMonth" class="nav_a" target="rightFrame">${_res.get('statistics_monthly')}</a></li>
                            	<li><a href="/course/getCourseCount?teacherId=-1" class="nav_a" target="rightFrame">${_res.get("statistics_details")}</a></li>
								<li><a href="/account/tongjilog.jsp" target="rightFrame">${_res.get('faculty_statistics')}(${_res.get('Educational.administration')})</a></li>
								<li><a href="/account/student_census.jsp" target="rightFrame">${_res.get('student_statistics')}(${_res.get('Educational.administration')})</a></li>
                        </ul>
                    </li>
                    
						<!-- 0为管理员5为教务 -->
                    <li class="nav_caidan">
                        <a href="#" class="nav_anniu"><img alt="image" src="/images/icons/small_icons_3/banxing.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('class_type_management')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="/classtype/findClassType" target="rightFrame">${_res.get('class_type_management')} </a>
                            </li>
                            <li><a href="/classtype/findClassOrder" target="rightFrame">${_res.get('class_management')}</a>
                            </li>
                        </ul>
                    </li>
                    
					 <!-- 0为管理员5为教务 -->                   
                    <li class="nav_caidan">
                        <a href="#" class="nav_anniu"><img alt="image" src="/images/icons/small_icons_3/kemu.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('subject_management')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">   
						   <li><a href="/subject/findSubjectManager" target="rightFrame">${_res.get('subject_management')}</a></li>
							<li><a href="/course/index" target="rightFrame">${_res.get('course_management')}</a></li>
						</ul>	
                    </li>
					 <!-- 0为管理员5为教务 -->                   
                    <li class="nav_caidan">
                        <a href="#" class="nav_anniu"><img alt="image" src="/images/icons/small_icons_3/guwen.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">顾问管理</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">   
						   	<li><a href="/mediator/index" class="nav_a" target="rightFrame">顾问列表</a></li>
							<li><a href="/mediator/add" target="rightFrame">添加顾问</a></li>
						   	<li><a href="/company/index" class="nav_a" target="rightFrame">${_res.get('Authorities.list')}</a></li>
						</ul>	
                    </li>
					 <!-- 0为管理员5为教务 -->                   
                    <li class="nav_caidan">
                        <a href="#" class="nav_anniu"><img alt="image" src="/images/icons/small_icons_3/xiaoshou_jihui.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">${_res.get('Opp.Sales.Opportunities')}</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">   
						   	<li><a href="/opportunity/index" class="nav_a" target="rightFrame">销售列表</a></li>
							<li><a href="/opportunity/add" target="rightFrame">添加销售</a></li>
						</ul>	
                    </li>
					 <!-- 0为管理员5为教务 -->                   
                    <li class="nav_caidan">
                        <a href="#" class="nav_anniu"><img alt="image" src="/images/icons/small_icons_3/caiwu.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">财务管理</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
						   	<!-- <li><a href="/orders/orderReviews" class="nav_a" target="rightFrame">订单审核</a></li> -->
						   	<li><a href="/orders/index?_query.needcheck=1" class="nav_a" target="rightFrame">订单审核</a></li>
						   	<li><a href="/orders/index?_query.needcheck=0" class="nav_a" target="rightFrame">交费管理</a></li>
						</ul>	
                    </li>
						<!-- 0为管理员5为教务 -->
                    <li class="nav_caidan">
                        <a href="#" class="nav_anniu"><img alt="image" src="/images/icons/small_icons_3/xiaoqu.png" style="width:30px;margin:0 10px 0 -15px;"><span class="nav-label">机构管理</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li><a href="/sysuser/index" class="nav_a" target="rightFrame">用户管理</a></li>
							<li><a href="/campus/findCampusManager" target="rightFrame">校区管理</a></li>
							<li><a href="/time/findTimeManager" target="rightFrame">时段管理</a></li>
							<li><a href="/address/getAllIpAdress" target="rightFrame">IP地址管理</a></li>
                        </ul>
                    </li>
                </ul>

            </div>
        </nav>
    </div>
    <!-- Mainly scripts -->
    <script src="/js/js/jquery-2.1.1.min.js"></script>
    <script src="/js/js/bootstrap.min.js?v=1.7"></script>
    <script src="/js/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/js/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/js/js/hplus.js?v=1.7"></script>
</body>

</html>