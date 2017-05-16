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

package com.momathink.sys.system.controller;

import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.ehcache.CacheKit;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.constants.DictKeys;
import com.momathink.common.plugin.PropertiesPlugin;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ToolMD5;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.system.service.SysUserService;
import com.momathink.teaching.campus.model.Campus;

@Controller(controllerKey = "/sysuser")
public class SysUserController extends BaseController {
	private static final Logger logger = Logger.getLogger(SysUserController.class);

	public void index() {
		splitPage.getQueryParam().put( "loginRoleCampusIds", getAccountCampus() );
		SysUserService.me.list(splitPage);
		setAttr("showPages", splitPage.getPage());
		setAttr("roles",Role.dao.getAllRoleNost());
		render("/sysuser/sysuser_list.jsp");
	}

	/** /sysuser/checkExist
	 * 检查是否存在
	 */
	public void checkExist() {
		String field = getPara("checkField");
		String value = getPara("checkValue");
		String id = getPara("id");
		if (!ToolString.isNull(field) && !ToolString.isNull(value)) {
			Long count = SysUser.dao.queryCount(field, value, id);
			renderJson("result", count);
		} else {
			renderJson("result", null);
		}
	}
	/**
	 * 添加系统用户*
	 */
	public void add() {
		try {
			List<Campus> clist = Campus.dao.getCampusByLoginUser( getSysuserId() );
			setAttr("campusList", clist);
			setAttr("roles",Role.dao.getAllRoleNost());
			renderJsp("/sysuser/sysuser_form.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	public void edit() {
		try {
			SysUser sysuser = SysUser.dao.findById(getParaToInt());
			setAttr("sysuser", sysuser);
			List<Campus> clist = Campus.dao.getCampus();
			List<AccountCampus> accountcampus = AccountCampus.dao.getCampusidsByAccountid(getParaToInt());
			String campusids = "|";
			if(!accountcampus.isEmpty()){
				for(AccountCampus c :accountcampus){
					campusids+=c.getInt("campus_id")+"|";
				}
			}
			//回填按校区区分是否显示全部信息
			for(Campus campus :clist){
				Integer campusid = campus.getInt("id");
				campus.put("showall", 0);
				for(AccountCampus c :accountcampus){
					Integer aCampusid = c.getInt("campus_id");
					if(campusid==aCampusid){
						campus.put("showall", 1);
					}
				}
			}
			
			setAttr("campusids",campusids);
			setAttr("campusList", clist);
			setAttr("roles",Role.dao.getAllRoleNost());
			renderJsp("/sysuser/sysuser_form.jsp");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	/**
	 * 保存用户
	 */
	public void save() {
		try {
			SysUser sysuser = getModel(SysUser.class);
			sysuser.set("user_pwd", ToolMD5.getMD5(Organization.dao.getTchLnitialPassword()));
			sysuser.set("create_time", new Date());
			sysuser.set("createuserid", getSysuserId());
			int id = SysUserService.me.save(sysuser);
			
			String str = getPara("campusids");
			if(!str.isEmpty()){
				String[] campusid = str.replace("|", ",").split(",");
				for(int i=0;i<campusid.length;i++){
					AccountCampus ac = new AccountCampus();
					ac.set("account_id", id).set("campus_id",campusid[i]).save();
				}
			}
			redirect("/sysuser/index");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	/**
	 * 更新用户
	 */
	public void update() {
		try {
			SysUser sysuser = getModel(SysUser.class);
			SysUserService.me.update(sysuser);
			String str = getPara("campusids");
			String id = getPara("sysUser.id");
			List<AccountCampus> acc= AccountCampus.dao.getAllCampusidByAccountid(id);
			if(!acc.isEmpty()){
				for(AccountCampus a:acc){
					a.delete();
				}
			}
			if(!str.isEmpty()){
				String[] campusid = str.replace("|", ",").split(",");
					for(int i=0;i<campusid.length;i++){
							AccountCampus ac = new AccountCampus();
							ac.set("account_id", id).set("campus_id",campusid[i]).save();
					}
			}
			//清除 该用户的校区缓存信息
			CacheKit.remove(DictKeys.cache_name_page, "campus_getCampusByLoginUser_" + sysuser.getInt("id"));
			redirect("/sysuser/index");
		} catch (Exception ex) {
			logger.error(ex.toString());
		}
	}

	public void freeze() {
		try {
			int state = getParaToInt("state");
			int id = getParaToInt("sysuserId");
			SysUser sysuser = SysUser.dao.findById(id);
			sysuser.set("state", state);
			SysUserService.me.update(sysuser);
			renderJson("result", "true");
		} catch (Exception e) {
			logger.error("AccountController.freezeAccount", e);
		}
	}

	public void changePassword() {
		JSONObject json = new JSONObject();
		try {
			Integer id = getParaToInt("id");
			String pwd = getPara("password");
			SysUser user = SysUser.dao.findById(id);
			user.set("USER_PWD", ToolMD5.getMD5(pwd));
			SysUserService.me.update(user);
			json.put("result", true);
		} catch (Exception ex) {
			logger.error("error", ex);
			json.put("result", false);
		}
		renderJson(json);
	}

	/*
	 * 跟去校区ID获取课程顾问
	 */
	public void getKcge() {
		JSONObject json = new JSONObject();
		String id = getPara("id");
		String oppkcuserid = getPara("oppkcuserid");
		String oppscuserid = getPara("oppscuserid");
		int sysid = getSysuserId();
		if (id != null) {
			List<SysUser> account = SysUser.dao. getKechengguwenCampus(id);
			List<SysUser> shichang = SysUser.dao.getShichangByCampusid(id);
			json.put("accountList", account);
			json.put("shichangList", shichang);
		} else {
			List<SysUser> account = SysUser.dao.getAllKcgw();
			json.put("accountList", account);
		}
		setAttr("roles",Role.dao.getAllRole());
		json.put("oppkcuserid", oppkcuserid);
		json.put("oppscuserid", oppscuserid);
		json.put("sysid", SysUser.dao.findById(sysid));
		renderJson(json);
	}
	/**
	 * 保存用户基本信息
	 */
	public void basePersonMessage(){
		try{
			String id= getPara("id");
			String name= getPara("name");
			String tel= getPara("tel");
			String email= getPara("email");
			String sex= getPara("sex");
			SysUser user = SysUser.dao.findById(id);
			if(user!=null){
				user.set("real_name",name).set("tel",tel).set("email",email).set("sex",sex).update();
			}
			renderJson(1);
		}catch(Exception e){
			e.printStackTrace();
			renderJson(0);
		}
	}
	
//	/**
//	 * 登陆网校系统
//	 */
//	public void loginToWord() {
//		Integer jwUserId = getSysuserId();
//		SysUser accountUser = SysUser.dao.findById( jwUserId );
//		JSONObject resultJson = new JSONObject();
//		if( accountUser == null ) {
//			resultJson.put( "flag" , false );
//		} else {
//			resultJson.put( "flag" , true );
//			resultJson.put( "isStudent" , Role.isStudent( accountUser.getStr( "roleids" )) );
//			String wordSystemPath = ( String )PropertiesPlugin.getParamMapValue( DictKeys.WORDSYSTEM_PATH );
//			resultJson.put( "wordSystemPath" , wordSystemPath );
//			String privateKey = ( String )PropertiesPlugin.getParamMapValue( DictKeys.WORD_SIGNATURE );
//			long timestamp = System.currentTimeMillis();
//			resultJson.put( "timestamp" , timestamp );
//			resultJson.put( "signature" , ToolMD5.getMD5( ToolMD5.getMD5( timestamp + privateKey ) ) );
//			resultJson.put( "jwUserId" , jwUserId );
//			resultJson.put( "email" , accountUser.getStr("EMAIL") );
//			resultJson.put( "realName" , accountUser.getStr("REAL_NAME") );
//		}
//		renderJson( resultJson );
//		
//	}
	
	/**
	 * 登陆网校系统
	 */
	public void loginToWord() {
		Integer jwUserId = getSysuserId();
		SysUser accountUser = SysUser.dao.findById( jwUserId );
		if( accountUser == null ) {
			setAttr("flag", false);
		} else {
			setAttr("flag", true);
			setAttr("isStudent", Role.isStudent( accountUser.getStr( "roleids" )));
			String wordSystemPath = ( String )PropertiesPlugin.getParamMapValue( DictKeys.WORDSYSTEM_PATH );
			setAttr("wordSystemPath", wordSystemPath);
			String privateKey = ( String )PropertiesPlugin.getParamMapValue( DictKeys.WORD_SIGNATURE );
			long timestamp = System.currentTimeMillis();
			setAttr("timestamp", timestamp);
			setAttr("signature", ToolMD5.getMD5( ToolMD5.getMD5( timestamp + privateKey ) ));
			setAttr("jwUserId", jwUserId);
			setAttr("email", accountUser.getStr("EMAIL"));
			setAttr("realName", accountUser.getStr("REAL_NAME"));
		}
		renderJsp("/sysuser/wordSystem_login.jsp");
	}
}
