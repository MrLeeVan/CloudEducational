
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

package com.momathink.common.handler;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jfinal.handler.Handler;
import com.momathink.common.tools.ToolContext;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolWeb;
import com.momathink.sys.system.model.SysLog;
import com.momathink.sys.system.model.ThreadSysLog;

/**
 * 全局Handler，设置一些通用功能
 * 
 * @author David 描述：主要是一些全局变量的设置，再就是日志记录开始和结束操作
 */
public class GlobalHandler extends Handler {

	public static final String reqSysLogKey = "reqSysLog";

	@Override
	public void handle(String target, HttpServletRequest request, HttpServletResponse response, boolean[] isHandled) {
		SysLog reqSysLog = getSysLog(request);
		long starttime = ToolDateTime.getDateByTime();
		reqSysLog.set("startdate", ToolDateTime.getSqlTimestamp(starttime));//开始时间
		reqSysLog.set("need", "0");
		request.setAttribute(reqSysLogKey, reqSysLog);
		
		String cxt = ToolContext.getContextAllPath(request);
		request.setAttribute("cxt", cxt);
		String cxting = ToolContext.getContextUrlPath(request);
		request.setAttribute("cxting", cxting);
		
		Map<String, Cookie> cookieMap = ToolWeb.readCookieMap(request);
		request.setAttribute("cookieMap", cookieMap);

		request.setAttribute("paramMap", ToolWeb.getParamMap(request));

		request.setAttribute("decorator", "none");
		response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
		response.setHeader("Pragma","no-cache"); //HTTP 1.0
		response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
		
		next.handle(target, request, response, isHandled);
		
		long endtime = ToolDateTime.getDateByTime();
		reqSysLog.set("enddate", ToolDateTime.getSqlTimestamp(endtime));
		
		Long haoshi = endtime - starttime;
		reqSysLog.set("haoshi", haoshi);
		if(isHandled[0]){
			if(reqSysLog.getStr("need").equals("1")){
				ThreadSysLog.add(reqSysLog);
			}
		}
	}
	
	/**
	 * 创建日志对象,并初始化一些属性值
	 * @param request
	 * @return
	 */
	public SysLog getSysLog(HttpServletRequest request){
		String requestPath = ToolWeb.getRequestURIWithParam(request); 
		String ip = ToolWeb.getIpAddr(request);
		String referer = request.getHeader("Referer"); 
		String userAgent = request.getHeader("User-Agent");
		String cookie = request.getHeader("Cookie");
		String method = request.getMethod();
		String xRequestedWith = request.getHeader("X-Requested-With");
		String host = request.getHeader("Host");
		String acceptLanguage = request.getHeader("Accept-Language");
		String acceptEncoding = request.getHeader("Accept-Encoding");
		String accept = request.getHeader("Accept");
		String connection = request.getHeader("Connection");

		SysLog reqSysLog = new SysLog();
		
		reqSysLog.set("ips", ip);
		reqSysLog.set("requestpath", requestPath);
		reqSysLog.set("referer", referer);
		reqSysLog.set("useragent", userAgent);
		reqSysLog.set("cookie", cookie);
		reqSysLog.set("method", method);
		reqSysLog.set("xrequestedwith", xRequestedWith);
		reqSysLog.set("host", host);
		reqSysLog.set("acceptlanguage", acceptLanguage);
		reqSysLog.set("acceptencoding", acceptEncoding);
		reqSysLog.set("accept", accept);
		reqSysLog.set("connection", connection);

		return reqSysLog;
	}
	
	
	
	
}
