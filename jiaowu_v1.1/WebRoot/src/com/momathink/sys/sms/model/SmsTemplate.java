
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

package com.momathink.sys.sms.model;

import java.util.List;

import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.constants.Constants;
@Table(tableName="crm_smstemplate")
public class SmsTemplate extends BaseModel<SmsTemplate> {
	private static final long serialVersionUID = 9173917692482770076L;
	public static final SmsTemplate dao = new SmsTemplate();
	
	/**
	 * 查询所有的模板
	 * @return
	 */
	public List<SmsTemplate> getAllMessage(String name,String type) {
		StringBuffer sf = new StringBuffer("select * from crm_smstemplate where 1=1  ");
		if(name!=null&&!name.equals("")){
			sf.append(" and sms_name = ").append(name);
		}
		if(type!=null&&!type.equals("0")){
			sf.append(" and sms_type = ").append(type);
		}
		return dao.find(sf.toString());
	}
	
	/**
	 * 学生丶家长和老师 下发课表的短信模板
	 * @param name
	 * @param time
	 * @param timerank
	 * @param campus
	 * @param room
	 * @param teacher
	 * @param course
	 * @param code   用于区别谁调用了这个方法
	 * @return
	 */
	public static String useTemplateToSendDownForAppointor(String name,String time,String timerank,String campus,String room,String teacher,String course,int code){
		StringBuffer sf = new StringBuffer("select * from crm_smstemplate where sms_state = 1 ");
		if(code==1){
			sf.append(" and sms_type=1 and sms_name = 0");
		}else if(code==2){
			sf.append(" and sms_type=2 and sms_name = 0");
		}else if(code==3){
			sf.append(" and sms_type=3 and sms_name = 0");
		}
		SmsTemplate sms = SmsTemplate.dao.findFirst(sf.toString());
		String str="";
			//判断对象是否为空
		if(sms==null){
			str="";
			//判断是否为有值
		}else if(sms.get("sms_ch_style")==null){
			str="";
			//判断是否包含
		}else if(sms.get("sms_ch_style").toString().contains("{student_name}") && sms.get("sms_ch_style").toString().contains("{course_date}")
				&& sms.get("sms_ch_style").toString().contains("{rank_name}") && sms.get("sms_ch_style").toString().contains("{campus_name}")
				&& sms.get("sms_ch_style").toString().contains("{room_name}")&& sms.get("sms_ch_style").toString().contains("{teacher_name}")
				&& sms.get("sms_ch_style").toString().contains("{course_name}")){
			 str = sms.get("sms_ch_style").toString()
						.replace("{student_name}",name).replace("{course_date}",time )
						.replace("{rank_name}", timerank).replace("{campus_name}",campus )
						.replace("{room_name}",room ).replace("{teacher_name}",teacher).replace("{course_name}",course);
		}else{
			str="";
		}
		return str;
	}
	
	/**
	 * 学生丶家长和老师的取消排课下发短信模板
	 * @param name
	 * @param time
	 * @param timerank
	 * @param campus
	 * @param room
	 * @param teacher 学生和家长调用的时候应该传入空
	 * @param course
	 * @param code
	 * @return
	 */
	public String useTemplateToSendDownCancelCourseForAppointor(String name,String time,String timerank,String campus,String room,String teacher,String course,int code){
		StringBuffer sf = new StringBuffer("select * from crm_smstemplate where sms_state = 1  ");
		if(code==1){
			sf.append(" and sms_type=1 and sms_name = 1");
		}else if(code==2){
			sf.append(" and sms_type=2 and sms_name = 1");
		}else if(code==3){
			sf.append(" and sms_type=3 and sms_name = 1");
		}
		SmsTemplate sms = SmsTemplate.dao.findFirst(sf.toString());
		String str="";
		//判断该对象是否存在《不存在则返回空》
		if(sms==null){
			str="";
			//判断获取的值是否为null
		}else if(sms.get("sms_ch_style")==null){
			str="";
		//判断获取的字符串是否包含指定字符串《不包含则返回空》	
		}else if(sms.get("sms_ch_style").toString().contains("{student_name}") && sms.get("sms_ch_style").toString().contains("{course_date}")
				&& sms.get("sms_ch_style").toString().contains("{rank_name}") && sms.get("sms_ch_style").toString().contains("{campus_name}")
				&& sms.get("sms_ch_style").toString().contains("{room_name}")
				&& sms.get("sms_ch_style").toString().contains("{course_name}")){
			//学生和家长调用的时候teacher传入的是空   区别家长丶学生跟老师下发课表的不同之处
			if(teacher!=""){
				 str = sms.get("sms_ch_style").toString()
							.replace("{student_name}",name).replace("{course_date}",time )
							.replace("{rank_name}", timerank).replace("{campus_name}",campus )
							.replace("{room_name}",room ).replace("{teacher_name}",teacher).replace("{course_name}",course);
			}else{
				//确定是老师的时候判断是否包含指定的字符串
				if(sms.get("sms_ch_style").toString().contains("{teacher_name}")){
					str = sms.get("sms_ch_style").toString()
							.replace("{student_name}",name).replace("{course_date}",time )
							.replace("{rank_name}", timerank).replace("{campus_name}",campus )
							.replace("{room_name}",room ).replace("{course_name}",course);
				}else{
					str="";
				}
			}
		}else{
			str="";
		}
		return str;
	}
	
