
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

package com.momathink.homepage.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.ehcache.CacheKit;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.constants.DictKeys;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.homepage.service.MainService;
import com.momathink.sys.leave.model.StudentLeaveReview;
import com.momathink.teaching.knowledge.service.KnowledgeService;
import com.momathink.teaching.remind.model.Remind;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.teacher.model.Announcement;
import com.momathink.teaching.teacher.model.SetPoint;

@Controller(controllerKey = "/main")
public class IndexPageController extends BaseController {

	private final JSONObject json = new JSONObject();

	public void index() {
		try {
			setAttr("copyrighYear", ToolDateTime.getYear(new Date()));
			renderJsp("/WEB-INF/view/main.jsp");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 周
	 */
	public void getWeek() {
		
		String loginRoleCampusIds  = getAccountCampus();
		String type = getPara();
		Map<String, Date> dateMap = new HashMap<String, Date>();
		if("week".equals(type)){
			dateMap = ToolDateTime.getWeekDate(ToolDateTime.getDate());
		}else if("month".equals(type)){
			dateMap = ToolDateTime.getMonthDate(ToolDateTime.getDate());
		}else if("quarter".equals(type)){
			Date startDate = ToolDateTime.getFirstDateOfSeason(ToolDateTime.getDate());
			Date endDate = ToolDateTime.getDate();
			dateMap.put("start", startDate);
			dateMap.put("end", endDate);
		}
		List<String> dateList = ToolDateTime.getDaySpaceDate(dateMap.get("start"), dateMap.get("end"));
		try {
			// 收入
			double week = MainService.me.getWeek(dateMap, getSysuserId(), loginRoleCampusIds );
			json.put("income", week);
			// 销售机会
			// 学生人数
			Long studentWeek = MainService.me.getWeekStudent(dateMap, getSysuserId(), loginRoleCampusIds );
			json.put("stunum", studentWeek);
			// 课时
			double keshi = MainService.me.getKeShi(dateMap, getSysuserId(), loginRoleCampusIds );
			json.put("coursenum", keshi);
			// 图表
			List<Record> statOrdersList = CourseOrder.dao.getOrdersByCreateDate(dateMap, getSysuserId(), loginRoleCampusIds );
			List<Record> statPaiedOrdersList = CourseOrder.dao.getOrdersByPayDate(dateMap, getSysuserId(), loginRoleCampusIds );
			List<Map<String, Object>> olist = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> plist = new ArrayList<Map<String, Object>>();
			double weekDingdan = 0;
			double weekPay = 0;
			double weektotalPay = 0;
			for (String statday : dateList) {
				// 订单
				Map<String, Object> omap = new HashMap<String, Object>();
				Long dayOrders = 0l;
				omap.put("time", ToolDateTime.parse(statday, "yyyy-MM-dd").getTime());
				for (Record statOrder : statOrdersList) {
					String statdate = statOrder.getStr("statdate");
					if (statday.equals(statdate)) {
						dayOrders = statOrder.getLong("numbers");
						weekDingdan += dayOrders;
						break;
					} else {
						continue;
					}
				}
				omap.put("value", dayOrders);
				// 付款
				Map<String, Object> pmap = new HashMap<String, Object>();
				Long dayPay = 0l;
				pmap.put("time", ToolDateTime.parse(statday, "yyyy-MM-dd").getTime());
				for (Record statPaiedOrder : statPaiedOrdersList) {
					String statdate = statPaiedOrder.getStr("statdate");
					if (statday.equals(statdate)) {
						dayPay = statPaiedOrder.getLong("numbers");
						weekPay += dayPay;
						weektotalPay += statPaiedOrder.getBigDecimal("amount").doubleValue();
						break;
					} else {
						continue;
					}
				}
				pmap.put("value", dayPay);
				olist.add(omap);
				plist.add(pmap);
			}
			json.put("data1", olist);
			json.put("data2", plist);
			// 订单总数(x/单)
			json.put("userOrders", weekDingdan);
			// 付款总数(x/单)
			json.put("totalOrders", weekPay);
			// 付款总数(x/RMB)
			json.put("totalNum", weektotalPay);
			renderJson(json);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 年
	 */
	public void getYear() {
		try {
			// //////////////////////////////////////////////////////////////////////////////////////////////////////
			// 收入
			double income = MainService.me.Year(getSysuserId(), getAccountCampus());
			json.put("income", income);
			// 学生人数
			Long stunum = MainService.me.studentYear(getSysuserId(),getAccountCampus());
			json.put("stunum", stunum);
			// 课时
			double coursenum = MainService.me.yearkeshi(getSysuserId(), getAccountCampus());
			json.put("coursenum", coursenum);
			// ////////////////////////////////////////////////////////////////////////////////////////////////////////
			// 图表
			String today = ToolDateTime.format(new Date(), "yyyy-MM-dd");
			List<Map<String, Object>> olist = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> plist = new ArrayList<Map<String, Object>>();
			for (int i = 365; i >= 0; i--) {
				String firstDay = ToolDateTime.getSpecifiedDayBefore(today, i);
				String lastDay = ToolDateTime.getSpecifiedDayBefore(today, i - 1);
				Long dayOrders = CourseOrder.dao.getUserDayOrders(firstDay, lastDay, getSysuserId());
				Map<String, Object> omap = new HashMap<String, Object>();
				omap.put("time", ToolDateTime.parse(firstDay, "yyyy-MM-dd").getTime());
				omap.put("value", dayOrders);
				Long dayPay = CourseOrder.dao.getDayUserPay(firstDay, lastDay, getSysuserId());
				Map<String, Object> pmap = new HashMap<String, Object>();
				pmap.put("time", ToolDateTime.parse(firstDay, "yyyy-MM-dd").getTime());
				pmap.put("value", dayPay);
				olist.add(omap);
				plist.add(pmap);
			}
			// 图表数据
			json.put("data1", olist);
			json.put("data2", plist);
			// 订单总数(x/单)
			double userOrders = MainService.me.getyearDingdan(getSysuserId(), getAccountCampus() );
			json.put("userOrders", userOrders);
			// 付款总数(x/单)
			Long totalOrders = MainService.me.getPaytyearOrder(getSysuserId(), getAccountCampus());
			json.put("totalOrders", totalOrders);
			// 付款总数(x/RMB)
			double totalNum = MainService.me.getPayyeartotalMoney(getSysuserId(), getAccountCampus());
			json.put("totalNum", totalNum);
			renderJson(json);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 总收入
	 */

	public void getAmout() {

		try {
			double amount = MainService.me.getAmount();
			json.put("amount", amount);

		} catch (Exception e) {
			e.printStackTrace();
		}
		renderJson(json);
	}

	/**
	 * 总学生人数
	 */

	public void getAmountStudent() {

		JSONObject json = new JSONObject();

		try {
			Long amSt = MainService.me.getAmStudent();
			json.put("amSt", amSt);
		} catch (Exception e) {
			e.printStackTrace();
		}
		renderJson(json);
	}

	/**
	 * 总课时
	 */
	public void getAmountCourseplan() {
		try {
			Long amountCour = MainService.me.getAmountCous();
			json.put("amountCour", amountCour);
		} catch (Exception e) {
			e.printStackTrace();
		}
		renderJson(json);
	}

	/**
	 * 总订单数
	 */
	public void getAmountOrder() {

		try {
			Long amountOrder = MainService.me.getAmountOrderCous();
			json.put("amountOrder", amountOrder);
			System.out.println(amountOrder);
		} catch (Exception e) {
			e.printStackTrace();
		}
		renderJson(json);
	}

	/**
	 * 付款总数
	 */
	// public void getAmountPay(){
	//
	// try {
	// Long AmountPay = mainService.getPayAmountOrder();
	// json.put("AmountPay", AmountPay);
	// System.out.println(AmountPay);
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	// renderJson(json);
	// }

	// ---------------------------------------------------
	/**
	 * 月收入
	 */
	public void getRevenues() {
		JSONObject json = new JSONObject();
		Record sysUser = getSessionAttr("account_session");
		Integer sysuserId = sysUser.getInt("ID");
		try {
			// 当月payment
			String monthIncome = MainService.me.getMonthIncome(sysuserId);

			json.put("monthIncome", monthIncome);
			// 整年
			String yearIncome = MainService.me.getYearIncome(sysuserId);
			json.put("yearIncome", yearIncome);
			System.out.println("year" + json);

		} catch (Exception ex) {
			ex.printStackTrace();
		}

		renderJson(json);
	}

	/**
	 * 学生人数（月）
	 */
	public void getStudentNum() {
		JSONObject json = new JSONObject();
		// Record sysUser = getSessionAttr("account_session");
		// Long sysId = sysUser.getLong("ID");
		try {
			// Long monthStudents = mainService.getMonthUserStudents(sysId);
			Long monthStudents = MainService.me.getMonthUserStudents(getSysuserId());
			json.put("monthSysStu", monthStudents);
			Long monthStu = MainService.me.getMonthUserStudents(null);
			json.put("monthStus", monthStu);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		renderJson(json);
	}

	/**
	 * 课时（天）
	 */
	public void getDayCourseNum() {
		JSONObject json = new JSONObject();
		// Record sysUser = getSessionAttr("account_session");
		// Long sysId = sysUser.getLong("ID");
		try {
			// Long stuCourseplans = mainService.getCoursePlanDay(sysId);
			// Long stuMonthPlans = mainService.getCoursePlanMonth(sysId);
			Long stuCourseplans = MainService.me.getCoursePlanDay(getSysuserId());
			Long stuMonthPlans = MainService.me.getCoursePlanMonth(getSysuserId());
			json.put("dayPlans", stuCourseplans);
			json.put("monthPlans", stuMonthPlans);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		renderJson(json);

	}

	/**
	 * 订单数和付款数(图表)
	 */
	public void getOrderAndPayList() {
		try {
			String today = ToolDateTime.format(new Date(), "yyyy-MM-dd");
			List<Map<String, Object>> olist = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> plist = new ArrayList<Map<String, Object>>();
			Long maxOrder = 0L;
			Long maxPay = 0L;
			Long amountOrder = MainService.me.getAmountOrderCous();
			json.put("amountOrder", amountOrder);
			Long AmountPay = MainService.me.getPayAmountOrder();// 付款总数（人）
			json.put("AmountPay", AmountPay);
			double Pay = MainService.me.getPayMoney();// 总金额
			json.put("Pay", Pay);
			for (int i = 31; i >= 0; i--) {
				String firstDay = ToolDateTime.getSpecifiedDayBefore(today, i);
				String lastDay = ToolDateTime.getSpecifiedDayBefore(today, i - 1);
				Long dayOrders = CourseOrder.dao.getUserDayOrders(firstDay, lastDay, getSysuserId());
				Map<String, Object> omap = new HashMap<String, Object>();
				omap.put("time", ToolDateTime.parse(firstDay, "yyyy-MM-dd").getTime());
				omap.put("value", dayOrders);
				maxOrder = maxOrder > dayOrders ? maxOrder : dayOrders;
				Long dayPay = CourseOrder.dao.getDayUserPay(firstDay, lastDay, getSysuserId());
				Map<String, Object> pmap = new HashMap<String, Object>();
				pmap.put("time", ToolDateTime.parse(firstDay, "yyyy-MM-dd").getTime());
				pmap.put("value", dayPay);
				olist.add(omap);
				plist.add(pmap);
				maxPay = maxPay > dayPay ? maxPay : dayPay;

			}
			Long userOrders = CourseOrder.dao.getUserDayOrders(ToolDateTime.getSpecifiedDayBefore(today, 31), today, getSysuserId());
			Long paiedOrders = CourseOrder.dao.getDayUserPay(ToolDateTime.getSpecifiedDayBefore(today, 31), today, getSysuserId());
			// String totalNumRMB =
			// CourseOrder.dao.getSumPaied(getSysuserId(),ToolDateTime.getSpecifiedDayBefore(today,
			// 31), today);
			json.put("userOrders", userOrders);// 订单总数(月/单)
			json.put("totalOrders", paiedOrders);// 付款订单数量(月/单)
			json.put("data1", olist);
			json.put("data2", plist);
			json.put("maxdata1", maxOrder + 2);
			json.put("maxdata2", maxPay + 1);
			// json.put("totalNum", totalNumRMB);//付款金额(月/RMB)

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		renderJson(json);

	}

	/**
	 * 反馈消息
	 */
	public void getFeedbackMassage() {

	}

	/** 未读消息 */
	public void getMessage() {
		JSONObject ret = new JSONObject();
		try {
			Integer sysuserId = getSysuserId();
			Record sysuser = getAccount();
			//获取缓存 减少数据查询次数
			Object timeObj = getSessionAttr("getMessage_time");
			if(timeObj != null){
				long timev = new Date().getTime();
				long timex = ((Date) timeObj).getTime();
				//1分钟内的请求 就使用 缓存数据
				if((timev - timex) < 60000){
					ret = CacheKit.get(DictKeys.cache_name_page, "getMessage_ret_" + sysuserId);
					if(ret != null){
						renderJson(ret);
						return;
					}else ret = new JSONObject();
				}
			}
			
			Map<Object, Object> s = getSessionAttr("operator_session");
			
			Long total = new Long("0");
			
			//最新订单
			if(toolQX(s, "qx_orders", false)){
				Long v = CourseOrder.dao.getUnreadOrderCounts(sysuserId);
				ret.put("orderCount", v);
				total += v;
			}
			
			
			//报告提醒
			if(toolQX(s, "qx_studentbirthday", false)){
				Long v = SetPoint.dao.getCountsForTeacherUnSubmit(sysuserId);
				ret.put("reportcounts", v);
				total += v;
			}
			
			//消息提醒
			if(toolQX(s, "qx_reportteacherReports", false)){
				Long v = Announcement.dao.getCountsUnreadMessage(sysuserId);
				ret.put("noann", v);
				total += v;
			}
			
			//学生生日提醒
			if(toolQX(s, "qx_teacherqueryAllReceiver", false)){
				Long v = Student.dao.getCountBirthdayToDay();
				ret.put("count", v);
				total += v;
			}
			
			//学生请假审批
			if(toolQX(s, "qx_leavemyAwaiting", false)){
				Long v = StudentLeaveReview.dao.getReviewNumbersBy(sysuserId);
				ret.put("approvalCount", v);
				total += v;
			}
			
			//未评价的课程
			if(toolQX(s, "qx_maingetMessagequeryByTeachergradeNoComment", false)){
				Long v = KnowledgeService.me.queryByTeachergradeNoComment(sysuser);
				ret.put("nocomment", v);
				total += v;
			}
			
			//提醒记录
			if(toolQX(s, "qx_remindManagerlist", false)){
				Long v = Remind.dao.getUnreadRemindCounts(sysuserId);
				ret.put("remind", v);
				total += v;
			}
			
			ret.put("total", total);
			
			//放入缓存 和Session时间戳
			setSessionAttr("getMessage_time", new Date());
			CacheKit.put(DictKeys.cache_name_page, "getMessage_ret_" + sysuserId, ret);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		renderJson(ret);
	}
	
	private boolean toolQX(Map<Object, Object> s, String k, boolean defaultv){
		Object ret = s.get(k);
		return ret != null ? (boolean) ret : defaultv;
	}
}
