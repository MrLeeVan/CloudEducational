

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

package com.momathink.sys.leave.service;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.alibaba.druid.util.StringUtils;
import com.jfinal.kit.StrKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.momathink.common.base.BaseService;
import com.momathink.common.base.SplitPage;
import com.momathink.common.tools.ToolDateTime;
import com.momathink.sys.leave.model.StudentAskingLeave;
import com.momathink.sys.leave.model.StudentLeaveReview;

public class StudentLeaveAskingService extends BaseService {
	private static String QUERYALLLIST = "1"; //学生请假列表查询所有
	private static String QUERYMYLIST = "0"; //学生请假列表查询我的发送

	public void askingList(Integer sysUserId , SplitPage splitPage , String loginRoleCampusIds ) {
		StringBuilder fromSqlSb = new StringBuilder();
		List< Object > paramValues = new LinkedList< Object >();
		Map< String , String > paramMap = splitPage.getQueryParam();
		
		String selectSql = 
				" SELECT asking.id , DATE_FORMAT(asking.createdate,'%Y-%m-%d %H:%i') AS createdate, asking.state , DATE_FORMAT(asking.starttime, '%Y-%m-%d %H:%i') AS starttime,"
				+ " DATE_FORMAT(asking.endtime, '%Y-%m-%d %H:%i') AS endtime, asking.type , "
				+ " stu.real_name stuName , stu.tel stuNum ";
		fromSqlSb.append( " FROM jw_leaveasking asking  " );
		fromSqlSb.append( " LEFT JOIN account stu on stu.id = asking.studentid WHERE 1=1 " );
		
		String queryType = paramMap.get( "queryType" );//1：所有请假列表；0我的申请	
		if( StrKit.notBlank( queryType ) && QUERYMYLIST.equals( queryType ) ) {
			//我的申请列表
			fromSqlSb.append( " and asking.applyuserid = " ).append( sysUserId );
		} else {
			fromSqlSb.append( " and asking.state != 1 " );
		}
		
		if( !StringUtils.isEmpty( loginRoleCampusIds)){
			fromSqlSb.append( " and stu.campusid in (" + loginRoleCampusIds + ")" );
		}
		Set< String > keySet = paramMap.keySet();
		for( String key : keySet ) {
			String value = paramMap.get( key );
			if( "stuNum".equals( key ) ) {
				fromSqlSb.append(  " and stu.num like ? " );
				paramValues.add( "%" + value + "%" );
			}
			if( "stuName".equals( key ) ) {
				fromSqlSb.append(  " and upper(stu.name) like ? " );
				paramValues.add( "%" + value.toUpperCase() + "%" );
			}
			if( "studentid".equals( key ) ) {
				fromSqlSb.append(  " and asking.studentid = ? " );
				paramValues.add(value);
			}
			if( "queryLeaveDay".equals( key ) ) {
				fromSqlSb.append( " and date_format( starttime , '%Y-%m-%d' ) <= ? and date_format( endtime , '%Y-%m-%d' ) >= ? " );
				paramValues.add( value );
				paramValues.add( value );
			}
			if( "queryStatus".equals( key ) ) {
				fromSqlSb.append( " and asking.state = ? " );
				paramValues.add( value );
			}
		}
		fromSqlSb.append(" ORDER BY asking.createdate DESC ");
		Page< Record > page = Db.paginate( splitPage.getPageNumber() , splitPage.getPageSize() , selectSql ,
					fromSqlSb.toString() , paramValues.toArray() );
		List< Record > recordList = page.getList() ;
		for( Record record : recordList ) {
			Integer recordState = record.getInt( "state" );
			/*awaitingReview= 待审核  revocation= 撤销  approval= 通过 reviewFail= 未通过 underReview= 审核中*/
			String stateCode = recordState == 4 ? "underReview" : recordState == 3 ? "reviewFail" :
				recordState == 2 ? "approval" : recordState == 1 ? "revocation" : "awaitingReview" ; 
			record.set( "stateCode" , stateCode );
		}
		
		splitPage.setPage( page );
		
	}
	
	
	//保存审批状态
	public void saveApprovalResult( StudentLeaveReview leaveReview ) {
		leaveReview.set( "approvaldate" , ToolDateTime.getDate() );
		boolean flag = leaveReview.update();
		if( flag ) {
			StudentLeaveReview currentReview = StudentLeaveReview.dao.findById( leaveReview.getInt( "id" ) );
			Integer leaveAskingId = currentReview.getInt( "leaveaskingid" );
			int nextOrders = currentReview.getInt( "orders" ) + 1;
			StudentLeaveReview nextReviewer = StudentLeaveReview.dao.queryOrderReviewInState( leaveAskingId , nextOrders, 0 );
			int askingState = 4 ;
			if( nextReviewer == null ) {
				askingState = currentReview.getInt( "state" );
			} else {
				nextReviewer.set( "state" , 1 ).update();
				askingState = 4;
			}
			StudentAskingLeave.dao.updateAskingLeaveState( askingState , leaveAskingId );
		}
	}
	
	
	
	
	
	
	
	

