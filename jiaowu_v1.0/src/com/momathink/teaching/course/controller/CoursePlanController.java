
     /*
   * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
   *
   * Copyright 2017 摩码创想, support@momathink.com
    *
   * This file is part of Jiaowu_v1.0.
   * Jiaowu_v1.0 is free software: you can redistribute it and/or modify
   * it under the terms of the GNU Lesser General Public License as published by
   * the Free Software Foundation, either version 3 of the License, or
   * (at your option) any later version.
   *
   * Jiaowu_v1.0 is distributed in the hope that it will be useful,
   * but WITHOUT ANY WARRANTY; without even the implied warranty of
   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   * GNU Lesser General Public License for more details.
   *
   * You should have received a copy of the GNU Lesser General Public License
   * along with Jiaowu_v1.0.  If not, see <http://www.gnu.org/licenses/>.
   *
   * 这个文件是Jiaowu_v1.0的一部分。
   * 您可以单独使用或分发这个文件，但请不要移除这个头部声明信息.
    * Jiaowu_v1.0是一个自由软件，您可以自由分发、修改其中的源代码或者重新发布它，
   * 新的任何修改后的重新发布版必须同样在遵守LGPL3或更后续的版本协议下发布.
   * 关于LGPL协议的细则请参考COPYING文件，
   * 您可以在Jiaowu_v1.0的相关目录中获得LGPL协议的副本，
   * 如果没有找到，请连接到 http://www.gnu.org/licenses/ 查看。
   *
   * - Author:摩码创想
   * - Contact: support@momathink.com
   * - License: GNU Lesser General Public License (GPL)
   */

package com.momathink.teaching.course.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.task.Organization;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.course.service.CourseplanService;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;
import com.momathink.teaching.teacher.model.Teacher;
import com.momathink.teaching.teacher.service.CoursecostService;

@Controller(controllerKey="/courseplan")
public class CoursePlanController extends BaseController {

	
	
