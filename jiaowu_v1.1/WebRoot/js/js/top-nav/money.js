

var $active_light;
var a=new Array(1,2,3,4,5,6,7,8,9,11,12,13,17,18,19,20,21);
var b=new Array(10,14,15,16);
    	for(x in a){
    	   var b = a[x];
    	   $active_light = $('li[ID=nav-nav'+b+']');
    	   $active_light.hide();
    	}
    	for(y in b){
     	   var c = b[y];
     	   $active_light = $('li[ID=nav-nav'+c+']');
     	   $active_light.show();
     	}
    	$('li[ID=money]').addClass("top-background");
    	$('li[ID=market]').removeClass("top-background");
    	$('li[ID=sale]').removeClass("top-background");
    	$('li[ID=teach]').removeClass("top-background");
    	$('li[ID=campus]').removeClass("top-background");