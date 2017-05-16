
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

package com.momathink.common.interceptor;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseController;
import com.momathink.common.handler.GlobalHandler;
import com.momathink.common.tools.ToolContext;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.sys.operator.model.Operator;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysLog;

/**
 * 权限认证拦截器
 * @author rongqiang.pu
 */
public class AuthenticationInterceptor implements Interceptor {
	
	private static Logger log = Logger.getLogger(AuthenticationInterceptor.class);
	
	@Override
	public void intercept(Invocation ai) {
		BaseController contro = (BaseController) ai.getController();
		HttpServletRequest request = contro.getRequest();
		
		log.info("获取reqSysLog!");
		SysLog reqSysLog = contro.getAttr(GlobalHandler.reqSysLogKey);
		contro.setReqSysLog(reqSysLog);

		String uri = ai.getActionKey(); // 默认就是ActionKey
		if(ai.getMethodName().equals("toUrl")){
			uri = ToolContext.getParam(request, "toUrl"); // 否则就是toUrl的值
		}
		log.info(uri);
		reqSysLog.set("uri", uri);

		Record user = null;
		if(contro.getSysuserId()!=null){
			user = contro.getAccount();// 当前登录用户
		}
		if(null != user){
			contro.setAttr("cUser", user);
			reqSysLog.set("userids", user.get("id"));
			reqSysLog.set("username", user.getStr("real_name"));
			contro.setAttr("cUserIds", user.get("id"));
		}
		
		if(uri.contains("/wesite")){
			log.info("URI免验证!");
			reqSysLog.set("status", "1");//成功
			Date actionStartDate = ToolDateTime.getDate();//action开始时间
			reqSysLog.set("actionstartdate", ToolDateTime.getSqlTimestamp(actionStartDate));
			reqSysLog.set("actionstarttime", actionStartDate.getTime());
			
			ai.invoke();
			
			return;
		}
			Object operatorObj = Operator.dao.cacheGet(uri);
			if(null != operatorObj){
				log.info("URI存在!");
				Operator operator = (Operator) operatorObj;
				reqSysLog.set("operatorids", operator.getPrimaryKeyValue());
				if(operator.get("privilege").equals("1")){// 是否需要权限验证
					log.info("需要权限验证!");
					reqSysLog.set("need", "1");
					if (user == null) {
						log.info("权限认证过滤器检测:未登录!");
						reqSysLog.set("status", "0");//失败
						reqSysLog.set("description", "未登录");
						reqSysLog.set("cause", "2");//2 未登录
						toInfoJsp(contro, 1);
						return;
					}else{
						if(Role.isAdmins(user.getStr("roleids"))){
							log.info("管理员不需要验证");
							reqSysLog.set("status", "1");//成功
							Date actionStartDate = ToolDateTime.getDate();//action开始时间
							reqSysLog.set("actionstartdate", ToolDateTime.getSqlTimestamp(actionStartDate));
							reqSysLog.set("actionstarttime", actionStartDate.getTime());
						}else{
							if(!ToolContext.hasPrivilegeOperator(operator, user)){// 权限验证
								log.info("权限验证失败，没有权限!");
								
								reqSysLog.set("status", "0");//失败
								reqSysLog.set("description", "没有权限!");
								reqSysLog.set("cause", "0");//没有权限
								
								toInfoJsp(contro, 2);
								return;
							}
						}
					}
				}else{
					reqSysLog.set("need", "0");
					log.info("不需要权限验证.");
				}
				log.info("权限认证成功!!!继续处理请求...");
				/*log.info("是否需要表单重复提交验证!");
				if(operator.getStr("formtoken").equals("1")){
					String tokenRequest = ToolContext.getParam(request, "formToken");
					String tokenCookie = ToolWeb.getCookieValueByName(request, "token");
					if(null == tokenRequest || tokenRequest.equals("")){
						log.info("tokenRequest为空，无需表单验证!");
					}else if(null == tokenCookie || tokenCookie.equals("") || !tokenCookie.equals(tokenRequest)){
						log.info("tokenCookie为空，或者两个值不相等，把tokenRequest放入cookie!");
						ToolWeb.addCookie(response,  "token", tokenRequest, 0);
					}else if(tokenCookie.equals(tokenRequest)){
						log.info("表单重复提交!");
						toInfoJsp(contro, 4);
						return;
						
					}else{
						log.error("表单重复提交验证异常!!!");
					}
				}*/
				log.info("权限认真成功更新日志对象属性!");
				reqSysLog.set("status", "1");//成功
				Date actionStartDate = ToolDateTime.getDate();//action开始时间
				reqSysLog.set("actionstartdate", ToolDateTime.getSqlTimestamp(actionStartDate));
				reqSysLog.set("actionstarttime", actionStartDate.getTime());
				try {
					ai.invoke();
					if(user==null){
						user = Db.findById("account", contro.getSysuserId());
						if(user!=null){
							reqSysLog.set("userids", user.get("id"));
							reqSysLog.set("username", user.getStr("real_name"));
							reqSysLog.set("need", "1");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					log.info("业务逻辑代码遇到异常时保存日志!");
					toInfoJsp(contro, 5);
					
				} finally {
					
				}
			}else{
				log.info("访问失败时保存日志!");
				reqSysLog.set("status", "0");//失败
				reqSysLog.set("description", "URL不存在");
				reqSysLog.set("cause", "1");//URL不存在
				log.info("URI不存在!");
				toInfoJsp(contro, 6);
				return;
			}
	}
	
	/**
	 * 提示信息展示页
	 * @param contro
	 * @param type
	 */
	private void toInfoJsp(BaseController contro, int type) {
		if(type == 1){// 未登录处理
			contro.redirect("/account/login");
			return ;
		}

		String referer = contro.getRequest().getHeader("X-Requested-With"); 
		String toPage = "/common/msgAjax.html";
		if(null == referer || referer.isEmpty()){
			toPage = "/common/msg.html";
		}
		
		String msg = null;
		if(type == 2){// 权限验证失败处理
			msg = "权限验证失败!";
			toPage = "/common/401.html";
		}else if(type == 3){// IP验证失败
			msg = "IP验证失败!";
			toPage = "/common/401.html";
		}else if(type == 4){// 表单验证失败
			msg = "请不要重复提交表单数据!";
			toPage = "/common/401.html";
		}else if(type == 5){// 业务代码异常
			msg = "业务代码异常!";
			toPage = "/common/500.html";
		}else if(type == 6){
			msg = "请求路径不存在!";
			toPage = "/common/404.html";
		}else{
			toPage = "/common/404.html";
		}
		
		contro.setAttr("referer", referer);
		contro.setAttr("msg", msg);
		contro.render(toPage);
	}
	
}
