
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

package com.momathink.teaching.teacher.model;

import java.util.List;

import com.jfinal.kit.StrKit;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
/**
 * 2015年7月30日prq
 * @author prq
 *
 */
@Table(tableName="jw_setpoint")
public class SetPoint extends BaseModel<SetPoint> {

	private static final long serialVersionUID = -2034227024451362756L;
	
	public static final SetPoint dao = new SetPoint();
	
	/**
	 * 根据学生id 获取该学生所有节点
	 * @param stuid
	 * @return
	 */
	public List<SetPoint> getPointsById(String stuid,String tchid){
		String sql = "select point.*,stu.real_name studentName,tch.real_name teacherName from jw_setpoint point left join account stu on stu.Id = point.studentid "
				+ " left join account tch on tch.Id = point.teacherid where 1=1 ";
		if(StrKit.notBlank(stuid)){
			sql+= " and point.studentid = " + stuid;
		}
		if(StrKit.notBlank(tchid)){
			sql+= " and point.teacherid = " + tchid;
		}
			sql += " order by point.appointment desc";
		List<SetPoint> list = dao.find(sql);
		return list;
	}

	/**
	 * 获取填写报告的基本信息
	 * @param pointid
	 * @return
	 */
	public SetPoint getFillReportBaseMsg(String pointid) {
		String sql = "select point.*,stu.real_name studentName,stu.SCHOOL,stu.GRADE_NAME,tch.real_name teacherName from jw_setpoint point left join account stu on stu.Id = point.studentid "
				+ " left join account tch on tch.Id = point.teacherid where point.id = ? ";
		return dao.findFirst(sql,pointid);
	}
	
	public Long getCountsForTeacherUnSubmit(Integer tchid){
		Long counts = 0L;
		String sql = "select count(*) counts from jw_setpoint where teacherid= ? and submissiontime is null and appointment = date_format(now(),'%Y-%m-%d') ";
		SetPoint point = SetPoint.dao.findFirst(sql, tchid);
		if(point!=null)
			counts = point.getLong("counts");
		return counts;
	}

	/**
	 * 
	 * @param pointId
	 * @return
	 */
	public SetPoint findPointAndStudentName(Integer pointId) {
		String sql = "select point.*,stu.Id stuid,stu.real_name,sum(IFNULL(co.classhour,0)) allhour from jw_setpoint point left join account stu on stu.Id=point.studentid "
				+ " left join crm_courseorder co on co.studentid=stu.id where co.delflag=0 and co.status!=0 and point.id= ? ";
		return dao.findFirst(sql,pointId);
	}
	/**
	 * 找到学生下次的周报节点时间id
	 * @param int1
	 * @return
	 */
	public SetPoint findByStudentId(Integer studentid,Integer pointid) {
		String sql = "select id from jw_setpoint where studentid = "+studentid+" and id > "+pointid+" order by id ";
		List<SetPoint> splist = SetPoint.dao.find(sql);
		if(splist.size()>0){
			return splist.get(0);
		}else{
			return null;
		}
	}

}
