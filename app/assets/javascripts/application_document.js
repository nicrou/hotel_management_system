//set domain to empty string or remove entirely if it is not a sub-uri application.
window.base_uri = "";

// Dummy code for displaying Readme
/*$(document).ready(function(){
  if (localStorage.getItem('visited') == null){
  	swal({
  	  type: 'info',
  	  html: '<div></div>',
  	  width: '90%',
  	  showCloseButton: true,
  	  showConfirmButton: true,
  	  confirmButtonText: 'Confirm'
  	})

  	$(".swal2-modal .swal2-content").html($("#readme>div").html());
  }
  localStorage.setItem('visited', true);
})*/

$(document).on('click', "li.readme" , function () {
  swal({
	  html: '<div></div>',
	  width: '100%',
	  showCloseButton: true,
	  showConfirmButton: true,
	  confirmButtonText: 'Confirm'
	})

	$(".swal2-modal .swal2-content").html($("#readme>div").html());
})

// end

$(document).on('click', "button.swal2-confirm" , function () {
  $(".swal2-content form").submit();
})

$(document).on('turbolinks:load', function () {
  if ($(".js-bootstrap-table").hasClass("applied") == false) {
    $(".js-bootstrap-table").bootstrapTable();
    $(".js-bootstrap-table").addClass("applied")
  }

  if ($(".js-selectpicker").hasClass("applied") == false) {
    $(".js-selectpicker").selectpicker();
    $(".js-selectpicker").addClass("applied")
  }
});

$(document).on('page:load', function(){
  window['rangy'].initialized = false
})

$(document).on('click', '.bootstrap-table button[name="refresh"]' , function () {
  indexRefresh();
})

function indexRefresh(){
  var url = window.location.href;
  url = url.replace('#','');
  url = url.split("/").pop();
  $.ajax({
    type: "get",
    url: url,
  })
}

function initCheckbox(element){
  element.checkboxpicker().on('change', function() {
    var input = $(this).closest("input");
      if (input.val() == "false" ) {
        input.val("true")
        $(this).prop('checked');
      }
      else {
        input.val("false")
        $(this).prop('unchecked');
      }
  });
}

var steps = {
  initControls: function(){
    var current_fieldset, next_fieldset, previous_fieldset;

    $("button.next").click(function(){

    	current_fieldset = $(this).parent();
    	next_fieldset = $(this).parent().next();

    	// Activate next step on progress-indicator using the index of next_fieldset.
    	$(".progress-indicator li").eq($("fieldset").index(next_fieldset)).addClass("completed");

    	//show the next fieldset
    	next_fieldset.show();
      current_fieldset.hide();
    });

    $("button.previous").click(function(){

    	current_fieldset = $(this).parent();
    	previous_fieldset = $(this).parent().prev();

    	// De-activate current step on progress-indicator.
      $(".progress-indicator li").eq($("fieldset").index(current_fieldset)).removeClass("completed");

    	// Show the previous fieldset.
      current_fieldset.hide();
    	previous_fieldset.show();
    });
  }
}
