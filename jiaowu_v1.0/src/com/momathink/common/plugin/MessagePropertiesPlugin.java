
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

package com.momathink.common.plugin;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.jfinal.plugin.IPlugin;
import com.momathink.common.constants.MesContantsFinal;
import com.momathink.sys.sms.model.SmsSettings;

/**
 * 短信/邮件消息下发配置
 * 
 * @author David
 *
 */
public class MessagePropertiesPlugin implements IPlugin {

	protected final Logger log = Logger.getLogger(getClass());

	/**
	 * 保存系统配置参数值
	 */
	private static Map<String, String> smsParamMap = new HashMap<String, String>();
	private static Map<String, String> emailParamMap = new HashMap<String, String>();
//	private static Map<String, Map<String,String>> campusParamMap = new HashMap<String, Map<String,String>>();
//	private static Map<String, String> subjectParamMap = new HashMap<String,String>();
//	private static Map<String, String> courseParamMap = new HashMap<String,String>();
//	private static Map<String, String> timeRankParamMap = new HashMap<String,String>();
//	private static Map<String, String> classroomParamMap = new HashMap<String,String>();
	private static Map<String, String> smsMessageMap = new HashMap<String,String>();
	private static Map<String, String> emailMessageMap = new HashMap<String,String>();
	private Properties properties;

	public MessagePropertiesPlugin(Properties properties) {
		this.properties = properties;
	}

