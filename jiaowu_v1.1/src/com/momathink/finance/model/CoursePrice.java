
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

package com.momathink.finance.model;

import java.util.List;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.teaching.course.model.CoursePlan;

/**订单下购买的课程*/
@SuppressWarnings("serial")
@Table(tableName = "crm_courseprice")
public class CoursePrice extends BaseModel<CoursePrice> {

	public static final CoursePrice dao = new CoursePrice().dao();

	public List<CoursePrice> findCoursePriceByStudentId(String studentId) {
		String sql = "SELECT p.*,c.COURSE_NAME FROM " + "(SELECT cc.id,cc.subjectid,cc.courseid,SUM(cc.classhour) ks  "
				+ "FROM crm_courseprice cc left join crm_courseorder coo on coo.id = cc.orderid and coo.delflag=0  WHERE cc.studentid=? GROUP BY cc.subjectid,cc.courseid) p " + "LEFT JOIN course c ON p.courseid=c.Id";
		return StringUtils.isEmpty(studentId) ? null : dao.find(sql, Integer.parseInt(studentId));
	}

	public List<CoursePrice> findByOrderId(String orderId) {
		String sql = "SELECT cp.*,c.COURSE_NAME FROM crm_courseprice cp "
				+ " LEFT JOIN course c ON cp.courseid=c.Id WHERE cp.orderid=?";
		return StringUtils.isEmpty(orderId) ? null : dao.find(sql, Integer.parseInt(orderId));
	}

	public float getRemainHour(String studentId, String courseId) {
		// 查询总节数和已经排课的节数
		Record info = dao.getCoursePirce(studentId, courseId);
		Float _ygks = info.getBigDecimal("ks").floatValue();
		float ygks = _ygks == null ? 0 : _ygks.floatValue();
		float ypks = CoursePlan.coursePlan.getUseClasshour(studentId,courseId);
		return ygks - ypks;
	}

	public Record getCoursePirce(String studentId, String courseId) {
		if (StringUtils.isEmpty(studentId) || StringUtils.isEmpty(courseId)) {
			return null;
		} else {
			String sql = "SELECT sum(cp.classhour) ks FROM crm_courseprice cp WHERE cp.studentid=? AND cp.courseid=?";
			Record record = Db.findFirst(sql, Integer.parseInt(studentId), Integer.parseInt(courseId));
			return record;
		}
	}

	/**
	 * 获取订单购买的课程
	 * @param orderId
	 * @param courseId
	 * @return
	 */
	public CoursePrice findByOrderIdAndCourseId(Integer orderId, Integer courseId) {
		String sql = "SELECT cp.*,c.COURSE_NAME FROM crm_courseprice cp LEFT JOIN course c ON cp.courseid=c.Id WHERE cp.orderid=? and cp.courseid=?";
		return dao.findFirst(sql, orderId,courseId);
	}

	public void deleteByOrderId(Integer orderId) {
		String sql = "DELETE FROM crm_courseprice WHERE crm_courseprice.orderid=?";
		Db.update(sql, orderId);
	}

	/**
	 * 获取订单的课程信息
	 * @param courseOrderId
	 * @return
	 */
	public String getCourseids(Integer courseOrderId) {
		String sql="select GROUP_CONCAT( DISTINCT courseid SEPARATOR '|') courseids from crm_courseprice cp left join course c on cp.courseid = c.id WHERE cp.orderid=?  LIMIT 0,1";
		String courseids = Db.queryStr(sql, courseOrderId);
		return courseids==null ? "" : courseids;
	}

	
	
	
	
}
