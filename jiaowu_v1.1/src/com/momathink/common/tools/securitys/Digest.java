
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

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;

/**
 * 
 * @ClassName com.yizhilu.os.core.util.Security.Digest
 * @description
 * @author : qinggang.liu voo@163.com
 * @Create Date : 2014-1-11 上午9:29:39
 */
public class Digest {
    public static final String ENCODE = "UTF-8"; // UTF-8

    /**
     * 直接用MD5签名对数据签名，不需要密钥
     * 
     * @param aValue
     * @return
     */
    public static String signMD5(String aValue, String encoding) {
        try {
            byte[] input = aValue.getBytes(encoding);
            MessageDigest md = MessageDigest.getInstance("MD5");
            return ConvertUtils.toHex(md.digest(input));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 直接用MD5签名对数据签名，不需要密钥
     * 
     * @param aValue
     * @return
     */
    public static String hmacSign(String aValue) {
        try {
            byte[] input = aValue.getBytes();
            MessageDigest md = MessageDigest.getInstance("MD5");
            return ConvertUtils.toHex(md.digest(input));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 对报文进行hmac签名，字符串按照UTF-8编码
     * 
     * @param aValue
     *            - 字符串
     * @param aKey
     *            - 密钥
     * @return - 签名结果，hex字符串
     */
    public static String hmacSign(String aValue, String aKey) {
        return hmacSign(aValue, aKey, ENCODE);
    }

    /**
     * 对报文进行采用MD5进行hmac签名
     * 
     * @param aValue
     *            - 字符串
     * @param aKey
     *            - 密钥
     * @param encoding
     *            - 字符串编码方式
     * @return - 签名结果，hex字符串
     */
    public static String hmacSign(String aValue, String aKey, String encoding) {
        byte k_ipad[] = new byte[64];
        byte k_opad[] = new byte[64];
        byte keyb[];
        byte value[];
        try {
            keyb = aKey.getBytes(encoding);
            value = aValue.getBytes(encoding);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            keyb = aKey.getBytes();
            value = aValue.getBytes();
        }
        Arrays.fill(k_ipad, keyb.length, 64, (byte) 54);
        Arrays.fill(k_opad, keyb.length, 64, (byte) 92);
        for (int i = 0; i < keyb.length; i++) {
            k_ipad[i] = (byte) (keyb[i] ^ 0x36);
            k_opad[i] = (byte) (keyb[i] ^ 0x5c);
        }

        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
        md.update(k_ipad);
        md.update(value);
        byte dg[] = md.digest();
        md.reset();
        md.update(k_opad);
        md.update(dg, 0, 16);
        dg = md.digest();
        return ConvertUtils.toHex(dg);
    }

    /**
     * 对报文进行采用SHA进行hmac签名
     * 
     * @param aValue
     *            - 字符串
     * @param aKey
     *            - 密钥
     * @param encoding
     *            - 字符串编码方式
     * @return - 签名结果，hex字符串
     */
    public static String hmacSHASign(String aValue, String aKey, String encoding) {
        byte k_ipad[] = new byte[64];
        byte k_opad[] = new byte[64];
        byte keyb[];
        byte value[];
        try {
            keyb = aKey.getBytes(encoding);
            value = aValue.getBytes(encoding);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            keyb = aKey.getBytes();
            value = aValue.getBytes();
        }
        Arrays.fill(k_ipad, keyb.length, 64, (byte) 54);
        Arrays.fill(k_opad, keyb.length, 64, (byte) 92);
        for (int i = 0; i < keyb.length; i++) {
            k_ipad[i] = (byte) (keyb[i] ^ 0x36);
            k_opad[i] = (byte) (keyb[i] ^ 0x5c);
        }

        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("SHA");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
        md.update(k_ipad);
        md.update(value);
        byte dg[] = md.digest();
        md.reset();
        md.update(k_opad);
        md.update(dg, 0, 20);
        dg = md.digest();
        return ConvertUtils.toHex(dg);
    }

    /**
     * 对报文进行SHA签名
     * 
     * @param aValue
     *            - 待签名的字符串（编码：UTF-8）
     * @return - 签名结果，hex字符串
     */
    public static String digest(String aValue) {
        return digest(aValue, ENCODE);

    }

    /**
     * 对报文进行SHA签名
     * 
     * @param aValue
     *            - 待签名的字符串
     * @param encoding
     *            - 字符串编码方式
     * @return - 签名结果，hex字符串
     */
    public static String digest(String aValue, String encoding) {
        aValue = aValue.trim();
        byte value[];
        try {
            value = aValue.getBytes(encoding);
        } catch (UnsupportedEncodingException e) {
            value = aValue.getBytes();
            e.printStackTrace();
        }
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance("SHA");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
        return ConvertUtils.toHex(md.digest(value));
    }

    /**
     * 对字符串进行签名
     * 
     * @param aValue
     *            - 待签名字符串
     * @param alg
     *            - 签名算法名称（如SHA, MD5等）
     * @param encoding
     *            - 字符串编码方式
     * @return - 签名结果，hex字符串
     */
    public static String digest(String aValue, String alg, String encoding) {
        aValue = aValue.trim();
        byte value[];
        try {
            value = aValue.getBytes(encoding);
        } catch (UnsupportedEncodingException e) {
            value = aValue.getBytes();
            e.printStackTrace();
        }
        MessageDigest md = null;
        try {
            md = MessageDigest.getInstance(alg);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
        return ConvertUtils.toHex(md.digest(value));
    }

    public static String udpSign(String aValue) {
        try {
            byte[] input = aValue.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("SHA1");
            return new String(Base64.encode(md.digest(input)), ENCODE);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
