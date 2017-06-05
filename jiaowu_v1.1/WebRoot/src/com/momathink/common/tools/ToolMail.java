
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

package com.momathink.common.tools;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

import org.apache.log4j.Logger;

import com.jfinal.kit.StrKit;
import com.momathink.common.plugin.MessagePropertiesPlugin;
import com.momathink.common.task.Organization;

/**
 * javaMail发送邮件工具类 2015年8月10日prq
 * 
 * @author prq
 * 
 */
public class ToolMail {
	private static final Logger logger = Logger.getLogger(ToolMail.class);

	/**
	 * 发送邮件
	 * 
	 * @param mailServerHost
	 *            邮件服务器地址
	 * @param mailServerPort
	 *            邮件服务器端口
	 * @param validate
	 *            是否要求身份验证
	 * @param fromAddress
	 *            发送邮件地址
	 * @param toAddress
	 *            接收邮件地址//以,号分割多个接收地址
	 * @param ccAddress
	 *            抄送地址//以,号分割多个抄送地址
	 * @param subject
	 *            邮件主题
	 * @param content
	 *            邮件内容
	 * @param isHTML
	 *            是否是html格式邮件
	 * @param isSSL
	 *            邮件服务器是否需要安全连接(SSL)
	 * @return true:发送成功;false:发送失败
	 */
	public static boolean sendMail(boolean validate, String toAddress, String ccAddress, String subject, String content, boolean isHTML, boolean isSSL) {
		Organization org = Organization.dao.findById(1);
		String mailServerPort = org.getStr("email_serverport") != null ? org.getStr("email_serverport") : MessagePropertiesPlugin.getEmailParamMapValue("server_port");
		String mailServerHost = org.getStr("email_serverhost") != null ? org.getStr("email_serverhost") : MessagePropertiesPlugin.getEmailParamMapValue("server_host");
		String fromAddress = org.getStr("email_fromaddress") != null ? org.getStr("email_fromaddress") : MessagePropertiesPlugin.getEmailParamMapValue("from_address");
		String userMail = org.getStr("email_senderemail") != null ? org.getStr("email_senderemail") : MessagePropertiesPlugin.getEmailParamMapValue("sender_email");
		String userPass = org.getStr("email_senderpassword") != null ? org.getStr("email_senderpassword") : MessagePropertiesPlugin.getEmailParamMapValue("sender_password");
		
		try {
		
			// 邮件接收者的地址
			List<String> to = new ArrayList<String>();
			
			String[] toAddres = toAddress.split(",");
			for (String mail : toAddres) 
				if(StrKit.notBlank(mail))
					to.add(mail);
			String[] ccAddres = ccAddress.split(",");
			for (String mail : ccAddres) 
				if(StrKit.notBlank(mail))
					to.add(mail);
			
			String[] attachFileNames = new String[]{};	// 邮件附件的文件名
			
			ToolMailV2.sendHtmlMail(mailServerHost, mailServerPort, validate, userMail, userPass, fromAddress, to, subject, content, attachFileNames);
			return true;
		} catch (Exception e) {
			logger.error(e);
			return false;
		}
	}

	/**
	 * 根据url生成静态页面
	 *
	 * @param url
	 *            动态文件路经 如：http://www.163.com/x.jsp
	 * @return d
	 */
	public static StringBuffer getHtmlTextByURL(String url) {
		// 从utl中读取html存为str
		StringBuffer sb = new StringBuffer();
		try {
			URL u = new URL(url);
			URLConnection uc = u.openConnection();
			InputStream is = uc.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			while (br.ready()) {
				sb.append(br.readLine() + "/n");
			}
			is.close();
			return sb;
		} catch (Exception e) {
			e.printStackTrace();
			return sb;
		}
	}

}

class myAuthenticator extends Authenticator {
	String userName;
	String userPass;

	public myAuthenticator() {
	}

	public myAuthenticator(String userName, String userPass) {
		this.userName = userName;
		this.userPass = userPass;
	}

	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(userName, userPass);
	}
}

