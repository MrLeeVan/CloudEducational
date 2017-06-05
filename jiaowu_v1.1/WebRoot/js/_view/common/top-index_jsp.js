function chengeI18n(type){
	$.ajax({
		url:"/i18n/setI18nCookies",
		type:"post",
		data:{"_locale":type},
		dataType:"json",
		success:function(result){
			window.location.reload();
		}
	});
}


function getMessage(){
	
	//挂机状态下的  自动持续请求
	var getMessagecoun = $("#nav-topwidth").data("getMessagecoun");
	getMessagecoun = getMessagecoun == null ? 1: (getMessagecoun + 1);
	$("#nav-topwidth").data("getMessagecoun", getMessagecoun);
	
	//发送请求
	$.ajax({
		url : "/main/getMessage",
		type : "post",
		dataType : "json",
		success : function(data) {
			setTimeout(function(){
				getMessage();
			}, (60000 * getMessagecoun ));
			var str1=data.total;
			var str2=data.orderCount;
			var str3=data.oppocounts;
			$("#total").text(str1);
			$("#orderCount").text(str2);
			$("#oppocounts").text(str3);
			$("#birthcounts").text(data.count);
			$("#reportcounts").text(data.reportcounts);
			$("#recvertions").text(data.noann);
			$("#approval").text(data.approvalCount);
			$("#remind").text(data.remind);
			$("#nocomment").text(data.nocomment);
		}
	});
}


function toTeacherReport(){
	var daytime = getCurrentDayTime();
	$("#reportid").attr("href","/report/teacherReports?_query.state=0&&_query.startappointment="+daytime+"&&_query.endappointment="+daytime);
	
} 
function toStudentBirthday(){
	var d = new Date();
	var str = (d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()).toString();
	$("#tobirthday").attr("href","/student/birthday?_query.like="+str);
}

function getCurrentDayTime(){
	var mydate = new Date();
	var year =  mydate.getFullYear();
	var month = mydate.getMonth()+1; 
	var day = mydate.getDate(); 
	return year+"-"+month+"-"+day;
}
function getHeadMessage(){
   	$("#topMessage").html('');
   	$.getJSON('/operator/getHeadMessage', function(data){
   		topMessageAppend(data);
   	});
}

//充填 topMessage
function topMessageAppend(data){
	var head = $("#head").val();
	var en = $("#en").val();
	var str="";
		for(i in data){
			if(data[i].FLAG){
				if(head==data[i].ID){
					str +=' <a href="/operator/getModulCompetence?systemsid='+data[i].ID+'">';
					if(en==1){
						str +='<li sty class="top-background"><div>'+data[i].NAMES+'</div></li></a> ';
					}else if(en==2){
						str +='<li sty class="top-background"><div>'+data[i].NUMBERS+'</div></li></a> ';
					}else{
						str +='<li sty class="top-background"><div>'+data[i].NAMES+'</div></li></a> ';
					}
  	   				
				}else{
					str +=' <a href="/operator/getModulCompetence?systemsid='+data[i].ID+'">';
					if(en==1){
  	   					str +='<li ><div>'+data[i].NAMES+'</div></li></a> ';
					}else if(en==2){
						str +='<li ><div>'+data[i].NUMBERS+'</div></li></a> ';
					}else if(en==3){
						str +='<li ><div>'+data[i].JPNUMBERS+'</div></li></a> ';
					}else{
						str +='<li ><div>'+data[i].NAMES+'</div></li></a> ';
					}
				}
				
			}
		}
		$("#topMessage").append(str);
}

function entryWordSystem() {
	$.ajax( {
		url : "/sysuser/loginToWord",
		async : false,
		success : function( result ) {
			if( result.flag ) {//location.href= 
				var redirectUrl = result.wordSystemPath +"/api/login?jwUserId="+result.jwUserId;
				redirectUrl += "&timeStamp="+result.timestamp+"&signature="+result.signature;
				redirectUrl += "&email="+result.email+"&realName="+result.realName+"&isStudent="+result.isStudent;
				alert(encodeURI(redirectUrl));
				window.open(encodeURI(redirectUrl)); 
			} else {
				layer.msg( "没有登陆权限" , 2 , 2 );
			}
		}
	} );
}


$(document).ready(function(){
	getHeadMessage();
	setTimeout(function(){
		getMessage();
	}, 1000);
});
