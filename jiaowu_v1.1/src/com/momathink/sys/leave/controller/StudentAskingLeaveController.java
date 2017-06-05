
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

package com.momathink.sys.leave.controller;

import java.util.List;

import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.momathink.common.annotation.controller.Controller;
import com.momathink.common.base.BaseController;
import com.momathink.sys.leave.model.StudentAskingLeave;
import com.momathink.sys.leave.model.StudentLeaveReview;
import com.momathink.sys.leave.service.StudentLeaveAskingService;
import com.momathink.sys.system.model.SysUser;

/**
 * 学生请假
 */
@Controller( controllerKey="/leave" )
public class StudentAskingLeaveController extends BaseController {
	
	private static final StudentLeaveAskingService leaveAskingService = new StudentLeaveAskingService();
	private static final Logger log = Logger.getLogger( StudentAskingLeaveController.class );
	
	public void list() {
		try {
			Integer sysUserId = getSysuserId();
			leaveAskingService.askingList( sysUserId , splitPage , getAccountCampus() );
			renderJsp( "list.jsp" );
		} catch (Exception e) {
			log.error( "studentAskingLeavelist" , e );
			renderError( 500 ) ; 
		}
	}
	
	/**
	 * 新建请假申请
	 */
	public void newAsking() {
		List< SysUser > approverLists = SysUser.dao.queryAllSysUserInState( getAccountCampus() );
		setAttr( "sysUserLists" , approverLists );
		renderJsp( "newasking.jsp" );
	}
	
	@Before( Tx.class )
	public void saveApplication() {
		JSONObject resultJson = new JSONObject();
		try {
			Integer sysUserId = getSysuserId();
			StudentAskingLeave askingLeave = getModel( StudentAskingLeave.class );
			Integer leaveId = StudentAskingLeave.dao.saveStudentLeaveAsking( askingLeave , sysUserId );
			
			if( null != leaveId ) {
				String[] orderArr = getParaValues( "approverOrder" );
				String[] userIds = getParaValues( "userIds" );//微站端传过来的数据
				if(orderArr != null)
					for( String order : orderArr )
						StudentLeaveReview.dao.saveStudentLeaveApprovers( leaveId , order , getPara( "userId_" + order ) );
				else
					for (int i = 0; i < userIds.length; i++)
						StudentLeaveReview.dao.saveStudentLeaveApprovers( leaveId , (i+"") , userIds[i] );
				
				StudentLeaveReview.dao.updateReviewertoReady( leaveId , 0 );
			}
			
			resultJson.put( "flag" , true );
		} catch ( Exception e ) {
			log.error( "saveApplication" , e );
			resultJson.put( "flag" , false );
			resultJson.put( "msg" , "系统异常" );
		}
		renderJson( resultJson );
	}
	
	public void revocation() {
		try {
			String askingId = getPara( "askingId" );
			StudentAskingLeave.dao.revocationAsking( askingId );
			renderJson(true);
		} catch ( Exception e ) {
			log.error( "revocation" , e );
			renderJson( false );
		}
	}
	
	public void viewAskingDetail() {
		try {
			String askingId = getPara();
			StudentAskingLeave studentLeave = StudentAskingLeave.dao.queryLeaveAskingById( askingId );
			setAttr( "studentLeave" ,studentLeave );
			
			List< StudentLeaveReview > reviewDetail = StudentLeaveReview.dao.queryLeaveReview( askingId );
			setAttr( "reviewDetail" , reviewDetail );
			
			renderJsp( "viewaskingdetail.jsp" );
		} catch (Exception e) {
			log.error( "viewAskingDetail" , e );
			renderError( 500 );
		}
	}
	
	public void approval() {
		try {
			String leaveViewId = getPara();
			StudentLeaveReview approvalReview = StudentLeaveReview.dao.queryStayReviewDetail( leaveViewId );
			setAttr( "leaveReview" , approvalReview );
			
			if( null != approvalReview ) {
				String askingId = approvalReview.getInt( "leaveaskingid" ).toString();
				StudentAskingLeave studentLeave = StudentAskingLeave.dao.queryLeaveAskingById( askingId );
				setAttr( "studentLeave" ,studentLeave );
				
				List< StudentLeaveReview > reviewDetail = StudentLeaveReview.dao.queryLeaveReview( askingId );
				setAttr( "reviewDetail" , reviewDetail );
				
				renderJsp( "viewaskingdetail.jsp" );
			}
		} catch (Exception e) {
			log.error( "approval" , e );
			renderError( 500 );
		}
	}
	
	public void saveApprovalResult() {
		try {
			StudentLeaveReview leaveReview = getModel( StudentLeaveReview.class );
			leaveAskingService.saveApprovalResult( leaveReview );
			renderJson( true );
		} catch (Exception e) {
			log.error( "saveApprovalResult" , e );
			renderJson( false );
		}
	}
	
	public void myAwaiting() {
		try {
			Integer sysUserId = getSysuserId();
			leaveAskingService.myAwaiting( sysUserId , splitPage );
			
			renderJsp( "myawaitinglist.jsp" );
		} catch (Exception e) {
			log.error( "myAwaiting" , e );
			renderError( 500 );
		}
	}

}

