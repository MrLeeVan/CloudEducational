
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

package com.momathink.finance.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.alibaba.druid.util.StringUtils;
import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.task.Organization;
import com.momathink.common.tools.ExcelExportUtil;
import com.momathink.common.tools.ExcelExportUtil.Pair;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolMail;
import com.momathink.common.tools.ToolString;
import com.momathink.finance.model.CourseOrder;
import com.momathink.sys.account.model.AccountBanci;
import com.momathink.teaching.classtype.model.ClassType;
import com.momathink.teaching.course.model.CoursePlan;
import com.momathink.teaching.student.model.Student;
import com.momathink.teaching.subject.model.Subject;

public class CourseOrderService extends BaseService {
	
	public static final CourseOrderService me = new CourseOrderService();
	
	/**
	 * 交费管理列表
	 * @param splitPage
	 */
	public Record queryOrderList(SplitPage splitPage) {
		Record  result  = new Record();
		try{
		List<Object> paramValue = new ArrayList<Object>();
		String select = "SELECT o.*,s.REAL_NAME studentname,t.REAL_NAME operatorname,DATE_FORMAT(o.createtime,'%Y-%m-%d') otime ,\n" +
				"(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount,\n" +
				"(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=0) waitcount,\n" +
				"(SELECT IFNULL(SUM(classhour),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidclasshour,\n" +
				"(SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount,bc.classNum,x.consumptionhour,x.consumptioncost \n";
			StringBuffer formSql =  new StringBuffer("FROM crm_courseorder o \n" +
					"LEFT JOIN account s ON o.studentid=s.Id\n" +
					"LEFT JOIN crm_opportunity opp ON opp.id=s.opportunityid  \n" +
					"LEFT JOIN account c ON o.operatorid=c.Id  LEFT JOIN account t ON o.createuserid=t.Id\n" +
					"LEFT JOIN (SELECT b.courseorderid,SUM(b.classhour) consumptionhour,SUM(b.realamount) consumptioncost FROM account_book b GROUP BY b.courseorderid) x ON o.id=x.courseorderid\n" +
					"LEFT JOIN class_order bc ON o.classorderid=bc.id \n" +
					"WHERE o.checkstatus = 1");
			Map<String,String> queryParam = splitPage.getQueryParam();
			String studentname = queryParam.get("studentname");
			String campusSql = queryParam.get("campusSql");
			String teachtype = queryParam.get("teachtype");
			String status = queryParam.get("status");
			String beginDate = queryParam.get("beginDate");
			String endDate = queryParam.get("endDate");
			if (null != studentname && !studentname.equals("")) {
				formSql.append(" AND s.real_name like ? ");
				paramValue.add("%" + studentname + "%");
			}
			if(!StringUtils.isEmpty(campusSql)){
				formSql.append(campusSql);
			}
			if (null != teachtype && !teachtype.equals("")) {
				formSql.append(" AND o.teachtype = ? ");
				paramValue.add(teachtype);
			}
			if (null != status && !status.equals("")) {
				formSql.append(" AND o.status = ? ");
				paramValue.add(Integer.parseInt(status));
			}
			if (!ToolString.isNull(beginDate)) {
				formSql.append(" AND o.createtime >= ? ");
				paramValue.add(beginDate+" 00:00:00");
			}
			if (!ToolString.isNull(endDate)) {
				formSql.append(" AND o.createtime <= ? ");
				paramValue.add(endDate+" 59:59:59");
			}
			formSql.append(" ORDER BY o.id desc");
			Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
			List<Record> list = page.getList();
			for (Record record : list) {
				CourseOrder co = CourseOrder.dao.findById(record.getInt("id"));
				String sids = null;
				if(!StringUtils.isEmpty(record.getStr("subjectids"))&&record.getStr("subjectids").substring(0, 1).equals("|")){
					sids=record.getStr("subjectids").replaceFirst("\\|", "");
				}else{
					sids=record.getStr("subjectids");
				}
				record.set("subjectname", Subject.dao.getSubjectNameByIds(sids));
				double consumptionHour = record.getDouble("consumptionhour")==null?0:record.getDouble("consumptionhour");
				double consumptionCost = record.getBigDecimal("consumptioncost")==null?0:record.getBigDecimal("consumptioncost").doubleValue();
				record.set("consumptionHour", consumptionHour);
				record.set("consumptioncost", consumptionCost);
				record.set("ddye",ToolArith.sub(record.getBigDecimal("realsum").doubleValue(), consumptionCost));
				record.set("syks",ToolArith.sub(record.getDouble("classhour"), consumptionHour));
				co.set("isread", 1);
				co.update();
			}
			splitPage.setPage(page);
		}catch(Exception e){
			e.printStackTrace();
		}	
		return result;
	}
	
