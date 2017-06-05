

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
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.sys.account.model.BanciCourse;
import com.momathink.teaching.classtype.model.ClassType;

public class ClassTypeService extends BaseService {
	
	public static final ClassTypeService me = new ClassTypeService();
	
	/**
	 * 班型管理分页
	 * @param splitPage
	 */
	@SuppressWarnings("unchecked")
	public void list(SplitPage splitPage) {
		String sql = "SELECT ct.status,ct.id,ct.`name` typeName , ct.subjectids subjectid, campus.campus_name";
		splitPageBase(splitPage, sql);
		Page<Record> page = (Page<Record>) splitPage.getPage();
		List<Record> olist = page.getList();
		for (Record r : olist) {
			Integer typeid = r.getInt("id");
			String coursename = "";
			List<BanciCourse> bclist = BanciCourse.dao.find("select c.COURSE_NAME courseName from banci_course bc left join course c on c.id=bc.course_id where banci_id =0 and type_id = ? ", typeid);
			for(BanciCourse bc : bclist){
				coursename +="、"+bc.getStr("courseName");
			}
			coursename = coursename.replaceFirst("、", "");
			r.set("coursename", coursename);
			String subname = "";
			List<BanciCourse> sublist = BanciCourse.dao.find("select distinct sub.SUBJECT_NAME subName from banci_course bc left join subject sub on sub.Id=bc.subject_id where bc.banci_id=0 and type_id = ? ", typeid)  ;
			for(BanciCourse bs : sublist){
				subname += "、"+bs.getStr("subName");
			}
			subname = subname.replaceFirst("、", "");
			r.set("subjectname", subname);
		}
	}
	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from class_type ct left join class_order on ct.id = class_order.classtype_id"
				+ " left join campus on ct.campusid = campus.id where 1=1 ");
		if (null == queryParam) {
			return;
		}
		String subid = queryParam.get("subjectid");
		String typeName = queryParam.get("typeName");
		String campus = queryParam.get( "classTypeCampus" );
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		if(!StringUtils.isEmpty(subid)){
			formSqlSb.append(" and ct.subjectids like ? ");
			paramValue.add("%\\|"+subid+"%");
		}
		if(!StringUtils.isEmpty(campus)){
			formSqlSb.append(" and class_order.campusId = ? ");
			paramValue.add( campus );
		}
		if(!StringUtils.isEmpty(typeName)){
			formSqlSb.append(" and ct.`name` like ? ");
			paramValue.add("%"+typeName+"%");
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds)){
			formSqlSb.append(" and ct.campusid in (" + loginRoleCampusIds + ") or ct.campusid is null " );
		}
		formSqlSb.append(" group by ct.id order by ct.Id desc ");
	}

	
	public static void update(ClassType classType) {
		try {
			classType.update();
		} catch (Exception e) {
			throw new RuntimeException("更新用户异常");
		}
	}
	
	

}
