
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
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.sys.operator.model.Operator;
import com.momathink.sys.operator.model.Role;

/**
 * WEB上下文工具类
 * 
 * @author David 2012-9-7 下午1:51:04
 */
public class ToolContext {

	private static Logger log = Logger.getLogger(ToolContext.class);

	/**
	 * 输出servlet文本内容
	 * 
	 * @author David 2012-9-14 下午8:04:01
	 * @param response
	 * @param content
	 */
	public static void outPage(HttpServletResponse response, String content) {
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding(ToolString.encoding);
		// PrintWriter out = response.getWriter();
		// out.print(content);
		try {
			response.getOutputStream().write(content.getBytes(ToolString.encoding));// char to byte 性能提升
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 输出CSV文件下载
	 * 
	 * @author David 2012-9-14 下午8:02:33
	 * @param response
	 * @param content CSV内容
	 */
	public static void outDownCsv(HttpServletResponse response, String content) {
		response.setContentType("application/download; charset=gb18030");
		try {
			response.setHeader("Content-Disposition", "attachment; filename=" + java.net.URLEncoder.encode(ToolDateTime.format(ToolDateTime.getDate(), ToolDateTime.pattern_ymd_hms_s) + ".csv", ToolString.encoding));
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		// PrintWriter out = response.getWriter();
		// out.write(content);
		try {
			response.getOutputStream().write(content.getBytes(ToolString.encoding));
		} catch (IOException e) {
			e.printStackTrace();
		}// char to byte 性能提升
			// out.flush();
			// out.close();
	}

	/**
	 * 获取上下文URL全路径
	 * 
	 * @param request
	 * @return
	 */
	public static String getContextAllPath(HttpServletRequest request) {
		StringBuilder sb = new StringBuilder();
		sb.append(request.getScheme()).append("://").append(request.getServerName()).append(":").append(request.getServerPort()).append(request.getContextPath());
		String path = sb.toString();
		sb = null;
		return path;
	}
	
	/**
	 * 获取上下文URL路径
	 * 
	 * @param request
	 * @return
	 */
	public static String getContextUrlPath(HttpServletRequest request) {
		StringBuilder sb = new StringBuilder();
		sb.append(request.getScheme()).append("://").append(request.getServerName());
		String path = sb.toString();
		sb = null;
		return path;
	}

	/**
	 * 获取请求参数
	 * 
	 * @param request
	 * @param name
	 * @return
	 */
	public static String getParam(HttpServletRequest request, String name) {
		String value = request.getParameter(name);
		if (null != value && !value.isEmpty()) {
			try {
				value = URLDecoder.decode(value, ToolString.encoding).trim();
			} catch (UnsupportedEncodingException e) {
				log.error("decode异常：" + value);
			}
		}
		return value;
	}

	/**
	 * 请求流转字符串
	 * 
	 * @param request
	 * @return
	 */
	public static String requestStream(HttpServletRequest request) {
		try {
			BufferedReader br = new BufferedReader(new InputStreamReader((ServletInputStream) request.getInputStream()));
			String line = null;
			StringBuilder sb = new StringBuilder();
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			return sb.toString();
		} catch (IOException e) {
			e.printStackTrace();
			log.error("request.getInputStream() to String 异常");
		}
		return null;
	}
	
	/**
	 * 判断用户是否对某个功能具有操作权限
	 * @param operator
	 * @param user
	 * @return 
	 */
	public static boolean hasPrivilegeOperator(Operator operator, Record user) {
		// 根据分组查询权限
		String roleIdsStr = user.getStr("roleids");
		if(null != roleIdsStr && roleIdsStr.length() > 1){
			List<Role> roles = ToolOperatorSession.getRole(roleIdsStr);
			for (Role role : roles) {
				String operatorIdsStr = role.getStr("operatorids");
				if(StrKit.notBlank(operatorIdsStr))
					if (operatorIdsStr.indexOf("operator_"+operator.getInt("id")+",") != -1)
						return true;
				else
					continue;
			}
		}

		// 根据岗位查询权限
		/*String stationIds = user.getStr("stationids");
		if (null != stationIds) {
			String[] stationIdsArr = stationIds.split(",");
			for (String ids : stationIdsArr) {
				Station station = Station.dao.cacheGet(ids);;
				String operatorIdsStr = station.getStr("operatorids");
				if(null == operatorIdsStr || operatorIdsStr.equals("")){
					continue;
				}
				if (operatorIdsStr.indexOf(operatorIds) != -1) {
					return true;
				}
			}
		}*/

		return false;
	}
	
	public static boolean hasPrivilegeUrl(String url, String userIds) {
		// 基于缓存查询operator
		Operator operator = Operator.dao.cacheGet(url);
		if (null == operator) {
			log.error("URL缓存不存在：" + url);
			return false;
		}

		// 基于缓存查询user
		Record userObj = Db.findById("account", userIds);
		if (null == userObj) {
			log.error("用户缓存不存在：" + userIds);
			return false;
		}

		return hasPrivilegeOperator(operator, userObj);
	}
	
}
