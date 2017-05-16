
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

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.momathink.common.base.BaseController;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;

/**
 * 参数封装拦截器
 * 
 * @author David
 */
public class ParamPkgInterceptor implements Interceptor {

	private static Logger log = Logger.getLogger(ParamPkgInterceptor.class);

	@Override
	public void intercept(Invocation ai) {
		BaseController controller = (BaseController) ai.getController();

		Class<?> controllerClass = controller.getClass();
		Class<?> superControllerClass = controllerClass.getSuperclass();

		Field[] fields = controllerClass.getDeclaredFields();
		Field[] parentFields = superControllerClass.getDeclaredFields();

		log.debug("*********************** 封装参数值到 controller 全局变量  start ***********************");

		// 是否需要分页

		splitPage(controller, superControllerClass);

		// 封装controller变量值
		for (Field field : fields) {
			setControllerFieldValue(controller, field);
		}

		// 封装baseController变量值
		for (Field field : parentFields) {
			setControllerFieldValue(controller, field);
		}

		log.debug("*********************** 封装参数值到 controller 全局变量  end ***********************");

		ai.invoke();

		log.debug("*********************** 设置全局变量值到 request start ***********************");

		// 封装controller变量值
		for (Field field : fields) {
			setRequestValue(controller, field);
		}

		// 封装baseController变量值
		for (Field field : parentFields) {
			setRequestValue(controller, field);
		}

		log.debug("*********************** 设置全局变量值到 request end ***********************");
	}

	/**
	 * 分页参数处理
	 * 
	 * @param controller
	 * @param superControllerClass
	 */
	public void splitPage(BaseController controller, Class<?> superControllerClass){
		SplitPage splitPage = new SplitPage();
		// 分页查询参数分拣
		Map<String, String> queryParam = new HashMap<String, String>();
		Enumeration<String> paramNames = controller.getParaNames();
		String name = null;
		String value = null;
		String key = null;
		while (paramNames.hasMoreElements()) {
			name = paramNames.nextElement();
			value = controller.getPara(name);
			if (name.startsWith("_query") && null != value && !value.trim().isEmpty()) {// 查询参数分拣
				log.debug("分页，查询参数：name = " + name + " value = " + value);
				key = name.substring(7);
				if(ToolString.regExpVali(key, ToolString.regExp_letter_5)){
					queryParam.put(key, value.trim());
				}else{
					log.error("分页，查询参数存在恶意提交字符：name = " + name + " value = " + value);
				}
			}
		}
		splitPage.setQueryParam(queryParam);
		
		String orderColunm = controller.getPara("orderColunm");// 排序条件
		if(null != orderColunm && !orderColunm.isEmpty()){
			log.debug("分页，排序条件：orderColunm = " + orderColunm);
			splitPage.setOrderColunm(orderColunm);
		}

		String orderMode = controller.getPara("orderMode");// 排序方式
		if(null != orderMode && !orderMode.isEmpty()){
			log.debug("分页，排序方式：orderMode = " + orderMode);
			splitPage.setOrderMode(orderMode);
		}

		String pageNumber = controller.getPara("pageNumber");// 第几页
		if(null != pageNumber && !pageNumber.isEmpty()){
			log.debug("分页，第几页：pageNumber = " + pageNumber);
			splitPage.setPageNumber(Integer.parseInt(pageNumber));
		}
		
		String pageSize = controller.getPara("pageSize");// 每页显示几多
		if(null != pageSize && !pageSize.isEmpty()){
			log.debug("分页，每页显示几多：pageSize = " + pageSize);
			splitPage.setPageSize(Integer.parseInt(pageSize));
		}
		
		controller.setSplitPage(splitPage);
	}

	/**
	 * 反射set值到全局变量
	 * 
	 * @param controller
	 * @param field
	 */
	public void setControllerFieldValue(BaseController controller, Field field) {
		try {
			field.setAccessible(true);
			String name = field.getName();
			String value = controller.getPara(name);
			if (null == value || value.isEmpty()) {// 参数值为空直接结束
				log.debug("参数值为空");
				return;
			}
			String fieldType = field.getType().getSimpleName();
			if (fieldType.equals("String")) {
				field.set(controller, value);

			} else if (fieldType.equals("int")) {
				field.set(controller, Integer.parseInt(value));

			} else if (fieldType.equals("Date")) {
				int dateLength = value.length();
				if (dateLength == ToolDateTime.pattern_ymd.length()) {
					field.set(controller, ToolDateTime.parse(value, ToolDateTime.pattern_ymd));

				} else if (dateLength == ToolDateTime.pattern_ymd_hms.length()) {
					field.set(controller, ToolDateTime.parse(value, ToolDateTime.pattern_ymd_hms));

				} else if (dateLength == ToolDateTime.pattern_ymd_hms_s.length()) {
					field.set(controller, ToolDateTime.parse(value, ToolDateTime.pattern_ymd_hms_s));
				}

			} else if (fieldType.equals("BigDecimal")) {
				BigDecimal bdValue = new BigDecimal(value);
				field.set(controller, bdValue);

			} else {
				log.debug("没有解析到有效字段类型");
			}
		} catch (IllegalArgumentException e1) {
			e1.printStackTrace();
		} catch (IllegalAccessException e1) {
			e1.printStackTrace();
		} finally {
			field.setAccessible(false);
		}
	}

	/**
	 * 反射全局变量值到request
	 * 
	 * @param controller
	 * @param field
	 */
	public void setRequestValue(BaseController controller, Field field) {
		try {
			field.setAccessible(true);
			Object value = field.get(controller);
			if (null == value) {// 参数值为空直接结束
				log.debug("参数值为空");
				return;
			}
			String name = field.getName();
			controller.setAttr(name, value);
		} catch (IllegalArgumentException e1) {
			e1.printStackTrace();
		} catch (IllegalAccessException e1) {
			e1.printStackTrace();
		} finally {
			field.setAccessible(false);
		}
	}
}
