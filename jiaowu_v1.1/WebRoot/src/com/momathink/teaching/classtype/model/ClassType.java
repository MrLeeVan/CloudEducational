
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

package com.momathink.teaching.classtype.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.account.model.BanciCourse;
import com.momathink.teaching.student.model.Student;

@SuppressWarnings("serial")
@Table(tableName = "class_type")
public class ClassType extends BaseModel<ClassType> {

	public static final ClassType dao = new ClassType();

	/**
	 * 根据班型名称查询对应的课程信息
	 * 
	 * @param type_name
	 * @return
	 */
	public static String getClassTypeDetail(String type_name) {
		String sql = "SELECT class_type.`name`, class_type.lesson_count, course.COURSE_NAME, banci_course.lesson_num  FROM class_type "
				+ "LEFT JOIN banci_course ON class_type.id = banci_course.type_id  LEFT JOIN course ON banci_course.course_id = course.Id "
				+ "WHERE class_type.`name` = ? GROUP BY banci_course.course_id ";
		List<ClassType> classType = ClassType.dao.find(sql, type_name);
		String str = "";
		for (ClassType ct : classType) {
			str += ct.getStr("COURSE_NAME") + "  ";
		}
		return str;
	}

	/**
	 * 添加班型信息
	 */
	public static void addClassType(String name, Integer teach_type, Integer subject_id, Integer course_id) {
		new ClassType().set("name", name).set("teach_type", teach_type).set("subject_id", subject_id).set("course_id", course_id).save();
	}

	public List<ClassType> getClassTypeList(String banxing, String kemu) {
		String sql = "SELECT DISTINCT ct.id,ct.`name` typeName FROM class_type ct LEFT JOIN banci_course bc ON ct.id=bc.type_id WHERE 1=1";
		if (!ToolString.isNull(banxing)) {
			sql += " AND ct.`name` LIKE '%" + banxing + "%'";
		}
		if (!ToolString.isNull(kemu) && !"0".equals(kemu)) {
			sql += " AND bc.subject_id = " + kemu;
		}
		sql += " ORDER BY ct.id";
		List<ClassType> list = ClassType.dao.find(sql);
		return list;
	}

	public List<Record> getSubjectList(Integer classTypeId) {
		String subjectSql = "SELECT DISTINCT s.SUBJECT_NAME FROM banci_course bc LEFT JOIN `subject` s ON bc.subject_id=s.Id WHERE bc.type_id = ?";
		List<Record> list = Db.find(subjectSql, classTypeId);
		return list;
	}

	public List<Record> getCourseList(Integer classTypeId) {
		String courseSql = "SELECT DISTINCT c.COURSE_NAME FROM banci_course bc LEFT JOIN course c ON bc.course_id=c.Id WHERE bc.type_id = ?";
		List<Record> courseList = Db.find(courseSql, classTypeId);
		return courseList;
	}

	public List<Record> findClassOrder(String banci, String kemu, String date1, String date2, Integer type_id) {
		String sql = "SELECT DISTINCT  class_order.id, class_order.classNum, class_order.classtype_id, "
				+ "	class_order.stuNum, class_order.teachTime, class_order.endTime, class_type.`name`, "
				+ "	class_type.lesson_count, class_order.lessonNum,class_order.totalfee, banci_course.subject_id,   class_type.id AS type_id FROM "
				+ "	class_order  LEFT JOIN class_type ON class_order.classtype_id = class_type.id "
				+ "LEFT JOIN banci_course ON class_order.id = banci_course.banci_id  WHERE banci_course.banci_id <> 0 ";
		if (!ToolString.isNull(banci)) {
			sql += " and class_order.classNum =  '" + banci + "'";
		}
		if (!ToolString.isNull(kemu) && !"0".equals(kemu)) {
			sql += " and banci_course.subject_id = " + kemu;
		}
		if (type_id != null && type_id != 0) {
			sql += " and type_id = " + type_id;
		}
		if (!ToolString.isNull(date1)) {
			sql += " and class_order.teachTime >=  '" + date1 + "'";
		}
		if (!ToolString.isNull(date2)) {
			sql += " and class_order.teachTime <=  '" + date2 + "'";
		}
		sql += " GROUP BY class_order.classNum order by class_order.classNum ";
		List<Record> list = Db.find(sql);
		return list;
	}

