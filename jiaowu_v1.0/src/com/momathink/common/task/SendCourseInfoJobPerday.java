
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

package com.momathink.common.task;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.Util;
import com.momathink.common.constants.Constants;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolMonitor;
import com.momathink.common.tools.ToolUtils;
import com.momathink.sys.sms.model.SendSMS;
import com.momathink.sys.sms.model.SmsTemplate;

/** 每天 17:30:30 执行的任务调度器
 */
public class SendCourseInfoJobPerday implements Runnable {
	private static final Logger logger = Logger.getLogger(SendCourseInfoJobPerday.class);
	
	@Override
	public void run() {
		organization();
		sendMonitor();
	}

	/**
	 * 报告服务器运行状态
	 */
	private void sendMonitor() {
		new ToolMonitor(ToolMonitor.report_timing).start();
	}
	
	/**
	 * 每日上课通知定时任务
	 */
	private void organization(){
		logger.info("每日上课通知定时任务开始：" + ToolDateTime.getDate());
		try {
			Organization organization = Organization.dao.findById(1);
			String sql = "SELECT cp.Id,cp.PLAN_TYPE,cp.class_id, xs.real_name AS student_name, xs.tel AS student_tel,"
					+ "xs.receive_sms_student, xs.fathertel,xs.receive_sms_father,xs.mothertel,xs.receive_sms_mother, "
					+ "ls.real_name teacher_name,ls.tel teacher_tel, ls.receive_sms_teacher,ls.isforeignteacher, "
					+ "xq.CAMPUS_NAME,js.`NAME` classname, sd.rank_name, kc.course_name, cp.remark\n" +
					"FROM courseplan cp\n" +
					"LEFT JOIN account xs ON cp.student_id = xs.id\n" +
					"LEFT JOIN account ls ON cp.teacher_id = ls.id\n" +
					"LEFT JOIN classroom js ON cp.room_id = js.id\n" +
					"LEFT JOIN time_rank sd ON cp.TIMERANK_ID = sd.id\n" +
					"LEFT JOIN course kc ON cp.course_id = kc.id\n" +
					"LEFT JOIN campus xq ON cp.CAMPUS_ID = xq.Id\n" +
					"WHERE DATE_FORMAT(cp.COURSE_TIME, '%Y-%m-%d')=date_add(CURDATE(), INTERVAL 1 DAY)";
			List<Record> list = Db.find(sql);
			String tomorrowDate = Util.getTomorrowDate();
			int vipCourseCount = 0;
			int banCourseCount = 0;
			for (Record record : list) {// 组合数据
				int planType = record.getInt("PLAN_TYPE");
				if(planType == 2)//老师休息
					continue;
				int classId = record.getInt("class_id");
				String studentName = record.getStr("student_name");
				String studentTel = record.getStr("student_tel");
				String teacherTel = record.getStr("teacher_tel");
				String fatherTel = record.getStr("fathertel");
				List<Record> xbStudentlist = null;
				if(classId != 0){
					String xbsql = "SELECT xs.REAL_NAME,xs.TEL,xs.receive_sms_student, xs.fathertel,xs.receive_sms_father,xs.mothertel,xs.receive_sms_mother"
							+ " FROM account_banci ab LEFT JOIN account xs ON ab.account_id=xs.Id WHERE ab.banci_id=?";
					xbStudentlist = Db.find(xbsql,classId);
				}
				if(planType == 0){//课程
					String studentCourseNoticeMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.STUDENT_COURSE_NOTICE,Constants.LANGUAGE_CH);
					String parentsCourseNoticeMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.PARENTS_COURSE_NOTICE,Constants.LANGUAGE_CH);
					String studentMessage = studentCourseNoticeMessage;
					studentMessage=studentMessage.replace("{course_date}",tomorrowDate ).replace("{rank_name}", record.getStr("rank_name"))
							.replace("{campus_name}",record.getStr("CAMPUS_NAME") ).replace("{room_name}",record.getStr("classname") )
							.replace("{teacher_name}",record.getStr("teacher_name")).replace("{course_name}",record.getStr("course_name"));
					String parentsMessage = parentsCourseNoticeMessage;
					parentsMessage=parentsMessage.replace("{course_date}",tomorrowDate ).replace("{rank_name}", record.getStr("rank_name"))
							.replace("{campus_name}",record.getStr("CAMPUS_NAME") ).replace("{room_name}",record.getStr("classname") )
							.replace("{teacher_name}",record.getStr("teacher_name")).replace("{course_name}",record.getStr("course_name"));
					if(classId == 0){//1vs1
						studentMessage = studentMessage.replace("{student_name}",studentName);
						parentsMessage = parentsMessage.replace("{student_name}",studentName);
						if(record.getInt("receive_sms_student")==1&&ToolUtils.isMobile(studentTel)){
							SendSMS.sendCoursePlanSms(studentMessage, studentTel,Constants.RECEIVE_SMS_STUDENT);
						}
						if(record.getInt("receive_sms_father")==1&&ToolUtils.isMobile(fatherTel)){
							SendSMS.sendCoursePlanSms(parentsMessage, fatherTel,Constants.RECEIVE_SMS_PARENTS);
						}
						if(record.getInt("receive_sms_teacher")==1&&ToolUtils.isMobile(teacherTel)){
							String teacherCourseNoticeChMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.TEACHER_COURSE_NOTICE,Constants.LANGUAGE_CH);
							String teacherCourseNoticeEnMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.TEACHER_COURSE_NOTICE,Constants.LANGUAGE_EN);
							String teacherMessage = record.getInt("isforeignteacher")==1?teacherCourseNoticeEnMessage:teacherCourseNoticeChMessage;
							teacherMessage=teacherMessage.replace("{course_date}",tomorrowDate ).replace("{rank_name}", record.getStr("rank_name"))
									.replace("{campus_name}",record.getStr("CAMPUS_NAME") ).replace("{room_name}",record.getStr("classname") )
									.replace("{teacher_name}",record.getStr("teacher_name")).replace("{course_name}",record.getStr("course_name"));
							teacherMessage = teacherMessage.replace("{student_name}",studentName);
							SendSMS.sendCoursePlanSms(teacherMessage, teacherTel,Constants.RECEIVE_SMS_TEACHER);
						}
						if(record.getInt("receive_sms_mother")==1&&ToolUtils.isMobile(record.getStr("mothertel"))){
							SendSMS.sendCoursePlanSms(parentsMessage, record.getStr("mothertel"),Constants.RECEIVE_SMS_PARENTS);
						}
						vipCourseCount++;
					}else{//小班
						String xbStudentMessage = studentMessage;
						String xbParentsMessage = parentsMessage;
						if(record.getInt("receive_sms_teacher")==1&&ToolUtils.isMobile(teacherTel)){
							String teacherCourseNoticeChMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.TEACHER_BAN_COURSE_NOTICE,Constants.LANGUAGE_CH);
							String teacherCourseNoticeEnMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.TEACHER_BAN_COURSE_NOTICE,Constants.LANGUAGE_EN);
							String teacherMessage = record.getInt("isforeignteacher")==1?teacherCourseNoticeEnMessage:teacherCourseNoticeChMessage;
							teacherMessage=teacherMessage.replace("{class_name}",studentName).replace("{course_date}",tomorrowDate ).replace("{rank_name}", record.getStr("rank_name"))
									.replace("{campus_name}",record.getStr("CAMPUS_NAME") ).replace("{room_name}",record.getStr("classname") )
									.replace("{teacher_name}",record.getStr("teacher_name")).replace("{course_name}",record.getStr("course_name"));
							SendSMS.sendCoursePlanSms(teacherMessage, teacherTel,Constants.RECEIVE_SMS_TEACHER);
						}
						if(xbStudentlist != null){
							for(Record student : xbStudentlist){
								if(student.getInt("receive_sms_student")==1&&ToolUtils.isMobile(student.getStr("TEL"))){
									SendSMS.sendCoursePlanSms(xbStudentMessage.replace("{student_name}", student.getStr("REAL_NAME")), studentTel,Constants.RECEIVE_SMS_STUDENT);
								}
								if(student.getInt("receive_sms_father")==1&&ToolUtils.isMobile(student.getStr("fathertel"))){
									SendSMS.sendCoursePlanSms(xbParentsMessage.replace("{student_name}", student.getStr("REAL_NAME")), student.getStr("fathertel"),Constants.RECEIVE_SMS_PARENTS);
								}	
								if(student.getInt("receive_sms_mother")==1&&ToolUtils.isMobile(student.getStr("mothertel"))){
									SendSMS.sendCoursePlanSms(xbParentsMessage.replace("{student_name}", student.getStr("REAL_NAME")), student.getStr("mothertel"),Constants.RECEIVE_SMS_PARENTS);
								}	
							}
						}
						banCourseCount++;
					}
				}else if(planType == 1){//模考
					String studentTestNoticeMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.STUDENT_TEST_NOTICE,Constants.LANGUAGE_CH);
					String parentsTestNoticeMessage = SmsTemplate.dao.getNoticeMessageByNumbers(Constants.PARENTS_TEST_NOTICE,Constants.LANGUAGE_CH);
					String studentMessage = studentTestNoticeMessage;
					studentMessage=studentMessage.replace("{course_date}",tomorrowDate ).replace("{rank_name}", record.getStr("rank_name"))
							.replace("{campus_name}",record.getStr("CAMPUS_NAME") ).replace("{room_name}",record.getStr("classname") )
							.replace("{course_name}",record.getStr("course_name"));
					String parentsMessage = parentsTestNoticeMessage;
					parentsMessage=parentsMessage.replace("{course_date}",tomorrowDate ).replace("{rank_name}", record.getStr("rank_name"))
							.replace("{campus_name}",record.getStr("CAMPUS_NAME") ).replace("{room_name}",record.getStr("classname") )
							.replace("{course_name}",record.getStr("course_name"));
					if(classId == 0){//1vs1
						studentMessage = studentMessage.replace("{student_name}",studentName);
						parentsMessage = parentsMessage.replace("{student_name}",studentName);
						if(record.getInt("receive_sms_student")==1&&ToolUtils.isMobile(studentTel)){
							SendSMS.sendCoursePlanSms(studentMessage, studentTel,Constants.RECEIVE_SMS_STUDENT);
						}
						if(record.getInt("receive_sms_father")==1&&ToolUtils.isMobile(fatherTel)){
							SendSMS.sendCoursePlanSms(parentsMessage, fatherTel,Constants.RECEIVE_SMS_PARENTS);
						}
						if(record.getInt("receive_sms_mother")==1&&ToolUtils.isMobile(record.getStr("mothertel"))){
							SendSMS.sendCoursePlanSms(parentsMessage, record.getStr("mothertel"),Constants.RECEIVE_SMS_PARENTS);
						}
					}else{//小班
						String xbStudentMessage = studentMessage;
						String xbParentsMessage = parentsMessage;
						if(xbStudentlist != null){
							for(Record student : xbStudentlist){
								if(student.getInt("receive_sms_student")==1&&ToolUtils.isMobile(student.getStr("TEL"))){
									SendSMS.sendCoursePlanSms(xbStudentMessage.replace("{student_name}", student.getStr("REAL_NAME")), studentTel,Constants.RECEIVE_SMS_STUDENT);
								}
								if(student.getInt("receive_sms_father")==1&&ToolUtils.isMobile(student.getStr("fathertel"))){
									SendSMS.sendCoursePlanSms(xbParentsMessage.replace("{student_name}", student.getStr("REAL_NAME")), student.getStr("fathertel"),Constants.RECEIVE_SMS_PARENTS);
								}	
								if(student.getInt("receive_sms_mother")==1&&ToolUtils.isMobile(student.getStr("mothertel"))){
									SendSMS.sendCoursePlanSms(xbParentsMessage.replace("{student_name}", student.getStr("REAL_NAME")), student.getStr("mothertel"),Constants.RECEIVE_SMS_PARENTS);
								}	
							}
						}
					}
				}
				Db.update("Update courseplan set sendsms=1 where id="+record.getInt("Id"));
			}
			
			List<String> nametels = new ArrayList<String>();
			if(organization.get("sms_names")!=null&&organization.get("sms_names")!=""){
				String[] smsname=organization.getStr("sms_names").split(",");
				String[] smstel=organization.getStr("sms_tels").split(",");
				for(int i=0;i<smsname.length;i++){
					nametels.add(smsname[i]+','+smstel[i]);
				}
			}
			if (nametels.size() > 0) {
				for (String rec : nametels) {
					String[] recInfo = rec.split(",");
					if (recInfo.length > 1) {
						int courseCount = vipCourseCount+banCourseCount;
						SendSMS.sendCoursePlanSms(recInfo[0] + "您好！" + tomorrowDate + "的课表已发送完毕，一对一共计：" + vipCourseCount + " 节，小班共计：" + banCourseCount + "节，总计" + courseCount + "节。", recInfo[1],Constants.RECEIVE_SMS_STAFF);
					}
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.info("每日上课通知定时任务结束：" + ToolDateTime.getDate());
	}

	
}
