
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

import java.math.BigDecimal;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Teacher;

@SuppressWarnings("serial")
@Table(tableName = "courseplan")
public class CoursePlan extends BaseModel<CoursePlan> {
	//废弃,更名 为 dao
	public static final CoursePlan dao = new CoursePlan();
	public static final CoursePlan coursePlan = dao;

	public Map<String, Object> getAttrs() {
		return super.getAttrs();
	}
	
	/**
	 * 获取课程信息
	 * @param id
	 * @return
	 */
	public CoursePlan findById(Integer id){
		String sql = "SELECT cp.*,t.REAL_NAME teachername,t.tworktype,"
				+ "s.REAL_NAME studentname,k.SUBJECT_NAME subjectname,c.COURSE_NAME coursename,tr.RANK_NAME rankname,tr.class_hour classhour,"
				+ "x.CAMPUS_NAME campusname,x.fullsign,x.partsign,r.`NAME` roomname,b.classNum FROM courseplan cp \n" +
				"LEFT JOIN account t ON cp.TEACHER_ID=t.Id\n" +
				"LEFT JOIN account s ON cp.STUDENT_ID=s.Id\n" +
				"LEFT JOIN `subject` k ON cp.SUBJECT_ID=k.Id\n" +
				"LEFT JOIN course c ON cp.COURSE_ID=c.Id\n" +
				"LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id\n" +
				"LEFT JOIN campus x ON cp.CAMPUS_ID=x.Id\n" +
				"LEFT JOIN classroom r ON cp.ROOM_ID=r.Id\n" +
				"LEFT JOIN class_order b ON cp.class_id=b.id\n" +
				"WHERE cp.Id=?";
		CoursePlan coursePlan = findFirst(sql, id);
		return coursePlan;
	}
	
	/**
	 * 取出同一个教室，同一个时段，同一个校区上课的所有学生的名字
	 */
	public static String getNames(String roomName,Integer rId,String courseCampusName,String courseDate){
		
		String sql = "SELECT  account.REAL_NAME,account.STATE  FROM  courseplan  "
				+ " LEFT JOIN account ON courseplan.STUDENT_ID = account.Id " 
				+ " INNER JOIN classroom ON courseplan.ROOM_ID = classroom.Id " 
				+ " INNER JOIN campus ON classroom.CAMPUS_ID = campus.Id " 
				+ " WHERE  courseplan.COURSE_TIME = ?  AND classroom.`NAME` = ?  AND courseplan.TIMERANK_ID = ? " 
				+ " and campus.CAMPUS_NAME = ? AND account.state <> 1 and courseplan.PLAN_TYPE!=2  " ;
		
		List<CoursePlan> list = CoursePlan.coursePlan.find(sql,courseDate,roomName,rId, courseCampusName);
		
		StringBuilder str = new StringBuilder(list.size());
		String br = "<br>&nbsp;&nbsp;";
		
		for(CoursePlan cp : list){
			
			if( ! cp.getInt("STATE").equals(2) ){
				str.append(br).append(cp.getStr("REAL_NAME") );
			}
		}
		return str.length() > 0 ? str.substring(br.length()) : "";
	}
	
	/**
	 * 根据日期段查询期间有课的日期
	 */
	public List<CoursePlan> getCourseDate(String date1,String date2){
		String sql = "SELECT " +
				"	DATE_FORMAT(COURSE_TIME, '%Y-%m-%d') as COURSE_TIME  " +
				"FROM " +
				"	courseplan " +
				"WHERE " +
				"	 COURSE_TIME >= ? " +
				"AND COURSE_TIME <= ? " +
				"GROUP BY " +
				"	COURSE_TIME " +
				"ORDER BY " +
				"	COURSE_TIME";
		List<CoursePlan> list = CoursePlan.coursePlan.find(sql, date1,date2);
		return list;
	}
	
	/**
	 * 根据学生id查询已排课的节数
	 */
	public static Integer getUseCourse(Integer stu_id) {
		String sql = "SELECT COUNT(*) AS count_course from courseplan WHERE STUDENT_ID=? and state=0 and PLAN_TYPE=0 ";
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sql, stu_id);
		return cp.getLong("count_course").intValue();
	}
	
	/** 查看该学生是否第一次排课*/
	public Long getUseCourse(Object stu_id, Object tac_id) {
		String sql = "SELECT COUNT(*) from courseplan WHERE STUDENT_ID=? and TEACHER_ID=? and state=0 and PLAN_TYPE=0 ";
		return Db.queryLong(sql, stu_id, tac_id);
	}
	
	/**
	 * 分页查询已取消的排课
	 */
	public static Page<CoursePlan> queryDelCoursePlan(Integer pageNumber,Integer pageSize){
		String select = "SELECT " +
				"courseplan_back.Id, " +
				"DATE_FORMAT(courseplan_back.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME, " +
				"DATE_FORMAT(courseplan_back.UPDATE_TIME,'%Y-%m-%d %H:%i:%s') AS UPDATE_TIME, " +
				"courseplan_back.REMARK, " +
				"courseplan_back.PLAN_TYPE, " +
				"courseplan_back.SIGNIN, " +
				"teacher.REAL_NAME AS teacher_name, " +
				"student.REAL_NAME AS student_name, " +
				"course.COURSE_NAME, " +
				"classroom.`NAME`, " +
				"time_rank.RANK_NAME, " +
				"IFNULL(campus.CAMPUS_NAME,'') AS CAMPUS_NAME, " +
				"IFNULL(class_order.classNum,'无') AS classNum, " +
				"courseplan_back.del_msg ";
		String sql = "FROM " +
				"courseplan_back " +
				"LEFT JOIN account AS student ON courseplan_back.STUDENT_ID = student.Id " +
				"LEFT JOIN account AS teacher ON courseplan_back.TEACHER_ID = teacher.Id " +
				"LEFT JOIN course ON courseplan_back.COURSE_ID = course.Id " +
				"LEFT JOIN classroom ON courseplan_back.ROOM_ID = classroom.Id " +
				"LEFT JOIN time_rank ON courseplan_back.TIMERANK_ID = time_rank.Id " +
				"LEFT JOIN campus ON courseplan_back.CAMPUS_ID = campus.Id " +
				"LEFT JOIN class_order ON courseplan_back.class_id = class_order.id " +
				"ORDER BY courseplan_back.UPDATE_TIME DESC";
		Page<CoursePlan> page = CoursePlan.coursePlan.paginate(pageNumber, pageSize, select, sql);
		return page;
	}

	public long queryCountByTimeRankId(String timeRankId) {
		String sql = "select count(1) counts from courseplan where TIMERANK_ID = "+timeRankId;
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sql);
		return cp.getLong("counts");
	}

	public List<Record> getCoursePlanDay(String courseTime, Integer campusId) {
		String sql = "select cp.ROOM_ID as roomId,tr.RANK_NAME,cp.TIMERANK_ID as timeRankId,cp.PLAN_TYPE as planType,cp.id as planId,rm.NAME as roomName "
				+ "from courseplan AS cp left join time_rank tr on tr.Id = cp.TIMERANK_ID "
				+ " left join classroom AS rm on cp.ROOM_ID=rm.id and rm.CAMPUS_ID= "
				+ campusId + " where cp.course_time  = '"+courseTime +"'" ;
		List<Record> lists = Db.find(sql);
		return lists;
	}

	@SuppressWarnings("unused")
	public List<CoursePlan> getCoursePlansByStuId(String stuId) {
		String sql ="select cp.COURSE_ID,cp.TEACHER_ID,cp.ROOM_ID,cp.COURSE_TIME,cp.TIMERANK_ID,course.COURSE_NAME,teacher.REAL_NAME,classroom.NAME from courseplan as cp "
				+ "left join course on cp.COURSE_ID=course.ID "
				+ "left join account as teacher on cp.TEACHER_ID=teacher.ID "
				+ "left join classroom on cp.ROOM_ID=classroom.ID "
				+ "where STUDENT_ID = ? and class_id = 0  ";
		List<CoursePlan> list = CoursePlan.coursePlan.find(sql, stuId);
		for(int i=0;i<list.size();i++){
			if(list==null)
				list.remove(i);
		}
		return list;
	}

	public List<CoursePlan> getStuCoursePlansBetweenDates(String stuId, String startDate, String endDate) {
		String sql = "select cp.ID,cp.class_id, cp.STUDENT_ID, cp.COURSE_ID , course.COURSE_NAME,"
				+ " cp.TEACHER_ID,teacher.REAL_NAME,cp.TIMERANK_ID,tr.RANK_NAME,tr.class_hour,"
				+ " cp.del_msg,cp.iscancel,cp.CAMPUS_ID,campus.campus_name,"
				+ " cp.ROOM_ID,room.NAME,DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME,cp.iscancel,cp.confirm "
				+ " from courseplan as cp "
				+ "left join course on cp.COURSE_ID=course.ID "
				+ "left join account as teacher on cp.TEACHER_ID=teacher.ID "
				+ "left join time_rank as tr on cp.TIMERANK_ID=tr.ID "
				+ "left join classroom as room on cp.ROOM_ID=room.ID "
				+ "left join campus on cp.CAMPUS_ID=campus.ID "
				+ "where cp.STUDENT_ID = ? "
				+ "and cp.COURSE_TIME >= ? "
				+ "and cp.COURSE_TIME <= ? ";
		List<CoursePlan> lists = coursePlan.find(sql, stuId,startDate,endDate);
		return lists;
	}

	/**
	 * 学生在某天的课程*
	 * @param cpday
	 * @param stuId
	 * @return
	 */
	public List<CoursePlan> getCoursePlansByDay(String cpday, String stuId) {
		String sql = "SELECT cp.ID, cp.STUDENT_ID,cp.TIMERANK_ID,"
				+ " tr.RANK_NAME,DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME,cp.ROOM_ID,cp.CAMPUS_ID "
				+ " FROM courseplan cp "
				+ " LEFT JOIN time_rank as tr on cp.TIMERANK_ID=tr.ID "
				+ " WHERE cp.COURSE_TIME = ? AND cp.STUDENT_ID = ? ";
		List<CoursePlan> cpListDay = coursePlan.find(sql, cpday, stuId);
		return cpListDay;
	}
	
	/**
	 *  某天老师和学生的排课；包括老师休息
	 * @param tchid
	 * @param coursetime
	 * @return
	 */
	public List<CoursePlan> getTeacherPlanesdDay(String studentId, String teacherId, String courseTime){
		String sql = "SELECT cp.id,cp.timerank_id,tr.rank_name,cp.startrest,cp.endrest,cp.plan_type\n" +
				"FROM courseplan cp LEFT JOIN\n" +
				"teachergrade tg on cp.id=tg.courseplan_id \n" +
				"left join time_rank as tr on cp.TIMERANK_ID=tr.ID\n" +
				"WHERE (cp.STUDENT_ID=? OR tg.studentid=? OR cp.TEACHER_ID=?) AND cp.COURSE_TIME=?";
		return coursePlan.find(sql, studentId, studentId, teacherId,courseTime);
	}
	
	/**
	 * 老师某天的课程*
	 * @param courseTime
	 * @param teacherId
	 * @return
	 */
	public List<CoursePlan> getTeacherCoursePlansByDay(String courseTime, String teacherId) {
		String sql = "select cp.ID,cp.STUDENT_ID, cp.TIMERANK_ID,"
				+ " tr.RANK_NAME,DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME ,"
				+ " cp.ROOM_ID,cp.CAMPUS_ID from courseplan as cp "
				+ "left join time_rank as tr on cp.TIMERANK_ID=tr.ID "
				+ "where cp.PLAN_TYPE!=2 AND cp.COURSE_TIME = ? and cp.TEACHER_ID = ? and iscancel=0 ";
		List<CoursePlan> cpListDay = coursePlan.find(sql, courseTime, teacherId);
		return cpListDay;
	}
