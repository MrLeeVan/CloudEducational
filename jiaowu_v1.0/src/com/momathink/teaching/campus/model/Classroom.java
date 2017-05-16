
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

import java.util.Date;
import java.util.List;

import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolString;

/**
 * @ClassName: 教室表
 */
@Table(tableName="classroom")
public class Classroom extends BaseModel<Classroom> {
	private static final long serialVersionUID = 1L;
	public static final Classroom dao = new Classroom();
	/**
	 * 查询该校区所有的教室分页
	 */
	public List<Classroom> getClassroom(int Campus_ID,String classAddr,String page) {
		// 要查询第几页
		int pagecount = (Integer.parseInt(page)-1) * 20;
		//分页记录
		String sql = "SELECT class.* FROM classroom class where class.campus_id=?";
		if (!ToolString.isNull(classAddr)) {
			classAddr = classAddr.trim();
			sql += " and (class.Name like '%" + classAddr + "%')";
		}
		sql += " order by class.Id asc LIMIT " + pagecount + ",20;";
		List<Classroom> list = Classroom.dao.find(sql,Campus_ID);
		return list;
	}
	/**
	 * 查询该校区所有的教室总记录数
	 */
	public String getClassroomNum(int Campus_ID,String classAddr) {
		//一共有多少条记录
		String sqlcount = "SELECT count(1) as counts FROM classroom class where state=0 and class.campus_id=?";
		if (!ToolString.isNull(classAddr)) {
			classAddr = classAddr.trim();
			sqlcount += " and (class.Name like '%" + classAddr+ "%')";
		}
		String classNum = Classroom.dao.find(sqlcount,Campus_ID).get(0).get("counts").toString();
		return classNum;
	}
	/**
	 * 添加教室
	 */
	public void addClassroom(String classAddress,int Campus_ID,int maxpeople) {
		new Classroom().set("maxpeople", maxpeople).set("address", classAddress).set("name", classAddress).set("Campus_ID", Campus_ID).set("create_time", new Date()).save();
	}
	/**
	 * 更新教室
	 */
	public void updateClassroom(int id,String classAddress) {
		Classroom.dao.findById(id).set("address", classAddress).set("name", classAddress).update();
	}
	public  List<Classroom> getClassRoomByCamp(Integer campusId) {
		// TODO Auto-generated method stub
		String sql = "select * from classroom where campus_id = ?";
		List<Classroom> cr = Classroom.dao.find(sql, campusId);
		return cr;
	}

	/**
	 * @Title: 取出所有正常的教室
	 */
	public List<Classroom> getAllRooms() {
		return dao.find("select * from classroom where state=0");
	}
	
	public String getRoomNameById(String roomId){
		if(roomId.equals("0")){
			return "网课";
		}
		else{
			return dao.findById(Integer.parseInt(roomId)).getStr("name");
		}
	}
	
	/**
	 * 取出校区的所有正常的教室
	 * @param campusid
	 * @return
	 */
	public List<Classroom> getClassRoombyCampusid(Object campusid){
		String sql = " select * from classroom where campus_id = ? and state=0 ";
		return dao.find(sql, campusid);
	}
}