	/**
	 * 学生档案交费管理列表
	 * @param splitPage
	 */
	public Record queryOrderListStudentMessage(String studentId) {
		Record  record  = new Record();
		try{
		String select = "SELECT o.*,s.REAL_NAME studentname,t.REAL_NAME operatorname,DATE_FORMAT(o.createtime,'%Y-%m-%d') otime ,"
				+ "(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount,"
				+ "(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=0) waitcount,"
				+ "(SELECT IFNULL(SUM(classhour),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidclasshour,"
				+ "(SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount,bc.classNum ";
			StringBuffer formSql =  new StringBuffer("  ");
			formSql.append(" FROM crm_courseorder o "
					+ " LEFT JOIN account s ON o.studentid=s.Id "
					+ "	left join crm_opportunity opp on opp.id=s.opportunityid "
					+ " LEFT JOIN account c ON o.operatorid=c.Id ");
			formSql.append(" LEFT JOIN account t ON o.createuserid=t.Id ");
			formSql.append(" LEFT JOIN class_order bc ON o.classorderid=bc.id WHERE o.checkstatus = 1");
			StringBuffer sfs = new StringBuffer();
			if (null != studentId && !studentId.equals("")) {
				sfs.append("0");
				formSql.append(" AND o.studentid = "+studentId+" ");
			}
			formSql.append(" ORDER BY o.id desc");
			List<Record> list = Db.find(select.toString()+formSql.toString());
			
			String type = "0";
			double yzxh = 0.0;
			for (Record r : list) {
				
				Date da = new Date();
				CourseOrder co = CourseOrder.dao.findById(r.getInt("id"));
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
				String end;
				String begin;
				begin = sf.format(da).substring(0,7)+"-01";
				end = sf.format(ToolDateTime.getLastDateOfMonth(da));
				record.set("date",sf.format(da).substring(0,7));
				
				if(co.getInt("teachtype")==2){
					Double yxhks = CoursePlan.coursePlan.getClassOrderMonthLesson(co.getInt("classorderid"),"","");
						if(!StringUtils.isEmpty(type)){
							sfs.append("0");
							if(type.equals("1")){
								if(yxhks<r.getDouble("classhour")){
									r.set("flag", true);
								}else{
									r.set("flag", false);
								}
							}
							if(type.equals("2")){
								if(yxhks>=r.getDouble("classhour")){
									r.set("flag", true);
								}else{
									r.set("flag", false);
								}
							}
						}
						if(sfs.toString().equals("")){
							if(yxhks<r.getDouble("classhour")){
								r.set("flag", true);
							}else{
								r.set("flag", false);
							}
						}
					Double byxhks = CoursePlan.coursePlan.getClassOrderMonthLesson(co.getInt("classorderid"),begin,end);
					r.set("byxhks", byxhks);
					r.set("yxhks", yxhks);
					r.set("qfe",r.getBigDecimal("realsum").doubleValue()-r.getBigDecimal("paidamount").doubleValue());
					r.set("ddye", yxhks==0?r.getBigDecimal("realsum").doubleValue():(r.getDouble("classhour")-yxhks)*r.getDouble("avgprice"));
					r.set("ddsyks", r.getDouble("classhour")-yxhks);
					r.set("kb", r.getStr("classnum"));
					yzxh+=byxhks*r.getDouble("avgprice");
				}else{
					String sids = null;
					if(r.getStr("subjectids").substring(0, 1).equals("|")){
						sids=r.getStr("subjectids").replaceFirst("\\|", "");
					}else{
						sids=r.getStr("subjectids");
					}
					r.set("subjectname", Subject.dao.getSubjectNameByIds(sids));
						if(!StringUtils.isEmpty(type)){
							sfs.append("0");
							if(type.equals("1")){
								double  d=CoursePlan.coursePlan.getKeShiByCourseOrderId(r.getInt("id"));
								if(d<r.getDouble("classhour")){
									r.set("flag", true);
								}else{
									r.set("flag", false);
								}
							}
							if(type.equals("2")){
								double  d=CoursePlan.coursePlan.getKeShiByCourseOrderId(r.getInt("id"));
								if(d>=r.getDouble("classhour")){
									r.set("flag", true);
								}else{
									r.set("flag", false);
								}
							}
						}
						if(sfs.toString().equals("")){
							double  d=CoursePlan.coursePlan.getKeShiByCourseOrderId(r.getInt("id"));
							if(d<r.getDouble("classhour")){
								r.set("flag", true);
							}else{
								r.set("flag", false);
							}
						}
					
					Double  byxhks = CoursePlan.coursePlan.getCourseOrderIdMonthLesson(r.getInt("id"),begin,end);
					Double  yxhks = CoursePlan.coursePlan.getCourseOrderIdMonthLesson(r.getInt("id"),"","");
					r.set("byxhks", byxhks);
					r.set("yxhks", yxhks);
					r.set("qfe",r.getBigDecimal("realsum").doubleValue()-r.getBigDecimal("paidamount").doubleValue());
					r.set("ddye", yxhks==0?r.getBigDecimal("realsum").doubleValue():(r.getDouble("classhour")-yxhks)*r.getDouble("avgprice"));
					r.set("ddsyks", r.getDouble("classhour")-yxhks);
					r.set("kb", Subject.dao.getSubjectNameByIds(sids));
					yzxh+=byxhks*r.getDouble("avgprice");
				}
				r.set("tjyf", begin);
				co.set("isread", 1);
				co.update();
			}
			record.set("list", list);
			record.set("yzxh", yzxh);
		}catch(Exception e){
			e.printStackTrace();
		}	
		return record;
	}
	
