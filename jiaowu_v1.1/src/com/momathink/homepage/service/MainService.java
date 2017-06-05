
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

package com.momathink.homepage.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.apache.log4j.Logger;

import com.momathink.common.base.BaseService;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.finance.model.CourseOrder;
import com.momathink.finance.model.Payment;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;

public class MainService extends BaseService {

	private static Logger log = Logger.getLogger(MainService.class);
	
	public static final MainService me = new MainService();

	public Long getUnreadOrder(Integer userId) {
		try {
			String sql = "select COUNT(*) as count from crm_courseorder co " + " left join account stu on stu.ID=co.studentid "
					+ " left join crm_opportunity opp on opp.id=stu.oppotunityid" + " where co.isread=0 and opp.scuserid = ? ";
			Long counts = CourseOrder.dao.find(sql, userId).get(0).get("count");
			return counts;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public String getMonthIncome(Integer sysuserId) {
		try {
			// 根据当天取得这个月的首
			Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
			return Payment.dao.getIncome(sysuserId, ToolDateTime.format(map.get("start"), "yyyy-MM-dd"));
		} catch (Exception ex) {
			ex.printStackTrace();
			log.error(ex);
		}
		return null;
	}

	public String getYearIncome(Integer sysuserId) {
		try {
			String firstDay = ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd");
			return Payment.dao.getIncome(sysuserId, firstDay);
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return null;
	}

	public Long getMonthUserStudents(Integer sysId) {
		try {
			Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
			return Student.dao.getMonthStudents(sysId, map.get("start"), map.get("end"));
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public Long getCoursePlanDay(Integer sysId) {
		String dayStr = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CoursePlan.coursePlan.getCoursePlanMonth(sysId, dayStr, dayStr);
	}

	public Long getCoursePlanMonth(Integer sysId) {
		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		String firstDay = ToolDateTime.format(map.get("start"), "yyyy-MM-dd");
		String dayStr = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CoursePlan.coursePlan.getCoursePlanMonth(sysId, firstDay, dayStr);
	}

	// ..................
	// public String getSevenIncome() {
	// Map<String, Date> map = ToolDateTime.getWeekDate(new Date());
	// String firstDay = ToolDateTime.format(map.get("start"), "yyyy-MM-dd");
	// String dayStr = ToolDateTime.format(new Date(), "yyyy-MM-dd");
	// System.out.println("firstDay"+firstDay+"dayStr"+dayStr);
	// return Payment.dao.getIncome();
	//
	// }

	public double getAmount() {

		return Payment.dao.getAmount();
	}

	public double getWeek(Map<String,Date> dateMap,Integer sysUserId, String loginRoleCampusIds ) throws ParseException {
		String beginDate = ToolDateTime.format(dateMap.get("start"), "yyyy-MM-dd");
		String endDate = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CourseOrder.dao.getSumPaied(beginDate,endDate, sysUserId, loginRoleCampusIds );
	}

	// ----------------------------------------------
	public double getMonth(Integer integer, String loginRoleCampusIds ) {
		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		return CourseOrder.dao.getSumPaied(ToolDateTime.format(map.get("start"), "yyyy-MM-dd"), ToolDateTime.format(map.get("end"), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double getMonths(Integer integer) {
		Date map = ToolDateTime.getFirstDateOfMonth(new Date());
		return Payment.dao.getMonth(integer, ToolDateTime.format(map, "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"));
	}

	public double getThmonth(Integer integer, String loginRoleCampusIds) {
		Date d1 = ToolDateTime.getlastMonthFirstDay(new Date());
		return CourseOrder.dao.getSumPaied(ToolDateTime.format(d1, "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double Year(Integer integer, String loginRoleCampusIds) {
		String firstDay = ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd");
		String now = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CourseOrder.dao.getSumPaied(firstDay, now, integer, loginRoleCampusIds);
	}

	public Long getWeekStudent(Map<String,Date> dateMap,Integer sysUserId, String loginRoleCampusIds ) throws ParseException {
		String beginDate = ToolDateTime.format(dateMap.get("start"), "yyyy-MM-dd");
		return Student.dao.getMonthStudent(beginDate, sysUserId, loginRoleCampusIds);
	}

	public Long getAmStudent() {

		return Student.dao.getAmountStudent();
	}

	public Long getAmountCous() {

		return CoursePlan.coursePlan.getAmountCous();
	}

	// -----
	public double getKeShi(Map<String,Date> dateMap,Integer sysUserId, String loginRoleCampusIds ) throws ParseException {
		String beginDate = ToolDateTime.format(dateMap.get("start"), "yyyy-MM-dd");
		String endDate = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CoursePlan.coursePlan.monthkeshi(beginDate,endDate, sysUserId, loginRoleCampusIds);
	}

	// 总订单
	public Long getAmountOrderCous() {
		// Map<String, Date> map = ToolDateTime.getWeekDate(new Date());
		// return
		// CourseOrder.dao.getAmountOrderCous(ToolDateTime.format(map.get("start"),
		// "yyyy-MM-dd"));

		return CourseOrder.dao.getAmountDingdan();
	}

	// 课时
	public double getWeekOrder() throws ParseException {
		// Map<String, Date> map = ToolDateTime.getWeekDate(new Date());
		String map = ToolDateTime.getSpecifiedDayBefore(new SimpleDateFormat("yyyy-MM-dd").format(new Date()), 7);
		return CourseOrder.dao.getWeekOrder(ToolDateTime.format(new SimpleDateFormat("yyyy-MM-dd").parse(map), "yyyy-MM-dd"),
				ToolDateTime.format(new Date(), "yyyy-MM-dd"));
		// return CourseOrder.dao.getWeekOrder();
	}

	// 付款总数（人）
	public Long getPayAmountOrder() {

		return Payment.dao.getPayAmountOrder();
	}


	// public Long getWeekMonth() {
	//
	// return Student.dao.getMonth();
	// }

	public Long studentThMonth(Integer integer) {
		Date d1 = ToolDateTime.getlastMonthFirstDay(new Date());
		return Student.dao.getMonthStudent(ToolDateTime.format(d1, "yyyy-MM-dd"), integer);
	}

	public Long studentYear(Integer integer, String loginRoleCampusIds ) {
		String firstDay = ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd");
		return Student.dao.getMonthStudent(firstDay, integer, loginRoleCampusIds );
	}

	public double monthkeshi(Integer integer, String loginRoleCampusIds ) {
		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		return CoursePlan.coursePlan
				.monthkeshi(ToolDateTime.format(map.get("start"), "yyyy-MM-dd"), ToolDateTime.format(map.get("end"), "yyyy-MM-dd"), integer, loginRoleCampusIds);
		// return CoursePlan.coursePlan.monthkeshi();
	}

	public double monthkeshis(Integer integer, String loginRoleCampusIds ) {
		Date map = ToolDateTime.getFirstDateOfMonth(new Date());
		return CoursePlan.coursePlan.monthkeshi(ToolDateTime.format(map, "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double thmonthkeshi(Integer integer, String loginRoleCampusIds) {
		Date d1 = ToolDateTime.getlastMonthFirstDay(new Date());
		return CoursePlan.coursePlan.monthkeshi(ToolDateTime.format(d1, "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double yearkeshi(Integer integer, String loginRoleCampusIds ) {
		String firstDay = ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd");
		String now = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CoursePlan.coursePlan.monthkeshi(firstDay, now, integer, loginRoleCampusIds);
	}

	// 学生
	public Long getMonthStudent(Integer integer) {
		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		return Student.dao.getMonthStudent(ToolDateTime.format(map.get("start"), "yyyy-MM-dd"), integer);
	}

	public Long getMonthStudents(Integer integer) {
		Date map = ToolDateTime.getFirstDateOfMonth(new Date());
		return Student.dao.getMonthStudent(ToolDateTime.format(map, "yyyy-MM-dd"), integer);
	}


	// 周订单
	public double getWeekDingdan(Integer integer, String loginRoleCampusIds ) throws ParseException {
		String map = ToolDateTime.getSpecifiedDayBefore(new SimpleDateFormat("yyyy-MM-dd").format(new Date()), 7);
		return CourseOrder.dao.getMonth(ToolDateTime.format(new SimpleDateFormat("yyyy-MM-dd").parse(map), "yyyy-MM-dd"),
				ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double getMonthDingdan(Integer integer, String loginRoleCampusIds) {

		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		return CourseOrder.dao.getMonth(ToolDateTime.format(map.get("start"), "yyyy-MM-dd"), ToolDateTime.format(map.get("end"), "yyyy-MM-dd"), integer, loginRoleCampusIds );
	}

	public double getthMonthDingdan(Integer integer, String loginRoleCampusIds ) {
		Date d1 = ToolDateTime.getlastMonthFirstDay(new Date());
		return CourseOrder.dao.getMonth(ToolDateTime.format(d1, "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds );
	}

	public double getyearDingdan(Integer integer, String loginRoleCampusIds ) {
		String firstDay = ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd");
		String now = ToolDateTime.format(new Date(), "yyyy-MM-dd");
		return CourseOrder.dao.getMonth(firstDay, now, integer, loginRoleCampusIds );
	}

	public double getPayMoney() {

		return Payment.dao.getPayMoney();

	}

	public Long getPayweekOrder(Integer integer, String loginRoleCampusIds ) throws ParseException {
		String map = ToolDateTime.getSpecifiedDayBefore(new SimpleDateFormat("yyyy-MM-dd").format(new Date()), 7);
		return CourseOrder.dao.getCOUNTPaied(ToolDateTime.format(new SimpleDateFormat("yyyy-MM-dd").parse(map), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public Long getPaymonthOrder(Integer integer, String loginRoleCampusIds) {
		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		return CourseOrder.dao.getCOUNTPaied(ToolDateTime.format(map.get("start"), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public Long getPaytmonthOrder(Integer integer, String loginRoleCampusIds) {
		Date map = ToolDateTime.getlastMonthFirstDay(new Date());
		return CourseOrder.dao.getCOUNTPaied(ToolDateTime.format(map, "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public Long getPaytyearOrder(Integer integer, String loginRoleCampusIds ) {
		String firstDay = ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd");
		return CourseOrder.dao.getCOUNTPaied(firstDay, integer, loginRoleCampusIds );
	}

	public double getPayweektotalMoney(Integer integer, String loginRoleCampusIds ) throws ParseException {
		String map = ToolDateTime.getSpecifiedDayBefore(new SimpleDateFormat("yyyy-MM-dd").format(new Date()), 7);
		return CourseOrder.dao.getSumPaied(ToolDateTime.format(new SimpleDateFormat("yyyy-MM-dd").parse(map), "yyyy-MM-dd"),
				ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double getPaymonthtotalMoney(Integer integer, String loginRoleCampusIds) {
		Map<String, Date> map = ToolDateTime.getMonthDate(new Date());
		return CourseOrder.dao.getSumPaied(ToolDateTime.format(map.get("start"), "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double getPaytmonthtotalMoney(Integer integer, String loginRoleCampusIds) {
		Date map = ToolDateTime.getlastMonthFirstDay(new Date());
		return CourseOrder.dao.getSumPaied(ToolDateTime.format(map, "yyyy-MM-dd"), ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

	public double getPayyeartotalMoney(Integer integer,String loginRoleCampusIds) {
		return CourseOrder.dao.getSumPaied(ToolDateTime.format(ToolDateTime.getCurrentYearStartTime(), "yyyy-MM-dd"),
				ToolDateTime.format(new Date(), "yyyy-MM-dd"), integer, loginRoleCampusIds);
	}

}
