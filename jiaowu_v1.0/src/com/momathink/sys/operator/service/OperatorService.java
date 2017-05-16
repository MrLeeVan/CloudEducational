
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

package com.momathink.sys.operator.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.sys.operator.model.Icon;
import com.momathink.sys.operator.model.Module;
import com.momathink.sys.operator.model.Operator;
import com.momathink.sys.operator.model.Role;
import com.momathink.sys.operator.model.Systems;
import com.momathink.sys.system.model.SysUser;

/** 系统管理   
 * */
public class OperatorService extends BaseService {
	
	public void treelist(SplitPage splitPage) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer select = new StringBuffer(" SELECT o.id, o.names,o.modulenames, o.url, o.rowFilter, o.splitPage, o.formToken, o.privilege, o.formaturl " );
		StringBuffer formSql = new StringBuffer("FROM pt_operator o WHERE 1=1 ");
		
		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "names":
				formSql.append(" and o.names like '%").append(value).append("%'");
				break;
			case "url":
				formSql.append(" and o.url like '%").append(value).append("%'");
				break;
			case "privilege":
				formSql.append(" and o.privilege = ").append(value);
				break;
			default:
				break;
			}
		}
		formSql.append(" order by moduleids");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		/*List<Record> list = page.getList();
		for (Record r : list) {
			r.set("ypksvip", CoursePlan.coursePlan.findFirst("SELECT IFNULL(SUM(t.class_hour),0) ypksvip FROM courseplan cp LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id  "
					+ " WHERE cp.STATE=0 AND cp.PLAN_TYPE=0 AND cp.class_id=0 AND cp.STUDENT_ID= " + r.getInt("Id")).get("ypksvip"));
			r.set("ypksxb", CoursePlan.coursePlan.findFirst("SELECT IFNULL(SUM(t.class_hour),0) ypksxb FROM courseplan cp LEFT JOIN time_rank t ON cp.TIMERANK_ID=t.Id "
				+ " WHERE cp.STATE=0 AND cp.PLAN_TYPE=0 AND cp.class_id!=0 AND cp.STUDENT_ID= " + r.getInt("Id")).get("ypksxb"));
			String kyksvip = r.getDouble("kyksvip")==null?"0":r.getDouble("kyksvip").toString();
			String ypksvip = r.getBigDecimal("ypksvip")==null?"0":r.getBigDecimal("ypksvip").toString();
			String kyksxb = r.getDouble("kyksxb")==null?"0":r.getDouble("kyksxb").toString();
			String ypksxb = r.getBigDecimal("ypksxb")==null?"0":r.getBigDecimal("ypksxb").toString();
			r.set("kyksvip", ToolString.subZeroAndDot(kyksvip));
			r.set("ypksvip", ToolString.subZeroAndDot(ypksvip));
			r.set("kyksxb", ToolString.subZeroAndDot(kyksxb));
			r.set("ypksxb", ToolString.subZeroAndDot(ypksxb));
		}*/
		splitPage.setPage(page);
	}

	public void roleList(SplitPage splitPage) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer select = new StringBuffer(" SELECT r.* " );
		StringBuffer formSql = new StringBuffer("FROM pt_role r ");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		splitPage.setPage(page);
		
	}
	
	/** 角色选择拥有 功能 */
	public String getTreeData(Integer id){
		StringBuffer sb = new StringBuffer();
		try{
			Role role  = Role.dao.findById(id);
			String[] rolemoduleids = null;
			if(role.getStr("moduleids")!=null){
				rolemoduleids = role.getStr("moduleids").split(",");
			}
			String[] roleoperatorids = null;
			if(role.getStr("operatorids")!=null){
				roleoperatorids = role.getStr("operatorids").split(",");
			}
			List<Systems> syslist = Systems.dao.queryAll();
			String sqlop = "SELECT po.id,po.names,po.moduleids from pt_operator po where po.privilege = 1";
			List<Operator> oplist = Operator.dao.find(sqlop);
			String sqlmu = "SELECT pm.id,pm.names,pm.parentmoduleids,pm.systemsids,ps.names as psnames from pt_module pm left join pt_systems ps on ps.id = pm.systemsids ";
			List<Module> molist = Module.dao.find(sqlmu);
			sb.append("[").append("\n");
			for(Systems sys:syslist){
				sb.append("{ id :'").append("sys_").append(sys.getInt("id")).append("', pId :'").append("0").append("', name:'").append(sys.getStr("names")).append("',title:''");
				sb.append(",open:true").append("}").append(", ").append("\n");
			}
			for(Operator op:oplist){
				sb.append("{ id :'").append("operator_").append(op.getInt("id")).append("', pId :'").append("module_").append(op.getStr("moduleids").equals(null)?0:op.getStr("moduleids")).append("', name:'").append(op.getStr("names")).append("',title:''");
				if(roleoperatorids != null){
					circle:for(String oper:roleoperatorids){
						if(oper.replace("operator_", "").equals(op.getInt("id").toString())){
							sb.append(", checked:true, open:true");
							break circle;
						}
					}
					
				}
				sb.append("}").append(", ").append("\n");
			}
			int pmSize = molist.size();
			int pmIndexSize = pmSize - 1;
			for(Module pm:molist){
				sb.append("{ id :'").append("module_").append(pm.getInt("id")).append("', pId :'");
				if(pm.getStr("parentmoduleids")==null){
					sb.append("sys_").append(pm.getStr("systemsids"));
				}else{
					sb.append("module_").append(pm.getStr("parentmoduleids"));
				}
				sb.append("', name:'").append(pm.getStr("names")).append("',title:''");
				if(rolemoduleids != null){
					circle:for(String module:rolemoduleids){
						if(module.replace("module_", "").equals(pm.getInt("id").toString())){
							sb.append(", checked:true, open:true");
							break circle;
						}
					}
					
				}
				sb.append("}");
				if (molist.indexOf(pm) < pmIndexSize) {
					sb.append(", ").append("\n");
				}
			}
			sb.append("\n").append("]");
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return sb.toString();
	}
	
	/** 角色分组  */
	public void groupList(SplitPage splitPage) {
		List<Object> paramValue = new ArrayList<Object>();
		String select = " SELECT g.* ";
		String formSql = "FROM pt_group g ";
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select, formSql, paramValue.toArray());
		splitPage.setPage(page);
	}
	
	/**
	 * 获取已有的角色  和未有的角色
	 * @param ids
	 * @return
	 */
	public Map<String, Object> queryGroupRolesSelect(String ids) {
		List<Role> noCheckedList = new ArrayList<Role>();
		List<Role> checkedList = new ArrayList<Role>();
		SysUser user = SysUser.dao.findById(ids);
		String roleIds = user.get("roleids")==null?"":user.getStr("roleids");
		if(!StringUtils.isEmpty(roleIds)){
			String fitler = toSql(roleIds);
			StringBuffer sbnot = new StringBuffer("SELECT id, names from pt_role where id not in (" ).append(fitler).append(" ) order by names asc");
			StringBuffer sbin = new StringBuffer("SELECT id, names from pt_role where id in (" ).append(fitler).append(" ) order by names asc");
			noCheckedList = Role.dao.find(sbnot.toString());
			checkedList = Role.dao.find(sbin.toString());
		}else{
			noCheckedList = Role.dao.find("SELECT id,names from pt_role order by names desc");
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("noCheckedList", noCheckedList);
		map.put("checkedList", checkedList);
		return map;
	}

	/** 模块列表 **/
	public void modulist(SplitPage splitPage) {
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer select = new StringBuffer(" SELECT m.*,f.names parentnames ");
		StringBuffer formSql = new StringBuffer(
				  "FROM pt_module m "
				+ "LEFT JOIN pt_module f on f.id = m.parentmoduleids "
				+ "WHERE 1=1 ");

		Map<String,String> queryParam = splitPage.getQueryParam();
		Set<String> paramKeySet = queryParam.keySet();
		for (String paramKey : paramKeySet) {
			String value = queryParam.get(paramKey);
			switch (paramKey) {
			case "names":
				formSql.append(" AND m.names LIKE '%").append(value).append("%'");
				break;
			case "parentnames":
				List<Module> modulelist = Module.dao.find("SELECT id FROM pt_module WHERE names LIKE '%"+value+"%'");
				if(modulelist.size()>0){
					StringBuffer fasb = new StringBuffer();
					String str = "";
					for(Module module:modulelist){
						str = fasb.append(",\"").append(module.getInt("id")).append("\"").toString().replaceFirst(",", "");
					}
					formSql.append(" AND m.parentmoduleids in ("+str+")");
				}
				break;
			default:
				break;
			}
		}
		formSql.append(" ORDER BY m.parentmoduleids");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		splitPage.setPage(page);
		
	}

	/** 保存模块  **/
	public boolean moduleSave(Module module, Integer sysuserid) {
		try {
			Module pamodule = Module.dao.findById(module.getStr("parentmoduleids"));
			Long max = Module.dao.queryByOrderidsMax();
			module.set("orderids", max+1);
			module.set("isparent", "false");
			if(module.get("iconid")!=null){
				Icon hp = Icon.dao.findById(module.getInt("iconid"));
				hp.set("state", 1).update();
			}
			boolean flag = module.save();
			List<Icon> list =  Icon.dao.queryBySysuserid(sysuserid);
			if(!list.isEmpty()){
				for(Icon h:list){
					File f = new File(h.getStr("url")); 
					f.delete();
					h.delete();
				}
			}
			if(flag&&pamodule!=null){
				pamodule.set("isparent", "true").update();
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/** 修改模块  */
	public boolean moduleUpdate(Module module, String moduleid, Integer sysuserid) {
		try {
			Module pamodule = Module.dao.findById(module.getStr("parentmoduleids"));
			if(module.get("iconid")!=null){
				Module s = Module.dao.findById(moduleid);
				if(s.get("iconid")!=null){
					Icon hp = Icon.dao.findById(s.getInt("iconid"));
					hp.set("state", 0).update();
				}
				Icon hp = Icon.dao.findById(module.getInt("iconid"));
				hp.set("state", 1).update();
			}
			boolean flag = module.update();
			List<Icon> list =  Icon.dao.queryBySysuserid(sysuserid);
			if(!list.isEmpty()){
				for(Icon h:list){
					File f = new File(h.getStr("url")); 
					f.delete();
					h.delete();
				}
			}
			if(flag&&pamodule!=null){
				pamodule.set("isparent", "true").update();
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/** 删除模块 **/
	public String deleteModule(String id) {
		String msg = "删除成功";
		boolean flag = false;
		Module module = Module.dao.findById(id);
		if(module==null){
			msg = "该模块已经不存在";
		}else{
			List<Module> childmodule = Module.dao.queryByParentmoduleids(id);
			if(childmodule.size()>0){
				msg = "该模块有子类模块，不能删除.";
			}else{
				if(childmodule.size()==0){
					List<Operator> childoperator = Operator.dao.queryByModuleids(id);
					if(childoperator.size()>0){
						msg="该模块下有使用功能，不可删除.";
					}else{
						flag = Module.dao.deleteById(id);
					}
				}
			}
			if(flag){
				msg = "删除成功.";
			}
		}
		return msg;
	}

	/**
	 *  删除 功能 
	 * @param id
	 * @return  结果 提示 (开发人员 用 ,占 不做兼容 处理)
	 */
	public String deleteThisOperator(String id) {
		String msg = "删除未成功!";
		if (StrKit.notBlank(id)) {
			Operator operator = Operator.dao.findById(id);
			if(operator==null){
				msg = "该uri信息不存在.";
			}else{
				if(operator.delete()){
					//剔除 角色 里面 存的  拥有功能id
					try{
						List<Role> roleList = Role.dao.find("SELECT * from pt_role where operatorids is not null ");
						for(Role role:roleList){
							String str = role.getStr("operatorids");
							if(!StringUtils.isEmpty(str)){
								if(str.indexOf(("operator_"+id+","))!=-1){
									role.set("operatorids", str.replace(("operator_"+id+","), "")).update();
								}
							}
						}
						msg = "删除成功.";
					}catch(Exception ex){
						ex.printStackTrace();
						msg = "剔除 角色管理  里的  拥有功能 异常";
					}
				}
			}
		}
		return msg;
	}
	
	/** 删除 角色 <br>
	 * 根据ID判断角色是否已被使用
	 * @param 角色id
	 * @return
	 */
	public String deleteThisRole(String id) {
		String msg = "角色已被使用，不能删除";
		List<SysUser>  userList = SysUser.dao.queryAllRoleids();
		boolean flag =true;
		String indexOfid = ","+id+",";
		for(SysUser user :userList){
			if((","+user.getStr("roleids")).indexOf(indexOfid) != (-1) ){
				flag =false;
				break;
			}
		}
		if(flag){
			Role role = Role.dao.findById(id);
			role.delete();
			msg = "删除成功";
		}
		return msg;
	}

	
		

}
