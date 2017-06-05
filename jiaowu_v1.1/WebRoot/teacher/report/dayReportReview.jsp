<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en"> 
<head>
   <meta charset="utf-8" />
   <title>${_res.get('Learning.progress.daily')}</title>
   <meta content="width=device-width, initial-scale=1.0" name="viewport" />
   <meta content="" name="description" />
   <meta content="Mosaddek" name="author" />
   <script src="/js/js/jquery-2.1.1.min.js"></script>
   <style>
     /*
                   初始化    
     */
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
      /*
        css
     */
      h3,h6{color:#fff}
      h3{font-weight: 900;font-size: 20px;margin-bottom: 6px}
      h6{font-size: 14px}
      .container{background:#ededed;font-size: 13px;color:#504e4f;font-family: "微软雅黑","serif"}
      header{background:#4a8bc2;height:60px;padding:10px}
      section{margin:20px 0}
      .secdiv{width:90%;margin:0 auto 30px;padding:10px;text-align: left;}
      .secname{font-size:16px}
      .seccont{margin-top:20px;font-size:14px}
      .sectioncont{width:90%;margin:0 auto}
      .coursegl{background:#fff;width:45%;float: left;padding:15px}
      .studentbx{background:#fff;width:45%;float: right;padding:15px}
      .coursestudent{background:#dff1ff;color:#3a87ad;padding:2px 4px;font-size: 15px;padding:10px}
      .courseone{margin:10px 0 10px 10px;color:#888}
      .shoukecont{margin:20px 0;background:#fff;padding:15px}
      .textarea{background:#f5f5f5;color:#888;border-radius:5px;padding:5px;margin-top:10px;min-height:40px;height:50px;overflow-y:auto}
      .floatleft{float: left;}
      .label{width:100px}
      .zcourse{width:60%;height:17px;background:#ededed}
      .zkcourse{background:#5eb95e;height:100%;float: left}
      .yscourse{background:#5eb95e;height:100%;float: left}
      footer{background:#4a8bc2;height:60px;padding:10px}
   </style>
</head>
<body>
  <div class="container">
   <header>
        <img alt="logo" src="/images/logo/logo_menu.png" width='300'>
        <div style="width:400px;margin:-50px auto;text-align: center;">
	        <h3>${_res.get('Learning.progress.daily')}</h3>
	        <h6><fmt:formatDate value="${plan.course_time }" type="time" timeStyle="full" pattern="yyyy-MM-dd"/></h6>
        </div>
    </header>
    <section>
        <div class="secdiv">
           <div class="secname">Hi,亲爱的${corder.real_name }同学家长您好：</div>
           <div class="seccont">以下是今日${plan.course_name }课程上课情况，具体内容如下：</div>
        </div>
        <div class="sectioncont">
           <div class="coursegl">
              <div class="coursestudent">${_res.get('Hours.Preview')}</div>
              <div class="courseone">${corder.real_name }同学</div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('total.sessions')}：</div> 
                  <div class="floatleft zcourse">
                       <div class="zkcourse" style="width:100%">
                       </div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${corder.allhour }${_res.get("session")}</div>
                  <div style="clear: both;"></div>
              </div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('Already.in.class')}：</div> 
                  <div class="floatleft zcourse">
                       <div class="zkcourse" style="width:100%">
                       </div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${usedHours }${_res.get("session")}</div>
                  <div style="clear: both;"></div>
              </div>
              <div class="courseone">
                  <div class="floatleft label">${_res.get('The.remaining.hours')}：</div> 
                  <div class="floatleft zcourse">
                       <div class="zkcourse" style="width:0%">
                       </div>
                  </div>
                  <div class="floatleft" style="margin-left:10px">${leftHours }${_res.get("session")}</div>
                  <div style="clear: both;"></div>
              </div>
           </div>
           <div class="studentbx">
              <div class="coursestudent">${_res.get('Academic.Performance')}</div>
              <div class="courseone">${_res.get('attention')}：${tg.ATTENTION }</div>
              <div class="courseone">${_res.get('understanding')}：${tg.UNDERSTAND }</div>
              <div class="courseone">${_res.get('study.attitude')}：${tg.STUDYMANNER }</div>
              <div class="courseone">${_res.get('Job.situation')}：${tg.STUDYTASK }</div>
           </div>
           <div style="clear: both;"></div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('The.course')}</div>
           <div class="textarea">${tg.COURSE_DETAILS }</div>
        </div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('This.job')}</div>
           <div class="textarea">${tg.HOMEWORK }</div>
        </div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('qs.in.homework')}（Homework Assigned）</div>
           <div class="textarea">${tg.question }</div>
        </div>
        <div class="shoukecont">
           <div class="coursestudent">${_res.get('Suggestions.program')}（What to  Prepare for Next Session）</div>
           <div class="textarea">${tg.method }</div>
        </div>
        </div>
    </section>
    <footer>
       <div style="width:580px;margin:10px auto 0;color:#fff">
        <div style="margin-bottom: 10px;text-align: center;">Hi，我是XXX的客服支持xxx，如果您在对我们的服务遇到问题，欢迎向我们咨询！</div>
        <div style="margin-bottom: 10px;text-align: center;">${_res.get('telphone')}：xxxxxxxxx&nbsp;&nbsp;&nbsp;邮件：xxxx@xx.com&nbsp;&nbsp;&nbsp;网站：http://www.xxx.com</div>
       </div>
    </footer> 
   </div> 
</body>
</html>