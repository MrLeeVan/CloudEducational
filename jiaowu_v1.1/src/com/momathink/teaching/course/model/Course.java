
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

package com.momathink.teaching.course.model;

import java.util.ArrayList;
import java.util.List;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolString;

/**课程
 * */
@SuppressWarnings("serial")
@Table(tableName="course")
public class Course extends BaseModel<Course> {

	public static final Course dao = new Course();
	
	
	public List<Course> findBySubjectId(Integer subjectId) {
		return dao.find("SELECT c.*,s.subject_name FROM course c LEFT JOIN `subject` s ON c.subject_id=s.id WHERE c.state = 0 and c.subject_id=?", subjectId);
	}
	
	/** 查询的课程信息 中带有 科目名称
	 * */
	public Course queryById(Object id){
		return dao.findFirst("SELECT c.*,s.subject_name FROM course c LEFT JOIN `subject` s ON c.subject_id=s.id WHERE c.id = ?", id);
	}
	
	public List<Course> getVIPStuCourse(String[] arrCourse){
		List<Course> lists = new ArrayList<Course>();
		for(int i=0;i<arrCourse.length;i++){
			String sql = "select * from course where state = 0 and id = ?";
			Course course = dao.findFirst(sql,arrCourse[i]);
			lists.add(course);
		}
		for(int j=0;j<lists.size();j++){
			if(lists.get(j)==null){
				lists.remove(j);
			}
		}
		return lists;
	}
	public Long queryCourseCount(String field, String value, String courseId, String subjectId) {
		if (!ToolString.isNull(field) && !ToolString.isNull(value)) {
			StringBuffer sql = new StringBuffer("select count(1) from course where subject_id=? and state=0 and ");
			sql.append(field).append("='").append(value).append("'");
			if (!ToolString.isNull(courseId)) {
				sql.append(" and id != ").append(courseId);
			}
			return Db.queryLong(sql.toString(),subjectId);
		} else {
			return null;
		}
	}


	public String getCourseNameById(String courseId) {
		if(StringUtils.isEmpty(courseId)){
			return null;
		}else{
			Course course = dao.findById(Integer.parseInt(courseId));
			return course.getStr("course_name");
		}
	}

	public List<Course> getCourses() {
		return dao.find("select * from course where state=0");
	}

	public Course getCourseByName(String coursename) {
		String sql = "select * from course where course_name = ? ";
		Course course = Course.dao.findFirst(sql, coursename);
		return course;
	}
	
	/**停用的课程*/
	public List<Course> getCourseBySubjectId(String subId){
		String sql = "select * from course where SUBJECT_ID = ? and SUBJECT_ID != 0 ";
		List<Course> list = dao.find(sql, subId);
		return list;
	}
	
	public List<Course> getCourseBySubjectIds(String subids){
		String sql = "select Id courseid,COURSE_NAME coursename from course where SUBJECT_ID in ( "+subids+ " ) and state = 0 and SUBJECT_ID !=0 " ;
		return dao.find(sql);
	}
	
	/**
	 * 学生订单中科目下所有课程
	 * @param stuid
	 * @return
	 */
	public List<Course> findStudentOrdersList(String stuid) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT distinct course.course_name,course.Id courseid FROM course WHERE FIND_IN_SET(course.SUBJECT_ID ,(SELECT REPLACE (GROUP_CONCAT(DISTINCT subjectids),'|',',') subids FROM crm_courseorder WHERE teachtype=1 and studentid=").append(stuid).append(")) AND course.STATE = 0");
		return dao.find(sb.toString());
	}

	public List<Course> getTeacherCourse(String ids) {
		String str = " select * from course where state=0 and  id in ("+ids+")";
		return dao.find(str);
	}

	/**
	 * 根据SubjectIds获取课程
	 * @author David
	 * @param subjcetIds：使用,分割如1,2,3,4
	 * @return
	 * @since JDK 1.7
	 */
	public  List<Course> findBySubjectIds(String subjectIds) {
		String str = " select * from course where state=0 and subject_id in ("+subjectIds+")";
		return dao.find(str);
	}
	
	/***
	 * 获取学生 购买的 一对一 课程信息
	 */
	public List<Course> queryByStudentCourse1v1(Object studentId) {
		return Course.dao.find(
						"SELECT " +
						"	c.* " +
						"FROM " +
						"	course c " +
						"LEFT JOIN crm_courseprice cp ON cp.courseid = c.Id " +
						"LEFT JOIN crm_courseorder co ON co.id = cp.orderid " +
						"WHERE " +
						"co.teachtype = 1 " +
						"AND cp.studentid = ? " +
						"GROUP BY c.Id"
						, studentId);
	}
	
	
	
	
	
}
