
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.base.BaseService;
import com.momathink.common.constants.Constants;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.finance.model.CoursePrice;
import com.momathink.finance.model.Payment;
import com.momathink.finance.service.CourseOrderService;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.AccountBook;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.subject.model.Subject;

public class AccountService extends BaseService {
	private static Logger log = Logger.getLogger(AccountService.class);
	public static final AccountService me = new AccountService();

	@Before(Tx.class)// 去除 synchronized  , 因为之前 ,写法是错误的锁并没有起作用, 但是也没账户金额问题,因为一般排课操作都是教务老师,不会好多个教务老师给一个学生排,顾去掉 锁,ps:消耗不对不是这个方法的问题
	public Map<String, String> accountManage(String type, String accountId, String paymentId, String orderId, String operateId,Double amount, String courseplanId,String banciId) {
		Map<String, String> result = new HashMap<String, String>();
		String code = "0";
		String msg = "操作成功";
		if (StringUtils.isEmpty(accountId)) {
			msg = "账户不存在";
			log.info("账户ID：" + accountId + "不存在");
		} else {
			Account account = Account.dao.findById(Integer.parseInt(accountId));
			if (account == null) {
				msg = "账户不存在";
				log.info("账户ID：" + accountId + "不存在");
			} else {
				account.set("version", account.getInt("version") == null ? 1 : account.getInt("version") + 1);
				if (StringUtils.isEmpty(operateId)) {
					msg = "操作用户不存在";
					log.info("操作用户ID：" + operateId + "不存在");
				} else {
					SysUser sysuser = SysUser.dao.findById(Integer.parseInt(operateId));
					if (sysuser == null) {
						msg = "操作用户不存在";
						log.info("操作用户ID：" + operateId + "不存在");
					} else {
						switch (type) {
						case Constants.ACCOUNT_PAYING:
							if (StringUtils.isEmpty(paymentId)) {
								msg = "支付记录不存在";
								log.info("支付记录ID：" + paymentId + "不存在");
							} else {
								Payment payment = Payment.dao.findById(Integer.parseInt(paymentId));
								if (payment == null) {
									msg = "支付记录不存在";
									log.info("支付记录ID：" + paymentId + "不存在");
								} else {
									CourseOrder courseOrder = CourseOrder.dao.findById(payment.getInt("orderid"));
									if (courseOrder == null) {
										msg = "支付订单不存在";
										log.info("支付记录ID：" + paymentId + "订单不存在");
									} else {
										double realsum = courseOrder.getBigDecimal("realsum").doubleValue();// 应支付金额
										double payfee = payment.getBigDecimal("amount").doubleValue();// 本次支付金额
										double total = payment.getTotalFeeByOrderId(payment.getInt("orderid"));// 总共支付金额
										if (total <= realsum) {
											double realBalance = account.getBigDecimal("realbalance").doubleValue();
											double rewardBalance = account.getBigDecimal("rewardbalance").doubleValue();
											realBalance = ToolArith.add(realBalance, payfee);
											account.set("realbalance", realBalance);
											AccountBook accountBook = new AccountBook();
											accountBook.set("accountid", account.getPrimaryKeyValue());
											accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_PAYING));
											accountBook.set("createuserid", Integer.parseInt(operateId));
											accountBook.set("realamount", payfee);
											accountBook.set("orderid", payment.getInt("orderid"));
											accountBook.set("paymentid", Integer.parseInt(paymentId));
											accountBook.set("realbalance", realBalance);
											accountBook.set("rewardbalance", rewardBalance);
											accountBook.set("subjectid", courseOrder.getInt("subjectid"));
											accountBook.set("classorderid", courseOrder.getInt("classorderid"));
											AccountBookService.me.save(accountBook);
											if (total == realsum) {
												double rebatefee = courseOrder.getBigDecimal("rebate").doubleValue();
												if (rebatefee > 0) {
													rewardBalance = ToolArith.add(rewardBalance, rebatefee);
													account.set("rewardbalance", rewardBalance);
													AccountBook _accountBook = new AccountBook();
													_accountBook.set("accountid", account.getPrimaryKeyValue());
													_accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_REWARD));
													_accountBook.set("createuserid", Integer.parseInt(operateId));
													_accountBook.set("orderid", payment.getInt("orderid"));
													_accountBook.set("paymentid", Integer.parseInt(paymentId));
													_accountBook.set("rewardamount", rebatefee);
													_accountBook.set("realbalance", realBalance);
													_accountBook.set("rewardbalance", rewardBalance);
													_accountBook.set("subjectid", courseOrder.getInt("subjectid"));
													_accountBook.set("classorderid", courseOrder.getInt("classorderid"));
													AccountBookService.me.save(_accountBook);
												}
												boolean hasNotpay = Payment.dao.hasNotPayCount(courseOrder.getPrimaryKeyValue());//查询是否还有没有收款的支付记录
												if(!hasNotpay){//全部都收到款了
													courseOrder.set("status", 1);
													courseOrder.set("paiedtime", new Date());
													courseOrder.set("operatorid", Integer.parseInt(operateId));
													courseOrder.set("version", courseOrder.getInt("version") + 1);
													CourseOrderService.me.update(courseOrder);
												}
											}
											account.set("update_time", new Date());
											account.update();
											code = "1";
										} else {
											msg = "订单已全部支付";
											log.info("支付记录ID：" + paymentId + "订单已全部支付");
										}
									}
								}
							}
							break;
						case Constants.ACCOUNT_REWARD:
							CourseOrder courseOrder = CourseOrder.dao.findById(Integer.parseInt(orderId));
							if (courseOrder == null) {
								msg = "支付订单不存在";
								log.info("支付记录ID：" + paymentId + "订单不存在");
							} else {
								double realsum = courseOrder.getBigDecimal("realsum").doubleValue();// 应支付金额
								if (realsum == 0) {
									double realBalance = account.getBigDecimal("realbalance").doubleValue();
									double rewardBalance = account.getBigDecimal("rewardbalance").doubleValue();
									account.set("realbalance", realBalance);
									double rebatefee = courseOrder.getBigDecimal("rebate").doubleValue();
									if (rebatefee > 0) {
										rewardBalance = ToolArith.add(rewardBalance, rebatefee);
										account.set("rewardbalance", rewardBalance);
										AccountBook _accountBook = new AccountBook();
										_accountBook.set("accountid", account.getPrimaryKeyValue());
										_accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_REWARD));
										_accountBook.set("createuserid", Integer.parseInt(operateId));
										_accountBook.set("orderid", Integer.parseInt(orderId));
										_accountBook.set("rewardamount", rebatefee);
										_accountBook.set("realbalance", realBalance);
										_accountBook.set("rewardbalance", rewardBalance);
										_accountBook.set("subjectid", courseOrder.getInt("subjectid"));
										_accountBook.set("classorderid", courseOrder.getInt("classorderid"));
										AccountBookService.me.save(_accountBook);
									}
									account.set("update_time", new Date());
									account.update();
									courseOrder.set("status", 1);
									courseOrder.set("paiedtime", new Date());
									courseOrder.set("operatorid", Integer.parseInt(operateId));
									courseOrder.set("version", courseOrder.getInt("version") + 1);
									CourseOrderService.me.update(courseOrder);
									code = "1";
								} else {
									msg = "订单已全部支付";
									log.info("支付记录ID：" + paymentId + "订单已全部支付");
								}
							}
							break;
						case Constants.ACCOUNT_REFUND:

