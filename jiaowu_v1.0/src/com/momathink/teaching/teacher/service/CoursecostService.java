
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

package com.momathink.teaching.teacher.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.sys.operator.model.Role;
import com.momathink.teaching.teacher.model.Coursecost;
import com.momathink.teaching.teacher.model.Teacher;

/***
 * @ClassName: 讲师课酬管理
 */
public class CoursecostService extends BaseService {
	//private static Logger log = Logger.getLogger(CoursecostService.class);
	public static final CoursecostService me = new CoursecostService();

	/**充血分页   角色  数据限制
	 * @param sysuser 登陆人 */
	public void list(SplitPage splitPage, Record sysuser) {
		
		Map<String, String> queryParam = splitPage.getQueryParam();
		String sysuserid = sysuser.getInt("id").toString();
		String roleids = sysuser.getStr("roleids");
		
		queryParam.put("accountcampusids", sysuser.getStr("accountcampusids"));
		
		//角色 查看数据权限1是全部0是个人	
		if(sysuser.getInt("showall").equals(0)){
			if (Role.isTeacher(roleids)) {
				queryParam.put("teacherid", sysuserid);
			}
		}
		
		//如果检测 到 搜索老师姓名 时候清除 老师的id 限制
		if(StrKit.notBlank(queryParam.get("teachernames")))
			queryParam.remove("teacherid");
		
		list( splitPage );
	}
	
	/**
	 * @Title: 讲师课酬 列表
	 */
	public void list(SplitPage splitPage){
		String select = " SELECT alltab.* ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(
				"FROM ( " +
				"		( " +
				"			SELECT " +
				"				ct.teacherid, " +
				"				ct.courseid, " +
				"				a.REAL_NAME, " +
				"				s.SUBJECT_NAME, " +
				"				c.COURSE_NAME, " +
				"				IFNULL(ct.yicost, 0) AS yicost, " +
				"				IFNULL(ct.xiaobancost, 0) AS xiaobancost, " +
				"				ct.REMARK " +
				"			FROM " +
				"				coursecost ct " +
				"			LEFT JOIN course c ON c.Id = ct.courseid " +
				"			LEFT JOIN `subject` s ON s.Id = c.SUBJECT_ID " +
				"			LEFT JOIN account a ON a.id = ct.teacherid " +
				"			LEFT JOIN account_campus acs ON acs.account_id = a.Id " +
				"			WHERE ct.courseid != '' "
				);
		
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			
			case "teacherid":// 教师id
				formSqlSb.append(" AND a.id = ? ");
				paramValue.add(value);
				break;
				
			case "teachernames":// 教师 姓名
				formSqlSb.append(" AND a.REAL_NAME LIKE ? ");
				paramValue.add("%"+value+"%");
				break;
				
			case "courseids":// 课程id
				formSqlSb.append(" AND FIND_IN_SET(c.Id, ?) ");
				paramValue.add(value);
				break;
				
			case "coursenames":// 课程 名称
				formSqlSb.append(" AND c.COURSE_NAME LIKE ? ");
				paramValue.add("%"+value+"%");
				break;
				
			case "subjectids":// 科目id
				formSqlSb.append(" AND FIND_IN_SET(s.Id, ?) ");
				paramValue.add(value);
				break;
				
			case "accountcampusids":// 校区id
				formSqlSb.append(" AND FIND_IN_SET(acs.campus_id, ?) ");
				paramValue.add(value);
				break;
				
