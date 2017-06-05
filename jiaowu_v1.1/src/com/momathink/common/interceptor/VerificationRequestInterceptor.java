
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

package com.momathink.common.interceptor;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.kit.StrKit;
import com.momathink.common.constants.DictKeys;
import com.momathink.common.plugin.PropertiesPlugin;
import com.momathink.common.tools.ToolMD5;


public class VerificationRequestInterceptor implements Interceptor {
	
	private static final Logger log = Logger.getLogger( VerificationRequestInterceptor.class );
	@Override
	public void intercept( Invocation ai ) {
		
		HttpServletRequest request = ai.getController().getRequest();
		String pullSignature = request.getParameter("signature");
		pullSignature = StrKit.isBlank( pullSignature ) ? "" : pullSignature;
		
		String privateKey = ( String )PropertiesPlugin.getParamMapValue( DictKeys.WORD_SIGNATURE );
		String pullTimestamp = request.getParameter("timeStamp");
		String spliceSignature = ToolMD5.getMD5( ToolMD5.getMD5( pullTimestamp + privateKey ) );
		
		pullTimestamp = StrKit.isBlank( pullTimestamp ) ? "0" : pullTimestamp ;
		long timestamp = Long.parseLong( pullTimestamp );
		
		JSONObject json = new JSONObject();
		long differenceTime = ( System.currentTimeMillis() - timestamp )/( 1000 * 60 );
		if( timestamp != 0 ){
			if( differenceTime < 5 ) {
				if( pullSignature.equals( spliceSignature ) ) {
					ai.invoke();
				} else {
					log.error( "签名不符合要求" );
					json.put( "code" , 0 );
					json.put( "message" , "签名不符" );
					ai.getController().renderJson( json );
				}
			} else {
				log.error( "请求超时" );
				json.put( "code" , 0 );
				json.put( "message" , "请求超时" );
				ai.getController().renderJson( json );
			}
		} else {
			log.error( "请求时间戳格式不正确" );
			json.put( "code" , 0 );
			json.put( "message" , "请求时间戳格式不正确" );
			ai.getController().renderJson( json );
		}
	}


}

