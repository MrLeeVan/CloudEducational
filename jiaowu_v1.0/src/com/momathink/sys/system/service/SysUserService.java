
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

package com.momathink.sys.system.service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolOperatorSession;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;

public class SysUserService extends BaseService {

	private static Logger log = Logger.getLogger(SysUserService.class);

	public static final SysUserService me = new SysUserService();
	
	/**
	 * 系统用户分页
	 * @param splitPage
	 */
	@SuppressWarnings("unchecked")
	public void list(SplitPage splitPage) {
		log.debug("分页处理");
		String select = " select  GROUP_CONCAT(campus.CAMPUS_NAME ) as CAMPUS_NAME , s.* ";
		splitPageBase(splitPage, select);
		Page<Record> page = (Page<Record>) splitPage.getPage();
		List<Record> list = page.getList();
		for(Record r:list){
			String roleids = r.getStr("roleids");
			if(ToolString.isNull(roleids))
				continue;
			List<Role> roleList = ToolOperatorSession.getRole(roleids);
			if(roleList.size()==0)
				continue;
			r.set("row",roleList.size());
			r.set("firstRole",roleList.get(0));
			roleList.remove(0);
			r.set("roleNames",roleList);
		}
	}
 
	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from account s "
				+ " left join account_campus accountCampus ON s.id = accountCampus.account_id "
				+ " left join campus on accountCampus.campus_id = campus.id where user_type=0 ");
		if (null == queryParam) {
			return;
		}
		String loginRoleCampusIds =  queryParam.get( "loginRoleCampusIds" );
		if( !StringUtils.isEmpty( loginRoleCampusIds)){
			formSqlSb.append( " and ( campus.id in(" + loginRoleCampusIds + ") or campusid is null )"  );
		}
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "sysusername":
				formSqlSb.append(" and s.real_name like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "phonenumber":
				formSqlSb.append(" and s.tel like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "email":
				formSqlSb.append(" and s.email like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "roleids":
				formSqlSb.append(" AND CONCAT(',', s.roleids) LIKE ? ");
				paramValue.add("%"+ value +",%");
				break;
			default:
				break;
			}
		}
		formSqlSb.append(" group by s.Id ORDER BY s.id DESC");
	}
	
	@Before(Tx.class)
	public int save(SysUser account) {
		int id;
		try {
			// 保存顾问
			account.set("state", "0");
			account.set("create_time", new Date());
			account.save();
			 id =account.getPrimaryKeyValue();
		} catch (Exception e) {
			throw new RuntimeException("保存用户异常");
		}
		return id;
	}

	@Before(Tx.class)
	public void update(SysUser account) {
		try {
			account.set("update_time", new Date());
			account.update();
		} catch (Exception e) {
			throw new RuntimeException("更新用户异常");
		}
	}
}
