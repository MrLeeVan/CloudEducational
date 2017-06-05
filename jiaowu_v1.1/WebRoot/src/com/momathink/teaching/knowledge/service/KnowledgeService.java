
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

package com.momathink.teaching.knowledge.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.sys.dict.model.Dict;
import com.momathink.sys.operator.model.Role;
import com.momathink.teaching.course.model.CoursePlan;

public class KnowledgeService extends BaseService {

	public static final KnowledgeService me = new KnowledgeService();
	
	/***获取 老师评价学生 的  UI 信息 */
	public List<Dict> getTeachertostu(){
		String type = Dict.dao.queryValGetDictname("jiaoxue_ketang_teachertostu_type");
		List<Dict> teachertostu = Dict.dao.cacheGetChild(type);
		
		for (Dict dict : teachertostu) {
			List<Dict> dictlist = Dict.dao.cacheGetChild(dict.getStr("numbers"));
			dict.put("dictlist", dictlist);
		}
		
		return teachertostu;
	}
	
	/**获取同日期(不算小时),同老师,同学生,同课程  */
	public Map<String, Object> queryBySimilarityCourseplan(CoursePlan courseplan){
		
		List<CoursePlan> courseplans = CoursePlan.coursePlan.find(
				"SELECT courseplan.Id,time_rank.RANK_NAME "
				+ "FROM courseplan "
				+ "LEFT JOIN time_rank ON time_rank.Id = courseplan.TIMERANK_ID "
				+ "LEFT JOIN teachergrade ON teachergrade.COURSEPLAN_ID = courseplan.Id "
				+ "WHERE teachergrade.UNDERSTAND != '' AND courseplan.Id != ? AND COURSE_ID = ? AND TEACHER_ID = ? AND COURSE_TIME = ? AND STUDENT_ID = ? ", 
				courseplan.get("ID"),
				courseplan.get("COURSE_ID"),
				courseplan.get("TEACHER_ID"),
				courseplan.get("COURSE_TIME"),
				courseplan.get("STUDENT_ID")
				);
		
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("size", courseplans.size());
		ret.put("courseplans", courseplans);
		return ret;
	}
	
	/**查询 未评论的课程
	 * @param sysuserId */
	public long queryByTeachergradeNoComment(Record sysuser){
		String roleids = sysuser.getStr("roleids");
		Integer uid = sysuser.getInt("id");
		
		String sql ="SELECT COUNT(*) " +
					"FROM courseplan " +
					"LEFT JOIN teachergrade ON teachergrade.COURSEPLAN_ID = courseplan.Id " +
					"WHERE teachergrade.UNDERSTAND = '' ";
		//老师与其他角色 不可共存(数据不好查询), 老师优先
		if(Role.isTeacher(roleids)){
			sql += " AND courseplan.TEACHER_ID = " + uid;
		}else if(Role.isDudao(roleids)){
			sql += " AND courseplan.STUDENT_ID IN( " + 
						"SELECT allstu.Id FROM ( " +
						"SELECT " +
						"	bcid.Id " +
						"FROM " +
						"	account bcid " +
						"LEFT JOIN class_order cr ON cr.accountid = bcid.Id " +
						"LEFT JOIN account_banci bi ON bi.banci_id = cr.id " +
						"LEFT JOIN account stu ON stu.Id = bi.account_id " +
						"WHERE stu.SUPERVISOR_ID = " + uid + " AND stu.STATE = 0 " +
						" UNION " +
						"SELECT Id FROM account WHERE SUPERVISOR_ID = " + uid + " AND STATE = 0 " +
					") allstu )";
		}
		
		return Db.queryLong(sql);
	}
	
}
