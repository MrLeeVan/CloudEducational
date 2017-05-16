
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

package com.momathink.common.plugin;

import java.util.List;

import org.apache.log4j.Logger;

import com.jfinal.plugin.IPlugin;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolClassSearcher;

/**
 * 扫描model上的注解，绑定model和table
 * @author David
 */
public class TablePlugin implements IPlugin {

    protected final Logger log = Logger.getLogger(getClass());
    
    private ActiveRecordPlugin arp;

	public TablePlugin(ActiveRecordPlugin arp){
		this.arp = arp;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public boolean start() {
		List<Class<? extends BaseModel>> modelClasses = ToolClassSearcher.of(BaseModel.class).search();// 查询所有继承BaseModel的类
		// 循环处理自动注册映射
		for (Class model : modelClasses) {
			// 获取注解对象
			Table tableBind = (Table) model.getAnnotation(Table.class);
			if (tableBind == null) {
				log.error(model.getName() + "继承了BaseModel，但是没有注解绑定表名");
				continue;
			}

			// 获取映射表
			String tableName = tableBind.tableName().trim();
			String pkName = tableBind.pkName().trim();
			if(tableName.equals("") || pkName.equals("")){
				log.error(model.getName() + "注解错误，表名或者主键名为空");
				continue;
			}
			
			// 映射注册
			arp.addMapping(tableName, pkName, model);
		}
		return true;
	}

	@Override
	public boolean stop() {
		return true;
	}

}
