
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

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.Payment;

public class PaymentService extends BaseService {
	
	public static final Payment dao = new Payment();

	public void list(SplitPage splitPage) {
		String select = "select cp.id,s.REAL_NAME studentname,cp.createtime,cp.amount,cp.ispay,cp.paydate,cp.paytype,u.REAL_NAME operatename,co.ordernum,co.delflag,co.delreason ";
		splitPageBase(splitPage, select);
	}

	protected void makeFilter(Map<String, String> queryParam, StringBuilder formSqlSb, List<Object> paramValue) {
		formSqlSb.append(" from crm_payment cp \n" 
				+ "left join crm_courseorder co on cp.orderid=co.id\n" 
				+ "left join account u on cp.operatorid=u.id "
				+ "left join account s on cp.studentid=s.id "
				+ "where co.delflag=0\n");
		if (null == queryParam) {
			return;
		}
		String loginRoleCampusIds = queryParam.get( "loginRoleCampusIds" );
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "studentId":
				formSqlSb.append(" and cp.studentid = ? ");
				paramValue.add(Integer.parseInt(value));
				break;
			case "studentname":
				formSqlSb.append(" and s.real_name like ? ");
				paramValue.add("%"+value+"%");
				break;
			case "startDate":// 添加日期
				formSqlSb.append(" and cp.createtime>= ? ");
				paramValue.add( value + " 00:00:00");
				break;
			case "endDate":// 添加日期
				formSqlSb.append(" and cp.createtime<= ? ");
				paramValue.add( value + " 59:59:59");
				break;
			default:
				break;
			}
		}
		if( !StringUtils.isEmpty( loginRoleCampusIds )){
			formSqlSb.append( " and s.campusid in (" + loginRoleCampusIds + ")" );
		}
		formSqlSb.append(" order by cp.createtime desc ");
	}
	
	@Before(Tx.class)
	public void save(Payment payment) {
		try {
			payment.set("createtime", ToolDateTime.getDate());
			payment.save();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("添加数据异常");
		}
	}
	
	@Before(Tx.class)
	public void update(Payment payment) {
		try {
			payment.set("updatetime", new Date());
			payment.update();
		} catch (Exception e) {
			throw new RuntimeException("更新数据异常");
		}
	}

	public double getPaidAmount(Integer courseOrderId) {
		BigDecimal sum = Db.queryBigDecimal("SELECT SUM(amount) FROM crm_payment WHERE orderid=?",courseOrderId);
		return sum==null?0:sum.doubleValue();
	}

	public Map<String, String> queryPrice(String studentId, String classType) {
		Map<String, String> result = new HashMap<String, String>();
		int teachType = 1;
		long price = 0;
		String ispay = "0";
		if (!"0".equals(classType)) {
			teachType = 2;
		}
		List<Payment> plist = Payment.dao.findbyStuIdAndTeachType(studentId, teachType);
		for (Payment payment : plist) {
			long remain = payment.getLong("remain") == null ? 0 : payment.getLong("remain");
			if (remain == 0) {
				continue;
			} else {
				price = payment.getLong("price") == null ? 0 : payment.getLong("price");
				ispay = payment.getStr("ispay");
				payment.set("remain", remain - 1);
				payment.update();
				result.put("price", price + "");
				result.put("ispay", ispay);
				result.put("paymentid", payment.getPrimaryKeyValue().toString());
				break;
			}
		}
		return result;
	}
}
