
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

package com.momathink.sys.table.controller;

import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.table.model.MetaObject;
import com.momathink.sys.table.service.FieIdService;

/**
 * 系统表字段
 */
@Controller(controllerKey = "/system/tablefieid")
public class TableFieldController extends BaseController {
	private static FieIdService service = new FieIdService();
	private static final String viewPath = "/WEB-INF/view/sys/table/tablefieid/";
	
	/**
	 * 列表
	 */
	public void list() {
		service.list(splitPage);
		setAttr("showPages", splitPage.getPage());
		renderJsp(viewPath+"list.jsp");
	}

	/**
	 * 添加
	 */
	public void add() {
		/*setAttr("tableField", (new TableField().set("tableName",getPara("tableName")).set("orders", "1" ) ) );*/
		renderJsp(viewPath+"layer_add.jsp");
	}

	/**
	 * 保存
	 */
	public void save() {
		operation(0);
	}

	/**
	 * 编辑
	 */
	public void edit(){
		/*TableField tableField = TableField.dao.findById(getPara("id"));
		setAttr("tableField", tableField);*/
		renderJsp(viewPath+"layer_edit.jsp");
	}

	/**
	 * 修改
	 */
	public void update(){
		operation(1);
	}

	/**
	 * 删除
	 */
	public void delete(){
		operation(2);
	}
	
	/**
	 * 查重
	 */
	public void checkExit(){
		renderJson(MetaObject.dao.queryTablesTheColumnsTheCount(MetaObject.db_connection_name_main, getPara("tableName"), getPara("columnName")));
	}
	
	/**
	 * @param type 0=保存,1=修改,2=删除
	 */
	private void operation(int type) {
		Integer returnValue = 0; // 0=失败,1成功,-1异常
		try {
			/*switch (type) {
			case 0:
				if (getModel(TableField.class).save())
					returnValue = 1;
				break;
			case 1:
				if (getModel(TableField.class).update())
					returnValue = 1;
				break;
			case 2:
				if (TableField.dao.findById(getPara("id")).delete())
					returnValue = 1;
				break;
			}*/
		} catch (Exception e) {
			e.printStackTrace();
			returnValue = -1;
		}
		renderJson(returnValue);
	}
	

}
