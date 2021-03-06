
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

import com.alibaba.fastjson.JSONObject;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.common.constants.Constants;
import com.momathink.sys.sms.model.SendSMS;
import com.momathink.sys.sms.model.SmsMessage;
import com.momathink.sys.sms.service.SmsMessageService;
@Controller(controllerKey="/smsmessage")
public class SmsMessageController extends BaseController {
	SmsMessageService smsMessageService = new SmsMessageService();
	/**
	 * 短信管理发送短信记录 分页
	 */
	public void index(){
		smsMessageService.smsMessagelist(splitPage);
		setAttr("showPages", splitPage.getPage());
		renderJsp("/operator/sms_message.jsp");
	}
	
	public void aginSend(){
		JSONObject json = new JSONObject();
		String id = getPara("id");
		SmsMessage sms = SmsMessage.dao.findById(id);
		SendSMS.sendCoursePlanSms(sms.get("send_msg").toString(), sms.get("recipient_tel").toString(),Constants.RECEIVE_SMS_STUDENT);
		renderJson(json);
	}
}
