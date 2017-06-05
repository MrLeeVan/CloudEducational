
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

package com.momathink.teaching.teacher.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.alibaba.druid.util.StringUtils;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
@Table(tableName="teachergroup")
public class Teachergroup extends BaseModel<Teachergroup> {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final Teachergroup dao = new Teachergroup();
 
	/**
	 * 
	 * @param id
	 * @return 返回一个分组对象
	 */
		public Teachergroup getGroupObj(Object id){
			return Teachergroup.dao.findById(id);
		}
		/**
		 * 返回所有老师对象
		 */
		public List<Teacher> allteacher(){
			return Teacher.dao.find("select * from account where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0");
		}
		/**
		 * 返回全部教研分组,集合 
		 */
		public List<Teachergroup> allgroup(){
			return Teachergroup.dao.find("select * from teachergroup");
		}
		public List<Teachergroup> findByGroupNameAndLeaderName(String groupname, String leadername) {
			StringBuffer sql = new StringBuffer("SELECT g.*,t.REAL_NAME from teachergroup g left join account t on g.leaderid=t.Id where 1=1 ");
			if(!StringUtils.isEmpty(leadername)){
				sql.append(" and t.REAL_NAME LIKE '%").append(leadername).append("%'");
			}
			if(!StringUtils.isEmpty(groupname)){
				sql.append(" AND g.groupname LIKE '%").append(groupname).append("%'");
			}
			return dao.find(sql.toString());
		}
		
		/**
		 * 显示教研分组中老师们的名字
		 */
		public String getGroupMembersId(String teacherId) {
			String sql = "select * from teachergroup where leaderid = ?";
			List<Teachergroup>  teacherList = Teachergroup.dao.find(sql, teacherId);
			StringBuffer teacherids=new StringBuffer(teacherId+"|");
			if(teacherList.size()==0){
				return  teacherId;
			}else{
				Map<String,String>  map = new HashMap<String,String>();
				for(Teachergroup teacher:teacherList){
					String str = teacher.get("teacherids");
					teacherids.append(str).append("|");
				}
					String[] s = teacherids.toString().split("\\|");
					teacherids.delete(0, teacherids.length());
				for(int i = 0;i<s.length;i++){
					map.put(s[i], s[i]);
				}
				Set<String> keySet = map.keySet();
				for(String key : keySet) {
				String value = map.get(key);
				teacherids.append(value).append(",");
				}
				teacherids.deleteCharAt(teacherids.length()-1);
			}
			return teacherids.toString();
		} 
		
}
