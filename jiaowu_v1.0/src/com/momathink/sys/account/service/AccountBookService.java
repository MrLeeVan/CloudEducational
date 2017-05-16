
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

package com.momathink.sys.account.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.sys.account.model.AccountBook;

public class AccountBookService extends BaseService {
	
	public static final AccountBookService me = new AccountBookService();
	
	
	public void list(SplitPage splitPage) {
		String select = " select ab.*, a.REAL_NAME as stuName, "
				+ " operate.REAL_NAME as operateName,cco.teachtype teachtype,"
				+ " classo.classNum xiaobanName, c.COURSE_NAME courseName,cp.orderid cpid ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from account_book ab ");
		formSqlSb.append(" left join account a on ab.accountid=a.id "
				+ " left join crm_payment cp on ab.paymentid = cp.id "
				+ " left join account operate on operate.id=ab.createuserid "
				+ " left join course c on c.Id = ab.courseid "
				+ " left join crm_courseorder cco on cco.id = ab.orderid "
				+ " left join class_order classo on classo.id= ab.classorderid  where 1=1 ");
		if (null == queryParam) {
			return;
		}

		String accountid = queryParam.get("accountid");
		if (!StringUtils.isEmpty(accountid)) {
			formSqlSb.append(" and ab.accountid = ? ");
			paramValue.add(Integer.parseInt(accountid));
		}
		formSqlSb.append(" order by ab.id desc");
	}

	@Before(Tx.class)
	public void save(AccountBook accountBook) {
		try {
			// 保存顾问
			accountBook.set("createtime", new Date());
			accountBook.save();
		} catch (Exception e) {
			throw new RuntimeException("保存用户异常");
		}
	}
}
