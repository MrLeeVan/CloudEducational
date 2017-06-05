
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

package com.momathink.sys.system.model;

import java.util.List;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.teaching.course.model.CoursePlan;

@Table(tableName="time_rank")
public class TimeRank extends BaseModel<TimeRank>{
	private static final long serialVersionUID = -7516175055292633955L;
	public static final TimeRank dao=new TimeRank();
	/**
	 * 查询所有时间段
	 */
	public List<TimeRank> getTimeRank() {
		String sql = "SELECT t.* FROM time_rank t where t.state=0 order by t.rank_name";
		List<TimeRank> list = TimeRank.dao.find(sql);
		return list;
	}
	
	
	public List<TimeRank> getAddPlanTimeRank(){
		String sql = "select tr.*, 0 as code from time_rank tr where tr.state=0 order by tr.rank_name";
		return dao.find(sql);
	}
	
	/**
	 * 添加时间段
	 */
	public void addTimeRank(String rankName,String rankType,String class_hour) {
		new TimeRank().set("RANK_NAME", rankName).set("RANK_TYPE", rankType).set("class_hour", class_hour).save();
	}
	/**
	 * 更新时间段
	 */
	public void updateTimeRank(int id,String rankName,String rankType,String class_hour) {
		TimeRank.dao.findById(id).set("RANK_NAME", rankName).set("RANK_TYPE", rankType).set("class_hour", class_hour).update();
	}
	
	/**
	 * 根据学生ID查询已经使用时段
	 * @param studentId
	 * @param courseTime
	 * @return
	 */
	public List<Record> queryUsrTimeRank(String studentId, String courseTime) {
		return Db.find("SELECT cp.Id planId,cp.TIMERANK_ID rankId,tr.RANK_NAME rankName,cp.PLAN_TYPE planType FROM courseplan cp LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id WHERE cp.STUDENT_ID="+studentId+" AND cp.COURSE_TIME ='"+courseTime+"'");
	}
	/**
	 * 根据小班ID查询已经使用的时段
	 * @param classId
	 * @param courseTime
	 * @return
	 */
	public List<Record> queryUsrTimeRankByClassId(String classId, String courseTime) {
		return Db.find("SELECT cp.Id planId,cp.TIMERANK_ID rankId,tr.RANK_NAME rankName,cp.PLAN_TYPE planType FROM courseplan cp LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id WHERE cp.STATE=1 AND cp.class_id="+classId+" AND cp.COURSE_TIME ='"+courseTime+"'");
	}
	public List<TimeRank> getAllTimeRank() {
		String sql = "SELECT t.* FROM time_rank t order by t.RANK_NAME";
		List<TimeRank> list = TimeRank.dao.find(sql);
		return list;
	}
	
	/**
	 * 获取最大排序数
	 * @return
	 */
	public int getNewMaxIndex() {
		Record record = Db.findFirst("SELECT MAX(RANK_TYPE) max_index FROM time_rank");
		return record.getInt("max_index") == null?1:record.getInt("max_index")+1;
	}
	
	/**
	 * 获取所有时段
	 * @return
	 */
	public List<TimeRank> getTimeRanks(){
		String sql = "select * from time_rank order by RANK_NAME ";
		List<TimeRank> tr = TimeRank.dao.find(sql);
		return  tr;
	}
	/**
	 * 获取时段的课时数
	 * @param rankId
	 * @return
	 */
	public float queryClassHour(String rankId) {
		if(StringUtils.isEmpty(rankId))
			return 0;
		else
			return dao.findById(Integer.parseInt(rankId)).getBigDecimal("class_hour").floatValue();
	}
	
	
	public String getTimeRankNameById(String timeId) {
		if(StringUtils.isEmpty(timeId)){
			return null;
		}else{
			TimeRank t = dao.findById(Integer.parseInt(timeId));
			return t.getStr("rank_name");
		}
	}
	
	public StringBuffer getTimeIdsByTime(String starthour, String startmin, String endhour, String endmin) {
		StringBuffer timeids = new StringBuffer();
		int beginTime = Integer.parseInt(starthour+startmin);
		int endTime = Integer.parseInt(endhour+endmin);
		List<TimeRank> list = dao.getAllTimeRank();
		for(TimeRank tr : list){
			String name = tr.get("RANK_NAME");
			int shour = Integer.parseInt((name.split("-"))[0].replace(":",""));
			int ehour = Integer.parseInt((name.split("-"))[1].replace(":",""));
			if((shour>=beginTime&&shour<=endTime)||(ehour>=beginTime&&ehour<=endTime)){
				timeids.append(",").append(tr.getInt("Id"));	
			}
		}
		timeids.replace(0, 1, "");
		return timeids;
	}
	

