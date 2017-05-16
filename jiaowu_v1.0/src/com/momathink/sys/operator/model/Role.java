
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

import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolOperatorSession;

/** 角色 管理  
 * */
@Table(tableName="pt_role")
public class Role extends BaseModel<Role> {
	private static final long serialVersionUID = 2014788334586877154L;
	public static final Role dao = new Role();
	
	/**
	 * 重写save方法
	 */
	public boolean save() {
		if(super.save()){
			ToolOperatorSession.refreshRoleMap();
			return true;
		}
		return false;
	}
	
	/**
	 * 重写update方法
	 */
	public boolean update() {
		this.set("version", this.getLong("version")+1);
		if(super.update()){
			ToolOperatorSession.refreshRoleMap();
			return true;
		}
		return false;
	}
	
	/**
	 * 根据roleids判断是否是管理员
	 * @param roleids
	 * @return
	 */
	public static boolean isAdmins(String roleids){
		return ToolOperatorSession.judgeRole("admins", roleids);
	}
	
	/**
	 * 根据roleids判断是否是学生
	 * @param roleids
	 * @return
	 */
	public static boolean isStudent(String roleids){
		return ToolOperatorSession.judgeRole("student", roleids);
	}
	
	/**
	 * 根据roleids判断是否是教师
	 * @param roleids
	 * @return
	 */
	public static boolean isTeacher(String roleids){
		return ToolOperatorSession.judgeRole("teachers", roleids);
	}
	
	/**
	 * 根据roleids判断是否是教务
	 * @param roleids
	 * @return
	 */
	public static boolean isJiaowu(String roleids){
		return ToolOperatorSession.judgeRole("jiaowu", roleids);
	}
	
	/**
	 * 根据roleids判断是否是督导
	 * @param roleids
	 * @return
	 */
	public static boolean isDudao(String roleids){
		return ToolOperatorSession.judgeRole("dudao", roleids);
	}
	
	/**
	 * 根据roleids判断是否是市场
	 * @param roleids
	 * @return
	 */
	public static boolean isShichang(String roleids){
		return ToolOperatorSession.judgeRole("shichang", roleids);
	}
	
	/**
	 * 根据roleids判断是否是课程顾问负责人
	 * @param roleids
	 * @return
	 */
	public static boolean isKcgwfzr(String roleids){
		return ToolOperatorSession.judgeRole("kechengguwen", roleids);
	}
	
	/**
	 * 根据roleids判断是否是课程顾问
	 * @param roleids
	 * @return
	 */
	public static boolean isKcgw(String roleids){
		return ToolOperatorSession.judgeRole("kcgw", roleids);
	}
	
	/**
	 * 根据roleids判断是否是财务
	 * @param roleids
	 * @return
	 */
	public static boolean isCaiwu(String roleids){
		return ToolOperatorSession.judgeRole("caiwu", roleids);
	}
	
	/**
	 * 根据roleids判断是否是教学总监
	 * @param roleids
	 * @return
	 */
	public static boolean isJxzj(String roleids){
		return ToolOperatorSession.judgeRole("jxzj", roleids);
	}
	
	/**
	 * 根据roleids判断是否是课程内容总监
	 * @param roleids
	 * @return
	 */
	public static boolean isKcnrzj(String roleids){
		return ToolOperatorSession.judgeRole("kcnrzj", roleids);
	}
	
	/**
	 * 获取所有的角色*
	 * @return
	 */
	public List<Role> getAllRole() {
		String  sql="select * from pt_role ";
		return dao.find(sql);
	}
	
	/**
	 * 获取老师和学生以外所有的角色*
	 * @return
	 */
	public Object getAllRoleNost() {
		String sql ="select id,names from pt_role where numbers <> 'student' and numbers <> 'teacher'";
		return dao.find(sql);
	}
	
	/**
	 * 保存学生保存role表numbers为student的id*
	 * @param string
	 * @return
	 */
	public Role getRoleByNumbers(String numbers) {
		String sql = "select id from pt_role where numbers = '"+numbers+"'";
		return dao.findFirst(sql);
	}
	
	
}
