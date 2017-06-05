
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

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolArith;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.campus.model.Classroom;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.course.model.SmartPlan;
import com.momathink.teaching.course.service.CourseService;
import com.momathink.teaching.course.service.CourseplanService;
import com.momathink.teaching.course.service.SmartPlanService;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Teacher;

@Controller(controllerKey="/smartplan")
public class SmartPlanController extends BaseController {

	private SmartPlanService smartplanService = new SmartPlanService();
	private CourseplanService coursePlanService = new CourseplanService();
	private CourseService courseService = new CourseService();
	
	public void setNewRule(){
		try{
			String stuId = getPara("stuid");
			setAttr("stuid", stuId);
			String campusid = getPara("campusid");
			setAttr("campusid", campusid);
			
			List<Campus> campus = Campus.dao.getCampusByLoginUser( getSysuserId() );
			setAttr("campus",campus);
			List<TimeRank> timelist = TimeRank.dao.getTimeRank();
			setAttr("trlist",timelist);
			if(StringUtils.isEmpty(stuId)){
				setAttr("stu","hant");
				setAttr("stucourse", null);
				setAttr("studentName",null);
			}else{
//				List<Course> courselist = smartplanService.getStudentCourses(stuId);
				Student student = Student.dao.findById(stuId);
				String type = "1";
				String classid = null;
				if(student.getInt("STATE").toString().equals("2")){
					type="2";
					ClassOrder classOrder = ClassOrder.dao.findByXuniId(student.getPrimaryKeyValue());
					classid = classOrder.getPrimaryKeyValue().toString();
				}
				List<Record> courselist = courseService.getStudentOrClassCourse(stuId,classid,type,0+"");
				setAttr("stu","has");
				setAttr("stucourse", courselist);
				setAttr("studentName",Student.dao.findById(stuId).getStr("REAL_NAME"));
			}
			setAttr("isAssistantTeachers", Teacher.dao.getIsAssistantTeacherByCampusid( getAccountCampus() ));
		}catch(Exception ex){
			ex.printStackTrace();
		}
		renderJsp("/course/layer_smartrule.jsp");
	}
	
	public void getAccountByNameLike(){
		try {
			String userName = getPara("studentName");
			List<Account> list = smartplanService.getAccountByNameLike(userName);
			renderJson("accounts", list);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	public void getRuleStudentCourses(){
		String stuid = getPara("stuid");
		List<Course> courselist = smartplanService.getStudentCourses(stuid);
		renderJson(courselist);
	}
	
	public void getCourseTeachers(){
		try{
			String stuid = getPara("stuid");
			String courseid = getPara("courseid");
			String loginRoleCampusIds = getAccountCampus();
			List<Teacher> list = smartplanService.getCourseTeachers( stuid, courseid, loginRoleCampusIds );
			renderJson(list);
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	public void saveRulePlan(){
		JSONObject json = new JSONObject();
		boolean flag = false;
		try{
			String[] weekdays = getParaValues("weekdays");
			SmartPlan smartplan = getModel(SmartPlan.class);
			SysUser user = SysUser.dao.findById(getSysuserId());
			if(user!=null){
				smartplan.set("createuserid", user.getInt("Id"));
			}
			StringBuffer sb = new StringBuffer("");
			if(weekdays.length>0){
				for(String wday:weekdays){
					sb.append("|").append(wday);
				}
			}
			smartplan.set("weekday", sb.toString().replaceFirst("\\|", ""));
			smartplan.set("addtime", new Date());
			flag = smartplan.save();
		}catch(Exception ex){
			ex.printStackTrace();
			flag = false;
		}
		if(flag){
			json.put("code", "1");
			json.put("msg", "保存成功.");
		}else{
			json.put("code", "0");
			json.put("msg", "保存失败.");
		}
		renderJson(json);
	}
	
	/**
	 * @Title: 排课页
	 */
	public void setRowRuleCourse(){
		try{
			String ruleid = getPara();
			setAttr("ruleid",ruleid);
			SmartPlan smartrule = smartplanService.getSmartPlan(ruleid);
			setAttr("smartrule", smartrule);
			setAttr("planday", new Date());
			setAttr("createuser", getAccount().getStr("REAL_NAME"));
			setAttr("room", Classroom.dao.getAllRooms());
		}catch(Exception ex){
			ex.printStackTrace();
		}
		renderJsp("/course/layer_setrulecourse.jsp");
	}
	
	public void sureEnoughHours(){
		String stime = getPara("stime");
		String alldays = getPara("alldays");
		String allhours = getPara("allhours");
		String weekday = getPara("weekday");
		String stuid = getPara("stuid");
		String rankid = getPara("rankid");
		String teacherid = getPara("teacherid");
		String campusid = getPara("campusid");
		String courseid = getPara("courseid");
		JSONObject json = new JSONObject();
		String msg = "msg";
		String code= "0";
		try{
			Student student = Student.dao.findById(stuid);
			if(student.getInt("state").toString().equals("2")){
				ClassOrder classorder = ClassOrder.dao.findByXuniId(student.getPrimaryKeyValue());
				float coursesum = classorder.getInt("lessonNum").floatValue();
				float thishours = Float.parseFloat(allhours);
				float ypks =  CoursePlan.coursePlan.getClassYpkcClasshour(classorder.getPrimaryKeyValue());
				double syks = ToolArith.sub(coursesum, ToolArith.add(thishours, ypks));
				if(syks>=0){
					Map<String,Object> map = smartplanService.getRoomAndDays(stime,alldays,weekday,stuid,teacherid,rankid,campusid,courseid);
					json.put("map", map);
					msg = "";
					code= "1";
				}else{
					msg = "课时不足";
					code= "0";
				}
			}else{
				double zks = CourseOrder.dao.getCanUseVIPzks(student.getPrimaryKeyValue());
				double ypks = CoursePlan.coursePlan.getUseClasshour(stuid,null);//全部已用课时
				float thishours = Float.parseFloat(allhours);
				double syks = ToolArith.sub(zks, ToolArith.add(thishours, ypks));
				if(syks>=0){
					Map<String,Object> map = smartplanService.getRoomAndDays(stime,alldays,weekday,stuid,teacherid,rankid,campusid,courseid);
					json.put("map", map);
					msg="";
					code="1";
				}else{
					msg = "课时不足";
					code= "0";
				}
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
		
	}
	
	public void delPlanRule(){
		JSONObject json = new JSONObject();
		String msg="成功删除";
		String code="1";
		String id = getPara("id");
		String force = getPara("force");
		SmartPlan rule = SmartPlan.dao.findById(id);
		if(rule==null){
			msg="该规则不存在。";
			code="0";
		}else{
			if(StrKit.isBlank(rule.getStr("coursedays")) || "force".equals(force)){
				rule.delete();
				msg="删除成功";
				code="1";
			}else{
				msg="该规则已使用，不能删除.";
				code="0";
			}
		}
		json.put("msg", msg);
		json.put("code", code);
		renderJson(json);
		
	}
	
	
	public void showStudentLastCourse(){
		JSONObject json = new JSONObject();
		String id = getPara("id");
		SmartPlan rule = SmartPlan.dao.findById(id);
		Integer stuid = rule.getInt("studentid");
		Integer courseid = rule.getInt("courseid");
		json = smartplanService.showStudentLastCourse(stuid.toString(),courseid.toString());
		renderJson(json);
	}
	
}
