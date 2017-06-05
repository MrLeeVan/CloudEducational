
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

package com.momathink.teaching.document.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;

/**
 * 2015年8月19日prq
 * @author prq
 *
 */

public class DocumentService extends BaseService {

	private static final Logger logger = Logger.getLogger(DocumentService.class);

	public void documentList(SplitPage splitPage, String loginRoleCampusIds) {
		
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer select =new StringBuffer("SELECT pul.*,stu.real_name stuname,uld.real_name uldname ");
		StringBuffer formSqlSb= new StringBuffer(" FROM pt_upload pul left join account stu on stu.id=pul.studentid left join account uld on uld.id=pul.uploaduser where 1=1 ");
		Map<String,String> queryParam = splitPage.getQueryParam();
		String studentname = queryParam.get("studentname");
		String begintime = queryParam.get("begindate");
		String endtime = queryParam.get("enddate");
		String documentname = queryParam.get("documentname");
		if (!StringUtils.isEmpty(studentname)) {
			logger.info("按学生姓名查询");
			formSqlSb.append(" AND stu.real_name like ").append("'%"+studentname+"%'");
		}
		if (!StringUtils.isEmpty(begintime)) {
			logger.info("上传时间开始");
			formSqlSb.append(" AND DATE_FORMAT(pul.uploadtime,'%Y-%m-%d') >= ? ");
			paramValue.add(begintime);
		}
		if (!StringUtils.isEmpty(endtime)) {
			logger.info("上传时间截止");
			formSqlSb.append(" AND DATE_FORMAT(pul.uploadtime,'%Y-%m-%d') <= ? ");
			paramValue.add(endtime);
		}
		if (!StringUtils.isEmpty(documentname)) {
			logger.info("按文档名称查询");
			formSqlSb.append(" AND pul.documentname like ").append("'%"+documentname+"%'");
		}
		if ( !StringUtils.isEmpty( loginRoleCampusIds ) ){
			logger.info( "当前登录角色所属的校区");
			formSqlSb.append( " AND stu.campusid in (" + loginRoleCampusIds + ")" );
		}
		formSqlSb.append(" order by pul.id desc ");
		
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSqlSb.toString(), paramValue.toArray());
		splitPage.setPage(page);
	}
	
	
}
