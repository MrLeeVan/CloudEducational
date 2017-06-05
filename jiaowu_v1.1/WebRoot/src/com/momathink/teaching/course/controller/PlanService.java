
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

package com.momathink.teaching.course.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.course.service.CourseplanService;
import com.momathink.teaching.teacher.model.Teachergrade;

public class PlanService {
	public static PlanService mi = new PlanService();
	
	private CourseplanService courseplanService = new CourseplanService();
	
	/**今日课表 **/
	public void todayList(SplitPage splitPage, String stuid){
		Map<String, String> queryParam = splitPage.getQueryParam();
		queryParam.put("stuid", stuid);
		queryParam.put("confirm", "1");
		queryParam.put("startTime", 
				ToolDateTime.format(
						ToolDateTime.getInternalDateByDay(ToolDateTime.getDate(), -1),
						ToolDateTime.pattern_ymd) + " 23:59:00");
		queryParam.put("endTime", 
				ToolDateTime.format(
						ToolDateTime.getDate(),
						ToolDateTime.pattern_ymd) + " 23:59:00");
		courseplanService.queryUserMessage(splitPage);
	}
	
	/**课表 **/
	public Map<String, Object> list(SplitPage splitPage){
		Map<String,Object> ret = new HashMap<String, Object>();
		try {
			courseplanService.queryUserMessage(splitPage);
			Page<?> page = splitPage.getPage();
			@SuppressWarnings("unchecked")
			List<Record> dbList = (List<Record>) page.getList();
			Map<String, List<Record>> map = new LinkedHashMap<>();
			
			for (Record r : dbList) {
				String timeKey = ToolDateTime.format(r.getDate("courseplan_time"), ToolDateTime.pattern_ymd);
				List<Record> timeList = map.get(timeKey);
				if(timeList == null){
					timeList = new ArrayList<Record>();
					map.put(timeKey, timeList);
				}
				timeList.add(r);
			}
			ret.put("data", map);
			ret.put("error", 0);
		} catch (Exception e) {
			e.printStackTrace();
			ret.put("error", 2);
		}
		ret.put("pageNumber", splitPage.getPageNumber());
		ret.put("pageSize", splitPage.getPageSize());
		return ret;
	}

	/**确认课程安排或调剂课程*/
	public Map<String, Object> affirmUpdate(String planid, String type,String cancelReason, Integer sysuserId) {
		Map<String,Object> ret = new HashMap<String, Object>();
		ret.put("error", 1);
		try {
			CoursePlan courseplan = CoursePlan.coursePlan.findById(planid);
			ret.put("planid", planid);
			
			if(courseplan !=null){
				courseplan.set("confirm", type.equals("confirm")?1:2);//0确认中, 1确认, 2取消(或调剂)
				courseplan.set("cancelReason", type.equals("confirm")?null:cancelReason);
				courseplan.set("recordTime", new Date());
				if(type.equals("confirm")){
					courseplan.update();
				}else{
					courseplan.set("del_msg", cancelReason);
					courseplan.set("UPDATE_TIME", new Date());
					courseplan.set("deluserid", sysuserId);
					courseplan.update();
					// 删除teachergrade中对应的记录
					Teachergrade.teachergrade.deleteByCoursePlanId(Integer.parseInt(planid));
					// 将要删除的排课记录添加到courseplan_back表中
					String copySql = "insert into courseplan_back SELECT * from  courseplan where ID=? ";// 将查询语句更新到courseplan_back
					Db.update(copySql, planid);
					// 删除courseplan表中的数据
					String deleteSql = "delete from  courseplan where ID=? ";
					Db.update(deleteSql, planid);// 删除班课
				}
			}
			ret.put("error", 0);
		} catch (Exception e) {
			e.printStackTrace();
			ret.put("error", 2);
		}
		return ret;
	}
	
}
