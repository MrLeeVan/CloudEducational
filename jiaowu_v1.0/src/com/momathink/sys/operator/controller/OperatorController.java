
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

package com.momathink.sys.operator.controller;

import java.io.File;
import java.util.Date;

import com.jfinal.aop.Before;
import com.jfinal.kit.PathKit;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.constants.DictKeys;
import com.momathink.common.plugin.PropertiesPlugin;
import com.momathink.common.tools.ToolMD5;
import com.momathink.sys.operator.model.Icon;
import com.momathink.sys.operator.model.Module;
import com.momathink.sys.operator.model.Operator;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.operator.model.Systems;
import com.momathink.sys.operator.service.OperatorService;
import com.momathink.sys.system.model.SysUser;
import com.momathink.sys.table.model.MetaObject;

/** 系统管理   
 * */
@Controller(controllerKey="/operator")
public class OperatorController extends BaseController {

	private OperatorService operatorService = new OperatorService();
	
	/** 功能 页面 的 路径  */
	private static final String filePath_operator = "/WEB-INF/view/sys/operator/operator/";
	/** 角色 页面 的 路径  */
	private static final String filePath_role = "/WEB-INF/view/sys/operator/role/";
	/** 用户 角色 页面 的 路径  */
	private static final String filePath_group = "/WEB-INF/view/sys/operator/group/";
	/** 模块 页面 的 路径  */
	private static final String filePath_module = "/WEB-INF/view/sys/operator/module/";
	/** 用户信息  页面 的 路径  */
	private static final String filePath_user = "/WEB-INF/view/sys/operator/user/";
	
	/** 功能列表   */
	public void index(){
		operatorService.treelist(splitPage);
		setAttr("showPages", splitPage.getPage());
		setAttr("config_devMode", PropertiesPlugin.getParamMapValue(DictKeys.config_devMode));
		renderJsp(filePath_operator + "list.jsp");
	}
	
	/** 添加新功能  */
	public void add(){
		setAttr("modulelists", Module.dao.queryAll());
		setAttr("operatorType", "add");
		renderJsp(filePath_operator + "form.jsp");
	}
	
	/** 保存功能  */
	public void save(){
		renderJson(getModel(Operator.class).save());
	}
	
	/** 编辑 功能 */
	public void editthisOperator(){
		String ids = getPara();
		setAttr("operator", Operator.dao.findById(ids));
		setAttr("modulelists", Module.dao.queryAll());
		setAttr("operatorType","update");
		renderJsp(filePath_operator + "form.jsp");
	}
	
	/** 修改功能  */
	public void update(){
		renderJson(getModel(Operator.class).update());
	}
	
	/** 查 重  */
	public void checkUrlExit(){
		long count = MetaObject.dao.queryCheckExcludeId("pt_operator", "formaturl", getPara("url"), getPara("id"));
		renderJson(count);
	}
	
	/** 数据 源  */
	public void showthisOperator(){
		// 功能保留   占 不要删除  该方法
	}
	
	/** 删除 功能  */
	public void delthisOperator(){
		renderJson(operatorService.deleteThisOperator(getPara("id")));
	}
	//----------------------------------角色-----------------------------------------
	
	/** 角色列表 */
	public void role(){
		operatorService.roleList(splitPage);
		setAttr("showPages", splitPage.getPage());
		setAttr("config_devMode", PropertiesPlugin.getParamMapValue(DictKeys.config_devMode));
		renderJsp(filePath_role + "list.jsp");
	}
	
	/** 添加角色 */
	public void addRoles(){
		setAttr("operatorType","add");
		setAttr("url","/operator/roleSave");
		renderJsp(filePath_role + "form.jsp");
	}
	
	/** 保存角色 */
	@Before(RoleValidator.class)
	public void roleSave(){
		getModel(Role.class).save();
		renderJson("code", 1);
	}
	
	/** 修改角色 */
	public void editthisRole(){
		setAttr("role",Role.dao.findById(getPara()));
		setAttr("operatorType","update");
		setAttr("url","/operator/roleUpdate");
		renderJsp(filePath_role + "form.jsp");
	}
	
	/** 保存修改的角色 */
	@Before(RoleValidator.class)
	public void roleUpdate(){
		getModel(Role.class).update();
		renderJson("code", 1);
	}
	
	/** 删除 角色 */
	public void delthisRole(){
		renderJson("msg",operatorService.deleteThisRole(id));
	}
	
	/** 角色选择拥有 功能(树) */
	public void setRoleOperatorDiaLog(){
		Integer ids = getParaToInt();
		setAttr("list", operatorService.getTreeData(ids));
		setAttr("ids", ids);
		renderJsp(filePath_role + "roleoperator_tree.jsp");
	}
	
	/** 保存角色拥有的功能 */
	public void setRoleOperator(){
		Role role = Role.dao.findById(getPara("ids"));
		role.set("moduleids", getPara("moduleIds"));
		role.set("operatorids", getPara("operatorIds"));
		renderJson(role.update());
	}
	