	/**
	 * 不在ids里面的时段
	 * @param ids
	 * @return
	 */
	public List<TimeRank> getTimeRanksIdNotIn(String ids) {
		StringBuffer sb = new StringBuffer();
		sb.append("select Id from time_rank where 1=1 ");
		if(!StringUtils.isEmpty(ids)){
			sb.append(" and Id not in (").append(ids).append(")");
		}
		return dao.find(sb.toString());
	}
	
	/**
	 * 取出大于rankname的时段
	 * @param rankname 08:00
	 * @return
	 */
	public List<TimeRank> getTimeRanksDesc(String rankname){
		String sql = "SELECT * FROM time_rank where rank_name>= ? ORDER BY time_rank.RANK_NAME ASC";
		return dao.find(sql,rankname);
	}

	/**
	 * 根据时段名称查询
	 * @param rankname
	 * @return
	 */
	public List<TimeRank> findByRankname(String rankname) {
		String sql = "SELECT * FROM time_rank where rank_name = ? ";
		return dao.find(sql,rankname);
	}

	/**
	 * 获取时段课时
	 * @param timeRankId
	 * @return
	 */
	public double getHourById(Integer timeRankId) {
		TimeRank timeRank = dao.findById(timeRankId);
		return timeRank.getBigDecimal("class_hour").doubleValue();
	}

	@Deprecated
	public Object getTimeRankList(String courseTime, String teacherId, String studentId, String coursePlanId) {
		List<TimeRank> ranklist = TimeRank.dao.getAddPlanTimeRank(); //获取所有时段
		List<CoursePlan> planlist = CoursePlan.coursePlan.getTeacherPlanesdDay(studentId, teacherId, courseTime);//某天老师和学生的排课；包括老师休息
		if(planlist!=null&&planlist.size()>0){
			for(CoursePlan plan:planlist){//遍历不可用时间
				if(coursePlanId!=null && plan.getPrimaryKeyValue().equals(Integer.parseInt(coursePlanId)))
					continue;
				String plantype = plan.getInt("plan_type").toString();
				Integer starttime = null;
				Integer endtime = null;
				if(plantype.equals("2")){//老师休息
					starttime = Integer.parseInt(plan.getStr("startrest").replace(":", ""));
					endtime = Integer.parseInt(plan.getStr("endrest").replace(":", ""));
				}else{//课程和模考
					starttime = Integer.parseInt(plan.getStr("rank_name").split("-")[0].replace(":", ""));
					endtime = Integer.parseInt(plan.getStr("rank_name").split("-")[1].replace(":", ""));
				}
				for(TimeRank time:ranklist){//遍历所有时段
					Integer rankstart = Integer.parseInt(time.getStr("rank_name").split("-")[0].replace(":", ""));
					Integer rankend = Integer.parseInt(time.getStr("rank_name").split("-")[1].replace(":", ""));
					if((rankstart<=starttime&&rankend>starttime)||(starttime<=rankstart&&endtime>rankstart)){//休息时间冲突
						//0正常；1占用；2有课
						if(!time.get("code").toString().equals("2"))
							time.put("code", "1");
					}
					if(rankstart.equals(starttime)&&rankend.equals(endtime)){
						time.put("code", "2");
					}
				}
			}
		}
		return ranklist;
	}

	/**
	 * 获取指定时段内的所有时段id
	 * 
	 * @param starthour
	 *            开始时
	 * @param endhour
	 *            结束时
	 * @param startmin
	 *            开始分
	 * @param endmin
	 *            结束分
	 * @return 该时段包含的所有定义的时段id
	 */
	public String findIdsToString(String starthour, String endhour, String startmin, String endmin) {
		String ids = "" ;
		Integer startRank = Integer.parseInt(starthour+startmin);
		Integer endRank = Integer.parseInt(endhour+endmin);
		String querySql = "SELECT GROUP_CONCAT(id) ids FROM time_rank tr WHERE 1 = 1 \n" +
				"AND (REPLACE(SUBSTR(tr.RANK_NAME,1,5),':','')>=? AND REPLACE(SUBSTR(tr.RANK_NAME,7,5),':','') <=?)";
		ids = Db.queryColumn(querySql, startRank,endRank);
		return ids;
	}
}
