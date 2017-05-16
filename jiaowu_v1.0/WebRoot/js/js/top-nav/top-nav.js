//市场：market    销售：sale   教学：teach  校区：campus  财务：money
    var $active_light;
    function teach(){
    	var a=new Array(8,9,10,11,12,13,14,15,16,18,19);
    	var c=new Array(1,2,3,4,5,6,7,17,21);
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
    	$('li[ID=teach]').addClass("top-background");
    	$('li[ID=market]').removeClass("top-background");
    	$('li[ID=sale]').removeClass("top-background");
    	$('li[ID=campus]').removeClass("top-background");
    	$('li[ID=money]').removeClass("top-background");
    }
