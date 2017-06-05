
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

package com.momathink.finance.controller;

import java.util.Date;
import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.finance.model.Payment;
import com.momathink.finance.service.CourseOrderService;
import com.momathink.finance.service.PaymentService;
import com.momathink.teaching.classtype.model.ClassType;
import com.momathink.teaching.course.model.CoursePlan;

/**
 * 交费管理
 * 
 * @author David
 */
@Controller(controllerKey = "/payment")
public class PaymentController extends BaseController {
	private PaymentService paymentService = new PaymentService();
	private CourseOrderService courseOrderService = new CourseOrderService();
	
	/**
	 * 交费及已交信息*
	 */
	public void toPayment(){
		String orderid = getPara();
		CourseOrder co = CourseOrder.dao.findById(Integer.parseInt(orderid));
		setAttr("orders", co);
		render("/finance/payment_form.jsp");
	}
	
	/**保存交费信息
	 * */
	public void savePayment(){
		JSONObject json = new JSONObject();
		String code="0";
		String msg="保存成功！";
		Payment payment = getModel(Payment.class);
		payment.set("operatorid", getSysuserId());
		try {
			CourseOrder courseOrder=CourseOrder.dao.findById(payment.getInt("orderid"));
			if(courseOrder == null){
				msg="交费订单不存在，请查证。";
			}else{
				double realsum=courseOrder.getBigDecimal("realsum").doubleValue();
				double amount=payment.getBigDecimal("amount").doubleValue();
				if(amount < 0){
					msg="交费金额不能为负数";
				}else{
					List<CoursePlan> stuPlans = CoursePlan.coursePlan.repeatCoursePlan(courseOrder.getInt("studentid"),courseOrder.getInt("classorderid"));
					if(stuPlans.size()>0){
						code = "0";
						msg = "有课程冲突：<br>";
						for(int i=0;i<stuPlans.size();i++){
							msg += ""+stuPlans.get(i).get("COURSE_TIME")+"   "+stuPlans.get(i).getStr("RANK_NAME")+"   "+stuPlans.get(i).getStr("COURSE_NAME")+"<br>";
						}
						msg += "请先修改排课或者进行其他处理。";
					}else {
						double paidFee = paymentService.getPaidAmount(payment.getInt("orderid"));
						if((paidFee+amount)<=realsum){
							boolean ispay = payment.getBoolean("ispay");
							boolean isFull = (paidFee == realsum||(paidFee+amount)==realsum);
							if(ispay){
								payment.set("confirmuserid",getSysuserId());
								payment.set("confirmtime",ToolDateTime.getDate());
								if(isFull){
									courseOrder.set("status", 1);
									courseOrder.set("version", courseOrder.getInt("version")+1);
									courseOrder.set("paiedtime", payment.getDate("paydate"));
								}
							}else{
								courseOrder.set("status", 2);//订单欠费状态
								courseOrder.set("version", courseOrder.getInt("version")+1);
							}
							courseOrderService.update(courseOrder);
							Integer banId = courseOrder.getInt("classorderid");
							if(isFull&&banId !=null){//未付与已付和等于订单金额并且未班课，则需要将学生加入到小班中
								ClassType.dao.connectStuToClass(courseOrder.getInt("studentid").toString(),banId);
							}
							payment.set("studentid", courseOrder.getInt("studentid"));
							if(amount != 0)
								paymentService.save(payment);
							code = "1";
							msg = "操作成功";
						}else{
							msg="所交费用超出订单应交费用。";
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			code="0";
			msg="数据保存异常，请联系系统管理员！";
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
	}
	
	public void toConfirmPage(){
		String paymentId = getPara();
		Payment payment = Payment.dao.findById(Integer.parseInt(paymentId));
		CourseOrder co = CourseOrder.dao.findById(payment.getInt("orderid"));
		setAttr("orders", co);
		setAttr("payment", payment);
		setAttr("isconfirm", true);
		renderJsp("/finance/payment_form.jsp");
	}
	
	public void confirm(){
		Payment confirmPayment = getModel(Payment.class);
		Payment payment = Payment.dao.findById(confirmPayment.getPrimaryKeyValue());
		JSONObject json = new JSONObject();
		String code="0";
		String msg="确认成功！";
		if(payment == null){
			msg="支付记录不存在！";
		}else{
			CourseOrder courseOrder=CourseOrder.dao.findById(payment.getInt("orderid"));
			if(courseOrder == null){
				msg="交费订单不存在，请查证。";
			}else{
				double realsum=courseOrder.getBigDecimal("realsum")==null?0:courseOrder.getBigDecimal("realsum").doubleValue();
				if(realsum == 0){
					msg="购买课时数为空！";
				}else{
					double amount = paymentService.getPaidAmount(payment.getInt("orderid"));
					if(amount == 0){
						msg="交费金额不能为0";
					}else{
						if(amount<=realsum){
							boolean ispay = payment.getBoolean("ispay");
							if(!ispay){
								payment.set("ispay", confirmPayment.getBoolean("ispay"));
								payment.set("paydate", confirmPayment.getDate("paydate"));
								payment.set("confirmuserid",getSysuserId());
								payment.set("confirmtime",ToolDateTime.getDate());
								paymentService.update(payment);
								boolean hasNotpay = Payment.dao.hasNotPayCount(courseOrder.getPrimaryKeyValue());//查询是否还有没有收款的支付记录
								if(!hasNotpay){//全部都收到款了
									courseOrder.set("status", 1);
									courseOrder.set("paiedtime", new Date());
									courseOrder.set("operatorid", getSysuserId());
									courseOrder.set("version", courseOrder.getInt("version") + 1);
									courseOrderService.update(courseOrder);
									Integer banId = courseOrder.getInt("classorderid");
									if(banId !=null){//班课需要关联用户到班课中
										ClassType.dao.connectStuToClass(courseOrder.getInt("studentid").toString(),banId);
									}
								}
							}else{
								msg="该支付记录已确认！";
							}
							code="1";
						}else{
							msg="所交费用超出应交费用。";
						}
					}
				}
			}
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
	}
}
