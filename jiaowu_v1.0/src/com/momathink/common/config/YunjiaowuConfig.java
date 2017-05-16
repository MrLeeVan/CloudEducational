
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

package com.momathink.common.config;


import org.apache.log4j.Logger;

import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.ext.interceptor.SessionInViewInterceptor;
import com.jfinal.i18n.I18nInterceptor;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.activerecord.CaseInsensitiveContainerFactory;
import com.jfinal.plugin.activerecord.dialect.MysqlDialect;
import com.jfinal.plugin.cron4j.Cron4jPlugin;
import com.jfinal.plugin.druid.DruidPlugin;
import com.jfinal.plugin.ehcache.EhCachePlugin;
import com.jfinal.render.ViewType;
import com.jfinal.template.Engine;
import com.momathink.common.constants.DictKeys;
import com.momathink.common.handler.GlobalHandler;
import com.momathink.common.interceptor.AuthenticationInterceptor;
import com.momathink.common.interceptor.LoginInterceptor;
import com.momathink.common.interceptor.ModuleFeaturesInterceptor;
import com.momathink.common.interceptor.ParamPkgInterceptor;
import com.momathink.common.interceptor.RemoveRefundSessionInterceptor;
import com.momathink.common.plugin.ControllerPlugin;
import com.momathink.common.plugin.MessagePropertiesPlugin;
import com.momathink.common.plugin.PropertiesPlugin;
import com.momathink.common.plugin.TablePlugin;
import com.momathink.common.thread.ThreadParamInit;
import com.momathink.common.tools.ToolMonitor;
import com.momathink.common.tools.ToolOperatorSession;
import com.momathink.common.tools.ToolString;
import com.momathink.sys.account.controller.AccountController;
import com.momathink.sys.system.model.ThreadSysLog;

/**
 * MoMA云教务系统 配置
 */
public class YunjiaowuConfig extends JFinalConfig {

	private static final Logger log = Logger.getLogger(YunjiaowuConfig.class);
	
	/**
	 * 配置常量
	 */
	public void configConstant(Constants me) {
		log.info("configConstant 缓存 properties");
		new PropertiesPlugin(loadPropertyFile("/init.properties")).start();
		log.info("configConstant 设置字符集");
		me.setEncoding(ToolString.encoding);
		log.info("configConstant 设置是否开发模式");
		me.setDevMode(getPropertyToBoolean("config.devMode", false));
		me.setViewType(ViewType.JSP);
//		me.setBaseViewPath("/WEB-INF/view");
		
		me.setI18nDefaultBaseName((String)PropertiesPlugin.getParamMapValue(DictKeys.basename));
		
		log.info("configConstant 视图error page设置");
		me.setError401View("/common/401.html");
		me.setError403View("/common/403.html");
		me.setError404View("/common/404.html");
		me.setError500View("/common/500.html");
	}

	/**
	 * 配置路由
	 */
	public void configRoute(Routes me) {
		me.add("/", AccountController.class);
		
		new ControllerPlugin(me).start();
	}

	/**
	 * 配置插件
	 */
	public void configPlugin(Plugins me) {
		log.info("configPlugin 配置Druid数据库连接池插件");
		DruidPlugin druidPlugin = new DruidPlugin(
				(String)PropertiesPlugin.getParamMapValue(DictKeys.db_connection_jdbcUrl), 
				(String)PropertiesPlugin.getParamMapValue(DictKeys.db_connection_userName), 
				(String)PropertiesPlugin.getParamMapValue(DictKeys.db_connection_passWord), 
				(String)PropertiesPlugin.getParamMapValue(DictKeys.db_connection_driverClass));
		druidPlugin.set(
				(int)PropertiesPlugin.getParamMapValue(DictKeys.db_initialSize), 
				(int)PropertiesPlugin.getParamMapValue(DictKeys.db_minIdle), 
				(int)PropertiesPlugin.getParamMapValue(DictKeys.db_maxActive));
		me.add(druidPlugin);
		log.info("configPlugin 配置ActiveRecord插件");
		ActiveRecordPlugin arp = new ActiveRecordPlugin(druidPlugin);
		arp.setShowSql(getPropertyToBoolean("config.devMode", false));
		log.info("configPlugin 使用数据库类型是 mysql");
		arp.setDialect(new MysqlDialect());
		log.info("数据库表字段: 统一大小写为 (大写)");
		arp.setContainerFactory(new CaseInsensitiveContainerFactory(false));//false 是大写, true是小写, 不写是
		log.info("表扫描注册");
		new TablePlugin(arp).start();
		me.add(arp);
		
		log.info("EhCachePlugin EhCache缓存");
		me.add(new EhCachePlugin());
		
		log.info("Cron4jPlugin 载入 任务调度");
		me.add(new Cron4jPlugin("task.properties"));
	}

	/**
	 * 配置全局拦截器
	 */
	public void configInterceptor(Interceptors me) {
		me.add(new SessionInViewInterceptor());
		me.add(new LoginInterceptor());
		me.add(new I18nInterceptor());
		me.add(new RemoveRefundSessionInterceptor());
		me.add(new ModuleFeaturesInterceptor());
		log.info("configInterceptor 权限认证拦截器");
		me.add(new AuthenticationInterceptor());
		
		log.info("configInterceptor 参数封装拦截器");
		me.add(new ParamPkgInterceptor());
	}

	/**
	 * 配置处理
	 */
	public void configHandler(Handlers me) {
		log.info("configHandler 全局配置处理器，主要是记录日志和request域值处理");
		me.add(new GlobalHandler());
	}
	
	/**模板引擎模块
	 */
	public void configEngine(Engine me) {
	}
	
	/**
	 * 系统启动完成后执行
	 */
	public void afterJFinalStart() {
		log.info("afterJFinalStart 启动操作日志入库线程");
		ThreadSysLog.startSaveDBThread();
		
		log.info("加载短信、邮件配置");
		new MessagePropertiesPlugin(loadPropertyFile("/smsconfig.properties")).start();

		log.info("加载角色信息到系统内存");
		ToolOperatorSession.refreshRoleMap();
		
		log.info("加载授权信息到系统内存");
		new ToolMonitor(ToolMonitor.report_start).start();
		
		log.info("加载缓存开始");
		new ThreadParamInit().start();
	}
	
	/**
	 * 系统关闭前调用
	 */
	public void beforeJFinalStop() {
		log.info("beforeJFinalStop 释放日志入库线程");
		ThreadSysLog.setThreadRun(false);
	}

}
