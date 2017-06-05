
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

import java.util.Date;
import java.util.List;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;

/***学生*/
@SuppressWarnings("serial")
@Table(tableName = "account")
public class Student extends BaseModel<Student> {

	public static final Student dao = new Student();
	
	//-----------------------------------常量字典  start------------------------------------------
	/**状态   0为正常 */
	public static final int DICT_STATE_0 = 0;
	/**状态  1删除 */
	public static final int DICT_STATE_1 = 1;
	/**状态  2是小班 */
	public static final int DICT_STATE_2 = 2;
	/**状态  3添加销售机会时下的临时保存学生 */
	public static final int DICT_STATE_3 = 3;
	
	
	//-----------------------------------常量字典 ------------------------------------------
	
	//-----------------------------------常用条件函数  start------------------------------------------
	/**是小班 的虚拟账户 */
	public boolean isClassOrder(){
		return getInt("state").equals(DICT_STATE_2);
	}
	
	
	//-----------------------------------常用条件函数  end------------------------------------------
	
	
	/**
	 * 检查是否存在相应字段的数据
	 * @param field
	 * @param value
	 * @param mediatorId
	 * @return
	 */
	public Long queryCount(String field, String value, String id) {
		if (StrKit.notBlank(field, value)) {
			StringBuffer sql = new StringBuffer("SELECT count(1) FROM account  WHERE ");
			sql.append(field).append("='").append(value).append("'");
			if (StrKit.notBlank(id))
				sql.append(" AND id != ").append(id);
			sql.append(" AND USER_TYPE = 1 ");//老师和学生重名,但是客户在学生表中又找不到这个名字, 这就尴尬了...
			return Db.queryLong(sql.toString());
		} else return new Long("0");
	}
	
	public Student showStudentDetail(String id){
		if(StrKit.isBlank(id))
			return null;
		String sql = 
				"select s.*, du.real_name duName, cc.real_name ccName, sc.real_name scName,med.realname medName,op.contacter,hp.url "
				+ " from account s "
				+ " left join account du on s.SUPERVISOR_ID=du.ID "
				+ " left join headpicture hp on s.headpictureid = hp.id "
				+ " left join account cc on cc.id = s.kcuserid "
				+ "	left join account sc on sc.id = s.scuserid "
				+ "	left join crm_mediator med on med.id = s.mediatorid "
				+ " left join crm_opportunity op on op.id = s.opportunityid "
				+ " where s.id = ? ";
		return dao.findFirst(sql, id);
	}

	/**
	 * 根据ID获取学生姓名
	 * @param studentId
	 * @return
	 */
	public String getStudentNameById(String studentId) {
		if(StringUtils.isEmpty(studentId)){
			return null;
		}else{
			Student student = dao.findById(Integer.parseInt(studentId));
			return student.getStr("real_name");
		}
	}
	/**
	 * 根据ID获取学生电话
	 * @param studentId
	 * @return
	 */
	public String getStudentPhoneNumberById(String studentId) {
		if(StringUtils.isEmpty(studentId)){
			return null;
		}else{
			Student student = dao.findById(Integer.parseInt(studentId));
			return student.getStr("tel");
		}
	}

	public List<Student> findByMediatorId(Integer mediatorId) {
		return mediatorId==null?null:dao.find("select s.* from account s left join crm_opportunity c on s.opportunityid = c.id where  c.isconver=1 and c.mediatorid=?",mediatorId);
	}

	public Student getStudentByName(String stuName) {
		String sql = "select * from account where USER_TYPE=1 AND REAL_NAME = ?";
		Student student = Student.dao.findFirst(sql, stuName);
		return student;
	}

	public Long getMonthStudents(Integer sysId, Date start, Date end) {
		String sql = "select COUNT(*) as counts from account stu "
				+ " left join crm_opportunity opp on opp.id = stu.opportunityid "
				+ "  where 1=1 and stu.create_time >= ?";
		if(sysId!=null){
			SysUser sysuser = SysUser.dao.findById(sysId);
			if(!Role.isAdmins(sysuser.getStr("roleids"))){
				sql += " and opp.scuserid =  " + sysId ;
			}
		}
		return dao.find(sql, start).get(0).get("counts");
	}

	/**
	 * 跟进班课编号查询虚拟用户
	 * @param bkbh：班次编号
	 * @return
	 */
	public Student findByClassNum(String bkbh) {
		if(StringUtils.isEmpty(bkbh)){
			return null;
		}else{
			String sql = "select * from account where REAL_NAME = ? ";
			Student student = Student.dao.findFirst(sql, bkbh);
			return student;
		}
	}

	/**
	 * 显示已排课程统计
	 * @param studentid
	 * @return
	 */
	public List<Record> showCourseUsedCount(String studentid) {
		String sql = "SELECT COUNT(cp.COURSE_ID) COUNT,cp.COURSE_ID,c.COURSE_NAME coursename FROM courseplan cp "
				+ " LEFT JOIN course c on c.Id=cp.COURSE_ID "
				+ " WHERE 1=1 and cp.STUDENT_ID = ?  "
				+ " GROUP BY COURSE_ID ";
		List<Record> list = Db.find(sql, studentid);
		return list;
	}

