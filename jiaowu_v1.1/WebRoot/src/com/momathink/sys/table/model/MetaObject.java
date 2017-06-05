
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

package com.momathink.sys.table.model;

import java.util.Date;
import java.util.List;

import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

/**
*  元数据 
*  只做 查询 使用
 */
public class MetaObject {
	
	/** *系统 数据库名	 */
	public static final String db_connection_name_main = "";//PropertiesPlugin.getParamMapValue(DictKeys.db_connection_name_main).toString();
	
	public static final MetaObject dao = new MetaObject();

	/**
	 * 查询指定 数据库的表
	 * @param tableSchema 数据库名称
	 * <pre>
	字段名	数据库类型	长度 小数		字符集	字符集规程	键长
表目录	TABLE_CATALOG	varchar	512 0		utf8	utf8_general_ci	0
表模式	TABLE_SCHEMA	varchar	64 0		utf8	utf8_general_ci	0
表名	TABLE_NAME 	varchar	64 0		utf8	utf8_general_ci	0
表类型	TABLE_TYPE	varchar	64 0		utf8	utf8_general_ci	0
引擎	ENGINE	varchar	64-1		utf8	utf8_general_ci	0
版本	VERSION	bigint	21-1-10				0
行格式	ROW_FORMAT	varchar	10-1		utf8	utf8_general_ci	0
表中的行数	TABLE_ROWS	bigint	21-1-10				0
平均行的长度	AVG_ROW_LENGTH	bigint	21-1-10				0
数据长度	DATA_LENGTH	bigint	21-1-10				0
最大数据长度	MAX_DATA_LENGTH	bigint	21-1-10				0
索引的长度	INDEX_LENGTH	bigint	21-1-10				0
无数据	DATA_FREE	bigint	21-1-10				0
数据量	AUTO_INCREMENT	bigint	21-1-10				0
创建时间	CREATE_TIME	datetime0	-1				0
更新时间	UPDATE_TIME	datetime0	-1				0
检查时间	CHECK_TIME	datetime0	-1				0
表格整理	TABLE_COLLATION	varchar	32-1		utf8	utf8_general_ci	0
校验	CHECKSUM	bigint	21-1-10				0
创建选项	CREATE_OPTIONS	varchar	255-1		utf8	utf8_general_ci	0
注释	TABLE_COMMENT 	varchar	2048 0		utf8	utf8_general_ci	0
	 </pre>
     * @return 参考注释 
	 */
	public List<Record> queryTables(String tableSchema){
		return Db.find("SELECT * FROM information_schema.`TABLES` WHERE table_schema = ? ", tableSchema);
	}
	
	/**
	 *  查询  该表 
	 * @param tableSchema 数据库名称
	 * @param tableName 表名
	 * @return 有返回1,没有返回0
	 */
	public Long queryTablesTheCount(String tableSchema, String tableName){
		return Db.queryLong("SELECT COUNT(*) FROM information_schema.`TABLES` WHERE table_schema = ? AND TABLE_NAME = ? ", tableSchema, tableName);
	}
	
	/**
	 * 查询指定 数据库,指定 表,获取该表 的 列名 
	 * @param tableSchema 数据库名称
	 * @param tableName 表名
	 * <pre>
 	字段名	数据库类型	长度 小数		字符集	字符集规程	键长
表目录	TABLE_CATALOG	varchar	512 0		utf8	utf8_general_ci	0
表模式	TABLE_SCHEMA	varchar	64 0		utf8	utf8_general_ci	0
表名	TABLE_NAME 	varchar	64 0		utf8	utf8_general_ci	0
列名	COLUMN_NAME	varchar	64 0		utf8	utf8_general_ci	0
序号位置	ORDINAL_POSITION	bigint	210-1				0
列默认	COLUMN_DEFAULT	longtext0	-1		utf8	utf8_general_ci	0
可为空	IS_NULLABLE	varchar	3 0		utf8	utf8_general_ci	0
数据类型	DATA_TYPE	varchar	64 0		utf8	utf8_general_ci	0
字符的最大长度	CHARACTER_MAXIMUM_LENGTH	bigint	21-1-10				0
字符的字节长度	CHARACTER_OCTET_LENGTH	bigint	21-1-10				0
数值精度	NUMERIC_PRECISION	bigint	21-1-10				0
数字表	NUMERIC_SCALE	bigint	21-1-10				0
字符集名称	CHARACTER_SET_NAME	varchar	32-1		utf8	utf8_general_ci	0
排序规则名称	COLLATION_NAME	varchar	32-1		utf8	utf8_general_ci	0
数据类型(长度)	COLUMN_TYPE	longtext0	utf8	utf8_general_ci	0
主键	COLUMN_KEY	varchar	3 0		utf8	utf8_general_ci	0
外键	EXTRA	varchar	27 0		utf8	utf8_general_ci	0
权限	PRIVILEGES	varchar	80 0		utf8	utf8_general_ci	0
注释	COLUMN_COMMENT	varchar	1024 0		utf8	utf8_general_ci	0
	 * </pre>
	 *  * @return 参考注释 
	 */
	public List<Record> queryTablesTheColumns(String tableSchema, String tableName){
		return Db.find("SELECT * FROM information_schema.`columns` WHERE table_schema = ? AND TABLE_NAME = ? ", tableSchema, tableName);
	}
	
