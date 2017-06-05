

var $active_light;
var a=new Array(1,2,3,4,5,6,7,8,9,10,14,15,16,17,19,20,21);
    	var c=new Array(11,12,13,18);
    	for(x in a){
     	   var b = a[x];
     	   $active_light = $('li[ID=nav-nav'+b+']');
     	   $active_light.hide();
     	}
    	for(y in c){
      	   var d = c[y];
      	   $active_light = $('li[ID=nav-nav'+d+']');
      	   $active_light.show();
      	}
    	$('li[ID=campus]').addClass("top-background");
    	$('li[ID=market]').removeClass("top-background");
    	$('li[ID=sale]').removeClass("top-background");
    	$('li[ID=teach]').removeClass("top-background");
    	$('li[ID=money]').removeClass("top-background");