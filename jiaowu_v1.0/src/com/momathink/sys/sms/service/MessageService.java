
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

package com.momathink.sys.sms.service;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.momathink.common.constants.MesContantsFinal;
import com.momathink.common.plugin.MessagePropertiesPlugin;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.sys.sms.model.SendSMS;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.campus.model.Classroom;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Teacher;

public class MessageService {
	
    public static final Logger log=Logger.getLogger(MessageService.class);
    
	/**
	 * 给学生发短信
	 * 
	 * @param sendType
	 * @param studentId
	 * @param subjectId
	 * @param courseId
	 * @param timeId
	 * @param coursePlanId
	 * @param planDate
	 * @param sms
	 * @param email
	 * @return
	 */
	public static void sendMessageToStudent(String sendSmsType, String coursePlanId) {
		if(!StringUtils.isEmpty(coursePlanId)){
			CoursePlan plan = CoursePlan.coursePlan.findById(Integer.parseInt(coursePlanId));
			if(plan!=null){
				Student student = Student.dao.findById(plan.getInt("student_id"));
				
				// 如果没有选择老师, 就为空吧
				Integer teacherid = plan.getInt("teacher_id");
				Teacher teacher = teacherid != null ? Teacher.dao.findById(teacherid) : new Teacher();
				
				String sms = MessagePropertiesPlugin.getSmsMessageMapValue(sendSmsType);
				if (!StringUtils.isEmpty(sms)) {
					String studentName = student.getStr("real_name");
					String timerankName = TimeRank.dao.getTimeRankNameById(plan.getInt("TIMERANK_ID").toString());
					String campusName = Campus.dao.getCampusNameById(plan.getInt("CAMPUS_ID").toString());
					String roomName = Classroom.dao.getRoomNameById(plan.getInt("ROOM_ID").toString());
					String teacherName = teacher.getStr("real_name");
					String crouseName = Course.dao.getCourseNameById(plan.getInt("COURSE_ID").toString());
					switch (sendSmsType) {
					case MesContantsFinal.xs_sms_today_tjpk:
						sms = sms.replace("{student_name}", studentName);
						sms = sms.replace("{course_date}", ToolDateTime.format(plan.getTimestamp("COURSE_TIME"), ToolDateTime.pattern_ymd_ch));
						sms = sms.replace("{rank_name}", timerankName);
						sms = sms.replace("{campus_name}", campusName);
						sms = sms.replace("{room_name}", roomName);
						sms = sms.replace("{teacher_name}", teacherName);
						sms = sms.replace("{course_name}", crouseName);
						SendSMS.sendSms(sms, student.getStr("tel"));
						if ("1".equals(student.getInt("PARENTS_TEL_ACCEPT") + "")&&!(student.get("tel")==null?"":student.getStr("tel")).equals(student.get("PARENTS_TEL")==null?"":student.getStr("PARENTS_TEL"))) {// 家长接收短信通知
							if (!StringUtils.isEmpty(student.get("PARENTS_TEL")==null?"":student.getStr("PARENTS_TEL")) && student.getStr("PARENTS_TEL").length() == 11) {
								sms = MessagePropertiesPlugin.getSmsMessageMapValue(MesContantsFinal.jz_sms_today_tjpk);
								sms = sms.replace("{student_name}", studentName);
								sms = sms.replace("{course_date}", ToolDateTime.format(plan.getTimestamp("COURSE_TIME"), ToolDateTime.pattern_ymd_ch));
								sms = sms.replace("{rank_name}", timerankName);
								sms = sms.replace("{campus_name}", campusName);
								sms = sms.replace("{room_name}", roomName);
								sms = sms.replace("{teacher_name}", teacherName);
								sms = sms.replace("{course_name}", crouseName);
								SendSMS.sendSms(sms, student.getStr("PARENTS_TEL"));
							}
						}
						break;
					case MesContantsFinal.xs_sms_today_qxpk:
						sms = sms.replace("{student_name}", studentName);
						sms = sms.replace("{course_date}", plan.getTimestamp("COURSE_TIME").toString());
						sms = sms.replace("{rank_name}", timerankName);
						sms = sms.replace("{campus_name}", campusName);
						sms = sms.replace("{room_name}", roomName);
						sms = sms.replace("{teacher_name}", teacherName);
						sms = sms.replace("{course_name}", crouseName);
						SendSMS.sendSms(sms, student.getStr("tel"));
						if ("1".equals(student.getInt("PARENTS_TEL_ACCEPT") + "")&&!student.getStr("tel").equals(student.getStr("PARENTS_TEL"))) {// 家长接收短信通知
							if (!StringUtils.isEmpty(student.getStr("PARENTS_TEL")) && student.getStr("PARENTS_TEL").length() == 11) {
								sms = MessagePropertiesPlugin.getSmsMessageMapValue(MesContantsFinal.jz_sms_today_qxpk);
								sms = sms.replace("{student_name}", studentName);
								sms = sms.replace("{course_date}", plan.getTimestamp("COURSE_TIME").toString());
								sms = sms.replace("{rank_name}", timerankName);
								sms = sms.replace("{campus_name}", campusName);
								sms = sms.replace("{room_name}", roomName);
								sms = sms.replace("{teacher_name}", teacherName);
								sms = sms.replace("{course_name}", crouseName);
								SendSMS.sendSms(sms, student.getStr("PARENTS_TEL"));
							}
						}
						break;
					default:
						break;
					}
				}			
			}
		}
	}

