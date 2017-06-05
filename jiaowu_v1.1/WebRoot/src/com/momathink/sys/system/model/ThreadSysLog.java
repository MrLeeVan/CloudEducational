
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

package com.momathink.sys.system.model;

import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

import org.apache.log4j.Logger;

/**
 * 操作日志入库处理
 * 2015年7月13日prq
 * @author prq
 *
 */

public class ThreadSysLog {

	private static Logger log = Logger.getLogger(ThreadSysLog.class);
	
	private static final int queueSize = 5000; // 入库队列大小
	private static boolean threadRun = true; // 线程是否运行
	
	/**
	 * 队列
	 */
	//private static final BlockingQueue<SysLog> queue = new LinkedBlockingQueue<SysLog>(queueSize); 
	private static Queue<SysLog> queue = new ConcurrentLinkedQueue<SysLog>(); //	此队列按照 FIFO（先进先出）原则对元素进行排序
	
	
	public static void setThreadRun(boolean threadRun) {
		ThreadSysLog.threadRun = threadRun;
	}

	/**
	 * 向队列中增加Syslog对象，基于ConcurrentLinkedQueue
	 * @param syslog
	 */
	public static void add(SysLog syslog){
		if(null != syslog){	// 此队列不允许使用 null 元素
			synchronized(queue) {
				if(queue.size() <= queueSize){
					queue.offer(syslog);
				}else{
					queue.poll(); // 获取并移除此队列的头，如果此队列为空，则返回 null
					queue.offer(syslog); // 将指定元素插入此队列的尾部
					log.error("日志队列：超过" + queueSize);
				}
			}
		}
	}
	
	/**
	 * 获取Syslog对象，基于ConcurrentLinkedQueue
	 * @return
	 */
	public static SysLog getSyslog(){
		synchronized(queue) {
			if(queue.isEmpty()){
				return null;
			}else{
				return queue.poll(); // 获取并移除此队列的头，如果此队列为空，则返回 null
			}
		}
	}
	
	/**
	 * 启动入库线程
	 */
	public static void startSaveDBThread() {
		try {
			for (int i = 0; i < 10; i++) {
				Thread insertDbThread = new Thread(new Runnable() {
					public void run() {
						while (threadRun) {
							try {
								// 取队列数据
								//SysLog sysLog = queue.take(); // 基于LinkedBlockingQueue
								SysLog sysLog = getSyslog();
								if(null == sysLog){
									Thread.sleep(200);
								} else {
									log.info("保存操作日志到数据库start......");
									sysLog.save();// 日志入库
									log.info("保存操作日志到数据库end......");
								}
							} catch (Exception e) {
								log.error("保存操作日志到数据库异常");
								e.printStackTrace();
								throw new RuntimeException("ThreadSysLog -> save Exception");
							}
						}
					}
				});

				insertDbThread.setName("little-ant-Thread-SysLog-insertDB-" + (i + 1));
				insertDbThread.start();
			}
		} catch (Exception e) {
			throw new RuntimeException("ThreadSysLog new Thread Exception");
		}
	}
	

}
