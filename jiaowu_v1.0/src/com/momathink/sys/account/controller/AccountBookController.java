
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

package com.momathink.sys.account.controller;

import java.util.List;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.account.model.AccountBook;
import com.momathink.sys.account.service.AccountBookService;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;

/**
 * 用户账本记录
 * @author David
 *
 */
@Controller(controllerKey = "/accountbook")
public class AccountBookController extends BaseController {

	private static Logger log = Logger.getLogger(AccountBookController.class);

	private AccountBookService accountBookService = new AccountBookService();

	/**
	 * 流水账目列表
	 */
	public void index() {
		log.debug("账本记录：分页");
		accountBookService.list(splitPage);
		setAttr("showPages", splitPage.getPage());
		render("/finance/accountbook_list.jsp");
	}

	/**
	 * 查看顾问详情
	 * 
	 * @author David
	 * @since JDK 1.7
	 */
	public void view() {
		Student student = Student.dao.findById(getPara());
		List<AccountBook> list = AccountBook.dao.findByAccountId(getPara());
		setAttr("accountBookList", list);
		setAttr("student", student);
		setAttr("operatorType", "view");
		render("/account/accountbook_list.jsp");
	}
	
	
	public void showCoursePlanDelete(){
		JSONObject json = new JSONObject();
		try{
			String id = getPara("courseplanid");
			CoursePlan cp = CoursePlan.coursePlan.getCoursePlanBack(id);
			json.put("planback", cp);
		}catch(Exception ex){
			ex.printStackTrace();
		}
		renderJson(json);
	}
	
	public void showCoursePlan(){
		JSONObject json = new JSONObject();
		try{
			String id = getPara("courseplanid");
			CoursePlan cp = CoursePlan.coursePlan.getCoursePlan(id);
			json.put("planback", cp);
		}catch(Exception ex){
			ex.printStackTrace();
		}
		renderJson(json);
	}

}
