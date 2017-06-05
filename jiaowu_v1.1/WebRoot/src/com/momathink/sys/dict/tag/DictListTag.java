
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

package com.momathink.sys.dict.tag;

import java.io.IOException;
import java.util.List;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

import com.jfinal.kit.StrKit;
import com.momathink.sys.dict.model.Dict;

/** 字典 集合
 * <br>
 使用 方法:
 页面引人 
 <%@taglib prefix="dt" uri="/WEB-INF/classes/com/momathink/sys/dict/tag/jfinal.tld"%>
 
 <:dt ...Alt + / 
 */
public class DictListTag extends TagSupport {

	private static final long serialVersionUID = -3647113162613485011L;

	/***字典的编码*/
	private String numbers;
	/***页面控件的type*/
    private String type;
    /***页面控件的id*/
    private String id;
    /***页面控件的name*/
    private String name;
    /***页面控件的class*/
    private String class_;
    /***页面控件的style*/
    private String style;
    /***页面控件的change 事件*/
    private String changefuc;
    /***页面控件 回填的值*/
    private String defaultnumber;
    
    public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type!=null?type:"";
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id!=null?id:"";
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name!=null?name:"";
	}

	public String getClass_() {
		return class_;
	}

	public void setClass_(String class_) {
		this.class_ = class_!=null?class_:"";
	}

	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style!=null?style:"";
	}

	public String getChangefuc() {
		return changefuc;
	}

	public void setChangefuc(String changefuc) {
		this.changefuc = changefuc!=null?changefuc:"";
	}

	public String getNumbers() {
		return numbers;
	}

	public void setNumbers(String numbers) {
		this.numbers = numbers!=null?numbers:"";
	}

	public String getDefaultnumber() {
		return defaultnumber;
	}

	public void setDefaultnumber(String defaultnumber) {
		this.defaultnumber = defaultnumber!=null?defaultnumber:"";
	}

	public int doStartTag() throws JspException {
    	try {
			if(type.equals("")){
				pageContext.getOut().write(select(id, name, class_, style,  numbers, defaultnumber));
				
			}else if(type.equals("selectall")){
				pageContext.getOut().write(selectall(id, name, class_, style,  numbers, defaultnumber));
				
			}else if(type.equals("select")){
				pageContext.getOut().write(select(id, name, class_, style,  numbers, defaultnumber));
				
			}else if(type.equals("selectchange")){
				pageContext.getOut().write(selectchange(id, name, class_, style, changefuc, numbers, defaultnumber));
				
			}else if(type.equals("selectchangeitems")){
				pageContext.getOut().write(selectchangeitem(id, name, class_, style, changefuc, numbers, defaultnumber));
				
			}else if(type.equals("selectchosen")){
				pageContext.getOut().write(selectchosen(id, name, class_, style,  numbers, defaultnumber));
				
			}else if(type.equals("radio")){
				pageContext.getOut().write(radio(id, name, class_, style, numbers, defaultnumber));
				
			}else if(type.equals("checkbox")){
				pageContext.getOut().write(checkbox(id, name, class_, style, numbers, defaultnumber));
				
			}else if(type.equals("languagebutton")){
				pageContext.getOut().write(languageButton(id, name, class_, style, numbers));
				
			} else {
				pageContext.getOut().write(select(id, name, class_, style,  numbers, defaultnumber));
			}
			
		} catch (IOException e) {
            return Tag.SKIP_BODY;
        }
        return Tag.EVAL_BODY_INCLUDE;
    }
 
	/**
	 * 多选
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String selectchosen(String id, String name, String class_, String style, String number, String defaultnumber) {

		StringBuilder sb = new StringBuilder();
		if (StrKit.notBlank(id)) {
			sb.append("<select data-placeholder='请选择' id='").append(id);
		}else{
			sb.append("<select data-placeholder='请选择");
		}
		sb.append("' name='").append(name).append("' class='").append(class_).append("' multiple style='").append(style);
		sb.append("' >");
		

		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
			//String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
//			if(null != parentI18n && parentI18n.equals("1")){
//				String localePram = (String) ctx.getGlobal("localePram");
//				val += I18NPlugin.i18n(localePram);
//			}
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				
				if(null == state || state.equals(0)){
					continue;
				}
				
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append("<option value='").append(numbersTemp).append("' selected='selected'>");
					sb.append(valueTemp);
					sb.append("</option>");
					
				} else {
					sb.append("<option value='").append(numbersTemp).append("'>");
					sb.append(valueTemp);
					sb.append("</option>");
				}
			}
		}
		sb.append("</select>");
		
		return sb.toString();
	
	}
	
	/**
	 *  下拉标签 改变触发方法
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param changefuc
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String selectchangeitem(String id, String name, String class_, String style, String changefuc, String number, String defaultnumber) {
		StringBuilder sb = new StringBuilder();
		if (null != id && !id.isEmpty()) {
			sb.append("<select id='").append(id).append("' name='").append(name);
			sb.append("' class='").append(class_).append("' style='").append(style);
		} else {
			sb.append("<select name='").append(name).append("' class='").append(class_);
			sb.append("' style='").append(style);
		}
		sb.append("' ");
		if(StrKit.notBlank(changefuc)){
			sb.append(" onchange='").append(changefuc).append("'  ");
		}
		sb.append(" >");
		
		sb.append("<option value='' >请选择</option>");
		
		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
//			String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
			/*if(null != parentI18n && parentI18n.equals("1")){
				String localePram = (String) ctx.getGlobal("localePram");
				val += I18NPlugin.i18n(localePram);
			}*/
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				
				if(null == state || state.equals(0)){
					continue;
				}
				
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append("<option value='").append(numbersTemp).append("' selected='selected'>");
					sb.append(valueTemp);
					sb.append("</option>");
					
				} else {
					sb.append("<option value='").append(numbersTemp).append("'>");
					sb.append(valueTemp);
					sb.append("</option>");
				}
			}
		}
		sb.append("</select>");
		
		return sb.toString();
	}

	/**
	 *  下拉标签 改变触发方法
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param changefuc
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String selectchange(String id, String name, String class_, String style, String changefuc, String number, String defaultnumber) {
		StringBuilder sb = new StringBuilder();
		if (null != id && !id.isEmpty()) {
			sb.append("<select id='").append(id).append("' name='").append(name);
			sb.append("' class='").append(class_).append("' style='").append(style);
		} else {
			sb.append("<select name='").append(name).append("' class='").append(class_);
			sb.append("' style='").append(style);
		}
		sb.append("' ");
		if(StrKit.notBlank(changefuc)){
			sb.append(" onchange='").append(changefuc).append("()'  ");
		}
		sb.append(" >");
		
		sb.append("<option value='' >请选择</option>");

		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
//			String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
//			if(null != parentI18n && parentI18n.equals("1")){
//				String localePram = (String) ctx.getGlobal("localePram");
//				val += I18NPlugin.i18n(localePram);
//			}
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				
				if(null == state || state.equals(0)){
					continue;
				}
				
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append("<option value='").append(numbersTemp).append("' selected='selected'>");
					sb.append(valueTemp);
					sb.append("</option>");
					
				} else {
					sb.append("<option value='").append(numbersTemp).append("'>");
					sb.append(valueTemp);
					sb.append("</option>");
				}
			}
		}
		sb.append("</select>");
		
		return sb.toString();
	}

	/**
	 *  下拉标签  查询条件  第一个为全部
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String selectall(String id, String name, String class_, String style, String number, String defaultnumber) {
		StringBuilder sb = new StringBuilder();
		if (null != id && !id.isEmpty()) {
			sb.append("<select id='").append(id).append("' name='").append(name);
			sb.append("' class='").append(class_).append("' style='").append(style).append("' >");
		} else {
			sb.append("<select name='").append(name).append("' class='").append(class_);
			sb.append("' style='").append(style).append("' >");
		}
		
		sb.append("<option value='' >全部</option>");

		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
//			String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
//			if(null != parentI18n && parentI18n.equals("1")){
//				String localePram = (String) ctx.getGlobal("localePram");
//				val += I18NPlugin.i18n(localePram);
//			}
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				
				if(null == state || state.equals(0)){
					continue;
				}
				
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append("<option value='").append(numbersTemp).append("' selected='selected'>");
					sb.append(valueTemp);
					sb.append("</option>");
					
				} else {
					sb.append("<option value='").append(numbersTemp).append("'>");
					sb.append(valueTemp);
					sb.append("</option>");
				}
			}
		}
		sb.append("</select>");
		
		return sb.toString();
	
	}

	/**
	 * 下拉标签 添加时候  有请选择
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String select(String id, String name, String class_, String style,  String number, String defaultnumber){
		StringBuilder sb = new StringBuilder();
		if (null != id && !id.isEmpty()) {
			sb.append("<select id='").append(id).append("' name='").append(name);
			sb.append("' class='").append(class_).append("' style='").append(style);
		} else {
			sb.append("<select name='").append(name).append("' class='").append(class_);
			sb.append("' style='").append(style);
		}
		sb.append("' >");
		
		sb.append("<option value='' >请选择</option>");

		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
//			String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
//			if(null != parentI18n && parentI18n.equals("1")){
//				String localePram = (String) ctx.getGlobal("localePram");
//				val += I18NPlugin.i18n(localePram);
//			}
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				
				if(null == state || state.equals(0)){
					continue;
				}
				
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append("<option value='").append(numbersTemp).append("' selected='selected'>");
					sb.append(valueTemp);
					sb.append("</option>");
					
				} else {
					sb.append("<option value='").append(numbersTemp).append("'>");
					sb.append(valueTemp);
					sb.append("</option>");
				}
			}
		}
		sb.append("</select>");
		
		return sb.toString();
	}

	/**
	 * 单选
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String radio(String id, String name, String class_, String style, String number, String defaultnumber){
		StringBuilder sb = new StringBuilder();
		
		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
			
//			String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
//			if(null != parentI18n && parentI18n.equals("1")){
//				String localePram = (String) ctx.getGlobal("localePram");
//				val += I18NPlugin.i18n(localePram);
//			}
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				if(null == state || state.equals(0)){
					continue;
				}
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append("<input type='radio' id='").append(id).append(dictList.indexOf(dict)).append("' name='").append(name)
					.append("' value='").append(numbersTemp).append("' class='").append(class_).append("' style='").append(style).append("' checked='checked' >").append(valueTemp);
				} else {
					sb.append("<input type='radio' id='").append(id).append(dictList.indexOf(dict)).append("' name='").append(name)
					.append("' value='").append(numbersTemp).append("' class='").append(class_).append("' style='").append(style).append("' >").append(valueTemp);
				}
			}
		}
		
		return sb.toString();
	}

	/**
	 * 多选
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String checkbox(String id, String name, String class_, String style, String number, String defaultnumber){
		StringBuilder sb = new StringBuilder();
		
		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
			
//			String parentI18n = parentDict.getStr("i18n");
			
			String val = "val";
//			if(null != parentI18n && parentI18n.equals("1")){
//				String localePram = (String) ctx.getGlobal("localePram");
//				val += I18NPlugin.i18n(localePram);
//			}
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				if(null == state || state.equals(0)){
					continue;
				}
				if (null != defaultnumber && null != valueTemp && defaultnumber.equals(numbersTemp)) {// 默认选中
					sb.append(valueTemp).append("<input type='checkbox' id='").append(id).append(dictList.indexOf(dict)).append("' name='").append(name)
					.append("' value='").append(numbersTemp).append("' class='").append(class_).append("' style='").append(style).append("' checked='checked' >");
					
				} else {
					sb.append(valueTemp).append("<input type='checkbox' id='").append(id).append(dictList.indexOf(dict)).append("' name='").append(name)
					.append("' value='").append(numbersTemp).append("' class='").append(class_).append("' style='").append(style).append("' >");
				}
			}
		}
		
		return sb.toString();
	}
	
	/**
	 * 多选
	 * @param id
	 * @param name
	 * @param class_
	 * @param style
	 * @param number
	 * @param defaultnumber
	 * @return
	 */
	private String languageButton(String id, String name, String class_, String style, String number){
		StringBuilder sb = new StringBuilder();
		
		Dict parentDict = Dict.dao.cacheGet(number);
		if(parentDict!=null){
			String val = "val";
			List<Dict> dictList = Dict.dao.cacheGetChild(number);
			
			for (Dict dict : dictList) {
				Integer state = dict.getInt("state");
				String numbersTemp = dict.getStr("numbers");
				String valueTemp = dict.getStr(val);
				if(null == state || state.equals(0)){
					continue;
				}
				sb.append("<input type='button' id='").append(id).append(dictList.indexOf(dict)).append("' name='").append(name)
				.append("' value='").append(numbersTemp).append("' class='").append(class_).append("' style='").append(style).append("' onclick=\"chengeI18n(\'"+valueTemp+"\')").append("\" > &nbsp;");
			}
		}
		
		return sb.toString();
	}
}

