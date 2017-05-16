
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

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Page;
import com.momathink.common.constants.DictKeys;

/**
 * 分页封装
 * @author David
 */
public class SplitPage implements Serializable {

	private static final long serialVersionUID = -7914983945613661637L;
	
	// 分页查询参数
	protected Map<String, String> queryParam;// 查询条件
	protected String orderColunm;// 排序条件
	protected String orderMode;// 排序方式
	protected int pageNumber = DictKeys.default_pageNumber;// 第几页
	protected int pageSize = DictKeys.default_pageSize;// 每页显示几多
	
	// jfinal数据库分页相关
	protected Page<?> page;
	
	// lucene分页相关
	protected List<?> list;				// list result of this page
	protected int totalPage;			// total page
	protected int totalRow;				// total row

	// 辅助分页属性
	protected int currentPageCount;// 当前页记录数量
	protected boolean isFirst;// 是否第一页
	protected boolean isLast;// 是否最后一页
	
	/**
	 * 分页计算
	 */
	public void compute() {
		getTotalPage();

		this.currentPageCount = this.list.size();// 当前页记录数

		if (pageNumber == 1) {
			this.isFirst = true;
		} else {
			this.isFirst = false;
		}

		if (pageNumber == totalPage) {
			this.isLast = true;
		} else {
			this.isLast = false;
		}
	}

	public int getTotalPage() {
		if ((this.totalRow % this.pageSize) == 0) {
			this.totalPage = this.totalRow / this.pageSize;// 计算多少页
		} else {
			this.totalPage = this.totalRow / this.pageSize + 1;// 计算多少页
		}
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getTotalRow() {
		return totalRow;
	}
	public void setTotalRow(int totalRow) {
		this.totalRow = totalRow;
	}
	public List<?> getList() {
		return list;
	}
	public void setList(List<?> list) {
		this.list = list;
	}
	public Page<?> getPage() {
		return page;
	}
	public void setPage(Page<?> page) {
		this.page = page;
	}
	public Map<String, String> getQueryParam() {
		return queryParam;
	}
	public void setQueryParam(Map<String, String> queryParam) {
		this.queryParam = queryParam;
	}
	public String getOrderColunm() {
		return orderColunm;
	}
	public void setOrderColunm(String orderColunm) {
		this.orderColunm = orderColunm;
	}
	public String getOrderMode() {
		return orderMode;
	}
	public void setOrderMode(String orderMode) {
		this.orderMode = orderMode;
	}
	public int getPageNumber() {
		if(pageNumber <= 0){
			pageNumber = DictKeys.default_pageNumber;
		}
		return pageNumber;
	}
	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}
	public int getPageSize() {
		if(pageSize <= 0){
			pageSize = DictKeys.default_pageSize;
		}
		if(pageSize > 200){
			pageSize = DictKeys.default_pageSize;
		}
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	
}
