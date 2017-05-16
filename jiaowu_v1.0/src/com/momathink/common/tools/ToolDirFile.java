
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

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.jfinal.kit.PathKit;
import com.jfinal.kit.StrKit;
import com.jfinal.upload.UploadFile;

/**
 * 文件和目录相关
 * 
 * @author David Wong 2012-9-7 下午2:06:13
 */
public class ToolDirFile {

	@SuppressWarnings("unused")
	private static Logger log = Logger.getLogger(ToolDirFile.class);
	
	/**
	 * 获取当前代码所在行
	 * @return
	 */
	public static String getLineNumber(){
		StackTraceElement ste = new Throwable().getStackTrace()[1];
		return ste.getFileName() + ": Line " + ste.getLineNumber();
	}
	
	/**
	 * 获取目录下的文件名称，不包含子目录名称
	 * 
	 * @author David Wong 2012-9-6 下午8:17:51
	 * @param dirPath
	 * @return
	 */
	public static List<String> getDirFileNames(String dirPath) {
		List<String> nameList = new ArrayList<String>();
		File file = new File(dirPath);
		File[] files = file.listFiles();
		for (File fileTemp : files) {
			if (!fileTemp.isDirectory()) {
				nameList.add(fileTemp.getName());
			}
		}
		return nameList;
	}
	
