
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

package com.momathink.sys.leave.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;

@Table( tableName="jw_leavereview" )
public class StudentLeaveReview extends BaseModel<StudentLeaveReview> {

	private static final long serialVersionUID = 2266115909687631149L;
	
	public static final StudentLeaveReview dao = new StudentLeaveReview();

	public void saveStudentLeaveApprovers( Integer leaveId , String order , String approveId ) {
		String sql = " insert into jw_leavereview ( leaveaskingid , reviewer , state , orders ) values ( ? , ? , ? , ? )";
		Db.update( sql , leaveId , Integer.parseInt( approveId ) , 0 , Integer.parseInt( order ) );
	}

	/**
	 * 更新某位审批人进入待审核状态
	 */
	public void updateReviewertoReady( Integer leaveId, int order ) {
		String sql = " update jw_leavereview set state = 1 where leaveaskingid = ? and orders = ? ";
		Db.update( sql , leaveId , order );
	}
	
	public StudentLeaveReview queryOrderReviewInState( Integer leaveAskingId , int orders , int state ) {
		String querySql = " select id , leaveaskingid , reviewer , state , orders from jw_leavereview  "
				+ " where leaveaskingid = ? and state = ? and orders = ? ";
		return dao.findFirst( querySql , leaveAskingId , state , orders );
	}

	/**
	 * 查出某条请假申请的审批详情，不包括未开始的审批
	 */
	public List< StudentLeaveReview > queryLeaveReview( String askingId ) {
		String querySql = " select leaveView.* , approver.real_name realName from jw_leavereview leaveView "
				+ " left join account approver on leaveView.reviewer = approver.id "
				+ " where leaveView.leaveaskingid = ? and leaveView.state != 0 order by leaveView.orders asc ";
		List< StudentLeaveReview > reviewList = dao.find( querySql , askingId );
		if( null != reviewList && reviewList.size() > 0 ) {
			for( StudentLeaveReview review : reviewList ) {
				Integer recordState = review.getInt( "state" );
				/*awaitingReview= (1)待审核   approval= (2)通过 reviewFail= (3)未通过 */
				String stateCode = recordState == 3 ? "reviewFail" : recordState == 2 ? "approval" : "underReview" ; 
				review.put( "stateCode" , stateCode );
			}
		}
		return reviewList;
	}

	public StudentLeaveReview queryStayReviewDetail( String leaveViewId ) {
		String querySql = " select leaveView.* , approver.real_name realName from jw_leavereview leaveView "
				+ " left join account approver on leaveView.reviewer = approver.id where leaveView.id = ? ";
		StudentLeaveReview review = dao.findFirst( querySql , leaveViewId );
		Integer recordState = review.getInt( "state" );
		/*awaitingReview= (1)待审核   approval= (2)通过 reviewFail= (3)未通过 */
		String stateCode = recordState == 3 ? "reviewFail" : recordState == 2 ? "approval" : "underReview" ; 
		review.put( "stateCode" , stateCode );
		return review;
	}

	public Long getReviewNumbersBy(Integer approvalUserId) {
		return Db.queryLong("select COUNT(*) from jw_leavereview  where reviewer=? and state=1 ",approvalUserId);
	}

}

