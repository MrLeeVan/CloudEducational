
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

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.internet.MimeUtility;

import org.apache.log4j.Logger;


/**
 * 邮件发送
 * @author David
 * 
 * 描述：使用javamail出现java.net.SocketException: Network is unreachable: connect异常 解决方法 
 * 
 * 1. main方法加入System.setProperty("java.net.preferIPv4Stack", "true");  
 * 2. tomcat服务器加上启动参数 -Djava.net.preferIPv4Stack=true   
 */
public class ToolMailV2 {
	
	private static final Logger logger = Logger.getLogger(ToolMailV2.class);

	public static final String sendType_text = "text";

	public static final String sendType_html = "html";
	
	/**
	 * 发送文本邮件
	 * @param host
	 * @param port
	 * @param validate
	 * @param userName
	 * @param password
	 * @param from
	 * @param to
	 * @param subject
	 * @param content
	 * @param attachFileNames
	 */
	public static void sendTextMail(
			String host, String port, boolean validate, String userName, String password,
			String from, List<String> to, 
			String subject, String content, String[] attachFileNames) {
		logger.info("发送文本邮件");
		SendMail mail = new SendMail(sendType_text, host, port, validate, userName, password, from, to, subject, content, attachFileNames);
		mail.start();
	}
	
	/**
	 * 发送html邮件
	 * @param host
	 * @param port
	 * @param validate
	 * @param userName
	 * @param password
	 * @param from
	 * @param to
	 * @param subject
	 * @param content
	 * @param attachFileNames
	 */
	public static void sendHtmlMail(
			String host, String port, boolean validate, String userName, String password,
			String from, List<String> to, 
			String subject, String content, String[] attachFileNames) {
		logger.info("发送html邮件");
		SendMail mail = new SendMail(sendType_html, host, port, validate, userName, password, from, to, subject, content, attachFileNames);
		mail.start();
	}
	
	public static void main(String[] args) {
		String host = "c2.icoremail.net";		// 发送邮件的服务器的IP
		String port = "25";	// 发送邮件的服务器的端口
		
		String from = "support@tslbritain.com";		// 邮件发送者的地址
		String userName = "support@tslbritain.com";	// 登陆邮件发送服务器的用户名
		String password = "tslsupport";	// 登陆邮件发送服务器的密码
		
		List<String> to = new ArrayList<String>();			// 邮件接收者的地址
		to.add("yongliang.wang@momathink.com");
		
		boolean validate = true;	// 是否需要身份验证
		
		String subject = "标题test111";		// 邮件标题
		String content = "内容test111";		// 邮件的文本内容
		String[] attachFileNames = new String[]{};	// 邮件附件的文件名
		
		sendTextMail(host, port, validate, userName, password, from, to, subject, content, attachFileNames);
	}

}

/**
 * 异步发送邮件线程
 * @author David  david@yunjiaowu.cn
 */
class SendMail extends Thread {

	private static final Logger logger = Logger.getLogger(ToolMail.class);
	
	private String sendType;		// 发送邮件的类型：text 、html
	
	private String host;		// 发送邮件的服务器的IP
	private String port = "25";	// 发送邮件的服务器的端口
	
	private String from;		// 邮件发送者的地址
	private String userName;	// 登陆邮件发送服务器的用户名
	private String password;	// 登陆邮件发送服务器的密码
	
	private List<String> to;			// 邮件接收者的地址
	
	private boolean validate = false;	// 是否需要身份验证
	
	private String subject;		// 邮件标题
	private String content;		// 邮件的文本内容
	private String[] attachFileNames;	// 邮件附件的文件名

	public SendMail(String sendType, 
			String host, String port, boolean validate, String userName, String password,
			String from, List<String> to, 
			String subject, String content, String[] attachFileNames) {
		this.sendType = sendType;
		this.host = host;
		this.port = port;
		this.from = from;
		this.userName = userName;
		this.password = password;
		this.to = to;
		this.validate = validate;
		this.subject = subject;
		this.content = content;
		this.attachFileNames = attachFileNames;
		
		// tomcat服务器加上启动参数 -Djava.net.preferIPv4Stack=true   
		System.setProperty("java.net.preferIPv4Stack", "true");  
	}

	@Override
	public void run() {
		boolean sendMail = false;
		if(sendType.equals(ToolMailV2.sendType_text)){
			sendMail = sendTextMail();
			
		} else if(sendType.equals(ToolMailV2.sendType_html)){
			sendMail = sendHtmlMail();
			
		} else {
			logger.error("发送邮件参数sendType不能为空");
		}
		logger.info("发送邮件任务 结果: " + (sendMail ? "成功" : "失败"));
	}

	/**
	 * 获得邮件会话属性
	 */
	public Properties getProperties() {
		Properties prop = new Properties();
		prop.put("mail.smtp.host", this.host);
		prop.put("mail.smtp.port", this.port);
		prop.put("mail.smtp.auth", validate ? "true" : "false");
		
		if(this.host.indexOf("smtp.gmail.com") >= 0){
			prop.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); 
			prop.setProperty("mail.smtp.socketFactory.fallback", "false"); 
			prop.setProperty("mail.smtp.port", "465"); 
			prop.setProperty("mail.smtp.socketFactory.port", "465"); 
		}
		