	/**
	 * 导出excel
	 * @param splitPage
	 * @return
	 */
	public List<Record> toExcelList(SplitPage splitPage) {
		List<Record> list = null;
		double yzxh = 0.0;
		try{
		 List<Object> paramValue = new ArrayList<Object>();
			String select = "SELECT o.id,o.subjectids,o.classhour,o.realsum,o.teachtype,o.avgprice,s.REAL_NAME studentname,o.ordernum,"
					+ " t.REAL_NAME operatorname,DATE_FORMAT(o.createtime,'%Y-%m-%d') otime ,o.status,"
					+ " (SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount,"
					+ " (SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=0) waitcount,"
					+ " (SELECT IFNULL(SUM(classhour),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidclasshour,"
					+ " (SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount,"
					+ " bc.classNum ";
				StringBuffer formSql =  new StringBuffer("  ");
				formSql.append(" FROM crm_courseorder o "
						+ " LEFT JOIN account s ON o.studentid=s.Id "
						+ "	left join crm_opportunity opp on opp.id=s.opportunityid "
						+ " LEFT JOIN account c ON o.operatorid=c.Id ");
				formSql.append(" LEFT JOIN account t ON o.createuserid=t.Id ");
				formSql.append(" LEFT JOIN class_order bc ON o.classorderid=bc.id WHERE o.checkstatus = 1");
				Map<String,String> queryParam = splitPage.getQueryParam();
				String studentname = queryParam.get("studentname");
				String campusSql = queryParam.get("campusSql");
				String date = queryParam.get("date");
				String teachtype = queryParam.get("teachtype");
				String status = queryParam.get("status");
				StringBuffer sfs = new StringBuffer();
				if (null != studentname && !studentname.equals("")) {
					sfs.append("0");
					formSql.append(" AND s.real_name like ? ");
					paramValue.add("%" + studentname + "%");
				}
				if(!StringUtils.isEmpty(campusSql)){
					formSql.append(campusSql);
				}
				if (null != teachtype && !teachtype.equals("")) {
					sfs.append("0");
					formSql.append(" AND o.teachtype = ? ");
					paramValue.add(teachtype);
				}
				if (null != status && !status.equals("")) {
					sfs.append("0");
					formSql.append(" AND o.status = ? ");
					paramValue.add(status);
				}
				formSql.append(" ORDER BY o.id desc");
				Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
				 list = page.getList();
				String type = queryParam.get("type");
				for (Record r : list) {
					CourseOrder co = CourseOrder.dao.findById(r.getInt("id"));
					SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
					String end;
					String begin;
					if(date !=null && !date.equals("")){
						begin = date+"-01";
						end = sf.format(ToolDateTime.getLastDateOfMonth(sf.parse(begin)));
					}else{
						Date da = new Date();
						begin = sf.format(da).substring(0,7)+"-01";
						end = sf.format(ToolDateTime.getLastDateOfMonth(da));
					}
					if(co.getInt("teachtype")==2){
						Double yxhks = CoursePlan.coursePlan.getClassOrderMonthLesson(co.getInt("classorderid"),"",end);
							if(!StringUtils.isEmpty(type)){
								sfs.append("0");
								if(type.equals("1")){
									if(yxhks<r.getDouble("classhour")){
										r.set("flag", true);
									}else{
										r.set("flag", false);
									}
								}
								if(type.equals("2")){
									if(yxhks>=r.getDouble("classhour")){
										r.set("flag", true);
									}else{
										r.set("flag", false);
									}
								}
							}
							if(sfs.toString().equals("")){
								if(yxhks<r.getDouble("classhour")){
									r.set("flag", true);
								}else{
									r.set("flag", false);
								}
							}
						Double byxhks = CoursePlan.coursePlan.getClassOrderMonthLesson(co.getInt("classorderid"),begin,end);
						r.set("byxhks", byxhks);
						r.set("yxhks", yxhks);
						r.set("qfe",r.getBigDecimal("realsum").doubleValue()-r.getBigDecimal("paidamount").doubleValue());
						r.set("ddye", yxhks==0?r.getBigDecimal("realsum").doubleValue():(r.getDouble("classhour")-yxhks)*r.getDouble("avgprice"));
						r.set("ddsyks", r.getDouble("classhour")-yxhks);
						r.set("zt",r.getInt("status")==0?"待收":r.getInt("status")==1?"已收":"欠费");
						r.set("sk", "小班");
						r.set("kb", r.getStr("classnum"));
						yzxh+=byxhks*r.getDouble("avgprice");
					}else{
						String sids = null;
						if(r.getStr("subjectids").substring(0, 1).equals("|")){
							sids=r.getStr("subjectids").replaceFirst("\\|", "");
						}else{
							sids=r.getStr("subjectids");
						}
						r.set("subjectname", Subject.dao.getSubjectNameByIds(sids));
							if(!StringUtils.isEmpty(type)){
								sfs.append("0");
								if(type.equals("1")){
									double  d=CoursePlan.coursePlan.getKeShiByCourseOrderId(r.getInt("id"));
									if(d<r.getDouble("classhour")){
										r.set("flag", true);
									}else{
										r.set("flag", false);
									}
								}
								if(type.equals("2")){
									double  d=CoursePlan.coursePlan.getKeShiByCourseOrderId(r.getInt("id"));
									if(d>=r.getDouble("classhour")){
										r.set("flag", true);
									}else{
										r.set("flag", false);
									}
								}
							}
							if(sfs.toString().equals("")){
								double  d=CoursePlan.coursePlan.getKeShiByCourseOrderId(r.getInt("id"));
								if(d<r.getDouble("classhour")){
									r.set("flag", true);
								}else{
									r.set("flag", false);
								}
							}
						
						Double  byxhks = CoursePlan.coursePlan.getCourseOrderIdMonthLesson(r.getInt("id"),begin,end);
						Double  yxhks = CoursePlan.coursePlan.getCourseOrderIdMonthLesson(r.getInt("id"),"",end);
						r.set("byxhks", byxhks);
						r.set("yxhks", yxhks);
						r.set("qfe",r.getBigDecimal("realsum").doubleValue()-r.getBigDecimal("paidamount").doubleValue());
						r.set("ddye", yxhks==0?r.getBigDecimal("realsum").doubleValue():(r.getDouble("classhour")-yxhks)*r.getDouble("avgprice"));
						r.set("ddsyks", r.getDouble("classhour")-yxhks);
						r.set("zt",r.getInt("status")==0?"代收":r.getInt("status")==1?"已收":"欠费");
						r.set("sk", "一对一");
						r.set("kb", Subject.dao.getSubjectNameByIds(sids));
						yzxh+=byxhks*r.getDouble("avgprice");
					}
					r.set("tjyf", begin);
					co.set("isread", 1);
					co.update();
				}
				splitPage.setPage(page);
		}catch(Exception e){
			e.printStackTrace();
		}
		Record record = new Record();
		record.set("flag",true).set("ddsyks","总消耗:").set("ddye", yzxh);
		list.add(record);
		return list;
	}
	
