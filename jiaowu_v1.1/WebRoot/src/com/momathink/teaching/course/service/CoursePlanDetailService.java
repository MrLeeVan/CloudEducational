
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

package com.momathink.teaching.course.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.sys.operator.model.Role;

/***
 *  课程记录
 * @author dufuzhong
 * @date 2016年12月28日 下午3:37:59
 */
public class CoursePlanDetailService extends BaseService {
	public static final CoursePlanDetailService me = new CoursePlanDetailService();

	/**充血分页   角色  数据限制
	 * @param sysuser 登陆人 */
	public void list(SplitPage splitPage, Record sysuser) {
		
		Map<String, String> queryParam = splitPage.getQueryParam();
		String sysuserid = sysuser.getInt("id").toString();
		String roleids = sysuser.getStr("roleids");
		
		queryParam.put("accountcampusids", sysuser.getStr("accountcampusids"));
		
		//角色 查看数据权限1是全部0是个人	
		if(sysuser.getInt("showall").equals(0)){
			if (Role.isTeacher(roleids)) {
				queryParam.put("teacher_id", sysuserid);
			}
			if (Role.isStudent(roleids)) {
				queryParam.put("student_id", sysuserid);
			}
			if (Role.isKcgw(roleids)) {
				queryParam.put("kcgw_id", sysuserid);
			}
			if (Role.isShichang(roleids)) {
				queryParam.put("scuserid", sysuserid);
			}
			if (Role.isDudao(roleids)) {
				queryParam.put("supervisor_id", sysuserid);
			}
			if (Role.isJiaowu(roleids)) {
				queryParam.put("jwuserid", sysuserid);
			}
		}
		
		//默认 时间区间 限制
		if (StrKit.isBlank(queryParam.get("starttime"))){
			queryParam.put("starttime", ToolDateTime.getMonthFirstDayYMD(new Date()));
		}
		if (StrKit.isBlank(queryParam.get("endtime"))){
			queryParam.put("endtime", ToolDateTime.getCurDate());
		}
		
		list( splitPage );
	}
	
	/**分页*/
	public void list(SplitPage splitPage) {
		String select = "SELECT a.* ";
		splitPageBase(splitPage, select);
	}
	
	@Override
	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		
		//课程评论
		String sqlFrom_1 = 
			"SELECT " +
			" c.Id COURSE_ID, " +
			" cp.Id cpid, " +
			" c.COURSE_NAME, " +
			" t.REAL_NAME TNAME, " +
			" s.REAL_NAME SNAME, " +
			" cpat.assistantName ZNAME, " +
			" DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d')COURSE_TIME, " +
			" r.RANK_NAME, " +
			" campus.CAMPUS_NAME, " +
			" co.classNum, " +
			" tg.* " +
			"FROM teachergrade tg " +
			" LEFT JOIN courseplan cp ON tg.courseplan_id = cp.Id " +
			" LEFT JOIN class_order co ON cp.class_id = co.id " +
			" LEFT JOIN account s ON tg.studentid = s.Id " +
			" LEFT JOIN account t ON cp.TEACHER_ID = t.Id " +
			" LEFT JOIN course c ON cp.COURSE_ID = c.Id " +
			" LEFT JOIN time_rank r ON cp.TIMERANK_ID = r.Id " +
			" LEFT JOIN campus ON cp.CAMPUS_ID = campus.Id " +
			" LEFT JOIN (SELECT GROUP_CONCAT(tch.REAL_NAME) AS assistantName , cpa.courseplanId FROM courseplan_assistant cpa LEFT JOIN account tch ON tch.Id = cpa.teacherId GROUP BY cpa.courseplanId ) cpat ON cpat.courseplanId = cp.Id " +
			"WHERE cp.STATE = 0 AND cp.class_id != 0 AND s.STATE = 0 ";
		
