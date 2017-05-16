
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

package com.momathink.sys.account.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.aop.Before;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.constants.Constants;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolMD5;
import com.momathink.common.tools.ToolMonitor;
import com.momathink.common.tools.ToolOperatorSession;
import com.momathink.common.tools.ToolString;
import com.momathink.common.tools.ToolUtils;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.account.model.AccountBook;
import com.momathink.sys.account.model.ExamScore;
import com.momathink.sys.account.model.UserCourse;
import com.momathink.sys.account.service.AccountService;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.grade.model.GradeDetail;
import com.momathink.teaching.grade.model.GradeRecord;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;

@Controller(controllerKey="/account")
public class AccountController extends BaseController {
	private static final Logger logger = Logger.getLogger(AccountController.class);
	
	public void index() {
		try {
			Record record = getSessionAttr("account_session");
			if(Role.isStudent(record.getStr("roleids"))){
				redirect("/account/backMain");
			}else if(Role.isTeacher(record.getStr("roleids"))){
				redirect("/account/backTeacher");
			}else{
				redirect("/main/index");
			}
		} catch (Exception e) {
			System.out.println(e.toString());
		}
	}
	
	// 已排过的课程禁止取消
	public void modifyCourse(){
		String stuId = getPara("stuId");
		String sql = "SELECT " +
				"courseplan.COURSE_ID, " +
				"course.COURSE_NAME " +
				"FROM " +
				"courseplan " +
				"LEFT JOIN account ON courseplan.STUDENT_ID = account.Id " +
				"LEFT JOIN course ON courseplan.COURSE_ID = course.Id " +
				"WHERE " +
				"courseplan.STUDENT_ID = ? AND " +
				"account.STATE <> 1 AND " +
				"courseplan.STATE <> 1 AND " +
				"courseplan.PLAN_TYPE = 0 " +
				"GROUP BY COURSE_ID ";
		List<Record> record = Db.find(sql, stuId);
		renderJson("record", record);
	}
	
	/**
	 * 验证手机号的惟一性
	 */
	public void checkTel() {
		String stuTel = getPara("stu_tel");
		String stuId = getPara("stu_id");
		if (!ToolString.isNull(stuTel)) {
			List<Record> record = Db.find("SELECT * FROM account WHERE account.state=0 and account.TEL=? and account.id <> ? ", stuTel,stuId);
			if (record.size() > 0) {
				renderJson("result", "hava");
			} else {
				renderJson("result", null);
			}
		}
	}
	
	/**
	 * 验证已排课的节数和用户输入的节数
	 */
	public void verifyUsedCourse() {
		Integer stu_id = getParaToInt("stu_id");// 学生id
		List<Record> record = Db.find("SELECT * FROM courseplan WHERE STUDENT_ID=? and state=0 and class_id=0 and PLAN_TYPE=0 ", stu_id);
		if (record == null) {
			renderJson("plancount", null);
		} else {
			Integer course_id = getParaToInt("course_id");
			Record record2 = null;
			String sql = "SELECT COUNT(*) AS plancount FROM courseplan WHERE STUDENT_ID=? AND COURSE_ID=? and state=0 and class_id=0 and PLAN_TYPE=0 ";
			record2 = Db.findFirst(sql, stu_id, course_id);
			renderJson("plancount", record2.getLong("plancount").intValue());
		}
	}
	public void freezeAccount(){
		try{
			int state=getParaToInt("state");
			int accountId=getParaToInt("accountId");
			Db.update("update account set state=? where id=?",state,accountId);//解冻or冻结用户
			renderJson("result", "true");
		}catch(Exception e)
		{
			logger.error("AccountController.freezeAccount",e);
		}
	}
	/**
	 * 根据科目和类别获取已有的班次
	 */
	public void getClassOrder() {
		Integer subject_id = getParaToInt("subjectId");
		List<ClassOrder> classOrder = ClassOrder.getClassOrder(subject_id);
		renderJson("classOrder", classOrder);
	}