			default:
				break;
			}
		}
		
		formSqlSb.append(" GROUP BY c.Id)");
		
		//根据 某个老师id 查询 的 时候, 把剩余未填写的 课程补齐
		String teacherid = queryParam.get("teacherid");
		if(StrKit.notBlank(teacherid)){
			
			formSqlSb.append(
						"		UNION ALL  ( " +
						"				SELECT  "+
						"				    ? AS teacherid, " +
					    "					c.Id AS courseid, " +
					    "					? AS REAL_NAME, " +
						"					s.SUBJECT_NAME, " +
						"					c.COURSE_NAME, " +
						"					0 AS yicost, " +
						"					0 AS xiaobancost, " +
						"					NULL AS REMARK " +
						"				FROM " +
						"					course c " +
						"				LEFT JOIN `subject` s ON s.Id = c.SUBJECT_ID " +
						"				WHERE  c.SUBJECT_ID != 0 AND FIND_IN_SET(c.Id, ?) "
			);
			
			//上面 sql 的 占位符  赋值
			Teacher teacher = Teacher.dao.findById(teacherid);
			String teachername = teacher.getStr("REAL_NAME");
			paramValue.add(teacherid);
			paramValue.add(teachername);//姓名
			paramValue.add((teacher.getStr("CLASS_TYPE")+"").replaceAll("\\|", ","));//老师 能教 的课程,(吐槽:这个字段名起的...)
			
			//页面展示老师名称使用, 不用于查询 限制条件
			queryParam.put("teachernameview", teachername);
			
			//处理 查询课程的时候
			String coursenames = queryParam.get("coursenames");
			if(StrKit.notBlank(coursenames)){
				formSqlSb.append("AND c.COURSE_NAME LIKE ? ");
				paramValue.add("%"+coursenames+"%");
			}
			
			//UNION ALL 这个函数 的 包尾
			formSqlSb.append(" ) ");
		}
		
		
		formSqlSb.append(
				"	) alltab " +
				"GROUP BY " +
				"	alltab.courseid " +
				"ORDER BY " +
				"	alltab.SUBJECT_NAME, " +
				"	alltab.COURSE_NAME");
		
	}
	
	
	/**
	 * @Title: 根据老师id 查询 出 老师的自定义课时费( 就是 课程为空的 ) 
	 */
	public List<Coursecost> queryByTeacheridAndIsNullCourseid(Object teacherid){
		if(StrKit.notNull(teacherid))
			return Coursecost.dao.find("SELECT * FROM coursecost WHERE teacherid=? AND ISNULL(courseid) ORDER BY yicost", teacherid);
		return new ArrayList<>();
	}
	
	/**
	 * @Title: 根据老师id 查询 出 老师的自定义课时费( 就是 课程为空的 ) 
	 */
	public List<Coursecost> queryByTeacheridAndCourseid(String teacherid, Object courseid){
		if(StrKit.notNull(teacherid))
			return Coursecost.dao.find(
					"SELECT * FROM coursecost "
					+ "WHERE teacherid=? AND (courseid = ? OR ISNULL(courseid)) "
					+ "ORDER BY xiaobancost DESC, yicost",
					teacherid, (courseid==null?"":courseid) );
		return new ArrayList<>();
	}
	
	/**
	 * @Title: 根据老师id 查询 出 老师的自定义 默认第一条  课时费( 就是 课程为空的 ) 
	 */
	public Coursecost queryByTeacheridAndCourseidDefault(String teacherid, Object courseid){
		if(StrKit.notNull(teacherid)) {
			Coursecost record = Coursecost.dao.findFirst(
					"SELECT * FROM coursecost "
							+ "WHERE teacherid=? AND (courseid = ? OR ISNULL(courseid)) "
							+ "ORDER BY xiaobancost DESC, yicost LIMIT 0,1",
							teacherid, (courseid==null?"":courseid) );
			if (record != null)
			  return record;
		}
		return new Coursecost().put("yicost", new Float("0")).put("xiaobancost", new Float("0"));
	}
	
	/***
	 * 保存 老师 自定义的课时费
	 * @param teacherid  老师 id
	 * @param customVals 自定义的课时费值
	 * @param creatid  录入人id
	 * @return 
	 */
	public void updateTeacheridCustom(Object teacherid, Object[] customVals, Object creatid){
		Db.update("DELETE FROM coursecost WHERE teacherid=? AND ISNULL(courseid)" ,teacherid);
		List<Coursecost> list = new ArrayList<>();
		Date date = new Date();
		for (Object val : customVals) {
			list.add(
					new Coursecost()
						.set("teacherid", teacherid)
						.set("yicost", val)
						.set("creattime", date)
						.set("creatid", creatid)
			);
		}
		String sql = "INSERT INTO `coursecost` (`teacherid`, `yicost`, `creattime`, `creatid`, `REMARK`) VALUES (?, ?, ?, ?, NULL)";
		Db.batch(sql, "teacherid,yicost,creattime,creatid", list, 50);
	}
	
	/**
	 * @Title: 排课时允许修改老师课时费
	 * @param customSwitch :  open是开启   shut关闭
	 */
	public void customSwitch(String customSwitch){
		Organization organizationMessage = Organization.dao.getOrganizationMessage();
		String customSwitchDb = organizationMessage.getStr("teacherFeeCustomSwitch");
		if(StrKit.isBlank(customSwitch)){
			
			if(StrKit.notBlank(customSwitchDb))
				customSwitch = "shut";//默认关闭
			else
				return;
		}
		
		if(!(customSwitch.equals(customSwitchDb))){
			try {
				organizationMessage.set("teacherFeeCustomSwitch", customSwitch);
				organizationMessage.update();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public String getEnddate(Date date, int tid){
		Coursecost coursecost = Coursecost.dao.findFirst("select min(enddate) from coursecost where teacherid = ? and enddate > ?",tid,date);
		if(coursecost.getDate("MIN(enddate)")==null){
			return null;
		}
		Date date1 = coursecost.getDate("MIN(enddate)");
		String str=ToolDateTime.format(date1,"yyyy-MM-dd");  
		return str;		
	}

	public Coursecost getCourecostByenddate(String enddate,int tid) {
		Coursecost coursecost = Coursecost.dao.findFirst("select * from coursecost where teacherid = ? and enddate = ?",tid,enddate);
		return coursecost;
	}

	public Coursecost getCourecostBylast(int tid) {
		Coursecost coursecost = Coursecost.dao.findFirst("select * from coursecost where teacherid = ? and enddate is null",tid);
		return coursecost;
	}

	public List<Coursecost> queryCostlistByTeacherId(String tid) {
		List<Coursecost> coursecosts = Coursecost.dao.find("select c.*,a.REAL_NAME from coursecost c left join account a on a.id = c.creatid where teacherid = ? ORDER BY c.startdate DESC",tid);
		return coursecosts;
	}
}
