
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseModel;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolMail;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.SysUser;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.service.StudentService;
import com.momathink.teaching.teacher.model.GradeUpdate;
import com.momathink.teaching.teacher.model.SetPoint;
import com.momathink.teaching.teacher.model.Teachergrade;
/**
 * 2015年7月30日
 * @author prq
 *
 */

public class ReportService extends BaseService {

	private Pattern escapresource = Pattern.compile("(\\$\\{)([\\w]+)(\\})");
	private static StudentService studentService = new StudentService();
	private static final Logger logger = Logger.getLogger(ReportService.class);
	private static String TEMPLATE_WEEKLY_NAME = null;
	
	public JSONObject saveNewPoint(String stuid,String[] tchids,String daynum,String[] dates,String remark){
		JSONObject json = new JSONObject();
		String code = "0";
		String msg = "保存成功";
		if(StrKit.isBlank(stuid)){
			msg="该学员不存在,不能提交";
		}else{
			if(tchids.length<1){
				msg="没有选择老师，保存失败.";
			}else{
				if(dates.length<1){
					msg="没有选择日期,保存失败.";
				}else{
					daynum = StrKit.isBlank(daynum)?0+"":daynum;
					for(String tchid:tchids){
						for(String date:dates){
							SetPoint newPoint = new SetPoint();
							newPoint.set("studentid", stuid);
							newPoint.set("teacherid", tchid);
							newPoint.set("appointment", date);
							newPoint.set("days", daynum);
							newPoint.set("state", 0);
							newPoint.set("remark", remark);
							newPoint.set("createtime", new Date());
							newPoint.save();
							code="1";
						}
					}
				}
			}
		}
		json.put("code", code);
		json.put("msg", msg);
		return json;
	}

	/**
	 * 分页 老师  我的报告
	 * @param splitPage
	 */
	public void getTeacherPoints(SplitPage splitPage) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer selectSql = new StringBuffer("select point.*,stu.real_name studentName,tch.real_name teacherName ");
		StringBuffer formSql = new StringBuffer("from jw_setpoint point left join account stu on stu.Id = point.studentid"
				+ " left join account tch on tch.Id = point.teacherid where 1=1 ");
		
		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
				case "state":
					formSql.append(" and point.state = ? ");
					paramValue.add(Integer.parseInt(value));
					break;
				case "teacherid":
					formSql.append(" and point.teacherid = ? ");
					paramValue.add(Integer.parseInt(value));
					break;
				case "studentname":
					formSql.append(" and stu.real_name like '%").append(value).append("%'");
					break;
				case "startappointment" :
					formSql.append(" and point.appointment >= ? ");
					paramValue.add(value);
					break;
				case "endappointment" :
					formSql.append(" and point.appointment <= ? ");
					paramValue.add(value);
					break;
				case "startsubmission" :
					formSql.append(" and point.submissiontime >= ? ");
					paramValue.add(value);
					break;
				case "endsubmission" :
					formSql.append(" and point.submissiontime <= ? ");
					paramValue.add(value);
					break;
					
