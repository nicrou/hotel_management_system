$(document).on('turbolinks:load', function () {
  hotel.initPage();
})

// These functions are for setting up owl-carousel, navbar's ripple effects and starting appropriate requests on changing languages from locale selectpicker change.
// Tinkering with those is deprecated since you might broke some basic controls.

var hotel = {
  initPage: function() {
    $(".owl-carousel").owlCarousel({
      items: 1,
      loop: true,
      center: true,
      autoplay: true,
      autoplayTimeout: 3000,
      //autoplayHoverPause: true,

      animateOut: 'slideOutDown',
      animateIn: 'flipInX',
      smartSpeed: 450,
    });

    // Create a deferred object
    var obj = $.Deferred();

    // Add handlers to be called when obj is resolved
    obj

      .done(function($a, e) {
        var parent, ink, d, x, y;
      	parent = $a.parent();
      	//create .ink element if it doesn't exist
      	if(parent.find(".ink").length == 0)
      		parent.prepend("<span class='ink'></span>");

      	ink = parent.find(".ink");
      	//incase of quick double clicks stop the previous animation
      	ink.removeClass("animate");

      	//set size of .ink
      	if(!ink.height() && !ink.width())
      	{
      		//use parent's width or height whichever is larger for the diameter to make a circle which can cover the entire element.
      		d = Math.max(parent.outerWidth(), parent.outerHeight());
      		ink.css({height: d, width: d});
      	}

      	//get click coordinates
      	//logic = click coordinates relative to page - parent's position relative to page - half of self height/width to make it controllable from the center;
      	x = e.pageX - parent.offset().left - ink.width()/2;
      	y = e.pageY - parent.offset().top - ink.height()/2;

      	//set the position and add class .animate
      	ink.css({top: y+'px', left: x+'px'}).addClass("animate");
      })

      .done(function( $a ){
        document.location = $a.attr('href');
      });

    // Resolve the Deferred object when the link is clicked
    $("#js-hotel-navbar ul li a").click(function(e){
      e.preventDefault();
      //store a reference to the anchor tag
      var $a = $(this);
      obj.resolve($a, e);
    })

    $(".locales .js-selectpicker").on('changed.bs.select', function (e) {
      hotel.refresh();
    });
  },
  refresh: function(){
    var url = window.location.href;

    //var id = url.match(/id=[0-9]*&/);
    url = window.base_uri + "/hotel/show?";
    window.location = url /* + id */ + "locale=" + $('[name="locale"]').val();
  }
}
