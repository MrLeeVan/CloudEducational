
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

package com.momathink.teaching.grade.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.operator.model.Role;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.grade.model.FenZhi;
import com.momathink.teaching.grade.model.GradeDetail;
import com.momathink.teaching.grade.model.GradeRecord;
import com.momathink.teaching.grade.service.GradeRecordService;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;
import com.momathink.teaching.subject.service.SubjectService;

/**
 * 成绩管理
 * 
 * @author David
 *
 */
@Controller(controllerKey = "/grade")
public class GradeController extends BaseController {

	private static Logger log = Logger.getLogger(GradeController.class);
	private SubjectService subjectService = new SubjectService();
	private GradeRecordService gradeRecordService = new GradeRecordService();

	/**
	 * 跳转添加成绩页面
	 */
	public void addGradeRecord() {
		if (!StringUtils.isEmpty(getPara())) {
			Student student = Student.dao.findById(Integer.parseInt(getPara()));
			setAttr("student", student);
		}
		List<Subject> subjectList = subjectService.findAvailableSubject();
		setAttr("subjectList", subjectList);
		renderJsp("/grade/grade_form.jsp");
	}

	/**
	 * 保存成绩记录
	 */
	public void saveGradeRecord() {
		GradeRecord gradeRecord = getModel(GradeRecord.class);
		Student student = Student.dao.findById(gradeRecord.getInt("studentId"));
		if (student != null) {
			List<GradeDetail> detailList = null;
			List<Course> courseList = Course.dao.findBySubjectId(gradeRecord.getInt("subjectId"));
			if (gradeRecord.getBoolean("hasDetail")) {
				detailList = new ArrayList<GradeDetail>();
				float total = 0;
				for (Course course : courseList) {
					Integer courseId = course.getInt("id");
					String courseName = course.getStr("course_name");
					total += Float.parseFloat((StringUtils.isEmpty(getPara("score_" + courseId)) ? "0" : getPara("score_" + courseId)));
					GradeDetail detail = new GradeDetail();
					detail.set("courseid", courseId);
					detail.set("coursename", courseName);
					detail.set("subjectId", gradeRecord.getInt("subjectId"));
					detail.set("subjectname", gradeRecord.getStr("subjectName"));
					detail.set("score", getPara("score_" + courseId));
					detailList.add(detail);
				}
				if (total > 0)
					gradeRecord.set("grossscore", total);
			}
			gradeRecordService.saveGradeInfo(gradeRecord, detailList);
		} else {
			log.info("学生不存在");
		}
		redirect("/grade/index");
	}