	//审批请假
	public void myAwaiting( Integer sysUserId , SplitPage splitPage ) {
		StringBuilder fromSqlSb = new StringBuilder();
		List< Object > paramValues = new LinkedList< Object >();
		Map< String , String > paramMap = splitPage.getQueryParam();
		
		String selectSql = " select asking.id , asking.createdate , asking.state , asking.starttime , asking.endtime, asking.type , "
				+ " stu.real_name stuName , stu.tel stuNum , review.id reviewId ";
		fromSqlSb.append( " from jw_leaveasking asking left join jw_leavereview review on review.leaveaskingid = asking.id " );
		fromSqlSb.append( " left join account stu on stu.id = asking.studentid where asking.state != 1 and review.reviewer = ? " );
		paramValues.add( sysUserId );
		
		String queryType = paramMap.get( "queryType" );//1：审核记录；0待我审核	
		if( StrKit.notBlank( queryType ) && QUERYALLLIST.equals( queryType ) ) {
			fromSqlSb.append( " and review.state != 1 and review.state != 0 " );
		} else {
			//待我审核
			fromSqlSb.append( " and review.state = 1 and ( asking.state = 0 or asking.state = 4 ) " );
		}
		
		
		Set< String > keySet = paramMap.keySet();
		for( String key : keySet ) {
			String value = paramMap.get( key );
			if( "stuNum".equals( key ) ) {
				fromSqlSb.append(  " and stu.num like ? " );
				paramValues.add( "%" + value + "%" );
			}
			if( "stuName".equals( key ) ) {
				fromSqlSb.append(  " and upper(stu.name) like ? " );
				paramValues.add( "%" + value.toUpperCase() + "%" );
			}
			if( "queryLeaveDay".equals( key ) ) {
				fromSqlSb.append( " and date_format( starttime , '%Y-%m-%d' ) <= ? and date_format( endtime , '%Y-%m-%d' ) >= ? " );
				paramValues.add( value );
				paramValues.add( value );
			}
			if( "queryStatus".equals( key ) ) {
				fromSqlSb.append( " and asking.state = ? " );
				paramValues.add( value );
			}
		}
		
		Page< Record > page = Db.paginate( splitPage.getPageNumber() , splitPage.getPageSize() , selectSql ,
				fromSqlSb.toString() , paramValues.toArray() );
		List< Record > recordList = page.getList() ;
		for( Record record : recordList ) {
			Integer recordState = record.getInt( "state" );
			/*awaitingReview= 待审核  revocation= 撤销  approval= 通过 reviewFail= 未通过 underReview= 审核中*/
			String stateCode = recordState == 4 ? "underReview" : recordState == 3 ? "reviewFail" :
				recordState == 2 ? "approval" : recordState == 1 ? "revocation" : "awaitingReview" ; 
			record.set( "stateCode" , stateCode );
		}
		
		splitPage.setPage( page );
		
	}



}

