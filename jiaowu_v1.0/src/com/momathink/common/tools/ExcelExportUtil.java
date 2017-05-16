

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

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;

import com.jfinal.plugin.activerecord.Record;

public class ExcelExportUtil
 {

	/**
	 * @param response
	 * @param request
	 * @param filename	导出的文件名
	 * @param titles 标题列和列名的对应.column:列名,title标题名
	 * @param records 记录
	 */
	public static void exportByRecord(HttpServletResponse response,HttpServletRequest request,String filename,List<Pair> titles, List<Record> records){
		exportByRecord(response, request, filename, new SheetData(titles, records));
	}

	/**
	 * @param response
	 * @param request
	 * @param filename	导出的文件名
	 * @param sheetDatas 产生一个sheet需要的数据
	 */
	public static void exportByRecord(HttpServletResponse response,HttpServletRequest request,String filename,SheetData... sheetDatas){

		HSSFWorkbook wb = new HSSFWorkbook();								

		//标题行的style
		CellStyle titleCellStyle = wb.createCellStyle();					
		titleCellStyle.setAlignment(CellStyle.ALIGN_CENTER);				//居中
		titleCellStyle.setWrapText(true);									//自动换行	
		Font font = wb.createFont();
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);						//加粗
		font.setFontName("微软雅黑");
		titleCellStyle.setFont(font);

		//内容行的style
		CellStyle cellStyle = wb.createCellStyle();					
		cellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);	//垂直居中
		cellStyle.setWrapText(true);	
		Font font2 = wb.createFont();
		font2.setFontName("微软雅黑");
		cellStyle.setFont(font2);	
		
		//多张sheet
		for (SheetData sheetData : sheetDatas) {
			List<Pair> titles = sheetData.titles;
			
			List<Record> records = sheetData.records;
			
			HSSFSheet sheet = wb.createSheet();
			
			int rowIndex = 0,cellIndex=0;
			
			HSSFRow row = null;
			HSSFCell cell = null;

			//创建标题行
			row = sheet.createRow(rowIndex);
			row.setHeight((short)450);
			rowIndex++;
			
			for (Pair pair : titles) {
				
				cell = row.createCell(cellIndex);
				cell.setCellStyle(titleCellStyle);				//设置样式
				cellIndex++;
				
				cell.setCellValue(pair.title);
			}
			
			//处理每一行
			for (Record record : records) {

				row = sheet.createRow(rowIndex);
				row.setHeight((short)450);
				rowIndex++;
				cellIndex = 0;

				
				for (Pair pair : titles) {
					
					cell = row.createCell(cellIndex);
					cell.setCellStyle(cellStyle);				//设置样式
					cellIndex++;
					
					Object value = record.get(pair.column);
					
					if(value!=null){
							
						cell.setCellValue(value.toString());
					}
				}
			}
		}
		
		//序号
		writeStream(filename, wb, response,request);
	}

	/**
	 * 写到输出流
	 */
	private static void writeStream(String filename, HSSFWorkbook wb, HttpServletResponse response, HttpServletRequest request)
	{

		try
		{
			String agent = request.getHeader("USER-AGENT");

			filename += ".xls";

			filename.replaceAll("/", "-");
			// filename = new String(filename.getBytes("gbk"),"ISO8859_1");
			

			if (agent.toLowerCase().indexOf("firefox")>0)
			{
				filename = new String(filename.getBytes("utf-8"), "iso-8859-1");
			}else{
				filename = URLEncoder.encode(filename, "UTF-8");
			}

			response.reset();
			response.setCharacterEncoding("UTF-8");
			response.setHeader("Content-Disposition", "attachment; filename=" + filename);
			response.setContentType("application/octet-stream;charset=UTF-8");
			OutputStream outputStream = new BufferedOutputStream(response.getOutputStream());
			wb.write(outputStream);
			outputStream.flush();
			outputStream.close();

		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}

	}
	
	/**
	 * 标题列和列名的对应
	 */
	public static class Pair {
		public String column;
		
		public String title;
		
		public Pair(String column,String title){
			this.column = column;
			
			this.title = title;
			
		}
	}
	
	/**
	 * 创建一个sheet需要的数据
	 */
	public static class SheetData{
		public List<Pair> titles;
		public List<Record> records;
		
		public SheetData(List<Pair> titles, List<Record> records) {
			this.titles = titles;
			
			this.records = records;
		}
	}
}
