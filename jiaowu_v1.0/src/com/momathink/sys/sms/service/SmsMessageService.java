
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

package com.momathink.sys.sms.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.sys.sms.model.SmsMessage;

public class SmsMessageService extends BaseService{
	
	public static final SmsMessageService me = new SmsMessageService(); 
			
	
	/**
	 * 下发短信的记录分页
	 */
	public void smsMessagelist(SplitPage splitPage) {
		 List<Object> paramValue = new ArrayList<Object>();
			StringBuffer select = new StringBuffer(" select * " );
			StringBuffer formSql = new StringBuffer("from crm_smsmessage where 1=1 ");
			
			Map<String,String> queryParam = splitPage.getQueryParam();
			Set<String> paramKeySet = queryParam.keySet();
			for (String paramKey : paramKeySet) {
				String value = queryParam.get(paramKey);
				switch (paramKey) {
				case "recipient_tel":
					formSql.append(" and recipient_tel like '%").append(value).append("%'");
					break;
				case "send_time":
					formSql.append(" and DATE_FORMAT(send_time,'%Y-%m-%d') = ").append(value);
					break;
				case "send_state":
				formSql.append(" and send_state = ").append(value);
				break;
				default:
					break;
				}
			}
			formSql.append(" order by send_time desc ");
			Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
			splitPage.setPage(page);
		}
	/**
	 * 保存发送短信的消息记录
	 */
	public void saveSendMessage(String tel,Integer type,String time,Integer state, String msg ){
		SmsMessage s = new SmsMessage();
		s.set("recipient_tel", tel).set("recipient_type", type).set("send_time", time).set("send_state",state).set("send_msg",msg).save();
	}
}
