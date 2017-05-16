
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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**处理I18n各个配置文件升级中遇见的问题
 * */
public class ToolI18nFile {
	static String gbk = "GBK";
	static String utf8 = "UTF-8";

	public static void main(String[] args) {
		System.out.println("开始处理--------------------" + new Date().getTime());
		//零时写的,针对 自己遇见的需求,如果需要使用根据自己的情况自己解析了！，， 变量名起的随意了....
		/*handle("F:/workspace/ultimate_jiaowu_v2.0/src/i18n",
				"F:/workspace/ultimate_jiaowu_v2.0/src/i18n.txt","　　　　");*/
		/*alignment("F:/workspace/ultimate_jiaowu_v2.0/src/i18n",
				"F:/workspace/ultimate_jiaowu_v2.0/src/i18n.txt");*/
		/*difference("F:/workspace/ultimate_jiaowu_v2.0/src/shang_i18n_ja_JPN.properties",
				"F:/workspace/ultimate_jiaowu_v2.0/src/i18n",
				"F:/workspace/ultimate_jiaowu_v2.0/src/i18n.txt");*/
		/*findWrite("F:/workspace/ultimate_jiaowu_v2.0/src/shang_i18n_ja_JPN.properties",
				"F:/workspace/ultimate_jiaowu_v2.0/src/shang_i18n_zh_CN.properties",
				"F:/workspace/ultimate_jiaowu_v2.0/src/i18n.properties");*/
		/*moduleSql("F:/workspace/ultimate_jiaowu_v2.0/src/i18n",
				"F:/workspace/ultimate_jiaowu_v2.0/src/pt_module.sql",
				"F:/workspace/ultimate_jiaowu_v2.0/doc/pt_module.sql");*/
//		deleteSQL("E:/项目/西奈山/2017-02-09/root-20170209_1.sql", "E:/项目/西奈山/2017-02-09/root-20170209_1_delLog.sql");
//		deleteSQL("E:/项目/楷德教育/2017-02-09/20170209_1.sql", "E:/项目/楷德教育/2017-02-09/20170209_1_delLog.sql");
//		deleteSQL("E:/项目/四中/2017-02-07/lotus_ams.sql", "E:/项目/四中/2017-02-07/lotus_ams_1_delLog.sql");
//		deleteSQL("E:/项目/乐享佳宁/2017-03-11/20170311_1.sql", "E:/项目/乐享佳宁/2017-03-11/20170311_1_delLog.sql");
//		deleteSQL("E:/项目/YESSTA/2017-02-25/yessat_jiaowu.sql", "E:/项目/YESSTA/2017-02-25/yessat_jiaowu_delLog.sql");
		
		
		pdlMake("E:/配置/脚本/moma_oa.qbl", "tomcat_momacrm",
				"momathink", "momathink2015", "rdswdxnvant154v624b2.mysql.rds.aliyuncs.com", "moma_crm",
				"moma_crm");
		
		System.out.println("结束处理--------------------" + new Date().getTime());
	}
	
	/*
	 * java文件添加头信息 
	 */
	/*public static void addHeadMessage(String pathReader, String pathWriter, String indexOf){
			BufferedReader br =  new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
		    BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
	}*/
	
