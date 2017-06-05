
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

package com.momathink.teaching.teacher.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.AccountBook;
import com.momathink.sys.account.service.AccountService;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.teacher.model.GradeUpdate;
import com.momathink.teaching.teacher.model.Teachergrade;

@Controller(controllerKey = "/teachergrade")
public class TeachergradeController extends BaseController {
	private static final Logger logger = Logger.getLogger(TeachergradeController.class);
	private AccountService accountService = new AccountService();
	/**
	 * 小班关联学生要上的课程，以备老师评论打分
	 */
	public void add() {
		JSONObject json = new JSONObject();
		json.put("code", 0);//成功
		try {
			// 获取页面数据
			String studentId = getPara("studentId");
			String coursePlanId = getPara("coursePlanId");
			String operateType = getPara("operateType");
			CoursePlan coursePlan = CoursePlan.coursePlan.findById(Integer.parseInt(coursePlanId));
			Integer classOrderId = coursePlan.getInt("class_id");
			Teachergrade teachergrade = Teachergrade.teachergrade.findByCoursePlanIdAndStudentid(coursePlanId, studentId);
			if ("add".equals(operateType)) {
				double banHour = CourseOrder.dao.getBanHour(Integer.parseInt(studentId), classOrderId);// 学生购买的小班课时
				double classHour = TimeRank.dao.getHourById(coursePlan.getInt("TIMERANK_ID"));// 本次要上的课程安排的课时
				double hasHour = Teachergrade.teachergrade.getHasHour(Integer.parseInt(studentId), classOrderId);// 已经安排了的课时总数
				double sumHour = ToolArith.add(classHour, hasHour);// 要给学生安排的总的课时数
				if (ToolArith.compareTo(banHour, sumHour) >= 0) {
					// 判断是否点名或是否已经评价
					if (teachergrade == null) {
						teachergrade = new Teachergrade();
						teachergrade.set("courseplan_id", coursePlanId).set("studentid", studentId).set("role", 1).set("createtime", new Date());
						teachergrade.save();
						Db.update("insert into teachergrade_update select * from teachergrade  where id= ? ", teachergrade.getPrimaryKeyValue());
					}
					accountService.consumeCourse(coursePlan.getPrimaryKeyValue(), Integer.parseInt(studentId), getSysuserId(),0);
				} else {
					json.put("code", 1);
					json.put("msg", "课时数不能大于已购" + banHour + "课时");
				}
			} else {
				if (teachergrade != null) {
					teachergrade.delete();
					Db.deleteById("teachergrade_update", teachergrade.getPrimaryKeyValue());
				}
				AccountBook.dao.deleteByAccountIdAndCoursePlanId(Integer.parseInt(studentId),Integer.parseInt(coursePlanId));
			}
		} catch (Exception e) {
			json.put("code", 1);
			json.put("msg", "操作失败请联系管理员");
			e.printStackTrace();
		}
		renderJson(json);
	}

