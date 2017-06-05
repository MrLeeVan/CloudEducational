
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

package com.momathink.teaching.campus.model;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.ehcache.CacheKit;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.constants.DictKeys;

/**
 * 校区
 * */
@SuppressWarnings("serial")
@Table(tableName="campus")
public class Campus extends BaseModel<Campus> {
	
	//字典
	private static final String CAMPUS_GET_CAMPUS = "campus_getCampus";
	
	public static final Campus dao = new Campus();

	@Override
	public boolean save() {
		CacheKit.remove(DictKeys.cache_name_system, CAMPUS_GET_CAMPUS);
		return super.save();
	}

	@Override
	public boolean update() {
		CacheKit.remove(DictKeys.cache_name_system, CAMPUS_GET_CAMPUS);
		return super.update();
	}

	/**
	 * 查询所有的校区
	 */
	public List<Campus> getCampus() {
	     return Campus.dao.findByCache(DictKeys.cache_name_system, CAMPUS_GET_CAMPUS, 
				"SELECT CONCAT('|',c.id,'|') ids ,c.* from campus c  where state=0");
	}
	
	/**
	 * 查询所有的校区,带校区负责人信息
	 */
	public List<Campus> getCampusMassage(){
		String sql = "select campus.*,sysuser.REAL_NAME,sysuser.tel fzrtel,sysuser.email fzremail from campus left join account as sysuser on campus.presidentid=sysuser.id ";
		List<Campus> list = Campus.dao.find(sql);
		return list;
	}
	
	/** 根据IDS字符串组, 查询出校区
	 */
	public List<Campus> getCampusByIds(String campusids) {
		return Campus.dao.find( "select * from campus where id IN(".concat(campusids).concat(")") );
	}
	
	/**
	 * 查询当前登录用户所属 :所有的校区,带校区负责人信息
	 */
	public List<Campus> getLoginUserCampusMassage( String loginRoleCampusIds ){
		String sql = "select campus.*,sysuser.REAL_NAME,sysuser.tel fzrtel,sysuser.email fzremail "
				+ "from campus left join account as sysuser on campus.presidentid=sysuser.id ";
		if( !StringUtils.isEmpty( loginRoleCampusIds)){
			sql += " where campus.id in (" + loginRoleCampusIds + ")";
		}
			
		List<Campus> list = Campus.dao.find(sql);
		return list;
	}
	
	public Campus showCampusMassage(String campusId) {
		String sql = "select campus.*,sysuser.REAL_NAME FROM campus left join account as sysuser on campus.presidentid=sysuser.id where campus.id= ? ";
		Campus campus = Campus.dao.findFirst(sql, campusId);
		return campus;
	}
	
	public String getCampusNameById(String campusId){
		Campus campus = dao.findById(Integer.parseInt(campusId));
		return campus.getStr("campus_name");
	}
	
	public List<Campus> getCanUseCampusInfo(){
		String sql = "select campus.id,campus.campus_name,sysuser.REAL_NAME fzrname,sysuser.tel fzrtel,sysuser.email fzremail from campus left join account as sysuser on campus.kcuserid=sysuser.id where campus.state=0";
		List<Campus> list = Campus.dao.find(sql);
		return list;
	}
	public Campus getCampusInfo(String campusId){
		String sql = "select c.*,"
				+ "f.id fzrid,f.REAL_NAME fzrname,f.tel fzrtel,f.email fzremail, "
				+ "j.id jwfzrid,j.REAL_NAME jwfzrname,j.tel jwfzrtel,j.email jwfzremail, "
				+ "k.id kcfzrid,k.REAL_NAME kcfzrname,k.tel kcfzrtel,k.email kcfzremail, "
				+ "s.id scfzrid,s.REAL_NAME scfzrname,s.tel scfzrtel,s.email scfzremail "
				+ "from campus c "
				+ "left join account as f on c.presidentid=f.id "
				+ "left join account as j on c.jwuserid=j.id "
				+ "left join account as k on c.kcuserid=k.id "
				+ "left join account as s on c.scuserid=s.id "
				+ "where c.state=0 and c.id=?";
		Campus campus = Campus.dao.findFirst(sql,Integer.parseInt(campusId));
		return campus;
	}
	public Campus getCampusInfoStateNotZero(String campusId){
		String sql = "select c.*,"
				+ "f.id fzrid,f.REAL_NAME fzrname,f.tel fzrtel,f.email fzremail, "
				+ "j.id jwfzrid,j.REAL_NAME jwfzrname,j.tel jwfzrtel,j.email jwfzremail, "
				+ "k.id kcfzrid,k.REAL_NAME kcfzrname,k.tel kcfzrtel,k.email kcfzremail, "
				+ "s.id scfzrid,s.REAL_NAME scfzrname,s.tel scfzrtel,s.email scfzremail "
				+ "from campus c "
				+ "left join account as f on c.presidentid=f.id "
				+ "left join account as j on c.jwuserid=j.id "
				+ "left join account as k on c.kcuserid=k.id "
				+ "left join account as s on c.scuserid=s.id "
				+ "where c.id=?";
		Campus campus = Campus.dao.findFirst(sql,Integer.parseInt(campusId));
		return campus;
	}

