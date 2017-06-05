
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
package com.momathink.sys.system.model;

import java.util.List;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolString;
/***
 * 账户 管理
 */
@SuppressWarnings("serial")
@Table(tableName = "account")
public class SysUser extends BaseModel<SysUser> {

	public static final SysUser dao = new SysUser();

	/** 获取 所有账户  使用的 角色 组合 */
	public List<SysUser> queryAllRoleids(){
		return dao.find("SELECT roleids FROM account WHERE roleids != ''  GROUP BY roleids");
	}
	
	public List<SysUser> getSysUser(){
		return dao.find("select * from account a where state=0 and "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', a.roleids) ) = 0 "
				+ " and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', a.roleids) ) = 0");
	}
	
	/** 获取系统当前登录角色所属校区的->系统用户 (不包含  老师 和学生)*/
	public List<SysUser> getSysUserByLoginRoleCampus( String loginRoleCampusIds ){
		return queryByRoleCampusIds(loginRoleCampusIds, true, true);
	}
	
	/** 根据角色ID(允许多ID, 逗号 间隔) 查询 系统用户 (不包含  学生)*/
	public List<SysUser> queryByRoleCampusIdsInside( String loginRoleCampusIds ){
		return queryByRoleCampusIds(loginRoleCampusIds, true, false);
	}
	
	
	/***根据角色ID(允许多ID, 逗号 间隔) 查询, true 是屏蔽
	 */
	private List<SysUser> queryByRoleCampusIds(String roleCampusIds , Boolean andStudent , Boolean andTeachers){
		StringBuilder sql =  new StringBuilder()
		.append("select distinct a.* from account a ")
		.append(" left join account_campus on a.id = account_campus.account_id ")
		.append(" left join campus on account_campus.campus_id = campus.id ")
		.append(" WHERE a.state=0 ");

		if(andStudent)
			sql.append(" and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', a.roleids) ) = 0 ");
		
		if(andTeachers)
			sql.append(" and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', a.roleids) ) = 0 ");
		
		//if(andXxx) //有需要 请继续 扩展
		
		if(StrKit.notBlank(roleCampusIds))
			sql.append(" and campus.id in (" ).append( roleCampusIds ).append( ")" );
		
		return dao.find( sql.toString() );
	}
	