	public void getCourseListBySubjectId() {
		try {
			String subjectId = getPara("SUBJECT_ID").replace("|", ",");
			 String strReverse=new StringBuffer(subjectId).reverse().toString(); 
			if(strReverse.substring(0,1).equals(",")){
				strReverse = strReverse.substring(1);
				String str=new StringBuffer(strReverse).reverse().toString(); 
				subjectId = str;
			}
			//String[] sub_id = subjectId.split(",");
			String sql = "SELECT " +
					"course.Id, " +
					"course.COURSE_NAME, " +
					"`subject`.SUBJECT_NAME " +
					"FROM " +
					"course " +
					"INNER JOIN `subject` ON course.SUBJECT_ID = `subject`.Id " +
					"WHERE " +
					"`subject`.Id  in ("+subjectId+")";
			/*for(int i = 1;i < sub_id.length;i++){
				sql += " or `subject`.Id = " + sub_id[i];
			}*/
			List<Course> courses = Course.dao.find(sql);
			renderJson("courses", courses);
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}



	

	/**
	 * 编辑用户资料
	 */
	public void editAccount() {
		try {
			String stuId = getPara(0);
			setAttr("subjects", Subject.dao.find("select * from subject where state=0"));
			setAttr("supervisors", Account.dao.find("SELECT * FROM `account` WHERE "
					+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role "
					+ " WHERE numbers = 'dudao'), CONCAT(',', roleids) ) > 0;"));
			setAttr("sells", Account.dao.find("SELECT * FROM `account` WHERE "
					+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role "
					+ " WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0;"));
			Account account = Account.dao.findById(getParaToInt());
			setAttr("accountEntity", account);
			Record record2 = Db.findFirst("SELECT COUNT(*) AS usecount FROM courseplan WHERE STUDENT_ID=? AND class_id=0 and PLAN_TYPE=0 ", account.getInt("id"));
			setAttr("usecount", record2.getLong("usecount").intValue());
			String classTypes = account.getStr("class_type") != null ? account.getStr("class_type").replace("|", ",").replaceFirst(",", "") : "0";
			String sql = "select course.id ,subject.id as subjectId,course.course_name,subject.subject_name as subjectName from  course left join subject on course.subject_id=subject.id  where course.id in ("
					+ classTypes + ")";
			List<Course> userCourses = Course.dao.find(sql);
			setAttr("userCourses", userCourses);
			// 查询用的所选的班次
			String sql3 = "SELECT " +
					"	class_order.classNum, " +
					"	account_banci.account_id, " +
					"	account_banci.banci_id, " +
					"	class_type.id, " +
					"	class_type.`name` " +
					"FROM " +
					"	account_banci " +
					"LEFT JOIN class_order ON account_banci.banci_id = class_order.id " +
					"LEFT JOIN class_type ON class_order.classtype_id = class_type.id " +
					"WHERE " +
					"	account_banci.account_id = ?";
			List<Record> record = Db.find(sql3, stuId);
			setAttr("userBanci", record);
			
			sql = "select * from exam_score where student_id=" + account.getInt("id");
			List<ExamScore> examScores = ExamScore.examScore.find(sql);
			if (examScores.size() > 0) {
				setAttr("examScoreEntity", examScores.get(0));
				if (examScores.size() > 0) {// 考试前跟考试后考试分数区别开
					examScores.remove(0);
				}
				setAttr("examScores", examScores);
			}
            if(Role.isTeacher(account.getStr("roleids")))
            	renderJsp("/account/teacher_form.jsp");
            else if(Role.isStudent(account.getStr("roleids")))
            	renderJsp("/account/student_form.jsp");
            else
            	renderJsp("/account/user_form.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}
	
	
	/**
	 * 根据名称获取对象模糊查询
	 */
	public void getAccountByNameLike() {
		try {
			List<Student> list = Student.dao.queryByAccountByNameLike(getPara("studentName"), getAccountCampus());
			renderJson("accounts", list);
		} catch (Exception ex) {
			logger.error(ex.toString());
			renderJson("accounts", "");
		}
	}
	
	/**
	 * 根据班次id查询
	 */
	public void getAccountByClassLike(){
		String campus = getAccountCampus();
		String classId = getPara("class_id");
		String sql = "SELECT " +
				"	class_order.classNum, " +
				"	class_type.`name`, " +
				"	banci_course.banci_id, "
				+ " account.id " +
				"FROM " +
				"	banci_course " +
				"INNER JOIN class_order ON banci_course.banci_id = class_order.id " +
				"INNER JOIN class_type ON class_order.classtype_id = class_type.id " +
				"INNER JOIN account_banci ON account_banci.banci_id = banci_course.banci_id  "
				+ " left join account on account.real_name = class_order.classNum " +
				"WHERE class_order.classNum LIKE ? and class_order.campusId in (" + campus + ") GROUP BY class_order.classNum";
		List<Record> record = Db.find(sql, "%"+classId+"%");
		renderJson("classes", record);
	}

	/**
	 * 根据名称获取对象以及使用数量
	 */
	public void getAccountByName() {
		try {
			String stuId = getPara("studentId"); // 学生id
			String sql0 = "select * from account where id=" + stuId;
			Account list = Account.dao.findFirst(sql0);
			if (list != null) {
				String sql = "SELECT " +
						"	c.account_id, " +
						"	c.course_id, " +
						"	c.COURSE_NAME, " +
						"	convert(CONCAT(IFNULL(b.count_course,0),' '),char) AS classinfo, " +
						"	IFNULL(b.count_course, 0) yipai, " +
						"	c.lesson_num " +
						"FROM " +
						"	( " +
						"		SELECT " +
						"			uc.account_id, " +
						"			uc.course_id, " +
						"			c.COURSE_NAME, " +
						"			uc.lesson_num " +
						"		FROM " +
						"			user_course uc " +
						"		LEFT JOIN course c ON uc.course_id = c.Id " +
						"		WHERE " +
						"			uc.account_id = ? " +
						"	) c " +
						"LEFT JOIN ( " +
						"	SELECT " +
						"		a.COURSE_ID, " +
						"		course.COURSE_NAME, " +
						"		COUNT(*) AS count_course " +
						"	FROM " +
						"		( " +
						"			SELECT " +
						"				cp.COURSE_ID, " +
						"				DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d') courseDate, " +
						"				cp.TIMERANK_ID " +
						"			FROM " +
						"				courseplan cp " +
						"			WHERE " +
						"				cp.STUDENT_ID = ? and cp.class_id = 0 and cp.PLAN_TYPE=0  " +
						"			GROUP BY " +
						"				cp.COURSE_ID, " +
						"				DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d'), " +
						"				cp.TIMERANK_ID " +
						"		) AS a " +
						"	INNER JOIN course ON course.Id = a.COURSE_ID " +
						"	GROUP BY " +
						"		a.COURSE_ID " +
						") b ON c.course_id = b.COURSE_ID";
				List<Record> record = Db.find(sql, stuId,stuId);//查询学生的详细排课信息
				// 查询总节数和已经排课的节数
				Integer countLesson = 0;
				Integer usedLesson = 0;
				String str = "";
				for (Record rec : record) {
					usedLesson += rec.getLong("yipai").intValue();
					if( rec.getInt( "lesson_num" ) != null ){
						countLesson += rec.getInt("lesson_num");
					}
				}
				// 从account中查询总的排课节数
				Record studentInfo = Db.findFirst("select * from account where id=? ", stuId);
				countLesson = studentInfo.getInt("COURSE_SUM");
				str += " 总节：" + countLesson + " 已排：" + usedLesson + " ";
				String stuName = list.getStr("REAL_NAME");// 学生姓名
				List<Object> courseList = new ArrayList<Object>();
				Map<Object, Object> map = new HashMap<Object, Object>();
				for (Record rec : record) {
					Map<Object, Object> map1 = new HashMap<Object, Object>();
					str += rec.getStr("COURSE_NAME") + "：" + rec.get("classinfo") + " ";
					map1.put("course_id", rec.get("course_id"));
					map1.put("course_name", rec.get("COURSE_NAME"));
					if(countLesson != 0 && countLesson == usedLesson){
						map1.put("status", 0);
					}else{
						map1.put("status", 1);
					}
					courseList.add(map1);
				}
				map.put("courseList", courseList);
				map.put("courseUseNum", usedLesson);
				map.put("stuName", stuName);
				map.put("stuMsg", str);
				map.put("studentId", stuId);
				map.put("sumCourse", countLesson);
				map.put("useCourse", usedLesson);
				renderJson("account", map);
			} else {
				renderJson("account", "noResult");
			}

		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}
	
	/**
	 * 根据班次id查询班次信息
	 */
	public void getAccountByClass() {
		try {
			String classId = getPara("classId"); // 班次id
			String sql0 = "select * from class_order where id=" + classId;
			Record list = Db.findFirst(sql0);
			if (list != null) {
				String sql = "SELECT c.banci_id,c.course_id,c.COURSE_NAME, " +
						" convert(CONCAT(IFNULL(b.count_course,0),' '),char) AS classinfo,IFNULL(b.count_course,0) AS yipai,c.lesson_num " +
						"FROM " +
						"(SELECT bc.banci_id,bc.course_id,c.COURSE_NAME,bc.lesson_num FROM banci_course bc " +
						"LEFT JOIN course c ON bc.course_id=c.Id " +
						"WHERE bc.banci_id=?) c " +
						"LEFT JOIN   " +
						"(SELECT " +
						"	a.COURSE_ID, " +
						"	course.COURSE_NAME, " +
						"	COUNT(*) AS count_course " +
						"FROM " +
						"( " +
						"		SELECT " +
						"			cp.COURSE_ID, " +
						"			DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d') courseDate, " +
						"			cp.TIMERANK_ID " +
						"		FROM " +
						"			courseplan cp " +
						"		WHERE " +
						"			cp.class_id = ? and cp.PLAN_TYPE=0  " +
						"		GROUP BY " +
						"			cp.COURSE_ID, " +
						"			DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d'), " +
						"			cp.TIMERANK_ID " +
						"	) AS a " +
						"INNER JOIN course ON course.Id = a.COURSE_ID " +
						"GROUP BY " +
						"	a.COURSE_ID " +
						") b " +
						"ON c.course_id=b.COURSE_ID";
				List<Record> record = Db.find(sql, classId,classId);//查询班次课程信息
				String sql3 = "SELECT " +
						"	banci_course.course_id, " +
						"	banci_course.lesson_num, " +
						"	banci_course.banci_id, " +
						"	class_order.classNum, " +
						"	class_type.`name`, " +
						"	class_order.lessonNum, " +
						"	class_order.teachTime, " +
						"  account_banci.account_id FROM " +
						"	banci_course " +
						"INNER JOIN account_banci ON banci_course.banci_id = account_banci.banci_id " +
						"INNER JOIN class_order ON account_banci.banci_id = class_order.id " +
						"INNER JOIN class_type ON class_order.classtype_id = class_type.id " +
						"WHERE " +
						"	banci_course.banci_id = ? " +
						"GROUP BY " +
						"	banci_course.course_id";
				Record record3 = Db.findFirst(sql3, classId);// 查询该班次的编号，班型名称，课时数,开课时间
				String class_name = record3.getStr("name");// 班型名称
				Integer banci_id = record3.getInt("banci_id");// 班次id
				String banci_name = record3.getStr("classNum");// 班次编号
				Integer lesson_num = record3.getInt("lessonNum");// 班次总课时
				Map<Object, Object> map = new HashMap<Object, Object>();
				Integer lessonUsedCount = 0;
				// 已经排课的总课时
				for (Record rec : record) {
					lessonUsedCount += rec.getLong("yipai").intValue();
				}
				String str = "";
				str += class_name + " 总节：" + lesson_num + " 已排：" + lessonUsedCount + " ";
				List<Object> courseList = new ArrayList<Object>();
				for (Record rec : record) {
					Map<Object, Object> map1 = new HashMap<Object, Object>();
					str += rec.getStr("COURSE_NAME") + "：" + rec.get("classinfo") + " ";
					map1.put("course_id", rec.get("course_id"));
					map1.put("course_name", rec.get("COURSE_NAME"));
					if(lesson_num != 0 && lesson_num == lessonUsedCount){
						map1.put("status", 0);
					}else{
						map1.put("status", 1);
					}
					courseList.add(map1);
				}
				map.put("courseList", courseList);
				map.put("courseUseNum", lessonUsedCount);
				map.put("banci_name", banci_name);
				map.put("stuMsg", str);
				map.put("studentId", record3.getInt("account_id"));
				map.put("banci_id", banci_id);
				map.put("sumCourse", lesson_num);
				map.put("useCourse", lessonUsedCount);
				renderJson("account", map);
			} else {
				renderJson("account", "noResult");
			}

		} catch (Exception ex) {
			logger.error(ex.toString());
		}

	}
	
	

	public void getTeacherByCourseId() {
		try {
			String courseId = getPara("courseId");
			String courseTime = getPara("courseTime");
			String timeRankId = getPara("timeRank");
			String youkeTeacherSql="SELECT cp.ID,cp.TEACHER_ID,cp.TIMERANK_ID,tr.RANK_NAME,cp.COURSE_ID FROM courseplan cp LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id WHERE cp.COURSE_TIME=? ";
			List<Record> youkeTeacherList = Db.find(youkeTeacherSql,courseTime);
			String teacherSql = "SELECT * FROM account t WHERE "
					+ "  LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role WHERE numbers = 'teachers'), CONCAT(',', t.roleids)) > 0"
					+ " AND state=0 AND t.CLASS_TYPE LIKE('%"+courseId+"%')";
			List<Account> teacherList = Account.dao.find(teacherSql);
			TimeRank timeRank = TimeRank.dao.findById(timeRankId);
			String timeNames[] = timeRank.getStr("RANK_NAME").split("-");
			int beginTime = Integer.parseInt(timeNames[0].replace(":", ""));
			int endTime = Integer.parseInt(timeNames[1].replace(":", ""));
			List<Account> canUseTeacherList = new ArrayList<Account>();
			for(Account a : teacherList){
				a.put("planId", null);
				String tId = a.getInt("id").toString();
				String courseIds[]=a.getStr("class_type").split("\\|");
				boolean hasCourse = false;
				for(String cid:courseIds){
					if(courseId.equals(cid)){
						hasCourse = true;
						break;
					}
				}
				if(!hasCourse){
					continue;
				}
				for(Record r : youkeTeacherList){
					String _tId = r.getInt("teacher_id").toString();
					if(tId.equals(_tId)){
						String rankName = r.getStr("rank_name");
						String rankTimes[] = rankName.split("-");
						int beginRankTime = Integer.parseInt(rankTimes[0].replace(":", ""));
						int endRankTime = Integer.parseInt(rankTimes[1].replace(":", ""));
						if ((beginTime >= beginRankTime && beginTime < endRankTime) || (endTime > beginRankTime && endTime <= endRankTime)) {
							a.put("planId", r.getInt("Id"));
							break;
						}
					}
				}
				canUseTeacherList.add(a);
			}
			renderJson("teacherList", canUseTeacherList);
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	public void updateUserPwd() {
		try {
			renderJsp("/account/pwd_manager.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	public void doUpdateUserPwd() {
		try {
			String accountId = getPara("accountId");
			String accountPwd = getPara("newPwd");
			String sql = "update account set user_pwd='" + ToolMD5.getMD5(accountPwd) + "' where id=" + accountId;
			Db.update(sql);
			renderJson(true);
		} catch (Exception ex) {
			logger.error("error",ex);
			renderJson(false);
		}
	}

	public void login() {
		try {
			String loginPath = Organization.getOrg().getStr("loginPath");
			if(StrKit.isBlank(loginPath)){
				renderJsp("/index.jsp");
				return;
			}
			renderJsp(loginPath);//自定义登录页
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	public void doLogin() {
		try {
			String email = getPara("email");
			String userPwd = getPara("userPwd");
			if(ToolUtils.CheckKeyWord(email==null ? "" : email.replaceAll(" ", ""))){
				login();
				return;
			}else{
				String sql = "select * from account where state=0 and email=? and user_pwd=? limit 1";
				Record account = Db.findFirst(sql, email, ToolMD5.getMD5(userPwd));
				if (account == null) {
					String parentssql = "select * from account where state=0 and parents_tel=? and user_pwd=? limit 1";
					account = Db.findFirst(parentssql, email, ToolMD5.getMD5(userPwd));
				}
				if (account == null) {
					login();
					return;
				} else {
					account.set("accountcampusids", AccountCampus.dao.getCampusIdsByAccountId(account.getInt("Id")));
					setSessionAttr("account_session", account);
					setSessionAttr("operator_session",ToolOperatorSession.operatorSessionSet(account.getInt("Id").toString()));
					if(ToolMonitor.whetherExpired(new Date())){
						logger.info("授权已过期");
						redirect("/company/expiration");
					}else{
						logger.info("授权有效");
						String roleids = account.getStr("roleids");
						if(Role.isTeacher(roleids)||Role.isStudent(roleids)||Role.isDudao(roleids)||Role.isJiaowu(roleids)){
							redirect("/course/courseSortListForMonth");
						}else{
							redirect("/main/index");
						}
					}
				}
			}
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	public void backMain() {
		
		setAttr("test1", "test1");
		renderJsp("/course/courseplan_month.jsp");
	}
	
	public void backTeacher() {
		setAttr("test2", "test2");
		renderJsp("/account/teacherlogin.jsp");
	}
	
	public void left(){
		setAttr("campusList", Campus.dao.getCampus());
		renderJsp("/common/left.jsp");
	}

	/**
	 * 根据email获取对象
	 */
	public void getAccountByEmailCount() {
		try {
			String email = getPara("email");
			String sql = "select * from account where state=0 and  email='" + email + "'";
			int count = Db.find(sql).size();
			renderJson("accountCount", count);
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	public void exit() {
		try {
			removeSessionAttr("account_session");
			redirect("/account/login");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	/**
	 * 我的学生
	 */
	public void myStudents() {
		try {
			Record account = getSessionAttr("account_session");
			String userName = getPara("userName");
			// 分页sql语句
			String page = getPara("page") != null ? getPara("page") : "0";
			// 要查询第几页
			int pagecount = Integer.parseInt(page) * 20;
			String sql = " SELECT distinct student.* ,c.teacher_id,IFNULL(a.xbzjs,0) xbzjs, " +
					" (SELECT COUNT(1) FROM courseplan cp WHERE cp.STUDENT_ID=student.id AND cp.class_id <> 0) xbyp, " +
					" (SELECT COUNT(1) FROM courseplan cp WHERE cp.STUDENT_ID=student.id AND (cp.class_id = 0 OR cp.class_id IS NULL)) yp  " +
					" FROM account student LEFT JOIN " +
					" (SELECT ab.account_id stu_id,SUM(co.lessonNum) xbzjs  " +
					" FROM account_banci ab LEFT JOIN class_order co " +
					" ON ab.banci_id=co.id GROUP BY ab.account_id) a " +
					" ON student.Id=a.stu_id left join courseplan c on c.student_id=student.Id "
					+ "WHERE student.state = 0 ";
			if(Role.isDudao(account.getStr("roleids"))){
				sql+= " and student.SUPERVISOR_ID=" + account.getInt("Id") + " ";
			}else if(Role.isTeacher(account.getStr("roleids"))){
				sql+= " and c.teacher_id=" + account.getInt("Id") + " ";
			}
			if(!ToolString.isNull(userName)){
				sql+=" and student.REAL_NAME like \"%"+userName+"%\"";
			}
			sql += " order by student.id desc LIMIT " + pagecount + ",20;";
			// 一共有多少条记录
			String sqlcount = "select count(*) as counts from account where state=0 and ";
			if(Role.isDudao(account.getStr("roleids")))
				sqlcount+= " SUPERVISOR_ID=" + account.getInt("Id");
			else if(Role.isTeacher(account.getStr("roleids")))
				sqlcount+= " Id in(select student_id from courseplan where teacher_id=" + account.getInt("Id") + ")";
			if(!ToolString.isNull(userName)){
				sqlcount+=" and REAL_NAME like \"%"+userName+"%\"";
			}
			List<Record> counts = Db.find(sqlcount);
			String count = counts.get(0).get("counts").toString();
			// 一共有多少页
			String pages = "";
			if ((Integer.parseInt(count) / 20) * 20 != Integer.parseInt(count)) {
				pages = (Integer.parseInt(count) / 20 + 1) + "";
			} else {
				pages = (Integer.parseInt(count) / 20) + "";
			}
			setAttr("pages", pages); // 总页数
			setAttr("count", count); // 总记录数
			setAttr("page", (Integer.parseInt(page) + 1)); // 查询的第几页
			setAttr("accountPage", Account.dao.find(sql));
			renderJsp("/account/account_list.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}
	
	/**
	 * 教师报表
	 */
	public void teacherReport() {
		try {
			String sql = "select account.id teacherid,account.real_name teacher_name,account.class_type,distable.* from account left join "
					+ "( "
					+ "select teacher_id,count(teacher_id) studentsum,coursenum+count(teacher_id)-1 coursenum, "
					+ "sum(readscore)/count(teacher_id) readscore, "
					+ "sum(listenscore)/count(teacher_id) listenscore, "
					+ "sum(speakscore)/count(teacher_id) speakscore, "
					+ "sum(writescore)/count(teacher_id)  writescore "
					+ "from ( "
					+ "select *,count(*) coursenum  from "
					+ "(select account.id teacher_id,account.class_type,courseplan.student_id  plan_student_id,courseplan.course_time from account left join courseplan on "
					+ "  account.id=courseplan.teacher_id  "
					+ " where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM 	pt_role WHERE numbers = 'teachers'), CONCAT(',', account.roleids) ) > 0 ) plan "
					+ "left join ( "
					+ "select student_id  fenshu_studdent_id,examscore.exam_time, "
					+ "(sum(read_score)/count(student_id)-read_score) readscore, "
					+ "(sum(listen_score)/count(student_id)-listen_score) listenscore, "
					+ "(sum(speak_score)/count(student_id)-speak_score) speakscore, "
					+ "(sum(write_score)/count(student_id)-write_score) writescore "
					+ "from (select student_id,read_score,listen_score,speak_score,write_score,exam_time from exam_score order by exam_time)  examscore  group by student_id "
					+ " )  fenshu   "
					+ "on plan_student_id=fenshu_studdent_id  where plan.course_time <=fenshu.exam_time group by teacher_id,plan_student_id  "
					+ ") zong where fenshu_studdent_id is not null   " + "group by teacher_id  "
					+ ") distable on account.id=distable.teacher_id where  "
					+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM 	pt_role WHERE numbers = 'dudao'), CONCAT(',', account.roleids) ) > 0";
			List<Record> list = Db.find(sql);
			setAttr("teacherReport", list);
			renderJsp("/account/teacher_report.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	/**
	 * 教师报表详情
	 */
	public void teacherReportInfo() {
		try {
			int teacherid = getParaToInt();
			String sql = "select distable.*,account.real_name studentname from( "
					+ "select *,count(*) coursenum  from "
					+ "(select account.id teacher_id,account.real_name teachername,account.class_type,courseplan.student_id  plan_student_id,courseplan.course_time from account left join courseplan on  account.id=courseplan.teacher_id  where courseplan.state=0 and account.id="
					+ teacherid
					+ ") plan "
					+ "left join  "
					+ "( "
					+ "select student_id  fenshu_studdent_id,examscore.exam_time, "
					+ "(sum(read_score)/count(student_id)-read_score) readscore, "
					+ "(sum(listen_score)/count(student_id)-listen_score) listenscore, "
					+ "(sum(speak_score)/count(student_id)-speak_score) speakscore, "
					+ "(sum(write_score)/count(student_id)-write_score) writescore "
					+ "from (select student_id,read_score,listen_score,speak_score,write_score,exam_time from exam_score order by exam_time)  examscore  group by student_id "
					+ " )  fenshu   "
					+ "on plan_student_id=fenshu_studdent_id  where plan.course_time <=fenshu.exam_time group by teacher_id,plan_student_id  "
					+ ")distable  left join account on distable.plan_student_id=account.id ";
			List<Record> list = Db.find(sql);
			setAttr("teacherReport", list);
			renderJsp("/account/report_info.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	/**
	 * 查询所有学员的记录   提供给单词系统的
	 */
	public void getStudentForWordSys() {
		String sql = "select account.id,account.real_name,account.tel,account.PARENTS_TEL,linshi.last_coursetime  from (select max(course_time) last_coursetime,student_id from  courseplan where courseplan.state=0  group by student_id asc) linshi left join  account on linshi.student_id=account.id";
		List<Record> list = Db.query(sql);
		renderJson("courses", list);
	}
	public void manageCourseInfo(){
		String accountId = getPara("accountId");
		Account account = Account.dao.findById(accountId);
		List<Subject> subjectList = Subject.dao.getSubject();
		if(!Role.isStudent(account.getStr("roleids"))){
			for(Subject s : subjectList){
				s.put("isChoose", "0");//未选择
				Integer sid = s.getInt("id");
				String canChooseCourseSql = "SELECT * FROM course c WHERE c.SUBJECT_ID =? ORDER BY c.SUBJECT_ID,c.ID";
				List<Course> courseList = Course.dao.find(canChooseCourseSql,sid);
				if(!ToolString.isNull(account.getStr("subject_id"))){
					String[] subjectids=account.getStr("subject_id").substring(1).split("\\|");
					for(String suid:subjectids){
						if(sid.toString().equals(suid)){
							s.put("isChoose", "1");//选择
							break;
						}
					}
				}
				if(!ToolString.isNull(account.getStr("class_type"))){
					String[] courseids = account.getStr("class_type").substring(1).split("\\|");
					for(Course c : courseList){
						c.put("isChoose", "0");
						String _cid = c.getInt("id").toString();
						for(String cid:courseids){
							if(_cid.equals(cid)){
								c.put("isChoose", "1");
								break;
							}
						}
					}
				}
				s.put("courseList", courseList);
			}
		}else{
			String userSubjectIdStr = "";
			List<UserCourse> userCourseList = UserCourse.dao.findByStudentId(accountId);
			String vipYipaiSql = "SELECT cp.COURSE_ID,COUNT(1) jieshu FROM courseplan cp LEFT JOIN course c ON cp.COURSE_ID=c.Id WHERE cp.PLAN_TYPE=0 and cp.class_id = 0 AND cp.STUDENT_ID=? GROUP BY cp.COURSE_ID ";
			List<Record> yipaiCourseList = Db.find(vipYipaiSql,accountId);
			String vipYishangShuSql = "SELECT COUNT(1) jieshu FROM courseplan cp LEFT JOIN course c ON cp.COURSE_ID=c.Id WHERE cp.PLAN_TYPE=0 and cp.class_id = 0 AND DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d')<=CURDATE() AND cp.STUDENT_ID=? ";
			Record vipYishangShuCourse = Db.findFirst(vipYishangShuSql,accountId);
			String vipYipaiShuSql = "SELECT COUNT(1) jieshu FROM courseplan cp LEFT JOIN course c ON cp.COURSE_ID=c.Id WHERE cp.PLAN_TYPE=0 and cp.class_id = 0 AND cp.STUDENT_ID=? ";
			Record vipYipaiShuCourse = Db.findFirst(vipYipaiShuSql,accountId);
			account.put("yishang", vipYishangShuCourse.getLong("jieshu"));
			account.put("yipai", vipYipaiShuCourse.getLong("jieshu"));
			String userUseSubjectSql = "SELECT c.SUBJECT_ID FROM courseplan cp LEFT JOIN course c ON cp.COURSE_ID=c.Id WHERE cp.PLAN_TYPE=0 AND cp.STUDENT_ID=? GROUP BY c.SUBJECT_ID";
			List<Record> userUseSubjectList = Db.find(userUseSubjectSql,accountId);
			List<UserCourse> userHaveSubjectList = UserCourse.dao.findHasSubjecByStudentId(accountId);
			boolean hasXiaoban = false;
			boolean hasVip = false;
			boolean xbCanChange = true;
			boolean vipCanChange = vipYipaiShuCourse.getLong("jieshu")==0?true:false;
			for(Subject subject : subjectList){
				subject.put("isChoose", "0");//未选择
				subject.put("canChange", "1");//可修改
				String subjectId = subject.getInt("id")+"";
				for(UserCourse u : userHaveSubjectList){//用户拥有的科目
					String _subjectId = u.getInt("subject_id")+"";
					if(subjectId.equals(_subjectId)){
						subject.put("isChoose", "1");//已选中
						userSubjectIdStr +=","+_subjectId;
						break;
					}
				}
				for(Record r : userUseSubjectList){//用户已用的科目
					String _useSubjectId = r.getInt("subject_id")+"";
					if(subjectId.equals(_useSubjectId)){
						subject.put("canChange", "0");//不可修改
					}
				}
				String canChooseCourseSql = "SELECT * FROM course c WHERE c.SUBJECT_ID =? ORDER BY c.SUBJECT_ID,c.ID";
				List<Course> courseList = Course.dao.find(canChooseCourseSql,subjectId);
				if(userCourseList.size()!=0||yipaiCourseList.size()!=0){
					hasVip = true;
					for(Course course:courseList){
						course.put("isChoose", "0");
						course.put("canChange", "1");
						String courseId = course.getInt("id")+"";
						for(UserCourse r:userCourseList){
							String _courseId = r.getInt("course_id")+"";
							if(courseId.equals(_courseId)){
								course.put("isChoose", "1");
								break;
							}
						}
						for(Record r : yipaiCourseList){
							String _courseId = r.getInt("course_id")+"";
							if(courseId.equals(_courseId)){
								course.put("canChange", "0");
								course.put("jieshu", r.getLong("jieshu"));
								break;
							}
							
						}
					}
				}
				subject.put("courseList", courseList);
			}
			String useXiaobanSql = "SELECT cp.class_id , COUNT(1) jieshu FROM courseplan cp LEFT JOIN course c ON cp.COURSE_ID=c.Id WHERE cp.PLAN_TYPE=0 and cp.class_id != 0 AND cp.STUDENT_ID=? GROUP BY cp.class_id ";
			List<Record> useXiaobanList = Db.find(useXiaobanSql,accountId);
			List<ClassOrder> banciList = ClassOrder.dao.queryBanciByStudentId(accountId, userSubjectIdStr);
			List<AccountBanci> accountBanciList = AccountBanci.dao.find("SELECT * FROM account_banci WHERE state=0 and account_id = ?",accountId);
			if(accountBanciList.size()!=0&&useXiaobanList.size()!=0){//有小班
				hasXiaoban = true;
				for(AccountBanci ab : accountBanciList){
					boolean nohas = true;
					String _banciId = ab.getInt("banci_id")+"";
					for(ClassOrder banci: banciList){
						String xbId = banci.getInt("id")+"";
						if(_banciId.equals(xbId)){
							banci.put("isChoose", "1");
							banci.put("canChange", "1");
							nohas = false;
							break;
						}
					}
					if(nohas){
						banciList.add(ClassOrder.dao.findById(Integer.parseInt(_banciId)).put("isChoose", "1").put("canChange", "1"));
					}
				}
				for(Record r : useXiaobanList){
					String _banciId = r.getInt("class_id")+"";
					if(!"0".equals(_banciId)){
						boolean nohas = true;
						for(ClassOrder banci: banciList){
							String xbId = banci.getInt("id")+"";
							if(_banciId.equals(xbId)){
								String yishangXiaobanSql = "SELECT COUNT(1) jieshu FROM courseplan cp WHERE date_format(cp.course_time,'%Y-%m-%d')<=CURDATE() and cp.PLAN_TYPE=0 and cp.class_id = ? and cp.student_id=?";
								String quanbuXiaobanSql = "SELECT COUNT(1) jieshu FROM courseplan cp WHERE cp.PLAN_TYPE=0 and cp.class_id = ? and cp.student_id=?";
								long yishangxb = Db.queryLong(yishangXiaobanSql,xbId,accountId);
								long quanbuxb = Db.queryLong(quanbuXiaobanSql,xbId,accountId);
								banci.put("isChoose", "0");
								for(AccountBanci ab : accountBanciList){
									if(_banciId.equals(ab.getInt("banci_id").toString())){
										banci.put("isChoose", "1");
										break;
									}
								}
								if(yishangxb==quanbuxb){
									banci.put("canChange", "0");
									xbCanChange=false;
								}else{
									banci.put("canChange", "1");
								}
								banci.put("jieshu", r.getLong("jieshu"));
								banci.put("yishangxb", yishangxb);
								nohas = false;
								break;
							}
						}
						if(nohas){
							banciList.add(ClassOrder.dao.findById(Integer.parseInt(_banciId)).put("isChoose", "1").put("canChange", "0").put("jieshu", r.getLong("jieshu")));
						}
					}
				}
			}
			setAttr("xiaobanList", banciList);
			setAttr("xbCanChange", xbCanChange);
			setAttr("vipCanChange", vipCanChange);
			setAttr("hasVip", hasVip);
			setAttr("hasXiaoban", hasXiaoban);
		}
		setAttr("account", account);
		setAttr("subjectList", subjectList);
		renderJsp("/account/account_course.jsp");
	}
	
	/**
	 * 验证电话号码
	 */
	public void checkPhoneNumber() {
		String phoneNumber = getPara("phoneNumber");
		String accountId = getPara("accountId");
		String checkType = getPara("checkType");
		StringBuffer sql = new StringBuffer("select count(1) from account where 1=1 ");
		if(!ToolString.isNull(phoneNumber)){
			if(!ToolString.isNull(accountId)){
				sql.append(" and id != "+accountId);
			}
			if("parent".equals(checkType)){
				sql.append(" and PARENTS_TEL="+phoneNumber);
			}else{
				sql.append(" and TEL="+phoneNumber);
			}
			Long count = Db.queryLong(sql.toString());
			renderJson("result",count);
		}else{
			renderJson("result",null);
		}
	}
	/**
	 * 验证邮箱
	 */
	public void checkEmail() {
		String email = getPara("email");
		String accountId = getPara("accountId");
		String checkType = getPara("checkType");
		StringBuffer sql = new StringBuffer("select count(1) from account where 1=1 ");
		if(!ToolString.isNull(email)){
			if(!ToolString.isNull(accountId)){
				sql.append(" and id != "+accountId);
			}
			if("parent".equals(checkType)){
				sql.append(" and PARENTS_EMAIL='"+email+"'");
			}else{
				sql.append(" and EMAIL='"+email+"'");
			}
			Long count = Db.queryLong(sql.toString());
			renderJson("result",count);
		}else{
			renderJson("result",null);
		}
	}
	/**
	 * 验证QQ
	 */
	public void checkQQ() {
		String qq = getPara("qq");
		String accountId = getPara("accountId");
		String checkType = getPara("checkType");
		StringBuffer sql = new StringBuffer("select count(1) from account where 1=1 ");
		if(!ToolString.isNull(qq)){
			if(!ToolString.isNull(accountId)){
				sql.append(" and id != "+accountId);
			}
			if("parent".equals(checkType)){
				sql.append(" and PARENTS_QQ='"+qq+"'");
			}else{
				sql.append(" and qq='"+qq+"'");
			}
			Long count = Db.queryLong(sql.toString());
			renderJson("result",count);
		}else{
			renderJson("result",null);
		}
	}
	/**
	 * 验证真实姓名
	 */
	public void checkRealName() {
		String realName = getPara("realName");
		String accountId = getPara("accountId");
		StringBuffer sql = new StringBuffer("select count(1) from account where 1=1 ");
		if(!ToolString.isNull(realName)){
			if(!ToolString.isNull(accountId)){
				sql.append(" and id != "+accountId);
			}
			sql.append(" and real_name='"+realName+"'");
			Long count = Db.queryLong(sql.toString());
			renderJson("result",count);
		}else{
			renderJson("result",null);
		}
	}
	/**
	 * 验证用户名
	 */
	public void checkUserName() {
		String userName = getPara("userName");
		String accountId = getPara("accountId");
		StringBuffer sql = new StringBuffer("select count(1) from account where 1=1 ");
		if(!ToolString.isNull(userName)){
			if(!ToolString.isNull(accountId)){
				sql.append(" and id != "+accountId);
			}
			sql.append(" and user_name='"+userName+"'");
			Long count = Db.queryLong(sql.toString());
			renderJson("result",count);
		}else{
			renderJson("result",null);
		}
	}
	
	
	/**
	 * 教务统计报表----->教师
	 */
	public void teachertongjilog() {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			Record loginAccount = getSessionAttr("account_session");// 当前登陆用户
			String queryType = getPara("queryType");// 0:本月，1：上月，2：下月
			String queryStarTtime = getPara("startTime");
			String queryEndTime = getPara("endTime");
			String teacherId = getPara("teacherId");
			String starttime = "";
			String endtime = "";
			if ("0".equals(queryType) || (ToolString.isNull(queryStarTtime) && ToolString.isNull(queryEndTime))) {// 本月
				starttime = ToolDateTime.getMonthFirstDayYMD(new Date());
				endtime = ToolDateTime.getSingleNumDate(new Date());
			} else if ("1".equals(queryType)) {// 上月
				starttime = ToolDateTime.getMonthFirstDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), -1));
				endtime = ToolDateTime.getMonthLastDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), -1));
			} else if ("2".equals(queryType)) {// 下月
				starttime = ToolDateTime.getMonthFirstDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), 1));
				endtime = ToolDateTime.getMonthLastDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), 1));
			} else {
				starttime = ToolString.isNull(queryStarTtime) ? ToolDateTime.getMonthFirstDayYMD(new Date()) : queryStarTtime;
				endtime = ToolString.isNull(queryEndTime) ? ToolDateTime.getMonthFirstDayYMD(new Date()) : queryEndTime;
			}
			if (loginAccount.getStr("roleids").equals("2,")) {
				teacherId = getSysuserId().toString();
			}
			List<CoursePlan> teacherlist = CoursePlan.coursePlan.getStatTeacherPlan(starttime,endtime,teacherId, getAccountCampus());
			map.put("list", teacherlist);
			long sumkecheng=0;
			float sumkeshi=0;
			for(CoursePlan sum:teacherlist){
				if(sum.get("kecheng")!=null){
					sumkecheng+=sum.getLong("kecheng");
				}
				if(sum.get("keshi")!=null){
					sumkeshi+=sum.getBigDecimal("keshi").floatValue();
				}
			}
			map.put("sumkecheng", sumkecheng);
			map.put("sumkeshi", sumkeshi);
			map.put("startTime", starttime);
			map.put("endTime", endtime);	
			renderJson(map);
		} catch (Exception ex) {
			ex.printStackTrace();
			logger.error(ex.toString());
		}
	}

	/**
	 * 教务统计报表----->学生
	 */
	public void studenttongjilog() {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			Record loginAccount = getSessionAttr("account_session");// 当前登陆用户
			String loginUserId = loginAccount.getInt("ID").toString();
			String campusid = getPara("campusid");
			String queryType = getPara("queryType");// 0:本月，1：上月，2：下月
			String queryStarTtime = getPara("startTime");
			String queryEndTime = getPara("endTime");
			String queryStudentName = getPara("studentName");
			String starttime = "";
			String endtime = "";
			if ("0".equals(queryType) || (ToolString.isNull(queryStarTtime) && ToolString.isNull(queryEndTime))) {// 本月
				starttime = ToolDateTime.getMonthFirstDayYMD(new Date());
				endtime = ToolDateTime.getSingleNumDate(new Date());
			} else if ("1".equals(queryType)) {// 上月
				starttime = ToolDateTime.getMonthFirstDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), -1));
				endtime = ToolDateTime.getMonthLastDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), -1));
			} else if ("2".equals(queryType)) {// 下月
				starttime = ToolDateTime.getMonthFirstDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), 1));
				endtime = ToolDateTime.getMonthLastDayYMD(ToolDateTime.getInternalDateByMon(ToolDateTime.getDate(queryStarTtime + " 00:00:00"), 1));
			} else {
				starttime = ToolString.isNull(queryStarTtime) ? ToolDateTime.getMonthFirstDayYMD(new Date()) : queryStarTtime;
				endtime = ToolString.isNull(queryEndTime) ? ToolDateTime.getMonthFirstDayYMD(new Date()) : queryEndTime;
			}
			String  condition ="";
			if (Role.isStudent(loginAccount.getStr("roleids"))) {
				condition += " AND s.id=" + loginUserId;
			}else{
				if(Role.isDudao(loginAccount.getStr("roleids"))&&loginAccount.getStr("roleids").equals("5,")){
					condition += " AND s.SUPERVISOR_ID=" + loginUserId;
				} else if(Role.isKcgw(loginAccount.getStr("roleids"))){
					
				}else if(Role.isTeacher(loginAccount.getStr("roleids"))&&"2,".equals(loginAccount.getStr("roleids"))){
					condition += " AND cp.teacher_id=" + loginUserId;
				}
				if(!StringUtils.isEmpty(campusid)){
					condition += " and cp.campus_id = "+ campusid;
				}else{
					condition += " AND cp.campus_id in (SELECT  ac.campus_id from account_campus ac WHERE ac.account_id=" + loginUserId+")";
				}
			}
			if(!StringUtils.isEmpty(queryStudentName)){
				condition += " and  s.REAL_NAME = '"+ queryStudentName +"'";
			}
			String sql="SELECT COUNT(1) kecheng,sum(a.class_hour) keshi,sum(if(a.TEACHER_PINGLUN='y',1,0)) TPINGLUN,a.* FROM "
					+ " ( ( SELECT s.REAL_NAME SNAME, cp.class_hour,cp.CAMPUS_NAME, s.id sid,cp.TEACHER_PINGLUN " +
					"FROM teachergrade tg  " +
					"LEFT JOIN account s ON tg.studentid=s.Id " +
					"LEFT JOIN (SELECT p.Id,p.teacher_id,p.TEACHER_PINGLUN,p.class_id,p.CAMPUS_ID,c.CAMPUS_NAME,p.COURSE_TIME,t.class_hour,p.PLAN_TYPE FROM courseplan p LEFT JOIN time_rank t ON p.TIMERANK_ID=t.Id LEFT JOIN campus c ON p.CAMPUS_ID=c.Id) cp ON tg.COURSEPLAN_ID=cp.Id " +
					"WHERE cp.class_id!=0 AND s.STATE!=2 and cp.PLAN_TYPE=0 "
					+ condition
					+ " and cp.COURSE_TIME>='"
					+starttime
					+ "' and cp.COURSE_TIME<='"
					+endtime
					+ "' ) "
					+ " UNION ALL "
					+ " ( SELECT s.REAL_NAME SNAME, tr.class_hour, campus.CAMPUS_NAME,s.id sid,cp.TEACHER_PINGLUN "
					+ " FROM courseplan cp "
					+ " LEFT JOIN account s ON cp.STUDENT_ID = s.Id "
					+ " LEFT JOIN time_rank tr ON cp.TIMERANK_ID = tr.Id "
					+ " LEFT JOIN campus ON cp.CAMPUS_ID = campus.Id "
					+ " WHERE cp.STATE = 0 AND cp.class_id = 0 and cp.PLAN_TYPE=0 "
					+ condition
					+ " and cp.COURSE_TIME>='"
					+starttime
					+ "' and cp.COURSE_TIME<='"
					+endtime
					+ "') ) a "
					+ " GROUP  BY a.SNAME DESC";
			List<Record> list = Db.find(sql);
			map.put("list", list);
			int sumkecheng=0;
			float sumkeshi=0;
			for(Record sum:list){
				if(sum.get("kecheng")!=null){
					sumkecheng+=Integer.parseInt(sum.get("kecheng").toString());
				}
				if(sum.get("keshi")!=null){
					sumkeshi+=Float.parseFloat(sum.get("keshi").toString());
				}
			}
			map.put("sumkecheng", sumkecheng);
			map.put("sumkeshi", sumkeshi);
			map.put("startTime", starttime);
			map.put("endTime", endtime);
			List<Campus> campus = Campus.dao.getCampusByLoginUser(Integer.parseInt(loginUserId));
			map.put("campuslist", campus);
			map.put("qcampusid", campusid);
		
			renderJson(map);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	/**
	 * 获得学生的信息
	 * */
	public void getStudentMessage() {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			String studentId = getPara("studentId");
			if (ToolString.isNull(studentId)) {
				map.put("errorMessage", "还没有学生的相关数据，小班请关联学生！");
			} else {
				Student student = Student.dao.findById(Integer.parseInt(studentId));
				List<GradeRecord> gradeList = GradeRecord.dao.findByStudentId(studentId);
				List<GradeRecord> pqList = new ArrayList<GradeRecord>();
				List<GradeRecord> phList = new ArrayList<GradeRecord>();
				for(GradeRecord gradeRecord : gradeList){
					List<GradeDetail> detailList = GradeDetail.dao.findbyRecordId(gradeRecord.getPrimaryKeyValue().toString());
					gradeRecord.put("detail", detailList);
					if(gradeRecord.getBoolean("scoretype")){//培训后分数
						phList.add(gradeRecord);
					}else{//培训前分数
						pqList.add(gradeRecord);
					}
				}
				map.put("pqList", pqList);
				map.put("phList", phList);
				map.put("remark", student.getStr("INTRO"));
			}
			renderJson(map);
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
	}
	
	public void queryStudentInfo() {
		try {
			Integer studentId = getParaToInt();
			Student student = Student.dao.showStudentDetail(studentId.toString());
			setAttr("student",student);
			List<GradeRecord> gradeList = GradeRecord.dao.findByStudentId(studentId.toString());
			List<GradeRecord> pqList = new ArrayList<GradeRecord>();
			List<GradeRecord> phList = new ArrayList<GradeRecord>();
			for(GradeRecord gradeRecord : gradeList){
				List<GradeDetail> detailList = GradeDetail.dao.findbyRecordId(gradeRecord.getPrimaryKeyValue().toString());
				gradeRecord.put("detail", detailList);
				if(gradeRecord.getBoolean("scoretype")){//培训后分数
					phList.add(gradeRecord);
				}else{
					pqList.add(gradeRecord);
				}
			}
			double sumClassHour=0;
			int courseCount=0;
			List<CoursePlan> coursePlanList = CoursePlan.coursePlan.queryStudentCourseInfo(studentId);
			if(coursePlanList !=null && coursePlanList.size()>0){
				courseCount = coursePlanList.size();
				for(CoursePlan coursePlan:coursePlanList){
					String weekname = ToolDateTime.getDateInWeek(coursePlan.getDate("course_time"),1);
					coursePlan.put("weekname", weekname);
					sumClassHour +=coursePlan.getBigDecimal("classhour")==null?0:coursePlan.getBigDecimal("classhour").doubleValue();
				}
			}
			setAttr("courseCount", courseCount);
			setAttr("sumClassHour",sumClassHour);
			setAttr("coursePlanList",coursePlanList);
			setAttr("pqList", pqList);
			setAttr("phList", phList);
			renderJsp("/account/student_manager.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 查看学员排课列表
	 */
	public void queryStudentCourseInfo(){
		Integer stuId = getParaToInt();
		List<CoursePlan> list = CoursePlan.coursePlan.queryStudentCourseInfo(stuId);
		if(list!=null&&list.size()>0){
			for(CoursePlan cp:list){
				String weekname = ToolDateTime.getDateInWeek(cp.getDate("course_time"),1);
				cp.put("weekname", weekname);
			}
			setAttr("has","yes");
		}else{
			setAttr("has","no");
		}
		setAttr("list",list);
		renderJsp("/account/layer_studentcourseinfo.jsp");
	}
	
	/**
	 * 跳转预存/定金收取界面
	 */
	public void toPayFrontMoney(){
		String accountId = getPara();
		Account account = Account.dao.findById(Integer.parseInt(accountId));
		List<AccountBook> accountBookList = AccountBook.dao.getByOperateType(accountId,Constants.ACCOUNT_FRONT_MONEY);
		setAttr("account", account);
		setAttr("accountBookList",accountBookList);
		render("/finance/frontmoney_form.jsp");
	}
	
	@Before(Tx.class)
	public void payFrontMoney(){
		AccountBook accountBook = getModel(AccountBook.class);
		Map<String, String> result = AccountService.me.accountManage(Constants.ACCOUNT_FRONT_MONEY, accountBook.getInt("accountid").toString(), null, null, getSysuserId().toString(), accountBook.getBigDecimal("temprealamount").doubleValue() ,null, null);
		renderJson(result);		
	}
}