		return prop;
	}

	/**
	 * 以文本格式发送邮件
	 */
	public boolean sendTextMail() {
		// 判断是否需要身份认证
		MailAuthenticator authenticator = null;
		Properties pro = getProperties();
		if (isValidate()) {
			// 如果需要身份认证，则创建一个密码验证器
			authenticator = new MailAuthenticator(getUserName(), getPassword());
		}
		
		// 根据邮件会话属性和密码验证器构造一个发送邮件的session
		Session sendMailSession = Session.getInstance(pro, authenticator);// getDefaultInstance
		
		try {
			// 根据session创建一个邮件消息
			Message mailMessage = new MimeMessage(sendMailSession);
			
			// 创建邮件发送者地址
			Address from = new InternetAddress(getFrom());
			
			// 设置邮件消息的发送者
			mailMessage.setFrom(from);
			
			// 创建邮件的接收者地址，并设置到邮件消息中
			Address[] tos = new InternetAddress[to.size()];
			for(int i=0; i<to.size(); i++){
				String receive = to.get(i);
				if(null != receive && !receive.isEmpty()){
					tos[i] = new InternetAddress(receive);
				}
			}
			
			// Message.RecipientType.TO属性表示接收者的类型为TO
			mailMessage.setRecipients(Message.RecipientType.TO, tos);

			// 设置邮件消息的主题
			mailMessage.setSubject(getSubject());
			
			// 设置邮件消息发送的时间
			mailMessage.setSentDate(new Date());
			
			Multipart multipart = new MimeMultipart();   
			
			// 正文
            MimeBodyPart mbp = new MimeBodyPart();   
            mbp.setText(getContent());
            multipart.addBodyPart(mbp);     
            
            // 附件
			for (String attachFile : attachFileNames) {
				mbp = new MimeBodyPart();   
                FileDataSource fds = new FileDataSource(attachFile); //得到数据源   
                
                mbp.setDataHandler(new DataHandler(fds)); //得到附件本身并至入BodyPart   
                String filename = MimeUtility.encodeText(fds.getName()); // 解决附件乱码
                mbp.setFileName(filename);  //得到文件名同样至入BodyPart   
                
                multipart.addBodyPart(mbp); 
			}
			
			// 设置邮件消息的主要内容
			mailMessage.setContent(multipart);
			
			// 发送邮件
			Transport.send(mailMessage);
			
			return true;
		} catch (MessagingException e) {
			logger.error("发送文本邮件异常：" + e.getMessage());
			e.printStackTrace();
			return false;
		} catch (UnsupportedEncodingException e) {
			logger.error("发送文本邮件异常：" + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 以HTML格式发送邮件
	 */
	public boolean sendHtmlMail() {
		// 判断是否需要身份认证
		MailAuthenticator authenticator = null;
		Properties pro = getProperties();
		// 如果需要身份认证，则创建一个密码验证器
		if (isValidate()) {
			authenticator = new MailAuthenticator(getUserName(), getPassword());
		}
		// 根据邮件会话属性和密码验证器构造一个发送邮件的session
		Session sendMailSession = Session.getInstance(pro, authenticator);// getDefaultInstance
		try {
			// 根据session创建一个邮件消息
			Message mailMessage = new MimeMessage(sendMailSession);
			// 创建邮件发送者地址
			Address from = new InternetAddress(getFrom());
			// 设置邮件消息的发送者
			mailMessage.setFrom(from);
			// 创建邮件的接收者地址，并设置到邮件消息中
			Address[] tos = new InternetAddress[to.size()];
			for(int i=0; i<to.size(); i++){
				String receive = to.get(i);
				if(null != receive && !receive.isEmpty()){
					tos[i] = new InternetAddress(receive);
				}
			}
			// Message.RecipientType.TO属性表示接收者的类型为TO
			mailMessage.setRecipients(Message.RecipientType.TO, tos);
			
			// 设置邮件消息的主题
			mailMessage.setSubject(getSubject());
			
			// 设置邮件消息发送的时间
			mailMessage.setSentDate(new Date());
			
			// MiniMultipart类是一个容器类，包含MimeBodyPart类型的对象
			Multipart multipart = new MimeMultipart();
			
			// 正文
			BodyPart mbp = new MimeBodyPart();
			mbp.setContent(getContent(), "text/html; charset=utf-8");// 设置HTML内容
			multipart.addBodyPart(mbp);
			
			// 附件
			for (String attachFile : attachFileNames) {
				mbp = new MimeBodyPart();   
                FileDataSource fds = new FileDataSource(attachFile); //得到数据源   
                
                mbp.setDataHandler(new DataHandler(fds)); //得到附件本身并至入BodyPart   
                String filename = MimeUtility.encodeText(fds.getName()); // 解决附件乱码
                mbp.setFileName(filename);  //得到文件名同样至入BodyPart   
                
                multipart.addBodyPart(mbp);
			}
			
			// 将MiniMultipart对象设置为邮件内容
			mailMessage.setContent(multipart);
			// 发送邮件
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException e) {
			logger.error("发送html邮件异常：" + e.getMessage());
			e.printStackTrace();
			return false;
		} catch (UnsupportedEncodingException e) {
			logger.error("发送html邮件异常：" + e.getMessage());
			e.printStackTrace();
			e.printStackTrace();
			return false;
		}
	}

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public List<String> getTo() {
		return to;
	}

	public void setTo(List<String> to) {
		this.to = to;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isValidate() {
		return validate;
	}

	public void setValidate(boolean validate) {
		this.validate = validate;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String[] getAttachFileNames() {
		return attachFileNames;
	}

	public void setAttachFileNames(String[] attachFileNames) {
		this.attachFileNames = attachFileNames;
	}

	public String getSendType() {
		return sendType;
	}

	public void setSendType(String sendType) {
		this.sendType = sendType;
	}
	
}

class MailAuthenticator extends Authenticator {
	String userName = null;
	String password = null;

	public MailAuthenticator() {
	}

	public MailAuthenticator(String username, String password) {
		this.userName = username;
		this.password = password;
	}

	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(userName, password);
	}
}
