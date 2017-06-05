
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

import java.text.DecimalFormat;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

import com.jfinal.kit.StrKit;

/**
 * 公共工具类
 * @author 董华健  2012-9-7 下午2:20:06
 */
public class ToolUtils {

	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(ToolUtils.class);
	
	/**
	 * double精度调整
	 * @param doubleValue 需要调整的值123.454
	 * @param format 目标样式".##"
	 * @return
	 */
	public static String decimalFormatToString(double doubleValue, String format){
		DecimalFormat myFormatter = new DecimalFormat(format);  
		String formatValue = myFormatter.format(doubleValue);
		return formatValue;
	}
	
	/**
	 * 获取UUID by jdk
	 * @author 董华健    2012-9-7 下午2:22:18
	 * @return
	 */
	/**
	 * 手机号验证
	 * 
	 * @param  str
	 * @return 验证通过返回true
	 */
	public static boolean isMobile(String str) { 
		Pattern p = null;
		Matcher m = null;
		boolean b = false; 
		p = Pattern.compile("^[1][3,4,5,7,8][0-9]{9}$"); // 验证手机号
		m = p.matcher(str);
		b = m.matches(); 
		return b;
	}
	/**
	 * 电话号码验证
	 * 
	 * @param  str
	 * @return 验证通过返回true
	 */
	public static boolean isPhone(String str) { 
		Pattern p1 = null,p2 = null;
		Matcher m = null;
		boolean b = false;  
		p1 = Pattern.compile("^[0][1-9]{2,3}-?[0-9]{5,10}$");  // 验证带区号的
		p2 = Pattern.compile("^[1-9]{1}[0-9]{5,8}$");         // 验证没有区号的
		if(str.length() >9)
		{	m = p1.matcher(str);
 		    b = m.matches();  
		}else{
			m = p2.matcher(str);
 			b = m.matches(); 
		}  
		return b;
	}
	public static String getUuidByJdk(boolean is32bit){
		String uuid = UUID.randomUUID().toString();
		if(is32bit){
			return uuid.toString().replace("-", ""); 
		}
		return uuid;
	}
	public static boolean CheckKeyWord(String sWord){
	      String StrKeyWord = "select|insert|delete|from|count/(|drop table|update|truncate|asc/(|mid/(|char/(|xp_cmdshell|exec master|netlocalgroup administrators|:|net user";
	      for(String str:StrKeyWord.split("\\|")){
	    	  if(sWord.trim().indexOf(str)!=-1)
	    		  return true;
	      }
	      return false;
	    }
	
	public static String changeDataRule(String data){
		if(StrKit.isBlank(data))
			return null;
		else{
			String newData = "";
			for(int i=data.length();i>0;i--){
				if(newData.length()>0){
					newData = newData.substring(newData.length()-1, newData.length())+data.substring(i-1, i)+newData.substring(0, newData.length()-1);
				}else{
					newData = data.substring(i-1, i);
				}
			}
			return newData;
		}
	}
	
	public static String returnOldData(String data){
		if(StrKit.isBlank(data))
			return null;
		else{
			String newData = "";
			while(data.length()>0){
				while(data.length()==1){
					newData += data;
					return newData;
				}
				while(data.length()>1){
					newData += data.substring(1, 2);
					data = data.substring(2, data.length())+data.substring(0, 1);
				}
			}
		}
		return null;
	}
	
	public static void main(String[] args){
		System.out.println(isPhone("0432-67151281"));
		System.out.println(changeDataRule("635_19260"));
		System.out.println(returnOldData("9151454667"));
	}
	
}
