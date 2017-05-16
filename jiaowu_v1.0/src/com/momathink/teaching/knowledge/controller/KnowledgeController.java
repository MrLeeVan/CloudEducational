
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

package com.momathink.teaching.knowledge.controller;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.knowledge.model.Courseplan_knowledge;
import com.momathink.teaching.knowledge.model.Knowledge;
import com.momathink.teaching.knowledge.service.KnowledgeService;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Teachergrade;
@Controller(controllerKey="/knowledge")
public class KnowledgeController extends BaseController {
	private static final Logger logger = Logger.getLogger(KnowledgeController.class);

	public void index() {
	}

	/**
	 * 教师评价，作业页面
	 */
	public void educationalManage() {
		try {
			int id = getSysuserId();
			SysUser user = SysUser.dao.findById(id);
			String courseplanId =  getPara("courseplanId");
			CoursePlan coursePlan = CoursePlan.coursePlan.findById(Integer.parseInt(courseplanId));
			setAttr("courseplan_id", courseplanId);
			Integer campusId = coursePlan.getInt("CAMPUS_ID");
			String courseDate = coursePlan.get("COURSE_TIME").toString().substring(0, 10);
			Integer rankTime = coursePlan.getInt("TIMERANK_ID");
			List<Student> slist = CoursePlan.coursePlan.getStudentByPlanId(coursePlan.getPrimaryKeyValue());
			setAttr("courseDate",courseDate);
			setAttr("campusId",campusId);
			setAttr("rankTime",rankTime);
			setAttr("assessment",1);
			if(coursePlan.getInt("class_id")!=0){//查看小班是否需要教师评价
				ClassOrder classOrder = ClassOrder.dao.findById(coursePlan.getInt("class_id"));
				setAttr("assessment",classOrder.getInt("is_assesment"));
			}
			setAttr("stu", slist);
			setAttr("course_id", coursePlan.get("COURSE_ID"));
			setAttr("coursename", coursePlan.get("coursename"));
			setAttr("class_num", coursePlan.get("classNum"));
			setAttr("banciId",coursePlan.get("CLASS_ID"));
			setAttr("record", coursePlan);
			setAttr("returnUrl", "%2Fknowledge%2FeducationalManage");
			setAttr("studentId", coursePlan.get("student_id"));
			setAttr("teachertostu", KnowledgeService.me.getTeachertostu());
			List<Teachergrade>  tg = Teachergrade.teachergrade.getGradeByCoursePlanIds(courseplanId);
			if(tg.isEmpty()){
				setAttr("code",1);
			}else{
				setAttr("tg",tg.get(0));
			}
			if(Role.isTeacher(user.getStr("roleids"))){
				renderJsp("/account/teacher_educational.jsp");
			}else if(Role.isStudent(user.getStr("roleids"))){
				if(!tg.isEmpty()){
					for(Teachergrade t :tg){
						if(t.getInt("studentid")==id){
							setAttr("t",t);
							break;
						}
					}
				}
				renderJsp("/account/student_educational.jsp");
			}else{
				renderJsp("/account/teacher_educational.jsp");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			renderError(404);
		}
	}
	/**
	 * 排课列表
	 * @author prq
	 */
	public void getCourseplanMsg() {
		try {
			String courseplanId = (getPara("courseplanId") == null || getPara("courseplanId") == "") ? getPara(0) : getPara("courseplanId");
			String sql = "select date_format(courseplan.course_time,'%Y-%m-%d') as coursetime, course.course_name as coursename,classroom.NAME as classname,"
					+ " time_rank.rank_name as timename, teacher.real_name  as teachername ,student.real_name as studentname,courseplan.student_id, "
					+ " courseplan.SIGNIN as signin, student.id as studentId , teacher.id as teatcherId,campus.campus_name as campusName ,"
					+ " courseplan.Id,courseplan.COURSE_ID,class_order.classNum "
					+ " from  courseplan "
					+ " left join course on courseplan.course_id=course.id "
					+ " left join account as student on courseplan.student_id=student.id  "
					+ " left join account as teacher on courseplan.teacher_id=teacher.id "
					+ " left join time_rank on courseplan.TIMERANK_ID=time_rank.id "
					+ " left join campus on courseplan.campus_id=campus.id "
					+ " left join classroom on courseplan.ROOM_ID=classroom.id "
					+ " LEFT JOIN class_order ON courseplan.class_id = class_order.id WHERE 1=1 AND courseplan.Id = ?  ";
			Record record = Db.findFirst(sql, courseplanId);
			setAttr("record",record);
			renderJsp("/account/courseplanmsg.jsp");
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 查出本科目所有的知识点
	 */
	public void getEducationalManage() {
		// 获取科目
		try {
			String course_id = getPara("course_id");
			// 查询出本科目所有的知识点
			String sql = "select * from knowledge where course_id=" + course_id;
			renderJson(Knowledge.knowledge.find(sql));
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 查出本科目已经安排好的知识点
	 */
	public void getAlreadyEducational() {
		// 获取科目
		try {
			// 查询出本科目所有的知识点
			String courseplan_id = getPara("courseplan_id");
			String sql = "select * from courseplan_knowledge where courseplan_id=" + courseplan_id + "";
			Courseplan_knowledge courseplan_Knowledge = getModel(Courseplan_knowledge.class);
			List<Courseplan_knowledge> l = courseplan_Knowledge.find(sql);
			/*
			 * List<Knowledge> list = new ArrayList<Knowledge>(); for(int i = 0
			 * ; i<l.size(); i++){
			 * list.add(Knowledge.knowledge.findById(l.get(i)
			 * .get("KNOWLEDGE_ID"))); }
			 */
			renderJson("knowledgeList", l);
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 保存科目与排好的知识点的对应关系
	 */
	public void saveCourseIdToKnowledgeId() {
		try {
			String courseplan_id = getPara("courseplan_id");
			String knowledge_list = getPara("knowledge_list");
			String knowledge_name = "";
			String parentSql;
			// 清空表中的数据
			String sql = "delete from courseplan_knowledge where COURSEPLAN_ID=" + Integer.parseInt(courseplan_id);
			Db.update(sql);
			// 保存科目与排好的知识点的对应关系
			String knowledge_names = "";
			if (knowledge_list.trim() != "") {
				String[] knowledges = knowledge_list.split(",");
				for (int i = 0; i < knowledges.length; i++) {
					String aa = "select * from knowledge where id=" + Integer.parseInt(knowledges[i]);
					List<Record> records = Db.find(aa);
					Courseplan_knowledge courseplan_Knowledge = getModel(Courseplan_knowledge.class);
					courseplan_Knowledge.set("courseplan_id", courseplan_id);
					courseplan_Knowledge.set("knowledge_id", knowledges[i]);
					parentSql = "select name from knowledge where id=" + records.get(0).getInt("parent_Id") + "";
					List<Record> Parentrecord = Db.find(parentSql);
					knowledge_name = Parentrecord.get(0).getStr("name") + "   " + records.get(0).getStr("name");
					courseplan_Knowledge.set("knowledge_name", knowledge_name);
					courseplan_Knowledge.save();
					if (i == knowledges.length - 1) {
						knowledge_names += records.get(0).getStr("name") + "";
					} else {
						knowledge_names += records.get(0).getStr("name") + "<br>";
					}
				}
			}
			String ss = "update courseplan set knowledge_names='" + knowledge_names + "' where id=" + Integer.parseInt(courseplan_id);
			Db.update(ss);
			renderJson("success", "success");
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 获取Knowledge中所有对应course的数据
	 */
	public void getKnowledgeByCourseID() {
		try {
			String courseID = getPara("courseID");
			String sql = "select a.* ,count(a.id) node_num,sum(b.id) node_sum from (select * from knowledge  where COURSE_ID=" + courseID
					+ " and PARENT_ID is null ) a left join  knowledge b on a.id=b.parent_id GROUP by a.id";
			renderJson("knowledgeList", Knowledge.knowledge.find(sql));
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 获取子目录的数据
	 */
	public void getChildCatalogue() {
		try {
			String parentid = getPara("parentid");
			String sql = "select * from knowledge where PARENT_ID=" + parentid + "";
			renderJson(Knowledge.knowledge.find(sql));
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 保存Knowledge数据
	 */
	public void saveKnowledge() {
		try {
			String knowledge_name = getPara("knowledge_name");
			String courseID = getPara("liuCourse");
			String parent_describe = getPara("parent_describe");
			String parentid = getPara("parentid");
			Knowledge saveKnowledge = getModel(Knowledge.class);
			saveKnowledge.set("name", knowledge_name);
			saveKnowledge.set("course_id", courseID);
			saveKnowledge.set("describe", parent_describe);
			if (parentid == null || "".equals(parentid)) {
			} else {
				saveKnowledge.set("parent_id", parentid);
			}
			saveKnowledge.save();
			renderJson("aaa", "bbb");
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 保存Knowledge子目录数据
	 */
	public void saveChildKnowledge() {
		try {
			String knowledge_name = getPara("knowledge_name");
			String courseID = getPara("liuCourse");
			String parent_describe = getPara("parent_describe");
			String parentid = getPara("parentid");
			Knowledge saveKnowledge = getModel(Knowledge.class);
			saveKnowledge.set("name", knowledge_name);
			saveKnowledge.set("course_id", courseID);
			saveKnowledge.set("describe", parent_describe);
			if (parentid == null || "".equals(parentid)) {
			} else {
				saveKnowledge.set("parent_id", parentid);
			}
			saveKnowledge.save();
			renderJson(saveKnowledge);
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 删除Knowledge数据
	 */
	public void deleteKnowledge() {
		try {
			String knowledge_ID = getPara("knowledge_ID");
			Knowledge deleteKnowledge = getModel(Knowledge.class);
			deleteKnowledge.deleteById(Integer.parseInt(knowledge_ID));
			renderJson("aaa", "bbb");
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 修改Knowledge数据
	 */
	public void updateKnowledge() {
		try {
			String knowledge_name = getPara("knowledge_name");
			String courseID = getPara("liuCourse");
			String knowledge_ID = getPara("knowledge_ID");
			String parent_describe = getPara("parent_describe");
			Knowledge updateKnowledge = getModel(Knowledge.class);
			updateKnowledge.set("id", knowledge_ID);
			updateKnowledge.set("name", knowledge_name);
			updateKnowledge.set("course_id", courseID);
			updateKnowledge.set("describe", parent_describe);
			updateKnowledge.update();
			String sql = "select * from knowledge where ID=" + Integer.parseInt(knowledge_ID);
			List<Record> records = Db.find(sql);
			renderJson(records);
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}

	/**
	 * 查询Knowledge子目录的数据
	 */
	public void selectChildKnowledge() {
		try {
			String parent_id = getPara("parentid");
			String sql = "select * from knowledge where PARENT_ID=" + Integer.parseInt(parent_id);
			List<Record> records = Db.find(sql);
			renderJson(records);
		} catch (Exception e) {
			logger.error(e.toString());
		}
	}
	
	/**
	 * 获取学生的评价信息*
	 */
	public void getStudentMessage(){
		JSONObject json = new JSONObject();
		json.put("code", 0);
		try{
			String studentid = getPara("studentId");
			String courseplanid = getPara("courseplanid");
			CoursePlan courseplan = CoursePlan.coursePlan.findById(courseplanid);
			Teachergrade tg = Teachergrade.teachergrade.findByCoursePlanIdAndStudentid(courseplanid, studentid);
			Map<String, Object> similarityCourseplan = KnowledgeService.me.queryBySimilarityCourseplan(courseplan);
			if(tg!=null){
				json.put("code", 1);
				json.put("tg", tg);
				json.put("similarityCourseplan", similarityCourseplan);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		renderJson(json);
	}
}
