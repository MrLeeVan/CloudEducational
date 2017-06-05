
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

package com.momathink.teaching.classtype.model;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolArith;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.common.tools.ToolString;
import com.momathink.teaching.campus.model.Campus;


/**班次(小班)*/
@SuppressWarnings("serial")
@Table(tableName="class_order")
public class ClassOrder extends BaseModel<ClassOrder> {
	
	public static final ClassOrder dao = new ClassOrder();

	/**
	 * 取得当前已有班次的最大数
	 * @return
	 */
	public static String getMaxIndex() {
		String curDate = ToolDateTime.getCurDate();
		String year = curDate.substring(2, 4);
		String month = curDate.substring(5, 7);
		String index = null;
		String ym = year+month;
		ClassOrder classOrder = ClassOrder.dao.findFirst("SELECT MAX(classNum) AS classNum FROM class_order WHERE classNum LIKE '"+ym+"%'");
		String classNum = classOrder.getStr("classNum");
		if(StringUtils.isEmpty(classNum)){
			index = "001";
		} else {
			String lastThreeNum = classNum.substring(classNum.length() - 3);
			if(ToolString.isNum(lastThreeNum))
				index = String.format("%03d", Integer.parseInt(lastThreeNum) + 1);
			else
				index = "001";
		}
		return  year + month + index;
	}

	/**
	 * 添加班次信息
	 * @param classNum
	 * @param classtype_id
	 * @param stuNum
	 * @param lessonNum
	 * @param teachTime
	 */
	public static void addClassOrder(String pcid,String classNum, Integer classtype_id, Integer stuNum, Integer lessonNum,Integer totalfee,Integer isassesment) {
		new ClassOrder().set("pcid", pcid).set("classNum", classNum).set("classtype_id", classtype_id).set("stuNum", stuNum).set("lessonNum", lessonNum).set("totalfee", totalfee).set("is_assesment", isassesment).save();
	}

	/**
	 * 取得所有的班次信息
	 * @param subject_id
	 * @param course_id
	 * @return
	 */
	public static List<ClassOrder> getClassOrder(Integer subject_id) {
		List<ClassOrder> list = ClassOrder.dao.find("SELECT\n" 
	 + "	class_order.classtype_id,\n" + "	class_order.classNum,\n"
				+ "	class_order.stuNum,\n" + "	class_order.lessonNum,\n" + "	class_order.teachTime,\n" + "	class_order.id,\n"
				+ "	class_type.`name`,\n" + "	class_type.teach_type,\n" + "	class_type.subject_id,\n" + "	class_type.course_id\n" + "FROM\n"
				+ "	class_order\n" + "LEFT JOIN class_type ON class_type.id = class_order.classtype_id\n" + "WHERE\n"
				+ "	class_type.subject_id = ?\n", subject_id);
		return list;

	}

	/**
	 * 获取该班次的选择人数等信息
	 */
	public static ClassOrder getClassOrderById(Integer class_id) {
//		String sql = "SELECT\n" +
//				"	class_order.classNum,\n" +
//				"	class_order.stuNum,\n" +
//				"	class_order.lessonNum,\n" +
//				"	class_order.teachTime,\n" +
//				"	class_type.`name`,\n" +
//				"	Count(account.class_id) AS countStuNum,\n" +
//				"	(\n" +
//				"		SELECT\n" +
//				"			Count(t.id)\n" +
//				"		FROM\n" +
//				"			(\n" +
//				"				SELECT\n" +
//				"					*\n" +
//				"				FROM\n" +
//				"					courseplan\n" +
//				"				WHERE\n" +
//				"					courseplan.class_id = ?\n" +
//				"				GROUP BY\n" +
//				"					courseplan.COURSE_TIME,\n" +
//				"					courseplan.TIMERANK_ID\n" +
//				"			) AS t\n" +
//				"	) AS countNum\n" +
//				"FROM\n" +
//				"	class_order\n" +
//				"LEFT JOIN class_type ON class_order.classtype_id = class_type.id\n" +
//				"LEFT JOIN account ON class_order.id = account.class_id\n" +
//				"WHERE\n" +
//				"	class_order.id = ?\n" +
//				"GROUP BY\n" +
//				"	class_order.classNum,\n" +
//				"	class_order.stuNum,\n" +
//				"	class_order.lessonNum,\n" +
//				"	class_order.teachTime,\n" +
//				"	class_type.`name`";
		
//		String sql = "SELECT\n" +
//				"class_order.classNum,\n" +
//				"class_type.`name`,\n" +
//				"class_order.teachTime\n" +
//				"FROM\n" +
//				"class_order\n" +
//				"LEFT JOIN banci_course ON class_order.classtype_id = banci_course.type_id\n" +
//				"LEFT JOIN class_type ON class_order.classtype_id = class_type.id\n" +
//				"WHERE\n" +
//				"banci_course.subject_id = ? ";
//		ClassOrder classOrder = ClassOrder.dao.findFirst(sql, class_id,class_id);
		return null;
	}
	
