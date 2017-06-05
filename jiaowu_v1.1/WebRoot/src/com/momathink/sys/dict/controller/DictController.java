
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

package com.momathink.sys.dict.controller;

import java.util.List;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.kit.StrKit;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.dict.model.Dict;
import com.momathink.sys.dict.service.DictService;
import com.momathink.sys.table.model.MetaObject;

/**字典管理 <br>
<pre>
id	int	110	-10字典ID				-1	0
version	bigint	20-1000	数据版本号			0
dictname	varchar	30-100	字典名称	utf8	utf8_general_ci	0
val	varchar	255-100	字典项值	utf8	utf8_general_ci	0
numbers	varchar	50-100	字典项编码	utf8	utf8_general_ci	0
parentid	int	11-100	父级字典			0
isparent	varchar	10-100	'false'是否父类	utf8	utf8_general_ci	0
levels	int	4-100	所在层级			0
state	int	2-100	1是否正常			0
<pre>
 */
@Controller(controllerKey="/system/dict")
public class DictController extends BaseController {
	
	private static final DictService dictService = new DictService();
	/** 页面 的 路径  */
	private static final String filePath = "/WEB-INF/view/sys/dict/";
	
	/** 字典列表 */
	public void list(){
		List<Dict> dictList = Dict.dao.queryTableNodeRoot();
		setAttr("dictlist",dictList);
		renderJsp(filePath + "listTree.jsp");
	}
	
	/**字典树*/
	public void treeTable(){
		String treeTableData = dictService.treeTable(getPara("pId"));
		renderText(treeTableData);
	}
	
	/**添加字典**/
	public void addDict(){
		setAttr("operatorType","add");
		renderJsp(filePath + "layer_adddict.jsp");
	}
	
	/** 选择父级字典 */
	public void choiceParentDict(){
		setAttr("dictId","dictId");
		setAttr("dictName","dictName");
		String checkedId = getPara("checkedIds");
		String checkedIds = "";
		String checkedName = "";
		if(StrKit.notBlank(checkedId)){
			Dict dict = Dict.dao.cacheGet(checkedId);
			if(dict!=null){
				checkedIds = dict.getPrimaryKeyValue().toString();
				checkedName = dict.getStr("dictname");
			}
		}
		setAttr("checkedIds",checkedIds);
		setAttr("checkedName",checkedName);
		renderJsp(filePath + "layer_radio.jsp");
		
	}
	
	/**字典树取值*/
	public void treeData(){
		List<JSONObject> treeDataJsonList = dictService.childTreeData( getPara("id") );
		renderJson(treeDataJsonList);
	}
	
	/**查重 */
	public void checkExit(){
		renderJson(MetaObject.dao.queryCheckExcludeId("pt_dict", "numbers", getPara("numbers"), getPara("dictid")));
	}
	
	/**保存字典*/
	public void save(){
		renderJson(dictService.saveDict(getModel(Dict.class)));
	}
	
	/**编辑字典*/
	public void editDict(){
		Dict dict = Dict.dao.queryDictDetail(getPara());
		setAttr("dict",dict);
		setAttr("operatorType","update");
		renderJsp(filePath + "layer_adddict.jsp");
	}
	
	/**修改字典*/
	public void update(){
		renderJson(dictService.updateDict(getModel(Dict.class),getPara("oldParentId")));
	}
	
	/**快速添加 子级字典*/
	public void fastAddDict(){
		Dict dict = Dict.dao.queryDictDetail(getPara());
		dict.put("parentname", dict.get("dictname"));
		dict.set("dictname", dict.get("dictname")+"的子级");
		dict.set("val", dict.get("val")+"的子级");
		dict.set("numbers", dict.get("numbers")+"的子级");
		dict.set("parentid", dict.get("id"));
		dict.set("id", null);
		setAttr("dict",dict);
		setAttr("operatorType","add");
		renderJsp(filePath + "layer_adddict.jsp");
	}
	
}