	/**
	 * 订单审核*
	 * @param splitPage
	 * @return
	 */
	public void checkorder(SplitPage splitPage){
		List<Object> paramValue = new ArrayList<Object>();
		StringBuffer select = new StringBuffer("SELECT o.*,s.REAL_NAME studentname,t.REAL_NAME operatorname,DATE_FORMAT(o.createtime,'%Y-%m-%d') otime ,"
				+ "(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount,"
				+ "(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=0) waitcount,"
				+ "(SELECT IFNULL(SUM(classhour),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidclasshour,"
				+ "(SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount,bc.classNum ");
		StringBuffer formSql = new StringBuffer("  FROM crm_courseorder o "
					+ " LEFT JOIN account s ON o.studentid=s.Id "
					+ "	left join crm_opportunity opp on opp.id=s.opportunityid "
					+ " LEFT JOIN account c ON o.operatorid=c.Id "
					+ " LEFT JOIN account t ON o.createuserid=t.Id "
					+ " LEFT JOIN class_order bc ON o.classorderid=bc.id WHERE o.checkstatus <> 1 and o.needcheck = 1 ");
		Map<String,String> queryParam = splitPage.getQueryParam();
		String studentname = queryParam.get("studentname");
		String subjectid = queryParam.get("subjectid");
		String campusSql = queryParam.get("campusSql");
		if (null != studentname && !studentname.equals("")) {
			formSql.append(" AND s.real_name like ? ");
			paramValue.add("%" + studentname + "%");
		}
		if (null != subjectid && !subjectid.equals("")) {
			formSql.append(" AND o.subjectid =? ");
			paramValue.add(Integer.parseInt(subjectid));
		}
		if(!StringUtils.isEmpty(campusSql)){
			formSql.append(campusSql);
		}
		formSql.append(" order BY o.Id desc");
		Page<Record> page = Db.paginate(splitPage.getPageNumber(), splitPage.getPageSize(), select.toString(), formSql.toString(), paramValue.toArray());
		List<Record>  list =page.getList();
		for(Record r:list){
			String sids = null;
			if(!ToolString.isNull(r.getStr("subjectids"))&&r.getStr("subjectids").substring(0, 1).equals("|")){
				sids=r.getStr("subjectids").replaceFirst("\\|", "");
			}else{
				sids=r.getStr("subjectids");
			}
			r.set("subjectname", Subject.dao.getSubjectNameByIds(sids));
		}
		splitPage.setPage(page);
	}
	
	
	@Before(Tx.class)
	public void save(CourseOrder courseOrder) {
		try {
			courseOrder.set("createtime", ToolDateTime.getDate());
			String teachType = courseOrder.getInt("teachtype").toString();
			if("2".equals(teachType)){//小班
//				ClassOrder banci = ClassOrder.dao.findById(courseOrder.getInt("classorderid"));
//				double yyks = CoursePlan.coursePlan.getClassUseClasshour(banci.getPrimaryKeyValue());//获取该班课已上课时
//				courseOrder.set("classhour",ToolArith.sub(banci.getInt("lessonnum"), yyks));
				courseOrder.set("remainclasshour",courseOrder.getDouble("classhour"));
			}
			courseOrder.save();
			Integer banId = courseOrder.getInt("classorderid");
			if(banId !=null&&courseOrder.getInt("status")==1){//班课需要关联用户到班课中
				ClassType.dao.connectStuToClass(courseOrder.getInt("studentid").toString(),banId);
				ClassType.dao.updateNewStuCourse(courseOrder.getInt("studentid"),banId);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("添加数据异常");
		}
	}
	
	@Before(Tx.class)
	public void update(CourseOrder courseOrder) {
		try {
			courseOrder.set("updatetime", new Date());
			courseOrder.update();
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException("更新数据异常");
		}
	}

	public List<AccountBanci> finByAccountId(String studentId) {
		List<AccountBanci> banciList = AccountBanci.dao.findByAccountId(studentId);
		Iterator<AccountBanci> it = banciList.iterator();
		while(it.hasNext()){
			AccountBanci ab = it.next();
			List<CourseOrder> colist = CourseOrder.dao.findCOByStuClassId(studentId,ab.getInt("banci_id"));
			if(colist.size()>0){
				it.remove();
			}
		}
		return banciList;
	}

	/**
	 * 获取某个学生的所有courseorder
	 * @param id
	 * @return
	 */
	public List<CourseOrder> getStudentCourseOrderlists(String id) {
		List<CourseOrder> list = CourseOrder.dao.queryStudentAllCourseOrders(id);
		processSubjectNames(list);
		return list;
	}
	
	/**
	 * 处理订单的科目名称
	 * @param courseOrderList
	 */
	private void processSubjectNames(List<CourseOrder> courseOrderList) {
		for (CourseOrder courseOrder : courseOrderList) {
			String sids = null;
			if(!StringUtils.isEmpty(courseOrder.getStr("subjectids"))&&courseOrder.getStr("subjectids").substring(0, 1).equals("|")){
				sids=courseOrder.getStr("subjectids").replaceFirst("\\|", "");
			}else{
				sids=courseOrder.getStr("subjectids");
			}
			courseOrder.put("subjectname", Subject.dao.getSubjectNameByIds(sids));
		}
	}

	/**
	 * 导出
	 * @param response
	 * @param request
	 * @param list
	 * @param filename
	 */
	public void export(HttpServletResponse response, HttpServletRequest request, SplitPage splitPage, String filename) {
		List<Object> paramValue = new ArrayList<Object>();
		String select = "SELECT o.*,s.REAL_NAME studentname,t.REAL_NAME operatorname,DATE_FORMAT(o.createtime,'%Y-%m-%d') otime ,\n" +
				"(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id) paycount,\n" +
				"(SELECT COUNT(1) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=0) waitcount,\n" +
				"(SELECT IFNULL(SUM(classhour),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidclasshour,\n" +
				"(SELECT IFNULL(SUM(amount),0) FROM crm_payment p WHERE p.orderid=o.id AND p.ispay=1) paidamount,bc.classNum,x.consumptionhour,x.consumptioncost \n";
			StringBuffer formSql =  new StringBuffer("FROM crm_courseorder o \n" +
					"LEFT JOIN account s ON o.studentid=s.Id\n" +
					"LEFT JOIN crm_opportunity opp ON opp.id=s.opportunityid  \n" +
					"LEFT JOIN account c ON o.operatorid=c.Id  LEFT JOIN account t ON o.createuserid=t.Id\n" +
					"LEFT JOIN (SELECT b.courseorderid,SUM(b.classhour) consumptionhour,SUM(b.realamount) consumptioncost FROM account_book b GROUP BY b.courseorderid) x ON o.id=x.courseorderid\n" +
					"LEFT JOIN class_order bc ON o.classorderid=bc.id \n" +
					"WHERE o.checkstatus = 1");
			Map<String,String> queryParam = splitPage.getQueryParam();
			String studentname = queryParam.get("studentname");
			String campusSql = queryParam.get("campusSql");
			String teachtype = queryParam.get("teachtype");
			String status = queryParam.get("status");
			String beginDate = queryParam.get("beginDate");
			String endDate = queryParam.get("endDate");
			if (null != studentname && !studentname.equals("")) {
				formSql.append(" AND s.real_name like ? ");
				paramValue.add("%" + studentname + "%");
			}
			if(!StringUtils.isEmpty(campusSql)){
				formSql.append(campusSql);
			}
			if (null != teachtype && !teachtype.equals("")) {
				formSql.append(" AND o.teachtype = ? ");
				paramValue.add(teachtype);
			}
			if (null != status && !status.equals("")) {
				formSql.append(" AND o.status = ? ");
				paramValue.add(Integer.parseInt(status));
			}
			if (!ToolString.isNull(beginDate)) {
				formSql.append(" AND o.createtime >= ? ");
				paramValue.add(beginDate+" 00:00:00");
			}
			if (!ToolString.isNull(endDate)) {
				formSql.append(" AND o.createtime <= ? ");
				paramValue.add(endDate+" 59:59:59");
			}
			formSql.append(" ORDER BY o.id desc");
			List<Record> list = Db.find(select+formSql.toString(), paramValue.toArray());
		for (Record record : list) {
			String sids = null;
			if (!StringUtils.isEmpty(record.getStr("subjectids")) && record.getStr("subjectids").substring(0, 1).equals("|")) {
				sids = record.getStr("subjectids").replaceFirst("\\|", "");
			} else {
				sids = record.getStr("subjectids");
			}
			record.set("subjectname", Subject.dao.getSubjectNameByIds(sids));
			record.set("zt", record.getInt("status") == 0 ? "待收" : record.getInt("status") == 1 ? "已收" : "欠费");
			record.set("kb", record.getInt("teachtype") == 1 ? record.getStr("subjectname") : record.getStr("classNum"));
			record.set("sk", record.getInt("teachtype") == 1 ? "1对1" : "班课");
			record.set("kb", record.getInt("teachtype") == 1 ? record.getStr("subjectname") : record.getStr("classNum"));
			double paidAmount = record.getBigDecimal("paidamount")==null?0:record.getBigDecimal("paidamount").doubleValue();
			double realsum = record.getBigDecimal("realsum")==null?0:record.getBigDecimal("realsum").doubleValue();
			record.set("qfe",ToolArith.sub(realsum,paidAmount));
			double consumptionHour = record.getDouble("consumptionhour") == null ? 0 : record.getDouble("consumptionhour");
			double consumptionCost = record.getBigDecimal("consumptioncost") == null ? 0 : record.getBigDecimal("consumptioncost").doubleValue();
			record.set("consumptionHour", consumptionHour);
			record.set("consumptioncost", consumptionCost);
			record.set("ddye", ToolArith.sub(realsum, consumptionCost));
			record.set("syks", ToolArith.sub(record.getDouble("classhour"), consumptionHour));

		}
		List<Pair> titles = new ArrayList<Pair>();
		titles.add(new Pair("studentname","姓名"));
		titles.add(new Pair("ordernum","订单号"));
		titles.add(new Pair("otime","订单日期"));
		titles.add(new Pair("zt","状态"));
		titles.add(new Pair("operatorname","提交人"));
		titles.add(new Pair("sk","授课"));
		titles.add(new Pair("kb","科目/班次"));
		titles.add(new Pair("realsum","应收额"));
		titles.add(new Pair("paidamount","已收额"));
		titles.add(new Pair("qfe","欠费额"));
		titles.add(new Pair("classhour","总课时"));
		titles.add(new Pair("avgprice","课时费"));
		titles.add(new Pair("consumptionhour","消耗课时"));
		titles.add(new Pair("consumptioncost","消耗费用"));
		titles.add(new Pair("syks","剩余课时"));
		titles.add(new Pair("ddye","订单余额"));
		ExcelExportUtil.exportByRecord(response, request, filename, titles , list);
	}
	/**
	 * 发送邮件
	 * @param str
	 * @param str2
	 * @param mailSubject
	 * @param string
	 * @param url
	 * @return
	 */
	public JSONObject sendOrderPayMessage(String toMail, String ccMail, String paydate, String report, String url,String studentid) {
		JSONObject json = new JSONObject();
		try{
			String content = "";
			json = getPayMessage(report,url,studentid,paydate);
			if(json.getString("code").equals("1")){
				content = json.getString("content");
			}
			
			boolean flag = ToolMail.sendMail(true, toMail,ccMail, "账单信息", content, true, true);
			if(!flag){
				json.put("code", "0");
				json.put("msg", "发送失败,请检查邮箱填写正确");
			}else{
				json.put("code", "1");
				json.put("msg", "发送成功");
			}
			return json;
		}catch(Exception ex){
			json.put("code", "0");
			json.put("msg", "发送失败.");
			return json;
		}
		
	}

	private JSONObject getPayMessage(String report, String url,String studentid,String paydate) {
		Organization org = Organization.dao.findById(1);
		JSONObject json = new JSONObject();
		String content = report.replace("/n", "").replace("section{margin:20px 0}", "section{margin:50px 0}").replace("/images/logo/logo_menu.png", url+"/images/logo/logo_menu.png");
		Map<String,String> map = new HashMap<String,String>();
		StringBuffer sf = new StringBuffer();
		List<CourseOrder> colist  = CourseOrder.dao.findArrearByStudentId(studentid);
		Student s = Student.dao.findById(studentid);
		Double totelqfe = 0.0;
		for(CourseOrder co:colist ){
			CourseOrder c = CourseOrder.dao.findById(co.getInt("id"));
			sf.append("<tr  align='center'  height='30px;'><td><div style='padding-top:2px;'>").append(c.getInt("teachtype")==1?c.getStr("subjectname"):c.getStr("classnum")).append("</div></td>");
			sf.append("<td><div style='padding-top:2px;'>").append(c.getNumber("classhour")).append("</div></td>");
			sf.append("<td><div style='padding-top:2px;'>").append(c.getNumber("avgprice")).append("</div></td>");
			sf.append("<td><div style='padding-top:2px;'>").append(c.getNumber("realsum").doubleValue()-(c.getBigDecimal("paidamount")==null?0.0:c.getBigDecimal("paidamount").doubleValue())).append("</td></tr>");
			totelqfe +=c.getNumber("realsum").doubleValue()-(c.getBigDecimal("paidamount")==null?0.0:c.getBigDecimal("paidamount").doubleValue());
		}
		map.put("url", url);
		map.put("paymessage", sf.toString());
		map.put("datelimit", paydate);
		map.put("studentname", s.getStr("real_name"));
		map.put("date", new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
		map.put("total", totelqfe.toString());
		map.put("bankAccountName", org.getStr("bankAccountName"));
		map.put("bankAccountNumber", org.getStr("bankAccountNumber"));
		map.put("bankAddress", org.getStr("bankAddress"));
		content = replaceOperator(content,map);
		json.put("code", "1");
		json.put("content", content);
		return json;
	}
	public String replaceOperator(String source , Map<String, String> paramsMap)
	{
		if(paramsMap.size() == 0 )
		{
			return source ; 
		}
		StringBuffer sb = new StringBuffer();
		/*将${wangsh}的值替换掉*/
		Matcher matcher = Pattern.compile("(\\$\\{)([\\w]+)(\\})").matcher(source);
		while(matcher.find())
		{
			if(paramsMap.get(matcher.group(2)) != null )
			{
				matcher.appendReplacement(sb, paramsMap.get(matcher.group(2))) ;
			}
		}
		matcher.appendTail(sb);
		return sb.toString() ; 
	}
}
