
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

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.constants.MesContantsFinal;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.finance.model.CoursePrice;
import com.momathink.finance.model.OrdersReject;
import com.momathink.finance.model.Payment;
import com.momathink.finance.service.CourseOrderService;
import com.momathink.finance.service.CoursePriceService;
import com.momathink.sys.account.model.Account;
import com.momathink.sys.account.model.BanciCourse;
import com.momathink.sys.account.model.UserCourse;
import com.momathink.sys.sms.service.MessageService;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.model.TimeRank;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.classtype.model.ClassOrder;
import com.momathink.teaching.course.model.Course;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;

/**
 * 订单管理
 * 
 * @author David
 */
@Controller(controllerKey = "/orders")
public class CourseOrderController extends BaseController {
	private static final Logger logger = Logger.getLogger(CourseOrderController.class);
	
	/**
	 * 导出列表
	 */
	public void toExcel(){
		Integer sysuserId = getSysuserId();
		String campusids = AccountCampus.dao.getCampusIdsByAccountId(sysuserId);
		Map<String,String> queryParam = splitPage.getQueryParam();
		splitPage.setPageNumber(1);
		splitPage.setPageSize(10000000);
		if (campusids != null) {
			String campusSql = " and s.campusid IN("+campusids+")";
			queryParam.put("campusSql",campusSql);
			if(null==queryParam.get("type")||queryParam.get("type").equals("")){
				queryParam.put("type","1");
			}
		}
		CourseOrderService.me.export(getResponse(), getRequest(), splitPage,"交费信息");	
		renderNull();
	}
	
	/**
	 * 订单审核
	 */
	public void orderreview(){
		Integer sysuserId = getSysuserId();
		String campusids = AccountCampus.dao.getCampusIdsByAccountId(sysuserId);
		if (campusids != null) {
		String campusSql = " and s.campusid IN("+campusids+")";
		Map<String,String> queryParam = splitPage.getQueryParam();
			queryParam.put("campusSql",campusSql);
		}
		CourseOrderService.me.checkorder(splitPage);
		setAttr("showPages", splitPage.getPage());
		render("/finance/ordercheck_list.jsp");
	}
	
