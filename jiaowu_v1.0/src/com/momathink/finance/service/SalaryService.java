
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

package com.momathink.finance.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.Ret;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseplanSalary;
import com.momathink.finance.model.Salary;
import com.momathink.teaching.course.model.CoursePlan;

/**
 * @ClassName: 老师 课时费
 */
public class SalaryService extends BaseService {
	
	public static final SalaryService me = new SalaryService();
	
	
	public void list(SplitPage splitPage) {
		String select = "SELECT b.REAL_NAME AS creatname,a.REAL_NAME,s.*";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" FROM salary s "
				+ " LEFT JOIN account a ON a.Id = s.teacher_id "
				+ " LEFT JOIN account b ON b.Id = s.creat_id "
				+ " LEFT JOIN account_campus accountCampus ON s.teacher_id = accountCampus.account_id "
				+ " LEFT JOIN campus ON accountCampus.campus_id = campus.id "
				+ " WHERE 1=1 ");
		String teachername = queryParam.get("teachername");
		if (null != teachername && !teachername.equals("")) {
			formSqlSb.append(" AND a.real_name like ? ");
			paramValue.add("%" + teachername + "%");
		}
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		if( StringUtils.isEmpty( loginRoleCampusIds )){
			formSqlSb.append( " and campus.id in(" + loginRoleCampusIds + ")" );
		}
		String sysuserid = queryParam.get( "sysuserid" );
		if( StrKit.notBlank( sysuserid )){
			formSqlSb.append( " and a.Id = ? ");
			paramValue.add(sysuserid);
		}
		String date = queryParam.get("date");
		String date1 = "";
		String date2 = "";
		if (null != date && !date.equals("")) {
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
			date1 = date+"-01 00:00:00";
			try {
				date2= sdf.format(ToolDateTime.getLastDateOfMonth(sdf.parse(date+"-01")));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			formSqlSb.append(" AND s.stat_time <= ? AND s.stat_time >= ?");
			paramValue.add(date2+"23:59:59");
			paramValue.add(date1);
		}
	}
	
	/**
	 * @Title: 按老师id 和 月份 查询 课酬 信息
	 * @param tid 老师id *必填
	 * @param yuefen 月份   *必填
	 */
	public List<Record> getsalarylist(Object tid, String yuefen){
		return getsalarylist(tid, yuefen, 
							"(SELECT a.* " +
							"FROM courseplan a " +
							"LEFT JOIN courseplan_salary b ON b.courseplanid = a.Id " +
							"WHERE b.id IS NULL)"
							);
	}
	
	/**
	 * @Title: 按老师id 和 月份 查询 历史流水记录  课酬 信息
	 * @param tid 老师id *必填
	 * @param yuefen 月份   *必填
	 */
	public List<Record> getsalarylistHistory(Object tid, String yuefen){
		return getsalarylist(tid, yuefen, "courseplan_salary");
	}
	
	private List<Record> getsalarylist(Object tid, String yuefen, String fromTable ){
		if(StrKit.isBlank(yuefen) || tid == null) 
			return new ArrayList<Record>();
		
		Date date_yuefen = null;
		try {
			date_yuefen = new SimpleDateFormat("yyyy-MM").parse(yuefen);
		} catch (ParseException e) {
			e.printStackTrace();
			date_yuefen = new Date();
		}
		Date lastDateOfMonth = ToolDateTime.getLastDateOfMonth(date_yuefen);
		
		// 以前排得, 但是 课程 的课酬(课时费) 还没有付的 ,给一起查询出来
		Ret query = Ret.create("teacher_id", tid).set("COURSE_TIME_end", lastDateOfMonth).set("fromTable", fromTable);
		
		List<Record> list = queryBySalarylist(query);
		return list;
	}

