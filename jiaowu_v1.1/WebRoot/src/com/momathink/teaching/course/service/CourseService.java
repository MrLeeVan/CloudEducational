
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

package com.momathink.teaching.course.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.aop.Before;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.jfinal.upload.UploadFile;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolImport;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.sys.leave.model.StudentAskingLeave;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;
import com.momathink.teaching.subject.service.ImportCourse;
import com.momathink.teaching.teacher.model.Teachergrade;

public class CourseService extends BaseService {
	
	public static final CourseService me = new CourseService();
	

	public void list(SplitPage splitPage) {
		String select = "SELECT c.*,s.SUBJECT_NAME ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" FROM course c LEFT JOIN `subject` s ON c.SUBJECT_ID=s.Id WHERE c.SUBJECT_ID != 0 ");
		if (null == queryParam) {
			return;
		}

		String coursename = queryParam.get("coursename");
		String subjectid = queryParam.get("subjectid");
		if (null != coursename && !coursename.equals("")) {
			formSqlSb.append(" AND c.course_name like ? ");
			paramValue.add("%" + coursename + "%");
		}
		if (null != subjectid && !subjectid.equals("")) {
			formSqlSb.append(" AND c.subject_id =? ");
			paramValue.add(Integer.parseInt(subjectid));
		}
		formSqlSb.append(" ORDER BY c.id,c.subject_id");
	}
	
	public List<Record> getCoursePlanDay(String courseTime, Integer campusId) {
		return CoursePlan.dao.getCoursePlanDay(courseTime,campusId);
	}
	@Before(Tx.class)
	public void save(Course course) {
		try {
			course.set("create_time", ToolDateTime.getDate());
			course.save();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("添加公司异常");
		}
	}
	
	public List<TimeRank> getTimeRank(){
		return TimeRank.dao.getTimeRanks();
	}
	
