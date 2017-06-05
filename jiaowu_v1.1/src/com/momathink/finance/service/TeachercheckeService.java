
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

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;

public class TeachercheckeService extends BaseService {
	
	public void list(SplitPage splitPage) {
		String select = "select p.teacher_id,c.real_name,"
				+ "SUM( IF ( p.iscancel = 0, t.class_hour, p.teacherhour )) zks,"
				+ "IFNULL(a.sign,0) zc,IFNULL(b.sign,0) cd,"
				+ "IFNULL(e.sign,0) wq,IFNULL(d.sign,0) bq,DATE_FORMAT(p.COURSE_TIME,'%Y-%m') yuefen,"
				+ "IF(s.stat_time,1,0) AS yijs";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String date = queryParam.get("date");
		String date1 = "";
		String date2 = "";
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		try{
			if (null != date && !date.equals("")) {
				Date dateD1 = sf.parse(date+"-1 00:00:00");
				Date date11 = ToolDateTime.getFirstDateOfMonth(dateD1);
				Date date12 = ToolDateTime.getLastDateOfMonth(dateD1);
				date1 = ToolDateTime.format(date11, "yyyy-MM-dd")+" 00:00:00";
				date2 = ToolDateTime.format(date12, "yyyy-MM-dd")+" 23:59:59";
			}else{
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				calendar.add(Calendar.MONTH, -1);
				Date datem =calendar.getTime();
				Date date11 = ToolDateTime.getFirstDateOfMonth(datem);
				Date date12 = ToolDateTime.getLastDateOfMonth(datem);
				date1 = ToolDateTime.format(date11, "yyyy-MM-dd")+" 00:00:00";
				date2 = ToolDateTime.format(date12, "yyyy-MM-dd")+" 23:59:59";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		formSqlSb.append("FROM courseplan p "
				+ " LEFT JOIN salary s ON p.teacher_id = s.teacher_id "
				+ " AND DATE_FORMAT(p.COURSE_TIME, '%Y-%m') = s.stat_time "
				+ " LEFT JOIN time_rank t ON p.TIMERANK_ID = t.Id "
				+ " LEFT JOIN account c ON c.Id = p.TEACHER_ID "
				+ " LEFT JOIN courseplan_salary cpsy ON cpsy.courseplanid = p.id AND cpsy.TEACHER_ID = p.TEACHER_ID "
				+ " LEFT JOIN account_campus accountCampus ON c.id = accountCampus.account_id "
				+ " LEFT JOIN ( SELECT p.TEACHER_ID,SUM( IF ( p.iscancel = 0, t.class_hour, p.teacherhour )) AS sign "
				+ "	FROM	courseplan p"
				+ "  LEFT JOIN time_rank t ON p.TIMERANK_ID = t.Id "
				+ " LEFT JOIN account c ON c.Id = p.TEACHER_ID"
				+ "  WHERE LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', c.roleids) ) > 0 AND p.PLAN_TYPE = 0	AND p.SIGNIN = 1 "
				+ " AND p.COURSE_TIME <= ? AND p.COURSE_TIME >= ? "
				+ " GROUP BY p.TEACHER_ID, p.SIGNIN ) a ON a.TEACHER_ID = p.TEACHER_ID "
				+ " LEFT JOIN ( SELECT p.TEACHER_ID,SUM( IF ( p.iscancel = 0, t.class_hour, p.teacherhour )) AS sign "
				+ " FROM	courseplan p "
				+ " LEFT JOIN time_rank t ON p.TIMERANK_ID = t.Id"
				+ "  LEFT JOIN account c ON c.Id = p.TEACHER_ID "
				+ " WHERE LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', c.roleids) ) > 0 AND p.PLAN_TYPE = 0	AND p.SIGNIN = 0 "
				+ " AND p.COURSE_TIME <= ? AND p.COURSE_TIME >= ? "
				+ " GROUP BY p.TEACHER_ID, p.SIGNIN ) e ON e.TEACHER_ID = p.TEACHER_ID"
				+ "  LEFT JOIN (SELECT	p.TEACHER_ID,	SUM( IF ( p.iscancel = 0, t.class_hour, p.teacherhour )) AS sign	"
				+ " FROM	courseplan p	"
				+ " LEFT JOIN time_rank t ON p.TIMERANK_ID = t.Id	"
				+ " LEFT JOIN account c ON c.Id = p.TEACHER_ID	"
				+ " WHERE LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', c.roleids) ) > 0 AND p.PLAN_TYPE = 0 AND p.SIGNIN = 2"
				+ "  AND p.COURSE_TIME <= ? AND p.COURSE_TIME >= ? "
				+ " GROUP BY p.TEACHER_ID, p.SIGNIN) b ON b.TEACHER_ID = p.TEACHER_ID "
				+ " LEFT JOIN (	SELECT p.TEACHER_ID, SUM( IF ( p.iscancel = 0, t.class_hour, p.teacherhour )) AS sign "
				+ " FROM courseplan p"
				+ "  LEFT JOIN time_rank t ON p.TIMERANK_ID = t.Id "
				+ " LEFT JOIN account c ON c.Id = p.TEACHER_ID"
				+ "  WHERE LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', c.roleids) ) > 0 AND p.PLAN_TYPE = 0	AND p.SIGNIN = 3 "
				+ " AND p.COURSE_TIME <= ? AND p.COURSE_TIME >= ? "
				+ " GROUP BY p.TEACHER_ID, p.SIGNIN) d ON d.TEACHER_ID = p.TEACHER_ID "
				+ " WHERE LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', c.roleids) ) > 0 AND p.PLAN_TYPE = 0 "
				+ " AND p.COURSE_TIME <= ? AND p.COURSE_TIME >= ? ");
		paramValue.add(date2);
		paramValue.add(date1);
		paramValue.add(date2);
		paramValue.add(date1);
		paramValue.add(date2);
		paramValue.add(date1);
		paramValue.add(date2);
		paramValue.add(date1);
		paramValue.add(date2);
		paramValue.add(date1);
		
		String teachername = queryParam.get("teachername");
		if (null != teachername && !teachername.equals("")) {
			formSqlSb.append(" AND c.real_name like ? ");
			paramValue.add("%" + teachername + "%");
		}
		if( !StringUtils.isEmpty(loginRoleCampusIds)){
			formSqlSb.append( " AND accountCampus.campus_id in (" + loginRoleCampusIds + ")" );
		}
		formSqlSb.append(" GROUP BY	p.TEACHER_ID");
	}
	
}
