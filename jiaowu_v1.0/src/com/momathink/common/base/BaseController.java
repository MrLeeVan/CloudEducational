
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

import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.jfinal.core.Const;
import com.jfinal.core.Controller;
import com.jfinal.i18n.I18n;
import com.jfinal.i18n.Res;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.constants.DictKeys;
import com.momathink.common.plugin.PropertiesPlugin;
import com.momathink.sys.system.model.AccountCampus;
import com.momathink.sys.system.model.SysLog;

/**
 * 公共Controller
 * @author David
 */
public abstract class BaseController extends Controller {

	//private static Logger log = Logger.getLogger(BaseController.class);
	
	/**
	 * 全局变量
	 */
	protected String id;			// 主键
	protected SplitPage splitPage;	// 分页封装
	protected List<?> list;			// 公共list
	protected SysLog reqSysLog;		//访问日志
	/**
	 * 请求/WEB-INF/下的视图文件
	 */
	public void toUrl() {
		String toUrl = getPara("toUrl");
		render(toUrl);
	}


	/**
	 * 获取项目请求根路径
	 * @return
	 */
	protected String getCxt() {
		return getAttr("cxt");
	}
	
	/**
	 * 获取查询参数
	 * 说明：和分页分拣一样，但是应用场景不一样，主要是给查询导出的之类的功能使用
	 * @return
	 */
	public Map<String, String> getQueryParam(){
		Map<String, String> queryParam = new HashMap<String, String>();
		Enumeration<String> paramNames = getParaNames();
		while (paramNames.hasMoreElements()) {
			String name = paramNames.nextElement();
			String value = getPara(name);
			if (name.startsWith("_query") && !value.isEmpty()) {// 查询参数分拣
				String key = name.substring(7);
				if(!StrKit.isBlank(value)){
					queryParam.put(key, value.trim());
				}
			}
		}
		
		return queryParam;
	}

	/**
	 * 调用此方法 可以页面查询条件回填可以直接写成value="${name}"  不需要写成value="${paramMap['_query.name']}"
	 * @param queryParam
	 */
	public void setqueryParamMap(Map<String, String> queryParam){
		Map<String,Object> params = new HashMap<String,Object>();
		Enumeration<String> paramNames = getParaNames();
		while (paramNames.hasMoreElements()) {
			String name = paramNames.nextElement();
			String value = getPara(name);
			if (!name.startsWith("_query") && !value.isEmpty()) {
				if (null != value && !value.trim().equals("")) {
					params.put(name, value.trim());
				}
			}
		}
		for (Map.Entry<String, String> entry : queryParam.entrySet()){
			params.put(entry.getKey(), entry.getValue());
		}
		
		setAttrs(params);
	}
	
	/**
	 * 设置默认排序
	 * @param colunm
	 * @param mode
	 */
	public void defaultOrder(String colunm, String mode){
		if(null == splitPage.getOrderColunm() || splitPage.getOrderColunm().isEmpty()){
			splitPage.setOrderColunm(colunm);
			splitPage.setOrderMode(mode);
		}
	}
	
	/**
	 * 排序条件
	 * 说明：和分页分拣一样，但是应用场景不一样，主要是给查询导出的之类的功能使用
	 * @return
	 */
	public String getOrderColunm(){
		String orderColunm = getPara("orderColunm");
		return orderColunm;
	}

	/**
	 * 排序方式
	 * 说明：和分页分拣一样，但是应用场景不一样，主要是给查询导出的之类的功能使用
	 * @return
	 */
	public String getOrderMode(){
		String orderMode = getPara("orderMode");
		return orderMode;
	}
	

	/************************************		get 	set 	方法		************************************************/
	
	public SysLog getReqSysLog() {
		return reqSysLog;
	}

	public void setReqSysLog(SysLog reqSysLog) {
		this.reqSysLog = reqSysLog;
	}

	public void setSplitPage(SplitPage splitPage) {
		this.splitPage = splitPage;
	}
	
	/**系统当前登录人 **/
	public Record getAccount(){
		return getSessionAttr("account_session");
	}

	/**系统当前登录人ID **/
	public Integer getSysuserId(){
		Record sysuser = getAccount();
		if(sysuser==null)
			return null;
		else
			return sysuser.getInt("id");
	}
	
	/**系统当前登录人  的 校区 id 组 , 逗号分割 **/
	public String getAccountCampus(){
		Record sysuser = getAccount();
		if(sysuser==null)
			return null;
		else{
			String campusids = sysuser.getStr(AccountCampus.SESSION_ACCOUNTCAMPUSIDS);
			if(campusids == null){
				campusids = AccountCampus.dao.getCampusIdsByAccountId(sysuser.getInt("id"));
				if(campusids != null)
					sysuser.set(AccountCampus.SESSION_ACCOUNTCAMPUSIDS, campusids);
			}
			return campusids;
		}
	}
	
	/**系统当前登录人的角色id > roleids  **/
	public String getAccountRoleids(){
		Record sysuser = getAccount();
		if(sysuser != null)
			return sysuser.getStr("roleids");
		else
			return null;
	}
	
	public boolean getIsEn(){
		String locale = getPara("_locale");
	       if (StrKit.notBlank(locale)) {	// change locale, write cookie
	        setCookie("_locale", locale, Const.DEFAULT_I18N_MAX_AGE_OF_COOKIE);
	       } else {	 // get locale from cookie and use the default locale if it is null
	        locale = getCookie("_locale");
	        if (StrKit.isBlank(locale))
	         locale = Locale.getDefault().getLanguage() + "_" + Locale.getDefault().getCountry();
	       }
	       if(locale.equals("en_US"))
	       return true;
	       else
	       return false;
	}
	
	public Res getRes(){
		String locale = getCookie( "_locale" );
		if(StrKit.notBlank(locale)){
			return I18n.use( (String) PropertiesPlugin.getParamMapValue( DictKeys.basename ) , getCookie( "_locale" ) );
		}else{
			return I18n.use( (String) PropertiesPlugin.getParamMapValue( DictKeys.basename ) , "zh_CN");
		}
	}
	
	
}