		//课程
		String sqlFrom_2 = 
			"SELECT " +
			" c.Id COURSE_ID, " +
			" cp.Id cpid, " +
			" c.COURSE_NAME, " +
			" t.REAL_NAME TNAME, " +
			" s.REAL_NAME SNAME, " +
			" cpat.assistantName ZNAME, " +
			" DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d')COURSE_TIME, " +
			" r.RANK_NAME, " +
			" campus.CAMPUS_NAME, " +
			" 0, " +
			" tg.* " +
			"FROM courseplan cp " +
			" LEFT JOIN account t ON cp.TEACHER_ID = t.Id " +
			" LEFT JOIN account s ON cp.STUDENT_ID = s.Id " +
			" LEFT JOIN teachergrade tg ON tg.courseplan_id = cp.Id " +
			" LEFT JOIN course c ON cp.COURSE_ID = c.Id " +
			" LEFT JOIN time_rank r ON cp.TIMERANK_ID = r.Id " +
			" LEFT JOIN campus ON cp.CAMPUS_ID = campus.Id " +
			" LEFT JOIN (SELECT GROUP_CONCAT(tch.REAL_NAME) AS assistantName , cpa.courseplanId FROM courseplan_assistant cpa LEFT JOIN account tch ON tch.Id = cpa.teacherId GROUP BY cpa.courseplanId ) cpat ON cpat.courseplanId = cp.Id " +
			"WHERE cp.STATE = 0 AND cp.confirm = 1 AND cp.class_id = 0 ";
		
		StringBuffer sql = new StringBuffer();
		Set<String> keyList = queryParam.keySet();
		for (String key : keyList) {
			String value = queryParam.get(key);
			switch (key) {
			
			case "teacher_id"://老师id
				sql.append(" AND cp.TEACHER_ID = ? ");
				paramValue.add(value);
				break;
			case "teacher_name"://老师姓名
				sql.append(" AND t.REAL_NAME LIKE ? ");
				paramValue.add("%" + value + "%");
				break;
			case "student_id"://学生id
				sql.append(" AND s.Id = ? ");
				paramValue.add(value);
				break;
			case "student_name"://学生姓名
				sql.append(" AND s.REAL_NAME LIKE ? ");
				paramValue.add("%" + value + "%");
				break;
			case "scuserid"://市场id
				sql.append(" AND s.scuserid = ? ");
				paramValue.add(value);
				break;
			case "supervisor_id"://督导id
				sql.append(" AND s.SUPERVISOR_ID = ? ");
				paramValue.add(value);
				break;
			case "jwuserid"://教务id
				sql.append(" AND s.jwuserid = ? ");
				paramValue.add(value);
				break;
			case "kcgw_id"://课程顾问id
				sql.append(" AND s.Id IN(SELECT student_id FROM student_kcgw WHERE kcgw_id = ? ) ");
				paramValue.add(value);
				break;
			case "accountcampusids"://登陆人校区id
				if( StrKit.isBlank(value) ) break;
				sql.append(" AND FIND_IN_SET(cp.CAMPUS_ID, ?) ");
				paramValue.add(value);
				break;
			case "campus_id"://校区id
				sql.append(" AND FIND_IN_SET(cp.CAMPUS_ID, ?) ");
				paramValue.add(value);
				break;
			case "starttime"://开始时间
				sql.append(" AND cp.COURSE_TIME >= ? ");
				paramValue.add(value);
				break;
			case "endtime"://结束时间
				sql.append(" AND cp.COURSE_TIME <= ? ");
				paramValue.add(value);
				break;
			case "comment_state"://评论状态
				sql.append(" AND tg.UNDERSTAND " + ("0".equals(value) ? "='' " : "!='' ")   );
				break;
				
			}
		}
		
		//UNION 是组合多个表的内容然后作为一个表输出,会去掉重复的行
		String sqlWhere = sql.toString();
		formSqlSb.append(" FROM ( (" + sqlFrom_1 + sqlWhere + ") UNION ALL (" + sqlFrom_2 + sqlWhere + ") )a ORDER BY a.course_time DESC ");
		
		//sqlWhere 被拼接了 两次, 所以占位符 多了一倍,paramValue也拷贝一次
		paramValue.addAll(paramValue);
	}

	
}
