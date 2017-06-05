
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

package com.momathink.finance.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CoursePrice;

public class CoursePriceService extends BaseService {
	
	public static final CoursePriceService me = new CoursePriceService();

	public void list(SplitPage splitPage) {
		String select = "SELECT c.*,s.SUBJECT_NAME ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" FROM course c LEFT JOIN `subject` s ON c.SUBJECT_ID=s.Id WHERE c.SUBJECT_ID != 0 ");
		if (null == queryParam) {
			return;
		}

		String coursename = queryParam.get("coursename");
		String subjectid = queryParam.get("subjectid");
		if (null != coursename && !coursename.equals("")) {
			formSqlSb.append(" AND c.course_name like ? ");
			paramValue.add("%" + coursename + "%");
		}
		if (null != subjectid && !subjectid.equals("")) {
			formSqlSb.append(" AND c.subject_id =? ");
			paramValue.add(Integer.parseInt(subjectid));
		}
		formSqlSb.append(" ORDER BY c.id,c.subject_id");
	}
	
	@Before(Tx.class)
	public void save(CoursePrice coursePrice) {
		try {
			coursePrice.set("createtime", ToolDateTime.getDate());
			coursePrice.save();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("添加数据异常");
		}
	}
	
	@Before(Tx.class)
	public void update(CoursePrice coursePrice) {
		try {
			coursePrice.set("updatetime", new Date());
			coursePrice.update();
		} catch (Exception e) {
			throw new RuntimeException("更新数据异常");
		}
	}
	
	public boolean delete(Integer id) {
		CoursePrice.dao.deleteById(id);
		return true;
	}
}