/**
 * 根据教师ID获得课程列表
 * @param tId
 * @param startDate
 * @param endDate
 * @return
 */
	public List<CoursePlan> getCoursePlansByTeacherId(String tId, String startDate, String endDate) {
		String sql = "select cp.ID, cp.STUDENT_ID, cp.COURSE_ID,cp.class_id,co.CLASSNUM,"
				+ "  cp.STATE,course.COURSE_NAME,cp.TEACHER_ID,teacher.REAL_NAME,"
				+ " cp.TIMERANK_ID,tr.RANK_NAME,campus.campus_name,cp.ROOM_ID,"
				+ " room.NAME,DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME ,cp.iscancel,cp.confirm "
				+ " from courseplan as cp "
				+ "left join course on cp.COURSE_ID=course.ID "
				+ "left join account as teacher on cp.TEACHER_ID=teacher.ID "
				+ "left join time_rank as tr on cp.TIMERANK_ID=tr.ID "
				+ "left join classroom as room on cp.ROOM_ID=room.ID "
				+ "left join class_order as co on cp.class_id = co.ID "
				+ "left join campus on cp.CAMPUS_ID=campus.ID "
				+ "where 1=1 AND cp.PLAN_TYPE !=2 and cp.TEACHER_ID = ? "
				+ "and cp.COURSE_TIME >= ? "
				+ "and cp.COURSE_TIME <= ?  ";
		List<CoursePlan> lists = coursePlan.find(sql, tId,startDate,endDate);
		return lists;
	}
	/**
	 * 根据时段ID获取排课记录
	 * @param rankId
	 * @param dayTime
	 * @return
	 */
	public List<CoursePlan> getCoursePlansByTimerankId(Integer rankId, String dayTime) {
		String sql = "select cp.ROOM_ID,tr.rank_name,"
				+ " DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME from courseplan cp"
				+ " left join time_rank tr on cp.TIMERANK_ID = tr.id "
				+ "  where cp.PLAN_TYPE!=2 AND cp.TIMERANK_ID = ? and cp.COURSE_TIME = ? ";
		List<CoursePlan> list = coursePlan.find(sql, rankId,dayTime);
		return list;
	}
	/**
	 * 根据时段ID获取排课记录
	 * @param rankIds:1,3,4,5
	 * @param dayTime
	 * @return
	 */
	public List<CoursePlan> getCoursePlansByTimerankIds(String rankIds, String dayTime) {
		String sql = "select cp.ROOM_ID,tr.rank_name,"
				+ " DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME from courseplan cp"
				+ " left join time_rank tr on cp.TIMERANK_ID = tr.id "
				+ "  where cp.PLAN_TYPE!=2 AND cp.TIMERANK_ID IN("+rankIds+") and cp.COURSE_TIME = ? ";
		List<CoursePlan> list = coursePlan.find(sql,dayTime);
		return list;
	}
	
	/**
	 * 根据时段ID获取排课记录(不含已取消）
	 * @param rankIds:1,3,4,5
	 * @param dayTime
	 * @return
	 */
	public List<CoursePlan> getCoursePlansByTimerankIdsNocancel(String rankIds, String dayTime) {
		String sql = "select cp.ROOM_ID,tr.rank_name,"
				+ " DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME from courseplan cp"
				+ " left join time_rank tr on cp.TIMERANK_ID = tr.id "
				+ "  where cp.PLAN_TYPE!=2 AND cp.iscancel!=1 AND cp.TIMERANK_ID IN("+rankIds+") and cp.COURSE_TIME = ? ";
		List<CoursePlan> list = coursePlan.find(sql,dayTime);
		return list;
	}
	
	/**
	 * 根据教室ID获取排课记录
	 * @param roomId
	 * @param dayTime
	 * @return
	 */
	public List<CoursePlan> getCoursePlansByRoomId(Integer roomId, String dayTime) {
		String sql = "select cp.ROOM_ID,tr.rank_name,"
				+ " DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME from courseplan cp"
				+ " left join time_rank tr on cp.TIMERANK_ID = tr.id "
				+ "  where cp.PLAN_TYPE!=2 AND cp.ROOM_ID = ? and cp.COURSE_TIME = ? ";
		List<CoursePlan> list = coursePlan.find(sql, roomId,dayTime);
		return list;
	}

	public double getYpVIPkcCount(Integer studentId, Integer courseId) {
		if(studentId==null || courseId==null){
			return 0;
		}
		String sql = "SELECT IFNULL(SUM(t.class_hour),0) ks from courseplan cp " +
				"LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id "
				+ "WHERE cp.state=0 and cp.PLAN_TYPE=0 and class_id=0 and cp.STUDENT_ID=? and cp.COURSE_ID=?";
		BigDecimal sumhour = Db.queryBigDecimal(sql,studentId,courseId);
		return sumhour==null?0:sumhour.doubleValue();
	}
	
	/**
	 * 根据学生id查询已排课的节数
	 */
	public float getUseClasshour(String studentId,String courseId) {
		if(StringUtils.isEmpty(studentId)){
			return 0;
		}
		StringBuffer sql = new StringBuffer("SELECT IFNULL(SUM(t.class_hour),0) ks from courseplan cp " +
				"LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id " +
				"WHERE cp.STUDENT_ID=? and cp.state=0 and cp.PLAN_TYPE=0 and class_id = 0 ");
		if(!StringUtils.isEmpty(courseId)){
			sql.append(" and cp.course_id=").append(courseId);
		}
		BigDecimal sumhour = Db.queryBigDecimal(sql.toString(),Integer.parseInt(studentId));
		return sumhour==null?0:sumhour.floatValue();
	}
	
	/**
	 * 获取学生课程消耗情况
	 * @param studentId
	 * @param subjectId
	 * @return
	 */
	public double getUsedVIPClasshour(Integer studentId, Integer subjectId) {
		String sql = " SELECT IFNULL(SUM(t.class_hour),0) ks FROM courseplan cp " 
				+ " LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id " 
				+ " WHERE cp.STUDENT_ID = ? and cp.SUBJECT_ID = ? ";
		return Db.queryBigDecimal(sql, studentId, subjectId).doubleValue();
	}

	public List<CoursePlan> getClassCoursePlansBetweenDates(String banciId, String startDate, String endDate) {
		String sql = "select cp.ID,cp.class_id, cp.STUDENT_ID, cp.COURSE_ID , course.COURSE_NAME,cp.TEACHER_ID,teacher.REAL_NAME,"
				+ "cp.TIMERANK_ID,tr.RANK_NAME,campus.campus_name,cp.ROOM_ID,room.NAME,DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME "
				+ " from courseplan as cp  left join course on cp.COURSE_ID=course.ID "
				+ "left join account as teacher on cp.TEACHER_ID=teacher.ID "
				+ "left join time_rank as tr on cp.TIMERANK_ID=tr.ID "
				+ "left join classroom as room on cp.ROOM_ID=room.ID "
				+ "left join campus on cp.CAMPUS_ID=campus.ID "
				+ "where cp.class_id = ?  and cp.COURSE_TIME >= ? "
				+ "and cp.COURSE_TIME <= ?   ";
		List<CoursePlan> lists = coursePlan.find(sql, banciId,startDate,endDate);
		return lists;
	}

	public CoursePlan getStuCoursePlan(String studentId, String timeId, String courseTime) {
		String sql = "select * from courseplan where student_id = ? and  timerank_id = ? and course_time = ? ";
		CoursePlan cp = coursePlan.findFirst(sql, studentId,timeId,courseTime);
		return cp;
	}

	public List<CoursePlan> getClassCoursePlan(Integer classOrder_id, String timeId, String courseTime) {
		String sql = "select * from courseplan where class_id = ? and  timerank_id = ? and course_time = ? ";
		List<CoursePlan> list = coursePlan.find(sql, classOrder_id,timeId,courseTime);
		return list;
	}
	/**
	 * 删除排课记录
	 * @param coursePlanId
	 * @param operateUserId
	 * @param delmsg
	 * @return
	 */
	public Integer deleteStuCoursePlan(Integer coursePlanId, Integer operateUserId, String delmsg) {
		try{
			CoursePlan cp = CoursePlan.coursePlan.findById(coursePlanId);
			cp.set("del_msg", delmsg).set("update_time", ToolDateTime.getDate()).set("deluserid", operateUserId).update();
			String sql1 = "insert into courseplan_back SELECT * from  courseplan where courseplan.id = ? ";
			Db.update(sql1, coursePlanId);
			cp.delete();
			Db.update("update account_book set status=? ,canceluserid=? ,canceltime=? where courseplanid=?", 1,operateUserId,ToolDateTime.getCurDateTime(),coursePlanId);
			return 1;
		}catch(Exception ex){
			ex.printStackTrace();
			return 0;
		}
	}

	/**
	 * 查询班课已排课时*
	 * @param classOrderId
	 * @return
	 */
	public float getClassYpkcClasshour(Integer classOrderId) {
		String sql = " SELECT IFNULL(SUM(t.class_hour),0) ks from courseplan cp " 
				+ " LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id " 
				+ " WHERE cp.class_id = ?  and cp.PLAN_TYPE=0 ";
		BigDecimal sumhour = Db.queryBigDecimal(sql,classOrderId);
		return sumhour==null?0:sumhour.floatValue();
	}
	/**
	 * 查询班课已用课时,包含今天
	 * @param classOrderId
	 * @return
	 */
	public float getClassUseClasshour(Integer classOrderId) {
		String sql = "SELECT IFNULL(SUM(t.class_hour),0) ks from courseplan cp " +
				"LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id " +
				"WHERE cp.class_id = ? and cp.PLAN_TYPE=0 AND cp.course_time <= now()";
		BigDecimal sumhour = Db.queryBigDecimal(sql,classOrderId);
		return sumhour==null?0:sumhour.floatValue();
	}

	public float getClassYpkcCount(Integer stuId, Integer courseId) {
			if(stuId==null || courseId==null){
				return 0;
			}
			String sql = "SELECT IFNULL(SUM(t.class_hour),0) ks from courseplan cp " +
					"LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id "
					+ "WHERE  cp.PLAN_TYPE=0 and cp.STUDENT_ID=? and cp.COURSE_ID=?";
			BigDecimal sumhour = Db.queryBigDecimal(sql,stuId,courseId);
			return sumhour==null?0:sumhour.floatValue();
	}

	public Long getCoursePlanMonth(Integer sysId, String firstDay, String dayStr) {
		String sql = "select sum(tr.class_hour) as counts from courseplan cp "
				+ " left join time_rank tr on tr.id = cp.TIMERANK_ID  "
				+ " left join account stu on  stu.ID = cp.STUDENT_ID "
				+ " left join crm_opportunity co on stu.opportunityid = co.id "
				+ " where (class_id<>0) or (cp.state=0 AND cp.class_id =0))  and  COURSE_TIME>= ? and COURSE_TIME <= ?  ";
		if(sysId!=null){
			SysUser sysuser = SysUser.dao.findById(sysId);
			if(!Role.isAdmins(sysuser.getStr("roleids"))){
				sql += " and co.scuserid = " + sysId ;
			}
		}
		return coursePlan.findFirst(sql, firstDay, dayStr).getBigDecimal("counts")==null?0:coursePlan.findFirst(sql, firstDay, dayStr).getBigDecimal("counts").longValue();
	}
	
	
	public List<CoursePlan> findByStudentId(Integer studentId , String startDate,String endDate) {
		String sql = "SELECT cp.*,r.class_hour FROM courseplan cp LEFT JOIN time_rank r ON cp.TIMERANK_ID=r.Id where cp.student_id = ? ";
		if(!StringUtils.isEmpty(startDate))
			sql +=" and DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') >= '"+startDate+"'";
		if(!StringUtils.isEmpty(endDate))
			sql +=" and DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') <= '"+endDate+"'";
		List<CoursePlan> clist = CoursePlan.coursePlan.find(sql,studentId);
		return clist;
	}

	public CoursePlan getCoursePlanBack(String id) {
		String sql = "select cb.COURSE_ID,cb.del_msg,c.COURSE_NAME from courseplan_back cb left join course c on cb.COURSE_ID=c.id where cb.Id= ? ";
		CoursePlan cp = coursePlan.findFirst(sql, id);
		return cp;
	}
	
	public CoursePlan getCoursePlan(String id) {
		String sql = "select cp.COURSE_ID,cp.CREATE_TIME,cp.STUDENT_ID,cp.COURSE_TIME,c.COURSE_NAME "
				+ " from courseplan cp left join course c on cp.COURSE_ID=c.id where cp.Id= ? ";
		CoursePlan cp = coursePlan.findFirst(sql, id);
		if(cp==null){
			String sql2 = "select cp.COURSE_ID,cp.CREATE_TIME,cp.STUDENT_ID,cp.COURSE_TIME,c.COURSE_NAME from courseplan_back cp left join course c on cp.COURSE_ID=c.id where cp.Id= ? ";
			cp = coursePlan.findFirst(sql2, id);
		}
		return cp;
	}

	/**
	 * 查看小班学员交费的时候是否与学员的课程有重复
	 * @param studentid
	 * @param xiaobanid
	 * @return 学员重复的courseplan
	 */
	public List<CoursePlan> repeatCoursePlan(Integer studentid, Integer xiaobanid) {
		if(StringUtils.isEmpty(studentid.toString())&&StringUtils.isEmpty(xiaobanid.toString())){
			return null;
		}else{
			String sql = "SELECT DATE_FORMAT(COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME,TIMERANK_ID,class_id FROM courseplan WHERE class_id=? and STATE = 1 and COURSE_TIME > curdate()";
			List<CoursePlan> xiaobancplist = CoursePlan.coursePlan.find(sql, xiaobanid);
			String stusql = "SELECT DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME,cp.TIMERANK_ID,tr.RANK_NAME, c.COURSE_NAME FROM courseplan cp "
					+ " left join course c on c.Id = cp.COURSE_ID left join time_rank tr on tr.Id=cp.TIMERANK_ID "
					+ " WHERE cp.student_id=? and cp.COURSE_TIME > curdate() ";
			List<CoursePlan> stucplist =CoursePlan.coursePlan.find(stusql, studentid);
			List<CoursePlan> list = new ArrayList<CoursePlan>();
			Iterator<CoursePlan> it = stucplist.iterator();
			while(it.hasNext()){
				CoursePlan plan = it.next();
				for(CoursePlan cp : xiaobancplist){
					if(cp.get("COURSE_TIME").equals(plan.get("COURSE_TIME"))&&cp.getInt("TIMERANK_ID") == plan.getInt("TIMERANK_ID")){
						list.add(plan);
					}
				}
			}
			
			return list;
		}
		
	}

	/**
	 * 根据学生ID查看科目是否已排课使用
	 * @param studentId
	 * @param subjectId
	 * @return true:已排课，fasle:未排课
	 */
	public boolean checkSubjectIsUse(Integer studentId, Integer subjectId) {
		String sql = "SELECT COUNT(1) FROM courseplan WHERE STUDENT_ID=? AND SUBJECT_ID=?";
		return Db.queryLong(sql, studentId, subjectId) > 0;
	}

	/**
	 * 某天、某时段、某个老师是否有课
	 * @param timerankid
	 * @param stime
	 * @param teacherId
	 * @return
	 */
	public Long queryCoursePlanCount(String timeid, String stime, String teacherId) {
		String sql = "select count(1) counts from courseplan where  COURSE_TIME = ? AND TEACHER_ID = ? and TIMERANK_ID = ?  AND PLAN_TYPE != 2 ";
		CoursePlan cp = coursePlan.findFirst(sql,stime,teacherId,timeid);
		if(cp==null){
			return 0L;
		}else{
			return cp.getLong("counts");
		}
	}

	/**
	 * 某天、某时间段、老师休息
	 * @param stime
	 * @param etime
	 * @param stime
	 * @param teacherId
	 * @return
	 */
	public List<CoursePlan> queryTeacherRestPlan(String stime, String etime, String coursetime, String teacherId) {
		String sql = "select * from courseplan where startrest = ? and endrest = ?  and COURSE_TIME = ? AND TEACHER_ID = ? and PLAN_TYPE = 2 ";
		List<CoursePlan> cp = coursePlan.find(sql,stime,etime,coursetime,teacherId);
		return cp;
	}

	/**
	 * 某天老师多少个休息时段
	 * @param stime
	 * @param teacherId
	 * @return
	 */
	public List<CoursePlan> queryDayRestCount(String stime, String teacherId) {
		String sql = "select * from courseplan where COURSE_TIME=? AND TEACHER_ID=? and PLAN_TYPE = 2 ";
		return coursePlan.find(sql,stime,teacherId);
	}

	/**
	 * 某天某时段有没有排课了
	 * @param int1
	 * @param int2
	 * @param day
	 * @return
	 */
	public long queryCoursePlanCRTRCount(Integer tr, Integer croom, String day) {
		String sql ="select count(1) counts from courseplan where COURSE_TIME = ? AND TIMERANK_ID = ? AND ROOM_ID =?  ";
		CoursePlan plan = coursePlan.findFirst(sql, day, tr,croom );
		if(plan==null){
			return 0;
		}else{
			return plan.getLong("counts");
		}
	}
	public String cpIdToGetRankTime(String courseplan_id){
		String sql = "select tr.RANK_NAME as rank_name  from courseplan cp  "
				+ " left join time_rank tr on cp.TIMERANK_ID = tr.Id where cp.Id=?";
		CoursePlan courseplan = CoursePlan.coursePlan.findFirst(sql, courseplan_id);
		return courseplan.getStr("rank_name");
	}
	
	
	public List<CoursePlan> querycpList(String stuid,String courseid){
		StringBuffer sb = new StringBuffer("select * from courseplan where 1=1  ");
		if(!StringUtils.isEmpty(stuid)){
			sb.append(" and STUDENT_ID=").append(stuid);
		}
		if(!StringUtils.isEmpty(courseid)){
			sb.append(" and COURSE_ID=").append(courseid);
		}
		List<CoursePlan> cplist = coursePlan.find(sb.toString());
		return cplist;
	}

	public CoursePlan getLastCoursePlan(String stuid, String courseid) {
		Student student = Student.dao.findById(stuid);
		Integer state = student.getInt("state");
		StringBuffer sb = new StringBuffer("select DATE_FORMAT(COURSE_TIME,'%Y-%m-%d') lasttime,teacher_id,room_id,timerank_id  from courseplan where Id = (select MAX(Id) id from courseplan ");
//		String sql ="select COURSE_TIME  from courseplan where Id = (select MAX(Id) id from courseplan where 1=1 and studentid = ? and course_id=?) ";
		StringBuffer wheresql = new StringBuffer(" where 1=1 ");
		if(!StringUtils.isEmpty(stuid)){
			wheresql.append(" and STUDENT_ID=").append(stuid);
		}
		if(!StringUtils.isEmpty(courseid)){
			wheresql.append(" and COURSE_ID=").append(courseid);
		}
		if(state.toString().equals("2"))
			wheresql.append(" and class_id !=0  ");
		else
			wheresql.append(" and class_id = 0 ");
		
		String sql = " ) ";
		CoursePlan plan = coursePlan.findFirst((sb.append(wheresql).toString()+sql));
		return plan;
	}
	
	/**
	 * 获取一对一已排科目课时
	 * @param studentId
	 * @return
	 */
	public List<CoursePlan> getVipYpks(Integer studentId) {
		String sql = "SELECT s.id subjectId,s.SUBJECT_NAME km,a.ypks FROM " +
				"(select cp.SUBJECT_ID,SUM(t.class_hour) ypks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id=0 AND cp.STUDENT_ID=? GROUP BY cp.SUBJECT_ID) a " +
				"LEFT JOIN `subject` s ON a.SUBJECT_ID=s.Id";
		return coursePlan.find(sql, studentId);
	}
	/**
	 * 获取一对一已上科目课时
	 * @param studentId
	 * @return
	 */
	public List<CoursePlan> getVipYsks(Integer studentId) {
		String datetime = ToolDateTime.getCurDate()+" 23:59:59";
		String sql = "SELECT s.id subjectId,s.SUBJECT_NAME km,a.ypks FROM " +
				"(select cp.SUBJECT_ID,SUM(t.class_hour) ypks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id=0 AND cp.STUDENT_ID=? AND course_time<=? GROUP BY cp.SUBJECT_ID) a " +
				"LEFT JOIN `subject` s ON a.SUBJECT_ID=s.Id";
		return coursePlan.find(sql, studentId,datetime);
	}
	
	/**
	 * 获取一对一已排课时
	 * @param studentId
	 * @return
	 */
	public double getYpksForVIP(Integer studentId) {
		String sql = "select SUM(t.class_hour) ypks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id=0 AND cp.STUDENT_ID=?";
		return Db.queryBigDecimal(sql, studentId)==null?0:Db.queryBigDecimal(sql, studentId).doubleValue();
	}
	/**
	 * 获取一对一已上课时
	 * @param studentId
	 * @return
	 */
	public double getYsksForVIP(Integer studentId) {
		String datetime = ToolDateTime.getCurDate()+" 23:59:59";
		String sql = "select SUM(t.class_hour) ypks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id=0 AND cp.STUDENT_ID=? AND course_time<=?";
		return Db.queryBigDecimal(sql, studentId,datetime)==null?0:Db.queryBigDecimal(sql, studentId,datetime).doubleValue();
	}

	/**
	 * 获取一对一以上科目课时
	 * @param studentId
	 * @param subjectId
	 * @return
	 */
	public double getVipYsks(Integer studentId, Integer subjectId) {
		String sql = "select cp.SUBJECT_ID,SUM(t.class_hour) ysks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id=0  AND cp.course_time < curdate() AND cp.STUDENT_ID=? and cp.SUBJECT_ID=?";
		BigDecimal ysks = coursePlan.findFirst(sql, studentId,subjectId).getBigDecimal("ysks");
		return ysks == null?0:ysks.doubleValue();
	}

	/**
	 * 获取学生班课已排课时
	 * @param studentId
	 * @return
	 */
	public List<CoursePlan> getBanYpks(Integer studentId) {
		String sql = "SELECT o.id banciId,o.classtype_id banxingId , o.classNum bcbh,a.ypks FROM " +
				"(select cp.class_id,SUM(t.class_hour) ypks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id!=0 AND cp.STUDENT_ID=? GROUP BY cp.class_id) a " +
				"LEFT JOIN class_order o ON a.class_id=o.id";
		return CoursePlan.coursePlan.find(sql,studentId);
	}

	/**
	 * 获取学生班课已上课时
	 * @param studentId
	 * @param banciId
	 * @return
	 */
	public double getBanYsks(Integer studentId, Integer banciId) {
		String sql = "select cp.class_id,SUM(t.class_hour) ysks from courseplan cp  " +
				"left join time_rank t on cp.TIMERANK_ID=t.Id " +
				"WHERE cp.PLAN_TYPE=0 and cp.STATE=0 AND cp.class_id!=0 AND cp.course_time < curdate() AND cp.STUDENT_ID=? AND cp.class_id=?";
		BigDecimal ysks = coursePlan.findFirst(sql, studentId,banciId).getBigDecimal("ysks");
		return ysks == null?0:ysks.doubleValue();
	}
	/**
	 * 获取班课
	 * @param studentId
	 * @return
	 */
	public double getBanJiYpks(Integer studentId){
		String sql = "select cp.class_id banciId,b.classtype_id banxingId,b.classNum bcbh,SUM(t.class_hour) ypks from teachergrade tg\n" +
				"left join courseplan cp on tg.COURSEPLAN_ID=cp.Id\n" +
				"left join time_rank t on cp.TIMERANK_ID=t.Id\n" +
				"left join class_order b on cp.class_id=b.id\n" +
				"WHERE cp.class_id!=0 AND cp.PLAN_TYPE=0 AND cp.STATE=0 AND tg.studentid=?";
		BigDecimal ysks = coursePlan.findFirst(sql, studentId).getBigDecimal("ypks");
		return ysks == null?0:ysks.doubleValue();
	}
	/**
	 * 获取班课
	 * @param studentId
	 * @return
	 */
	public double getBanJiYsks(Integer studentId){
		String sql = "select cp.class_id banciId,b.classtype_id banxingId,b.classNum bcbh,SUM(t.class_hour) ypks from teachergrade tg\n" +
				"left join courseplan cp on tg.COURSEPLAN_ID=cp.Id\n" +
				"left join time_rank t on cp.TIMERANK_ID=t.Id\n" +
				"left join class_order b on cp.class_id=b.id\n" +
				"WHERE cp.class_id!=0 AND cp.PLAN_TYPE=0 AND cp.STATE=0 AND tg.studentid=? and cp.course_time < curdate()";
		BigDecimal ysks = coursePlan.findFirst(sql, studentId).getBigDecimal("ypks");
		return ysks == null?0:ysks.doubleValue();
	}
	//总课时
	public Long getAmountCous() {
//		
//		Long cous = Db.queryLong("select count(jieshu) from courseplan");
//		return cous;
		String sql = "select sum(tr.class_hour) as counts from courseplan cp "
				+ " left join time_rank tr on tr.id = cp.TIMERANK_ID  "
				+ " left join account stu on  stu.ID = cp.STUDENT_ID "
				+ " left join crm_opportunity co on stu.opportunityid = co.id "
				+ " where (( class_id<>0) or (cp.state=0 AND cp.class_id =0)) ";
		
		return coursePlan.findFirst(sql).getBigDecimal("counts")==null?0:coursePlan.findFirst(sql).getBigDecimal("counts").longValue();
	}
	//周课时
	public double getKeShi(String date1, String date2) {
		
//		Long keshi = Db.queryLong("select sum(jieshu) from courseplan where createtime <='"+date+"'");
//		return keshi;
		String sql = "SELECT sum(tr.class_hour) AS counts FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.TIMERANK_ID WHERE class_id <> 0 AND COURSE_TIME >'"+date1+"'";
		String sql2 = "SELECT sum(tr.class_hour) AS counts FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.TIMERANK_ID WHERE	cp.state = 0 AND class_id = 0 AND COURSE_TIME > '"+date1+"'";
		BigDecimal t1 = Db.queryBigDecimal(sql);
		BigDecimal t2 = Db.queryBigDecimal(sql2);
		return  t1.doubleValue()+t2.doubleValue();
	}
	
	public long queryTeacherCourseplansCounts(String teachid,String coursetime){
		String sql ="select count(1) counts from courseplan where COURSE_TIME = ? AND TEACHER_ID =?  ";
		CoursePlan plan = coursePlan.findFirst(sql, coursetime, teachid );
		if(plan==null){
			return 0;
		}else{
			return plan.getLong("counts");
		}
	}
	
	/**
	 * 查询学生的全部课程信息
	 * @param stuid
	 * @return
	 */
	public List<CoursePlan> queryStudentCourseInfo(Integer stuid){
		if(null == stuid ){
			return null;
		}
		String sql = "SELECT * FROM (\n" +
				"(SELECT s.REAL_NAME studentname, cp.COURSE_TIME,cp.rankname,cp.COURSE_NAME,cp.teachername,cp.class_hour classhour,cp.CAMPUS_NAME,cp.roomname, cp.class_id,s.id sid,cp.TEACHER_PINGLUN\n" +
				"FROM teachergrade tg \n" +
				"LEFT JOIN account s ON tg.studentid=s.Id\n" +
				"LEFT JOIN (SELECT p.Id,p.TEACHER_PINGLUN,p.class_id,p.CAMPUS_ID,c.CAMPUS_NAME,m.`NAME` roomname,p.COURSE_TIME,t.class_hour,t.RANK_NAME rankname,tc.REAL_NAME teachername,k.COURSE_NAME,p.TEACHER_ID,p.SUBJECT_ID,p.COURSE_ID\n" +
				"FROM courseplan p LEFT JOIN time_rank t ON p.TIMERANK_ID=t.Id LEFT JOIN campus c ON p.CAMPUS_ID=c.Id LEFT JOIN classroom m ON p.ROOM_ID=m.id LEFT JOIN account tc ON p.TEACHER_ID=tc.Id\n" +
				"LEFT JOIN course k ON p.COURSE_ID=k.Id WHERE p.PLAN_TYPE=0 " +
				") cp ON tg.COURSEPLAN_ID=cp.Id\n" +
				"WHERE cp.class_id!=0 AND s.STATE!=2 AND s.ID=? "+
				"\nUNION ALL\n" +
				"(SELECT s.REAL_NAME studentname, cp.COURSE_TIME,tr.RANK_NAME rankname,k.COURSE_NAME,tc.real_name teachername,tr.class_hour classhour,c.CAMPUS_NAME,m.`NAME` roomname, cp.class_id,s.id sid,cp.TEACHER_PINGLUN\n" +
				"FROM courseplan cp  \n" +
				"LEFT JOIN account s ON cp.STUDENT_ID = s.Id\n" +
				"LEFT JOIN account tc ON cp.TEACHER_ID=tc.Id\n" +
				"LEFT JOIN time_rank tr ON cp.TIMERANK_ID = tr.Id  \n" +
				"LEFT JOIN campus c ON cp.CAMPUS_ID = c.Id\n" +
				"LEFT JOIN course k ON cp.COURSE_ID=k.Id\n" +
				"LEFT JOIN classroom m ON cp.ROOM_ID=m.Id\n" +
				"WHERE cp.plan_type=0 and cp.STATE = 0 AND cp.class_id = 0 AND s.ID=? ))) a ORDER BY a.COURSE_TIME,a.rankname";
		return find(sql,stuid,stuid);
	}
	
	
	/**
	 * //课时
	 * @param date1
	 * @param date2
	 * @param integer
	 * @return
	 */
	public double monthkeshi(String date1, String date2, Integer integer, String loginRoleCampusIds ) {
		Account user = Account.dao.findById(integer);
		StringBuffer sql1 = new  StringBuffer(" SELECT sum(tr.class_hour) AS counts FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.TIMERANK_ID ");
		StringBuffer sql2 = new  StringBuffer(" SELECT sum(tr.class_hour) AS counts FROM courseplan cp LEFT JOIN time_rank tr ON tr.id = cp.TIMERANK_ID ");
		BigDecimal t1 = null;
		BigDecimal t2 = null;
		
		if(Role.isKcgw(user.getStr("roleids"))){//课程顾问
			sql1.append(" left join account a ON cp.STUDENT_ID = a.id left join student_kcgw ak ON a.Id = ak.student_id ");
			sql2.append(" left join account a ON cp.STUDENT_ID = a.id left join student_kcgw ak ON a.Id = ak.student_id ");
		}
		sql1.append(" WHERE	 class_id <> 0 AND COURSE_TIME >= ? AND COURSE_TIME <= ? ");
		sql2.append(" WHERE	cp.state = 0 AND class_id =  0 AND COURSE_TIME >= ? AND COURSE_TIME <= ? ");
		
		if(Role.isKcgw(user.getStr("roleids"))){//课程顾问
			sql1.append(" and ak.kcgw_id = ?");
			sql2.append(" and ak.kcgw_id = ?");
			if( !StringUtils.isEmpty(loginRoleCampusIds) ){
				sql1.append( " AND cp.campus_id in (" + loginRoleCampusIds + ")" );
				sql2.append( " AND cp.campus_id in (" + loginRoleCampusIds + ")" );
			}
			t1 = Db.queryBigDecimal(sql1.toString(),date1,date2,integer);
			t2 = Db.queryBigDecimal(sql2.toString(),date1,date2,integer);
		}
		
		else{
			if( !StringUtils.isEmpty(loginRoleCampusIds) ){
				sql1.append( " AND cp.campus_id in (" + loginRoleCampusIds + ")" );
				sql2.append( " AND cp.campus_id in (" + loginRoleCampusIds + ")" );
			}
			t1 = Db.queryBigDecimal(sql1.toString(),date1,date2);
			t2 = Db.queryBigDecimal(sql2.toString(),date1,date2);
		}
		double td1 = t1==null?0:t1.doubleValue();
		double td2 = t2==null?0:t2.doubleValue();
		return  td1+td2;
	}
	
	//季度课时
	public Long thmonthkeshi(String date1) {
		String sql = "select sum(tr.class_hour) as counts from courseplan cp "
				+ " left join time_rank tr on tr.id = cp.TIMERANK_ID  "
				+ " left join account stu on  stu.ID = cp.STUDENT_ID "
				+ " left join crm_opportunity co on stu.opportunityid = co.id "
				+ " where (( class_id<>0) or (cp.state=0 AND cp.class_id =0))  and  COURSE_TIME>= ?   ";
		
		return coursePlan.findFirst(sql, date1).getBigDecimal("counts")==null?0:coursePlan.findFirst(sql, date1).getBigDecimal("counts").longValue();
		
	}


	public double getYear(String date, String now) {
		//小班
		String s1 = "SELECT SUM(class_hour) AS a1 FROM courseplan a2 LEFT JOIN time_rank a3 ON a3.Id = a2.TIMERANK_ID WHERE a2.PLAN_TYPE = 0 AND a2.class_id <> 0 AND a2.STATE = 1 AND a2.COURSE_TIME >= '"+date+"' and a2.COURSE_TIME <='"+now+"'";                             
		//一对一
		String s2 = "SELECT SUM(class_hour) AS a1 FROM courseplan a2 LEFT JOIN time_rank a3 ON a3.Id = a2.TIMERANK_ID WHERE a2.PLAN_TYPE = 0 AND a2.class_id = 0 AND a2.STATE = 0 AND a2.COURSE_TIME >= '"+date+"' and a2.COURSE_TIME <='"+now+"'"; 
		BigDecimal t1 = Db.queryBigDecimal(s1);
		BigDecimal t2 = Db.queryBigDecimal(s2);
		return t1.doubleValue() + t2.doubleValue();
	}

	/**
	 * 某个学生消耗的课时数量  group by  teachtype,subjectid
	 * @param id
	 * @return
	 */
	public List<CoursePlan> queryStudentSubjectHoursUsed(Integer studentId) {
		String nowdate = ToolDateTime.dateToDateString(new Date(), "yyyy-MM-dd")+" 23:59:59";
		String sql = "(SELECT sum(tr.class_hour)sumhours,class_id,subject_id FROM courseplan LEFT JOIN time_rank tr ON tr.id = courseplan.timerank_id\n" +
				"WHERE courseplan.plan_type = 0 AND student_id = ? AND class_id = 0 AND course_time <= ? GROUP BY class_id, subject_id)\n" +
				"UNION ALL\n" +
				"(SELECT sum(tr.class_hour)sumhours, class_id, subject_id FROM courseplan LEFT JOIN time_rank tr ON tr.id = courseplan.timerank_id\n" +
				"WHERE courseplan.plan_type = 0 AND student_id = ? AND class_id <> 0 AND course_time <= ? GROUP BY class_id)";
		return coursePlan.find(sql,studentId,nowdate,studentId,nowdate);
	}

	/**
	 * 已排,同上
	 * @param id
	 * @return
	 */
	public List<CoursePlan> queryStudentSubjectHoursPlaned(String id) {
		StringBuffer sb = new StringBuffer("");
		sb.append("select sum(tr.class_hour) sumhours,class_id,subject_id from courseplan left join time_rank tr on tr.id=courseplan.timerank_id where courseplan.plan_type=0 and student_id = ").append(id).append(" and class_id=0   group by subject_id ");
		StringBuffer sbclass = new StringBuffer("");
		sbclass.append("select sum(tr.class_hour) sumhours,class_id,subject_id from courseplan left join time_rank tr on tr.id=courseplan.timerank_id where courseplan.plan_type=0 and student_id = ").append(id).append(" and class_id<>0 group by class_id ");
		return coursePlan.find("( "+sb.append(" ) ").append("  UNION ALL ").append("( ").append(sbclass).append(" )").toString());
	}

	/**
	 * 某个学生某科目下排课总数（今天之后）
	 * @param sub_id
	 * @param studentid
	 * @param teachtype
	 * @return
	 */
	public List<CoursePlan> querySubStuCps(String subId, String studentid, String teachtype, Integer classorderid) {
		String nowhm = ToolDateTime.getCurDateTime().substring(11, 16);
		List<TimeRank> trlist = TimeRank.dao.find("select id from time_rank where rank_name > ? ",nowhm);
		StringBuffer trids = new StringBuffer();
		if(trlist!=null&&trlist.size()>0){
			for(TimeRank tr:trlist){
				trids.append(",").append(tr.getInt("id"));
			}
		}
		String nowdate = ToolDateTime.dateToDateString(new Date(), "yyyy-MM-dd");
		String classsql = teachtype.equals("1")?" and courseplan.class_id = 0 ":" and courseplan.class_id = "+classorderid;
		StringBuffer sb = new StringBuffer("");
		sb.append("select sum(tr.class_hour) sumhours,class_id,courseplan.subject_id,sub.SUBJECT_NAME,courseplan.course_id,course.course_name,courseplan.student_id from courseplan left join time_rank tr on tr.id=courseplan.timerank_id ");
		sb.append(" left join subject sub on sub.id = courseplan.SUBJECT_ID left join course on course.id = courseplan.course_id ").append(" where courseplan.plan_type=0 and courseplan.student_id = ").append(studentid);
		sb.append(" and courseplan.subject_id = ").append(subId).append(classsql).append(" and (courseplan.course_time> '").append(nowdate).append("'");
		if(!StringUtils.isEmpty(trids.toString().replaceFirst(",", ""))){
			sb.append(" or (courseplan.course_time= '").append(nowdate).append("' and courseplan.timerank_id in (").append(trids.toString().replaceFirst(",", "")).append(") )");
		}
		sb.append(" )  group by courseplan.course_id ");
		return coursePlan.find(sb.toString());
		
	}
	/**
	 * 获得某个学生某个课程的排课(今天之后 )
	 * @param stuId
	 * @param subId
	 * @param courseId
	 * @param classorderid
	 * @return
	 */
	public List<CoursePlan> getCoursePlanStudentCourseSubject(String stuId, String subId, String courseId, String classorderid) {
		String nowhm = ToolDateTime.getCurDateTime().substring(11, 16);
		List<TimeRank> trlist = TimeRank.dao.find("select id from time_rank where rank_name > ? ",nowhm);
		StringBuffer trids = new StringBuffer();
		if(trlist!=null&&trlist.size()>0){
			for(TimeRank tr:trlist){
				trids.append(",").append(tr.getInt("id"));
			}
		}
		String today = ToolDateTime.dateToDateString(new Date(), "yyyy-MM-dd");
		StringBuffer sb = new StringBuffer("");
		sb.append("select tr.class_hour,tr.RANK_NAME,cp.COURSE_TIME,cp.Id FROM courseplan cp left join time_rank tr on tr.id=cp.timerank_id ").append(" where cp.plan_type=0 and cp.student_id = ").append(stuId).append(" and cp.course_id = ").append(courseId);
		if(!StringUtils.isEmpty(classorderid)){
			sb.append(" and cp.class_id = ").append(classorderid);
		}
		sb.append(" and cp.subject_id = ").append(subId).append(" and (cp.course_time> '").append(today).append("'");
		if(!StringUtils.isEmpty(trids.toString().replaceFirst(",", ""))){
			sb.append(" or (cp.course_time= '").append(today).append("' and cp.timerank_id in (").append(trids.toString().replaceFirst(",", "")).append(") )");
		}
		sb.append( ")  ORDER BY COURSE_TIME DESC , RANK_NAME DESC ");
		
		return coursePlan.find(sb.toString());
		
	}
	
	public Double getHoursForStudentCoursePlaned(String stuid,String courseid){
		Double sumhours = 0.0;
		CoursePlan  cp = CoursePlan.coursePlan.findFirst("SELECT SUM(tr.class_hour) sumhours FROM courseplan LEFT JOIN time_rank tr on tr.Id=TIMERANK_ID WHERE STUDENT_ID= ? AND COURSE_ID= ? ", stuid,courseid);
		if(cp==null){
			sumhours = 0.0;
		}else{
			sumhours = cp.getBigDecimal("sumhours")==null?0.0:cp.getBigDecimal("sumhours").doubleValue();
		}
		return sumhours;
	}

	/**
	 * 某个学生某个课程今天之后已排的课时总数
	 * @param subId
	 * @param stuId
	 * @param courseId
	 * @param classorderid
	 * @return
	 */
	public CoursePlan getSubjectCoursePlanedSum(String subId, String stuId, String courseId, String classorderid) {
		String nowhm = ToolDateTime.getCurDateTime().substring(11, 16);
		List<TimeRank> trlist = TimeRank.dao.find("select id from time_rank where rank_name > ? ",nowhm);
		StringBuffer trids = new StringBuffer();
		if(trlist!=null&&trlist.size()>0){
			for(TimeRank tr:trlist){
				trids.append(",").append(tr.getInt("id"));
			}
		}
		String nowdate = ToolDateTime.dateToDateString(new Date(), "yyyy-MM-dd");
		String classsql = StringUtils.isEmpty(classorderid)?" and courseplan.class_id = 0 ":" and courseplan.class_id = "+classorderid;
		StringBuffer sb = new StringBuffer("");
		sb.append("select sum(tr.class_hour) sumhours from courseplan left join time_rank tr on tr.id=courseplan.timerank_id ").append(" where courseplan.plan_type=0 and courseplan.student_id = ").append(stuId);
		sb.append(" and courseplan.subject_id = ").append(subId).append(" and courseplan.course_id = ").append(courseId).append(classsql).append(" and (courseplan.course_time> '").append(nowdate).append("'");
		if(!StringUtils.isEmpty(trids.toString().replaceFirst(",", ""))){
			sb.append(" or (courseplan.course_time= '").append(nowdate).append("' and courseplan.timerank_id in (").append(trids.toString().replaceFirst(",", "")).append(") )");
		}
		sb.append(" ) ");
		
		return coursePlan.findFirst(sb.toString());
	}

	public CoursePlan getDelHourByTeacherID(String tid,String starttime, String endtime) {
		return coursePlan.findFirst("select sum(teacherhour) delkeshi,count(id) nums  from courseplan where  iscancel=1  and course_time>= '"+starttime+"' and  course_time<= '"+endtime +"' and TEACHER_ID = ? ",tid);
	}

	public CoursePlan getDelHourByTeacherIDs(String string,String s) {
		 return coursePlan.findFirst("select sum(teacherhour) delkeshi,count(id) nums from courseplan where  iscancel=1  and DATE_FORMAT(COURSE_TIME,'%Y-%m') = '"+s+"' and  TEACHER_ID = ? ",string);
	}
	
	public double getStudentUsedCoursePlanHours(Integer stuid,Map<String,Date> daymap){
		String sql ="select sum(tr.class_hour) sumhours from courseplan left join time_rank tr on courseplan.timerank_id=tr.id where courseplan.student_id = ?  ";
		if(daymap!=null){
			if(daymap.get("end")!=null){
				sql += " and courseplan.course_time <= '"+ToolDateTime.format(daymap.get("end"),"yyyy-MM-dd")+"'";
			}
			if(daymap.get("start")!=null)
				sql += " and courseplan.course_time >= '"+ToolDateTime.format(daymap.get("start"),"yyyy-MM-dd")+"'";
		}
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sql, stuid);
		return cp.getBigDecimal("sumhours")==null?0.0:cp.getBigDecimal("sumhours").doubleValue();
	}
	
	/**
	 * 学生某天该课程
	 * @param stuId
	 * @param string
	 * @param day
	 * @return
	 */
	public List<CoursePlan> getStudentDayCoursePlans(String stuId, String courseid, String day,String type) {
		List<CoursePlan> list = new ArrayList<CoursePlan>();
		String ydySql = "SELECT\n" +
				"	cp.Id cpid,\n" +
				"	cp.course_time,\n" +
				"	cp.confirm,\n" +
				"	tr.id trid,\n" +
				"	tr.rank_name,\n" +
				"	campus.id campusid,\n" +
				"	campus.campus_name,\n" +
				"	tch.id tchid,\n" +
				"	tch.real_name tchname,\n" +
				"	room.id roomid,\n" +
				"	room. NAME roomname,\n" +
				"classNum\n"+
				"FROM\n" +
				"	courseplan cp\n" +
				"LEFT JOIN time_rank tr ON tr.id = cp.timerank_id \n" +
				"LEFT JOIN campus ON campus.id = cp.campus_id\n" +
				"LEFT JOIN account tch ON tch.id = cp.teacher_id\n" +
				"LEFT JOIN classroom room ON room.id = cp.room_id\n" +
				"LEFT JOIN class_order ON cp.class_id = class_order.id\n"+
				"WHERE\n" +
				"	cp.student_id = ?\n" +
				"AND cp.course_id = ?\n" +
				"AND course_time = ?\n" ;
		String xbSql = "SELECT \n" +
				"	cp.Id cpid,\n" +
				"teacher.real_name tchname,\n" +
				"teacher.Id  tchid,\n" +
				"	tr.id trid,\n" +
				"	tr.rank_name,\n" +
				"room. NAME roomname ,\n" +
				"room.id roomid,\n" +
				"campus.id campusid,\n" +
				"campus.campus_name,\n" +
				"	tgr.Id tgrid,\n" +
				"	cp.course_time,\n" +
				"class_order.classNum\n"+
				"FROM courseplan cp\n" +
				"LEFT JOIN teachergrade tgr ON tgr.COURSEPLAN_ID = cp.Id \n" +
				"LEFT JOIN account student ON tgr.studentid=student.Id\n" +
				"LEFT JOIN account teacher ON  cp.TEACHER_ID = teacher.Id\n" +
				"LEFT JOIN time_rank tr ON cp.TIMERANK_ID = tr.Id\n" +
				"LEFT JOIN classroom room ON cp.ROOM_ID = room.Id\n" +
				"LEFT JOIN campus ON campus.Id = cp.CAMPUS_ID\n" +
				"LEFT JOIN class_order ON cp.class_id = class_order.id\n"+
				"WHERE \n" +
				"1 = 1 \n" +
				"AND cp.course_time = ? \n" +
				"AND cp.COURSE_ID = ?\n" +
				"AND cp.STUDENT_ID = ?" ;
		if(type.equals("1")){
			List<CoursePlan>ydyList = coursePlan.find(ydySql, stuId, courseid,day) ;//获取一对一课程
			for (CoursePlan courseplan:ydyList) {//合并课程
				list.add(courseplan);
			}
		}else if(type.equals("2")){
			List<CoursePlan>xbList = coursePlan.find(xbSql, day, courseid,stuId) ;//获取小班课程
			for (CoursePlan courseplan:xbList) {//合并课程
				list.add(courseplan) ;
			}
		}
		return list ;
	}

	/**
	 * 给学生排过课程ids
	 * @param stuid
	 * @return
	 */
	public String getCourseIdsUsed(String stuid) {
		String sql =" select group_concat(distinct cp.course_id) courseids from courseplan cp where cp.class_id=0 and cp.student_id = ?  ";
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sql, stuid);
		if(cp!=null&&!StringUtils.isEmpty(cp.getStr("courseids")))
			return ","+cp.getStr("courseids")+",";
		return null;
	}

	/**
	 * 已排课程的名字
	 * @param stuid
	 * @return
	 */
	public String getCourseUsedNames(String stuid) {
		String sql = "SELECT GROUP_CONCAT(course.COURSE_NAME SEPARATOR '、') couresenames FROM course WHERE FIND_IN_SET(course.Id,(select group_concat(distinct cp.course_id) courseids from courseplan cp where cp.class_id=0 and cp.student_id = "+stuid+")) AND course.STATE=0";
		Course course = Course.dao.findFirst(sql);
		return course==null?"":course.getStr("COURESENAMES");
	}

	/**
	 * 校区当天有课程的教室ids
	 * @param campusid
	 * @param coursetime
	 * @return
	 */
	public String getCampusDayRoomids(String campusid, String coursetime,String rankTimeIds) {
		String sql = " select group_concat(distinct cp.room_id) roomids from courseplan cp where cp.course_time = ? and cp.campus_id = ? and cp.plan_type !=2 and cp.timerank_id in "+rankTimeIds;
		CoursePlan plan = CoursePlan.coursePlan.findFirst(sql, coursetime, campusid);
		return plan==null?"":plan.getStr("roomids");
	}
	
	/**
	 * 
	 * 校区课程  不包括休息
	 * @param campusid
	 * @param coursetime
	 * @return
	 */
	public List<CoursePlan> getCampusDayRoomPlans(String campusid,String coursetime){
		String sql = "select cp.*,room.name roomname,course.course_name,stu.real_name stuname,tch.real_name tchname from courseplan cp "
				+ " left join classroom room on room.id=cp.room_id  left join course on course.id=cp.course_id "
				+ " left join account stu on stu.id = cp.student_id left join account tch on tch.id=cp.teacher_id "
				+ "  where cp.campus_id = ? and cp.course_time = ? and cp.plan_type!=2 order by cp.room_id ";
		return coursePlan.find(sql, campusid, coursetime);
	}
	
	/**
	 * 
	 * 当天教室有的课程
	 * @param roomid
	 * @param coursetime
	 * @return
	 */
	public List<CoursePlan> getCoursetimeRoomPlans(String roomid,String coursetime){
		String sql = "select cp.*,tch.real_name tchname,stu.real_name stuname,course.course_name,tr.rank_name from courseplan cp "
				+ " left join account tch on tch.id=cp.teacher_id left join account stu on stu.id=cp.student_id "
				+ " left join course on course.id=cp.course_id left join time_rank tr on tr.id=cp.timerank_id where cp.course_time= ?  and cp.room_id = ? and cp.plan_type!=2  ";
		return coursePlan.find(sql, coursetime, roomid); 
	}

	/**
	 * 根据id获取所属信息
	 * @param string
	 * @return
	 */
	public CoursePlan getCoursePlanCurrentSaved(String cpid) {
		String sql = "select cp.*,tch.real_name tchname,tr.rank_name,c.course_name,campus.campus_name,room.name roomname  from courseplan cp "
				+ " left join account tch on tch.id=cp.teacher_id "
				+ " left join time_rank tr on tr.id=cp.timerank_id "
				+ " left join campus on campus.id= cp.campus_id "
				+ " LEFT JOIN course c on cp.course_id = c.id "
				+ " left join classroom room on room.id=cp.room_id "
				+ " where cp.id = ? ";
		return coursePlan.findFirst(sql, cpid);
	}
	/**
	 * 查询教书在某个时段是否有排课或者休息
	 * @param reservationTime
	 * @param teachetid
	 * @return
	 */
	public List<CoursePlan> getCourseDateAndTeacherId(String reservationTime, Integer teachetid) {
		String sql ="SELECT tr.rank_name "
				+ " FROM courseplan cp "
				+ " LEFT JOIN account tch ON tch.id = cp.teacher_id "
				+ " LEFT JOIN time_rank tr ON tr.id = cp.timerank_id "
				+ " where cp.course_time= ?  and cp.TEACHER_ID = ? and cp.plan_type!=2  ";
		return coursePlan.find(sql,reservationTime,teachetid);
	}
	/**
	 * 获取月 日 季度的课时方法*
	 * @param teacherid
	 * @param start
	 * @param end
	 * @return
	 */
	public CoursePlan getCoursePlanHour(String teacherid,Date start,Date end){
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		//String s = sf.format(end);
		String sql = "select sum(t.class_hour) classHour from courseplan c left join time_rank t on c.TIMERANK_ID = t.id where  PLAN_TYPE=0 AND iscancel=0 and  c.TEACHER_ID = ? "
				+"and date_format(c.COURSE_TIME, '%Y-%m-%d') >= '" + sf.format(start) +"' and date_format(c.COURSE_TIME, '%Y-%m-%d') <= '" +  sf.format(end) +"'";
		return coursePlan.findFirst(sql, teacherid);
	}
	//根据当前时间获取当前一天的开始结束时间(为了方便使用date_formart())
	public CoursePlan getDayCoursePlanHour(String teacherid){
		String sql = "select sum(t.class_hour) classHour from courseplan c left join time_rank t on c.TIMERANK_ID = t.id where PLAN_TYPE=0 AND iscancel=0 and c.TEACHER_ID = ? "
				+"and c.COURSE_TIME between date_format(now(), '%Y-%m-%d 00:00:00') and date_format(now(), '%Y-%m-%d 23:59:59')";
		return coursePlan.findFirst(sql, teacherid);
	}
	/**
	 * 获取月 日季度的未签到 以及签到的方法*
	 */
	public CoursePlan getCourseSign(int sing,String teacherid,Date start,Date end){
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		String sql = "select count(*) tdcount from courseplan c where c.SIGNIN="+sing+" and c.TEACHER_ID = ?"
				+"and date_format(c.course_time,'%Y-%m-%d') >='" + sf.format(start)+"' and date_format(c.course_time,'%Y-%m-%d') <= '" + sf.format(end) +"'";
		return coursePlan.findFirst(sql,teacherid);
	}
	/**
	 * 获取老师当天的课时*
	 * 
	 */
	public List<CoursePlan> getDayCourse(String teacherid){
		String sql = "SELECT cp.id ,c.COURSE_NAME COURSENAME, tr.RANK_NAME ranktime,cr.name crname,"
				+" ca.CAMPUS_NAME campusname,acc.REAL_NAME teachername,ac.REAL_NAME studentname,cp.SIGNIN,"
				+ " date_format(course_time,'%Y-%m-%d') ctime "
				+" FROM courseplan cp "
				+" LEFT JOIN course c ON cp.COURSE_ID=c.Id "
				+" LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id "
				+" LEFT JOIN campus ca ON cp.CAMPUS_ID=ca.Id "
				+" left join classroom cr on cp.ROOM_ID = cr.id "
				+" LEFT JOIN account ac ON cp.STUDENT_ID=ac.Id "
				+" LEFT JOIN account acc ON cp.TEACHER_ID=acc.Id "
				+" WHERE PLAN_TYPE=0 and iscancel=0 and TEACHER_ID=? and date_format(course_time,'%Y-%m-%d')=(select current_date)";
		return coursePlan.find(sql, teacherid);
	}
	/**
	 * 获取某个学生在某个班次的排课*
	 * @param class_id
	 * @param stuId
	 * @return
	 */
	public List<CoursePlan> getStudentXiaoBanCoursePlanMessag(Integer class_id, Integer stuId) {
		String sql ="select * from courseplan where date_format(course_time,'%Y-%m-%d')>=CURDATE() AND STUDENT_ID = ? and class_id = ?";
		return coursePlan.find(sql,class_id,stuId);
	}
	/**
	 * 根据班次id查找排课*
	 * @param orderid
	 * @return
	 */
	public List<CoursePlan> getAllCourseByOrderId(String orderid) {
		String sql ="select cp.id,t.real_name  from  courseplan cp"
				+ " left join account t on cp.teacher_id = t.id  "
				+ " where class_id = "+orderid;
		return coursePlan.find(sql);
	}
	
	/**
	 * 统计班次的某个时间段的课时
	 * @param classorderid
	 * @param begin
	 * @param end
	 * @return
	 */
	public Double getClassOrderMonthLesson(Integer classorderid, String begin, String end) {
		StringBuffer sf = new StringBuffer();
		sf.append("select sum(tr.class_hour) ks from courseplan cp  LEFT JOIN time_rank tr on cp.TIMERANK_ID = tr.Id where 1=1 ");
		if(!begin.equals("")){
			sf.append(" and DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') >= '"+begin+"'");
		}
		if(!end.equals("")){
			sf.append(" and DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') <'"+end+"'");
		}
		sf.append(" AND cp.class_id = "+classorderid+" AND cp.STATE = 1");
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sf.toString());
		if(cp!=null){
			if(cp.get("ks")!=null){
				return cp.getDouble("ks");
			}else{
				return 0.0;
			}
		}else{
			return 0.0;
		}
		
	}
	/**
	 * 根据订单Id统计课时
	 * @param int1
	 * @return
	 */
	public double getKeShiByCourseOrderId(Integer courseorderid) {
		String sql = "select sum(if(cp.iscancel=0,tr.class_hour,cp.teacherhour)) ks from courseplan cp "
				+ " left join time_rank tr ON cp.TIMERANK_ID  = tr.Id  "
				+ " where  courseorderid = "+courseorderid;
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sql);
		if(cp!=null){
			if(cp.get("ks")!=null){
				return cp.getNumber("ks").doubleValue();
			}else{
				return 0;
			}
		}else{
			return 0;
		}
		
	}
	
	/**
	 * 一对一  统计订单的课时
	 * @param courseorderid
	 * @return
	 */
	public Double getCourseOrderIdMonthLesson(Integer courseorderid, String begin, String end) {
		StringBuffer sf = new StringBuffer();
		sf.append("select sum(if(cp.iscancel=0,tr.class_hour,cp.teacherhour)) ks from courseplan cp  LEFT JOIN time_rank tr on cp.TIMERANK_ID = tr.Id where 1=1 ");
		if(!begin.equals("")){
			sf.append(" and DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') >= '"+begin+"'");
		}
		if(!end.equals("")){
			sf.append(" and DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') <'"+end+"'");
		}
		sf.append(" AND cp.courseorderid = ").append(courseorderid);
		CoursePlan cp = CoursePlan.coursePlan.findFirst(sf.toString());
		if(cp!=null){
			if(cp.get("ks")!=null){
				return cp.getNumber("ks").doubleValue();
			}else{
				return 0.0;
			}
		}else{
			return 0.0;
		}
		
	}
	/**
	 * 获取学生的今日课程信息
	 * @param orderids
	 * @param id
	 * @return
	 */
	public List<CoursePlan> findByOrderIdsAndStudentid(String orderids, Integer studentid) {
		if(orderids.equals("")){
			String sql = " SELECT "
					+ " cp.COURSE_TIME,c.CAMPUS_NAME,co.COURSE_NAME,cr.NAME,t.REAL_NAME,tr.RANK_NAME "
					+ " FROM courseplan cp "
					+ " LEFT JOIN campus c on cp.CAMPUS_ID = c.Id "
					+ " LEFT JOIN course co on cp.COURSE_ID = co.Id "
					+ " LEFT JOIN classroom cr on cp.ROOM_ID = cr.Id "
					+ " LEFT JOIN account t on cp.TEACHER_ID = t.Id  "
					+ " LEFT JOIN time_rank tr  on cp.TIMERANK_ID = tr.Id "
					+ " where cp.STUDENT_ID = ? and DATE_FORMAT(cp.COURSE_TIME,'%y-%m-%d') = (SELECT CURRENT_DATE) order by cp.COURSE_TIME";
			return coursePlan.find(sql,studentid);
		}else{
			String sql = "select * from ((SELECT "
					+ " cp.COURSE_TIME,c.CAMPUS_NAME,co.COURSE_NAME,cr.NAME,t.REAL_NAME,tr.RANK_NAME "
					+ " FROM "
					+ " courseplan cp "
					+ " LEFT JOIN campus c on cp.CAMPUS_ID = c.Id "
					+ " LEFT JOIN course co on cp.COURSE_ID = co.Id "
					+ " LEFT JOIN classroom cr on cp.ROOM_ID = cr.Id "
					+ " LEFT JOIN account t on cp.TEACHER_ID = t.Id  "
					+ " LEFT JOIN time_rank tr  on cp.TIMERANK_ID = tr.Id "
					+ " where cp.class_id IN ("+orderids+") and DATE_FORMAT(cp.COURSE_TIME,'%y-%m-%d') = (SELECT CURRENT_DATE)) "
					+ " union all (SELECT "
					+ " cp.COURSE_TIME,c.CAMPUS_NAME,co.COURSE_NAME,cr.NAME,t.REAL_NAME,tr.RANK_NAME "
					+ " FROM courseplan cp "
					+ " LEFT JOIN campus c on cp.CAMPUS_ID = c.Id "
					+ " LEFT JOIN course co on cp.COURSE_ID = co.Id "
					+ " LEFT JOIN classroom cr on cp.ROOM_ID = cr.Id "
					+ " LEFT JOIN account t on cp.TEACHER_ID = t.Id  "
					+ " LEFT JOIN time_rank tr  on cp.TIMERANK_ID = tr.Id "
					+ " where cp.STUDENT_ID = "+studentid+" and DATE_FORMAT(cp.COURSE_TIME,'%y-%m-%d') = (SELECT CURRENT_DATE))) message order by message.COURSE_TIME";
			return coursePlan.find(sql);
		}
	}
	/**
	 * 获取某个时段下的课程
	 * @param campusid
	 * @param ids
	 * @param date
	 * @return
	 */
	public List<CoursePlan> findByCampusidAndTeacherids(String campusid, String ids, String date,Integer teacherid) {
		StringBuilder sf = new StringBuilder();
		sf.append("SELECT cp.Id cpid,cp.TIMERANK_ID,cp.class_id, s.id studentid,t.real_name teachername,s.real_name studentname "
				+ " FROM "
				+ " courseplan cp "
				+ " LEFT JOIN account t ON cp.TEACHER_ID = t.Id "
				+ " LEFT JOIN account s ON cp.STUDENT_ID = s.id "
				+ " where cp.STATE = 0 AND cp.confirm = 1 AND DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') = '"+date+"' and t.id = "+teacherid);
		if(!campusid.equals("")){
			sf.append(" and cp.CAMPUS_ID = ").append(campusid);
		}
		if(!ids.equals("")){
			sf.append(" and t.id in (").append(ids).append(")");
		}
		return coursePlan.find(sf.toString());
	}

	/**
	 * 根据查询条件查询所有的课程信息 
	 * 包含小班、模块、排休
	 * @author David
	 * @param queryParams 查询参数
	 */
	public List<CoursePlan> getAllCoursePlan(Map<String, String> queryParams) {
		if(queryParams == null){
			return null;
		}else{
			StringBuilder sql = new StringBuilder("select * from ( "+
					"SELECT concat(" +
						"IF(courseplan.iscancel=1,'(已取消)\r\n','')," +
						"IF(courseplan.PLAN_TYPE=1,'类型:模考\r\n',IF(courseplan.PLAN_TYPE=2,'类型:休息',IF(courseplan.PLAN_TYPE=0 AND courseplan.class_id=0,IF(courseplan.netCourse=1,'授课:一对一(网络课)\r\n','授课:一对一\r\n'),'')))," +
						"IF(ISNULL(course.course_name),'',CONCAT('课程:',course.course_name))," +
						"IF(courseplan.rechargecourse=1,'(补排)\r\n','\r\n')," +
						"IF(ISNULL(teacher.real_name),'',CONCAT('老师:',teacher.real_name,'\r\n'))," +
						"IF(ISNULL(cpat.assistantName),'',CONCAT('助教:',cpat.assistantName,'\r\n'))," +
						"IF(courseplan.PLAN_TYPE!=2,CONCAT('场地:',IFNULL(campus.campus_name,''),IFNULL(classroom.name,''),'\r\n日期:',date_format(courseplan.course_time,'%Y-%m-%d'),'\r\n时段:',time_rank.RANK_NAME,IF(courseplan.class_id!=0,'',CONCAT('\r\n学生:',stu.real_name))),CONCAT( '时段:',IF(LENGTH(courseplan.startrest)<=4,CONCAT('0',courseplan.startrest),courseplan.startrest), '-', courseplan.endrest ))," +
						"IF(courseplan.class_id!=0,CONCAT('\r\n班型:',xiaoban.bantypename,'\r\n班次:',xiaoban.classNum),'')" + 
					") as  title," +
					"IFNULL( CONCAT( IF(LENGTH(courseplan.startrest)<=4,CONCAT('0',courseplan.startrest),courseplan.startrest), '-', courseplan.endrest ), time_rank.RANK_NAME ) trrankname," +
					"courseplan.course_time, classroom.name classroomname,campus.campus_name,campus.campustype,time_rank.RANK_NAME,courseplan.ROOM_ID,courseplan.campus_id,courseplan.teacher_id," +
					"courseplan.student_id,courseplan.course_id, courseplan.class_id, courseplan.remark, date_format(courseplan.course_time,'%Y,(%c-1),%d') as start, date_format(courseplan.course_time,'%Y-%m-%d') as start_course_time," +
					"courseplan.rechargecourse ,courseplan.plan_type as planType,courseplan.id,courseplan.startrest,courseplan.endrest," +
					"courseplan.netCourse as netCourse, courseplan.signin as signin,courseplan.TEACHER_PINGLUN as teacherPinglun,courseplan.TIMERANK_ID," +
					"date_format(courseplan.course_time,'%Y-%m-%d') kcrq "+
					"FROM courseplan " +
					"LEFT JOIN course on courseplan.course_id = course.id " +
					"LEFT JOIN campus on campus.id=courseplan.campus_id " +
					"LEFT JOIN classroom on classroom.id=courseplan.room_id " +
					"LEFT JOIN time_rank  on time_rank.id=courseplan.timerank_id " +
					"LEFT JOIN (select bc.id,bx.`name` bantypename,bc.classNum from class_order bc left join class_type bx on bc.classtype_id=bx.id) xiaoban on xiaoban.id = courseplan.class_id " +
					"LEFT JOIN account stu on stu.id=courseplan.student_id " +
					"LEFT JOIN account teacher on teacher.id=courseplan.teacher_id " + 
					"LEFT JOIN (SELECT GROUP_CONCAT(tch.REAL_NAME) AS assistantName , cpa.courseplanId FROM courseplan_assistant cpa LEFT JOIN account tch ON tch.Id = cpa.teacherId GROUP BY cpa.courseplanId ) cpat ON cpat.courseplanId = courseplan.Id "
					);
			sql.append(" WHERE (courseplan.confirm = 1 OR stu.STATE = 2 OR courseplan.PLAN_TYPE !=0) and courseplan.course_time>='").append(queryParams.get("startDate")).append("' and courseplan.course_time<= '").append(queryParams.get("endDate")).append("' ");
			
			if(!StringUtils.isEmpty(queryParams.get("studentId"))){//学生登录
				Integer studentId = Integer.parseInt(queryParams.get("studentId"));
				sql.append(" and ( stu.id=").append(studentId).append(" or xiaoban.id in(SELECT ab.banci_id from account_banci ab where ab.account_id=")
				.append(studentId).append(" AND ab.state=0 ))");
			}
			
			if(StrKit.notBlank(queryParams.get("kcgwid"))){
				sql.append(" AND( stu.id IN(").append(queryParams.get("kcgwid")).append(") OR xiaoban.id != '' ) ");
			}
			
			if(!StringUtils.isEmpty(queryParams.get("studentName"))){
				Student student = Student.dao.getStudentByName(queryParams.get("studentName"));
				if(student == null){
					return null;
				}else{
					Integer studentId = student.getPrimaryKeyValue();
					String banciIds = AccountBanci.dao.getBanciIds(studentId);
					sql.append(" and( stu.id=").append(studentId).append(" or xiaoban.id in("+banciIds+")) ");
				}
			}
			if(!StringUtils.isEmpty(queryParams.get("teacherId"))){
				sql.append(" and teacher.id=").append(queryParams.get("teacherId"));
			}else{
				if(!StringUtils.isEmpty(queryParams.get("teacherName"))){
					Teacher teacher  = Teacher.dao.getTeacherByName(queryParams.get("teacherName"));
					if(teacher == null){
						return null;
					}else{
						Integer teacherId = teacher.getPrimaryKeyValue();
						sql.append(" and teacher.id=").append(teacherId);
					}
				}
			}
			
			if(!StringUtils.isEmpty(queryParams.get("banciName"))){
				sql.append(" and xiaoban.classNum = ").append(queryParams.get("banciName"));
			}
			if(!StringUtils.isEmpty(queryParams.get("campusId"))){
				sql.append(" and courseplan.campus_id in (").append(queryParams.get("campusId")).append(")");
			}
			sql.append(") a WHERE a.title != '' ORDER BY a.course_time asc, a.trrankname asc");
			List<CoursePlan> result = coursePlan.find(sql.toString());
			return result;
		}
	}

	/**
	 * 根据班次ID和课程ID获取已排课程数
	 * @author David
	 * @param classOrderId
	 * @param courseId
	 */
	public float getClassYpkcClasshour(Integer classOrderId, Integer courseId) {
		String sql = " SELECT IFNULL(SUM(t.class_hour),0) ks from courseplan cp " 
				+ " LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id " 
				+ " WHERE cp.class_id = ? and cp.COURSE_ID = ? and cp.PLAN_TYPE=0 ";
		BigDecimal sumhour = Db.queryBigDecimal(sql,classOrderId,courseId);
		return sumhour==null?0:sumhour.floatValue();
	}

	/**
	 * 获取班课已排课程信息
	 * @param classOrderId
	 * @return
	 */
	public List<CoursePlan> getCoursePlanByClassOrderId(Integer classOrderId) {
		String sql ="select cp.Id,t.REAL_NAME teacherName,c.COURSE_NAME courseName,x.CAMPUS_NAME campusName,r.`NAME` roomName,cp.COURSE_TIME courseTime,cp.TIMERANK_ID,s.RANK_NAME timeName,b.classNum from courseplan cp\n" +
				"left join account t on cp.TEACHER_ID=t.Id\n" +
				"left join course c on cp.COURSE_ID=c.Id\n" +
				"left join campus x on cp.CAMPUS_ID=x.Id\n" +
				"left join classroom r on cp.ROOM_ID=r.Id\n" +
				"left join time_rank s on cp.TIMERANK_ID=s.Id\n" +
				"left join class_order b on cp.class_id=b.id\n" +
				"WHERE class_id=? and cp.STATE=0 and cp.PLAN_TYPE=0 order by course_time, rank_name";
		return coursePlan.find(sql, classOrderId);
	}

	/**
	 * 获取班课已排课程信息分页
	 * @param classOrderId
	 * @return
	 */
	public void getCoursePlanByClassOrderId(SplitPage splitPage,Integer classOrderId) {
		String select ="select cp.Id,t.REAL_NAME teacherName,c.COURSE_NAME courseName,x.CAMPUS_NAME campusName,r.`NAME` roomName,cp.COURSE_TIME courseTime,cp.TIMERANK_ID,s.RANK_NAME timeName,s.class_hour classHour,b.classNum ";
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer formSql = new StringBuffer("from courseplan cp\n" +
				"left join account t on cp.TEACHER_ID=t.Id\n" +
				"left join course c on cp.COURSE_ID=c.Id\n" +
				"left join campus x on cp.CAMPUS_ID=x.Id\n" +
				"left join classroom r on cp.ROOM_ID=r.Id\n" +
				"left join time_rank s on cp.TIMERANK_ID=s.Id\n" +
				"left join class_order b on cp.class_id=b.id\n" +
				"WHERE class_id=? and cp.STATE=0 and cp.PLAN_TYPE=0 order by course_time, rank_name");
		paramValue.add(classOrderId);
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		splitPage.setPage(page);
	}

	/**
	 * 通过AccountBook课程消耗记录表获取未上课程
	 * 不包含今天的课程，今天以后的所有课程都记未上
	 * @param studentId
	 * @param courseOrderId
	 * @return
	 */
	public List<CoursePlan> getUnusedCoursePlan(Integer studentId,Integer courseOrderId) {
		String sql = "SELECT ab.courseorderid ,ab.courseplanid,cp.class_id FROM account_book ab\n" +
				"LEFT JOIN courseplan cp ON ab.courseplanid=cp.Id\n" +
				"WHERE ab.accountid=? AND ab.courseorderid=? AND ab.operatetype=4 AND ab.`status`=0 AND cp.COURSE_TIME>=?";
		return coursePlan.find(sql, studentId,courseOrderId,ToolDateTime.getCurDate()+" 23:59:59");
	}

	/**
	 * 获取学生班课的课程安排
	 * @param courseTime
	 * @param studentId
	 * @param classOrderId
	 * @return
	 */
	public List<CoursePlan> getCoursePlansByDay(String courseTime, Integer studentId, Integer classOrderId) {
		String sql = "SELECT cp.ID, tg.studentid STUDENT_ID,cp.TIMERANK_ID,tr.RANK_NAME,DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME,cp.ROOM_ID,cp.CAMPUS_ID FROM courseplan cp INNER JOIN\n" +
				"teachergrade tg on cp.id=tg.courseplan_id \n" +
				"left join time_rank as tr on cp.TIMERANK_ID=tr.ID\n" +
				"WHERE tg.studentid=? AND cp.class_id=? AND cp.COURSE_TIME=?";
		List<CoursePlan> cpListDay = coursePlan.find(sql, studentId,classOrderId,courseTime);
		return cpListDay;
	}

	/**
	 * 教师排休会用到的查询
	 * @param teacherId
	 * @param stime
	 * @param etime
	 * @return
	 */
	public Map<String, Long> getPlanCountsForRest(String teacherId, String stime, String etime) {
		String sql = "SELECT CONCAT(DATE_FORMAT(COURSE_TIME,'%Y-%m-%d'),TIMERANK_ID) coursetime,TIMERANK_ID,COUNT(1) counts from courseplan where TEACHER_ID=? AND COURSE_TIME>=? AND COURSE_TIME<=? AND PLAN_TYPE != 2 GROUP BY COURSE_TIME,TIMERANK_ID";
		List<CoursePlan> list = coursePlan.find(sql, Integer.parseInt(teacherId),stime,etime);
		Map<String,Long> map = new HashMap<String, Long>();
		for(CoursePlan p : list){
			map.put(p.getStr("coursetime"), p.getLong("counts"));
		}
		return map;
	}

	/**
	 * 统计老师上课情况
	 * @param starttime
	 * @param endtime
	 * @param teacherId
	 * @return
	 */
	public List<CoursePlan> getStatTeacherPlan(String starttime, String endtime, String teacherId) {
		StringBuffer sql = new StringBuffer("select t.Id tid,t.real_name realname, COUNT(1) kecheng, SUM(tr.class_hour) keshi,if(cp.isovertime=1,sum(tr.class_hour),sum(0)) otkeshi,if(cp.isovertime=0,sum(tr.class_hour),sum(0)) nootkeshi,IFNULL(sum(case when cp.TEACHER_PINGLUN = 'y' then 1 else 0 end),0) tpinglun, IFNULL(sum(case when cp.SIGNIN != 0 then 1 else 0 end),0) signin  from courseplan cp \n" +
				"left join account t on t.Id = cp.teacher_id\n" +
				"left join time_rank tr on cp.TIMERANK_ID=tr.Id\n" +
				"where cp.plan_type=0 and cp.course_time>='").append(starttime).append("' and cp.course_time<='").append(endtime).append("' and cp.iscancel=0 ");
		
		if(!ToolString.isNull(teacherId)){
			sql.append(" and cp.teacher_id=").append(teacherId);
		}
		return coursePlan.find(sql.append(" GROUP BY cp.TEACHER_ID ORDER BY CONVERT(t.real_name USING gbk)").toString());
	}
	
	/**
	 * 按照校区统计老师上课情况
	 * @param starttime
	 * @param endtime
	 * @param teacherId
	 * @return
	 */
	public List<CoursePlan> getStatTeacherPlan(String starttime, String endtime, String teacherId, String campusIds) {
		StringBuffer sql = new StringBuffer("select t.Id tid,IFNULL(t.real_name,'' ) realname, COUNT(1) kecheng, SUM(tr.class_hour) keshi,if(cp.isovertime=1,sum(tr.class_hour),sum(0)) otkeshi,if(cp.isovertime=0,sum(tr.class_hour),sum(0)) nootkeshi,IFNULL(sum(case when cp.TEACHER_PINGLUN = 'y' then 1 else 0 end),0) tpinglun, IFNULL(sum(case when cp.SIGNIN != 0 then 1 else 0 end),0) signin  from courseplan cp \n" +
				"left join account t on t.Id = cp.teacher_id\n" +
				"left join time_rank tr on cp.TIMERANK_ID=tr.Id\n" +
				"where cp.plan_type=0 and cp.course_time>='").append(starttime).append("' and cp.course_time<='").append(endtime).append("' and cp.iscancel=0 ");
		sql.append( " and cp.campus_id in (" + campusIds + ")" );
		if(!ToolString.isNull(teacherId)){
			sql.append(" and cp.teacher_id=").append(teacherId);
		}
		return coursePlan.find(sql.append(" GROUP BY cp.TEACHER_ID ORDER BY CONVERT(t.real_name USING gbk)").toString());
	}
	
	/**
	 * 根据排课ID获取这节课上课学生
	 * @param coursePlanId
	 * @return
	 */
	public List<Student> getStudentByPlanId(Integer coursePlanId) {
		List<Student> studentList = new ArrayList<Student>();
		CoursePlan plan = coursePlan.findById(coursePlanId);
		if(plan.getInt("class_id")==0){
			studentList.add(Student.dao.findById(plan.getInt("student_id")));
		}else{
			String sql = "SELECT s.* FROM teachergrade t LEFT JOIN account s ON t.studentid=s.Id WHERE s.state!=2 AND t.COURSEPLAN_ID=?";
			studentList = Student.dao.find(sql, coursePlanId);
		}
		return studentList;
	}
	/**
	 * 根据 多条id拼接字符串查询列表
	 * 	ids = "id1,id2,id2,id4"
	 * @param ids  
	 * @return List<Model>
	 */
	public List<CoursePlan> findListByIds(String ids){
		String querySql = "SELECT * FROM courseplan WHERE FIND_IN_SET(id,?)";
		return   this.find(querySql, ids);
	}

	public CoursePlan findInfoById(String id) {
		String sql = "SELECT\n" +
				" cp.id id,\n" +
				" cp.remark,\n" +
				"cp.PLAN_TYPE PLAN_TYPE,\n"+
				"student.id studentid,\n" +
				"campus.CAMPUS_NAME,\n" +
				"campus.Id campusid,\n" +
				"student.REAL_NAME student_name,\n" +
				"teacher.REAL_NAME teacher_name,\n" +
				"teacher.Id tchid,room.id roomid,room.name room_name,\n" +
				"course.COURSE_NAME,course.Id courseid,sub.SUBJECT_NAME,\n" +
				"tr.RANK_NAME,tr.id trid,cp.remark remark ,\n" +
				"cp.COURSE_TIME  COURSE_TIME,\n" +
				"student.STATE userstate\n" +
				"FROM  courseplan cp  \n" +
				"LEFT JOIN  `subject` sub ON cp.SUBJECT_ID = sub.Id\n" +
				"LEFT JOIN  campus campus ON cp.CAMPUS_ID  = campus.Id\n" +
				"LEFT JOIN account teacher ON cp.TEACHER_ID = teacher.Id\n" +
				"LEFT JOIN account student ON cp.STUDENT_ID = student.Id\n" +
				"LEFT JOIN course ON cp.COURSE_ID = course.Id\n" +
				"LEFT JOIN classroom room ON cp.ROOM_ID = room.Id\n" +
				"LEFT JOIN  time_rank tr ON tr.Id =  cp.TIMERANK_ID\n" +
				"WHERE \n" +
				"cp.Id=?"   ;
		return coursePlan.findFirst(sql, Integer.parseInt(id));
	}

	/***
	 * 获取学员或教师在当天可用时间段  学生不包括自己的当前上课时间
	 * 教师不包括 
	 * @param stuid
	 * @param tchid
	 * @param coursetime
	 * @return
	 */
	public List<CoursePlan>  getEnableRankList(String stuid, String tchid, String coursetime,int cpid){
		String sql = " select cp.id,cp.timerank_id,tr.rank_name,cp.startrest,cp.endrest,cp.plan_type from courseplan cp left join time_rank tr on tr.id=cp.timerank_id  where (cp.teacher_id = ? or cp.student_id = ?) and cp.course_time = ?  AND cp.Id!= ?";
		return coursePlan.find(sql, tchid, stuid, coursetime,cpid);
	}
	/**
	 * 查询出关联的teachergrade个数
	 * @param courspPlanid
	 * @return
	 */
	public Integer queryDataFroStatistic(Integer courspPlanid){
		String sql = "select count() from teachergrade where courseplan_id = ?";
		return Db.queryInt(sql,courspPlanid);
	}
	
	

	public Time getStarttime() {
		return get("starttime");
	}
	
	public Time getEndtime() {
		return get("endtime");
	}
	

	
    /***
     * 获取学生当日上课具体时间
     */
	public String courseSpecificTime(Integer id) {
		String sql = "select DATE_FORMAT(cou.course_time,'%Y-%m-%d'),ti.rank_name from courseplan cou ,time_rank ti WHERE "
				+"cou.TIMERANK_ID = ti.Id and cou.STUDENT_ID = ? ";
		Record record = Db.findFirst(sql,id);
		SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd");
		StringBuilder builder = new StringBuilder("");
		builder.append(simple.format(record.getTimestamp("course_time")));
		builder.append(" ");
		builder.append(record.getStr("rank_name"));
		return builder.toString();
	}
	
	
	/***
	 * 获取课程计划上课时间段
	 * @param id  课程计划id
	 */
	public String getCourseTime(String id) {
		String sql = "select ti.rank_name from courseplan cou ,time_rank ti WHERE "
				+"cou.TIMERANK_ID = ti.Id and cou.id = ? ";
		
		Record record = Db.findFirst(sql,id);
		return record.getStr("rank_name");
	}
}