	/**切掉中间部分**/
	public static void handle(String pathReader, String pathWriter, String indexOf){
		
		try {
		    BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
		    BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
		    String line = null;
		    while ((line = br.readLine()) != null) {
		         // lines.add(new String(line.getBytes(gbk), utf8));
		    	int s = line.indexOf("=");
		    	int n = line.indexOf(indexOf);
		    	if(s>1 && n >1){
		    		sb.append(line.substring(0, s+1));
		    		sb.append(line.substring(n, line.length()));
		    	}else{
		    		sb.append(line);
		    	}
		    	sb.append("\r\n");
		    }
			br.close();
			sb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**对齐**/
	public static void alignment(String pathReader, String pathWriter){
		
		int j=50;
		try {
		    BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
		    BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
		    String line = null;
		    while ((line = br.readLine()) != null) {
		         // lines.add(new String(line.getBytes(gbk), utf8));
		    	int s = line.indexOf("=");
		    	if(s>1){
		    		String tou = line.substring(0, s).trim();
		    		tou = tou.replaceAll("　", "");
		    		sb.append(tou);
		    		for (int i = 0; i < (j-tou.length()); i++) {
		    			sb.append(" ");
					}
		    		sb.append("= ");
		    		String hou = line.substring(s+1, line.length()).trim();
		    		hou = hou.replaceAll("　", "");
		    		sb.append(hou);
		    	}else{
		    		if(line.length()>1)
		    			sb.append(line.trim());
		    	}
		    	sb.append("\r\n");
		    }
			br.close();
			sb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**找出缺失的部分**/
	public static void difference(String pathReader,String pathReader2, String pathWriter){
		
		Map<String, String> map = new HashMap<String, String>();
		try {
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
			BufferedReader br2=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader2), utf8));
			BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
			String line = null;
			//缺失的文件
			while ((line = br.readLine()) != null) {
				// lines.add(new String(line.getBytes(gbk), utf8));
				int s = line.indexOf("=");
				if(s>1){
					String tou = line.substring(0, s).trim();
					map.put(tou, "");
				}
			}
			//查找到 对比的文件
			while ((line = br2.readLine()) != null) {
				// lines.add(new String(line.getBytes(gbk), utf8));
				int s = line.indexOf("=");
				if(s>1){
					String tou = line.substring(0, s).trim();
					//找出缺失的
					if(map.get(tou) == null){
						sb.append(line + "\t\t\t");
						sb.append("\r\n");
					}
				}
			}
			br.close();
			br2.close();
			sb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**补齐文件*/
	public static void findWrite(String pathReader,String pathReader2, String pathWriter){
		try {
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
			BufferedReader br2=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader2), utf8));
			BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
			String line = null;
			//缺失的文件
			while ((line = br.readLine()) != null) {
				sb.append(line);
				sb.append("\r\n");
				int s = line.indexOf("=");
				if(s>1){
					String tou = line.substring(0, s).trim();
					//查找到 对比的文件
					line = null;
					while ((line = br2.readLine()) != null) {
						int s2 = line.indexOf("=");
						if(s2>1){
							String tou2 = line.substring(0, s).trim();
							if(tou.equals(tou2)){//一样
								break;
							}else{//多出来的 部分
								sb.append(line);
								sb.append("\r\n");
							}
						}
					}
				}
			}
			
			br.close();
			br2.close();
			sb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**处理菜单SQL文件  */
	public static void moduleSql(String pathReader,String pathReader2, String pathWriter){
		
		Map<String, String> map = new HashMap<String, String>();
		try {
			BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
			BufferedReader br2=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader2), utf8));
			BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
			String line = null;
			//翻译的文件
			while ((line = br.readLine()) != null) {
				// lines.add(new String(line.getBytes(gbk), utf8));
				int s = line.indexOf("　　　");// 我看见的文件 一行中最小 分割 参数是这个
				if(s>1){
					String tou = line.substring(0, s).trim();
					String hou = line.substring(s, line.length()).trim();
		    		hou = hou.replaceAll("　", "");
					map.put(tou, hou);
				}
			}
			//整理的sql文件
			int count = 0;
			while ((line = br2.readLine()) != null) {
				if(count == 70){
					//System.out.println(count);
				}
				// lines.add(new String(line.getBytes(gbk), utf8));
				String sindexOf = "`names`='";
				int s = line.indexOf(sindexOf);
				int k = line.indexOf("', `orderids");
				String tou = line.substring(s + sindexOf.length(), k).trim();
				String mapv = map.get(tou);
				if(mapv != null){
					String jindexOf = "`japanese`=";
					int j = line.indexOf(jindexOf);
					String neir = line.substring(0, j + jindexOf.length());
					int r = line.indexOf(" WHERE (");
					String neirhou = line.substring(r, line.length());
					
					sb.append(neir + "'" + mapv + "'" + neirhou);
					sb.append("\r\n");
				}
				count = count + 1;
			}
			br.close();
			br2.close();
			sb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/*** 剔除SQL 文本中 不要的数据减小容量, 如 log 
	 */
	public static void deleteSQL(String pathReader, String pathWriter){
		
		try {
		    BufferedReader br=new BufferedReader(new InputStreamReader(new FileInputStream(pathReader), utf8));
		    BufferedWriter sb = new BufferedWriter(new FileWriter(new File(pathWriter), true));
		    String line = null;
		    while ((line = br.readLine()) != null) {
		    	int s = line.indexOf("INSERT INTO `pt_syslog` VALUES (");
	    		if(s < 0){
	    			sb.append(line);
	    			sb.append("\r\n");
	    		}
		    }
			br.close();
			sb.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Xshell 脚本生成
	 * @param fielPath  存放位置
	 * @param tomcat    tomcat名称
	 * @param useName   数据库登录名
	 * @param password  数据库密码
	 * @param IP        数据库IP
	 * @param use       数据库名
	 * @param jiaowuPathsName  SQL备份目录  
	 */
	public static void pdlMake(String fielPath, String tomcat, String useName, String password, String IP, String use, String jiaowuPathsName){
		String txt = (
						"[QuickButton]\r\n"
						+ "CR_0=1\r\n"
						+ "Visible_1=0\r\n"
						+ "Type_3=0\r\n"
						+ "Label_5=登陆数据库\r\n"
						+ "Command_5=\r\n"
						+ "Parameter_7=\r\n"
						+ "TextFile_10=\r\n"
						+ "Visible_0=0\r\n"
						+ "CR_1=1\r\n"
						+ "Type_2=0\r\n"
						+ "Command_2=\r\n"
						+ "Label_4=备份数据库\r\n"
						+ "Parameter_6=\r\n"
						+ "Type_1=0\r\n"
						+ "Parameter_1=\r\n"
						+ "CR_2=1\r\n"
						+ "Label_3=启动" + tomcat + "\r\n"
						+ "Command_3=\r\n"
						+ "Visible_7=0\r\n"
						+ "Parameter_10=\r\n"
						+ "Type_0=0\r\n"
						+ "Command_0=\r\n"
						+ "ScriptFile_0=\r\n"
						+ "Parameter_0=\r\n"
						+ "ScriptFile_1=\r\n"
						+ "Label_2=停止" + tomcat + "\r\n"
						+ "ScriptFile_2=\r\n"
						+ "CR_3=1\r\n"
						+ "ScriptFile_3=\r\n"
						+ "ScriptFile_4=\r\n"
						+ "ScriptFile_5=\r\n"
						+ "ScriptFile_6=\r\n"
						+ "Visible_6=0\r\n"
						+ "ScriptFile_7=\r\n"
						+ "ScriptFile_8=\r\n"
						+ "ScriptFile_9=\r\n"
						+ "Label_1=查看tomcat\r\n"
						+ "Command_1=\r\n"
						+ "Text_2= /opt/" + tomcat + "/bin/shutdown.sh\r\n"
						+ "Parameter_3=\r\n"
						+ "CR_4=0\r\n"
						+ "Visible_5=0\r\n"
						+ "Count=11\r\n"
						+ "Label_0=查看日志\r\n"
						+ "Parameter_2=\r\n"
						+ "Text_3= /opt/" + tomcat + "/bin/startup.sh\r\n"
						+ "Visible_4=0\r\n"
						+ "CR_5=1\r\n"
						+ "Text_0= tail -f /opt/" + tomcat + "/logs/catalina.out\r\n"
						+ "CR_6=1\r\n"
						+ "Text_1= ps aux | grep " + tomcat + "\r\n"
						+ "CR_7=1\r\n"
						+ "Text_6=set names utf8;\r\n"
						+ "Label_10=查看nginx\r\n"
						+ "Text_10=ps aux | grep  nginx\r\n"
						+ "Command_10=\r\n"
						+ "Text_7=use " + use + ";\r\n"
						+ "CR_8=1\r\n"
						+ "Visible_9=0\r\n"
						+ "Type_10=0\r\n"
						+ "TextFile_0=\r\n"
						+ "TextFile_1=\r\n"
						+ "TextFile_2=\r\n"
						+ "TextFile_3=/usr/bin/mysqldump --opt --skip-lock-tables --default-character-set=utf8 --skip-comments --extended-insert=false -h " + IP + " -u" + useName + " -p" + password + " " + use + " > /root/jiaowu/" + jiaowuPathsName + "20170307_1.sql;\r\n"
						+ "TextFile_4=\r\n"
						+ "TextFile_5=\r\n"
						+ "TextFile_6=\r\n"
						+ "TextFile_7=\r\n"
						+ "TextFile_8=\r\n"
						+ "Visible_8=0\r\n"
						+ "Type_9=0\r\n"
						+ "CR_9=0\r\n"
						+ "TextFile_9=\r\n"
						+ "Parameter_9=\r\n"
						+ "Text_5=mysql -u" + useName + " -p" + password + " -h " + IP + "\r\n"
						+ "Type_8=0\r\n"
						+ "Command_8=\r\n"
						+ "Parameter_8=\r\n"
						+ "CR_10=1\r\n"
						+ "Label_9=运行sql文件\r\n"
						+ "Command_9=\r\n"
						+ "ScriptFile_10=\r\n"
						+ "Type_7=0\r\n"
						+ "Label_8=显示所有的数据库\r\n"
						+ "Type_6=0\r\n"
						+ "Command_6=\r\n"
						+ "Visible_3=0\r\n"
						+ "Type_5=0\r\n"
						+ "Parameter_5=\r\n"
						+ "Label_7=进入某库\r\n"
						+ "Command_7=\r\n"
						+ "Text_8=show databases;\r\n"
						+ "Visible_2=0\r\n"
						+ "Type_4=0\r\n"
						+ "Command_4=\r\n"
						+ "Parameter_4=\r\n"
						+ "Label_6=设置字符集\r\n"
						+ "Text_9=source /" + useName + "/" + jiaowuPathsName + "/" + jiaowuPathsName + "_2017-03-08_1.sql\r\n"
						+ "Visible_10=0\r\n"
						);
		try {
			FileWriter fileWriter = new FileWriter(new File(fielPath));
			fileWriter.write(txt);
			fileWriter.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("---------------完毕------------------");
	}

}