	/*
	 * public List<Record> editClassTypeFind(String type_id) { String sql =
	 * "SELECT class_type.id, class_type.`name`, class_type.teach_type, class_type.lesson_count, "
	 * + "	banci_course.subject_id, banci_course.course_id " +
	 * "FROM class_type " +
	 * "LEFT JOIN banci_course ON class_type.id = banci_course.type_id " +
	 * "WHERE class_type.id = ?  AND banci_course.banci_id = 0"; List<Record>
	 * record = Db.find(sql, type_id); return record; }
	 */

	/**
	 * 查询班型信息
	 * 
	 * @param name
	 * @return
	 */
	public static ClassType getClassName(String name) {
		String sql = "select * from class_type where name=? ";
		ClassType list = ClassType.dao.findFirst(sql, name);
		return list;
	}

	public Record findRecordCourse(Integer courseid) {
		String sql = "SELECT course.SUBJECT_ID, course.COURSE_NAME,	course.Id  FROM  course  WHERE course.ID = ?";
		Record record = Db.findFirst(sql, courseid);
		return record;
	}

	public Integer getClassTypeIdByName(String name) {
		String sql = "select id from class_type where name = ? ";
		Integer id = ClassType.dao.findFirst(sql, name).getInt("id");
		return id;
	}

	public void deleteBanciCourse(String id) {
		String sql = "DELETE FROM banci_course WHERE type_id = ? and banci_id = 0 ";
		Db.update(sql, id);
	}

	public List<Record> getClassTypeByTypeId(String type_id) {
		String sql = "SELECT class_type.id, class_type.`name`,class_type.campusid campusid, class_type.teach_type, class_type.lesson_count, "
				+ "	banci_course.subject_id, banci_course.course_id  FROM class_type  LEFT JOIN banci_course ON class_type.id = banci_course.type_id "
				+ "WHERE class_type.id = ?  AND banci_course.banci_id = 0";
		List<Record> record = Db.find(sql, type_id);
		return record;
	}

	public List<Record> getRecordClasstypeName(String name) {
		String sql = "select * from class_type where name=? ";
		List<Record> record = Db.find(sql, name);
		return record;
	}

	public List<ClassType> getClassNameByLike(String name) {
		String sql = "select * from class_type where name=? ";
		List<ClassType> list = ClassType.dao.find(sql, name);
		return list;
	}

	public List<Record> getClassTypeForJson(String type_id) {
		String sql = "SELECT class_type.id, class_type.`name`, class_type.teach_type, class_type.lesson_count,class_type.campusid, "
				+ "	banci_course.subject_id, banci_course.course_id  FROM class_type  LEFT JOIN banci_course ON class_type.id = banci_course.type_id "
				+ "WHERE class_type.id = ?  AND banci_course.banci_id = 0 GROUP BY banci_course.subject_id ";
		List<Record> record = Db.find(sql, type_id);
		return record;
	}

	public List<ClassType> getClassType() {
		String sql = "SELECT * FROM class_type";
		List<ClassType> list = ClassType.dao.find(sql);
		return list;
	}
	/*
	 *获取当前登录用户所属校区下的班型 
	 *
	 */
	public List<ClassType> getClassTypeByCampusIds( String campusIds ) {
		String sql = "SELECT * FROM class_type left join class_order on class_type.id = class_order.classtype_id where class_order.campusId in ("+ campusIds +")";
		List<ClassType> list = ClassType.dao.find(sql);
		return list;
	}
	
	public List<ClassType> getClassTypekeyong( String campusIds ) {
		String sql = "SELECT *  FROM class_type ct WHERE status = 1 and "
				+ " ( ct.campusid in (" + campusIds + ") or ct.campusid is null )";
		List<ClassType> list = ClassType.dao.find(sql);
		return list;
	}

	public Integer getclassTypeByClasstypeId(Integer classtype_id) {
		String sql = "select * from class_type where id=? ";
		Integer classtype = ClassType.dao.findFirst(sql, classtype_id).getInt("lesson_count");
		return classtype;
	}

	public Record getClassOrderbyclassnum(String class_num) {
		String sql = "select * from class_order where classNum=? ";
		Record record = Db.findFirst(sql, class_num);
		return record;
	}

	public List<Record> getCourseListByClassType(Integer type_id) {
		String sql = "SELECT class_type.`name`, IFNULL(class_type.lesson_count, 0) AS lesson_count, course.COURSE_NAME, "
				+ "	class_type.id AS type_id, banci_course.subject_id, IFNULL(banci_course.lesson_num, 0) AS lesson_num, "
				+ "	banci_course.course_id, banci_course.Id  FROM class_type  LEFT JOIN banci_course ON class_type.id = banci_course.type_id "
				+ "LEFT JOIN course ON banci_course.course_id = course.Id  WHERE banci_course.type_id = ?  AND banci_course.banci_id = 0";
		List<Record> record = Db.find(sql, type_id);
		return record;
	}

