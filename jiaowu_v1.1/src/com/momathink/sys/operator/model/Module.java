
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

package com.momathink.sys.operator.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;

/**
 菜单 模块 管理
 */
@Table(tableName="pt_module")
public class Module extends BaseModel<Module> {

	private static final long serialVersionUID = -1515933061522779523L;
	public static final Module dao = new Module();
	
	/** 查询所有的 模块 */
	public List<Module> queryAll(){
		return dao.find("SELECT * FROM pt_module");
	}

	/** 查询 现有 排序 最大的 数字  */
	public Long queryByOrderidsMax() {
		String sql = "SELECT MAX(orderids) FROM pt_module";
		return Db.queryNumber(sql).longValue();
	}

	/*** 根据父级模块 查询子模块 */
	public List<Module> queryByParentmoduleids(String parentmoduleids) {
		String sql = "SELECT * FROM pt_module WHERE parentmoduleids = ? ";
		return dao.find(sql, parentmoduleids);
	}

	/**
	 * 根据模块标题  获取应有的模块功能权限*
	 * @param systemsid
	 * @return
	 */
	public static List<Module> getFeatures(String systemsid) {
		String  sql ="SELECT m.*,i.name iconname FROM pt_module m "
				+ " LEFT JOIN pt_icon i on m.iconid = i.id "
				+ "  WHERE ISNULL(m.parentmoduleids) AND  m.systemsids = ? ORDER BY orderids";
		return dao.find(sql, systemsid);
	}
	
	/**
	 * 获取模块下的小功能*
	 * @param moduleid
	 * @return
	 */
	public List<Module> queryBYParentmoduleids(String parentmoduleids) {
		String sql = "SELECT * FROM pt_module WHERE parentmoduleids IN("+parentmoduleids+") ORDER BY parentmoduleids,orderids";
		return dao.find(sql);
	}

	public List<Module> findByAllOperator(Integer sysuserId) {
		String sql = "SELECT count(a.systemsids) maxsyscount ,a.systemsids FROM ( "
				+ " SELECT mo.systemsids,mo.`names`,  mo.parentmoduleids ,mo.id "
				+ " FROM pt_module mo  LEFT JOIN pt_module pmo ON pmo.id = mo.parentmoduleids "
				+ " WHERE FIND_IN_SET(mo.id ,(  SELECT GROUP_CONCAT(DISTINCT moduleids) FROM pt_operator "
				+ " WHERE FIND_IN_SET(id,( SELECT GROUP_CONCAT( DISTINCT REPLACE( operatorids,'operator_','') ) FROM pt_role "
				+ " WHERE FIND_IN_SET( id , (SELECT GROUP_CONCAT(DISTINCT roleids) FROM account WHERE id = ? )) )) ) ) "
				+ " AND pmo.parentmoduleids IS NULL  GROUP BY parentmoduleids ) a  GROUP BY a.systemsids ORDER BY maxsyscount DESC";
		return dao.find(sql,sysuserId);
	}
	

}
