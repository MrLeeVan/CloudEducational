
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

package com.momathink.common.tools;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

/**
 * 日期时间相关
 * 
 * @author David 2012-9-7 下午1:58:46
 */
public class ToolDateTime {

	private static Logger log = Logger.getLogger(ToolDateTime.class);

	public static final String pattern_ymd = "yyyy-MM-dd"; // pattern_ymd
	public static final String pattern_ymd_ch = "yyyy年MM月dd日"; // pattern_ymd
	public static final String pattern_ymd_hm = "yyyy-MM-dd HH:mm"; // pattern_ymdtime
	public static final String pattern_ymd_hms = "yyyy-MM-dd HH:mm:ss"; // pattern_ymdtime
	public static final String pattern_ymd_hms_s = "yyyy-MM-dd HH:mm:ss:SSS"; // pattern_ymdtimeMillisecond
	// 默认显示日期的格式
	public static final String DATAFORMAT_STR = "yyyy-MM-dd";
	// 默认显示日期的格式
	public static final String YYYY_MM_DATAFORMAT_STR = "yyyy-MM";
	// 默认显示日期时间的格式
	public static final String DATATIMEF_STR = "yyyy-MM-dd HH:mm:ss";
	// 默认显示简体中文日期的格式
	public static final String ZHCN_DATAFORMAT_STR = "yyyy年MM月dd日";
	// 默认显示简体中文日期时间的格式
	public static final String ZHCN_DATATIMEF_STR = "yyyy年MM月dd日HH时mm分ss秒";
	// 默认显示简体中文日期时间的格式
	public static final String ZHCN_DATATIMEF_STR_4yMMddHHmm = "yyyy年MM月dd日HH时mm分";
	private static DateFormat dateFormat = null;
	private static DateFormat dateTimeFormat = null;
	private static DateFormat zhcnDateFormat = null;
	private static DateFormat zhcnDateTimeFormat = null;
	static {
		dateFormat = new SimpleDateFormat(DATAFORMAT_STR);
		dateTimeFormat = new SimpleDateFormat(DATATIMEF_STR);
		zhcnDateFormat = new SimpleDateFormat(ZHCN_DATAFORMAT_STR);
		zhcnDateTimeFormat = new SimpleDateFormat(ZHCN_DATATIMEF_STR);
	}

	private static DateFormat getDateFormat(String formatStr) {
		if (formatStr.equalsIgnoreCase(DATAFORMAT_STR)) {
			return dateFormat;
		} else if (formatStr.equalsIgnoreCase(DATATIMEF_STR)) {
			return dateTimeFormat;
		} else if (formatStr.equalsIgnoreCase(ZHCN_DATAFORMAT_STR)) {
			return zhcnDateFormat;
		} else if (formatStr.equalsIgnoreCase(ZHCN_DATATIMEF_STR)) {
			return zhcnDateTimeFormat;
		} else {
			return new SimpleDateFormat(formatStr);
		}
	}

	/**
	 * 按照默认显示日期时间的格式"yyyy-MM-dd HH:mm:ss"，转化dateTimeStr为Date类型
	 * dateTimeStr必须是"yyyy-MM-dd HH:mm:ss"的形式
	 * @param dateTimeStr
	 * @return
	 */
	public static Date getDate(String dateTimeStr) {
		return getDate(dateTimeStr, DATATIMEF_STR);
	}

	/**
	 * 按照默认formatStr的格式，转化dateTimeStr为Date类型
	 * dateTimeStr必须是formatStr的形式
	 * @param dateTimeStr
	 * @param formatStr
	 * @return
	 */
	public static Date getDate(String dateTimeStr, String formatStr) {
		try {
			if (dateTimeStr == null || dateTimeStr.equals("")) {
				return null;
			}
			DateFormat sdf = getDateFormat(formatStr);
			java.util.Date d = sdf.parse(dateTimeStr);
			return d;
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * 将YYYYMMDD转换成Date日期
	 * @param date
	 * @return
	 * @throws BusinessException
	 */
	public static Date transferDate(String date) throws Exception {
		if (date == null || date.length() < 1)
			return null;

		if (date.length() != 8)
			throw new Exception("日期格式错误");
		String con = "-";

		String yyyy = date.substring(0, 4);
		String mm = date.substring(4, 6);
		String dd = date.substring(6, 8);

		int month = Integer.parseInt(mm);
		int day = Integer.parseInt(dd);
		if (month < 1 || month > 12 || day < 1 || day > 31)
			throw new Exception("日期格式错误");

		String str = yyyy + con + mm + con + dd;
		return ToolDateTime.getDate(str, ToolDateTime.DATAFORMAT_STR);
	}

	/**
	 * 将Date转换成字符串“yyyy-mm-dd hh:mm:ss”的字符串
	 * @param date
	 * @return
	 */
	public static String dateToDateString(Date date) {
		return dateToDateString(date, DATATIMEF_STR);
	}

	/**
	 * 将Date转换成formatStr格式的字符串
	 * @param date
	 * @param formatStr
	 * @return
	 */
	public static String dateToDateString(Date date, String formatStr) {
		DateFormat df = getDateFormat(formatStr);
		return df.format(date);
	}

	/**
	 * 返回一个yyyy-MM-dd HH:mm:ss 形式的日期时间字符串中的HH:mm:ss
	 * @param dateTime
	 * @return
	 */
	public static String getTimeString(String dateTime) {
		return getTimeString(dateTime, DATATIMEF_STR);
	}

	/**
	 * 返回一个formatStr格式的日期时间字符串中的HH:mm:ss
	 * @param dateTime
	 * @param formatStr
	 * @return
	 */
	public static String getTimeString(String dateTime, String formatStr) {
		Date d = getDate(dateTime, formatStr);
		String s = dateToDateString(d);
		return s.substring(DATATIMEF_STR.indexOf('H'));
	}

	/**
	 * 获取当前日期yyyy-MM-dd的形式
	 * @return
	 */
	public static String getCurDate() {
		// return dateToDateString(new Date(),DATAFORMAT_STR);
		return dateToDateString(Calendar.getInstance().getTime(),
				DATAFORMAT_STR);
	}

	/**
	 * 获取当前日期yyyy年MM月dd日的形式
	 * @return
	 */
	public static String getCurZhCNDate() {
		return dateToDateString(new Date(), ZHCN_DATAFORMAT_STR);
	}

	/**
	 * 获取当前日期时间yyyy-MM-dd HH:mm:ss的形式
	 * @return
	 */
	public static String getCurDateTime() {
		return dateToDateString(new Date(), DATATIMEF_STR);
	}

	/**
	 * 获取当前日期时间yyyy年MM月dd日HH时mm分ss秒的形式
	 * @return
	 */
	public static String getCurZhCNDateTime() {
		return dateToDateString(new Date(), ZHCN_DATATIMEF_STR);
	}

	/**
	 * 获取日期d的days天后的一个Date
	 * @param d
	 * @param days
	 * @return
	 */
	public static Date getInternalDateByDay(Date d, int days) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		now.add(Calendar.DATE, days);
		return now.getTime();
	}

	public static Date getInternalDateByMon(Date d, int months) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		now.add(Calendar.MONTH, months);
		return now.getTime();
	}