	/**
	 * 保存学生列表购课
	 */
	public void save(){
		CourseOrder courseOrder = getModel(CourseOrder.class);
		JSONObject json = new JSONObject();
		String code="0";
		String msg="确认成功！";
		Integer studentid = courseOrder.getInt("studentid");
		Student student = Student.dao.findById(studentid);
		if(student == null){
			msg="学生不存在！";
		}else{
			String subjectids = getPara("subjectids");
			if((subjectids==null) && courseOrder.isTeachType1V1() ){
				msg="科目不能为空";
			}else{
				Double classhour = Double.parseDouble(getPara("courseOrder.classhour"));//TODO 需要修改
				if(classhour.equals(0)){
					msg="课时数不能为0";
				}else{
					courseOrder.set("status",1);
					courseOrder.set("operatorid",getSysuserId());
					courseOrder.set("createuserid", getSysuserId());
					courseOrder.set("remainclasshour", courseOrder.getDouble("classhour"));
					long ordernum = System.currentTimeMillis();
					courseOrder.set("ordernum",ordernum);
					courseOrder.set("subjectids",subjectids);
					CourseOrderService.me.save(courseOrder);
					Integer orderId = courseOrder.getPrimaryKeyValue();
					
					if(courseOrder.isTeachType1V1()){
						//-------- 1对1 start---------------
						String courseIds[] = getPara("courseids").split("\\|");
						
						for (String courseId : courseIds) {
							CoursePrice coursePrice = new CoursePrice();
							coursePrice.set("studentid", studentid);
							coursePrice.set("unitprice", courseOrder.getDouble("avgprice"));
							coursePrice.set("realprice", courseOrder.getDouble("avgprice"));
							coursePrice.set("classhour", 0);
							coursePrice.set("remainclasshour", 0);
							coursePrice.set("courseid", courseId);
							coursePrice.set("orderid", orderId);
							coursePrice.set("operatorid",courseOrder.getInt("operatorid"));
							CoursePriceService.me.save(coursePrice);
						}
						UserCourse.dao.deleteByStudentId(studentid);
						List<Course> courses =Course.dao.queryByStudentCourse1v1(studentid);
						for(Course course : courses){
							new UserCourse()
							.set("account_id", studentid)
							.set("course_id", course.get("id"))
							.set("tech_type", 1).save();
						}
						//-------- 1对1 end---------------
					} else if (courseOrder.isTeachTypeClassOrder()){
						//-----------班课  start------------
						String courseIds[] = getParaValues("course_id");
						String courseHours[] = getParaValues("keshi");
						for(int i=0 ;i<courseIds.length;i++){
							String courseHour = courseHours[i];
							if(StringUtils.isEmpty(courseHour))
								continue;
							CoursePrice coursePrice = new CoursePrice();
							coursePrice.set("studentid", studentid);
							coursePrice.set("unitprice", courseOrder.getDouble("avgprice"));
							coursePrice.set("realprice", courseOrder.getDouble("avgprice"));
							coursePrice.set("classhour", courseHour);
							coursePrice.set("remainclasshour", courseHour);
							coursePrice.set("courseid", courseIds[i]);
							coursePrice.set("orderid", orderId);
							coursePrice.set("operatorid",courseOrder.getInt("operatorid"));
							CoursePriceService.me.save(coursePrice);
						}
						//-----------班课  end------------
					}
					
					//发送短信、邮件给财务
					SysUser sysuser = SysUser.dao.findById(getSysuserId());
					Campus campus = Campus.dao.findById(sysuser.getInt("campusid"));
					if(campus!=null && (courseOrder.getBigDecimal("realsum").compareTo(BigDecimal.ZERO)==1) ){
						MessageService.sendMessageToFinance(MesContantsFinal.apply_sms, MesContantsFinal.apply_email, studentid.toString(), campus.getInt("presidentid").toString(), getSysuserId().toString());
					}
					code="1";
					msg="订单提交成功";
				}
			}
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
	}
	
	/**
	 *	/order/checkEnoughCoursehours
	 *  按课程排课课时校验(粗略校验)
	 */
	public void checkEnoughCoursehours(){
		try{
			JSONObject json = new JSONObject();
			String code="0";
			String studentId = getPara("studentId");
			String plantype = getPara("plantype");
			if(plantype.equals("1")){
				logger.info("模考，不需要判断时间是否够用");
				code="0";
			}else{
				Student student = Student.dao.findById(Integer.parseInt(studentId));
				if(student.getInt("state")==2){
					logger.info("虚拟用户，查询小班课时是否够用");
					ClassOrder classorder= ClassOrder.dao.findByXuniId(Integer.parseInt(studentId));
					int zks = classorder.getInt("lessonNum");
					float ypks =  CoursePlan.coursePlan.getClassYpkcClasshour(classorder.getPrimaryKeyValue());
					double syks = ToolArith.sub(zks, ypks);//剩余课时
					int chargeType = classorder.getInt("chargeType");
					if(chargeType == 1 && syks <= 0){// 按期
						code = "1";
						json.put("msg",student.getStr("real_name")+"的课时不足，请购买课时。");
					}
				}else{
					Course course = Course.dao.findById(getParaToInt("courseId"));
					Account account = Account.dao.findById(Integer.parseInt(studentId));
					Integer subjectId = course.getInt("subject_id");
					double yjfks = CourseOrder.dao.getPaidVIPzks(Integer.valueOf(studentId),subjectId);
					double zks = CourseOrder.dao.getCanUseVIPzks(student.getPrimaryKeyValue(),subjectId);
					double ypks = CoursePlan.coursePlan.getUsedVIPClasshour(Integer.parseInt(studentId), subjectId);
					double syks = ToolArith.sub(zks, ypks);//剩余课时
					Organization org = Organization.dao.findById(1);
					String keqianStr = org.get("basic_maxdefaultclass").toString();
					double keqian = 10000000;
					if(!StringUtils.isEmpty(keqianStr)){
						keqian = Double.parseDouble(keqianStr);
					}
					if (syks >= 0) {
						if (ypks >= yjfks +keqian) {
							code = "0";
							json.put("msg", account.getStr("real_name") + "同学含有欠费订单，交款后继续排课。");
						}else{
							if(0 >= syks) {
								code = "1";
								json.put("msg", account.getStr("real_name") + "剩余" + syks + "课时,请先进行其他相应操作再排课.");
							}
						}
					} else {
						code = "1";
						json.put("msg", account.getStr("real_name") + "课时不足，请确认是否已交费或已购买。");
					}
				}		
			}
			//这是日志
			logger.info("code为0课时足够，为1课时不够;一对一可以排超指定课时，小班没有排超.");
			json.put("code", code);
			renderJson(json);
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	
	/**
	 * 查询预排课时是否足够
	 */
	public void queryUsableHour(){
		try{
			JSONObject json = new JSONObject();
			String code="0";
			String studentId = getPara("studentId");
			String rankId = getPara("rankId");
			String rankName = getPara("rankName");
			String plantype = getPara("plantype");
			rankName = rankName.substring(0, 5);
			if(plantype.equals("1")){//模考
				code="0";
			}else{//正常排课，走验证课时是否够用
				Student student = Student.dao.findById(Integer.parseInt(studentId));
				if(student.getInt("state")==2){//虚拟用户，查询小班课时是否够用
					ClassOrder classorder= ClassOrder.dao.findByXuniId(Integer.parseInt(studentId));
					TimeRank timeRank = TimeRank.dao.findById(Integer.parseInt(rankId));
					int zks = classorder.getInt("lessonNum");
					int chargeType = classorder.getInt("chargeType");
					if(chargeType == 1){// 按期
						float ypks =  CoursePlan.coursePlan.getClassYpkcClasshour(classorder.getPrimaryKeyValue());
						double syks = ToolArith.sub(zks, ypks);//剩余课时
						if(syks>0){
							if (timeRank.getBigDecimal("class_hour").doubleValue()>syks) {
								code = "1";
								json.put("msg",student.getStr("real_name")+"剩余"+syks+"课时,该时段课时为"+timeRank.getBigDecimal("class_hour")+"课时");
							}
						}else{
							code = "1";
							json.put("msg",student.getStr("real_name")+"的课时不足，请购买课时。");
						}			
					}
				}else{
					Course course = Course.dao.queryById(getParaToInt("courseId"));
					Integer subjectId = course.getInt("subject_id");
					Account account = Account.dao.findById(Integer.parseInt(studentId));
					TimeRank timeRank = TimeRank.dao.findById(Integer.parseInt(rankId));
					double yjfks = CourseOrder.dao.getPaidVIPzks(Integer.valueOf(studentId),subjectId);
					double zks = CourseOrder.dao.getCanUseVIPzks(student.getPrimaryKeyValue(),subjectId);
					double ypks = CoursePlan.coursePlan.getUsedVIPClasshour(Integer.parseInt(studentId), subjectId);
					double syks = ToolArith.sub(zks, ypks);//剩余课时
					Organization org = Organization.dao.findById(1);
					String keqianStr = org.get("basic_maxdefaultclass").toString();
					double keqian = 10000000;
					if(!StringUtils.isEmpty(keqianStr)){
						keqian = Double.parseDouble(keqianStr);
					}
					if (syks > 0) {
						if ((ypks + timeRank.getBigDecimal("class_hour").doubleValue() > yjfks +keqian)&&keqian!=0) {
							code = "1";
							json.put("msg", account.getStr("real_name") + "同学含有欠费订单，交款后继续排课。");
						}else{
							if(timeRank.getBigDecimal("class_hour").doubleValue() > syks) {
								code = "1";
								json.put("msg", account.getStr("real_name") + " 购买[ "+ course.get("subject_name") + " ]科目剩余为[ " 
										+ syks + " ]课时,而该时段课时为[ " + timeRank.getBigDecimal("class_hour") + " ]课时,不够排了,需要重新购买");
							}
						}
					} else {
						code = "1";
						json.put("msg", account.getStr("real_name") +" 购买[ "+ course.get("subject_name") + " ]科目的 课时不足，需要确认是否已交费或重新购买。");
					}
				}		
			}
			json.put("code", code);
			renderJson(json);
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	/**
	 * 购买课程
	 */
	public void goBuyCoursePage(){
		try{
		String studentId = getPara();
		if(StringUtils.isEmpty(studentId)){
			logger.info("学生ID为空");
		}else{
			Student student = Student.dao.findById(Integer.parseInt(studentId));
			if(student == null){
				logger.info("学生不存在");
			}else{
				List<Subject> subjectList = Subject.dao.getSubject();
				List<ClassOrder> classList = ClassOrder.dao.findCanBuyByStudentId(studentId);
				setAttr("banciList", classList);
				setAttr("student", student);
				setAttr("subjectList", subjectList);
				setAttr("operateType","buy");
				renderJsp("/finance/course_buypage.jsp");
			}
		}
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	public void edit(){
		try{
			String orderId = getPara();
			if(StringUtils.isEmpty(orderId)){
				logger.info("订单ID为空");
			}else{
				CourseOrder courseOrder = CourseOrder.dao.findById(Integer.parseInt(orderId));
				if(courseOrder == null){
					logger.info("订单不存在");	
				}else{
					Integer teachType = courseOrder.getInt("teachtype");
					if(teachType!=null && teachType.equals(1)){//一对一
						List<Subject> subjectList = Subject.dao.getSubject();
						String courseIds = courseOrder.getStr("subjectids");
						double canUseHour = CourseOrder.dao.getCanUseVIPzksByCourseOrderId(Integer.parseInt(orderId));
						long payCount = Payment.dao.getPayCount(Integer.parseInt(orderId));
						if(!StringUtils.isEmpty(courseIds)){
							String subIds[] = courseIds.split("\\|");
							for(Subject subject : subjectList){
								String _sid = subject.getPrimaryKeyValue().toString();
								for(String sid : subIds){
									boolean isuse = CoursePlan.coursePlan.checkSubjectIsUse(courseOrder.getInt("studentid"),Integer.parseInt(sid));
									if(_sid.equals(sid)){
										subject.put("checked", "checked");
									}
									if(isuse){
										subject.put("checked", "checked");
										subject.put("isuse", isuse);
									}
								}
							}
						}
						setAttr("payCount",payCount);
						setAttr("canUseHour",canUseHour);
						setAttr("subjectList", subjectList);
						setAttr("courseList",Course.dao.findBySubjectIds(courseIds.replace("|", ",")));
						setAttr("studentCourseIds",CoursePrice.dao.getCourseids(courseOrder.getPrimaryKeyValue()));
					}else{//小班
						int classOrderId = courseOrder.getInt("classorderid");
						List<ClassOrder> classList = new ArrayList<ClassOrder>();
						classList.add(ClassOrder.dao.findById(classOrderId));
						setAttr("banciList", classList);
						List<BanciCourse> banciCourseList = BanciCourse.dao.findByClassOrderId(classOrderId);
						List<CoursePrice> coursePriceList = CoursePrice.dao.findByOrderId(orderId);
						for(BanciCourse bc : banciCourseList){
							for(CoursePrice cp: coursePriceList ){
								if(bc.getInt("course_id").equals(cp.getInt("courseid"))){
									bc.put("oldClassHour", cp.getDouble("classhour"));
									break;
								}
							}
						}
						setAttr("banciCourseList",banciCourseList);
					}
					setAttr("student", Student.dao.findById(courseOrder.getInt("studentid")));
					setAttr("courseOrder",courseOrder);
					setAttr("operateType","modify");
					renderJsp("/finance/course_buypage.jsp");
				}
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	/**
	 * 保存课程订单
	 */
	@Before(Tx.class)
	public void saveCourseOrder(){
		CourseOrder courseOrder = getModel(CourseOrder.class);
		JSONObject json = new JSONObject();
		String code="0";
		String msg="确认成功！";
		Student student = Student.dao.findById(courseOrder.getInt("studentid"));
		if(student == null){
			msg="学生不存在！";
		}else{
			courseOrder.set("operatorid",getSysuserId());
			courseOrder.set("createuserid", getSysuserId());
			courseOrder.set("remainclasshour", courseOrder.getDouble("classhour"));
			CourseOrderService.me.save(courseOrder);
			Integer orderId = courseOrder.getPrimaryKeyValue();
			List<Course> clist = Course.dao.findBySubjectId(courseOrder.getInt("subjectid"));
			for(Course c : clist){
				double ks = getPara("ks_"+c.getPrimaryKeyValue())==null?0:Double.parseDouble(getPara("ks_"+c.getPrimaryKeyValue()));
				if(ks==0){
					continue;
				}
				CoursePrice cp = new CoursePrice();
				cp.set("studentid", courseOrder.getInt("studentid"));
				cp.set("subjectid", courseOrder.getInt("subjectid"));
				cp.set("classhour", ks);
				cp.set("remainclasshour", ks);
				cp.set("courseid", c.getPrimaryKeyValue());
				cp.set("orderid", orderId);
				cp.set("operatorid",courseOrder.getInt("operatorid"));
				CoursePriceService.me.save(cp);
			}
			SysUser sysuser = SysUser.dao.findById(getSysuserId());
			Campus campus = Campus.dao.findById(sysuser.getInt("campusid"));
			if(campus!=null){
				MessageService.sendMessageToFinance(MesContantsFinal.apply_sms, MesContantsFinal.apply_email, courseOrder.getInt("studentid").toString(), campus.getInt("presidentid").toString(), getSysuserId().toString());
			}
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
	}
	
	
	/**
	 * 未审核过的订单审核
	 */
	public void orderFirstReviews(){
		String orderid = getPara();
		CourseOrder co = CourseOrder.dao.findById(Integer.parseInt(orderid));
		String teachtype = co.getInt("teachtype").toString();
		if(teachtype.equals("1")){
			co.put("subjectname", Subject.dao.getSubjectNameByIds(co.getStr("subjectids")));
		}
		setAttr("orders", co);
		if(co.getInt("checkstatus")==2){
			List<OrdersReject> orj = OrdersReject.dao.getOrdersRejectsByOrderId(orderid);
			setAttr("reject", orj);
		}
		render("/finance/order_firstreviews.jsp");
	
	}
	
	/**
	 * /orders/ordersPassed 	
	 * 订单管理/通过待审核
	 */
	public void ordersPassed(){
		try{
			String orderId = getPara("orderId");
			Record loginAccount = getSessionAttr("account_session");// 当前登陆用户
			String loginUserId = loginAccount.getInt("ID").toString();
			CourseOrder co = CourseOrder.dao.findById(orderId);
			Double realsum = co.getBigDecimal("realsum")==null?0:co.getBigDecimal("realsum").doubleValue();
			co.set("checkstatus", 1);
			co.set("checktime", ToolDateTime.getDate());
			co.set("checkuserid", loginUserId);
			if(Double.valueOf(0).compareTo(realsum) == 0){//
				// 如果是0元， 则直接通过交费成功
				co.set("status", 1);
				co.set("paiedtime", new Date());
				co.set("operatorid", getSysuserId());
				co.set("version", co.getInt("version") + 1);
			}
			CourseOrderService.me.update(co);
			List<CoursePrice> coursePriceList = CoursePrice.dao.findByOrderId(orderId);
			for(CoursePrice coursePrice : coursePriceList){
				new UserCourse()
				.set("tech_type", (co.getInt("teachtype") == 1) ? 1 : 2)
				.set("account_id", co.getInt("studentid")).set("course_id", coursePrice.getInt("courseid"))
				.save();
			}
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("msg", "操作已成功.");
			map.put("face", 9);
			MessageService.sendMessageToFinance(MesContantsFinal.apply_sms_pass, MesContantsFinal.apply_email_pass, co.getInt("studentid").toString(), getSysuserId().toString(),co.getInt("operatorid").toString());
			renderJson(map);
		}catch(Exception ex){
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("msg", "操作出现异常，请联系管理员.");
			map.put("face", 8);
			renderJson(map);
			ex.printStackTrace();
		}
	}
	
	public synchronized void ordersReject(){
		try{
			String orderId = getPara("orderId");
			Record loginAccount = getSessionAttr("account_session");// 当前登陆用户
			String loginUserId = loginAccount.getInt("ID").toString();
			CourseOrder co = CourseOrder.dao.findById(orderId);
			co.set("checkstatus", 2);
			co.set("checktime", ToolDateTime.getDate());
			co.set("checkuserid", loginUserId);
			co.update();
			/*OrdersReject ore = new OrdersReject();*/
			OrdersReject ore = getModel(OrdersReject.class);
			ore.set("rejecttime", ToolDateTime.getDate());
			ore.set("operatorid", loginUserId);
			ore.set("operatorname", loginAccount.getStr("REAL_NAME").toString());
			ore.set("orderid", orderId);
			ore.set("reason", getPara("remark"));
			ore.save();
			MessageService.sendMessageToFinance(MesContantsFinal.apply_sms_refuse, MesContantsFinal.apply_email_refuse, co.getInt("studentid").toString(), getSysuserId().toString(), co.getInt("operatorid").toString());
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("msg", "操作已成功.");
			map.put("face", 9);
			renderJson(map);
		}catch(Exception ex){
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("msg", "操作出现异常，请联系管理员.");
			map.put("face", 8);
			renderJson(map);
			ex.printStackTrace();
		}
	}
	
	/**
	 * 订单取消原因
	 */
	public void showOrderReviews(){
		try{
			String orderid = getPara();
			CourseOrder courseOrder = CourseOrder.dao.findById(Integer.parseInt(orderid));
			List<CoursePrice> cplist = CoursePrice.dao.findByOrderId(orderid);
			String teachtype = courseOrder.getInt("teachtype").toString();
			boolean sameprice = true;
			if(teachtype.equals("1")){
				List<Course> courses = Course.dao.findBySubjectId(courseOrder.getInt("subjectid"));
				if(courses.size()>0){
					int price=courses.get(0).getInt("UNIT_PRICE");
					courseOrder.put("price", price);
					for(Course course:courses){
						int _price = course.getInt("UNIT_PRICE")==null?0:course.getInt("UNIT_PRICE");
						if(price !=_price){
							sameprice = false;
							break;
						}
					}
				}
				setAttr("cplist", cplist);
			}
			courseOrder.put("sameprice", sameprice);
			courseOrder.put("coursePirceList", CoursePrice.dao.findByOrderId(orderid));
			setAttr("orders", courseOrder);
			if(courseOrder.getInt("checkstatus")==1){
				List<OrdersReject> orj = OrdersReject.dao.getOrdersRejectsByOrderId(orderid);
				if(orj==null){
					setAttr("msg",0);
				}else{
					setAttr("reject", orj);
					setAttr("msg",1);
				}
			}else{
				List<OrdersReject> orj = OrdersReject.dao.getOrdersRejectsByOrderId(orderid);
				setAttr("reject", orj);
			}
			render("/finance/payment_list.jsp");
	
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	public synchronized void delOrder(){
		JSONObject json = new JSONObject();
		try{
			String orderId = getPara("orderId");
			String reason = getPara("reason").replace(" ", "");
			CourseOrder co = CourseOrder.dao.findById(orderId);
			if(StringUtils.isEmpty(reason)){
				json.put("msg", "请填写取消订单原因！");
				json.put("code", 0);	
			}else{
				co.set("delflag", 1);
				co.set("deltime", ToolDateTime.getDate());
				co.set("deluserid", getSysuserId());
				co.set("delreason", reason);
				co.update();
				json.put("msg", "订单取消成功！");
				json.put("code", 1);
			}
		
		}catch(Exception ex){
			json.put("msg", "操作出现异常，请联系管理员.");
			json.put("code", 0);
			ex.printStackTrace();
		}
		renderJson(json);
	}
	
	/**
	 * 调课
	 */
	public void tiaoke(){
		try{
			String orderId = getPara();
			if(StringUtils.isEmpty(orderId)){
				logger.info("订单ID为空");
			}else{
				CourseOrder courseOrder = CourseOrder.dao.findById(Integer.parseInt(orderId));
				if(courseOrder == null){
					logger.info("订单不存在");	
				}else{
					Integer teachType = courseOrder.getInt("teachtype");
					if(teachType!=null&&teachType.equals(1)){
						List<Subject> subjectList = Subject.dao.getSubject();
						String subjectIds = courseOrder.getStr("subjectids");
						if(!StringUtils.isEmpty(subjectIds)){
							if(subjectIds.substring(0,1).equals("|")){
								subjectIds = subjectIds.substring(1);
							}
							String subIds[] = subjectIds.split("\\|");
							for(Subject subject : subjectList){
								String _sid = subject.getPrimaryKeyValue().toString();
								for(String sid : subIds){
									boolean isuse = CoursePlan.coursePlan.checkSubjectIsUse(courseOrder.getInt("studentid"),Integer.parseInt(sid));
									if(_sid.equals(sid)){
										subject.put("checked", "checked");
									}
									if(isuse){
										subject.put("checked", "checked");
										subject.put("isuse", isuse);
									}
								}
							}
						}
						setAttr("subjectList", subjectList);
					}else{
						List<ClassOrder> classList = new ArrayList<ClassOrder>();
						classList.add(ClassOrder.dao.findById(courseOrder.getInt("classorderid")));
						setAttr("banciList", classList);
					}
					setAttr("student", Student.dao.findById(courseOrder.getInt("studentid")));
					setAttr("courseOrder",courseOrder);
					setAttr("operateType","tiaoke");
					renderJsp("/finance/course_buypage.jsp");
				}
			}
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
	/**
	 * 修改订单
	 */
	public void modify(){
		try{
			String orderId = getPara();
			if(StringUtils.isEmpty(orderId)){
				logger.info("订单ID为空");
				setAttr("msg", "订单不存在");
			}else{
				CourseOrder courseOrder = CourseOrder.dao.findById(Integer.parseInt(orderId));
				if(courseOrder == null){
					logger.info("订单不存在");
					setAttr("msg", "订单不存在");
				}else{
					Subject subject = courseOrder.getInt("studentid")==null?null:Subject.dao.findById(courseOrder.getInt("subjectid"));
					if(subject == null){
						logger.info("科目不存在");
						setAttr("msg", "科目不存在");
					}else{
						Student student = Student.dao.findById(courseOrder.getInt("studentid"));
						if(student == null){
							logger.info("学生不存在");
							setAttr("msg", "学生不存在");
						}else{
							List<CoursePrice> coursePriceList = CoursePrice.dao.findByOrderId(orderId);
							setAttr("student", student);
							setAttr("subject", subject);
							setAttr("courseOrder", courseOrder);
							setAttr("type","modify");
							setAttr("coursePriceList", coursePriceList);
						}
					}
				}
			}
		}catch(Exception ex){
			ex.printStackTrace();
			setAttr("msg", "系统异常");
		}
		renderJsp("/finance/layer_modifyorder.jsp");
	}
	
	public void update(){
		CourseOrder courseOrder = getModel(CourseOrder.class);
		Integer orderId = courseOrder.getPrimaryKeyValue();
		Integer studentid = courseOrder.getInt("studentid");
		int studentId = studentid;
		JSONObject json = new JSONObject();
		String code="0";
		String msg="确认成功！";
		Student student = Student.dao.findById(studentId);
		if(student == null){
			msg="学生不存在！";
		}else{
			String subjectids = getPara("subjectids");
			String courseids = getPara("courseids");
			if(subjectids==null && courseOrder.isTeachType1V1()){
				msg="科目不能为空";
			}else{
				courseOrder.set("status", 1);
				courseOrder.set("remainclasshour",courseOrder.getDouble("classhour"));
				courseOrder.set("subjectids",subjectids);
				CourseOrderService.me.update(courseOrder);
				CoursePrice.dao.deleteByOrderId(orderId);
				if(courseOrder.isTeachType1V1()){
					//---------------- 1对1 start-----------------------
					String[] courseIds = courseids.split("\\|");
					for(int i=0 ;i<courseIds.length;i++){
						CoursePrice coursePrice = new CoursePrice();
						coursePrice.set("studentid", studentid);
						coursePrice.set("unitprice", courseOrder.getDouble("avgprice"));
						coursePrice.set("realprice", courseOrder.getDouble("avgprice"));
						coursePrice.set("classhour", 0);
						coursePrice.set("remainclasshour", 0);
						coursePrice.set("courseid", Integer.parseInt(courseIds[i]));
						coursePrice.set("orderid", orderId);
						coursePrice.set("operatorid",getSysuserId());
						CoursePriceService.me.save(coursePrice);
					}
					UserCourse.dao.deleteByStudentId(studentid);
					List<Course> courses =Course.dao.queryByStudentCourse1v1(studentid);
					for(Course course : courses){
						new UserCourse()
						.set("account_id", studentid)
						.set("course_id", course.get("id"))
						.set("tech_type", 1).save();
					}
					//---------------- 1对1 end-----------------------
				}else{
					//---------------- 小班  start-----------------------
					courseOrder.set("subjectids",0);
					String courseIds[] = getParaValues("course_id");
					String courseHours[] = getParaValues("keshi");
					if(courseIds != null){
						for(int i=0 ;i<courseIds.length;i++){
							String courseHour = courseHours[i];
							if(StringUtils.isEmpty(courseHour))
								continue;
							CoursePrice coursePrice = new CoursePrice();
							coursePrice.set("studentid", studentid);
							coursePrice.set("unitprice", courseOrder.getDouble("avgprice"));
							coursePrice.set("realprice", courseOrder.getDouble("avgprice"));
							coursePrice.set("classhour", courseHour);
							coursePrice.set("remainclasshour", courseHour);
							coursePrice.set("courseid", courseIds[i]);
							coursePrice.set("orderid", orderId);
							coursePrice.set("operatorid",getSysuserId());
							CoursePriceService.me.save(coursePrice);
						}
					}
					//---------------- 小班  end-----------------------
				}
				code = "1";
			}
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
	}
	/**
	 * 发送催费邮件
	 */
	 public void sendCourseOrderMesage(){
		 try{
			 	String studentid = getPara();
			 	Student s = Student.dao.findById(studentid);
			 	List<CourseOrder> colist  = CourseOrder.dao.findArrearByStudentId(studentid);
			 	Double totelqfe = 0.0;
				for(CourseOrder co:colist ){
					CourseOrder c = CourseOrder.dao.findById(co.getInt("id"));
					co.put("paymessage",c);
					totelqfe +=c.getBigDecimal("realsum").doubleValue()-(c.getBigDecimal("paidamount")==null?0.0:c.getBigDecimal("paidamount").doubleValue());
				}
				List<SysUser> ulist = SysUser.dao.getSysUserByLoginRoleCampus(getAccountCampus());
				setAttr("ulist",ulist);
				setAttr("totelqfe",totelqfe);
				setAttr("student",s);
				setAttr("date",new Date());
				setAttr("list",colist);
				setAttr("organization",Organization.dao.findById(1));
			 renderJsp("/finance/layer_sendPaymentMessage.jsp");
		 }catch(Exception e){
			 e.printStackTrace();
		 }
	 }
}
