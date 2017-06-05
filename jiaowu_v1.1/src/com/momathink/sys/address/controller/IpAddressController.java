
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
package com.momathink.sys.address.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.address.model.IpAddress;
import com.momathink.sys.address.service.IpAddressService;
import com.momathink.teaching.campus.model.Campus;
@Controller(controllerKey="/address")
public class IpAddressController extends BaseController {
	/**
	 * 
	 */
	private static final Logger logger = Logger.getLogger(IpAddress.class);
	private IpAddressService ipAddressService = new IpAddressService();

	/**
	 * 查询所有的ip地址
	 * */
	public void getAllIpAdress() {
		try {
			Map<String,String> queryParam = splitPage.getQueryParam();
			if(!StringUtils.isEmpty(getPara("ipaddress"))){
				queryParam.put("name", getPara("ipaddress").toString());
			}
			queryParam.put( "loginRoleCampusIds", getAccountCampus() );
			splitPage.setOrderMode("desc");
			ipAddressService.list(splitPage);
			setAttr("showPages", splitPage.getPage());
			renderJsp("/ipaddress/ipaddress_list.jsp");
		} catch (Exception e) {
			logger.error("在IpAddressController的getAllIpAdress出现" + e);
			e.printStackTrace();
		}
	}

	/**
	 * 添加ip地址
	 * */
	public void createIpAddress() {
		JSONObject json = new JSONObject();
		String code="0";
		String msg="添加失败！";
		try {
			String ipAddress = getPara("ip");
			int campuid=getParaToInt("campusid");
			IpAddress saveIpaddress = getModel(IpAddress.class);
			saveIpaddress.set("campus_id", campuid);
			saveIpaddress.set("name", ipAddress);
			saveIpaddress.set("create_time", new Date());
			if(saveIpaddress.save()){
				code="1";
				msg="添加成功！";
			}
		} catch (Exception e) {
			logger.equals("IpAddressController下的createIpAddress出现" + e);
			e.printStackTrace();
		}
		json.put("code", code);
		json.put("msg", msg);
		renderJson(json);
	}

	/**
	 * 删除id地址
	 * */
	public void delIpAddress() {
		try {
			int ipaddressId = getParaToInt("ipaddressId");
			ipAddressService.deleteByRecordId(ipaddressId);
			getAllIpAdress();
		} catch (Exception e) {
			logger.equals("IpAddressController下的delIpAddress出现" + e);
			e.printStackTrace();
		}
	}

	/**
	 * 修改IpAddress地址
	 * */
	public void updateIpAddress() {
		JSONObject json = new JSONObject();
		String code="0";
		String msg="修改失败！";
		try {
			int ipaddressId = getParaToInt("ipaddressId");
			String name = getPara("name");
			int campusid=getParaToInt("campusid");
			String.format("yyyy-mm-dd", new Date());
			IpAddress updateIpaddress = getModel(IpAddress.class);
			updateIpaddress.set("name", name);
			updateIpaddress.set("create_time", new Date());
			updateIpaddress.set("id", ipaddressId);
			updateIpaddress.set("campus_id", campusid);
			if(updateIpaddress.update()){
				code="1";
				msg="修改成功！";
			}
		} catch (Exception e) {
			logger.equals("IpAddressController下的updateAddress出现" + e);
			e.printStackTrace();
		}
		json.put("code", code);
		json.put("msg",msg);
		renderJson(json);
	}

	/**
	 * 通过id获取IdAddress地址
	 * 
	 * */
	public void getIpaddressById() {
		try {
			List<Campus> campus = Campus.dao.getCampusByLoginUser( getSysuserId() );
	        setAttr("campus", campus);
	        int ipaddressId=Integer.parseInt(getPara());
			String sql = "select * from ipaddress where Id =" + ipaddressId;
			Record ipaddress = Db.findFirst(sql);
			setAttr("ipaddress", ipaddress);
			renderJsp("/ipaddress/ipaddress_edit.jsp");
		} catch (Exception e) {
			logger.equals("IpAddressController下的getIpAddressById出现" + e);
			e.printStackTrace();
		}
	}
	/**
	 * 获取所有校区
	 */
    public void getAllCampus(){
    	try {
        List<Campus> campus = Campus.dao.getCampusByLoginUser( getSysuserId() );
        setAttr("campus", campus);
    	renderJsp("/ipaddress/apaddress_add.jsp");
    	} catch (Exception e) {
			logger.equals("IpAddressController下的getAllCampus出现" + e);
			e.printStackTrace();
		}
    }
}