	/**排课 课程 的课酬(课时费)
	 * */
	private List<Record> queryBySalarylist(Ret query) {
		List<Object> val = new ArrayList<>();
		String sql = 
			"SELECT " +
			"	p.Id, " +
			"	DATE_FORMAT(p.COURSE_TIME, '%Y-%m-%d') yuefen, " +
			"	t.RANK_NAME, " +
			"IF ( " +
			"	p.class_id = 0, " +
			"	'一对一', " +
			"	'小班' " +
			") AS sklx, " +
			" s.SUBJECT_NAME, " +
			" c.COURSE_NAME, " +
			" a.REAL_NAME, " +
			" ( " +
			"	CASE " +
			"	WHEN (p.SIGNIN = '0') THEN " +
			"		'未签到' " +
			"	WHEN (p.SIGNIN = '1') THEN " +
			"		'正常' " +
			"	WHEN (p.SIGNIN = '2') THEN " +
			"		'迟到' " +
			"	WHEN (p.SIGNIN = '3') THEN " +
			"		'补签' " +
			"	ELSE " +
			"		0 " +
			"	END " +
			") AS kaoqin, " +
			" t.class_hour, " +
			" p.iscancel, " +
			" p.teacherhour, " +
			"IFNULL(p.coursecost,0) AS ksf, " +
			"IFNULL(t.class_hour * p.coursecost,0) AS kc " +
			"FROM " +
			query.get("fromTable") + " p " +//别名
			"LEFT JOIN time_rank t ON p.TIMERANK_ID = t.Id " +
			"LEFT JOIN `subject` s ON p.SUBJECT_ID = s.Id " +
			"LEFT JOIN course c ON c.Id = p.COURSE_ID " +
			"LEFT JOIN account a ON p.STUDENT_ID = a.Id " +
			//"LEFT JOIN coursecost ct ON ct.courseid = c.Id AND ct.teacherid = p.teacher_id " +
			"WHERE 1=1 " ;
			//TODO 助教先不考虑,
		
		if(query.notNull("teacher_id")){
			sql += "AND p.teacher_id = ? ";
			val.add(query.get("teacher_id"));
		}
		if(query.notNull("COURSE_TIME_start")){
			sql += "AND p.COURSE_TIME >= ? ";
			val.add(query.get("COURSE_TIME_start"));
		}
		if(query.notNull("COURSE_TIME_end")){
			sql += "AND p.COURSE_TIME <= ? ";
			val.add(query.get("COURSE_TIME_end"));
		}
		
		sql += " ORDER BY p.COURSE_TIME, t.RANK_NAME";
		
		List<Record> list = Db.find(sql, val.toArray());
		return list;
	}
	
	/**
	 * 保存老师课酬薪资
	 * @param salary 
	 * @param coursePlanIds 
	 * @param integer 
	 */
	public void saveSalary(Salary salary, String coursePlanIds, Integer sysuserid){
		
		salary.set("creat_time", new Date());
		salary.set("creat_id", sysuserid);
		salary.save();
		
		if(StrKit.isBlank(coursePlanIds) || coursePlanIds.length() < 1) return;
		
		//查询出课程记录
		coursePlanIds = coursePlanIds.substring(0, coursePlanIds.length() -1 );
		List<CoursePlan> courseplans = CoursePlan.dao.find("SELECT * FROM `courseplan` WHERE FIND_IN_SET(Id, ?)", coursePlanIds);
		
		Object salaryId = salary.get("id");
		List<CourseplanSalary> courseplanSalarys = new ArrayList<>();
		
		//深层安全 拷贝数据, 不用sql语句拷贝是为了后面扩展和变动 
		StringBuilder sqlSets = new StringBuilder();
		StringBuilder sqlVals = new StringBuilder(") VALUES (");
		for (int i = 0; i < courseplans.size(); i++)
			courseplanSalarys.add(copiesCoursePlanToCourseplanSalary(courseplans.get(i), salaryId, i, sqlSets, sqlVals));
		
		//渲染后的sql 处理
		String sqlSet = sqlSets.toString();
		String sqlVal = sqlVals.toString();
		sqlSet = sqlSet.substring(0, sqlSet.length() - 1);
		sqlVal = sqlVal.substring(0, sqlVal.length() - 1);
		
		String sql = "INSERT INTO `courseplan_salary` (" + sqlSet + sqlVal + ")";

		//批量保存流水记录
		Db.batch(sql, sqlSet, courseplanSalarys, 1000);
	}
	
	/***
	 * @Title: save  保存课程计划表和课酬的详细流水
	 * @param coursePlan 课程计划表
	 * @param salaryId  发放课时费的表 id
	 * @param stop 控制喧嚷到 第几层了
	 * @param sqlSets  拼接 set 部分
	 * @param sqlVals  拼接 VALUES 部分 
	 * @return CourseplanSalary    一条流水记录
	 */
	public CourseplanSalary copiesCoursePlanToCourseplanSalary(CoursePlan coursePlan, Object salaryId, int stop, StringBuilder sqlSets, StringBuilder sqlVals) {
		
		Map<String, Object> cpAttr = coursePlan.getAttrs();
		
		CourseplanSalary courseplanSalary = new CourseplanSalary();
		
		//获取 CourseplanSalary 的所有字段
		for (String key : courseplanSalary.getTable().getColumnTypeMap().keySet()) {
			
			//不要 ID, sql 里也不要
			if(key.equals("ID")) continue;
			
			courseplanSalary.set(key, cpAttr.get(key));
			
			//sql 第一次 拼接 就够了, 再多就错了
			if(stop > 0) continue;
			sqlSets.append(key).append(",");
			sqlVals.append("?,");
		}
		
		courseplanSalary.set("courseplanid", cpAttr.get("id"));
		courseplanSalary.set("salaryId", salaryId);
		
		return courseplanSalary;
	}
}
