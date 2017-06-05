
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

package com.momathink.sys.sms.controller;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.sms.model.SmsTemplate;
@Controller(controllerKey="/smstemplate")
public class SmsTemplateController  extends BaseController {
	/**
	 * 列表显示
	 */
	public void index(){
		String name = getPara("sms_name");
		setAttr("name",name);
		String type = getPara("sms_type");
		setAttr("type",type);
		List<SmsTemplate> list = SmsTemplate.dao.getAllMessage(name,type);
		setAttr("list",list);
		renderJsp("/operator/sms_templateMessage.jsp");
	}
	/**
	 * 添加新的模板
	 */
	public void add(){
		setAttr("type","add");
		renderJsp("/operator/layer_smsTemplate_form.jsp");
	}
	/**
	 * 修改模板
	 */
	public void update(){
		String id = getPara();
		SmsTemplate sms = SmsTemplate.dao.findById(id);
		setAttr("sms",sms);
		setAttr("type","update");
		renderJsp("/operator/layer_smsTemplate_form.jsp");
	}
	/**
	 * 保存新添加或修改的模板
	 */
	public void save(){
		JSONObject json = new JSONObject();
		SmsTemplate sms = getModel(SmsTemplate.class);
		String id = getPara("smsTemplate.id");
		try{
			if(id.equals("")){
				sms.save();
			}else{
				sms.update();
			}
			json.put("code",1);
		}catch(Exception e){
			e.printStackTrace();
			json.put("code", 0);
		}
		renderJson(json);
	}
	/**
	 * 改变模板的使用状态
	 */
	public void updateState(){
		JSONObject json = new JSONObject();
		try{
			String[] id = getPara("id").toString().split(",");
			if(id[1].equals("1")){
				SmsTemplate sms = SmsTemplate.dao.findById(id[0]);
				sms.set("sms_state", 1).update();
			}else if(id[1].equals("2")){
				SmsTemplate sms = SmsTemplate.dao.findById(id[0]);
				sms.set("sms_state", 0).update();
			}
			json.put("code", 1);
		} catch (Exception e){
			e.printStackTrace();
			json.put("code", 0);
		}
		renderJson(json);
	}
	/**
	 * 删除模板
	 */
	public void deleteTemplate(){
		JSONObject json = new JSONObject();
		try{
			String id = getPara("id");
			SmsTemplate sms = SmsTemplate.dao.findById(id);
			if(sms.getInt("sms_state")==1){
				json.put("code", 2);
			}else{
				sms.delete();
				json.put("code", 1);
			}
		}catch(Exception e){
			e.printStackTrace();
			json.put("code", 0);
		}
		renderJson(json);
	}
}