	/**
	 * 根据学生ID和科目查询可用班次
	 * 
	 * @param studentId
	 * @param subjectIds
	 * @return
	 */
	public List<ClassOrder> queryBanciByStudentId(String studentId, String subjectIds) {
		String sql = "SELECT co.*,ct.`name` bxname FROM class_order co LEFT JOIN class_type ct ON co.classtype_id=ct.id WHERE co.endTime IS NULL OR co.endTime>CURDATE()";
//		if(!ToolString.isNull(subjectIds)){
//			sql +="AND co.id IN( SELECT bc.banci_id FROM banci_course bc WHERE bc.subject_id IN("+subjectIds.substring(1)+"))";
//		}
		List<ClassOrder> recordList = ClassOrder.dao.find(sql);//所有班次
		if (recordList.size() > 0) {
			if (!ToolString.isNull(studentId) && !"0".equals(studentId)) {
				List<Record> studentcp = Db.find("SELECT * FROM courseplan WHERE student_id=? AND class_id=0 ", Integer.parseInt(studentId));// 查询该用户的一对一排课
				if (studentcp.size() > 0) {
					for (Record stucp : studentcp) {
						String course_time = ToolDateTime.getStringTimestamp(stucp.getTimestamp("COURSE_TIME"));
						Integer timerank_id = stucp.getInt("TIMERANK_ID");
						circle: for (int i = 0; i < recordList.size(); i++) {// 遍历所有可选班次的排课
							int class_id = recordList.get(i).getInt("id");
							List<Record> record2 = Db.find("SELECT DATE_FORMAT(COURSE_TIME,'%Y-%m-%d') AS COURSE_TIME,TIMERANK_ID,class_id,STUDENT_ID FROM courseplan WHERE class_id=? ", class_id);
							if (record2.size() > 0) { // 该班次已有排课
								for (Record rec2 : record2) {
									if (course_time.equals(rec2.get("COURSE_TIME")) && timerank_id == rec2.getInt("TIMERANK_ID")) {
										recordList.remove(i);
										break circle;
									}
								}
							}
						}
					}
					return recordList;
				} else {
					// 一对一排课为空则返回
					return recordList;
				}
			} else {
				return recordList;
			}
		} else {
			return null;
		}

	}
	
	/**
	 * 查询当前学生所属校区没有结束的班次,
	 * @return
	 */
	public List<ClassOrder> findCanBuyByStudentId(String studentId) {
		if(StringUtils.isEmpty(studentId)){
			return null;
		}else{
			Integer campusId = Campus.dao.getCampusIdByStudentId( studentId );
			List<ClassOrder> list = dao.find("SELECT o.* ,t.`name` classTypeName FROM class_order o LEFT JOIN class_type t ON o.classtype_id=t.id WHERE ( o.endTime IS NULL OR o.endTime>NOW() ) "
					+ " and o.campusId = ? ORDER BY o.id DESC", campusId );
			return list;
		}
	}
	