	/**
	 * 保存老师为学生打的分数
	 */
	public void saveTeachergrade() {
		JSONObject json = new JSONObject();
		try {
			// 获取页面数据
			String studentid = getPara("studentid");
			String courseplanid = getPara("courseplanid");

			String bencikecheng = getPara("bencikecheng");
			String bencizuoye = getPara("bencizuoye");
			String question = getPara("question");
			String method = getPara("method");
			String tutormsg = getPara("tutormsg");

			// 获取登陆用户身份用于判断
			Integer sysuserid = getSysuserId();
			SysUser user = SysUser.dao.findById(sysuserid);
			String role = "";

			// 获取课程信息，判断是否在规定时间内
			CoursePlan cp = CoursePlan.coursePlan.getCoursePlanCurrentSaved(courseplanid);

			// 判断是否点名或是否已经评价
			Teachergrade records = null;

			if (Role.isStudent(user.getStr("roleids"))) {
				role = "2";
			}
			if (Role.isTeacher(user.getStr("roleids"))) {
				role = "1";
			}
			String cptime = ToolDateTime.getStringTimestamp(cp.getTimestamp("COURSE_TIME"));
			// 查看机构配置规定评价时间
			Organization o = Organization.dao.findById(1);
			int hours = o.getInt("basic_maxdaily");

			String time_rank = cp.getStr("RANK_NAME");// 上课的时间段
			String lastTime = cptime + " " + time_rank.split("-")[0] + ":00";// 取出结束时间并合并成time格式
			long diffTime = ToolDateTime.compareDateStr(lastTime, ToolDateTime.dateToDateString(new Date())) / 1000 / 60;// 计算相差的分钟数
			if (diffTime >= 0) {
				if (role.equals("1") || role.equals("2")) {
					if (role.equals("1")) { // 老师评论
						String attention = getPara("ATTENTION");//注意力打分/知识点
						String understand = getPara("UNDERSTAND");//理解力/逻辑性
						String studymanner = getPara("STUDYMANNER");//学习态度/亲和力
						String studytask = getPara("STUDYTASK");//上次作业/责任心
						String achievement = getPara("ACHIEVEMENT");//现有成绩(每节课的成绩)
						String onekeyCourseplanId = getPara("onekeyCourseplanId");// 同老师,同学生,同课程

						List<String> courseplanIdsum = new ArrayList<String>();
						courseplanIdsum.add(courseplanid);
						
						if (StrKit.notBlank(onekeyCourseplanId)){
							String[] onekeyCourseplanIds = onekeyCourseplanId.split(",");
							for (String onekeyCourseplanIdStr : onekeyCourseplanIds)
								courseplanIdsum.add(onekeyCourseplanIdStr);
						}
						
						for (String courseplanidKey : courseplanIdsum) {
							
							records = Teachergrade.teachergrade.findByCoursePlanIdAndStudentid(courseplanidKey, studentid);
							Db.update("update courseplan set TEACHER_PINGLUN='y' where ID=?", cp.getInt("id"));
							if (records == null) {
								Teachergrade t = new Teachergrade();
								t.set("courseplan_id", courseplanidKey).set("studentid", studentid).set("ATTENTION", attention).set("UNDERSTAND", understand)
										.set("STUDYMANNER", studymanner).set("STUDYTASK", studytask).set("ACHIEVEMENT", achievement);
								t.set("COURSE_DETAILS", bencikecheng).set("HOMEWORK", bencizuoye).set("question", question).set("method", method)
										.set("tutormsg", tutormsg);
								t.set("role", role);
								t.set("createtime", new Date());
								if (diffTime < hours * 60 * 60) {
									t.set("isoneday", 1);
								} else {
									t.set("isoneday", 2);
								}
								t.save();
								Db.update("insert into teachergrade_update select * from teachergrade  where id= ? ", t.getPrimaryKeyValue());
							} else {
								boolean flag = false;
								if (records.getStr("UNDERSTAND").equals("")) {
									flag = true;
								}
								records.set("ATTENTION", attention).set("UNDERSTAND", understand).set("STUDYMANNER", studymanner).set("STUDYTASK", studytask).set("ACHIEVEMENT", achievement);
								records.set("COURSE_DETAILS", bencikecheng).set("HOMEWORK", bencizuoye).set("question", question).set("method", method)
										.set("tutormsg", tutormsg).update();
								if (flag) {
									GradeUpdate gp = GradeUpdate.dao.findById(records.getPrimaryKeyValue());
									gp.set("ATTENTION", attention).set("UNDERSTAND", understand).set("STUDYMANNER", studymanner).set("STUDYTASK", studytask).set("ACHIEVEMENT", achievement);
									gp.set("COURSE_DETAILS", bencikecheng).set("HOMEWORK", bencizuoye).set("question", question).set("method", method)
											.set("tutormsg", tutormsg).update();
								}
							}
						}
						
					} else if (role.equals("2")) {// 学生评论 暂未
						records = Teachergrade.teachergrade.findByCoursePlanIdAndStudentid(courseplanid, sysuserid.toString());
						Db.update("update courseplan set STUDENT_PINGLUN='y' where ID=?", cp.getInt("id"));
						String ljx = getPara("LJX");//教师逻辑性（学生评价）
						String zsd = getPara("ZSD");//教师知识点（学生评价）
						String zrx = getPara("ZRX");//教师责任心（学生评价）
						String qhl = getPara("QHL");//教师亲和力（学生评价） 
						String sbz = getPara("SBZ");//学生评价教师备注（学生评价） 
						
						records.set("LJX", ljx).set("ZSD", zsd).set("ZRX", zrx).set("QHL", qhl).set("SBZ", sbz).update();
					}
					if (diffTime < (hours * 60 * 60)) {
						json.put("message", "保存成功。");
					} else {
						json.put("message", "保存成功,但是提交日期已经超出" + hours + "小时");
					}
				} else {
					json.put("message", "对不起,您不是该课程的评价教师或学生。如需评价，请通知课程教师或学生进行评价");
				}
			} else {
				json.put("message", "课程未完成！");
			}
			renderJson(json);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 查询老师为学生打的分数 回显
	 */
	public void getTeachergrade() {
		try {
			String courseplan_id = getPara("courseplan_id");
			String sql = "select * from teachergrade where COURSEPLAN_ID=" + Integer.parseInt(courseplan_id);
			java.util.List<Record> records = Db.find(sql);
			if (records.size() > 0) {
				renderJson(records);
			} else {
				renderJson("aaa");
			}
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/*
	 * public void syncPinglun(){ String sql =
	 * "SELECT cp.class_id,cp.TIMERANK_ID,cp.COURSE_TIME,cp.ROOM_ID,cp.TEACHER_ID,cp.TEACHER_PINGLUN,cp.STUDENT_PINGLUN FROM courseplan cp WHERE cp.class_id<>0 AND cp.STATE=0 AND cp.TEACHER_PINGLUN='y'"
	 * ; List<Record> list = Db.find(sql); for(Record cp : list){ Record xb =
	 * Db.findFirst(
	 * "SELECT * FROM courseplan WHERE STATE=1 AND COURSE_TIME=? AND TIMERANK_ID=? AND TEACHER_ID=? "
	 * , cp.get("COURSE_TIME"), cp.getInt("TIMERANK_ID"),
	 * cp.getInt("TEACHER_ID")); } }
	 */
}
