
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

import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.account.service.AccountService;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.course.model.CourseBack;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.course.service.CourseCancelService;

@Controller(controllerKey="/coursecancel")
public class CourseCancelController extends BaseController {

	private CourseCancelService coursecancelService = new CourseCancelService();
	private AccountService accountService = new AccountService();
	/**
	 * 查看已取消课程信息*
	 * */
	public void index() {
		try{
			//当前登录人所属校区IDS
			String loginRoleCampusIds = getAccountCampus();
			Map<String, String> queryParam = splitPage.getQueryParam();
			if( !StringUtils.isEmpty( loginRoleCampusIds )){
				queryParam.put( "loginRoleCampusIds", loginRoleCampusIds);
			}
			Integer sysuserId = getSysuserId();
			coursecancelService.list(splitPage);
			setAttr("showPages", splitPage.getPage());
			setAttr("campuslist",  Campus.dao.getCampusByLoginUser(  sysuserId  ));
			renderJsp("/course/findDelCoursePlan.jsp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 恢复课程信息*
	 */
	public void restoreCoursePlan(){
		JSONObject json = new JSONObject();
		try{
			boolean teacherflag = false;
			String id = getPara("id");
			CourseBack cb = CourseBack.dao.findByIdToMessage(id);
			String[] ctime = cb.getStr("RANK_NAME").split("-");
			List<CoursePlan> cplist =CoursePlan.coursePlan.getTeacherCoursePlansByDay(cb.getStr("course_time"),cb.getInt("teacher_id").toString());
			if(cplist.isEmpty()){
				teacherflag = true;
			}else{
				for(CoursePlan cp :cplist){
					String[] ytime = cp.getStr("RANK_NAME").split("-");
					if(ctime[1].compareTo(ytime[0])<=0||ctime[0].compareTo(ytime[1])>0){
						teacherflag = true;
						break;
					}
				}
				if(!teacherflag){
					json.put("code",1);
				}
			}
			boolean studentflag=false;
			List<CoursePlan> slist = CoursePlan.coursePlan.getCoursePlansByDay(cb.getStr("course_time"),cb.getInt("student_id").toString());
			if(slist.isEmpty()){
				studentflag = true;
			}else{
				for(CoursePlan cp :slist){
					String[] ytime = cp.getStr("RANK_NAME").split("-");
					if(ctime[1].compareTo(ytime[0])<=0||ctime[0].compareTo(ytime[1])>0){
						studentflag = true;
						break;
					}
				}
				if(!studentflag){
					json.put("code",2);
				}
			}
			boolean roomflag = false;
			List<CoursePlan> rlist = CoursePlan.coursePlan.getCoursePlansByRoomId(cb.getInt("room_id"),cb.getStr("course_time"));
			if(rlist.isEmpty()){
				roomflag = true;
			}else{
				for(CoursePlan cp :rlist){
					String[] ytime = cp.getStr("RANK_NAME").split("-");
					if(ctime[1].compareTo(ytime[0])<=0||ctime[0].compareTo(ytime[1])>0){
						roomflag = true;
						break;
					}
				}
				if(!roomflag){
					json.put("code",3);
				}
			}
			if(teacherflag&&studentflag&&roomflag){
				boolean result = accountService.consumeCourse(Integer.parseInt(id), cb.getInt("student_id"), getSysuserId(),0);
				if(result){
					String sql1 = "insert into courseplan SELECT * from  courseplan_back where ID=? ";
					Db.update(sql1,id);
					CourseBack c= CourseBack.dao.findById(id);
					c.delete();
					json.put("code", 0);
				}else{
					json.put("code", 4);
				}
			}
			renderJson(json);
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
}