	/**
	 * 删除成绩记录
	 */
	public void delGradeRecord() {
		try {
			if (getParaToInt("recordId") != null) {
				gradeRecordService.deleteByRecordId(getParaToInt("recordId"));
				renderJson("result", "true");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 根据成绩记录查看分数明细
	 */
	public void queryGradeDetail() {
		JSONObject json = new JSONObject();
		String recordId = getPara("recordId");
		GradeRecord record = GradeRecord.dao.findById(Integer.parseInt(recordId));
		List<GradeDetail> detailList = GradeDetail.dao.findbyRecordId(recordId);
		if (detailList == null || detailList.size() == 0) {
			json.put("code", "0");
			json.put("msg", "成绩明细不存在");
		} else {
			json.put("code", "1");
			json.put("detail", detailList);
			json.put("record", record);
		}
		renderJson(json);
	}

	/**
	 * 计算页面传送过来的数据并且保存到数据库
	 */
	public void saveScore() {
		JSONObject json = new JSONObject();
		try {
			String r = "^[0-9]*$";
			GradeRecord graderecord = getModel(GradeRecord.class);
			int studentid = graderecord.getInt("studentid");
			String level = graderecord.getInt("leveltype").toString();
			String studentName = graderecord.getStr("studentname");
			String subjectname = graderecord.getStr("subjectname");
			int subjectid = Subject.dao.findSubjectByName(subjectname).getInt("Id");
			Date examdate = graderecord.getDate("examdate");
			graderecord.set("studentid", studentid);
			graderecord.set("studentname", studentName);
			graderecord.set("subjectid", subjectid);
			graderecord.set("scoretype",true);
			graderecord.set("hasdetail",true);
			graderecord.set("subjectname", subjectname);
			graderecord.set("examdate", examdate);
			graderecord.set("gradetype", 1);
			graderecord.set("createtime", new Date());
			graderecord.set("leveltype", level);
			List<Course> list = Course.dao.findBySubjectId((Integer.parseInt(Subject.dao.findSubjectByName(subjectname).get("id").toString())));
			for(int i=0;i<list.size();i++){
				if(list.get(i).get("COURSE_NAME").toString().indexOf("写作")!=-1){
					list.remove(i); 
				}
			}
			float grossscore = 0;
			boolean flag = false;
			List<Integer> detailids = new ArrayList<Integer>();
			for (Course course : list) {
				GradeDetail gradeDetail = new GradeDetail();
				String rightname = "c_" + course.getInt("id");
				String wrongname = "m_" + course.getInt("id");
				String correctnum = getPara(rightname);
				String wrongnum = getPara(wrongname);
				if (!correctnum.matches(r) || !wrongnum.matches(r)) {
					json.put("code", 0);
					json.put("msg", "请填写有效的题数");
					break;
				} else {
					double score = ToolArith.sub(ToolArith.mul(Integer.parseInt(correctnum), 1),
							ToolArith.mul(Integer.parseInt(wrongnum), ToolArith.div(1, 4, 2)));
					float realscore = 0;
					if (course.getStr("COURSE_NAME").indexOf("阅读") != -1 || course.getStr("COURSE_NAME").indexOf("词汇") != -1
							|| course.getStr("COURSE_NAME").indexOf("数学") != -1) {
						if (((course.get("COURSE_NAME").toString().indexOf("阅读") != -1) && (ToolArith.add(Integer.parseInt(correctnum),
								Integer.parseInt(wrongnum)) <= 40))
								|| ((course.get("COURSE_NAME").toString().indexOf("词汇") != -1) && (ToolArith.add(Integer.parseInt(correctnum),
										Integer.parseInt(wrongnum)) <= 60))
								|| ((course.get("COURSE_NAME").toString().indexOf("数学") != -1) && (ToolArith.add(Integer.parseInt(correctnum),
										Integer.parseInt(wrongnum)) <= 50))) {
							if ((course.get("COURSE_NAME").toString().indexOf("阅读") != -1) || (course.get("COURSE_NAME").toString().indexOf("词汇") != -1)
									|| (course.get("COURSE_NAME").toString().indexOf("数学") != -1)) {
								if(score<0){
									realscore=0;
								}else{
									realscore = FenZhi.dao.levelAndCourseValueFindToScorce(score, level).getFloat(
										course.get("COURSE_NAME").toString().indexOf("阅读") != -1 ? "yuedu" : (course.get("COURSE_NAME").toString()
												.indexOf("词汇") != -1 ? "cihui" : "shuxue"));
								}
							}
						} else {
							json.put("code", 0);
							json.put("msg", "正确题数或错误题数信息数据异常");
							flag = false;
							break;
						}
					}
					gradeDetail.set("subjectid", subjectid);
					gradeDetail.set("recordid", 0);
					gradeDetail.set("subjectname", subjectname);
					gradeDetail.set("courseid", course.get("id"));
					gradeDetail.set("coursename", course.get("course_name"));
					gradeDetail.set("score", ToolArith.round(realscore, 0));
					gradeDetail.set("createtime", new Date());
					gradeDetail.set("corrector", Integer.parseInt(correctnum));
					gradeDetail.set("wrong", Integer.parseInt(wrongnum));
					gradeDetail.save();
					detailids.add(gradeDetail.getInt("id"));
					flag = true;
					grossscore += realscore;
				}
			}
			if (flag) {
				graderecord.set("grossscore", grossscore);
				graderecord.set("remark", "无");
				graderecord.save();
				int recordid = graderecord.getPrimaryKeyValue();
				for (Integer ids : detailids) {
					GradeDetail detail = GradeDetail.dao.findById(ids);
					detail.set("recordid", recordid).update();
				}
				json.put("code", 1);
				json.put("msg", "保存成功");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json.put("code", 0);
			json.put("msg", "信息数据异常");
		} finally {
			renderJson(json);
		}
	}

	// 名字模糊查询
	public void getAccountByNameLike() {
		try {
			String userName = getPara("studentName");
			String loginRoleCampusIds = getAccountCampus();
			String sql = "select * from account "
					+ " where state=0 and LOCATE( (SELECT CONCAT(',', id, ',') ids FROM pt_role  WHERE numbers = 'student'), CONCAT(',', roleids) ) > 0 "
					+ " and (user_name like \"%" + userName + "%\" or real_name like \"%" + userName + "%\") ";
			if( !ToolString.isNull( loginRoleCampusIds ) ){
				sql += " and campusid in (" + loginRoleCampusIds + ")"; 
			}
			sql = sql + " order by account.Id desc";
					
			List<Account> list = Account.dao.find(sql);
			renderJson("accounts", list);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 修改成绩表
	public void toModifyScoredId() {
		try {
			String recordId = getPara();
			boolean flag=true;
			GradeRecord graderecord  = GradeRecord.dao.findById(recordId);
			if(graderecord.getBoolean("hasdetail")==true){
				setAttr("flag",flag);
				List<GradeDetail> grade = GradeDetail.dao.findbyRecordId(recordId);
				setAttr("gradeList",grade);
			}
			setAttr("graderecord", graderecord);
			setAttr("roles",Role.dao.getAllRole());
			render("/grade/grade_layer_modifyScore.jsp");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 保存修改后的数据
	public  void saveModifyScores(){
		JSONObject json = new JSONObject();
		try{
			GradeRecord  graderecord = getModel(GradeRecord.class); 
			if(graderecord.get("hasdetail")){
				int id = graderecord.getInt("id");
				List<GradeDetail> gradeDetail = GradeDetail.dao.findbyRecordId(Integer.toString(id));
				float grossscore = 0;
				for(GradeDetail grade:gradeDetail){
					String idname = "s_"+grade.get("id");
					float  score = Float.parseFloat(getPara(idname));
					grade.set("score",score);
					grade.update();
					grossscore +=score;
				}
				graderecord.set("grossscore", grossscore);
				graderecord.update();
			}else{
				graderecord.set("grossscore", graderecord.get("grossscore"));
				graderecord.update();
			}
			json.put("code",1);
			json.put("msg","更新数据成功");
		}catch(Exception e){
			e.printStackTrace();
			json.put("code",0);
			json.put("msg","更新数据失败");
		}finally{
			renderJson(json);
		}
	}
	/**
	 * 查找所有 的课程的科目
	 */
	public void getCource() {
		JSONObject json = new JSONObject();
		try {
			String subjectname = getPara("subjectname");
			List<Course> list = Course.dao.findBySubjectId((Integer.parseInt(Subject.dao.findSubjectByName(subjectname).get("id").toString())));
			for(int i=0;i<list.size();i++){
				if(list.get(i).get("COURSE_NAME").toString().indexOf("写作")!=-1){
					list.remove(i); 
				}
			}
			json.put("listCourse", list);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			renderJson(json);
		}

	}
}
