
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
package com.momathink.common.tools;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.jfinal.kit.StrKit;
import com.momathink.sys.operator.model.Module;
import com.momathink.sys.operator.model.Operator;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;

public class ToolOperatorSession {
	
	/**编码 当  K*/
	private static Map<String, String> roleMap = new HashMap<String, String>();
	/**id  当K */
	private static Map<String, Role> roleIdMap = new HashMap<String, Role>();
	
	public static Map<Object,Object> operatorSessionSet(String userId){
		Map<Object,Object> map = new HashMap<Object,Object>();
		try{
			StringBuffer moduleinids = new StringBuffer();
			SysUser user = SysUser.dao.findById(userId);
			if(!Role.isAdmins(user.getStr("roleids"))){
				String roleids = user.getStr("roleids");
				StringBuffer rolesin = new StringBuffer("select id,names,operatorids from pt_role where id in (").append(roleids.substring(0, roleids.length()-1)).append(" ) order by names asc");
				List<Role> rolelist = Role.dao.find(rolesin.toString());
				StringBuffer roleBuffer = new StringBuffer();
				for(Role role:rolelist){
					if(!StringUtils.isEmpty(role.getStr("operatorids"))){
						roleBuffer.append(role.getStr("operatorids").replace("operator_", ""));
					}
				}
				String operatorids = toSql(roleBuffer.toString());
				StringBuffer operatorin = new StringBuffer("select id,names,url,privilege,moduleids,formaturl from pt_operator where id in (").append(operatorids).append(" ) order by names asc ");
				StringBuffer operatornotin = new StringBuffer("select id,names,privilege,url,moduleids,formaturl from pt_operator where id not in (").append(operatorids).append(" ) order by names asc ");
				List<Operator> operatorinList = Operator.dao.find(operatorin.toString());
				List<Operator> operatornotList = Operator.dao.find(operatornotin.toString());
				for(Operator opin:operatorinList){
					map.put(opin.getStr("formaturl"), true);
					moduleinids.append(",\"").append(opin.getStr("moduleids")).append("\"");
				}
				for(Operator opnotin:operatornotList){
					if(opnotin.getStr("privilege").equals("0")){
						map.put(opnotin.getStr("formaturl"), true);
					}else{
						map.put(opnotin.getStr("formaturl"), false);
					}
				}
			}else{
				//
				List<Operator> unoperatorlist = Operator.dao.queryAll();
				for(Operator unoperator:unoperatorlist){
					if(Role.isAdmins(user.getStr("roleids"))){
						map.put(unoperator.getStr("formaturl"), true);
						moduleinids.append(",\"").append(unoperator.getStr("moduleids")).append("\"");
					}else{
						if(unoperator.getStr("privilege").equals("0")){
							map.put(unoperator.getStr("formaturl"), true);
							moduleinids.append(",\"").append(unoperator.getStr("moduleids")).append("\"");
						}else{
							map.put(unoperator.getStr("formaturl"), false);
						}
					}
				}
			}
			String muinids = moduleinids.toString().replaceFirst(",", "");
			StringBuffer strmoduleids = new StringBuffer();
			List<Module> moduleinlist =  Module.dao.find("select * from pt_module where 1=1 and id in ("+muinids+")");
			for(Module module: moduleinlist){
				strmoduleids.append(",\"").append(module.getStr("parentmoduleids")).append("\"");
				map.put(module.getStr("numbers"), true);
			}
			List<Module> parentmodule = Module.dao.find("select * from pt_module where 1=1 and isparent = 'true' and id in ( "+strmoduleids.toString().replaceFirst(",", "")+" )");
			List<Module> parentnotmodule = Module.dao.find("select * from pt_module where 1=1 and isparent = 'true' and id not in ("+strmoduleids.toString().replaceFirst(",", "")+")");
			for(Module parent:parentmodule){
				map.put(parent.getStr("numbers"), true);
			}
			for(Module parentnot : parentnotmodule){
				map.put(parentnot.getStr("numbers"), false);
			}
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		//取出所在分组、所在角色、角色具有权限  为可
		
		return map;	
	}

	
	protected static String toSql(String ids) {
		if (null == ids || ids.isEmpty()) {
			return "";
		}

		String[] idsArr = ids.split(",");
		StringBuilder sqlSb = new StringBuilder();
		int length = idsArr.length;
		for (int i = 0, size = length - 1; i < size; i++) {
			sqlSb.append(" '").append(idsArr[i]).append("', ");
		}
		if (length != 0) {
			sqlSb.append(" '").append(idsArr[length - 1]).append("' ");
		}

		return sqlSb.toString();
	}
	
	/**
	 * 判断角色
	 * 
	 * @param numbers
	 *            角色编码
	 * @param roleids
	 *            角色表的id, 允许逗号 “,” 拼接的字符串
	 * @return 是：返回true 否：返回false
	 */
	public static boolean judgeRole(String numbers, String roleids) {
		String roleId = roleMap.get(numbers);
		if (StrKit.isBlank(roleids) || StrKit.isBlank(numbers) || StrKit.isBlank(roleId) ) {
			return false;
		}
		
		String key = numbers + "_" + roleids;
		String numbers_roleids = roleMap.get(key);
		if(numbers_roleids != null)
			return true;
			
		String[] roleid = roleids.split(",");
		for (int i = 0; i < roleid.length; i++) {
			if (roleId.equals(roleid[i])) {
				roleMap.put(key, roleId);
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 获取角色
	 * 
	 * @param roleids
	 *            角色表的id, 允许逗号 “,” 拼接的字符串
	 * @return 返回  List<Role> 注意 千万不要 删除或修改  List中的对象, 只可查询使用
	 */
	public static List<Role> getRole(String roleids) {
		if (StrKit.isBlank(roleids))
			return new ArrayList<Role>();
		
		//Role roleMap = roleIdMap.get(roleids);
		//if(roleMap != null)
			//return roleMap.get("roles");
		
		ArrayList<Role> roles =  new ArrayList<Role>();
		
		String[] roleid = roleids.split(",");
		for (int i = 0; i < roleid.length; i++) {
			Role role = roleIdMap.get(roleid[i]);
			if(role != null)
				roles.add(role);
		}
		
		//roleIdMap.put(roleids, new Role().put("roles", roles));
		
		return roles;
	}

	/**
	 * 刷新加载数据库中的角色到系统内存map
	 */
	public static void refreshRoleMap() {
		/**编码 当  K*/
		Map<String, String> mroleMap = new HashMap<String, String>();
		/**id  当K */
		Map<String, Role> mroleIdMap = new HashMap<String, Role>();
		List<Role> roleList = Role.dao.getAllRole();
		for (Role role : roleList) {
			mroleMap.put(role.getStr("numbers"), role.get("id").toString());
			mroleIdMap.put(role.get("id").toString(), role);
		}
		roleMap.clear();
		roleMap.putAll(mroleMap);
		roleIdMap.clear();
		roleIdMap.putAll(mroleIdMap);
	}
	
	
}
