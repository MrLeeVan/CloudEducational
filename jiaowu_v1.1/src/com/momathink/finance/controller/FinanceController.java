

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

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolArith;
import com.momathink.finance.model.CourseOrder;
import com.momathink.finance.service.CourseOrderService;
import com.momathink.sys.account.model.AccountBook;
import com.momathink.sys.account.service.AccountService;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;

/**
 * 财务管理
 * 
 * @author David
 */
@Controller(controllerKey = "/finance")
public class FinanceController extends BaseController {
	private static final Logger logger = Logger.getLogger(FinanceController.class);
	public void initdata(){
		try {
			if("init".equals(getPara("key"))){
				Integer studentId = null;
				StringBuffer sqlo = new StringBuffer("select * from crm_courseorder where delflag=0");
				StringBuffer sqlc = new StringBuffer("select * from courseplan where plan_type=0 and state=0 and class_id=0 and STUDENT_ID is NOT null AND SUBJECT_ID is NOT null ");
				StringBuffer banSql = new StringBuffer( "insert into account_book(accountid,operatetype,createuserid,classorderid,courseid,subjectid,courseorderid,courseplanid,courseprice,carriedOver,realamount,classhour)\n" +
				"select a.studentid,4,1,a.class_id,a.COURSE_ID,a.SUBJECT_ID,o.id,a.COURSEPLAN_ID,o.avgprice,0,ROUND(o.avgprice*t.class_hour,2),t.class_hour from \n" +
				"(select t.studentid,p.class_id,t.COURSEPLAN_ID,p.COURSE_ID,p.SUBJECT_ID,p.TIMERANK_ID from teachergrade t \n" +
				"left join account s on t.studentid=s.Id\n" +
				"left join courseplan p on t.COURSEPLAN_ID=p.Id\n" +
				"where s.STATE=0 AND p.plan_type=0 and p.class_id!=0) a\n" +
				"left join crm_courseorder o on a.class_id=o.classorderid and a.studentid=o.studentid\n" +
				"left join time_rank t on a.TIMERANK_ID=t.Id\n" +
				"WHERE o.`status`!=0");
				if(!StringUtils.isEmpty(getPara("studentid"))){
					studentId=getParaToInt("studentid");
					sqlo.append(" and studentid="+getPara("studentid"));
					sqlc.append(" and student_id="+getPara("studentid"));
					banSql.append(" and a.studentid="+getPara("studentid"));
				}
//				List<CourseOrder> orderList = CourseOrder.dao.find(sqlo.toString());
//				for(CourseOrder o : orderList){
//					if(o.getBigDecimal("realsum").compareTo(BigDecimal.ZERO)==1){
//						Account account = Account.dao.findById(o.getInt("studentid"));
//						double realbalance = account.getBigDecimal("realbalance")==null?0:account.getBigDecimal("realbalance").doubleValue();
//						double rewardbalance = account.getBigDecimal("rewardbalance")==null?0:account.getBigDecimal("rewardbalance").doubleValue();
//						AccountBook book = new AccountBook();
//						book.set("accountid", o.get("studentid"));
//						book.set("createtime", o.get("createtime"));
//						book.set("operatetype", 1);
//						book.set("createuserid", 1);
//						book.set("realamount", o.get("realsum"));
//						book.set("rewardamount",0);
//						book.set("realbalance", ToolArith.add(realbalance,o.getBigDecimal("realsum").doubleValue()));
//						book.set("rewardbalance", rewardbalance);
//						book.set("orderid", o.getPrimaryKeyValue());
//						book.set("classorderid", o.getInt("classorderid"));
//						book.set("status", 0);
//						book.save();
//						account.set("realbalance", ToolArith.add(realbalance,o.getBigDecimal("realsum").doubleValue()));
//						account.set("rewardbalance", rewardbalance);
//						account.set("version", account.getInt("version")==null?1:account.getInt("version")+1);
//						account.update();
//					}
//					if(o.getBigDecimal("rebate").compareTo(BigDecimal.ZERO)==1){
//						Account account = Account.dao.findById(o.getInt("studentid"));
//						double realbalance = account.getBigDecimal("realbalance")==null?0:account.getBigDecimal("realbalance").doubleValue();
//						double rewardbalance = account.getBigDecimal("rewardbalance")==null?0:account.getBigDecimal("rewardbalance").doubleValue();
//						AccountBook book = new AccountBook();
//						book.set("accountid", o.get("studentid"));
//						book.set("createtime", o.get("createtime"));
//						book.set("operatetype", 2);
//						book.set("createuserid", 1);
//						book.set("realamount", 0);
//						book.set("rewardamount", o.get("rebate"));
//						book.set("realbalance", realbalance);
//						book.set("rewardbalance", ToolArith.add(rewardbalance,o.getBigDecimal("rebate").doubleValue()));
//						book.set("orderid", o.getPrimaryKeyValue());
//						book.set("classorderid", o.getInt("classorderid"));
//						book.set("status", 0);
//						book.save();
//						account.set("realbalance", realbalance);
//						account.set("rewardbalance", ToolArith.add(rewardbalance,o.getBigDecimal("rebate").doubleValue()));
//						account.set("version", account.getInt("version")==null?1:account.getInt("version")+1);
//						account.update();
//					}
//					if(o.getInt("classorderid")!=null&&o.getInt("classorderid")!=0){
//						Account _account = Account.dao.findById(o.getInt("studentid"));
//						double _realbalance = _account.getBigDecimal("realbalance")==null?0:_account.getBigDecimal("realbalance").doubleValue();
//						double _rewardbalance = _account.getBigDecimal("rewardbalance")==null?0:_account.getBigDecimal("rewardbalance").doubleValue();
//						AccountBook _book = new AccountBook();
//						_book.set("accountid", o.get("studentid"));
//						_book.set("createtime", o.get("createtime"));
//						_book.set("operatetype", 4);
//						_book.set("createuserid", 1);
//						_book.set("realamount", o.get("realsum"));
//						_book.set("rewardamount", o.get("rebate"));
//						_book.set("realbalance", ToolArith.sub(_realbalance,o.getBigDecimal("realsum").doubleValue()));
//						_book.set("rewardbalance", ToolArith.sub(_rewardbalance,o.getBigDecimal("rebate").doubleValue()));
//						_book.set("orderid", o.getPrimaryKeyValue());
//						_book.set("classorderid", o.getInt("classorderid"));
//						_book.set("status", 0);
//						_book.save();
//						_account.set("realbalance", ToolArith.sub(_realbalance,o.getBigDecimal("realsum").doubleValue()));
//						_account.set("rewardbalance", ToolArith.sub(_rewardbalance,o.getBigDecimal("rebate").doubleValue()));
//						_account.set("version", _account.getInt("version")==null?1:_account.getInt("version")+1);
//						_account.update();
//					}
//				}
//				
				List<CoursePlan> clist = CoursePlan.coursePlan.find(sqlc.append(" order by student_id,course_time").toString());
				AccountBook.dao.deleteByAccountId(studentId);
				for(CoursePlan p : clist){
					boolean result = AccountService.me.consumeCourse(p.getPrimaryKeyValue(), p.getInt("student_id"), getSysuserId(),0);
					if(result){
						logger.info("完成：学生ID:"+p.getInt("student_id")+"课程ID"+p.getPrimaryKeyValue());
					}else{
						logger.info("失败：学生ID:"+p.getInt("student_id")+"课程ID"+p.getPrimaryKeyValue());
					}
				}
				Db.update(banSql.toString());
				renderJson("msg","数据初始化成功");
			}else{
				renderJson("msg","非法请求");
			}
		} catch (Exception e) {
			e.printStackTrace();
			renderJson("msg","初始化数据异常");
		}
	}
	
