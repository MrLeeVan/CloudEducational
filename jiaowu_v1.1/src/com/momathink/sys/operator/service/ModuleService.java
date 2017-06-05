
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

package com.momathink.sys.operator.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.momathink.common.base.BaseService;
import com.momathink.sys.operator.model.Module;

public class ModuleService extends BaseService {
	//TODO 需要整改, 一次请求的 性能 都被这个 吃掉 40%... 
	public static List<Module> getFeatures(String systemsid) {
		List<Module> list = Module.getFeatures(systemsid); 
		if(!list.isEmpty()){
			StringBuffer parentmoduleidsSb = new StringBuffer();
			for(Module m:list){
				parentmoduleidsSb.append(m.getInt("id")+",");
			}
			String parentmoduleids = parentmoduleidsSb.toString();
			Map<String, List<Module>> moduleMap = queryBYParentmoduleidsMap(parentmoduleids.substring(0, parentmoduleids.length()-1));
			for(Module m : list){
				 List<Module> listm = moduleMap.get( m.getInt("id").toString() );
				 if(listm == null) listm = new ArrayList<Module>();
				 for(Module mod : listm){
					 if(mod.get("url")!=null){
						 String str = mod.getStr("url");
						 if(str.indexOf("index")>0){
							 str=str.substring(0,str.indexOf("index"));
						 }
						 if(str.indexOf('?')>0){
							 mod.put("urls",str.substring(0, str.indexOf('?')).replaceAll("/",""));
						 }else{
							 mod.put("urls",str.replaceAll("/",""));
						 } 
					 }
				 }
				 m.put("smail", listm);
			}
		}
		return list;
	}
	
	/** 获取多个模块下的小功能 **/
	public static Map<String, List<Module>> queryBYParentmoduleidsMap(String parentmoduleids){
		List<Module> modulesDb = Module.dao.queryBYParentmoduleids(parentmoduleids);
		Map<String, List<Module>> moduleMap = new HashMap<String, List<Module>>();
		String parentmoduleidsFor = "";
		List<Module> modules = null;
		
		for (Module module : modulesDb) {
			String parentmoduleidsDb = module.getStr("parentmoduleids");
			if (!parentmoduleidsFor.equals(parentmoduleidsDb)) {
				modules = new ArrayList<Module>();
				moduleMap.put(parentmoduleidsDb, modules);
				parentmoduleidsFor = parentmoduleidsDb!=null?parentmoduleidsDb:"";
			}
			modules.add(module);
		}
		return moduleMap;
	}
}
