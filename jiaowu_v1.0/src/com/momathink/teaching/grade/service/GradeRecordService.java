
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

package com.momathink.teaching.grade.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;
import com.momathink.teaching.grade.model.GradeDetail;
import com.momathink.teaching.grade.model.GradeRecord;

public class GradeRecordService extends BaseService {
	private static final Logger logger = Logger.getLogger(GradeRecordService.class);

	public void list(SplitPage splitPage) {
		logger.debug("成绩管理：分页处理");
		String select = " select graderecord.* ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from graderecord "
				+ " LEFT JOIN account ON graderecord.studentid = account.id where 1=1 ");
		if (null == queryParam) {
			return;
		}else{
			String studentId = queryParam.get("studentId");
			String subjectId = queryParam.get("subjectId");
			String studentName = queryParam.get("studentName");
			String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
			if (!ToolString.isNull(studentId)) {
				formSqlSb.append(" and studentid = ? ");
				paramValue.add(Integer.parseInt(studentId));
			}
			if (!ToolString.isNull(studentName)) {
				formSqlSb.append(" and studentname like ? ");
				paramValue.add("%"+studentName+"%");
			}
			if (!ToolString.isNull(subjectId)) {
				formSqlSb.append(" and subjectid = ? ");
				paramValue.add(Integer.parseInt(subjectId));
			}
			if( !ToolString.isNull( loginRoleCampusIds ) ){
				formSqlSb.append( " and campusid in (" + loginRoleCampusIds + ")" );
			}
		}
	}

	public void saveGradeInfo(GradeRecord record, List<GradeDetail> detailList) {
		if (record != null) {
			Date date = ToolDateTime.getDate();
			record.set("createtime", date);
			if (record.getDate("examdate") == null)
				record.set("examdate", ToolDateTime.format(date, ToolDateTime.pattern_ymd));
			record.save();
			if (detailList != null) {
				Integer recordId = record.getPrimaryKeyValue();
				for (GradeDetail detail : detailList) {
					detail.set("recordid", recordId);
					detail.set("createtime", date);
					detail.save();
				}
			}
		}
		logger.info("保存成绩成功");
	}

	public void deleteByRecordId(Integer paraToInt) {
		GradeDetail.dao.deleteByRecordId(paraToInt);
		GradeRecord.dao.deleteById(paraToInt);
	}
}
