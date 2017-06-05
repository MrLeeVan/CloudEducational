<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>${_res.get('Weekly.learning.progress')}</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">

<script src="/js/js/jquery-2.1.1.min.js"></script>
   <style>
     
       html{color:#000;background:#FFF;}
       body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,button,textarea,p,blockquote,th,td{margin:0;padding:0;}
       table{border-collapse:collapse;border-spacing:0;}
       fieldset,img{border:none;}
       address,caption,cite,code,dfn,em,strong,th,var{font-style:normal;font-weight:normal;}
       li{list-style:none;}caption,th{text-align:left;}
       h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal;}
       q:before,q:after{content:”;}
       abbr,acronym{border:none;font-variant:normal;}
       sup{vertical-align:text-top;}sub{vertical-align:text-bottom;}
       input,button,textarea,select{font-family:inherit;font-size:inherit;font-weight:inherit;}
       input,button,textarea,select{*font-size:100%;}
       legend{color:#000;}
       del,ins{text-decoration:none;}
       small{font-size:100%;}

      h3,h6{color:#fff}
      h3{font-weight: 900;font-size: 20px;margin-bottom: 6px}
      h6{font-size: 14px}
      .container{background:#ededed;font-size: 13px;color:#504e4f;font-family: "微软雅黑","serif"}
      header{background:#4a8bc2;height:60px;padding:10px}
      section{margin:20px 0}
      .secdiv{width:370px;margin:0 auto 30px;padding:10px}
      .weekbao{width:400px;margin:-50px auto;text-align: center;color:"#fff"}
      .zcourse{width:60%;height:17px;background:#ededed}
      .secname{font-size:16px}
      .seccont{margin-top:20px;font-size:14px}
      .sectioncont{width:90%;margin:0 auto}
      .coursegl{background:#fff;width:45%;float: left;padding:15px;height:185px}
      .studentbx{background:#fff;width:45%;float: right;padding:15px}
      .coursestudent{background:#dff1ff;color:#3a87ad;padding:2px 4px;font-size: 15px;padding:10px}
      .courseone{margin:10px 0 10px 10px;color:#888}
      .shoukecont{margin:20px 0;background:#fff;padding:15px}
      .textarea{background:#f5f5f5;color:#888;border-radius:5px;padding:5px;margin-top:10px;height:120px;overflow-y:auto}
      .floatleft{float: left;}
      .table{background:#f5f5f5;padding:15px;margin-top:10px}
       table tr td,th{text-align: center;padding:4px 6px}
       th{background:#e5e5e5}
      .label{width:100px}
      .zkcourse{background:#5eb95e;height:100%;float: left}
      .yscourse{background:#5eb95e;height:100%;float: left}
      footer{background:#4a8bc2;height:60px;padding:10px}
   </style>
</head>
<body>
  <div class="container">
   <header>
        <img alt="logo" src="/images/logo/logo_menu.png" width='300'>
        <div class="weekbao" >
	        <h3>${_res.get('Weekly.learning.progress')}</h3>
	        <h6>${tg.lastcoursebegindate}&nbsp;&nbsp;--&nbsp;&nbsp;${tg.lastcourseenddate}</h6>
        </div>
    </header>
    <section>
        <div class="secdiv">
           <div class="secname">Hi,亲爱的${point.real_name}同学家长您好：</div>
           <div class="seccont">我们已经提交了${point.real_name}同学的周报，内容如下：</div>
        </div>
        <div class="sectioncont">
           <div class="coursegl">
              <div class="coursestudent">${_res.get('Hours.Preview')}</div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('total.sessions')}：</div> 
                  <div class="floatleft zcourse">
                       <div class="zkcourse" style="width:100%">
                       </div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${point.allhour}</div>
                  <div style="clear: both;"></div>
              </div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('Already.in.class')}：</div> 
                  <div class="floatleft zcourse">
                       <div class="yscourse" id="usedHours" style="width:${usedhourpx}%"></div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${usedHours}</div>
                  <div style="clear: both;"></div>
              </div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('The.remaining.hours')}：</div> 
                  <div class="floatleft zcourse">
                      <div class="yscourse" id="leftHours" style="width:${lefthourpx}%"></div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${leftHours}</div>
                  <div style="clear: both;"></div>
              </div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('When.classes.this.week')}：</div> 
                  <div class="floatleft zcourse">
                      <div class="yscourse" id="currentplanhours" style="width:${currentplanhourpx}%"></div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${currentplanhours }</div>
                  <div style="clear: both;"></div>
              </div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('Pre.next.week.Timetable')}：</div> 
                  <div class="floatleft zcourse">
                      <div class="yscourse" id="nextplanhours" style="width:${nextplanhourpx}%"></div>
                  </div>
                  <div class="floatleft" id="nextplanhours" style="margin-left:10px">${nextplanhours }</div>
                  <div style="clear: both;"></div>
              </div>
           </div>
           <div class="studentbx" style="height:185px">
              <div class="coursestudent">${_res.get('Operational.issues') }</div>
              <div class="textarea">${tg.question }</div>
           </div>
           <div style="clear: both;"></div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('Course.details.this.week') }</div>
           <div class="table">
	           <table width="100%">
	             <tr>
	                <th width="8%">${_res.get("index")}</th>
	                <th width="12%">${_res.get('Class.Date')}</th>
	                <th width="12%">${_res.get('class.time.session')}</th>
	                <th width="10%">${_res.get('course.course')}</th>
	                <th width="8%">${_res.get('session')}</th>
	                <th width="10%">${_res.get('Instructor')}</th>
	                <th width="10%">${_res.get('type.of.class')}</th>
	                <th width="8%">${_res.get('admin.dict.property.status')}</th>
	                <th width="22%">${_res.get('The.reason')}</th>
	             </tr>
	             <c:choose>
	             	<c:when test="${empty currentPlans }">
	             		<td colspan="9" >${_res.get('None.this.week.curriculum') }.</td>
	             	</c:when>
	             	<c:otherwise>
			             <c:forEach items="${currentPlans }" var="cplan" varStatus="index" >
			             	<tr>
			             		<td>${index.count }</td>
			             		<td>${cplan.COURSE_TIME }</td>
			             		<td>${cplan.RANK_NAME }</td>
			             		<td>${cplan.COURSE_NAME }</td>
			             		<td>${cplan.class_hour }</td>
			             		<td>${cplan.REAL_NAME }</td>
			             		<td>${cplan.class_id=='0'?_res.get('IEP'):_res.get('course.classes') }</td>
			             		<td>${cplan.iscancel=='0'?_res.get('normal'):_res.get('Cancel')}</td>
			             		<td>${cplan.msg }</td>
			             	</tr>
			             </c:forEach>
	             	</c:otherwise>
	             </c:choose>
	           </table>
	        </div>   
        </div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('Overall.impression')}（Teacher Feedback）</div>
           <div class="textarea">${tg.teacherfeedback }</div>
        </div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('Suggestions.program')}（What to  Prepare for Next Session）</div>
           <div class="textarea">${tg.method }</div>
        </div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('Next.week.curriculum')}</div>
           <div class="table">
	           <table width="100%">
	             <tr>
	                <th width="10%">${_res.get("index")}</th>
	                <th width="12%">${_res.get('Class.Date')}</th>
	                <th width="12%">${_res.get('class.time.session')}</th>
	                <th width="12%">${_res.get('course.course')}</th>
	                <th width="10%">${_res.get("session")}</th>
	                <th width="10%">${_res.get('Instructor')}</th>
	                <th width="10%">${_res.get('type.of.class')}</th>
	                <th width="12%">${_res.get("system.campus")}</th>
	                <th width="12%">${_res.get('class.classroom')}</th>
	             </tr>
	             <c:choose>
	             	<c:when test="${empty nextPlans }">
	             		<td colspan="9" >${_res.get('Next.week.there.is.no.curriculum')}.</td>
	             	</c:when>
	             	<c:otherwise>
			             <c:forEach items="${nextPlans }" var="cplan" varStatus="index" >
			             	<tr>
			             		<td>${index.count }</td>
			             		<td>${cplan.COURSE_TIME }</td>
			             		<td>${cplan.RANK_NAME }</td>
			             		<td>${cplan.COURSE_NAME }</td>
			             		<td>${cplan.class_hour }</td>
			             		<td>${cplan.REAL_NAME }</td>
			             		<td>${cplan.class_id=='0'?_res.get('IEP'):_res.get('course.classes') }</td>
			             		<td>${cplan.campus_name }</td>
			             		<td>${cplan.name }</td>
			             	</tr>
			             </c:forEach>
	             	</c:otherwise>
	             </c:choose>
	           </table>
	        </div>   
        </div>
        </div>
    </section>
    <footer>
       <div style="width:580px;margin:10px auto 0;color:#fff">
        <div style="margin:10px 0 10px 0;text-align: center;">Hi，我是XXX的客服支持xxx，如果您在对我们的服务遇到问题，欢迎向我们咨询！</div>
        <div style="margin-bottom: 10px;text-align: center;">${_res.get('telphone')}：xxxxxxxxx&nbsp;&nbsp;&nbsp;邮件：xxxx@xx.com&nbsp;&nbsp;&nbsp;网站：http://www.xxx.com</div>
       </div>
    </footer> 
   </div> 
   
   <script type="text/javascript">
   </script>
   
</body>
</html>