	public List<Record> getCourseListByClassType2(Integer banci_id) {
		String sql = "SELECT class_type.`name`, course.COURSE_NAME, class_type.id AS type_id, "
				+ "	banci_course.subject_id, IFNULL(banci_course.lesson_num, 0) AS lesson_num, banci_course.course_id, "
				+ "	banci_course.Id, banci_course.banci_id  FROM class_type  LEFT JOIN banci_course ON class_type.id = banci_course.type_id "
				+ "LEFT JOIN course ON banci_course.course_id = course.Id  WHERE banci_course.banci_id = ?  AND banci_course.banci_id <> 0";
		List<Record> record = Db.find(sql, banci_id);
		return record;
	}

	public Long getStuCount(String class_num) {
		String sql = "SELECT COUNT(*) AS stuCount  FROM account_banci  LEFT JOIN class_order ON account_banci.banci_id = class_order.id "
				+ "LEFT JOIN account ON account_banci.account_id = account.Id  WHERE class_order.classNum = ?  AND account.STATE = 0";
		Long stuCount = Db.findFirst(sql, class_num).getLong("stuCount");
		return stuCount;
	}

	public Record getClassTypePlancount(Integer course_id, Integer stu_id, Integer banci_id) {
		Record record = null;
		String sql = "SELECT COUNT(*) AS plancount  FROM ( 	SELECT * FROM courseplan " + "WHERE courseplan.COURSE_ID = ? and courseplan.PLAN_TYPE=0  ";
		if (banci_id != 0 && banci_id != null) {
			sql += " AND courseplan.class_id = ? AND courseplan.state = 0 GROUP BY COURSE_ID, "
					+ "	DATE_FORMAT(COURSE_TIME, '%Y-%m-%d'), TIMERANK_ID ) a";
			record = Db.findFirst(sql, course_id, banci_id);
		} else if (stu_id != 0 && stu_id != null) {
			sql += "		AND courseplan.STUDENT_ID = ? ) a";
			record = Db.findFirst(sql, course_id, stu_id);
		}
		return record;
	}

	public Record getYPKRecord(Integer id) {
		String sql = "SELECT count(1) jieshu,max(DATE_FORMAT(c.COURSE_TIME,'%Y-%m-%d')) kctime FROM courseplan c WHERE c.class_id=?";
		Record ypkrecord = Db.findFirst(sql, id);
		return ypkrecord;
	}

	public void deleteBanciCourseId(Integer id) {
		String sql = "delete from banci_course where banci_id = ? and banci_id <> 0";
		Db.update(sql, id);
	}

	public Record selectAccountRealname(String realname) {
		String sql = "select * from account where real_name=?";
		Record record = Db.findFirst(sql, realname);
		return record;
	}

	public List<Record> getCoursePlan(Integer class_id) {
		String sql = "SELECT * FROM courseplan WHERE class_id=? AND STATE=0 AND DATE_FORMAT(COURSE_TIME,'%Y-%m-%d') <= CURDATE() ";
		List<Record> record = Db.find(sql, class_id);
		return record;
	}

	public Record getClassOrder(Integer id) {
		String sql = "SELECT class_order.id, class_order.classNum, class_order.classtype_id, class_order.stuNum, "
				+ "	class_order.teachTime,class_order.is_assesment,class_order.endTime, class_type.`name`, class_type.lesson_count, "
				+ "	class_order.lessonNum  FROM class_order  LEFT JOIN class_type ON class_order.classtype_id = class_type.id " + " WHERE class_order.id = ? ";
		Record list = Db.findFirst(sql, id);
		return list;
	}

