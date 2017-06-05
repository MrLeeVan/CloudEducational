
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

package com.momathink.common.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseController;
import com.momathink.sys.operator.model.Module;
import com.momathink.sys.operator.model.Operator;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.operator.service.ModuleService;

/** 菜单 处理 
 * */
public class ModuleFeaturesInterceptor implements Interceptor{

	public void intercept(Invocation ai) {
		BaseController contro = (BaseController) ai.getController();
		String actionKey = ai.getActionKey();
		
		HttpServletRequest request = contro.getRequest();
		//String url = request.getRequestURI();
		if(actionKey.contains("/wesite")){//URI免验证!
			ai.invoke();
			return;
		}
		Operator o = Operator.dao.cacheGet(actionKey);//正则匹配太慢, 已踢掉
		
		Record record = ai.getController().getSessionAttr("account_session");
		if(record!=null){//判断角色   主页面显示应有角色的数据信息
			boolean isadmins =Role.isAdmins(record.getStr("roleids"));
			request.setAttribute("isadmins",isadmins);
			boolean isteacher =Role.isTeacher(record.getStr("roleids"));
			request.setAttribute("isteacher",isteacher);
			boolean isstudent =Role.isStudent(record.getStr("roleids"));
			request.setAttribute("isstudent",isstudent);
		}
		
		if("/operator/getHeadMessage".equals(actionKey)
			||"/operator/getModulCompetence".equals(actionKey)
			||"/main/getMessage".equals(actionKey)
			){
			ai.invoke();
		}else if(o==null||o.get("privilege").equals("0")){
			List<Module> mlist = Module.dao.findByAllOperator(contro.getSysuserId());
			String systemsid = "";
			if(mlist.isEmpty()){
				systemsid = "5";
			}else{
				systemsid = mlist.get(0).getStr("systemsids");
			}
			List<Module> list = ModuleService.getFeatures(systemsid);
			request.setAttribute("modules",list);
			ai.invoke();
		}else{
			Module m = Module.dao.findById(o.getStr("moduleids"));
			Object parentmoduleids = m.get("parentmoduleids");
			if(parentmoduleids != null){
				m = Module.dao.findById(parentmoduleids);
				request.setAttribute("left", m.getInt("id"));
			}
			String systemsid = m.getStr("systemsids");
			
			List<Module> list = ModuleService.getFeatures(systemsid);
			request.setAttribute("head",systemsid);
			request.setAttribute("smailleft",o.getStr("moduleids"));
			request.setAttribute("modules",list);
			ai.invoke();
		}
	}

}
