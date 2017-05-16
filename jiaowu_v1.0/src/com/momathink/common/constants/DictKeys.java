
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

package com.momathink.common.constants;

import org.apache.log4j.Logger;

/**
 * 常量数据字典
 * 
 * @author David Wang
 */
public abstract class DictKeys {

	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(DictKeys.class);


	/**
	 * URL缓存Key
	 */
	public static final String cache_name_page = "SimplePageCachingFilter";

	/**
	 * 系统缓存，主要是权限和数据字典等
	 */
	public static final String cache_name_system = "system";

	/**
	 * 加密
	 */
	public static final String config_securityKey_key = "config.securityKey";

	/**
	 * 密码最大错误次数
	 */
	public static final String config_passErrorCount_key = "config.passErrorCount";

	/**
	 * 密码错误最大次数后间隔登陆时间（小时）
	 */
	public static final String config_passErrorHour_key = "config.passErrorHour";

	/**
	 * #文件上传大小限制 10 * 1024 * 1024 = 10M
	 */
	public static final String config_maxPostSize_key = "config.maxPostSize";
	public static final String config_devMode = "config.devMode";

	/**
	 * 当前数据库类型
	 */
	public static final String db_type_key = "db.type";

	public static final String db_type_postgresql = "postgresql";
	public static final String db_type_mysql = "mysql";

	public static final String db_connection_driverClass = "driverClass";
	public static final String db_connection_jdbcUrl = "jdbcUrl";
	public static final String db_connection_userName = "userName";
	public static final String db_connection_passWord = "passWord";

	public static final String db_connection_ip = "db_ip";
	public static final String db_connection_port = "db_port";
	public static final String db_connection_dbName = "db_name";

	public static final String db_initialSize = "db.initialSize";
	public static final String db_minIdle = "db.minIdle";
	public static final String db_maxActive = "db.maxActive";

	/**
	 * 分页参数初始化值
	 */
	public static final int default_pageNumber = 1;// 第几页
	public static final int default_pageSize = 20;// 每页显示几多

	/**
	 * 用户登录状态码
	 */
	public static final int login_info_0 = 0;// 用户不存在
	public static final int login_info_1 = 1;// 停用账户
	public static final int login_info_2 = 2;// 密码错误次数超限
	public static final int login_info_3 = 3;// 密码验证成功
	public static final int login_info_4 = 4;// 密码验证失败

	/**
	 * 微信配置
	 */
	//public static final String weixin_token = "weixin.token";
	//public static final String weixin_appId = "weixin.appId";
	//public static final String weixin_appSecret = "weixin.appSecret";
	public static final String weixin_gzh = "weixin.gzh";
	public static final String weixin_gzhname = "weixin.gzhname";
	public static final String weixin_xsgzh = "weixin.xsgzh";

	/**
	 * 公司配置
	 */
	//public static final String company_name = "company.name";
	//public static final String company_kfemail = "company.kfemail";
	//public static final String company_website = "company.website";
	public static final String company_defaultCanUseKeshi="company.defaultCanUseKeshi";
	public static final String company_zuidaweichengdan="company.zuidaweichengdan";
	/**
	 * 推广返佣比例设置
	 */
	public static final String promo_lv1 = "promo.lv1";
	public static final String promo_lv2 = "promo.lv2";
	public static final String promo_lv3 = "promo.lv3";
	public static final String promo_lv4 = "promo.lv4";
	public static final String promo_lv5 = "promo.lv5";
	public static final String promo_default = "promo.default";
	
	/**
	 * i18n
	 */
	public static final String basename = "basename";

	public static final String WORD_SIGNATURE = "wordsystem.signature";
	public static final String WORDSYSTEM_PATH = "wordsystem.path";
}
