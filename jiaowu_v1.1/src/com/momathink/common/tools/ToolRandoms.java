
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

import java.util.Random;

import org.apache.log4j.Logger;

/**
 * 随机数类
 */
public class ToolRandoms {

	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(ToolRandoms.class);

	private static final Random random = new Random();

	// 定义验证码字符.去除了O、I、l、、等容易混淆的字母
	public static final char authCode[] = { 
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'G', 'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 
		'a', 'c', 'd', 'e', 'f', 'g', 'h', 'k', 'm', 'n', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 
		'3', '4', '5', '7', '8' };
	
	public static final int length = authCode.length;
	
	/**
	 * 生成验证码
	 * @return
	 */
	public static char getAuthCodeChar() {
		return authCode[number(0, length)];
	}
	
	/**
	 * 生成验证码
	 * @return
	 */
	public static String getAuthCode(int length) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < length; i++) {
			sb.append(authCode[number(0, length)]);
		}
		return sb.toString();
	}
	
	/**
	 * 产生两个数之间的随机数
	 * @param min 小数
	 * @param max 比min大的数
	 * @return int 随机数字
	 */
	public static int number(int min, int max) {
		return min + random.nextInt(max - min);
	}

	/**
	 * 产生0--number的随机数,不包括num
	 * @param number   数字
	 * @return int 随机数字
	 */
	public static int number(int number) {
		return random.nextInt(number);
	}

	/**
	 * 生成RGB随机数
	 * @return
	 */
	public static int[] getRandomRgb() {
		int[] rgb = new int[3];
		for (int i = 0; i < 3; i++) {
			rgb[i] = random.nextInt(255);
		}
		return rgb;
	}
	
}
