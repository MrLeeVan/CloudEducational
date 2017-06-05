
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

package com.momathink.teaching.campus.controller;

import java.util.List;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.SysUser;
import com.momathink.teaching.campus.model.Campus;
import com.momathink.teaching.campus.model.Classroom;

@Controller(controllerKey = "/campus")
public class CampusController extends BaseController {
	private static final Logger logger = Logger.getLogger(CampusController.class);

	/**
	 * 教室管理
	 */
	public void findClassroomManager() {
		try {
			String classAddr = getPara("classAddr");
			String campusId = getPara("campusId");
			// 当前页
			String page = getPara("page") != null ? getPara("page") : "1";
			List<Classroom> classrooms = Classroom.dao.getClassroom(Integer.parseInt(campusId), classAddr, page);
			int count = Integer.parseInt(Classroom.dao.getClassroomNum(Integer.parseInt(campusId), classAddr));
			// 一共有多少页
			String pages = "";
			if ((count / 20) * 20 != count) {
				pages = (count / 20 + 1) + "";
			} else {
				pages = (count / 20) + "";
			}
			setAttr("pages", pages); // 总页数
			setAttr("count", count); // 总记录数
			setAttr("page", page); // 查询的第几页
			setAttr("classPage", classrooms);
			setAttr("classAddr", classAddr);
			setAttr("campusId", campusId);
			setAttr("campus",Campus.dao.findById(Integer.parseInt(campusId)));
			renderJsp("/campus/findClassroomManager.jsp");
		} catch (Exception e) {
			logger.error("CampusController.findClassroomManager", e);
			renderJsp("/campus/findClassroomManager.jsp");
		}
	}

	/**
	 * 验证教室地址是否已存在
	 */
	public void checkClassAddr() {
		try {
			String campusId = getPara("campusId"); // 校区id
			String roomName = getPara("roomName");
			String id = getPara("id");
			if (id == null) {
				Classroom classroom = Classroom.dao.findFirst("select * from classroom where campus_Id=" + campusId + " and `name`=? ", roomName);
				boolean flag = false;
				if (classroom != null) {
					flag = true;
				}
				renderJson(flag);
			} else {
				Classroom classroom = Classroom.dao.findFirst(
						"select * from classroom where campus_Id=" + campusId + " and `name`=? and id not in(" + id + ")", roomName);
				boolean flag = false;
				if (classroom != null) {
					flag = true;
				}
				renderJson(flag);
			}
		} catch (Exception e) {
			logger.error("CampusController.checkClassAddr", e);
			renderJson(false);
		}
	}

	/**
	 * 添加教室跳转页面
	 */
	public void addClassroomManager() {
		try {
			Integer campusId = getParaToInt(); // 校区id
			List<Classroom> list = Classroom.dao.getClassRoomByCamp(campusId);
			int roomNum = list.size() + 1;
			String name = roomNum + "教室";
			Classroom classroom = new Classroom();
			classroom.set("name", name);
			classroom.set("campus_id", campusId);
			setAttr("classroom", classroom);
		} catch (Exception e) {
			logger.error("CampusController.addClassroomManager", e);
		}
		renderJsp("/campus/layer_classroom_form.jsp");
	}

	/**
	 * 添加或更新教室信息
	 */
	public void doAddClassroomManager() {
		Classroom classroom = getModel(Classroom.class);
		if (!ToolString.isNull(classroom.getInt("id") + "")) {
			classroom.update();
		} else {
			classroom.save();
		}
		redirect("/campus/findClassroomManager?campusId=" + classroom.getInt("campus_id"));
	}

	/**
	 * 根据班型id查找教室的信息回显到页面
	 */
	public void editClassroomManager() {
		try {
			String classroom_id = getPara("classroom_id");// 课程id
			Record record = Db.findById("classroom", classroom_id);
			if (!ToolString.isNull(classroom_id)) {
				setAttr("id", classroom_id);
				setAttr("campusId", record.get("CAMPUS_ID"));
				// setAttr("className", record.get("NAME"));
				setAttr("classAddress", record.get("ADDRESS"));
			}
			renderJsp("/campus/addClassroomManager.jsp");
		} catch (Exception e) {
			logger.error("CampusController.editClassroomManager", e);
			renderJsp("/campus/addClassroomManager.jsp");
		}
	}

