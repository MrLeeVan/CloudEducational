
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

package com.momathink.teaching.grade.model;

import java.util.List;

import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
@Table(tableName="fenzhi1")//关联到数据库的表
public class FenZhi extends BaseModel<FenZhi> {
	private static final long  serialVersionUID = 7996762001003047294L;
	//创建数据库表对象
	public static FenZhi dao=new FenZhi();
	/**
	 * 获取表所有的数据
	 */
	public List<FenZhi> findAllFenZhiTableOne(){
		return dao.find("select * from fenzhi1 where type = 0");
	}
	public List<FenZhi> findAllFenZhiTable(){
		return dao.find("select * from fenzhi1 where type = 1");
	}
	//根据类型和课程原值查找数据对象
		public FenZhi levelAndCourseValueFindToScorce(double courseYuanzhi,String level){
			return dao.findFirst("select * from fenzhi1 where yuanzhi = ? and type=?",courseYuanzhi,level );
		}
}