				default:
					break;
			}
		}
		formSql.append(" order by point.appointment desc ");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), selectSql.toString(), formSql.toString(), paramValue.toArray());
		splitPage.setPage(page);
	}
	

	/**
	 * 分页 报告列表
	 * @param splitPage
	 */
	public void getReportList(SplitPage splitPage, String loginRoleCampusIds ) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer selectSql = new StringBuffer(
				"select tg.id tgid,tg.courseplan_id,tg.pointid,tg.isoneday,"
				+ " DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') coursetime, tr.RANK_NAME, c.COURSE_NAME,"
				+ " tg.createtime,tg.issend,tg.sendtime, point.submissiontime,stu.real_name studentName,"
				+ " tch.real_name teacherName,1 weekorday ");
		StringBuffer formSql = new StringBuffer(
				"from teachergrade tg "
				+ " left join jw_setpoint point on point.id= tg.pointid "
				+ " left join account stu on stu.Id = point.studentid"
				+ " left join account tch on tch.Id = point.teacherid "
				+ " left join courseplan cp on cp.id = tg.courseplan_id "
				+ " LEFT JOIN time_rank tr on cp.TIMERANK_ID = tr.Id  "
				+ " LEFT JOIN course  c on cp.COURSE_ID = c.Id "
				+ " where if(tg.pointid is  null,length(tg.UNDERSTAND) <> 0,1=1) ");
		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
				case "sysuserid" :
					SysUser user = SysUser.dao.findById(value);
					if(Role.isTeacher(user.getStr("roleids"))){
						//老师看自己的就可以了
						formSql.append(" and ( point.teacherid = ").append(value);
						formSql.append(" or cp.teacher_id = ").append(value).append(" ) ");
					}
					if(Role.isJiaowu(user.getStr("roleids"))||Role.isKcgw(user.getStr("roleids"))){//教务
						String campusids = AccountCampus.dao.getCampusIdsByAccountId(Integer.parseInt(value));
						String tchids = AccountCampus.dao.getTeacherIdsfromCampusids(campusids);
							formSql.append(" and (  FIND_IN_SET (point.teacherid, '").append(tchids).append("') ");
							formSql.append(" or  FIND_IN_SET ( cp.teacher_id, '").append(tchids).append("') ) ");
					}
					break;
				case "startappointment" :
					formSql.append(" and tg.createtime >= ? ");
					paramValue.add(value);
					break;
				case "endappointment" :
					formSql.append(" and tg.createtime <= ? ");
					paramValue.add(value);
					break;
				case "teacherid":
					formSql.append(" and ( point.teacherid = ").append(value);
					formSql.append(" or cp.teacher_id = ").append(value).append(" ) ");
					break;
				case "studentid":
					formSql.append(" and ( point.studentid = ").append(value);
					formSql.append(" or cp.student_id = ").append(value).append(" ) ");
					/*queryParam.put("studentname", Student.dao.getStudentNameById(value));*/
					break;
				case "studentName":
					formSql.append(" and stu.real_name like ?");
					paramValue.add("%"+value+"%");
					break;
				case "typeid":
					if(value.equals("1")){
						formSql.append(" and tg.courseplan_id != 0  ");
					}
					if(value.equals("2")){
						formSql.append(" and tg.courseplan_id = 0  ");
					}
					break;
				default:
					break;
			}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			String teacherIds  =  AccountCampus.dao.getTeacherIdsfromCampusids(loginRoleCampusIds);
			formSql.append(" and (  FIND_IN_SET (point.teacherid, '" + teacherIds + "') ");
			formSql.append(" or  FIND_IN_SET ( cp.teacher_id, '" + teacherIds + "') ) ");
		}
		formSql.append(" order by point.appointment desc ");
		
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), selectSql.toString(), formSql.toString(), paramValue.toArray());
		
		List<Record> list = page.getList();
		for (Record r : list) {
			if(r.getInt("courseplan_id")!=0){
				String plansql = "select stu.real_name studentName,tch.real_name teacherName from courseplan cp left join account stu on stu.id=cp.student_id left join account tch on tch.id=cp.teacher_id "
						+ " where cp.id = "+r.getInt("courseplan_id");
				CoursePlan plan = CoursePlan.coursePlan.findFirst(plansql);
				if(plan!=null){
					r.set("studentName", plan.getStr("studentName"));
					r.set("teacherName", plan.getStr("teacherName"));
					r.set("weekorday", 2);
				}
			}
		}
		splitPage.setPage(page);
	}
	
	public void getReportListUpdate(SplitPage splitPage, String loginRoleCampusIds ) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer selectSql = new StringBuffer("select tg.id tgid,tg.courseplan_id,tg.pointid,tg.isoneday,"
				+ " DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d') coursetime, tr.RANK_NAME, c.COURSE_NAME,"
				+ " tg.createtime,tg.issend,tg.sendtime, point.submissiontime,stu.real_name studentName,"
				+ " tch.real_name teacherName,1 weekorday ");
		StringBuffer formSql = new StringBuffer("from teachergrade_update tg "
				+ " left join jw_setpoint point on point.id= tg.pointid "
				+ " left join account stu on stu.Id = point.studentid"
				+ " left join account tch on tch.Id = point.teacherid "
				+ " left join courseplan cp on cp.id = tg.courseplan_id "
				+ " LEFT JOIN time_rank tr on cp.TIMERANK_ID = tr.Id  "
				+ " LEFT JOIN course  c on cp.COURSE_ID = c.Id "
				+ " where if(tg.pointid is  null,length(tg.UNDERSTAND) <> 0,1=1) ");
		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
				case "sysuserid" :
					SysUser user = SysUser.dao.findById(value);
					if(Role.isTeacher(user.getStr("roleids"))){
						//老师看自己的就可以了
						formSql.append(" and ( point.teacherid = ").append(value);
						formSql.append(" or cp.teacher_id = ").append(value).append(" ) ");
					}
					if(Role.isJiaowu(user.getStr("roleids"))||Role.isKcgw(user.getStr("roleids"))){//教务
						String campusids = AccountCampus.dao.getCampusIdsByAccountId(Integer.parseInt(value));
						String tchids = AccountCampus.dao.getTeacherIdsfromCampusids(campusids);
							formSql.append(" and (  FIND_IN_SET (point.teacherid, '").append(tchids).append("') ");
							formSql.append(" or  FIND_IN_SET ( cp.teacher_id, '").append(tchids).append("') ) ");
					}
					break;
				case "startappointment" :
					formSql.append(" and tg.createtime >= ? ");
					paramValue.add(value);
					break;
				case "endappointment" :
					formSql.append(" and tg.createtime <= ? ");
					paramValue.add(value);
					break;
				case "teacherid":
					formSql.append(" and ( point.teacherid = ").append(value);
					formSql.append(" or cp.teacher_id = ").append(value).append(" ) ");
					break;
				case "studentid":
					formSql.append(" and ( point.studentid = ").append(value);
					formSql.append(" or cp.student_id = ").append(value).append(" ) ");
					break;
				case "studentName":
					formSql.append(" and stu.real_name like ?");
					paramValue.add("%"+value+"%");
					break;
				case "typeid":
					if(value.equals("1")){
						formSql.append(" and tg.courseplan_id != 0  ");
					}
					if(value.equals("2")){
						formSql.append(" and tg.courseplan_id = 0  ");
					}
					break;
				default:
					break;
			}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			String teacherIds  =  AccountCampus.dao.getTeacherIdsfromCampusids(loginRoleCampusIds);
			formSql.append(" and (  FIND_IN_SET (point.teacherid, '" + teacherIds + "') ");
			formSql.append(" or  FIND_IN_SET ( cp.teacher_id, '" + teacherIds + "') ) ");
		}
		formSql.append(" order by point.appointment desc ");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), selectSql.toString(), formSql.toString(), paramValue.toArray());
		List<Record> list = page.getList();
		for (Record r : list) {
			if(r.getInt("courseplan_id")!=0){
				String plansql = "select stu.real_name studentName,tch.real_name teacherName from courseplan cp left join account stu on stu.id=cp.student_id left join account tch on tch.id=cp.teacher_id "
						+ " where cp.id = "+r.getInt("courseplan_id");
				CoursePlan plan = CoursePlan.coursePlan.findFirst(plansql);
				if(plan!=null){
					r.set("studentName", plan.getStr("studentName"));
					r.set("teacherName", plan.getStr("teacherName"));
					r.set("weekorday", 2);
				}
			}
		}
		splitPage.setPage(page);
	}
	public Record getReportDetail(String id) {
		String sql = "select tg.*,course.course_name from teachergrade_update tg left join course on course.id=tg.courseid where tg.id = "+id;
		Record record = Db.findFirst(sql);
		Integer planid = record.getInt("COURSEPLAN_ID");
		Integer pointid = record.getInt("pointid");
		if(planid!=null){//日报
			String planSql = "select course.course_name,stu.real_name studentName,tch.real_name teacherName,cp.course_time submissiontime,stu.SCHOOL,stu.GRADE_NAME "
					+ " from courseplan cp left join account stu on stu.Id=cp.student_id left join account tch on tch.id=cp.teacher_id "
					+ " left join course on course.id=cp.course_id  ";
			CoursePlan plan = CoursePlan.coursePlan.findFirst(planSql);
			record.set("studentName",plan.getStr("studentName"));
			record.set("course_name",plan.getStr("course_name"));
			record.set("teacherName",plan.getStr("teacherName"));
			record.set("submissiontime",plan.getDate("submissiontime"));
			record.set("SCHOOL",plan.getStr("SCHOOL"));
			record.set("GRADE_NAME",plan.getStr("GRADE_NAME"));
		}
		if(pointid!=null){//周报
			SetPoint point = SetPoint.dao.getFillReportBaseMsg(pointid.toString());
			record.set("studentName",point.getStr("studentName"));
			record.set("teacherName",point.getStr("teacherName"));
			record.set("submissiontime",point.getDate("submissiontime"));
			record.set("SCHOOL",point.getStr("SCHOOL"));
			record.set("GRADE_NAME",point.getStr("GRADE_NAME"));
		}
		return record;
	}

	/**
	 * 设置节点分页
	 * @param splitPage
	 */
	public void setPointPages(SplitPage splitPage, String loginRoleCampusIds) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer selectSql = new StringBuffer("select real_name,id  ");
		StringBuffer formSql = new StringBuffer("from account where "
				+ "LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 and state=0 ");
		
		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
				case "sysuserid" :
					SysUser sysuser = SysUser.dao.findById(value);
					if(!Role.isAdmins(sysuser.getStr("roleids"))){
						//需要根据用户属性做区分时候使用
					}
					break;
				case "studentname" :
					formSql.append(" and real_name like ? ");
					paramValue.add("%" + value + "%");
					break;
				default:
					break;
			}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSql.append( " and account.campusid in (" + loginRoleCampusIds + ")" );
		}
		formSql.append(" order by create_time desc ");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), selectSql.toString(), formSql.toString(), paramValue.toArray());
		List<Record> list = page.getList();
		for(Record stu:list){
			String subjectNames = studentService.getStudentSubjectNames(stu.getInt("Id").toString());
			stu.set("subjectname", subjectNames);
		}
		splitPage.setPage(page);
		
	}
	
	/**
	 * 替换文本周报数据
	 * @param report
	 * @param url
	 * @param tgId
	 * @return
	 */
	public JSONObject getWeekMailContent(String report, String url, String tgId, boolean en){
		JSONObject json = new JSONObject();
		Map<String,String> map = new HashMap<String,String>();
		map.put("url", url);
		String content = report.replace("/n", "").replace("section{margin:20px 0}", "section{margin:50px 0}").replace("/images/logo/logo.png", url+"/images/logo/logo.png");
		BaseModel<?> tg = null;
		if(en)
			tg = GradeUpdate.dao.queryById(tgId);
		else
			tg = Teachergrade.teachergrade.queryById(tgId);
		SetPoint sp = SetPoint.dao.getFillReportBaseMsg(tg.getInt("pointid").toString());
		map.put("url",url);
		map.put("teachername", sp.getStr("teacherName"));
		map.put("studentname", sp.getStr("studentName"));
		map.put("appointment", sp.get("appointment")+"");
		map.put("school", sp.getStr("SCHOOL")==null?"":sp.getStr("SCHOOL"));
		
		map.put("teacherfeedback",tg.get("teacherfeedback")==null?"暂无总结":tg.getStr("teacherfeedback"));
		map.put("question",tg.get("question")==null?"暂无总结":tg.getStr("question"));
		map.put("method",tg.get("method")==null?"暂无总结":tg.getStr("method"));
		map.put("homework",tg.get("HOMEWORK")==null?"暂无总结":tg.getStr("HOMEWORK"));
		map.put("attention", tg.get("ATTENTION")==null?"4":tg.getStr("ATTENTION"));//滑动条
		map.put("studymanner", tg.get("STUDYMANNER")==null?"4":tg.getStr("STUDYMANNER"));
		map.put("coursename", tg.get("COURSE_NAME")==null?"暂无总结":tg.getStr("COURSE_NAME"));
		SetPoint nextsp = SetPoint.dao.findByStudentId(sp.getInt("studentid"),tg.getInt("pointid"));
		if(nextsp!=null){
			Teachergrade tgs = Teachergrade.teachergrade.getPointGradeByPointId(nextsp.getInt("id").toString());
			if(tgs == null){
				map.put("nextteacherfeedback","暂无总结");
				map.put("nextquestion","暂无总结");
				map.put("nextmethod","暂无总结");
				map.put("nexthomework","暂无总结");
			}else{
				map.put("nextteacherfeedback",tgs.getStr("teacherfeedback"));
				map.put("nextquestion",tgs.getStr("question"));
				map.put("nextmethod",tgs.getStr("method"));
				map.put("nexthomework",tgs.getStr("HOMEWORK"));
			}
		}else{
			map.put("nextteacherfeedback","暂无总结");
			map.put("nextquestion","暂无总结");
			map.put("nextmethod","暂无总结");
			map.put("nexthomework","暂无总结");
		}
		content = replaceOperator(content,map);
		json.put("code", "1");
		json.put("content", content);
		return json;
	}
	
	/**
	 * 翻译周报发送
	 * @param report
	 * @param url
	 * @param tgId
	 * @param en
	 * @return
	 */
	public JSONObject getWeekMailContentUpdate(String report, String url, String tgId, boolean en){
		return getWeekMailContent(report, url, tgId, true);
	}
	
	/**
	 * 发送邮件
	 * @param toMail
	 * @param ccMail
	 * @param title
	 * @param report
	 * @param url
	 * @param tgId
	 * @return
	 */
	public JSONObject  sendWeekMail(String toMail,String ccMail,String title,String report, String url, String tgId) {
		JSONObject json = new JSONObject();
		try{
			json = getWeekMailContentUpdate(report,url,tgId,false);
			String content = "";
			if(json.get("code").equals("1"))
				content = json.getString("content");
			
			boolean flag = ToolMail.sendMail(true, toMail,ccMail, title, content, true, true);
			if(!flag){
				json.put("code", "0");
				json.put("msg", "发送失败,请检查邮箱填写正确");
			}else{
				json.put("code", "1");
				json.put("msg", "发送成功");
			}
			return json;
		}catch(Exception ex){
			json.put("code", "0");
			json.put("msg", "发送失败.");
			return json;
		}
	}
	
	/**
	 * 数据替换
	 * @param source
	 * @param paramsMap
	 * @return
	 */
	public String replaceOperator(String source , Map<String, String> paramsMap)
	{
		if(paramsMap.size() == 0 )
		{
			return source ; 
		}
		logger.info("替换页面${}值");
		StringBuffer sb = new StringBuffer();
		/*将${wangsh}的值替换掉*/
		Matcher matcher = this.escapresource.matcher(source);
		while(matcher.find())
		{
			if(paramsMap.get(matcher.group(2)) != null )
			{
				matcher.appendReplacement(sb, paramsMap.get(matcher.group(2))) ;
			}
		}
		
		matcher.appendTail(sb);
		
		return sb.toString() ; 
	}
	
	public String returnlistmap(List<CoursePlan> planlist,String type){
		StringBuffer sb = new StringBuffer();
		for(int i=0;i<planlist.size();i++){
			CoursePlan plan = planlist.get(i);
			sb.append("<tr>	                <td>").append(i+1).append("</td>	                <td>").append(plan.getStr("COURSE_TIME")).append("</td>	                <td>").append(plan.getStr("RANK_NAME")).append("</td>	                <td>").append(plan.getStr("COURSE_NAME"));
			sb.append("</td>	                <td>").append(plan.getBigDecimal("class_hour").toString()).append("</td>	                <td>").append(plan.getStr("REAL_NAME")).append("</td>	                <td>").append(plan.getInt("class_id")==0?"一对一":"小班");
			if(type.equals("0"))
				sb.append("</td>	                <td>").append(plan.getInt("iscancel")==0?"正常":"取消").append("</td>	                <td>").append(StrKit.isBlank(plan.getStr("msg"))?"":plan.getStr("msg")).append("</td>	             </tr>	                ");
			if(type.equals("1"))
				sb.append("</td>	                <td>").append(plan.getStr("campus_name")).append("</td>	                <td>").append(plan.getStr("name")).append("</td>	             </tr>	                ");
		}
		return sb.toString();
	}

	/**
	 * 发送日报
	 * @param toMail(多个以,分开)
	 * @param ccMail(多个以,分开)
	 * @param title
	 * @param report
	 * @param url
	 * @param tgId
	 */
	public JSONObject sendDayMail(String toMail,String ccMail,String title,String report, String url, String tgId) {
		JSONObject json = new JSONObject();
		try{
			String content = "";
			json = getDayReportContentUpdate(report,url,tgId);
			if(json.getString("code").equals("1")){
				content = json.getString("content");
			}
			
			boolean flag = ToolMail.sendMail(true, toMail,ccMail, title, content, true, true);
			if(!flag){
				json.put("code", "0");
				json.put("msg", "发送失败,请检查邮箱填写正确");
			}else{
				json.put("code", "1");
				json.put("msg", "发送成功");
			}
			return json;
		}catch(Exception ex){
			json.put("code", "0");
			json.put("msg", "发送失败.");
			return json;
		}
		
	}
	
	/**
	 * 转换日报文本格式
	 * @param report
	 * @param url
	 * @param tgId
	 * @return
	 */
	public JSONObject getDayReportContent(String report,String url,String tgId){
		JSONObject json = new JSONObject();
		String content = report.replace("/n", "").replace("section{margin:20px 0}", "section{margin:50px 0}").replace("/images/logo/logo_menu.png", url+"/images/logo/logo_menu.png");
		
		Map<String,String> map = new HashMap<String,String>();
		map.put("url", url);
		Teachergrade tg = Teachergrade.teachergrade.findById(tgId);
		if(tg!=null){
			map.put("tgATTENTION", tg.getStr("ATTENTION")==null?"":tg.getStr("ATTENTION"));
			map.put("tgUNDERSTAND", tg.getStr("UNDERSTAND")==null?"":tg.getStr("UNDERSTAND"));
			map.put("tgSTUDYMANNER", tg.getStr("STUDYMANNER")==null?"":tg.getStr("STUDYMANNER"));
			map.put("tgSTUDYTASK", tg.getStr("STUDYTASK")==null?"":tg.getStr("STUDYTASK"));
			map.put("tgCOURSE_DETAILS", tg.getStr("COURSE_DETAILS")==null?"":tg.getStr("COURSE_DETAILS"));
			map.put("tgHOMEWORK", tg.getStr("HOMEWORK")==null?"":tg.getStr("HOMEWORK"));
			map.put("tgquestion", tg.getStr("question")==null?"":tg.getStr("question"));
			map.put("tgmethod", tg.getStr("method")==null?"":tg.getStr("method"));
		}else{
			json.put("code", "0");
			json.put("msg", "报告不存在，发送失败.");
			return json;
		}
		Organization organization = Organization.dao.findFirst("SELECT * FROM crm_organization");
		map.put("tel", organization.getStr("tel"));
		map.put("email", organization.getStr("email"));
		map.put("web", organization.getStr("web"));
		CoursePlan plan = CoursePlan.coursePlan.getCoursePlan(tg.getInt("COURSEPLAN_ID").toString());//course_name,course_time
		if(plan!=null){
			map.put("plancourse_time", ToolDateTime.format(plan.getDate("course_time"),"yyyy-MM-dd"));
			map.put("plancourse_name", plan.getStr("course_name"));
		}else{
			json.put("code", "0");
			json.put("msg", "课程不存在,发送失败.");
			return json;
		}
		
		Integer stuid = tg.getInt("studentid");
		CourseOrder co = CourseOrder.dao.getStudentHours(stuid.toString());//allhour,real_name
		map.put("corderreal_name", co.getStr("real_name"));
		map.put("corderallhour", co.getDouble("allhour").toString());
		
		
		Map<String,Date> nowmap = new HashMap<String,Date>();
		nowmap.put("start", null);
		nowmap.put("end", plan.getDate("COURSE_TIME"));
		Double usedplanhours = CoursePlan.coursePlan.getStudentUsedCoursePlanHours(stuid,nowmap);//used
		Double usedhourspx = ((usedplanhours/co.getDouble("allhour")*100));
		map.put("usedHours",usedplanhours.toString());
		map.put("usedhourpx", usedhourspx.toString());
		
		Double leftHours = (co.getDouble("allhour")-usedplanhours);
		Double lefthourspx = (leftHours/co.getDouble("allhour"))*100;
		map.put("leftHours",leftHours.toString());
		map.put("lefthourpx", lefthourspx.toString());
		content = replaceOperator(content,map);
		json.put("code", "1");
		json.put("content", content);
		return json;
	}
	/**
	 * 转换翻译日报文本格式
	 * @param report
	 * @param url
	 * @param tgId
	 * @return
	 */
	public JSONObject getDayReportContentUpdate(String report,String url,String tgId){
		JSONObject json = new JSONObject();
		String content = report.replace("/n", "").replace("section{margin:20px 0}", "section{margin:50px 0}").replace("/images/logo/logo_menu.png", url+"/images/logo/logo_menu.png");
		
		Map<String,String> map = new HashMap<String,String>();
		map.put("url", url);
		GradeUpdate tg = GradeUpdate.dao.findById(tgId);
		if(tg!=null){
			map.put("tgATTENTION", tg.getStr("ATTENTION")==null?"":tg.getStr("ATTENTION"));
			map.put("tgUNDERSTAND", tg.getStr("UNDERSTAND")==null?"":tg.getStr("UNDERSTAND"));
			map.put("tgSTUDYMANNER", tg.getStr("STUDYMANNER")==null?"":tg.getStr("STUDYMANNER"));
			map.put("tgSTUDYTASK", tg.getStr("STUDYTASK")==null?"":tg.getStr("STUDYTASK"));
			map.put("tgCOURSE_DETAILS", tg.getStr("COURSE_DETAILS")==null?"":tg.getStr("COURSE_DETAILS"));
			map.put("tgHOMEWORK", tg.getStr("HOMEWORK")==null?"":tg.getStr("HOMEWORK"));
			map.put("tgquestion", tg.getStr("question")==null?"":tg.getStr("question"));
			map.put("tgmethod", tg.getStr("method")==null?"":tg.getStr("method"));
		}else{
			json.put("code", "0");
			json.put("msg", "报告不存在，发送失败.");
			return json;
		}
		Organization organization = Organization.dao.findFirst("SELECT * FROM crm_organization");
		map.put("tel", organization.getStr("tel"));
		map.put("email", organization.getStr("email"));
		map.put("web", organization.getStr("web"));
		CoursePlan plan = CoursePlan.coursePlan.getCoursePlan(tg.getInt("COURSEPLAN_ID").toString());//course_name,course_time
		if(plan!=null){
			map.put("plancourse_time", ToolDateTime.format(plan.getDate("course_time"),"yyyy-MM-dd"));
			map.put("plancourse_name", plan.getStr("course_name"));
		}else{
			json.put("code", "0");
			json.put("msg", "课程不存在,发送失败.");
			return json;
		}
		
		Integer stuid = tg.getInt("studentid");
		CourseOrder co = CourseOrder.dao.getStudentHours(stuid.toString());//allhour,real_name
		map.put("corderreal_name", co.getStr("real_name"));
		map.put("corderallhour", co.getDouble("allhour").toString());
		
		
		Map<String,Date> nowmap = new HashMap<String,Date>();
		nowmap.put("start", null);
		nowmap.put("end", plan.getDate("COURSE_TIME"));
		Double usedplanhours = CoursePlan.coursePlan.getStudentUsedCoursePlanHours(stuid,nowmap);//used
		Double usedhourspx = ((usedplanhours/co.getDouble("allhour")*100));
		map.put("usedHours",usedplanhours.toString());
		map.put("usedhourpx", usedhourspx.toString());
		
		Double leftHours = (co.getDouble("allhour")-usedplanhours);
		Double lefthourspx = (leftHours/co.getDouble("allhour"))*100;
		map.put("leftHours",leftHours.toString());
		map.put("lefthourpx", lefthourspx.toString());
		content = replaceOperator(content,map);
		json.put("code", "1");
		json.put("content", content);
		return json;
	}

	/**获取周报模版名称**/
	public String getTemplateWeeklyName(){
		if(StrKit.isBlank(TEMPLATE_WEEKLY_NAME)){
			Organization init = Organization.dao.getOrganizationMessage();
			TEMPLATE_WEEKLY_NAME = init.getStr("template_weekly_name");
			if(StrKit.isBlank(TEMPLATE_WEEKLY_NAME))
				setTemplateWeeklyName("weekreport");
		}
		return TEMPLATE_WEEKLY_NAME;
	}
	
	/**设置新周报模版名称**/
	public void setTemplateWeeklyName(String template_weekly_name){
		Organization init = Organization.dao.getOrganizationMessage();
		init.set("template_weekly_name", template_weekly_name);
		init.update();
		TEMPLATE_WEEKLY_NAME = template_weekly_name;
	}
	
}
