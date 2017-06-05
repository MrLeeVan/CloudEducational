
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

package com.momathink.common.base;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;

public abstract class BaseService {

	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(BaseService.class);

	/**
	 * 把11,22,33...转成'11','22','33'...
	 * 
	 * @param ids
	 * @return
	 */
	protected String toSql(String ids) {
		if (null == ids || ids.isEmpty()) {
			return "";
		}

		String[] idsArr = ids.split(",");
		StringBuilder sqlSb = new StringBuilder();
		int length = idsArr.length;
		for (int i = 0, size = length - 1; i < size; i++) {
			sqlSb.append(" '").append(idsArr[i]).append("', ");
		}
		if (length != 0) {
			sqlSb.append(" '").append(idsArr[length - 1]).append("' ");
		}

		return sqlSb.toString();
	}

	/**
	 * 分页
	 * 
	 * @param splitPage
	 * @param select
	 * @return
	 */
	protected void splitPageBase(SplitPage splitPage, String select) {
		// 接收返回值对象
		StringBuilder formSqlSb = new StringBuilder();
		List<Object> paramValue = new LinkedList<Object>();

		// 调用生成from sql，并构造paramValue
		makeFilter(splitPage.getQueryParam(), formSqlSb, paramValue);

		// 行级：过滤
		rowFilter(formSqlSb);

		// 排序
		String orderColunm = splitPage.getOrderColunm();
		String orderMode = splitPage.getOrderMode();
		if (null != orderColunm && !orderColunm.isEmpty() && null != orderMode && !orderMode.isEmpty()) {
			formSqlSb.append(" order by ").append(orderColunm).append(" ").append(orderMode);
		}

		String formSql = formSqlSb.toString();

		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select, formSql, paramValue.toArray());
		splitPage.setPage(page);
	}

	/**
	 * 行级：过滤
	 * 
	 * @return
	 */
	protected void rowFilter(StringBuilder formSqlSb) {
		
	}

	/**
	 * 查询条件过滤
	 * 
	 * @return
	 */
	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {

	}
}