	public List<Record> getCourse(Integer id) {
		String sql2 = "SELECT c.banci_id,c.course_id,c.COURSE_NAME, "
				+ " convert(CONCAT(IFNULL(b.count_course,0),' '),char) AS classinfo,IFNULL(b.count_course,0) AS yipai,c.lesson_num  FROM "
				+ "(SELECT bc.banci_id,bc.course_id,c.COURSE_NAME,bc.lesson_num FROM banci_course bc  LEFT JOIN course c ON bc.course_id=c.Id "
				+ "WHERE bc.banci_id=?) c  LEFT JOIN (SELECT  a.COURSE_ID,  course.COURSE_NAME, sum(hour) AS count_course  FROM "
				+ "(  SELECT  cp.COURSE_ID,  tr.class_hour hour, DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d') courseDate, cp.TIMERANK_ID  FROM "
				+ "courseplan cp left join time_rank tr on tr.Id=cp.TIMERANK_ID WHERE  cp.class_id = ? and cp.PLAN_TYPE=0  GROUP BY "
				+ "cp.COURSE_ID, DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d'), cp.TIMERANK_ID  ) AS a  INNER JOIN course ON course.Id = a.COURSE_ID "
				+ "GROUP BY a.COURSE_ID  ) b  ON c.course_id=b.COURSE_ID";
		List<Record> record = Db.find(sql2, id, id);
		return record;
	}

	public List<Record> getAccountBanci(Integer id) {
		String sql3 = "SELECT account_banci.account_id, account_banci.banci_id, account.REAL_NAME,  account.TEL,  account.CREATE_TIME  FROM "
				+ "	account_banci  LEFT JOIN account ON account_banci.account_id = account.Id WHERE account_banci.banci_id = ? and account.state=0 ";
		List<Record> stuList = Db.find(sql3, id);
		return stuList;
	}

	public void deleteClassAccount(Integer class_id, Integer stuId) {
		String sql = "delete from account_banci where account_id = ? and banci_id =? ";
		// Db.update(sql);
		Db.update(sql, stuId, class_id);
		// Db.delete(tableName, record)

	}

	public List<Record> getSignin(Integer id) {
		String sql = "select SIGNIN from courseplan where class_id = ?";
		List<Record> signs = Db.find(sql, id);
		return signs;
	}

	public List<Record> getCoursesByClassId(Integer id) {
		String sql = "select * from courseplan where COURSE_TIME >=CURDATE() AND CLASS_ID = ?";
		List<Record> list = Db.find(sql, id);
		return list;
	}

	public List<BanciCourse> getBanciCourse(Integer classTypeId) {
		String sql = "select * from banci_course where banci_id = ?";
		List<BanciCourse> list = BanciCourse.dao.find(sql, classTypeId);
		return list;
	}

	public List<Student> getStudents(String stuName) {
		String sql = "select * from account where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 ";
		if (!ToolString.isNull(stuName)) {
			sql += " AND real_name LIKE \"" + stuName + "%\"";
		}
		List<Student> list = Student.dao.find(sql);
		return list;
	}

	public List<Record> getStudentCourses(Integer stuId) {
		String sql = "select * from courseplan where COURSE_TIME>=CURDATE() AND STUDENT_ID = ?";
		List<Record> list = Db.find(sql, stuId);
		return list;
	}

	public Integer connectStuToClass(String stuId, Integer class_id) {
		AccountBanci accountBanci = AccountBanci.dao.findABbyStuClassId(stuId, class_id);
		if (accountBanci == null) {
			accountBanci = new AccountBanci();
			accountBanci.set("account_id", stuId).set("banci_id",class_id).set("createDate", ToolDateTime.getDate()).save();
			return 1;
		} else {
			return 0;
		}

	}

	public void updateNewStuCourse(Integer stuId, Integer class_id) {
		String sql = "INSERT INTO courseplan (STUDENT_ID,STATE,COURSE_ID,TEACHER_ID,CREATE_TIME,UPDATE_TIME,SORT_NUM,ROOM_ID,TIMERANK_ID,COURSE_TIME,SUBJECT_ID,REMARK,PLAN_TYPE,KNOWLEDGE_NAMES,TEACHER_PINGLUN,STUDENT_PINGLUN,SIGNIN,LATE_TIME,CAMPUS_ID,class_id) "
				+ "SELECT "
				+ stuId
				+ ",0,cp.COURSE_ID,cp.TEACHER_ID,cp.CREATE_TIME,cp.UPDATE_TIME,cp.SORT_NUM,ROOM_ID,TIMERANK_ID, date_format(COURSE_TIME,'%Y-%m-%d') COURSE_TIME,SUBJECT_ID,REMARK,PLAN_TYPE,KNOWLEDGE_NAMES,TEACHER_PINGLUN,STUDENT_PINGLUN,SIGNIN,LATE_TIME,CAMPUS_ID,class_id "
				+ "FROM courseplan cp WHERE cp.STATE=1 AND cp.class_id=? and cp.COURSE_TIME > curdate() ";
		Db.update(sql, class_id);
	}



}