	/**
	 * 发送短信、邮件给财务
	 * 
	 * @param sendSmsType
	 * @param sendEmailType
	 * @param studentId
	 * @param verifierUserId
	 * @param applyUserId
	 * @param orderId
	 */
	public static void sendMessageToFinance(String sendSmsType, String sendEmailType, String studentId, String verifierUserId, String applyUserId) {
		Student student = Student.dao.findById(Integer.parseInt(studentId));
		String studentName = student.getStr("real_name");
		SysUser verifierUser = SysUser.dao.findById(Integer.parseInt(verifierUserId));
		SysUser applyUser = SysUser.dao.findById(Integer.parseInt(applyUserId));
		String verifierName = verifierUser.getStr("real_name");
		String verifierTel = verifierUser.getStr("tel");
		String applyUserName = applyUser.getStr("real_name");
		String applyUserTel = applyUser.getStr("tel");
		String sms = MessagePropertiesPlugin.getSmsMessageMapValue(sendSmsType);

		if (!StringUtils.isEmpty(sendSmsType)&&!StringUtils.isEmpty(verifierTel)) {
			switch (sendSmsType) {
			case MesContantsFinal.apply_sms:
				sms = sms.replace("{verifier_name}", verifierName);
				sms = sms.replace("{apply_user_name}", applyUserName);
				sms = sms.replace("{student_name}", studentName);
				SendSMS.sendSms(sms, verifierTel);
				break;
			case MesContantsFinal.apply_sms_again:
				sms = sms.replace("{verifier_name}", verifierName);
				sms = sms.replace("{apply_user_name}", applyUserName);
				sms = sms.replace("{student_name}", studentName);
				SendSMS.sendSms(sms, verifierTel);
				break;
			default:
				break;
			}
		}
		if (!StringUtils.isEmpty(sendSmsType)&&!StringUtils.isEmpty(applyUserTel)) {
			switch (sendSmsType) {
			case MesContantsFinal.apply_sms_pass:
				sms = sms.replace("{apply_user_name}", applyUserName);
				sms = sms.replace("{student_name}", studentName);
				SendSMS.sendSms(sms, applyUserTel);
				break;
			case MesContantsFinal.apply_sms_refuse:
				sms = sms.replace("{apply_user_name}", applyUserName);
				sms = sms.replace("{student_name}", studentName);
				SendSMS.sendSms(sms, applyUserTel);
				break;
			default:
				break;
			}
		}
	}
}
