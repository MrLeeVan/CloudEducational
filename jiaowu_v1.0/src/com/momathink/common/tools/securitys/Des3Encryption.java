
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

package com.momathink.common.tools.securitys;


/**
 * 
 * @ClassName com.yizhilu.os.core.util.Security.Des3Encryption
 * @description
 * @author : qinggang.liu voo@163.com
 * @Create Date : 2014-1-11 上午9:29:36
 */
public class Des3Encryption {
    public static final String CHAR_ENCODING = "UTF-8";

    public static byte[] encode(byte[] key, byte[] data) throws Exception {
        return MessageAuthenticationCode.des3Encryption(key, data);
    }

    public static byte[] decode(byte[] key, byte[] value) throws Exception {
        return MessageAuthenticationCode.des3Decryption(key, value);
    }

    public static String encode(String key, String data) {
        try {
            byte[] keyByte = key.getBytes(CHAR_ENCODING);
            byte[] dataByte = data.getBytes(CHAR_ENCODING);
            byte[] valueByte = MessageAuthenticationCode
                    .des3Encryption(keyByte, dataByte);
            String value = new String(Base64.encode(valueByte), CHAR_ENCODING);
            return value;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String decode(String key, String value) {
        try {
            byte[] keyByte = key.getBytes(CHAR_ENCODING);
            byte[] valueByte = Base64.decode(value.getBytes(CHAR_ENCODING));
            byte[] dataByte = MessageAuthenticationCode
                    .des3Decryption(keyByte, valueByte);
            String data = new String(dataByte, CHAR_ENCODING);
            return data;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    public static String decryptFromHex(String key, String value) {
        try {
            byte[] keyByte = key.getBytes(CHAR_ENCODING);
            byte[] valueByte = ConvertUtils.fromHex(value);
            byte[] dataByte = MessageAuthenticationCode
                    .des3Decryption(keyByte, valueByte);
            String data = new String(dataByte, CHAR_ENCODING);
            return data;
        } catch (Exception e) {
            //e.printStackTrace();
            return null;
        }
    }

    public static String encode(String value) {
        return encode("z9aa179L5c2g0253375qx67G", value);
    }

    public static String decode(String value) {
        return decode("z9aa179L5c2g0253375qx67G", value);
    }

}