

var $active_light;
var a=new Array(1,2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,20,21);
for(x in a){
   var b = a[x];
   $active_light = $('li[ID=nav-nav'+b+']');
   $active_light.hide();
}
$('li[ID=nav-nav9]').show();
$('li[ID=nav-nav19]').show();
$('li[ID=sale]').addClass("top-background");
$('li[ID=market]').removeClass("top-background");
$('li[ID=teach]').removeClass("top-background");
$('li[ID=campus]').removeClass("top-background");
$('li[ID=money]').removeClass("top-background");