	/**
	 *  查询  该字段 
	 * @param tableSchema 数据库名称
	 * @param tableName 表名
	 * @param columnName 字段名
	 * @return 有返回1,没有返回0
	 */
	public Long queryTablesTheColumnsTheCount(String tableSchema, String tableName, String columnName) {
		return Db.queryLong("SELECT COUNT(*) FROM information_schema.`columns` WHERE table_schema = ? AND TABLE_NAME = ? AND COLUMN_NAME = ? ", tableSchema, tableName, columnName);
	}
	
	/**
	 * 查询主数据源 某表的一行  数据,请注意看sql
	 * @return
	 */
	public Record queryTableRow(String tableName, String field, String val){
		return Db.findFirst("SELECT * FROM " + tableName + " WHERE " + field + " = ? ", val);
	}
	
	/**数据库表  保存 
	 * @return 
	 */
	public boolean tableSave(String tableName, Record record) {
		if(null != record.get("version")){ // 是否需要乐观锁控制
			record.set("version", Long.valueOf(0)); // 初始化乐观锁版本号
		}
		if(null != record.get("createdate")){ // 是否需要系统添加时间
			record.set("createdate", new Date()); // 系统添加时间
		}
		return Db.save(tableName, record);
	}
	
	
	/**数据库表  修改 
	 * @return 
	 */
	public boolean tableUpdata(String tableName, Record record) {
		// 1.数据是否还存在
		Record modelOld = queryTableRow(tableName, "id", record.get("id").toString());
		if(null == modelOld){ // 数据已经被删除
			throw new RuntimeException("数据库中此数据不存在，可能数据已经被删除，请刷新数据后在操作");
		}
		// 2.乐观锁控制
		String versionForms = record.get("version");// 表单中的版本号
		if(StrKit.notBlank(versionForms)){ // 是否需要乐观锁控制
			long versionDB = modelOld.getLong("version");// 数据库中的版本号 
			long versionForm = Long.parseLong(versionForms);
			if(versionForm < versionDB){
				throw new RuntimeException("表单数据版本号和数据库数据版本号不一致，可能数据已经被其他人修改，请重新编辑");
			}
			record.set("version", versionForm+1); // 乐观锁版本号+1
		}
		if(null != record.get("updatedate")){ // 是否需要系统更新时间
			record.set("updatedate", new Date()); // 系统更新时间
		}
		return Db.update(tableName, record);
	}
	
	/**
	 * 公共删除
	 * @param tableName 表名
	 * @param records 对象里面必须有id 字段
	 * @return 行数
	 */
	public int delete(String tableName, Record... records) {
		if(null != tableName && null != records && records.length>0){
			String sql = "DELETE FROM " + tableName + " WHERE id IN (";
			for (Record id : records) {
				sql = sql + id.get("id") + ",";
			}
			return Db.update(sql.substring(0, sql.length() - 1) + ")");
		}
		return 0;
	}
	
	/**
	 * 公共删除
	 * @param tableName 表名
	 * @param records 对象里面必须有id 字段
	 * @return 行数
	 */
	public int delete(String tableName, String... records) {
		if(null != tableName && null != records && records.length>0){
			String sql = "DELETE FROM " + tableName + " WHERE id IN (";
			for (String id : records) {
				sql = sql + id + ",";
			}
			return Db.update(sql.substring(0, sql.length() - 1) + ")");
		}
		return 0;
	}
	
	/**
	 * 公共删除
	 * @param tableName 表名
	 * @param records 对象里面必须有id 字段
	 * @return 行数
	 */
	public int delete(String tableName, List<Record> records) {
		if(null != records && records.size() >0)
			return delete(tableName, records.toArray(new Record[records.size()]));
		return 0;
	}
	
	/**
	 * 公共 查重   
	 * @param tableName 表名
	 * @param columnName 列名
	 * @param columnNameVal 列值
	 * @param ExcludeId 排除id值 
	 * @return 0 = 没有 , 1或大于1 = 有 
	 */
	public long queryCheckExcludeId(String tableName, String columnName, String columnNameVal, String ExcludeId){
		if(StrKit.notBlank(tableName, columnName, columnNameVal)){
			String sql = "SELECT count(*) FROM " + tableName + " WHERE " + columnName + " = ?";
			if(StrKit.isBlank(ExcludeId))
				return Db.queryLong(sql, columnNameVal);
			else{
				sql = sql + " AND id != ?";
				return Db.queryLong(sql, columnNameVal, ExcludeId);
			}
		}
		return 0;
	}
	
	

}