	/**
	 * 跟进班次ID获取学生
	 * @param classorderid
	 * @return
	 */
	public List<Student> findStudentByClassorderId(Integer classorderid) {
		if(classorderid==null){
			return null;
		}else{
			String sql = "select s.id account_id,s.real_name,s.tel,s.create_time,o.classorderid banci_id "
					+ "from account s left join crm_courseorder o on s.id=o.studentid "
					+ "where o.classorderid=? and o.delflag=0 and s.state=0";
			return dao.find(sql, classorderid);
		}
	}
	/**
	 * 获取全部学生
	 * @return
	 */
	public List<Student> getAllStudents() {
		String sql = "select * from account where state <> 3 and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 ";
		return Student.dao.find(sql);
	}

	/**
	 * 跟进电话获取学生
	 * @param phone
	 * @return
	 */
	public Student findByPhone(String phone) {
		String sql = "select * from account where TEL = ? and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 ";
		Student student = Student.dao.findFirst(sql, phone);
		return student;
	}
	
	/**
	 * 跟进家长电话获取学生
	 * @param phone
	 * @return
	 */
	public Student findByParentsPhone(String phone) {
		String sql = "select * from account where parents_tel = ? and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 ";
		Student student = Student.dao.findFirst(sql, phone);
		return student;
	}

	public Long getWeekStudent(String date1, String date2) {
		Long student = Db.queryLong("select count(*) from account where CREATE_TIME >='"+date1+"' and CREATE_TIME <='"+date2+"'");
		return student;
	}

	public Long getAmountStudent() {
		
		Long amst = Db.queryLong("select count(*) from account ");
		return amst;
	}

	//查取类似名字学生
	public List<Student> getStudentsNameLike(String studentName) {
		String sql = "select real_name,id from account where user_type=1 and real_name like '%"+studentName+"%'";
		return dao.find(sql);
	}
	
	/**
	 * //学生人数
	 * @param beginDate
	 * @param integer
	 * @return
	 */
	public Long getMonthStudent(String beginDate, Integer integer) {
		Account user = Account.dao.findById(integer);
		StringBuffer sql = new  StringBuffer(" select count(1) from account a ");
		Long total = null;
		
		if(Role.isKcgw(user.getStr("roleids"))){//课程顾问
			sql.append(" left join student_kcgw ak ON a.Id = ak.student_id ");
		}
		sql.append(" WHERE state <> 3 and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', a.roleids) ) > 0 AND CREATE_TIME >= ?");
		if(Role.isKcgw(user.getStr("roleids"))){//课程顾问
			sql.append(" and ak.kcgw_id = ?");
			total = Db.queryLong(sql.toString(),beginDate,integer);
		}
		
		else{
			total = Db.queryLong(sql.toString(),beginDate);
		}
		
		return  total;
	}
	
	/**
	 * //根据校区学生人数
	 * @param beginDate
	 * @param integer
	 * @return
	 */
	public Long getMonthStudent(String beginDate, Integer integer, String loginRoleCampusIds ) {
		Account user = Account.dao.findById(integer);
		StringBuffer sql = new  StringBuffer(" select count(1) from account a ");
		Long total = null;
		
		if(Role.isKcgw(user.getStr("roleids"))){//课程顾问
			sql.append(" left join student_kcgw ak ON a.Id = ak.student_id ");
		}
		sql.append(" WHERE state <> 3 and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', a.roleids) ) > 0 AND CREATE_TIME >= ?");

		if(Role.isKcgw(user.getStr("roleids"))){//课程顾问
			if( !StringUtils.isEmpty(loginRoleCampusIds)){
				sql.append( " and a.campusid in(" + loginRoleCampusIds + ")" );
			}
			sql.append(" and ak.kcgw_id = ?");
			total = Db.queryLong(sql.toString(),beginDate,integer);
		}
		
		
		else{
			if( !StringUtils.isEmpty(loginRoleCampusIds)){
				sql.append( " and a.campusid in(" + loginRoleCampusIds + ")" );
			}
			total = Db.queryLong(sql.toString(),beginDate);
		}
		
		return  total;
	}
	
