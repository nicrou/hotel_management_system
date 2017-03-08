// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require turbolinks

//= require bootstrap
//= require bootstrap-table
//= require bootstrap-switch
//= require bootstrap-select
//= require bootstrap-datepicker/core
//= require bootstrap-tokenfield
//= require bootstrap-wysihtml5
//= require bootstrap-checkbox

//= require pick-a-color.min
//= require tinycolor-min
//= require moment
//= require Chart.min
//= require jquery_match_height
//= require dropzone
//= require sweetalert2.min
//= require owl.carousel

//= require_tree .

// Override the default confirm dialog by rails.
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}
// User click confirm button.
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  swal({
    title: message,
    html: '<p>You won\'t be able to revert this!</p>',
    type: 'warning',
    showCloseButton: true,
    buttonsStyling: true,

    confirmButtonText: '<i class="fa fa-trash"></i>',
    confirmButtonColor: '#c9302c'

    //showCancelButton: true,
    //cancelButtonText: '<i class="fa fa-trash"></i>',
    //cancelButtonClass: 'btn btn-default',

  }).then(function(e){
    $.rails.confirmed(link);
  }).then(function(e){
    swal(
      'Deleted!',
      'Record has been deleted.',
      'success'
    )
  });
};
