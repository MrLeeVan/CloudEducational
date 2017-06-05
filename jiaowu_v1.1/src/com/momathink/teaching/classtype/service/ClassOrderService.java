
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

package com.momathink.teaching.classtype.service;

import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.teaching.course.model.CoursePlan;

public class ClassOrderService extends BaseService {
	
	public static final ClassOrderService me = new ClassOrderService();
	
	@SuppressWarnings("unchecked")
	public void list(SplitPage splitPage ) {
		String sql = "SELECT DISTINCT  class_order.id,	class_order.classNum className, class_order.classtype_id,kc.real_name kcgwname,"
				+ " class_order.stuNum, class_order.teachTime, class_order.is_assesment,class_order.endTime, class_type.`name` ,class_order.chargeType, "
				+ "	class_type.lesson_count, class_order.lessonNum, class_order.totalfee, class_type.id AS type_id,class_order.accountid, campus.campus_name ";
		splitPageBase(splitPage, sql );
		Page<Record> page = (Page<Record>) splitPage.getPage();
		List<Record> list = page.getList();
		for (Record r : list) {
			r.set("teachername", queryByClassid(r.getInt("id")));
			r.set("studentCount", AccountBanci.dao.getStudentCountByClassOrderId(r.getInt("id"),r.getInt("accountid")));
			r.set("coursePlanCount", CoursePlan.coursePlan.getClassYpkcClasshour(r.getInt("id")));
		}
	}
	
	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		
		formSqlSb.append(" from class_order  LEFT JOIN class_type ON class_order.classtype_id = class_type.id  "
				+ "	left join account kc on class_order.pcid = kc.id "
				+ " left join campus on class_order.campusid = campus.id WHERE  1=1 ");
		if (null == queryParam) {
			return;
		}
		String className = queryParam.get("className");
		String classTypeId = queryParam.get("classTypeId");
		String jieke = queryParam.get("jieke");
		String teachtimefirst = queryParam.get("teachtimefirst");
		String teachtimeend = queryParam.get("teachtimeend");
		String pcid = queryParam.get("pcid");
		String teacherid = queryParam.get("teacherid");
		String campus = queryParam.get( "classCampus" );
		String loginRoleCampusIds = queryParam.get("loginRoleCampusIds");
		
		boolean flag = true;
		if(!StringUtils.isEmpty(className)){
			flag= false;
			formSqlSb.append(" and class_order.classNum like ? ");
			paramValue.add("%"+className+"%");
		}
		if(!StringUtils.isEmpty(classTypeId)){
			flag= false;
			formSqlSb.append(" and class_order.classtype_id = ? ");
			paramValue.add(classTypeId);
		}
		if(!StringUtils.isEmpty(pcid)){
			flag= false;
			formSqlSb.append(" and class_order.pcid = ? ");
			paramValue.add(pcid);
		}
		if(!StringUtils.isEmpty(teacherid)){
			flag= false;
			String classids = queryByTeacherid(teacherid);
			if(StrKit.notBlank(classids))
				formSqlSb.append(" AND class_order.id IN (" +classids+ ") ");
		}
		if(!StringUtils.isEmpty(jieke)){
			flag= false;
			if(jieke.equals("1")){//1 结课
				formSqlSb.append(" and DATE_FORMAT(IFNULL(class_order.endTime,'2099-1-1'),'%Y-%m-%d') < (select current_date)");
			}else{//没结课
				formSqlSb.append(" and DATE_FORMAT(IFNULL(class_order.endTime,'2099-1-1'),'%Y-%m-%d') >= (select current_date)");
			}
			
		}
		if(!StringUtils.isEmpty(teachtimefirst)){
			flag= false;
			formSqlSb.append("  and class_order.teachTime >=  ? ");
			paramValue.add(teachtimefirst);
		}
		if(!StringUtils.isEmpty(teachtimeend)){
			flag= false;
			formSqlSb.append(" and class_order.teachTime <=  ?  ");
			paramValue.add(teachtimeend);
		}
		if( !StringUtils.isEmpty( campus )){
			flag= false;
			formSqlSb.append( " and class_order.campusid = ?");
			paramValue.add( campus );
		}
		if(flag){
			formSqlSb.append(" and DATE_FORMAT(IFNULL(class_order.endTime,'2099-1-1'),'%Y-%m-%d') >= (select current_date)" );
		}
		
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSqlSb.append(" AND (class_order.campusid IN (" + loginRoleCampusIds + ") OR class_order.campusid = 0)" );
		}
		
		formSqlSb.append(" ORDER BY class_order.id DESC ");
		
	}
	
	/**根据班次 查询老师,用 br 做分割*/
	public String queryByClassid(Object classid){
		return Db.queryStr(
				"SELECT " +
				"	REPLACE ( " +
				"		GROUP_CONCAT(ts.real_name), " +
				"		',', " +
				"		'<br>' " +
				"	) " +
				"FROM " +
				"	( " +
				"		SELECT " +
				"			t.real_name " +
				"		FROM " +
				"			courseplan cp " +
				"		LEFT JOIN account t ON cp.teacher_id = t.id " +
				"		WHERE " +
				"			cp.class_id = ? " +
				"		GROUP BY " +
				"			t.id " +
				"	) ts", classid);
	}
	
	/**根据老师 查询班次,用 "逗号" 做分割*/
	public String queryByTeacherid(Object teacherid){
		return Db.queryStr(
				"SELECT " +
				"	GROUP_CONCAT(ts.class_id) " +
				"FROM " +
				"	( " +
				"		SELECT " +
				"			cp.class_id " +
				"		FROM " +
				"			courseplan cp " +
				"		WHERE " +
				"			cp.teacher_id = ? " +
				"		GROUP BY " +
				"			cp.class_id " +
				"	) ts", teacherid);
	}

}