	/**
	 * 查询还么有结束的班次
	 * @return
	 */
	public List<ClassOrder> findCanBuy(String studentId) {
		if(StringUtils.isEmpty(studentId)){
			return null;
		}else{
			Integer campusId = Campus.dao.getCampusIdByStudentId( studentId );
			List<ClassOrder> list = dao.find("SELECT o.* ,t.`name` classTypeName FROM class_order o LEFT JOIN class_type t ON o.classtype_id=t.id WHERE o.endTime IS NULL OR o.endTime>NOW() "
					+ " and o.campusId = ? ORDER BY o.id DESC", campusId );
//			List<Record> studentcp = Db.find("SELECT COURSE_TIME,TIMERANK_ID FROM courseplan WHERE student_id=? and COURSE_TIME > curdate() ", Integer.parseInt(studentId));// 查询该用户的所有排课
//			List<CourseOrder> olist = CourseOrder.dao.findByStudentId(studentId);
//			if (studentcp.size() > 0) {
//				for (Record stucp : studentcp) {
//					List<Record> ykxb = Db.find("SELECT DISTINCT class_id FROM courseplan WHERE class_id!=0 and COURSE_TIME = ? and TIMERANK_ID = ?  ", stucp.getTimestamp("COURSE_TIME"),stucp.getInt("TIMERANK_ID"));
//					if (ykxb.size() > 0) { // 该班次已有排课
//						circle: for (int i = 0; i < list.size(); i++) {// 遍历所有可选班次的排课
//							Integer class_id = list.get(i).getInt("id");
//							for (Record rec : ykxb) {
//								if (class_id.equals(rec.getInt("class_id"))) {
//									list.remove(i);
//									break circle;
//								}
//							}
//						}
//					}
//				}
//			}
//			if(olist!=null&&olist.size()>0){
//				for(CourseOrder o : olist){
//					Integer banId = o.getInt("classorderid");
//					if(banId!=null){
//						circle: for (int i = 0; i < list.size(); i++) {// 遍历所有可选班次的排课
//							Integer class_id = list.get(i).getInt("id");
//							if (banId.equals(class_id)) { // 已购买
//								list.remove(i);
//								break circle;
//							}
//						}
//					}
//				}
//			}
			return list;
		}
	}

	public Long getOrderNameSure(String name) {
		String sql = "select count(id) as namecount from class_order where classNum = ? ";
		Long count = ClassOrder.dao.find(sql, name).get(0).get("namecount");
		return count;
	}

	public Map<String,Object> getClassOrderCourseUsed(String classOrderId, String courseid) {
		String sql = " select SUM(tr.class_hour) classhours FROM courseplan cp LEFT JOIN account xb on xb.Id = cp.STUDENT_ID "
				+ "LEFT JOIN class_order co ON xb.REAL_NAME = co.classNum  LEFT JOIN time_rank tr ON tr.Id=cp.TIMERANK_ID "
				+ "WHERE xb.STATE = 2 AND cp.STATE=1  AND co.id= ?  AND cp.COURSE_ID = ? ";
		Record record = Db.findFirst(sql, classOrderId, courseid);
		Map<String,Object> map = new HashMap<String,Object>();
		if(record==null){
			map.put("used", 0+"");
			map.put("min", 0+"");
		}else{
			BigDecimal count = record.getBigDecimal("classhours");
			if(count==null){
				map.put("used", 0+"");
				map.put("min", 0+"");
			}else{
				String[] arrcount = count.toString().split("\\.");
				if(arrcount[1].equals("0")){
					map.put("used", count.toString());
					map.put("min", arrcount[0]);
				}else if(arrcount[1].equals("5")){
					map.put("used", count.toString());
					map.put("min", String.valueOf((Integer.parseInt(arrcount[0])+1)));
				}else{
					map.put("used", 0+"");
					map.put("min", 0+"");
				}
			}
		}
		return map;					
	}

