
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

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.Logger;

import com.jfinal.plugin.IPlugin;
import com.momathink.common.constants.DictKeys;

/**
 * 读取Properties配置文件数据放入缓存
 * @author David
 */
public class PropertiesPlugin implements IPlugin {

    protected final Logger log = Logger.getLogger(getClass());

	/**
	 * 保存系统配置参数值
	 */
	private static Map<String, Object> paramMap = new HashMap<String, Object>();
	
    private Properties properties;

	public PropertiesPlugin(Properties properties){
		this.properties = properties;
	}

	/**
	 * 获取系统配置参数值
	 * @param key
	 * @return
	 */
	public static Object getParamMapValue(String key){
		return paramMap.get(key);
	}
	
	@Override
	public boolean start() {
		paramMap.put(DictKeys.db_type_key, properties.getProperty(DictKeys.db_type_key).trim());
		
		String jdbcUrl = null;
		String database = null;
		
		// 判断数据库类型
		String db_type = (String) getParamMapValue(DictKeys.db_type_key);
		if(db_type.equals(DictKeys.db_type_postgresql)){ // pg 数据库连接信息
			// 读取当前配置数据库连接信息
			paramMap.put(DictKeys.db_connection_driverClass, properties.getProperty("postgresql.driverClass").trim());
			paramMap.put(DictKeys.db_connection_jdbcUrl, properties.getProperty("postgresql.jdbcUrl").trim());
			paramMap.put(DictKeys.db_connection_userName, properties.getProperty("postgresql.userName").trim());
			paramMap.put(DictKeys.db_connection_passWord, properties.getProperty("postgresql.passWord").trim());
			
			// 解析数据库连接URL，获取数据库名称
			jdbcUrl = (String) getParamMapValue(DictKeys.db_connection_jdbcUrl);
			database = jdbcUrl.substring(jdbcUrl.indexOf("//") + 2);
			database = database.substring(database.indexOf("/") + 1);
			
		}else if(db_type.equals(DictKeys.db_type_mysql)){ // mysql 数据库连接信息
			// 读取当前配置数据库连接信息
			paramMap.put(DictKeys.db_connection_driverClass, "com.mysql.jdbc.Driver");
			paramMap.put(DictKeys.db_connection_jdbcUrl, properties.getProperty("mysql.jdbcUrl").trim());
			paramMap.put(DictKeys.db_connection_userName, properties.getProperty("mysql.userName").trim());
			paramMap.put(DictKeys.db_connection_passWord, properties.getProperty("mysql.passWord").trim());

			// 解析数据库连接URL，获取数据库名称
			jdbcUrl = (String) getParamMapValue(DictKeys.db_connection_jdbcUrl);
			database = jdbcUrl.substring(jdbcUrl.indexOf("//") + 2);
			database = database.substring(database.indexOf("/") + 1, database.indexOf("?"));
		}
		
		// 解析数据库连接URL，获取数据库地址IP
		String ip = jdbcUrl.substring(jdbcUrl.indexOf("//") + 2);
		ip = ip.substring(0, ip.indexOf(":"));

		// 解析数据库连接URL，获取数据库地址端口
		String port = jdbcUrl.substring(jdbcUrl.indexOf("//") + 2);
		port = port.substring(port.indexOf(":") + 1, port.indexOf("/"));
		
		// 把数据库连接信息写入常用map
		paramMap.put(DictKeys.db_connection_ip, ip);
		paramMap.put(DictKeys.db_connection_port, port);
		paramMap.put(DictKeys.db_connection_dbName, database);
		
		// 数据库连接池信息
		paramMap.put(DictKeys.db_initialSize, Integer.parseInt(properties.getProperty(DictKeys.db_initialSize).trim()));
		paramMap.put(DictKeys.db_minIdle, Integer.parseInt(properties.getProperty(DictKeys.db_minIdle).trim()));
		paramMap.put(DictKeys.db_maxActive, Integer.parseInt(properties.getProperty(DictKeys.db_maxActive).trim()));
		
		// 把常用配置信息写入map
		paramMap.put(DictKeys.config_securityKey_key, properties.getProperty(DictKeys.config_securityKey_key).trim());
		//paramMap.put(DictKeys.db_connection_name_main, properties.getProperty(DictKeys.db_connection_name_main).trim());
		paramMap.put(DictKeys.config_passErrorCount_key, Integer.parseInt(properties.getProperty(DictKeys.config_passErrorCount_key)));
		paramMap.put(DictKeys.config_passErrorHour_key, Integer.parseInt(properties.getProperty(DictKeys.config_passErrorHour_key)));
		paramMap.put(DictKeys.config_maxPostSize_key, Integer.valueOf(properties.getProperty(DictKeys.config_maxPostSize_key)));
		paramMap.put(DictKeys.config_devMode, properties.getProperty(DictKeys.config_devMode));
		
		// 微信配置写入Map
	//	paramMap.put(DictKeys.weixin_token, properties.getProperty(DictKeys.weixin_token).trim());
	//	paramMap.put(DictKeys.weixin_appId, properties.getProperty(DictKeys.weixin_appId).trim());
		//paramMap.put(DictKeys.weixin_appSecret, properties.getProperty(DictKeys.weixin_appSecret).trim());
		paramMap.put(DictKeys.weixin_gzh, properties.getProperty(DictKeys.weixin_gzh).trim());
		paramMap.put(DictKeys.weixin_gzhname, properties.getProperty(DictKeys.weixin_gzhname).trim());
		paramMap.put(DictKeys.weixin_xsgzh, properties.getProperty(DictKeys.weixin_xsgzh).trim());
		
		// 公司信息配置
	/*	paramMap.put(DictKeys.company_name, properties.getProperty(DictKeys.company_name).trim());
		paramMap.put(DictKeys.company_kfemail, properties.getProperty(DictKeys.company_kfemail).trim());
		paramMap.put(DictKeys.company_website, properties.getProperty(DictKeys.company_website).trim());*/
		paramMap.put(DictKeys.company_defaultCanUseKeshi, properties.getProperty(DictKeys.company_defaultCanUseKeshi).trim());
		paramMap.put(DictKeys.company_zuidaweichengdan, properties.getProperty(DictKeys.company_zuidaweichengdan).trim());
		//推广返佣比例
		paramMap.put(DictKeys.promo_lv1, properties.getProperty(DictKeys.promo_lv1).trim());
		paramMap.put(DictKeys.promo_lv2, properties.getProperty(DictKeys.promo_lv2).trim());
		paramMap.put(DictKeys.promo_lv3, properties.getProperty(DictKeys.promo_lv3).trim());
		paramMap.put(DictKeys.promo_lv4, properties.getProperty(DictKeys.promo_lv4).trim());
		paramMap.put(DictKeys.promo_lv5, properties.getProperty(DictKeys.promo_lv5).trim());
		paramMap.put(DictKeys.promo_default, properties.getProperty(DictKeys.promo_default).trim());
		
		//i18n
		paramMap.put(DictKeys.basename, properties.getProperty(DictKeys.basename).trim());
		
		//wordsystem_signature
		paramMap.put( DictKeys.WORD_SIGNATURE , properties.getProperty( DictKeys.WORD_SIGNATURE ).trim() );
		paramMap.put( DictKeys.WORDSYSTEM_PATH , properties.getProperty( DictKeys.WORDSYSTEM_PATH ).trim() );
		return true;
	}

	@Override
	public boolean stop() {
		paramMap.clear();
		return true;
	}

}
