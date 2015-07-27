/**
 * Apply a class to each child
 * Required for IE8-
 */
$('.circle-container').children().each(function() {
  $(this).addClass('item'+($(this).index() + 1));
});
$(document).ready(function(e){
						   //alert($('.circle-container li').length);
						   var lenli=$('.circle-container li').length;
						   if(lenli==4)
						   {
							   //$('.circle-container').
						   }
						   if(lenli==3)
						   {
							   //$('.circle-container').
						   }
						 
			
	$('.circle-container li a').hover(
					  function() {
    $( this ).find('img').attr( "src","arrow-nav.png" );
  }, function() {
        $( this ).find('img').attr( "src","plus-nav.png" );
  }
					   );
						   
						   });