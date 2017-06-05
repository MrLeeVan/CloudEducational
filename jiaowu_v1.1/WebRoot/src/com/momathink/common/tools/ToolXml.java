

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

package com.momathink.common.tools;

import java.io.Writer;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.core.util.QuickWriter;
import com.thoughtworks.xstream.io.HierarchicalStreamWriter;
import com.thoughtworks.xstream.io.xml.DomDriver;
import com.thoughtworks.xstream.io.xml.PrettyPrintWriter;
import com.thoughtworks.xstream.mapper.MapperWrapper;

public class ToolXml {
	
	/**
	 * 获取XStream对象
	 * @return
	 */
	public static XStream getXStream() {
		//在文本前后加上<![CDATA[和]]>
		DomDriver domDriver = new DomDriver() {
			public HierarchicalStreamWriter createWriter(Writer out) {
				return new PrettyPrintWriter(out) {
					protected void writeText(QuickWriter writer, String text) {
						if (text.startsWith("<![CDATA[") && text.endsWith("]]>")) {
							writer.write(text);
						} else {
							//super.writeText(writer, text);
							super.writeText(writer, "<![CDATA[" + text + "]]>");
						}
					}
				};
			};
		};
		
		//去除XML属性在JavaBean中映射不到属性值的异常
		XStream xStream = new XStream(domDriver){       
			protected MapperWrapper wrapMapper(MapperWrapper next) {                 
				return new MapperWrapper(next) {
					@SuppressWarnings("rawtypes")
					public boolean shouldSerializeMember(Class definedIn, String fieldName) {                      
						if (definedIn == Object.class) {                     
							try {                      
								return this.realClass(fieldName) != null;                      
							} catch(Exception e) {                      
								return false;                      
							}                      
						} else {                             
							return super.shouldSerializeMember(definedIn, fieldName);                         
						}                     
					}                 
				};            
			}         
		};

		return xStream;
	}

	/**
	 * 获取xml一级节点文本值，不区分元素名称大小写
	 * @param xml
	 * @param element
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static String getStairText(String xml, String elementName){
		elementName = elementName.toLowerCase();
		String result = null;
		try {
			Document doc = DocumentHelper.parseText(xml);
			Element root = doc.getRootElement();
			for(Iterator iterTemp = root.elementIterator(); iterTemp.hasNext();) {	
				Element element = (Element) iterTemp.next();	
				if(element.getName().toLowerCase().equals(elementName)){
					result = element.getText();
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 把xml转bean对象
	 * @param xml
	 * @param map
	 * @return
	 */
	public static Object xmlToBean(String xml, Map<String, Class<?>> map) {
		XStream xStream = getXStream();
		Set<String> keys = map.keySet();
		for (String key : keys) {
			xStream.alias(key, map.get(key));
		}
		return xStream.fromXML(xml);
	}
	
	/**
	 * bean对象转xml
	 * @param bean
	 * @return
	 */
	/*public static String beanToXml(Object bean){
		XStream xStream = getXStream();
		xStream.alias("xml",ResponseMsgText.class);
		String content = xStream.toXML(bean);
		content = content.replaceAll("&lt;", "<");// <
		content = content.replaceAll("&gt;", ">");// >
		return content;
	}*/
	
	/*public static void main(String[] args) {
		String xml = "<xml>";
		xml += "<URL><![CDATA[http://littleant.duapp.com/msg]]></URL>";
		xml += "<ToUserName><![CDATA[jiu_guang]]></ToUserName>";
		xml += "<FromUserName><![CDATA[dongcb678]]></FromUserName>";
		xml += "<CreateTime>11</CreateTime>";
		xml += "<MsgType><![CDATA[text\\//]]></MsgType>";
		xml += "<Content><![CDATA[wentest]]></Content>";
		xml += "<MsgId>11</MsgId>";
		xml += "</xml>";

		Map<String, Class<?>> map = new HashMap<String, Class<?>>();
		map.put("xml", RecevieMsgText.class);
		RecevieMsgText recevie = (RecevieMsgText) xmlToBean(xml, map);
		System.out.println(recevie.getToUserName());
		System.out.println(recevie.getFromUserName());
		System.out.println(recevie.getMsgType());
		
		System.out.println(beanToXml(recevie));
	}*/
	

}