	/**
	 * 查看老师的上课信息
	 * */
	public void getTeacherMessage() {
		try{
			
			Map<String,String> queryParam = splitPage.getQueryParam();
			queryParam.put("ISCANCEL", "0");
			queryParam.put("loginRoleCampusIds", getAccountCampus() );
			CourseplanService.me.list(splitPage);
			setAttr("list", splitPage.getPage());
			List<Subject> list = Subject.dao.getSubject();
			setAttr("subject", list);
			renderJsp("/account/month_census.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 查看学生的上课信息
	 * */
	public void getStudentMessage() {
		try{
			setAttr("teacherList", Teacher.dao.getTeachersByCampusid(getAccountCampus()));
			CourseplanService.me.queryStudentPlan(splitPage);
			setAttr("list", splitPage.getPage());
			List<Subject> list = Subject.dao.getSubject();
			setAttr("subject", list);
			renderJsp("/account/month_census_student.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public void getCoursesBySubjectId(){
		try{
			String subjectId = getPara("subId");
			List<Course> list = Course.dao.getCourseBySubjectId(subjectId);
			renderJson("course", list);
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	


	/**
	 * 批量修改教師
	 * 
	 * @return   
	 */
	public void goUpdateTeacher() {
		String ids = getPara("selectIdValue");
		setAttr("ids", ids);
		setAttr( "teacherList", Teacher.dao.getTeachersByCampusid( getAccountCampus()) );
		renderJsp("/batch/batchUpdateTeacher.jsp");
	}

	/**
	 * 批量更新教师
	 * 
	 * @return json 0表示成功 1表示失败
	 * 
	 */
	public void batchUpdateTeacher() {
		JSONObject json = new JSONObject();
		String ids = getPara("ids");
		String tchid = getPara("teacherid");
		json = CourseplanService.me.batchUpdateTeacher(ids, tchid); // 更改记录
		renderJson(json);
	}

	/**
	 * 批量删除
	 */
	public void goBatchDetele() {
		String ids = getPara("selectIdValue");
		setAttr("ids", ids);
		renderJsp("/batch/batchDelete.jsp");
	}

	/**
	 * 批量删除执行
	 * 
	 * @return json 0 成功 1 失败
	 */
	public void batchDelete() {
		JSONObject json = new JSONObject();
		String ids = getPara("selectIdValue");
		String reason = getPara("reason");
		json = CourseplanService.me.batchDelete(ids, reason);
		renderJson(json);
	}

	/**
	 * 批量修改备注
	 * 
	 * @return
	 */
	public void goUpdateRemark() {
		String ids = getPara("selectIdValue");
		setAttr("ids", ids);
		renderJsp("/batch/batchUpdateRemark.jsp");
	}

	/**
	 * 批量更新备注
	 * 
	 * @return json 0 成功 1失败
	 */
	public void batchUpdateRemark() {
		JSONObject json = new JSONObject();
		String ids = getPara("selectIdValue");
		String remarkinfo = getPara("remarkInfo");
		json = CourseplanService.me.batchUpdateRemark(ids, remarkinfo);
		renderJson(json);
	}

	/**
	 * 批量修改课程
	 * 
	 * @return
	 */
	public void goUpdateCourse() {
		String ids = getPara("selectIdValue");
		setAttr("ids", ids);
		setAttr("subjectList", Subject.dao.getSubject());
		setAttr("courseList", Course.dao.getCourses());
		renderJsp("/batch/batchUpdateCourse.jsp");
	}

	/**
	 * 获取课程通过科目ID
	 */
	public void getCourseBySubId() {
		JSONObject json = new JSONObject();
		String id = getPara("subjectid");
		List<Course> courseList = new ArrayList<Course>();
		if (id != null && id.length() > 0) {
			courseList = Course.dao.getCourseBySubjectId(id);
		}
		json.put("courseList", courseList);
		renderJson(courseList);
	}

	/**
	 * 批量更新课程
	 * 
	 * @return json 0 成功 1 失败
	 */
	public void batchUpdateCourse() {
		JSONObject json = new JSONObject();
		String ids = getPara("ids");
		String courseid = getPara("courseid");
		String subjectid = getPara("subjectid");
		json = CourseplanService.me.batchUpdateCourse(ids, courseid, subjectid);
		renderJson(json);
	}

	/**
	 * 批量修改教师排休
	 */
	public void goBatchUpdateTeacherRest() {
		String ids = getPara("selectIdValue");
		int type = getParaToInt("type");
		List<Map<String, String>> hourlist = new ArrayList<Map<String, String>>();
		for (int i = 5; i < 24; i++) {
			Map<String, String> hourmap = new HashMap<String, String>();
			String key = i < 10 ? "0" + i : i + "";
			hourmap.put("key", key);
			hourmap.put("value", key);
			hourlist.add(hourmap);
		}
		setAttr("hour", hourlist);// 排休列表
		setAttr("ids", ids); 
		if (type == 0) {
			renderJsp("/batch/batchUpdateTeacherRest.jsp");
		} else if (type == 1) {
			setAttr("courseplan", CoursePlan.coursePlan.findById(ids));
			renderJsp("/batch/updateTeacherRestInfo.jsp");
		}
	}

	/**
	 * 批量更新排休
	 * 
	 * @return json 0 成功 1失败
	 */
	public void batchUpdateTeacherRest() {
		String ids = getPara("ids");
		String time = getPara("timeMsg");
		JSONObject json = new JSONObject();
		json = CourseplanService.me.batchUpdateTeacherRest(ids, time);
		renderJson(json);
	}
	/**
	 * 修改课程详情
	 * @return
	 */
	public void goUpdateInfo(){
		String coursePlanId = getPara("selectIdValue") ;//记录ID
	    CoursePlan coursePlan = CoursePlan.coursePlan.findInfoById(coursePlanId)  ;
	    Student student = Student.dao.findById(coursePlan.getInt("STUDENTID").toString()) ;
	    String courseTime = coursePlan.getTimestamp("course_time").toString();
	    List<Teacher> teacherList = Teacher.dao.getTeachersByCourseids(coursePlan.getInt("COURSEID").toString());
	    Map<String,Object> roomMap = CourseplanService.me.getCampusDayRoomMsgMap(coursePlan.getInt("campusid").toString(),courseTime,coursePlan.getInt("trid").toString(),coursePlanId);
	    setAttr("coursePlan", coursePlan) ;
	    setAttr("teacherList", teacherList);
	    Integer teacherid = coursePlan.getInt("TCHID");
	    if(teacherid ==null){
	    	teacherid =0;
	    }
	    setAttr("rankList", CourseplanService.me.getEnableRankList(courseTime, teacherid.toString(), coursePlan.getInt("STUDENTID").toString(),coursePlanId));  
	    setAttr("roomList", roomMap.get("roomlists"));
	    setAttr("student", student) ;
	    setAttr("subjectList", Subject.dao.getSubject()) ;
	    setAttr("courseList",  CourseplanService.me.getCourseList(coursePlanId) ) ;
	    setAttr("campusList",Campus.dao.getCampusByLoginUser(getSysuserId()) ) ;//校区列表
	    setAttr("organization", Organization.getOrg());
	    renderJsp("/batch/updateInfo.jsp");
	}
	/**
	 * 通过课程获取教师列表
	 */
	public void getTeacherByCourse() {
		JSONObject json = new JSONObject() ;
		List<Teacher> teacherList = new ArrayList<Teacher>() ;
		String courseid = getPara("courseid") ;
		teacherList =  Teacher.dao.getTeachersByCourseids(courseid); //查询教师 ;
		json.put("teacherList", teacherList) ;
		renderJson(json);
	}
	
	/**
	 * 查询时段是否可用
	 */
	public void getEnableRankList() {
		JSONObject json = new JSONObject() ;
		String stuid = getPara("stuid") ;
		String tchid = getPara("tchid");
		String coursetime = getPara("coursetime");
		String cpid = getPara("cpid");
		String courseid = getPara("courseid");
		json.put("ranklist", CourseplanService.me.getEnableRankList(coursetime,tchid,stuid,cpid)) ;
		json.put("coursecosts", CoursecostService.me.queryByTeacheridAndCourseid(tchid, courseid));
		renderJson(json);
	}
	
	/**
	 * 通过时段获取可用教室
	 */
	public void getClassRoomByRankTime(){
		JSONObject json = new JSONObject();
		String coursePlanId = getPara("coursePlanId");
		String rankId = getPara("rankid");
		String campusid = getPara("campusid");
		String coursetime = getPara("coursetime");
		try{
			Map<String,Object> roomMap = CourseplanService.me.getCampusDayRoomMsgMap(campusid, coursetime, rankId,coursePlanId);
			json.put("normal","1");
			json.put("room", roomMap);
		}catch(Exception ex){
			json.put("normal","0");
			ex.printStackTrace();
		}
		renderJson(json);
	}
	/**
	 * 更新记录详情
	 */
	public void updateInfo(){
		CoursePlan coursePlan = null;
		JSONObject json = new JSONObject();
		String cpid = getPara("cpid");
		String roomid = getPara("roomid");
		String rankid = getPara("rankid");
		String teacherid = getPara("teacherid");
		String courseid = getPara("courseid");
		String coursetime = getPara("coursetime");
		String campusid = getPara("campusid");
		String remark = getPara("remark");
		if (cpid != null && cpid.length() > 0)
			coursePlan = CoursePlan.coursePlan.findById(cpid); // 记录 包含班课和学生两种
			coursePlan.set("TEACHER_ID", teacherid);
			coursePlan.set("COURSE_TIME", coursetime);
			coursePlan.set("COURSE_ID", courseid);
			coursePlan.set("TIMERANK_ID",rankid);
			coursePlan.set("CAMPUS_ID",campusid);
			coursePlan.set("ROOM_ID",roomid);
			coursePlan.set("callremark",remark) ;
			try {
				coursePlan.update();
				json.put("code", "0");
			} catch (Exception e) {
				e.printStackTrace();
				json.put("code", "1");
			}

		renderJson(json);
	}
	
	/**
	 * 查课表
	 */
	public void courseSchedule(){ 
		List<Map<String,String>> hourList = new ArrayList<Map<String,String>>(); 
		List<Map<String,String>>  minuList = new ArrayList<Map<String,String>>();
		//取时段
		for(int i = 0; i<24; i++){
			Map<String ,String> hourMap = new HashMap<String ,String>();
			String value  = "";
			if(i<10)
			{
				value = "0" +i;	
			}else{
				value = i + "";
			}
			hourMap.put("key",value);
			hourMap.put("value",value);
			hourList.add(hourMap);
		}
		for(int i = 0; i <= 6; i++){
			Map<String ,String> minuMap = new HashMap<String ,String>();
			String value = i*10+"";
			if(i==6) value = i*10-1 +"";
			if(i==0) value = i +"0" ;
			minuMap.put("key", value);
			minuMap.put("value", value);
			minuList.add(minuMap);
		}
		//取校区
		List<Campus> campusList = Campus.dao.getCampusByLoginUser(getSysuserId());
		//取教师
		List<Teacher> teacherList = Teacher.dao.getTeachersByCampusid(getAccountCampus());
		//参数回显
		String tchid = getPara("teacherid");
		String campusid = getPara("campusid");
		String startDate = getPara("startDate");
		String endDate = getPara("endDate");
		String starthour = getPara("starthour");
		String startmin = getPara("startmin");
		String endhour = getPara("endhour");
		String endmin = getPara("endmin");
		setAttr("startDate", startDate);
		setAttr("endDate", endDate); 
		setAttr("campusid",campusid );
		setAttr("starthours", starthour);
		setAttr("startmins", startmin);
		setAttr("endhours", endhour);
		setAttr("endmins", endmin);
		setAttr("tchid", tchid);
		setAttr("teacherList", teacherList);
		setAttr("campusList", campusList);
		setAttr("hourList", hourList);
		setAttr("minuList", minuList);
		renderJsp("/course/courseSchedule.jsp");
	}
	/**
	 * 获取日历课表内容
	 */
	public void findCourseScheduleList(){
		String message = "";
		//获取参数
		SysUser sysUser = SysUser.dao.findById(getSysuserId());
		String campusid = getPara("campusid");
		String startDate = getPara("startDate");
		String endDate = getPara("endDate");
		String starthour = StringUtils.isEmpty(getPara("starthour"))?"00":getPara("starthour");
		String endhour = StringUtils.isEmpty(getPara("endhour"))?"23":getPara("endhour");
		String startmin = StringUtils.isEmpty(getPara("startmin"))?"00":getPara("startmin");
		String endmin = StringUtils.isEmpty(getPara("endmin"))?"59":getPara("endmin");
		String rankIds = TimeRank.dao.findIdsToString(starthour,endhour,startmin,endmin);
		String teacherid = getPara("tchid");
		String loginRoleCampusIds = getAccountCampus();
		
		try {
			  message = CourseplanService.me.findCourseScheduleList(sysUser,rankIds,campusid,startDate,endDate,teacherid,loginRoleCampusIds);
		} catch (Exception e) {
			e.printStackTrace();
		}
		setAttr("startDate", startDate);
		setAttr("endDate", endDate);
		//renderText(message);
		renderJson(message);
	}
	/**
	 * 拖动日历更新课程,根据不同选择不同的操作 。
	 * 月、周（month,basicWeek）视图拖动时按天（12小时）为最小单位。
	 * 日（agendaDay）视图拖动时按分（） 。
	 * view = {agendaDay,month,basicWeek};
	 */
	public void adjustmentCourse(){
		JSONObject json = new JSONObject();
		String id = getPara("id");
		String isAllDay = getPara("isAllDay");
		String dateInterval = getPara("dateInterval");
		String minInterval = getPara("minInterval");
		String type = getPara("type");
		String view = getPara("view");
		if(view.equals("basicWeek")||view.equals("month")){//月视图或周视图
			try {
				json =  CourseplanService.me.adjustmentCourse(id,dateInterval,type);
			} catch (Exception e) {
				e.printStackTrace();
				json.put("code", "1");
				json.put("result", "服务器异常，请稍后再试");
			}
				renderJson(json);
		}else{//日视图（day）
			if(Integer.parseInt(type)!=2){//课程
				List<TimeRank> rankList = new ArrayList<TimeRank>();
				setAttr("id", id);
				setAttr("dateInterval", dateInterval);
				setAttr("isAllDay", isAllDay);
				setAttr("minInterval",minInterval);
				setAttr("type",type);
				setAttr("view", view);
				try {
					rankList = CourseplanService.me.getRankListBySameName(getPara("id"),getPara("minInterval"));
				} catch (Exception e) {
					e.printStackTrace();	
				}
				setAttr("rankList", rankList);
				renderJsp("/course/chooseTimeRank.jsp");
			}else{//教师休息
				List<Map<String, String>> hourlist = new ArrayList<Map<String,String>>();
				CoursePlan coursePlan = CoursePlan.coursePlan.findById(getPara("id"));
				int hour = Integer.parseInt(coursePlan.getStr("startrest").split(":")[0]) + (Integer.parseInt(coursePlan.getStr("startrest").split(":")[1]) + Integer.parseInt(minInterval))/60 ;
				for(;hour<24;hour++ ){
					Map<String, String> hourmap = new HashMap<String, String>();
					String key = hour < 10 ? "0" + hour : hour + "";
					hourmap.put("key", key);
					hourmap.put("value", key);
					hourlist.add(hourmap);
				}
				setAttr("id", getPara("id"));
				setAttr("dateInterval", getPara("dateInterval"));
				setAttr("isAllDay", getPara("isAllDay"));
				setAttr("minInterval", getPara("minInterval"));
				setAttr("type",getPara("type"));
				setAttr("view", getPara("view"));
				setAttr("coursePlan", coursePlan);
				setAttr("hourlist", hourlist);
				renderJsp("/course/calendarTeacherRest.jsp");
			}
			
		}
	}
	/**
	 * 保存更新时段信息
	 */
	public void saveTimeRank(){
		JSONObject json = new JSONObject();
		String cpid = getPara("cpid");
		String rankid = getPara("rankid");
		try {
			json = CourseplanService.me.saveTimeRank(cpid,rankid);
		} catch (Exception e) {
			json.put("code", 1);
		}
		renderJson(json);
	}
	/**
	 * 检查时段是否超期
	 */
	public void check(){
		JSONObject json = new JSONObject();
		String id = getPara("id");
		String  minInterval = getPara("minInterval");
		String type = getPara("type");
		try {
			json = CourseplanService.me.check(id,minInterval,type);
		} catch (Exception e) {
			e.printStackTrace();
			json.put("code", "1");
			json.put("code", "服务器异常");
		}
		
		renderJson(json);
	}
}