	/**
	 * 该方法用与给外教发送上课或取消排课的信息
	 * @param name
	 * @param time
	 * @param timerank
	 * @param campus
	 * @param room
	 * @param teacher
	 * @param course
	 * @param code 用于判断是外教时   发送的是上课信息   还是取消排课信息
	 * @return
	 */
	public String isForeignTeacherUseTemplate(String name,String time,String timerank,String campus,String room,String teacher,String course,int code){
		StringBuffer sf = new StringBuffer("select * from crm_smstemplate where sms_state = 1  ");
		if(code==0){
			sf.append(" and sms_type=3 and sms_name = 0 ");
		}else{
			sf.append(" and sms_type=3 and sms_name = 1 ");
		}
		SmsTemplate sms = SmsTemplate.dao.findFirst(sf.toString());
		String str="";
		if(sms==null){
			str="";
			//判断获取的值是否为null
		}else if(sms.get("sms_en_style")==null){
			str="";
		//判断获取的字符串是否包含指定字符串《不包含则返回空》	
		}else if(sms.get("sms_en_style").toString().contains("{student_name}") && sms.get("sms_ch_style").toString().contains("{course_date}")
				&& sms.get("sms_en_style").toString().contains("{rank_name}") && sms.get("sms_ch_style").toString().contains("{campus_name}")
				&& sms.get("sms_en_style").toString().contains("{room_name}")&&sms.get("sms_en_style").toString().contains("{teacher_name}")
				&& sms.get("sms_en_style").toString().contains("{course_name}")){
				//确定是老师的时候判断是否包含指定的字符串
					str = sms.get("sms_en_style").toString()
							.replace("{student_name}",name).replace("{course_date}",time )
							.replace("{rank_name}", timerank).replace("{campus_name}",campus )
							.replace("{room_name}",room ).replace("{course_name}",course);
		}else{
			str="";
		}
		return str;
	}
	
	/**
	 * 查询正在使用的模板
	 * @return
	 */
	public SmsTemplate getUseTemplate(int name,int type){
		StringBuffer  sf = new StringBuffer("select * from crm_smstemplate where sms_state = 1  ");
		if(name==0 && type==1){
			sf.append(" and sms_name = 0 and sms_type = 1 ");
		}else if(name==1 && type==1){
			sf.append(" and sms_name = 1 and sms_type = 1 ");
		}else if(name==0 && type==2){
			sf.append(" and sms_name = 0 and sms_type = 2 ");
		}else if(name==1 && type==2){
			sf.append(" and sms_name = 1 and sms_type = 2 ");
		}else if(name==0 && type==3){
			sf.append(" and sms_name = 0 and sms_type = 3 ");
		}else if(name==1 && type==3){
			sf.append(" and sms_name = 1 and sms_type = 3 ");
		}
		return dao.findFirst(sf.toString());
	}

	/**
	 * 根据短信模板编码获取短信模板 
	 * @author David
	 * @param numbers 短信模板编码
	 * @param language 语言
	 * @return 默认返回中文短信模板
	 */
	public String getNoticeMessageByNumbers(String numbers,String language) {
		SmsTemplate sms = dao.findFirst("select * from crm_smstemplate where numbers = ?",numbers);
		if(Constants.LANGUAGE_EN.equals(language)){
			return sms.getStr("sms_en_style");
		}else{
			return sms.getStr("sms_en_style");
		}
	}
}