	/**
	 * 查询用户是否是课程顾问负责人
	 * @param sysuserId
	 * @return
	 */
	public String IsCampusKcFzr(Integer sysuserId) {
		List<Campus> campusList = dao.find("select * from campus where kcuserid=?",sysuserId);
		if(campusList!=null && campusList.size()>0){
			StringBuffer campusids = new StringBuffer();
			for(Campus c : campusList){
				campusids.append(c.getPrimaryKeyValue()).append(",");
			}
			return campusids.substring(0, campusids.length()-1);
		}else{
			return null;
		}
	}
	/**
	 * 是否是市场负责人
	 * @param sysuserId
	 * @return
	 */
	public String IsCampusScFzr(Integer sysuserId) {
		List<Campus> campusList = dao.find("select * from campus where scuserid=?",sysuserId);
		if(campusList!=null && campusList.size()>0){
			StringBuffer campusids = new StringBuffer();
			for(Campus c : campusList){
				campusids.append(c.getPrimaryKeyValue()).append(",");
			}
			return campusids.substring(0, campusids.length()-1);
		}else{
			return null;
		}
	}
	/**
	 * 是否是教务负责人
	 * @param sysuserId
	 * @return
	 */
	public String IsCampusJwFzr(Integer sysuserId) {
		List<Campus> campusList = dao.find("select * from campus where jwuserid=?",sysuserId);
		if(campusList!=null && campusList.size()>0){
			StringBuffer campusids = new StringBuffer();
			for(Campus c : campusList){
				campusids.append(c.getPrimaryKeyValue()).append(",");
			}
			return campusids.substring(0, campusids.length()-1);
		}else{
			return null;
		}
	}
	/**
	 * 是否是校区负责人
	 * @param sysuserId
	 * @return
	 */
	public String IsCampusFzr(Integer sysuserId) {
		List<Campus> campusList = dao.find("select * from campus where presidentid=?",sysuserId);
		if(campusList!=null && campusList.size()>0){
			StringBuffer campusids = new StringBuffer();
			for(Campus c : campusList){
				campusids.append(c.getPrimaryKeyValue()).append(",");
			}
			return campusids.substring(0, campusids.length()-1);
		}else{
			return null;
		}
	}

	public List<Campus> getCampusByName(String campusname) {
		try{
			List<Campus> campus = dao.find("select * from campus where CAMPUS_NAME like '%"+campusname+"%'");
			return campus;
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return null;
	}

	public List<Campus> getCampusIds(String campuskcids) {
		List<Campus> list = dao.find("select * from campus where Id in ( ? )",campuskcids);
		return list;
	}

	/**
	 * 随机获取老师所属校区中的一个
	 * @param teacherId
	 * @return
	 */
	public Campus getRoundCampusId(String teacherId) {
		String sql="SELECT b.campus_id FROM ( SELECT * FROM account_campus WHERE account_campus.account_id= ? ) b "
				+ " WHERE b.campus_id >= (SELECT floor(RAND() * (SELECT MAX(campus_id) FROM account_campus WHERE account_id= ? ))) "
				+ " ORDER BY campus_id LIMIT 1 ";
		if(!StringUtils.isEmpty(teacherId)){
			Campus campus = dao.findFirst(sql, teacherId,teacherId);
			return campus;
		}else{
			return null;
		}
	}

	public List<Campus> getCampusIdsIn(String campusIdsByAccountId) {
		List<Campus> list = dao.find("select * from campus where Id in ("+campusIdsByAccountId+")");
		return list;
	}

	/**
	 * 获取当前登录用户所属校区 
	 * @author David
	 * @param loginUserId
	 * @return
	 */
	public List<Campus> getCampusByLoginUser(Integer loginUserId) {
		List<Campus> list = CacheKit.get(DictKeys.cache_name_system, "campus_getCampusByLoginUser_" + loginUserId);
		if(list == null || list.size() == 0){
			list = Campus.dao.find("select xq.* from campus xq left join account_campus ac on xq.id = ac.campus_id WHERE ac.account_id=? AND state =  0 ", loginUserId);
			CacheKit.put(DictKeys.cache_name_page, "campus_getCampusByLoginUser_" + loginUserId, list);
		}
		return list;
	}
	/**
	 * 根据学生ID查找校区ID
	 * @author David
	 * @param loginUserId
	 * @return
	 */
	public Integer getCampusIdByStudentId(String studentId) {
		String sql=" select campusid from account where id = ?";
		if(!StringUtils.isEmpty(studentId)){
			Integer campusId = Db.queryInt( sql, studentId );
			return campusId;
		}else{
			return null;
		}
	}
	
	/**
	 * 返回覆盖范围
	 * return Double
	 */
	 public Double getCover() {
		 return getDouble("cover");
	 }
	 
	 /**
	  * 返回经度
	  * return Double
	  */
	 public Double getLat() {
		 return getDouble("lat");
	 }
	 
	 /**
	  * 返回纬度
	  * return Double
	  */
	 public Double getLng() {
		 return getDouble("lng");
	 }
}