	/**
	 * 根据虚拟用户ID获取所属班次（班课）
	 * @param parseInt
	 * @return
	 */
	public ClassOrder findByXuniId(Integer parseInt) {
		String sql = "select * from class_order where accountid=? ";
		ClassOrder classOrder = ClassOrder.dao.findFirst(sql, parseInt); 
		return classOrder;
	}
	
	public ClassOrder getClassOrderDetailMsg(String coid){
		String sql = "select co.*,ct.name ctname from class_order co left join class_type ct on ct.id=co.classtype_id where co.id=? ";
		return dao.findFirst(sql, coid);
	}
	/**
	 * 获取所有的班次*
	 * @return
	 */
	public List<ClassOrder> getAllClassOrder(){
		String sql ="select co.*,ct.name ctname from class_order co left join class_type ct on ct.id=co.classtype_id order by ct.id";
		return dao.find(sql);
	}
	/**
	 * 根据学生id查询班次
	 * @param id
	 * @return
	 */
	public List<ClassOrder> finfByStudentid(Integer id) {
		String  sql ="SELECT co.id FROM class_order co "
				+ " LEFT JOIN account_banci ab on ab.banci_id = co.id "
				+ " LEFT JOIN account  s on ab.account_id = s.Id "
				+ " where s.Id = ? GROUP BY co.id";
		return dao.find(sql,id);
	}
	
	/**
	 * 根据ID获取班次
	 * @author David
	 * @param id 班次ID
	 */
	public ClassOrder findById(Integer id){
		String sql = "select o.*,t.`name` classTypeName from class_order o left join class_type t on o.classtype_id=t.id where o.id=?";
		return dao.findFirst(sql, id);
	}

	/**
	 * 根据学生ID获取学生已购买的小班课
	 * @param studentId
	 * @return
	 */
	public List<ClassOrder> getClassOrderByStudentId(Integer studentId) {
		String sql = "select ban.id,ban.classNum,co.`status` from crm_courseorder co left join class_order ban ON co.classorderid=ban.id WHERE co.studentid=? AND co.teachtype=2 AND co.delflag=0";
		return dao.find(sql, studentId);
	}

	/**
	 * 更新开班时间和结束时间
	 * id: 班次id或学生id
	 * classType,2小班1一对一
	 */
	public void updateTeachTime(Integer classOrderId){
		String sql="SELECT SUM(tr.class_hour) classhour,MIN(DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d')) startdate,MAX(DATE_FORMAT(cp.COURSE_TIME,'%Y-%m-%d')) enddate FROM courseplan cp LEFT JOIN time_rank tr ON cp.TIMERANK_ID=tr.Id WHERE cp.class_id=? AND cp.PLAN_TYPE=0";
		Record record = Db.findFirst(sql, classOrderId);
		ClassOrder classOrder = ClassOrder.dao.findById(classOrderId);
		int lessonNum = classOrder.getInt("lessonNum");
		double planHour = record.getBigDecimal("classhour")==null?0:record.getBigDecimal("classhour").doubleValue();
		classOrder.set("teachTime", record.getStr("startdate"));
		if(classOrder.getInt("chargeType")==1&&ToolArith.compareTo(planHour, lessonNum)==0){//按期更新结束时间
			classOrder.set("endTime", record.getStr("enddate"));
		}
		classOrder.update();
	}
	/**
	 * 获取班级列表
	 * @return
	 */
	public Object getClassOrderList() {
		String querySql = "select * from class_order" ;  
		return dao.find(querySql);
	}
	/**
	 * 获取校区所有的班次*
	 * @return
	 */
	public List<ClassOrder> getAllClassOrderByCampusIds( String campusids){
		String sql ="select co.*,ct.name ctname from class_order co left join class_type ct on ct.id=co.classtype_id where co.campusId in (" +campusids +")order by ct.id";
		return dao.find(sql);
	}
	/**
	 * 获取校区所有班级列表
	 * @return
	 */
	public Object getClassOrderListByCampusIds( String campusIds) {
		String querySql = "select * from class_order where campusId in (" + campusIds + ")";  
		return dao.find(querySql);
	}
}
