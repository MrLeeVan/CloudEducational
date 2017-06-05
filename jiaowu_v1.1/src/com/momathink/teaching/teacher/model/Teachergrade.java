
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.sys.account.model.AccountBook;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.course.model.CourseBack;

@SuppressWarnings("serial")
@Table(tableName = "teachergrade")
public class Teachergrade extends BaseModel<Teachergrade> {

	public static final Teachergrade teachergrade = new Teachergrade();
	
	/**获取带更多参数的**/
	public Teachergrade queryById(Object id) {
		return teachergrade.findFirst("SELECT t.*, c.COURSE_NAME  FROM teachergrade t " +
				"LEFT JOIN course c ON c.id = t.courseid WHERE t.Id = ?", id);
	}
	
	/**
	 * 根据设置节点id获取报告内容
	 * @param pointid
	 * @return
	 */
	public Teachergrade getPointGradeByPointId(String pointid) {
		String sql = "select * from teachergrade where pointid = ? ";
		return teachergrade.findFirst(sql, pointid);
	}
	/**
	 *
	 * @param cpid
	 * @return
	 */
	public Teachergrade getGradeByCoursePlanId(String cpid){
		if(StrKit.isBlank(cpid))
			return null;
		return teachergrade.findFirst("select * from teachergrade where COURSEPLAN_ID = ? ",cpid);
	}
	/**
	 * 找到下次预约的时间信息*
	 * @param int1
	 * @return
	 */
	public Teachergrade getNextTeachergrade(Integer tgid) {
		String  sql = "select tg.*,sp.appointment from teachergrade tg "
				+ " left join jw_setpoint sp on tg.pointid = sp.id  where tutorid = ? ";
		return teachergrade.findFirst(sql,tgid);
	}
	/**
	 * 根据课程id和学生id查看*
	 * @param courseplanid
	 * @param studentid
	 * @return
	 */
	public Teachergrade findByCoursePlanIdAndStudentid(String courseplanid, String studentid) {
		String sql = "select * from teachergrade where courseplan_id = ? and studentid = ? ";
		return teachergrade.findFirst(sql , courseplanid , studentid);
	}
	public List<Teachergrade> getGradeByCoursePlanIds(String cpid) {
		return teachergrade.find("select * from teachergrade where COURSEPLAN_ID = ? ",cpid);
	}
	public List<Teachergrade> getListByStudentIdAndClassOrderId(Integer studentId, Integer classOrderId) {
		String sql = "select tg.*,cp.timerank_id from teachergrade tg left join courseplan cp on tg.COURSEPLAN_ID=cp.Id WHERE tg.studentid=? AND cp.class_id=?";
		return teachergrade.find(sql, studentId,classOrderId);
	}
	public double getHasHour(Integer studentId, Integer classOrderId) {
		List<Teachergrade> list = teachergrade.getListByStudentIdAndClassOrderId(studentId, classOrderId);
		double sumHour = 0;
		for(Teachergrade tg : list){
			double classHour =TimeRank.dao.getHourById(tg.getInt("timerank_id"));
			sumHour = ToolArith.add(sumHour, classHour);
		}
		return sumHour;
	}
	
	/**
	 * 根据排课ID获取小班学生
	 * @param coursePlanId
	 * @return
	 */
	public String getStudentNameByCoursePlanId(Integer coursePlanId) {
		String sql = "SELECT GROUP_CONCAT(s.REAL_NAME) studentNames FROM teachergrade t LEFT JOIN account s ON t.studentid=s.Id WHERE t.COURSEPLAN_ID=?";
		return Db.queryStr(sql, coursePlanId);
	}
	
	/**
	 * 根据课程ID删除小班某个学生的排课记录
	 * @param coursePlanId
	 * @param studentId
	 */
	public void deleteByCoursePlanId(Integer coursePlanId,Integer studentId,Integer operateUserId) {
		Teachergrade teacherGrade = teachergrade.findByCoursePlanIdAndStudentid(coursePlanId+"", studentId+"");
		if(teacherGrade != null){
			String sql1 = "insert into courseplan_back SELECT * from  courseplan where courseplan.id = ? ";
			Db.update(sql1, coursePlanId);
			CourseBack cp = CourseBack.dao.findById(coursePlanId);
			cp.set("del_msg", "退费").set("update_time", ToolDateTime.getDate()).set("deluserid", operateUserId).update();
			AccountBook.dao.deleteByAccountIdAndCoursePlanId(studentId, coursePlanId);//删除某个学生的
			teacherGrade.delete();
		}
	}
	
	/**
	 * 根据课程ID删除所有学生小班关联记录和1对1的上课评价记录
	 * @param coursePlanId
	 */
	public void deleteByCoursePlanId(Integer coursePlanId) {
		String sql = "delete from teachergrade where COURSEPLAN_ID=?";
		Db.update(sql, coursePlanId);
		AccountBook.dao.deleteByCoursePlanId(coursePlanId);//删除所有学生的排课记录
	}
	
	/**
	 * 查询某个日期参加小班的学生名单
	 * @param queryParams
	 * @return
	 */
	public Map<Integer, String> getStudentNames(Map<String, String> queryParams) {
		String sql = "SELECT tg.COURSEPLAN_ID,GROUP_CONCAT(s.REAL_NAME) studentNames FROM teachergrade tg \n" +
				"left join account s on tg.studentid=s.Id\n" +
				"left join courseplan cp on tg.COURSEPLAN_ID=cp.Id\n" +
				"WHERE s.STATE=0 AND cp.COURSE_TIME>=? AND cp.COURSE_TIME<=? AND cp.class_id!=0\n" +
				"GROUP BY tg.COURSEPLAN_ID";
		List<Teachergrade> list = teachergrade.find(sql, queryParams.get("startDate"),queryParams.get("endDate"));
		Map<Integer,String> map = new HashMap<Integer, String>();
		for(Teachergrade t : list){
			map.put(t.getInt("COURSEPLAN_ID"), t.getStr("studentNames"));
		}
		return map;
	}
	
}
