
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

package com.momathink.teaching.teacher.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;

public class TeacherGroupService extends BaseService {
	private static Logger log = Logger.getLogger(TeacherGroupService.class);

	public static final TeacherGroupService me = new TeacherGroupService();
	
	/**
	 * 教研组分页
	 */
	public void list(SplitPage splitPage){
		log.debug("教师分组：分页处理");
		String select = "SELECT distinct g.*,t.REAL_NAME";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from teachergroup g "
				+ " left join account t on g.leaderid=t.Id "
				+ " left join account_campus accountCampus on g.leaderid = accountCampus.account_id "
				+ " left join campus on accountCampus.campus_id = campus.id "
				+ " where 1=1" );
		if (null == queryParam) {
			return;
		}
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "groupname":
				formSqlSb.append(" and g.groupname like  ? ");
				paramValue.add("%" + value + "%");
				break;
			case "leadername":
				formSqlSb.append(" and t.REAL_NAME like  ? ");
				paramValue.add("%" + value + "%");
				break;
			default:
				break;
			}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds ) ){
			formSqlSb.append( " and campus.id in (" + loginRoleCampusIds + ")" );
		}
		formSqlSb.append("");
	}
	
}
