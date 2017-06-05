
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

package com.momathink.common.task;

import java.util.List;

import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolArith;

/***
 * 机构信息
 */
@SuppressWarnings("serial")
@Table(tableName = "crm_organization")
public class Organization extends BaseModel<Organization> {

	public static final Organization dao = new Organization();
	
	//避免频繁的 查询 id 为 1  的 机构信息
	private static Organization staticOrg = null;
	
	public static Organization getOrg() {
		if (staticOrg == null)
			staticOrg = dao.findFirst("select * from crm_organization WHERE id = 1");
		return staticOrg;
	}
	
	@Override
	public boolean update() {
		if(super.update()){
			if("1".equals(this.get("id") + ""))
				staticOrg = null;
			return true;
		}else return false;
	}

	@Override
	public Organization findById(Object idValue) {
		if("1".equals((idValue) + ""))
			return getOrg();
		return super.findById(idValue);
	}

	public List<Organization> getAllOrganizationMessage() {
		String sql = "select * from crm_organization ";
		return dao.find(sql);
	}
	
	public Organization getOrganizationMessage() {
		return getOrg();
	}
	
	/***获取学生初始密码
	 */
	public String getStuLnitialPassword(){
		if(this.equals(dao)) 
			return getOrg().getStr("stuLnitialPassword");
		return getStr("stuLnitialPassword");
	}
	
	/***获取老师初始密码
	 */
	public String getTchLnitialPassword(){
		if(this.equals(dao)) 
			return getOrg().getStr("tchLnitialPassword");
		return getStr("tchLnitialPassword");
	}
	
	/** 购课课时 审核阀值, 太小的不要审核了 
	 * @param classhour 购课课时
	 * @return 小于阀值 的= true ,  大于阀值 的=false **/
	public boolean isBasicAudithourmaxnumber(Double classhour){
		if(this.equals(dao)) 
			return ToolArith.compareTo(getOrg().getInt("basic_audithourmaxnumber") , classhour) >= 0;
		return ToolArith.compareTo(getInt("basic_audithourmaxnumber") , classhour) >= 0;
	}
	
	
}
