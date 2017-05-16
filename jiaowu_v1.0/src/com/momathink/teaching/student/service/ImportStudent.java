
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

package com.momathink.teaching.student.service;

import java.util.LinkedHashMap;
import java.util.Map;

public class ImportStudent {
	public static final Map<String, String> tabMap = new LinkedHashMap<String, String>();
	public static final Map<String,String> mapTab =  new LinkedHashMap<String, String>();
	public static final String mustTab = "real_name,";//必填项
	static{
		tabMap.put("姓名", "real_name");			mapTab.put("real_name", "姓名");
		tabMap.put("英文名字", "en_name");		mapTab.put("en_name", "英文名字");
		tabMap.put("QQ", "qq");					mapTab.put("qq", "QQ");
		tabMap.put("学生学号", "studentid");		mapTab.put("studentid", "学生学号");
		tabMap.put("性别", "sex");				mapTab.put("sex", "性别");
		tabMap.put("邮箱", "email");				mapTab.put("email", "邮箱");
		tabMap.put("企业名称", "enterprise");	mapTab.put("enterprise", "企业名称");
		tabMap.put("手机", "tel");				mapTab.put("tel", "手机");
		tabMap.put("微信", "wechat");			mapTab.put("wechat", "微信");
		tabMap.put("身份证号", "zjnumber");		mapTab.put("zjnumber", "身份证号");
		tabMap.put("籍贯", "address");			mapTab.put("address", "籍贯");
		tabMap.put("国籍", "nationality");		mapTab.put("nationality", "国籍");
		tabMap.put("出生日期", "birthday");		mapTab.put("birthday", "出生日期");
		tabMap.put("年龄", "age");				mapTab.put("age", "年龄");
		tabMap.put("年级", "grade_name");		mapTab.put("grade_name", "年级");
		tabMap.put("院校", "school");			mapTab.put("school", "院校");
		tabMap.put("住址", "stuaddress");		mapTab.put("stuaddress", "住址");
		tabMap.put("课表确认(是/否)", "release");mapTab.put("release", "课表确认(是/否)");
		tabMap.put("远程(是/否)", "remote");		mapTab.put("remote", "远程(是/否)");
		tabMap.put("父亲姓名", "fathername");	mapTab.put("fathername", "父亲姓名");
		tabMap.put("母亲姓名", "mothername");	mapTab.put("mothername", "母亲姓名");
		tabMap.put("父亲电话", "fathertel");		mapTab.put("fathertel", "父亲电话");
		tabMap.put("母亲电话", "mothertel");		mapTab.put("mothertel", "母亲电话");
		tabMap.put("父亲邮箱", "fatheremail");	mapTab.put("fatheremail", "父亲邮箱");
		tabMap.put("母亲邮箱", "motheremail");	mapTab.put("motheremail", "母亲邮箱");
		tabMap.put("住宿(是/否)", "board");		mapTab.put("board", "住宿(是/否)");
		tabMap.put("备注", "remark");			mapTab.put("remark", "备注");
		tabMap.put("父亲接收短信(是/否)", "receive_sms_father");mapTab.put("receive_sms_father", "父亲接收短信(是/否)");
		tabMap.put("母亲接收短信(是/否)", "receive_sms_mother");mapTab.put("receive_sms_mother", "母亲接收短信(是/否)");
		tabMap.put("学生接收短信(是/否)", "receive_sms_student");mapTab.put("receive_sms_student", "学生接收短信(是/否)");
	}
}