	/**
	 * 获取督导
	 * @return
	 */
	public List<SysUser> getDudao(){
		return dao.find("select * from  account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'dudao'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 获取教务
	 * @return
	 */
	public List<SysUser> getJiaowu(){
		return dao.find("select * from  account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'jiaowu'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 获取市场
	 * @return
	 */
	public List<SysUser> getScuserid(){
		return dao.find("select * from  account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'shichang'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 获取课程顾问
	 * @return
	 */
	public List<SysUser> getKcuserid(){
		return dao.find("select * from  account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 检查是否存在相应字段的数据
	 * @param field
	 * @param value
	 * @param mediatorId
	 * @return
	 */
	public Long queryCount(String field, String value, String id) {
		if (!ToolString.isNull(field) && !ToolString.isNull(value)) {
			StringBuffer sql = new StringBuffer("select count(1) from account  "
					+ " where 1=1  and ");
			sql.append(field).append("='").append(value).append("'");
			if (!ToolString.isNull(id)) {
				sql.append(" and id != ").append(id);
			}
			return Db.queryLong(sql.toString());
		} else {
			return null;
		}
	}
	/**
	 * 获取所有的用户 不包含老师和学生
	 * @return
	 */
	public List<SysUser> getAllSysUsers() {
		String sql = "select s.* from account s where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', s.roleids) ) = 0 "
					+ " and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) = 0 ";
		List<SysUser> list = dao.find(sql);
		return list;
	}

	/**
	 * 获取课程顾问
	 * @return
	 */
	public List<SysUser> getKechengguwen(String campusId) {
		return dao.find("select account.Id,account.REAL_NAME,account.SEX,campus.CAMPUS_NAME from  account left join campus on account.campusid = campus.id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 某校区课程顾问
	 * @param campusid
	 * @return
	 */
	public List<SysUser> getKechengguwenCampus(String campusid){
		return dao.find("select CONCAT('|',a.id,'|')  kcgwids , a.* from  account a left join account_campus ac on a.id=ac.account_id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', a.roleids) ) > 0 and ac.campus_id = ? ",campusid);
	}
	
	/**
	 * 获取教务
	 * @param campusId
	 * @return
	 */
	public List<SysUser> getJiaowu(String campusId) {
		return dao.find("select * from  account where "
				+ "LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'jiaowu'), CONCAT(',', roleids) ) > 0");
	}
	/**
	 * 获取财务
	 * @param campusId
	 * @return
	 */
	public List<SysUser> getCaiwu(String campusId) {
		return dao.find("select * from  account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'caiwu'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 获取某校区的所有督导
	 */
	public List<SysUser> getTutorsByCampusid(String campusid) {
		return dao.find("select a.* from account a left join account_campus ac on a.id=ac.account_id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'dudao'), CONCAT(',', a.roleids) ) > 0 and ac.campus_id = ? ", campusid);
	}
	/**
	 * 获取某校区的所有课程顾问*
	 */
	public List<SysUser> getCampusKcgws(String campusid){
		return dao.find("select distinct a.*,CONCAT('|',a.id,'|') KCGWIDS from account a "
				+ " left join account_campus ac on a.id=ac.account_id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', a.roleids) ) > 0 and ac.campus_id in( "+campusid+" )");
	}
	public List<SysUser> getAllKcgw(){
		return dao.find("select * from account  where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0");
	}
	
	/**
	 * 获取某校区的所有教务
	 */
	public List<SysUser> getJiaowuByCampusid(String campusid) {
		return dao.find("select a.* from account a left join account_campus ac on a.id=ac.account_id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'jiaowu'), CONCAT(',', a.roleids) ) > 0  and ac.campus_id = ? ", campusid);
	}
	
	/**
	 * 获取某校区的所有市场
	 */
	public List<SysUser> getShichangByCampusid(String campusid) {
		return dao.find("select a.* from account a left join account_campus ac on a.id=ac.account_id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'shichang'), CONCAT(',', a.roleids) ) > 0 and ac.campus_id = ? ", campusid);
	}
	/**
	 * 获取某校区的所有市场
	 */
	public List<SysUser> getShichangByCampusids(String campusids) {
		return dao.find("select distinct a.* from account a left join account_campus ac on a.id=ac.account_id where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'shichang'), CONCAT(',', a.roleids) ) > 0 and ac.campus_id in ("+ campusids+")");
	}
	/**
	 * 获取所有的发送报告权限的用户*
	 * @return
	 */
	public List<SysUser> findAllSysUser() {
		
		String sql = " select id ,REAL_NAME,roleids from account where state <> 2 ";
		return dao.find(sql);
	}

	/**
	 * 开通账号 未停用  已转正 非学生
	 */
	public List<SysUser> queryAllSysUserInState(){
		String sql = "select * from account where state = 0 and user_type = 0 ";
		List<SysUser> userList = dao.find(sql);
		return userList;
	}
	
	/**
	 * 开通账号 未停用  已转正 非学生,校区限制
	 */
	public List<SysUser> queryAllSysUserInState( String loginRoleCampsuIds ){
		String sql = "select distinct account.id , account.real_name  from account "
				+ " left join account_campus accountCampus on account.id = accountCampus.account_id "
				+ " where state = 0 and user_type = 0 and accountCampus.campus_id in (" + loginRoleCampsuIds + ")";
		List<SysUser> userList = dao.find(sql);
		return userList;
	}
	public String getNames() {
		return getStr("REAL_NAME");
	}
}