	public void checkCanRefund(){
		JSONObject json = new JSONObject();
		try{
			String id = getPara("id");
			long counts = CourseOrder.dao.getQianfeiCount(id);
			if(counts>0){
				//有欠费
				json.put("code", 0);
				json.put("msg", "还有订单欠费，不可申请退费");
			}else{
				json.put("code", 1);
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
		renderJson(json);
	}
	
	public void applyRefund(){
		try{
			String id = getPara("id");
			if(StringUtils.isEmpty(id)){
				String name = getPara("name");
				Student student = Student.dao.getStudentByName(name);
				id = student.getPrimaryKeyValue().toString();
				setAttr("name",student.getStr("real_name"));
			}else{
				Student student = Student.dao.findById(id);
				setAttr("name",student.getStr("real_name"));
			}
				List<CourseOrder> list = CourseOrderService.me.getStudentCourseOrderlists(id);
				setAttr("stulist",list);
				renderJsp("/finance/apply_refund.jsp");
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	public void toDoRefund(){
		try{
			Integer courseOrderId = getParaToInt();
			CourseOrder courseOrder =  CourseOrder.dao.getCourseOrderInfoById(courseOrderId);
//			String subjectids =  ordermap.getStr("subjectids");
//			Integer studentid =  ordermap.getInt("studentid");
//			Integer teachtype =  ordermap.getInt("teachtype");
//			Integer classOrderId =  ordermap.getInt("classOrderId");
//			List<CoursePlan> subjectList = financeService.getStudentOrderSubjectPlaned(subjectids,studentid.toString(),teachtype.toString(),classOrderId);
//			setAttr("subjectList", subjectList);
			
			double remainClassHour = ToolArith.sub(courseOrder.getDouble("classhour"), courseOrder.getDouble("usedhours"));
			setAttr("remainClassHour", remainClassHour);
			setAttr("remainBalance", ToolArith.mul(courseOrder.getDouble("avgprice"), remainClassHour));// 单价 * 课时
			
			setAttr("orders", courseOrder);
			renderJsp("/finance/layer_torefund.jsp");
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
}
