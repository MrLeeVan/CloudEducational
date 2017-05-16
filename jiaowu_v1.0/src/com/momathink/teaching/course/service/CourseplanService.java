
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

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.i18n.Res;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.constants.MesContantsFinal;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.account.model.BanciCourse;
import com.momathink.sys.account.service.AccountService;
import com.momathink.sys.dict.model.Dict;
import com.momathink.sys.leave.model.StudentAskingLeave;
import com.momathink.sys.sms.service.MessageService;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.campus.model.Classroom;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Coursecost;
import com.momathink.teaching.teacher.model.Teacher;
import com.momathink.teaching.teacher.model.Teachergrade;
import com.momathink.teaching.teacher.model.Teachergroup;
import com.momathink.teaching.teacher.service.CoursecostService;

public class CourseplanService extends BaseService {
	public static final CourseplanService me = new CourseplanService();

	public void list(SplitPage splitPage) {
		String select = "SELECT s.REAL_NAME STUNAME,t.real_name teachername,cp.isovertime, DATE_FORMAT(cp.course_time,'%Y-%m-%d') COURSETIME,tr.RANK_NAME ranktime, tr.class_hour,c.COURSE_NAME  courseName,cp.class_id,campus.CAMPUS_NAME,cp.TEACHER_PINGLUN,cp.iscancel,cp.SIGNIN  signin ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		String stuid = queryParam.get("stuid");
		String tid = queryParam.get("tid");
		String courseid = queryParam.get("courseid");
		String signin = queryParam.get("signin");
		String plun = queryParam.get("TEACHER_PINGLUN");
		String iscancel = queryParam.get("ISCANCEL");
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds");
		String startTime = ToolString.isNull(queryParam.get("startTime")) ? ToolDateTime.getMonthFirstDayYMD(new Date()) : queryParam.get("startTime");
		String endTime = ToolString.isNull(queryParam.get("endTime")) ? ToolDateTime.getMonthLastDayYMD(ToolDateTime.getDate(startTime + " 00:00:00"))
				: queryParam.get("endTime");
		formSqlSb.append("FROM courseplan cp " + "LEFT JOIN class_order co ON cp.class_id = co.id " + "LEFT JOIN account s ON cp.STUDENT_ID = s.Id "
				+ "left join course c on cp.course_id = c.id   " + "Left join account t on cp.teacher_id = t.id "
				+ "LEFT JOIN time_rank tr ON cp.TIMERANK_ID = tr.Id " + "LEFT JOIN campus ON cp.CAMPUS_ID = campus.Id " + "WHERE cp.PLAN_TYPE=0 ");
		
		if( !StringUtils.isEmpty(loginRoleCampusIds) ){
			formSqlSb.append( " and cp.campus_id in (" + loginRoleCampusIds +")" );
		}
		if (null != stuid && !stuid.equals("")) {
			formSqlSb.append("  and s.ID = ").append(stuid);
			queryParam.put("STUNAME", getStuName(Integer.parseInt(stuid)));
		}
		if (null != tid && !tid.equals("")) {
			formSqlSb.append(" and t.ID = ").append(tid);
		}
		if (null != startTime && !startTime.equals("")) {
			formSqlSb.append(" and cp.course_time >= '").append(startTime).append("'");
		}
		if (null != iscancel && !iscancel.equals("")) {
			formSqlSb.append(" and cp.iscancel= ").append(iscancel);
		}
		if (null != endTime && !endTime.equals("")) {
			formSqlSb.append(" and cp.course_time <= '").append(endTime).append("'");
		}
		if (null != courseid && !courseid.equals("")) {
			formSqlSb.append(" and cp.COURSE_ID = ").append(courseid);
		}
		if (null != signin && !signin.equals("")) {
			formSqlSb.append(" and cp.SIGNIN = ").append(signin);
		}
		if (null != plun && !plun.equals("")) {
			formSqlSb.append(" and cp.TEACHER_PINGLUN= '").append(plun).append("'");
		}

	}

	/**
	 * 课程结束才可以补签
	 * 
	 * @param id
	 * @return
	 */
	public Map<String, Object> confirmCoursePlan(String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		CoursePlan courseplan = CoursePlan.dao.findById(id);
		TimeRank tr = TimeRank.dao.findById(courseplan.getInt("TIMERANK_ID"));
		StringBuffer sb = new StringBuffer(ToolDateTime.format(courseplan.getDate("COURSE_TIME"), "yyyy-MM-dd"));
		sb.append(" ").append(tr.getStr("RANK_NAME").split("-")[1]).append(":00");
		String nowdate = ToolDateTime.format(new Date(), ToolDateTime.pattern_ymd_hms);
		boolean flag = nowdate.compareTo(sb.toString()) > 0 ? true : false;
		if (flag) {
			map.put("code", "1");
			map.put("msg", "");
		} else {
			map.put("code", "0");
			map.put("msg", "课程未结束,不能补签.");
		}
		return map;
	}

	/**
	 * 课程结束之后只能让他补签
	 * 
	 * @param id
	 * @return
	 */
	public Map<String, Object> confirmCoursePlanReadySign(String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		CoursePlan courseplan = CoursePlan.dao.findById(id);
		TimeRank tr = TimeRank.dao.findById(courseplan.getInt("TIMERANK_ID"));
		StringBuffer sb = new StringBuffer(ToolDateTime.format(courseplan.getDate("COURSE_TIME"), "yyyy-MM-dd")).append(" ")
				.append(tr.getStr("RANK_NAME").split("-")[1]).append(":00");
		String nowdate = ToolDateTime.format(new Date(), ToolDateTime.pattern_ymd_hms);
		long end = ToolDateTime.compareDateStr(sb.toString(), nowdate);
		boolean flag = end > 1800000 ? false : true;
		String startcourse = ToolDateTime.format(courseplan.getDate("COURSE_TIME"), "yyyy-MM-dd") + " " + tr.getStr("RANK_NAME").split("-")[0] + ":00";
		long start = ToolDateTime.compareDateStr(nowdate, startcourse);
		boolean bflag = start > 1800000 ? false : true;
		if (flag) {
			if (bflag) {
				map.put("code", "1");
				map.put("msg", "");
			} else {
				map.put("code", "0");
				map.put("msg", "提前30分钟才可以签到.");
			}
		} else {
			map.put("code", "0");
			map.put("msg", "课程结束超过30分钟，请进行补签.");
		}
		return map;
	}

