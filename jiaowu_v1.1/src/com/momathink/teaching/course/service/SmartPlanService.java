
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

package com.momathink.teaching.course.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.leave.model.StudentAskingLeave;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Classroom;
import com.momathink.teaching.classtype.model.BanciCourse;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.course.model.SmartPlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Teacher;

public class SmartPlanService extends BaseService {

	public void queryAllPlan(SplitPage splitPage) {
		String listsql = "select sp.studentid,stu.REAL_NAME stuname,course.COURSE_NAME,sp.teacherid,sp.createuserid, sp.state,sp.id,sp.weekday,sp.addtime,"
				+ " sp.usedtimes,campus.CAMPUS_NAME,tr.RANK_NAME, "
				+ "(SELECT GROUP_CONCAT(REAL_NAME) FROM account WHERE FIND_IN_SET(Id, sp.assistantids)) AS assistantnames ";//助教的名字
		splitPageBase(splitPage, listsql);
		@SuppressWarnings("unchecked")
		Page<Record> page = (Page<Record>) splitPage.getPage();
		/*if(page!=null){*/
			List<Record> list = page.getList();
			for(Record record:list){
				record.set("weekday", record.getStr("weekday").replace("|", "、").replace("1", "星期一").replace("2", "星期二").replace("3", "星期三").replace("4", "星期四").replace("5", "星期五").replace("6", "星期六").replace("7", "星期日"));
				List<Account> acclist = Account.dao.find("select Id,REAL_NAME from account where  "
						+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) = 0");
				circle:for(Account acc:acclist){
					boolean tflag = false;boolean uflag = false; 
					if((acc.getInt("ID").toString()).equals(record.getInt("TEACHERID").toString())){
						record.set("teachername", acc.getStr("REAL_NAME"));
						tflag = true;
					}
					if((acc.getInt("ID").toString()).equals(record.getInt("CREATEUSERID").toString())){
						record.set("addusername", acc.getStr("REAL_NAME"));
						uflag = true;
					}
					if(tflag&&uflag){
						break circle;
					}
				}
			}
		/*}*/
	}
	
	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from smartplanrecord sp left join campus on campus.id=sp.campusid"
				+ " left join course on course.id = sp.courseid "
				+ " left join time_rank tr on tr.id = sp.timerankid "
				+ " left join account stu on stu.Id = sp.studentid "
				+ " where sp.state = 0 and 1=1");
		if (null == queryParam) {
			return;
		}
		String loginRoleCampusIds = queryParam.get("loginRoleCampusIds");
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "studentname":
				if(!StringUtils.isEmpty(value)){
					formSqlSb.append(" and stu.REAL_NAME like ? ");
					paramValue.add("%" + value + "%");
				}
				break;
			case "campusname":
				if(!StringUtils.isEmpty(value)){
					formSqlSb.append(" and campus.CAMPUS_NAME like ? ");
					paramValue.add("%" + value + "%");
				}
				break;
			default:
				break;
			}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSqlSb.append(" and campus.id in (" + loginRoleCampusIds + ")" );
		}
		formSqlSb.append(" ORDER BY sp.id  DESC");
	}

	/**
	 * 某个学员具有的课程
	 * @param stuId
	 * @return
	 */
	public List<Course> getStudentCourses(String stuId) {
		Student student = Student.dao.findById(stuId);
		//小班
		if(student.getInt("STATE").toString().equals("2")){
			ClassOrder classorder = ClassOrder.dao.findByXuniId(student.getInt("Id"));
			List<BanciCourse> bancicourse = BanciCourse.dao.getBanciCourseCanUse(classorder.getInt("id"));
			List<Course> list = new ArrayList<Course>();
			if(bancicourse.size()>0){
				for(BanciCourse banci:bancicourse){
					Course course = new Course();
					course.put("courseid",banci.getInt("course_id"));
					course.put("coursename",banci.getStr("course_name"));
					list.add(course);
				}
			}
			return list;
		}else{
			//一对一
			List<CourseOrder> courseorder = CourseOrder.dao.findOrderByStudentId(stuId);
			StringBuilder sb = new StringBuilder();
			if(courseorder.size()>0){
				for(CourseOrder order:courseorder){
					sb.append(",\"").append(order.getStr("subjectids").replace("\\|", "\",\"")).append("\"");
				}
				List<Course> courselist = Course.dao.getCourseBySubjectIds(sb.toString().replaceFirst(",", ""));
				return courselist;
			}else{
				return null;
			}
		}
	}

	/**
	 * 
	 * @param userName
	 * @return
	 */
	public List<Account> getAccountByNameLike(String userName) {
		String sql = "select Id,REAL_NAME from account where  "
				+ " (LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0  or roleids = '') and real_name like \"%" + userName + "%\"  order by Id desc";
		List<Account> list = Account.dao.find(sql);
		return list;
	}

	/**
	 * 某课程的老师
	 * @param stuid
	 * @param courseid
	 * @return
	 */
	public List<Teacher> getCourseTeachers(String stuid, String courseid, String loginRoleCampusIds ) {
		List<Teacher> list = new ArrayList<Teacher>();
		String sql = "select account.Id Id, account.REAL_NAME REAL_NAME, account.CLASS_TYPE CLASS_TYPE from account "
				+ " LEFT JOIN account_campus accountCampus ON account.id = accountCampus.account_id "
				+ " LEFT JOIN campus ON accountCampus.campus_id = campus.id where  "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0 "
				+ " AND CLASS_TYPE IS NOT NULL AND campus.id in (" + loginRoleCampusIds + ")" ;
		List<Teacher> tlist = Teacher.dao.find(sql);
		if(tlist.size()>0){
			for(Teacher tch : tlist){
				String classtype[] =  tch.getStr("CLASS_TYPE").split("\\|");
				if(classtype.length>0){
					circle:for(int i=0;i<classtype.length;i++){
						if(classtype[i].equals(courseid)){
							list.add(tch);
							break circle;
						}
					}
				}
			}
		}
		return list;
		
	}

	public SmartPlan getSmartPlan(String ruleid) {
		String sql = "select sp.studentid,stu.REAL_NAME stuname,sp.timerankid,course.COURSE_NAME,sp.courseid,sp.teacherid,teach.REAL_NAME teachername,sp.createuserid,"
				+ " sp.state,sp.id,sp.weekday,sp.addtime, sp.usedtimes,campus.CAMPUS_NAME,tr.RANK_NAME,tr.class_hour,sp.campusid, "
				+ "(SELECT GROUP_CONCAT(REAL_NAME) FROM account WHERE FIND_IN_SET(Id, sp.assistantids)) AS assistantnames,sp.assistantids "//助教的名字
				+ " from smartplanrecord sp left join campus on campus.Id = sp.campusid "
				+ " left join course on course.Id = sp.courseid left join account teach on teach.Id = sp.teacherid "
				+ " left join account stu on stu.Id = sp.studentid left join time_rank tr on tr.id = sp.timerankid "
				+ " where sp.id = ?  ";
		SmartPlan ruleplan = SmartPlan.dao.findFirst(sql,ruleid);
		ruleplan.put("weeknames", ruleplan.getStr("weekday").replace("|", "、").replace("1", "星期一").replace("2", "星期二").replace("3", "星期三").replace("4", "星期四").replace("5", "星期五").replace("6", "星期六").replace("7", "星期日"));
		String weekstr = ruleplan.getStr("weeknames").split("、")[0];
		Date dateToday = new Date();
		String hhmm = ToolDateTime.dateToDateString(dateToday).substring(10,16).trim().replace(":", "");
		String rhm = ruleplan.getStr("RANK_NAME").split("-")[0].replace(":", "");
		if(Integer.parseInt(hhmm)>Integer.parseInt(rhm)){
			dateToday =  ToolDateTime.getInternalDateByDay(dateToday, 1);
		}
		circle:for(int i=0;i<7;i++){
			Date datenext = ToolDateTime.getInternalDateByDay(dateToday, i);
			String dayname = ToolDateTime.getDateInWeek(datenext, 1);
			if(dayname.equals(weekstr)){
				ruleplan.put("firstday", ToolDateTime.dateToDateString(datenext, ToolDateTime.DATAFORMAT_STR));
				break circle;
			}
		}
		
		return ruleplan;
	}

	public synchronized Map<String, Object> getRoomAndDays(String stime, String alldays, String weekday, String stuid, String teacherid, String rankid, String campusid, String courseid) {
		//取出下个星期几是几号
		Map<String,Object> map = new HashMap<String,Object>();
		String code = "0";
		String msg = "校验成功，可以排课";
		try {
		
			List<Classroom> rooms = Classroom.dao.getClassRoombyCampusid(campusid);
			TimeRank rank = TimeRank.dao.findById(rankid);
			String[] plantime = rank.getStr("RANK_NAME").split("-");
			Integer planfirst = Integer.parseInt(plantime[0].replace(":", ""));
			Integer planlast = Integer.parseInt(plantime[1].replace(":", ""));
			List<String> tlist = new ArrayList<String>();
			StringBuilder candaylist = new StringBuilder();
			StringBuilder cantroomids = new StringBuilder(",");
			String sstime = stime;
			int days = Integer.parseInt(alldays);
			String[] weekarr = weekday.split("\\|");
			if(weekarr.length>0){
				all:for(int wa=0;wa<weekarr.length;wa++){
					String wday = weekarr[wa];
					wday = wday.equals("1")?"星期一":wday.equals("2")?"星期二":wday.equals("3")?"星期三":wday.equals("4")?"星期四":wday.equals("5")?"星期五":wday.equals("6")?"星期六":wday.equals("7")?"星期日":"";
					
					for(int i=0;i<7;i++){
						String nowtime = ToolDateTime.getSpecifiedDayBefore(sstime, -i);
						String testweekday = ToolDateTime.getDateInWeek(ToolDateTime.parse(nowtime, ToolDateTime.pattern_ymd), 1);
						if(testweekday.equals(wday)){
							sstime = nowtime;
						}
					}
					String firstdaytime = sstime;
					for(int j=0;j<days;j++){
						boolean flag = true;
						//老师课程
						sstime = ToolDateTime.getSpecifiedDayBefore(firstdaytime, -(j*7));
						List<CoursePlan> teachcourseplan = CoursePlan.coursePlan.getTeacherCoursePlansByDay(sstime, teacherid);
						if(teachcourseplan.size()>0){
							circle:for(CoursePlan plan : teachcourseplan){
								String[] planedtime = plan.getStr("RANK_NAME").split("-");
								Integer planedFirst = Integer.parseInt(planedtime[0].replace(":", ""));
								Integer planedLast = Integer.parseInt(planedtime[1].replace(":", ""));
								if((planedFirst<planlast&&planedFirst>=planfirst)||(planedLast<=planlast&&planedLast>planfirst)
										||(planedLast>=planlast&&planedFirst<=planfirst)){
									flag = false;
									if((plan.getInt("CAMPUS_ID").toString()).equals(campusid)){
	//							cantroomids.append(plan.getInt("ROOM_ID")).append(",");
									}
									break circle;
								}
							}
						}
						//老师休息
						List<CoursePlan> teachdayrest = CoursePlan.coursePlan.queryDayRestCount(sstime,teacherid);
						if(teachdayrest.size()>0){
							circle:for(CoursePlan rest : teachdayrest){
								Integer restfirst = Integer.parseInt(rest.getStr("startrest").replace(":", ""));
								Integer restlast = Integer.parseInt(rest.getStr("endrest").replace(":", ""));
								if((restfirst<planlast&&restfirst>=planfirst)||(restlast<=planlast&&restlast>planfirst)
										||(restlast>=planlast&&restfirst<=planfirst)){
									flag = false;
									break circle;
								}
							}
						}
						//学生课程
						List<CoursePlan> stucourseplan = CoursePlan.coursePlan.getStuCoursePlansBetweenDates(stuid, sstime, sstime);
						if(stucourseplan.size()>0){
							circle:for(CoursePlan stuplan:stucourseplan){
								String planedtime = stuplan.getStr("RANK_NAME");
								Integer planedFirst = Integer.parseInt(planedtime.split("-")[0].replace(":", ""));
								Integer planedLast = Integer.parseInt(planedtime.split("-")[1].replace(":", ""));
								if((planedFirst<planlast&&planedFirst>=planfirst)||(planedLast<=planlast&&planedLast>planfirst)
										||(planedLast>=planlast&&planedFirst<=planfirst)){
									flag = false;
									if((stuplan.getInt("CAMPUS_ID").toString()).equals(campusid)){
	//							cantroomids.append(stuplan.getInt("ROOM_ID")).append(",");
									}
									break circle;
								}
							}
						}
						//学生请假
						//String[] times = plantime.split("-");//只计算 开始时间, 后面 的时间冲突,自动跳过
						List<StudentAskingLeave> studentaskingleaves = StudentAskingLeave.dao.queryByStudentid(stuid, stime + " " + plantime[0], stime + " " + plantime[1]);
						if(studentaskingleaves.size() > 0 ){
							flag = false;
							code = "1";
							msg = "学生请假,请做调整.";
							break all;
						}
						
						if(flag){
							candaylist.append(",").append(sstime);
							tlist.add(sstime);
						}else{
							code = "1";
							msg = "课程冲突,请做调整.";
							break all;
						}
					}
					sstime = stime;
					days = Integer.parseInt(alldays);
				}
			}
			//校区 教室被别人占用
			if(code.equals("0")){
				if(tlist.size()>0){
					for(String strtime:tlist){
						List<Record> roomused = CoursePlan.coursePlan.getCoursePlanDay(strtime, Integer.parseInt(campusid));
						if(roomused.size()>0){
							for(Record record:roomused){
								String planedtime = record.getStr("RANK_NAME");
								Integer planedFirst = Integer.parseInt(planedtime.split("-")[0].replace(":", ""));
								Integer planedLast = Integer.parseInt(planedtime.split("-")[1].replace(":", ""));
								if((planedFirst<planlast&&planedFirst>=planfirst)||(planedLast<=planlast&&planedLast>planfirst)
										||(planedLast>=planlast&&planedFirst<=planfirst)){
									cantroomids.append(record.getInt("ROOMID")).append(",");
								}
							}
						}
						
					}
				}
				Collections.sort(tlist);
				for(Classroom room:rooms){
					String roomstr = ","+room.getInt("Id").toString()+"," ;
					if(cantroomids.indexOf(roomstr)!=-1){
						room.put("used","yes");
					}else{
						room.put("used", "no");
					}
				}
				map.put("rooms", rooms);
			}
			map.put("canlist", candaylist.toString().replaceFirst(",", ""));
			map.put("lastday", tlist.size()>1?tlist.get(tlist.size()-1):null);
		}catch(NumberFormatException e){
			code = "1";
			msg = "周期不正确,请做调整(整数).";
		} catch (Exception e) {
			code = "1";
			msg = "参数不正确,请做调整.";
		}
		map.put("code", code);
		map.put("msg", msg);
		return map;
	}

	public synchronized JSONObject showStudentLastCourse(String stuid, String courseid) {
		JSONObject json = new JSONObject();
		String msg="无课程记录";
		String code="0";
		Student student = Student.dao.findById(stuid);
		Course course = Course.dao.findById(courseid);
		json.put("studentname", student.getStr("REAL_NAEM"));
		try{
			List<CoursePlan> alllist = CoursePlan.coursePlan.querycpList(stuid,null);
			List<CoursePlan> courselist = CoursePlan.coursePlan.querycpList(stuid,courseid);
			if(alllist.size()>0){
				code = "1";
				CoursePlan allplan = CoursePlan.coursePlan.getLastCoursePlan(stuid,null);
				json.put("alltime", allplan.getStr("lasttime"));
				msg = student.getStr("REAL_NAME") +" 同学:<br>所有课程已排到："+allplan.getStr("lasttime")+"<br>";
				if(courselist.size()>0){
					CoursePlan courseplan = CoursePlan.coursePlan.getLastCoursePlan(stuid,courseid);
					json.put("coursetime", courseplan.getStr("lasttime"));
					msg += course.getStr("COURSE_NAME") + " 已排到： ";
					msg += courseplan.getStr("lasttime");
				}else{
					json.put("coursetime", "");
					msg += course.getStr("COURSE_NAME") +  "未有排课记录";
				}
			}else{
				code = "0";
				msg = "无课程记录";
			}
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		json.put("msg", msg);
		json.put("code", code);
		
		return json;
	}

}