	/**
	 * 复制文件夹或文件
	 * 
	 * @author David Wong 2012-9-3 下午7:29:28
	 * @param source
	 * @param target
	 * @throws IOException
	 */
	public static void copyDir(String source, String target) throws IOException {
		(new File(source)).mkdirs();
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(source)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 复制文件
				copyFile(file[i], new File(target + file[i].getName()));
			}
			if (file[i].isDirectory()) {
				// 复制目录
				String sourceDir = source + File.separator + file[i].getName();
				String targetDir = target + File.separator + file[i].getName();
				copyDirectiory(sourceDir, targetDir);
			}
		}
	}

	/**
	 * copy文件或目录
	 * 
	 * @author David Wong 2012-9-3 下午7:31:57
	 * @param source
	 * @param target
	 */
	public static void lovecopy(String source, String target) {
		// (new File(url2)).mkdirs();
		File f = new File(target);
		if (!f.exists()) {
			f.mkdirs();
		}

		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(source)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 复制文件
				try {
					copyFile(file[i], new File(target + file[i].getName()));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (file[i].isDirectory()) {
				// 复制目录
				String sourceDir = source + File.separator + file[i].getName();
				String targetDir = target + File.separator + file[i].getName();
				try {
					copyDirectiory(sourceDir, targetDir);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	/**
	 * 复制文件
	 * 
	 * @author David Wong 2012-9-3 下午7:32:26
	 * @param sourceFile
	 * @param targetFile
	 * @throws IOException
	 */
	public static void copyFile(File sourceFile, File targetFile) throws IOException {
		// 新建文件输入流并对它进行缓冲
		FileInputStream input = new FileInputStream(sourceFile);
		BufferedInputStream inBuff = new BufferedInputStream(input);

		// 新建文件输出流并对它进行缓冲
		FileOutputStream output = new FileOutputStream(targetFile);
		BufferedOutputStream outBuff = new BufferedOutputStream(output);

		// 缓冲数组
		byte[] b = new byte[1024 * 5];
		int len;
		while ((len = inBuff.read(b)) != -1) {
			outBuff.write(b, 0, len);
		}
		// 刷新此缓冲的输出流
		outBuff.flush();

		// 关闭流
		inBuff.close();
		outBuff.close();
		output.close();
		input.close();
	}

	/**
	 * 复制文件夹
	 * 
	 * @author David Wong 2012-9-3 下午7:32:33
	 * @param sourceDir
	 * @param targetDir
	 * @throws IOException
	 */
	public static void copyDirectiory(String sourceDir, String targetDir) throws IOException {
		// 新建目标目录
		(new File(targetDir)).mkdirs();
		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isFile()) {
				// 源文件
				File sourceFile = file[i];
				// 目标文件
				File targetFile = new File(new File(targetDir).getAbsolutePath() + File.separator + file[i].getName());
				copyFile(sourceFile, targetFile);
			}
			if (file[i].isDirectory()) {
				// 准备复制的源文件夹
				String dir1 = sourceDir + "/" + file[i].getName();
				// 准备复制的目标文件夹
				String dir2 = targetDir + "/" + file[i].getName();
				copyDirectiory(dir1, dir2);
			}
		}
	}
	
	/**
	 * 检查目录是否存在，如果不存在就创建目录
	 * 
	 * @author David Wong    2012-9-10 下午5:17:58
	 * @param dirPath
	 */
	public static void createDirectory(String dirPath){
		File file = new File(dirPath);
		if(!file.exists()){
			file.mkdirs();
		}
	}
	
	/**
	 * 删除文件或者目录
	 * @param file
	 */
	public static void delete(File file) {
		if (file != null && file.exists()) {
			if (file.isDirectory()) {
				File files[] = file.listFiles();
				for (int i=0, length = files.length; i<length; i++) {
					delete(files[i]);
				}
			}else{
				file.delete();
			}
		}
	}
	
	/**
	 * 文件下载
	 * @param response
	 * @param fileName
	 * @param filePath
	 * @throws IOException
	 */
	public static void download(HttpServletResponse response, String fileName, String filePath) throws IOException{
		FileInputStream fis = null;
        BufferedInputStream buff = null;
		try {
    		File file = new File(filePath);
    		response.setContentType("application/x-msdownload");//设置response的编码方式
            response.setContentLength((int)file.length());//写明要下载的文件的大小
			response.setHeader("Content-Disposition", "attachment;filename=" + new String(fileName.getBytes(ToolString.encoding), "iso-8859-1")); //解决中文乱码
	        
	        //读出文件到i/o流
	        fis = new FileInputStream(file);
	        buff = new BufferedInputStream(fis);
	        byte[] bytes = new byte[1024];//相当于我们的缓存
	        long k = 0;//该值用于计算当前实际下载了多少字节
	        OutputStream os = response.getOutputStream();//从response对象中得到输出流,准备下载
	        
	        //开始循环下载
	        while(k < file.length()){
	            int j = buff.read(bytes, 0, 1024);
	            k += j;
	            os.write(bytes, 0, j);//将b中的数据写到客户端的内存
	        }
	        
	        os.flush();//将写入到客户端的内存的数据,刷新到磁盘
	        
	        buff.close();
	        buff = null;
	        
	        fis.close();
	        fis = null;
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} finally {
			if(buff != null){
				buff.close();
		        buff = null;
			}
			if(fis != null){
				fis.close();
				fis = null;
			}
		}
	}
	
	/**
	 * 创建文件
	 * @param savePath 保存路径
	 * @param content 文件内容
	 */
	public static void createFile(String savePath, String content){
		try {
			File file = new File(savePath);
			BufferedWriter output = new BufferedWriter(new FileWriter(file));   
			output.write(content);   
			output.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  替换系统内的文件
	 * @param file 接收到的文件
	 * @param fileType 文件类型
	 * @param newPath 替换掉文件的相对路径
	 * @return 提示
	 */
	public static String replaceFile(UploadFile file,String fileType, String newPath) {
		if (StrKit.isBlank(newPath))
			return "没有找到文件路径";
		String returnMsg = null;
		File fnewpath = null;
		try {
			fnewpath = file.getFile();
			if(null == fnewpath)
				return "没有上传文件";
			String path = file.getFileName();
			if ((path.toLowerCase().endsWith(fileType)) || (null == fileType)) {
				// 上传上来的
				// 系统里的文件
				File oldFile = null;
				oldFile = new File(PathKit.getWebRootPath() + newPath);
				oldFile.delete();
				// 上传上来的文件  移动到 系统里的文件地方
				returnMsg = fnewpath.renameTo(oldFile) ? "上传成功" : "上传失败";
			} else {
				returnMsg = "请上传." + fileType + "格式的文件";
				fnewpath.delete();
			}
		} catch (Exception e) {
			e.printStackTrace();
			returnMsg = "文件处理异常,请联系管理员";
			if(null != fnewpath)
				fnewpath.delete();
		}
		return returnMsg;
	}
	
	public static void main(String[] args) throws IOException{
		copyDir("D:\\aa\\新建文本文档 (2).txt", "D:\\bb\\新建文本文档 (2).txt");
	}

}