	@Before(Tx.class)
	public void update(Course course) {
		try {
			course.set("update_time", new Date());
			course.update();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public List<Course> getVIPStuCourse(String courseIds) {
		String[] arrCourses = courseIds.replace("|", ",").split(",");
		List<Course> list = Course.dao.getVIPStuCourse(arrCourses);
		return list;
	}

	@SuppressWarnings("unused")
	public List<CoursePlan> getCoursePlansByStuId(String stuId) {
		List<CoursePlan> lists = CoursePlan.coursePlan.getCoursePlansByStuId(stuId);
		for(int i=0;i<lists.size();i++){
			if(lists==null)
				lists.remove(i);
		}
		return lists;
	}

	public static List<CoursePlan> circleCoursePlan(List<CoursePlan> list){
		for(int i=0;i<list.size();i++){
			if(list.get(i).getInt("CLASS_ID")!=0){
				if(i<list.size()-1){
					if(list.get(i).getStr("COURSE_TIME").equals(list.get(i+1).getStr("COURSE_TIME")) 
							&& list.get(i).getInt("CLASS_ID").equals(list.get(i+1).getInt("CLASS_ID")) 
							&& list.get(i).getInt("TIMERANK_ID").equals(list.get(i+1).getInt("TIMERANK_ID"))){
						list.remove(i+1);
						circleCoursePlan(list);
					}
				}
				
			}
		}
		return list;
	}
	
	public List<CoursePlan> getCoursePlansBetweenDates(String stuId, String tId, String startDate, String endDate,String courseType) {
		List<CoursePlan> list = new ArrayList<CoursePlan>();
		List<CoursePlan> cplist = CoursePlan.coursePlan.getStuCoursePlansBetweenDates(stuId,startDate,endDate);
		List<CoursePlan> tlist = CoursePlan.coursePlan.getCoursePlansByTeacherId(tId,startDate,endDate);
		if(courseType.equals("0")){//课程
			Iterator<CoursePlan> iter = cplist.iterator();
			while(iter.hasNext()){
				CoursePlan plan = iter.next();
				if(plan.getInt("CLASS_ID")!=0){
					iter.remove();
				}
			}
		}else{//模考
			return cplist;
		}
		
		for(int i=0;i<cplist.size();i++){
			list.add(cplist.get(i));
		}
		Iterator<CoursePlan> iter = tlist.iterator();
		while(iter.hasNext()){
			CoursePlan cp = iter.next();
			for(int i=0;i<list.size();i++){
				if(list.get(i).getInt("ID").equals(cp.getInt("ID"))){
					iter.remove();
				}
			}
		}
		for(int i=0;i<tlist.size();i++){
			list.add(tlist.get(i));
		}
		return list;
	}
	
	/**学生 请假占用的 课程表*/
	public List<StudentAskingLeave> queryByStudentAskingLeave(String stuId, String startDate, String endDate) {
		List<StudentAskingLeave> stuLeaves =  StudentAskingLeave.dao.queryByStudentid(stuId, startDate, endDate+" 59:59");
		List<TimeRank> timeranks = TimeRank.dao.getTimeRank();
		for (StudentAskingLeave stuLeave : stuLeaves) {
			List<Record> dayTimes = new ArrayList<Record>();
			String starttime = stuLeave.get("starttime").toString();
			String endtime = stuLeave.get("endtime").toString();
			
			List<String> printDay = ToolDateTime.printDay(ToolDateTime.parse(starttime, ToolDateTime.pattern_ymd_hm), ToolDateTime.parse(endtime, ToolDateTime.pattern_ymd_hm));
			starttime = starttime.substring(11);
			endtime = endtime.substring(11);
			if(printDay.size() == 1){
				toolDayTim(timeranks, dayTimes, (starttime + "-" + endtime), printDay.get(0));
			}else{
				for (int i = 0; i < printDay.size() - 1; i++) {
					toolDayTim(timeranks, dayTimes, (starttime + "-59:59"), printDay.get(i));
				}
				toolDayTim(timeranks, dayTimes, ("00:00-" + endtime), printDay.get(printDay.size() - 1));
			}
			stuLeave.put("DAYTIMES", dayTimes);
		}
		return stuLeaves;
	}
	
	/** 判断 时间 大小 并状态 */
	private void toolDayTim(List<TimeRank> timeranks, List<Record> dayTimes, String time, String day) {
		List<Integer> timeRankId = new ArrayList<Integer>();
		for (TimeRank timeRank : timeranks) {
			String timeDb = timeRank.getStr("RANK_NAME");
			String[] timeDbs = timeDb.split("-");
			String[] times = time.split("-");
			if(times[0].compareTo(timeDbs[0]) <= 0 && times[1].compareTo(timeDbs[1]) >= 0){
				timeRankId.add(timeRank.getInt("id"));
			}else if(times[0].compareTo(timeDbs[1]) < 0 && times[1].compareTo(timeDbs[0]) > 0){
				timeRankId.add(timeRank.getInt("id"));
			}
		}
		dayTimes.add(new Record().set("DAY", day).set("TIMERANKID", timeRankId));
	}

	public List<CoursePlan> getCoursePlansByDay(String courseTime, String studentId, String teacherId) {
		List<CoursePlan> studentCoursePlanList = CoursePlan.coursePlan.getCoursePlansByDay(courseTime,studentId);//获取学生小班的排课信息
		Student student = Student.dao.findById(studentId);
		if(student.getInt("STATE").toString().equals("2")){//等于2是小班
			ClassOrder classorder = ClassOrder.dao.findByXuniId(student.getInt("Id"));//根据虚拟ID查询小班
			List<CourseOrder> ablist = CourseOrder.dao.findOrderByClassId(classorder.getInt("Id"));//查询班次课程信息列表
			if(ablist.size()>0){
				for(CourseOrder ab:ablist){//遍历列表
					if(!ab.getInt("studentid").toString().equals(studentId)){//检索与学生相关的信息
						List<CoursePlan> stulist = CoursePlan.coursePlan.getCoursePlansByDay(courseTime,ab.getInt("studentid").toString());//根据时间和学生ID查询学生课表信息
						if(stulist.size()>0){
							studentCoursePlanList.addAll( stulist );
						}
					}
				}
			}
		}else{//1对1排课
			List<AccountBanci> ablist = AccountBanci.dao.findAllByAccountId(studentId);
			if(ablist.size()>0){
				for(AccountBanci ab:ablist){
					List<CoursePlan> stulist = CoursePlan.coursePlan.getCoursePlansByDay(courseTime,student.getPrimaryKeyValue(),ab.getInt("banci_id"));
					if(stulist.size()>0){
						studentCoursePlanList.addAll( stulist );
					}
				}
			}
			
		}
		List<CoursePlan> tcpListDay = CoursePlan.coursePlan.getTeacherCoursePlansByDay(courseTime, teacherId);
		//老师和学生的排课无重复并集 （老师已排课程列表中移除与学生排课重复的(同一次课程)的课程 ，再做并集）
		tcpListDay.removeAll( studentCoursePlanList );
		studentCoursePlanList.addAll( tcpListDay );
		return studentCoursePlanList;
	}
	/**
	 * 获得小班课程
	 * @param banciId
	 * @param tId
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<CoursePlan> getClassCoursePlansBetweenDates(String banciId, String tId, String startDate, String endDate) {
		List<CoursePlan> list = new ArrayList<CoursePlan>();
		List<CoursePlan> cplist = CoursePlan.coursePlan.getClassCoursePlansBetweenDates(banciId,startDate,endDate);//班课
		List<CoursePlan> tlist = CoursePlan.coursePlan.getCoursePlansByTeacherId(tId,startDate,endDate);//老师的课程
		Iterator<CoursePlan> it = tlist.iterator();
		while(it.hasNext()){//遍历老师的课程
			CoursePlan cplan = it.next();
			if(cplan.getInt("CLASS_ID")!=0 && cplan.getInt("STATE")==0){//去除小班课，留下学生在班级所上的课程和班课
				it.remove();
			}
		}
		
		for(int i=0;i<cplist.size();i++){//取出班课添加到集合
			list.add(cplist.get(i));
		}
		Iterator<CoursePlan> iter = tlist.iterator();//遍历学生在班级所上的课程和班课
		while(iter.hasNext()){
			CoursePlan cp = iter.next();
			for(int i=0;i<list.size();i++){
				if(list.get(i).getInt("ID").equals(cp.getInt("ID"))){
					iter.remove();//去除班级课程
				}
			}
		}
		for(int i=0;i<tlist.size();i++){
			list.add(tlist.get(i));
		}
		return list;
	}


	public List<Map<String, Object>> getTeacherWeekDayRestRankId(String tId,Date parse, String dateInWeek) {
		List<CoursePlan> plan = CoursePlan.coursePlan.queryDayRestCount(ToolDateTime.format(parse, "yyyy-MM-dd"), tId);
		if(plan.size()>0){
			List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
			List<TimeRank> trlist = TimeRank.dao.getTimeRank();
			for(CoursePlan cp : plan){
				Integer st = Integer.parseInt(cp.getStr("startrest").replace(":", ""));
				Integer et = Integer.parseInt(cp.getStr("endrest").replace(":", ""));
				for(int j=0;j<trlist.size();j++){
					int ft = Integer.parseInt(trlist.get(j).getStr("RANK_NAME").split("-")[0].replaceAll(":", ""));
					int lt = Integer.parseInt(trlist.get(j).getStr("RANK_NAME").split("-")[1].replaceAll(":", ""));
					if((ft<=st&&lt>st)||(ft>=st&&lt<=et)||(ft<et&&lt>=et)){
						Map<String,Object> map = new LinkedHashMap<String, Object>();
						map.put("timeId", trlist.get(j).getInt("ID"));
						map.put("rankname", trlist.get(j).getStr("RANK_NAME"));
						map.put("day", parse);
						list.add(map);
					}
				}
				
			}
			return list;
		}else{
			return null;
		}
	}

	/**
	 * 课程列表
	 * @param stuid
	 * @param classid
	 * @param type 1一对一;2小班
	 * @param courseType 0课程；1模考
	 * @return
	 */
	public List<Record> getStudentOrClassCourse(String stuid,String classid,String type,String courseType){
		StringBuffer sb = new StringBuffer();
		if(type.equals("1")){
			if(courseType.equals("0"))
				sb.append("SELECT distinct course.course_name,course.Id courseid FROM course WHERE FIND_IN_SET(course.id ,(SELECT (GROUP_CONCAT(DISTINCT course_id)) subids FROM user_course WHERE account_id=").append(stuid).append(" AND tech_type = 1 )) AND course.STATE = 0");
			if(courseType.equals("1"))
				sb.append("SELECT subject.Id,subject.SUBJECT_NAME FROM subject WHERE FIND_IN_SET(subject.Id, (SELECT REPLACE (GROUP_CONCAT(DISTINCT subjectids),'|',',') subids FROM crm_courseorder WHERE crm_courseorder.studentid=").append(stuid).append(")) AND subject.STATE=0");
		}
		if(type.equals("2")){
			if(courseType.equals("0"))
				sb.append(" select distinct c.course_name,c.Id courseid from banci_course bc left join course c on c.id=bc.course_id where banci_id=").append(classid).append(" and c.state = 0  ");
			if(courseType.equals("1"))
				sb.append(" SELECT subject.Id,subject.SUBJECT_NAME FROM subject WHERE FIND_IN_SET(subject.Id ,(SELECT GROUP_CONCAT(DISTINCT bc.subject_id) FROM banci_course bc WHERE  bc.banci_id=").append(classid).append(")) and subject.STATE=0 ");
		}
 		return Db.find(sb.toString());
	}

	/**
	 * 保存点名结果
	 */
	public void saveCallNameMessage(String cpid, String[] remark,
			String[] singn, String[] studentids) {
		for (int i = 0; i < studentids.length; i++) {
			Teachergrade tg = Teachergrade.teachergrade.findByCoursePlanIdAndStudentid(cpid, studentids[i]);
			if (tg == null) {
				Teachergrade t = new Teachergrade();
				t.set("courseplan_id", cpid).set("studentid", studentids[i]).set("singn", singn[i]).set("singnremark", remark[i])
						.set("demohour", new Date()).save();
				Db.update("insert into teachergrade_update select * from teachergrade where id =? ", t.getPrimaryKeyValue());
			} else {
				tg.set("courseplan_id", cpid).set("studentid", studentids[i]).set("singn", singn[i]).set("singnremark", remark[i]).update();
			}
			//accountService.consumeCourse(Integer.parseInt(cpid), Integer.parseInt(studentids[i]), sysuserid, 1);
		}
	}
	
	/**
	 * 保存导入
	 * @param subjectids 
	 */
	public static  String importSubjects(UploadFile file,Integer createuserid,Integer courseid, String[] subjectids) {
		// 获取文件
		String msg = "导入失败,请检查数据格式是否正确";
		try {
			//path = 文件目录 + 文件名称
			String fileName = file.getFileName();
			//判断后缀是否已xls
			if(fileName.toLowerCase().endsWith("xls")){
				// 处理导入数据
				Map<String, Object> flagList = ToolImport.dealDataByPath(file.getFile(), ImportCourse.tabMap, ImportCourse.mustTab);
				//
				boolean flag = (boolean) flagList.get("flag");
				if (!flag) {
				} else {
					@SuppressWarnings("unchecked")
					List<Map<String, String>> list = (List<Map<String, String>>) flagList.get("list"); // 分析EXCEL数据
					
					Map<String, Object> saveMsg =  forAddXLSDB(list,createuserid,courseid,subjectids);
					
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
	 * @param subjectids 
	 * @return
	 */
	public static  Map<String,Object> forAddXLSDB( List<Map<String, String>> list,Integer createuserid,Integer courseid, String[] subjectids){
		Map<String, Object> saveMsg = new HashMap<String, Object>();
		StringBuffer msg = new StringBuffer();
		int save = 0;
		String key = null;
		String value = null;
		
		try {
			for (String subjectid : subjectids) {
				Subject subject = Subject.dao.findById(subjectid);
				String subjectName = subject.getStr("SUBJECT_NAME");
				for (Map<String, String> map : list) { // 遍历取出的数据，并保存
					Course course = new Course();
					for (Map.Entry<String, String> entry : map.entrySet()) {
						key = entry.getKey();
						value = entry.getValue();
						if(StrKit.notBlank(value))
							value = value.trim();
						course.set(key, value );
					}
					try{
						course.set("COURSE_NAME", subjectName + "-" + course.get("COURSE_NAME"));
						course.set("SUBJECT_ID", subjectid);
						course.set("INTRO", "导入");
						course.set("CREATE_TIME", new Date());
						Long courseCount = Db.queryLong("Select COUNT(*) FROM course where COURSE_NAME = ?",course.get("COURSE_NAME"));
						if(courseCount == 0){
							boolean saveflag = course.save();//bookUser保存到数据库
							if(saveflag){
								save++;//保存几条数据
							}else{
								msg.append("第:"+ (save+1) +"  条信息存入失败");
								msg.append("<br>");
							}
						}
					}catch(Exception ex){
						String exStr = ex.getLocalizedMessage();
						exStr = exStr.substring(exStr.indexOf(":"));
						msg.append("第:"+ (save+1) +"  条信息存入异常" + exStr);
						msg.append("<br>");
						ex.printStackTrace();
					}
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
