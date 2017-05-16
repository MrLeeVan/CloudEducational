
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

package com.momathink.common.base;

/**
 * @ClassName com.common.Constants
 * @description
 * @author : David
 * @Create Date : 2014-7-9 下午4:06:53
 */
public class Constants {
	public static String account_session = "account_session";// 存储当前用户信息session
	public static String schoolDomain = ".paike.268xue.com";// 使用268教育网站时二级域名后缀
	public static String EhcacheName = "ehcache";// ehcache默认名字
	public static String domoaincache = "ehcache:domoaincache";// 存域名的信息
	public static String session_school = "session_school";// 存域名的信息

	public static final String OPERATE_SUCCESS_CODE = "0";
	public static final String OPERATE_FAILE_CODE = "1";
	public static final String OPERATE_SUCCESS = "操作成功";
	public static final String OPERATE_FAILE = "操作失败";
	public static final String MOBILE_IS_EXIST = "手机号已存在";
	public static final String EMAIL_IS_EXIST = "电子邮箱已存在";
	public static final String QQ_IS_EXIST = "QQ号码已存在";
	public static final String ENTITY_IS_NULL = "操作对象不存在";
	public static final String COUNSELOR_NOT_EXIST = "顾问不存在";
	public static final String COUNSELOR_NAME_IS_NULL = "姓名不能为空";
	public static final String COUNSELOR_MOBILE_IS_NULL = "手机号不能为空";
	public static final String COUNSELOR_EMAIL_IS_NULL = "电子邮箱不能为空";
	public static final String COUNSELOR_PARENT_MOBLIE_IS_NULL = "推荐人手机号不能为空";
	public static final String COUNSELOR_PARENT_NOT_EXIST = "推荐人不存在";
	public static final String COUNSELOR_IS_EXIST = "顾问已存在";
	public static final String CONTACTER_IS_EXIST = "联系人已存在";
	public static final String CONTACTER_NOT_EXIST = "联系人不存在";
	public static final String STUDENT_NOT_EXIST = "学生不存在";
	public static final String SUBJECT_IS_NULL = "咨询科目不能为空";
	public static final String SUBJECT_NOT_EXIST = "咨询科目不存在";
	public static final String PAIKE_ACCOUNT_IS_EXIST = "排课账号已存在";
	public static final String PHONE_IS_ERROR = "请填写正确的电话格式";
	public static final String LENGTH_IS_ERROR = "输入内容超出规定的长度";
	public static final String NAME_CANNOT_EMPTY = "姓名不能为空";
	public static final String TUIJIAN_SUCCESS = "推荐成功";
	public static final String TUIJIAN_FAILE = "推荐失败";
	public static final String WEI_GUAN_ZHU_WEIXIN = "请先搜索微信号【ldzhushou】，关注后再进行注册。";
	public static final String ACCOUNT_PAYING = "1";// 用户付款
	public static final String ACCOUNT_REWARD = "2";// 赠送、优惠
	public static final String ACCOUNT_REFUND = "3";// 退费
	public static final String ACCOUNT_CONSUME_COURSE = "4";// 课程消耗
	public static final String ACCOUNT_CANCEL_COURSE = "5";// 课程取消
	public static final String ACCOUNT_FRONT_MONEY = "6";// 定金
	public static final String ACCOUNT_ZHUANCUN = "7";//转存
	public static final String ACCOUNT_ZHUANRU = "8";//转入主账户
}
