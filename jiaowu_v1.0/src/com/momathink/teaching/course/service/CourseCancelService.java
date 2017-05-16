
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

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;

public class CourseCancelService extends BaseService {
	private static Logger log = Logger.getLogger(CourseCancelService.class);
	
	/**
	 * 分页
	 * 
	 * @param splitPage
	 */
	public void list(SplitPage splitPage){
		log.debug("已删除课程");
		String select = "SELECT " +
				"courseplan_back.Id, " +
				"DATE_FORMAT(courseplan_back.COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME, " +
				"DATE_FORMAT(courseplan_back.UPDATE_TIME,'%Y-%m-%d %H:%i:%s') AS UPDATE_TIME, " +
				"courseplan_back.REMARK, " +
				"courseplan_back.PLAN_TYPE, " +
				"courseplan_back.SIGNIN, " +
				"del.REAL_NAME AS deluserid, " +
				"teacher.REAL_NAME AS teacher_name, " +
				"student.REAL_NAME AS student_name, " +
				"course.COURSE_NAME, " +
				"classroom.`NAME`, " +
				"time_rank.RANK_NAME, " +
				"IFNULL(campus.CAMPUS_NAME,'') AS CAMPUS_NAME, " +
				"IFNULL(class_order.classNum,'无') AS classNum, " +
				"courseplan_back.del_msg ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(
				"FROM courseplan_back " +
				"LEFT JOIN account AS student ON courseplan_back.STUDENT_ID = student.Id " +
				"LEFT JOIN account AS teacher ON courseplan_back.TEACHER_ID = teacher.Id " +
				"LEFT JOIN account AS del ON courseplan_back.deluserid = del.Id " +
				"LEFT JOIN course ON courseplan_back.COURSE_ID = course.Id " +
				"LEFT JOIN classroom ON courseplan_back.ROOM_ID = classroom.Id " +
				"LEFT JOIN time_rank ON courseplan_back.TIMERANK_ID = time_rank.Id " +
				"LEFT JOIN campus ON courseplan_back.CAMPUS_ID = campus.Id " +
				"LEFT JOIN class_order ON courseplan_back.class_id = class_order.id WHERE 1=1");
		if (null == queryParam) {
			return;
		}
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds");
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			if(!StringUtils.isEmpty(value)){
				switch (paramKey) {
				case "studentname":
					formSqlSb.append(" and student.REAL_NAME = '").append(value).append("' ");
					break;
				case "userid":
					if(StrKit.isBlank(value) || "null".equals(value))
						break;
					formSqlSb.append(" and courseplan_back.STUDENT_ID = ? ");
					paramValue.add(value);
					break;
				case "startCourseDate":
					formSqlSb.append(" AND DATE_FORMAT(courseplan_back.COURSE_TIME,'%Y-%m-%d') >= ? ");
					paramValue.add(value);
					break;
				case "endCourseDate":
					formSqlSb.append(" AND DATE_FORMAT(courseplan_back.COURSE_TIME,'%Y-%m-%d') <= ? ");
					paramValue.add(value);
					break;
				case "startDelDate":
					formSqlSb.append(" AND courseplan_back.UPDATE_TIME >= ? ");
					paramValue.add(value+" 00:00:00");
					break;
				case "endDelDate":
					formSqlSb.append(" AND courseplan_back.UPDATE_TIME <= ? ");
					paramValue.add(value+" 59:59:59");
					break;
				case "campusid":
					formSqlSb.append(" AND courseplan_back.CAMPUS_ID in(" + value + ") ");
					break;
				case "confirm":
					formSqlSb.append(" AND courseplan_back.confirm in(" + value + ") ");
					break;
				default:
					break;
				}
			}
		}
		//当前登录角色所属的校区约束
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSqlSb.append( " and campus.id in ("+ loginRoleCampusIds +")");
		}
		formSqlSb.append(" ORDER BY courseplan_back.UPDATE_TIME DESC");
	}

}
