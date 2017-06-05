
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

package com.momathink.teaching.subject.controller;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolString;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.service.CourseService;
import com.momathink.teaching.subject.model.Subject;
import com.momathink.teaching.subject.service.SubjectService;

@Controller(controllerKey="/subject")
public class SubjectController extends BaseController {
	private static final Logger logger = Logger.getLogger(SubjectController.class);
	
	/**
	 * 科目管理
	 */
	public void findSubjectManager() {
		try{
			List<Subject> subject = Subject.dao.getSubject();
			setAttr("subject", subject);
			renderJsp("/subject/findSubjectManager.jsp");
		}catch(Exception e)
		{
			logger.error("SubjectController.findSubjectManager",e);
			renderJsp("/subject/findSubjectManager.jsp");
		}
	}
	/**
	 * 验证科目名是否已存在
	 */
	public void checkSubjectName()
	{
		try{
			String subjectName=getPara("subjectName");
			Subject subject=Subject.dao.findFirst("select * from subject where state=0 and Subject_Name=?",subjectName);
			boolean flag=false;
			if(subject!=null)
			{
				flag=true;
			}
			renderJson(flag);
		}catch(Exception e)
		{
			logger.error("SubjectController.checkSubjectName",e);
			renderJson(false);
		}
	}
	/**
	 * 添加或更新科目信息
	 */
	public void doAddSubjectManager() {
		String id = getPara("id"); // 科目id
		String subjectName = getPara("subjectName"); // 科目名称
		try {
			if (!ToolString.isNull(id)) {// id不为空更新，为空添加
				Subject.dao.findById(id).set("subject_Name", subjectName).update();
				Integer courseSubjectId = -Integer.parseInt(id);
				Course course = Course.dao.findById(courseSubjectId);
				course.set("COURSE_NAME", subjectName).set("UPDATE_TIME", new Date()).set("version", course.getInt("version")+1).update();
			} else {
				Subject sub = new Subject();
				sub.set("subject_Name", subjectName).save();
				new Course().set("Id",-sub.getInt("Id")).set("COURSE_NAME", sub.getStr("SUBJECT_NAME"))
					.set("CREATE_TIME", new Date()).set("UPDATE_TIME", new Date()).set("SUBJECT_ID", 0).save();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("SubjectController.doAddSubjectManager", e);
		}
		renderJson("1");
	}
	/**
	 * 根据科目id查找科目的信息回显到页面
	 */
	public void editSubjectManager(){
		try{
			String subject_id = getPara();//科目id
			Record record = Db.findById("subject",subject_id);
			if(!ToolString.isNull(subject_id)){
				setAttr("id", subject_id);
				setAttr("subjectName", record.get("SUBJECT_NAME"));
			}
			renderJsp("/subject/addSubjectManager.jsp");
		}catch(Exception e)
		{
			logger.error("SubjectController.editSubjectManager",e);
			renderJsp("/subject/addSubjectManager.jsp");
		}
	}
	/**
	 * 删除科目:检查该科目下是否有课程
	 */
	public void delSubject1() {
		try {
			if (getParaToInt("subjectId") != null) {
				int id = getParaToInt("subjectId");
				// 查询该科目下是否有课程
				String sql = "SELECT * from course c where c.SUBJECT_ID=?";
				if (Db.find(sql, id).size() > 0)// 如果有排课未开始或未结束
				{
					renderJson("result", "该科目已有课程，禁止删除！");
				} else {
					Db.update("update subject set state=1 where id=?", id);// 改变状态，删除成功
					renderJson("result", "true");
				}
			}
		} catch (Exception e) {
			logger.error("SubjectController.delSubject", e);
		}
	}
	/**
	 * 变更科目顺序
	 */
	public void modifySubjectOrder() {
		try {
			if (getParaToInt("subjectId") != null) {
				int id = getParaToInt("subjectId");
				int sortOrder = getParaToInt("sortOrder");
				String sql = "SELECT * from subject s where s.id=?";
				if (Db.find(sql, id).size() > 0){
					Db.update("update subject set sortorder="+sortOrder+" where id=?", id);
					renderJson("result", "true");
				} else {
					renderJson("result", "该科目不存在！");
				}
			}
		} catch (Exception e) {
			logger.error("SubjectController.delSubject", e);
		}
	}
	
	/**
	 * 导入subject
	 *
	 **  /subject/importSubjects
	 */
	 
	public void importSubjects(){
		render("/subject/import_subjects.jsp");
	}
	
	/**
	 * 保存导入subject
	 *   /subject/saveImportSubjects
	 */
	public void saveImportSubjects(){
		Integer createuserid = getSysuserId();
		setAttr("msg", SubjectService.importSubjects(getFile("fileField"),createuserid));
		importSubjects();
	}
	
	/**
	 * 导入课程
	 *  /subject/importCourses
	 */
	public void importCourses(){
		String subjectid = getPara();
		setAttr("subjectid", subjectid);
		setAttr("subjects", Subject.dao.getSubject());
		render("/subject/import_courses.jsp");
	}
	
	/**
	 * 保存导入course
	 *   /subject/saveImportCourses
	 */
	public void saveImportCourses(){
		UploadFile file = getFile("fileField");
		String[] subjectids = getParaValues("subjectids");
		if(subjectids == null){
			setAttr("msg", "科目为空, 不能导入");
			importCourses();
			return;
		}
		Integer createuserid = getSysuserId();
		setAttr("msg", CourseService.importSubjects(file,createuserid,getParaToInt("courseid"),subjectids));
		setAttr("subjectid", subjectids[0]);
		importCourses();
	}
}