	/** 获取角色拥有的功能 */
	public void getRoleOperator(){
		Role role = Role.dao.findById(getPara("ids"));
		renderJson(role);
	}
	//--------------------------用户 选择角色---------------------------------------
	
	/** 角色分组  */
	public void group(){
		operatorService.groupList(splitPage);
		setAttr("showPages", splitPage.getPage());
		renderJsp(filePath_group + "usergroup.jsp");
	}
	
	/** 用户选择角色 */
	public void setGroupToRoles(){
		String ids = getPara();
		setAttr("map", operatorService.queryGroupRolesSelect(ids));
		setAttr("ids", ids);
		renderJsp(filePath_group + "layer_setgrouprole.jsp");
	}
	
	/** 保存用户的 角色 */
	public void setGroupRoles(){
		SysUser user = SysUser.dao.findById(getPara("ids"));
		user.set("roleids", getPara("roleIds"));
		renderJson(user.update());
	}
	//--------------------------------------模块-------------------------------------------------------
	
	/** 模块列表 **/
	public void module(){
		operatorService.modulist(splitPage);
		setAttr("showPages", splitPage.getPage());
		setAttr("config_devMode", PropertiesPlugin.getParamMapValue(DictKeys.config_devMode));
		renderJsp(filePath_module + "list.jsp");
	}
	
	/** 模块 form 页面 数据 打包  */
	private void moduleForm() {
		setAttr("modulelist", Module.dao.queryAll());
		setAttr("systemlist", Systems.dao.queryAll());
		renderJsp(filePath_module + "form.jsp");
	}
	
	/** 添加模块 */
	public void addmodule(){
		setAttr("operatorType", "add");
		moduleForm();
	}
	
	/** 编辑模块 */
	public void editmodule(){
		Module module = Module.dao.findById(getPara());
		if(module.get("iconid")!=null){
			setAttr("name", Icon.dao.findById(module.get("iconid")).getStr("name"));
		}
		setAttr("module", module);
		setAttr("operatorType","update");
		moduleForm();
	}
	
	/*** 查重 */
	public void checkModulenumExit(){
		long count = MetaObject.dao.queryCheckExcludeId("pt_module", "numbers", getPara("num"), getPara("id"));
		renderJson(count);
	}
	
	/** 保存模块 **/
	public void moduleSave(){
		boolean fruit = operatorService.moduleSave(getModel(Module.class), getSysuserId());
		renderJson(fruit);
	}
	
	/** 更新模块 **/
	public void moduleUpdate(){
		boolean fruit = operatorService.moduleUpdate(getModel(Module.class),getPara("module.id"), getSysuserId());
		renderJson(fruit);
	}
	
	/** 删除模块 **/
	public void delthisModule(){
		renderJson(operatorService.deleteModule(getPara("id")));
	}
	
	/** 上传图标 */
	public void unloadIcon(){
		try{
			String name = new Date().getTime() + ".png";
			
			getFile("file").getFile().renameTo( new File(PathKit.getWebRootPath() + "/images/lefticon/" + name) );
			
			Icon hp = new Icon();//这个设计的有点 蛋疼... 
			hp.set("url", "/images/lefticon").set("name", name).set("sysuserid", getSysuserId()).save();
			
			setAttr("code",0);
			setAttr("url", name);
			setAttr("id", hp.get("id"));
			
		}catch(Exception e){
			e.printStackTrace();
		}
		renderJsp(filePath_module + "icon.jsp");
	}
	//-------------------------用户--------------------------------------------------------
	
	/**  账号信息* */
	public void personal(){
		try{
			Integer id = getSysuserId();
			SysUser sys = SysUser.dao.findById(id);
			String[] roleids = sys.getStr("roleids").split(","); 
			StringBuffer sf = new StringBuffer();
			for(String s :roleids){
				sf.append(Role.dao.findById(s).getStr("names")).append(",");
			}
			setAttr("roles",sf.substring(0, sf.length()-1));
			setAttr("sys",sys);
		}catch(Exception e){
			e.printStackTrace();
		}
		renderJsp(filePath_user + "personalInformation.jsp");
	}
	
	/** 账号密码*  */
	public void personalPossword(){
		SysUser sys = SysUser.dao.findById(getSysuserId());
		setAttr("sys",sys);
		renderJsp(filePath_user + "personalPossword.jsp");
	}
	
	/**  验证密码*  */
	public void chackPassword(){
		try{
			String id = getPara("id");
			String oldpossword = getPara("oldpossword");
			if(ToolMD5.getMD5(oldpossword).equals(SysUser.dao.findById(id).getStr("USER_PWD"))){
				renderJson(1);
			}else{
				renderJson(0);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/**  保存密码*  */
	public void savenewPassword(){
		try{
			String id = getPara("id");
			String newpossword = getPara("newpossword");
			SysUser user = SysUser.dao.findById(id);
			user.set("USER_PWD", ToolMD5.getMD5(newpossword)).update();
			renderJson(1);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
