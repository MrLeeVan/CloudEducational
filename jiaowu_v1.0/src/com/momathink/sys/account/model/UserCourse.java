
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

package com.momathink.sys.account.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolString;
import com.momathink.teaching.course.model.Course;
@SuppressWarnings("serial")
@Table(tableName="user_course")
public class UserCourse extends BaseModel<UserCourse> {
	public static final UserCourse dao = new UserCourse();
	
	
	public List<UserCourse> findByStudentId(String accountId) {
		return ToolString.isNull(accountId)?null:UserCourse.dao.find("SELECT uc.subject_id,uc.course_id,c.COURSE_NAME FROM user_course uc LEFT JOIN course c ON uc.course_id=c.Id WHERE uc.account_id=? ORDER BY uc.subject_id",accountId);
	}
	public List<UserCourse> findHasSubjecByStudentId(String accountId) {
		return ToolString.isNull(accountId)?null:UserCourse.dao.find("SELECT uc.subject_id FROM user_course uc WHERE uc.account_id=? GROUP BY uc.subject_id",accountId);
	}
	public List<UserCourse> findByAccountId(String accountId) {
		return ToolString.isNull(accountId)?null:UserCourse.dao.find("SELECT * FROM user_course uc WHERE uc.account_id=? ",Integer.parseInt(accountId));
	}
	/**
	 * 获取学生对应ids
	 * @param stuid
	 * @return
	 */
	public String getStudentCourseids(String stuid) {
		String sql="SELECT GROUP_CONCAT( DISTINCT course_id SEPARATOR '|') courseids FROM user_course WHERE account_id = ? ";
		UserCourse ucourse = dao.findFirst(sql, stuid);
		return ucourse==null?"":ucourse.getStr("courseids");
	}
	
	/**
	 * 获取学生已选择的课程
	 * @param stuid
	 * @return
	 */
	public List<Course> getStudentUserCourse(String stuid){
		String sql = "SELECT c.* FROM user_course uc LEFT JOIN course c ON uc.course_id=c.Id WHERE tech_type = 1 and uc.account_id=? GROUP BY c.Id";
		return Course.dao.find(sql, Integer.parseInt(stuid));
	}
	
	/**
	 * 根据学生ID和科目ID获取课程
	 * @param studentId学生ID
	 * @param subjectIds科目ID,格式1,2,3
	 * @author David
	 */
	public Object findByStudentIdAndSubjectIds(Integer studentId, String subjectIds) {
		String sql = "select uc.id,uc.account_id,c.COURSE_NAME,c.SUBJECT_ID from user_course uc left join course c on uc.course_id = c.id WHERE uc.account_id=? and c.subject_id in(?)";
		return dao.find(sql, studentId,subjectIds);
	}
	
	/**
	 * 根据学生ID科目ID获取课程ID
	 * @author David
	 * @param studentId学生ID
	 * @param subjectIds科目ID：1,2,3
	 * @return
	 */
	public String getStudentCourseids(String studentId, String subjectIds) {
		String sql="select GROUP_CONCAT( DISTINCT course_id SEPARATOR '|') courseids from user_course uc left join course c on uc.course_id = c.id WHERE uc.account_id=? and c.subject_id in(?)";
		UserCourse ucourse = dao.findFirst(sql, studentId,subjectIds);
		return ucourse==null?"":ucourse.getStr("courseids");
	}
	
	/**
	 * 根据学生ID删除学生的课程
	 * @author David
	 * @param studentId
	 */
	public void deleteByStudentId(Object studentId) {
		Db.update("DELETE FROM user_course WHERE account_id=?", studentId);
	}
	
}
