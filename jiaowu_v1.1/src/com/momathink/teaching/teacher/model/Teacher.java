
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

package com.momathink.teaching.teacher.model;

import java.util.Arrays;
import java.util.List;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolString;


/***
 * @ClassName: 老师
 */
@SuppressWarnings("serial")
@Table(tableName = "account")
public class Teacher extends BaseModel<Teacher> {

	public static final Teacher dao = new Teacher();
	/**
	 * 检查是否存在相应字段的数据
	 * @param field
	 * @param value
	 * @param mediatorId
	 * @return
	 */
	public Long queryCount(String field, String value, String id) {
		if (!ToolString.isNull(field) && !ToolString.isNull(value)) {
			StringBuffer sql = new StringBuffer("select count(1) from account s where 1=1 and ");
			sql.append(field).append("='").append(value).append("'");
			if (!ToolString.isNull(id)) {
				sql.append(" and id != ").append(id);
			}
			return Db.queryLong(sql.toString());
		} else {
			return null;
		}
	}
	public Teacher getTeacherByName(String tname) {
		String sql = "select * from account where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0 AND REAL_NAME = ? ";
		Teacher teacher = Teacher.dao.findFirst(sql, tname);
		return teacher;
	}
	public String getTeacherNameById(String tid) {
		if(StringUtils.isEmpty(tid)){
			return null;
		}else{
			Teacher teacher = dao.findById(Integer.parseInt(tid));
			return teacher.getStr("REAL_NAME");
		}
	}
	
	/**
	 * 获取老师
	 * @return
	 */
	public List<Teacher> getTeachers() {
		String sql = "select * from account where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0 ORDER BY state, CONVERT(REAL_NAME USING gbk)";
		List<Teacher> list = dao.find(sql);
		return list;
	}
	
	
	/**
	 * 根据课程id获取能上该课程的老师(包括停用的老师
	 */
	public List<Teacher> getTeachersByCourseids(String courseid){
		if(StrKit.isBlank(courseid))
			return null;
		else
			courseid = "|"+courseid+"|";
		String sql = " SELECT tch.* FROM account tch LEFT JOIN (SELECT Id,CONCAT('|',CLASS_TYPE,'|') classtypeids FROM `account` WHERE "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0) a ON a.Id=tch.Id WHERE a.classtypeids LIKE '%"+courseid+"%' ";
		return dao.find(sql);
	}
	
	/**
	 * 根据课程id获取能上该课程的老师(不包括停用的老师
	 */
	public List<Teacher> getTeachersByCourseidsState(String courseid){
		if(StrKit.isBlank(courseid))
			return null;
		else
			courseid = "|"+courseid+"|";
		String sql = " SELECT tch.* FROM account tch LEFT JOIN (SELECT Id,CONCAT('|',CLASS_TYPE,'|') classtypeids FROM `account` WHERE "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0) a ON a.Id=tch.Id WHERE tch.state = 0 and a.classtypeids LIKE '%"+courseid+"%' ";
		return dao.find(sql);
	}
	/**
	 * 根据课程id,和当前学生所属校区,获取属于当前学生所属校区的能上该课程的老师(不包括停用的老师.
	 */
	public List<Teacher> getTeachersByCourseidsState(String courseid, Integer stuCampusId){
		if(StrKit.isBlank(courseid) || !StrKit.notNull(stuCampusId) )
			return null;
		else
			courseid = "%|"+courseid+"|%";
		String sql = " SELECT tch.* FROM account tch "
				+ " LEFT JOIN account_campus on  account_campus.account_id = tch.Id "
				+ " LEFT JOIN (SELECT Id,CONCAT('|',CLASS_TYPE,'|') classtypeids FROM `account` WHERE "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0) a "
				+ " ON a.Id=tch.Id WHERE tch.state = 0 and a.classtypeids LIKE ? "
				+ " and account_campus.campus_id = ? ";
		return dao.find(sql, courseid, stuCampusId);
	}
	/**
	 * 获取某个校区下的所有教师
	 * @param campusid
	 * @return
	 */
	public List<Teacher> getTeachersByCampusid(String campusid) {
		String sql ="SELECT distinct( t.Id ),t.REAL_NAME FROM account t "
				+ " LEFT JOIN account_campus ac ON account_id = t.id "
				+ " LEFT JOIN campus c on ac.campus_id = c.Id WHERE "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', t.roleids) ) > 0 AND t.STATE = 0 and c.Id in ("+ campusid +")";
		return dao.find(sql);
	}
	
	/**
	 * 根据教师姓名和校区 查询教师
	 * @param campusid
	 * @return
	 */
	public List<Teacher> getTeachersByCampusid(String teacherName, String campusid ) {
		String sql ="SELECT distinct( t.Id ),t.REAL_NAME FROM account t "
				+ " LEFT JOIN account_campus ac ON account_id = t.id "
				+ " LEFT JOIN campus c on ac.campus_id = c.Id WHERE "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', t.roleids) ) > 0 AND t.STATE = 0 and c.Id IN ("+ campusid +") AND REAL_NAME LIKE ? ";
		return dao.find(sql, ("%"+teacherName+"%") );
	}
	
	/**
	 * 获取某个校区下的所有教师(助教身份)
	 * @param campusid
	 * @return
	 */
	public List<Teacher> getIsAssistantTeacherByCampusid(String campusid) {
		String sql = "SELECT distinct( t.Id ),t.REAL_NAME FROM account t "
				+ " LEFT JOIN account_campus ac ON account_id = t.id "
				+ " LEFT JOIN campus c on ac.campus_id = c.Id "
				+ " WHERE  LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', t.roleids) ) > 0"
				+ " and c.Id in ("+ campusid +") AND t.isAssistantTeacher > 0";
		return dao.find(sql);
	}
	
	/**
	 * 根据ids查询教师
	 * @param ids
	 * @return
	 */
	public List<Teacher> findByIds(String ids) {
		StringBuffer sf = new StringBuffer();
		sf.append("select id,real_name from account where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0 and state=0  ") ;
		if(!ids.equals("")){
			sf.append(" and id in (").append(ids).append(")");
		}
		return dao.find(sf.toString());
	}

	/**
	 * 通过教师ID获取该教师所能教授的课程List
	 * 
	 * @param teacherid
	 * @return subject id list
	 */
	public List<String> findSubListByTchId(int teacherid) {
		String querySql = "SELECT REPLACE(SUBJECT_ID,\"|\",\",\") FROM account WHERE id = ?";
		return Arrays.asList((String) Db.queryColumn(querySql, teacherid));
	}

	/**
	 * 通过教师id ，courseid 查询 该教师是否能教授该课程
	 * 
	 * @param teacherid
	 * @param courseid
	 * @return boolean
	 */
	public boolean findTeacherByTidAndCid(String teacherid, String courseid) {
		String querySql = "SELECT * FROM account t WHERE FIND_IN_SET(?,REPLACE(t.subject_id,'|',',')) and t.id=?;";
		return (this.findFirst(querySql, courseid, teacherid) == null) ? false : true;
	}
	/**
	 * 根据教师名称查询教师
	 * @param teacherName 教师姓名	
	 * @return Teacher
	 */
	public Teacher findByName(String teacherName) {
		String sql = "SELECT * FROM account WHERE USER_TYPE = 1 AND REAL_NAME = ? ";
		Teacher teacher = Teacher.dao.findFirst(sql, teacherName);
		return teacher;
	}
}
