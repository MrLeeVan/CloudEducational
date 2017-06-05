
/**
 * 去除字符串两端空格
 * @returns
 */
String.prototype.trim = function(){  
	return this.replace(/(^\s*)|(\s*$)/g, "");  
};

/**
 * 字符串真实长度
 * @returns
 */
String.prototype.getBytes = function() {    
    var cArr = this.match(/[^\x00-\xff]/ig);    
    return this.length + (cArr == null ? 0 : cArr.length);    
};

/**
 * 日期格式化:new Date().format('yyyy-MM-dd hh:mm:ss')
 * @param format
 * @returns
 */
Date.prototype.format = function(format){
    var o = {
        "M+" : this.getMonth()+1, //month
        "d+" : this.getDate(),    //day
        "h+" : this.getHours(),   //hour
        "m+" : this.getMinutes(), //minute
        "s+" : this.getSeconds(), //second
        "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
        "S" : this.getMilliseconds() //millisecond
    };
    
    if(/(y+)/.test(format)){
    	format=format.replace(RegExp.$1,(this.getFullYear()+"").substr(4 - RegExp.$1.length));
    }
    
    for(var k in o){
    	if(new RegExp("("+ k +")").test(format)){
    		format = format.replace(RegExp.$1,RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
    	}
    }
    
    return format;
};

/**
 * 用于两个日期控件日期范围相互限制
 * @param startDateElem 开始日期控件的id 
 * @param endDateElem 结束日期控件的id
 */
function toolDateRangeLimit(startDateElem, endDateElem) {
	//日期范围限制
	var startDate = {
		elem : '#' + startDateElem,
		format : 'YYYY-MM-DD',
		max : '2099-06-16', //最大日期
		istime : false,
		istoday : false,
		choose : function(datas) {
			endDate.min = datas; //开始日选好后，重置结束日的最小日期
			endDate.start = datas //将结束日的初始值设定为开始日
		}
	};
	var endDate = {
		elem : '#' + endDateElem,
		format : 'YYYY-MM-DD',
		max : '2099-06-16',
		istime : false,
		istoday : false,
		choose : function(datas) {
			startDate.max = datas; //结束日选好后，重置开始日的最大日期
		}
	};
	laydate(startDate);
	laydate(endDate);
}


function toolLaydate(id) {
	var date = {
		elem : '#'+id,
		format : 'YYYY-MM-DD',
		max : '2099-06-16', //最大日期
		istime : false,
		istoday : false
	};
	laydate(date);
}

/**点击滑动到某个位置
a.滑动id为item scrollTo('#item',300);
b.滑到某个标签item scrollTo('.item');
* */
function scrollTo(ele, speed){
	if(!speed) speed = 300;
	if(!ele){
		$("html,body").animate({scrollTop:0},speed);
	}else{
		if(ele.length>0) $("html,body").animate({scrollTop:$(ele).offset().top},speed);
	}
	return false;
}

/**
 * 查看的时候禁用所有控件
 * @param formid form表单 的id
 */
function disabledForm(formid) {
	$("form[id='" + formid + "'] :input").attr("readonly", "readonly");
	$("form[id='" + formid + "'] :text").attr("readonly", "readonly");
	$("form[id='" + formid + "'] textarea").attr("readonly", "readonly");
	$("form[id='" + formid + "'] select").attr("disabled", "disabled");
	$("form[id='" + formid + "'] :radio").attr("disabled", "disabled");
	$("form[id='" + formid + "'] :checkbox").attr("disabled","disabled");
	$(".chosen-container").unbind();
	$(".chosen-choices").unbind();
	$("input").css("background", "#fff");
	$("textarea").css("background", "#fff");
}

/**
 * 多选select 数据初始化
 * @param selectid select控件的 id
 * @param data 以"|" 作为分割点的字符串
 */
function multiSelect(selectid,data){
	var select = "#" + selectid;
	if(null != data && '' != data){
		data=data+"";
		var datas = data.split("|");
		for (i = 0; i < datas.length; i++) {
			$(select + " [value='" + (datas[i]) + "']").attr('selected', 'selected');
		}
		$(select).trigger("chosen:updated");
	}
}

/**
 * 批量去空格
 * @param formId
 */
function formInputTrim(formId){
	var formNode = document.getElementById(formId);
	var length = formNode.length;
	for ( var i = 0; i < length; i++) {
		var node = formNode.elements[i];
		if(node.type == "text" && node.disabled == false){// || node.type == "hidden" || node.type == "password"
			node.value = node.value.trim();
		}
	}
}

/**
 * 显示输入框验证提示
 * @param inputNode
 */
function showInputColor(inputNode, type){
	var controlGroupDiv = inputNode.parent().parent();
	if(type == "error"){
		controlGroupDiv.addClass("error");
		controlGroupDiv.children(".control-label").each(function(i){
			 $(this).attr("for", "inputError");
		});
	}else if(type == "success"){
		controlGroupDiv.addClass("success");
		controlGroupDiv.children(".control-label").each(function(i){
			 $(this).attr("for", "inputSuccess");
		});
	}else if(type == "warning"){
		controlGroupDiv.addClass("warning");
		controlGroupDiv.children(".control-label").each(function(i){
			 $(this).attr("for", "inputWarning");
		});
	}
}

/**
 * 隐藏输入框提示
 * @param inputNode
 */
function hiddenInputColor(inputNode){
	var controlGroupDiv = inputNode.parent().parent();
	controlGroupDiv.removeClass("error");
	controlGroupDiv.removeClass("success");
	controlGroupDiv.removeClass("warning");
	controlGroupDiv.children(".control-label").each(function(i){
		 $(this).attr("for", "");
	});
}

	
/**
 * 输入框数据验证
 * @param nodeId
 * @returns {Boolean}
 */
function inputDataVali(inputNode, nodeType){
	var vType = inputNode.attr("vType");
	var type = inputNode.attr("type");
	if(null != vType && (type == "text" || type == "password")){// || inputNode.type == "hidden"
		var inputId = inputNode.attr("id");
		var messageDiv = $('#'+inputId+'Mes');
		var value = inputNode.val();
		value = $.trim(value);
		inputNode.val(value);
		 
		var minLength = inputNode.attr("vMin");
		var maxLength = inputNode.attr("maxlength");//inputNode.getAttribute("vMax");

		var resultArr = {"result" : false, "message" : ""};
		
		//1.验证长度
		resultArr = utils_valiFunc.minMax(value, minLength, maxLength);
		var result = resultArr["result"];// true or false
		var message = resultArr["message"];
		
		if(result != true){
			hiddenInputColor(inputNode);
			showInputColor(inputNode, "error");
			if(nodeType == "input"){
				messageDiv.text(message);
				messageDiv.click();
			}
			return false;
		}else if(vType == "length"){//如果只验证长度
			hiddenInputColor(inputNode);
			showInputColor(inputNode, "success");
			return true;
			
		}else if(value.length == 0){
			hiddenInputColor(inputNode);
			showInputColor(inputNode, "success");
		}
		
		//2.验证格式
		if(value.length != 0){
			if(vType == "email"){//邮箱
				resultArr = utils_valiFunc.email(value);
				
			}else if(vType == "number"){//整数
				resultArr = utils_valiFunc.number(value);
				
			}else if(vType == "numberZ"){//正整数
				resultArr = utils_valiFunc.numberZ(value);
				
			}else if(vType == "chinaLetterNumber"){//中文字母数字
				resultArr = utils_valiFunc.chinaLetterNumber(value);
			
			}else if(vType == "string"){//普通验证
				resultArr = utils_valiFunc.stature(value);
				
			}else if(vType == "letterNumber"){//字母数字
				resultArr = utils_valiFunc.letterNumber(value);
				
			}else if(vType == "tell"){//电话,如02788888888,注意没有横杠(-)
				resultArr = utils_valiFunc.tell(value);
				
			}else if(vType == "phone"){//手机
				resultArr = utils_valiFunc.phone(value);
				
			}else if(vType == "postboy"){//邮编
				resultArr = utils_valiFunc.postboy(value);
				
			}else if(vType == "idCard"){//身份证号15-18位
				resultArr = utils_valiFunc.idCard(value);
				
			}else if(vType == "qq"){//QQ
				resultArr = utils_valiFunc.qq(value);
				
			}else if(vType == "url"){//网址
				resultArr = utils_valiFunc.url(value);
				
			}else if(vType == "stature"){//身高
				resultArr = utils_valiFunc.stature(value);
				
			}else if(vType == "ip"){//IP
				resultArr = utils_valiFunc.ip(value);
				
			}else if(vType == "avoirdupoi"){//体重
				resultArr = utils_valiFunc.avoirdupoi(value);
				
			}else if(vType == "numberDecimal"){//数字
				resultArr = utils_valiFunc.numberDecimal(value);
			
			}else if(vType == "tellphone"){
				resultArr = utils_valiFunc.tell(value);//先验证电话
				result = resultArr["result"];// true or false
				if(result == false){
					resultArr = utils_valiFunc.phone(value);					
				}
			}
			
			result = resultArr["result"];// true or false
			message = resultArr["message"];
			
			if(result != true){
				hiddenInputColor(inputNode);
				showInputColor(inputNode, "error");
				if(nodeType == "input"){
					messageDiv.text(message);
					messageDiv.click();
				}
				return false;
			}else{
				hiddenInputColor(inputNode);
				showInputColor(inputNode, "success");
			}
		}
	}
	return true;
}
	
/**
 * 失去焦点时验证
 * @param inputNode
 * @returns {Boolean}
 */
function onblurVali(inputNode){
	inputNode = $(inputNode);
	inputDataVali(inputNode, "input");
}
	
/**
 * 整个form一次验证
 * @param formNode
 * @returns {Number}
 */
function formVali(formNode){
	var length = formNode.length;
	var errorCount = 0;
	for ( var i = 0; i < length; i++) {
		var node = formNode.elements[i];
		node = $(node);
		var result = inputDataVali(node, "form");
		if(result == false){
			errorCount += 1;
		}
	}
	return errorCount;
}

var utils_valiFunc = {
	/**
	 * 验证长短
	 * @param str
	 * @param minLength
	 * @param maxLength
	 * @returns
	 */
	"minMax" : function(str, minLength, maxLength){
		var objectLength = str.length;//.getBytes();//length;
		if(objectLength == 0 && minLength == 0){
			return {"result" : true, "message" : ""};
		}
		if(objectLength==0){
			return {"result" : false, "message" : "不能为空！"};
		}
		if(null != minLength && null != maxLength && minLength==maxLength && objectLength < minLength){
			return {"result" : false, "message" : "长度必须" + minLength + "位！"};
		}
		if((null != minLength && objectLength < minLength) || (null != maxLength && objectLength > maxLength)){
			return {"result" : false, "message" : "长度至少" + minLength + "位！"};
		}else{
			return {"result" : true, "message" : ""};
		}
	},
	
	/**
	 * 整数
	 * @param str
	 * @returns
	 */
	"number" : function(str){
		var result = str.match(/^(-|\+)?\d+$/);
	    if(result == null){
	    	return {"result" : false, "message" : "只能为整数！"};
	    }else{
	    	return {"result" : true, "message" : ""};
	    }
	},
	/**
	 * 数字
	 * @param str
	 * @returns
	 */
	"numberDecimal" : function(str){
		var result = str.match(/^[0-9]+(.[0-9]{1,2})?$/);
		if(result == null){
			return {"result" : false, "message" : "只能为数字！"};
		}else{
			return {"result" : true, "message" : ""};
		}
	},

	/**
	 * 正整数
	 * @param str
	 * @returns
	 */
	"numberZ" : function(str){
		var result = str.match(/^[0-9]*[1-9][0-9]*$/);
	    if(result == null){
	    	return {"result" : false, "message" : "只能为正整数！"};
	    }else{
	    	return {"result" : true, "message" : ""};
	    }
	},

	/**
	 * 中文_字母_数字
	 * @param str
	 * @returns
	 */
	"chinaLetterNumber" : function(str){
		var pattern = /((^[\u4E00-\u9FA5]{2,5}$)|(^[a-zA-Z]+[\s\.]?([a-zA-Z]+[\s\.]?){0,4}[a-zA-Z]$))/; 
		if (pattern.test(str)){ 
			return {"result" : true, "message" : ""};
		}else{ 
			return {"result" : false, "message" : "只能包含中文、字母、数字！"};
		} 
	},
	
	/**
	 * 字母_数字
	 * @param str
	 * @returns
	 */
	"letterNumber" : function(str){
		var letterNumber=/^[A-Za-z0-9]+$/;
		if(letterNumber.test(str)){
			return {"result" : true, "message" : ""};
		}else {
			showMessage = "";
			return {"result" : false, "message" : "只能包含字母、数字！"};
		}
	},

	/**
	 * 验证邮箱
	 * @param str
	 * @returns
	 */
	"email" : function(str){
		var email = /^[\w.+-]+@(?:[-a-z0-9]+\.)+[a-z]{2,4}$/i;//正则/\b[^\s\@]+\@(?:[a-z\d-]+\.)+(?:com|net|org|info|cn|jp|gov|aero)\b/;
		if(email.test(str)){
			return {"result" : true, "message" : ""};
		}else {
			return {"result" : false, "message" : "格式不正确！"};
		}
	},

	/**
	 * 匹配固定电话或小灵通，例如：031185907468或02185907468格式
	 * @param str
	 * @returns
	 */
	"tell" : function(str){
		var partten = /^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/;
		if(partten.test(str)){
			return {"result" : true, "message" : ""};
		}else{
			return {"result" : false, "message" : "格式不正确！"};
		}
	},

	/**
	 * 手机
	 * @param str
	 * @returns
	 */
	"phone" : function(str){
		var partten = /^0?(13[0-9]|15[0-9]|18[0-9]|14[0-9]|17[0-9])[0-9]{8}$/; ///^1[3,5]\d{9}$/;
		if(partten.test(str)){
			return {"result" : true, "message" : ""};
		}else{
			return {"result" : false, "message" : "格式不正确！"};
		}
	},

	/**
	 * 邮编
	 * @param str
	 * @returns
	 */
	"postboy" : function(str){
		var partten = /^[a-zA-Z0-9 ]{3,12}$/;
		if(partten.test(str)){
			return {"result" : true, "message" : ""};
		}else{
			return {"result" : false, "message" : "格式不正确！"};
		}
	},

	/**
	 * 身份证号15-18位
	 * @param str
	 * @returns
	 */
	"idCard" : function(str){
		var result=str.match(/\d{15}|\d{18}/);
	    if(result == null){
			return {"result" : false, "message" : "格式不正确！"};
	    }else{
	    	return {"result" : true, "message" : ""};
	    }
	},

	/**
	 * qq
	 * @param str
	 * @returns
	 */
	"qq" : function(str){
		var result = str.match(/^(-|\+)?\d+$/);
	    if(result == null){
			return {"result" : false, "message" : "格式不正确！"};
	    }else{
	    	return {"result" : true, "message" : ""};
	    }
	},

	/**
	 * URL 网址
	 * @param str
	 * @returns
	 */
	"url" : function(str){
		var result = null;//str.match(/^[0-9a-zA-Z_-.:?&=\/%@]+$/);
	    if(result == null){
	    	return {"result" : false, "message" : "格式不正确！"};
	    }else{
	    	return {"result" : true, "message" : ""};
	    }
	},

	/**
	 * 	IP 地址
	 * @param str
	 * @returns
	 */
	"ip" : function(str){
		var val = /([0-9]{1,3}\.{1}){3}[0-9]{1,3}/;
	    var vald = val.exec(str);
	    if (vald == null) {
	    	return {"result" : false, "message" : "格式不正确！"};
	    }
	    if (vald != '') {
	        if (vald[0] != str) {
	        	return {"result" : false, "message" : "格式不正确！"};
	        }
	    }
	    return {"result" : true, "message" : ""};
	},

	/**
	 * 身高
	 * @param str
	 * @returns
	 */
	"stature" : function(str){
		var result = str.match(/^(-|\+)?\d+$/);
	    if(result == null){
	    	return {"result" : false, "message" : "格式不正确！"};
	    }else{
	    	if(parseInt(str) < 25 || parseInt(str) > 250){
	    		return {"result" : false, "message" : "应该在" + 25 + "-" + 250 + "cm之间！"};
			}
	    	return {"result" : true, "message" : ""};
	    }
	},
	
	/**
	 * 体重
	 * @param str
	 * @returns
	 */
	"avoirdupoi" : function(str){
		var result = str.match(/^(-|\+)?\d+$/);
	    if(result == null){
	    	return {"result" : false, "message" : "格式不正确！"};
	    }else{
	    	if(parseInt(str) < 2 || parseInt(str) > 500){
	    		return {"result" : false, "message" : "应该在" + 2 + "-" + 500 + "kg之间！"};
			}
	    	return {"result" : true, "message" : ""};
	    }
	},
	
	/**
	 * 判断文件上传类型
	 * @param valuePath
	 * @returns
	 */
	"valiFile" : function(valuePath){
		var imageGeShi = valuePath.substr(valuePath.lastIndexOf(".")+1);
		var geShi = ["jpg", "jpeg", "png"];
		var imageResult = false;
		for(var i in geShi){
			if(imageGeShi == geShi[i]){
				imageResult =  true;
			}
		}
		if(imageResult == false){
			return {"result" : false, "message" : "文件格式不正确！"};
		}else{
			return {"result" : true, "message" : ""};
		}
	}
};

var utils_cookie = {
	/**
	 * 写cookies
	 * @param name
	 * @param value
	 * @param day	保存天数
	 */
	"add" : function(name, value, day){
		var exp  = new Date();
	    exp.setTime(exp.getTime() + day*24*60*60*1000);
	    document.cookie = name + "="+ escape(value) + ";expires=" + exp.toGMTString();
	},
	
	/**
	 * 取cookies
	 * @param name
	 * @returns
	 */
	"get" : function(name){
		var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
	    if(arr != null) {
			return unescape(arr[2]); 
		}
		return null;
	},
	
	/**
	 * 删除cookie
	 * @param name
	 */
	"delete" : function(name){
		var exp = new Date();
	    exp.setTime(exp.getTime() - 1);
	    var cval = utils_getCookie(name);
	    if(cval != null) {
			document.cookie= name + "="+cval+";expires="+exp.toGMTString();
		}
	},
	
	/**
	 * 是否支持Cookie
	 * @returns {Boolean}
	 */
	"enable" : function(){
		var result=false;
	    if(navigator.cookiesEnabled){
	    	return true;
	    }
	    document.cookie = "testcookie=yes;";
	    var cookieSet = document.cookie;
	    if (cookieSet.indexOf("testcookie=yes") > -1){
	    	result=true;
	    }
	    document.cookie = "";
	    return result;
	}
};
