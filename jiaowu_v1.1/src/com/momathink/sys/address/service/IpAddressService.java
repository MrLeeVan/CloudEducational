
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

package com.momathink.sys.address.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.address.model.IpAddressDetail;
import com.momathink.sys.address.model.IpAddressRecord;

public class IpAddressService extends BaseService{
	private static final Logger logger = Logger.getLogger(IpAddressService.class);

	public void list(SplitPage splitPage) {
		logger.debug("IP管理：分页处理");
		String select = " select ip.*,c.CAMPUS_NAME ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from ipaddress ip left join campus c on ip.campus_id=c.Id where 1=1 ");
		if (null == queryParam) {
			return;
		}else{
			String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
			String id = queryParam.get("Id");
			String name=queryParam.get("name");
			if (!ToolString.isNull(id)) {
				formSqlSb.append(" and ip.Id = ? ");
				paramValue.add(Integer.parseInt(id));
			}
			if(!ToolString.isNull(name)){
				formSqlSb.append(" and name like ? ");
				paramValue.add("%"+name+"%");
			}
			if( !ToolString.isNull( loginRoleCampusIds ) ){
				formSqlSb.append( " and c.id in (" + loginRoleCampusIds + ")" );
			}
		}
		formSqlSb.append( " order by ip.id desc " );
	}

	public void saveIpAddressInfo(IpAddressRecord record, List<IpAddressDetail> detailList) {
		if (record != null) {
			Date date = ToolDateTime.getDate();
			record.set("create_time", date);
			record.save();
			if (detailList != null) {
				Integer recordId = record.getPrimaryKeyValue();
				for (IpAddressDetail detail : detailList) {
					detail.set("recordid", recordId);
					detail.set("createtime", date);
					detail.save();
				}
			}
		}
		logger.info("保存IP成功");
	}

	public void deleteByRecordId(Integer paraToInt) {
		IpAddressDetail.dao.deleteByRecordId(paraToInt);
		IpAddressRecord.dao.deleteById(paraToInt);
	}

}