							break;
						case Constants.ACCOUNT_CONSUME_COURSE:
							if (StringUtils.isEmpty(courseplanId)) {
								if(StringUtils.isEmpty(banciId)){
									msg = "课程安排记录不存在";
									log.info("课程安排ID：" + courseplanId + "不存在");
								}else{
									ClassOrder ban = ClassOrder.dao.findById(Integer.parseInt(banciId));
									if(StringUtils.isEmpty(orderId)){
										msg = "支付订单不存在";
										log.info("支付记录ID：" + paymentId + "订单不存在");
									}else{
										CourseOrder _courseOrder = CourseOrder.dao.findById(Integer.parseInt(orderId));
										if (_courseOrder == null) {
											msg = "支付订单不存在";
											log.info("支付记录ID：" + paymentId + "订单不存在");
										} else {
											double price = _courseOrder.getBigDecimal("realsum").doubleValue();
											double realbalance = account.getBigDecimal("realbalance").doubleValue();
											double rewardbalance = account.getBigDecimal("rewardbalance").doubleValue();
											double realamount = 0;
											double rewardamount = 0;
											double remain = ToolArith.add(realbalance, rewardbalance);
											if (remain >= price) {
												if(realbalance>=price){
													realamount = price;
													realbalance = ToolArith.sub(realbalance, realamount);
												}else{
													realamount = realbalance;
													rewardamount = ToolArith.sub(price, realbalance);
													realbalance = 0;
													rewardbalance = ToolArith.sub(rewardbalance, rewardamount);
												}
												AccountBook accountBook = new AccountBook();
												accountBook.set("accountid", account.getPrimaryKeyValue());
												accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_CONSUME_COURSE));
												accountBook.set("createuserid", Integer.parseInt(operateId));
												accountBook.set("realamount", realamount);
												accountBook.set("rewardamount", rewardamount);
												accountBook.set("realbalance", realbalance);
												accountBook.set("rewardbalance", rewardbalance);
												accountBook.set("classorderid", ban.getPrimaryKeyValue());
												accountBook.set("courseprice", price);
												AccountBookService.me.save(accountBook);
												account.set("realbalance", realbalance);
												account.set("rewardbalance", rewardbalance);
												account.set("update_time", new Date());
												account.update();
												log.info("班课学生：" + account.getStr("real_name") + "一次性扣费，流水ID:"+accountBook.getPrimaryKeyValue()+"实账余额："+realbalance+"虚账余额："+rewardbalance);
												code="1";
											} else {
												msg = "学生" + account.getStr("real_name") + "金额不足，请充值购买课程";
												log.info("学生：" + account.getStr("real_name") + "账户金额不足");
											}
										}
									}
								}
								
							} else {
								CoursePlan courseplan = CoursePlan.coursePlan.findById(Integer.parseInt(courseplanId));
								if (courseplan == null) {
									msg = "课程安排记录不存在";
									log.info("课程安排ID：" + courseplanId + "不存在");
								} else {
									TimeRank tr = TimeRank.dao.findById(courseplan.getInt("TIMERANK_ID"));
									double classhour = tr.getBigDecimal("class_hour").doubleValue();
									Course course = Course.dao.findById(courseplan.getInt("course_id"));
									double unitprice = course.getBigDecimal("UNIT_PRICE").doubleValue();
									double price = ToolArith.mul(classhour,unitprice);
									double realbalance = account.getBigDecimal("realbalance").doubleValue();
									double rewardbalance = account.getBigDecimal("rewardbalance").doubleValue();
									double realamount = 0;
									double rewardamount = 0;
									double remain = ToolArith.add(realbalance, rewardbalance);
									if (remain >= price) {
										double allremainhour=CourseOrder.dao.getRemainHour(accountId,courseplan.getInt("subject_id")+"");
										if(allremainhour>=classhour){
											List<CourseOrder> list = CourseOrder.dao.getCanuseOrder(accountId,courseplan.getInt("subject_id")+"");
											if(list == null){
												msg = "学生" + account.getStr("real_name") + "课时不足，请充值购买课程";
												log.info("学生：" + account.getStr("real_name") + "订单课时不足");
											}else{
												double _remainhour=0;
												for(CourseOrder order : list){
													if(order == null){
														return null;
													}else{
														if(classhour==0){
															break;
														}else{
															CoursePrice coursePrice = CoursePrice.dao.findByOrderIdAndCourseId(order.getPrimaryKeyValue(),courseplan.getInt("course_id"));
															double remainHour = order.getDouble("remainclasshour");
															double fee=0;
															_remainhour = ToolArith.sub(classhour, remainHour);
															if(coursePrice==null||remainHour==0){
																continue;
															}else{
																if(_remainhour<0){
																	order.set("remainclasshour",ToolArith.sub(remainHour, classhour));
																	_remainhour=0;
																	fee = ToolArith.mul(classhour, unitprice);
																	coursePrice.set("remainclasshour", ToolArith.sub(coursePrice.getDouble("remainclasshour"), classhour));
																}else{
																	order.set("remainclasshour",0);
																	fee = ToolArith.mul(remainHour, unitprice);
																	coursePrice.set("remainclasshour", ToolArith.sub(coursePrice.getDouble("remainclasshour"), remainHour));
																}
																if(realbalance>=fee){
																	realamount = fee;
																	realbalance = ToolArith.sub(realbalance, realamount);
																}else{
																	realamount = realbalance;
																	rewardamount = ToolArith.sub(fee, realbalance);
																	realbalance = 0;
																	rewardbalance = ToolArith.sub(rewardbalance, rewardamount);
																}
																order.update();
																coursePrice.update();
																AccountBook accountBook = new AccountBook();
																accountBook.set("accountid", account.getPrimaryKeyValue());
																accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_CONSUME_COURSE));
																accountBook.set("createuserid", Integer.parseInt(operateId));
																accountBook.set("realamount", realamount);
																accountBook.set("rewardamount", rewardamount);
																accountBook.set("courseplanid", Integer.parseInt(courseplanId));
																accountBook.set("realbalance", realbalance);
																accountBook.set("rewardbalance", rewardbalance);
																accountBook.set("courseid", courseplan.getInt("course_id"));
																accountBook.set("courseprice", price);
																accountBook.set("courseorderid", order.getPrimaryKeyValue());
																AccountBookService.me.save(accountBook);
																log.info("学生：" + account.getStr("real_name") + "添加排课，流水ID:"+accountBook.getPrimaryKeyValue()+"实账余额："+realbalance+"虚账余额："+rewardbalance);
																classhour=_remainhour;
															}
														}
													}				
												}
												account.set("realbalance", realbalance);
												account.set("rewardbalance", rewardbalance);
												account.set("update_time", new Date());
												account.update();
												code="1";
											}
										}else{
											msg = "学生" + account.getStr("real_name") + "课时不足，请充值购买课程";
											log.info("学生：" + account.getStr("real_name") + "订单课时不足");
										}
									} else {
										msg = "学生" + account.getStr("real_name") + "金额不足，请充值购买课程";
										log.info("学生：" + account.getStr("real_name") + "账户金额不足");
									}
								}
							}
							break;
						case Constants.ACCOUNT_CANCEL_COURSE:
							if (StringUtils.isEmpty(courseplanId)) {
								msg = "课程安排记录不存在";
								log.info("课程安排ID：" + courseplanId + "不存在");
							} else {
								List<AccountBook> accountbookList = AccountBook.dao.findByCourseplanId(courseplanId);
								for(AccountBook accountbook:accountbookList){
									if (accountbook == null) {
										msg = "课程消耗流水不存在";
										log.info("课程安排ID：" + courseplanId + "消耗流水不存在");
									} else {
										Account _account = Account.dao.findById(account.getPrimaryKeyValue());
										double realbalance = _account.getBigDecimal("realbalance").doubleValue();
										double rewardbalance = _account.getBigDecimal("rewardbalance").doubleValue();
										double realamount = accountbook.getBigDecimal("realamount").doubleValue();
										double rewardamount = accountbook.getBigDecimal("rewardamount").doubleValue();
										if (realamount > 0) {
											realbalance = ToolArith.add(realbalance, realamount);
										}
										if(rewardamount>0){
											rewardbalance = ToolArith.add(rewardbalance, rewardamount);
										}
										AccountBook accountBook = new AccountBook();
										accountBook.set("accountid", account.getPrimaryKeyValue());
										accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_CANCEL_COURSE));
										accountBook.set("createuserid", Integer.parseInt(operateId));
										accountBook.set("realamount", realamount);
										accountBook.set("rewardamount", rewardamount);
										accountBook.set("courseplanid", Integer.parseInt(courseplanId));
										accountBook.set("realbalance", realbalance);
										accountBook.set("rewardbalance", rewardbalance);
										accountBook.set("courseid", accountbook.getInt("course_id"));
										accountBook.set("courseprice", accountbook.getBigDecimal("courseprice"));
										accountBook.set("accountbookid", accountbook.getPrimaryKeyValue());
										accountbook.set("status", 1);
										accountbook.set("canceluserid", Integer.parseInt(operateId));
										accountbook.set("canceltime",  new Date());
										accountbook.set("version", accountbook.getInt("version")+1);
										AccountBookService.me.save(accountBook);
										accountbook.update();
										_account.set("realbalance", realbalance);
										_account.set("rewardbalance", rewardbalance);
										_account.set("update_time", new Date());
										_account.update();
										double backfee = ToolArith.add(realamount,rewardamount);
										CourseOrder _courseOrder = CourseOrder.dao.findById(accountbook.getInt("courseorderid"));
										if(_courseOrder!=null){
											CoursePrice _coursePrice = CoursePrice.dao.findByOrderIdAndCourseId(accountbook.getInt("courseorderid"), accountbook.getInt("courseid"));
											double backclasshour = ToolArith.div(backfee, _coursePrice.getBigDecimal("unitprice").doubleValue(), 1);
											_courseOrder.set("remainclasshour", ToolArith.add(_courseOrder.getDouble("remainclasshour"), backclasshour));
											_coursePrice.set("remainclasshour", ToolArith.add(_coursePrice.getDouble("remainclasshour"), backclasshour));
											_courseOrder.update();
											_coursePrice.update();
										}
										log.info("取消了学生：" + account.getStr("real_name") + "排课，退回消耗，流水ID:"+accountbook.getPrimaryKeyValue());
										code="1";
									}
								}
							}
							break;
						case Constants.ACCOUNT_FRONT_MONEY:
							double temprealBalance = account.getBigDecimal("temprealbalance").doubleValue();
							double totalFrontMoney = ToolArith.add(temprealBalance, amount);
							account.set("temprealbalance",totalFrontMoney);
							AccountBook _accountBook = new AccountBook();
							_accountBook.set("accountid", account.getPrimaryKeyValue());
							_accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_FRONT_MONEY));
							_accountBook.set("createuserid", Integer.parseInt(operateId));
							_accountBook.set("temprealamount", amount);
							_accountBook.set("realbalance", account.getBigDecimal("realbalance"));
							_accountBook.set("rewardbalance", account.getBigDecimal("rewardbalance"));
							_accountBook.set("temprealbalance", totalFrontMoney);
							_accountBook.set("temprewardbalance", account.getBigDecimal("temprewardbalance"));
							AccountBookService.me.save(_accountBook);
							account.set("update_time", new Date());
							account.update();
							code = "1";
							break;
						case Constants.ACCOUNT_ZHUANCUN:
							double realbalance = account.getBigDecimal("realbalance").doubleValue();
							double rewardbalance = account.getBigDecimal("rewardbalance").doubleValue();
							double _temprealBalance = account.getBigDecimal("temprealbalance").doubleValue();
							double _temprewardBalance = account.getBigDecimal("temprewardbalance").doubleValue();
							double remainTemp = 0;
							AccountBook _accountBookZhuancun = new AccountBook();
							if(rewardbalance>=amount){//副账户够转存
								rewardbalance = ToolArith.sub(rewardbalance, amount);
								remainTemp=ToolArith.sub(amount, rewardbalance);
								_accountBookZhuancun.set("rewardamount", amount);
								_accountBookZhuancun.set("temprewardbalance",ToolArith.add(_temprewardBalance, amount));
								account.set("temprewardbalance",ToolArith.add(_temprewardBalance, amount));
							}else{
								_accountBookZhuancun.set("rewardamount", rewardbalance);
								_accountBookZhuancun.set("temprewardbalance",ToolArith.add(_temprewardBalance, rewardbalance));
								remainTemp=ToolArith.sub(amount, rewardbalance);
								account.set("temprewardbalance",ToolArith.add(_temprewardBalance, rewardbalance));
								rewardbalance=0;
							}
							if(remainTemp>0){
								realbalance = ToolArith.sub(realbalance, remainTemp);
								account.set("temprealbalance",ToolArith.add(_temprealBalance, remainTemp));
								_accountBookZhuancun.set("realamount", remainTemp);
								_accountBookZhuancun.set("temprealbalance", ToolArith.add(_temprealBalance, remainTemp));
							}
							account.set("realbalance", realbalance);
							account.set("rewardbalance", rewardbalance);
							_accountBookZhuancun.set("accountid", account.getPrimaryKeyValue());
							_accountBookZhuancun.set("operatetype", Integer.parseInt(Constants.ACCOUNT_ZHUANCUN));
							_accountBookZhuancun.set("createuserid", Integer.parseInt(operateId));
							_accountBookZhuancun.set("realbalance", realbalance);
							_accountBookZhuancun.set("rewardbalance",rewardbalance);
							_accountBookZhuancun.set("orderid", orderId);
							AccountBookService.me.save(_accountBookZhuancun);
							account.set("update_time", new Date());
							account.update();
							code = "1";
							break;
						case Constants.ACCOUNT_ZHUANRU:
							double zhubalance = account.getBigDecimal("realbalance").doubleValue();
							double fubalance = account.getBigDecimal("rewardbalance").doubleValue();
							double _tempzhuBalance = account.getBigDecimal("temprealbalance").doubleValue();
							double _tempfuBalance = account.getBigDecimal("temprewardbalance").doubleValue();
							double remainTempZhuanru = 0;
							AccountBook _accountBookZhuanru = new AccountBook();
							double totaltemp=ToolArith.add(_tempzhuBalance, _tempfuBalance);
							if(totaltemp>=amount){//够转
								remainTempZhuanru=ToolArith.sub(_tempzhuBalance,amount );
								if(remainTempZhuanru>=0){//预存主账户够转
									_tempzhuBalance = ToolArith.sub(_tempzhuBalance, amount);
									_accountBookZhuanru.set("temprealamount", amount);
									_accountBookZhuanru.set("temprealbalance",_tempzhuBalance);
									_accountBookZhuanru.set("temprewardbalance",_tempfuBalance);
									zhubalance = ToolArith.add(zhubalance, amount);
									account.set("temprealbalance",_tempzhuBalance);
									account.set("temprewardbalance", _tempfuBalance);
								}else{//预存主账号不够转，也要转副的
									if(_tempzhuBalance>0){//预存主账户有钱
										_accountBookZhuanru.set("temprealamount", _tempzhuBalance);
										_accountBookZhuanru.set("temprealbalance",0);
										zhubalance = ToolArith.add(zhubalance, _tempzhuBalance);
										account.set("temprealbalance",0);
									}
									if(_tempfuBalance>0){
										_accountBookZhuanru.set("temprewardamount", ToolArith.sub(amount,_tempzhuBalance));
										_accountBookZhuanru.set("temprewardbalance",ToolArith.sub(_tempfuBalance, ToolArith.sub(amount,_tempzhuBalance)));
										fubalance = ToolArith.add(fubalance, ToolArith.sub(amount,_tempzhuBalance));	
										account.set("temprewardbalance",ToolArith.sub(_tempfuBalance, ToolArith.sub(amount,_tempzhuBalance)));
									}
								}
								_accountBookZhuanru.set("accountid", account.getPrimaryKeyValue());
								_accountBookZhuanru.set("operatetype", Integer.parseInt(Constants.ACCOUNT_ZHUANRU));
								_accountBookZhuanru.set("createuserid", Integer.parseInt(operateId));
								_accountBookZhuanru.set("realbalance", zhubalance);
								_accountBookZhuanru.set("rewardbalance",fubalance);
								_accountBookZhuanru.set("orderid", orderId);
								AccountBookService.me.save(_accountBookZhuanru);
								account.set("realbalance",zhubalance);
								account.set("rewardbalance", fubalance);
								account.set("update_time", new Date());
								account.update();
								code = "1";
								break;								
							}else{
								break;
							}
						default:
							break;
						}
					}

				}
			}
		}

		result.put("code", code);
		result.put("msg", msg);
		return result;
	}

	/**
	 * 课程消耗
	 * @param coursePlanId
	 * @param studentId
	 * @param operaterId
	 * @param carriedOver 0未结转1已结转
	 */
	public boolean consumeCourse(Integer coursePlanId, Integer studentId, Integer operaterId,int carriedOver) {
		boolean result = false;
		CoursePlan coursePlan = CoursePlan.coursePlan.findById(coursePlanId);//课程
		Subject subject  = Subject.dao.findById(coursePlan.getInt("subject_id"));//科目
		List<CourseOrder> courseOrderList = null;
		if(coursePlan.getInt("class_id")==0){//1VS1
			courseOrderList = CourseOrder.dao.getOrderByStudentidAndSubjectid(studentId.toString(),subject.getPrimaryKeyValue().toString());
			log.info("学生："+studentId+",科目："+subject.getPrimaryKeyValue());
		}else{//小班
			courseOrderList = CourseOrder.dao.getCourseOrders(studentId,coursePlan.getInt("class_id"));
		}
		TimeRank timeRank = TimeRank.dao.findById(coursePlan.getInt("timerank_id"));
		double classHour = timeRank.getBigDecimal("class_hour").doubleValue();
		if(carriedOver == 0){//排课先添加一条未结转消耗记录
			for(CourseOrder courseOrder : courseOrderList){
				Record record = AccountBook.dao.getOrderConsume(courseOrder.getPrimaryKeyValue());
				double consume = record.getBigDecimal("consumeAmount")==null?0:record.getBigDecimal("consumeAmount").doubleValue();//消耗的金额
				double consumeClassHour = record.getDouble("consumeClassHour")==null?0:record.getDouble("consumeClassHour");//消耗的课时数
				double realsum = courseOrder.getBigDecimal("realsum").doubleValue();//订单金额
				double orderClasshour = courseOrder.getDouble("classhour");//订单的课时数
				if(ToolArith.compareTo(consumeClassHour, orderClasshour)==0){//说明已消耗完
					log.info("学生ID："+studentId+"课程ID："+coursePlanId+"扣费，扣费订单ID："+courseOrder.getPrimaryKeyValue()+"已消耗完，操作人ID："+operaterId);
					continue;
				}else if(ToolArith.compareTo(orderClasshour,consumeClassHour)==1){//说明该订单还有剩余
					double avgprice = courseOrder.get("avgprice")==null?0:courseOrder.getDouble("avgprice");//课程单价
					double classHourFee = ToolArith.mul(classHour, avgprice);//本次要扣的课时费
					Record deducationRecord = AccountBook.dao.getDeductionFee(coursePlanId, studentId);//已消耗的费用
					double deductionFee = deducationRecord.getBigDecimal("consumeAmount")==null?0:deducationRecord.getBigDecimal("consumeAmount").doubleValue();//消耗的金额
					double deductionClassHour = deducationRecord.getDouble("consumeClassHour")==null?0:deducationRecord.getDouble("consumeClassHour");//消耗的课时数
					double remainAmount = ToolArith.sub(realsum, consume);
					double remainOrderClassHour = ToolArith.sub(orderClasshour, consumeClassHour);
					if(ToolArith.compareTo(classHour, deductionClassHour)==1){//课程消耗费没扣除完
						double arrearage = ToolArith.sub(classHourFee, deductionFee);//待扣除费用
						double arrearageClassHour = ToolArith.sub(classHour, deductionClassHour);//待扣课时
						AccountBook accountBook = new AccountBook();
						accountBook.set("accountid", studentId);
						accountBook.set("operatetype", Integer.parseInt(Constants.ACCOUNT_CONSUME_COURSE));
						accountBook.set("createuserid", operaterId);
						accountBook.set("classorderid", coursePlan.getInt("class_id"));
						accountBook.set("courseid", coursePlan.getInt("course_id"));
						accountBook.set("subjectid", coursePlan.getInt("subject_id"));
						accountBook.set("courseorderid", courseOrder.getPrimaryKeyValue());
						accountBook.set("courseplanid", coursePlanId);
						accountBook.set("courseprice", avgprice);
						accountBook.set("carriedOver", carriedOver);
						if(ToolArith.compareTo(remainOrderClassHour, arrearageClassHour)>=0){//该订单还够扣费
							accountBook.set("realamount", arrearage);
							accountBook.set("classhour", arrearageClassHour);
							AccountBookService.me.save(accountBook);
							log.info("学生ID："+studentId+"课程ID："+coursePlanId+"扣费成功，扣费订单ID："+courseOrder.getPrimaryKeyValue()+"，操作人ID："+operaterId);
							result = true;
							break;
						}else{//把订单剩余的都扣了
							accountBook.set("realamount", remainAmount);
							accountBook.set("classhour", remainOrderClassHour);
							AccountBookService.me.save(accountBook);
							log.info("学生ID："+studentId+"课程ID："+coursePlanId+"扣费成功，扣费订单ID："+courseOrder.getPrimaryKeyValue()+"，操作人ID："+operaterId);
						}
					}else{
						log.info("学生ID："+studentId+"课程ID："+coursePlanId+"已扣完费用,操作人ID："+operaterId);
						break;
					}
				}else{//订单超了
					continue;
				}
			}
		}else{//结转
//			if(coursePlan.getInt("iscancel")==1){//已取消
//				classHour = coursePlan.getDouble("teacherhour");
//				List<AccountBook> abList = AccountBook.dao.findByCourseplanId(coursePlanId.toString());
//				if(abList != null){
//					if (abList.size()>1){//只有一条数据
//						AccountBook accountBook = abList.get(0);
//						double courseprice = accountBook.getBigDecimal("courseprice").doubleValue();
//						double classHourFee = ToolArith.mul(classHour, courseprice);//本次要扣的课时费
//						accountBook.set("realamount", classHourFee);
//						accountBook.set("classhour", classHour);
//						accountBook.update();
//					}else{
//						for(AccountBook accountBook : abList){
//							double _classhour = accountBook.getDouble("classhour");
//							if(ToolArith.compareTo(classHour, _classhour)>=0){
//								classHour = ToolArith.sub(classHour, _classhour);
//								continue;
//							}else{
//								if(classHour==0){
//									accountBook.set("realamount", 0);
//									accountBook.set("classhour", 0);
//									accountBook.update();
//								}else{
//									double courseprice = accountBook.getBigDecimal("courseprice").doubleValue();
//									double classHourFee = ToolArith.mul(classHour, courseprice);//本次要扣的课时费
//									accountBook.set("realamount", classHourFee);
//									accountBook.set("classhour", classHour);
//									accountBook.update();
//									classHour = 0;
//								}
//							}
//						}
//					}
//				}
//			}
			Db.update("update account_book set carriedover=? ,carriedoveruserid=? ,carriedovertime=? where courseplanid=?", carriedOver,operaterId,ToolDateTime.getCurDateTime(),coursePlanId);
			result = true;
		}
		return result;
	}

}