	/**
	 * 删除教室
	 */
	public void delClassroom() {
		try {
			if (getParaToInt("roomId") != null) {
				int id = getParaToInt("roomId");
				int state = getParaToInt("state");
				// 查询该教室是否有未开始或未结束的课，有则不让删除。sql语义：查找大于当前日期的该教室的排课和等与当前日期该教室该时段未开始或未结束的排课
				String sql = "select * from courseplan  c"
						+ " LEFT JOIN classroom cr ON c.ROOM_ID=cr.Id"
						+ " LEFT JOIN time_rank t ON c.TIMERANK_ID=t.Id"
						+ " where  (c.COURSE_TIME>NOW() OR (DATE_FORMAT(c.COURSE_TIME,'%Y-%m-%d')=DATE_FORMAT(NOW(),'%Y-%m-%d') and SUBSTRING(t.RANK_NAME,-5)>DATE_FORMAT(NOW(),'%H:%i')))"
						+ " and c.state=0 and cr.id=?" + " ORDER BY COURSE_TIME ";
				if (Db.find(sql, id).size() > 0 && state == 1)// 如果有排课未开始或未结束
				{
					renderJson("result", "该教室有未开始或未结束的排课，不能停用");
				} else {
					Db.update("update classroom set state=? where id=?", state, id);// 改变状态，删除成功，该时段只会在按月浏览的历史排课中显示
					renderJson("result", "true");
				}
			}
		} catch (Exception e) {
			logger.error("CampusController.delClassroom", e);
		}
	}

	/**
	 * 根据日期查询教室
	 */
	public void getClassRoomByDateAndDateRank() {
		try {
			String courseTime = getPara("courseTime");
			String timeRank = getPara("timeRank");
			int campusId = getParaToInt("campus_id");
			String sql = "select classroom.id as roomId ,classroom.name as roomName,classroom.address as address,courseplan.id as planId,courseplan.plan_type as planType  from classroom left join courseplan on"
					+ " classroom.id=courseplan.room_id  and courseplan.course_time='"
					+ courseTime
					+ "'  and courseplan.timerank_id="
					+ Integer.parseInt(timeRank)
					+ " where classroom.state=0 and classroom.campus_id="
					+ campusId
					+ " group by classroom.id order by classroom.id ";
			renderJson("classRooms", Db.find(sql));
		} catch (Exception ex) {
			logger.error("error", ex);
		}
	}

	/**
	 * 校区管理
	 */
	public void findCampusManager() {
		try {
			List<Campus> campus = Campus.dao.getLoginUserCampusMassage( getAccountCampus() );
			setAttr("campus", campus);
			renderJsp("/campus/findCampusManager.jsp");
		} catch (Exception e) {
			e.printStackTrace();
			renderJsp("/campus/findCampusManager.jsp");
		}
	}

