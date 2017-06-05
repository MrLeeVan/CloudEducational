
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

import java.util.Date;
import java.util.List;

import com.jfinal.plugin.activerecord.Db;
import com.momathink.common.annotation.model.Table;
import com.momathink.common.base.BaseModel;
import com.momathink.common.tools.ToolDateTime;

@Table( tableName="jw_leaveasking" )
public class StudentAskingLeave extends BaseModel<StudentAskingLeave> {

	private static final long serialVersionUID = -45815801653282953L;
	
	public static final StudentAskingLeave dao = new StudentAskingLeave();

	public Integer saveStudentLeaveAsking( StudentAskingLeave askingLeave ,  Integer sysUserId ) {
		askingLeave.set( "state" , 0 );
		askingLeave.set( "applyuserid" , sysUserId );
		askingLeave.set( "createdate" , ToolDateTime.getDate() );
		askingLeave.save();
		return askingLeave.getPrimaryKeyValue();
	}

	public void revocationAsking( String askingId ) {
		String updateSql = " update jw_leaveasking set state = 1 where id = ? and state = 0 ";
		Db.update( updateSql , askingId );
	}
	
	public StudentAskingLeave queryLeaveAskingById( String askingId ) {
		String querySql = " select asking.id , asking.state , asking.starttime , asking.endtime , asking.type , asking.content , "
				+ " asking.createdate , stu.tel stuNum , stu.real_name stuName , applyUser.real_name realName "
				+ " from jw_leaveasking asking left join account stu on stu.id = asking.studentid "
				+ " left join account applyUser on applyUser.id = asking.applyuserid where asking.id = ? ";
		StudentAskingLeave leaveAsking = dao.findFirst( querySql , askingId );
		if( null != leaveAsking ) {
			Integer recordState = leaveAsking.getInt( "state" );
			/*awaitingReview= 待审核  revocation= 撤销  approval= 通过 reviewFail= 未通过 underReview= 审核中*/
			String stateCode = recordState == 4 ? "underReview" : recordState == 3 ? "reviewFail" :
				recordState == 2 ? "approval" : recordState == 1 ? "revocation" : "awaitingReview" ; 
			leaveAsking.put( "stateCode" , stateCode );
		}
		return leaveAsking;
		
	}

	public void updateAskingLeaveState( int currentState , Integer leaveAskingId ) {
		String sql = " update jw_leaveasking set state = ? where id = ? ";
		Db.update( sql , currentState , leaveAskingId );
	}
	
	
	public String leavedStudentIdsInTime( String startTime , String endTime , String semesterId ) {
		String sql = " select studentid , starttime , endtime  from jw_leaveasking where state = 2 and semesterid = ? and " 
				+ " ( ( starttime >= ? and endtime <= ? ) or ( startTime <= ? and endTime >= ? ) or ( startTime <= ? and endTime >= ? ) ) "; 
		List< StudentAskingLeave > studentList = dao.find( sql , semesterId , startTime , endTime , startTime , startTime , endTime , endTime ) ;
		if( studentList != null && studentList.size() > 0 ) {
			StringBuilder studentIdSb = new StringBuilder( "," );
			for( StudentAskingLeave student : studentList ) {
				studentIdSb.append( student.getInt( "studentid" ) ).append( "," );
			}
			return studentIdSb.toString();
		}
		return ",,";
		
	}
	
	/**某学生在 某时间里 有没有请假    有=true  , 没有= false**/
	public boolean queryByStudentidIsRange(Integer studentid, Date date){
		if(date == null)
			return false;
		String sql = 
				"SELECT  COUNT(*)  FROM  jw_leaveasking " +
				"WHERE       state =  2  AND studentid =? " +
				" AND((  starttime >= ?  AND endtime <  ? )" +
				"  OR (  starttime >  ?  AND endtime <= ? )" +
				"  OR (  starttime >= ?  AND endtime <= ? )" + 
				")";
		Long stuleave = Db.queryLong(sql, studentid,  date,date,  date,date,  date,date);
		return stuleave > 0;
	}
	
	/**某学生 在 某 时间段内的 请假**/
	public List<StudentAskingLeave> queryByStudentid(String stuId, String startDate, String endDate){
		return dao.find(
				"SELECT " +
				"	DATE_FORMAT(`starttime`, '%Y-%m-%d %H:%i') starttime, " +
				"	DATE_FORMAT(`endtime`,   '%Y-%m-%d %H:%i') endtime " +
				"FROM " +
				"	jw_leaveasking " +
				"WHERE " +
				"	state = 2 " +
				"AND studentid = ? " +
				"AND (  ( " +
				"		starttime <= ? " +
				"		AND endtime >= ? " +
				"	) OR ( " +
				"		starttime < ? " +
				"		AND endtime > ? " +
				"	) )",
				stuId, startDate, endDate,    endDate, startDate);
	}

}

