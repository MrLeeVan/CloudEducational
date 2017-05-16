
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

package com.momathink.sys.account.model;

import java.util.List;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;

@Table(tableName = "account_book")
public class AccountBook extends BaseModel<AccountBook> {
	private static final long serialVersionUID = 966792592703947013L;
	public static final AccountBook dao = new AccountBook();

	public List<AccountBook> findByAccountId(String accountId) {
		return StringUtils.isEmpty(accountId) ? null : dao.find("select * from account_book where accountid=? order by id desc",
				Integer.parseInt(accountId));
	}

	/**
	 * 跟进课程安排ID查询流水记录
	 * @param courseplanId
	 * @return
	 */
	public List<AccountBook> findByCourseplanId(String courseplanId) {
		return StringUtils.isEmpty(courseplanId)?null:dao.find("select * from account_book where courseplanid= ? and `status` = 0 order by id desc ",Integer.parseInt(courseplanId));
	}

	/**
	 * 跟进渠道查询相应月份的VIP消耗情况
	 * @param mediatorId
	 * @param statMonth
	 * @return
	 */
	public List<AccountBook> queryVipDetail(String mediatorId, String statMonth) {
		if(StringUtils.isEmpty(mediatorId)||StringUtils.isEmpty(statMonth)){
			return null;
		}else{
			String sql ="SELECT b.*,s.id studentid,s.REAL_NAME studentname,s.mediatorid,m.realname mediatorname,'一对一' teachtype ,DATE_FORMAT(c.COURSE_TIME,'%Y-%m-%d') statmonth,t.class_hour ks,b.realamount sxh,b.rewardamount xxh\n" +
					"FROM account_book b \n" +
					"LEFT JOIN account s ON b.accountid=s.Id\n" +
					"LEFT JOIN courseplan c ON b.courseplanid=c.Id\n" +
					"LEFT JOIN crm_mediator m ON s.mediatorid=m.id\n" +
					"LEFT JOIN time_rank t ON c.TIMERANK_ID=t.Id\n" +
					"WHERE b.isclearing=0 AND b.operatetype=4 AND b.`status`=0 AND c.PLAN_TYPE=0 AND c.STATE=0 AND c.class_id=0 AND m.id=? AND DATE_FORMAT(c.COURSE_TIME,'%Y-%m')=?";
			return dao.find(sql,Integer.parseInt(mediatorId),statMonth);
		}
	}

	/**
	 * 跟进渠道查询相应月份的班课消耗
	 * @param mediatorId
	 * @param statMonth
	 * @return
	 */
	public List<AccountBook> queryBanDetail(String mediatorId, String statMonth) {
		if(StringUtils.isEmpty(mediatorId)||StringUtils.isEmpty(statMonth)){
			return null;
		}else{
			String sql ="SELECT b.*,s.id studentid,s.REAL_NAME studentname,s.mediatorid,m.realname mediatorname,o.classNum teachtype ,DATE_FORMAT(o.endTime,'%Y-%m-%d') statmonth,o.lessonNum ks,b.realamount sxh,b.rewardamount xxh\n" +
					"FROM account_book b \n" +
					"LEFT JOIN account s ON b.accountid=s.Id\n" +
					"LEFT JOIN class_order o ON b.classorderid=o.id\n" +
					"LEFT JOIN crm_mediator m ON s.mediatorid=m.id\n" +
					"WHERE b.isclearing=0 AND b.operatetype=4 AND b.`status`=0 AND m.id=? AND DATE_FORMAT(o.endTime,'%Y-%m')=?";
			return dao.find(sql,Integer.parseInt(mediatorId),statMonth);
		}
	}

	/**
	 * 跟进操作类型获取流水记录
	 * @param accountid
	 * @param operatetype
	 * @return
	 */
	public List<AccountBook> getByOperateType(String accountid ,String operatetype) {
		return dao.find("select * from account_book where accountid=? and operatetype=? order by id desc",Integer.parseInt(accountid),Integer.parseInt(operatetype));
	}

	/**
	 * 根据订单获取其课时消耗
	 * @param courseOrderId
	 * @return
	 */
	public Record getOrderConsume(Integer courseOrderId) {
		Record record = Db.findFirst("select sum(realamount) consumeAmount,sum(classhour) consumeClassHour from account_book where operatetype=4 AND courseorderid=? AND `status`=0", courseOrderId);
		return record;
	}

	/**
	 * 根据课程ID获取已扣除的课时费
	 * @param coursePlanId
	 * @param accountid 
	 * @return
	 */
	public Record getDeductionFee(Integer coursePlanId, Integer accountid) {
		Record record = Db.findFirst("select sum(realamount) consumeAmount,sum(classhour) consumeClassHour from account_book where courseplanid=? and operatetype=4 AND `status`=0 AND accountid = ? ",coursePlanId , accountid);
		return record;
	}

	/**
	 * 删除消耗记录
	 * @param accountId
	 */
	public void deleteByAccountId(Integer accountId) {
		if(accountId == null){
			Db.update("TRUNCATE account_book");
		}else{
			Db.update("delete from account_book where accountid=?",accountId);
		}
	}

	/**
	 * 删除消耗
	 * @param accountId
	 * @param coursePlanId
	 */
	public void deleteByAccountIdAndCoursePlanId(Integer accountId, Integer coursePlanId) {
		Db.update("delete from account_book where accountid=? and courseplanid=?",accountId,coursePlanId);
	}

	/**
	 * 根据课程ID删除扣费记录，注意删除的是1对1的，小班课的用上面的
	 * @param planId
	 */
	public void deleteByCoursePlanId(Integer coursePlanId) {
		Db.update("delete from account_book where courseplanid=?",coursePlanId);
	}
}
