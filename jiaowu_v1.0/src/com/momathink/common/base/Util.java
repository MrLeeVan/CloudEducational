
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

package com.momathink.common.base;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Properties;

public class Util {
	private static Properties props = new Properties();
	static InputStream ips = Util.class.getClassLoader().getResourceAsStream("smsconfig.properties");

	/**
	 * 数组转字符串
	 * 
	 * @param arrs
	 * @return
	 */
	public static String printArray(String[] arrs) {
		StringBuffer str = new StringBuffer("");
		if(arrs.length>0){
			for (String arr : arrs) {
				str.append(arr+"|");
			}
			str.deleteCharAt(str.length()-1);
		}
		return str.toString();
	}

	public static String getTomorrowDate() {
		Date date = new Date();// 取时间
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, 1);// 把日期往后增加一天.整数往后推,负数往前移动
		date = calendar.getTime(); // 这个时间就是日期往后推一天的结果
		SimpleDateFormat formatter = new SimpleDateFormat("MM月dd日");
		String dateString = formatter.format(date);
		return dateString;
	}

	public static String getPropVal(String key) {
		try {
			props.load(ips);
		} catch (IOException e1) {
			e1.printStackTrace();
			System.out.println("加载配置文件错误！");
		}
		String value = props.getProperty(key);
		return value;
	}

	public static void setPropVal(String key, String value) {
		try {
			props.load(ips);
			props.setProperty(key, value);
		} catch (IOException e1) {
			e1.printStackTrace();
			System.out.println("加载配置文件错误！");
		}
	}

	public static void main(String[] args) {
		System.out.println(getTomorrowDate());
	}
}
