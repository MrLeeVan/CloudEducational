
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

/***
 * 根据经纬度，计算2个点之间的距离。
 * @author dufuzhong
 * @date 2017年3月21日 下午8:47:10
 */
public class ToolLagLng {
	
/*	public static void main(String[] args) {
		// / 根据经纬度，计算2个点之间的距离。
		// 39.94607,116.32793 31.24063,121.42575
		double distance = distance(39.90403, 116.407526,
							40.03040073254819, 116.36894863292693);
		System.out.println(distance);
	}*/

	private static double haverSin(double theta) {
		double v = Math.sin(theta / 2);
		return v * v;
	}

	static double EARTH_RADIUS = 6371000;// m 地球半径 平均值，米

	// / <summary>
	// / 给定的经度1，纬度1；经度2，纬度2. 计算2个经纬度之间的距离。
	// / </summary>
	// / <param name="lat1">经度1</param>
	// / <param name="lon1">纬度1</param>
	// / <param name="lat2">经度2</param>
	// / <param name="lon2">纬度2</param>
	// / <returns>距离（米）</returns>
	public static double distance(double lat1, double lon1, double lat2, double lon2) {
		// 用haversine公式计算球面两点间的距离。
		// 经纬度转换成弧度
		lat1 = convertDegreesToRadians(lat1);
		lon1 = convertDegreesToRadians(lon1);
		lat2 = convertDegreesToRadians(lat2);
		lon2 = convertDegreesToRadians(lon2);
		// 差值
		double vLon = Math.abs(lon1 - lon2);
		double vLat = Math.abs(lat1 - lat2);
		// h is the great circle distance in radians, great
		// circle就是一个球体上的切面，它的圆心即是球心的一个周长最大的圆。
		double h = haverSin(vLat) + Math.cos(lat1) * Math.cos(lat2)
				* haverSin(vLon);
		double distance = 2 * EARTH_RADIUS * Math.asin(Math.sqrt(h));
		return distance;
	}

	// / <summary>
	// / 将角度换算为弧度。
	// / </summary>
	// / <param name="degrees">角度</param>
	// / <returns>弧度</returns>
	private static double convertDegreesToRadians(double degrees) {
		return degrees * Math.PI / 180;
	}

}
