
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

package com.momathink.sys.tool.controller;

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolDateTime;

/**
 * excel 工具
 * @ClassName: ExcelController
 * @author dufuzhong
 * @date 2016年11月19日 下午2:18:52
 */
@Controller(controllerKey="/tool/excel")
public class ExcelController extends BaseController {
	
	/**导出
	<br>
	%3F 代表 ?    %3D 代表  =     %26  代表  & 
	中文参数需要自己处理一下
	<a target="_blank" href='/tool/excel/export?name=导出文件的名称&downloadUrl=渲染页面的请求地址%3F挂参%3D参数&preview=preview' 
	>导出</a>
	 * */
	public void export(){
		setAttr("name", getPara("name"));//导出文件的名称
		setAttr("downloadUrl", getPara("downloadUrl"));//渲染页面的请求地址
		setAttr("preview", getPara("preview"));//是否预览 preview=preview
		renderJsp("/WEB-INF/view/sys/tool/toexcel.jsp");
	}
	
	/**转xls 并让客户端下载*/
	public void toxls(){
		getFile();
		String htmlSrc = getPara("html");
		htmlSrc = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'><head><meta http-equiv=Content-Type content='text/html; charset=utf-8'><meta name=ProgId content=Excel.Sheet><meta name=Generator content='Microsoft Excel 15'></head><body>" 
		+ htmlSrc + "</body></html>";
		String name = getPara("name");
		name = name + ToolDateTime.format(ToolDateTime.getDate(), ToolDateTime.pattern_ymd) + ".xls";
		writeStream(name, htmlSrc, getResponse(), getRequest());
		renderNull();
	}
	
	/**
	 * 写到输出流
	 */
	private static void writeStream(String filename, String javaSrc, HttpServletResponse response, HttpServletRequest request) {

		try {
			String agent = request.getHeader("USER-AGENT");

			filename.replaceAll("/", "-");
			// filename = new String(filename.getBytes("gbk"),"ISO8859_1");

			if (agent.toLowerCase().indexOf("firefox") > 0) {
				filename = new String(filename.getBytes("utf-8"), "iso-8859-1");
			} else {
				filename = URLEncoder.encode(filename, "UTF-8");
			}

			response.reset();
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; filename=" + filename);
			response.setContentType("application/octet-stream;charset=UTF-8");
			OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
			outputStream.write(javaSrc.getBytes());
			outputStream.flush();
			outputStream.close();

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
