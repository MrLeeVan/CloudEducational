
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

package com.momathink.teaching.remind.controller;

import java.util.Map;

import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.SysUser;
import com.momathink.teaching.remind.model.Remind;
import com.momathink.teaching.remind.service.RemindService;

/**
 * 2015年10月26日
 * @author prq
 *提醒管理
 */

@Controller(controllerKey="/remindManager")
public class RemindManageController extends com.momathink.common.base.BaseController {
	
	/**
	 * 提醒列表   分页
	 */
	public void list(){
		Map<String, String> queryParam = splitPage.getQueryParam();
		SysUser sysuser = SysUser.dao.findById(getAttr("cUserIds"));
		boolean isAdmins = Role.isAdmins(sysuser.getStr("roleids"));
		queryParam.put("userId", getAttr("cUserIds").toString());
		String loginRoleCampusIds  = getAccountCampus();
		queryParam.put( "loginRoleCampusIds", loginRoleCampusIds );
		RemindService.service.list(splitPage);
		setAttr("showPages", splitPage.getPage());
		setAttr("isAdmins", isAdmins);
		render("/remind/remind_list.jsp");
	}
	
	/**
	 * 添加提醒
	 */
	public void add(){
		setAttr("stuId",getPara());
		setAttr("operatorType", "add");
		render("/remind/layer_remind_form.jsp");
	}
	
	/**
	 * 保存提醒
	 */
	public void save(){
		JSONObject json = new JSONObject();
		try{
			Remind remind = getModel(Remind.class);
			RemindService.service.save(remind,getAttr("cUserIds").toString());
			json.put("code", 1);
			json.put("msg", "添加成功");
		}catch(Exception e){
			e.printStackTrace();
			json.put("code", 0);
			json.put("msg", "添加数据异常，请联系管理员");
		}
		renderJson(json);
		
	}
	
	/**
	 * 编辑提醒信息
	 */
	public void edit(){
		Remind remind = Remind.dao.findById(getPara());
		setAttr("remind",remind);
		setAttr("operatorType", "update");
		render("/remind/layer_remind_form.jsp");
	}
	
	public void update(){
		JSONObject json = new JSONObject();
		try{
			Remind remind = getModel(Remind.class);
			RemindService.service.update(remind,getAttr("cUserIds").toString());
			json.put("code", 1);
			json.put("msg", "修改成功");
		}catch(Exception e){
			e.printStackTrace();
			json.put("code", 0);
			json.put("msg", "修改数据异常，请联系管理员");
		}
		renderJson(json);
	}
	
	/**
	 * 删除提醒
	 */
	public void delete(){
		String ids = getPara("ids");
		JSONObject json = new JSONObject();
		boolean flag = RemindService.service.deleteRemind(ids);
		if(flag){
			json.put("code", "0");
		    json.put("msg", "删除成功！");
		}else{
			json.put("code", "1");
			json.put("msg", "修改数据异常，请联系管理员！");
		}
		renderJson(json);
	}
	
	/**
	 * 删除提醒
	 */
	public void updateRead(){
		String ids = getPara("ids");
		JSONObject json = new JSONObject();
		boolean flag = RemindService.service.updateRead(ids);
		if(flag){
			json.put("code", "0");
		    json.put("msg", "修改成功！");
		}else{
			json.put("code", "1");
			json.put("msg", "修改数据异常，请联系管理员！");
		}
		renderJson(json);
	}
}
