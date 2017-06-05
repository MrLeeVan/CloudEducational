
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

package com.momathink.sys.account.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;

@Table(tableName = "account")
public class Account extends BaseModel<Account> {
	private static final long serialVersionUID = -3456750340176316673L;
	public static final Account dao = new Account();

	public Account findByName(String accountName) {
		Account account = this.findFirst("SELECT * FROM account WHERE account.REAL_NAME=?", accountName);
		return account;
	}

	public Account getAccountById(String id) {
		Account account = dao.findById(id);
		return account;
	}

	/**
	 * 查询所有已经有的班次供选择
	 * 
	 * @return
	 */
	public static List<Account> getUsedClassId(Integer subject_id) {
		String sql = "SELECT\n" + "class_order.classNum,\n" + "class_order.teachTime,\n" + "class_type.`name`\n" + "FROM\n" + "account_banci\n"
				+ "LEFT JOIN class_order ON account_banci.banci_id = class_order.id\n"
				+ "LEFT JOIN banci_course ON class_order.classtype_id = banci_course.type_id\n"
				+ "LEFT JOIN class_type ON class_order.classtype_id = class_type.id\n" + "WHERE\n" + "banci_course.subject_id = ?\n" + "GROUP BY\n"
				+ "account_banci.banci_id ";
		List<Account> list = dao.find(sql, subject_id);
		return list;
	}

	/**
	 * 获取所有的教师*
	 * @return
	 */
	public List<Account> getTeachers() {
		String sql = "select * from account where LOCATE((SELECT CONCAT(',', id, ',') ids FROM 	pt_role WHERE numbers = 'teachers'), CONCAT(',', roleids) ) > 0 and state=0 and class_type!= '' ";
		List<Account> list = dao.find(sql);
		return list;
	}


	public Long studentThMonth(String date) {
		Long student = Db.queryLong("select count(*) from account where CREATE_TIME >='"+date +"'");
		return student;
	}
	
	/**
	 * 查询某节班课中上课的学生
	 * @param coursetime 日期
	 * @param rankid 时段
	 * @param cpid 记录id
	 * @return List<Student> 
	 */
	public List<Account> findClassStudent(String cpid) {
		String querySql = "SELECT * FROM account stu WHERE FIND_IN_SET( Id, (SELECT GROUP_CONCAT(studentid) stus FROM teachergrade tgr WHERE tgr.COURSEPLAN_ID=?))";
		return Account.dao.find(querySql, cpid);
	}
}
