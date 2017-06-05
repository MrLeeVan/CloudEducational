
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

import org.apache.log4j.Logger;

import com.jfinal.core.Controller;
import com.jfinal.validate.Validator;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.operator.model.Role;

public class RoleValidator extends Validator {

	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(RoleValidator.class);
	
	protected void validate(Controller controller) {
		String actionKey = getActionKey();
		if (actionKey.equals("/operator/roleSave")){
			validateRegex("role.numbers", ToolString.regExp_letter_5, "numbersMsg", "角色编码必须由数字、26个英文字母或者下划线组成的字符串。");
			validateString("role.numbers", 2, 15, "numbersMsg", "编码长度为2-15位");
			validateString("role.names", 2, 20, "namesMsg", "名称长度为2-20位");
		} else if (actionKey.equals("/operator/roleUpdate")){
			validateRegex("role.numbers", ToolString.regExp_letter_5, "numbersMsg", "角色编码必须由数字、26个英文字母或者下划线组成的字符串。");
			validateString("role.numbers", 2, 15, "numbersMsg", "编码长度为2-15位");
			validateString("role.names", 2, 20, "namesMsg", "名称长度为2-20位");
		}
	}
	
	protected void handleError(Controller controller) {
		controller.keepModel(Role.class);
		controller.renderJson(new String[]{"numbersMsg","namesMsg"});
	}
}