	/**
	 * 获取短信配置信息
	 * @param key
	 * @return
	 */
	public static String getSmsParamMapValue(String key) {
		return smsParamMap.get(key);
	}
	/**
	 * 获取邮件配置信息
	 * @param key
	 * @return
	 */
	public static String getEmailParamMapValue(String key) {
		return emailParamMap.get(key);
	}
	/**
	 * 获取校区配置信息
	 * @param key
	 * @return
	 */
//	public static Map<String,String> getCampusParamMapValue(String key) {
//		return campusParamMap.get(key);
//	}
	/**
	 * 获取发送邮件相关内容配置
	 * @param key
	 * @return
	 */
	public static String getEmailMessageMapValue(String key) {
		return emailMessageMap.get(key);
	}
	/**
	 * 获取发送短信相关内容配置
	 * @param key
	 * @return
	 */
	public static String getSmsMessageMapValue(String key) {
		return smsMessageMap.get(key);
	}
	/**
	 * 获取科目信息
	 * @param key
	 * @return
	 */
//	public static String getSubjectParamMapValue(String key) {
//		return subjectParamMap.get(key);
//	}
//	
//	public static String getTimeRankParamMapValue(String key) {
//		return timeRankParamMap.get(key);
//	}
//
//	public static String getCourseParamMapValue(String key) {
//		return courseParamMap.get(key);
//	}
//	public static String getClassroomParamMapValue(String key) {
//		return classroomParamMap.get(key);
//	}
	@Override
	public boolean start() {
		SmsSettings sms = SmsSettings.dao.getUsedServiceProvider();
		smsParamMap.put("username", sms==null?"":sms.getStr("sms_user"));
		smsParamMap.put("password",sms==null?"":sms.getStr("sms_possword"));
		smsParamMap.put("servicesHost", sms==null?"":sms.getStr("sms_servicesHost"));
		smsParamMap.put("servicesRequestAddRess", sms==null?"":sms.getStr("sms_servicesRequestAddRess"));
		
		
		smsMessageMap.put(MesContantsFinal.cs_sms_zhuce, properties.getProperty(MesContantsFinal.cs_sms_zhuce));
		smsMessageMap.put(MesContantsFinal.cs_sms_tuijian, properties.getProperty(MesContantsFinal.cs_sms_tuijian));
		smsMessageMap.put(MesContantsFinal.cs_sms_tuijian_nokcgw, properties.getProperty(MesContantsFinal.cs_sms_tuijian_nokcgw));
		smsMessageMap.put(MesContantsFinal.cs_sms_buchong, properties.getProperty(MesContantsFinal.cs_sms_buchong));
		smsMessageMap.put(MesContantsFinal.cs_sms_fankui, properties.getProperty(MesContantsFinal.cs_sms_fankui));
		smsMessageMap.put(MesContantsFinal.cs_sms_fankui_again, properties.getProperty(MesContantsFinal.cs_sms_fankui_again));
		smsMessageMap.put(MesContantsFinal.cs_sms_chengdan, properties.getProperty(MesContantsFinal.cs_sms_chengdan));
		smsMessageMap.put(MesContantsFinal.cs_sms_jiaofei, properties.getProperty(MesContantsFinal.cs_sms_jiaofei));
		smsMessageMap.put(MesContantsFinal.cs_sms_yupaike, properties.getProperty(MesContantsFinal.cs_sms_yupaike));
		smsMessageMap.put(MesContantsFinal.cs_sms_xufei, properties.getProperty(MesContantsFinal.cs_sms_xufei));
		smsMessageMap.put(MesContantsFinal.cs_sms_xiaji, properties.getProperty(MesContantsFinal.cs_sms_xiaji));
		smsMessageMap.put(MesContantsFinal.cs_sms_jiesuan, properties.getProperty(MesContantsFinal.cs_sms_jiesuan));
		
		emailMessageMap.put(MesContantsFinal.cs_email_zhuce, properties.getProperty(MesContantsFinal.cs_email_zhuce));
		emailMessageMap.put(MesContantsFinal.cs_email_tuijian, properties.getProperty(MesContantsFinal.cs_email_tuijian));
		emailMessageMap.put(MesContantsFinal.cs_email_buchong, properties.getProperty(MesContantsFinal.cs_email_buchong));
		emailMessageMap.put(MesContantsFinal.cs_email_fankui, properties.getProperty(MesContantsFinal.cs_email_fankui));
		emailMessageMap.put(MesContantsFinal.cs_email_fankui_again, properties.getProperty(MesContantsFinal.cs_email_fankui_again));
		emailMessageMap.put(MesContantsFinal.cs_email_chengdan, properties.getProperty(MesContantsFinal.cs_email_chengdan));
		emailMessageMap.put(MesContantsFinal.cs_email_jiaofei, properties.getProperty(MesContantsFinal.cs_email_jiaofei));
		emailMessageMap.put(MesContantsFinal.cs_email_yupaike, properties.getProperty(MesContantsFinal.cs_email_yupaike));
		emailMessageMap.put(MesContantsFinal.cs_email_xufei, properties.getProperty(MesContantsFinal.cs_email_xufei));
		emailMessageMap.put(MesContantsFinal.cs_email_xiaji, properties.getProperty(MesContantsFinal.cs_email_xiaji));
		emailMessageMap.put(MesContantsFinal.cs_email_jiesuan, properties.getProperty(MesContantsFinal.cs_email_jiesuan));
		
		smsMessageMap.put(MesContantsFinal.kc_sms_buchong, properties.getProperty(MesContantsFinal.kc_sms_buchong));
		smsMessageMap.put(MesContantsFinal.kc_sms_nottuijian, properties.getProperty(MesContantsFinal.kc_sms_nottuijian));
		smsMessageMap.put(MesContantsFinal.kc_sms_tuijian, properties.getProperty(MesContantsFinal.kc_sms_tuijian));
		smsMessageMap.put(MesContantsFinal.kc_sms_tuijian_xuesheng, properties.getProperty(MesContantsFinal.kc_sms_tuijian_xuesheng));
		
		smsMessageMap.put(MesContantsFinal.apply_sms, properties.getProperty(MesContantsFinal.apply_sms));
		smsMessageMap.put(MesContantsFinal.apply_sms_again, properties.getProperty(MesContantsFinal.apply_sms_again));
		smsMessageMap.put(MesContantsFinal.apply_sms_pass, properties.getProperty(MesContantsFinal.apply_sms_pass));
		smsMessageMap.put(MesContantsFinal.apply_sms_refuse, properties.getProperty(MesContantsFinal.apply_sms_refuse));
		
		emailMessageMap.put(MesContantsFinal.kc_email_buchong, properties.getProperty(MesContantsFinal.kc_email_buchong));
		emailMessageMap.put(MesContantsFinal.kc_email_tuijian, properties.getProperty(MesContantsFinal.kc_email_tuijian));
		
		emailMessageMap.put(MesContantsFinal.apply_email, properties.getProperty(MesContantsFinal.apply_email));
		emailMessageMap.put(MesContantsFinal.apply_email_again, properties.getProperty(MesContantsFinal.apply_email_again));
		emailMessageMap.put(MesContantsFinal.apply_email_pass, properties.getProperty(MesContantsFinal.apply_email_pass));
		emailMessageMap.put(MesContantsFinal.apply_email_refuse, properties.getProperty(MesContantsFinal.apply_email_refuse));

		smsMessageMap.put(MesContantsFinal.ls_sms_today_qxpk, properties.getProperty(MesContantsFinal.ls_sms_today_qxpk));
		smsMessageMap.put(MesContantsFinal.ls_sms_today_tjpk, properties.getProperty(MesContantsFinal.ls_sms_today_tjpk));
		
		smsMessageMap.put(MesContantsFinal.xs_sms_today_qxpk, properties.getProperty(MesContantsFinal.xs_sms_today_qxpk));
		smsMessageMap.put(MesContantsFinal.xs_sms_today_tjpk, properties.getProperty(MesContantsFinal.xs_sms_today_tjpk));
		
		smsMessageMap.put(MesContantsFinal.jz_sms_today_qxpk, properties.getProperty(MesContantsFinal.jz_sms_today_qxpk));
		smsMessageMap.put(MesContantsFinal.jz_sms_today_tjpk, properties.getProperty(MesContantsFinal.jz_sms_today_tjpk));
		
		smsMessageMap.put(MesContantsFinal.ls_email_tjpk, properties.getProperty(MesContantsFinal.ls_email_tjpk));
		smsMessageMap.put(MesContantsFinal.dd_email_tjpk, properties.getProperty(MesContantsFinal.dd_email_tjpk));

		return true;
	}

	@Override
	public boolean stop() {
		smsParamMap.clear();
		return true;
	}

}