	/**
	 * 显示校区信息
	 */
	public void showCampusMassage() {
		String campusId = getPara();
		try {
			Campus campus = Campus.dao.getCampusInfo(campusId);
			setAttr("campus", campus);
			renderJsp("/campus/layer_showCampusMassage.jsp");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 验证校区名是否已存在
	 */
	public void checkCampusName() {
		try {
			String campusName = getPara("campusName");
			Campus campus = Campus.dao.findFirst("select * from campus where state=0 AND campus_Name=?", campusName);
			boolean flag = false;
			if (campus != null) {
				flag = true;
			}
			renderJson(flag);
		} catch (Exception e) {
			logger.error("CampusController.checkCampusName", e);
			renderJson(false);
		}
	}

	/**
	 * 添加或更新校区信息
	 */
	public void doAddCampusManager() {
		try {
			Campus campus = getModel(Campus.class);
			Integer id = campus.getPrimaryKeyValue();
			String campus_name = campus.getStr("campus_name");
			if (id != null) {// id不为空更新，为空添加
				campus.update();
				redirect("/campus/findCampusManager");
			} else {
				Campus chenkCampus = Campus.dao.findFirst("select * from campus  where campus_name = ? ", campus_name);
				if (chenkCampus != null) {
					redirect("/campus/findCampusManager");
				} else {
					campus.save();
					
					//添加人的校区更新,防止添加者看不见添加后的校区
					new AccountCampus().set("campus_id", campus.get("id")).set("account_id", getSysuserId()).save();
					getAccount().remove(AccountCampus.SESSION_ACCOUNTCAMPUSIDS);
					
					String roomNum = getPara("roomNum");
					if (roomNum == null) {
						redirect("/campus/findCampusManager");
					} else {
						for (int i = 1; i <= Integer.parseInt(roomNum); i++) {
							String classAddr = i + "教室";
							Classroom.dao.addClassroom(classAddr, campus.getInt("Id"), 0);
						}
						redirect("/campus/findCampusManager");
					}
				}
			}
		} catch (Exception e) {
			logger.error("CourseCpntroller.doAddCampusManager", e);
			forwardAction("/campus/findCampusManager");
		}
	}

	/**
	 * 根据id查找校区的信息回显到页面
	 */
	public void editCampusManager() {
		try {
			String campusId = getPara("campusId");// 科目id
			Campus campus = Campus.dao.getCampusInfoStateNotZero(campusId);
			setAttr("campus", campus);
			List<SysUser> list = SysUser.dao.getSysUserByLoginRoleCampus( getAccountCampus() );
			setAttr("users", list);
			renderJsp("/campus/addCampusManager.jsp");
		} catch (Exception e) {
			logger.error("CampusController.editCampusManager", e);
			renderJsp("/campus/addCampusManager.jsp");
		}
	}

	public void addCampusManager() {
		try {
			List<SysUser> list = SysUser.dao.getSysUserByLoginRoleCampus( getAccountCampus() );
			setAttr("users", list);
			renderJsp("/campus/addCampusManager.jsp");
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	/**
	 * 删除校区
	 */
	public void delCampus1() {
		try {
			if (getParaToInt("campusId") != null) {
				int id = getParaToInt("campusId");
				// 查询该校区是否有未开始或未结束的课，有则不让删除。sql语义：查找大于当前日期的该校区的排课和等与当前日期该校区所有教室该时段未开始或未结束的排课
				String sql = "select * from classroom room where room.campus_id=?";
				if (Db.find(sql, id).size() > 0) {// 如果有排课未开始或未结束
					renderJson("result", "该校区下含有教室，确认删除吗");
				} else {
					Campus campus = Campus.dao.findById(id);
					if (campus.getInt("state") == 1) {
						Db.update("update campus set state=0 where id=?", id);// 改变状态，删除成功，该时段只会在按月浏览的历史排课中显示
					} else if (campus.getInt("state") == 0) {
						Db.update("update campus set state=1 where id=?", id);// 改变状态
					}
					renderJson("result", "true");
				}
			}
		} catch (Exception e) {
			logger.error("CampusController.delCampus", e);
		}
	}

	/**
	 * 删除校区
	 */
	public void delCampus2() {
		try {
			if (getParaToInt("campusId") != null) {
				int id = getParaToInt("campusId");
				// 查询该校区下的教室是否有未开始或未结束的课，有则不让删除。sql语义：查找大于当前日期的该校区的排课和等与当前日期该校区所有教室该时段未开始或未结束的排课
				String sql = "select * from courseplan  c"
						+ " LEFT JOIN classroom cr ON c.ROOM_ID=cr.Id"
						+ " LEFT JOIN campus cp on cr.CAMPUS_ID=cp.Id"
						+ " LEFT JOIN time_rank t ON c.TIMERANK_ID=t.Id"
						+ " where  (c.COURSE_TIME>NOW() OR (DATE_FORMAT(c.COURSE_TIME,'%Y-%m-%d')=DATE_FORMAT(NOW(),'%Y-%m-%d') and SUBSTRING(t.RANK_NAME,-5)>DATE_FORMAT(NOW(),'%H:%i')))"
						+ " and c.state=0 and cp.id=?" + " ORDER BY COURSE_TIME ";
				if (Db.find(sql, id).size() > 0)// 如果有排课未开始或未结束
				{
					renderJson("result", "该校区的教室有未开始或未结束的排课，不能删除");
				} else {
					Campus campus = Campus.dao.findById(id);
					if (campus.getInt("state") == 1) {
						Db.update("update campus set state=0 where id=?", id);// 改变状态，
						Db.update("update classroom set state=0 where classroom.campus_id=?", id);// 删除该校区下所有教室
					} else if (campus.getInt("state") == 0) {
						Db.update("update campus set state=1 where id=?", id);// 改变状态，删除成功，该时段只会在按月浏览的历史排课中显示
						Db.update("update classroom set state=1 where classroom.campus_id=?", id);// 删除该校区下所有教室
					}
					renderJson("result", "true");
				}
			}
		} catch (Exception e) {
			logger.error("CampusController.delCampus", e);
		}
	}

	/**
	 * 修改教室信息
	 */
	public void toModifyClassroom() {
		Integer roomId = getParaToInt();
		setAttr("classroom", Classroom.dao.findById(roomId));
		renderJsp("/campus/layer_classroom_form.jsp");
	}

	/**
	 * 保存修改教室后的信息
	 */
	public void toSaveModifyClassRoom() {
		// 获得页面传送的数据保存到数据库
		JSONObject json = new JSONObject();
		try {
			Classroom classroom = getModel(Classroom.class);
			if (!ToolString.isNull(classroom.getInt("id") + "")) {
				classroom.update();
			} else {
				classroom.save();
			}
			json.put("code", "1");
			json.put("msg", "更新成功");
		} catch (Exception e) {
			logger.error("CourseCpntroller.toSaveModifyClassRoom", e);
			json.put("code", "0");
			json.put("msg", "更新失败");
		}
		renderJson(json);
	}
}