	public static Date getInternalDateByYear(Date d, int years) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		now.add(Calendar.YEAR, years);
		return now.getTime();
	}

	public static Date getInternalDateBySec(Date d, int sec) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		now.add(Calendar.SECOND, sec);
		return now.getTime();
	}

	public static Date getInternalDateByMin(Date d, int min) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		now.add(Calendar.MINUTE, min);
		return now.getTime();
	}

	public static Date getInternalDateByHour(Date d, int hours) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		now.add(Calendar.HOUR_OF_DAY, hours);
		return now.getTime();
	}

	/**
	 * 根据一个日期字符串，返回日期格式，目前支持4种
	 * 如果都不是，则返回null
	 * @param DateString
	 * @return
	 */
	public static String getFormateStr(String DateString) {
		String patternStr1 = "[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}"; // "yyyy-MM-dd"
		String patternStr2 = "[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}\\s[0-9]{1,2}:[0-9]{1,2}:[0-9]{1,2}"; // "yyyy-MM-dd HH:mm:ss";
		String patternStr3 = "[0-9]{4}年[0-9]{1,2}月[0-9]{1,2}日";// "yyyy年MM月dd日"
		String patternStr4 = "[0-9]{4}年[0-9]{1,2}月[0-9]{1,2}日[0-9]{1,2}时[0-9]{1,2}分[0-9]{1,2}秒";// "yyyy年MM月dd日HH时mm分ss秒"

		Pattern p = Pattern.compile(patternStr1);
		Matcher m = p.matcher(DateString);
		boolean b = m.matches();
		if (b)
			return DATAFORMAT_STR;
		p = Pattern.compile(patternStr2);
		m = p.matcher(DateString);
		b = m.matches();
		if (b)
			return DATATIMEF_STR;

		p = Pattern.compile(patternStr3);
		m = p.matcher(DateString);
		b = m.matches();
		if (b)
			return ZHCN_DATAFORMAT_STR;

		p = Pattern.compile(patternStr4);
		m = p.matcher(DateString);
		b = m.matches();
		if (b)
			return ZHCN_DATATIMEF_STR;
		return null;
	}

	/**
	 * 将一个"yyyy-MM-dd HH:mm:ss"字符串，转换成"yyyy年MM月dd日HH时mm分ss秒"的字符串
	 * @param dateStr
	 * @return
	 */
	public static String getZhCNDateTime(String dateStr) {
		Date d = getDate(dateStr);
		return dateToDateString(d, ZHCN_DATATIMEF_STR);
	}

	/**
	 * 将一个"yyyy-MM-dd"字符串，转换成"yyyy年MM月dd日"的字符串
	 * @param dateStr
	 * @return
	 */
	public static String getZhCNDate(String dateStr) {
		Date d = getDate(dateStr, DATAFORMAT_STR);
		return dateToDateString(d, ZHCN_DATAFORMAT_STR);
	}

	/**
	 * 将dateStr从fmtFrom转换到fmtTo的格式
	 * @param dateStr
	 * @param fmtFrom
	 * @param fmtTo
	 * @return
	 */
	public static String getDateStr(String dateStr, String fmtFrom, String fmtTo) {
		Date d = getDate(dateStr, fmtFrom);
		return dateToDateString(d, fmtTo);
	}

	/**
	 * 比较两个"yyyy-MM-dd HH:mm:ss"格式的日期，之间相差多少毫秒,time2-time1
	 * @param time1
	 * @param time2
	 * @return
	 */
	public static long compareDateStr(String time1, String time2) {
		Date d1 = getDate(time1);
		Date d2 = getDate(time2);
		return d2.getTime() - d1.getTime();
	}

	/**
	 * 将小时数换算成返回以毫秒为单位的时间
	 * @param hours
	 * @return
	 */
	public static long getMicroSec(BigDecimal hours) {
		BigDecimal bd;
		bd = hours.multiply(new BigDecimal(3600 * 1000));
		return bd.longValue();
	}

	/**
	 * 获取Date中的分钟
	 * @param d
	 * @return
	 */
	public static int getMin(Date d) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		return now.get(Calendar.MINUTE);
	}

	/**
	 * 获取Date中的小时(24小时)
	 * @param d
	 * @return
	 */
	public static int getHour(Date d) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		return now.get(Calendar.HOUR_OF_DAY);
	}

	/**
	 * 获取Date中的秒
	 * @param d
	 * @return
	 */
	public static int getSecond(Date d) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		return now.get(Calendar.SECOND);
	}

	/**
	 * 获取xxxx-xx-xx的日
	 * @param d
	 * @return
	 */
	public static int getDay(Date d) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		return now.get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 获取月份，1-12月
	 * @param d
	 * @return
	 */
	public static int getMonth(Date d) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		return now.get(Calendar.MONTH) + 1;
	}

	/**
	 * 获取19xx,20xx形式的年
	 * @param d
	 * @return
	 */
	public static int getYear(Date d) {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		now.setTime(d);
		return now.get(Calendar.YEAR);
	}

	/**
	 * 得到d的上个月的年份+月份,如200505
	 * @return
	 */
	public static String getYearMonthOfLastMon(Date d) {
		Date newdate = getInternalDateByMon(d, -1);
		String year = String.valueOf(getYear(newdate));
		String month = String.valueOf(getMonth(newdate));
		return year + month;
	}

	/**
	 * 得到当前日期的年和月如200509
	 * @return String
	 */
	public static String getCurYearMonth() {
		Calendar now = Calendar.getInstance(TimeZone.getDefault());
		String DATE_FORMAT = "yyyyMM";
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(
				DATE_FORMAT);
		sdf.setTimeZone(TimeZone.getDefault());
		return (sdf.format(now.getTime()));
	}

	public static Date getNextMonth(String year, String month) {
		String datestr = year + "-" + month + "-01";
		Date date = getDate(datestr, DATAFORMAT_STR);
		return getInternalDateByMon(date, 1);
	}

	public static Date getLastMonth(String year, String month) {
		String datestr = year + "-" + month + "-01";
		Date date = getDate(datestr, DATAFORMAT_STR);
		return getInternalDateByMon(date, -1);
	}

	/**
	 * 得到日期d，按照页面日期控件格式，如"2001-3-16"
	 * @param d
	 * @return
	 */
	public static String getSingleNumDate(Date d) {
		return dateToDateString(d, DATAFORMAT_STR);
	}

	/**
	 * 得到d半年前的日期,"yyyy-MM-dd"
	 * @param d
	 * @return
	 */
	public static String getHalfYearBeforeStr(Date d) {
		return dateToDateString(getInternalDateByMon(d, -6), DATAFORMAT_STR);
	}

	/**
	 * 得到当前日期D的月底的前/后若干天的时间,<0表示之前，>0表示之后
	 * @param d
	 * @param days
	 * @return
	 */
	public static String getInternalDateByLastDay(Date d, int days) {

		return dateToDateString(getInternalDateByDay(d, days), DATAFORMAT_STR);
	}

	/**
	 * 日期中的年月日相加
	 *  @param field int  需要加的字段  年 月 日
	 * @param amount int 加多少
	 * @return String
	 */
	public static String addDate(int field, int amount) {
		int temp = 0;
		if (field == 1) {
			temp = Calendar.YEAR;
		}
		if (field == 2) {
			temp = Calendar.MONTH;
		}
		if (field == 3) {
			temp = Calendar.DATE;
		}

		String Time = "";
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance(TimeZone.getDefault());
			cal.add(temp, amount);
			Time = sdf.format(cal.getTime());
			return Time;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	/**
	 * 获得系统当前月份的天数
	 * @return
	 */
	public static int getCurentMonthDay() {
		Date date = Calendar.getInstance().getTime();
		return getMonthDay(date);
	}

	/**
	 * 获得指定日期月份的天数
	 * @return
	 */
	public static int getMonthDay(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.getActualMaximum(Calendar.DAY_OF_MONTH);

	}

	/**
	 * 获得指定日期月份的天数  yyyy-mm-dd
	 * @return
	 */
	public static int getMonthDay(String date) {
		Date strDate = getDate(date, DATAFORMAT_STR);
		return getMonthDay(strDate);

	}

	public static String getStringDate(Calendar cal) {

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		return format.format(cal.getTime());
	}

	public static String getStringTimestamp(Timestamp timestamp) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");// 定义格式，不显示毫秒
		return df.format(timestamp);
	}

	public static String getMonthFirstDay(Date day) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(day);
		GregorianCalendar gcLast = (GregorianCalendar) Calendar.getInstance();
		gcLast.setTime(day);
		gcLast.set(Calendar.DAY_OF_MONTH, 1);
		String day_first = df.format(gcLast.getTime());
		return day_first;
	}

	public static String getMonthLastDay(Date day) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(day);
		calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		return format.format(calendar.getTime());
	}
	public static String getMonthFirstDayYMD(Date day) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(day);
		GregorianCalendar gcLast = (GregorianCalendar) Calendar.getInstance();
		gcLast.setTime(day);
		gcLast.set(Calendar.DAY_OF_MONTH, 1);
		String day_first = df.format(gcLast.getTime());
		return day_first;
	}
	
	public static String getMonthLastDayYMD(Date day) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(day);
		calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		return format.format(calendar.getTime());
	}

	/**
	 * 主要是给jfinal使用，数据库只认java.sql.*
	 * 
	 * @param date
	 * @return
	 */
	public static Timestamp getSqlTimestamp(Date date) {
		if (null == date) {
			date = new Date();
		}
		return getSqlTimestamp(date.getTime());
	}

	/**
	 * 主要是给jfinal使用，数据库只认java.sql.*
	 * 
	 * @param time
	 * @return
	 */
	public static Timestamp getSqlTimestamp(long time) {
		return new java.sql.Timestamp(time);
	}

	/**
	 * 获取当前时间
	 * 
	 * @return
	 */
	public static Date getDate() {
		return new Date();
	}

	/**
	 * 获取当前时间的时间戳
	 * 
	 * @return
	 */
	public static long getDateByTime() {
		return new Date().getTime();
	}

	/**
	 * 格式化
	 * 
	 * @param date
	 * @param pattern
	 * @return
	 */
	public static String format(Date date, String pattern) {
		DateFormat format = new SimpleDateFormat(pattern);
		return format.format(date);
	}

	/**
	 * 格式化
	 * 
	 * @param date
	 * @param parsePattern
	 * @param returnPattern
	 * @return
	 */
	public static String format(String date, String parsePattern, String returnPattern) {
		return format(parse(date, parsePattern), returnPattern);
	}

	/**
	 * 解析
	 * 
	 * @param date
	 * @param pattern
	 * @return
	 */
	public static Date parse(String date, String pattern) {
		SimpleDateFormat format = new SimpleDateFormat(pattern);
		try {
			return format.parse(date);
		} catch (ParseException e) {
			log.error("ToolDateTime.parse异常：date值" + date + "，pattern值" + pattern);
			return null;
		}
	}

	/**
	 * 解析
	 * 
	 * @param dateStr
	 * @return
	 */
	public static Date parse(String dateStr) {
		Date date = null;
		try {
			date = DateFormat.getDateTimeInstance().parse(dateStr);
		} catch (ParseException e) {
			log.error("ToolDateTime.parse异常：date值" + date);
			return null;
		}
		return date;
	}

	/**
	 * 两个日期的时间差，返回"X天X小时X分X秒"
	 * 
	 * @param begin
	 * @param end
	 * @return
	 */
	public static String getBetween(Date begin, Date end) {
		long between = (end.getTime() - begin.getTime()) / 1000;// 除以1000是为了转换成秒
		long day = between / (24 * 3600);
		long hour = between % (24 * 3600) / 3600;
		long minute = between % 3600 / 60;
		long second = between % 60 / 60;

		StringBuilder sb = new StringBuilder();
		sb.append(day);
		sb.append("天");
		sb.append(hour);
		sb.append("小时");
		sb.append(minute);
		sb.append("分");
		sb.append(second);
		sb.append("秒");

		return sb.toString();
	}

	/**
	 * 返回两个日期之间隔了多少小时
	 * 
	 * @param date1
	 * @param end
	 * @return
	 */
	public static int getDateHourSpace(Date start, Date end) {
		int hour = (int) ((start.getTime() - end.getTime()) / 3600 / 1000);
		return hour;
	}

	/**
	 * 返回两个日期之间隔了多少天
	 * 
	 * @param date1
	 * @param end
	 * @return
	 */
	public static int getDateDaySpace(Date start, Date end) {
		int day = (int) (getDateHourSpace(start, end) / 24);
		return day;
	}

	/**
	 * 得到某一天是星期几
	 * 
	 * @param type
	 *            0：返回几；其他返回星期几
	 * @param strDate
	 *            日期字符串
	 * @return String 星期几
	 * 
	 */
	@SuppressWarnings("static-access")
	public static String getDateInWeek(Date date, Integer type) {
		String[] weekDays = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" };
		if (type.equals(0)) {
			weekDays = new String[] { "日", "一", "二", "三", "四", "五", "六" };
		}
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int dayIndex = calendar.get(calendar.DAY_OF_WEEK) - calendar.SUNDAY;
		if (dayIndex < 0) {
			dayIndex = 0;
		}
		return weekDays[dayIndex];
	}

	/**
	 * 日期减去多少个小时
	 * 
	 * @param date
	 * @param hourCount
	 *            多少个小时
	 * @return
	 */
	public static Date getDateReduceHour(Date date, long hourCount) {
		long time = date.getTime() - 3600 * 1000 * hourCount;
		Date dateTemp = new Date();
		dateTemp.setTime(time);
		return dateTemp;
	}

	/**
	 * 日期区间分割
	 * 
	 * @param start
	 * @param end
	 * @param splitCount
	 * @return
	 */
	public static List<Date> getDateSplit(Date start, Date end, long splitCount) {
		long startTime = start.getTime();
		long endTime = end.getTime();
		long between = endTime - startTime;

		long count = splitCount - 1l;
		long section = between / count;

		List<Date> list = new ArrayList<Date>();
		list.add(start);

		for (long i = 1l; i < count; i++) {
			long time = startTime + section * i;
			Date date = new Date();
			date.setTime(time);
			list.add(date);
		}

		list.add(end);

		return list;
	}

	/**
	 * 返回两个日期之间隔了多少天，包含开始、结束时间
	 * 
	 * @param start
	 * @param end
	 * @return
	 */
	public static List<String> getDaySpaceDate(Date start, Date end) {
		Calendar fromCalendar = Calendar.getInstance();
		fromCalendar.setTime(start);
		fromCalendar.set(Calendar.HOUR_OF_DAY, 0);
		fromCalendar.set(Calendar.MINUTE, 0);
		fromCalendar.set(Calendar.SECOND, 0);
		fromCalendar.set(Calendar.MILLISECOND, 0);

		Calendar toCalendar = Calendar.getInstance();
		toCalendar.setTime(end);
		toCalendar.set(Calendar.HOUR_OF_DAY, 0);
		toCalendar.set(Calendar.MINUTE, 0);
		toCalendar.set(Calendar.SECOND, 0);
		toCalendar.set(Calendar.MILLISECOND, 0);

		List<String> dateList = new LinkedList<String>();

		long dayCount = (toCalendar.getTime().getTime() - fromCalendar.getTime().getTime()) / (1000 * 60 * 60 * 24);
		if (dayCount < 0) {
			return dateList;
		}

		dateList.add(format(fromCalendar.getTime(), pattern_ymd));

		for (int i = 0; i < dayCount; i++) {
			fromCalendar.add(Calendar.DATE, 1);// 增加一天
			dateList.add(format(fromCalendar.getTime(), pattern_ymd));
		}

		return dateList;
	}

	/**
	 * 获取开始时间
	 * 
	 * @param start
	 * @param end
	 * @return
	 */
	public static Date startDateByDay(Date start, int end) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(start);
		calendar.add(Calendar.DATE, end);// 明天1，昨天-1
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		Date date = calendar.getTime();
		return date;
	}

	/**
	 * 获取结束时间
	 * 
	 * @param start
	 * @param end
	 * @return
	 */
	public static Date endDateByDay(Date start) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(start);
		calendar.set(Calendar.HOUR_OF_DAY, 23);
		calendar.set(Calendar.MINUTE, 59);
		calendar.set(Calendar.SECOND, 59);
		calendar.set(Calendar.MILLISECOND, 999);
		Date date = calendar.getTime();
		return date;
	}

	/**
	 * 获取开始时间
	 * 
	 * @param start
	 * @param end
	 * @return
	 */
	public static Date startDateByHour(Date start, int end) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(start);
		calendar.set(Calendar.MINUTE, end);
		Date date = calendar.getTime();
		return date;
	}

	/**
	 * 获取结束时间
	 * 
	 * @param start
	 * @param end
	 * @return
	 */
	public static Date endDateByHour(Date end) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(end);
		calendar.set(Calendar.SECOND, 59);
		calendar.set(Calendar.MILLISECOND, 999);
		Date date = calendar.getTime();
		return date;
	}

	/**
	 * 根据年份和周得到周的开始和结束日期
	 * 
	 * @param year
	 * @param week
	 * @return
	 */
	public static Map<String, Date> getStartEndDateByWeek(int year, int week) {
		Calendar weekCalendar = new GregorianCalendar();
		weekCalendar.set(Calendar.YEAR, year);
		weekCalendar.set(Calendar.WEEK_OF_YEAR, week);
		weekCalendar.set(Calendar.DAY_OF_WEEK, weekCalendar.getFirstDayOfWeek());

		Date startDate = weekCalendar.getTime(); // 得到周的开始日期

		weekCalendar.roll(Calendar.DAY_OF_WEEK, 6);
		Date endDate = weekCalendar.getTime(); // 得到周的结束日期

		// 开始日期往前推一天
		Calendar startCalendar = Calendar.getInstance();
		startCalendar.setTime(startDate);
		startCalendar.add(Calendar.DATE, 1);// 明天1，昨天-1
		startCalendar.set(Calendar.HOUR_OF_DAY, 0);
		startCalendar.set(Calendar.MINUTE, 0);
		startCalendar.set(Calendar.SECOND, 0);
		startCalendar.set(Calendar.MILLISECOND, 0);
		startDate = startCalendar.getTime();

		// 结束日期往前推一天
		Calendar endCalendar = Calendar.getInstance();
		endCalendar.setTime(endDate);
		endCalendar.add(Calendar.DATE, 1);// 明天1，昨天-1
		endCalendar.set(Calendar.HOUR_OF_DAY, 23);
		endCalendar.set(Calendar.MINUTE, 59);
		endCalendar.set(Calendar.SECOND, 59);
		endCalendar.set(Calendar.MILLISECOND, 999);
		endDate = endCalendar.getTime();

		Map<String, Date> map = new HashMap<String, Date>();
		map.put("start", startDate);
		map.put("end", endDate);
		return map;
	}

	/**
	 * 根据日期月份，获取月份的开始和结束日期
	 * 
	 * @param date
	 * @return
	 */
	public static Map<String, Date> getMonthDate(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR_OF_DAY, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);

		// 得到前一个月的第一天
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMinimum(Calendar.DAY_OF_MONTH));
		Date start = calendar.getTime();

		// 得到前一个月的最后一天
		calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
		Date end = calendar.getTime();

		Map<String, Date> map = new HashMap<String, Date>();
		map.put("start", start);
		map.put("end", end);
		return map;
	}

	/**
	 * 根据日期，获取所在周的开始和结束日期
	 * 
	 * @param date
	 * @return
	 */
	public static Map<String, Date> getWeekDate(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		Map<String, Date> map = getStartEndDateByWeek(c.get(Calendar.YEAR), c.get(Calendar.WEEK_OF_YEAR));
		return map;
	}

	/**
	 * 根据日期，获取上周的开始和结束日期
	 * 
	 * @param date
	 * @return
	 */
	public static Map<String, Date> getBeforeWeekDate(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(startDateByDay(date, -7));
		Map<String, Date> map = getStartEndDateByWeek(c.get(Calendar.YEAR), c.get(Calendar.WEEK_OF_YEAR));
		return map;
	}
	/**
	 * 获取指定日期的前几天 getSpecifiedDayBefore:(这里用一句话描述这个方法的作用). <br/>
	 * 
	 * @param specifiedDay
	 * @param 前多少天
	 *            (time为天数,正整数为减；负数为加)
	 * @return
	 */
	public static String getSpecifiedDayBefore(String specifiedDay, Integer time) {
		Calendar c = Calendar.getInstance();
		Date date = null;
		try {
			date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		c.setTime(date);
		int day = c.get(Calendar.DATE);
		c.set(Calendar.DATE, day - time);

		String dayBefore = new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
		return dayBefore;
	}
	
	
	/**
	 * 获取指定日期的前几天 getSpecifiedDayBefore:(这里用一句话描述这个方法的作用). <br/>
	 * 
	 * @param specifiedDay
	 * @param 前多少天
	 *            (time为天数,正整数为减；负数为加)
	 * @return
	 */
	public static Date getSpecifiedDayBefore(Date date, Integer time) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.DATE, c.get(Calendar.DATE) - time);
		return c.getTime();
	}
	
	//
	public static String getlasttowMonth(String date2 , Integer time){
		//获取当前的时间
		Calendar c=Calendar.getInstance();
		//获取今天是本月的第几天
		int day=c.get(Calendar.DAY_OF_MONTH);
		//月份减去2，记住，加2的话参数为2，减去2的话相当于加-2
		c.add(Calendar.MONTH, -2);//执行add后现在已经变成了2015-05-07
		//减去天数，5.1=5.7-6
		c.add(Calendar.DAY_OF_MONTH, 1-day);
		int day1 = c.get(Calendar.DATE);
		c.set(Calendar.DATE, day1 - time);
		//将Calendar转换为date
		Date date=c.getTime();
		String dateStr=new SimpleDateFormat("yyyy-MM-dd").format(date);
		
		return dateStr;
	}
	
	/**
	 * 获取指定日期的前一天
	 * 
	 * @param specifiedDay
	 * @return
	 */
	public static String getSpecifiedDayBefore(String specifiedDay) {
		Calendar c = Calendar.getInstance();
		Date date = null;
		try {
			date = new SimpleDateFormat("yy-MM-dd").parse(specifiedDay);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		c.setTime(date);
		int day = c.get(Calendar.DATE);
		c.set(Calendar.DATE, day - 1);

		String dayBefore = new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
		return dayBefore;
	}

	/**
	 * 方法描述：取得两个日期之间的日期List,包含两端日期
	 * 
	 * @author rongqiang.pu
	 * @time Jun 24, 2011 10:25:04 AM
	 * @param startDay
	 *            开始时间
	 * @param endDay
	 *            结束时间
	 *            开始和结束时间不能是同一天
	 */
	public static List<String> printDay(Date startDate, Date endDate) {
		Calendar startDay = Calendar.getInstance();
		startDay.setTime(getFormatDate(startDate, pattern_ymd));
		Calendar endDay = Calendar.getInstance();
		endDay.setTime(getFormatDate(endDate, pattern_ymd));
		List<String> list = new ArrayList<String>();
		// 给出的日期开始日比终了日大则不执行打印
		if (startDay.compareTo(endDay) > 0) {
			return list;
		}
		if(startDay.compareTo(endDay)==0){
			list.add(new SimpleDateFormat("yyyy-MM-dd").format(startDay.getTime()));
			return list;
		}
		list.add(new SimpleDateFormat("yyyy-MM-dd").format(startDay.getTime()));
		// 现在打印中的日期
		Calendar currentPrintDay = startDay;
		while (true) {
			// 日期加一
			currentPrintDay.add(Calendar.DATE, 1);
			// 日期加一后判断是否达到终了日，达到则终止打印
			if (currentPrintDay.compareTo(endDay) == 0) {
				break;
			}
			list.add(new SimpleDateFormat("yyyy-MM-dd").format(currentPrintDay.getTime()));
		}
		list.add(new SimpleDateFormat("yyyy-MM-dd").format(endDay.getTime()));
		return list;
	}

	
	public static List<String> printMonths(Date startDate, Date endDate) {
		Calendar startDay = Calendar.getInstance();
		startDay.setTime(getFormatDate(startDate, pattern_ymd));
		Calendar endDay = Calendar.getInstance();
		endDay.setTime(getFormatDate(endDate, pattern_ymd));
		List<String> list = new ArrayList<String>();
		// 给出的日期开始日比终了日大则不执行打印
		if (startDay.compareTo(endDay) > 0) {
			return list;
		}
		if(startDay.compareTo(endDay)==0){
			list.add(new SimpleDateFormat("yyyy-MM").format(startDay.getTime()));
			return list;
		}
		list.add(new SimpleDateFormat("yyyy-MM").format(startDay.getTime()));
		// 现在打印中的日期
		Calendar currentPrintDay = startDay;
		while (true) {
			// 日期加一
			currentPrintDay.add(Calendar.MONTH, 1);
			// 日期加一后判断是否达到终了日，达到则终止打印
			if (currentPrintDay.compareTo(endDay) == 0) {
				break;
			}
			list.add(new SimpleDateFormat("yyyy-MM").format(currentPrintDay.getTime()));
		}
		list.add(new SimpleDateFormat("yyyy-MM").format(endDay.getTime()));
		return list;
	}

	/**
	 * 格式化日期
	 * 
	 * @return
	 */
	public static Date getFormatDate(Date date, String pattern) {
		try {
			SimpleDateFormat formater = new SimpleDateFormat(pattern);
			String result = formater.format(date);
			Date d = formater.parse(result);
			return d;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 取得月已经过的天数
	 * 
	 * @param date
	 * @return
	 */
	public static int getPassDayOfMonth(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 取得月天数
	 * 
	 * @param date
	 * @return
	 */
	public static int getDayOfMonth(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.getActualMaximum(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 取得月第一天
	 * 
	 * @param date
	 * @return
	 */
	public static Date getFirstDateOfMonth(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
		return c.getTime();
	}

	/**
	 * 取得月最后一天
	 * 
	 * @param date
	 * @return
	 */
	public static Date getLastDateOfMonth(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
		return c.getTime();
	}

	/**
	 * 取得季度第一天
	 * 
	 * @param date
	 * @return
	 */
	public static Date getFirstDateOfSeason(Date date) {
		return getFirstDateOfMonth(getSeasonDate(date)[0]);
	}

	/**
	 * 取得季度最后一天
	 * 
	 * @param date
	 * @return
	 */
	public static Date getLastDateOfSeason(Date date) {
		return getLastDateOfMonth(getSeasonDate(date)[2]);
	}

	/**
	 * 取得季度天数
	 * 
	 * @param date
	 * @return
	 */
	public static int getDayOfSeason(Date date) {
		int day = 0;
		Date[] seasonDates = getSeasonDate(date);
		for (Date date2 : seasonDates) {
			day += getDayOfMonth(date2);
		}
		return day;
	}

	/**
	 * 取得季度剩余天数
	 * 
	 * @param date
	 * @return
	 */
	public static int getRemainDayOfSeason(Date date) {
		return getDayOfSeason(date) - getPassDayOfSeason(date);
	}

	/**
	 * 取得季度已过天数
	 * 
	 * @param date
	 * @return
	 */
	public static int getPassDayOfSeason(Date date) {
		int day = 0;
		Date[] seasonDates = getSeasonDate(date);
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		int month = c.get(Calendar.MONTH);
		if (month == Calendar.JANUARY || month == Calendar.APRIL || month == Calendar.JULY || month == Calendar.OCTOBER) {// 季度第一个月
			day = getPassDayOfMonth(seasonDates[0]);
		} else if (month == Calendar.FEBRUARY || month == Calendar.MAY || month == Calendar.AUGUST || month == Calendar.NOVEMBER) {// 季度第二个月
			day = getDayOfMonth(seasonDates[0]) + getPassDayOfMonth(seasonDates[1]);
		} else if (month == Calendar.MARCH || month == Calendar.JUNE || month == Calendar.SEPTEMBER || month == Calendar.DECEMBER) {// 季度第三个月
			day = getDayOfMonth(seasonDates[0]) + getDayOfMonth(seasonDates[1]) + getPassDayOfMonth(seasonDates[2]);
		}
		return day;
	}

	/**
	 * 取得季度月
	 * 
	 * @param date
	 * @return
	 */
	public static Date[] getSeasonDate(Date date) {
		Date[] season = new Date[3];
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		int nSeason = getSeason(date);
		if (nSeason == 1) {// 第一季度
			c.set(Calendar.MONTH, Calendar.JANUARY);
			season[0] = c.getTime();
			c.set(Calendar.MONTH, Calendar.FEBRUARY);
			season[1] = c.getTime();
			c.set(Calendar.MONTH, Calendar.MARCH);
			season[2] = c.getTime();
		} else if (nSeason == 2) {// 第二季度
			c.set(Calendar.MONTH, Calendar.APRIL);
			season[0] = c.getTime();
			c.set(Calendar.MONTH, Calendar.MAY);
			season[1] = c.getTime();
			c.set(Calendar.MONTH, Calendar.JUNE);
			season[2] = c.getTime();
		} else if (nSeason == 3) {// 第三季度
			c.set(Calendar.MONTH, Calendar.JULY);
			season[0] = c.getTime();
			c.set(Calendar.MONTH, Calendar.AUGUST);
			season[1] = c.getTime();
			c.set(Calendar.MONTH, Calendar.SEPTEMBER);
			season[2] = c.getTime();
		} else if (nSeason == 4) {// 第四季度
			c.set(Calendar.MONTH, Calendar.OCTOBER);
			season[0] = c.getTime();
			c.set(Calendar.MONTH, Calendar.NOVEMBER);
			season[1] = c.getTime();
			c.set(Calendar.MONTH, Calendar.DECEMBER);
			season[2] = c.getTime();
		}
		return season;
	}

	/**
	 * 
	 * 1 第一季度 2 第二季度 3 第三季度 4 第四季度
	 * 
	 * @param date
	 * @return
	 */
	public static int getSeason(Date date) {
		int season = 0;
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		int month = c.get(Calendar.MONTH);
		switch (month) {
		case Calendar.JANUARY:
		case Calendar.FEBRUARY:
		case Calendar.MARCH:
			season = 1;
			break;
		case Calendar.APRIL:
		case Calendar.MAY:
		case Calendar.JUNE:
			season = 2;
			break;
		case Calendar.JULY:
		case Calendar.AUGUST:
		case Calendar.SEPTEMBER:
			season = 3;
			break;
		case Calendar.OCTOBER:
		case Calendar.NOVEMBER:
		case Calendar.DECEMBER:
			season = 4;
			break;
		default:
			break;
		}
		return season;
	}

	/**
	 * 当前年的开始时间，即2015-01-01 00:00:00
	 *
	 * @return
	 */
	public static Date getCurrentYearStartTime() {
		DateFormat format = new SimpleDateFormat(pattern_ymd);
		Calendar c = Calendar.getInstance();
		Date now = null;
		try {
			c.set(Calendar.MONTH, 0);
			c.set(Calendar.DATE, 1);
			now = format.parse(format.format(c.getTime()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return now;
	}
	/**
	 * 获取年的第一天
	 */
	public static Date getCurrentYearFristTime() {
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar c = Calendar.getInstance();
        try{
        	c.set(Calendar.DAY_OF_YEAR, 1);
        }catch(Exception e){
        	e.printStackTrace();
        }
        return c.getTime();
	}
	/**
	 * 获取年的最后一天
	 */
	public static Date getCurrentYearEndTime() {
			Date date = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy");//可以方
			String years = dateFormat.format(date);
			Date d=null;
			try {
				d = new SimpleDateFormat("yyyy-MM-dd").parse(years+"-12-31");
			} catch (ParseException e) {
				e.printStackTrace();
			}
			return  d ;
	}
	/**
	 * 判断传入日期是否是今天
	 * 
	 * @param date1
	 *            ：yyyy-MM-hh
	 * @return
	 */
	public static boolean isToday(String date) {
		String today = format(new Date(),pattern_ymd);
		if (date.equals(today))
			return true;
		else
			return false;
	}
	
	/**
	 * 获取前两个月的第一天
	 * @param date2 
	 * @param args
	 * @throws ParseException
	 */
	
	public static Date getlastMonthFirstDay(Date date2){
		//获取当前的时间
				Calendar c=Calendar.getInstance();
				//获取今天是本月的第几天
				int day=c.get(Calendar.DAY_OF_MONTH);
				//月份减去2，记住，加2的话参数为2，减去2的话相当于加-2
				c.add(Calendar.MONTH, -2);//执行add后现在已经变成了2015-05-07
				//减去天数，5.1=5.7-6
			//	c.add(Calendar.DAY_OF_MONTH, -6);
				c.add(Calendar.DAY_OF_MONTH, 1-day);
				//将Calendar转换为date
				Date date=c.getTime();
				String dateStr=new SimpleDateFormat("yyyy-MM-dd").format(date);
				System.out.println(dateStr);
				return date;
		
	}
	
	public static void main(String[] args) throws ParseException {
		// System.out.println(format("2013-07-01", pattern_ymd, "MM-dd"));

		// Date start = parse("2013-07-01 01:00:00", pattern_ymdtime);
		// Date end = parse("2013-07-01 12:00:00", pattern_ymdtime);
		// long splitCount = 12l;
		// List<Date> list = getDateSplit(start, end, splitCount);
		// for (Date date : list) {
		// System.out.println(format(date, pattern_ymdtime));
		// }

		// Date start = parse("2013-07-01 01:00:00", pattern_ymdtime);
		// Date end = parse("2013-07-05 12:00:00", pattern_ymdtime);
		// List<String> list = getDaySpaceDate(start, end);
		// for (String str : list) {
		// System.out.println(str);
		// }

		// Date start = parse("2013-07-01 01:00:00", pattern_ymdtime);
		// Date end = endDate(start, 7);
		// System.out.println(format(end, pattern_ymdtime));

		// Date endDate = ToolDateTime.endDate(new Date());
		// Date startDate = ToolDateTime.startDate(endDate, -14);
		// System.out.println(format(startDate, pattern_ymdtimeMillisecond));
		// System.out.println(format(endDate, pattern_ymdtimeMillisecond));

		// Date endDate = ToolDateTime.endDateByHour(new Date());
		// Date startDate = ToolDateTime.startDateByHour(endDate, -24);
		//
		// System.out.println(format(startDate, pattern_ymdtimeMillisecond));
		// System.out.println(format(endDate, pattern_ymdtimeMillisecond));
//		System.out.println(getSpecifiedDayBefore("2015-03-21", 0));
		// System.out.println(getCurrentYearStartTime());
	//	 String bdate = "2015-02-26";
	//	 String edate = "2015-03-26";
	//	 System.out.println(printDay(parse(bdate,pattern_ymd), parse(edate,pattern_ymd)));
//		 System.out.print(ToolDateTime.getFirstDateOfMonth(new Date()));
	//	 System.out.print(ToolDateTime.getFirstDateOfSeason(new Date()));
	//	 System.out.print(ToolDateTime.getDaySpaceDate(parse(bdate,pattern_ymd), parse(edate,pattern_ymd)));
		// System.out.println(new SimpleDateFormat("yyyy-MM-dd").format(getInternalDateByDay(new Date(),5)));
		 //System.out.println(getFormatDate(new Date(), "yyyy-MM-dd"));\
		System.out.println(compareDateStr( "2016-11-16 16:26:00","2016-11-16 16:25:00"));
	}

	

	/**
	 * 根据日期，获取下周的开始和结束日期
	 * 
	 * @param date
	 * @return
	 */
	public static Map<String, Date> getNextWeekDate(Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(startDateByDay(date, +7));
		Map<String, Date> map = getStartEndDateByWeek(c.get(Calendar.YEAR), c.get(Calendar.WEEK_OF_YEAR));
		return map;
	}
	
	
	public static String getStringTimestamp(Timestamp timestamp,String format) {
		SimpleDateFormat df = new SimpleDateFormat(format);// 定义格式，不显示毫秒
		return df.format(timestamp);
	}
	
	/**
	 * 返回两个日期之间隔了多少分钟
	 * 
	 * @param start
	 * @param end
	 * @return
	 */
	public static int getDateMinuteSpace(Date start, Date end) {
		int hour = (int) ((end.getTime() - start.getTime()) / (60 * 1000));
		return hour;
	}
	
	/***
	 * 
	 * @param time
	 * @return
	 */
	public static String format (Time time) {
		SimpleDateFormat simple = new SimpleDateFormat("HH:mm");
         return   simple.format(time);
	}
	
	
	/**
	 * 比较俩个时间字符串大小，
	 * 返回true ,第一个参数大，false  第二个参数大。
	 */
	public static boolean compareTwoTime(String time1,String time2) {
        SimpleDateFormat simple = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        long flag = 0;
        Date date1 = null;
        Date date2 = null;
        try{
				date1 = simple.parse(time1);
			    date2 = simple.parse(time2);
        	} catch (Exception e) {
        	System.out.println("转换异常");
        }
		 flag = date1.getTime()-date2.getTime();
		return flag >0 ? true : false;
	}
	
}