	public Long getYear(String date) {
		long total = Db.queryLong("SELECT COUNT(*) FROM account a1 WHERE "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', a1.roleids) ) > 0 AND CREATE_TIME >='"+date+"'");
		
		return total;
	}
	/**
	 * 根据销售机会查看该机会下报名的所有学生和交费情况
	 * @param opportunityId
	 * @return
	 */
	public List<Student> findStudentsByOppid(String opportunityId) {
		
		return dao.find(" select id,real_name,tel ,state ,email,birthday,sex from account  "
				+ "  where  STATE <> 2 AND opportunityid = ? ",opportunityId);
	}

	public Student findByOppid(String string) {
		return dao.findFirst("select * from account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 and state=3 and opportunityid = ? " ,string);
	}
	
	public Student getFistStudentByOppid(String string) {
		List<Student> list = Student.dao.find("select * from account where "
				+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0"
				+ "  and opportunityid = ? order by CREATE_TIME  ",string);
		if(list.size()==0){
			return null;
		}
		return list.get(0);
	}
	/**
	 * 获取当天生日的人数
	 * @return
	 */
	public Long getCountBirthdayToDay() {
		return Db.queryLong("select count(*) sum from account where state <> 3 and DATE_FORMAT(BIRTHDAY,'%m-%d') = DATE_FORMAT((select current_date),'%m-%d')");
	}

	public List<Student> getAllStudent() {
		String sql ="select id,real_name from account where user_type=1 and state!=2 ORDER BY state, CONVERT(REAL_NAME USING gbk)";
		return dao.find(sql);
	}
	/**
	 * 获取学生s
	 * @param studentids
	 * @return
	 */
	public List<Student> findByIds(String studentids) {
		String sql = "select id,real_name from account where id in("+studentids+")"; 
		return dao.find(sql);
	}
	/**
	 * 查询小班的学生信息* 
	 * @param campusId
	 * @param courseDate
	 * @param rankTime
	 * @param teacherId
	 * @return
	 */
	public List<Student> findByOrderCourseMessage(String  courseplanid) {
		String sql = "SELECT cp.Id,s.id studentid ,s.real_name, cp.TEACHER_ID, cp.class_id,co.is_assesment "
				+ " FROM courseplan cp  "
				+ " LEFT JOIN account_banci ab on cp.class_id = ab.banci_id "
				+ "	LEfT JOIN class_order co on cp.class_id = co.id "
				+ " LEFT JOIN account s ON ab.account_id = s.Id "
				+ " WHERE cp.id = ? AND cp.STATE <> 1 AND s.state = 0 AND ab.state = 0";
		return dao.find(sql,courseplanid);
	}
	/**
	 * 一对一获取学生的信息*
	 * @param campusId
	 * @param courseDate
	 * @param rankTime
	 * @param teacherId
	 * @return
	 */
	public List<Student> findByOneCourseMessage(String  courseplanid) {
		String sql  ="SELECT courseplan.Id,account.REAL_NAME,account.id studentid,courseplan.STUDENT_ID,"
						+ "	courseplan.TEACHER_ID,courseplan.class_id,o.is_assesment  " 
						+ " FROM courseplan "
						+ " LEFT JOIN account ON courseplan.STUDENT_ID = account.Id " 
						+ " LEFT JOIN class_order o on courseplan.class_id=o.id "
						+ " WHERE courseplan.id = ?  AND courseplan.STATE <> 1 and account.state = 0 ";
		return dao.find(sql,courseplanid);
	}
	/**
	 * 根据班次id查询学生信息
	 * @param int1
	 * @return
	 */
	public List<Student> findByClassOrderId(Integer classorderid) {
		String sql = "select s.* from  account s "
				+ " left join account_banci ab on ab.account_id = s.id"
				+ " left join class_order co on ab.banci_id = co.id "
				+ " where s.state= 0 and  co.id = ? "
				+ " group by s.id ";
		return dao.find(sql,classorderid);
	}
	/**
	 * 获取当前登录角色下的学生
	 * @param int1
	 * @return
	 */
	public List<Student> getStuByCampusIds( String campusids ){
		String sql = "select id,real_name from account where user_type=1 and state!=2 and campusid in ("+ campusids + ") ORDER BY state, CONVERT(REAL_NAME USING gbk)";
		return dao.find(sql);
	}

	/**
	 * 根据学生姓名 模糊查询
	 */
	public List<Student> queryByAccountByNameLike(String userName, String campusId) {
		String sql = "select * from account where state=0 "
				+ " and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 "
				+ " and (user_name like ? OR real_name like ?) "
				+ " and FIND_IN_SET(campusid, ?) order by Id desc";
		userName = "%" + userName + "%";
		return dao.find(sql, userName, userName, campusId);
	}
	
	
	/**
	 * 根据学生手机号查询学生
	 * @Title: queryByPhonenumber
	 * @Description: TODO 待添加
	 * @param @param phonenumber
	 * @param @return    设定文件
	 * @return Student    返回类型
	 * @throws
	 */
	public Student queryByStuPhonenumber(String phonenumber){
		return dao.findFirst("SELECT  s.* FROM jw_student s WHERE s.phonenumber = ?", phonenumber);
	}
	
	/**
	 * 根据老师手机号查询老师
	 * @Title: queryByPhonenumber
	 * @Description: TODO 待添加
	 * @param @param phonenumber
	 * @param @return    设定文件
	 * @return Student    返回类型
	 * @throws
	 */
	public Record queryByTeaPhonenumber(String phonenumber){
		return Db.findFirst("SELECT  s.* FROM pt_user s WHERE s.mobile = ?", phonenumber);
	}
	
	public String getNames() {
		return getStr("REAL_NAME");
	}
}
