
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

package com.momathink.teaching.student.service;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ExcelExportUtil;
import com.momathink.common.tools.ExcelExportUtil.Pair;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolImport;
import com.momathink.common.tools.ToolMD5;
import com.momathink.common.tools.ToolString;
import com.momathink.finance.model.CourseOrder;
import com.momathink.finance.model.Payment;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.student.model.StudentKcgw;
import com.momathink.teaching.subject.model.Subject;


public class StudentService extends BaseService {
	private static Logger log = Logger.getLogger(StudentService.class);
	
	/**单例模式, 恶汉式**/
	public static final StudentService me = new StudentService();

	/**
	 * 分页
	 * 
	 * @param splitPage
	 */
	@SuppressWarnings("unchecked")
	public void list(SplitPage splitPage) {
		log.debug("学生管理：分页处理");
		String select = "select s.*,c.campus_name campusname,sc.real_name scusername,jw.real_name jwusername,du.real_name dudaoname ";
		splitPageBase(splitPage, select);
		Page<Record> page = (Page<Record>) splitPage.getPage();
		List<Record> list = page.getList();
		for (Record r : list) {
			r.set("zksvip", CourseOrder.dao.getCanUseVIPzks(r.getInt("Id")));
			r.set("ypksvip", CoursePlan.coursePlan.getYpksForVIP(r.getInt("Id")));
			r.set("ysksvip", CoursePlan.coursePlan.getYsksForVIP(r.getInt("Id")));
			r.set("classList", ClassOrder.dao.getClassOrderByStudentId(r.getInt("Id")));
			r.set("kcgwList", StudentKcgw.dao.getKcgwByStudentId(r.getInt("Id")));
			r.set("zksban", CourseOrder.dao.getPaidBanzks(r.getInt("Id")));
			r.set("ypksban", CoursePlan.coursePlan.getBanJiYpks(r.getInt("Id")));
			r.set("ysksban", CoursePlan.coursePlan.getBanJiYsks(r.getInt("Id")));
		}
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from account s "
				+ "left join campus c on s.campusid=c.id "
				+ "left join account sc on s.scuserid=sc.id "
				+ "left join account jw on s.jwuserid=jw.id "
				+ "left join account du on s.SUPERVISOR_ID=du.id "
				+ "where s.USER_TYPE=1 and s.STATE=0 ");
		if (null == queryParam) {
			return;
		}
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "state":
				formSqlSb.append(" and s.state = ?");
				paramValue.add(value);
				break;
			case "studentname":// 学生姓名
				formSqlSb.append(" and s.real_name like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "campusid":// 校区id
				formSqlSb.append(" AND s.campusid IN(" + value + ") ");
				break;
			case "scuserid":// 市场id
				formSqlSb.append(" and s.scuserid = ? ");
				paramValue.add(value);
				break;
			case "email":// 邮箱
				formSqlSb.append(" and s.email like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "mobile":// 手机
				formSqlSb.append(" and s.mobile like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "telephone":// 电话
				formSqlSb.append(" and s.telephone like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "qq":// QQ
				formSqlSb.append(" and s.qq like ? ");
				paramValue.add("%" + value + "%");
				break;
			case "begindate"://查询开始日期
				formSqlSb.append(" and s.create_time>=? ");
				paramValue.add(value + " 00:00:00");
				break;
			case "enddate":// 结束日期
				formSqlSb.append(" and s.create_time<=? ");
				paramValue.add(value + " 23:59:59");
				break;
			case "kcuserid":// 课程顾问id
				formSqlSb.append(" and find_in_set(s.id,(SELECT GROUP_CONCAT(sk.student_id) FROM student_kcgw sk WHERE sk.kcgw_id = ?))");
				paramValue.add(Integer.parseInt(value));
				break;
			case "classorderid":// 小班id
				formSqlSb.append(" and find_in_set(s.id,(SELECT GROUP_CONCAT(cc.studentid) FROM crm_courseorder cc WHERE cc.classorderid = ?))");
				paramValue.add(Integer.parseInt(value));
				break;
			default:
				break;
			}
		}
		formSqlSb.append(" ORDER BY s.id DESC");
	}
	
	/**
	 * 保存学生*
	 * @param account
	 * @return
	 */
	public Integer save(Student account) {
		Integer id ;
		try {
			account.set("state", "0");
			account.set("create_time", new Date());
			account.set("roleids", "4,");
			account.set("user_type", 1);
			account.save();
			id=account.getPrimaryKeyValue();
		} catch (Exception e) {
			throw new RuntimeException("保存用户异常");
		}
		return id;
	}

	public void update(Student account) {
		try {
			account.set("update_time", new Date());
			account.set("roleids", "4,");
			account.set("user_type", 1);
			account.update();
		} catch (Exception e) {
			throw new RuntimeException("更新用户异常");
		}
	}

	/**
	 * 获取学生的剩余总课时
	 * @param studentId
	 * @return
	 */
	public float getSurplusClasshour(String studentId) {
		float zks = Payment.dao.getPaidClasshourByStudentId(studentId);
		float ypks = CoursePlan.coursePlan.getUseClasshour(studentId,null);//全部已用课时
		return zks-ypks;
	}

	/*public List<Student> queryStudentByMediator(Mediator mediator) {
		List<Student> list = Student.dao.findByMediatorId(mediator.getPrimaryKeyValue());
		for (Student student : list) {
			List<Payment> paymentList = Payment.dao.findbyStudentId(student.getPrimaryKeyValue(),"1");
			Date date = new Date();
			Map<String, Date> beforeWeek = ToolDateTime.getBeforeWeekDate(date);
			Map<String, Date> week = ToolDateTime.getWeekDate(date);
			String start = ToolDateTime.format(week.get("start"), ToolDateTime.pattern_ymd);
//			String end = ToolDateTime.format(week.get("end"), ToolDateTime.pattern_ymd);
			String bstart = ToolDateTime.format(beforeWeek.get("start"), ToolDateTime.pattern_ymd);
			String bend = ToolDateTime.format(beforeWeek.get("end"), ToolDateTime.pattern_ymd);
			Map<String, Float> szPlan = coursePlanService.queryCourseplanInfo(student.getPrimaryKeyValue(), bstart, bend);//上周排课
			Map<String, Float> bzPlan = coursePlanService.queryCourseplanInfo(student.getPrimaryKeyValue(), start, ToolDateTime.format(date, ToolDateTime.pattern_ymd));//本周排课
			Map<String, Float> ljPlan = coursePlanService.queryCourseplanInfo(student.getPrimaryKeyValue(), null,ToolDateTime.format(date, ToolDateTime.pattern_ymd));//累计排课
			if (paymentList != null && paymentList.size() > 0) {
				student.put("paymentList", paymentList);
				student.put("recordNumber", paymentList.size());
				double moneyTotal = 0;
				double jieshuTotal = 0;
				for (Payment payment : paymentList) {
					moneyTotal = ToolArith.add(moneyTotal, payment.getBigDecimal("amount").doubleValue());
					jieshuTotal = ToolArith.add(jieshuTotal,payment.getDouble("classhour"));
				}
				student.put("moneyTotal", moneyTotal);
				student.put("jieshuTotal", jieshuTotal);
				student.put("szxh", (double) (szPlan.get("vip") + szPlan.get("xb")));
				student.put("szyj", (szPlan.get("vip") + szPlan.get("xb")) );
				student.put("bzxh", (double) (bzPlan.get("vip") + bzPlan.get("xb")));
				student.put("ljks", (ljPlan.get("vip") + ljPlan.get("xb")));
				student.put("ljxh", (double) (ljPlan.get("vip") + ljPlan.get("xb")));
				student.put("ljyj", (ljPlan.get("vip") + ljPlan.get("xb")));
			} else {
				student.put("recordNumber", 0);
				student.put("moneyTotal", 0);
				student.put("jieshuTotal", 0);
				student.put("szxh", 0.00);
				student.put("szyj", 0.0f);
				student.put("bzxh", 0.00);
				student.put("ljks", 0.0f);
				student.put("ljxh", 0.00);
				student.put("ljyj", 0.00);
			}
			student.put("szks", szPlan.get("vip") + szPlan.get("xb"));
			student.put("bzks", bzPlan.get("vip") + bzPlan.get("xb"));
		}
		return list;
	
	}*/

	public List<Course> getStuCourseName(String classType) {
		try{
			String[] couid = classType.replace("|", ",").split(",");
			List<Course> list = new ArrayList<Course>();
			for(int i=0;i<couid.length;i++){
				Course course = Course.dao.findById(couid[i]);
				if(course!=null){
					list.add(course);
				}
			}
			return list;
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return null;
	}

	public void queryMyStudents(SplitPage splitPage,Integer sysuserId) {
		 List<Object> paramValue = new ArrayList<Object>();
		if(sysuserId!=null){
			SysUser sysuser = SysUser.dao.findById(sysuserId);
			StringBuffer select = new StringBuffer("select s.Id,campus.campus_name campusname,s.REAL_NAME,s.opportunityid,s.STATE,s.create_time,s.TEL,"
					+ " d.real_name dudaoname, jw.real_name jwusername, "
					+ " sc.real_name scusername,cc.real_name kcusername,m.realname mediatorname, IFNULL(b.zksvip,0) zksvip,xiaoban.classNum,"
					+ "IFNULL(b.kyksvip,0) kyksvip,IFNULL(c.zksxb,0) zksxb,IFNULL(c.kyksxb,0) kyksxb   " );
			StringBuffer formSql = 
					new StringBuffer("from account s  "
					+ " left join campus on s.campusid = campus.id "
					+ " left join account jw on s.jwuserid=jw.id "
					+ " left join "
					+ " (select cpt.studentid,cod.id,GROUP_CONCAT(cod.classNum) classNum from crm_courseorder cpt "
					+ " left join class_order cod on cpt.classorderid = cod.id where cpt.teachtype =2 and cpt.status <> 0 ) xiaoban  "
					+ " on s.id = xiaoban.studentid \n" 
					+ " left join account d on s.SUPERVISOR_ID=d.id  left join account sc on s.scuserid=sc.id "
					+ " left join (SELECT GROUP_CONCAT(k.REAL_NAME) real_name,GROUP_CONCAT(ak.kcgw_id) kcgwids, ak.student_id  id "
					+ " FROM "
					+ " student_kcgw ak "
					+ " LEFT JOIN account a ON ak.student_id = a.Id "
					+ " LEFT JOIN (select * from account where "
					+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0) k ON k.Id = ak.kcgw_id "
					+ " GROUP BY a.Id) cc on s.id=cc.id  left join crm_mediator m on s.mediatorid=m.id  \n" 
					+ "left join \n" 
					+ "(SELECT a.studentid,SUM(a.classhour) zksvip,SUM(a.totalsum) zjevip,SUM(a.realsum) zjfvip,FLOOR(SUM(a.ks)) kyksvip\n" 
					+ "FROM (SELECT co.classhour,co.totalsum,co.realsum,co.studentid,IF(co.avgprice=0,co.classhour,cp.totalfee/co.avgprice) ks \n" 
					+ "FROM crm_courseorder co \n" 
					+ "LEFT JOIN (SELECT p.orderid,SUM(amount) totalfee FROM crm_payment p GROUP BY p.orderid) cp ON co.id=cp.orderid "
					+ " WHERE co.status<>0 and co.delflag=0 AND co.teachtype=1) a GROUP BY a.studentid) b \n" 
					+ "on s.id=b.studentid \n" 
					+ "left join \n" 
					+ "(SELECT a.studentid,SUM(a.classhour) zksxb,SUM(a.totalsum) zjexb,SUM(a.realsum) zjfxb,FLOOR(SUM(a.ks)) kyksxb \n" 
					+ "FROM (SELECT co.classhour,co.totalsum,co.realsum,co.studentid,IF(co.avgprice=0,co.classhour,cp.totalfee/co.avgprice) ks \n" 
					+ "FROM crm_courseorder co \n" 
					+ "LEFT JOIN (SELECT p.orderid,SUM(amount) totalfee FROM crm_payment p GROUP BY p.orderid) cp ON co.id=cp.orderid "
					+ " WHERE co.status<>0 and co.delflag=0 AND co.teachtype=2) a GROUP BY a.studentid) c \n" 
					+ "on s.id=c.studentid ");
			 	if(Role.isAdmins(sysuser.getStr("roleids"))){//管理员
					formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0 ");
				}else{
					String campusids = AccountCampus.dao.getCampusIdsByAccountId(sysuserId);
					if(Role.isTeacher(sysuser.getStr("roleids"))){//老师
						formSql.append("\n LEFT JOIN ("
								+ "SELECT\n" +
								"	* from(\n" +
								"		(\n" +
								"			SELECT\n" +
								"				lspk.TEACHER_ID,\n" +
								"				lspk.STUDENT_ID\n" +
								"			FROM\n" +
								"				courseplan lspk\n" +
								"			WHERE\n" +
								"				lspk.class_id = 0\n" +
								"		)\n" +
								"		UNION ALL\n" +
								"			(\n" +
								"				SELECT\n" +
								"					lspk.TEACHER_ID,\n" +
								"					ab.account_ID student_id\n" +
								"				FROM\n" +
								"					courseplan lspk\n" +
								"				LEFT JOIN class_type ct ON lspk.class_id = ct.id\n" +
								"				LEFT JOIN account_banci ab ON ct.id = ab.banci_id\n" +
								"				WHERE\n" +
								"					lspk.class_id <> 0\n" +
								"		GROUP BY ab.account_id	)\n" +
								"	) s\n" +
								"GROUP BY\n" +
								"	s.TEACHER_ID,\n" +
								"	s.student_ID"
								+ ") t "
								+ " ON s.Id=t.STUDENT_ID where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  and s.state = 0 AND t.TEACHER_ID=?");
						paramValue.add(sysuserId);
					}else if(Role.isDudao(sysuser.getStr("roleids"))||Role.isKcgw(sysuser.getStr("roleids"))||Role.isJiaowu(sysuser.getStr("roleids"))){//教务
						if(campusids != null){
							formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(campusids);
							if(sysuser.getInt("campusid")!=null){
								formSql.append(",").append(sysuser.getInt("campusid"));
							}
							formSql.append(") ");
						}else{
							if(sysuser.getInt("campusid")!=null){
								formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(sysuser.getInt("campusid")).append(") ");
							}
						}
					}else if(Role.isShichang(sysuser.getStr("roleids"))){//市场
						if(campusids != null){
							formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(campusids).append(") ");
						}else{
							formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.scuserid=?");
							paramValue.add(sysuserId);
						}
					}else{
						if(campusids != null){
							formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(campusids).append(") ");
						}
					}
				}
			
			Map<String,String> queryParam = splitPage.getQueryParam();
			Set<String> paramKeySet = queryParam.keySet();
			String state = queryParam.get("state");
			if(StringUtils.isEmpty(state))
				queryParam.put("state", "0");
			for (String paramKey : paramKeySet) {
				String value = queryParam.get(paramKey);
				switch (paramKey) {
				case "state":
					formSql.append(" and s.state = ?");
					paramValue.add(Integer.parseInt(value));
					break;
				case "studentname":
					formSql.append(" and s.real_name like ? ");
					paramValue.add("%" + value + "%");
					break;
				case "begindate":
					formSql.append(" and s.create_time >= ?");
					paramValue.add(value);
					break;
				case "enddate":
					formSql.append(" and s.create_time <= ?");
					paramValue.add(value);
					break;
				case "scuserid":
					formSql.append(" and s.scuserid = ? ");
					paramValue.add(Integer.parseInt(value));
					break;
				case "oppid":
					formSql.append(" and s.opportunityid = ? ");
					paramValue.add(Integer.parseInt(value));
					break;	
				case "kcuserid":
					formSql.append(" and CONCAT(',',cc.kcgwids,',') like ? ");
					paramValue.add("%,"+value+",%");
					break;
				case "supervisor_id":
					formSql.append(" and s.supervisor_id = ? ");
					paramValue.add(Integer.parseInt(value));
					break;
				case "classorderid":
					formSql.append(" and xiaoban.id = ? ");
					paramValue.add(Integer.parseInt(value));
					break;
				default:
					break;
				}
			}
			formSql.append(" ORDER BY s.id DESC");
			Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
			List<Record> list = page.getList();
			for (Record r : list) {
				r.set("ypksvip", CoursePlan.coursePlan.findFirst("SELECT IFNULL(SUM(t.class_hour),0) ypksvip FROM courseplan cp LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id  "
						+ " WHERE cp.STATE=0 AND cp.PLAN_TYPE=0 AND cp.class_id=0 AND cp.STUDENT_ID= " + r.getInt("Id")).get("ypksvip"));
				r.set("ypksxb", CoursePlan.coursePlan.findFirst("SELECT IFNULL(SUM(t.class_hour),0) ypksxb FROM courseplan cp LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id "
					+ " WHERE cp.STATE=0 AND cp.PLAN_TYPE=0 AND cp.class_id!=0 AND cp.STUDENT_ID= " + r.getInt("Id")).get("ypksxb"));
				String kyksvip = r.getDouble("kyksvip")==null?"0":r.getDouble("kyksvip").toString();
				String ypksvip = r.getBigDecimal("ypksvip")==null?"0":r.getBigDecimal("ypksvip").toString();
				String kyksxb = r.getDouble("kyksxb")==null?"0":r.getDouble("kyksxb").toString();
				String ypksxb = r.getBigDecimal("ypksxb")==null?"0":r.getBigDecimal("ypksxb").toString();
				r.set("kcgwList", StudentKcgw.dao.getKcgwByStudentId(r.getInt("Id")));
				r.set("kyksvip", ToolString.subZeroAndDot(kyksvip));
				r.set("ypksvip", ToolString.subZeroAndDot(ypksvip));
				r.set("kyksxb", ToolString.subZeroAndDot(kyksxb));
				r.set("ypksxb", ToolString.subZeroAndDot(ypksxb));
				r.set("classList", ClassOrder.dao.getClassOrderByStudentId(r.getInt("Id")));
			}
			splitPage.setPage(page);
		}
	}
	
	public List<Record> queryMyStudentsToexcel(SplitPage splitPage,Integer sysuserId, String loginRoleCampusIds ) {
		 List<Object> paramValue = new ArrayList<Object>();
		if(sysuserId!=null){
			SysUser sysuser = SysUser.dao.findById(sysuserId);
			StringBuffer select = new StringBuffer("select op.contacter,s.PARENTS_EMAIL,s.PARENTS_TEL,s.QQ,s.REAL_NAME,s.opportunityid,s.STATE,DATE_FORMAT(s.create_time,'%Y-%m-%d') AS create_time,s.TEL, d.real_name dudao,"
					+ " sc.real_name scusername,cc.real_name kcusername,m.realname mediatorname, IFNULL(b.zksvip,0) zksvip,"
					+ "IFNULL(b.kyksvip,0) kyksvip,IFNULL(c.zksxb,0) zksxb,IFNULL(c.kyksxb,0) kyksxb  \n" );
			StringBuffer formSql = 
					new StringBuffer("from account s  \n" 
					+ "left join account d on s.SUPERVISOR_ID=d.id  left join account sc on s.scuserid=sc.id "
					+ "left join crm_opportunity op on s.opportunityid=op.id"
					+ " left join (SELECT GROUP_CONCAT(k.REAL_NAME) real_name,GROUP_CONCAT(ak.kcgw_id) kcgwids, ak.student_id  id "
					+ " FROM "
					+ " student_kcgw ak "
					+ " LEFT JOIN account a ON ak.student_id = a.Id "
					+ " LEFT JOIN (select * from account where "
					+ " LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'kcgw'), CONCAT(',', roleids) ) > 0) k ON k.Id = ak.kcgw_id "
					+ " GROUP BY a.Id) cc on s.id=cc.id  left join crm_mediator m on s.mediatorid=m.id  \n" 
					+ "left join \n" 
					+ "(SELECT a.studentid,SUM(a.classhour) zksvip,SUM(a.totalsum) zjevip,SUM(a.realsum) zjfvip,FLOOR(SUM(a.ks)) kyksvip\n" 
					+ "FROM (SELECT co.classhour,co.totalsum,co.realsum,co.studentid,IF(co.avgprice=0,co.classhour,cp.totalfee/co.avgprice) ks \n" 
					+ "FROM crm_courseorder co \n" 
					+ "LEFT JOIN (SELECT p.orderid,SUM(amount) totalfee FROM crm_payment p GROUP BY p.orderid) cp ON co.id=cp.orderid "
					+ " WHERE co.delflag=0 AND co.teachtype=1) a GROUP BY a.studentid) b \n" 
					+ "on s.id=b.studentid \n" 
					+ "left join \n" 
					+ "(SELECT a.studentid,SUM(a.classhour) zksxb,SUM(a.totalsum) zjexb,SUM(a.realsum) zjfxb,FLOOR(SUM(a.ks)) kyksxb \n" 
					+ "FROM (SELECT co.classhour,co.totalsum,co.realsum,co.studentid,IF(co.avgprice=0,co.classhour,cp.totalfee/co.avgprice) ks \n" 
					+ "FROM crm_courseorder co \n" 
					+ "LEFT JOIN (SELECT p.orderid,SUM(amount) totalfee FROM crm_payment p GROUP BY p.orderid) cp ON co.id=cp.orderid "
					+ " WHERE  co.delflag=0 AND co.teachtype=2) a GROUP BY a.studentid) c \n" 
					+ "on s.id=c.studentid ");
			 	if(Role.isAdmins(sysuser.getStr("roleids"))){//管理员
					formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0 ");
					if( !StringUtils.isEmpty( loginRoleCampusIds )){
			 			formSql.append( " and s.campusid in (" + loginRoleCampusIds + ")" );
			 		}
				}else{
					String fzxqids = Campus.dao.IsCampusFzr(sysuserId);
					//判断是否角色唯一,如果不唯一,则加上校区限制.防止多角色出现导出失败.
					String[] roleArry =  sysuser.getStr("roleids").split(",");
					boolean isSingelRole =  roleArry.length == 1 ? true : false;
					if(fzxqids != null){
						formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(fzxqids).append(") ");
					}else{
						if(Role.isTeacher(sysuser.getStr("roleids")) && isSingelRole ){//老师
							formSql.append("\n LEFT JOIN (SELECT lspk.TEACHER_ID,lspk.STUDENT_ID FROM courseplan lspk "
									+ " GROUP BY lspk.TEACHER_ID,lspk.STUDENT_ID) t "
									+ " ON s.Id=t.STUDENT_ID where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  and s.state = 0 AND t.TEACHER_ID=?");
							paramValue.add(sysuserId);
						} else if(Role.isDudao(sysuser.getStr("roleids")) && isSingelRole ){//督导
							formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(" + loginRoleCampusIds + ")");
						}else if(Role.isJiaowu(sysuser.getStr("roleids")) && isSingelRole ){//教务
							String campusids = AccountCampus.dao.getCampusIdsByAccountId(sysuserId);
							if(campusids != null){
								formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(campusids);
								if(sysuser.getInt("campusid")!=null){
									formSql.append(",").append(sysuser.getInt("campusid"));
								}
								formSql.append(") ");
							}else{
								if(sysuser.getInt("campusid")!=null){
									formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(sysuser.getInt("campusid")).append(") ");
								}
							}
						}else if(Role.isKcgw(sysuser.getStr("roleids"))  ){//课程顾问
							String campusids = AccountCampus.dao.getCampusIdsByAccountId(sysuserId);
							if(campusids != null){
								//formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.kcuserid=? AND s.campusid in(").append(campusids).append(") ");
								formSql.append(" \n where find_in_set(s.id,(SELECT GROUP_CONCAT(sk.student_id) FROM student_kcgw sk WHERE sk.kcgw_id = ? )) and s.USER_TYPE=1 and s.STATE=0 ");
								paramValue.add(sysuserId);
							}else{
								formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.kcuserid=?" );
								paramValue.add(sysuserId);
							}
						}else if(Role.isShichang(sysuser.getStr("roleids")) && isSingelRole ){//市场
							String campusids = Campus.dao.IsCampusScFzr(sysuserId);
							if(campusids != null){
								formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in(").append(campusids).append(") ");
							}else{
								formSql.append("\n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.scuserid=?");
								paramValue.add(sysuserId);
							}
						}else {
							if( !StringUtils.isEmpty( loginRoleCampusIds)){
								formSql.append( " \n where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', s.roleids) ) > 0  AND s.campusid in("+ loginRoleCampusIds+ ")" );
							}
						}
					}
				}
			
			Map<String,String> queryParam = splitPage.getQueryParam();
			Set<String> paramKeySet = queryParam.keySet();
			String state = queryParam.get("state");
			if(StringUtils.isEmpty(state))
				queryParam.put("state", "0");
			for (String paramKey : paramKeySet) {
				String value = queryParam.get(paramKey);
				switch (paramKey) {
				case "state":
					formSql.append(" and s.state = ?");
					paramValue.add(Integer.parseInt(value));
					break;
				case "studentname":
					formSql.append(" and s.real_name like ? ");
					paramValue.add("%" + value + "%");
					break;
				case "begindate":
					formSql.append(" and s.create_time >= ?");
					paramValue.add(value);
					break;
				case "enddate":
					formSql.append(" and s.create_time <= ?");
					paramValue.add(value);
					break;
				case "scuserid":
					formSql.append(" and s.id in (select DISTINCT sk.student_id from student_kcgw sk where sk.kcgw_id=?) ");
					paramValue.add(Integer.parseInt(value));
					break;
				case "oppid":
					formSql.append(" and s.opportunityid = ? ");
					paramValue.add(Integer.parseInt(value));
					break;	
				case "kcuserid":
					formSql.append(" and CONCAT(',',cc.kcgwids,',') like ? ");
					paramValue.add("%,"+value+",%");
					break;
				case "supervisor_id":
					formSql.append(" and s.supervisor_id = ? ");
					paramValue.add(Integer.parseInt(value));
					break;
			
				default:
					break;
				}
			}
			formSql.append(" ORDER BY s.id DESC");
			List<Record> list =  Db.find(select.toString()+formSql.toString(),paramValue.toArray());
//			Page<Record> page = Db.paginate(splitPage.getPageNumber(), 1000000, select.toString(), formSql.toString(), paramValue.toArray());
//			List<Record> list = page.getList();
			for (Record r : list) {
				r.set("ypksvip", CoursePlan.coursePlan.findFirst("SELECT IFNULL(SUM(t.class_hour),0) ypksvip FROM courseplan cp LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id  "
						+ " WHERE cp.STATE=0 AND cp.PLAN_TYPE=0 AND cp.class_id=0 AND cp.STUDENT_ID= " + r.getInt("Id")).get("ypksvip"));
				r.set("ypksxb", CoursePlan.coursePlan.findFirst("SELECT IFNULL(SUM(t.class_hour),0) ypksxb FROM courseplan cp LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id "
					+ " WHERE cp.STATE=0 AND cp.PLAN_TYPE=0 AND cp.class_id!=0 AND cp.STUDENT_ID= " + r.getInt("Id")).get("ypksxb"));
				String kyksvip = r.getDouble("kyksvip")==null?"0":r.getDouble("kyksvip").toString();
				String ypksvip = r.getBigDecimal("ypksvip")==null?"0":r.getBigDecimal("ypksvip").toString();
				String kyksxb = r.getDouble("kyksxb")==null?"0":r.getDouble("kyksxb").toString();
				String ypksxb = r.getBigDecimal("ypksxb")==null?"0":r.getBigDecimal("ypksxb").toString();
				r.set("kyksvip", ToolString.subZeroAndDot(kyksvip));
				r.set("ypksvip", ToolString.subZeroAndDot(ypksvip));
				r.set("kyksxb", ToolString.subZeroAndDot(kyksxb));
				r.set("ypksxb", ToolString.subZeroAndDot(ypksxb));
			}
			return list;
		}
		return null;
	}
	
	/**
	 * 导出数据
	 * @param response
	 * @param request
	 * @param member
	 */
	public void export(HttpServletResponse response, HttpServletRequest request, List<Record> members,String filename) {
		
		List<Pair> titles = new ArrayList<Pair>();
		titles.add(new Pair("REAL_NAME","姓名"));
		titles.add(new Pair("contacter","联系人"));
		titles.add(new Pair("STATE","状态"));
		titles.add(new Pair("create_time","创建时间"));
		titles.add(new Pair("QQ","QQ"));
		titles.add(new Pair("TEL","电话"));
		titles.add(new Pair("PARENTS_TEL","家长电话"));
		titles.add(new Pair("PARENTS_EMAIL","家长邮箱"));
		titles.add(new Pair("dudao","督导"));
		titles.add(new Pair("scusername","市场专员"));
		titles.add(new Pair("kcusername","课程顾问"));
		titles.add(new Pair("mediatorname","顾问"));
		titles.add(new Pair("zksvip","一对一预购课时"));
		titles.add(new Pair("kyksvip","一对一已购课时"));
		titles.add(new Pair("ypksvip","一对一已排课时"));
		titles.add(new Pair("zksxb","小班预购课时"));
		titles.add(new Pair("kyksxb","小班已购课时"));
		titles.add(new Pair("ypksxb","小班已排课时"));

		
		// 特殊处理
//		for (Member member : Member) {
//			
//		}
//		
		ExcelExportUtil.exportByRecord(response, request, filename, titles , members);
	}

	
	/**
	 * 某学生的所用订单
	 * @param studentid
	 * @return
	 */
	public List<CourseOrder> getStudentOrderlists(Integer userId) {
		String sql = "SELECT o.delflag,o.id,o.subjectids,o.createtime,o.`status`,o.teachtype,o.totalsum,o.realsum,o.rebate,o.classhour, "
				+ " (SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount, "
				+ " s.REAL_NAME studentname, "
				+ " (SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount, bc.classNum  "
				+ " FROM crm_courseorder o LEFT JOIN account s ON o.studentid=s.Id "
				+ " left join crm_opportunity opp on opp.id=s.opportunityid "
				+ " LEFT JOIN class_order bc ON o.classorderid=bc.id "
				+ " WHERE 1=1 ";
		SysUser sysuser = SysUser.dao.findById(userId);
		if(!Role.isAdmins(sysuser.getStr("roleids"))){
			sql +=" AND o.operatorid= "+userId;
		}
		List<CourseOrder> list = CourseOrder.dao.find(sql+" ORDER BY o.id desc ");
		for(CourseOrder o : list){
			o.put("subjectname", Subject.dao.getSubjectNameByIds(o.getStr("subjectids")));
		}
		return list;
	}

	/**
	 * 学生课程 统计
	 * @param studentid
	 * @return
	 */
	public Student showCourseUsedCount(String studentid) {
		Student student = Student.dao.findById(Integer.parseInt(studentid));
		try{
			List<CourseOrder> colist = CourseOrder.dao.findByStudentId(studentid);
			double zksvip = 0;
			double zksxb = 0;//总课时	已购(课时)
			double ypvip = 0;
			double ypxb = 0;//总课时		已排(课时)
			StringBuffer vorderids = new StringBuffer();
			StringBuffer xborderid = new StringBuffer();
			String classorderids = "";
			for(CourseOrder co : colist){
				if(co.getInt("teachtype")==1){//1授课类型：1一对一、2小班
					zksvip+=co.getDouble("classhour");
					vorderids.append(co.getPrimaryKeyValue()).append(",");
				}else if(co.getInt("teachtype")==2){//2小班
					zksxb += co.getDouble("classhour");
					classorderids += ","+co.getInt("classorderid").toString();
					xborderid.append(co.getPrimaryKeyValue()).append(",");
				}
			}
			classorderids = classorderids.replaceFirst(",", "");
			if(classorderids.length()>0){//有买 小班
				StringBuffer classordersql = new StringBuffer();
				classordersql.append(" select classNum from class_order where id in (").append(classorderids).append(")");
				List<ClassOrder> orderlist = ClassOrder.dao.find(classordersql.toString());
				student.put("classordername", orderlist);//小班编号
			}
			if(vorderids!=null&&vorderids.length()>0){
				vorderids.replace(0, vorderids.length(), vorderids.substring(0, vorderids.length()-1));
			}
			if(xborderid!=null&&xborderid.length()>0){
				xborderid.replace(0, xborderid.length(), xborderid.substring(0, xborderid.length()-1));
			}
			//一对一 的   总课时		已排(课时)
			BigDecimal sumplan = Db.queryBigDecimal("SELECT IFNULL(SUM(tr.class_hour),0) ypks "
					+ "FROM courseplan cp LEFT JOIN time_rank tr ON tr.Id=cp.TIMERANK_ID WHERE STUDENT_ID = ? ", studentid);
			ypvip += sumplan.intValue();
			
			//小班的   总课时		已排(课时)
			sumplan = Db.queryBigDecimal("SELECT IFNULL(SUM(tr.class_hour),0) ypks "
					+ "FROM courseplan cp LEFT JOIN time_rank tr ON tr.Id=cp.TIMERANK_ID WHERE cp.class_id IN("+classorderids+")");
			ypxb += sumplan.intValue();
			
			student.put("zksvip", zksvip);
			student.put("ypvip", ypvip);
			student.put("zksxb", zksxb);
			student.put("ypxb", ypxb);
			
			int vlength = 0;
			if(vorderids!=null&&vorderids.length()>0){
				String vssql = "SELECT a.ks chour,b.yp ypcourse,b.SUBJECT_ID subjectid,b.SUBJECT_NAME "
						+ " FROM("
						+ "		SELECT o.studentid,SUM(o.classhour) ks "
						+ "		FROM crm_courseorder o "
						+ "		WHERE o.`status`!=0 AND o.studentid= ? "
						+ " ) a "
						+ " LEFT JOIN("
						+ " 	SELECT cp.student_id,SUM(tr.class_hour) yp,cp.SUBJECT_ID,s.SUBJECT_NAME "
						+ " 	FROM courseplan cp "
						+ " 	LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id "
						+ " 	LEFT JOIN `subject` s ON cp.SUBJECT_ID=s.Id "
						+ " 	WHERE cp.class_id=0 AND cp.PLAN_TYPE=0 AND cp.STUDENT_ID=? GROUP BY s.id "
						+ " ) b ON a.studentid=b.student_id ";
				List<Record> vsublist = Db.find(vssql, studentid, studentid);
				for(Record subject : vsublist){
					String vcsql = "SELECT a.ks chour,b.yp ypcourse,b.COURSE_ID courseid,b.COURSE_NAME "
							+ " FROM("
							+ "    SELECT o.studentid,SUM(o.classhour) ks "
							+ "    FROM crm_courseorder o "
							+ "    WHERE o.`status`!=0 AND o.studentid=? "
							+ " ) a "
							+ " LEFT JOIN("
							+ "    SELECT cp.student_id,SUM(tr.class_hour) yp,cp.COURSE_ID,s.COURSE_NAME "
							+ "    FROM courseplan cp "
							+ "    LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id "
							+ "    LEFT JOIN `course` s ON cp.course_id=s.Id "
							+ "    WHERE cp.class_id=0 AND cp.PLAN_TYPE=0 AND cp.STUDENT_ID=? AND cp.SUBJECT_ID = ? GROUP BY s.id "
							+ ") b ON a.studentid=b.student_id ";
					List<Course> vcublist = Course.dao.find(vcsql, studentid,studentid,subject.getInt("SUBJECTID"));
					subject.set("subjectlength", vcublist.size()+1);
					vlength += vcublist.size()+1;
					subject.set("vcourselist", vcublist);
				}
				student.put("vsubject", vsublist);
			}
			student.put("vlength", vlength+1);
			
			int xblength = 0;
			if(classorderids.length()>0){//表示 有购买小班
				String xbssql = "SELECT ("
						+ " SELECT SUM(tr.class_hour) "
						+ "    FROM courseplan cp "
						+ "    LEFT JOIN time_rank tr ON tr.Id=cp.TIMERANK_ID "
						+ "    WHERE cp.SUBJECT_ID = bc.subject_id AND cp.STUDENT_ID = acc.account_id AND cp.class_id <> 0 "
						+ " ) ypcourse, sub.SUBJECT_NAME,bc.subject_id subid "
						
						+ " FROM banci_course bc "
						+ " LEFT JOIN subject sub on bc.subject_id = sub.id "
						+ " LEFT JOIN account_banci acc on acc.banci_id = bc.banci_id "
						+ " WHERE bc.banci_id IN (" + classorderids + ") GROUP BY bc.subject_id ";
				List<Record> xbsublist = Db.find(xbssql);
				for(Record sub: xbsublist){// 每种 课程的课时
					String vcsql = "SELECT ("
							+ " SELECT SUM(tr.class_hour) "
							+ "   FROM courseplan cp "
							+ "   LEFT JOIN time_rank tr on tr.Id=cp.TIMERANK_ID "
							+ "   WHERE cp.COURSE_ID = bc.course_id AND cp.STUDENT_ID = acc.account_id AND cp.class_id <> 0 "
							+ "	) ypcourse, bc.course_id, sub.COURSE_NAME "
							
							+ " FROM banci_course bc "
							+ " LEFT JOIN account_banci acc ON acc.banci_id = bc.banci_id "
							+ " LEFT JOIN course sub ON bc.course_id = sub.id"
							+ " WHERE bc.banci_id IN ("+ classorderids +") AND bc.subject_id= ? GROUP BY bc.course_id ";
					
					List<Record> xbcublist = Db.find(vcsql, sub.get("subid"));
					sub.set("xbcourselength", xbcublist.size()+1);
					xblength += xbcublist.size()+1;
					sub.set("xbcourselist", xbcublist);
				}
				student.put("xbsubject", xbsublist);
			}
			student.put("xblength", xblength+1);
			
		}catch(Exception ex){
			ex.printStackTrace();
			
		}
		
		return student;
	}
	
	/**
	 * 根据学生id获取学生所对应的所有科目名称 返回字符串
	 * @param string
	 * @return
	 */
	public String getStudentSubjectNames(String stuid) {
		String sql = "select GROUP_CONCAT( REPLACE(subjectids,'|',',')) subids from crm_courseorder WHERE studentid = ? and LENGTH(subjectids)!=0";
		CourseOrder courseOrder = CourseOrder.dao.findFirst(sql, stuid);
		String subjectids = null;
		String subjectNames = "";
		if(courseOrder!=null&&StrKit.notBlank(courseOrder.getStr("subids"))){
			subjectids = courseOrder.getStr("subids");
			String subjectNameSql = "select group_concat(subject_name) names from subject where id in ("+subjectids+")";
			Subject subject = Subject.dao.findFirst(subjectNameSql);
			subjectNames = StringUtils.isEmpty(subject.getStr("names"))?"无":subject.getStr("names").replace(",", "<br>");
		}
		return subjectNames;
	}
	
	/**
	 * 
	 * 学生选择该时段是否够课时
	 * @param studentId
	 * @param rankid
	 * @param classtype
	 * @return
	 */
	public boolean checkHaveEnoughHours(String studentId, String rankid, String classtype, Integer subjectId) {
		if(classtype.equals("1"))
			return true;
		else{
			Student student = Student.dao.findById(studentId);
			if(student.getInt("state")==2){//虚拟用户，查询小班课时是否够用
				ClassOrder classorder= ClassOrder.dao.findByXuniId(Integer.parseInt(studentId));
				TimeRank timeRank = TimeRank.dao.findById(rankid);
				int zks = classorder.getInt("lessonNum");
				float ypks =  CoursePlan.coursePlan.getClassYpkcClasshour(classorder.getPrimaryKeyValue());
				double syks = ToolArith.sub(zks, ypks);//剩余课时
				int chargeType = classorder.getInt("chargeType");
				if(chargeType == 1){
					if(syks>0){
						if (timeRank.getBigDecimal("class_hour").doubleValue()>syks) {
							return false;
						}
					}else{
						return false;
					}			
				}
			}else{
				TimeRank timeRank = TimeRank.dao.findById(rankid);
				double yjfks = CourseOrder.dao.getPaidVIPzks(Integer.valueOf(studentId),subjectId);
				double zks = CourseOrder.dao.getCanUseVIPzks(student.getPrimaryKeyValue(),subjectId);
				double ypks = CoursePlan.coursePlan.getUsedVIPClasshour(Integer.parseInt(studentId), subjectId);
				double syks = ToolArith.sub(zks, ypks);//剩余课时
				Organization org = Organization.dao.findById(1);
				String keqianStr = org.get("basic_maxdefaultclass").toString();
				double keqian = 10000000;
				if(!StringUtils.isEmpty(keqianStr)){
					keqian = Double.parseDouble(keqianStr);
				}
				if (syks <= 0) {
					if (ypks + timeRank.getBigDecimal("class_hour").doubleValue() > yjfks +keqian) {
						return false;
					}else{
						if(timeRank.getBigDecimal("class_hour").doubleValue() > syks) {
							return false;
						}
					}
				} 
			}		
		}
		return true;
	}
	/**
	 * 学生生日列表分页
	 * @param splitPage
	 */
	public void getAllStudentBirthDay(SplitPage splitPage, String loginRoleCampusIds ) {
		 List<Object> paramValue = new ArrayList<Object>();
			StringBuffer select = new StringBuffer(" select * ," );
			select.append("DATE_FORMAT(birthday,'%m-%d') shengri,");
			Date date=new Date();
			DateFormat format=new SimpleDateFormat("yyyy");
			String time=format.format(date); 
			select.append(time).append("-DATE_FORMAT(birthday,'%Y') nianling");
			StringBuffer formSql = new StringBuffer("from account where LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 and state <> 2 and BIRTHDAY IS NOT NULL ");
			
			Map<String,String> queryParam = splitPage.getQueryParam();
			Set<String> paramKeySet = queryParam.keySet();
			for (String paramKey : paramKeySet) {
				String value = queryParam.get(paramKey);
				switch (paramKey) {
				case "like":
					formSql.append(" and DATE_FORMAT(birthday,'%m-%d') = DATE_FORMAT((select current_date),'%m-%d') ");
					break;
				case "begin":
					formSql.append(" and birthday >= '").append(value).append("'");
					break;
				case "end":
					formSql.append(" and birthday <= '").append(value).append("'");
					break;
				case "studentname":
					formSql.append(" and real_name like '%").append(value).append("%'");
					break;
				default:
					break;
				}
			}
			if(queryParam.get("begin")==null&&queryParam.get("end")==null){
				
				format=new SimpleDateFormat("MM-dd");
				time=format.format(date); 
				formSql.append(" and DATE_FORMAT(birthday,'%m-%d') >= '").append(time).append("'");
			}
			if( !StringUtils.isEmpty( loginRoleCampusIds ) ){
				formSql.append( " and account.campusid in (" + loginRoleCampusIds + ")" );
			}
			formSql.append(" order by birthday desc ");
			Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
			splitPage.setPage(page);
		
	}

	/**
	 * 购课记录 分页
	 * @return 
	 */
	public List<Record> showCourseOrdersDetail(SplitPage splitPage, Integer sysuserId, String loginRoleCampusIds) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer select = new StringBuffer(
				  " SELECT o.delflag,o.id,o.subjectids,o.createtime,o.`status`,o.teachtype,o.realsum,o.rebate,o.classhour, "
				+ " (SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount, "
				+ " s.REAL_NAME studentname, "
				+ " (SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount, bc.classNum  ");
		
		StringBuffer formSql = new StringBuffer(
				  " FROM crm_courseorder o "
			    + " LEFT JOIN account s ON o.studentid=s.Id "
				+ " LEFT JOIN crm_opportunity opp on opp.id=s.opportunityid "
				+ " LEFT JOIN class_order bc ON o.classorderid=bc.id "
				+ " WHERE 1=1 ");
		SysUser sysUser = SysUser.dao.findById(sysuserId);
		if(Role.isKcgw(sysUser.getStr("roleids"))){
			formSql.append(" AND FIND_IN_SET(o.studentid,(SELECT GROUP_CONCAT(sk.student_id) FROM student_kcgw sk WHERE sk.kcgw_id=?))");
			paramValue.add(sysuserId);
		}
		if( !StringUtils.isEmpty(loginRoleCampusIds) ){
			formSql.append( " AND s.campusid in (" + loginRoleCampusIds + ")" );
		}
		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "studentname":
				formSql.append(" and s.REAL_NAME like ? ");//预留查询
				paramValue.add("%" + value + "%");
				break;
			default:
				break;
			}
		}
		
		formSql.append(" ORDER BY o.id desc ");
		
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		
		List<Record> recordList  =page.getList();
		for(Record record : recordList){
			record.set("subjectname", Subject.dao.getSubjectNameByIds(record.getStr("subjectids")));
		}
		splitPage.setPage(page);
		return recordList;
	}


	/**
	 * 保存导入
	 */
	public static String importStudents(UploadFile file,Integer createuserid,Integer campusid) {
		// 获取文件
		String msg = "导入失败,请检查数据格式是否正确";
		try {
			//path = 文件目录 + 文件名称
			String fileName = file.getFileName();
			//判断后缀是否已xls
			if(fileName.toLowerCase().endsWith("xls")){
				// 处理导入数据
				Map<String, Object> flagList = ToolImport.dealDataByPath(file.getFile(), ImportStudent.tabMap, ImportStudent.mustTab);
				//
				boolean flag = (boolean) flagList.get("flag");
				if (!flag) {
				} else {
					@SuppressWarnings("unchecked")
					List<Map<String, String>> list = (List<Map<String, String>>) flagList.get("list"); // 分析EXCEL数据
					
					Map<String, Object> saveMsg =  forAddXLSDB(list,createuserid,campusid);
					
					StringBuffer sb = new StringBuffer("您成功导入了 ").append(saveMsg.get("save")).append(" 条信息   <br>");
					sb.append("本次导入信息如下：<br>").append(flagList.get("errormsg")).append("<br>").append(saveMsg.get("saveMsg"));
					msg = sb.toString();
				}
			}else{
				msg = "上传文件只能为.xls类型";
			}
			ToolImport.removeTempFile(file);
			return msg;
		} catch (Exception e) {
			e.printStackTrace();
			ToolImport.removeTempFile(file);
			return msg;
		}
	}
	
	/**
	 * 把xls文件内容写入数据库
	 * @param tabDBName
	 * @param list
	 * @return
	 */
	public  static Map<String,Object> forAddXLSDB(List<Map<String, String>> list,Integer createuserid,Integer campusid){
		Map<String, Object> saveMsg = new HashMap<String, Object>();
		StringBuffer msg = new StringBuffer();
		int save = 0;
		String key = null;
		String value = null;
		String userPwd = ToolMD5.getMD5(Organization.dao.getStuLnitialPassword());
		
		try {
			for (Map<String, String> map : list) { // 遍历取出的数据，并保存
				Account account = new Account();//用户对象
				for (Map.Entry<String, String> entry : map.entrySet()) {
					key = entry.getKey();
					value = entry.getValue();
					if(StrKit.notBlank(value))
						value = value.trim();
					//默认值处理
					switch (key) {
					
					case "sex"://男 女
						account.set(key, "男".equals(value) ? 1:0);//1男 0女
						break;
					
					case "release"://课表确认(是/否)
						account.set(key, "是".equals(value) ? 1:0);//1是 0否
						break;
						
					case "receive_sms_student"://学生接收短信(是/否)
						account.set(key, "是".equals(value) ? 1:0);//1是 0否
						break;
						
					case "receive_sms_father"://父亲接收短信(是/否)
						account.set(key, "是".equals(value) ? 1:0);//1是 0否
						break;
						
					case "receive_sms_mother"://母亲接收短信(是/否)
						account.set(key, "是".equals(value) ? 1:0);//1是 0否
						break;
						
					case "board"://住宿(是/否)
						account.set(key, "是".equals(value) ? 1:0);//1是 0否
						break;
						
					case "remote"://远程(是/否)
						account.set(key, "是".equals(value) ? 1:0);//1是 0否
						break;

					default:
						account.put(key, value);
						break;
					}
					
				}
				try{
					
					account.set("user_name", account.get("real_name") );
					account.set("roleids", "4,");
					account.set("campusid", campusid);//校区
					account.set("user_type", "1");
					account.set("createuserid",createuserid);//当前登录人id
					account.set("user_pwd", userPwd);
					account.set("CREATE_TIME", new Date());
					boolean saveflag = account.save();//bookUser保存到数据库
					if(saveflag){
						save++;//保存几条数据
					}else{
						msg.append("第:"+ (save+1) +"  条信息存入失败");
						msg.append("<br>");
					}
				}catch(Exception ex){
					String exStr = ex.getLocalizedMessage();
					exStr = exStr.substring(exStr.indexOf(":"));
					msg.append("第:"+ (save+1) +"  条信息存入异常" + exStr);
					msg.append("<br>");
					ex.printStackTrace();
				}
			}
		} catch (Exception e) {
			msg.append("导入异常.");
			e.printStackTrace();
		}
		saveMsg.put("save", save);
		saveMsg.put("saveMsg", msg);
		return saveMsg;
	}

}
