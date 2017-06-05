
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

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.jfinal.kit.FileKit;
import com.jfinal.kit.StrKit;
import com.jfinal.upload.UploadFile;
import com.momathink.common.base.BaseModel;
import com.momathink.sys.dict.model.Dict;

/**
 * 导入时候的两个共用方法
 * @author prq
 * @version 2016年1月19日 上午9:45:50
 */
public class ToolImport {
	
	
	/**
	 * 分析excel的内容
	 * @param file Excel路径
	 * @return
	 */
	public static Map<String, Object> dealDataByPath(File file,Map<String,String > maptab,String mustTab) {
		Map<String, Object> flagList = new HashMap<String, Object>();
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		StringBuffer  errormsg = new StringBuffer("");
		HSSFWorkbook hwb = null;
		try {
			hwb = new HSSFWorkbook(new FileInputStream(file));
			HSSFSheet sheet = hwb.getSheetAt(0); // 获取到第一个sheet中数据
			HSSFRow zeroRow = sheet.getRow(0);
			HSSFCell zeroCell = zeroRow.getCell(0);

			// "判断是否为提供模版"
			boolean flag = isProvidedModel(zeroRow,maptab);
			if (!flag) {
				flagList.put("flag", false);
				flagList.put("list", list);
				flagList.put("errormsg", errormsg);
				return flagList;
			} else {
				flagList.put("flag", true);
			}
			
			Integer tabsize = maptab.size();
			Integer rownum = sheet.getLastRowNum();
			
			// "获取文件内容"
			circle: for (int i = 1; i < rownum + 1; i++) {// 第二行开始取值，第一行为标题行

				HSSFRow row = sheet.getRow(i); // 获取到第i列的行数据(表格行)
				if(row==null){
					break circle;
				}
				Map<String, String> map = new HashMap<String, String>();
				for (int j = 0; j < tabsize; j++) {
					zeroCell = zeroRow.getCell(j);
					zeroCell.setCellType(HSSFCell.CELL_TYPE_STRING);
					String zeroObj = zeroCell.getStringCellValue().trim();
					HSSFCell cell = row.getCell(j); 
					if(null==cell){
						if(cellIsNull(j,i, mustTab, maptab, zeroObj, errormsg, tabsize, cell, row))
							continue circle;
					}
					if(cell!=null){
						if(!cellNotNull(map, tabsize, j, cell, mustTab, maptab, zeroObj, errormsg, row))
							continue circle;
					}
				}
				list.add(map);
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		flagList.put("list", list);
		flagList.put("errormsg", errormsg);
		return flagList;
	}
	
	/**
	 * 判断excel每行第一个是空
	 */
	public static boolean cellIsNull(int j,int i,String mustTab,Map<String,String> maptab,String zeroObj,StringBuffer errormsg,Integer tabsize,HSSFCell cell,HSSFRow row){
		String key = maptab.get(zeroObj);
		if(j==0){
			return true;
		}else if(mustTab.indexOf(key)>-1){
			errormsg.append("<br>第 ").append(i).append(" 行，有必填项：\"").append(zeroObj).append("\"没有填写;该行的信息如下:<br>");
			for(int z=0;z<tabsize;z++){
				cell = row.getCell(z); 
				if(z==0){
					errormsg.append(cell!=null?ToolString.removeSpace(cell.getStringCellValue()):"");
				}else{
					errormsg.append("-").append(cell!=null?ToolString.removeSpace(cell.getStringCellValue()):"");
				}
			}
			return true;
		}
		return false;
	}
	
	/**
	 * 判断excel每行第一个不是空
	 * @return 
	 */
	public static boolean cellNotNull(Map<String, String> map,Integer tabsize,int i,HSSFCell cell,String mustTab,Map<String,String> maptab,String zeroObj,StringBuffer errormsg,HSSFRow row){
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		String obj = ToolString.removeSpace(cell.getStringCellValue());
		if (ToolString.isNull(obj)) {
			if(mustTab.indexOf(maptab.get(zeroObj))>-1){
				errormsg.append("<br>第 ").append(i).append(" 行，有必填项：\"").append(zeroObj).append("\"没有填写;该行的信息如下:<br>");
				for(int z=0;z<tabsize;z++){
					cell = row.getCell(z); 
					if(z==0){
						errormsg.append(cell!=null?ToolString.removeSpace(cell.getStringCellValue()):"");
					}else{
						errormsg.append("-").append(cell!=null?ToolString.removeSpace(cell.getStringCellValue()):"");
					}
				}
				return false;
			}
		} else {
			map.put(maptab.get(zeroObj), obj);
		}
		return true;
	}
	
	

	/**
	 * 判断文件是否以提供的模版上传
	 * @param titleRow
	 * @return
	 */
	public static boolean isProvidedModel(HSSFRow titleRow,Map<String,String> maptab ) {
		int size =0;
		String cellvalue= "";
		for(int i=0;i<size;i++){
			cellvalue = "";
			HSSFCell cellName = titleRow.getCell(i);
			if(null==cellName)
				return false;
			cellName.setCellType(HSSFCell.CELL_TYPE_STRING);
			cellvalue = cellName.getStringCellValue();
			if((StrKit.isBlank(cellvalue))||(StrKit.notBlank(cellvalue)&&StrKit.isBlank(maptab.get(cellvalue)))){
				return false;
			}
		}
		return true;
	}
	
	/**
	 * 字典项
	 * @param entry
	 * @param dictnum
	 * @param model
	 */
	public static void setDictVal(Map.Entry<String, String> entry,String dictnum,@SuppressWarnings("rawtypes") BaseModel model ){
		List<Dict> dictList = Dict.dao.cacheGetChild(dictnum);
		for(Dict dict:dictList){
			if(dict.getStr("val").equals(entry.getValue()))
				model.set(entry.getKey(), dict.getStr("numbers"));
		}
	}
	
	/**
	 * 删除上传的缓存文件
	 * @param upfile
	 */
	public static void removeTempFile(UploadFile upfile){
		if (upfile != null) 
		FileKit.delete(upfile.getFile());
	}
	

}
