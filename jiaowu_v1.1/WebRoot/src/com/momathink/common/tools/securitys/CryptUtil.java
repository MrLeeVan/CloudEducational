
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
 * <p>
 * 加解密功能接口
 * </p>
 * <p>
 * Description: 提供单向加密、加解密功能
 * </p>
 * 
 * @ClassName com.yizhilu.os.core.util.Security.CryptUtil
 * @description
 * @author : qinggang.liu voo@163.com
 * @Create Date : 2014-1-11 上午9:29:21
 */
public interface CryptUtil {

    /**
     * 按照Triple-DES算法，对数据进行加密
     * 
     * @param source
     *            - 明文数据
     * @param key
     *            - 密钥
     * @return - 密文数据
     */
    String cryptDes(String source, String key);

    /**
     * 按照Triple-DES算法，对数据进行解密
     * 
     * @param des
     *            - 密文数据
     * @param key
     *            - 密钥
     * @return - 明文数据
     */
    String decryptDes(String des, String key);

    /**
     * 按照Triple-DES算法，使用系统固定的密钥"a1b2c3d4e5f6g7h8i9j0klmn"，对数据进行加密
     * 
     * @param source
     *            - 明文数据
     * @return - 密文数据
     */
    String cryptDes(String source);

    /**
     * 按照Triple-DES算法，使用系统固定的密钥"a1b2c3d4e5f6g7h8i9j0klmn"，对数据进行解密
     * 
     * @param des
     *            - 密文数据
     * @return - 明文数据
     */
    String decryptDes(String des);

    /**
     * 对数据进行MD5签名
     * 
     * @param source
     *            - 待签名数据
     * @param key
     *            - 密钥
     * @return - 数据签名结果
     */
    String cryptMd5(String source, String key);
}
