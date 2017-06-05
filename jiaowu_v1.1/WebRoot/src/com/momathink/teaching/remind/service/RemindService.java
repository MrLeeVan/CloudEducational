
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

package com.momathink.teaching.remind.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.ItemsOutIn;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;
import com.momathink.teaching.remind.model.Remind;

/**
 * 2015年10月26日
 * @author prq
 *
 */

public class RemindService extends BaseService {
	
	private static Logger log = Logger.getLogger(RemindService.class);
	public static final RemindService service = new RemindService();

	/**
	 * 提醒管理   分页
	 * @param splitPage
	 */
	public void list(SplitPage splitPage) {
		log.debug("教材物品管理：分页处理");
		String select = " select remind.*,st.real_name stname,user.real_name sysuser";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from crm_remind remind ");
		formSqlSb.append(" left join account user on user.id = remind.sysuser ");
		formSqlSb.append(" LEFT JOIN account st ON st.id = remind.stuid ");
		formSqlSb.append(" WHERE 1 = 1  ");
		if (null == queryParam) {
			return;
		}

		String remindname = queryParam.get("remindname");
		String startDate = queryParam.get("startDate");
		String endDate = queryParam.get("endDate");
		String userId = queryParam.get("userId");
		String read = queryParam.get("read");
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		SysUser sysuser = SysUser.dao.findById(Integer.parseInt(userId));
		if(!Role.isAdmins(sysuser.getStr("roleids"))){//非管理员
			formSqlSb.append(" and remind.sysuser = ? ");
			paramValue.add(userId);
		}
		
		if (null != remindname && !remindname.equals("")) {
			formSqlSb.append(" and st.real_name like ?");
			paramValue.add("%" + remindname + "%");
		}
		if (null != read && !read.equals("")) {
			formSqlSb.append(" and remind.read = ?");
			paramValue.add(read);
		}
		if (null != startDate && !startDate.equals("")) {
			formSqlSb.append(" and remind.createdate >= ? ");
			paramValue.add(startDate + " 00:00:00");
		}
		if (null != endDate && !endDate.equals("")) {
			formSqlSb.append(" and remind.createdate <= ? ");
			paramValue.add(endDate + " 23:59:59");
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds ) ){
			formSqlSb.append( " and st.campusid in (" + loginRoleCampusIds + ")" );
		}
	}
	
	/**
	 * 保存
	 * @param remind
	 * @return
	 */
	public boolean save(Remind remind,String userids) {
		try{
			remind.set("createdate", ToolDateTime.getDate());
			remind.set("version", 0);
			remind.set("sysuser", userids);
			remind.save();
			return true;
		}catch(Exception ex){
			ex.printStackTrace();
			return false;
		}
	}

	/**
	 * 更新提醒
	 * @param remind
	 * @param string
	 * @return
	 */
	public boolean update(Remind remind, String userids) {
		try{
			remind.set("updatedate", ToolDateTime.getDate());
			remind.set("version", remind.getLong("version")+1);
			remind.set("sysuser", userids);
			remind.update();
			return true;
		}catch(Exception ex){
			ex.printStackTrace();
			return false; 
		}
	}

	/**
	 * 删除提醒
	 * @param ids
	 * @return
	 */
	public boolean deleteRemind(String ids) {
		try{
			Remind remind = Remind.dao.findById(ids);
			if(remind==null){
				return true;
			}else{
				return remind.delete();
			}
		}catch(Exception ex){
			ex.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 标记已读
	 * @param ids
	 * @return
	 */
	public boolean updateRead(String ids) {
		try{
			Remind remind = Remind.dao.findById(ids);
			if(remind==null){
				return true;
			}else{
				remind.set("read", 1);
				return remind.update();
			}
		}catch(Exception ex){
			ex.printStackTrace();
			return false;
		}
	}
	/**
	 * 更新出库
	 * @param out
	 * @param bi
	 * @param cUserIds
	 * @return
	 */
	public boolean updateRead(ItemsOutIn out,  String cUserIds) {
		try {
			if(null!=out.getLong("fnum")){
				out.set("handlenum", -out.getLong("fnum"));
			}
			out.set("sysuserids", cUserIds);
			out.set("handletime", ToolDateTime.getDate());
			return out.update();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

}