	/**课程列表*/
	public void queryUserMessage(SplitPage splitPage) {
		StringBuffer select = new StringBuffer(
				"SELECT cp.Id as courseplan_id,cp.COURSE_TIME as courseplan_time,cp.class_id,cp.SIGNIN,cp.signedtime,cp.signcause,cp.confirm,cp.cancelReason,    "
						+ "c.COURSE_NAME ,ast.REAL_NAME as student_name, at.REAL_NAME as teacher_name, "
						+ "ca.CAMPUS_NAME, cr.NAME as room_name,tr.RANK_NAME, sj.SUBJECT_NAME, "
						+ "co.classNum ,ct.name as type_name,ap.REAL_NAME as signinperson,tg.singn,tg.singnremark,tg.demohour");
		
		StringBuffer formSqlSb = new StringBuffer(
				  " FROM courseplan  cp " 
				+ " LEFT JOIN course c on cp.COURSE_ID = c.Id " 
				+ " LEFT JOIN account ast on cp.STUDENT_ID = ast.Id "
				+ " LEFT JOIN account at on cp.TEACHER_ID=at.Id " 
				+ " LEFT JOIN campus ca on cp.CAMPUS_ID = ca.Id"
				+ " LEFT JOIN classroom cr on cp.ROOM_ID= cr.Id " 
				+ " LEFT JOIN time_rank tr on cp.TIMERANK_ID = tr.Id"
				+ " LEFT JOIN subject sj on cp.SUBJECT_ID = sj.Id" 
				+ " LEFT JOIN class_order co on cp.class_id = co.id"
				+ " LEFT JOIN class_type ct on co.classtype_id = ct.id" 
				+ " LEFT JOIN account ap on cp.signinperson_id = ap.Id"
				+ " LEFT JOIN teachergrade tg ON cp.Id=tg.COURSEPLAN_ID" 
				+ " WHERE cp.STATE = 0 AND cp.iscancel = 0 AND cp.PLAN_TYPE = 0 ");
		
		Map<String, String> queryParam = splitPage.getQueryParam();
		Map<String, String> put = new HashMap<String, String>();
		List<Object> paramValue = new ArrayList<Object>();
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds");
		Set<String> keyList = queryParam.keySet();
		for (String key : keyList) {
			String value = queryParam.get(key);
			switch (key) {
			case "stuid":
				formSqlSb.append("and cp.STUDENT_ID = ? ");
				paramValue.add(Integer.parseInt(value));
				put.put("STUNAME", getStuName(Integer.parseInt(value)));
				break;
			case "confirm":
				formSqlSb.append("and cp.confirm in( " + value + ") ");
				formSqlSb.append("and ast.STATE != 2 ");
				break;
			case "confirmOrState":
				formSqlSb.append("and ( ast.STATE = 2 OR cp.confirm in( " + value + ") ) ");
				break;
			case "teacherId":
				formSqlSb.append("and cp.teacher_id = ? ");
				paramValue.add(Integer.parseInt(value));
				break;
			case "studentname":
				formSqlSb.append("and  ast.real_name like ? ");
				paramValue.add("%" + value + "%");
				put.put("studentname", value);
				break;
			case "teachername":
				formSqlSb.append("and  at.real_name like ? ");
				paramValue.add("%" + value + "%");
				put.put("teachername", value);
				break;
			case "tid":
				formSqlSb.append(" and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', t.roleids) ) > 0  and t.ID = ? ");
				paramValue.add(Integer.parseInt(value));
				formSqlSb.append(" and cp.id not in (select id from courseplan as cplan where cplan.state=0 and cplan.class_id <> 0 ) ");
				break;
			case "ISCANCEL":
				formSqlSb.append(" and cp.iscancel= ? ");
				paramValue.add(value);
				break;
			case "startTime":
				formSqlSb.append(" and cp.course_time >= ? ");
				paramValue.add(value);
				break;
			case "endTime":
				formSqlSb.append(" and cp.course_time <= ? ");
				paramValue.add(value);
				break;
			case "courseid":
				formSqlSb.append(" and cp.COURSE_ID = ? ");
				paramValue.add(value);
				break;
			case "signin":
				formSqlSb.append(" and cp.SIGNIN = ? ");
				paramValue.add(value);
				break;
			case "TEACHER_PINGLUN":
				formSqlSb.append(" and cp.TEACHER_PINGLUN = ? ");
				paramValue.add(value);
				break;
			}
		}
		queryParam.putAll(put);
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSqlSb.append(" and ca.id in (" + loginRoleCampusIds + ")" );
		}
		formSqlSb.append(" ORDER BY cp.COURSE_TIME DESC,tr.RANK_NAME,cr.NAME ");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSqlSb.toString(), paramValue.toArray());
		splitPage.setPage(page);
	}

	private String getStuName(Integer stuId) {
		Student stu = Student.dao.findById(stuId);
		return stu.getStr("REAL_NAME");
	}

	/*
	 * private String getTeacherName(Integer tId) { Teacher teacher =
	 * Teacher.dao.findById(tId); return teacher.getStr("REAL_NAME"); }
	 */

	public Map<String, Float> queryCourseplanInfo(Integer studentId, String start, String end) {
		Map<String, Float> result = new HashMap<String, Float>();
		float y = 0;
		float x = 0;
		if (studentId != null) {
			List<CoursePlan> cList = CoursePlan.dao.findByStudentId(studentId, start, end);
			for (CoursePlan c : cList) {
				Integer classId = c.getInt("class_id");
				float classhour = c.getBigDecimal("class_hour").floatValue();
				if (classId == null || classId == 0) {// 1对1
					y += classhour;
				} else {// 小班
					x += classhour;
				}
			}
		}
		result.put("vip", y);
		result.put("xb", x);
		return result;
	}

	public List<CoursePlan> queryCourseByMediatorId(Integer mediator) {

		return null;
	}

	/**
	 * 删除课程管理列表中某条记录
	 * 
	 * @param planId
	 *            课程ID
	 * @param operateId
	 *            操作人ID
	 * @param delreason
	 *            删除理由
	 * @param enforce
	 * @param delHistoryCoursePlan
	 *            权限验证
	 * @return
	 */
	public JSONObject deleteCoursePlan(Integer planId, Integer operateId, String delreason, String studentId, String enforce, boolean delHistoryCoursePlan) {
		JSONObject json = new JSONObject();
		String code = "0";
		String msg = "删除成功";
		Student student = null;
		if (planId != null) {// 课程ID
			CoursePlan coursePlan = CoursePlan.dao.findById(planId);// 取出待删除的课程
			if (coursePlan != null) {
				if (!ToolString.isNull(studentId)) {
					student = Student.dao.findById(studentId);// 查询学生
				} else {
					student = Student.dao.findById(coursePlan.getInt("student_id"));// 查询学生
				}
				String today = ToolDateTime.format(new Date(), ToolDateTime.pattern_ymd) + " 00:00:00";
				String courseTime = ToolDateTime.format(coursePlan.getTimestamp("course_time"), ToolDateTime.pattern_ymd) + " 00:00:00";
				long betw = ToolDateTime.compareDateStr(today, courseTime);// 课程时间和当前时间间隔
				if (coursePlan.getInt("PLAN_TYPE") == 2) {// 0为课程类型1为模考类型2老师休息
					if (betw >= 0 || delHistoryCoursePlan) { // 课程还未开课
						String sql3 = "delete from  courseplan where ID=? ";
						Db.update(sql3, coursePlan.getPrimaryKeyValue());// 删除老师休息记录
						code = "1";
					} else {
						code = "0";
						msg = "您没有删除今日(包括)之前课程安排和排序权限"; // 课程一开可或者权限不够
					}
				} else { // //此时是删除一对一课程
					if (coursePlan.getInt("SIGNIN") != 0 && !"yes".equals(enforce)) { // 查看是否已经签到
						code = "2";
						msg = "已签到禁止删除该排课记录";
					} else {
						Integer banid = coursePlan.getInt("class_id");// 班次ID
						if (betw >= 0 || delHistoryCoursePlan) { // 权限认证
							if ("0".equals(banid + "")) {// 1对1退费
								// 更新排课记录的update_time
								String sql2 = "update courseplan set del_msg = ?,update_time=now() where ID=? "; // 设置更新信息
								Db.update(sql2, delreason, coursePlan.getPrimaryKeyValue()); // 更新信息
								coursePlan.set("deluserid", operateId); // 操作人ID
								coursePlan.update(); // 更新记录
								// 删除teachergrade中对应的记录
								Teachergrade.teachergrade.deleteByCoursePlanId(planId);
								// 将要删除的排课记录添加到courseplan_back表中
								String sql1 = "insert into courseplan_back SELECT * from  courseplan where ID=? ";// 将查询语句更新到courseplan_back
								Db.update(sql1, coursePlan.getPrimaryKeyValue());
								// 删除courseplan表中的数据
								String sql3 = "delete from  courseplan where ID=? ";
								Db.update(sql3, coursePlan.getPrimaryKeyValue());// 删除班课
								// 发送短信
								if (ToolDateTime.isToday(courseTime)) {
									MessageService.sendMessageToStudent(MesContantsFinal.xs_sms_today_qxpk, coursePlan.getPrimaryKeyValue().toString());
								}
								code = "1";
							} else {// 班课取消
								Integer state = student.getInt("state");
								Integer classOrderId = coursePlan.getInt("class_id"); // 班次ID
								if ("2".equals(state + "")) {// 删除的为虚拟用户，则删除整个班课下面的学生排课
									Integer timeId = coursePlan.getInt("timerank_id");
									String sql2 = "update courseplan set deluserid = ? ,del_msg = ? ,update_time=now() where class_id=? and course_time=? and timerank_id=? ";
									Db.update(sql2, operateId, delreason, banid, coursePlan.getTimestamp("course_time"), timeId);
									// 将要删除的排课记录添加到courseplan_back表中
									String sql1 = "insert into courseplan_back SELECT * from  courseplan where class_id=? and course_time=? and timerank_id=? ";
									Db.update(sql1, banid, coursePlan.getTimestamp("course_time"), timeId);
									// 删除courseplan表中的数据
									String sql3 = "delete from  courseplan where class_id=? and course_time=? and timerank_id=? ";
									Db.update(sql3, banid, coursePlan.getTimestamp("course_time"), timeId);
									// 删除班级下面所有学生的排课
									Teachergrade.teachergrade.deleteByCoursePlanId(planId);
									ClassOrder classOrder = ClassOrder.dao.findById(classOrderId);
									classOrder.set("endTime", null).update();// 更新班级开班结束时间
								} else {
									String delSql = "delete from teachergrade where teachergrade.studentid = ? and teachergrade.COURSEPLAN_ID = ? ";
									Db.update(delSql, studentId, planId);
								}
								/*
								 * else { // 更新排课记录的update_time String sql2 =
								 * "update courseplan set del_msg = ?, update_time=now() where ID=? "
								 * ; Db.update(sql2, delreason,
								 * coursePlan.getPrimaryKeyValue()); //
								 * 将要删除的排课记录添加到courseplan_back表中
								 * coursePlan.set("deluserid", operateId);
								 * coursePlan.update(); String sql1 =
								 * "insert into courseplan_back SELECT * from  courseplan where ID=? "
								 * ; Db.update(sql1,
								 * coursePlan.getPrimaryKeyValue()); //
								 * 删除courseplan表中的数据 String sql3 =
								 * "delete from  courseplan where ID=? ";
								 * Db.update(sql3,
								 * coursePlan.getPrimaryKeyValue()); }
								 */
								code = "1";
							}
						} else {
							msg = "您没有删除今日(包括)之前课程安排和排序权限";
						}
					}
				}
			}
		}
		json.put("code", code);
		json.put("msg", msg);
		return json;
	}

	public JSONObject deleteCoursePlans(String planid) {
		JSONObject json = new JSONObject();
		String sql1 = "insert into courseplan_back SELECT * from  courseplan where id= ? ";
		Db.update(sql1, planid);
		json.put("code", 1);
		return json;
	}

	public JSONObject doAddCoursePlans(String type, String timeId, String studentId, String courseTime, CoursePlan saveCoursePlan, String teacherId, String assistantids,
			String roomId, String campusId, String subjectid, String plantype, String netCourse, String remark, String courseId,  Integer classOrderId,
			String planType, String rankId, CoursePlan newCoursePlan, Integer sysuerid) {
		JSONObject json = new JSONObject();
		String code = "0";
		String msg = "保存成功！";
		try {
			// String type = getPara("type");
			Date nowdate = ToolDateTime.getDate();
			TimeRank timeRank = TimeRank.dao.findById(Integer.parseInt(timeId));
			double classhour = timeRank.getBigDecimal("class_hour").doubleValue();
			if (type.equals("1")) {
				// CoursePlan cp =
				// CoursePlan.coursePlan.getStuCoursePlan(studentId, timeId,
				// getPara("dayTime"));
				CoursePlan cp = CoursePlan.dao.getStuCoursePlan(studentId, timeId, courseTime);
				if (cp == null) {
					String[] times = timeRank.getStr("rank_name").split("-");
					List<StudentAskingLeave> studentaskingleaves = StudentAskingLeave.dao.queryByStudentid(studentId, courseTime + " " + times[0], courseTime + " " + times[1]);
					if(studentaskingleaves.size() == 0 ){
						Account account = Account.dao.findById(Integer.parseInt(studentId));
						json.put("havecourse", "0");
						double zks = CourseOrder.dao.getVIPzks(account.getPrimaryKeyValue());
						double ypks = CoursePlan.dao.getUseClasshour(studentId, null);// 全部已用课时
						double syks = ToolArith.sub(zks, ypks);// 剩余课时
						// CoursePlan saveCoursePlan = getModel(CoursePlan.class);
						// String courseTime = getPara("dayTime");
						DateFormat dd = new SimpleDateFormat("yyyy-MM-dd");
						saveCoursePlan.set("course_time", dd.parse(courseTime));
						saveCoursePlan.set("create_time", nowdate);
						saveCoursePlan.set("update_time", nowdate);
						saveCoursePlan.set("class_id", 0);
						saveCoursePlan.set("student_id", studentId);
						saveCoursePlan.set("teacher_id", teacherId.equals("") ? null : teacherId);
						saveCoursePlan.set("room_id", roomId);
						saveCoursePlan.set("timerank_id", timeId);
						saveCoursePlan.set("campus_id", campusId);
						saveCoursePlan.set("SUBJECT_ID", subjectid);
						saveCoursePlan.set("plan_type", plantype);
						// saveCoursePlan.set("plan_type", getPara("plantype"));
						// saveCoursePlan.set("netCourse", getPara("netCourse"));
						saveCoursePlan.set("netCourse", netCourse);
						saveCoursePlan.set("adduserid", sysuerid);

						//查看学生是否需要  确认 课表
						if(account.getInt("release").equals(0)){//  0不需要     1需要
							saveCoursePlan.set("confirm", 1);
						}
						
						if (remark == null || remark.equals("")) {
							saveCoursePlan.set("remark", "暂无");
						} else {
							saveCoursePlan.set("remark", ToolString.replaceBlank(remark));
						}
						if (plantype.equals("1")) {
							saveCoursePlan.set("course_id", "-" + courseId);
							code = "1";
							saveCoursePlan.save();
						} else {
							saveCoursePlan.set("course_id", courseId);
							if (syks > 0 && plantype.equals("0")) {
								if (timeRank.getBigDecimal("class_hour").doubleValue() > syks) {
									msg = account.getStr("real_name") + "剩余" + syks + "课时,该时段课时为" + timeRank.getBigDecimal("class_hour") + "课时";
								} else {
									saveCoursePlan.save();
									// 发送短信
									if (ToolDateTime.isToday(courseTime)) {
										MessageService.sendMessageToStudent(MesContantsFinal.xs_sms_today_tjpk, saveCoursePlan.getPrimaryKeyValue().toString());
									}
									code = "1";
									msg = "success";
								}
							} else {
								code = "0";
								msg = account.getStr("real_name") + "课时不足，请购买课时。";
							}
						}
					}else{
						code = "0";
						msg = "该学生请假";
					}
				} else {
					json.put("havecourse", "1");
				}
			} else {
				DateFormat dd = new SimpleDateFormat("yyyy-MM-dd");
				// Integer classOrderId = getParaToInt("banci_id");
				ClassOrder ban = ClassOrder.dao.findById(classOrderId);
				if (ban == null) {
					code = "0";
					msg = "班课不存在";
				} else {
					double lessonNum = ban.getInt("lessonNum");
					double ypks = CoursePlan.dao.getClassYpkcClasshour(classOrderId);
					if (classhour > ToolArith.sub(lessonNum, ypks) && planType == "0") {
						code = "0";
						msg = "该班课课时不足";
					} else {
						List<CoursePlan> cp = CoursePlan.dao.getClassCoursePlan(classOrderId, timeId, courseTime);
						if (cp.size() == 0) {
							json.put("havecourse", "0");
							// String sql =
							// "SELECT DISTINCT studentid from crm_courseorder WHERE classorderid=? ";//
							// 根据班次id取出所有具有此班次的学生id
							// List<Record> banUser = Db.find(sql,
							// classOrderId);
							Integer xnAccountId = ban.getInt("accountid");// 虚拟班课账户ID

							// CoursePlan saveCoursePlan =
							// getModel(CoursePlan.class);
							saveCoursePlan.set("course_time", dd.parse(courseTime));
							saveCoursePlan.set("create_time", nowdate);
							saveCoursePlan.set("update_time", nowdate);
							saveCoursePlan.set("class_id", classOrderId);
							saveCoursePlan.set("student_id", xnAccountId);
							saveCoursePlan.set("SUBJECT_ID", subjectid);
							saveCoursePlan.set("room_id", roomId);
							saveCoursePlan.set("timerank_id", rankId);
							saveCoursePlan.set("campus_id", campusId);
							saveCoursePlan.set("plan_type", plantype);
							saveCoursePlan.set("netCourse", netCourse);
							saveCoursePlan.set("adduserid", sysuerid);
							saveCoursePlan.set("confirm", 1);//班课不需要确认
							if (plantype.equals("1")) {// 模考
								saveCoursePlan.set("course_id", "-" + courseId);
							} else {
								saveCoursePlan.set("teacher_id", teacherId);
								saveCoursePlan.set("course_id", courseId);
							}
							if (remark == null || remark.equals("")) {
								saveCoursePlan.set("remark", "暂无");
							} else {
								saveCoursePlan.set("remark", ToolString.replaceBlank(remark));
							}
							saveCoursePlan.set("STATE", 0);
							saveCoursePlan.save();
							ClassOrder.dao.updateTeachTime(classOrderId);// 更新开班时间和结束时间
							code = "1";
							msg = "success";

						} else {// 在该日期下的该时间段内，该学生或小班已有排课
							json.put("havacourse", "1");
						}
					}
				}
			}
			//助教老师 和课程 中间表 保存
			CoursePlanAssistantService.me.save(saveCoursePlan.get("id"), assistantids);
		} catch (Exception e) {
			e.printStackTrace();
			code = "0";
			msg = "数据保存异常，请联系系统管理员！";
		}
		json.put("code", code);
		json.put("msg", msg);
		return json;
	}

	/**
	 * 交叉时间内所有课程
	 * 
	 * @param rankid
	 * @param coursetime
	 * @param stuid
	 * @param tchid
	 * @return
	 */
	public List<CoursePlan> getPlanListByRankIdArround(String rankid, String coursetime, String stuid, String tchid) {
		String sql = " SELECT distinct cp.id,cp.course_time,cp.STUDENT_ID,cp.TEACHER_ID,cp.COURSE_ID,cp.ROOM_ID,cp.TIMERANK_ID,cp.PLAN_TYPE,cp.CAMPUS_ID,cp.startrest,cp.endrest, "
				+ " stu.REAL_NAME stuname, tch.REAL_NAME tchname, tr.RANK_NAME,course.COURSE_NAME,campus.CAMPUS_NAME,room.name roomname,sub.subject_name from courseplan cp "
				+ " LEFT JOIN  account stu ON stu.Id = cp.STUDENT_ID LEFT JOIN account tch ON tch.Id=cp.TEACHER_ID "
				+ " LEFT JOIN course on course.Id=cp.COURSE_ID LEFT JOIN time_rank tr ON tr.Id=cp.TIMERANK_ID "
				+ " LEFT JOIN campus ON campus.Id=cp.CAMPUS_ID left join subject sub on sub.id=cp.subject_id "
				+ " LEFT JOIN classroom room on room.id=cp.room_id  WHERE (cp.STUDENT_ID= ? OR cp.TEACHER_ID = ? )" + " AND cp.COURSE_TIME = ?  ";
		List<CoursePlan> allplans = CoursePlan.dao.find(sql, stuid, tchid, coursetime);
		List<CoursePlan> planlist = new ArrayList<CoursePlan>(allplans.size());
		TimeRank rank = TimeRank.dao.findById(rankid);
		Integer rankstart = Integer.parseInt(rank.getStr("rank_name").split("-")[0].replace(":", ""));
		Integer rankend = Integer.parseInt(rank.getStr("rank_name").split("-")[1].replace(":", ""));
		if (allplans != null && allplans.size() > 0) {
			for (CoursePlan plan : allplans) {
				String plantype = plan.getInt("plan_type").toString();
				Integer startplan = null;
				Integer endplan = null;
				if (plantype.equals("2")) {
					startplan = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
					endplan = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
				} else {
					startplan = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
					endplan = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
				}
				if ((rankstart <= startplan && rankend > startplan) || (rankstart >= startplan && rankstart < endplan)) {
					planlist.add(plan);
				}
			}
		}
		return planlist;
	}

	/**
	 * 该校区当天教室占用情况
	 * 
	 * @param campusid
	 * @param coursetime
	 * @return
	 */
	public Map<String, Object> getCampusDayRoomMsgMap(String campusid, String coursetime, String rankId) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<TimeRank> tr = TimeRank.dao.getTimeRank();
		String[] timeNames = TimeRank.dao.findById(Integer.parseInt(rankId)).getStr("RANK_NAME").split("-");
		int beginTime = Integer.parseInt(timeNames[0].replace(":", ""));
		int endTime = Integer.parseInt(timeNames[1].replace(":", ""));
		List<Integer> rankIds = new ArrayList<Integer>();
		rankIds.add(Integer.parseInt(rankId));
		for (TimeRank rec : tr) {
			String rankName = rec.getStr("RANK_NAME");
			String rankTimes[] = rankName.split("-");
			int beginRankTime = Integer.parseInt(rankTimes[0].replace(":", ""));
			int endRankTime = Integer.parseInt(rankTimes[1].replace(":", ""));
			if ((beginTime >= beginRankTime && beginTime < endRankTime) || (endTime > beginRankTime && endTime <= endRankTime)
					|| (beginTime <= beginRankTime && endTime > endRankTime) || (beginTime >= beginRankTime && endTime <= endRankTime)) {
				rankIds.add(rec.getInt("Id"));
			}
		}
		String rids = rankIds.toString().replace("[", "(").replace("]", ")");
		List<Classroom> roomlists = Classroom.dao.getClassRoombyCampusid(campusid);
		String dayroomids = CoursePlan.dao.getCampusDayRoomids(campusid, coursetime, rids);
		dayroomids = "," + dayroomids + ",";
		for (Classroom room : roomlists) {
			if (StrKit.isBlank(dayroomids))
				room.put("code", "0");
			else {
				String roompkids = "," + room.getPrimaryKeyValue() + ",";
				if (dayroomids.indexOf(roompkids) != -1)
					room.put("code", "1");
				else
					room.put("code", "0");
			}
		}
		map.put("roomlists", roomlists);
		List<CoursePlan> roomplans = CoursePlan.dao.getCampusDayRoomPlans(campusid, coursetime);
		map.put("roomplans", roomplans);
		return map;
	}

	/**
	 * 多选删除课程
	 * 
	 * @param cpid
	 */
	public boolean isDeleteMultipleChoice(String cpids, Integer userid) {
		boolean flag = false;
		try {
			String[] ids = cpids.split(",");
			for (String id : ids) {
				CoursePlan cp = CoursePlan.dao.findById(id);
				cp.set("deluserid", userid).set("update_time", new Date()).update();
				String sql = "insert into courseplan_back SELECT * from  courseplan where id= ? ";
				Db.update(sql, id);
				cp.delete();
			}
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	/**
	 * 按日历格式展示课程安排情况查询
	 * 
	 * @author David
	 * @param queryParams
	 *            页面查询条件封装到Map对象中
	 * @param res 
	 * @return 返回Calendar插件需要的json格式
	 */
	public String queryCoursePlanForCalendar(Map<String, String> queryParams, Res res) {
		
		List<CoursePlan> coursePlans = CoursePlan.dao.getAllCoursePlan(queryParams);
		if (coursePlans == null || coursePlans.size() == 0) {
			return "";
		} else {
			//小班 提取,避免 循环中 取班级
			Map<Integer, String> studentNameInClassMap 	= Teachergrade.teachergrade.getStudentNames(queryParams);
			
			// 公共 变量 提取 ----------------
			JSONArray 	jsons 			= new JSONArray(coursePlans.size());
			JSONObject 	json 			= null;
			String 		title 			= null;
			Integer 	signin 			= null;
			String 		teacherPinglun 	= null;
			String 		newDateTime 	= ToolDateTime.getCurDateTime();
			
			// 国际化 部分 提取 ,避免在 循环中 取值  --------------
			String one_on_one_tutoring 	= res.get( "one-on-one_tutoring" );
			String subject 				= res.get( "subject" );
			String re_enter 			= res.get( "re-enter" );
			String canceled 			= res.get( "canceled" );
			String location 			= res.get( "location" );
			String date 				= res.get( "date" );
			String time 				= res.get( "time" );
			String tutor 				= res.get( "tutor" );
			String student 				= res.get( "STUDENT" );
			String assistant 			= res.get( "assistant" );
			
			// -----------------------------------------
			
			StringBuilder kcsj = new StringBuilder();
			
			
			// 遍历组装 -----------------
			for (CoursePlan cp : coursePlans) {
				
				int classId = cp.getInt("class_id");
				String students = "";
				Integer coursePlanId = cp.getInt("id");
				if (classId != 0) {
					students = studentNameInClassMap.get(coursePlanId);
					if (ToolString.isNull(students))
						students = "没有学生或没有设置学生班课课表";
				}
				
				kcsj.setLength(0);
				kcsj.append(cp.getStr("kcrq") )
				.append(" ")
				.append(cp.getStr("RANK_NAME").substring(0, cp.getStr("RANK_NAME").indexOf("-"))  )
				.append(":00");
				
				long ss = ToolDateTime.compareDateStr(kcsj.toString(), newDateTime);
				
				// 标题 的国际化 处理 (目前没有想到 好的 处理方式 先 放 这里) ---------------------------------------
				title = "无";
				if(StrKit.notBlank( cp.getStr("title") ))
					title = cp.getStr("title")
											.replace("授课:一对一", 	one_on_one_tutoring )
											.replace("课程", 		subject )
											.replace("补排", 		re_enter )
											.replace("已取消课", 		canceled )
											.replace("场地", 		location )
											.replace("日期", 		date )
											.replace("时段", 		time )
											.replace("老师", 		tutor )
											.replace("学生", 		student )
											.replace("助教", 		assistant );
				
				//  -----------------------------------------------------------------
				signin 			= null;
				teacherPinglun 	= null;
				if ("true".equals(queryParams.get("isStudent"))) {
					signin 		  	= (ss > 0) ?  1	:  0 ;
					teacherPinglun 	= (ss > 0) ? "y" : "n";
				} else {
					signin 			= cp.getInt("signin");
					teacherPinglun 	= cp.getStr("teacherPinglun");
				}
				
				
				//组装 json  ----------------------------------------------
				json = new JSONObject();
				jsons.add(json);
				
				json.put("title", 			title);
				json.put("start", 			cp.get("start_course_time"));
				json.put("classId", 		classId);
				json.put("student",			students);
				json.put("msg", 			cp.getStr("remark") );
				json.put("courseplanId", 	coursePlanId);
				json.put("name", 			cp.getStr("classroomname"));
				json.put("TIMERANK_ID", 	cp.getInt("TIMERANK_ID"));
				json.put("datetime", 		cp.get("start_course_time"));
				json.put("campus_name", 	cp.getStr("campus_name"));
				json.put("campustype", 		cp.getInt("campustype"));
				json.put("netCourse", 		cp.getInt("netCourse"));
				json.put("plantype", 		cp.getInt("plantype"));
				json.put("signin", 			signin);
				json.put("teacherPinglun", 	teacherPinglun);
				
				
			}
			
			return jsons.toJSONString();
		
		}
	}

	/**
	 * 查询学生课表
	 * 
	 * @param splitPage
	 */
	public void queryStudentPlan(SplitPage splitPage) {

		Map<String, String> queryParam = splitPage.getQueryParam();
		String stuid = queryParam.get("stuid");
		String studentName = queryParam.get("studentName");
		String tid = queryParam.get("teacherId");
		String subjectId = queryParam.get("subjectId");
		String courseid = queryParam.get("courseid");
		String startTime = ToolString.isNull(queryParam.get("startTime")) ? ToolDateTime.getMonthFirstDayYMD(new Date()) : queryParam.get("startTime");
		String endTime = ToolString.isNull(queryParam.get("endTime")) ? ToolDateTime.getMonthLastDayYMD(ToolDateTime.getDate(startTime + " 00:00:00"))
				: queryParam.get("endTime");
		StringBuffer banWhereSql = new StringBuffer("");
		StringBuffer whereSql = new StringBuffer("");
		if (null != stuid && !stuid.equals("")) {
			whereSql.append("  and s.ID = ").append(stuid);
			queryParam.put("STUNAME", getStuName(Integer.parseInt(stuid)));
		}
		if (null != tid && !tid.equals(""))
			whereSql.append(" and cp.TEACHER_ID = ").append(tid);
		if (null != startTime && !startTime.equals("")) {
			whereSql.append(" and cp.course_time >= '").append(startTime).append("'");
			banWhereSql.append(" and p.course_time >= '").append(startTime).append("'");
			queryParam.put("startTime", startTime);
		}
		if (null != endTime && !endTime.equals("")) {
			whereSql.append(" and cp.course_time <= '").append(endTime).append("'");
			banWhereSql.append(" and p.course_time <= '").append(endTime).append("'");
			queryParam.put("endTime", endTime);
		}
		if (null != courseid && !courseid.equals(""))
			whereSql.append(" and cp.COURSE_ID = ").append(courseid);
		if (null != subjectId && !subjectId.equals(""))
			whereSql.append(" and cp.subject_id = ").append(courseid);
		if (!ToolString.isNull(studentName))
			whereSql.append(" and s.REAL_NAME='").append(studentName).append("'");
		String selectSql = "SELECT *";
		String fromSql = "FROM ( "
				+ "(SELECT s.REAL_NAME SNAME, cp.COURSE_TIME,cp.ranktime,cp.COURSE_NAME,cp.teachername,cp.class_hour,cp.CAMPUS_NAME, cp.class_id,s.id sid,cp.TEACHER_PINGLUN "
				+ "FROM teachergrade tg  "
				+ "LEFT JOIN account s ON tg.studentid=s.Id "
				+ "LEFT JOIN (SELECT p.Id,p.TEACHER_PINGLUN,p.class_id,p.CAMPUS_ID,c.CAMPUS_NAME,p.COURSE_TIME,t.class_hour,t.RANK_NAME ranktime,tc.REAL_NAME teachername,k.COURSE_NAME,p.TEACHER_ID,p.SUBJECT_ID,p.COURSE_ID "
				+ "FROM courseplan p LEFT JOIN time_rank t ON p.TIMERANK_ID=t.Id LEFT JOIN campus c ON p.CAMPUS_ID=c.Id LEFT JOIN account tc ON p.TEACHER_ID=tc.Id "
				+ "LEFT JOIN course k ON p.COURSE_ID=k.Id WHERE p.PLAN_TYPE=0 "
				+ banWhereSql.toString()
				+ ") cp ON tg.COURSEPLAN_ID=cp.Id "
				+ "WHERE cp.class_id!=0 AND s.STATE!=2 "
				+ whereSql.toString()
				+ " UNION ALL "
				+ "(SELECT s.REAL_NAME SNAME, cp.COURSE_TIME,tr.RANK_NAME ranktime,k.COURSE_NAME,tc.real_name teachername,tr.class_hour,c.CAMPUS_NAME, cp.class_id,s.id sid,cp.TEACHER_PINGLUN "
				+ "FROM courseplan cp   " + "LEFT JOIN account s ON cp.STUDENT_ID = s.Id " + "LEFT JOIN account tc ON cp.TEACHER_ID=tc.Id "
				+ "LEFT JOIN time_rank tr ON cp.TIMERANK_ID = tr.Id   " + "LEFT JOIN campus c ON cp.CAMPUS_ID = c.Id "
				+ "LEFT JOIN course k ON cp.COURSE_ID=k.Id " + "WHERE cp.plan_type=0 and cp.STATE = 0 AND cp.class_id = 0 " + whereSql.toString() + " ))) a ";
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), selectSql, fromSql + "ORDER BY a.course_time, a.ranktime");
		splitPage.setPage(page);
	}

	/**
	 * 删除学员在小班中课程
	 * 
	 * @param parseInt
	 * @param sysuserId
	 * @param inXbDelReason
	 * @param inXbenforce
	 * @param delHistoryInXbCoursePlan
	 * @return
	 */
	public JSONObject deleteInXbCoursePlan(Integer courseplanid, Integer sysuserId, String inXbDelReason) {
		JSONObject json = new JSONObject();
		String code = "";
		String msg = "";
		Integer planId = courseplanid;
		if (courseplanid != null) {
			CoursePlan CPID = CoursePlan.dao.findById(courseplanid);
			if (CPID != null) {// 当前记录存在
				//if (CPID.getStr("singn") == null) { 当前课程尚未签到
				/*} else {
					code = "0";
					msg = "课程已经签到无法删除";
				}*/
				String delCPSql = "DELETE FROM courseplan WHERE courseplan.Id = ? ";// 删除小班中某学生对应的课程
				String delTESql = " DELETE FROM teachergrade WHERE COURSEPLAN_ID = ? ";
				Db.update(delCPSql, CPID.getPrimaryKeyValue());
				Db.update(delTESql, CPID.getPrimaryKeyValue());
				code = "1";// 删除成功
				msg = "删除成功";
			} else {
				code = "0";
				msg = "您删除的课程不存在";
			}
		} else {
			code = "1";
			msg = "请选择要删除的课程";
		}
		json.put("planId", planId);
		json.put("code", code);
		json.put("msg", msg);
		return json;
	}
	
	/**修改更新学生确认课程状态 */
	public int updateConfirmPlan(){
		String confirm = Dict.dao.queryValGetDictname("confirm");
		int interval = StrKit.isBlank(confirm) ? 2 : Integer.parseInt(confirm);//字典:学生未确认课程自动确认间隔天数,默认值2天
		return Db.update("UPDATE courseplan SET confirm = 1 , recordTime = now() WHERE confirm = 0 AND datediff(now(), CREATE_TIME) > ? ", interval);
	}
	/**
	 * 获取记录列表 
	 * @param splitPage
	 */
	public void getAllCoursePlanList(SplitPage splitPage) {
		List<Object> paramValue = new  ArrayList<Object> () ;
		String select = "SELECT cp.Id,cp.PLAN_TYPE,cp.startrest,cp.endrest,cp.class_id,teacher.id AS teacherId,\n" +
						" tr.class_hour AS CLASSHOUR,  teacher.REAL_NAME AS TEACHERNAME,room.NAME AS roomName,class_order.classNum,\n" +
						" campus.CAMPUS_NAME,student.REAL_NAME AS STUNAME,student.id AS studentId,course.COURSE_NAME AS courseName,course.id AS courseId,\n" +
						" course.COURSE_NAME AS COURSENAME,cp.course_time COURSE_TIME,tr.Id AS timeid,tr.RANK_NAME AS RANKTIME,cp.calltheroll,cp.REMARK";
		StringBuilder formSql = new StringBuilder("") ;//cp.STATE = 0  AND student.STATE = 2代表为班级记录 并不是班级学生记录
			formSql.append("FROM courseplan cp\n" +
					"LEFT JOIN account student ON cp.STUDENT_ID = student.Id LEFT JOIN account teacher ON cp.TEACHER_ID = teacher.Id\n" +
					"LEFT JOIN classroom room ON cp.ROOM_ID = room.Id LEFT JOIN class_order ON cp.class_id = class_order.id\n" +
					"LEFT JOIN campus ON cp.CAMPUS_ID = campus.Id LEFT JOIN time_rank tr ON cp.TIMERANK_ID = tr.Id LEFT JOIN course ON cp.COURSE_ID = course.Id\n" +
					"WHERE (cp.class_id = 0 OR (cp.STATE = 0  AND student.STATE = 2))");
		Map<String,String> queryParam  = splitPage.getQueryParam();
		String beginTime = queryParam.get("startTime") ;
		String endTime = queryParam.get("endTime") ;
		String campusId = queryParam.get("campusId") ;
		String studentId = queryParam.get("studentId") ;
		String teacherId = queryParam.get("teacherId") ;
		String classOrderId = queryParam.get("classOrderId") ;
		String planType = queryParam.get("typePlan") ;
		String sysUserType = queryParam.get("sysUserType") ;
		String sysUserId = queryParam.get("sysUserId") ;
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		if(beginTime!=null&&beginTime!=""){
			formSql.append( "AND cp.course_time>=?") ;
			paramValue.add(beginTime) ;
		}
		if(endTime!=null&&endTime!=""){
			formSql.append(" AND cp.course_time<=?") ;
			paramValue.add(endTime) ;
		}
		if(campusId!=null&&campusId!=""){
			formSql.append(" AND cp.campus_id=? ");
			paramValue.add(campusId) ;
		}
		if(studentId!=null&&studentId!=""){
			formSql.append(" AND cp.student_id=?");
			paramValue.add(studentId);
		}
		if(teacherId!=null&&teacherId!=""){
			formSql.append(" AND cp.teacher_id=?");
			paramValue.add(teacherId);
		}
		if(classOrderId!=null&&classOrderId!=""){
			formSql.append(" AND cp.class_id=?");
			paramValue.add(classOrderId) ;
		}
	
		if(sysUserType.equals("4")){//课程顾问 查看课程和教师休息
			formSql.append(" and (FIND_IN_SET(cp.student_Id,(SELECT GROUP_CONCAT(sk.student_id) FROM student_kcgw sk WHERE sk.kcgw_id="+sysUserId+")) OR cp.PLAN_TYPE=2)");
		}else{
					if(planType!=null&&planType!=""&&!planType.equals("all")){
								if(planType.equals("1")){
									planType="0" ;
								}else if(planType.equals("2")){
									planType="1" ;
								}else if(planType.equals("3")){
									planType="2" ;
								}
						formSql.append(" AND cp.PLAN_TYPE=?");
						paramValue.add(planType) ;
					}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSql.append(" and campus.id in (" + loginRoleCampusIds + ")" );
		}
		formSql.append(" ORDER BY cp.COURSE_TIME DESC") ;
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		splitPage.setPage(page);
	}
	/**
	 * 获取教师列表
	 * @return TeacherList
	 */
	@Deprecated
	public List<Teacher> getTeacherList() {
	 	String sql = "select * from account where user_type=1 and state=0  group by REAL_NAME ";
	 	return Teacher.dao.find(sql) ;
	}

	/**
	 * 批量更新教师
	 * 
	 * @param ids
	 *            需要更新记录ID
	 * @param teacherid
	 *            选择的教师ID
	 * @param courseTime
	 *            课程时间
	 * @return JSONObject 0表示成功 1表示删除
	 */
	public JSONObject batchUpdateTeacher(String ids, String teacherid) {
		JSONObject json = new JSONObject();
		boolean flag = true ;
		List<CoursePlan> modelList = new ArrayList<CoursePlan>();
		if (StrKit.isBlank(ids)) {
			json.put("code", 1);
			json.put("result", "请选择需要更改的记录");
		} else if (StrKit.isBlank(teacherid)) {
			json.put("code", 1);
			json.put("result", "请正确填写 修改后的教师信息");
		} else {
			List<CoursePlan> coursePlanList = CoursePlan.dao.findListByIds(ids);// 获取修改记录列表
			for (CoursePlan courseplan : coursePlanList) { 
				TimeRank tr = TimeRank.dao.findById(courseplan.getInt("TIMERANK_ID"));
				if(!isTimeConflict(tr.getStr("rank_name"), courseplan.getTimestamp("COURSE_TIME"), Integer.parseInt(teacherid), courseplan.getPrimaryKeyValue())){
					json.put("code", 1);
					json.put("time", courseplan.getTimestamp("COURSE_TIME"));
					json.put("teacher", Teacher.dao.findById(teacherid).getStr("real_name"));
					json.put("hour", TimeRank.dao.findById(courseplan.getInt("TIMERANK_ID")).getStr("RANK_NAME"));
					flag = false ;
					break;
				}else{
					CoursePlan model = new CoursePlan();
					model.set("id", courseplan.getPrimaryKeyValue());
					model.set("TEACHER_ID", teacherid);
					
					//课时费 的处理 
					//0:为一对一;否则为小班
					Coursecost coursecost = CoursecostService.me.queryByTeacheridAndCourseidDefault(teacherid, courseplan.get("COURSE_ID"));
					Float cost = (new Integer(0).equals(courseplan.getInt("class_id"))) ? coursecost.getFloat("yicost") : coursecost.getFloat("xiaobancost");
					
					model.set("coursecost", cost);
					
					modelList.add(model);
					continue;
				}
			}
			
			if(flag){
				String columns = "TEACHER_ID,id";
				String batchSql = "UPDATE courseplan SET TEACHER_ID = ? ,UPDATE_TIME=now() WHERE id=?   ";
				int batchSize = 500;
				try {
					Db.batch(batchSql, columns, modelList, batchSize);
					json.put("code", 0);
					json.put("result", "更新成功");
				} catch (Exception e) {
					json.put("code", 1);
					json.put("result", "服务器异常");
				}
			}
		}
		return json;
	}

	/**
	 * 批量删除
	 * 
	 * @param ids
	 *            批量删除的ids
	 * @param reason
	 *            删除的理由
	 * @return json
	 */
	public JSONObject batchDelete(String ids, String reason) {
		JSONObject json = new JSONObject();
		if (ids == null || ids.length() < 0) {
			json.put("code", 1);
			json.put("result", "请选择操作记录");
		} else if (reason == null || reason.length() < 0) {
			json.put("code", 1);
			json.put("result", "请填写删除理由");
		} else {
			List<CoursePlan> coursePlanList = CoursePlan.dao.findListByIds(ids);
			List<CoursePlan> modelList = new ArrayList<CoursePlan>();
			for (CoursePlan coursePlan : coursePlanList) {
				CoursePlan cp = new CoursePlan();
				cp.set("del_msg", reason);
				cp.set("id", coursePlan.getPrimaryKeyValue());
				modelList.add(cp);
			}
			String keyId = "id";
			String updateColumn = "del_msg,id";
			
			String classSql = "DELETE FROM courseplan WHERE id =?";
			String updateSql = "UPDATE  courseplan SET del_msg = ?,UPDATE_TIME=now()  WHERE id =?";
			String insertSql = "INSERT INTO courseplan_back SELECT * FROM courseplan WHERE FIND_IN_SET(id,?) ";
			String xbSql = "DELETE FROM teachergrade where COURSEPLAN_ID = ?";
			String accountBook = "DELETE FROM account_book WHERE courseplanid=?";
			
			Db.batch(updateSql, updateColumn, modelList, 500);
			Db.update(insertSql, ids);
			Db.batch(classSql, keyId, modelList, 500);
			Db.batch(xbSql, keyId, modelList, 500);
			Db.batch(accountBook, keyId, modelList, 500);
			
			json.put("code", 0);
			json.put("result", "删除成功");
		}
		return json;
	}

	/**
	 * 批量修改备注
	 * 
	 * @param ids
	 *            记录id
	 * @param remarkinfo
	 *            备注信息
	 * @return
	 */
	public JSONObject batchUpdateRemark(String ids, String remarkinfo) {
		JSONObject json = new JSONObject();
		if (ids == null || ids.length() < 0) {
			json.put("code", 1);
			json.put("result", "所选记录不存在");
		} else if (remarkinfo == null || remarkinfo.length() < 0) {
			json.put("code", 1);
			json.put("result", "请填写备注信息");
		} else {
			List<CoursePlan> modelList = new ArrayList<CoursePlan>();
			List<CoursePlan> coursePlanList = CoursePlan.dao.findListByIds(ids);
			for (CoursePlan courseplan : coursePlanList) {
				CoursePlan model = new CoursePlan();
				model.set("REMARK", remarkinfo);
				model.set("ID", courseplan.getPrimaryKeyValue());
				modelList.add(model);
			}
			String upSql = "UPDATE courseplan SET REMARK=? ,UPDATE_TIME=now() WHERE id =?";
			String columns = "REMARK,ID";
			int batchSize = 500;
			try {
				Db.batch(upSql, columns, modelList, batchSize);
				json.put("code", 0);
				json.put("result", "更新成功");
			} catch (Exception e) {
				e.printStackTrace();
				json.put("code", 1);
				json.put("result", "服务器异常");
			}
		}
		return json;
	}

	/**
	 * 批量更新课程
	 * 
	 * @param ids
	 *            记录ids
	 * @param courseid
	 *            课程id(将修改成的课程)
	 * @param subjectid
	 *            科目id
	 * @return json
	 */
	public JSONObject batchUpdateCourse(String ids, String courseid, String subjectid) {
		JSONObject json = new JSONObject();
		List<CoursePlan> modelList = new ArrayList<CoursePlan>();
		boolean flag = true;
		if (ids == null || courseid.length() < 0) {
			json.put("code", 1);
			json.put("result", "所选记录不存在");
		} else if (subjectid == null || subjectid.length() < 0) {
			json.put("code", 1);
			json.put("result", "请选择科目");
		} else if (courseid == null || courseid.length() < 0) {
			json.put("code", 1);
			json.put("result", "请选择课程");
		} else {
			List<CoursePlan> coursePlanList  = CoursePlan.dao.findListByIds(ids);
			for (CoursePlan coursePlan : coursePlanList) {
				if (coursePlan.getInt("COURSE_ID") != Integer.parseInt(courseid)) {// 相同课程
					if (!(Teacher.dao.findTeacherByTidAndCid(coursePlan.getInt("TEACHER_ID").toString(), subjectid))) {
						json.put("code", 1);
						json.put("result", "您选择的课程中有冲突，信息为：");
						json.put("teacher",Teacher.dao.findById(coursePlan.getInt("TEACHER_ID")).getStr("real_name"));//冲突教师
						json.put("course",Course.dao.findById(courseid).getStr("COURSE_NAME"));
						flag = false;
						break;
					}else{
						CoursePlan model = new CoursePlan();
						model.set("COURSE_ID", courseid);
						model.set("id", coursePlan.getPrimaryKeyValue());
						modelList.add(model);
					}
				}
			}
			if (flag) {
				int batchSize = 500;
				String columns = "COURSE_ID,id";
				String sql = "UPDATE courseplan SET COURSE_ID=?,UPDATE_TIME=now() WHERE id=?";
				try {
					Db.batch(sql, columns, modelList, batchSize);
					json.put("code", 0);
					json.put("result", "更新成功");
				} catch (Exception e) {
					json.put("code", 1);
					json.put("result", "服务器异常");
				}
			}
		}
		return json;
	}
	/**
	 * 批量更新教师排休
	 * @param ids 批量id
	 * @param time 时段
	 * @return json 
	 */
	public JSONObject batchUpdateTeacherRest(String ids, String ranktime) { 
		boolean flag =true ;
		JSONObject json = new JSONObject() ;
		List<CoursePlan> modelList = new ArrayList<CoursePlan>();
		if(ids==null||ids.length()<0){
			json.put("code", 1);
			json.put("result", "所选记录为空");
		}else if(ranktime==null||ranktime.length()<0){
			json.put("code", 1);
			json.put("result", "请选择挑选的时段");
		}else{
			List<CoursePlan> coursePlanList = CoursePlan.dao.findListByIds(ids);
			for(CoursePlan coursePlan : coursePlanList){
				if(!isTimeConflict(ranktime,coursePlan.getTimestamp("COURSE_TIME"),coursePlan.getInt("TEACHER_ID"),coursePlan.getPrimaryKeyValue())){
						json.put("code", 1);
						json.put("time", coursePlan.getTimestamp("COURSE_TIME"));
						json.put("teacher", Teacher.dao.findById(coursePlan.getInt("TEACHER_ID")));
						flag = false ;
						break;
				}else{
					CoursePlan model = new CoursePlan();
					model.set("id", coursePlan.getPrimaryKeyValue());
					model.set("startrest",ranktime.split("-")[0].trim() );
					model.set("endrest",ranktime.split("-")[1].trim() );
					modelList.add(model);
					continue;
				}
			}
			if(flag){
				int batchSize = 500;
				String columns = "startrest,endrest,id";
				String sql = "UPDATE courseplan SET startrest=?,endrest=? ,UPDATE_TIME=now() WHERE id=?";
				try {
					Db.batch(sql, columns, modelList, batchSize);
					json.put("code", 0);
					json.put("result", "更新成功");
				} catch (Exception e) {
					json.put("code", 1);
					json.put("result", "服务器异常");
				}
			}
		}
		return json;
	}
	 /**
	  * 根据给定时段，日期，教师id,记录id查询该日期该教师的该时段是否被占用（排除自身记录）
	  * @param ranktime 给定的时段
	  * @param time         给定的日期
	  * @return true 无冲突 false 有冲突
	  */
	private boolean isTimeConflict(String ranktime,Timestamp time,Integer teacherid ,Integer cpid) {
		int startTime = Integer.parseInt((ranktime.split("-")[0]).replace(":", "").trim());
		int endTime   = Integer.parseInt((ranktime.split("-")[1]).replace(":", "").trim());
		List<CoursePlan>  conflictList = null;//冲突记录列表
		String restSql = "SELECT * FROM courseplan WHERE COURSE_TIME=? AND TEACHER_ID=? AND PLAN_TYPE =2 AND id<> ?\n" +
									  "AND ((REPLACE(endrest,':','')>=? AND REPLACE(startrest,':','')< ?) OR (REPLACE(endrest,':','')<=?  AND REPLACE(endrest,':','')>? ))" ;
		conflictList = CoursePlan.dao.find(restSql, time.toString(),teacherid,cpid,endTime,endTime,endTime,startTime); //查询休息是否冲突
		if(conflictList.size()==0) {
			String courseSql ="SELECT * FROM courseplan cp LEFT JOIN time_rank tr  ON cp.TIMERANK_ID = tr.id WHERE COURSE_TIME =? AND TEACHER_ID=? AND PLAN_TYPE <>2 AND cp.id<>?\n" +
										  "AND ((REPLACE(SUBSTR(tr.RANK_NAME, 7, 5),':','')>=? AND REPLACE(SUBSTR(tr.RANK_NAME, 1, 5),':','')< ?) OR (REPLACE(SUBSTR(tr.RANK_NAME, 7, 5),':','')<=?  AND REPLACE(SUBSTR(tr.RANK_NAME, 7, 5),':','')>?))" ;
			conflictList= CoursePlan.dao.find(courseSql,time,teacherid,cpid,endTime,endTime,endTime,startTime); //查询课程是否冲突
			if(conflictList.size()==0) return true ;//不冲突
			else return  false;//排课冲突
		}else 
			return  false;//排休冲突
	}
	/**
	 * 该校区当天教室占用情况
	 * @param campusid
	 * @param coursetime
	 * @return
	 */
	public Map<String, Object> getCampusDayRoomMsgMap(String campusid, String coursetime,String rankId,String coursePlanId) {
		Integer classRoomId = null;
		if(coursePlanId!=null){
			CoursePlan coursePlan = CoursePlan.dao.findById(Integer.parseInt(coursePlanId));
			classRoomId = coursePlan.getInt("room_id");
		}
		Map<String,Object> map = new HashMap<String,Object>();
		List<TimeRank> timeRankList = TimeRank.dao.getTimeRank();//获取所有时段
		String[] timeNames = TimeRank.dao.findById(Integer.parseInt(rankId)).getStr("RANK_NAME").split("-");//当前选中的时段
		int beginTime = Integer.parseInt(timeNames[0].replace(":", ""));//原有课程开始时间
		int endTime = Integer.parseInt(timeNames[1].replace(":", ""));//原有课程结束时间
		List<Integer> rankIds = new ArrayList<Integer>();
		rankIds.add(Integer.parseInt(rankId));//获取原有课程的时段id
		for (TimeRank rec : timeRankList) { //判断时段是否交叉
			String rankName = rec.getStr("RANK_NAME");//获取记录时段
			String rankTimes[] = rankName.split("-");
			int beginRankTime = Integer.parseInt(rankTimes[0].replace(":", ""));
			int endRankTime = Integer.parseInt(rankTimes[1].replace(":", ""));
			if ((beginTime >= beginRankTime && beginTime < endRankTime) || (endTime > beginRankTime && endTime <= endRankTime)
					|| (beginTime <= beginRankTime && endTime > endRankTime) || (beginTime >= beginRankTime && endTime <= endRankTime)) {
				rankIds.add(rec.getInt("Id"));//如果有交叉放入list
			}
		}
		String rids = rankIds.toString().replace("[", "(").replace("]", ")");//获取ID列表
		List<Classroom> roomlists = Classroom.dao.getClassRoombyCampusid(campusid);
		String dayroomids = CoursePlan.dao.getCampusDayRoomids(campusid,coursetime,rids);//获取当前有课程的教室ids
		dayroomids = ","+dayroomids+",";
		for(Classroom room:roomlists){
			if(StrKit.isBlank(dayroomids)){
				room.put("code","0");//可用
			}else{
				String roompkids = ","+room.getPrimaryKeyValue()+",";
				if(dayroomids.indexOf(roompkids)!=-1){
					if(room.getInt("ID").equals(classRoomId)){
						room.put("code", "0");
					}else{
						room.put("code", "1");
					}
				}else{
					room.put("code", "0");
				}
			}
		}
		map.put("roomlists", roomlists);
		List<CoursePlan> roomplans = CoursePlan.dao.getCampusDayRoomPlans(campusid, coursetime);
		map.put("roomplans", roomplans);
		return map;
	}

	/**
	 * 获取课程记录
	 * 
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List getCourseList(String id) {
		CoursePlan coursePlan = null;
		List<BanciCourse> banCourseList = new ArrayList<BanciCourse>();
		List<Course> userCourseList = new ArrayList<Course>();
		coursePlan = CoursePlan.dao.findById(id);// 获取课程记录
		Student student = Student.dao.findById(coursePlan.getInt("STUDENT_ID"));// 获取学生
		if (student.isClassOrder()) {// 查询班课列表
			ClassOrder xb = ClassOrder.dao.findByXuniId(student.getPrimaryKeyValue()); // 获取小班
			String sql = "select bc.course_id id,type_id typeid ,banci_id banciid ,c.course_name from banci_course bc left join course c on c.id=bc.course_id where banci_id= ? ";
			banCourseList = BanciCourse.dao.find(sql, xb.getPrimaryKeyValue());
		} else {// 查询一对一课程列表
			userCourseList = Course.dao.queryByStudentCourse1v1(student.get("id"));// 学生课程
		}

		return banCourseList.size() != 0 ? banCourseList : userCourseList;
	}

	/**
	 * 获取可用时段
	 * 
	 * @param rankid 时段ID
	 * @param datetime 日期 
	 * @param teacherid 教师ID
	 * @param cpid 记录ID
	 * @return
	 */
	public List<TimeRank> getEnableRankList(String coursetime, String tchid, String stuid, String cpid) {
		List<TimeRank> ranklist = TimeRank.dao.getAddPlanTimeRank();
		Account student = Account.dao.findById(stuid);
		List<Account> studentList = new ArrayList<Account>();
		if (student.getInt("state") == 2) {// 班课
			studentList = Account.dao.findClassStudent(cpid);
			for (Account stu : studentList) {// 遍历该班级上课学生，查询每一位学生在该日期中的课程（班课和一对一）和该日期中老师的排休（结果中去除当前修改的班课）
				String keSql = "SELECT cp.id,cp.timerank_id,tr.rank_name,cp.startrest,cp.endrest,cp.plan_type FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.timerank_id WHERE\n"
						+ "	(cp.teacher_id = ? OR cp.student_id = ?) AND cp.course_time = ? AND cp.Id<>?";
				List<CoursePlan> hasConflictList = CoursePlan.dao.find(keSql, tchid, stu.getInt("ID").toString(), coursetime, cpid);// 学生某天的课程和教师的排休
				if (hasConflictList.size() == 0) continue;
				else
					for (CoursePlan plan : hasConflictList) {// 遍历该课表
						String plantype = plan.getInt("plan_type").toString();
						Integer starttime = null;
						Integer endtime = null;
						if (plantype.equals("2")) {// 老师休息
							starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
							endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
						} else {// 课程和模考
							starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
							endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
						}
						for (TimeRank time : ranklist) {
							Integer rankstart = Integer.parseInt(time.getStr("rank_name").split("-")[0].replace(":", ""));// 开始
							Integer rankend = Integer.parseInt(time.getStr("rank_name").split("-")[1].replace(":", ""));// 结束
							if ((rankstart <= starttime && rankend > starttime) || (starttime <= rankstart && endtime > rankstart)) {
								// 0正常；1占用；2有课
								if (!time.get("code").toString().equals("2")) 
									time.put("code", "1");
								if (rankstart.equals(starttime) && rankend.equals(endtime))
									time.put("code", "2");
							}
						}
					}
			}
		} else {
			List<CoursePlan> planlist = CoursePlan.dao.getEnableRankList(stuid, tchid, coursetime, Integer.parseInt(cpid));// 某天老师和学生的排课；包括老师休息
			if (planlist != null && planlist.size() > 0) {
				for (CoursePlan plan : planlist) {
					String plantype = plan.getInt("plan_type").toString();
					Integer starttime = null;
					Integer endtime = null;
					if (plantype.equals("2")) {// 老师休息
						starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
						endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
					} else {// 课程和模考
						starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
						endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
					}
					for (TimeRank time : ranklist) {
						Integer rankstart = Integer.parseInt(time.getStr("rank_name").split("-")[0].replace(":", ""));
						Integer rankend = Integer.parseInt(time.getStr("rank_name").split("-")[1].replace(":", ""));
						if ((rankstart <= starttime && rankend > starttime) || (starttime <= rankstart && endtime > rankstart)) {
							// 0正常；1占用；2有课
							if (!time.get("code").toString().equals("2"))
								time.put("code", "1");
						}
						if (rankstart.equals(starttime) && rankend.equals(endtime)) {
							time.put("code", "2");
						}
					}
				}
			}
		}
		return ranklist;
	}

	/**
	 * 获取日历列表内容
	 * 
	 * @param sysUser
	 *            当前登录用户
	 * @param campusid
	 *            校区ID
	 * @param startDate
	 *            开始日期
	 * @param endDate
	 *            结束日期
	 * @param teacherName
	 *            教师姓名
	 * @param rankIds
	 *            时段ids
	 * @return
	 */
	public String findCourseScheduleList(SysUser sysUser, String rankIds, String campusid, String startDate, String endDate, String teacherid, String loginRoleCampusIds ) {
		Integer userType;
		userType = sysUser.getInt("user_type");
		StringBuffer querySql = new StringBuffer("SELECT * FROM ((");
		StringBuffer endSql = new StringBuffer(") ) a ORDER BY a.course_time ASC, a.trrankname ASC");
		StringBuffer subQuerySql = new StringBuffer(
				"SELECT DISTINCT courseplan.id cpid,concat( '时段:', time_rank.RANK_NAME, '\r\n老师:', IFNULL(teacher.real_name, '') ) AS title,\n"
						+ "				IFNULL(course.course_name, '') AS couse_name, class_order.classNum, stu.real_name stuName,\n"
						+ "				IFNULL( CONCAT( IF ( LENGTH(courseplan.startrest) <= 4, CONCAT('0', courseplan.startrest), courseplan.startrest ),'-', courseplan.endrest ),\n"
						+ "				time_rank.RANK_NAME ) trrankname, courseplan.course_time, classroom. NAME classroomname, campus.campus_name, campus.campustype,\n"
						+ "				time_rank.RANK_NAME, courseplan.ROOM_ID, courseplan.campus_id, courseplan.teacher_id, courseplan.student_id, courseplan.course_id,\n"
						+ "				courseplan.class_id, courseplan.remark, date_format( courseplan.course_time, '%Y,(%c-1),%d' ) AS START, date_format(courseplan.course_time,'%Y-%m-%d') as start_course_time, courseplan.rechargecourse,\n"
						+ "				courseplan.plan_type AS planType, courseplan.id, courseplan.startrest, courseplan.endrest, courseplan.netCourse AS netCourse, courseplan.signin AS signin,\n"
						+ "				courseplan.TEACHER_PINGLUN AS teacherPinglun, courseplan.TIMERANK_ID, date_format( courseplan.course_time, '%Y-%m-%d' ) kcrq\n");
		StringBuffer subFromSql = new StringBuffer(
						"			   FROM courseplan LEFT JOIN course ON courseplan.course_id = course.id LEFT JOIN campus ON campus.id = courseplan.campus_id\n"
						+ "			   LEFT JOIN classroom ON classroom.id = courseplan.room_id LEFT JOIN time_rank ON time_rank.id = courseplan.timerank_id\n"
						+ "			   LEFT JOIN class_order ON class_order.id = courseplan.class_id LEFT JOIN account stu ON stu.id = courseplan.student_id\n"
						+ "			   LEFT JOIN account teacher ON teacher.id = courseplan.teacher_id WHERE courseplan.plan_type != 1");
		StringBuffer subWhereSql = new StringBuffer();
		// 查询字段
		if (startDate != null && startDate.length() > 0) {// 选择开始日期查询
			subWhereSql.append(" AND courseplan.COURSE_TIME>=").append(" ' ").append(startDate.trim()).append("'");
		}
		if (endDate != null && endDate.length() > 0) {// 选择结束时间查询
			subWhereSql.append(" AND courseplan.COURSE_TIME<=").append(" ' ").append(endDate.trim()).append("'");
		}
		if (rankIds != null && rankIds.length() > 0) {// 选择时段查询
			subWhereSql.append(" AND courseplan.TIMERANK_ID IN").append("(").append(rankIds).append(")");
		}
		if (campusid != null && campusid.length() > 0) {// 选择校区查询
			subWhereSql.append(" AND courseplan.CAMPUS_ID=").append(campusid);
		}
		if (teacherid != null && teacherid.length() > 0) {// 选择教师查询
			subWhereSql.append(" AND courseplan.TEACHER_ID= ").append(teacherid);
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			subWhereSql.append( " AND courseplan.campus_id in (" + loginRoleCampusIds + ")" );
		}

		String sql = querySql.toString() + subQuerySql.toString() + subFromSql.toString() + subWhereSql.toString() + endSql.toString();
		List<CoursePlan> list = CoursePlan.dao.find(sql);
		
		JSONArray jsons = new JSONArray(list.size());
		JSONObject json = null;
		
		StringBuilder courseTime = new StringBuilder();
		
		
		for (CoursePlan cp : list) {
			
			json = new JSONObject();
			jsons.add(json);
			
			String title = cp.getStr("title");
			String student = "无";
			courseTime.setLength(0);
			courseTime.append(cp.getStr("kcrq")).append(" ")
					.append(cp.getStr("RANK_NAME").substring(0, cp.getStr("RANK_NAME").indexOf("-"))).append(":00");
			String nowDateTime = ToolDateTime.getCurDateTime();
			long interval = ToolDateTime.compareDateStr(courseTime.toString(), nowDateTime); // 时间间隔
			String[] rankName = cp.getStr("RANK_NAME").split("-");
			
			// 课程类型
			if (cp.getInt("planType").toString().equals("0")) {// 课程
				cp.put("startRank", rankName[0]);
				cp.put("endRank", rankName[1]);
				if ((cp.getInt("class_id") == 0)) {// 一对一
					student = cp.getStr("stuName");
					cp.put("ctname", "");// 班课，此时班型为空
				} else {//小班
					ClassOrder classorder = ClassOrder.dao.getClassOrderDetailMsg(cp.getInt("class_id").toString());
					cp.put("ctname", classorder.getStr("ctname"));
					student = CourseOrder.dao.findStudentNamesByClassIds(classorder.getPrimaryKeyValue().toString());
				}
			}
			// 教师休息
			String startrest = cp.getStr("startrest");
			String endrest = cp.getStr("endrest");
			if (cp.getInt("planType").toString().equals("2")) {// 休息
				Teacher teachercp = Teacher.dao.findById(cp.getInt("teacher_id"));
				cp.put("startRank", startrest);
				cp.put("endRank", endrest);
				rankName = new String[2];
				if (startrest.equals("00:00") && endrest.equals("23:59")) {
					title = "时段:全天\r\n老师:" + teachercp.getStr("REAL_NAME");
					rankName[0] = "00:00";
					rankName[1] = "23:59";
				} else {
					title = "时段:" + startrest + "-" + endrest + "\r\n老师:" + teachercp.getStr("REAL_NAME");// 非全天
					rankName[0] = startrest;
					rankName[1] = endrest;
				}
			}
			
			
			Integer signin 			= null;
			String teacherPinglun 	= null;
			if ("2".equals(userType)) {// 教师
				signin 		  	= (interval > 0) ?  1  :  0 ;// interval > 0   表示: 课程已结束
				teacherPinglun 	= (interval > 0) ? "y" : "n";
			} else {
				signin 			= cp.getInt("signin");
				teacherPinglun 	= cp.getStr("teacherPinglun");
			}
			
			String date = cp.getStr("start_course_time");
			
			
			json.put("title", 			   title );//2017-02-24 15:13:27
			json.put("start", 			   date + " " + rankName[0] + ":00");
			json.put("end", 			   date + " " + rankName[1] + ":00");
			json.put("classId", 		cp.getInt("class_id") );
			json.put("cpid", 			cp.getInt("cpid") );
			json.put("student", 		   student );
			json.put("msg", 			cp.getStr("remark") );
			json.put("courseplanId", 	cp.getInt("courseplanId") );
			json.put("name", 			cp.getStr("classroomname") );
			json.put("TIMERANK_ID", 	cp.getInt("TIMERANK_ID") );
			json.put("datetime", 		   date );
			json.put("campus_name", 	cp.getStr("campus_name") );
			json.put("campustype", 		cp.get("campustype") );
			json.put("netCourse", 		cp.getInt("netCourse") );
			json.put("plantype", 		cp.getInt("plantype") );
			json.put("couse_name", 		cp.getStr("couse_name") );
			json.put("kcrq", 			cp.getStr("kcrq") );
			json.put("stuName", 		cp.getStr("stuName") );
			json.put("ctname", 			cp.getStr("ctname") );
			json.put("rechargecourse", 	cp.getBoolean("rechargecourse") );
			json.put("signin", 			   signin );
			json.put("teacherPinglun", 	   teacherPinglun );
			
		}
		
		return jsons.toJSONString();
	}
 

	/**
	 * 获取相同开始时段的时段列表(可用时段) 用于调整课程使用
	 * 
	 * @param id
	 *            记录id
	 * @param minInterval
	 *            时段
	 * @return 时段列表
	 */
	public List<TimeRank> getRankListBySameName(String id, String minInterval) {
		List<TimeRank> rankList = new ArrayList<TimeRank>();
		String querySql = "SELECT tr.RANK_NAME,cp.*  FROM courseplan cp JOIN time_rank tr ON cp.TIMERANK_ID=tr.id where cp.id=? ";
		CoursePlan coursePlan = CoursePlan.dao.findFirst(querySql, id);
		String rankname = "";
		String[] array = coursePlan.getStr("RANK_NAME").split("-")[0].split(":");
		int hour = Integer.parseInt(array[0]);
		int newMin = Integer.parseInt(array[1]) + Integer.parseInt(minInterval);
		if (Math.abs(newMin) > 60) {
			int newHour = hour + newMin / 60;
			if (newHour < 10) {
				rankname = "0" + newHour;
			} else {
				rankname = newHour + "";
			}
		} else {
			int newHour = hour;
			if (newHour < 10) {
				rankname = "0" + newHour;
			} else {
				rankname = newHour + "";
			}
		}
		StringBuffer sql = new StringBuffer("SELECT id,rank_name ,0 as code FROM time_rank WHERE  rank_name like '").append(rankname).append("%'");
		rankList = TimeRank.dao.find(sql.toString()); // 获取该时段列表
		if (rankList.size() > 0) {
			if (coursePlan.getInt("class_id") != 0) {// 班课
				// 查询该班级所有学生
				String sqlStu = "SELECT * FROM account WHERE FIND_IN_SET(Id,(SELECT GROUP_CONCAT(account_id) FROM account_banci WHERE banci_id=?)) AND STATE <> 2";
				List<Student> studentList = Student.dao.find(sqlStu, coursePlan.getInt("class_id"));
				for (Student student : studentList) {// 查询班课中每个学生的排课情况
					List<CoursePlan> list = CoursePlan.dao.getEnableRankList(student.getPrimaryKeyValue().toString(), coursePlan.getInt("TEACHER_ID")
							.toString(), coursePlan.getTimestamp("COURSE_TIME").toString(), coursePlan.getPrimaryKeyValue());
					for (CoursePlan plan : list) {
						String plantype = plan.getInt("plan_type").toString();
						Integer starttime = null;
						Integer endtime = null;
						if (plantype.equals("2")) {// 老师休息
							starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
							endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
						} else {// 课程和模考
							starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
							endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
						}
						for (TimeRank time : rankList) {
							Integer rankstart = Integer.parseInt(time.getStr("rank_name").split("-")[0].replace(":", ""));
							Integer rankend = Integer.parseInt(time.getStr("rank_name").split("-")[1].replace(":", ""));
							if ((rankstart <= starttime && rankend > starttime) || (starttime <= rankstart && endtime > rankstart)) {
								// 0正常；1占用；2有课
								if (!time.get("code").toString().equals("2"))
									time.put("code", "1");
							}
							if (rankstart.equals(starttime) && rankend.equals(endtime)) {
								time.put("code", "2");
							}
						}
					}
				}
			} else {// 一对一
				List<CoursePlan> planlist = CoursePlan.dao.getEnableRankList(coursePlan.getInt("STUDENT_ID").toString(), coursePlan.getInt("TEACHER_ID")
						.toString(), coursePlan.getTimestamp("COURSE_TIME").toString(), coursePlan.getPrimaryKeyValue());
				if (planlist != null && planlist.size() > 0) {
					for (CoursePlan plan : planlist) {
						String plantype = plan.getInt("plan_type").toString();
						Integer starttime = null;
						Integer endtime = null;
						if (plantype.equals("2")) {// 老师休息
							starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
							endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
						} else {// 课程和模考
							starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
							endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
						}
						for (TimeRank time : rankList) {
							Integer rankstart = Integer.parseInt(time.getStr("rank_name").split("-")[0].replace(":", ""));
							Integer rankend = Integer.parseInt(time.getStr("rank_name").split("-")[1].replace(":", ""));
							if ((rankstart <= starttime && rankend > starttime) || (starttime <= rankstart && endtime > rankstart)) {
								// 0正常；1占用；2有课
								if (!time.get("code").toString().equals("2"))
									time.put("code", "1");
							}
							if (rankstart.equals(starttime) && rankend.equals(endtime)) {
								time.put("code", "2");
							}
						}
					}
				}
			}
		}
		return rankList;
	}
	/**
	 *  保存调整课程信息
	 * @param cpid
	 * @param rankid
	 * @return
	 */
	public JSONObject saveTimeRank(String cpid, String rankid) {
		JSONObject json = new JSONObject();
		if (cpid == null || cpid.length() < 0) {
			json.put("code", 1);
			json.put("result", "请选择要修改的记录");
		} else if (rankid == null || rankid.length() < 0) {
			json.put("code", 1);
			json.put("result", "请选择时段信息");
		} else {
			String sql = "UPDATE courseplan SET TIMERANK_ID = ? ,UPDATE_TIME = now() WHERE id=?";
			Db.update(sql, rankid, cpid);
			json.put("code", "0");
			json.put("result", "更新成功");
		}
		return json;
	}
	/**
	 * 月、周视图修改课程
	 * @param id
	 * @param dateInterval
	 * @param type
	 * @return
	 */
	public JSONObject adjustmentCourse(String id, String dateInterval, String type) {
		boolean flag = true;
		JSONObject json = new JSONObject();
		CoursePlan coursePlan = CoursePlan.dao.findById(id);
		Date courseTime = coursePlan.getTimestamp("COURSE_TIME");
		// 获取要更改到的日期
		Date newDate = ToolDateTime.getInternalDateByDay(courseTime, Integer.parseInt(dateInterval));
		if (Integer.parseInt(type) == 2) {
			String ranktime = coursePlan.getStr("startrest") + "-" + coursePlan.getStr("endrest");
			long  interval = ToolDateTime.compareDateStr(coursePlan.getTimestamp("COURSE_TIME").toString().replace("00:00:00:0",  coursePlan.getStr("startrest"))+":00",ToolDateTime.getCurDateTime());
			if(interval>0){//修改的记录是否是已发生的记录
				json.put("code", "2");
				json.put("result", " 该教师休息时间已超期，不能更改");
			}else{//修改到的时间是否是已发生的时间
				String dateTime = ToolDateTime.format(newDate, "yyyy-MM-dd");
				long  interval1 = ToolDateTime.compareDateStr(dateTime+ coursePlan.getStr(" startrest"),ToolDateTime.getCurDateTime());
				if(interval1>0){
					json.put("code", "2");
					json.put("result", " 您不能将休息时间修改到已过去的时间");
				}else{
					if (!isTimeConflict(ranktime, ToolDateTime.getSqlTimestamp(newDate), coursePlan.getInt("teacher_id"), coursePlan.getPrimaryKeyValue())) {
						json.put("code", "1");
						json.put("result", " 您不能移动到该日期，在{0}教师{1}{2}在 {3}期间有排休/排课");
						json.put("ranktime", ranktime);
						json.put("date", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate));
						json.put("teacher", Teacher.dao.findById(coursePlan.getInt("TEACHER_ID")).getStr("REAL_NAME"));
						json.put("student", "");
					} else {
						String sql = "UPDATE courseplan SET course_time = ? , UPDATE_TIME = now() WHERE id = ?";
						Db.update(sql, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate), coursePlan.getPrimaryKeyValue());
						json.put("code", "0");
						json.put("result", "更新成功");
					}
				}
			}
		} else {// 课程
			String time = TimeRank.dao.findById(coursePlan.getInt("TIMERANK_ID")).getStr("RANK_NAME").split("-")[0];
			long  interval = ToolDateTime.compareDateStr(coursePlan.getTimestamp("COURSE_TIME").toString().replace("00:00:00.0",  time)+":00",ToolDateTime.getCurDateTime());
			if(interval>0){//课程以超期
				json.put("code", "2");
				json.put("result", " 该课程已经超期，不能更改");
			}else{
				String dateTime = ToolDateTime.format(newDate, "yyyy-MM-dd");
				long  interval1 = ToolDateTime.compareDateStr(dateTime +" "+ time+":00",ToolDateTime.getCurDateTime());
				if(interval1>0){
					json.put("code", "2");
					json.put("result", " 您不能将课程时间修改到已过去的时间");
				}else{
					if (coursePlan.getInt("class_id") != 0) {// 班课
						String ranktime = TimeRank.dao.findById(coursePlan.getInt("TIMERANK_ID")).getStr("RANK_NAME");
						// 查询学生
						String sql = "SELECT * FROM account stu WHERE FIND_IN_SET( Id, (SELECT GROUP_CONCAT(DISTINCT studentid) stus FROM teachergrade tgr WHERE tgr.COURSEPLAN_ID=?))";
						List<Student> studentList = Student.dao.find(sql, coursePlan.getPrimaryKeyValue());// 该班级下的学生
						label: for (Student stu : studentList) {// 遍历学生查询班级每个学生在该日期，该时段是否有课程冲突
							String query = "SELECT cp.id,cp.timerank_id,tr.rank_name,cp.startrest,cp.endrest,cp.plan_type "
									+ " FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.timerank_id WHERE\n"
									+ "	(cp.teacher_id = ? OR cp.student_id = ?) AND cp.course_time = ?  ";
							List<CoursePlan> coursePlanList = CoursePlan.dao.find(query, coursePlan.getInt("teacher_id"), stu.getInt("ID"),
									new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate));// 学生某天的课程和教师的排休
							if (coursePlanList.size() > 0){ //存在记录
								for (CoursePlan plan : coursePlanList) {
									String plantype = plan.getInt("plan_type").toString();
									Integer starttime = null;
									Integer endtime = null;
									if (plantype.equals("2")) {// 老师休息
										starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
										endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
									} else {// 课程和模考
										starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
										endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
									}
									Integer rankstart = Integer.parseInt(ranktime.split("-")[0].replace(":", ""));// 开始
									Integer rankend = Integer.parseInt(ranktime.split("-")[1].replace(":", ""));// 结束
									if ((rankstart <= starttime && rankend > starttime) || (starttime <= rankstart && endtime > rankstart)) {
										flag = false;
										break label; // 有冲突
									}
								}
							}
						}
						if (flag) {
							String update = "UPDATE courseplan SET course_time = ? , UPDATE_TIME = now() WHERE id = ?";
							Db.update(update, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate), coursePlan.getPrimaryKeyValue());
							json.put("code", "0");
							json.put("result", "更新成功");
						} else {// 冲突
							json.put("code", "1");
							json.put("result", "不能移动到该日期，在{0}教师{1}/班级{2}中学生在{3}期间排休或排课");
							json.put("ranktime", ranktime);
							json.put("date", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate));
							json.put("teacher", Teacher.dao.findById(coursePlan.getInt("TEACHER_ID")).getStr("REAL_NAME"));
							json.put("student", Student.dao.findById(coursePlan.getInt("STUDENT_ID")).getStr("real_name"));
						}
					} else {// 一对一课程
						String rankname = TimeRank.dao.findById(coursePlan.getInt("TIMERANK_ID")).getStr("RANK_NAME");
						String query = "SELECT cp.id,cp.timerank_id,tr.rank_name,cp.startrest,cp.endrest,cp.plan_type "
								+ " FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.timerank_id WHERE\n"
								+ "	(cp.teacher_id = ? OR cp.student_id = ?) AND cp.course_time = ?  ";
						List<CoursePlan> courseplanList = CoursePlan.dao.find(query, coursePlan.getInt("teacher_id"), coursePlan.getInt("student_id"), newDate);
						for (CoursePlan plan : courseplanList) {
							String plantype = plan.getInt("plan_type").toString();
							Integer starttime = null;
							Integer endtime = null;
							if (plantype.equals("2")) {// 老师休息
								starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
								endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
							} else {// 课程和模考
								starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
								endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
							}
							Integer rankstart = Integer.parseInt(rankname.split("-")[0].replace(":", ""));// 开始
							Integer rankend = Integer.parseInt(rankname.split("-")[1].replace(":", ""));// 结束
							if ((rankstart <= starttime && rankend > starttime) || (starttime <= rankstart && endtime > rankstart)) {
								flag = false;
								break; // 有冲突
							}
						}
						if (flag) {
							String update = "UPDATE courseplan SET course_time = ? , UPDATE_TIME = now() WHERE id = ?";
							Db.update(update, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate), coursePlan.getPrimaryKeyValue());
							json.put("code", "0");
							json.put("result", "更新成功");
						} else {// 冲突
							json.put("code", "1");
							json.put("result", "不能移动到该日期，在{0}内教师{1}/学生{2}在{3}期间有排休或排课");
							json.put("ranktime", rankname);
							json.put("date", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(newDate));
							json.put("teacher", Teacher.dao.findById(coursePlan.getInt("TEACHER_ID")).getStr("REAL_NAME"));
							json.put("student", Student.dao.findById(coursePlan.getInt("STUDENT_ID")).getStr("real_name"));
						}
					}
				}
			}
	
		}
		return json;
	}

	/**
	 * 查询记录是否超期
	 * 
	 * @param id
	 * @param minInterval
	 * @param type
	 *            类型
	 * @return
	 */
	public JSONObject check(String id, String minInterval, String type) {
		JSONObject json = new JSONObject();
		CoursePlan coursePlan = CoursePlan.dao.findById(id);
		if (Integer.parseInt(type) != 2) {
			String time = TimeRank.dao.findById(coursePlan.getInt("TIMERANK_ID")).getStr("RANK_NAME").split("-")[0];
			long interval = ToolDateTime.compareDateStr(coursePlan.getTimestamp("COURSE_TIME").toString().replace("00:00:00.0", time) + ":00",
					ToolDateTime.getCurDateTime());
			if (interval > 0) {// 课程已超期
				json.put("code", "1");
				json.put("result", "课程已超期");
			}  else {
				String[] array = TimeRank.dao.findById(coursePlan.getInt("TIMERANK_ID")).getStr("RANK_NAME").split("-")[0].split(":");
				int minutes = Integer.parseInt(array[1]) + Integer.parseInt(minInterval) + Integer.parseInt(array[0]) * 60;
				String rankname = getTimeString(minutes);
				String newTime = rankname;
				long newInterval = ToolDateTime.compareDateStr(coursePlan.getTimestamp("COURSE_TIME").toString().replace("00:00:00.0", newTime),
						ToolDateTime.getCurDateTime());
				if (newInterval >0) {// 课程已超期
					json.put("code", "1");
					json.put("result", "您无法将课程时间修改到已发生过的时间里");
				}
			} 
		} else {// 教师休息
			String time = coursePlan.getStr("startrest");
			long interval = ToolDateTime.compareDateStr(coursePlan.getTimestamp("COURSE_TIME").toString().replace("00:00:00.0", time) + ":00",
					ToolDateTime.getCurDateTime());
			if (interval > 0) {// 休息时段已超期
				json.put("code", "1");
				json.put("result", "该教师休息时间已超期，不能更改");
			} else {
				String[] array = coursePlan.getStr("startrest").split(":");
				int minutes = Integer.parseInt(array[1]) + Integer.parseInt(minInterval) + Integer.parseInt(array[0]) * 60;
				String rankname = getTimeString(minutes);
				long newInterval = ToolDateTime.compareDateStr(coursePlan.getTimestamp("COURSE_TIME").toString().replace("00:00:00.0", rankname),
						ToolDateTime.getCurDateTime());
				if (newInterval < 0) {// 课程已超期
					json.put("code", "1");
					json.put("result", "您无法将课程时间修改到已发生过的时间里");
				}
			} 
		}
		return json;
	}

	/** 时间 后缀 转换工具
	 * 00:00:00
	 */
	public String  getTimeString(int minutes){
		String rankname = "";
		if (minutes > 60) {
			int newHour = minutes / 60;
			int minu = minutes % 60;
			if (newHour > 10) {
				rankname += newHour + "" + ":";
			} else {
				rankname += "0" + newHour + ":";
			}
			if (minu > 10) {
				rankname += minu + ":00";
			} else {
				rankname += "0" + minu + ":00";
			}
		} else {
			rankname = "00:" + minutes + "00";
		}
		return rankname;
	}
	
	/** 排课管理
	 * @param teacherId 
	 * @param studentId 
	 * @param date2 
	 * @param date1 
	 * @param classtype 
	 * @param campusId 
	 * @param banciId 
	 * @param sysuserId */
	public Map<String, Object> queryCoursePlansManagement(Integer sysuserId, String banciId, String campusId, String classtype, String date1, String date2, String studentId, String teacherId, String loginRoleCampusIds) {
			//查询有课时间如5号到八号的记录
			List<CoursePlan> getCourseDate = CoursePlan.dao.getCourseDate(date1, date2);
			
			//拼接课程计划表 sql
			StringBuffer cpsql = new StringBuffer(
					"SELECT * FROM ( "
					+ " SELECT cp.Id, IF (cp.class_id <> 0,CONCAT('班型:',class_type.`name`,'<br>班次:',class_order.classNum),'授课:一对一') AS teach_type, "
					+ " cp.class_id,r.Id as RANK_ID,r.RANK_NAME, IF(cp.COURSE_ID<0,("
					+ "    		SELECT s.SUBJECT_NAME "
					+ "			FROM `subject` s "
					+ "			WHERE s.Id = ABS(cp.COURSE_ID)"
					+ " ),c.COURSE_NAME) COURSE_NAME,"
					+ " s.USER_TYPE AS USER_TYPE,s.REAL_NAME as S_NAME,t.REAL_NAME as T_NAME,m.`NAME` as ROOM_NAME,cp.STATE,cp.CAMPUS_ID,cp.ROOM_ID,"
					+ " IF(cp.rechargecourse,1,0) rechargecourse,"
					+ " IFNULL( CONCAT( IF(LENGTH(cp.startrest)<=4,CONCAT('0',cp.startrest),cp.startrest), '-', cp.endrest ), r.RANK_NAME ) trrankname, cp.COURSE_TIME,"
					+ "(	SELECT p.CAMPUS_NAME "
					+ " 	FROM campus p WHERE p.Id=(SELECT classroom.CAMPUS_ID FROM classroom WHERE classroom.Id=m.Id) "
					+ ") as CAMPUS_NAME,"
					+ " cp.REMARK,cp.PLAN_TYPE,cp.startrest,cp.iscancel,cp.endrest,cp.confirm,class_order.classNum,class_type.`name` AS type_name,cc.kcgwids,cpat.assistantName ");
			if(!StringUtils.isEmpty(studentId)){
				cpsql.append(
						" FROM ( " +
						"SELECT  courseplan.*,courseplan.STUDENT_ID studentid " +
						"FROM courseplan  " +
						"WHERE " +
						"courseplan.STUDENT_ID="+ studentId +" " +
						"UNION " +
						"SELECT courseplan.*,teachergrade.studentid FROM teachergrade " +
						"LEFT JOIN courseplan  ON teachergrade.COURSEPLAN_ID=courseplan.Id " +
						"WHERE " +
						"teachergrade.studentid="+ studentId +
						") cp");
			}else{
				cpsql.append(" FROM courseplan cp ");
			}
			cpsql.append(" LEFT JOIN course c ON cp.COURSE_ID=c.Id");
			cpsql.append(" LEFT JOIN account as t ON cp.TEACHER_ID=t.Id");
			if(!StringUtils.isEmpty(studentId)){
				cpsql.append(" LEFT JOIN account as s ON cp.studentid=s.Id");
			}else{
				cpsql.append(" LEFT JOIN account as s ON cp.STUDENT_ID=s.Id");
			}
			cpsql.append(
					  " LEFT JOIN ("
					+ "		SELECT GROUP_CONCAT(k.REAL_NAME) real_name, GROUP_CONCAT(ak.kcgw_id) kcgwids, ak.student_id id "
					+ "		FROM student_kcgw ak "
					+ "		LEFT JOIN account a ON ak.student_id = a.Id "
					+ "		LEFT JOIN ( "
					+ "				SELECT * FROM account WHERE LOCATE( "
					+ "					(SELECT CONCAT(',', id, ',') ids FROM pt_role WHERE numbers = 'kcgw'),"
					+ "					CONCAT(',', roleids) "
					+ "				) > 0 ) k ON k.Id = ak.kcgw_id GROUP BY a.Id "
					+ " ) cc on s.id = cc.id ");
			cpsql.append(" LEFT JOIN time_rank r ON cp.TIMERANK_ID=r.Id");
			cpsql.append(" LEFT JOIN classroom m ON cp.ROOM_ID=m.Id ");
			cpsql.append(" LEFT JOIN class_order ON cp.class_id = class_order.id ");
			cpsql.append(" LEFT JOIN class_type  ON class_order.classtype_id = class_type.id ");
			//关联助教
			cpsql.append(" LEFT JOIN (SELECT GROUP_CONCAT(tch.REAL_NAME) AS assistantName , cpa.courseplanId FROM courseplan_assistant cpa LEFT JOIN account tch ON tch.Id = cpa.teacherId GROUP BY cpa.courseplanId ) cpat ON cpat.courseplanId = cp.Id ");
			cpsql.append(" WHERE   s.state <> 1  and cp.COURSE_TIME =? ");
			
			if (!StringUtils.isEmpty(teacherId)) {// 老师ID不为空
				String teacherIds = Teachergroup.dao.getGroupMembersId(teacherId);//显示教研分组中老师的名字
				cpsql.append(" AND cp.TEACHER_ID IN (" + teacherIds + ")");
			}
			if (!StringUtils.isEmpty(studentId)) {//学生ID不为空
				cpsql.append(" AND cp.studentid=").append(studentId);
				//coursePlanSql.append(" AND cp.class_id!=0");
			}
			if (classtype != null) {
				if (classtype.equals("0"))//课程类型
					cpsql.append(" and cp.class_id = 0 ");
				if (classtype.equals("1"))//模考类型
					cpsql.append(" and cp.class_id <> 0 ");
			}
			
			if (!StringUtils.isEmpty(banciId))// 班次
				cpsql.append(" and class_order.id =").append(banciId);
			if (StringUtils.isEmpty(campusId)) {//校区ID
				String campusids = Campus.dao.IsCampusKcFzr(sysuserId);//查询用户是否为课程顾问负责人
				if (campusids != null) {
					cpsql.append(" and cp.CAMPUS_ID IN(").append(campusids).append(")");
				}
			} else {
				cpsql.append(" AND cp.CAMPUS_ID=").append(campusId);
			}
			//添加校区当前登录人所属校区限制
			if( !StringUtils.isEmpty( loginRoleCampusIds )){
				cpsql.append( " AND cp.CAMPUS_ID in (" + loginRoleCampusIds +")" );
			}
			Map<String, Object> timeMap = new LinkedHashMap<String, Object>();
			for (CoursePlan cpdate : getCourseDate) {
				String courseDate = cpdate.getStr("COURSE_TIME");
				List<CoursePlan> cplist = CoursePlan.dao.find(cpsql + " ) a ORDER BY  a.trrankname asc  ", courseDate);
				timeMap.put(courseDate, cplist);

			}
			return timeMap;
		}
	
	/**
	 * @Title: 保存普通排课的内容
	 * @Description: TODO 时间紧张  简易 提取代码
	 * @param json
	 * @param type
	 * @param studentId
	 * @param teacherId
	 * @param roomId
	 * @param timeId
	 * @param campusId
	 * @param subjectid
	 * @param planType
	 * @param isovertime
	 * @param coursetime
	 * @param assistants 助教老师IDS
	 * @param saveCoursePlan
	 * @param courseTime
	 * @param sysuserId
	 * @param plantype
	 * @param netCourse
	 * @param dayTime
	 * @param remark
	 * @param courseId
	 * @param stuId
	 * @param banci_id
	 * @param rankId
	 * @param coursecosts 
	 * @return void   
	 */
	public void saveCoursePlans(JSONObject json, String type ,
			String studentId, String teacherId, String roomId, String timeId,
			String campusId, String subjectid, String planType,
			String isovertime, String coursetime, String assistants, CoursePlan saveCoursePlan,
			String courseTime,Integer sysuserId, String plantype, String netCourse, String dayTime, String remark,
			String courseId, String stuId, String banci_id, String rankId, String coursecost
		){
			String code = "0";
			String msg = "未保存";
			json.put("code", code);
			json.put("msg", msg);
		
			Date nowdate = ToolDateTime.getDate();
			TimeRank timeRank = TimeRank.dao.findById(Integer.parseInt(timeId));
			String fh = timeRank.getStr("RANK_NAME").split("-")[0].split(":")[0];
			String fm = timeRank.getStr("RANK_NAME").split("-")[0].split(":")[1];
			String hms = coursetime.trim().substring(0, 10) + " " + (fh.trim().length() == 1 ? ("0" + fh.trim()) : fh.trim()) + ":"
					+ (fm.trim().length() == 1 ? ("0" + fm.trim()) : fm.trim()) + ":00";
			String thms = ToolDateTime.dateToDateString(new Date(), ToolDateTime.DATATIMEF_STR);
			long between = ToolDateTime.compareDateStr(thms, hms);
			Integer recharge = between < 0 ? 1 : 0;// 1是补排课程,0是正常排课
			double classhour = timeRank.getBigDecimal("class_hour").doubleValue();
			
			saveCoursePlan.set("coursecost", StrKit.notBlank(coursecost) ? coursecost : 0 );
			
			if (type.equals("1")) { // 一对一排课
				CoursePlan cp = CoursePlan.dao.getStuCoursePlan(studentId, timeId, dayTime);
				if (cp == null) {
					Account account = Account.dao.findById(Integer.parseInt(studentId));
					json.put("havecourse", "0");
					double zks = CourseOrder.dao.getVIPzks(account.getPrimaryKeyValue());
					double ypks = CoursePlan.dao.getUseClasshour(studentId, null);// 全部已用课时
					double syks = ToolArith.sub(zks, ypks);// 剩余课时
					
					saveCoursePlan.set("course_time",  courseTime + " 00:00:00");
					saveCoursePlan.set("create_time", nowdate);
					saveCoursePlan.set("update_time", nowdate);
					saveCoursePlan.set("class_id", 0);
					saveCoursePlan.set("isovertime", isovertime);
					saveCoursePlan.set("student_id", studentId);
					saveCoursePlan.set("room_id", roomId);
					saveCoursePlan.set("timerank_id", timeId);
					saveCoursePlan.set("campus_id", campusId);
					saveCoursePlan.set("SUBJECT_ID", subjectid);
					saveCoursePlan.set("adduserid", sysuserId);
					saveCoursePlan.set("rechargecourse", recharge);
					saveCoursePlan.set("plan_type", plantype);
					saveCoursePlan.set("netCourse", netCourse);
					
					//查看学生是否需要  确认 课表
					if(account.getInt("release").equals(0)){//  0不需要     1需要
						saveCoursePlan.set("confirm", 1);
					}
					
					List<CourseOrder> colist = CourseOrder.dao.getOrderByStudentidAndSubjectid(studentId, subjectid);
					TimeRank tr = TimeRank.dao.findById(timeId);
					for (CourseOrder co : colist) {
						double d = CoursePlan.dao.getKeShiByCourseOrderId(co.getInt("id"));
						if (d + tr.getBigDecimal("class_hour").doubleValue() <= co.getDouble("classhour")) {
							saveCoursePlan.set("courseorderid", co.getInt("id"));
							break;
						}
					}
					
					saveCoursePlan.set("remark", StrKit.isBlank(remark)?"暂无":remark.trim());
					
					if ("1".equals(plantype)) {
						saveCoursePlan.set("course_id", "-" + courseId);
						code = "1";
						saveCoursePlan.save();
						Teacher t = Teacher.dao.findById(teacherId);
						if (t != null) {
							t.set("kcuserid", 0).update();// 使用kcuserid字段表示教师课表变动
						}
					} else {
						saveCoursePlan.set("teacher_id", teacherId.equals("") ? null : teacherId);
						saveCoursePlan.set("course_id", courseId);
						if (syks > 0 && "0".equals(plantype)) {
							if (timeRank.getBigDecimal("class_hour").doubleValue() > syks) {
								msg = account.getStr("real_name") + "剩余" + syks + "课时,该时段课时为" + timeRank.getBigDecimal("class_hour") + "课时";
							} else {
								saveCoursePlan.save();
								//课程消耗
								AccountService.me.consumeCourse(saveCoursePlan.getPrimaryKeyValue(), Integer.parseInt(studentId), sysuserId, 0);
								//保存助教   ,一对一可能不需要助教... 有大于无..
								CoursePlanAssistantService.me.save(saveCoursePlan.get("id"), assistants);
								
								Teacher t = Teacher.dao.findById(teacherId);
								if (t != null) {
									t.set("kcuserid", 0).update();// 使用kcuserid字段表示教师课表变动
								}
								if (recharge == 0) {
									// 发送短信
									if (ToolDateTime.isToday(courseTime)) {
										MessageService.sendMessageToStudent(MesContantsFinal.xs_sms_today_tjpk, saveCoursePlan.getPrimaryKeyValue().toString());
									}
								}
								code = "1";
								msg = "success";
								json.put("plan", CoursePlan.dao.getCoursePlanCurrentSaved(saveCoursePlan.getPrimaryKeyValue().toString()));

							}
						} else {
							code = "0";
							msg = account.getStr("real_name") + "课时不足，请购买课时。";
						}
					}
				} else {
					json.put("havecourse", "1");
				}
			} else {// 小班排课
				Integer classOrderId = Integer.parseInt(banci_id);
				ClassOrder ban = ClassOrder.dao.findById(classOrderId);
				if (ban == null) {
					code = "0";
					msg = "班课不存在";
				} else {
					double lessonNum = ban.getInt("lessonNum");
					int chargeType = ban.getInt("chargeType");
					double ypks = CoursePlan.dao.getClassYpkcClasshour(classOrderId);
					if (classhour > ToolArith.sub(lessonNum, ypks) && planType == "0" && chargeType == 1) {
						code = "0";
						msg = "该班课课时不足";
					} else {
						List<CoursePlan> cp = CoursePlan.dao.getClassCoursePlan(classOrderId, timeId, dayTime);
						if (cp.size() == 0) {
							json.put("havecourse", "0");
							Integer xnAccountId = ban.getInt("accountid");// 虚拟班课账户ID
							
							saveCoursePlan.set("course_time", courseTime + " 00:00:00");
							saveCoursePlan.set("create_time", nowdate);
							saveCoursePlan.set("update_time", nowdate);
							saveCoursePlan.set("isovertime", isovertime);
							saveCoursePlan.set("class_id", classOrderId);
							saveCoursePlan.set("student_id", xnAccountId);
							saveCoursePlan.set("SUBJECT_ID", subjectid);
							saveCoursePlan.set("room_id", roomId);
							saveCoursePlan.set("timerank_id", rankId);
							saveCoursePlan.set("campus_id", campusId);
							saveCoursePlan.set("plan_type", plantype);
							saveCoursePlan.set("netCourse", netCourse);
							saveCoursePlan.set("rechargecourse", recharge);
							saveCoursePlan.set("adduserid", sysuserId);
							saveCoursePlan.set("confirm", 1);//小班直接通过
							if ("1".equals(plantype)) {// 模考
								saveCoursePlan.set("course_id", "-" + courseId);
							} else {
								saveCoursePlan.set("teacher_id", teacherId);
								saveCoursePlan.set("course_id", courseId);
							}
							saveCoursePlan.set("remark", StrKit.isBlank(remark)?"暂无":remark.trim());
							
							saveCoursePlan.save();
							ClassOrder.dao.updateTeachTime(classOrderId);// 更新开班时间和结束时间
							//保存助教
							CoursePlanAssistantService.me.save(saveCoursePlan.get("id"), assistants);
							code = "1";
							msg = "success";
							json.put("plan", CoursePlan.dao.getCoursePlanCurrentSaved(saveCoursePlan.getPrimaryKeyValue().toString()));
						} else {// 在该日期下的该时间段内，该学生或小班已有排课
							json.put("havacourse", "1");
						}
					}
				}
			}
			json.put("code", code);
			json.put("msg", msg);
	}
	
	/**
	 * 学生查看指定时间的课程如本周，下周
	 */
	public List<CoursePlan> findStudentSchedule(String studentid,String teacherid,String  startdate,String enddate) {
		StringBuilder sql = new StringBuilder("select cp.*,co.course_name as curriculumname,stu.real_name studentname,ac.real_name as teachername,cl.name roomname from courseplan cp ");
			sql.append("LEFT JOIN course co on co.id = cp.COURSE_ID ");
			sql.append("LEFT JOIN account ac on ac.id = cp.TEACHER_ID ");
			sql.append("LEFT JOIN account stu on stu.id = cp.STUDENT_ID ");
			sql.append("LEFT JOIN classroom cl on cl.id = cp.room_id ");
		    sql.append("where 1=1  ");
		    List<String> queryList = new ArrayList<String>();
		    if (StrKit.isBlank(startdate)&&StrKit.isBlank(enddate)) {
		    	sql.append("and DATE_FORMAT(cp.course_time,'%Y-%m-%d') = CURDATE() ");
		    } else {
		    	sql.append(" and cp.course_time > ? ");
		    	sql.append(" and cp.course_time < ? ");
		    	queryList.add(startdate);
		    	queryList.add(enddate);
		    }
		    if (StrKit.notBlank(studentid)) {
		    	sql.append("and cp.STUDENT_ID = ?  ");
		    	queryList.add(studentid);
		    	return  CoursePlan.dao.find(sql.toString(),queryList.toArray());
		    } else {
		    	sql.append("and cp.TEACHER_ID = ? ");
		    	queryList.add(teacherid);
		    	return CoursePlan.dao.find(sql.toString(),queryList.toArray());
		    }
	}

	
	
	/**
	 * 查询课程数
	 * @param studentids
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Long findStudentScheduleCount ( String studentids,String teacherids, String startDate, String endDate ){
		StringBuffer sqlMain = new StringBuffer("select count(*) FROM courseplan ");
		String vipWhere = null;
		if(StrKit.notBlank(studentids)&& !studentids.equals("null")){
			vipWhere 	= "where STUDENT_ID = ?  and class_id = 0 ";
		}else{
			vipWhere 	= "where TEACHER_ID = ? ";
		}

		String commonWhere 	= "  and course_time >= ? and course_time <= ? order by course_time";
		String where = " and teachTime < ? and endTime > ?";
		StringBuilder vipSql 	= new StringBuilder(sqlMain);
		StringBuilder classSql 	= new StringBuilder("select count(*)  from class_order ");
		Long vipList 	= Db.queryLong(vipSql.append(vipWhere).append(commonWhere).toString(), studentids == null ? teacherids:studentids, startDate, endDate);
		if(StrKit.notBlank(studentids)&& !studentids.equals("null")){
			String classIds = toSql(AccountBanci.dao.findClassIdsByStudentIds(studentids));// 学生所在班级的ID
			String classWhere 	= "where id in( "+classIds+" ) ";
			if(!StringUtils.isEmpty(classIds)){
				Long classList = Db.queryLong(classSql.append(classWhere).append(where).toString(), startDate, endDate);
				vipList = vipList + classList;
			}
		}
		return vipList;
	}
}
