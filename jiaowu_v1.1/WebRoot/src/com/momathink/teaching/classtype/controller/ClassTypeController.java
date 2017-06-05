
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

package com.momathink.teaching.classtype.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.base.Util;
import com.momathink.common.interceptor.renderJsonInterceptor;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolMD5;
import com.momathink.common.tools.ToolString;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.account.model.BanciCourse;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.classtype.model.ClassType;
import com.momathink.teaching.classtype.service.ClassOrderService;
import com.momathink.teaching.classtype.service.ClassTypeService;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;
import com.momathink.teaching.teacher.model.Teachergrade;

/***
 * 班型班次管理
 */
@Controller(controllerKey = "/classtype")
public class ClassTypeController extends BaseController {

	private static final Logger logger = Logger.getLogger(ClassTypeController.class);

	// 班型管理分页
	public void index() {
		String loginRoleCampusIds = getAccountCampus();
		Map<String, String> queryParam = splitPage.getQueryParam();
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			queryParam.put( "loginRoleCampusIds", loginRoleCampusIds);
		}
		ClassTypeService.me.list(splitPage);
		//查询当前登录角色所属的校区
		setAttr( "userCampus", Campus.dao.getCampusByLoginUser( Integer.parseInt( getAccount().get("id")+"" ) ) );
		setAttr("showPages", splitPage.getPage());
		List<Subject> subject = Subject.dao.getSubject();
		setAttr("subject", subject);
		renderJsp("/classes/findClassType.jsp");
	}

	/**
	 * 班次列表 
	 * @author David
	 */
	public void findClassOrder() {
		try {
			Map<String, String> queryParam = splitPage.getQueryParam();
			Record sysuser = getAccount();
			String sysuserid = sysuser.get("id")+"";
			String roleids = sysuser.getStr("roleids");
			if(Role.isTeacher(roleids)){
				queryParam.put("teacherid", sysuserid);
			}
			
			String loginRoleCampusIds = getAccountCampus();
			//添加角色约束
			if( !StringUtils.isEmpty( loginRoleCampusIds )){
				queryParam.put( "loginRoleCampusIds", loginRoleCampusIds );
			}
			
			ClassOrderService.me.list(splitPage );
			setAttr("showPages", splitPage.getPage());
			List<Subject> subject = Subject.dao.getSubject();
			if( Role.isAdmins(sysuserid) ){
				List<SysUser> userlist = SysUser.dao.getKcuserid();
				setAttr("userlist", userlist);
			}else{
				List<SysUser> userlist = SysUser.dao.getKechengguwenCampus(loginRoleCampusIds);
				setAttr("userlist", userlist);
			}
			List<ClassType> classTypeList = ClassType.dao.getClassType();
			
			//查询当前登录角色所属的校区
			setAttr( "userCampus", Campus.dao.getCampusByLoginUser( Integer.parseInt( sysuserid ) ) );
			setAttr("subject", subject);
			
			setAttr("classTypeList", classTypeList);
			renderJsp("/classes/findClassOrder.jsp");
		} catch (Exception e) {
			logger.info("findClassOrderException", e);
			e.printStackTrace();
		}
	}

	public void editClassType() {
		String[] str = getPara().split(",");//[100, 2]
		String type_id = str[0];// 班型id 100
		Integer type = Integer.parseInt(str[1]);// 方式，2为修改班型  2
		if (StrKit.notBlank(type_id)) {
			ClassType classType = ClassType.dao.findById(type_id);
			List<Record> record = ClassType.dao.getClassTypeByTypeId(type_id);
			    setAttr("classType", classType);
				setAttr("type", type);
				setAttr("name",classType.getStr("name"));
				setAttr("id", classType.get("id"));
				setAttr("lesson_count", classType.get("lesson_count"));
				setAttr("subject_id",classType.get("subject_id"));
				setAttr( "campusid", classType.getInt( "campusid" ));
				List<Integer> list = new ArrayList<Integer>();
				for (Record rec : record) {
					list.add(rec.getInt("course_id"));
				}
		}
		List<Subject> subject = Subject.dao.getSubject();
		setAttr("subject", subject);
		setAttr( "campusList", Campus.dao.getCampusByLoginUser( getSysuserId() ));
		renderJsp("/classes/layer_addClassType.jsp");
	}

	public void doAddClassType() {
		JSONObject json = new JSONObject();
		String type = getPara("type"); // 方式，2为修改
		String id = getPara("id"); // 班型id
		String subids = getPara("subids");
		subids = subids.replaceAll(",", "\\|");
		Integer[] course_id = getParaValuesToInt("course_id"); // 课程id
		Integer lesson_count = getParaToInt("lesson_count"); // 课时总数
		String name = getPara("name"); // 班型名称
		ClassType classType = ClassType.getClassName(name); // 查询班型信息
		String campusId = getPara( "classTypeCampus" );
		//如果不选择校区,则设置校区ID为空,否则插入数据库出错
		if( campusId == "" ){
			campusId = null;
		}
		try {
			if (classType == null) { // 如果为空
				if ("2".equals(type) && id != "" && id != null && !"0".equals(id)) { // 如果值为2则更新原有班型
					ClassType.dao.findById(id).set("name", name).set("lesson_count", lesson_count).set("subjectids", subids).set( "campusid", campusId).update();
					ClassType.dao.deleteBanciCourse(id);
					for (int i = 0; i < course_id.length; i++) {
						Record record = ClassType.dao.findRecordCourse(course_id[i]);
						new BanciCourse().set("subject_id", record.getInt("SUBJECT_ID")).set("course_id", record.getInt("Id")).set("type_id", id).save();
					}
				} else {
					new ClassType().set("name", name).set("lesson_count", lesson_count).set("subjectids", subids).set( "campusid", campusId).save();
					for (int i = 0; i < course_id.length; i++) {
						Record record = ClassType.dao.findRecordCourse(course_id[i]);
						Integer type_id = ClassType.dao.getClassTypeIdByName(name);
						new BanciCourse().set("subject_id", record.getInt("SUBJECT_ID")).set("course_id", record.getInt("Id")).set("type_id", type_id).save();
					}
				}
			} else { // 如果不为空则更新班型
				ClassType.dao.findById(classType.getInt("id")).set("NAME", name).set("lesson_count", lesson_count).set( "campusid",  campusId ).set("subjectids", subids).update();
				Integer type_id = ClassType.dao.getClassTypeIdByName(name);
				ClassType.dao.deleteBanciCourse(type_id.toString());
				for (int i = 0; i < course_id.length; i++) {
					Record record = ClassType.dao.findRecordCourse(course_id[i]);
					new BanciCourse().set("subject_id", record.getInt("SUBJECT_ID")).set("course_id", record.getInt("Id")).set("type_id", type_id).save();
				}
			}
			json.put("code", 1);
			json.put("msg", "保存成功");
		} catch (Exception e) {
			e.printStackTrace();
			json.put("code", 0);
			json.put("msg", "保存失败！");
		}
		renderJson(json);
	}

	public void editClassTypeForJson() {
		String type_id = getPara("id");// 班型id
		List<Record> record = ClassType.dao.getClassTypeByTypeId(type_id);
		renderJson("courseJson", record);
	}

	public void getClassName() {
		String name = getPara("name");
		List<Record> record = ClassType.dao.getRecordClasstypeName(name);
		renderJson("className", record);
	}

	public void getClassNameByLike() {
		String name = getPara("name");
		List<ClassType> list = ClassType.dao.getClassNameByLike(name);
		renderJson("className", list);
	}

	public void editClassTypeForJson2() {
		String type_id = getPara("type_id");// 班型id
		List<Record> record = ClassType.dao.getClassTypeForJson(type_id);
		renderJson("record", record);
	}

	public void addClassType() {
		List<Campus> campusList = Campus.dao.getCampusByLoginUser(getSysuserId());
		List<Subject> subject = Subject.dao.getSubject();
		setAttr( "campusList", campusList );
		setAttr("subject", subject);
		renderJsp("/classes/layer_addClassType.jsp");
	}

	public void editClassOrder() {
		Integer classid = getParaToInt();
		if (classid == null) {
			classid = getParaToInt("classid");
		}
		ClassOrder classOrder = ClassOrder.dao.findById(classid);
		Integer classtype_id = classOrder.getInt("classtype_id");// 班型id
		List<Campus> campusList = Campus.dao.getCampusByLoginUser(getSysuserId());
		setAttr("campusList", campusList);
		List<ClassType> classTypeList = ClassType.dao.getClassType();
		List<BanciCourse> banciCourseList = BanciCourse.dao.getCourseList(classtype_id,classid);
		List<SysUser> kcgwList = SysUser.dao.getKechengguwenCampus(classOrder.getInt("campusId")+"");//课程顾问
		setAttr("kcgwList", kcgwList);
		setAttr("classOrder", classOrder);
		setAttr("classTypeList", classTypeList);
		setAttr("banciCourseList", banciCourseList);
		setAttr("orderid", classOrder.getInt("id"));
		setAttr("classNum", classOrder.getStr("classNum"));
		setAttr("editname", classOrder.getStr("classNum"));
		setAttr("class_type", classOrder.get("classtype_id"));// 班型id
		setAttr("stuNum", classOrder.get("stuNum"));
		setAttr("totalfee", classOrder.get("totalfee"));
		setAttr("teachTime", classOrder.get("teachTime"));
		setAttr("isassesment", classOrder.get("is_assesment"));
		renderJsp("/classes/layer_ClassOrderForm.jsp");
	}

	public void getCourseListByClassType() {
		Integer type_id = getParaToInt("type_id");
		List<Record> record = ClassType.dao.getCourseListByClassType(type_id);
		renderJson("record", record);
	}

	public void getCourseListByClassType2() {
		String class_num = getPara("class_num");// 班次编号
		Record classRecord = ClassType.dao.getClassOrderbyclassnum(class_num);
		if (classRecord == null) {
			renderJson("record", null);
		} else {
			Integer banci_id = classRecord.getInt("id");// 班次id
			List<Record> record = ClassType.dao.getCourseListByClassType2(banci_id);
			renderJson("record", record);
		}
	}

	public void stuCount() {
		String class_num = getPara("class_num");
		Long stuCount = ClassType.dao.getStuCount(class_num);
		renderText(stuCount.toString());
	}

	public void verifyUsedCourse() {
		try {
			Integer classOrderId = getParaToInt("classOrderId");// 班次编号
			Integer courseId = getParaToInt("course_id");
			float used = CoursePlan.coursePlan.getClassYpkcClasshour(classOrderId, courseId);
			renderJson("plancount", used);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	public void addClassOrder() {
		List<ClassType> classTypeList =  ClassType.dao.getClassTypekeyong( getAccountCampus());
		String maxIndex = ClassOrder.getMaxIndex();
		List<Campus> campusList = Campus.dao.getCampusByLoginUser( getSysuserId() );
		setAttr("campusList", campusList);
		setAttr("classNum", maxIndex);
		setAttr("classTypeList", classTypeList);
		setAttr("addorder", 1);
		renderJsp("/classes/layer_ClassOrderForm.jsp");
	}

	public void doAddClassOrder() {
		JSONObject json = new JSONObject();
		ClassOrder classOrder = getModel(ClassOrder.class);
		Integer[] course_id = getParaValuesToInt("course_id");// 班次课程表的id
		Integer[] keshi = getParaValuesToInt("keshi");// 课时
		Role role = Role.dao.getRoleByNumbers("student");
		try {
			if (!ToolString.isNull(classOrder.getInt("id")+"")) {// 班次已存在则更新
				ClassOrder oldClassOrder = ClassOrder.dao.findById(classOrder.getInt("id"));
				if(oldClassOrder != null){
					Record ypkrecord = ClassType.dao.getYPKRecord(oldClassOrder.getInt("id"));
					float useCount = CoursePlan.coursePlan.getClassYpkcClasshour(classOrder.getInt("id"));
					int zks = classOrder.getInt("lessonNum");
					if (useCount==zks) {
						classOrder.set("endTime", ypkrecord.get("kctime"));
					}else{
						classOrder.set("endTime", null);
					}
					classOrder.update();
					// 先删除后添加
					ClassType.dao.deleteBanciCourseId(classOrder.getInt("ID"));
					String[] sub_id = new String[course_id.length];
					String[] cur_id = new String[course_id.length];
					for (int i = 0; i < course_id.length; i++) {// 更新班次课程表
						BanciCourse newBanciCourse = new BanciCourse();
						Course course = Course.dao.findById(course_id[i]);
						newBanciCourse.set("subject_id", course.getInt("SUBJECT_ID"));
						newBanciCourse.set("course_id", course_id[i]);
						newBanciCourse.set("lesson_num", keshi[i]);
						newBanciCourse.set("type_id", classOrder.getInt("classtype_id"));
						newBanciCourse.set("banci_id", classOrder.getInt("ID"));
						newBanciCourse.save();
						sub_id[i] = course.getInt("subject_id").toString();
						cur_id[i] = course_id[i].toString();
					}
					// 更新添加班次时的操作
					// 添加班次的同时添加一个学生用于排课
					if (course_id != null && course_id.length > 0) {
						Account account = Account.dao.findById(oldClassOrder.getInt("accountid"));
						if (account != null) { // 如果不为空则更新
							account.set("SUBJECT_ID", Util.printArray(sub_id));
							account.set("campusid", classOrder.getInt("campusId"));
							account.set("CLASS_TYPE", Util.printArray(cur_id));
							account.set("REAL_NAME", classOrder.get("classNum"));
							account.set("EMAIL", classOrder.get("classNum"));
							account.set("USER_NAME", classOrder.get("classNum"));
							account.set("UPDATE_TIME", new Date());
							account.set("COURSE_SUM", classOrder.get("lessonNum"));
							account.set("roleids", role.getInt("id") + ",").set("user_type", 1);
							account.update();
						} else { // 为空则添加
							account = new Account();
							account.set("EMAIL", classOrder.getStr("classNum")).set("REAL_NAME", classOrder.getStr("classNum"))
									.set("REAL_NAME", classOrder.getStr("classNum")).set("campusid", classOrder.getInt("campusId"))
									.set("SUBJECT_ID", Util.printArray(sub_id)).set("CLASS_TYPE", Util.printArray(cur_id)).set("USER_PWD", ToolMD5.getMD5(Organization.dao.getTchLnitialPassword()))
									.set("CREATE_TIME", new Date()).set("UPDATE_TIME", new Date()).set("STATE", 2).set("COURSE_SUM", classOrder.getInt("lessonNum"))
									.set("groupids", role.getInt("id") + ",").set("user_type", 1).save();
							// 取得添加用户的id
							new AccountBanci().set("account_id", account.getInt("Id")).set("banci_id", classOrder.getInt("id")).save();
							Db.update("UPDATE class_order o LEFT JOIN account a ON o.classNum=a.REAL_NAME SET o.accountid=a.Id");
						}
					}
					ClassOrder.dao.updateTeachTime(classOrder.getInt("id"));
				}else{
					json.put("code", 0);
					json.put("msg", "小班不存在");
				}
			} else {// 班次不存在则添加
				classOrder.save();
				String[] sub_id = new String[course_id.length];
				String[] cur_id = new String[course_id.length];
				for (int i = 0; i < course_id.length; i++) {
					BanciCourse newBanciCourse = new BanciCourse();
					Course course = Course.dao.findById(course_id[i]);
					newBanciCourse.set("subject_id", course.getInt("SUBJECT_ID"));
					newBanciCourse.set("course_id", course_id[i]);
					newBanciCourse.set("lesson_num", keshi[i]);
					newBanciCourse.set("type_id", classOrder.getInt("classtype_id"));
					newBanciCourse.set("banci_id", classOrder.getInt("ID"));
					newBanciCourse.save();
					sub_id[i] = course.getInt("subject_id").toString();
					cur_id[i] = course_id[i].toString();
				}
				// 添加班次的同时添加一个学生用于排课
				if (course_id != null && course_id.length > 0) {
					Account account = new Account();
					account.set("EMAIL", classOrder.getStr("classNum"));
					account.set("REAL_NAME", classOrder.getStr("classNum"));
					account.set("REAL_NAME", classOrder.getStr("classNum"));
					account.set("campusid", classOrder.getInt("campusId"));
					account.set("SUBJECT_ID", Util.printArray(sub_id));
					account.set("CLASS_TYPE", Util.printArray(cur_id));
					account.set("USER_PWD", ToolMD5.getMD5(Organization.dao.getTchLnitialPassword()));
					account.set("CREATE_TIME", new Date());
					account.set("UPDATE_TIME", new Date());
					account.set("STATE", 2);
					account.set("COURSE_SUM", classOrder.getInt("lessonNum"));
					account.set("groupids", role.getInt("id") + ",").set("user_type", 1).save();
					// 取得添加用户的id
					new AccountBanci().set("account_id", account.getInt("Id")).set("banci_id", classOrder.getInt("id")).save();
					Db.update("UPDATE class_order o LEFT JOIN account a ON o.classNum=a.REAL_NAME SET o.accountid=a.Id");
				}
			}
			json.put("code", 1);
			json.put("msg", "班次保存成功。");
		} catch (Exception e) {
			e.printStackTrace();
			json.put("code", 0);
			json.put("msg", "数据保存异常");
		}
		renderJson(json);
	}

	public void clearCourse() { // class_id
		Integer class_id = getParaToInt("class_id");
		List<Record> record = ClassType.dao.getCoursePlan(class_id);
		if (record.size() > 0) {
			renderJson("result", record);
		} else {
			renderJson("result", null);
		}
	}

	public void deleteCourse() {
		Integer class_id = getParaToInt("class_id");
		Db.update("DELETE FROM courseplan WHERE class_id=? and COURSE_TIME>curdate()", class_id); // 删除该班次的排课
		Db.update("UPDATE class_order SET teachTime=NULL,endTime=NULL WHERE id=? ", class_id); // 更改开班时间
		List<Record> list = Db.find("SELECT * from account_banci WHERE banci_id=? ", class_id);
		for (Record rec : list) {
			Integer stu_id = rec.getInt("account_id");
			Integer useCourse = CoursePlan.getUseCourse(stu_id); // 查询已排课节数
			Db.update("UPDATE account SET COURSE_USENUM=? WHERE Id=? ", useCourse, stu_id); // 更新account表中的已排课记录
		}
		redirect("/classtype/findClassOrder");
	}

	public void showBanciDetail() {
		Integer classOrderId = getParaToInt("id");
		ClassOrder classOrder = ClassOrder.dao.findById(classOrderId);
		List<BanciCourse> courseList = BanciCourse.dao.findByClassOrderId(classOrderId);
		setAttr("courseList", courseList);
		classOrder.put("studentCount", AccountBanci.dao.getStudentCountByClassOrderId(classOrder.getInt("id"),classOrder.getInt("accountid")));
		setAttr("classOrder",classOrder);
		Integer sign = 1;
		if (classOrder.get("endTime") != null) {
			Date da = classOrder.get("endTime");
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
			Long n = Long.parseLong(formatter.format(new Date()));
			Long b = Long.parseLong(formatter.format(da));
			if (b > n) {
				sign = 1;
			} else {
				sign = 0;
			}
		} else {
			sign = 1;
		}

		setAttr("sign", sign);
		// 查询选择该班次的学生姓名
		List<AccountBanci> studentList = AccountBanci.dao.getStudentsByClassOrderId(classOrderId);
		for(AccountBanci student : studentList){
			student.put("orderHour",CourseOrder.dao.getBanHour(student.getInt("account_id"), classOrderId));
		}
		setAttr("studentList", studentList);
		CoursePlan.coursePlan.getCoursePlanByClassOrderId(splitPage,classOrderId);
		setAttr("coursePlanList", splitPage.getPage());
		setAttr("id", classOrderId);
		renderJsp("/course/showBanciDetail.jsp");
	}

	public void classConnectionStudents() {
		Integer id = getParaToInt("id");
		setAttr("class_id", id);
		Record list = ClassType.dao.getClassOrder(id);
		setAttr("banci", list.get("classNum"));
		setAttr("banxing", list.get("name"));
		setAttr("stuNum", list.get("stuNum"));
		setAttr("lesson_count", list.get("lesson_count"));
		setAttr("lessonNum", list.get("lessonNum"));
		setAttr("teachTime", list.get("teachTime"));
		setAttr("endTime", list.get("endTime"));
		setAttr("is_assesment", list.get("is_assesment"));
		List<Record> rec = ClassType.dao.getCourse(id);
		setAttr("record", rec);

		Integer sign = 1;
		if (list.get("endTime") != null) {
			Date da = list.get("endTime");
			SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
			Long n = Long.parseLong(formatter.format(new Date()));
			Long b = Long.parseLong(formatter.format(da));
			if (b > n) {
				sign = 1;
			} else {
				sign = 0;
			}
		} else {
			sign = 1;
		}

		setAttr("sign", sign);

		// 查询选择该班次的学生姓名
		List<Record> stuList = ClassType.dao.getAccountBanci(id);
		setAttr("stuList", stuList);

		renderJsp("/course/classConnectionStudents.jsp");
	}

	public void showStudentSelect() {
		try {
			String stuName = getPara("studentName");
			Integer classId = getParaToInt("classId");
			List<Record> claCourseLists = ClassType.dao.getCoursesByClassId(classId);// 小班的今后所有排课；
			List<Student> students = ClassType.dao.getStudents(stuName);
			List<Student> lists = new ArrayList<Student>();
			ClassOrder classOrder = ClassOrder.dao.findById(classId);
			Integer classTypeId = classOrder.get("classtype_id");
			List<BanciCourse> bc = ClassType.dao.getBanciCourse(classId);
			if (students.size() > 0) {
				for (int i = 0; i < students.size(); i++) {
					int count = 0;
					String courseids = students.get(i).getStr("CLASS_TYPE");
					if (courseids != null) {
						String[] couids = courseids.replace("|", ",").split(",");
						// 这样的判断需要保证元素不重复
						for (int j = 0; j < couids.length; j++) {
							for (int z = 0; z < bc.size(); z++) {
								if (bc.get(z).getInt("COURSE_ID").toString().equals(couids[j])) {
									count++;
								}
							}
						}
						if ((count == couids.length || count == bc.size())) {
							lists.add(students.get(i));
						}
					} else if (courseids == null) {
						String subjects = students.get(i).getStr("SUBJECT_ID");
						if (subjects != null) {
							String[] subid = subjects.replace("|", ",").split(",");
							for (int k = 0; k < subid.length; k++) {
								if (subid[k].equals(classTypeId.toString())) {
									lists.add(students.get(i));
								}
							}
						} else if (subjects == null) {
							lists.add(students.get(i));
						}
					}

				}
			}
			List<AccountBanci> abs = AccountBanci.dao.findABbyClassId(classId);
			for (int i = 0; i < abs.size(); i++) {
				again: for (int j = 0; j < lists.size(); j++) {
					if (lists.get(j).getInt("ID") == abs.get(i).getInt("account_id")) {
						lists.remove(j);
						break again;
					}
				}
			}
			if (claCourseLists.size() > 0) {// 该班次往后有排课；筛选排课不冲突的学生；
				// 查看学生的课程安排
				for (int i = 0; i < claCourseLists.size(); i++) {
					TimeRank rectimeRank = TimeRank.dao.findById(claCourseLists.get(i).getInt("TIMERANK_ID"));// 小班的某一次课claCourseLists.get(i)
					String rectimeNames[] = rectimeRank.getStr("RANK_NAME").split("-");
					int recbeginTime = Integer.parseInt(rectimeNames[0].replace(":", ""));
					int recendTime = Integer.parseInt(rectimeNames[1].replace(":", ""));
					// claCourseLists.get(i).getStr("COURSE_TIME");
					circle: for (int j = 0; j < lists.size(); j++) {// lists为筛选出来的学生
						Integer stuId = lists.get(j).getInt("id");
						List<Record> stuLists = ClassType.dao.getStudentCourses(stuId);// 某一学生的今后课程安排；
						for (int z = 0; z < stuLists.size(); z++) {
							if (claCourseLists.get(i).get("COURSE_TIME").equals(stuLists.get(z).get("COURSE_TIME"))) {
								TimeRank timeRank = TimeRank.dao.findById(stuLists.get(z).getInt("TIMERANK_ID"));
								String timeNames[] = timeRank.getStr("RANK_NAME").split("-");
								int beginTime = Integer.parseInt(timeNames[0].replace(":", ""));
								int endTime = Integer.parseInt(timeNames[1].replace(":", ""));
								if ((beginTime >= recbeginTime && beginTime <= recendTime) || (endTime >= recbeginTime && endTime <= recendTime)) {
									lists.remove(j);
									break circle;
								}

							}
						}
					}
				}
				renderJson("stuList", lists);

			} else {
				// 直接把list提交上去就好了
				renderJson("stuList", lists);

			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("showStudentLists", e);
		}

	}

	public synchronized void removeAccountFromClass() {
		Integer accountBanciId = getParaToInt("accountBanciId");
		try {
			AccountBanci accountBanci = AccountBanci.dao.findById(accountBanciId);
			int state = accountBanci.getInt("state")==0?1:0;
			accountBanci.set("state", state).set("quitDate", ToolDateTime.getCurDateTime()).update();
			renderJson("result", "true");
		} catch (Exception e) {
			logger.error("ErrorRemoveAccountFromClass", e);
			renderJson("result", "false");
		}

	}

	public void addStuToClass() {
		try {
			Integer class_id = getParaToInt("classId");
			String stuIds = getPara("stuIds");
			String[] sids = stuIds.split(",");
			
			Integer temp = 0;
			Integer sum = 0;
			for (int i = 0; i < sids.length; i++) {
				if (sids[i] != "" && sids[i] != null && sids[i] != " ") {
					sum += 1;
					Integer test = ClassType.dao.connectStuToClass(sids[i], class_id);
					temp += test;
				}
			}
			if (temp != 0 && temp == sum) {
				renderJson("result", "success");
			} else {
				renderJson("result", "fail");
			}
		} catch (Exception e) {
			e.printStackTrace();
			renderJson("result", "fail");
		}

	}

	public void getClassOrderNameSure() {
		JSONObject json = new JSONObject();
		try {
			String ordername = getPara("name");
			Long count = ClassOrder.dao.getOrderNameSure(ordername);
			if (count > 0) {
				json.put("code", 0);
				json.put("msg", "班次已存在，建议更换.");
			} else {
				json.put("code", 1);
				json.put("msg", "班次编号可用.");
			}
			renderJson(json);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public void changeClassTypeStatus() {
		String id = getPara("id");
		ClassType classType = ClassType.dao.findById(id);
		if (classType.getInt("status") == 1) {
			classType.set("status", 2);
		} else {
			classType.set("status", 1);
		}
		ClassTypeService.update(classType);
		renderJson("result", "true");
	}

	public void getKcgwBySchoolid() {
		try {
			String scid = getPara("scid");
			List<SysUser> kcgw = SysUser.dao.getKechengguwenCampus(scid);
			renderJson(kcgw);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 结课
	 */
	@Before(renderJsonInterceptor.class)
	public void endClassOrder(){
		ClassOrder.dao.findById(getPara("id")).set("endTime", ToolDateTime.getSpecifiedDayBefore(new Date(), 1)).update();
	}

	/**
	 * 删除小班
	 */
	public void deleteClassOrder() {
		JSONObject json = new JSONObject();
		try {
			String orderid = getPara("id");
			boolean cpflag = true;
			boolean coflag = true;
			List<CoursePlan> cplist = CoursePlan.coursePlan.getAllCourseByOrderId(orderid);
			if (cplist.size() > 0) {// 判断排课情况
				cpflag = false;
				json.put("code", 1);
			}
			List<CourseOrder> colist = CourseOrder.dao.findOrderByClassId(Integer.parseInt(orderid));
			if (colist.size() > 0) {// 判断购课情况
				coflag = false;
				json.put("num", 1);
			}
			if (cpflag && coflag) {
				ClassOrder classOrder = ClassOrder.dao.findById(orderid);
				Account.dao.findById(classOrder.getInt("accountid")).delete();
				classOrder.delete();// 删除
				json.put("code", 0);
			}
		} catch (Exception e) {
			json.put("num", 0);
			e.printStackTrace();
		}
		renderJson(json);
	}
	
	/**
	 * 获取班课的课程信息 
	 * @author David
	 */
	public void getCourseListByClassId() {
		JSONObject result = new JSONObject();
		Integer classOrderId = getParaToInt("classOrderId");
		List<BanciCourse> courseList = BanciCourse.dao.findByClassOrderId(classOrderId);
		result.put("courseList", courseList);
		result.put("chargeType", ClassOrder.dao.findById(classOrderId).getInt("chargeType"));
		renderJson("result", result);
	}
	
	@SuppressWarnings("unchecked")
	public void chooseCoursePlan(){
		Integer accountBanciId = getParaToInt();
		AccountBanci accountBanci = AccountBanci.dao.findById(accountBanciId);
		Integer studentId = accountBanci.getInt("account_id");
		Integer classOrderId = accountBanci.getInt("banci_id");
		ClassOrder classOrder = ClassOrder.dao.findById(classOrderId);
		List<CourseOrder> courseOrderList = CourseOrder.dao.getCourseOrders(studentId,classOrderId);
		setAttr("courseOrderList", courseOrderList);
		setAttr("student", Student.dao.findById(studentId));
		setAttr("classOrder", classOrder);
		CoursePlan.coursePlan.getCoursePlanByClassOrderId(splitPage,classOrderId);
		List<Record> coursePlanList = (List<Record>) splitPage.getPage().getList();
		List<Teachergrade> teachergradeList = Teachergrade.teachergrade.getListByStudentIdAndClassOrderId(studentId,classOrderId);
		List<CoursePlan> studentList = CoursePlan.coursePlan.findByStudentId(studentId, null, null);
		int chargeType = classOrder.getInt("chargeType");
		if(chargeType == 1&&coursePlanList.size()==teachergradeList.size()){//按期并且是整班购买
			setAttr("chooseAll", true);
		}else{
			setAttr("chooseAll", false);
		}
		double sumhour = CourseOrder.dao.getBanHour(studentId, classOrderId);
		double banHour = classOrder.getInt("lessonNum");
		if(ToolArith.compareTo(sumhour, banHour)==0){
			setAttr("showChooseAll", true);
		}else{
			setAttr("showChooseAll", false);
		}
		for(Record coursePlan : coursePlanList){
			coursePlan.set("choose", false);
			coursePlan.set("isConflict",false);//判断是否和1对1冲突
			String courseTimeBan = ToolDateTime.getStringTimestamp(coursePlan.getTimestamp("courseTime"));
			Integer timerankIdBan = coursePlan.getInt("TIMERANK_ID");
			for(Teachergrade teacherGreade : teachergradeList){
				if(coursePlan.getInt("Id").equals(teacherGreade.getInt("courseplan_id"))){
					coursePlan.set("choose", true);
					break;
				}
			}
			for(CoursePlan studentPlan : studentList){
				String courseTimeStu = ToolDateTime.getStringTimestamp(studentPlan.getTimestamp("COURSE_TIME"));
				Integer timerankIdStu = studentPlan.getInt("TIMERANK_ID");
				if(courseTimeBan.equals(courseTimeStu)&&timerankIdBan.equals(timerankIdStu)){
					coursePlan.set("isConflict",true);
					break;
				}
			}
		}
		setAttr("coursePlanList", splitPage.getPage());
		setAttr("accountBanciId",accountBanciId);
		renderJsp("/course/layer_chooseCoursePlan.jsp");
	}
}
