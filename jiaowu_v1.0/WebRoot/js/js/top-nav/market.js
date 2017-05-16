

var $active_light;
var a=new Array(1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,20,21);
for(x in a){
   var b = a[x];
   $active_light = $('li[ID=nav-nav'+b+']');
   $active_light.hide();
   //c = $('li[ID=nav-nav'+b+']').hide();
  // $('li[ID=nav-nav'+b+']').data(c);
}
$('li[ID=nav-nav8]').show();
$('li[ID=market]').addClass("top-background");
$('li[ID=sale]').removeClass("top-background");
$('li[ID=teach]').removeClass("top-background");
$('li[ID=campus]').removeClass("top-background");
$('li[ID=money]').removeClass("top-background");
