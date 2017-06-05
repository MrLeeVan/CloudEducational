
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

package com.momathink.teaching.student.model;

import java.util.List;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.sys.system.model.SysUser;
@Table(tableName = "student_kcgw")
public class StudentKcgw extends BaseModel<StudentKcgw>{
	private static final long serialVersionUID = 24099496026157413L;
	public static final StudentKcgw dao = new StudentKcgw();
	
	/**根据课程顾问id查询 出他的学生id 已逗号 分割**/
	public String queryByGroupConcatStudentId(Integer kcgwid){
		String studentid = Db.queryStr("SELECT GROUP_CONCAT(student_id) from student_kcgw WHERE kcgw_id = ? GROUP BY kcgw_id", kcgwid); 
		return StrKit.notBlank(studentid)?studentid:null; 
	}
	
	public List<StudentKcgw> getAllKcgwidsByStudentid(int studentId) {
		return dao.find("select * from student_kcgw where student_id = ? ", studentId);
	}
	
	
	public StudentKcgw getKcgwNames(String para) {
		return dao.findFirst("SELECT GROUP_CONCAT(k.REAL_NAME) real_name,CONCAT(',',GROUP_CONCAT(ak.kcgw_id),',') kcgwids,"
							+" ak.student_id  id"
							+" FROM"
							+" student_kcgw ak"
							+" LEFT JOIN account a ON ak.student_id = a.Id"
							+" LEFT JOIN (select * from account where "
							+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0"
							+ " ) k ON k.Id = ak.kcgw_id"
							+" WHERE a.id = ? "+" GROUP BY a.Id ", para);
	}
	
	public List<SysUser> getKcgwByStudentId(Integer studentId) {
		String sql = "SELECT s.Id,s.REAL_NAME FROM student_kcgw sk LEFT JOIN account s ON sk.kcgw_id=s.Id WHERE sk.student_id=?";
		return SysUser.dao.find(sql, studentId);
	}
}
