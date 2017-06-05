
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

import java.lang.reflect.Field;
import java.util.Set;

import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Table;
import com.jfinal.plugin.activerecord.TableMapping;

/**
 * Model基础类
 * 
 * @author David Wang
 * @param <M>
 */
public abstract class BaseModel<M extends Model<M>> extends Model<M> {

	private static final long serialVersionUID = -900378319414539856L;

	private static Logger log = Logger.getLogger(BaseModel.class);
	
	
	/**
	 * 获取表映射对象
	 * 
	 * @return
	 */
	public Table getTable() {
		return TableMapping.me().getTable(getClass());
	}

	/**
	 * 获取主键值
	 * @return
	 */
	public Integer getPrimaryKeyValue(){
		return this.getInt(getTable().getPrimaryKey()[0]);
	}

	/**
	 * 重写save方法
	 */
	public boolean save() {
		if(getTable().hasColumnLabel("version")){ // 是否需要乐观锁控制
			this.set("version", Long.valueOf(0)); // 初始化乐观锁版本号
		}
		return super.save();
	}

	/**
	 * 重写update方法
	 */
	@SuppressWarnings("unchecked")
	public boolean update() {
		Table table = getTable();
		String name = table.getName();
		String pk = table.getPrimaryKey()[0];
		
		// 1.数据是否还存在
		String sql = new StringBuilder("select * from ").append(name).append(" where ").append(pk).append(" = ? ").toString();
		Model<M> modelOld = findFirst(sql , getInt("id"));
		if(null == modelOld){ // 数据已经被删除
			throw new RuntimeException("数据库中此数据不存在，可能数据已经被删除，请刷新数据后在操作");
		}
		
		// 2.乐观锁控制
		Set<String> modifyFlag = null;
		try {
			Field field = this.getClass().getSuperclass().getSuperclass().getDeclaredField("modifyFlag");
			field.setAccessible(true);
			Object object = field.get(this);
			if(null != object){
				modifyFlag = (Set<String>) object;
			}
			field.setAccessible(false);
		} catch (NoSuchFieldException | SecurityException e) {
			log.error("业务Model类必须继承BaseModel");
			e.printStackTrace();
			throw new RuntimeException("业务Model类必须继承BaseModel");
		} catch (IllegalArgumentException | IllegalAccessException e) {
			log.error("BaseModel访问modifyFlag异常");
			e.printStackTrace();
			throw new RuntimeException("BaseModel访问modifyFlag异常");
		}
		boolean versionModify = modifyFlag.contains("version");
		if(versionModify && getTable().hasColumnLabel("version")){ // 是否需要乐观锁控制
			int versionDB = modelOld.getNumber("version")==null?0:modelOld.getNumber("version").intValue(); // 数据库中的版本号
			int versionForm = getNumber("version").intValue(); // 表单中的版本号
			if(versionForm <= versionDB){
				throw new RuntimeException("表单数据版本号和数据库数据版本号不一致，可能数据已经被其他人修改，请重新编辑");
			}
		}
		return super.update();
	}
	
	/**get值 .toString() */
	public String toGetStr(String key) {
		Object val = get(key); 
		return val==null ? "":val.toString();
	}

}
